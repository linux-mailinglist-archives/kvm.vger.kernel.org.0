Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E30D57AA97
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiGSXu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiGSXuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:50:24 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4746932BA5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o3-20020a17090aac0300b001f210a5e47aso260290pjq.7
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BeLUBPWGvrc1z4ayLhHoeORRjwnbyy4mCi2eqGdwMcQ=;
        b=ZcO7RFWgYV6BKEYKTi4CwajtwHcMIW/kQDa14t+Z5p/2btKv7Lsd65ZwXJxvg23uHn
         IsWYQR2aVRYbsehw0mh2InIlozJI4xkuqBRaymR6xoJusYvZLN0EJLlF/sFtt7lUedIt
         hOyUNAO0ONJgm2Yr4e9ARSUyIgWVm+W3bS398SuVbGgN4D9NZ8F+dC4O0tY8ZPseEanA
         sqt8wYS/b5eMwzp06EjdTJdfDMFc4PKq9o9BE1wbxj1SRoQsl0WZEQ3Nkj7mF8I4ItOz
         t7jZMiXwgLfKLzq2++Ghf2m9bxj7UmEUyYAGQcLW162PspODoIh8zTdzxv1mGiSDntPb
         Px6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BeLUBPWGvrc1z4ayLhHoeORRjwnbyy4mCi2eqGdwMcQ=;
        b=7FVUYFFbT5keJiTbuNkBqgJZNHC79NTzFzchrnENvr+6Ugr29S0wFceJYeshH7Eeu8
         Z4Mi81PclSbjhw4QWZB64x6IATNxMU/2gdRsq/IbgepmSXQwdfW70j8kq2UIJcOQS+c1
         wcB4TKSQogF3ZdqfdpAsI5rkJVsBun3Ea5RRvyuIbsF3pUriGQNPJdjHesBH9M131rrU
         X5+PSV7Tdg8XIU/XeFns8Qvxzy/suSrTLOs6VlDTXST+Zzp7VCuhukpT3JJrd8vaGqCC
         e5buxqJNuVFvO7LfD3O98CrNDvpRinn3sg9OUowuxBeTB8LnpIs+5lrlqg8tVzfXrQgl
         S22g==
X-Gm-Message-State: AJIora9eAXPb8SyGZ5rGLhnvolcxqfPeQrCm6pfYLjT9avyQJoRUqj7Q
        0ccxCeCzuP8pCAJa/2hchWWBycgJKSZzbEkGNYu/NgAtmMuD3ww6dYaho60q9hTs9vD7JmDmn52
        6n1U13bl5AjrAFLF96ImMoTYAIS4rU9C9OJqz0OXlcr+LaPebhMtT3L5VmzOkqs07NZwi
X-Google-Smtp-Source: AGRyM1st7uUbJNGtpgQrCAA/vwf6kPQlthY9EgcKC5332JcCDPmtWwB+4UYGgdOo4BhmYBUFLz21u+l4emMjwYkk
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:1190:b0:1f2:69d:40c9 with SMTP
 id e16-20020a17090a119000b001f2069d40c9mr2065680pja.188.1658274622705; Tue,
 19 Jul 2022 16:50:22 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:49:51 +0000
In-Reply-To: <20220719234950.3612318-1-aaronlewis@google.com>
Message-Id: <20220719234950.3612318-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220719234950.3612318-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH v2 3/3] selftests: kvm/x86: Test the flags in MSR
 filtering / exiting
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

When using the flags in KVM_X86_SET_MSR_FILTER and
KVM_CAP_X86_USER_SPACE_MSR it is expected that an attempt to write to
any of the unused bits will fail.  Add testing to walk over every bit
in each of the flag fields in MSR filtering / exiting to verify that
happens.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/userspace_msr_exit_test.c      | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index f84dc37426f5..3b4ad16cc982 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -734,6 +734,99 @@ static void test_msr_permission_bitmap(void)
 	kvm_vm_free(vm);
 }
 
+static void test_results(int rc, const char *scmd, bool expected_success)
+{
+	int expected_rc;
+
+	expected_rc = expected_success ? 0 : -1;
+	TEST_ASSERT(rc == expected_rc,
+		    "Unexpected result from '%s', rc: %d, expected rc: %d.",
+		    scmd, rc, expected_rc);
+	TEST_ASSERT(!rc || (rc == -1 && errno == EINVAL),
+		    "Failures are expected to have rc == -1 && errno == EINVAL(%d),\n"
+		    "  got rc: %d, errno: %d",
+		    EINVAL, rc, errno);
+}
+
+#define test_ioctl(vm, cmd, arg, expected_success)	\
+({							\
+	int rc = __vm_ioctl(vm, cmd, arg);		\
+							\
+	test_results(rc, #cmd, expected_success);	\
+})
+#define FLAG (1ul << i)
+
+static void run_user_space_msr_flag_test(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = { .cap = KVM_CAP_X86_USER_SPACE_MSR };
+	int nflags = sizeof(cap.args[0]) * BITS_PER_BYTE;
+	int rc;
+	int i;
+
+	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
+	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+
+	for (i = 0; i < nflags; i++) {
+		cap.args[0] = FLAG;
+		test_ioctl(vm, KVM_ENABLE_CAP, &cap,
+			   FLAG & KVM_MSR_EXIT_REASON_VALID_MASK);
+	}
+}
+
+static void run_msr_filter_flag_test(struct kvm_vm *vm)
+{
+	u64 deny_bits = 0;
+	struct kvm_msr_filter filter = {
+		.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+		.ranges = {
+			{
+				.flags = KVM_MSR_FILTER_READ,
+				.nmsrs = 1,
+				.base = 0,
+				.bitmap = (uint8_t *)&deny_bits,
+			},
+		},
+	};
+	int nflags;
+	int rc;
+	int i;
+
+	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
+	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
+
+	nflags = sizeof(filter.flags) * BITS_PER_BYTE;
+	for (i = 0; i < nflags; i++) {
+		filter.flags = FLAG;
+		test_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter,
+			   FLAG & KVM_MSR_FILTER_VALID_MASK);
+	}
+
+	filter.flags = KVM_MSR_FILTER_DEFAULT_ALLOW;
+	nflags = sizeof(filter.ranges[0].flags) * BITS_PER_BYTE;
+	for (i = 0; i < nflags; i++) {
+		filter.ranges[0].flags = FLAG;
+		test_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter,
+			   FLAG & KVM_MSR_FILTER_RANGE_VALID_MASK);
+	}
+}
+
+/* Test that attempts to write to the unused bits in a flag fails. */
+static void test_flags(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	/* Test flags for KVM_CAP_X86_USER_SPACE_MSR. */
+	run_user_space_msr_flag_test(vm);
+
+	/* Test flags and range flags for KVM_X86_SET_MSR_FILTER. */
+	run_msr_filter_flag_test(vm);
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	/* Tell stdout not to buffer its content */
@@ -745,5 +838,7 @@ int main(int argc, char *argv[])
 
 	test_msr_permission_bitmap();
 
+	test_flags();
+
 	return 0;
 }
-- 
2.37.1.359.gd136c6c3e2-goog

