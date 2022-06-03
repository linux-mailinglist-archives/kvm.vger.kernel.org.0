Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85C053C1C3
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbiFCAof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239940AbiFCAoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA1344D9
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v3-20020a1709028d8300b00163fc70a4dbso3462925plo.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=36XEOpYEohNCR+Q01vTzoi5csXjLmHgWiPTQjP0f6so=;
        b=DPkxiw2UxFi8eI9M47WQApqgocwHJV3aKzzdUq70auJn5gJ2hNpfwD46/NLb0EpB++
         lRbsjiWihAy9Iw+Ij5xFss7Zpy6qqf5HuIdHL4jg6YE6ipxBRe5iCKK0DmniMFY7a+6i
         eNGT2D7WbjM98RplHYgTuPU93X1F5K02mJojLc4hmWULxIpMGollFkG90litawmtIU9U
         iC0+YN60QmQap5LyZSmjItpYZFJJ9oIAfLqQw/bvhf0ppZW/GOxls5xS8wMTcq361Khf
         LAFBw4FqIEmHmOgXjWli9hbXdLOhSEM+6RMdduLnIyId6p1Ut2rURktkTNyPAabWM1Vi
         Xw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=36XEOpYEohNCR+Q01vTzoi5csXjLmHgWiPTQjP0f6so=;
        b=IaGO/PCZhfU+sy/YJ0pACtrZXXtx3QmacHbwe1TOwrWrZ367xvOxw3Y9MHU/z+YpXx
         51nlZdGAQMsVF1ZyL+XOyUhDOcWFWwgJS1B5hQIp3psBuPJ9HdmGwcHkywlufDtCRYeJ
         9RTcg6+BkDMX2Q6XWRcciwWJrutqQwg1VIho+b0zmAnkuPXNIN7qD5abz8oB9WlQIC7a
         K5pIuTY7Q8XeYj2LvkzZF4IfnEEnEiXJh+7BaowVbXwlABhkjp5lf7tXJ/k8tcwF2hKM
         +Bdd7Djmbqhh9ABzN+U9d16NvjsAvjf+X2NXKUrNzjFHq3hwT5h1LCUxBjRgpWuZdvdW
         JREA==
X-Gm-Message-State: AOAM531zfGJAAxxCBR8M+CxkdiO1UCBEFfhhID4GMCKAwXcXQvNFRx42
        H0xY7Ny8enXZGybOm5/qHWn2tgHzwe4=
X-Google-Smtp-Source: ABdhPJzdGSeC0T86+jtLCBMRqiGhNV3/FHNY2wGn3K9xEccz0doOK8gB6KaZW9JbCCwx6YGNr20uXQ0Oukg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a2:b0:505:974f:9fd6 with SMTP id
 u34-20020a056a0009a200b00505974f9fd6mr7734316pfg.12.1654217043072; Thu, 02
 Jun 2022 17:44:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:22 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 015/144] KVM: selftests: Make vm_ioctl() a wrapper to
 pretty print ioctl name
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

Make vm_ioctl() a macro wrapper and print the _name_ of the ioctl on
failure instead of the number.

Deliberately do not use __stringify(), as that will expand the ioctl all
the way down to its numerical sequence.  Again the intent is to print the
name of the macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 38 ++++++++++---------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 28 ++++----------
 2 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c2dfc4341b31..39e1971e5d65 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -105,6 +105,27 @@ int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
 int vm_check_cap(struct kvm_vm *vm, long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
+
+#define __KVM_SYSCALL_ERROR(_name, _ret) \
+	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
+
+#define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
+#define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
+
+int __kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
+void kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
+
+int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
+void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg);
+#define vm_ioctl(vm, cmd, arg) _vm_ioctl(vm, cmd, #cmd, arg)
+
+int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
+		 void *arg);
+void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
+		 const char *name, void *arg);
+#define vcpu_ioctl(vm, vcpuid, cmd, arg) \
+	_vcpu_ioctl(vm, vcpuid, cmd, #cmd, arg)
+
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
@@ -156,23 +177,6 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 	uint32_t flags);
 
-#define __KVM_SYSCALL_ERROR(_name, _ret) \
-	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
-
-#define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
-#define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
-
-void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
-		 const char *name, void *arg);
-int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
-		 void *arg);
-#define vcpu_ioctl(vm, vcpuid, ioctl, arg) \
-	_vcpu_ioctl(vm, vcpuid, ioctl, #ioctl, arg)
-
-void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
-int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
-void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
-int __kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 940decfaa633..7eedd9ff20fa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1690,32 +1690,18 @@ void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
 	return vcpu->dirty_gfns;
 }
 
-/*
- * VM Ioctl
- *
- * Input Args:
- *   vm - Virtual Machine
- *   cmd - Ioctl number
- *   arg - Argument to pass to the ioctl
- *
- * Return: None
- *
- * Issues an arbitrary ioctl on a VM fd.
- */
-void vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
-{
-	int ret;
-
-	ret = __vm_ioctl(vm, cmd, arg);
-	TEST_ASSERT(ret == 0, "vm ioctl %lu failed, rc: %i errno: %i (%s)",
-		cmd, ret, errno, strerror(errno));
-}
-
 int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 {
 	return ioctl(vm->fd, cmd, arg);
 }
 
+void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg)
+{
+	int ret = __vm_ioctl(vm, cmd, arg);
+
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
+}
+
 /*
  * KVM system ioctl
  *
-- 
2.36.1.255.ge46751e96f-goog

