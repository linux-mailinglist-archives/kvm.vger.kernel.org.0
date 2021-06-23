Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAB33B1405
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 08:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFWGma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 02:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhFWGm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 02:42:29 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80A7C061574;
        Tue, 22 Jun 2021 23:40:12 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 7BB9B3C2; Wed, 23 Jun 2021 08:40:08 +0200 (CEST)
Date:   Wed, 23 Jun 2021 08:40:00 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: [PATCH 2/3] x86/sev: Add defines for GHCB version 2 MSR protocol
 requests
Message-ID: <YNLXQIZ5e1wjkshG@8bytes.org>
References: <20210622144825.27588-1-joro@8bytes.org>
 <20210622144825.27588-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622144825.27588-3-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add the necessary defines for supporting the GHCB version 2 protocol.
This includes defines for:

	- MSR-based AP hlt request/response
	- Hypervisor Feature request/response

This is the bare minimum of requests that need to be supported by a GHCB
version 2 implementation. There are more requests in the specification,
but those depend on Secure Nested Paging support being available.

These defines are shared between SEV host and guest support, so they are
submitted as an individual patch without users yet to avoid merge
conflicts in the future.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-common.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1cc9e7dd8107..9aa2f29b4c97 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -47,6 +47,21 @@
 		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
 		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
 
+/* AP Reset Hold */
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
+
+/* GHCB Hypervisor Feature Request/Response */
+#define GHCB_MSR_HV_FT_REQ			0x080
+#define GHCB_MSR_HV_FT_RESP			0x081
+#define GHCB_MSR_HV_FT_POS			12
+#define GHCB_MSR_HV_FT_MASK			GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_HV_FT_RESP_VAL(v)		\
+	((unsigned long)((v) >> GHCB_MSR_HV_FT_POS) & GHCB_MSR_HV_FT_MASK)
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-- 
2.31.1

