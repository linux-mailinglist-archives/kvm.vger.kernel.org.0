Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E946BA518
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjCOCS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCOCSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1532E805
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544570e6d82so54176987b3.23
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTfFnzlVbgHA4yLi91OjwVvIMZq5YobnQNy+0t5Y1os=;
        b=SbQbTgauOj8SF/qThrELRob6CK7088fdCcev5pgnuA+5goVZf/VLoIpx7OqUGayKlM
         e4uKHpvIAmfutRl7l641AWGwe/LvcioX6Gu9AnE3aBroPtzBXj7CXTmG+UypGqBOFiSy
         X9QwL1TCMSgRYe5+MpXevQNvqfgeB2qhMpyTi1n+r0arQEJ1jBDyK3p0IgFqDsLOn/D3
         fwCUzve3AAjtB/4hP0kX6SzWFsoMCR9sKalBDY19z1Z/5CWY8MyqE6dJkP2RebhTJhEr
         7ygnzdd0diBDTbe7lzTSfsS3L0CFipjN2K1Oyk6M8OiH9r1RH0ibxntzaitJ1+gFlyZY
         TZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTfFnzlVbgHA4yLi91OjwVvIMZq5YobnQNy+0t5Y1os=;
        b=fHcuq7Irq+oTkJ3Q1F9AwueCieB7Ba5jVyYRlH3tKtQbYXL4xA1p6c1Pc+0UviWCii
         Bg+cJM6YT3yM5dgXiawFT01I7e1m0Nu/wcKfqx06/Ta+gf32jYig7jvxNQwO5yuws5gh
         c3jBZpWCMHxuF3+YCgHPZMhj82o8rAs0Zfl337w8QkBp7osOnC4n/ENM/RIoJ6WkJ5a1
         WS0O0Y/xG5qOAx1uO5OqXeVyrhORWXaVOYxxJar0p1T2uM292KFhgveFfvpc6JBXEWJS
         QvkZr0m75a5EQCDvQFO8pQ7ESbZYXh7G5kzIkSswwDoHcsEAr0RE9uTIbmPWVFlXGzkR
         tdPw==
X-Gm-Message-State: AO0yUKW7QnTEDu8Zz0w7dmDAxV4r8JM5x036kKfMj7IxspejhMRvZxyQ
        V/YFgdggLhAo/Mi7mEycioWsDqliyM7KwA==
X-Google-Smtp-Source: AK7set8/aAE7Rd9xJfziTRYdmCtUeLmMv5J5T3P62J+/VebncMoCBFFRoUNLdvxtoxYaShNuBQDN1UFjPf67ZQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:728:b0:b48:5eaa:a804 with SMTP
 id l8-20020a056902072800b00b485eaaa804mr1758041ybt.0.1678846690946; Tue, 14
 Mar 2023 19:18:10 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:35 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-12-amoorthy@google.com>
Subject: [WIP Patch v2 11/14] KVM: arm64: Allow user_mem_abort to return 0 to
 signal a 'normal' exit
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_handle_guest_abort currently just returns 1 if user_mem_abort
returns 0. Since 1 is the "resume the guest" code, user_mem_abort is
essentially incapable of triggering a "normal" exit: it can only trigger
exits by returning a negative value, which indicates an error.

Remove the "if (ret == 0) ret = 1;" statement from
kvm_handle_guest_abort and refactor user_mem_abort slightly to allow it
to trigger 'normal' exits by returning 0.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ffe..735044859eb25 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1190,7 +1190,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
 {
-	int ret = 0;
+	int ret = 1;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault;
 	bool device = false;
@@ -1281,8 +1281,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	    (logging_active && write_fault)) {
 		ret = kvm_mmu_topup_memory_cache(memcache,
 						 kvm_mmu_cache_min_pages(kvm));
-		if (ret)
+		if (ret < 0)
 			return ret;
+		else
+			ret = 1;
 	}
 
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
@@ -1305,7 +1307,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 				   write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
-		return 0;
+		return 1;
 	}
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
@@ -1387,6 +1389,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 					     KVM_PGTABLE_WALK_HANDLE_FAULT |
 					     KVM_PGTABLE_WALK_SHARED);
 
+	if (ret == 0)
+		ret = 1;
+
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
@@ -1397,7 +1402,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	read_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
-	return ret != -EAGAIN ? ret : 0;
+	return ret != -EAGAIN ? ret : 1;
 }
 
 /* Resolve the access fault by making the page young again. */
@@ -1549,8 +1554,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	}
 
 	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
-	if (ret == 0)
-		ret = 1;
 out:
 	if (ret == -ENOEXEC) {
 		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-- 
2.40.0.rc1.284.g88254d51c5-goog

