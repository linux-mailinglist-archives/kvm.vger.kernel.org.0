Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2704A3D66D1
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhGZSBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhGZSBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 14:01:17 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1214AC061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 11:41:46 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id g14-20020a17090a4b0eb029017395ea5199so1101891pjh.6
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 11:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8yNu6qbpILTbh+UzH48Yh1lHlgrQw9nlbePevAAANOg=;
        b=BQ6cipGmLFFAawNsq6cd/QslSsDWcxh/L0hhNO4UuL0lYHSTgbshPfw5nzgolWJ3Ag
         7TmKWWgq4/Y4Y8Yh2fkaUu4KgXAXMKgqRMy0zY/0CYYgUqGbJ3xzq75uFIDwfDGoo2tT
         OxHxH2NbA/BUbQoB7IHbrm8wacMpD9VBnjoeka6zPF7POsIGOaRnRPZckDy1Queg45jM
         YSQTjMrBia2dBUpUINRjDtfMtAmwyEFcgWPmHhQJM2zqyvRVWTlXIs/HQuhHFgfE9z3R
         izOUEKZ3NbCjEe6RSqJ9Au1l90EQiFftdccyc/Fx+4FsMKIJQlJGa3fXfxVSVpQKzPjT
         380w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8yNu6qbpILTbh+UzH48Yh1lHlgrQw9nlbePevAAANOg=;
        b=k4v+DPaLiEiPNyDHcXG0y4l2OMWfEtFIfAAVk2sVDgtsHCVmYMx58zxVYPxYSLU+qp
         rNYBeNGDwhZm2loQk4BkY1+A4B5Zt/j4aXdSGZvx8TMmCRZOPkcz0uNrxPjdxzE0GaEw
         FK09AKFxVDKUMZl87wnn8SC/iJfx4FEmexvPqw1u1Tp5GX2RPIKIVwlv4cSR4BuPo1Fx
         6mHFN7hRMxXQxM4rWNBfQE9gqAaP8QM+nfjcZEg4TSCuoEoD2v6Ckszs4bVoNSNwkxSU
         t/97QJf9JRaH6WBav2ZDxJ78gRL9ST8XCHgWGgiFGdIoaMU4Czy3VZvLDs5kEQBQ5YJn
         ozbw==
X-Gm-Message-State: AOAM533GFiabOaAsNb960K6eS/nhoi3qn1Zklt9Q2c9vivregXDYIleW
        7la4aWEFxpqDqt2FOOSGFd1jNINXyiNw4BUt
X-Google-Smtp-Source: ABdhPJyaBOAU4+6aPwZeRlAPbdxdr7qCKLg3yTiDRI5/sBA671QngyaXBDjyzuLGuSpSspJt+iZgMBn/nDpy8nzq
X-Received: from nehir.kir.corp.google.com ([2620:15c:29:204:e222:115f:790c:cd0f])
 (user=erdemaktas job=sendgmr) by 2002:a05:6a00:b46:b029:334:54db:af17 with
 SMTP id p6-20020a056a000b46b029033454dbaf17mr19321862pfo.26.1627324905486;
 Mon, 26 Jul 2021 11:41:45 -0700 (PDT)
Date:   Mon, 26 Jul 2021 11:37:54 -0700
In-Reply-To: <20210726183816.1343022-1-erdemaktas@google.com>
Message-Id: <20210726183816.1343022-2-erdemaktas@google.com>
Mime-Version: 1.0
References: <20210726183816.1343022-1-erdemaktas@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [RFC PATCH 1/4] KVM: selftests: Add support for creating non-default
 type VMs
From:   Erdem Aktas <erdemaktas@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Sagi Shahar <sagis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Like Xu <like.xu@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently vm_create function only creates KVM_X86_LEGACY_VM type VMs.
Changing the vm_create function to accept type parameter to create
new VM types.

Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Sagi Shahar <sagis@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d53bfadd2..c63df42d6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -88,6 +88,7 @@ int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm, int type);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e5fbf16f7..70caa3882 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -180,13 +180,36 @@ _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params)
  * Return:
  *   Pointer to opaque structure that describes the created VM.
  *
- * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
+ * Wrapper VM Create function to create a VM with default type (0).
+ */
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
+{
+	return __vm_create(mode, phy_pages, perm, 0);
+}
+
+/*
+ * VM Create with a custom type
+ *
+ * Input Args:
+ *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
+ *   phy_pages - Physical memory pages
+ *   perm - permission
+ *   type - VM type
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Pointer to opaque structure that describes the created VM.
+ *
+ * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K) and the
+ * type specified in type (e.g. KVM_X86_LEGACY_VM, KVM_X86_TDX_VM ...).
  * When phy_pages is non-zero, a memory region of phy_pages physical pages
  * is created and mapped starting at guest physical address 0.  The file
  * descriptor to control the created VM is created with the permissions
  * given by perm (e.g. O_RDWR).
  */
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
+			    int perm, int type)
 {
 	struct kvm_vm *vm;
 
@@ -200,7 +223,7 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	INIT_LIST_HEAD(&vm->userspace_mem_regions);
 
 	vm->mode = mode;
-	vm->type = 0;
+	vm->type = type;
 
 	vm->pa_bits = vm_guest_mode_params[mode].pa_bits;
 	vm->va_bits = vm_guest_mode_params[mode].va_bits;
-- 
2.32.0.432.gabb21c7263-goog

