Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70D18AF54
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgCSJPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:15:39 -0400
Received: from 8bytes.org ([81.169.241.247]:51922 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbgCSJOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:49 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id EA96BEEE; Thu, 19 Mar 2020 10:14:28 +0100 (CET)
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
Subject: [PATCH 68/70] x86/sev-es: Support CPU offline/online
Date:   Thu, 19 Mar 2020 10:14:05 +0100
Message-Id: <20200319091407.1481-69-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add a play_dead handler when running under SEV-ES. This is needed
because the hypervisor can't deliver an SIPI request to restart the AP.
Instead the kernel has to issue a VMGEXIT to halt the VCPU. When the
hypervisor would deliver and SIPI is wakes up the VCPU instead.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kernel/sev-es.c        | 58 +++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index a19ce9681ec2..20a05839dd9a 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -84,6 +84,7 @@
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
 #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
+#define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
 #define		SVM_VMGEXIT_GET_AP_JUMP_TABLE			1
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index f56bdaf12fbe..3c22f256645e 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -23,6 +23,8 @@
 #include <asm/processor.h>
 #include <asm/traps.h>
 #include <asm/svm.h>
+#include <asm/smp.h>
+#include <asm/cpu.h>
 
 #define DR7_RESET_VALUE        0x400
 
@@ -381,6 +383,60 @@ static bool __init sev_es_setup_ghcb(void)
 	return true;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static void sev_es_ap_hlt_loop(void)
+{
+	struct ghcb_state state;
+	struct ghcb *ghcb;
+
+	ghcb = sev_es_get_ghcb(&state);
+
+	while (true) {
+		vc_ghcb_invalidate(ghcb);
+		ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_HLT_LOOP);
+		ghcb_set_sw_exit_info_1(ghcb, 0);
+		ghcb_set_sw_exit_info_2(ghcb, 0);
+
+		sev_es_wr_ghcb_msr(__pa(ghcb));
+		VMGEXIT();
+
+		/* Wakup Signal? */
+		if (ghcb_is_valid_sw_exit_info_2(ghcb) &&
+		    ghcb->save.sw_exit_info_2 != 0)
+			break;
+	}
+
+	sev_es_put_ghcb(&state);
+}
+
+void sev_es_play_dead(void)
+{
+	play_dead_common();
+
+	/* IRQs now disabled */
+
+	sev_es_ap_hlt_loop();
+
+	/*
+	 * If we get here, the VCPU was woken up again. Jump to CPU
+	 * startup code to get it back online.
+	 */
+
+	start_cpu();
+}
+#else  /* CONFIG_HOTPLUG_CPU */
+#define sev_es_play_dead	native_play_dead
+#endif /* CONFIG_HOTPLUG_CPU */
+
+#ifdef CONFIG_SMP
+static void sev_es_setup_play_dead(void)
+{
+	smp_ops.play_dead = sev_es_play_dead;
+}
+#else
+static inline void sev_es_setup_play_dead(void) { }
+#endif
+
 void sev_es_init_ghcbs(void)
 {
 	int cpu;
@@ -399,6 +455,8 @@ void sev_es_init_ghcbs(void)
 				     sizeof(*ghcb) >> PAGE_SHIFT);
 		memset(ghcb, 0, sizeof(*ghcb));
 	}
+
+	sev_es_setup_play_dead();
 }
 
 static void __init vc_early_vc_forward_exception(struct es_em_ctxt *ctxt)
-- 
2.17.1

