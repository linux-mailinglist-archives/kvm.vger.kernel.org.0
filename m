Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743CB21F05A
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgGNMLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgGNMLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:11:25 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73139C08C5DF;
        Tue, 14 Jul 2020 05:11:23 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id B1749FF5;
        Tue, 14 Jul 2020 14:11:14 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Martin Radev <martin.b.radev@gmail.com>, hpa@zytor.com,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v4 75/75] x86/sev-es: Check required CPU features for SEV-ES
Date:   Tue, 14 Jul 2020 14:09:17 +0200
Message-Id: <20200714120917.11253-76-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Martin Radev <martin.b.radev@gmail.com>

Make sure the machine supports RDRAND, otherwise there is no trusted
source of of randomness in the system.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/sev-es.c |  3 +++
 arch/x86/kernel/sev-es-shared.c   | 15 +++++++++++++++
 arch/x86/kernel/sev-es.c          |  3 +++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index b522c18c0588..eb1a8b5cc753 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -145,6 +145,9 @@ void sev_es_shutdown_ghcb(void)
 	if (!boot_ghcb)
 		return;
 
+	if (!sev_es_check_cpu_features())
+		error("SEV-ES CPU Features missing.");
+
 	/*
 	 * GHCB Page must be flushed from the cache and mapped encrypted again.
 	 * Otherwise the running kernel will see strange cache effects when
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index 608f76d0d088..56de70cb80d8 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -9,6 +9,21 @@
  * and is included directly into both code-bases.
  */
 
+#ifndef __BOOT_COMPRESSED
+#define error(v)	pr_err(v)
+#define has_cpuflag(f)	boot_cpu_has(f)
+#endif
+
+static bool __init sev_es_check_cpu_features(void)
+{
+	if (!has_cpuflag(X86_FEATURE_RDRAND)) {
+		error("RDRAND instruction not supported - no trusted source of randomness available\n");
+		return false;
+	}
+
+	return true;
+}
+
 static void sev_es_terminate(unsigned int reason)
 {
 	u64 val = GHCB_SEV_TERMINATE;
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 61308f9c8138..481ea00c58b6 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -682,6 +682,9 @@ void __init sev_es_init_vc_handling(void)
 	if (!sev_es_active())
 		return;
 
+	if (!sev_es_check_cpu_features())
+		panic("SEV-ES CPU Features missing");
+
 	/* Initialize per-cpu GHCB pages */
 	for_each_possible_cpu(cpu) {
 		sev_es_alloc_runtime_data(cpu);
-- 
2.27.0

