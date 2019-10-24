Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F5E3C88
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406693AbfJXTyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 15:54:39 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:42449 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390431AbfJXTyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 15:54:38 -0400
Received: by mail-pf1-f202.google.com with SMTP id w16so9668pfj.9
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 12:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=haioOoskBRBydFeA6DvXJpqQ02xkMHKkeUpYLf3y49E=;
        b=fXPWLXN627Q7gWb6DoS6HKE29fuTMr1aTKmoYNV461mC2ZGBYMccc55lnm8YkRRQzH
         ftPGt/7KH++pWn7UT6KXAcQ7aaqARS5Tu0J6pKgOrJm0CwKInNwrwJ2OQY1cUqfdGiKp
         AnJuWJy+ANtjIpoiRm078wPrxmypvC8aNok8U3XhO+i4cwDFTUrn0xF3BnuQnX4245jW
         4uRai5bx5drZFYolaEtPBMcydBcwdf6/H9PyEANrCu/UJF6+50uf0/y+Ht0715NYMNX7
         43KcC5rWdN0kpBXVzieO0JkZtfVDy0wlw3BzsGZubQ5jy+WuBJ4I0cbs3/7qi3poeyXD
         7PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=haioOoskBRBydFeA6DvXJpqQ02xkMHKkeUpYLf3y49E=;
        b=FfPQMMtebECObpt9Kx1gOyUqzAYWSk3rbKdsfmb/t2Ehy91nakehiZMSrFBMfV25L3
         tP1TQChlP5D3dgw8N9M1V2al6PoZbCzat+MkTr25cgNWEYxEM8wVKfx0kFj7IjAOIzf5
         b6ksPHYAkx1lq8+p7OFvC0oh7hUKyF9i27Ez1+tOahiXtidjctEcGkVmTBSmHI4ucQld
         Tgyw3uTILeaWIIM7D5P/Krd5sMlbJBIu9j2apH8hBe4a4sDQsWBtGLhq9E69qZ3aKL7X
         Y7BaGkQl8Dclq3yczKYuMmCRZRt2b6GpCsk3qZ8R7W11CbvQ/dzZM7YkPdZnujy8PGY+
         DA7g==
X-Gm-Message-State: APjAAAXj9yCfjDlTv1XgW5a/IHulExb1R+TLa22p/mpMOdrdTRvjW0LX
        rzwgYhZklHMpz2fvCJRVD3akk0GkDn6b/L6Dzxlbg1eBMGdesmTIlalv5ZkA+PyypdHJPSLtZRm
        K3qdnaZFyD/vZdpsTvBVVMmGsZsexQ0ss12rh50LrXUdG8d9lLZYMz0n51wzZb1g=
X-Google-Smtp-Source: APXvYqznf4QumgFLEDXHFFc5+Sm9/m/6dbDTp+S/bXlj9PS3/Axu98W9jxM6rAxNcNTWVBjOophFN/mmw+dX7g==
X-Received: by 2002:a63:1e04:: with SMTP id e4mr11451964pge.4.1571946877360;
 Thu, 24 Oct 2019 12:54:37 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:54:31 -0700
Message-Id: <20191024195431.183667-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2] kvm: x86: Add cr3 to struct kvm_debug_exit_arch
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ken Hofsass <hofsass@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ken Hofsass <hofsass@google.com>

A userspace agent can use cr3 to quickly determine whether a
KVM_EXIT_DEBUG is associated with a guest process of interest.

KVM_CAP_DEBUG_EVENT_PDBR indicates support for the extension.

Signed-off-by: Ken Hofsass <hofsass@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
---
v1 -> v2: Changed KVM_CAP_DEBUG_EVENT_PG_BASE_ADDR to KVM_CAP_DEBUG_EVENT_PDBR
          Set debug.arch.cr3 in kvm_vcpu_do_singlestep and
	                        kvm_vcpu_check_breakpoint
          Added svm support
	  
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/svm.c              | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 3 +++
 include/uapi/linux/kvm.h        | 1 +
 5 files changed, 10 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 503d3f42da167..cea355c7ee8e7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -254,6 +254,7 @@ struct kvm_debug_exit_arch {
 	__u64 pc;
 	__u64 dr6;
 	__u64 dr7;
+	__u64 cr3; /* Depends on KVM_CAP_DEBUG_EVENT_PDBR */
 };
 
 #define KVM_GUESTDBG_USE_SW_BP		0x00010000
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6df51066..1a774d2c78eef 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2738,6 +2738,7 @@ static int db_interception(struct vcpu_svm *svm)
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.pc =
 			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+		kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		return 0;
 	}
@@ -2748,9 +2749,11 @@ static int db_interception(struct vcpu_svm *svm)
 static int bp_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
 	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+	kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 	kvm_run->debug.arch.exception = BP_VECTOR;
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae9..736284d293c4a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4690,6 +4690,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		rip = kvm_rip_read(vcpu);
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
+		kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 		kvm_run->debug.arch.exception = ex_no;
 		break;
 	default:
@@ -4909,6 +4910,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
 			vcpu->run->debug.arch.dr7 = dr7;
 			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
+			vcpu->run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 			vcpu->run->debug.arch.exception = DB_VECTOR;
 			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
 			return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf385266..2fd18b55462a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3222,6 +3222,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_DEBUG_EVENT_PDBR:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -6490,6 +6491,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
 		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
+		kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		return 0;
@@ -6534,6 +6536,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 		if (dr6 != 0) {
 			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
 			kvm_run->debug.arch.pc = eip;
+			kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 			kvm_run->debug.arch.exception = DB_VECTOR;
 			kvm_run->exit_reason = KVM_EXIT_DEBUG;
 			*r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e83..cde4b28338482 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1000,6 +1000,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_DEBUG_EVENT_PDBR 176
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.24.0.rc0.303.g954a862665-goog

