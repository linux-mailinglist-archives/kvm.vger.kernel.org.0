Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A85E49575D
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 01:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378404AbiAUAaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 19:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378408AbiAUAaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 19:30:24 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A690C061748
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:24 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h9-20020a170902680900b0014adffcba60so1238487plk.7
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lHkAYzvU+gvACQS+B203C+Z1CPAITSVUhZfrMamGfEo=;
        b=erq9giT+nz2vof3ybLlfjog6bGmIW7l1hEFH/EpVmtcxFwp1vSjBfSF8KdD7Nj6qL2
         KBD28MC5m8SOiK4YheM3fE1zoa4O3CBtFlxortyM9Mssm/SAuQhrjaC+X7nVJonXHu8C
         vkQpwZKqLx78neOesCuzslqkIiFdN4TSsXFs8/f9n3kO80OWgco2vgaRUbHbErGjKB7B
         UR9mEoEUGwgMl3HwC7OXgWWHxxGfvWfIcDdHXLqBcni8hq+qZHMS/vm+A45E+WQk5iwZ
         K6pPklS2hWvah6gLxPGcDMMV8LtL1qhVuYO0yfZvaWH4V5aIpRU8oaNtYsLUVOX551Uh
         AYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lHkAYzvU+gvACQS+B203C+Z1CPAITSVUhZfrMamGfEo=;
        b=rY7Z1K6/jewCwTKihGePKUKP8rkaMX5+w5qRqJaf6DD2XIjFVuMOZzMfALV4igMXAt
         gauUEDHw6l+OI6VZEP5B9s3iu6mIN+iZsLnYIx84/LX1yzZ8t0O8AVl92NrqbDt87QMl
         cXe1DA6sZ0ykO3T/+PA5Ge+/SupEwfLz4d1iTUTKUR+jnUlAil5YscG2Fau+LMymem9R
         jBK6o9o18402v6Stwi75jipDPAayqI60Y8qIPdjSQiyEWVCgaqnYkg3bLL91PEanTQul
         Jfv8l7kvbvPQeZncg7SMm+zjDRpxWoAfZ0ypPvaa2jEPm3kTHByfkeyboqnEN8ESpc64
         gMzQ==
X-Gm-Message-State: AOAM530gedlSZt+JAsgIlzjGFcCbKH3uTGZdbLLLsupQl9vAkmx5noxX
        JPW4MzYFHCGY94Jln2lSKkAGH8szGC+NszRG3hizpiQF30jcKuzDwrT3NjavuBY8/9nCb2Zn54T
        lGi+xYJmq7ikuf5ZmapKc2iWWNH/Fm1MEWTzyRU/gT4QnIxn1NR2MQj6HR/IDTG9Rww==
X-Google-Smtp-Source: ABdhPJwcDJszuCRohcH0AQWDfbTMTmDn/EwZVT1DcoXbjS3PwV9sQQN/KR8bRWUhemH3q0EPBckDtP0jI3qz9ZI=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a05:6a00:b8e:b0:4c2:860c:1cea with SMTP
 id g14-20020a056a000b8e00b004c2860c1ceamr1489996pfj.22.1642725023490; Thu, 20
 Jan 2022 16:30:23 -0800 (PST)
Date:   Fri, 21 Jan 2022 00:29:51 +0000
In-Reply-To: <20220121002952.241015-1-daviddunn@google.com>
Message-Id: <20220121002952.241015-3-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121002952.241015-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 2/3] selftests: introduce function to create test VM
 without vcpus.
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
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

