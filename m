Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CF6409821
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345577AbhIMP61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:58:27 -0400
Received: from 8bytes.org ([81.169.241.247]:56874 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244891AbhIMP5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:57:38 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 8B1EA1043;
        Mon, 13 Sep 2021 17:56:19 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <joro@8bytes.org>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 05/12] x86/sev: Use GHCB protocol version 2 if supported
Date:   Mon, 13 Sep 2021 17:55:56 +0200
Message-Id: <20210913155603.28383-6-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913155603.28383-1-joro@8bytes.org>
References: <20210913155603.28383-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Check whether the hypervisor supports GHCB version 2 and use it if
available.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/sev.c | 10 ++++++++--
 arch/x86/include/asm/sev.h     |  4 ++--
 arch/x86/kernel/sev-shared.c   | 17 ++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 101e08c67296..7f8416f76be7 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -119,16 +119,22 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 /* Include code for early handlers */
 #include "../../kernel/sev-shared.c"
 
+static unsigned int ghcb_protocol;
+
 static u64 sev_get_ghcb_proto_ver(void)
 {
-	return GHCB_PROTOCOL_MAX;
+	return ghcb_protocol;
 }
 
 static bool early_setup_sev_es(void)
 {
-	if (!sev_es_negotiate_protocol(NULL))
+	struct sev_ghcb_protocol_info info;
+
+	if (!sev_es_negotiate_protocol(&info))
 		sev_es_terminate(GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
 
+	ghcb_protocol = info.vm_proto;
+
 	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
 		return false;
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..134a7c9d91b6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -12,8 +12,8 @@
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 
-#define GHCB_PROTO_OUR		0x0001UL
-#define GHCB_PROTOCOL_MAX	1ULL
+#define GHCB_PROTOCOL_MIN	1ULL
+#define GHCB_PROTOCOL_MAX	2ULL
 #define GHCB_DEFAULT_USAGE	0ULL
 
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 36eaac2773ed..40a1ca81bdb8 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -61,6 +61,7 @@ static void __noreturn sev_es_terminate(unsigned int reason)
 
 static bool sev_es_negotiate_protocol(struct sev_ghcb_protocol_info *info)
 {
+	unsigned int protocol;
 	u64 val;
 
 	/* Do the GHCB protocol version negotiation */
@@ -71,14 +72,24 @@ static bool sev_es_negotiate_protocol(struct sev_ghcb_protocol_info *info)
 	if (GHCB_MSR_INFO(val) != GHCB_MSR_SEV_INFO_RESP)
 		return false;
 
-	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTO_OUR ||
-	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTO_OUR)
+	/* Sanity check untrusted input */
+	if (GHCB_MSR_PROTO_MIN(val) > GHCB_MSR_PROTO_MAX(val))
+		return false;
+
+	/* Use maximum supported protocol version */
+	protocol = min_t(unsigned int, GHCB_MSR_PROTO_MAX(val), GHCB_PROTOCOL_MAX);
+
+	/*
+	 * Hypervisor does not support any protocol version required for this
+	 * kernel.
+	 */
+	if (protocol < GHCB_MSR_PROTO_MIN(val))
 		return false;
 
 	if (info) {
 		info->hv_proto_min = GHCB_MSR_PROTO_MIN(val);
 		info->hv_proto_max = GHCB_MSR_PROTO_MAX(val);
-		info->vm_proto	   = GHCB_PROTO_OUR;
+		info->vm_proto	   = protocol;
 	}
 
 	return true;
-- 
2.33.0

