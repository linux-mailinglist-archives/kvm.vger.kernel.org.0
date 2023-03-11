Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F249A6B5711
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCKArw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCKArK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:47:10 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD4913F183
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:43 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p10-20020a170902e74a00b0019ec1acba17so3633335plf.0
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UlahK4EgI3F4LmN6mIFBVS1s8jM35sN7dKW8KqGf28I=;
        b=XYfJ0XzSMcF3E1kvv8pyJPBUY1oOTCxtwnj2AeqySuQR1ZfvAKc1SW9iPHhnHJe3Gi
         XcutjwG0mgZaRNsN46psXVVdRMFDBq81EReYNPudybB7KQX35AkogMA4TCUr/VbuZvJx
         /Hku8ULfZNkx8JFRFzRKqCm+FH1VdoYEXygr0lWSRV08+fWnuTiTlMkxKw1BJvqob1GB
         3avYN4po4ipfmpO5vp3/rDjXCawszeDN6tP4Hn6j/nGQ5Mn2rLnkV2CSZ7GHd9sNhr7/
         o+PPXOXQsCoX2fQ9HR12St5LPalBRdIIsvavz0RQtcWzQFysV3ImhfIBkvx24fD+16hu
         zjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UlahK4EgI3F4LmN6mIFBVS1s8jM35sN7dKW8KqGf28I=;
        b=u2ki+ML/NB0UwiNIOiLcDGFua7Zp/Umu12UPqLRLdYPDxpwyh3g6DF+iu461B208ag
         NeA4DSTgb3J2EZhkljItgOBPXT1uyoivTbeCjdDmTV8mPVDFoyklFgH1mWbNxtvRUnyW
         k/Coxy1ql8iEpTVSr/3HBqD6mX09hpx2q78oUvKVUehQZH79/a5EUt/r2BjDPP4pLL13
         LU8Z9YvgcIiH/1/excxj8JLxI6u47dXnK0AldGzUYiN2NCUgeuWXkKJHRGD4P2bTH7fi
         jeHP3qtf/FZrV4eAo33WKnrfCk8rNZAeCCgEUWnXHumA3G81vwTq5lHitb22taHBAD+A
         mwqA==
X-Gm-Message-State: AO0yUKW55FvLX5Ei5ErdEBjGCJRbmSzvI1jx9+U0jQlLpwGCQnCPnJcx
        OiaTkZX1gliZtR/ISGkXiPgQaL4Op+M=
X-Google-Smtp-Source: AK7set8HwFPz9V2UekB+yM7oEJ6o6fajmdcDwtPEGxNDv9yOe0tK/NfCJPiB1RiF4p0C3VRjGYZd8q16rTg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:a512:0:b0:593:fcfb:208b with SMTP id
 v18-20020a62a512000000b00593fcfb208bmr11074429pfm.3.1678495602725; Fri, 10
 Mar 2023 16:46:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:08 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-12-seanjc@google.com>
Subject: [PATCH v3 11/21] KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Reimplement vcpu_set_msr() as a macro and pretty print the failing MSR
(when possible) and the value if KVM_SET_MSRS fails instead of using the
using the standard KVM_IOCTL_ERROR().  KVM_SET_MSRS is somewhat odd in
that it returns the index of the last successful write, i.e. will be
'0' on failure barring an entirely different KVM bug.  And for writing
MSRs, the MSR being written and the value being written are almost always
relevant to the failure, i.e. just saying "failed!" doesn't help debug.

Place the string goo in a separate macro in anticipation of using it to
further expand MSR testing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 30 ++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53ffa43c90db..26c8e202a956 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -928,14 +928,30 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index);
 int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value);
 
-static inline void vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index,
-				uint64_t msr_value)
-{
-	int r = _vcpu_set_msr(vcpu, msr_index, msr_value);
-
-	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_SET_MSRS, r));
-}
+/*
+ * Assert on an MSR access(es) and pretty print the MSR name when possible.
+ * Note, the caller provides the stringified name so that the name of macro is
+ * printed, not the value the macro resolves to (due to macro expansion).
+ */
+#define TEST_ASSERT_MSR(cond, fmt, msr, str, args...)				\
+do {										\
+	if (__builtin_constant_p(msr)) {					\
+		TEST_ASSERT(cond, fmt, str, args);				\
+	} else if (!(cond)) {							\
+		char buf[16];							\
+										\
+		snprintf(buf, sizeof(buf), "MSR 0x%x", msr);			\
+		TEST_ASSERT(cond, fmt, buf, args);				\
+	}									\
+} while (0)
 
+#define vcpu_set_msr(vcpu, msr, val)							\
+do {											\
+	uint64_t v = val;								\
+											\
+	TEST_ASSERT_MSR(_vcpu_set_msr(vcpu, msr, v) == 1,				\
+			"KVM_SET_MSRS failed on %s, value = 0x%lx", msr, #msr, v);	\
+} while (0)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
-- 
2.40.0.rc1.284.g88254d51c5-goog

