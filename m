Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A3B40981E
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbhIMP6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:58:25 -0400
Received: from 8bytes.org ([81.169.241.247]:56962 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245366AbhIMP5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:57:39 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 555131074;
        Mon, 13 Sep 2021 17:56:20 +0200 (CEST)
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
Subject: [PATCH v2 06/12] x86/sev: Cache AP Jump Table Address
Date:   Mon, 13 Sep 2021 17:55:57 +0200
Message-Id: <20210913155603.28383-7-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913155603.28383-1-joro@8bytes.org>
References: <20210913155603.28383-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Store the physical address of the AP Jump Table in kernel memory so
that it does not need to be fetched from the Hypervisor again.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 5d3422e8b25e..eedba56b6bac 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -42,6 +42,9 @@ static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  */
 static struct ghcb __initdata *boot_ghcb;
 
+/* Cached AP Jump Table Address */
+static phys_addr_t sev_es_jump_table_pa;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -546,12 +549,14 @@ void noinstr __sev_es_nmi_complete(void)
 	__sev_put_ghcb(&state);
 }
 
-static u64 get_jump_table_addr(void)
+static phys_addr_t get_jump_table_addr(void)
 {
 	struct ghcb_state state;
 	unsigned long flags;
 	struct ghcb *ghcb;
-	u64 ret = 0;
+
+	if (sev_es_jump_table_pa)
+		return sev_es_jump_table_pa;
 
 	local_irq_save(flags);
 
@@ -567,39 +572,36 @@ static u64 get_jump_table_addr(void)
 
 	if (ghcb_sw_exit_info_1_is_valid(ghcb) &&
 	    ghcb_sw_exit_info_2_is_valid(ghcb))
-		ret = ghcb->save.sw_exit_info_2;
+		sev_es_jump_table_pa = (phys_addr_t)ghcb->save.sw_exit_info_2;
 
 	__sev_put_ghcb(&state);
 
 	local_irq_restore(flags);
 
-	return ret;
+	return sev_es_jump_table_pa;
 }
 
 int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
 {
 	u16 startup_cs, startup_ip;
-	phys_addr_t jump_table_pa;
-	u64 jump_table_addr;
 	u16 __iomem *jump_table;
+	phys_addr_t pa;
 
-	jump_table_addr = get_jump_table_addr();
+	pa = get_jump_table_addr();
 
 	/* On UP guests there is no jump table so this is not a failure */
-	if (!jump_table_addr)
+	if (!pa)
 		return 0;
 
 	/* Check if AP Jump Table is page-aligned */
-	if (jump_table_addr & ~PAGE_MASK)
+	if (pa & ~PAGE_MASK)
 		return -EINVAL;
 
-	jump_table_pa = jump_table_addr & PAGE_MASK;
-
 	startup_cs = (u16)(rmh->trampoline_start >> 4);
 	startup_ip = (u16)(rmh->sev_es_trampoline_start -
 			   rmh->trampoline_start);
 
-	jump_table = ioremap_encrypted(jump_table_pa, PAGE_SIZE);
+	jump_table = ioremap_encrypted(pa, PAGE_SIZE);
 	if (!jump_table)
 		return -EIO;
 
-- 
2.33.0

