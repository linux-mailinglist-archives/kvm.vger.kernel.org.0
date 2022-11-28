Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECB963B50A
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiK1W5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiK1W5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:57:45 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DAC183AA
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:57:43 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l7-20020a170902f68700b001890d921b36so11412556plg.2
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zg00uXws3lbVg3WmOqt0KpGktbnRibsEvuUvf38EKYM=;
        b=SNEgHTuGepcVT0hleAXFeoidYnrZiTOu7AkH1RwjlgjAosXoj3yc1R/6F0kUvHY7MY
         4DBYI6QMKEWoS5M//J9FBtvLrYhjPojsC4VZuLtPdW2O/SPUDeEZAtuF0TW3frT4K0e4
         pYXGa2J04ZbXHsBHLxiGK1JuUgJOa66Uq2eCkISqQ+4lCJ/tDR1njpPMzHxR8TEWDXHQ
         hf0DcH+JUueqy9AjZOTM8u14qMNII20fpQZ2sE8WyuhzRZwDeppDhhwowMqggp9EsLCQ
         RdzCut7ZXqwQDBhIlUJaq166VW8OEdr/7fxCw7mAveyt/Bxe3KITHfFqT4ewtd9sfbZ5
         j1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zg00uXws3lbVg3WmOqt0KpGktbnRibsEvuUvf38EKYM=;
        b=Sxc0c/3hB4dU1CfUIriT6RzrUaM9XnoYcdLRG8ifst4Qz7sWO/gwd0a6cFIVYiJYHE
         IyEMcsgHB9J7u0/rHIFKKo0qw8biV+2bQ0yNpjWcBJIaSNWCKK8BqAE/UnfG2cO7TkSx
         zeQhQPIrlEQpJzcqhQ1VV/hAlOjmfZSHR0zmQipzT8SZR1/apP+YjoBq+z88gfUrbnI4
         CGJ/kwBWrTGum7d9AW3bjC8EGLsqxBwAxcL/gv143PXYPbGFnmwj5bEUz1vRz1SKRfSh
         q19liBjlPxkZd242yKB8bzeYPng9Xw1DqGCNrDQhbmh81E07AyhJHK5Rv5J+1YcHFkvG
         cPlg==
X-Gm-Message-State: ANoB5plbPsgaJyCeOljYSCJ50nMLOEJtGwlmfqg6MtGT2tVElAbEO9o3
        O2ubmW13OE4tMgut7O0Y6NstR8nAkpI=
X-Google-Smtp-Source: AA0mqf4sPgJrNPggTk8EPKR2ZTR0EsdjpcO1b2cyeDyCdqWYpYpz4yM89OYrhWQlkWwe9xl2r6d8kAjPvPs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9f0d:0:b0:56b:e16d:b08 with SMTP id
 g13-20020aa79f0d000000b0056be16d0b08mr34328668pfr.70.1669676262984; Mon, 28
 Nov 2022 14:57:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 28 Nov 2022 22:57:33 +0000
In-Reply-To: <20221128225735.3291648-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221128225735.3291648-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221128225735.3291648-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: selftests: Move __vm_xsave_require_permission()
 below CPUID helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lei Wang <lei4.wang@intel.com>,
        Sean Christopherson <seanjc@google.com>
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

Move __vm_xsave_require_permission() below the CPUID helpers so that a
future change can reference the cached result of KVM_GET_SUPPORTED_CPUID
while keeping the definition of the variable close to its intended user,
kvm_get_supported_cpuid().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 64 +++++++++----------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index aac7b32a794b..23067465c035 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -552,38 +552,6 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
-void __vm_xsave_require_permission(int bit, const char *name)
-{
-	int kvm_fd;
-	u64 bitmask;
-	long rc;
-	struct kvm_device_attr attr = {
-		.group = 0,
-		.attr = KVM_X86_XCOMP_GUEST_SUPP,
-		.addr = (unsigned long) &bitmask
-	};
-
-	kvm_fd = open_kvm_dev_path_or_exit();
-	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
-	close(kvm_fd);
-
-	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
-		__TEST_REQUIRE(0, "KVM_X86_XCOMP_GUEST_SUPP not supported");
-
-	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
-
-	__TEST_REQUIRE(bitmask & (1ULL << bit),
-		       "Required XSAVE feature '%s' not supported", name);
-
-	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit));
-
-	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
-	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
-	TEST_ASSERT(bitmask & (1ULL << bit),
-		    "prctl(ARCH_REQ_XCOMP_GUEST_PERM) failure bitmask=0x%lx",
-		    bitmask);
-}
-
 void kvm_arch_vm_post_create(struct kvm_vm *vm)
 {
 	vm_create_irqchip(vm);
@@ -705,6 +673,38 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 	return buffer.entry.data;
 }
 
+void __vm_xsave_require_permission(int bit, const char *name)
+{
+	int kvm_fd;
+	u64 bitmask;
+	long rc;
+	struct kvm_device_attr attr = {
+		.group = 0,
+		.attr = KVM_X86_XCOMP_GUEST_SUPP,
+		.addr = (unsigned long) &bitmask
+	};
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
+	close(kvm_fd);
+
+	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
+		__TEST_REQUIRE(0, "KVM_X86_XCOMP_GUEST_SUPP not supported");
+
+	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
+
+	__TEST_REQUIRE(bitmask & (1ULL << bit),
+		       "Required XSAVE feature '%s' not supported", name);
+
+	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit));
+
+	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
+	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
+	TEST_ASSERT(bitmask & (1ULL << bit),
+		    "prctl(ARCH_REQ_XCOMP_GUEST_PERM) failure bitmask=0x%lx",
+		    bitmask);
+}
+
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid)
 {
 	TEST_ASSERT(cpuid != vcpu->cpuid, "@cpuid can't be the vCPU's CPUID");
-- 
2.38.1.584.g0f3c55d4c2-goog

