Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424468BADB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbfHMNyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:54:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36633 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbfHMNxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so1533211wme.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a93Im5z5Ix69mZdWJn1THOVc/7bNAs6K4ApoypuzVhg=;
        b=qp4zX3AHckA2pNCJnWihZD3OrpMvsDW1/nlbd+5Q+ES9EUAxthKioxDhyjdB1xPGE/
         ymbDcc60stQCZ98AU2gC1Uo1DBKWHLuMhioHBMaXXaJrjg1j863pjAUcvLcnSDunqNHq
         s1KznBVKPD1D5Cpb951XB7iHAe6SDDOdH1DV68vrsbtrw8ujtc0swIV3lcm8pLNnWhJC
         IY/OIl+lCw+OWNrclHSxGPpPEuEkFNtZ7WeicO5pFWWLXcrxIUwr4GX0QxdFpSN30Lhb
         kYEeqCKGHW0DOWpjR+0XKNYbolVJIwk9M/fFy4Igbc+FwMB3zJp6ahmdBg7oYAp2nPT0
         mIGw==
X-Gm-Message-State: APjAAAWbhFjDRFS7yBlgxL+nlnvS7OQCVAxRCPMOpE/y46o+UIUOwDbx
        mSO/kq4a4Ukk1yaI5ca6zXs7+859u4M=
X-Google-Smtp-Source: APXvYqzbCVFOFWFv973LiK5d08gyFUsBp6auwzFvMEOcVNiaUMCzfnLmLrxEuIGJ1KFK99mE/WaGNg==
X-Received: by 2002:a05:600c:144:: with SMTP id w4mr3477047wmm.94.1565704424653;
        Tue, 13 Aug 2019 06:53:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 5/7] x86: KVM: svm: remove hardcoded instruction length from intercepts
Date:   Tue, 13 Aug 2019 15:53:33 +0200
Message-Id: <20190813135335.25197-6-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
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
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
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

