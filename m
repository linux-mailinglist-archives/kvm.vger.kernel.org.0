Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70923107ABA
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfKVWkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:61229 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfKVWkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029679"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:03 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] KVM: x86: Refactor init_emulate_ctxt() to explicitly take context
Date:   Fri, 22 Nov 2019 14:39:53 -0800
Message-Id: <20191122223959.13545-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
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
index 8147bea8eda4..dd6f010345d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6324,9 +6324,9 @@ static bool inject_emulated_exception(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
-static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
+static void init_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int cs_db, cs_l;
 
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
@@ -6353,7 +6353,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	int ret;
 
-	init_emulate_ctxt(vcpu);
+	init_emulate_ctxt(ctxt);
 
 	ctxt->op_bytes = 2;
 	ctxt->ad_bytes = 2;
@@ -6683,7 +6683,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	kvm_clear_exception_queue(vcpu);
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
-		init_emulate_ctxt(vcpu);
+		init_emulate_ctxt(ctxt);
 
 		/*
 		 * We will reenter on the same instruction since
@@ -8787,7 +8787,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	int ret;
 
-	init_emulate_ctxt(vcpu);
+	init_emulate_ctxt(ctxt);
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
 				   has_error_code, error_code);
-- 
2.24.0

