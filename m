Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD0159116
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgBKN56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:57:58 -0500
Received: from 8bytes.org ([81.169.241.247]:52240 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbgBKNxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:22 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5B8FCE1A; Tue, 11 Feb 2020 14:53:11 +0100 (CET)
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
Subject: [PATCH 23/62] x86/idt: Move IDT to data segment
Date:   Tue, 11 Feb 2020 14:52:17 +0100
Message-Id: <20200211135256.24617-24-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
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
 arch/x86/kernel/idt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 87ef69a72c52..7f81c1294847 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -166,7 +166,7 @@ static const __initconst struct idt_data dbg_idts[] = {
 #endif
 
 /* Must be page-aligned because the real IDT is used in a fixmap. */
-gate_desc idt_table[IDT_ENTRIES] __page_aligned_bss;
+gate_desc idt_table[IDT_ENTRIES] __page_aligned_data;
 
 struct desc_ptr idt_descr __ro_after_init = {
 	.size		= (IDT_ENTRIES * 2 * sizeof(unsigned long)) - 1,
-- 
2.17.1

