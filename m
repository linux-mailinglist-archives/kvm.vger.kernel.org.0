Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B02E407208
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 21:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhIJTdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 15:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbhIJTdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 15:33:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981C6C061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 12:32:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k23-20020a17090a591700b001976d2db364so2160529pji.2
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 12:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gp/EtrgVV0pqgAxNAgUDSeBZ+pTvYj4FQRlJ1GMLFEU=;
        b=AuY6LIJxJFI0BygWczR7RWIpobT48uhXYq/QvfUlCY2F2I0YalDnxjBhUMIr62Sg8E
         4IlZDKKjWK7MLYPcreaZ0X1Ilrxo/tGZOrvIE1iOHXhCYxwEyKNddT2U1bQJron5k0Sx
         ZDrP2tbC8Bf35TrbfoqPaLSbT9sL/Fgv/5uIhDJiuO9wUtFqmLsqEXDIE55iiVi2SjUU
         qSBbiZFEzmFSwOwlFRTQStZ5ljt1Buo1xGWjG/u/EiIMmxjsKMQl2BiPAdde/Hj95btQ
         XO0Am4J0baDlBhg260FYw9vdd1rYHzVyl3sexJA3W3i7xgKEs2PAMMC0LxRhaJID/giR
         UGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gp/EtrgVV0pqgAxNAgUDSeBZ+pTvYj4FQRlJ1GMLFEU=;
        b=spcrUs+WEX0BR0K16Yq/AOP/is3FFTKTz/2EZ9HSqbYeUQAxHu9gxvnm2aVaFxvpfm
         VnO4tId5JsJ05wWt7Awl/Kr9KyiXjttWSRTjlk7ptkaVpuNTMtFC1lWe8uhi7FdCAhJ8
         cjOxSn4BVvGh7QD/wM7svyXS9Nad5jRLVr7hd/MEDeLwCzwzDJFDtxSlMIw1MbHAYvIn
         A6icisnNx7NH1Q2iH2Z12+nqDQjaLmBZ8AkKe9DWP21/vsFU76aooDr84N8hDI1Jo8Ml
         w91yaKXDMu16iDgwnKxGXFh1gRBQmj6gxg0xlI9FQpGv9ccvYGRdobBqH9Dl4DcQmrzy
         IMeA==
X-Gm-Message-State: AOAM532eObQ4aewnTGDojS50tL1IL4rB/cdgwRiM7KiHRFaTof5MjMEV
        XpUxJ/wOtPyC8J3KR4f3sWi2BQ==
X-Google-Smtp-Source: ABdhPJx7k1Xe3NcxnUviUrljAE+Zul5MGB53kScveWe4Yie9kWrVt15hLLhM0LFtFUt7WR4y2CTMGA==
X-Received: by 2002:a17:902:db05:b0:139:1b8:10c0 with SMTP id m5-20020a170902db0500b0013901b810c0mr8811814plx.26.1631302329725;
        Fri, 10 Sep 2021 12:32:09 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id a71sm5922769pfd.86.2021.09.10.12.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 12:32:09 -0700 (PDT)
Date:   Fri, 10 Sep 2021 12:32:05 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTuytfGTDlaoz0yH@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
 <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
 <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru and Eric,

On Fri, Sep 10, 2021 at 10:42:23AM +0200, Eric Auger wrote:
> Hi Alexandru,
> 
> On 9/10/21 10:28 AM, Alexandru Elisei wrote:
> > Hi Ricardo,
> >
> > On 9/9/21 5:47 PM, Ricardo Koller wrote:
> >> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
> >>> Hi Ricardo,
> >>>
> >>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
> >>>> Extend vgic_v3_check_base() to verify that the redistributor regions
> >>>> don't go above the VM-specified IPA size (phys_size). This can happen
> >>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> >>>>
> >>>>   base + size > phys_size AND base < phys_size
> >>>>
> >>>> vgic_v3_check_base() is used to check the redist regions bases when
> >>>> setting them (with the vcpus added so far) and when attempting the first
> >>>> vcpu-run.
> >>>>
> >>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>>> ---
> >>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >>>>  1 file changed, 4 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> >>>> index 66004f61cd83..5afd9f6f68f6 100644
> >>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> >>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> >>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >>>>  			rdreg->base)
> >>>>  			return false;
> >>>> +
> >>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> >>>> +			kvm_phys_size(kvm))
> >>>> +			return false;
> >>> Looks to me like this same check (and the overflow one before it) is done when
> >>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
> >>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
> >>> kvm_vgic_addr() handles both ways of setting the Redistributor address.
> >>>
> >>> Without this patch, did you manage to set a base address such that base + size >
> >>> kvm_phys_size()?
> >>>
> >> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
> >> to get to this situation is with the selftest in patch 2.  I then tried
> >> an extra experiment: map the first redistributor, run the first vcpu,
> >> and access the redist from inside the guest. KVM didn't complain in any
> >> of these steps.
> > Yes, Eric pointed out that I was mistaken and there is no check being done for
> > base + size > kvm_phys_size().
> >
> > What I was trying to say is that this check is better done when the user creates a
> > Redistributor region, not when a VCPU is first run. We have everything we need to
> > make the check when a region is created, why wait until the VCPU is run?
> >
> > For example, vgic_v3_insert_redist_region() is called each time the adds a new
> > Redistributor region (via either of the two APIs), and already has a check for the
> > upper limit overflowing (identical to the check in vgic_v3_check_base()). I would
> > add the check against the maximum IPA size there.
> you seem to refer to an old kernel as vgic_v3_insert_redist_region was
> renamed into  vgic_v3_alloc_redist_region in
> e5a35635464b kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()
> 
> I think in case you use the old rdist API you do not know yet the size
> of the redist region at this point (count=0), hence Ricardo's choice to
> do the check latter.

Just wanted to add one more detail. vgic_v3_check_base() is also called
when creating the redistributor region (via vgic_v3_set_redist_base ->
vgic_register_redist_iodev). This patch reuses that check for the old
redist API to also check for "base + size > kvm_phys_size()" with a size
calculated using the vcpus added so far.

> >
> > Also, because vgic_v3_insert_redist_region() already checks for overflow, I
> > believe the overflow check in vgic_v3_check_base() is redundant.
> >

It's redundant for the new redist API, but still needed for the old
redist API.

> > As far as I can tell, vgic_v3_check_base() is there to make sure that the
> > Distributor doesn't overlap with any of the Redistributors, and because the
> > Redistributors and the Distributor can be created in any order, we defer the check
> > until the first VCPU is run. I might be wrong about this, someone please correct
> > me if I'm wrong.
> >
> > Also, did you verify that KVM is also doing this check for GICv2? KVM does
> > something similar and calls vgic_v2_check_base() when mapping the GIC resources,
> > and I don't see a check for the maximum IPA size in that function either.
> 
> I think vgic_check_ioaddr() called in kvm_vgic_addr() does the job (it
> checks the base @)
>

It seems that GICv2 suffers from the same problem. The cpu interface
base is checked but the end can extend above IPA size. Note that the cpu
interface is 8KBs and vgic_check_ioaddr() is only checking that its base
is 4KB aligned and below IPA size. The distributor region is 4KB so
vgic_check_ioaddr() is enough in that case.

What about the following?

I can work on the next version of this patch (v2 has the GICv2 issue)
which adds vgic_check_range(), which is like vgic_check_ioaddr() but
with a size arg.  kvm_vgic_addr() can then call vgic_check_range() and
do all the checks for GICv2 and GICv3. Note that for GICv2, there's no
need to wait until first vcpu run to do the check. Also note that I will
have to keep the change in vgic_v3_check_base() to check for the old v3
redist API at first vcpu run.

Thanks,
Ricardo

> Thanks
> 
> Eric
> >
> > Thanks,
> >
> > Alex
> >
> >> Thanks,
> >> Ricardo
> >>
> >>> Thanks,
> >>>
> >>> Alex
> >>>
> >>>>  	}
> >>>>  
> >>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> 
