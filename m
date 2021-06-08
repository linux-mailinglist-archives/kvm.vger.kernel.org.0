Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D6B39F2F5
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 11:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhFHJ4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 05:56:39 -0400
Received: from 8bytes.org ([81.169.241.247]:42808 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230261AbhFHJ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 05:56:39 -0400
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 91B0A386;
        Tue,  8 Jun 2021 11:54:44 +0200 (CEST)
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
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v3 1/7] x86/ioremap: Map efi_mem_reserve() memory as encrypted for SEV
Date:   Tue,  8 Jun 2021 11:54:33 +0200
Message-Id: <20210608095439.12668-2-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608095439.12668-1-joro@8bytes.org>
References: <20210608095439.12668-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Some drivers require memory that is marked as EFI boot services data. So that
this memory is not re-used by the kernel after ExitBootServices(),
efi_mem_reserve() is used to preserve it by inserting a new EFI memory
descriptor and marking it with the EFI_MEMORY_RUNTIME attribute.

Under SEV, memory marked with the EFI_MEMORY_RUNTIME attribute needs to
be mapped encrypted by Linux, otherwise the kernel might crash at boot
like below:

 EFI Variables Facility v0.08 2004-May-17
 general protection fault, probably for non-canonical address 0x3597688770a868b2: 0000 [#1] SMP NOPTI
 CPU: 13 PID: 1 Comm: swapper/0 Not tainted 5.12.4-2-default #1 openSUSE Tumbleweed
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 RIP: 0010:efi_mokvar_entry_next+0x34/0x40
 Code: c5 01 48 8b 17 48 c7 07 00 00 00 00 48 85 c0 74 24 48 85 d2 74 14 80 3a 00 74 18 48 8b 82 00 01 00 00 48 8d 84 02 08 01 00 00 <80> 38 00 74 04 48 89 07 c3 31 c0 c3 0f 1f 44 00 00 41 54 4c 8b 25
 [...]
 Call Trace:
  efi_mokvar_sysfs_init
  ? efi_mokvar_table_init
  do_one_initcall
  ? __kmalloc
  kernel_init_freeable
  ? rest_init
  kernel_init
  ret_from_fork
 Modules linked in:
 ---[ end trace 0de27ecc25d41b73 ]---

Expand the __ioremap_check_other() function to additionally check for this
other type of "runtime" data and indicate that it should be mapped encrypted
for an SEV guest.

Fixes: 58c909022a5a ("efi: Support for MOK variable config table")
Reported-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/mm/ioremap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12c686c65ea9..60ade7dd71bd 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -118,7 +118,9 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA)
+	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA ||
+	    (efi_mem_type(addr) == EFI_BOOT_SERVICES_DATA &&
+	     efi_mem_attributes(addr) & EFI_MEMORY_RUNTIME))
 		desc->flags |= IORES_MAP_ENCRYPTED;
 }
 
-- 
2.31.1

