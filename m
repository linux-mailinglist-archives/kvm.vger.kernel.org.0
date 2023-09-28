Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7CA7B22B4
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjI1Qra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjI1Qr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:47:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CEE99
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695919601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e1nG43NAk1FHCA+ImOZ9oNANJUjy6sdGqu8LxM+SXvk=;
        b=XIph5LStl6kywqC+OoKB5cHogt++WQhtdwDTOgzAHJf3pcyj3C2aQ/G9GLM0tTraHPFSo+
        z5G7YxJMAxbRXblbJ54WHFM/MF6W2yf1VuxEChSugvGowArmRtbvuaH+12sKSLo0syabfg
        jVNDanMx3kUrhaqhVyZbW2gKbVfZsfk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-jxuNIuZJOc-JWH2TBCOxIA-1; Thu, 28 Sep 2023 12:46:38 -0400
X-MC-Unique: jxuNIuZJOc-JWH2TBCOxIA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4063f0af359so44224545e9.1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695919598; x=1696524398;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e1nG43NAk1FHCA+ImOZ9oNANJUjy6sdGqu8LxM+SXvk=;
        b=DE4AGM03AlYFs9TGVckIDO0ynBq9oqwuHwOB5X5TlNB7oiwjeh82qibfEz1bBYTPlt
         yyW9xgMGX+puXsyGPP6pBMgGGCzembqsBUD4NEhOnArBPsRzxEoxl3f/EJ7KnfgIWFkk
         3D8h8AZhXU9Ssib4in0althBeeuVSSC60NueKpnkMZC+M/LQD2bhpIGk1jKxg8ihetsg
         SzzXEgDnCAAeaomzGSQF+TF/Xe8aIxe41iraJLCa6X6pSWaVZugYqrUopR6NYwM1KP0t
         X20GCT0a+mj0AUXrNXywspJLDK1DZVK42jr4OKZXjD7qXrtiW7Lo0r7DvyXrGTrc+8vw
         8WgQ==
X-Gm-Message-State: AOJu0YwADLzVtsdQ8W/pdKIxYAPSqErdBQXVwcxPWd61LGaQQJBz9pAb
        /0qLs/84ZWkBwmCVDQ9rOm9xE8s86hekroNaZVUd3RB8zJ1dqicQzf7RiA8vm++e9ru5P/9gLIc
        Ybnj5+E0ilR9I
X-Received: by 2002:a5d:5151:0:b0:31f:eb88:e3c8 with SMTP id u17-20020a5d5151000000b0031feb88e3c8mr1641087wrt.32.1695919597788;
        Thu, 28 Sep 2023 09:46:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECAhLGbnen61UUw8FpaxsVW7uCtdSfU9iZ7QE8TtuL/KJb16ImOsM03QIoWXomHtErupETRg==
X-Received: by 2002:a5d:5151:0:b0:31f:eb88:e3c8 with SMTP id u17-20020a5d5151000000b0031feb88e3c8mr1641070wrt.32.1695919597459;
        Thu, 28 Sep 2023 09:46:37 -0700 (PDT)
Received: from starship ([89.237.96.178])
        by smtp.gmail.com with ESMTPSA id ba6-20020a0560001c0600b003248a490e3asm1383100wrb.39.2023.09.28.09.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 09:46:36 -0700 (PDT)
Message-ID: <0b5e476cd0a31376fbda4be62fb650a1caf004dd.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: remove unnecessary "bool shared"
 argument from functions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 28 Sep 2023 19:46:35 +0300
In-Reply-To: <20230928162959.1514661-2-pbonzini@redhat.com>
References: <20230928162959.1514661-1-pbonzini@redhat.com>
         <20230928162959.1514661-2-pbonzini@redhat.com>
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
> Neither tdp_mmu_next_root nor kvm_tdp_mmu_put_root need to know
> if the lock is taken for read or write.  Either way, protection
> is achieved via RCU and tdp_mmu_pages_lock.  Remove the argument
> and just assert that the lock is taken.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c | 34 +++++++++++++++++++++-------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  3 +--
>  3 files changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f7901cb4d2fa..64b1bdba943e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3548,7 +3548,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  		return;
>  
>  	if (is_tdp_mmu_page(sp))
> -		kvm_tdp_mmu_put_root(kvm, sp, false);
> +		kvm_tdp_mmu_put_root(kvm, sp);
>  	else if (!--sp->root_count && sp->role.invalid)
>  		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6cd4dd631a2f..ab0876015be7 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -73,10 +73,13 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  	tdp_mmu_free_sp(sp);
>  }
>  
> -void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  bool shared)
> +void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  {
> -	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +	/*
> +	 * Either read or write is okay, but the lock is needed because
> +	 * writers might not take tdp_mmu_pages_lock.
> +	 */
> +	lockdep_assert_held(&kvm->mmu_lock);

I double checked all callers and indeed at least the read lock is held.

>  
>  	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>  		return;
> @@ -106,10 +109,16 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   */
>  static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  					      struct kvm_mmu_page *prev_root,
> -					      bool shared, bool only_valid)
> +					      bool only_valid)
>  {
>  	struct kvm_mmu_page *next_root;
>  
> +	/*
> +	 * While the roots themselves are RCU-protected, fields such as
> +	 * role.invalid are protected by mmu_lock.
> +	 */
> +	lockdep_assert_held(&kvm->mmu_lock);
> +
>  	rcu_read_lock();
>  
>  	if (prev_root)
> @@ -132,7 +141,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  	rcu_read_unlock();
>  
>  	if (prev_root)
> -		kvm_tdp_mmu_put_root(kvm, prev_root, shared);
> +		kvm_tdp_mmu_put_root(kvm, prev_root);
>  
>  	return next_root;
>  }
> @@ -144,13 +153,12 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>   * recent root. (Unless keeping a live reference is desirable.)
>   *
>   * If shared is set, this function is operating under the MMU lock in read
> - * mode. In the unlikely event that this thread must free a root, the lock
> - * will be temporarily dropped and reacquired in write mode.
> + * mode.
>   */
>  #define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
> -	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
> -	     _root;								\
> -	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
> +	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);	\
> +	     _root;							\
> +	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))	\
>  		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
>  		    kvm_mmu_page_as_id(_root) != _as_id) {			\
>  		} else
> @@ -159,9 +167,9 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
>  
>  #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
> -	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, false);		\
> -	     _root;								\
> -	     _root = tdp_mmu_next_root(_kvm, _root, _shared, false))		\
> +	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
> +	     _root;							\
> +	     _root = tdp_mmu_next_root(_kvm, _root, false))
>  		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
>  		} else
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 733a3aef3a96..20d97aa46c49 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -17,8 +17,7 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>  	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
>  }
>  
> -void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  bool shared);
> +void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
>  
>  bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);


I don't know all of the details of the kvm mmu, so I might have missed something,
but still I need to get back to reviewing....

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

