Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC159A49B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732769AbfHWBHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:07:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:38007 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732692AbfHWBHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733495"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 18:07:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 04/13] KVM: x86: Drop EMULTYPE_NO_UD_ON_FAIL as a standalone type
Date:   Thu, 22 Aug 2019 18:07:00 -0700
Message-Id: <20190823010709.24879-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "no #UD on fail" is used only in the VMWare case, and for the VMWare
scenario it really means "#GP instead of #UD on fail".  Remove the flag
in preparation for moving all fault injection into the emulation flow
itself, which in turn will allow eliminating EMULATE_DONE and company.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 3 +--
 arch/x86/kvm/vmx/vmx.c          | 3 +--
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44a5ce57a905..dd6bd9ed0839 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,7 +1318,6 @@ enum emulation_result {
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
 #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
-#define EMULTYPE_NO_UD_ON_FAIL	    (1 << 4)
 #define EMULTYPE_VMWARE		    (1 << 5)
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..5a42f9c70014 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2772,8 +2772,7 @@ static int gp_interception(struct vcpu_svm *svm)
 
 	WARN_ON_ONCE(!enable_vmware_backdoor);
 
-	er = kvm_emulate_instruction(vcpu,
-		EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
+	er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
 	if (er == EMULATE_USER_EXIT)
 		return 0;
 	else if (er != EMULATE_DONE)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18286e5b5983..6ecf773825e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4509,8 +4509,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
 		WARN_ON_ONCE(!enable_vmware_backdoor);
-		er = kvm_emulate_instruction(vcpu,
-			EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
+		er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
 		if (er == EMULATE_USER_EXIT)
 			return 0;
 		else if (er != EMULATE_DONE)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe847f8eb947..e0f0e14d8fac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6210,7 +6210,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
-	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
+	if (emulation_type & EMULTYPE_VMWARE)
 		return EMULATE_FAIL;
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
-- 
2.22.0

