Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4BF87F28
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437091AbfHIQPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52918 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437061AbfHIQPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 59BC2305D369;
        Fri,  9 Aug 2019 19:01:44 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C8C39305B7A1;
        Fri,  9 Aug 2019 19:01:43 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 90/92] kvm: x86: emulate lock cmpxchg8b atomically
Date:   Fri,  9 Aug 2019 19:00:45 +0300
Message-Id: <20190809160047.8319-91-alazar@bitdefender.com>
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

As it was the case for lock cmpxchg, lock cmpxchg8b was emulated in two
steps the first one setting/clearing the zero flag and the last one
making the actual atomic operation.

This patch fixes that by combining the two, ie. the writeback step is
no longer necessary as the first step made the changes directly in
memory.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dac4c0ca1ee3..2038e42c1eae 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2320,7 +2320,47 @@ static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
 
 static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
 {
-	u64 old = ctxt->dst.orig_val64;
+	u64 old;
+
+	if (ctxt->lock_prefix) {
+		int rc;
+		ulong linear;
+		u64 new = (reg_read(ctxt, VCPU_REGS_RBX) & (u32)-1) |
+			((reg_read(ctxt, VCPU_REGS_RCX) & (u32)-1) << 32);
+
+		old = (reg_read(ctxt, VCPU_REGS_RAX) & (u32)-1) |
+			((reg_read(ctxt, VCPU_REGS_RDX) & (u32)-1) << 32);
+
+		/* disable writeback altogether */
+		ctxt->d &= ~SrcWrite;
+		ctxt->d |= NoWrite;
+
+		rc = linearize(ctxt, ctxt->dst.addr.mem, 8, true, &linear);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+
+		rc = ctxt->ops->cmpxchg_emulated(ctxt, linear, &old, &new,
+						 ctxt->dst.bytes,
+						 &ctxt->exception);
+
+		switch (rc) {
+		case X86EMUL_CONTINUE:
+			ctxt->eflags |= X86_EFLAGS_ZF;
+			break;
+		case X86EMUL_CMPXCHG_FAILED:
+			*reg_write(ctxt, VCPU_REGS_RAX) = old & (u32)-1;
+			*reg_write(ctxt, VCPU_REGS_RDX) = (old >> 32) & (u32)-1;
+
+			ctxt->eflags &= ~X86_EFLAGS_ZF;
+
+			rc = X86EMUL_CONTINUE;
+			break;
+		}
+
+		return rc;
+	}
+
+	old = ctxt->dst.orig_val64;
 
 	if (ctxt->dst.bytes == 16)
 		return X86EMUL_UNHANDLEABLE;
