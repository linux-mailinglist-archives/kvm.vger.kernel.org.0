Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82168286FA6
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 09:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgJHHj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 03:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgJHHj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 03:39:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDC9C061755;
        Thu,  8 Oct 2020 00:39:28 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602142766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wGS8RvPqjWluL2zEoasmPYr+Mt5G8eg7w6trwMiIRys=;
        b=g9sr7Db6oViY7+CNLNPLqR2diLWAEuYBHLUy/gNyBzuAWzXRUgeUCs6sNOZpxLofDhl+i6
        68Fd1xmKCe2rwDvq/sd7PiT7+B5XvK8VScniD1E/1UG5GG5n3PQaEjVFd5Stx1YlLqKv7B
        9XwIRII8xSs4awPsfGqvHoLy5muOKShFWHqOW0jSXflOCow69afm+4nz71foETF3RSbH7s
        ePMmR11SPMWL2vmoJMViNcwI0n3TsbNss5yxMEWcJ3pjyRWKyv5VJsUUwrjOU9UixwRzZf
        bpfq+sDP8CfUzrSK65nj/ZFfGBlny2Z6RTdEfPu0VMOUudDamZtQg4b5EmyRww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602142766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wGS8RvPqjWluL2zEoasmPYr+Mt5G8eg7w6trwMiIRys=;
        b=usUoY8ncbtaKaCM2W+geUKP8rahFbzcy+Er9Fhx50RETPyNpyWBGA5efdMzHwrX80a2EbK
        iU4RrqW+LMMyioDQ==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
In-Reply-To: <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com> <87mu17ghr1.fsf@nanos.tec.linutronix.de> <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
Date:   Thu, 08 Oct 2020 09:39:26 +0200
Message-ID: <87r1q92mkx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 14:54, Dave Jiang wrote:
> On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
>> Aside of that this is fiddling in the IMS storage array behind the irq
>> chips back without any comment here and a big fat comment about the
>> shared usage of ims_slot::ctrl in the irq chip driver.
>> 
> This is to program the pasid fields in the IMS table entry. Was
> thinking the pasid fields may be considered device specific so didn't
> attempt to add the support to the core code.

Well, the problem is that this is not really irq chip functionality.

But the PASID programming needs to touch the IMS storage which is also
touched by the irq chip.

This might be correct as is, but without a big fat comment explaining
WHY it is safe to do so without any form of serialization this is just
voodoo and unreviewable.

Can you please explain when the PASID is programmed and what the state
of the interrupt is at that point? Is this a one off setup operation or
does this happen dynamically at random points during runtime?

This needs to be clarified first.

Thanks,

        tglx


