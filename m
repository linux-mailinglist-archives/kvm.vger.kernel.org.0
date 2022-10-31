Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297BF613CCB
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJaSBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJaSBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:01:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF61513DCE
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-360a7ff46c3so108769047b3.12
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fUax8zk38TfX3ZHfYoXO0Z/gTphayQ7H+KL0pW9fwP0=;
        b=N5RvQXoh/pqNeTNg1QX1HAJwERc2uRU+S5Xfy9zqMQl67B9frO4nT2TNDJ199hCPK9
         aDypUp1jwAF0y94w4Yjimn7Ho9uWCb4i1Xa2qHtBH/JSLVa4+w0MESZWpN0KF2x0vaD9
         L03LdwOFr3/Jdmrp1hhoC+ukkVuLqA1GOWnxU6Yh6fCxHOh12aGQGs0gxsZfuNS3qnyi
         brNtgpWmt6NC8mTflVWKMgqIbGohr+CuUBquFD6NHbA3cuWxoC7FxXtxRiMpX2ckfPjI
         Wt6sWYeO4CvMHGQmwpbwdGdnslXJFVAYdCg7RYHVjJwK2xjBVXa14n+nHd5y3uyPZ7PR
         glKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fUax8zk38TfX3ZHfYoXO0Z/gTphayQ7H+KL0pW9fwP0=;
        b=uoRSZDz7/snnFF7LoNsE+y0mqEbuttPlav76RO3+vKUbzrldSOoH5nqQSjKQQprmrH
         Bz+7gmJXFWP/bHLB6nambxS+RNwe4+ETtHcYoROGY0pJ6v9cQos8363v1G4tOWdA/RWW
         fiYMs7cxHbXpwElvLj6/SSLOoP7ARN5E/GXJ3LBiJMg87YW7337aHQMm4ZSoWCvFU1WY
         DHn16+aGQ+JNkfQs61m/7AHLN9ssL1V8LnGtDKnjQoxe8q9HtLv661wgpV0wQ7OFux1w
         7BPQ88audUIch3hyVJODFWwCGxZqPIrD/91xo2djflgfJVXD5ysiC83BE2j+yUnHcsMm
         d4yA==
X-Gm-Message-State: ACrzQf3pcWCCglvbK6p5jJIdlnlOso0uALKBXKCDqTbvSj+W0Hx5V/7I
        Ay8tZrDJRVL363Gq/uTWbZbaMZMMUKUtAQ==
X-Google-Smtp-Source: AMsMyM4uNgM42PUGuS223PfGwHn0V4BfrgzpVwXoNHoT6zI0YA0etvt6X8WnnEDDZiK6Sp04SRrxHftHVn0Amw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:10c:0:b0:6be:28ee:2b86 with SMTP id
 12-20020a5b010c000000b006be28ee2b86mr12975643ybx.582.1667239266012; Mon, 31
 Oct 2022 11:01:06 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:44 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-10-dmatlack@google.com>
Subject: [PATCH v3 09/10] KVM: selftests: Expect #PF(RSVD) when TDP is disabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Change smaller_maxphyaddr_emulation_test to expect a #PF(RSVD), rather
than an emulation failure, when TDP is disabled. KVM only needs to
emulate instructions to emulate a smaller guest.MAXPHYADDR when TDP is
enabled.

Fixes: 39bbcc3a4e39 ("selftests: kvm: Allows userspace to handle emulation errors.")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../smaller_maxphyaddr_emulation_test.c       | 47 ++++++++++++++++---
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index f438a98e8bb7..5934ddc94aa0 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -21,9 +21,22 @@
 #define MEM_REGION_SLOT	10
 #define MEM_REGION_SIZE PAGE_SIZE
 
-static void guest_code(void)
+static void guest_code(bool tdp_enabled)
 {
-	flds(MEM_REGION_GVA);
+	uint64_t error_code;
+	uint64_t vector;
+
+	vector = kvm_asm_safe_ec(FLDS_MEM_EAX, error_code, "a"(MEM_REGION_GVA));
+
+	/*
+	 * When TDP is disabled, no instruction emulation is required so flds
+	 * should generate #PF(RSVD).
+	 */
+	if (!tdp_enabled) {
+		GUEST_ASSERT_EQ(vector, PF_VECTOR);
+		GUEST_ASSERT(error_code & PFERR_RSVD_MASK);
+	}
+
 	GUEST_DONE();
 }
 
@@ -32,6 +45,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t gpa, pte;
+	struct ucall uc;
 	uint64_t *hva;
 	int rc;
 
@@ -41,6 +55,10 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_args_set(vcpu, 1, kvm_is_tdp_enabled());
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
 
 	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
 
@@ -61,10 +79,27 @@ int main(int argc, char *argv[])
 	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
 
 	vcpu_run(vcpu);
-	assert_exit_for_flds_emulation_failure(vcpu);
-	skip_flds_instruction(vcpu);
-	vcpu_run(vcpu);
-	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	/*
+	 * When TDP is enabled, KVM must emulate the flds instruction, which
+	 * results in an emulation failure out to userspace since KVM does not
+	 * know how to emulate flds.
+	 */
+	if (kvm_is_tdp_enabled()) {
+		assert_exit_for_flds_emulation_failure(vcpu);
+		skip_flds_instruction(vcpu);
+		vcpu_run(vcpu);
+	}
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unrecognized ucall: %lu\n", uc.cmd);
+	}
 
 	kvm_vm_free(vm);
 
-- 
2.38.1.273.g43a17bfeac-goog

