Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2234967E3
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 23:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiAUW3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 17:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiAUW3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 17:29:45 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D2FC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:45 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p17-20020a170903249100b0014af06caa65so2185152plw.6
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lHkAYzvU+gvACQS+B203C+Z1CPAITSVUhZfrMamGfEo=;
        b=Ma1llP5LV0ECB7GJH7JmX9CaH80a751vNfoPNRODB0yYw6K2ZPP9zwQjf6g5+TX6gI
         H8W21MDLPimBOAjcuC38OogSzIMQCB4UBBtNTiwR/JY3q7MAa/Zzq+tKqOuv05dcnmqn
         I/H2F4wZwl9HrFbBVMDZGga4o//DK0jTR0zkuZy6ytb2b2T4Db0yqc5o/+iO7/pOlg2m
         exAeD5Jm52oSzTEJE9Q+WEpTgj8rBCEEKY97jhVnpeOg8LLyGylRC11e+4IB3qZ5CFtt
         191mkrhXxAN1lFtzAN4ZEKq1FqX3Nh/yRMcrN0HcAJ0iEYQjnfxyOZieP+6mBglo+VKX
         KaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lHkAYzvU+gvACQS+B203C+Z1CPAITSVUhZfrMamGfEo=;
        b=VZnCLv0zbwFpoO2p3aC6sTp/gzsleMlNSzwUbpcwcQSbZeGCamVsrEWEoay2jtfpps
         xX4HppEc+VT2JlcrL1/jqKogK8hsJAD1FofNfxmteCLDpIV97zFtTYXV3V65fgLObSjr
         Cp2TFy6E5Q1QyxfaFeuH7DBl5Y3Kpuqrbz600KNwj/VtU7HcVNewpsjK5z8RQEzTyArt
         vkw+QrFL0iTFqpZ1oXtfowF5Zn8txG6QrhBVGgGokr3jffUuku5WKB4ZwTJQysuebIBu
         qwl6zBDOdu8iZNwizzYATy8IFKtrP+ogq95jURHHJ5RU9YoljgAsD0U1cxMVOFNFWem8
         eQSQ==
X-Gm-Message-State: AOAM533GKg1D11joo36lmRR82JWFEY4Lti9W3uuaPJX6vr67TDSMPEha
        nU74V9NEso1giEjpXUD42VeyyRdueD8oeHSpGLwKgTJcNqa98YS2m8n+ZPKwG9E+PGwTOFl0if4
        o3XrYjEjTFtJnKhWN4nEuNmwMxsByg35RB/5huvcymSVv+8d4iEZIXZDXXu+XUMqCKQ==
X-Google-Smtp-Source: ABdhPJzu1Nq3fEP/asga4mSZXSdaqG5yvqtA3sv/LO75CSv8imkaoIjCDjfoXV7/0OfsSTSXTRBE/vs/txM+nGw=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:aa7:818b:0:b0:4c7:abe1:f94a with SMTP id
 g11-20020aa7818b000000b004c7abe1f94amr2457299pfi.66.1642804184708; Fri, 21
 Jan 2022 14:29:44 -0800 (PST)
Date:   Fri, 21 Jan 2022 22:29:32 +0000
In-Reply-To: <20220121222933.696067-1-daviddunn@google.com>
Message-Id: <20220121222933.696067-3-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121222933.696067-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v4 2/3] KVM: selftests: Allow creation of selftest VM without vcpus
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

