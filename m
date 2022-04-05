Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D858F4F496F
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381457AbiDEWQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455487AbiDEQAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:00:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E64317E2D
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 08:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649171753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/hMlkmmyLf263hSrvPKkNm/6nEPBpJbD0iMYZMZaxjM=;
        b=BqWvGSn+zJiWWIdscI3uWkmR7JRh+846rrdE9aEo9pHOQlb83kVxD+Yl6HdRPUoNzBNxUN
        2guYSdSHfat9SF5fXuUDH82BLgH2FZRW7RyHfSzp0GhZQrF9G5Uu4T8S1s1GV0RDXig5Q/
        T9xuxua/NqzHK1ZdNJWYBLfWGMWlkyA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-K8_os-8aOdyLWhE90AA0gA-1; Tue, 05 Apr 2022 11:15:52 -0400
X-MC-Unique: K8_os-8aOdyLWhE90AA0gA-1
Received: by mail-qv1-f72.google.com with SMTP id gg12-20020a056214252c00b00443c829976eso8091423qvb.0
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 08:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/hMlkmmyLf263hSrvPKkNm/6nEPBpJbD0iMYZMZaxjM=;
        b=D/Ls/FI7/YfUoQh3SKa8FJ2+o6QT8QnW8wsFhp/m2nqidKR869QmX7BxyzeRoA4FkI
         64wE2CLbwr4E+goKQfhHXWWqgI28OM7HqPExm9NswZQZeOJ3xoTv3YsHKhfECYZaIfqm
         n2gYuduYZtBXBroL/BPjsQWguXM1l7cHQ9d7Kpkdb0Ts9d7porhb2QtbX9zVgltr4Y9r
         CVXTptLBWKqByaf0arCfAE5qEyzT/TKs22OzId+vRHOalTtTRWrcx27XCDZI7++egzLp
         WQmZYwKt6FEUS/bG1aB0BmVzOmeifKTM/1z5DFDF12UVASXiQBzgcGVfdu8pIxxrlz1I
         t/1w==
X-Gm-Message-State: AOAM530QNKXnRuDnMI7XdkIb21fBel3fGxpCNLm7uehSVVwTFt7zSnq3
        Dz/dNqiBQlkqXfcgRoiqBVhZPBoZgdjW7QQ95FSr4A4P6DBegVutZLhNhY0LLjK4lwPUT4w2Xz7
        FLj9drHr61rUg
X-Received: by 2002:a05:620a:6c4:b0:67d:3912:ea39 with SMTP id 4-20020a05620a06c400b0067d3912ea39mr2503384qky.447.1649171751367;
        Tue, 05 Apr 2022 08:15:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPvg8C6cJl/yQX7Y31aen22UhOZ8nlbFI01UkX6EhB0OVBYX9QEwo9Okg42OdAyKyminMXcA==
X-Received: by 2002:a05:620a:6c4:b0:67d:3912:ea39 with SMTP id 4-20020a05620a06c400b0067d3912ea39mr2503351qky.447.1649171751020;
        Tue, 05 Apr 2022 08:15:51 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id k1-20020ac85fc1000000b002e1c6420790sm11862147qta.40.2022.04.05.08.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:15:50 -0700 (PDT)
Message-ID: <564d7c99-0490-897e-6660-54203c0aa31e@redhat.com>
Date:   Tue, 5 Apr 2022 17:15:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 049/104] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <8907eadab058300fa6ba7943036ad638b41ee0ef.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8907eadab058300fa6ba7943036ad638b41ee0ef.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
>   static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
> +					  bool private_spte,
>   					  u64 old_spte, u64 new_spte, int level)
>   {
>   	bool pfn_changed;
>   	struct kvm_memory_slot *slot;
>   
> +	/*
> +	 * TDX doesn't support live migration.  Never mark private page as
> +	 * dirty in log-dirty bitmap, since it's not possible for userspace
> +	 * hypervisor to live migrate private page anyway.
> +	 */
> +	if (private_spte)
> +		return;

This should not be needed, patch 35 will block it anyway because 
kvm_slot_dirty_track_enabled() will return false.

> @@ -1215,7 +1227,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>   	 * into this helper allow blocking; it'd be dead, wasteful code.
>   	 */
>   	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +		/*
> +		 * For TDX shared mapping, set GFN shared bit to the range,
> +		 * so the handler() doesn't need to set it, to avoid duplicated
> +		 * code in multiple handler()s.
> +		 */
> +		gfn_t start;
> +		gfn_t end;
> +
> +		if (is_private_sp(root)) {
> +			start = kvm_gfn_private(kvm, range->start);
> +			end = kvm_gfn_private(kvm, range->end);
> +		} else {
> +			start = kvm_gfn_shared(kvm, range->start);
> +			end = kvm_gfn_shared(kvm, range->end);
> +		}

I think this could be a separate function kvm_gfn_for_root(kvm, root, ...).

> @@ -1237,6 +1265,15 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>   	if (!is_accessed_spte(iter->old_spte))
>   		return false;
>   
> +	/*
> +	 * First TDX generation doesn't support clearing A bit for private
> +	 * mapping, since there's no secure EPT API to support it.  However
> +	 * it's a legitimate request for TDX guest, so just return w/o a
> +	 * WARN().
> +	 */
> +	if (is_private_spte(iter->sptep))
> +		return false;

Please add instead a "bool only_shared" argument to 
kvm_tdp_mmu_handle_gfn, since you can check "only_shared && 
is_private_sp(root)" just once (instead of checking it once per PTE).

>   	new_spte = iter->old_spte;
>   
>   	if (spte_ad_enabled(new_spte)) {
> @@ -1281,6 +1318,13 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   	/* Huge pages aren't expected to be modified without first being zapped. */
>   	WARN_ON(pte_huge(range->pte) || range->start + 1 != range->end);
>   
> +	/*
> +	 * .change_pte() callback should not happen for private page, because
> +	 * for now TDX private pages are pinned during VM's life time.
> +	 */
> +	if (WARN_ON(is_private_spte(iter->sptep)))
> +		return false;
> +
>   	if (iter->level != PG_LEVEL_4K ||
>   	    !is_shadow_present_pte(iter->old_spte))
>   		return false;
> @@ -1332,6 +1376,16 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   	u64 new_spte;
>   	bool spte_set = false;
>   
> +	/*
> +	 * First TDX generation doesn't support write protecting private
> +	 * mappings, since there's no secure EPT API to support it.  It
> +	 * is a bug to reach here for TDX guest.
> +	 */
> +	if (WARN_ON(is_private_sp(root)))
> +		return spte_set;

Isn't this function unreachable even for the shared address range?  If 
so, this WARN should be in kvm_tdp_mmu_wrprot_slot, and also it should 
check if !kvm_arch_dirty_log_supported(kvm).

> +	start = kvm_gfn_shared(kvm, start);
> +	end = kvm_gfn_shared(kvm, end);

... and then these two lines are unnecessary.

>   	rcu_read_lock();
>   
>   	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
> @@ -1398,6 +1452,16 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   	u64 new_spte;
>   	bool spte_set = false;
>   
> +	/*
> +	 * First TDX generation doesn't support clearing dirty bit,
> +	 * since there's no secure EPT API to support it.  It is a
> +	 * bug to reach here for TDX guest.
> +	 */
> +	if (WARN_ON(is_private_sp(root)))
> +		return spte_set;

Same here, can you check it in kvm_tdp_mmu_clear_dirty_slot?

> +	start = kvm_gfn_shared(kvm, start);
> +	end = kvm_gfn_shared(kvm, end);

Same here.

>   	rcu_read_lock();
>   
>   	tdp_root_for_each_leaf_pte(iter, root, start, end) {
> @@ -1467,6 +1531,15 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>   	struct tdp_iter iter;
>   	u64 new_spte;
>   
> +	/*
> +	 * First TDX generation doesn't support clearing dirty bit,
> +	 * since there's no secure EPT API to support it.  It is a
> +	 * bug to reach here for TDX guest.
> +	 */
> +	if (WARN_ON(is_private_sp(root)))
> +		return;

IIRC this is reachable from userspace, so WARN_ON is not possible.  But, 
again please check

	if (!kvm_arch_dirty_log_supported(kvm))
		return;

in kvm_tdp_mmu_clear_dirty_pt_masked.

> +	gfn = kvm_gfn_shared(kvm, gfn);

Also unnecessary, I think.

>   	rcu_read_lock();
>   
>   	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
> @@ -1530,6 +1603,16 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>   	struct tdp_iter iter;
>   	kvm_pfn_t pfn;
>   
> +	/*
> +	 * This should only be reachable in case of log-dirty, which TD
> +	 * private mapping doesn't support so far.  Give a WARN() if it
> +	 * hits private mapping.
> +	 */
> +	if (WARN_ON(is_private_sp(root)))
> +		return;
> +	start = kvm_gfn_shared(kvm, start);
> +	end = kvm_gfn_shared(kvm, end);

I think this is not a big deal and you can leave it as is. 
Alternatively, please move the WARN to 
kvm_tdp_mmu_zap_collapsible_sptes().  It is also only reachable if you 
can set KVM_MEM_LOG_DIRTY_PAGES in the first place.

Paolo

>   	rcu_read_lock();
>   
>   	tdp_root_for_each_pte(iter, root, start, end) {
> @@ -1543,8 +1626,9 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>   
>   		pfn = spte_to_pfn(iter.old_spte);
>   		if (kvm_is_reserved_pfn(pfn) ||
> -		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
> -							    pfn, PG_LEVEL_NUM))
> +		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot,
> +			    tdp_iter_gfn_unalias(kvm, &iter), pfn,
> +			    PG_LEVEL_NUM))
>   			continue;
>   
>   		/* Note, a successful atomic zap also does a remote TLB flush. */
> @@ -1590,6 +1674,14 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>   
>   	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
>   
> +	/*
> +	 * First TDX generation doesn't support write protecting private
> +	 * mappings, since there's no secure EPT API to support it.  It
> +	 * is a bug to reach here for TDX guest.
> +	 */
> +	if (WARN_ON(is_private_sp(root)))
> +		return spte_set;
> +
>   	rcu_read_lock();
>   
>   	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,

