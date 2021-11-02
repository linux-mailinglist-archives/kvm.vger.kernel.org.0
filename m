Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D7F442A29
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhKBJSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:18:12 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50987 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230353AbhKBJSK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 05:18:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Uuk1u78_1635844533;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0Uuk1u78_1635844533)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Nov 2021 17:15:34 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code seg
Date:   Tue,  2 Nov 2021 17:15:29 +0800
Message-Id: <093eabb1eab2965201c9b018373baf26ff256d85.1635842679.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
References: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Truncate the new EIP to a 32-bit value when handling EMULTYPE_SKIP as the
decode phase does not truncate _eip.  Wrapping the 32-bit boundary is
legal if and only if CS is a flat code segment, but that check is
implicitly handled in the form of limit checks in the decode phase.

Opportunstically prepare for a future fix by storing the result of any
truncation in "eip" instead of "_eip".

Fixes: 1957aa63be53 ("KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..3d7fc5c21ceb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8124,7 +8124,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * updating interruptibility state and injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
-		kvm_rip_write(vcpu, ctxt->_eip);
+		if (ctxt->mode != X86EMUL_MODE_PROT64)
+			ctxt->eip = (u32)ctxt->_eip;
+		else
+			ctxt->eip = ctxt->_eip;
+
+		kvm_rip_write(vcpu, ctxt->eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
 		return 1;
-- 
2.31.1

