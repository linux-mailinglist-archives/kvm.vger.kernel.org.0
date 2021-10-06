Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E5F4244D5
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbhJFRnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:10 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53562 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239177AbhJFRmj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 99A96307CAE7;
        Wed,  6 Oct 2021 20:30:59 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 800553064495;
        Wed,  6 Oct 2021 20:30:59 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 16/77] KVM: x86: save the error code during EPT/NPF exits handling
Date:   Wed,  6 Oct 2021 20:30:12 +0300
Message-Id: <20211006173113.26445-17-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index 29f4e8b619e1..db88d38e485d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -916,6 +916,9 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+
+	/* #PF translated error code from EPT/NPT exit reason */
+	u64 error_code;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b7ef0671863e..de6cb59a332d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2077,6 +2077,8 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	svm->vcpu.arch.error_code = error_code;
+
 	trace_kvm_page_fault(fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a140d69b1bd3..ceba2e112e26 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5389,6 +5389,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
+	vcpu->arch.error_code = error_code;
 
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
