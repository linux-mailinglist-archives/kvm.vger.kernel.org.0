Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1C034E8B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFDRQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:16:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35176 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFDRQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:16:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so891396wml.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IfRWVq9gwOTjXCzrcYbX/Nm26/S+KGE7mHqiVtU6dPQ=;
        b=OMeQs+fTHbgN3Q9J7LpWjndqGdqPuCP4mN6vf53V8I3seT+UsZHCtnKKJSUPnvj5e1
         y4nwLXRk4HEZIkUMbigF/5U4+QiOWDzdPfThTZ0rE5eOhV9ptwsfrd18/KvxUxfpUbQ9
         BovPCFK7p+VxDKI340A3fWDD9skE7TTeelwNimCRFRrhlDlz3sUi8/ExCzOLKEofMDBs
         rSG41Gk/dDmMni/E5TPxZvie2DJJiYm0EZeUVrM836O2G/zokyIttv2wbB4h2/7kOeL4
         oQ1iFtw6UdWJjAc5J91S8mwc94NXy3WPoMSf2tNvBxXAC47Kjx/HJvVWTWLy3LvuAwUI
         bI9A==
X-Gm-Message-State: APjAAAW4dwQ7kz2oT2hjLJMwjD67w2bBf1p2eHr5GTI+BspfThQfCJ+C
        lu+oQ7aBINTjyxM2OuMvYpBgmg==
X-Google-Smtp-Source: APXvYqx7YUoN1/kh4Ckzx0FHmk2IlquzUxVQtA8KaimBp/AvTemdNV9mjlOfXeZTzuyriv1K4Y+Rxw==
X-Received: by 2002:a1c:1bc9:: with SMTP id b192mr10642535wmb.152.1559668595503;
        Tue, 04 Jun 2019 10:16:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id b5sm7991369wru.69.2019.06.04.10.16.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:16:34 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] kvm: selftests: aarch64: use struct kvm_vcpu_init
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, thuth@redhat.com, peterx@redhat.com
References: <20190527143141.13883-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ab872d9d-acb2-09cf-3cd2-c5340bcc2387@redhat.com>
Date:   Tue, 4 Jun 2019 19:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527143141.13883-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 16:31, Andrew Jones wrote:
> aarch64 vcpu setup requires a vcpu init step that takes a kvm_vcpu_init
> struct. So far we've just hard coded that to be one that requests no
> features and always uses KVM_ARM_TARGET_GENERIC_V8 for the target. We
> should have used the preferred target from the beginning, so we do that
> now, and we also provide an API to unit tests to select a target of their
> choosing and/or cpu features.
> 
> Switching to the preferred target fixes running on platforms that don't
> like KVM_ARM_TARGET_GENERIC_V8. The new API will be made use of with
> some coming unit tests.

The following can replace patches 1 and 2 and simplify the API, so
that aarch64 and x86_64 are more similar:

---------------- 8< -------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/1] kvm: selftests: hide vcpu_setup in x86_64 code

This removes the processor-dependent arguments from vm_vcpu_add.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h            | 3 +--
 tools/testing/selftests/kvm/lib/aarch64/processor.c       | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c                | 9 +++------
 tools/testing/selftests/kvm/lib/kvm_util_internal.h       | 2 --
 tools/testing/selftests/kvm/lib/x86_64/processor.c        | 5 +++--
 tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 2 +-
 tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c | 2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c             | 2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c           | 2 +-
 9 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a5a4b28f14d8..55de43a7bd54 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -88,8 +88,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
-		 int gdt_memslot);
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 19e667911496..16cba9480ad6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -243,7 +243,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 					DEFAULT_ARM64_GUEST_STACK_VADDR_MIN, 0, 0);
 
-	vm_vcpu_add(vm, vcpuid, 0, 0);
+	vm_vcpu_add(vm, vcpuid);
 
 	set_reg(vm, vcpuid, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
 	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 633b22df46a4..6634adc4052d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -764,11 +764,10 @@ static int vcpu_mmap_sz(void)
  *
  * Return: None
  *
- * Creates and adds to the VM specified by vm and virtual CPU with
- * the ID given by vcpuid.
+ * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid.
+ * No additional VCPU setup is done.
  */
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
-		 int gdt_memslot)
+void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu;
 
@@ -802,8 +801,6 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
 		vm->vcpu_head->prev = vcpu;
 	vcpu->next = vm->vcpu_head;
 	vm->vcpu_head = vcpu;
-
-	vcpu_setup(vm, vcpuid, pgd_memslot, gdt_memslot);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 4595e42c6e29..6171c92561f4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -65,8 +65,6 @@ struct kvm_vm {
 };
 
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
-void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot,
-		int gdt_memslot);
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
 void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 21f3040d90cb..11f22c562380 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -610,7 +610,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
+static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
 {
 	struct kvm_sregs sregs;
 
@@ -656,7 +656,8 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 				     DEFAULT_GUEST_STACK_VADDR_MIN, 0, 0);
 
 	/* Create VCPU */
-	vm_vcpu_add(vm, vcpuid, 0, 0);
+	vm_vcpu_add(vm, vcpuid);
+	vcpu_setup(vm, vcpuid, 0, 0);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vm, vcpuid, &regs);
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index b38260e29775..dbf82658f2ef 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -144,7 +144,7 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID, 0, 0);
+		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
index 50e92996f918..e5d980547896 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
@@ -34,7 +34,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 		int vcpu_id = first_vcpu_id + i;
 
 		/* This asserts that the vCPU was created. */
-		vm_vcpu_add(vm, vcpu_id, 0, 0);
+		vm_vcpu_add(vm, vcpu_id);
 	}
 
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 4daf520bada1..8c063646f2a0 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -144,7 +144,7 @@ int main(int argc, char *argv[])
 		state = vcpu_save_state(vm, VCPU_ID);
 		kvm_vm_release(vm);
 		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID, 0, 0);
+		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 2a4121f4de01..13545df46d8b 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -177,7 +177,7 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID, 0, 0);
+		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
-- 
1.8.3.1

