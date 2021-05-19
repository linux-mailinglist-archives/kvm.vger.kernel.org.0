Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74C0388F9A
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 15:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353879AbhESNyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 09:54:46 -0400
Received: from 8bytes.org ([81.169.241.247]:40206 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353772AbhESNyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 09:54:33 -0400
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 6F9B24D9;
        Wed, 19 May 2021 15:53:11 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v2 6/8] x86/insn-eval: Make 0 a valid RIP for insn_get_effective_ip()
Date:   Wed, 19 May 2021 15:52:49 +0200
Message-Id: <20210519135251.30093-7-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519135251.30093-1-joro@8bytes.org>
References: <20210519135251.30093-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

In theory 0 is a valid value for the instruction pointer, so don't use
it as the error return value from insn_get_effective_ip().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/lib/insn-eval.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index a67afd74232c..4eecb9c7c6a0 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1417,7 +1417,7 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
 	}
 }
 
-static unsigned long insn_get_effective_ip(struct pt_regs *regs)
+static int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
 {
 	unsigned long seg_base = 0;
 
@@ -1430,10 +1430,12 @@ static unsigned long insn_get_effective_ip(struct pt_regs *regs)
 	if (!user_64bit_mode(regs)) {
 		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
 		if (seg_base == -1L)
-			return 0;
+			return -EINVAL;
 	}
 
-	return seg_base + regs->ip;
+	*ip = seg_base + regs->ip;
+
+	return 0;
 }
 
 /**
@@ -1455,8 +1457,7 @@ int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
 	unsigned long ip;
 	int not_copied;
 
-	ip = insn_get_effective_ip(regs);
-	if (!ip)
+	if (insn_get_effective_ip(regs, &ip))
 		return 0;
 
 	not_copied = copy_from_user(buf, (void __user *)ip, MAX_INSN_SIZE);
@@ -1484,8 +1485,7 @@ int insn_fetch_from_user_inatomic(struct pt_regs *regs, unsigned char buf[MAX_IN
 	unsigned long ip;
 	int not_copied;
 
-	ip = insn_get_effective_ip(regs);
-	if (!ip)
+	if (insn_get_effective_ip(regs, &ip))
 		return 0;
 
 	not_copied = __copy_from_user_inatomic(buf, (void __user *)ip, MAX_INSN_SIZE);
-- 
2.31.1

