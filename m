Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FAD87F4C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437236AbfHIQPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:47 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52904 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437128AbfHIQPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A4D1C305D35C;
        Fri,  9 Aug 2019 19:01:38 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E68C0305B7A1;
        Fri,  9 Aug 2019 19:01:35 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [RFC PATCH v6 74/92] kvm: x86: do not unconditionally patch the hypercall instruction during emulation
Date:   Fri,  9 Aug 2019 19:00:29 +0300
Message-Id: <20190809160047.8319-75-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

It can happened for us to end up emulating the VMCALL instruction as a
result of the handling of an EPT write fault. In this situation, the
emulator will try to unconditionally patch the correct hypercall opcode
bytes using emulator_write_emulated(). However, this last call uses the
fault GPA (if available) or walks the guest page tables at RIP,
otherwise. The trouble begins when using KVMI, when we forbid the use of
the fault GPA and fallback to the guest pt walk: in Windows (8.1 and
newer) the page that we try to write into is marked read-execute and as
such emulator_write_emulated() fails and we inject a write #PF, leading
to a guest crash.

The fix is rather simple: check the existing instruction bytes before
doing the patching. This does not change the normal KVM behaviour, but
does help when using KVMI as we no longer inject a write #PF.

CC: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04b1d2916a0a..965c4f0108eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7363,16 +7363,33 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
+#define KVM_HYPERCALL_INSN_LEN 3
+
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 {
+	int err;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	char instruction[3];
+	char buf[KVM_HYPERCALL_INSN_LEN];
+	char instruction[KVM_HYPERCALL_INSN_LEN];
 	unsigned long rip = kvm_rip_read(vcpu);
 
+	err = emulator_read_emulated(ctxt, rip, buf, sizeof(buf),
+				     &ctxt->exception);
+	if (err != X86EMUL_CONTINUE)
+		return err;
+
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
+	if (!memcmp(instruction, buf, sizeof(instruction)))
+		/*
+		 * The hypercall instruction is the correct one. Retry
+		 * its execution maybe we got here as a result of an
+		 * event other than #UD which has been resolved in the
+		 * mean time.
+		 */
+		return X86EMUL_CONTINUE;
 
-	return emulator_write_emulated(ctxt, rip, instruction, 3,
-		&ctxt->exception);
+	return emulator_write_emulated(ctxt, rip, instruction,
+				       sizeof(instruction), &ctxt->exception);
 }
 
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
