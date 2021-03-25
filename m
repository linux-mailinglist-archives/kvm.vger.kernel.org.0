Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3563C3499A8
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 19:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCYSpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 14:45:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49514 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhCYSou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 14:44:50 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616697888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sc4ikcvtPux6cS4O7kxP+ZUa35wiLI0ZiU6P4R8vLds=;
        b=gKFxuNfsW+Vl9i0a62FLBGLtEjS1oiWtTzcoKGlxwwcIUkOZ19AIp7e/7xDAtFsOjoO+q0
        CD5ikVGKd4QBstoT/QVAaj3rc9/mYbGV0TC1z9gxYHlfA0QL/E0FgqWfMcgigg5c24lipg
        +N9qaY1tUcDHsKpjlKfflwWw1V30P0IBTgMWClvx2+IgQfAqC+ePAwGvMC0kemqjDlQd04
        nsB3ZNNmPoy14AnvNNwtFmB59GMjC8PZPETs5j5IeVMc9RRt4DkTSHWYQW6hZTOSniCkWf
        eh9YIIpUbp55YG0oSPoR4gCUkEt+EBaAygJ3ZEx2jY3h6LVsn80P3uLtsoE/Bw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616697888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sc4ikcvtPux6cS4O7kxP+ZUa35wiLI0ZiU6P4R8vLds=;
        b=qmchaHgbktj5g1ZW7Fad7vH+aDWR4zgUUjC2juXG48RpTVOp8FNuX94Gq1nnM012a9qPrp
        vukNwVgphsGYiiBA==
To:     Marc Zyngier <maz@kernel.org>, Megha Dey <megha.dey@intel.com>
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: Re: [Patch V2 07/13] irqdomain/msi: Provide msi_alloc/free_store() callbacks
In-Reply-To: <8735wjrwjm.wl-maz@kernel.org>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com> <1614370277-23235-8-git-send-email-megha.dey@intel.com> <8735wjrwjm.wl-maz@kernel.org>
Date:   Thu, 25 Mar 2021 19:44:48 +0100
Message-ID: <87lfabvzrz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25 2021 at 17:08, Marc Zyngier wrote:
> Megha Dey <megha.dey@intel.com> wrote:
>> @@ -434,6 +434,12 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
>>  	if (ret)
>>  		return ret;
>>  
>> +	if (ops->msi_alloc_store) {
>> +		ret = ops->msi_alloc_store(domain, dev, nvec);
>
> What is supposed to happen if we get aliasing devices (similar to what
> we have with devices behind a PCI bridge)?
>
> The ITS code goes through all kind of hoops to try and detect this
> case when sizing the translation tables (in the .prepare callback),
> and I have the feeling that sizing the message store is analogous.

No. The message store itself is sized upfront by the underlying 'master'
device. Each 'master' device has it's own irqdomain.

This is the allocation for the subdevice and this is not part of PCI and
therefore not subject to PCI aliasing.

  |-----------|
  |  PCI dev  |         <- driver creates irqdomain and manages MSI
  |-----------|            Sizing is either fixed (hardware property)
                           or just managed by that irqdomain/driver
                           with some hardware constraints
       |subdev|         <- subdev gets ^^irqdomain assigned and
                           allocates from it.
       .....
       |subdev|

So this is fundamentally different from ITS because ITS has to size the
translation memory, i.e. where the MSI message is written to by the
device.

IMS just handles the storage of the message in the (sub)device. So if
that needs to be supported on ARM then the issue is not with the
subdevices, the issue is with the 'master' device, but that does not use
that alloc_store() callback as it provides it with the irqdomain it
manages.

Thanks,

        tglx


