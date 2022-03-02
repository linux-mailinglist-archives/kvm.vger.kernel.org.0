Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827604CA899
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiCBOzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiCBOza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:55:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2363548396
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646232886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RrgBy/URXQ7yxGZ1lNrLQlpQAKYtAdhn5mnE5clLzSw=;
        b=iLr2IL+QxbiQOVKtu7ptWzSZM4dD0IJME8pdpTsa9GL4pH9ERay9wJZlwGOG5l08qp0qk9
        tdG1FX8Kg6B9s9WQ/0iWlLzLbbh05Uc5V7RiGuf2qHmR66iyZslumA8MA2u18Ko028Li81
        gWO/hGsxBBJuwgha9VvfED+sCoC0hmM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-HfatNy0eOMSbhM1K7PSl4w-1; Wed, 02 Mar 2022 09:54:45 -0500
X-MC-Unique: HfatNy0eOMSbhM1K7PSl4w-1
Received: by mail-wm1-f71.google.com with SMTP id d8-20020a05600c34c800b0037e3cd6225eso608821wmq.6
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:54:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=RrgBy/URXQ7yxGZ1lNrLQlpQAKYtAdhn5mnE5clLzSw=;
        b=nVMoaJreqSstpQHQZbeV+5QXQmR4X4B3b3LjhJL8+D5RT41CFOJlPcNz6iUlbRtjxo
         rB1v9mvrPS24r6jDsm0WgFHc6fbnPE7IWLrOja4FS1tDYVLCgDkvN0KXqo/oFUONNzFl
         TgtEu8EK28zcW3EP22iuGIaY+vEThHswY7F+pL1BbNTrFoeTQ8IjaQCdGqgKkkz7pzVH
         mXb5V7IMU4P97QCFI89R0EUY0cawsHuWzTJuqgCkXiDJiMmsHy5cMnhhh4FdxwN2B24y
         ZAZETWvmIsf8UAY/0+ULFalNwkGoEgfU2JDxsD8tX5KIMVAZXUqPvBKSjr0cov74hJ9j
         6UpA==
X-Gm-Message-State: AOAM5315GNw3hwrVc33EQaSjwcQYitOJswsRVwCMUym/QGEwHgSyklGT
        TYZFlIv2Aah903v3HbVON1oqeu+5HMO/0ca4dFuDjRPQ94q8g+2e/F7kHlso+D+jem32DAllhKP
        EkDP1x8TLu1qW
X-Received: by 2002:adf:d4c8:0:b0:1f0:22df:d67c with SMTP id w8-20020adfd4c8000000b001f022dfd67cmr4634787wrk.510.1646232883507;
        Wed, 02 Mar 2022 06:54:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylnVuocQZzGpWv/bVN7DI4IIK9QMOHjsY27kcSgMCpf030/jYzosx5ByAwmtCXQAeFV3wKeg==
X-Received: by 2002:adf:d4c8:0:b0:1f0:22df:d67c with SMTP id w8-20020adfd4c8000000b001f022dfd67cmr4634766wrk.510.1646232883127;
        Wed, 02 Mar 2022 06:54:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id f11-20020a7bcc0b000000b0037e0c362b6dsm5807313wmh.31.2022.03.02.06.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 06:54:42 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------lMqdFSkMSZVuSlXd7UQ6sFr2"
Message-ID: <2e856a9d-bef0-09ff-351a-113db9b36e2d@redhat.com>
Date:   Wed, 2 Mar 2022 15:54:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs
 for defunct TDP MMU root
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-21-seanjc@google.com>
 <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
 <Yh53V23gSJ6jphnS@google.com>
 <f444790d-3bc7-9870-576e-29f30354a63b@redhat.com>
 <Yh7SwAR/H5dPrqLN@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh7SwAR/H5dPrqLN@google.com>
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

This is a multi-part message in MIME format.
--------------lMqdFSkMSZVuSlXd7UQ6sFr2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/22 03:13, Sean Christopherson wrote:
> After typing up all of the below, I actually tried the novel idea of compiling
> the code... and we can't do xchg() on role.invalid because it occupies a single
> bit, it's not a standalone boolean.

Yeah I thought the same right after sending the email, but I'll just say it
was pseudocode. :)  We can do

static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
{
	union kvm_mmu_page_role role = page->role;
	role.invalid = true;

	/* No need to use cmpxchg, only the invalid bit can change.  */
	role.word = xchg(&page->role.word, role.word);
	return role.invalid;
}

Either way, barriers or xchg, it needs to be a separate function.

> by using refcount_dec_not_one() above, there's no guarantee that this
> task is the last one to see it as kvm_tdp_mmu_get_root() can succeed
> and bump the refcount between refcount_dec_not_one() and here.
Yep, I agree refcount_dec_and_test is needed.

>> Based on my own version, I guess you mean (without comments due to family
>> NMI):
>>
>>          if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>>                  return;
>>
>> 	if (!xchg(&root->role.invalid, true) {
>> 		refcount_set(&root->tdp_mmu_root_count, 1);
>> 	 	tdp_mmu_zap_root(kvm, root, shared);
>> 	        if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>>          	        return;
>> 	}
>>
>>          spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>>          list_del_rcu(&root->link);
>>          spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>>          call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> 
> That would work, though I'd prefer to recurse on kvm_tdp_mmu_put_root() instead
> of open coding refcount_dec_and_test() so that we get coverage of the xchg()
> doing the right thing.
> 
> I still slightly prefer having the "free" path be inside the xchg().  To me, even
> though the "free" path is the only one that's guaranteed to be reached for every root,
> the fall-through to resetting the refcount and zapping the root is the "normal" path,
> and the "free" path is the exception.

Hmm I can see how that makes especially sense once you add in the worker logic.
But it seems to me that the "basic" logic should be "do both the xchg and the
free", and coding the function with tail recursion obfuscates this.  Even with
the worker, you grow an

+	if (kvm_get_kvm_safe(kvm)) {
+		... let the worker do it ...
+		return;
+	}
+
	tdp_mmu_zap_root(kvm, root, shared);

but you still have a downwards flow that matches what happens even if multiple
threads pick up different parts of the job.

So, I tried a bunch of alternatives including with gotos and with if/else, but
really the above one remains my favorite.

My plan would be:

1) splice the mini series I'm attaching before this patch, and
remove patch 1 of this series.  next_invalidated_root() is a
bit yucky, but notably it doesn't need to add/remove a reference
in kvm_tdp_mmu_zap_invalidated_roots().

Together, these two steps ensure that readers never acquire a
reference to either refcount=0/valid or invalid pages".  In other
words, the three states of that kvm_tdp_mmu_put_root moves the root
through (refcount=0/valid -> refcount=0/invalid -> refcount=1/invalid)
are exactly the same to readers, and there are essentially no races
to worry about.

In other other words, it's trading slightly uglier code for simpler
invariants.

2) here, replace the change to kvm_tdp_mmu_put_root with the following:

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b6ffa91fb9d7..aa0669f54d96 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -81,6 +81,16 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
  static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
  			     bool shared);
  
+static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
+{
+	union kvm_mmu_page_role role = page->role;
+	role.invalid = true;
+
+	/* No need to use cmpxchg, only the invalid bit can change.  */
+	role.word = xchg(&page->role.word, role.word);
+	return role.invalid;
+}
+
  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
  			  bool shared)
  {
@@ -91,20 +101,44 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
  
  	WARN_ON(!root->tdp_mmu_page);
  
+	/*
+	 * The root now has refcount=0 and is valid.  Readers cannot acquire
+	 * a reference to it (they all visit valid roots only, except for
+	 * kvm_tdp_mmu_zap_invalidated_roots() which however does not acquire
+	 * any reference itself.
+	 *
+	 * Even though there are flows that need to visit all roots for
+	 * correctness, they all take mmu_lock for write, so they cannot yet
+	 * run concurrently. The same is true after kvm_tdp_root_mark_invalid,
+	 * since the root still has refcount=0.
+	 *
+	 * However, tdp_mmu_zap_root can yield, and writers do not expect to
+	 * see refcount=0 (see for example kvm_tdp_mmu_invalidate_all_roots()).
+	 * So the root temporarily gets an extra reference, going to refcount=1
+	 * while staying invalid.  Readers still cannot acquire any reference;
+	 * but writers are now allowed to run if tdp_mmu_zap_root yields and
+	 * they might take an extra reference is they themselves yield.  Therefore,
+	 * when the reference is given back after tdp_mmu_zap_root terminates,
+	 * there is no guarantee that the refcount is still 1.  If not, whoever
+	 * puts the last reference will free the page, but they will not have to
+	 * zap the root because a root cannot go from invalid to valid.
+	 */
+	if (!kvm_tdp_root_mark_invalid(root)) {
+		refcount_set(&root->tdp_mmu_root_count, 1);
+		tdp_mmu_zap_root(kvm, root, shared);
+
+		/*
+		 * Give back the reference that was added back above.  We now
+		 * know that the root is invalid, so go ahead and free it if
+		 * no one has taken a reference in the meanwhile.
+		 */
+		if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
+			return;
+	}
+
  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
  	list_del_rcu(&root->link);
  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-
-	/*
-	 * A TLB flush is not necessary as KVM performs a local TLB flush when
-	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
-	 * to a different pCPU.  Note, the local TLB flush on reuse also
-	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
-	 * intermediate paging structures, that may be zapped, as such entries
-	 * are associated with the ASID on both VMX and SVM.
-	 */
-	tdp_mmu_zap_root(kvm, root, shared);
-
  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
  }
  

3) for the worker patch, the idea would be

+static void tdp_mmu_zap_root_work(struct work_struct *work)
+{
+	...
+}
+
+
+static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+       root->tdp_mmu_async_data = kvm;
+       INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
+       schedule_work(&root->tdp_mmu_async_work);
+}
+
  static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
  {
         union kvm_mmu_page_role role = page->role;
@@ -125,13 +165,24 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
          */
         if (!kvm_tdp_root_mark_invalid(root)) {
                 refcount_set(&root->tdp_mmu_root_count, 1);
-               tdp_mmu_zap_root(kvm, root, shared);
  
                 /*
-                * Give back the reference that was added back above.  We now
+                * If the struct kvm is alive, we might as well zap the root
+                * in a worker.  The worker takes ownership of the reference we
+                * have just added to root as well as the new reference to kvm.
+                */
+               if (kvm_get_kvm_safe(kvm)) {
+                       tdp_mmu_schedule_zap_root(kvm, root);
+                       return;
+               }
+
+               /*
+                * The struct kvm is being destroyed, zap synchronously and give
+                * back immediately the reference that was added above.  We now
                  * know that the root is invalid, so go ahead and free it if
                  * no one has taken a reference in the meanwhile.
                  */
+               tdp_mmu_zap_root(kvm, root, shared);
                 if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
                         return;
         }


Again, I appreciate the idea behind the recursive call, but I think
overall it's clearer to have a clear flow from the beginning to the
end of the function, with the exceptions and optimizations noted as
early returns.

Let me know what you think.  Tomorrow I have a day off, but later
today I will have my changes tested and pushed to kvm/queue for you
to look at.

Thanks,

Paolo
--------------lMqdFSkMSZVuSlXd7UQ6sFr2
Content-Type: text/x-patch; charset=UTF-8; name="readers.patch"
Content-Disposition: attachment; filename="readers.patch"
Content-Transfer-Encoding: base64

RnJvbSBmNTRkMjNlYzI1OGRhN2M2MzFjN2IwNTkwNDhmYjM4M2I4MjU1MDc5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQu
Y29tPgpEYXRlOiBXZWQsIDIgTWFyIDIwMjIgMDg6NDQ6MjIgLTA1MDAKU3ViamVjdDogW1BB
VENIIDEvMl0gS1ZNOiB4ODYvbW11OiBvbmx5IHBlcmZvcm0gZWFnZXIgcGFnZSBzcGxpdHRp
bmcgb24gdmFsaWQKIHJvb3RzCgpFYWdlciBwYWdlIHNwbGl0dGluZyBpcyBhbiBvcHRpbWl6
YXRpb247IGl0IGRvZXMgbm90IGhhdmUgdG8gYmUgcGVyZm9ybWVkIG9uCmludmFsaWQgcm9v
dHMuICBCeSBvbmx5IG9wZXJhdGluZyBvbiB0aGUgdmFsaWQgcm9vdHMsIHRoaXMgcmVtb3Zl
cyB0aGUKb25seSBjYXNlIGluIHdoaWNoIGEgcmVhZGVyIG1pZ2h0IGFjcXVpcmUgYSByZWZl
cmVuY2UgdG8gYW4gaW52YWxpZCByb290LgoKU2lnbmVkLW9mZi1ieTogUGFvbG8gQm9uemlu
aSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KLS0tCiBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUu
YyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYv
a3ZtL21tdS90ZHBfbW11LmMKaW5kZXggOTQxZTI1ZmQxNGJkLi5lM2IxMDQ0NDhlMTQgMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jCisrKyBiL2FyY2gveDg2L2t2
bS9tbXUvdGRwX21tdS5jCkBAIC0xNTQxLDcgKzE1NDEsNyBAQCB2b2lkIGt2bV90ZHBfbW11
X3RyeV9zcGxpdF9odWdlX3BhZ2VzKHN0cnVjdCBrdm0gKmt2bSwKIAogCWt2bV9sb2NrZGVw
X2Fzc2VydF9tbXVfbG9ja19oZWxkKGt2bSwgc2hhcmVkKTsKIAotCWZvcl9lYWNoX3RkcF9t
bXVfcm9vdF95aWVsZF9zYWZlKGt2bSwgcm9vdCwgc2xvdC0+YXNfaWQsIHNoYXJlZCkgewor
CWZvcl9lYWNoX3ZhbGlkX3RkcF9tbXVfcm9vdF95aWVsZF9zYWZlKGt2bSwgcm9vdCwgc2xv
dC0+YXNfaWQsIHNoYXJlZCkgewogCQlyID0gdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jv
b3Qoa3ZtLCByb290LCBzdGFydCwgZW5kLCB0YXJnZXRfbGV2ZWwsIHNoYXJlZCk7CiAJCWlm
IChyKSB7CiAJCQlrdm1fdGRwX21tdV9wdXRfcm9vdChrdm0sIHJvb3QsIHNoYXJlZCk7Ci0t
IAoyLjMxLjEKCgpGcm9tIDk1NTU3NDgzYzJhMzIzODZjYjA3NjlhNjFmODM4NTUwZDk0Njc0
MzQgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCkZyb206IFBhb2xvIEJvbnppbmkgPHBib256
aW5pQHJlZGhhdC5jb20+CkRhdGU6IFdlZCwgMiBNYXIgMjAyMiAwODo1MTowNSAtMDUwMApT
dWJqZWN0OiBbUEFUQ0ggMi8yXSBLVk06IHg4Ni9tbXU6IGRvIG5vdCBhbGxvdyByZWFkZXJz
IHRvIGFjcXVpcmUgcmVmZXJlbmNlcwogdG8gaW52YWxpZCByb290cwoKUmVtb3ZlIHRoZSAi
c2hhcmVkIiBhcmd1bWVudCBvZiBmb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWllbGRfc2FmZSwg
dGh1cyBlbnN1cmluZwp0aGF0IHJlYWRlcnMgZG8gbm90IGV2ZXIgYWNxdWlyZSBhIHJlZmVy
ZW5jZSB0byBhbiBpbnZhbGlkIHJvb3QuICBBZnRlciB0aGlzCnBhdGNoLCBhbGwgcmVhZGVy
cyBleGNlcHQga3ZtX3RkcF9tbXVfemFwX2ludmFsaWRhdGVkX3Jvb3RzKCkgdHJlYXQKcmVm
Y291bnQ9MC92YWxpZCwgcmVmY291bnQ9MC9pbnZhbGlkIGFuZCByZWZjb3VudD0xL2ludmFs
aWQgaW4gZXhhY3RseSB0aGUKc2FtZSB3YXkuICBrdm1fdGRwX21tdV96YXBfaW52YWxpZGF0
ZWRfcm9vdHMoKSBpcyBkaWZmZXJlbnQgYnV0IGl0IGFsc28KZG9lcyBub3QgYWNxdWlyZSBh
IHJlZmVyZW5jZSB0byB0aGUgaW52YWxpZCByb290LCBhbmQgaXQgY2Fubm90IHNlZQpyZWZj
b3VudD0wL2ludmFsaWQgYmVjYXVzZSBpdCBpcyBndWFyYW50ZWVkIHRvIHJ1biBhZnRlcgpr
dm1fdGRwX21tdV9pbnZhbGlkYXRlX2FsbF9yb290cygpLgoKU2lnbmVkLW9mZi1ieTogUGFv
bG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KLS0tCiBhcmNoL3g4Ni9rdm0vbW11
L3RkcF9tbXUuYyB8IDEwICsrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS90
ZHBfbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYwppbmRleCBlM2IxMDQ0NDhl
MTQuLjJlOTM1ZWRkM2Y2YyAxMDA2NDQKLS0tIGEvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11
LmMKKysrIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMKQEAgLTE3MSw4ICsxNzEsOCBA
QCBzdGF0aWMgc3RydWN0IGt2bV9tbXVfcGFnZSAqdGRwX21tdV9uZXh0X3Jvb3Qoc3RydWN0
IGt2bSAqa3ZtLAogI2RlZmluZSBmb3JfZWFjaF92YWxpZF90ZHBfbW11X3Jvb3RfeWllbGRf
c2FmZShfa3ZtLCBfcm9vdCwgX2FzX2lkLCBfc2hhcmVkKQlcCiAJX19mb3JfZWFjaF90ZHBf
bW11X3Jvb3RfeWllbGRfc2FmZShfa3ZtLCBfcm9vdCwgX2FzX2lkLCBfc2hhcmVkLCB0cnVl
KQogCi0jZGVmaW5lIGZvcl9lYWNoX3RkcF9tbXVfcm9vdF95aWVsZF9zYWZlKF9rdm0sIF9y
b290LCBfYXNfaWQsIF9zaGFyZWQpCQlcCi0JX19mb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWll
bGRfc2FmZShfa3ZtLCBfcm9vdCwgX2FzX2lkLCBfc2hhcmVkLCBmYWxzZSkKKyNkZWZpbmUg
Zm9yX2VhY2hfdGRwX21tdV9yb290X3lpZWxkX3NhZmUoX2t2bSwgX3Jvb3QsIF9hc19pZCkJ
CQlcCisJX19mb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWllbGRfc2FmZShfa3ZtLCBfcm9vdCwg
X2FzX2lkLCBmYWxzZSwgZmFsc2UpCiAKIC8qCiAgKiBJdGVyYXRlIG92ZXIgYWxsIFREUCBN
TVUgcm9vdHMuICBSZXF1aXJlcyB0aGF0IG1tdV9sb2NrIGJlIGhlbGQgZm9yIHdyaXRlLApA
QCAtODc5LDcgKzg3OSw4IEBAIGJvb2wga3ZtX3RkcF9tbXVfemFwX2xlYWZzKHN0cnVjdCBr
dm0gKmt2bSwgaW50IGFzX2lkLCBnZm5fdCBzdGFydCwgZ2ZuX3QgZW5kLAogewogCXN0cnVj
dCBrdm1fbW11X3BhZ2UgKnJvb3Q7CiAKLQlmb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWllbGRf
c2FmZShrdm0sIHJvb3QsIGFzX2lkLCBmYWxzZSkKKwlsb2NrZGVwX2Fzc2VydF9oZWxkX3dy
aXRlKCZrdm0tPm1tdV9sb2NrKTsKKwlmb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWllbGRfc2Fm
ZShrdm0sIHJvb3QsIGFzX2lkKQogCQlmbHVzaCA9IHRkcF9tbXVfemFwX2xlYWZzKGt2bSwg
cm9vdCwgc3RhcnQsIGVuZCwgY2FuX3lpZWxkLCBmYWxzZSk7CiAKIAlyZXR1cm4gZmx1c2g7
CkBAIC04OTUsOCArODk2LDkgQEAgdm9pZCBrdm1fdGRwX21tdV96YXBfYWxsKHN0cnVjdCBr
dm0gKmt2bSkKIAkgKiBpcyBiZWluZyBkZXN0cm95ZWQgb3IgdGhlIHVzZXJzcGFjZSBWTU0g
aGFzIGV4aXRlZC4gIEluIGJvdGggY2FzZXMsCiAJICogS1ZNX1JVTiBpcyB1bnJlYWNoYWJs
ZSwgaS5lLiBubyB2Q1BVcyB3aWxsIGV2ZXIgc2VydmljZSB0aGUgcmVxdWVzdC4KIAkgKi8K
Kwlsb2NrZGVwX2Fzc2VydF9oZWxkX3dyaXRlKCZrdm0tPm1tdV9sb2NrKTsKIAlmb3IgKGkg
PSAwOyBpIDwgS1ZNX0FERFJFU1NfU1BBQ0VfTlVNOyBpKyspIHsKLQkJZm9yX2VhY2hfdGRw
X21tdV9yb290X3lpZWxkX3NhZmUoa3ZtLCByb290LCBpLCBmYWxzZSkKKwkJZm9yX2VhY2hf
dGRwX21tdV9yb290X3lpZWxkX3NhZmUoa3ZtLCByb290LCBpKQogCQkJdGRwX21tdV96YXBf
cm9vdChrdm0sIHJvb3QsIGZhbHNlKTsKIAl9CiB9Ci0tIAoyLjMxLjEKCg==

--------------lMqdFSkMSZVuSlXd7UQ6sFr2--

