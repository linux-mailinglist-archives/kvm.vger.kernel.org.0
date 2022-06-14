Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CAB54BB1B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349829AbiFNUHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242345AbiFNUHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7445A4D69C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u6-20020a63d346000000b00407d7652203so3528121pgi.18
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=V4zIbtKJ1hQubZ2Po5itG3J6U3n8PHWRADbXM/EgI5s=;
        b=ipu+l6K1KLZTBB0JOCBxUwcMdeHTImhhfbvpc3v15RMSRz9Cgt3mQV6vmIiXbh7uAW
         PlKOvblbjVUNHpEUa+ucuCqWM6b3DrBUvS1WkH/rpBPGmsSQk8knZn24x5udaJ8M8Mc/
         H5iK4fbagCGgntVT3iamNDONL8xoOkNX0yfOj7ow+nGfdqoiKXD6+Ml1mYHye9IZQAFS
         gsK1Y1c3Lc+Oc27TCOOBZA7krpgDk6IXrZSKgB6h+w+J8YPNwrZoOxLFl86ImWg1ddiD
         tDfeVH2svWqLZG4Pd19JsCRhEqKoopcdQijrPpPfwS67C4OuQWUF0yKHywPlkHHb8gtr
         y3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=V4zIbtKJ1hQubZ2Po5itG3J6U3n8PHWRADbXM/EgI5s=;
        b=WMWRnngaKUQhQ73nAn8Fo3TeioRBkbpU4wNWuRIaWzVR7rEv6FaHXKGOUEx6Jg+x/Z
         atGmDswgWuz/5eeD+LIZKymB99dROGP0mGmGs2yR/Zd7FjQIIOQzcTRyORnFu/IThBVW
         P0QQLS+BmoGwVQlCjwxK9J29JjKP2hhFVZMjpogIXboMaCbPpWN+MZDt6wX2y9Vgba/A
         PQnDIxY36sF2guzriPm/j7AIhBVn7VTpIrMtSGszR2phMQ2AGWtDzn9X04Pn1NpYyTdz
         fLFVHQhfgcyoXd57E0jfSCxaiMsKTBbpf9VPPwfA8hydHlXvngJ2cQQYhsy3UobRSqDO
         0tgg==
X-Gm-Message-State: AJIora/ygPbJ5tvRuYQTgl8yw7ywFd8HT3KypmD85Rhiw2XlNmvy8jlz
        j8tgw04RWrLPY3bumN/iEju2JsPcy+c=
X-Google-Smtp-Source: AGRyM1vvDnbvaeDW3hTiZGuNUlGtl4c59JAQ9AXo/b96fG7zMYPGTEJ671xWzoiuXkNgsej2288gqhlk7qc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3a8f:b0:1e8:7669:8a2f with SMTP id
 om15-20020a17090b3a8f00b001e876698a2fmr6214455pjb.55.1655237234951; Tue, 14
 Jun 2022 13:07:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:26 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 01/42] KVM: selftests: Set KVM's supported CPUID as vCPU's
 CPUID during recreate
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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
index cdaea2383543..1b9e8719c624 100644
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
index 39f2f5f1338f..38c6083c9ce1 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -392,11 +392,17 @@ void kvm_vm_restart(struct kvm_vm *vmp)
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
@@ -1813,7 +1819,7 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
 
-unsigned long __attribute__((weak)) vm_compute_max_gfn(struct kvm_vm *vm)
+unsigned long __weak vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
 }
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 4a7de11d6f37..c46a22f8a9af 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -663,6 +663,15 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
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
2.36.1.476.g0c4daa206d-goog

