Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C857891EE
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 00:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjHYWri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 18:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjHYWrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 18:47:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAD826BD
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 15:47:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5924b2aac52so19363567b3.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 15:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693003633; x=1693608433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fy8dusJmYqsxiCFpM3IjxGXvMbJEv8J/Sip3GIJESiI=;
        b=PQYOGYayv9KAnS2NtxLEro1nB+dpj9WufnImMELVJYMwS7T4bix2T/ar5btH9gnJNx
         /X24o2yTGQAS3mgcKiPOzXBaMtcHkIQ2fUblqwV1HugCiRZEHHzJ2MYEownw80AWheMt
         s0nl7c5w/xJ+hLfMOIbYmDEwC3YJiW8ulGrE52J85hTtW6cpqpdhu7K/GiHNQ73E9X8b
         7cKLiq/LsiPNVZFUitvCvr2FSI2igolJ4rfmPqk2bkG6inTPBBNOeIbIHh/lpTuTVrrM
         adkKEYwuzu0Z6R5G+RfCvj7Z01p4vd4KAewbUbYSLCE1u5BTj6/t/ct2nzY+svtc2p41
         /4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693003633; x=1693608433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fy8dusJmYqsxiCFpM3IjxGXvMbJEv8J/Sip3GIJESiI=;
        b=GHleS6aDTJ8Yt28YF5zYkN7HqyvcgwG3fcB9aNlxqoRRYRFHb1fgbQ5Okyuh6iBAO9
         d3dXsW3JnWvo+Jv5fNiDgxOj9tOplG0UCJeRvAtFAJB0jUOiVMfoJEgTeDybctLhWQYW
         wjcD9LzFm4z9siZvhQ88cuhzYW8XTYkvl7ySvrFfiYyEOut8fs/ZISvgYRuO1m6fZ0f8
         asbZCfQtciYZj15iY0WvknUzTYoADYSpYa2feBSVgJ27EWks19CCOGj8JzwNMKzSy0i9
         WY/g/QFGVBKbNbgCVDekAEkWqOsWKBf0UmWLuYCpd9DzvavrcVpWQXt+Rt67upeCDhyc
         f5eg==
X-Gm-Message-State: AOJu0YzVEF2HxtvVnVKq4YotdCRI3Pt7D+R5vOjkSEC9Gk1Jx0OLhZrW
        uWjxd9cX4qBtc6oykpWNQDoHvNKGqFU=
X-Google-Smtp-Source: AGHT+IH92rCuyl3zbt+Vpza7u0Pgt8d3SHq3CxNbEqY/zOlaEBMdBi4PyRhshMN0fLelpgaNhUVM8Ee9BO0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af0e:0:b0:58c:6ddd:d27c with SMTP id
 n14-20020a81af0e000000b0058c6dddd27cmr516511ywh.6.1693003633476; Fri, 25 Aug
 2023 15:47:13 -0700 (PDT)
Date:   Fri, 25 Aug 2023 15:47:11 -0700
In-Reply-To: <20230714065454.20688-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065454.20688-1-yan.y.zhao@intel.com>
Message-ID: <ZOkvbzR0Sft1lnD1@google.com>
Subject: Re: [PATCH v4 09/12] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Yan Zhao wrote:
> +/*
> + * Add @range into kvm->arch.mtrr_zap_list and sort the list in
> + * "length" ascending + "start" descending order, so that
> + * ranges consuming more zap cycles can be dequeued later and their
> + * chances of being found duplicated are increased.

Wrap comments as close to 80 chars as possible.

> + */
> +static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
> +{
> +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> +	u64 len = range->end - range->start;
> +	struct mtrr_zap_range *cur, *n;
> +	bool added = false;
> +
> +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +
> +	if (list_empty(head)) {
> +		list_add(&range->node, head);
> +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +		return;

Make this

		goto out;

or
		goto out_unlock;

and then do the same instead of the break; in the loop.  Then "added" goes away
and there's a single unlock.

> +	}
> +
> +	list_for_each_entry_safe(cur, n, head, node) {

This shouldn't need to use the _safe() variant, it's not deleting anything.

> +		u64 cur_len = cur->end - cur->start;
> +
> +		if (len < cur_len)
> +			break;
> +
> +		if (len > cur_len)
> +			continue;
> +
> +		if (range->start > cur->start)
> +			break;
> +
> +		if (range->start < cur->start)
> +			continue;

Looking at kvm_zap_mtrr_zap_list(), wouldn't we be better off sorting by start,
and then batching in kvm_zap_mtrr_zap_list()?  And maybe make the batching "fuzzy"
for fixed MTRRs?  I.e. if KVM is zapping any fixed MTRRs, zap all fixed MTRR ranges
even if there's a gap.

> +
> +		/* equal len & start, no need to add */
> +		added = true;
> +		kfree(range);


Hmm, the memory allocations are a bit of complexity that'd I'd prefer to avoid.
At a minimum, I think kvm_add_mtrr_zap_list() should do the allocation.  That'll
dedup a decount amount of code.

At the risk of rehashing the old memslots implementation, I think we should simply
have a statically sized array in struct kvm to hold "range to zap".  E.g. use 16
entries, bin all fixed MTRRs into a single range, and if the remaining 15 fill up,
purge and fall back to a full zap.

128 bytes per VM is totally acceptable, especially since we're burning waaay
more than that to deal with per-vCPU MTRRs.  And a well-behaved guest should have
identical MTRRs across all vCPUs, or maybe at worst one config for the BSP and
one for APs.

> +		break;
> +	}
> +
> +	if (!added)
> +		list_add_tail(&range->node, &cur->node);
> +
> +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +}
> +
> +static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
> +{
> +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> +	struct mtrr_zap_range *cur = NULL;
> +
> +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +
> +	while (!list_empty(head)) {
> +		u64 start, end;
> +
> +		cur = list_first_entry(head, typeof(*cur), node);
> +		start = cur->start;
> +		end = cur->end;
> +		list_del(&cur->node);
> +		kfree(cur);

Hmm, the memory allocations are a bit of complexity that'd I'd prefer to avoid.

> +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +
> +		kvm_zap_gfn_range(kvm, start, end);
> +
> +		spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +	}
> +
> +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +}
> +
> +static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
> +{
> +	if (atomic_cmpxchg_acquire(&kvm->arch.mtrr_zapping, 0, 1) == 0) {
> +		kvm_zap_mtrr_zap_list(kvm);
> +		atomic_set_release(&kvm->arch.mtrr_zapping, 0);
> +		return;
> +	}
> +
> +	while (atomic_read(&kvm->arch.mtrr_zapping))
> +		cpu_relax();
> +}
> +
> +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> +				   gfn_t gfn_start, gfn_t gfn_end)
> +{
> +	struct mtrr_zap_range *range;
> +
> +	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
> +	if (!range)
> +		goto fail;
> +
> +	range->start = gfn_start;
> +	range->end = gfn_end;
> +
> +	kvm_add_mtrr_zap_list(vcpu->kvm, range);
> +
> +	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> +	return;
> +
> +fail:
> +	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
> +}
> +
> +void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu)

Rather than provide a one-liner, add something like

  void kvm_mtrr_cr0_cd_changed(struct kvm_vcpu *vcpu)
  {
	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
		return;

	return kvm_zap_gfn_range(vcpu, 0, -1ull);
  }

that avoids the comically long function name, and keeps the MTRR logic more
contained in the MTRR code.

> +{
> +	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));

Meh, just zap 0 => ~0ull.  That 51:0 happens to be the theoretical max gfn on
x86 is coincidence (AFAIK).  And if the guest.MAXPHYADDR < 52, shifting ~0ull
still doesn't yield a "legal" gfn.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 32cc8bfaa5f1..bb79154cf465 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -943,7 +943,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  
>  	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>  	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> -		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> +		kvm_honors_guest_mtrrs_zap_on_cd_toggle(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
>  
> @@ -12310,6 +12310,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.guest_can_read_msr_platform_info = true;
>  	kvm->arch.enable_pmu = enable_pmu;
>  
> +	spin_lock_init(&kvm->arch.mtrr_zap_list_lock);
> +	INIT_LIST_HEAD(&kvm->arch.mtrr_zap_list);
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
>  	kvm->arch.hv_root_tdp = INVALID_PAGE;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index e7733dc4dccc..56d8755b2560 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -315,6 +315,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					  int page_num);
>  void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
>  					   u8 *type, bool *ipat);
> +void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu);
>  bool kvm_vector_hashing_enabled(void);
>  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
>  int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> -- 
> 2.17.1
> 
