Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB518CE9D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 14:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgCTNRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 09:17:13 -0400
Received: from 8bytes.org ([81.169.241.247]:54470 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbgCTNRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 09:17:11 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id EDAE0364; Fri, 20 Mar 2020 14:17:09 +0100 (CET)
Date:   Fri, 20 Mar 2020 14:17:07 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: [RFC PATCH v2.1] x86/sev-es: Handle NMI State
Message-ID: <20200320131707.GF5122@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-71-joro@8bytes.org>
 <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 08:35:59AM -0700, Andy Lutomirski wrote:
> 1. Just put the NMI unmask in do_nmi().  The kernel *already* knows
> how to handle running do_nmi() with NMIs unmasked.  This is much, much
> simpler than your code.

Okay, attached is the updated patch which implements this approach. I
tested it in an SEV-ES guest with 'perf top' running for a little more
than 30 minutes and all looked good. I also removed the dead code from
the patch.


From ec3b021c5d9130fd66e00d823c4fabc675c4b49e Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Tue, 28 Jan 2020 17:31:05 +0100
Subject: [PATCH] x86/sev-es: Handle NMI State

When running under SEV-ES the kernel has to tell the hypervisor when to
open the NMI window again after an NMI was injected. This is done with
an NMI-complete message to the hypervisor.

Add code to the kernels NMI handler to send this message right at the
beginning of do_nmi(). This always allows nesting NMIs.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-es.h   |  2 ++
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kernel/nmi.c           |  8 ++++++++
 arch/x86/kernel/sev-es.c        | 18 ++++++++++++++++++
 4 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 63acf50e6280..441ec1ba2cc7 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -82,11 +82,13 @@ struct real_mode_header;
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
+void sev_es_nmi_complete(void);
 #else /* CONFIG_AMD_MEM_ENCRYPT */
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
 {
 	return 0;
 }
+static inline void sev_es_nmi_complete(void) { }
 #endif /* CONFIG_AMD_MEM_ENCRYPT*/
 
 #endif
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 20a05839dd9a..0f837339db66 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -84,6 +84,7 @@
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
 #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
+#define SVM_VMGEXIT_NMI_COMPLETE		0x80000003
 #define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 54c21d6abd5a..fc872a7e0ed1 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -37,6 +37,7 @@
 #include <asm/reboot.h>
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
+#include <asm/sev-es.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -510,6 +511,13 @@ NOKPROBE_SYMBOL(is_debug_stack);
 dotraplinkage notrace void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	/*
+	 * Re-enable NMIs right here when running as an SEV-ES guest. This might
+	 * cause nested NMIs, but those can be handled safely.
+	 */
+	if (sev_es_active())
+		sev_es_nmi_complete();
+
 	if (IS_ENABLED(CONFIG_SMP) && cpu_is_offline(smp_processor_id()))
 		return;
 
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 3c22f256645e..a7e2739771e7 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -270,6 +270,24 @@ static phys_addr_t vc_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
+void sev_es_nmi_complete(void)
+{
+	struct ghcb_state state;
+	struct ghcb *ghcb;
+
+	ghcb = sev_es_get_ghcb(&state);
+
+	vc_ghcb_invalidate(ghcb);
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_NMI_COMPLETE);
+	ghcb_set_sw_exit_info_1(ghcb, 0);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	sev_es_put_ghcb(&state);
+}
+
 static u64 sev_es_get_jump_table_addr(void)
 {
 	struct ghcb_state state;
-- 
2.16.4

