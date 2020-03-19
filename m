Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4963118AFA4
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCSJSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:18:35 -0400
Received: from 8bytes.org ([81.169.241.247]:52420 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbgCSJOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:34 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id F1A6B4F1; Thu, 19 Mar 2020 10:14:20 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 26/70] x86/idt: Move IDT to data segment
Date:   Thu, 19 Mar 2020 10:13:23 +0100
Message-Id: <20200319091407.1481-27-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

With SEV-ES, exception handling is needed very early, even before the
kernel has cleared the bss segment. In order to prevent clearing the
currently used IDT, move the IDT to the data segment.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/idt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 87ef69a72c52..a8fc01ea602a 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -165,8 +165,12 @@ static const __initconst struct idt_data dbg_idts[] = {
 };
 #endif
 
-/* Must be page-aligned because the real IDT is used in a fixmap. */
-gate_desc idt_table[IDT_ENTRIES] __page_aligned_bss;
+/*
+ * Must be page-aligned because the real IDT is used in a fixmap.
+ * Also needs to be in the .data segment, because the idt_table is
+ * needed before the kernel clears the .bss segment.
+ */
+gate_desc idt_table[IDT_ENTRIES] __page_aligned_data;
 
 struct desc_ptr idt_descr __ro_after_init = {
 	.size		= (IDT_ENTRIES * 2 * sizeof(unsigned long)) - 1,
-- 
2.17.1

