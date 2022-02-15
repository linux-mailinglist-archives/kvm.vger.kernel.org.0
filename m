Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ED74B6023
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 02:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiBOBt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 20:49:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiBOBt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 20:49:28 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAA0B0C6E
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:49:20 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i7-20020a626d07000000b004e07b61362bso9761391pfc.6
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xzoDSSbA/Oh693FmOYSmCVHVw6XaqoDwmTTizxvQuKY=;
        b=gFogC119QdTcru7OVz6dZpP9yDX6QfoK4Jz1/wFvkUWkmrSrH0wzhX9tf/i0OW9d8j
         Q2pEMee9VKalXZvYqIgtfRQ3oDDeRue8NkLUrN7saw3C+Y3ZFsJW1VzZcqcOukpXxClK
         3kM6mbP9qh0NFqk5mnL80xwaoklQzx1BGzYmXcvFHUoQYeMuJ0NKRpRH8KvwPUNPJikh
         jkjInpIpnYxaAqHh6rn+pv3Bj5x4QNpd5qk+9cT5zvyOC8Aw/YCpwen0CpSGBmliZFd1
         CjROSIfx17AZFJ/O+lASfn2foNGIgWVKGb1WG1iWRTapl7TNRcphqyPtJP4X8L2A+xJr
         yA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xzoDSSbA/Oh693FmOYSmCVHVw6XaqoDwmTTizxvQuKY=;
        b=VH4cosg5VV13gw76vPh0VyasCJIm3ZsKm2Xta5+OYXrNssDU2HvWtBEX6zYps/xw/1
         1KLhBPGLjTJzPVadQImrAwFBgqbNgBRpS4/tm43ZsIGJftbSgyrNHZmok5kAjC7XXIFs
         JfzEaPjJBa4MD/qIcuvZxiakdNZP98V9xGaFBEF2tdCZOXKbnTHcaL7HhdOHN49/atui
         gtkUZg9jWh/TDVA2KBo4tTpegYiEcsUXN4LhBmpWqLh8eiX/UI/5X+DABl1r0yRlW/Gu
         XFpo4jNXN17LAnNRDwZx+Ato5PTKpy+FnoF1JJ8mKO+lGLfbuWKWlBX6V8lZwB7EBbXg
         3U+A==
X-Gm-Message-State: AOAM5338gHFclsBHq+kq/pXCSgV1UWXHfY1NoJiB58tvXD4vcJg9bWga
        w+ay/8XrqMhuLas1+XSoU0sQjy4Ex27P1+I=
X-Google-Smtp-Source: ABdhPJwgTOKXtP8H4nCEuAXVjtMgDM/xBvf/qRrbqigne9VJFVyS9CaI1KZn+NNzcMIS1BA7FiZtvb6RAnOoMpM=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:90a:a50f:b0:1b8:e6ad:f63c with SMTP
 id a15-20020a17090aa50f00b001b8e6adf63cmr229335pjq.1.1644889759054; Mon, 14
 Feb 2022 17:49:19 -0800 (PST)
Date:   Tue, 15 Feb 2022 01:48:05 +0000
In-Reply-To: <20220215014806.4102669-1-daviddunn@google.com>
Message-Id: <20220215014806.4102669-3-daviddunn@google.com>
Mime-Version: 1.0
References: <20220215014806.4102669-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v7 2/3] KVM: selftests: Carve out helper to create "default"
 VM without vCPUs
From:   David Dunn <daviddunn@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, David Dunn <daviddunn@google.com>
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

Carve out portion of vm_create_default so that selftests can modify
a "default" VM prior to creating vcpus.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4ed6aa049a91..f987cf7c0d2e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -336,6 +336,9 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				    uint32_t num_percpu_pages, void *guest_code,
 				    uint32_t vcpuids[]);
 
+/* Create a default VM without any vcpus. */
+struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
+
 /*
  * Adds a vCPU with reasonable defaults (e.g. a stack)
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d8cf851ab119..5aea7734cfe3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -362,6 +362,34 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	return vm;
 }
 
+/*
+ * Default VM creation without creating VCPUs
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
@@ -412,13 +440,8 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
 	pages = vm_adjust_num_guest_pages(mode, pages);
-	vm = vm_create(mode, pages, O_RDWR);
-
-	kvm_vm_elf_load(vm, program_invocation_name);
 
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
+	vm = vm_create_without_vcpus(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
-- 
2.35.1.265.g69c8d7142f-goog

