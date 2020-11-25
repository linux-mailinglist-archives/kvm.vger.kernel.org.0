Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBDF2C3C73
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgKYJlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:41:53 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57024 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbgKYJlw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E21B2305D505;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BFB963072785;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 19/81] KVM: x86: save the error code during EPT/NPF exits handling
Date:   Wed, 25 Nov 2020 11:34:58 +0200
Message-Id: <20201125093600.2766-20-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 01853453a659..86048037da23 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -813,6 +813,9 @@ struct kvm_vcpu_arch {
 		 */
 		bool enforce;
 	} pv_cpuid;
+
+	/* #PF translated error code from EPT/NPT exit reason */
+	u64 error_code;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2bfefcfbddd7..43a2e4ec6178 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1916,6 +1916,8 @@ static int npf_interception(struct vcpu_svm *svm)
 	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	svm->vcpu.arch.error_code = error_code;
+
 	trace_kvm_page_fault(fault_address, error_code);
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a7d2bab38233..d5d4203378d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5390,6 +5390,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 		      ? PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
+	vcpu->arch.error_code = error_code;
 
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
