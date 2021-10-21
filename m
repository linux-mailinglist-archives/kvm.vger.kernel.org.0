Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CF8435CAB
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 10:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhJUILD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 04:11:03 -0400
Received: from 8bytes.org ([81.169.241.247]:34366 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231467AbhJUIK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 04:10:57 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9AFE51F0;
        Thu, 21 Oct 2021 10:08:37 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xinyang Ge <xing@microsoft.com>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/2] x86/sev: Fix stack type check in vc_switch_off_ist()
Date:   Thu, 21 Oct 2021 10:08:32 +0200
Message-Id: <20211021080833.30875-2-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211021080833.30875-1-joro@8bytes.org>
References: <20211021080833.30875-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The value of STACK_TYPE_EXCEPTION_LAST points to the last _valid_
exception stack. Reflect that in the check done in the
vc_switch_off_ist() function.

Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: a13644f3a53de ("x86/entry/64: Add entry code for #VC handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a58800973aed..f516f2b4797e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -709,7 +709,7 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
 	stack = (unsigned long *)sp;
 
 	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
-	    info.type >= STACK_TYPE_EXCEPTION_LAST)
+	    info.type > STACK_TYPE_EXCEPTION_LAST)
 		sp = __this_cpu_ist_top_va(VC2);
 
 sync:
-- 
2.33.1

