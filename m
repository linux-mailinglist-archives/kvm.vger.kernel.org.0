Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761C053D44A
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349922AbiFDBVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349905AbiFDBVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B4056744
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so4105749plg.15
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Es6Hr0vsBiuO2l+ZC4ANogFQnImDp4bB4meXusroIVo=;
        b=njUGNgodrQvV516LxtQT86zB8HOXOboHg5ttENGNlletzErC96wkV0OoCyJDUmFu56
         r8m8ED1x0nxUDSRAnlgnTcGcu2CFEK7NUat7NVWIHihkio8UmBxEuAoRE91qmkFKaK+L
         MxoxRFyfQVhR2k4rsL0E77LtfIcHD5OvXjieAAdxEtws1/Q8gdC9aY9+GA/Jw61hgk7r
         ksCEwcqQvP1zV8vBx9WQW3x7CMw1la/BnDlWswD2yHwkeuZm8mZYaHjfGv8vhTMW577i
         16vipFFYeHL20PP64sg66a55Spq2aewvphUCqq0pF1yaZZ7YHcjshzTUAqWL7VeQ0rwh
         5sLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Es6Hr0vsBiuO2l+ZC4ANogFQnImDp4bB4meXusroIVo=;
        b=zhHqX3P1dcEzxsreiG+RO5S5wCZJTJkrBWQSx/HYbPYASJ+URnJfHGGfNgxwxxom4o
         5C5DYr1qQ9YB/siXYVMEM4jlqXY9k3NUTpiObFGheA1jr1ipieFGp58F0frv7iKqmC6K
         iQtS1nDoFndqeBTLN0S/H/1ijyj2matCSjBZSNfIsnkUOvgUnt75SwUcXGhMzZXuBzLN
         4iZYRecVsq/ATwrOBT1s6qscFAzpcg/z957Ceh0NT+BLh/wChZEVfMjZIHrQR9dsMyTS
         Tl2TaqiA6Hy8AfhrXNjh9j8RxFOSEsNDPkgv/ht9pxcs7WWhmZ1InOHHRkYbRDImFCgH
         TrmQ==
X-Gm-Message-State: AOAM530/Ki16mKDUu/FilREjI9crdHxTW0M942znc80UJbqvKii+3v3t
        fh/VNc2RM94i3CuYu8LLYDaI4bxt188=
X-Google-Smtp-Source: ABdhPJy8pHaHwIxvawFrAb/4mbIxTluL+iM5Cy9jUBF0/tRU63dRzjbqgzCyfU8C8+FtDJnjiBtqhVv6RtM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2410:b0:51b:c954:8e55 with SMTP id
 z16-20020a056a00241000b0051bc9548e55mr10588234pfh.22.1654305662360; Fri, 03
 Jun 2022 18:21:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:17 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 01/42] KVM: selftests: Set KVM's supported CPUID as vCPU's
 CPUID during recreate
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On x86-64, set KVM's supported CPUID as the vCPU's CPUID when recreating
a VM+vCPU to deduplicate code for state save/restore tests, and to
provide symmetry of sorts with respect to vm_create_with_one_vcpu().  The
extra KVM_SET_CPUID2 call is wasteful for Hyper-V, but ultimately is
nothing more than an expensive nop, and overriding the vCPU's CPUID with
the Hyper-V CPUID information is the only known scenario where a state
save/restore test wouldn't need/want the default CPUID.

Opportunistically use __weak for the default vm_compute_max_gfn(), it's
provided by tools' compiler.h.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h    |  9 +++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c             | 10 ++++++++--
 tools/testing/selftests/kvm/lib/x86_64/processor.c     |  9 +++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c          |  1 -
 tools/testing/selftests/kvm/x86_64/smm_test.c          |  1 -
 tools/testing/selftests/kvm/x86_64/state_test.c        |  1 -
 .../selftests/kvm/x86_64/vmx_preemption_timer_test.c   |  2 --
 7 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 0eaf0c9b7612..93661d26ac4e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -681,6 +681,15 @@ static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	return vm_arch_vcpu_add(vm, vcpu_id, guest_code);
 }
 
+/* Re-create a vCPU after restarting a VM, e.g. for state save/restore tests. */
+struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id);
+
+static inline struct kvm_vcpu *vm_vcpu_recreate(struct kvm_vm *vm,
+						uint32_t vcpu_id)
+{
+	return vm_arch_vcpu_recreate(vm, vcpu_id);
+}
+
 void virt_arch_pgd_alloc(struct kvm_vm *vm);
 
 static inline void virt_pgd_alloc(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f0300767df16..d73d9eba2585 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -391,11 +391,17 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 	}
 }
 
+__weak struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm,
+					      uint32_t vcpu_id)
+{
+	return __vm_vcpu_add(vm, vcpu_id);
+}
+
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 {
 	kvm_vm_restart(vm);
 
-	return __vm_vcpu_add(vm, 0);
+	return vm_vcpu_recreate(vm, 0);
 }
 
 /*
@@ -1812,7 +1818,7 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
 
-unsigned long __attribute__((weak)) vm_compute_max_gfn(struct kvm_vm *vm)
+unsigned long __weak vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
 }
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a871723f7ee1..ea246a87c446 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -664,6 +664,15 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	return vcpu;
 }
 
+struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id)
+{
+	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
+
+	vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
+
+	return vcpu;
+}
+
 /*
  * Allocate an instance of struct kvm_cpuid2
  *
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index dab4ca16a2df..95f59653dbce 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -425,7 +425,6 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
-		vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
 		vcpu_load_state(vcpu, state);
 		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 3cd1da388b52..e89139ce68dd 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -205,7 +205,6 @@ int main(int argc, char *argv[])
 		kvm_vm_release(vm);
 
 		vcpu = vm_recreate_with_one_vcpu(vm);
-		vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
 		vcpu_load_state(vcpu, state);
 		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 0bcd78cf7c79..ea878c963065 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -214,7 +214,6 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
-		vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
 		vcpu_load_state(vcpu, state);
 		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index 99e57b0cc2c9..771b54b227d5 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -237,8 +237,6 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
-
-		vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
 		vcpu_load_state(vcpu, state);
 		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
-- 
2.36.1.255.ge46751e96f-goog

