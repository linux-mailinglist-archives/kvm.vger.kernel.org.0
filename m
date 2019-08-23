Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B073C9A4A2
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbfHWBH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:07:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:37991 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732744AbfHWBHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733510"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 18:07:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 09/13] KVM: x86: Exit to userspace on emulation skip failure
Date:   Thu, 22 Aug 2019 18:07:05 -0700
Message-Id: <20190823010709.24879-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kill a few birds with one stone by forcing an exit to userspace on skip
emulation failure.  This removes a reference to EMULATE_FAIL, fixes a
bug in handle_ept_misconfig() where it would exit to userspace without
setting run->exit_reason, and fixes a theoretical bug in SVM's
task_switch_interception() where it would overwrite run->exit_reason on
a return of EMULATE_USER_EXIT.

Note, this technically doesn't fully fix task_switch_interception()
as it now incorrectly handles EMULATE_FAIL, but in practice there is no
bug as EMULATE_FAIL will never be returned for EMULTYPE_SKIP.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 4 ++--
 arch/x86/kvm/x86.c | 9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 97562c2c8b7b..c8e3bef2d586 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3881,8 +3881,8 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (skip_emulated_instruction(&svm->vcpu) != EMULATE_DONE)
-			goto fail;
+		if (skip_emulated_instruction(&svm->vcpu) == EMULATE_USER_EXIT)
+			return 0;
 	}
 
 	if (int_type != SVM_EXITINTINFO_TYPE_SOFT)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bff3320aa78e..1a886ec6957d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6209,6 +6209,13 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 		return EMULATE_DONE;
 	}
 
+	if (emulation_type & EMULTYPE_SKIP) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		return EMULATE_USER_EXIT;
+	}
+
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
@@ -6536,8 +6543,6 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 				return EMULATE_DONE;
 			if (ctxt->have_exception && inject_emulated_exception(vcpu))
 				return EMULATE_DONE;
-			if (emulation_type & EMULTYPE_SKIP)
-				return EMULATE_FAIL;
 			return handle_emulation_failure(vcpu, emulation_type);
 		}
 	}
-- 
2.22.0

