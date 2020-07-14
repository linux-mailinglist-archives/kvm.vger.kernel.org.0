Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB1121F0B9
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgGNMQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:16:04 -0400
Received: from 8bytes.org ([81.169.241.247]:53184 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgGNMKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:10:50 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9CA87B2D;
        Tue, 14 Jul 2020 14:10:47 +0200 (CEST)
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
Subject: [PATCH v4 27/75] x86/idt: Move IDT to data segment
Date:   Tue, 14 Jul 2020 14:08:29 +0200
Message-Id: <20200714120917.11253-28-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 0db21206f2f3..b920f2352df5 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -158,7 +158,7 @@ static const __initconst struct idt_data apic_idts[] = {
 };
 
 /* Must be page-aligned because the real IDT is used in the cpu entry area */
-static gate_desc idt_table[IDT_ENTRIES] __page_aligned_bss;
+static gate_desc idt_table[IDT_ENTRIES] __page_aligned_data;
 
 struct desc_ptr idt_descr __ro_after_init = {
 	.size		= IDT_TABLE_SIZE - 1,
-- 
2.27.0

