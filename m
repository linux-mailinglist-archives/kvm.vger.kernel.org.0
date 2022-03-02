Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FEB4CACEA
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbiCBSFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244283AbiCBSFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEE7114083
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646244289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TppJCGmipLpFSIwLputLq7WRzf+Iq52WdMq4YxQrcGM=;
        b=ibHBTl99QGqzudHFaVdyEU2X1W4lckRHQ+ZkEOt1IMR/4eK+aaH4K5TmT3eDa8SzzDjKxl
        WwMAHRzDQBuDLXvwBgu4t+QuGf9QlcEewWW4vS+33eVzLYNLmiLNlqStZ9ObhfeIxAW+1Y
        F01aphvDBqZZHFPHF0xFW9EiJYwQlcE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-s5lE1D43M5Gf_xDHpCepfQ-1; Wed, 02 Mar 2022 13:04:48 -0500
X-MC-Unique: s5lE1D43M5Gf_xDHpCepfQ-1
Received: by mail-wm1-f70.google.com with SMTP id c62-20020a1c3541000000b003815245c642so2191205wma.6
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 10:04:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=TppJCGmipLpFSIwLputLq7WRzf+Iq52WdMq4YxQrcGM=;
        b=WhRIsytrV3lgPOzn6teXvYjcsvh5GDBuaGUz0Y8SA3ki7M9z8Whls/43o7R/POn/3D
         BjjXb6A7FBjlCBzA7NFVMMi4T2wzB7tjwJcAkiM9mMSn8Pf0894ckomdicYXkdhlsmG0
         DLHeRrCg4a7S6sGb0yrELki6PfWabrLtuLlxfKmBCJPepIYEx0S25JB+FoE3rc+Cd9zw
         qRfWGkzI/Q4BHP2irtqBPLL5OQuPr8ofhfpSlCZ4eGHl36psGEQi1ET7UCSH4Ui9xbDR
         4r6Jt34r3ahPrZQQvihup8UhB6kI3pNFbiGlFcF8c7gYUwlO2romKYlCXUqINdIPTLTF
         wz6w==
X-Gm-Message-State: AOAM532HLJSKf50r/TO3blJQfcS4h1OkaA1bXyRxTtePNr2h4Ex+di5k
        x3vgrZk/U8RmXtFexdZASsU7qi3b7JltfWbFXedqOAnaI4DwK2dhEqVkNzDs549H6eL3R1vJLB+
        GsNdLokOS7M8d
X-Received: by 2002:adf:eb87:0:b0:1ef:85f5:6ab4 with SMTP id t7-20020adfeb87000000b001ef85f56ab4mr17459850wrn.158.1646244286907;
        Wed, 02 Mar 2022 10:04:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWoswIXfFEgH0D5HMWiu8TDJQRQlM+OO4a41LM49zRdYWHoGQcZbXKGjU8uP0ioPgQ1HYS5Q==
X-Received: by 2002:adf:eb87:0:b0:1ef:85f5:6ab4 with SMTP id t7-20020adfeb87000000b001ef85f56ab4mr17459838wrn.158.1646244286615;
        Wed, 02 Mar 2022 10:04:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id j27-20020adfd21b000000b001e519f3e0d0sm17269490wrh.7.2022.03.02.10.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 10:04:45 -0800 (PST)
Message-ID: <ee757515-4a0f-c5cb-cd57-04983f62f499@redhat.com>
Date:   Wed, 2 Mar 2022 19:04:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root
 shadow page is zapped
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20220225182248.3812651-1-seanjc@google.com>
 <20220225182248.3812651-5-seanjc@google.com>
 <40a22c39-9da4-6c37-8ad0-b33970e35a2b@redhat.com>
In-Reply-To: <40a22c39-9da4-6c37-8ad0-b33970e35a2b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 18:55, Paolo Bonzini wrote:
> On 2/25/22 19:22, Sean Christopherson wrote:
>> @@ -5656,7 +5707,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>>        * Note: we need to do this under the protection of mmu_lock,
>>        * otherwise, vcpu would purge shadow page but miss tlb flush.
>>        */
>> -    kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
>> +    kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
> 
> I was going to squash in this:
> 
>        * invalidating TDP MMU roots must be done while holding mmu_lock for
> -     * write and in the same critical section as making the reload 
> request,
> +     * write and in the same critical section as making the free request,
>        * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and 
> yield.
> 
> But then I realized that this needs better comments and that my 
> knowledge of
> this has serious holes.  Regarding this comment, this is my proposal:
> 
>          /*
>           * Invalidated TDP MMU roots are zapped within MMU read_lock to be
>           * able to walk the list of roots, but with the expectation of no
>           * concurrent change to the pages themselves.  There cannot be
>           * any yield between kvm_tdp_mmu_invalidate_all_roots and the free
>           * request, otherwise somebody could grab a reference to the root
>       * and break that assumption.
>           */
>          if (is_tdp_mmu_enabled(kvm))
>                  kvm_tdp_mmu_invalidate_all_roots(kvm);
> 
> However, for the second comment (the one in the context above), there's 
> much
> more.  From easier to harder:
> 
> 1) I'm basically clueless about the TLB flush "note" above.
> 
> 2) It's not clear to me what needs to use for_each_tdp_mmu_root; for
> example, why would anything but the MMU notifiers use 
> for_each_tdp_mmu_root?
> It is used in kvm_tdp_mmu_write_protect_gfn, 
> kvm_tdp_mmu_try_split_huge_pages
> and kvm_tdp_mmu_clear_dirty_pt_masked.
> 
> 3) Does it make sense that yielding users of for_each_tdp_mmu_root must
> either look at valid roots only, or take MMU lock for write?  If so, can
> this be enforced in tdp_mmu_next_root?

Ok, I could understand this a little better now, but please correct me
if this is incorrect:

2) if I'm not wrong, kvm_tdp_mmu_try_split_huge_pages indeed does not
need to walk invalid  roots.  The others do because the TDP MMU does
not necessarily kick vCPUs after marking roots as invalid.  But
because TDP MMU roots are gone for good once their refcount hits 0,
I wonder if we could do something like

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7e3d1f985811..a4a6dfee27f9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -164,6 +164,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
  	 */
  	if (!kvm_tdp_root_mark_invalid(root)) {
  		refcount_set(&root->tdp_mmu_root_count, 1);
+		kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
  
  		/*
  		 * If the struct kvm is alive, we might as well zap the root
@@ -1099,12 +1100,16 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
  {
  	struct kvm_mmu_page *root;
+	bool invalidated_root = false
  
  	lockdep_assert_held_write(&kvm->mmu_lock);
  	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
  		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
-			root->role.invalid = true;
+			invalidated_root |= !kvm_tdp_root_mark_invalid(root);
  	}
+
+	if (invalidated_root)
+		kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
  }
  
  /*

(based on my own version of Sean's patches) and stop walking invalid roots
in kvm_tdp_mmu_write_protect_gfn and kvm_tdp_mmu_clear_dirty_pt_masked.


3) Yes, it makes sense that yielding users of for_each_tdp_mmu_root must
either look at valid roots only, or take MMU lock for write.  The only
exception is kvm_tdp_mmu_try_split_huge_pages, which does not need to
walk invalid roots.  And kvm_tdp_mmu_zap_invalidated_pages(), but that
one is basically an asynchronous worker [and this is where I had the
inspiration to get rid of the function altogether]

Paolo

