Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03136C153
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 10:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhD0Izl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 04:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhD0Izl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 04:55:41 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C7FC061574;
        Tue, 27 Apr 2021 01:54:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso6867274pjn.0;
        Tue, 27 Apr 2021 01:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DvudTC2BwHZGDoQJqasDl9cPJYuqaFYI5WCZvH5B/Zw=;
        b=oZTdWHWa9y4vR0NRkwGHue6dwcl2JqZgsg7a6+YjFGuPfYA01jgtr5CG2FVV6JxsZ9
         mypKHQE3nwLiAe0xgegucJmA7TC2ZoXS596vwbQv8YCiSKBLOMOYJ8Im+ZlEXh+zSJ9g
         CHv2PTnEtz7IYhTMf68AtMxtuO4rUylhz0qM2NHyetmNgDmoXfdZvPmgKbnLQf4ilqyT
         H0MgsAj/qVMZiQ9HbXjDKU6nbYGbANvN+DVIMT23z4vlS7QnD53TDBNLTwkBxXpsNpZE
         +KC9qHwy4uf+fbZxJj96Zrs7SPVrj/7U1zxWyVqqlCxxH8NWiTS4Q0V+XrcwxNqP1099
         RhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DvudTC2BwHZGDoQJqasDl9cPJYuqaFYI5WCZvH5B/Zw=;
        b=l+AcO67iwz1+aDetsF0X1LWUlEzl7W/6z8cQ2+ucyYngw6Op/xqmQda+mMkXgJ8HSx
         PJ5MO7xRlY+NOTY3Li9Fs9SpS1H0kMhGB2eCD3raD/t4xG7SJNlyVfb+EIAxSwx0X3Yg
         iZKawFk/UCXv2G98pNbAvyYsidGACWEK6BuIvtylmyaG6Ofv4jJDG46eGqQeuNYsVwTA
         B5qzsPX8rJI5sg1tJWqSF6fsxzOHSrY/E7C9z111YYEv4OUYAw2N2Vq0SXs7fTrr8V7Q
         /XsxMTeDJZ2wGppmA4aYcYBK890sZINHr9iSkY07N2fRrq44bVrLXzpGKxsqnkquOx0f
         pv+Q==
X-Gm-Message-State: AOAM530Z1kHSkAWMbzzsoqNw2huTue0LTGlRFwyUEn1dt0uXitPp2PV9
        909QyrgQfL5eGrVTZkPAhiQ8uINmmZM=
X-Google-Smtp-Source: ABdhPJyED8YOs73pY8DPavmzXj80ySfIXNvSlWASjVV8n8Ia2PPeO5IlLOQb7WEVRwY9uJ/wGmcSPA==
X-Received: by 2002:a17:90b:2393:: with SMTP id mr19mr3656655pjb.24.1619513697046;
        Tue, 27 Apr 2021 01:54:57 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id a65sm1986221pfb.116.2021.04.27.01.54.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Apr 2021 01:54:56 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Jian Cai <caij2003@gmail.com>,
        xen-devel@lists.xenproject.org
Subject: [PATCH 1/4] x86/xen/entry: Rename xenpv_exc_nmi to noist_exc_nmi
Date:   Tue, 27 Apr 2021 07:09:46 +0800
Message-Id: <20210426230949.3561-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210426230949.3561-1-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

There is no any functionality change intended.  Just rename it and
move it to arch/x86/kernel/nmi.c so that we can resue it later in
next patch for early NMI and kvm.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: kvm@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/idtentry.h | 2 +-
 arch/x86/kernel/nmi.c           | 8 ++++++++
 arch/x86/xen/enlighten_pv.c     | 9 +++------
 arch/x86/xen/xen-asm.S          | 2 +-
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index e35e342673c7..5b11d2ddbb5c 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -590,7 +590,7 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 /* NMI */
 DECLARE_IDTENTRY_NMI(X86_TRAP_NMI,	exc_nmi);
 #ifdef CONFIG_XEN_PV
-DECLARE_IDTENTRY_RAW(X86_TRAP_NMI,	xenpv_exc_nmi);
+DECLARE_IDTENTRY_RAW(X86_TRAP_NMI,	noist_exc_nmi);
 #endif
 
 /* #DB */
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index bf250a339655..2b907a76d0a1 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -524,6 +524,14 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 		mds_user_clear_cpu_buffers();
 }
 
+#ifdef CONFIG_XEN_PV
+DEFINE_IDTENTRY_RAW(noist_exc_nmi)
+{
+	/* On Xen PV, NMI doesn't use IST.  The C part is the same as native. */
+	exc_nmi(regs);
+}
+#endif
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4f18cd9eacd8..5efbdb0905b7 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -565,12 +565,6 @@ static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
 
 void noist_exc_debug(struct pt_regs *regs);
 
-DEFINE_IDTENTRY_RAW(xenpv_exc_nmi)
-{
-	/* On Xen PV, NMI doesn't use IST.  The C part is the same as native. */
-	exc_nmi(regs);
-}
-
 DEFINE_IDTENTRY_RAW_ERRORCODE(xenpv_exc_double_fault)
 {
 	/* On Xen PV, DF doesn't use IST.  The C part is the same as native. */
@@ -626,6 +620,9 @@ struct trap_array_entry {
 	.xen		= xen_asm_xenpv_##func,		\
 	.ist_okay	= ist_ok }
 
+/* Alias to make TRAP_ENTRY_REDIR() happy for nmi */
+#define xen_asm_xenpv_exc_nmi	xen_asm_noist_exc_nmi
+
 static struct trap_array_entry trap_array[] = {
 	TRAP_ENTRY_REDIR(exc_debug,			true  ),
 	TRAP_ENTRY_REDIR(exc_double_fault,		true  ),
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 1e626444712b..12e7cbbb2a8d 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -130,7 +130,7 @@ _ASM_NOKPROBE(xen_\name)
 xen_pv_trap asm_exc_divide_error
 xen_pv_trap asm_xenpv_exc_debug
 xen_pv_trap asm_exc_int3
-xen_pv_trap asm_xenpv_exc_nmi
+xen_pv_trap asm_noist_exc_nmi
 xen_pv_trap asm_exc_overflow
 xen_pv_trap asm_exc_bounds
 xen_pv_trap asm_exc_invalid_op
-- 
2.19.1.6.gb485710b

