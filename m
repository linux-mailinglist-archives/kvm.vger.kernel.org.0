Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6654F86819
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404410AbfHHRbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:31:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38011 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404396AbfHHRbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:31:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so95716351wrr.5
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZQeP5pAAHF+4yJKvgmP/zEaBqLwWDCph05fC4t/i+o=;
        b=Kw7b2f1mPC4C9CHldAFuumSyExo9AHn0g3ctWfZaCpYDBlEBYbxiuwhsr1I7fsGv8Q
         NyfyYKe9gPU32CdlQaoLeubYFWUlrV1QglFdfbrRJzK/ibXclYsUccAm5z7TzTwSoCxV
         1g+w+ZE7YD4VujoN88bucpfdDiEc4CDBQY3xr3QmUtUiCt6vBTn3J5VzMe9irfpSe82B
         504PIAUja4pm+brEXu+HHjESQNc5smrz7Zn2H+pT5jIB0iES3cQhPnwShC0K21pPqjT5
         z2xS3mtrbLfpMycsQJ37Qqh3vbo7FzR34JO//VFEQwVYvpV5onJAKB2Fk13w+gNag0ZL
         y9ow==
X-Gm-Message-State: APjAAAU5Hqi/nasCGDF/Q1TB2YSr4X+G0Nzpvdc8w+Gd0jq0CfjS5iej
        ehPhPY0dE22qvvIAxAiN2zTTRAr9IyI=
X-Google-Smtp-Source: APXvYqyFnZIg3A/u0hiem3K5bxNdCTBfVUjt7Dotwuqdf7EzJLA1VGFiiWEgYQ9S03QxroPp1nNFGg==
X-Received: by 2002:adf:ea4c:: with SMTP id j12mr19211557wrn.75.1565285463510;
        Thu, 08 Aug 2019 10:31:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.31.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:31:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 5/7] x86: KVM: svm: remove hardcoded instruction length from intercepts
Date:   Thu,  8 Aug 2019 19:30:49 +0200
Message-Id: <20190808173051.6359-6-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808173051.6359-1-vkuznets@redhat.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Various intercepts hard-code the respective instruction lengths to optimize
skip_emulated_instruction(): when next_rip is pre-set we skip
kvm_emulate_instruction(vcpu, EMULTYPE_SKIP). The optimization is, however,
incorrect: different (redundant) prefixes could be used to enlarge the
instruction. We can't really avoid decoding.

svm->next_rip is not used when CPU supports 'nrips' (X86_FEATURE_NRIPS)
feature: next RIP is provided in VMCB. The feature is not really new
(Opteron G3s had it already) and the change should have zero affect.

Remove manual svm->next_rip setting with hard-coded instruction lengths.
The only case where we now use svm->next_rip is EXIT_IOIO: the instruction
length is provided to us by hardware.

Hardcoded RIP advancement remains in vmrun_interception(), this is going to
be taken care of separately.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 858feeac01a4..6d16d1898810 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2903,13 +2903,11 @@ static int nop_on_interception(struct vcpu_svm *svm)
 
 static int halt_interception(struct vcpu_svm *svm)
 {
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 1;
 	return kvm_emulate_halt(&svm->vcpu);
 }
 
 static int vmmcall_interception(struct vcpu_svm *svm)
 {
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	return kvm_emulate_hypercall(&svm->vcpu);
 }
 
@@ -3697,7 +3695,6 @@ static int vmload_interception(struct vcpu_svm *svm)
 
 	nested_vmcb = map.hva;
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
 	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
@@ -3724,7 +3721,6 @@ static int vmsave_interception(struct vcpu_svm *svm)
 
 	nested_vmcb = map.hva;
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
 	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
@@ -3775,7 +3771,6 @@ static int stgi_interception(struct vcpu_svm *svm)
 	if (vgif_enabled(svm))
 		clr_intercept(svm, INTERCEPT_STGI);
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
@@ -3791,7 +3786,6 @@ static int clgi_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
 	disable_gif(svm);
@@ -3816,7 +3810,6 @@ static int invlpga_interception(struct vcpu_svm *svm)
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
 	kvm_mmu_invlpg(vcpu, kvm_rax_read(&svm->vcpu));
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	return kvm_skip_emulated_instruction(&svm->vcpu);
 }
 
@@ -3839,7 +3832,6 @@ static int xsetbv_interception(struct vcpu_svm *svm)
 	u32 index = kvm_rcx_read(&svm->vcpu);
 
 	if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
-		svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 		return kvm_skip_emulated_instruction(&svm->vcpu);
 	}
 
@@ -3921,7 +3913,6 @@ static int task_switch_interception(struct vcpu_svm *svm)
 
 static int cpuid_interception(struct vcpu_svm *svm)
 {
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 	return kvm_emulate_cpuid(&svm->vcpu);
 }
 
@@ -4251,7 +4242,6 @@ static int rdmsr_interception(struct vcpu_svm *svm)
 
 		kvm_rax_write(&svm->vcpu, msr_info.data & 0xffffffff);
 		kvm_rdx_write(&svm->vcpu, msr_info.data >> 32);
-		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 		return kvm_skip_emulated_instruction(&svm->vcpu);
 	}
 }
@@ -4457,7 +4447,6 @@ static int wrmsr_interception(struct vcpu_svm *svm)
 		return 1;
 	} else {
 		trace_kvm_msr_write(ecx, data);
-		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 		return kvm_skip_emulated_instruction(&svm->vcpu);
 	}
 }
-- 
2.20.1

