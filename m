Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E6A53C20D
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbiFCAoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239971AbiFCAoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5352F344DE
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:53 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d12-20020a17090a628c00b001dcd2efca39so3406513pjj.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZToLd+b6cE0macinzYD5MjEUTm772bDRWbsALHzHspU=;
        b=MUpGemkGOlOWFgEEZSXBT4G8ZoMbr6BUHUM0fU83XgI3L/FL2odp9+OWKxJuZoi7i4
         lnWVp7vFfIsPFuUNsSoRiJF71usk7FBnWnhUsqkAbwoSTrFXrzxniwtg/HmW9Bojxpmn
         bTgvHEMziq3moqwfzH0Z0PuCTBAYCOy3aEdq+vViMD28h+PqPzvJoTI60kZx6DO0GXlE
         ptAKxC3/NKZssdN8WNNpoBtH8a3QdlbaI+wUyM5W19bl7C0bdgL785r3ernzuquKjjkT
         J6h9+g04ZOM2a32iaJi4o6rtBTfgnNXqgdA1d/Xj2iRjOrYldfTL1umZG/BknWMLBkAX
         KXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZToLd+b6cE0macinzYD5MjEUTm772bDRWbsALHzHspU=;
        b=kdPOqUr1r4Sk4gGyr1PsbYGAYUBzEUUPeOjkCMWIVDoSuXW4BC0VXVkk6gOtV9Kbjn
         RSiov33db2ynKbhjKJRQsUwBIMlIipMgXts/zO/fcpVi1MoruyW56Oqi+Gbo5r4SKmv9
         IdiYuRPZB2c76tZJFYZ60Z6GH3WqOtaWv/j2XJ5Vn26/LHKvgr3mJshiMbZUnhUbP8RE
         9uJA3Br3b849HszjkXvGqHz4OeUdhtoK8RkFcjozi6vAX0TChN4ruSsWfOGtun3ilz/u
         oSs+l2wP6bWu4KjlihR3junHA5TdRRP9wqaIolSe5h9mmSG444eM9MH/wT4TNuFbUJd5
         lshA==
X-Gm-Message-State: AOAM532D6cSObc6LYb2oCKm0IpMeAfCi8oX2MY+HXgOzCAa9tUWv3se9
        Q4WOGTnMABS6PZRlUGYmAybFv9gcnM0=
X-Google-Smtp-Source: ABdhPJxHcJcyC0Vrg7eTR6RNdt1Ajan21uMkaqKI7aGsbkpydsH/MuysYjLHyzbiYczf03T2zP3cotzI0zg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:e116:0:b0:51b:c452:47e6 with SMTP id
 q22-20020a62e116000000b0051bc45247e6mr7025147pfh.25.1654217032760; Thu, 02
 Jun 2022 17:43:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:16 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 009/144] KVM: selftests: Split vcpu_set_nested_state() into
 two helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Split vcpu_nested_state_set() into a wrapper that asserts, and an inner
helper that does not.  Passing a bool is all kinds of awful as it's
unintuitive for readers and requires returning an 'int' from a function
that for most users can never return anything other than "success".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  6 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 20 +++++++++----------
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f6984b0c3816..314d971c1f06 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -261,8 +261,10 @@ void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
 #ifdef __x86_64__
 void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
 			   struct kvm_nested_state *state);
-int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_nested_state *state, bool ignore_error);
+int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			    struct kvm_nested_state *state);
+void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			   struct kvm_nested_state *state);
 #endif
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bab4ab297fcc..7b339f98070b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1826,22 +1826,22 @@ void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
 		ret, errno);
 }
 
-int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_nested_state *state, bool ignore_error)
+int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			    struct kvm_nested_state *state)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	ret = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
-	if (!ignore_error) {
-		TEST_ASSERT(ret == 0,
-			"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
-			ret, errno);
-	}
+	return ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
+}
 
-	return ret;
+void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			   struct kvm_nested_state *state)
+{
+	int ret = __vcpu_nested_state_set(vm, vcpuid, state);
+
+	TEST_ASSERT(!ret, "KVM_SET_NESTED_STATE failed, ret: %i errno: %i", ret, errno);
 }
 #endif
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 5827b9bae468..af3b60eb35ec 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -29,7 +29,7 @@ bool have_evmcs;
 
 void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
 {
-	vcpu_nested_state_set(vm, VCPU_ID, state, false);
+	vcpu_nested_state_set(vm, VCPU_ID, state);
 }
 
 void test_nested_state_expect_errno(struct kvm_vm *vm,
@@ -38,7 +38,7 @@ void test_nested_state_expect_errno(struct kvm_vm *vm,
 {
 	int rv;
 
-	rv = vcpu_nested_state_set(vm, VCPU_ID, state, true);
+	rv = __vcpu_nested_state_set(vm, VCPU_ID, state);
 	TEST_ASSERT(rv == -1 && errno == expected_errno,
 		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
 		strerror(expected_errno), expected_errno, rv, strerror(errno),
-- 
2.36.1.255.ge46751e96f-goog

