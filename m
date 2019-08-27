Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6479F555
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbfH0Vln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:41:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:61898 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730798AbfH0Vks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919747"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 04/14] KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error code
Date:   Tue, 27 Aug 2019 14:40:30 -0700
Message-Id: <20190827214040.18710-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMware backdoor hooks #GP faults on IN{S}, OUT{S}, and RDPMC, none
of which generate a non-zero error code for their #GP.  Re-injecting #GP
instead of attempting emulation on a non-zero error code will allow a
future patch to move #GP injection (for emulation failure) into
kvm_emulate_instruction() without having to plumb in the error code.

Reviewed-and-tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 10 +++++++++-
 arch/x86/kvm/vmx/vmx.c | 12 +++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..7242142573d6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2772,12 +2772,20 @@ static int gp_interception(struct vcpu_svm *svm)
 
 	WARN_ON_ONCE(!enable_vmware_backdoor);
 
+	/*
+	 * VMware backdoor emulation on #GP interception only handles IN{S},
+	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
+	 */
+	if (error_code) {
+		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+		return 1;
+	}
 	er = kvm_emulate_instruction(vcpu,
 		EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
 	if (er == EMULATE_USER_EXIT)
 		return 0;
 	else if (er != EMULATE_DONE)
-		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18286e5b5983..8a65e1122376 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4509,12 +4509,22 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
 		WARN_ON_ONCE(!enable_vmware_backdoor);
+
+		/*
+		 * VMware backdoor emulation on #GP interception only handles
+		 * IN{S}, OUT{S}, and RDPMC, none of which generate a non-zero
+		 * error code on #GP.
+		 */
+		if (error_code) {
+			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+			return 1;
+		}
 		er = kvm_emulate_instruction(vcpu,
 			EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
 		if (er == EMULATE_USER_EXIT)
 			return 0;
 		else if (er != EMULATE_DONE)
-			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 		return 1;
 	}
 
-- 
2.22.0

