Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848917B2306
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjI1Q4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjI1Q4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:56:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D460A99
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695920136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=db4LuX+cyuFVDjWljKNDIps/ix54Zu0j3S8rKzmKS9g=;
        b=isNtNe82o30t3rkjgM4WsY1FVsN66zUEMY3h3ppYDiELRrY1QUCAjvhjJbvBc/8QovRkfn
        td677vIvBV+Xei1plJVirvNcpVdLAUIhpX6s+0O/SBmp5CiOJOOjNFchx1Fgcd8ISzGVlm
        sqo/PD96M8izY3RgeUTn6YfL/tU15xM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-Yt2IUYMEO2uy4W8P7aEJqg-1; Thu, 28 Sep 2023 12:55:32 -0400
X-MC-Unique: Yt2IUYMEO2uy4W8P7aEJqg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4064b38dc63so9606735e9.1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695920131; x=1696524931;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=db4LuX+cyuFVDjWljKNDIps/ix54Zu0j3S8rKzmKS9g=;
        b=Nl/xpur9JJivvwz/e9yIBIUA02xP0QMtA8isFX4+lwFvfFBlszUw2BoZ4GJQd5VSF0
         FBHiTmv4OXb0Vnh/Yd8gGSPiPKelRXIXN7npllYPrWxZi0FhEUXVz8vmmARQWHtWFoWS
         QQZ9XsIno83BlSfpsxakN3uTgiNrinzzo/1cvf3JJw23VboNLgkTiPvU96DeKzhDMGiV
         5TwlL2q3fbd0vIV8tsIrrlnj9zlcgScEieDfFk5nlkUyFIUM2RMzMgKi2xqEW7/NQhGV
         H2nhOXXy4wjuTPQpeF2m662Akp6tYdqFy42wlyfWSOt60f6zgnlodAUdJz4A1s5nSpLd
         IEvw==
X-Gm-Message-State: AOJu0YyE0Zzu+KVB743x4NUcaAVEXUmPdGvpMdiGA+ElEf6sq827yDTk
        t6PPiCMQ2CJd4Ic2TWfBokeKmXh4CWtVn9Rg0gYjI5hnfeCQxNPuKunoigPFcur+H2yfOseG4in
        BihZtMSyq1fObX+jpTOIN
X-Received: by 2002:a7b:cbc6:0:b0:401:b307:7ba8 with SMTP id n6-20020a7bcbc6000000b00401b3077ba8mr1739813wmi.13.1695920131330;
        Thu, 28 Sep 2023 09:55:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIh6DPgfjKsJwbVKkFhgslwFjC0g1VAZsEHPUuFPkQ1hV8Yizc8jo5QvaABlkfrvTNdEruPw==
X-Received: by 2002:a7b:cbc6:0:b0:401:b307:7ba8 with SMTP id n6-20020a7bcbc6000000b00401b3077ba8mr1739797wmi.13.1695920130954;
        Thu, 28 Sep 2023 09:55:30 -0700 (PDT)
Received: from starship ([89.237.96.178])
        by smtp.gmail.com with ESMTPSA id u8-20020a7bc048000000b003fe2b081661sm23214122wmc.30.2023.09.28.09.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 09:55:30 -0700 (PDT)
Message-ID: <6bc63f82495501f9664b7d19bd8c7ba64329d37b.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: remove unnecessary "bool shared"
 argument from iterators
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 28 Sep 2023 19:55:28 +0300
In-Reply-To: <20230928162959.1514661-3-pbonzini@redhat.com>
References: <20230928162959.1514661-1-pbonzini@redhat.com>
         <20230928162959.1514661-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У чт, 2023-09-28 у 12:29 -0400, Paolo Bonzini пише:
> The "bool shared" argument is more or less unnecessary in the
> for_each_*_tdp_mmu_root_yield_safe() macros.  Many users check for
> the lock before calling it; all of them either call small functions
> that do the check, or end up calling tdp_mmu_set_spte_atomic() and
> tdp_mmu_iter_set_spte().  Add a few assertions to make up for the
> lost check in for_each_*_tdp_mmu_root_yield_safe(), but even this
> is probably overkill and mostly for documentation reasons.

Why not to leave the 'kvm_lockdep_assert_mmu_lock_held' but drop the shared argument from it?
and then use lockdep_assert_held. If I am not mistaken, lockdep_assert_held should assert
if the lock is held for read or write.

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ab0876015be7..b9abfa78808a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -155,23 +155,20 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>   * If shared is set, this function is operating under the MMU lock in read
>   * mode.
>   */
> -#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
> +#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _only_valid)\
>  	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);	\
>  	     _root;							\
>  	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))	\
> -		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
> -		    kvm_mmu_page_as_id(_root) != _as_id) {			\
> +		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
>  		} else
>  
> -#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
> -	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
> +#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
> +	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, true)
>  
> -#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
> +#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
>  	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
>  	     _root;							\
>  	     _root = tdp_mmu_next_root(_kvm, _root, false))
> -		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
> -		} else
>  
>  /*
>   * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
> @@ -840,7 +837,8 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
>  {
>  	struct kvm_mmu_page *root;
>  
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +	for_each_tdp_mmu_root_yield_safe(kvm, root)
>  		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
>  
>  	return flush;
> @@ -862,7 +860,8 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  	 * is being destroyed or the userspace VMM has exited.  In both cases,
>  	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>  	 */
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +	for_each_tdp_mmu_root_yield_safe(kvm, root)
>  		tdp_mmu_zap_root(kvm, root, false);
>  }
>  
> @@ -876,7 +875,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  
>  	read_lock(&kvm->mmu_lock);
>  
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
> +	for_each_tdp_mmu_root_yield_safe(kvm, root) {
>  		if (!root->tdp_mmu_scheduled_root_to_zap)
>  			continue;
>  
> @@ -899,7 +898,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  		 * the root must be reachable by mmu_notifiers while it's being
>  		 * zapped
>  		 */
> -		kvm_tdp_mmu_put_root(kvm, root, true);
> +		kvm_tdp_mmu_put_root(kvm, root);
>  	}
>  
>  	read_unlock(&kvm->mmu_lock);
> @@ -1133,7 +1132,9 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  {
>  	struct kvm_mmu_page *root;
>  
> -	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false, false)
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>  		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
>  					  range->may_block, flush);
>  
> @@ -1322,7 +1323,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>  
> -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
> +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
>  		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
>  			     slot->base_gfn + slot->npages, min_level);
>  
> @@ -1354,6 +1355,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  {
>  	struct kvm_mmu_page *sp;
>  
> +	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +
>  	/*
>  	 * Since we are allocating while under the MMU lock we have to be
>  	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
> @@ -1504,11 +1507,10 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
>  	int r = 0;
>  
>  	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> -
> -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, shared) {
> +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id) {
>  		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
>  		if (r) {
> -			kvm_tdp_mmu_put_root(kvm, root, shared);
> +			kvm_tdp_mmu_put_root(kvm, root);
>  			break;
>  		}
>  	}
> @@ -1568,8 +1570,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
>  	bool spte_set = false;
>  
>  	lockdep_assert_held_read(&kvm->mmu_lock);
> -
> -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
> +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
>  		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
>  				slot->base_gfn + slot->npages);
>  
> @@ -1703,8 +1704,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  	struct kvm_mmu_page *root;
>  
>  	lockdep_assert_held_read(&kvm->mmu_lock);
> -
> -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
> +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
>  		zap_collapsible_spte_range(kvm, root, slot);
>  }
>  


