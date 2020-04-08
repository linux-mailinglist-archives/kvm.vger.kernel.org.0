Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFAA1A1B65
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgDHFHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:07:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgDHFF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853kJT191170;
        Wed, 8 Apr 2020 05:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YqkpSF+xaj87ukpBfxxbSQruerieQm4kGvLikr6EByg=;
 b=JdkjanUuxwOILdkRa92kgljdqWjdgneiBkVZJxAeqNWM1rn046UVVjh8q+hLyr1jCaw5
 efBQTN7ituKdbN9KZYhmSd6bCobGZy4Ai8YbCGV7w+NxE1HICzDkva4dKA2R+PUxPIzC
 shywYoahTgQ9oCJkap9TlaUAxYpHeIGVf+XMEFvzEXjWP7PfrP/slqcx10d7fz1KStg2
 kcTlKOfFWU0p6o2YZbGTWkmxDBVRKFs1+6jB2CTRjJvQ3gD2DZgw1BPb+x1v8dy4x7qv
 J0Dv+ro6jQX3SXKG0NtTYkrxjdavZEFEdN+7kyhodZuYxmp5MbHHWuEIxUhLyQuwPcF6 vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3091m0s0rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852XPH062239;
        Wed, 8 Apr 2020 05:05:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3091mh1k6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03854w5i030423;
        Wed, 8 Apr 2020 05:04:59 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:04:57 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 02/26] x86/paravirt: Allow paravirt patching post-init
Date:   Tue,  7 Apr 2020 22:02:59 -0700
Message-Id: <20200408050323.4237-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paravirt-ops are patched at init to convert indirect calls into
direct calls and in some cases, to inline the target at the call-site.
This is done by way of PVOP* macros which save the call-site
information via compile time annotations.

Pull this state out in .parainstructions.runtime for some pv-ops such
that they can be used for runtime patching.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig                      | 12 ++++++++++++
 arch/x86/include/asm/paravirt_types.h |  5 +++++
 arch/x86/include/asm/text-patching.h  |  5 +++++
 arch/x86/kernel/alternative.c         |  2 ++
 arch/x86/kernel/module.c              | 10 +++++++++-
 arch/x86/kernel/vmlinux.lds.S         | 16 ++++++++++++++++
 include/asm-generic/vmlinux.lds.h     |  8 ++++++++
 7 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1edf788d301c..605619938f08 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -764,6 +764,18 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
+config PARAVIRT_RUNTIME
+	bool "Enable paravirtualized ops to be patched at runtime"
+	depends on PARAVIRT
+	help
+	  Enable the paravirtualized guest kernel to switch pv-ops based on
+	  changed host conditions, potentially improving performance
+	  significantly.
+
+	  This would increase the memory footprint of the running kernel
+	  slightly (depending mostly on whether lock and unlock are inlined
+	  or not.)
+
 config PARAVIRT_XXL
 	bool
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 37e8f27a3b9d..00e4a062ca10 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -723,6 +723,11 @@ struct paravirt_patch_site {
 extern struct paravirt_patch_site __parainstructions[],
 	__parainstructions_end[];
 
+#ifdef CONFIG_PARAVIRT_RUNTIME
+extern struct paravirt_patch_site __parainstructions_runtime[],
+	__parainstructions_runtime_end[];
+#endif
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* _ASM_X86_PARAVIRT_TYPES_H */
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index 67315fa3956a..e2ef241c261e 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -18,6 +18,11 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
+#ifndef CONFIG_PARAVIRT_RUNTIME
+#define __parainstructions_runtime	NULL
+#define __parainstructions_runtime_end	NULL
+#endif
+
 /*
  * Currently, the max observed size in the kernel code is
  * JUMP_LABEL_NOP_SIZE/RELATIVEJUMP_SIZE, which are 5.
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7867dfb3963e..fdfda1375f82 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -740,6 +740,8 @@ void __init alternative_instructions(void)
 #endif
 
 	apply_paravirt(__parainstructions, __parainstructions_end);
+	apply_paravirt(__parainstructions_runtime,
+		       __parainstructions_runtime_end);
 
 	restart_nmi();
 	alternatives_patched = 1;
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index d5c72cb877b3..658ea60ce324 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -222,7 +222,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    struct module *me)
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
-		*para = NULL, *orc = NULL, *orc_ip = NULL;
+		*para = NULL, *para_run = NULL, *orc = NULL, *orc_ip = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
 	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
@@ -234,6 +234,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
+		if (!strcmp(".parainstructions.runtime",
+			    secstrings + s->sh_name))
+			para_run = s;
 		if (!strcmp(".orc_unwind", secstrings + s->sh_name))
 			orc = s;
 		if (!strcmp(".orc_unwind_ip", secstrings + s->sh_name))
@@ -257,6 +260,11 @@ int module_finalize(const Elf_Ehdr *hdr,
 		void *pseg = (void *)para->sh_addr;
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
+	if (para_run) {
+		void *pseg = (void *)para_run->sh_addr;
+
+		apply_paravirt(pseg, pseg + para_run->sh_size);
+	}
 
 	/* make jump label nops */
 	jump_label_apply_nops(me);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1bf7e312361f..7f5b8f6ab96e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -269,6 +269,7 @@ SECTIONS
 	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
 		__parainstructions = .;
 		*(.parainstructions)
+		PARAVIRT_DISCARD(.parainstructions.runtime)
 		__parainstructions_end = .;
 	}
 
@@ -348,6 +349,21 @@ SECTIONS
 		__smp_locks_end = .;
 	}
 
+#ifdef CONFIG_PARAVIRT_RUNTIME
+	/*
+	 * .parainstructions.runtime sticks around in memory after
+	 * init so it doesn't need to be page-aligned but everything
+	 * around us is so we will be too.
+	 */
+	. = ALIGN(8);
+	.parainstructions.runtime : AT(ADDR(.parainstructions.runtime) - \
+								LOAD_OFFSET) {
+		__parainstructions_runtime = .;
+		PARAVIRT_KEEP(.parainstructions.runtime)
+		__parainstructions_runtime_end = .;
+	}
+#endif
+
 #ifdef CONFIG_X86_64
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
 		NOSAVE_DATA
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 71e387a5fe90..6b009d5ce51f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -135,6 +135,14 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#if defined(CONFIG_PARAVIRT_RUNTIME)
+#define PARAVIRT_KEEP(sec)	*(sec)
+#define PARAVIRT_DISCARD(sec)
+#else
+#define PARAVIRT_KEEP(sec)
+#define PARAVIRT_DISCARD(sec)	*(sec)
+#endif
+
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 /*
  * The ftrace call sites are logged to a section whose name depends on the
-- 
2.20.1

