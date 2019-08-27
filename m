Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235159F553
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbfH0Vlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:41:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:61893 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbfH0Vks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919753"
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
Subject: [PATCH v2 06/14] KVM: x86: Add explicit flag for forced emulation on #UD
Date:   Tue, 27 Aug 2019 14:40:32 -0700
Message-Id: <20190827214040.18710-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an explicit emulation type for forced #UD emulation and use it to
detect that KVM should unconditionally inject a #UD instead of falling
into its standard emulation failure handling.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d1d5b5ca1195..a38c93362945 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,6 +1318,7 @@ enum emulation_result {
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
 #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
+#define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 228ca71d5b01..a1f9e36b2d58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5337,7 +5337,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 				sig, sizeof(sig), &e) == 0 &&
 	    memcmp(sig, "\xf\xbkvm", sizeof(sig)) == 0) {
 		kvm_rip_write(vcpu, kvm_rip_read(vcpu) + sizeof(sig));
-		emul_type = 0;
+		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}
 
 	er = kvm_emulate_instruction(vcpu, emul_type);
@@ -6532,7 +6532,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		trace_kvm_emulate_insn_start(vcpu);
 		++vcpu->stat.insn_emulation;
 		if (r != EMULATION_OK)  {
-			if (emulation_type & EMULTYPE_TRAP_UD)
+			if ((emulation_type & EMULTYPE_TRAP_UD) ||
+			    (emulation_type & EMULTYPE_TRAP_UD_FORCED))
 				return EMULATE_FAIL;
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
-- 
2.22.0

