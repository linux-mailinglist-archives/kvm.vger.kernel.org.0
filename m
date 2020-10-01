Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F36627FBBF
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgJAIpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 04:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgJAIpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 04:45:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F75C0613D0;
        Thu,  1 Oct 2020 01:45:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601541898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WhgkxnVG6EstNwK8jxm1/YLBRim7CJx8RIxGbHgpesE=;
        b=Q8Qs9jym5ynC/704Uq2IQI6/1oYa47l84PMVz6tUMORy3MFidPn6AWF6IBiUFI0pgWsyEZ
        tB9FFHPGtY2sLpx34+7q88vtshPa4h42Wjq1GaysJhxSMvfjqWLYHy6PCE06Iz/Hith+4S
        EuGPWmn4Wc6dTq2S2KDrU2VCxsPa+2siQ1fct65OIXg5J57ZN0cTdTRYl+1rgDjS2OuvuG
        T9t90uUzLUuH3z2ZGt4vfkopIkJPU6esKme9wmFrnm9zLj9PFOaszT4DF9nxWwg1jw2U0U
        +/qxULKJwssMdJoVMZG47wO8VzmDNHs7q9x4tnIyDcRi9uRclAhRbExk5kbUHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601541898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WhgkxnVG6EstNwK8jxm1/YLBRim7CJx8RIxGbHgpesE=;
        b=jrYH8mVSQWYuXAIhGVLDIV7y7akwWVshLZI6MLB7OMFtMmRfcv8ht7eEA0VTuxFJiRjLS/
        yU8lgbbdnUtS+QDQ==
To:     "Raj\, Ashok" <ashok.raj@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
In-Reply-To: <20201001010706.GD26492@otc-nc-03>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com> <87sgazgl0b.fsf@nanos.tec.linutronix.de> <20200930185103.GT816047@nvidia.com> <20200930214941.GB26492@otc-nc-03> <87d023gc71.fsf@nanos.tec.linutronix.de> <20201001010706.GD26492@otc-nc-03>
Date:   Thu, 01 Oct 2020 10:44:58 +0200
Message-ID: <87y2kqfi7p.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30 2020 at 18:07, Ashok Raj wrote:
> On Wed, Sep 30, 2020 at 11:57:22PM +0200, Thomas Gleixner wrote:
>
> Devices exposed to guest need host OS support for programming interrupt
> entries in the IOMMU interrupt remapping table. VFIO provides those 
> services for standard interrupt schemes like MSI/MSIx for instance. 
> Since IMS is device specific VFIO can't provide an intercept when 
> IMS entries are programmed by the guest OS.

Why is IMS exposed to the guest in the first place? You expose a
subdevice to a guest, right? And that subdevice should not even know
that IMS exists simply because IMS is strictly host specific.

The obvious emulation here is to make the subdevice look like a PCI
device and expose emulated MSIX (not MSI) which is intercepted when
accessing the MSIX table and then redirected to the proper place along
with IRTE and PASID and whatever.

>> Also this stuff is host side and not guest side. I seriously doubt that
>> you want to hand in the whole PCI device which contains the IMS
>
> You are right, but nothing prevents a user from simply taking a full PCI
> device and assign to guest. 

You surely can and should prevent that because it makes no sense and
cannot work.

That's why you want a generic check for 'this device is magic SIOV or
whatever' and not something burried deep into a driver..

Thanks,

        tglx
