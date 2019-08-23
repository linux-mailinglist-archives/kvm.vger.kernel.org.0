Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6219A4A4
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbfHWBII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:08:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:38007 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732696AbfHWBHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733498"
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
Subject: [RESEND PATCH 05/13] KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error code
Date:   Thu, 22 Aug 2019 18:07:01 -0700
Message-Id: <20190823010709.24879-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 6 +++++-
 arch/x86/kvm/vmx/vmx.c | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5a42f9c70014..b96a119690f4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2772,11 +2772,15 @@ static int gp_interception(struct vcpu_svm *svm)
 
 	WARN_ON_ONCE(!enable_vmware_backdoor);
 
+	if (error_code) {
+		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+		return 1;
+	}
 	er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
 	if (er == EMULATE_USER_EXIT)
 		return 0;
 	else if (er != EMULATE_DONE)
-		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ecf773825e2..3ee0dd304bc7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4509,11 +4509,16 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
 		WARN_ON_ONCE(!enable_vmware_backdoor);
+
+		if (error_code) {
+			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+			return 1;
+		}
 		er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
 		if (er == EMULATE_USER_EXIT)
 			return 0;
 		else if (er != EMULATE_DONE)
-			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 		return 1;
 	}
 
-- 
2.22.0

