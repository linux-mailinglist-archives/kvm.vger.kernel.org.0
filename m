Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E52494AD0
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359294AbiATJdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:33:36 -0500
Received: from out0-136.mail.aliyun.com ([140.205.0.136]:50954 "EHLO
        out0-136.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358140AbiATJdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:33:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047203;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.MfqJchL_1642671212;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MfqJchL_1642671212)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:33:32 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Fix wrong privilege check for code segment in __load_segment_descriptor()
Date:   Thu, 20 Jan 2022 17:33:30 +0800
Message-Id: <ed8917d7bab80a1c1a130beae45c7d6ecdef47fc.1642669684.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
References: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Code segment descriptor can be loaded by jmp/call/ret, iret
and int. The privilege checks are different between those
instructions above realmode. Although, the emulator has
use x86_transfer_type enumerate to differentiate them, but
it is not really used in __load_segment_descriptor(). Note,
far jump/call to call gate, task gate or task state segment
are not implemented in emulator.

As for far jump/call to code segment, if DPL > CPL for conforming
code or (RPL > CPL or DPL != CPL) for non-conforming code, it
should trigger #GP. The current checks are ok.

As for far return, if RPL < CPL or DPL > RPL for conforming
code or DPL != RPL for non-conforming code, it should trigger #GP.
Outer level return is not implemented above virtual-8086 mode in
emulator. So it implies that RPL <= CPL, but the current checks
wouldn't trigger #GP if RPL < CPL.

As for code segment loading in task switch, if DPL > RPL for conforming
code or DPL != RPL for non-conforming code, it should trigger #TS. Since
segment selector is loaded before segment descriptor when load state from
tss, it implies that RPL = CPL, so the current checks are ok.

The only problem in current implementation is mssing RPL < CPL check for
far return. However, change code to follow the manual is better.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 864db6fbe8db..b7ce2a85e58e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1631,14 +1631,28 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		if (!(seg_desc.type & 8))
 			goto exception;
 
-		if (seg_desc.type & 4) {
-			/* conforming */
-			if (dpl > cpl)
-				goto exception;
-		} else {
-			/* nonconforming */
-			if (rpl > cpl || dpl != cpl)
-				goto exception;
+		if (transfer == X86_TRANSFER_RET && rpl < cpl)
+			goto exception;
+		if (transfer == X86_TRANSFER_RET || X86_TRANSFER_TASK_SWITCH) {
+			if (seg_desc.type & 4) {
+				/* conforming */
+				if (dpl > rpl)
+					goto exception;
+			} else {
+				/* nonconforming */
+				if (dpl != rpl)
+					goto exception;
+			}
+		} else { /* X86_TRANSFER_CALL_JMP */
+			if (seg_desc.type & 4) {
+				/* conforming */
+				if (dpl > cpl)
+					goto exception;
+			} else {
+				/* nonconforming */
+				if (rpl > cpl || dpl != cpl)
+					goto exception;
+			}
 		}
 		/* in long-mode d/b must be clear if l is set */
 		if (seg_desc.d && seg_desc.l) {
-- 
2.31.1

