Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC96A9A49E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733110AbfHWBHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:07:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:38007 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732741AbfHWBHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733507"
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
Subject: [RESEND PATCH 08/13] KVM: x86: Move #UD injection for failed emulation into emulation code
Date:   Thu, 22 Aug 2019 18:07:04 -0700
Message-Id: <20190823010709.24879-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Immediately inject a #UD and return EMULATE done if emulation fails when
handling an intercepted #UD.  This helps pave the way for removing
EMULATE_FAIL altogether.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1f9e36b2d58..bff3320aa78e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5328,7 +5328,6 @@ EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 int handle_ud(struct kvm_vcpu *vcpu)
 {
 	int emul_type = EMULTYPE_TRAP_UD;
-	enum emulation_result er;
 	char sig[5]; /* ud2; .ascii "kvm" */
 	struct x86_exception e;
 
@@ -5340,12 +5339,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}
 
-	er = kvm_emulate_instruction(vcpu, emul_type);
-	if (er == EMULATE_USER_EXIT)
-		return 0;
-	if (er != EMULATE_DONE)
-		kvm_queue_exception(vcpu, UD_VECTOR);
-	return 1;
+	return kvm_emulate_instruction(vcpu, emul_type) != EMULATE_USER_EXIT;
 }
 EXPORT_SYMBOL_GPL(handle_ud);
 
@@ -6533,8 +6527,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		++vcpu->stat.insn_emulation;
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
-			    (emulation_type & EMULTYPE_TRAP_UD_FORCED))
-				return EMULATE_FAIL;
+			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
+				kvm_queue_exception(vcpu, UD_VECTOR);
+				return EMULATE_DONE;
+			}
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
 				return EMULATE_DONE;
-- 
2.22.0

