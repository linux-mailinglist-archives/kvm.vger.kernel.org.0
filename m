Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55B144AE5
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 05:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgAVEnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 23:43:42 -0500
Received: from mga18.intel.com ([134.134.136.126]:1757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgAVEnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 23:43:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 20:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,348,1574150400"; 
   d="scan'208";a="215779960"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 21 Jan 2020 20:43:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 02/01] KVM: x86: Use a typedef for fastop functions
Date:   Tue, 21 Jan 2020 20:43:39 -0800
Message-Id: <20200122044339.4888-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
References: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a typedef to for the fastop function prototype to make the code more
readable.

No functional change intended.

Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Applies on top of Miaohe's patch.  Feel free to squash this.

 arch/x86/kvm/emulate.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0accce94f660..ddbc61984227 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -311,7 +311,9 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
 #define ON64(x)
 #endif
 
-static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *));
+typedef void (*fastop_t)(struct fastop *);
+
+static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 
 #define __FOP_FUNC(name) \
 	".align " __stringify(FASTOP_SIZE) " \n\t" \
@@ -5502,7 +5504,7 @@ static void fetch_possible_mmx_operand(struct operand *op)
 		read_mmx_reg(&op->mm_val, op->addr.mm);
 }
 
-static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
+static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
 {
 	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
 
@@ -5680,12 +5682,10 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		ctxt->eflags &= ~X86_EFLAGS_RF;
 
 	if (ctxt->execute) {
-		if (ctxt->d & Fastop) {
-			void (*fop)(struct fastop *) = (void *)ctxt->execute;
-			rc = fastop(ctxt, fop);
-		} else {
+		if (ctxt->d & Fastop)
+			rc = fastop(ctxt, (fastop_t)ctxt->execute);
+		else
 			rc = ctxt->execute(ctxt);
-		}
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		goto writeback;
-- 
2.24.1

