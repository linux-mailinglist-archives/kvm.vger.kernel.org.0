Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A5A228ADD
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgGUVRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:44 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37854 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731278AbgGUVQG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 60EB0305D76B;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4597F304FA14;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 22/84] KVM: x86: save the error code during EPT/NPF exits handling
Date:   Wed, 22 Jul 2020 00:08:20 +0300
Message-Id: <20200721210922.7646-23-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed for kvm_page_track_emulation_failure().

When the introspection tool {read,write,exec}-protect a guest memory
page, it is notified from the read/write/fetch callbacks used by
the KVM emulator. If the emulation fails it is possible that the
read/write callbacks were not used. In such cases, the emulator will
call kvm_page_track_emulation_failure() to ensure that the introspection
tool is notified of the read/write #PF (based on this saved error code),
which in turn can emulate the instruction or unprotect the memory page
(and let the guest execute the instruction).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/svm/svm.c          | 2 ++
 arch/x86/kvm/vmx/vmx.c          | 1 +
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f04a01dac423..2530af4420cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -837,6 +837,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/* #PF translated error code from EPT/NPT exit reason */
+	u64 error_code;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9c8e77193f98..1ec88ff241ab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1799,6 +1799,8 @@ static int npf_interception(struct vcpu_svm *svm)
 	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	svm->vcpu.arch.error_code = error_code;
+
 	trace_kvm_page_fault(fault_address, error_code);
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cd498ece8b52..6554c2278176 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5365,6 +5365,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 		      ? PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
+	vcpu->arch.error_code = error_code;
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
