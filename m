Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B2E51B2A3
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379933AbiEDXBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379429AbiEDXAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:00:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA0258396
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:31 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i188-20020a636dc5000000b003c143f97bc2so1344220pgc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ImITDaKyBtkThLaJUpWVVxyOwWtQRhgJK8uxleorh40=;
        b=I5/dXrI0Zyq6aPBwvpxtNVIny30LcjxKzdxTg+xMw2uABG3fTfwqU+CKeyDML3A7WE
         iESb6YqBVExXCIGsVHaIAm5hvPYKw3lYWxsVSLmYdILkTa5cZ8pDnkW/x306HFtCxwoe
         IRwrHnq9Nr5YRwY9oir2y/2Lo0EILNcXKJR6xL6u3/QtNve6r0WMyNWJioGm5cQwyBcv
         BoWOj9KuzLkR8MphZd/e+/Cd+v+9HPbJeRMgan7fxADO0fp3vn9pKeKzIN3qVtB1Xd5C
         Md5v6wfpzwUz3MfM/e7COSB5ZI05qcTEZzEQ4M6HGRqzAbYwygorlDrB/G6ZMqdsm4or
         9PFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ImITDaKyBtkThLaJUpWVVxyOwWtQRhgJK8uxleorh40=;
        b=AQdAbD3X6aR7X7G7aiCIi/7lRUeTyDbwEjN4n8T5vUOPjWY0sRlzO0e1EZ7iZ5sAC0
         oszaqMm5ewibKZw+dt1J9YI1l2DypRiY0JP3OhMsnZgBxIReWCM6ky+EYodPMA/mqs0e
         1iHtpkrcj3NkgS+XJPwxhYrsk29gQsUCt4s80+Lv5IhfsUrjLzpZ4/Xn4r/Ks182ND0S
         P2IcyZW9I8bon6U1nLci+dNWasEEtuYnarZU6SOPYb/j8YcOMKiMQ/6F6cfBBOVvKn3h
         0r0721k/YmTd53riljOw5oi1N0s3uPrcy5qGeEMhSQ4N4MwoIxbNyVFJtDxuxaZs2lkB
         EgsA==
X-Gm-Message-State: AOAM5338BElLlJrj+iDQhgRe+/R0c1+MUnhBMsAPmMLwmvtYAA8YvUsN
        YKZXY4S0aXy+RSPPK3Y76FXn+Hw8j5s=
X-Google-Smtp-Source: ABdhPJzExXBkY1l3swQDMZ7ZYuQWL0GSRHERa+Mb9iCOj8Hp691xytqU/tqSPbxCC9s7wFUjfMF+CyAw6OA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP id
 t16-20020a17090ae51000b001d9ee239fa1mr140692pjy.0.1651704779761; Wed, 04 May
 2022 15:52:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:07 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-122-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 121/128] KVM: selftests: Drop vcpu_get(), rename vcpu_find()
 => vcpu_exists()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop vcpu_get() and rename vcpu_find() to vcpu_exists() to make it that
much harder for a test to give meaning to a vCPU ID.  I.e. force tests to
capture a vCPU when the vCPU is created.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 --
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 +++++++------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c0533f2ab418..5ab9b5380310 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -93,8 +93,6 @@ struct kvm_vm {
 			continue;			\
 		else
 
-struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpu_id);
-
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 822bdcb5c38c..c5156e0caa98 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -463,26 +463,6 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
-static struct kvm_vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpu_id)
-{
-	struct kvm_vcpu *vcpu;
-
-	list_for_each_entry(vcpu, &vm->vcpus, list) {
-		if (vcpu->id == vcpu_id)
-			return vcpu;
-	}
-
-	return NULL;
-}
-
-struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpu_id)
-{
-	struct kvm_vcpu *vcpu = vcpu_find(vm, vcpu_id);
-
-	TEST_ASSERT(vcpu, "vCPU %d does not exist", vcpu_id);
-	return vcpu;
-}
-
 /*
  * VM VCPU Remove
  *
@@ -1053,6 +1033,18 @@ static int vcpu_mmap_sz(void)
 	return ret;
 }
 
+static bool vcpu_exists(struct kvm_vm *vm, uint32_t vcpu_id)
+{
+	struct kvm_vcpu *vcpu;
+
+	list_for_each_entry(vcpu, &vm->vcpus, list) {
+		if (vcpu->id == vcpu_id)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Adds a virtual CPU to the VM specified by vm with the ID given by vcpu_id.
  * No additional vCPU setup is done.  Returns the vCPU.
@@ -1062,7 +1054,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
-	TEST_ASSERT(!vcpu_find(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
+	TEST_ASSERT(!vcpu_exists(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
 
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
-- 
2.36.0.464.gb9c8b46e94-goog

