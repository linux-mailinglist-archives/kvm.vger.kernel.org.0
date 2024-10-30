Return-Path: <kvm+bounces-30027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9D99B655D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:12:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F03371C232E1
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 14:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BEA1EF923;
	Wed, 30 Oct 2024 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ree5B4cZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D31991D3
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730297559; cv=none; b=BCN4e8fo02RgAVkHWnTJFMWrs3zksfrNvM57ij6PT2W/JyEv/NQ3mPBkQkwxr2EX6P/d/vFKqyFAl4lPYxD8JZmnPKhZLlwDJoaBM9I1Uqhgqtpb1YUzIUOD3NAv5ZQxXdErNEGn9KojflHF3Ga9DwYgfprewPNzlYokj5UliwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730297559; c=relaxed/simple;
	bh=wQRe747rGpmBjj7wIoBHyNuzGhkKkUp3dyuebA5JZnM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sybp1d5RkBkQVsHdwzaIp4aYOX9+rmZ4k/A0meD8zCFvdqDoXmRloma4tByUJsfHSRF2Ixd9OjTtHqxfcJhlw6E9rZgl9Nb4kuUdAbTwBgnEFBvTSRSWQLMnBLDGrrAd3v26VQRhniUdIxm7QjHlYLdl6KRH7xpgcC3qQbm2t08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ree5B4cZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e315a5b199so121177097b3.2
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 07:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730297555; x=1730902355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNni/Y/nD2N6D5AfIOwFDe/SzDxHZ8JrYR/9CRliS7A=;
        b=Ree5B4cZcl7l3IcgBTHwCSUQ5PtJxcN/kXCaQEVQ3rCy4qVGUNrpRVW98TVdg804RM
         rztDJJexLuhcT70cdKV6YHKv6spKwGK76Hj/vVUipyeJLbnoc5pPrpTCiFXzlBHOYK8d
         KMBLKo7Eh6k/NerIJKdUn1qw6+WFUg3MckwZ3udI2d8NokLYcA3r/ITR52cVJvSotqmW
         L9tGPt/PtclAscywoz67CCydMuBx6AlS4lIZrJOzAnONbL7sX0uMgnydLK8YqRO0Hz0w
         kNCd7mTOcDx7QPJU+N/uSnz8gpk20tmX6LAxyNEOynTVNRJF7S0HIbxs9QGbKYClkfxa
         6YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730297555; x=1730902355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNni/Y/nD2N6D5AfIOwFDe/SzDxHZ8JrYR/9CRliS7A=;
        b=b6mi79wK5npnn+oA/Q/pl4YjuUWg1fj4QEjMTgwPg6si4jTeDd+uQceksMw5ITEOzV
         ovli7UWrUII6RQWmzG1xtlgbB7I/tFXJ3PaD/nX4hQ6zWZdtC9ciJSj8B6An89w3WJGb
         l675X4npOuf/euyG3rRrI7Y+qWeG1RUfnZscjD4OcXUr+1yTpkFshdZqTYm+KtkwdXdC
         87GTqdF0czPFXYBuV3DkaeGtXDsWKD5i66DrPl/ahkjsJLzqf8P5KN3yVEKgDHsZdLLR
         PyOC8tsUzgZ+ve3wZ/8ZcllXOJjoHvOxlr6VBATkxMwt94F5LXF4nN18Vp0v4wMl9xyD
         vaXg==
X-Forwarded-Encrypted: i=1; AJvYcCWNjCJIKUCmh3P+LeHUjb+45zxz15ZhzsczYcFJxA9mn9fbJvtYlX5eZaQQU9nK54C2G9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4WWeMY9IYd8mqhOP3N0l4V2rjDWcT+KNnopRqw4X0zxakTnDI
	zbNOf29BcFB6xQ5PNWiBTXfQTk5u7LYsx71/8GjKCtTpCoV7AWKGf8AJDX1g3YATmj5je8XQMVj
	uRg==
X-Google-Smtp-Source: AGHT+IFMyKb5lUQGT1Lie++StznUu7UTUqxgFIghFpOfSmQZLFmC5ZrOl44cP8qcfYmyifNPH+B/MfiUWNs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6381:b0:6b2:6cd4:7f9a with SMTP id
 00721157ae682-6e9d8b8f0e8mr6928617b3.8.1730297554913; Wed, 30 Oct 2024
 07:12:34 -0700 (PDT)
Date: Wed, 30 Oct 2024 07:12:33 -0700
In-Reply-To: <20240906204515.3276696-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906204515.3276696-1-vipinsh@google.com> <20240906204515.3276696-2-vipinsh@google.com>
Message-ID: <ZyI-0cPWbbHtZQLj@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Vipin Sharma wrote:
> Create separate list for storing TDP MMU NX huge pages and provide

Create a separate list...

> counter for it. Use this list in NX huge page recovery worker along with
> the existing NX huge pages list. Use old NX huge pages list for storing
> only non-TDP MMU pages and provide separate counter for it.
> 
> Separate list will allow to optimize TDP MMU NX huge page recovery in
> future patches by using MMU read lock.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 13 ++++++++++-
>  arch/x86/kvm/mmu/mmu.c          | 39 +++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/mmu_internal.h |  8 +++++--
>  arch/x86/kvm/mmu/tdp_mmu.c      | 19 ++++++++++++----
>  arch/x86/kvm/mmu/tdp_mmu.h      |  1 +
>  5 files changed, 61 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 950a03e0181e..0f21f9a69285 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,8 +1318,12 @@ struct kvm_arch {
>  	 * guarantee an NX huge page will be created in its stead, e.g. if the
>  	 * guest attempts to execute from the region then KVM obviously can't
>  	 * create an NX huge page (without hanging the guest).
> +	 *
> +	 * This list only contains shadow and legacy MMU pages. TDP MMU pages
> +	 * are stored separately in tdp_mmu_possible_nx_huge_pages.

Hmm, ideally that would be reflected in the name.  More thoughts two comments
down.

>  	 */
>  	struct list_head possible_nx_huge_pages;
> +	u64 nr_possible_nx_huge_pages;

Changelog says nothing about tracking the number of possible pages.  This clearly
belongs in a separate patch.

>  #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  	struct kvm_page_track_notifier_head track_notifier_head;
>  #endif
> @@ -1474,7 +1478,7 @@ struct kvm_arch {
>  	 * is held in read mode:
>  	 *  - tdp_mmu_roots (above)
>  	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
> -	 *  - possible_nx_huge_pages;
> +	 *  - tdp_mmu_possible_nx_huge_pages
>  	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
>  	 *    by the TDP MMU
>  	 * Because the lock is only taken within the MMU lock, strictly
> @@ -1483,6 +1487,13 @@ struct kvm_arch {
>  	 * the code to do so.
>  	 */
>  	spinlock_t tdp_mmu_pages_lock;
> +
> +	/*
> +	 * Similar to possible_nx_huge_pages list but this one stores only TDP
> +	 * MMU pages.
> +	 */
> +	struct list_head tdp_mmu_possible_nx_huge_pages;
> +	u64 tdp_mmu_nr_possible_nx_huge_pages;

These obviously come in a pair, and must be passed around as such.  To make the
relevant code easier on the eyes (long lines), and to avoid passing a mismatched
pair, add a parent structure.

E.g.

  struct kvm_possible_nx_huge_pages {
	struct list_head list;
	u64 nr_pages;
  }

And then you can have 

	struct kvm_possible_nx_huge_pages shadow_mmu_possible_nx_huge_pages;

	struct kvm_possible_nx_huge_pages tdp_mmu_possible_nx_huge_pages;

And the comments about the lists can go away, since the structures and names are
fairly self-explanatory.


Aha!  An even better idea.

enum kvm_mmu_types {
	KVM_SHADOW_MMU,
#ifdef CONFIG_X86_64
	KVM_TDP_MMU,
#endif
	KVM_NR_MMU_TYPES,
};


	struct kvm_possible_nx_huge_pages possible_nx_huge_pages[NR_MMU_TYPES];

And then the line lengths aren't heinous and there's no need to trampoline in and
out of the TDP MMU.

>  static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> @@ -881,7 +882,10 @@ static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  	sp->nx_huge_page_disallowed = true;
>  
>  	if (nx_huge_page_possible)
> -		track_possible_nx_huge_page(kvm, sp);
> +		track_possible_nx_huge_page(kvm,
> +					    sp,

No need to put "kvm" and "sp" on separate lines.  And if we go with the array
approach, this becomes:

	if (nx_huge_page_possible)
		track_possible_nx_huge_page(kvm, sp, KVM_SHADOW_MMU);

> +					    &kvm->arch.possible_nx_huge_pages,
> +					    &kvm->arch.nr_possible_nx_huge_pages);
>  }
>  
>  static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu,
> @@ -7311,9 +7317,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  	return err;
>  }
>  
> -static void kvm_recover_nx_huge_pages(struct kvm *kvm)
> +void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
> +			       unsigned long nr_pages)

And this becomes something like:

static void kvm_recover_nx_huge_pages(struct kvm *kvm,
				      enum kvm_mmu_types mmu_type)
{
	struct kvm_possible_nx_huge_pages *possible_nx_pages;
	struct kvm_memory_slot *slot;
	int rcu_idx;
	struct kvm_mmu_page *sp;
	unsigned int ratio;
	LIST_HEAD(invalid_list);
	bool flush = false;
	ulong to_zap;

	possible_nx_pages = &kvm->arch.possible_nx_huge_pages[mmu_type];


>  {
> -	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
>  	struct kvm_memory_slot *slot;
>  	int rcu_idx;
>  	struct kvm_mmu_page *sp;
> @@ -7333,9 +7339,9 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  	rcu_read_lock();
>  
>  	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> -	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
> +	to_zap = ratio ? DIV_ROUND_UP(nr_pages, ratio) : 0;
>  	for ( ; to_zap; --to_zap) {
> -		if (list_empty(&kvm->arch.possible_nx_huge_pages))
> +		if (list_empty(pages))
>  			break;
>  
>  		/*
> @@ -7345,7 +7351,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  		 * the total number of shadow pages.  And because the TDP MMU
>  		 * doesn't use active_mmu_pages.
>  		 */
> -		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
> +		sp = list_first_entry(pages,
>  				      struct kvm_mmu_page,
>  				      possible_nx_huge_page_link);
>  		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);

> @@ -7417,6 +7423,12 @@ static long get_nx_huge_page_recovery_timeout(u64 start_time)
>  		       : MAX_SCHEDULE_TIMEOUT;
>  }
>  
> +static void kvm_mmu_recover_nx_huge_pages(struct kvm *kvm)
> +{
> +	kvm_recover_nx_huge_pages(kvm, &kvm->arch.possible_nx_huge_pages,
> +				  kvm->arch.nr_possible_nx_huge_pages);
> +}
> +
>  static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
>  {
>  	u64 start_time;
> @@ -7438,7 +7450,10 @@ static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
>  		if (kthread_should_stop())
>  			return 0;
>  
> -		kvm_recover_nx_huge_pages(kvm);
> +		kvm_mmu_recover_nx_huge_pages(kvm);
> +		if (tdp_mmu_enabled)
> +			kvm_tdp_mmu_recover_nx_huge_pages(kvm);

And this:

		for (i = KVM_SHADOW_MMU; i < KVM_NR_MMU_TYPES; i++
			kvm_recover_nx_huge_pages(kvm, i);

>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c7dc49ee7388..9a6c26d20210 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -15,6 +15,7 @@
>  void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  {
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
> +	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_possible_nx_huge_pages);

And this copy-paste goes away.

>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
>  }
>  
> @@ -73,6 +74,13 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  	tdp_mmu_free_sp(sp);
>  }
>  
> +void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
> +{
> +	kvm_recover_nx_huge_pages(kvm,
> +				  &kvm->arch.tdp_mmu_possible_nx_huge_pages,
> +				  kvm->arch.tdp_mmu_nr_possible_nx_huge_pages);
> +}
> +
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  {
>  	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
> @@ -318,7 +326,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	sp->nx_huge_page_disallowed = false;
> -	untrack_possible_nx_huge_page(kvm, sp);
> +	untrack_possible_nx_huge_page(kvm, sp, &kvm->arch.tdp_mmu_nr_possible_nx_huge_pages);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  }
>  
> @@ -1162,10 +1170,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  
>  		if (fault->huge_page_disallowed &&
> -		    fault->req_level >= iter.level) {
> +		    fault->req_level >= iter.level &&
> +		    sp->nx_huge_page_disallowed) {
>  			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -			if (sp->nx_huge_page_disallowed)
> -				track_possible_nx_huge_page(kvm, sp);

And this is _exactly_ why I am so strict about the "one change per patch" rule.

commit 21a36ac6b6c7059965bac0cc73ef3cbb8ef576dd
Author:     Sean Christopherson <seanjc@google.com>
AuthorDate: Tue Dec 13 03:30:28 2022 +0000
Commit:     Paolo Bonzini <pbonzini@redhat.com>
CommitDate: Fri Dec 23 12:33:53 2022 -0500

    KVM: x86/mmu: Re-check under lock that TDP MMU SP hugepage is disallowed
    
    Re-check sp->nx_huge_page_disallowed under the tdp_mmu_pages_lock spinlock
    when adding a new shadow page in the TDP MMU.  To ensure the NX reclaim
    kthread can't see a not-yet-linked shadow page, the page fault path links
    the new page table prior to adding the page to possible_nx_huge_pages.
    
    If the page is zapped by different task, e.g. because dirty logging is
    disabled, between linking the page and adding it to the list, KVM can end
    up triggering use-after-free by adding the zapped SP to the aforementioned
    list, as the zapped SP's memory is scheduled for removal via RCU callback.
    The bug is detected by the sanity checks guarded by CONFIG_DEBUG_LIST=y,
    i.e. the below splat is just one possible signature.
    
      ------------[ cut here ]------------
      list_add corruption. prev->next should be next (ffffc9000071fa70), but was ffff88811125ee38. (prev=ffff88811125ee38).
      WARNING: CPU: 1 PID: 953 at lib/list_debug.c:30 __list_add_valid+0x79/0xa0
      Modules linked in: kvm_intel
      CPU: 1 PID: 953 Comm: nx_huge_pages_t Tainted: G        W          6.1.0-rc4+ #71
      Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
      RIP: 0010:__list_add_valid+0x79/0xa0
      RSP: 0018:ffffc900006efb68 EFLAGS: 00010286
      RAX: 0000000000000000 RBX: ffff888116cae8a0 RCX: 0000000000000027
      RDX: 0000000000000027 RSI: 0000000100001872 RDI: ffff888277c5b4c8
      RBP: ffffc90000717000 R08: ffff888277c5b4c0 R09: ffffc900006efa08
      R10: 0000000000199998 R11: 0000000000199a20 R12: ffff888116cae930
      R13: ffff88811125ee38 R14: ffffc9000071fa70 R15: ffff88810b794f90
      FS:  00007fc0415d2740(0000) GS:ffff888277c40000(0000) knlGS:0000000000000000
      CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
      CR2: 0000000000000000 CR3: 0000000115201006 CR4: 0000000000172ea0
      Call Trace:
       <TASK>
       track_possible_nx_huge_page+0x53/0x80
       kvm_tdp_mmu_map+0x242/0x2c0
       kvm_tdp_page_fault+0x10c/0x130
       kvm_mmu_page_fault+0x103/0x680
       vmx_handle_exit+0x132/0x5a0 [kvm_intel]
       vcpu_enter_guest+0x60c/0x16f0
       kvm_arch_vcpu_ioctl_run+0x1e2/0x9d0
       kvm_vcpu_ioctl+0x271/0x660
       __x64_sys_ioctl+0x80/0xb0
       do_syscall_64+0x2b/0x50
       entry_SYSCALL_64_after_hwframe+0x46/0xb0
       </TASK>
      ---[ end trace 0000000000000000 ]---
    
    Fixes: 61f94478547b ("KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting SPTE")
    Reported-by: Greg Thelen <gthelen@google.com>
    Analyzed-by: David Matlack <dmatlack@google.com>
    Cc: David Matlack <dmatlack@google.com>
    Cc: Ben Gardon <bgardon@google.com>
    Cc: Mingwei Zhang <mizhang@google.com>
    Signed-off-by: Sean Christopherson <seanjc@google.com>
    Message-Id: <20221213033030.83345-4-seanjc@google.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fbdef59374fe..62a687d094bb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1214,7 +1214,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
                if (fault->huge_page_disallowed &&
                    fault->req_level >= iter.level) {
                        spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-                       track_possible_nx_huge_page(kvm, sp);
+                       if (sp->nx_huge_page_disallowed)
+                               track_possible_nx_huge_page(kvm, sp);
                        spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
                }
        }

