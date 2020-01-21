Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E07143E88
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgAUNsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:48:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37479 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgAUNsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 08:48:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so3089191wmf.2;
        Tue, 21 Jan 2020 05:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=WQU1L9qQCnv53A9YDExCWzfCFNaPEWQjRccNAKJ2zmI=;
        b=Txu8TGOyS8OPQNLR6tXwLOgwDR+Im7w00WRyDlz8xB5OxBEXnRxDZkhIw3P0Lqn+M3
         8B6+FHDUWxR9LDV7VJP/20pNXCjNFF0iUnkZO+AZMf9K8LIqxfWyiGS+EPMmhOeRUGQy
         A8VTluZhGcWSQ7KWXcugoryJHxxhcpdH0A7f2pvxcXcNCUayWV3jIqVgSUehmELl/WPn
         7pmX8ZpuNPbweNeSn8BuxTda2wwbtVHHIXiR268Yk2p1RkISghkIkusAEYxtLc9Kgo3D
         hue85W7U0xK6dH2CCOwcKjlc5ii8NxGRiS5eLcrnNIxLFAHcLbRm3B0cf3SlmJMF24K8
         qA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=WQU1L9qQCnv53A9YDExCWzfCFNaPEWQjRccNAKJ2zmI=;
        b=aYL96jh4cCaKuSJ1PAg822xccpCTimwg1pGln3iOLoE7CZsCJcPK4Oi9P+h+wHiWOg
         mjwOs8NICYbneJYIXGhMht5O+10E1FICvaq7fJQolsnu7BZn5SxPxZjb819Ux7S+u5gl
         64dPw6aG6+GtFrAj2SvGS53epcjVvIr82lUzk8Je+a5prOPYgLIGJHaJv8z1qyxhiJOA
         /1rNvwcrx/7J1CD7hK01bzeeXMLrs/HGjVqpUtrpKArtr3KD7ruKL1+BSa9C0eYNu6xY
         BsSy05qcww/o09ZSsXSLVxHhkIdvWP9BwaPRRQKlL8pu1IZt3sOh0/vQtcKeCRjBmSkA
         AHAA==
X-Gm-Message-State: APjAAAV8brlJhucaG2jafeofuMEGrp84aEWyrUZUbl6mY4/StZuQrQum
        bb057Bfpf1TL9FeiAlW6iZCYEU5N
X-Google-Smtp-Source: APXvYqxNNxkdhYczKoAl5tWzFetoCTLwgnvio8xmm0blTvhT9l2deTBSP+qiBDrtoX426Ku9nPC86Q==
X-Received: by 2002:a1c:1d02:: with SMTP id d2mr4630528wmd.185.1579614490829;
        Tue, 21 Jan 2020 05:48:10 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b17sm51975006wrp.49.2020.01.21.05.48.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 05:48:10 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@redhat.com>
Subject: [PATCH] KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL
Date:   Tue, 21 Jan 2020 14:48:07 +0100
Message-Id: <1579614487-44583-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the guest is configured to have SPEC_CTRL but the host does not
(which is a nonsensical configuration but these are not explicitly
forbidden) then a host-initiated MSR write can write vmx->spec_ctrl
(respectively svm->spec_ctrl) and trigger a #GP when KVM tries to
restore the host value of the MSR.  Add a more comprehensive check
for valid bits of SPEC_CTRL, covering host CPUID flags and,
since we are at it and it is more correct that way, guest CPUID
flags too.

For AMD, remove the unnecessary is_guest_mode check around setting
the MSR interception bitmap, so that the code looks the same as
for Intel.

Cc: Jim Mattson <jmattson@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c     |  9 +++------
 arch/x86/kvm/vmx/vmx.c |  7 +++----
 arch/x86/kvm/x86.c     | 22 ++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  1 +
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b7c5369c7998..235a7e51de96 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4324,12 +4324,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
 
-		/* The STIBP bit doesn't fault even if it's not advertised */
-		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
+		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
 			return 1;
 
 		svm->spec_ctrl = data;
-
 		if (!data)
 			break;
 
@@ -4353,13 +4351,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-
+		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
+			return 1;
 		if (!data)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		if (is_guest_mode(vcpu))
-			break;
 		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bdbf27e92851..112d2314231d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1998,12 +1998,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
 			return 1;
 
-		/* The STIBP bit doesn't fault even if it's not advertised */
-		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
+		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
 			return 1;
 
 		vmx->spec_ctrl = data;
-
 		if (!data)
 			break;
 
@@ -2037,7 +2035,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-
+		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+			return 1;
 		if (!data)
 			break;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f24f5d16854..141fb129c6bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10389,6 +10389,28 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+bool kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+{
+	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
+
+	/* The STIBP bit doesn't fault even if it's not advertised */
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
+		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
+	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
+		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		bits &= ~SPEC_CTRL_SSBD;
+	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
+	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		bits &= ~SPEC_CTRL_SSBD;
+
+	return bits;
+}
+EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ab715cee3653..bc38ac695776 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -367,5 +367,6 @@ static inline bool kvm_pat_valid(u64 data)
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
+bool kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 
 #endif
-- 
1.8.3.1

