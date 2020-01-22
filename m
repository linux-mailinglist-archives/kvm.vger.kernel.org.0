Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F97C144A56
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 04:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgAVDTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 22:19:52 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:55916 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728779AbgAVDTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 22:19:52 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D98259FE338F0A416F4A;
        Wed, 22 Jan 2020 11:19:50 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 22 Jan 2020
 11:19:40 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: X86: Add 'else' to unify fastop and execute call path
Date:   Wed, 22 Jan 2020 11:21:44 +0800
Message-ID: <1579663304-14524-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

It also helps eliminate some duplicated code.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/emulate.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c7a0da45f60a..0accce94f660 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5683,11 +5683,9 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		if (ctxt->d & Fastop) {
 			void (*fop)(struct fastop *) = (void *)ctxt->execute;
 			rc = fastop(ctxt, fop);
-			if (rc != X86EMUL_CONTINUE)
-				goto done;
-			goto writeback;
+		} else {
+			rc = ctxt->execute(ctxt);
 		}
-		rc = ctxt->execute(ctxt);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		goto writeback;
-- 
2.19.1

