Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5944812
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404575AbfFMRED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45829 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393371AbfFMREC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so21543741wre.12;
        Thu, 13 Jun 2019 10:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LrsdwY5oeKnCEzpxEpH2pMSwNmXiuq/c8to0EOSJdAw=;
        b=i4YhAVe8Qi4Qs5oPDdcySnM088oH4WdO9dqUWtrO637Uq3eQmNM6oGgjpRP4j9bIP0
         oV/LtUO+3iikkJYJ9EW+vUM1SjUgobPybdK41hzOe4/SYzpZcfxm+/74gQ6tcW9ymyxT
         1K7DgAb13dc2lpGxMVVgy48EOwsWp7r/6dRiuMRH731ODirFOGcgdVeX8ZMceVDxPx+3
         uYKAtGTi/s2yb3A86EZlroJVDh+wLzvSD2OxResnp3S1p9gOfEMDCoeAI7nR4GRk2lMe
         jGfw41cKKDn4jowhjZpLMKMlDRNVyuSzhAF25K6VmEMgTKpbHNg6VPUJP0OW4HqWQXeY
         IXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=LrsdwY5oeKnCEzpxEpH2pMSwNmXiuq/c8to0EOSJdAw=;
        b=gQRlREIE83J+3BzFDVze52Xqtz1qsD7nhKxkDCHvWO417ZEND0YkRU06ErxsNU3v4T
         Xylc4NP5O/XhaZaPLnaMkC4ufBysu0fyF2v+S9ahTbYX2cD259yeva6tvhlaEy3XNrPB
         xZWrqFdX0aHX2Vy7T3XltZYIp7VO6km8P6y3fsLmNfuoKm3D4gAm+8MLNwwuwaWTKC6E
         4eD5ml0aRBMVAmb9dI1Fs/yG7/LDpBaS0iLBTXgBxfBKtW6YGMDfYKPw2nZBOQ+3mUJp
         RfpH/u0EpM2cl3B624SgcyFf+q2ELgwI1KoYfzMwFHzW/xJGvrwjBvN0/7wx0Bf7+5ho
         i/bA==
X-Gm-Message-State: APjAAAXDsP+Cpg1T978J2Mr6wnsyjGQsUb1tTYrYypn3Anmw2txAF9m6
        cqGL500XVnEnCVVKsf5W1uSRwk47
X-Google-Smtp-Source: APXvYqxARXtkNdCcBtlyjbs1jKCmTWAlnWJ47Uqs+Trbh1paf715xSsyrQ2yWJoykr9/GSbnSzkgng==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr9222858wrx.82.1560445440327;
        Thu, 13 Jun 2019 10:04:00 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:59 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 27/43] KVM: nVMX: Update vmcs12 for MSR_IA32_DEBUGCTLMSR when it's written
Date:   Thu, 13 Jun 2019 19:03:13 +0200
Message-Id: <1560445409-17363-28-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM unconditionally intercepts WRMSR to MSR_IA32_DEBUGCTLMSR.  In the
unlikely event that L1 allows L2 to write L1's MSR_IA32_DEBUGCTLMSR, but
but saves L2's value on VM-Exit, update vmcs12 during L2's WRMSR so as
to eliminate the need to VMREAD the value from vmcs02 on nested VM-Exit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +---
 arch/x86/kvm/vmx/vmx.c    | 8 ++++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 68c031e2cc4d..138f27597c91 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3563,10 +3563,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		(vmcs12->vm_entry_controls & ~VM_ENTRY_IA32E_MODE) |
 		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
 
-	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS) {
+	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
 		kvm_get_dr(vcpu, 7, (unsigned long *)&vmcs12->guest_dr7);
-		vmcs12->guest_ia32_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
-	}
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ede2ac670f5b..975b2705c5b2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1845,6 +1845,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			get_vmcs12(vcpu)->guest_sysenter_esp = data;
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
+	case MSR_IA32_DEBUGCTLMSR:
+		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
+						VM_EXIT_SAVE_DEBUG_CONTROLS)
+			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
+
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		break;
+
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-- 
1.8.3.1


