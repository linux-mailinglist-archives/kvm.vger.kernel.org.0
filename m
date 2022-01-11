Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDFE48B2BE
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbiAKQ7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241302AbiAKQ7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 11:59:46 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3247C06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 08:59:45 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h1so18127862pls.11
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 08:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NM1YKEzIM8tGqBc0n3TyDW24QIkGu+HKbCPjDATsj68=;
        b=nnvQD7e28G0p7YCABuNTGDFNTAzi9hm+ogCN+DcP1bdzgEni3JcQrHerCUnr5IjY5G
         /rfYeI3B/cTaAMGPKwl4XW/+VYyfFJXRfuunvjJ763BTaT2Rx1GtWWHvO0knTf9TEyNh
         S0XXW6zRYUAa08BUhMwoKwd/RTHvCXHkcy8fwr7N0gu3DSgXcxto2HgM5dxPW36jzAyD
         pzJznxgWqmrytXmg5G/PwNZocAxs/Ts647iOH979Yg7ZxypJvNW2fMeJm4d2SMEZ+tw2
         bEwwse2axNEnDJzS29CDGXgiRu+4OYxRCKeXWCta+gXzjxbGeTT2clREuOsBifHYlNUV
         l2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NM1YKEzIM8tGqBc0n3TyDW24QIkGu+HKbCPjDATsj68=;
        b=7lSUB3qQ47b6YilkPDY0tY/ePE9sCfajDQCkpDHALSLb8D2IpFS+FxdmwETvwYgjNa
         wEPlTsTaax0dPXpitM0dvpaCEPGyo3Fyc1eyG9UVIM+jRD22WRlE3H6FMfkSZc00Bn6D
         LMHpnver1saTZ08aWm4c1ooDtZeojqbvaEb8O2BsxWGReiQZ3+pkJtzvLzrqvrWcq4Iy
         QMGStcqB00+53ZTnTJe5Ua7KpThBkYbH8VPA1n2dnMhCGgc7aYXLiraIBPWVzP4AtbKc
         5q4IRz2LccS0r2rKLRTARrF0tl1bcPOxx3FXcNCLKOoAFnODVLc2tG/VWAJLD/VNxwI/
         GcFw==
X-Gm-Message-State: AOAM530L74aeGsgOxMI3k3ipXc+c0hPTZS2xYnD7PIbV9ki7eM0u3HKT
        +PcBZq9iMDSnpvrxpD8IwvuMFQ==
X-Google-Smtp-Source: ABdhPJwGQcXrHgxq/Nl+gjh7pFbmxIaN4mzkUhCWXHFpgegLuLJeMvkrL2XLYJjc+ZhGKtWnCsjjBQ==
X-Received: by 2002:a17:90b:350b:: with SMTP id ls11mr4120442pjb.134.1641920385147;
        Tue, 11 Jan 2022 08:59:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mw8sm3228018pjb.42.2022.01.11.08.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 08:59:44 -0800 (PST)
Date:   Tue, 11 Jan 2022 16:59:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, agraf@csgraf.de,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v2 1/1] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Yd23fDV8ckkfCUiD@google.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <20211220055722.204341-2-shivam.kumar1@nutanix.com>
 <Ydx2EW6U3fpJoJF0@google.com>
 <eca3faed-5f2c-6217-fb2c-298855510265@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eca3faed-5f2c-6217-fb2c-298855510265@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Shivam Kumar wrote:
> On 10/01/22 11:38 pm, Sean Christopherson wrote:
> > > +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
> > "FULL" is a bit of a misnomer, there's nothing being filled.  REACHED is a better,
> > though not perfect because the quota can be exceeded if multiple pages are dirtied
> > in a single run.  Maybe just KVM_EXIT_DIRTY_QUOTA?
> 
> Absolutely. Does KVM_EXIT_DIRTY_QUOTA_EXHAUSTED look good? Or should I keep it just
> KVM_EXIT_DIRTY_QUOTA?

EXHAUSTED is good.

> > This stat should count regardless of whether dirty logging is enabled.  First and
> > foremost, counting only while dirty logging is enabled creates funky semantics for
> > KVM_EXIT_DIRTY_QUOTA, e.g. a vCPU can take exits even though no memslots have dirty
> > logging enabled (due to past counts), and a vCPU can dirty enormous amounts of
> > memory without exiting due to the relevant memslot not being dirty logged.
> > 
> > Second, the stat could be useful for determining initial quotas or just for debugging.
> > There's the huge caveat that the counts may be misleading if there's nothing clearing
> > the dirty bits, but I suspect the info would still be helpful.
> > 
> > Speaking of caveats, this needs documentation in Documentation/virt/kvm/api.rst.
> > One thing that absolutely needs to be covered is that this quota is not a hard limit,
> > and that it is enforced opportunistically, e.g. with VMX's PML enabled, a vCPU can go
> > up to 511 (or 510? I hate math) counts over its quota.
> 
> I think section 5 (kvm run structure) will be the right place to document this. Please
> confirm once.

Yep.

> > The "(if dirty quota throttling is enabled)" is stale, this is the enable.
> 
> dirty_quota will be reset to zero at the end of live migration. I added this
> to capture this scenario.

That's irrelevant with respect to KVM's responsibilities.  More below.

> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f079820f52b5..7449b9748ddf 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -424,6 +424,20 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> >   	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
> >   }
> > 
> > +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> > +{
> > +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> 
> I think we can store vcpu->stat.generic.pages_dirtied too in some variable here, and
> use that in the next statements.

Yep.

> > @@ -508,6 +514,12 @@ struct kvm_run {
> >   		struct kvm_sync_regs regs;
> >   		char padding[SYNC_REGS_SIZE_BYTES];
> >   	} s;
> > +	/*
> > +	 * Number of pages the vCPU is allowed to have dirtied over its entire
> > +	 * liftime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA if the quota is
> > +	 * reached/exceeded.
> > +	 */
> > +	__u64 dirty_quota;
> >   };
> 
> As mentioned above, this doesn't capture resetting of dirty_quota. Please let
> me know if that can be ignored here and captured in the documentation.

Capture it in the documentation.  Similar to the "reset to zero at the end of
live migration" comment, that's the behavior of _one_ userspace VMM, and isn't
fully representative of KVM's responsibilities.  From a KVM perspective, we can't
make any assumptions about how exactly userspace will utilize a feature, what
matters is what is/isn't supported by KVM's ABI.  E.g. for this particular comment,
KVM needs to play nice with userspace setting dirty_quota to any arbitrary value,
and functionally at any time as well since the quota is checked inside the run
loop, hence suggestion to use READ_ONCE().

It's certainly helpful to document how a feature can be used, especially for users
and VMM developers, but that belongs in the "official" documentation, not internal
code comments.

Speaking of VMM behavior, this also needs a selftest.  I'm guessing it'll be easier
and cleaner to add a new test instead of enhancing something like dirty_log_test,
but whatever works.

> >   /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 168d0ab93c88..aa526b5b5518 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3163,7 +3163,12 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >   	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> >   		return;
> > 
> > -	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> > +	if (!memslot)
> > +		return;
> > +
> > +	vcpu->stat.generic.pages_dirtied++;
> > +
> > +	if (kvm_slot_dirty_track_enabled(memslot)) {
> >   		unsigned long rel_gfn = gfn - memslot->base_gfn;
> >   		u32 slot = (memslot->as_id << 16) | memslot->id;
> > 
> > --
> > 
> This looks superb. I am very thankful to you for your reviews. As a beginner in linux
> kernel development, I have learnt a lot from your suggestions.
> 
> I'll be sending this with the documentation bit shortly. Please let me know if I can
> add you in the "Reviewed-by" list in the next patch.

No :-)  A Reviewed-by can be speculatively/conditionally provided, but generally
speaking that's only done if the expected delta is minimal and/or unlikely to have
any impact on the functionally.  That's also a good guideline for carrying reviews
across revisions of a patch: it's usually ok to retain a R-b if you rebase a patch,
tweak a comment/changelog, make minor revisions such as renaming a variable, etc...,
but you should drop a R-b (or explicitly ask as you've done here) if you make
non-trivial changes to a patch and/or modify the functionality in some way.
