Return-Path: <kvm+bounces-4604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E08815822
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 08:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66A551F25900
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 07:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E14113AC0;
	Sat, 16 Dec 2023 07:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lyoqq0er"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5548B134AC;
	Sat, 16 Dec 2023 07:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702710164; x=1734246164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lOQJTvu9nXAtsh+1v9ZBLjUIH0wLI8goSM/VimYjQg0=;
  b=lyoqq0erprMjal/lc/LfkIREVN2xRaV/rQKtrMyh8Cms+8N04FCuUKVB
   TZ7u7S4J5eZ4jA66yiVI5YOp16X0MGqRDQsPkY8SANsZhqcfy3GbRX/G7
   jEw0VcMppScveAc2OuAm2iWfmNpBNnj1i50TIuJ5AMAY/MotN+KnlG1NG
   IOL2OjeWrSvzlfTgz8nHqPwPyC/e2QJc9dcl9RVMFejsHEZqbTff7p9ws
   cIgRF2eGWvyVSKP84XydYhSlbVIl3jw8cwO4L6jx+QsLfYP1VP28gsFU0
   xJmyb7Nhb8/1FQprP2pTmFoWqAkj8fzX8TczIkpa5kohAE0smF6lUu3mu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10925"; a="375515993"
X-IronPort-AV: E=Sophos;i="6.04,281,1695711600"; 
   d="scan'208";a="375515993"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 23:02:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10925"; a="893168964"
X-IronPort-AV: E=Sophos;i="6.04,281,1695711600"; 
   d="scan'208";a="893168964"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 15 Dec 2023 23:02:42 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13A 24/35] x86/fred: Add a NMI entry stub for FRED
Date: Fri, 15 Dec 2023 22:31:39 -0800
Message-ID: <20231216063139.25567-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SA1PR11MB673465C969A6554B8574157EA893A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <SA1PR11MB673465C969A6554B8574157EA893A@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

On a FRED system, NMIs nest both with themselves and faults, transient
information is saved into the stack frame, and NMI unblocking only
happens when the stack frame indicates that so should happen.

Thus, the NMI entry stub for FRED is really quite small...

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v13:
* Save and restore %cr2 upon entering and leaving the FRED NMI handler
  (H. Peter Anvin).
* Remove an unnecessary check "IS_ENABLED(CONFIG_SMP)" (H. Peter Anvin).
* Sync a microcode change to the IDT NMI handler from 8f849ff63bcbc to
  the FRED NMI handler.
---
 arch/x86/kernel/nmi.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 17e955ab69fe..1dd8838e5583 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -35,6 +35,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/microcode.h>
 #include <asm/sev.h>
+#include <asm/fred.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -651,6 +652,41 @@ void nmi_backtrace_stall_check(const struct cpumask *btp)
 
 #endif
 
+#ifdef CONFIG_X86_FRED
+/*
+ * With FRED, CR2/DR6 is pushed to #PF/#DB stack frame during FRED
+ * event delivery, i.e., there is no problem of transient states.
+ * And NMI unblocking only happens when the stack frame indicates
+ * that so should happen.
+ *
+ * Thus, the NMI entry stub for FRED is really straightforward and
+ * as simple as most exception handlers. As such, #DB is allowed
+ * during NMI handling.
+ */
+DEFINE_FREDENTRY_NMI(exc_nmi)
+{
+	irqentry_state_t irq_state;
+
+	if (arch_cpu_is_offline(smp_processor_id())) {
+		if (microcode_nmi_handler_enabled())
+			microcode_offline_nmi_handler();
+		return;
+	}
+
+	this_cpu_write(nmi_cr2, read_cr2());
+
+	irq_state = irqentry_nmi_enter(regs);
+
+	inc_irq_stat(__nmi_count);
+	default_do_nmi(regs);
+
+	irqentry_nmi_exit(regs, irq_state);
+
+	if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))
+		write_cr2(this_cpu_read(nmi_cr2));
+}
+#endif
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
-- 
2.43.0


