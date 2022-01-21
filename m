Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5824496718
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 22:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiAUVH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 16:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiAUVH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 16:07:29 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C031AC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:28 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id k2-20020a17090a658200b001b399622095so6903159pjj.9
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lHkAYzvU+gvACQS+B203C+Z1CPAITSVUhZfrMamGfEo=;
        b=jove1Dlo2QubReInLUxgIeQ/h+XCFIwyjfeVH/sAiHFfQcnaNBWjvp04L+9wF4aYvk
         ywlkR8WB8cFCimPnR+RInvhydRZzjrxJQl19PcG6+sI4nXgR3ZL9ABBgNktQeLP5U6Aq
         spywCo1OM0l/RszjZJv/PlqilVMuUQILht/M4ogstlfUFZyJknOxLyIs6qXmf5TMJwYp
         6nsEkBs694qwZm7LZE6vz2KukdtGzKtMqcMBeb+aBabvaPV8gTezc6cH86yAmy6tWv7Z
         hilhR3wk8d0wI+gy5lZlwFfoJzW/oJxUUDBX7PB28i2Bk2STQJFNva4MyNTjso2kxFzH
         Y5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lHkAYzvU+gvACQS+B203C+Z1CPAITSVUhZfrMamGfEo=;
        b=O6h2lYj4rGUUMv7WSGydrk4xTgClhn8SgAZM9B2jTYkjHGpPDZ0JqEffhimbDntAMY
         2Pe9kj7nN/AVDonHvMHeFDcf5dnl+zcNPAt+IzlyTGn7b9Psm4g4q+Fc4YZmhKH2FMDN
         cjrnmtedQjj3QPJiAez5WqAWe8JqYf7NgvpFYnoe9ekXCO4LwGQk3H3xktDUMtQb1tvq
         +dIrMEzWeewohB1RG3mmuksJPRRhnEq4qfPGlQTrsvYdCf++detc2MjXSXcwF9cyjmqk
         oGsoLajM8h3s7ErU2nyyrMKI3CvxoasA2ZENWZSWFsyS4idlIT+99zao3DyoRLEaNukV
         20Tw==
X-Gm-Message-State: AOAM532svI0R2O80PbTixwfEA0093ifzkaP5GSfKUQLzTWk9REB3fn9F
        gfcY7H2divJ6AnbbBrWmKeeX9NaOLOOOJ6F/+gyWBrAvfzh+TVtMdd6NFUtDhDZ4an8/RsYiihe
        rBzw87Nj5NDWzqedBtsGghdXTXbreqFMzzbYp5STutGUXVjDnTIcK8/9b2grprMmEkQ==
X-Google-Smtp-Source: ABdhPJyynydLx+/jNzUkMHSE39PYK/BPI3DUeBLYcqaPzqRgIkJZi/0cx9p1/JzAj7IK4vQT7DC0XxbRn0XZsd4=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:90b:4f44:: with SMTP id
 pj4mr487485pjb.1.1642799247602; Fri, 21 Jan 2022 13:07:27 -0800 (PST)
Date:   Fri, 21 Jan 2022 21:07:01 +0000
In-Reply-To: <20220121210702.635477-1-daviddunn@google.com>
Message-Id: <20220121210702.635477-3-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121210702.635477-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v3 2/3] KVM: selftests: Allow creation of selftest VM without vcpus
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Break out portion of vm_create_with_vcpus so that selftests can modify
the VM prior to creating vcpus.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 48 ++++++++++++++-----
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 66775de26952..0454027d588d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -336,6 +336,9 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				    uint32_t num_percpu_pages, void *guest_code,
 				    uint32_t vcpuids[]);
 
+/* First phase of vm_create_with_vcpus, allows customization before vcpu add */
+struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
+
 /*
  * Adds a vCPU with reasonable defaults (e.g. a stack)
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8c53f96ab7fe..f44fd2210c66 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -362,6 +362,40 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	return vm;
 }
 
+/*
+ * VM Create without creating VCPUs
+ *
+ * Input Args:
+ *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
+ *   pages - pages of memory required for VM
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Pointer to opaque structure that describes the created VM.
+ *
+ * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
+ */
+struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
+{
+	struct kvm_vm *vm;
+
+#ifdef __x86_64__
+	/*
+	 * Permission needs to be requested before KVM_SET_CPUID2.
+	 */
+	vm_xsave_req_perm();
+#endif
+	vm = vm_create(mode, pages, O_RDWR);
+
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+#ifdef __x86_64__
+	vm_create_irqchip(vm);
+#endif
+	return vm;
+}
+
 /*
  * VM Create with customized parameters
  *
@@ -393,13 +427,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	struct kvm_vm *vm;
 	int i;
 
-#ifdef __x86_64__
-	/*
-	 * Permission needs to be requested before KVM_SET_CPUID2.
-	 */
-	vm_xsave_req_perm();
-#endif
-
 	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
 	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
 		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
@@ -419,13 +446,8 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
 	pages = vm_adjust_num_guest_pages(mode, pages);
-	vm = vm_create(mode, pages, O_RDWR);
 
-	kvm_vm_elf_load(vm, program_invocation_name);
-
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
+	vm = vm_create_without_vcpus(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
-- 
2.35.0.rc0.227.g00780c9af4-goog

