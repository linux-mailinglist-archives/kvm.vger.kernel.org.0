Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAE74AF882
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiBIR3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiBIR3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:29:53 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B564C05CB86
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:29:56 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ay10-20020a17090b030a00b001b8a4029ba0so4236314pjb.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cE6nPhqUrdzaQ7066nYi569JLAMVfUJ5DNprAL1or7c=;
        b=LxvqmeRyjdn9uhoRdunTjzoeDd/+jD2yoE3Dg67uRUJpy7WeRNSJDVFpf7YTQOP37U
         loLFD2syK4/T4k9JHDAoRDWwcR9LQiXCLMFTWTL9excgLqYO9m6MaaGE7HrrBGWUL6iS
         1NkWjojK3KySrNFfg4FzdkmZpA1Vl/xRLjABoY+tr9q09+w9p3tvZRU4wR618XSnhdUy
         59NCIf72SAJxgQaBTG2ubyT0aWoUzp5sZYU4KAQ1MPyQALU8pyQY3y6TEYxiWBiEjby3
         bl+mZbA0+0tb3KR085MEAngB+VqocUVFFEsMt0bPjUFKrhJGG0SxgprUZymrC4ekCQ9i
         MXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cE6nPhqUrdzaQ7066nYi569JLAMVfUJ5DNprAL1or7c=;
        b=mXQZJpqHzGmQV99fa61in8CBXJTW8vIpwuz5OkqBJ6aFp4tP/vJPXXaU59wGpgJdDU
         HvsBGfeY7qazP9ZwIQTYmO2H7qjjmyfmBgL7nc5tVvL27WCy7M5PfhkkKhXo9UTRNf3s
         rwJMMm/+kQYVbu8DIUR86lhuWZOZnLUMwk3zO6gLucRzxHLvfJ/rHlayubKh1iErT0SN
         N/za4NMdQagcu7BETn3iIyPztelExYab4twSe/Afb4fb2Af8CrGI7QKwEvdE10glUbgr
         tUeaM18BEGbJCx56BI2NYo+YsDz9jZF1KTeSwnPDAjruZPDHw0aD8cfzQXaQn2cm8CVQ
         JQyw==
X-Gm-Message-State: AOAM533Z0ZIpFNqoB6QwF0lkxlmqLNvnGuKoxpmCewDFyQP11a0EK+cv
        mr/COhkrxSdE6vOE5XbUVLNlSA30mwZQGNk=
X-Google-Smtp-Source: ABdhPJwXFc+eXwLS6S6SnOulElBTcAYiQHfaYFn8YwxFX2r/7x8cPSYtYX4P/0hs5Y6CcefBngtzprC+LlgEcsg=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a05:6a00:1d9f:: with SMTP id
 z31mr3075554pfw.38.1644427795727; Wed, 09 Feb 2022 09:29:55 -0800 (PST)
Date:   Wed,  9 Feb 2022 17:29:44 +0000
In-Reply-To: <20220209172945.1495014-1-daviddunn@google.com>
Message-Id: <20220209172945.1495014-3-daviddunn@google.com>
Mime-Version: 1.0
References: <20220209172945.1495014-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v6 2/3] KVM: selftests: Allow creation of selftest VM without vcpus
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

Break out portion of vm_create_with_vcpus so that selftests can modify
the VM prior to creating vcpus.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4ed6aa049a91..2bdf96f520aa 100644
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
index d8cf851ab119..52f1f530564e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -362,6 +362,34 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
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
2.35.0.263.gb82422642f-goog

