Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1394C92E4
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiCASWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbiCASWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:22:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABDA3652EF
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646158885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sX3ETO8oscWhws5FyzWjk22/h95q+KF0N6R5Pl0UWSM=;
        b=ff+eI9n9Q7aSvcF4qDT5znguPIbBkhofuQiCvJ3VwBLmQaXYKauMy0PiVWI3y028oxl39I
        7cRih89dwOgZkwSX2YQOCYNnxpyB4MEL7ZD2qc5AcG2kUUBROGRoKo7LYzfTa3Y/Bh/JKm
        N4qFFmJSf4d3mGGxhLVAOHaXriJFXds=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-LSuWcCUXOlCRhPHizO4uLQ-1; Tue, 01 Mar 2022 13:21:24 -0500
X-MC-Unique: LSuWcCUXOlCRhPHizO4uLQ-1
Received: by mail-wm1-f70.google.com with SMTP id f13-20020a05600c154d00b003818123caf9so1624636wmg.0
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 10:21:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sX3ETO8oscWhws5FyzWjk22/h95q+KF0N6R5Pl0UWSM=;
        b=2O3CJAfTAJA27T5sltpGA5VdjIYPt+YiS9B/8AOFp6chG2qd51T/RC8RJ/caq+3Lko
         M8uc74eI/bqMX4ZWpToGqgPvwtKU3EI6uu6yCmKKVctlBlol/SkiqWqRd90YZYZwwQnA
         z79Tfim9sGUAl50qPJrlmmPA2GLh3UCXw+RS8UMweApEznJsGZrlwyiEqqXZLB4ACInj
         WkGVouSXjHcFSz6pyvHVyPNSpLI5iBWE7rqtpHgEdHVwUaal3DGLP2PogkZCE5X8BXU9
         DC8djt5pWfBIujWTECEV1dWTCvANbHMeyNHSQ9R4eDiRptajLtQMlQy5D9nYA7S0bcBx
         nM+A==
X-Gm-Message-State: AOAM531tKPtqcvIsxynYrhSLWApo2owHinj2YyTzOpxlm+kNqeWHuHEM
        EdyTMCL5YEymXxpnc7GZ/SW1Cm9Be97SqA3CiwDNzY/Vw7G0as6Y1Bx8n/Q8pkpLtnAptl5tjvU
        n8zXILxsg/wW6
X-Received: by 2002:a1c:35c9:0:b0:37b:edec:4d88 with SMTP id c192-20020a1c35c9000000b0037bedec4d88mr17971025wma.159.1646158883306;
        Tue, 01 Mar 2022 10:21:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIEcmz6e39C4hacm7O7sEH3Bx1ypWDR4DcxCyv7A8vcdJSP/m9x5qSKJmHfed4VGhxeVcRyg==
X-Received: by 2002:a1c:35c9:0:b0:37b:edec:4d88 with SMTP id c192-20020a1c35c9000000b0037bedec4d88mr17971004wma.159.1646158882974;
        Tue, 01 Mar 2022 10:21:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p5-20020a05600c358500b0038167e239a2sm3947712wmq.19.2022.03.01.10.21.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 10:21:22 -0800 (PST)
Message-ID: <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
Date:   Tue, 1 Mar 2022 19:21:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs
 for defunct TDP MMU root
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-21-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220226001546.360188-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/26/22 01:15, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3031b42c27a6..b838cfa984ad 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -91,21 +91,66 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   
>   	WARN_ON(!root->tdp_mmu_page);
>   
> -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -	list_del_rcu(&root->link);
> -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +	/*
> +	 * Ensure root->role.invalid is read after the refcount reaches zero to
> +	 * avoid zapping the root multiple times, e.g. if a different task
> +	 * acquires a reference (after the root was marked invalid) and puts
> +	 * the last reference, all while holding mmu_lock for read.  Pairs
> +	 * with the smp_mb__before_atomic() below.
> +	 */
> +	smp_mb__after_atomic();
> +
> +	/*
> +	 * Free the root if it's already invalid.  Invalid roots must be zapped
> +	 * before their last reference is put, i.e. there's no work to be done,
> +	 * and all roots must be invalidated (see below) before they're freed.
> +	 * Re-zapping invalid roots would put KVM into an infinite loop (again,
> +	 * see below).
> +	 */
> +	if (root->role.invalid) {
> +		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +		list_del_rcu(&root->link);
> +		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +
> +		call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> +		return;
> +	}
> +
> +	/*
> +	 * Invalidate the root to prevent it from being reused by a vCPU, and
> +	 * so that KVM doesn't re-zap the root when its last reference is put
> +	 * again (see above).
> +	 */
> +	root->role.invalid = true;
> +
> +	/*
> +	 * Ensure role.invalid is visible if a concurrent reader acquires a
> +	 * reference after the root's refcount is reset.  Pairs with the
> +	 * smp_mb__after_atomic() above.
> +	 */
> +	smp_mb__before_atomic();

I have reviewed the series and I only have very minor comments... but 
this part is beyond me.  The lavish comments don't explain what is an 
optimization and what is a requirement, and after spending quite some 
time I wonder if all this should just be

         if (refcount_dec_not_one(&root->tdp_mmu_root_count))
                 return;

	if (!xchg(&root->role.invalid, true) {
	 	tdp_mmu_zap_root(kvm, root, shared);

		/*
		 * Do not assume the refcount is still 1: because
		 * tdp_mmu_zap_root can yield, a different task
		 * might have grabbed a reference to this root.
		 *
	        if (refcount_dec_not_one(&root->tdp_mmu_root_count))
         	        return;
	}

	/*
	 * The root is invalid, and its reference count has reached
	 * zero.  It must have been zapped either in the "if" above or
	 * by someone else, and we're definitely the last thread to see
	 * it apart from RCU-protected page table walks.
	 */
	refcount_set(&root->tdp_mmu_root_count, 0);

	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
	list_del_rcu(&root->link);
	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);

	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);

(Yay for xchg's implicit memory barriers)

Paolo

> +	/*
> +	 * Note, if mmu_lock is held for read this can race with other readers,
> +	 * e.g. they may acquire a reference without seeing the root as invalid,
> +	 * and the refcount may be reset after the root is skipped.  Both races
> +	 * are benign, as flows that must visit all roots, e.g. need to zap
> +	 * SPTEs for correctness, must take mmu_lock for write to block page
> +	 * faults, and the only flow that must not consume an invalid root is
> +	 * allocating a new root for a vCPU, which also takes mmu_lock for write.
> +	 */
> +	refcount_set(&root->tdp_mmu_root_count, 1);
>   
>   	/*
> -	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> -	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> -	 * to a different pCPU.  Note, the local TLB flush on reuse also
> -	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> -	 * intermediate paging structures, that may be zapped, as such entries
> -	 * are associated with the ASID on both VMX and SVM.
> +	 * Zap the root, then put the refcount "acquired" above.   Recursively
> +	 * call kvm_tdp_mmu_put_root() to test the above logic for avoiding an
> +	 * infinite loop by freeing invalid roots.  By design, the root is
> +	 * reachable while it's being zapped, thus a different task can put its
> +	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for a
> +	 * defunct root is unavoidable.
>   	 */
>   	tdp_mmu_zap_root(kvm, root, shared);
> -
> -	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> +	kvm_tdp_mmu_put_root(kvm, root, shared);
>   }
>   
>   enum tdp_mmu_roots_iter_type {

