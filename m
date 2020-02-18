Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5FB16372B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBRX36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:29:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:38639 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgBRX35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936668"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:56 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/13] KVM: x86: Refactor init_emulate_ctxt() to explicitly take context
Date:   Tue, 18 Feb 2020 15:29:47 -0800
Message-Id: <20200218232953.5724-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly pass the emulation context when initializing said context in
preparation of dynamically allocation the emulation context.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69d3dd64d90c..0e67f90db9a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6414,9 +6414,9 @@ static bool inject_emulated_exception(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
-static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
+static void init_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int cs_db, cs_l;
 
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
@@ -6443,7 +6443,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	int ret;
 
-	init_emulate_ctxt(vcpu);
+	init_emulate_ctxt(ctxt);
 
 	ctxt->op_bytes = 2;
 	ctxt->ad_bytes = 2;
@@ -6770,7 +6770,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	kvm_clear_exception_queue(vcpu);
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
-		init_emulate_ctxt(vcpu);
+		init_emulate_ctxt(ctxt);
 
 		/*
 		 * We will reenter on the same instruction since
@@ -8943,7 +8943,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	int ret;
 
-	init_emulate_ctxt(vcpu);
+	init_emulate_ctxt(ctxt);
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
 				   has_error_code, error_code);
-- 
2.24.1

