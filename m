Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372D5163763
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgBRXk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:40:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:39205 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgBRXkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:40:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:40:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436033034"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 15:40:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Take an unsigned 32-bit int for has_emulated_msr()'s index
Date:   Tue, 18 Feb 2020 15:40:11 -0800
Message-Id: <20200218234012.7110-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218234012.7110-1-sean.j.christopherson@intel.com>
References: <20200218234012.7110-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take a u32 for the index in has_emulated_msr() to match hardware, which
treats MSR indices as unsigned 32-bit values.  Functionally, taking a
signed int doesn't cause problems with the current code base, but could
theoretically cause problems with 32-bit KVM, e.g. if the index were
checked via a less-than statement, which would evaluate incorrectly for
MSR indices with bit 31 set.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm.c              | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..cac9c40e505c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1050,7 +1050,7 @@ struct kvm_x86_ops {
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
-	bool (*has_emulated_msr)(int index);
+	bool (*has_emulated_msr)(u32 index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
 	struct kvm *(*vm_alloc)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a3e32d61d60c..2991a4a1fc30 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5989,7 +5989,7 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
-static bool svm_has_emulated_msr(int index)
+static bool svm_has_emulated_msr(u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..47017da35ac4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6251,7 +6251,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
-static bool vmx_has_emulated_msr(int index)
+static bool vmx_has_emulated_msr(u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
-- 
2.24.1

