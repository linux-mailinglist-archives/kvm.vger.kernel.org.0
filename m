Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1361A4AD50D
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 10:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355394AbiBHJeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 04:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355334AbiBHJeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:34:14 -0500
Received: from out0-144.mail.aliyun.com (out0-144.mail.aliyun.com [140.205.0.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD32C03FEC9;
        Tue,  8 Feb 2022 01:34:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047206;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.Mn034LU_1644312848;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mn034LU_1644312848)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 17:34:08 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: x86/emulator: Fix wrong privilege check for code segment in __load_segment_descriptor()
Date:   Tue, 08 Feb 2022 17:34:04 +0800
Message-Id: <e01f5ea70fc1f18f23da1182acdbc5c97c0e5886.1644292363.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1644292363.git.houwenlong.hwl@antgroup.com>
References: <cover.1644292363.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

The only problem in current implementation is missing RPL < CPL check for
far return. However, change code to follow the manual is better.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b7ee7de9f8cd..37c4213bdcc1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1631,14 +1631,29 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
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
+		/* RET can never return to an inner privilege level. */
+		if (transfer == X86_TRANSFER_RET && rpl < cpl)
+			goto exception;
+		if (transfer == X86_TRANSFER_RET || transfer == X86_TRANSFER_TASK_SWITCH) {
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

