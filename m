Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E421F1A1B69
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgDHFHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:07:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgDHFF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038544lW191251;
        Wed, 8 Apr 2020 05:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Q/x63j7IF9jNQkX6xMMSEc7WXp2MrGiG0gMNWP0OfWM=;
 b=ECcLHHKM1Y3f/mNjqQHcNekCfZwy7o5zdSSQAxLfqjPZMM2CwYlwO9ziEEQME73MsHEU
 L++tyOqLrBEz+TPthoQ2QMk9tFdULvWDh4X7mSjd1qCUoYVZk28ix7ZtaRdJ1F2vD2PG
 eMan5188ae3P/oVnDlkKI+g407m/RDHzMPH9B1nDUdn9BJAV5875XtLNojw57f/axCcB
 AQtKmdYasSQzu01XH4kHhT8ck/rfDnFf6wPrMCXiNGxOZ70jmj13uXWotmQoRbM+QzS6
 IgK8/idFBsVRyi7CG4lOSpSf8+0yp0jR+s01UpXhsN41QuU9tT4s+LayyeXT4pPfCgK2 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3091m0s0s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853Kcm158669;
        Wed, 8 Apr 2020 05:05:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3091m01frk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:08 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 038557fF007332;
        Wed, 8 Apr 2020 05:05:07 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:07 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 07/26] x86/paravirt: Persist .parainstructions.runtime
Date:   Tue,  7 Apr 2020 22:03:04 -0700
Message-Id: <20200408050323.4237-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
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

Persist .parainstructions.runtime in memory. We will use it to
patch paravirt-ops at runtime.

The extra memory footprint depends on chosen config options but the
inlined queued_spin_unlock() presents an edge case:

 $ objdump -h vmlinux|grep .parainstructions
 Idx Name              		Size      VMA
 	LMA                File-off  Algn
  27 .parainstructions 		0001013c  ffffffff82895000
  	0000000002895000   01c95000  2**3
  28 .parainstructions.runtime  0000cd2c  ffffffff828a5140
  	00000000028a5140   01ca5140  2**3

(The added footprint is the size of the .parainstructions.runtime
section.)

  $ size vmlinux
  text       data       bss        dec      hex       filename
  13726196   12302814   14094336   40123346 2643bd2   vmlinux

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/alternative.h |  1 +
 arch/x86/kernel/alternative.c      | 16 +++++++++++++++-
 arch/x86/kernel/module.c           | 28 +++++++++++++++++++++++-----
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index db91a7731d87..d19546c14ff6 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -76,6 +76,7 @@ extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 struct module;
 
 void alternatives_module_add(struct module *mod, char *name,
+			     void *para, void *para_end,
 			     void *locks, void *locks_end,
 			     void *text, void *text_end);
 void alternatives_module_del(struct module *mod);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 09e4ee0e09a2..8189ac21624c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -482,6 +482,12 @@ struct alt_module {
 	struct module	*mod;
 	char		*name;
 
+#ifdef CONFIG_PARAVIRT_RUNTIME
+	/* ptrs to paravirt sites */
+	struct paravirt_patch_site *para;
+	struct paravirt_patch_site *para_end;
+#endif
+
 	/* ptrs to lock prefixes */
 	const s32	*locks;
 	const s32	*locks_end;
@@ -496,6 +502,7 @@ struct alt_module {
 static LIST_HEAD(alt_modules);
 
 void __init_or_module alternatives_module_add(struct module *mod, char *name,
+					      void *para, void *para_end,
 					      void *locks, void *locks_end,
 					      void *text,  void *text_end)
 {
@@ -506,7 +513,7 @@ void __init_or_module alternatives_module_add(struct module *mod, char *name,
 	if (!noreplace_smp && (num_present_cpus() == 1 || setup_max_cpus <= 1))
 		uniproc_patched = true;
 #endif
-	if (!uniproc_patched)
+	if (!IS_ENABLED(CONFIG_PARAVIRT_RUNTIME) && !uniproc_patched)
 		return;
 
 	mutex_lock(&text_mutex);
@@ -516,6 +523,11 @@ void __init_or_module alternatives_module_add(struct module *mod, char *name,
 	alt->mod	= mod;
 	alt->name	= name;
 
+#ifdef CONFIG_PARAVIRT_RUNTIME
+	alt->para	= para;
+	alt->para_end	= para_end;
+#endif
+
 	if (num_possible_cpus() != 1 || uniproc_patched) {
 		/* Remember only if we'll need to undo it. */
 		alt->locks	= locks;
@@ -733,6 +745,8 @@ void __init alternative_instructions(void)
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
 	alternatives_module_add(NULL, "core kernel",
+				__parainstructions_runtime,
+				__parainstructions_runtime_end,
 				__smp_locks, __smp_locks_end,
 				_text, _etext);
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index fc3d35198b09..7b2632184c11 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -248,12 +248,30 @@ int module_finalize(const Elf_Ehdr *hdr,
 		void *aseg = (void *)alt->sh_addr;
 		apply_alternatives(aseg, aseg + alt->sh_size);
 	}
-	if (locks && text) {
-		void *lseg = (void *)locks->sh_addr;
-		void *tseg = (void *)text->sh_addr;
+	if (para_run || (locks && text)) {
+		void *pseg, *pseg_end;
+		void *lseg, *lseg_end;
+		void *tseg, *tseg_end;
+
+		pseg = pseg_end = NULL;
+		lseg = lseg_end = NULL;
+		tseg = tseg_end = NULL;
+		if (para_run) {
+			pseg = (void *)para_run->sh_addr;
+			pseg_end = pseg + para_run->sh_size;
+		}
+
+		if (locks && text) {
+			tseg = (void *)text->sh_addr;
+			tseg_end = tseg + text->sh_size;
+
+			lseg = (void *)locks->sh_addr;
+			lseg_end = lseg + locks->sh_size;
+		}
 		alternatives_module_add(me, me->name,
-					lseg, lseg + locks->sh_size,
-					tseg, tseg + text->sh_size);
+					pseg, pseg_end,
+					lseg, lseg_end,
+					tseg, tseg_end);
 	}
 
 	if (para) {
-- 
2.20.1

