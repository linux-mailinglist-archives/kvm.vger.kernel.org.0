Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A877B417EEA
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbhIYA6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346610AbhIYA5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 20:57:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FBAC061613
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:49 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b5-20020a251b05000000b005b575f23711so5827114ybb.4
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ah8BjXPWllLk7CuVOQDBnnkjluI1bAcWQEy7hqnXFdI=;
        b=LH0fEQWiB4eDpGtf5hQ32ngY9GD9n7/7byCfmfVAytc4CKzgNHw+3wzIXFXa/o5bjL
         2I8Eux8FnK1n3Iopqot3X1OQnjmh9TXn5kbxaAIGqSl+9CT/5AZsgzAsrWdmxrS6mlrW
         dx+aaDSPBdScsR191c0lwGAUmjnCNBA+1XrB67IkhS4U9E2OhMxPrheuqrJo04xzwB0N
         XAS0I23+EYToVad3pLc9+Altu8hz2KVdmKC0N6gwn8kCYuyHcyl1sb/GxSbWhO/S13/S
         czeNRHxyY1pa57ENB4tByagarGXZrQ657lOxch4brq39vjJlp224VHM9XKZnUh7GAMXk
         zEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ah8BjXPWllLk7CuVOQDBnnkjluI1bAcWQEy7hqnXFdI=;
        b=b6iAAuz32WxlP5u5wC5skS3NPt69XwyOqhkkyeiY6WJMu8JrFU+x85no7sxX5aUiGY
         E8GcpndlL8Aqwrw+hG+F6bRHK29C/14yVpkeTHYM6cg3VCEyqYM4KhWDaopEW3iYetj0
         h6J989eNYYTThzwW4Lh6C86Wh39gceBN8yhr3OnP5OtsDMOx5X0Pzzl3N8swkcbLkC+b
         lZQsSDLtQJNJWyg94mjiinssUbGRtsvfvzPymuxdUbef1Dn4FEcn9pE6gfEl8P9fPVMF
         10fDmEaxaijtUP/kE/ms+/KzAWl15EDqeBh5lhPaRmTizptMktdBxIjGDaW7lzF/aL+Q
         pwWA==
X-Gm-Message-State: AOAM533tvm4yuJfTsHV/zrsN6+TYEg4k1hbaBK6+2aoCw4qCLfSHY2K/
        aHH4zuc+yLfdpepJ/yhQyQOHgqtgm0g=
X-Google-Smtp-Source: ABdhPJxp5JGS1M0N56DHKiumu5prHduzDpf9Ztz1q5ePOF80kOqklxBqHGGBpfEM+YrqrhVUO4t7wkRniPM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:1d09:: with SMTP id d9mr16059645ybd.140.1632531348364;
 Fri, 24 Sep 2021 17:55:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:22 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 08/14] KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename a variety of HLT-related helpers to free up the function name
"kvm_vcpu_halt" for future use in generic KVM code, e.g. to differentiate
between "block" and "halt".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 13 +++++++------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4e8c21083bdb..cfebef10b89c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1679,7 +1679,7 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
 int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
 int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index eedcebf58004..f689e463b678 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3618,7 +3618,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
 		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
 			vmx->nested.nested_run_pending = 0;
-			return kvm_vcpu_halt(vcpu);
+			return kvm_emulate_halt_noskip(vcpu);
 		}
 		break;
 	case GUEST_ACTIVITY_WAIT_SIPI:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d118daed0530..858f5f1f1273 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4740,7 +4740,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 		if (kvm_emulate_instruction(vcpu, 0)) {
 			if (vcpu->arch.halt_request) {
 				vcpu->arch.halt_request = 0;
-				return kvm_vcpu_halt(vcpu);
+				return kvm_emulate_halt_noskip(vcpu);
 			}
 			return 1;
 		}
@@ -5414,7 +5414,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vcpu->arch.halt_request) {
 			vcpu->arch.halt_request = 0;
-			return kvm_vcpu_halt(vcpu);
+			return kvm_emulate_halt_noskip(vcpu);
 		}
 
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0c21d42f453..eade8a2bdccf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8643,7 +8643,7 @@ void kvm_arch_exit(void)
 #endif
 }
 
-static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
+static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
@@ -8655,11 +8655,11 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	}
 }
 
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
 {
-	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
+EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
@@ -8668,7 +8668,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
 	 * KVM_EXIT_DEBUG here.
 	 */
-	return kvm_vcpu_halt(vcpu) && ret;
+	return kvm_emulate_halt_noskip(vcpu) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
@@ -8676,7 +8676,8 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
 {
 	int ret = kvm_skip_emulated_instruction(vcpu);
 
-	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
+					KVM_EXIT_AP_RESET_HOLD) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
 
-- 
2.33.0.685.g46640cef36-goog

