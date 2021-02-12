Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1508331A454
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 19:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBLSM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 13:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbhBLSM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 13:12:57 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D852C061574
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 10:12:18 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c11so6287174pfp.10
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 10:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XnDmLaHyelI7Lpy2GL+/p/1FWa1b+0Cz/FJ/ziRNpAk=;
        b=Nr34SGv0g5sAZDtqNkX2J80QXc+lfAFgLC+RsIWBrBMwzes8Lpv0lPQGLpNO6f9gNC
         mDC3hueINJwgIQ2hzoucvm6YIRVefMN8XEE7J8SYjS7Fka/EB5QPDt+8zFh2Ng8o8LKR
         6HMtCOLNBJR1h1HA9JZlW4S0m0Ui0cYl8aHDJ9AUUeZXinSjwjcSBENJ90mEG6NzfML7
         UI58sIdTLpBcwDZCewMkkF7Pm3KI//yynxSeEBS858uZZIp7Hti6YO11QZCxcfh5wBP1
         6H6zhZ2OwaB8OoJWpvaCU7sPvnWfEkDffD7X6Kg9y6RAK04F5CRqYHle26d7R66zFno0
         dcTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XnDmLaHyelI7Lpy2GL+/p/1FWa1b+0Cz/FJ/ziRNpAk=;
        b=QTFQQPNfUlPapGE+hMAEwks4ay3tWZbSO11Zmz3CshZWtAlShdA/i25wc/4NmGCDlQ
         I0P/xH8NAsR3Cfcxh1lC9JNK3eBcpxNVVAOZQBpX/P+bk9XBMNMHS0V+HMtQ7+KN32JC
         KPVi1SrJ7myYoHN8uBPLs308OA3pOAwcbg4sfc3u+cQRs1M3xHtJvGx2bQJjBY9tVR79
         K4iaLKxXTZeshAeoE+JjrkkAOUW/qEoZyG2LxWEm8Cc79jk49rPzOvQuHVbwzeC+CVZa
         f+lM/HnX+EvS7ztLaPiRgpQOilzMBlmiMoRUWw9JYdyQcArMkoBiehukNB761v79oJyk
         +bTg==
X-Gm-Message-State: AOAM531BUqC3RbXQ7OJHzLO47foV37Xo6Cr8Z9ryJUuc1DXhWeF2Eeaa
        wGWlxyEZOwy0MPJmCIZRhlbjHg==
X-Google-Smtp-Source: ABdhPJwrPu0NT9Ss0EwYQGx/0w/u8XdK8UvfsPzVVGiUCx99LC+ulN7/4RD+bvjKoO5EcsGf5/0ecg==
X-Received: by 2002:a62:3181:0:b029:1df:4f2:16b3 with SMTP id x123-20020a6231810000b02901df04f216b3mr3833757pfx.24.1613153537335;
        Fri, 12 Feb 2021 10:12:17 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
        by smtp.gmail.com with ESMTPSA id k10sm9877038pfk.0.2021.02.12.10.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 10:12:16 -0800 (PST)
Date:   Fri, 12 Feb 2021 10:12:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pshier@google.com, jmattson@google.com,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RESEND PATCH ] KVM: VMX: Enable/disable PML when dirty logging
 gets enabled/disabled
Message-ID: <YCbE+hJC8xeWnKRg@google.com>
References: <20210210212308.2219465-1-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210212308.2219465-1-makarandsonare@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Makarand Sonare wrote:
> Currently, if enable_pml=1 PML remains enabled for the entire lifetime
> of the VM irrespective of whether dirty logging is enable or disabled.
> When dirty logging is disabled, all the pages of the VM are manually
> marked dirty, so that PML is effectively non-operational. Clearing

s/clearing/setting

Clearing is also expensive, but that can't be optimized away with this change.

> the dirty bits is an expensive operation which can cause severe MMU
> lock contention in a performance sensitive path when dirty logging
> is disabled after a failed or canceled live migration. Also, this
> would break if some other code path clears the dirty bits in which
> case, PML will actually start logging dirty pages even when dirty
> logging is disabled incurring unnecessary vmexits when the PML buffer
> becomes full. In order to avoid this extra overhead, we should
> enable or disable PML in VMCS when dirty logging gets enabled
> or disabled instead of keeping it always enabled.


...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 777177ea9a35e..eb6639f0ee7eb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4276,7 +4276,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  	*/
>  	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
>  
> -	if (!enable_pml)
> +	if (!enable_pml || !vcpu->kvm->arch.pml_enabled)
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;

The checks are unnecessary if PML is dynamically toggled, i.e. this snippet can
unconditionally clear PML.  When setting SECONDARY_EXEC (below snippet), PML
will be preserved in the current controls, which is what we want.

>  	if (cpu_has_vmx_xsaves()) {
> @@ -7133,7 +7133,8 @@ static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
>  		SECONDARY_EXEC_SHADOW_VMCS |
>  		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> -		SECONDARY_EXEC_DESC;
> +		SECONDARY_EXEC_DESC |
> +		SECONDARY_EXEC_ENABLE_PML;
>  
>  	u32 new_ctl = vmx->secondary_exec_control;
>  	u32 cur_ctl = secondary_exec_controls_get(vmx);
> @@ -7509,6 +7510,19 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot)
>  {
> +	/*
> +	 * Check all slots and enable PML if dirty logging
> +	 * is being enabled for the 1st slot
> +	 *
> +	 */
> +	if (enable_pml &&
> +	    kvm->dirty_logging_enable_count == 1 &&
> +	    !kvm->arch.pml_enabled) {
> +		kvm->arch.pml_enabled = true;
> +		kvm_make_all_cpus_request(kvm,
> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
> +	}

This is flawed.  .slot_enable_log_dirty() and .slot_disable_log_dirty() are only
called when LOG_DIRTY_PAGE is toggled in an existing memslot _and_ only the
flags of the memslot are being changed.  This fails to enable PML if the first
memslot with LOG_DIRTY_PAGE is created or moved, and fails to disable PML if the
last memslot with LOG_DIRTY_PAGE is deleted.

> +
>  	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
>  		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
>  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
> @@ -7517,9 +7531,39 @@ static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>  static void vmx_slot_disable_log_dirty(struct kvm *kvm,
>  				       struct kvm_memory_slot *slot)
>  {
> +	/*
> +	 * Check all slots and disable PML if dirty logging
> +	 * is being disabled for the last slot
> +	 *
> +	 */
> +	if (enable_pml &&
> +	    kvm->dirty_logging_enable_count == 0 &&
> +	    kvm->arch.pml_enabled) {
> +		kvm->arch.pml_enabled = false;
> +		kvm_make_all_cpus_request(kvm,
> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
> +	}
> +
>  	kvm_mmu_slot_set_dirty(kvm, slot);
>  }

...

>  #define kvm_err(fmt, ...) \
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ee4ac2618ec59..c6e5b026bbfe8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -307,6 +307,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  {
>  	return kvm_make_all_cpus_request_except(kvm, req, NULL);
>  }
> +EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>  
>  #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
>  void kvm_flush_remote_tlbs(struct kvm *kvm)
> @@ -1366,15 +1367,24 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	}
>  
>  	/* Allocate/free page dirty bitmap as needed */
> -	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
> +	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES)) {
>  		new.dirty_bitmap = NULL;
> -	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
> +
> +		if (old.flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +			WARN_ON(kvm->dirty_logging_enable_count == 0);
> +			--kvm->dirty_logging_enable_count;

The count will be corrupted if kvm_set_memslot() fails.

The easiest/cleanest way to fix both this and the refcounting bug is to handle
the count in kvm_mmu_slot_apply_flags().  That will also allow making the dirty
log count x86-only, and it can then be renamed to cpu_dirty_log_count to align
with the

We can always move/rename the count variable if additional motivation for
tracking dirty logging comes along.


> +		}
> +
> +	} else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
>  		r = kvm_alloc_dirty_bitmap(&new);
>  		if (r)
>  			return r;
>  
>  		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>  			bitmap_set(new.dirty_bitmap, 0, new.npages);
> +
> +		++kvm->dirty_logging_enable_count;
> +		WARN_ON(kvm->dirty_logging_enable_count == 0);
>  	}
>  
>  	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
> -- 
> 2.30.0.478.g8a0d178c01-goog
