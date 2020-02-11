Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0D41597A8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 19:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgBKSEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 13:04:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39891 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgBKSEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 13:04:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so13596092wrt.6;
        Tue, 11 Feb 2020 10:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=q8IlFsAzW42BdHawcbUm+vPgezsGHOH9GeI0fUJDSVM=;
        b=I87ccuceFBGwZWz6MWVVHLS9yZqJ4oxZ8rVMt3h/dieBPIXmTksaUGIK9emDsbPJ72
         72KObeNgooFPdyUFIkNE9tfG9YCQT6DX97igWnoTk5XILeoDrV7XmBmNHZ6wxbM8Pmtd
         ZWogo0fjRb3v4pOrlrDwa/TkzDxv79WtPnZGLikTvYVSmqKOdPgekvANTruoPe8hQVKg
         Q8ke+MOLP8bEfh1RqNNqqj250UkVxF57F9Nw8ItyeGJqfXF0ht/pwYs3rJ8NaEpULXf7
         4shrJgs+Hi1V6e1ec38bHvO7j+2I/5AcC3i48ib6FRo+YneO8Psd2BR1w1z+iHS0GGNP
         T6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=q8IlFsAzW42BdHawcbUm+vPgezsGHOH9GeI0fUJDSVM=;
        b=ZTFCevzZLRLYONXoarrtdgaFG+qMN6VxIt7PBilJy3UOKW4tQCEpUL/7qA60CNe6pZ
         mlTrYp5fDU4FyCUbjlXe4dx/yxsIIir7pasBqevJ2eKBVnnbAVBqNRGg39+js6lyKmaS
         F0C2zVr0VIewR5aJhL9TkWtLVc/dbaDKHiMijGJApR2YExzJR35wbme5EcXz/U6DqVBr
         jtvzrlF7+1OdwN0FoqTF/2SW87vAPbIsjdADPKnaqgBsUMBoN/AYxZRrc4juSGKicgV5
         aWmCWd325/f21woo4fVZcNTy1IrWJQG78tRXhaWFbqHXUk4HJ9b921IJkOMk+DvlaTMZ
         gRgA==
X-Gm-Message-State: APjAAAUGacB7d3EcZO27bNCwchIJjs35NH0FEfcZP+BFXRWwziORzaiB
        ScbXnaveeogU/BA+bbAusiXB+BlX
X-Google-Smtp-Source: APXvYqyhLYqPjSzy0F1s0h9EYZQPJT9P7yUxxdFIy+Dr2hO87FpztILGHBFxMSyYce9J9y6V8rVzgQ==
X-Received: by 2002:adf:e8c9:: with SMTP id k9mr9870271wrn.168.1581444281212;
        Tue, 11 Feb 2020 10:04:41 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h128sm168982wmh.33.2020.02.11.10.04.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 10:04:40 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: do not reset microcode version on INIT or RESET
Date:   Tue, 11 Feb 2020 19:04:39 +0100
Message-Id: <1581444279-10033-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The microcode version should be set just once, since it is essentially
a CPU feature; so do it on vCPU creation rather than reset.

Userspace can tie the fix to the availability of MSR_IA32_UCODE_REV in
the list of emulated MSRs.

Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c     | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a7e63b613837..280f6d024e84 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2185,7 +2185,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	u32 dummy;
 	u32 eax = 1;
 
-	vcpu->arch.microcode_version = 0x01000065;
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
@@ -2276,6 +2275,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	init_vmcb(svm);
 
 	svm_init_osvw(vcpu);
+	vcpu->arch.microcode_version = 0x01000065;
 
 	return 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..d625b4b0e7b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4238,7 +4238,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
-	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
@@ -6763,6 +6762,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = -1ull;
 
+	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
 
 	/*
-- 
1.8.3.1

