Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7A22CA7C
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgGXQEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:04:10 -0400
Received: from 8bytes.org ([81.169.241.247]:59420 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgGXQEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:09 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id EEB786FA;
        Fri, 24 Jul 2020 18:04:06 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v5 20/75] x86/boot/compressed/64: Check return value of kernel_ident_mapping_init()
Date:   Fri, 24 Jul 2020 18:02:41 +0200
Message-Id: <20200724160336.5435-21-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
References: <20200724160336.5435-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The function can fail to create an identity mapping, check for that
and bail out if it happens.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/ident_map_64.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index b4f2a5f503cd..aa91bebc0fe9 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -91,6 +91,8 @@ static struct x86_mapping_info mapping_info;
  */
 static void add_identity_map(unsigned long start, unsigned long end)
 {
+	int ret;
+
 	/* Align boundary to 2M. */
 	start = round_down(start, PMD_SIZE);
 	end = round_up(end, PMD_SIZE);
@@ -98,8 +100,9 @@ static void add_identity_map(unsigned long start, unsigned long end)
 		return;
 
 	/* Build the mapping. */
-	kernel_ident_mapping_init(&mapping_info, (pgd_t *)top_level_pgt,
-				  start, end);
+	ret = kernel_ident_mapping_init(&mapping_info, (pgd_t *)top_level_pgt, start, end);
+	if (ret)
+		error("Error: kernel_ident_mapping_init() failed\n");
 }
 
 /* Locates and clears a region for a new top level page table. */
-- 
2.27.0

