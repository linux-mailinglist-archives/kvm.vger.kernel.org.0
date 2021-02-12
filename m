Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D06231A6B7
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 22:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhBLVTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 16:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhBLVTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 16:19:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5B1C061756
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 13:18:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l18so348711pji.3
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 13:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=puPSa5+BGW9nqcMGlCFaJeX+UVnQ3PZGElCApLRKkWE=;
        b=cjjrhbbEDvT15A9JlprYYaO/sW6xWO1TQVlKbBCmanUhuSRPE27vC3tU9SDvVNiZ/i
         tzSooStcLMdMdFHuTShOCsS5/0UxlVC7ottdWfjRtWzbCQ09I5cuMjRZlmGveew9QCvt
         yr5xb4pFS7UtMhRJcTV6164/j4GTtxtoyOYd1POXwqeIKYCAd2/GB5ZRhn0SAlUr7S/G
         N8SLMr9nAIi2AfrTvPMMzhIBPuhvtzleCzoGT4bWHSBB3GfM4D+HlSzKb0eFAo5HnMDW
         xVOOpvzW7PgFgvP85nvDgv+keoPZefK8xFdx3D9h0aiXsTQAu3bfV/FPxKRYP6Av7HGr
         aQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puPSa5+BGW9nqcMGlCFaJeX+UVnQ3PZGElCApLRKkWE=;
        b=IO4Inzozhsqu3Cu/uM5WWzXrANcqDKquLV9Dc9xGmIk1NU6qkN4ZL1dSR0z6vxw2RR
         nrCBzp/Jmt3VQyk3W7kNoJnkOCKexmAMyjgpkM8isS+oCZF9xuO5sFN7i39GiIwIvk8l
         Djc7GQeT8aAXwgaLSWJ8xWx5JIxpgsUN3tPXYuCxpIS44XMZr918XGa7VhP3f3JudJi7
         KxtHafP6dIs3MW1Vi7mMxZejW0ht4lOsFSF9Fh6iROSqiWrtvJw1uGo1XUCQieuaAPL6
         zFIpGAUWtAZZQn1o3oaz+v4H5Bh4wS1QNGeikoGBnFG4RitflULxKTDmhPTl3oWjv3dW
         iZ+g==
X-Gm-Message-State: AOAM533ExIWZJN2YApTEhejbS7hxSrmn15j5wR1WHBD3I1LgGJa4ULvd
        NisOrFGIv/gemXFoqgMeob8cnw==
X-Google-Smtp-Source: ABdhPJwTld5G0Tr9luoSjSkXtGGY5seN8PDa1AJIuTfjAPcGArAGwmZBe/iSZCc2nVlfk9KUR0JDBg==
X-Received: by 2002:a17:90a:46cc:: with SMTP id x12mr4397347pjg.114.1613164730728;
        Fri, 12 Feb 2021 13:18:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:b407:1780:13d2:b27])
        by smtp.gmail.com with ESMTPSA id m4sm9609229pfd.130.2021.02.12.13.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 13:18:49 -0800 (PST)
Date:   Fri, 12 Feb 2021 13:18:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pshier@google.com, jmattson@google.com,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RESEND PATCH ] KVM: VMX: Enable/disable PML when dirty logging
 gets enabled/disabled
Message-ID: <YCbws4v7Up2daHyQ@google.com>
References: <20210210212308.2219465-1-makarandsonare@google.com>
 <YCbE+hJC8xeWnKRg@google.com>
 <CA+qz5sqFYrFj=0+kq9m4huwkpC6V8MV_vy5c05VNqMgCPw+fDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+qz5sqFYrFj=0+kq9m4huwkpC6V8MV_vy5c05VNqMgCPw+fDg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021, Makarand Sonare wrote:
> >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> index 777177ea9a35e..eb6639f0ee7eb 100644
> >> --- a/arch/x86/kvm/vmx/vmx.c
> >> +++ b/arch/x86/kvm/vmx/vmx.c
> >> @@ -4276,7 +4276,7 @@ static void
> >> vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> >>  	*/
> >>  	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
> >>
> >> -	if (!enable_pml)
> >> +	if (!enable_pml || !vcpu->kvm->arch.pml_enabled)
> >>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
> >
> > The checks are unnecessary if PML is dynamically toggled, i.e. this snippet
> > can
> > unconditionally clear PML.  When setting SECONDARY_EXEC (below snippet),
> > PML
> > will be preserved in the current controls, which is what we want.
> 
> Assuming a new VCPU can be added at a later time after PML is already
> enabled, should we clear
> PML in VMCS for the new VCPU. If yes what will be the trigger for
> setting PML for the new VCPU?

Ah, didn't consider that.  Phooey.

> >>  	if (cpu_has_vmx_xsaves()) {
> >> @@ -7133,7 +7133,8 @@ static void vmcs_set_secondary_exec_control(struct
> >> vcpu_vmx *vmx)
> >>  		SECONDARY_EXEC_SHADOW_VMCS |
> >>  		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
> >>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> >> -		SECONDARY_EXEC_DESC;
> >> +		SECONDARY_EXEC_DESC |
> >> +		SECONDARY_EXEC_ENABLE_PML;
> >>
> >>  	u32 new_ctl = vmx->secondary_exec_control;
> >>  	u32 cur_ctl = secondary_exec_controls_get(vmx);
> >> @@ -7509,6 +7510,19 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int
> >> cpu)
> >>  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> >>  				     struct kvm_memory_slot *slot)
> >>  {
> >> +	/*
> >> +	 * Check all slots and enable PML if dirty logging
> >> +	 * is being enabled for the 1st slot
> >> +	 *
> >> +	 */
> >> +	if (enable_pml &&
> >> +	    kvm->dirty_logging_enable_count == 1 &&
> >> +	    !kvm->arch.pml_enabled) {
> >> +		kvm->arch.pml_enabled = true;
> >> +		kvm_make_all_cpus_request(kvm,
> >> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
> >> +	}

...

> >> @@ -1366,15 +1367,24 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >>  	}
> >>
> >>  	/* Allocate/free page dirty bitmap as needed */
> >> -	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
> >> +	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES)) {
> >>  		new.dirty_bitmap = NULL;
> >> -	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
> >> +
> >> +		if (old.flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >> +			WARN_ON(kvm->dirty_logging_enable_count == 0);
> >> +			--kvm->dirty_logging_enable_count;
> >
> > The count will be corrupted if kvm_set_memslot() fails.
> >
> > The easiest/cleanest way to fix both this and the refcounting bug is to
> > handle the count in kvm_mmu_slot_apply_flags().  That will also allow
> > making the dirty log count x86-only, and it can then be renamed to
> > cpu_dirty_log_count to align with the
> >
> > We can always move/rename the count variable if additional motivation for
> > tracking dirty logging comes along.
> 
> Thanks for pointing out. Will this solution take care of the scenario
> where a memslot is created/deleted with LOG_DIRTY_PAGE?

Yes?  At least, that's the plan. :-)  I'll post my whole series as an RFC later
today so you and Ben can poke holes in my changes.  There are some TDP MMU fixes
that I've accumulated and would like to get posted before the 5.12 merge window
opens, if only so that Paolo can make an informed decision on whether or not to
enable TDP MMU by default.
