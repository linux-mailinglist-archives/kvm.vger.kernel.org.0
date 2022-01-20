Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E41494ACE
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359137AbiATJdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:33:35 -0500
Received: from out0-153.mail.aliyun.com ([140.205.0.153]:58769 "EHLO
        out0-153.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbiATJde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:33:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---.MfqJch5_1642671211;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MfqJch5_1642671211)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:33:31 +0800
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
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()
Date:   Thu, 20 Jan 2022 17:33:29 +0800
Message-Id: <117283244eab58e94d589af58a5f2b245b8c0025.1642669684.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
References: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM on the "Instruction Set Reference", when
loading segment descriptor, not-present segment check should
be after all type and privilege checks. But the emulator checks
it first, then #NP is triggered instead of #GP if privilege fails
and segment is not present. Put not-present segment check after
type and privilege checks in __load_segment_descriptor().

Fixes: 38ba30ba51a00 (KVM: x86 emulator: Emulate task switch in emulator.c)
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 166a145fc1e6..864db6fbe8db 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1616,11 +1616,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		goto exception;
 	}

-	if (!seg_desc.p) {
-		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
-		goto exception;
-	}
-
 	dpl = seg_desc.dpl;

 	switch (seg) {
@@ -1660,6 +1655,10 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	case VCPU_SREG_TR:
 		if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
 			goto exception;
+		if (!seg_desc.p) {
+			err_vec = NP_VECTOR;
+			goto exception;
+		}
 		old_desc = seg_desc;
 		seg_desc.type |= 2; /* busy */
 		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
@@ -1684,6 +1683,11 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		break;
 	}

+	if (!seg_desc.p) {
+		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
+		goto exception;
+	}
+
 	if (seg_desc.s) {
 		/* mark segment as accessed */
 		if (!(seg_desc.type & 1)) {
--
2.31.1

