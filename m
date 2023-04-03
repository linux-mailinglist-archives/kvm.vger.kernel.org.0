Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD826D4673
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjDCOFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjDCOFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:05:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BD227825;
        Mon,  3 Apr 2023 07:05:10 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q102so27289296pjq.3;
        Mon, 03 Apr 2023 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pP1y+2npNFi89ug0/IC9s4GPFuEkE96kXvViHM8S82Y=;
        b=LYgZJSU2LQVRKrVl3gJ6LmbsVBK8qTWoaiMbyLBWehqV4nTSQiAgTT3PYjLLV4+aRl
         U/o2j8y3HhKy0BXoBFaF91+h1zy+ksM1f5aJ9S4ql1WBgMBz3UXtr2MiXM2Oqk+CK9Bh
         FpVuJHo+ShHAPoJPVbr1/j76Tn0xm9zDBoofWk1lh+VyAVl/OMjaduJ/HPanBKTvzPK5
         w/3MvnrMud4MqCovVyBgPjuXkhxKBF3jEvDvzwRM1AVOIlg+3yXdxjK+D1u8spJ+bjpo
         0i99aQYTXGrHlujBFga9HLJn/awlfmA7b9pLZkKhysVnQua51WB9SVYgu/B7BPwYOvba
         Yd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pP1y+2npNFi89ug0/IC9s4GPFuEkE96kXvViHM8S82Y=;
        b=nwAK7cguxb7/Pwc+zB6WxBgOrgFY/3Pr5KD8a/6iqwCY3VTecyU/kUhZi3zqmN5cpl
         n6RltTj2Oq7v/m+dIRP5NPHtMSyYgZJ3kebwUv1ZDz41GMQF3J5Io92+E4Gna+bvcc7V
         gE1Mt8fUx+t0PmONUSJc8H0yp/VH83i9T7rUOBh1ahGJphGehpEA0K0pGm3j0ivOCZBo
         40hHQFhz5IXn1xN+T3OJGjyg2oMcX4Rd1hvrBaxorQgFPm6MgdhijKfthMLGBvmc8rtq
         EnxgojfPDLps4aDgYwVB0EgQCqIRXFzOfiA0MjCZ8M663xA2zcb7aa8mzgeibJ6Wa/eb
         TBRA==
X-Gm-Message-State: AAQBX9cfzaZmYW+mokRoHHUq5kb3bB4e4fC7KCGJanSZPIoto66xP6QL
        RMUNCV6GuzfGlgEg0h/z2oAjL7AWFQw=
X-Google-Smtp-Source: AKy350ZPMTNT8j/gFua35RH6Y9rBKALeYSJ1nl6jWYeCMkrNYNAcbUZmVOrD3GaqTK0xuYAKNZrY2A==
X-Received: by 2002:a17:902:fa8d:b0:19f:30be:ea0d with SMTP id lc13-20020a170902fa8d00b0019f30beea0dmr30070199plb.62.1680530709345;
        Mon, 03 Apr 2023 07:05:09 -0700 (PDT)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902a60800b001a045f45d49sm6638401plq.281.2023.04.03.07.05.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:08 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: [RFC PATCH 2/7] x86/entry: Add IST main stack
Date:   Mon,  3 Apr 2023 22:06:00 +0800
Message-Id: <20230403140605.540512-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230403140605.540512-1-jiangshanlai@gmail.com>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Add IST main stack for atomic-IST-entry.

The size is THREAD_SIZE since there might be multiple super
exceptions being handled on the stack.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 Documentation/x86/kernel-stacks.rst   | 2 ++
 arch/x86/include/asm/cpu_entry_area.h | 5 +++++
 arch/x86/kernel/dumpstack_64.c        | 6 ++++--
 arch/x86/mm/cpu_entry_area.c          | 1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/kernel-stacks.rst b/Documentation/x86/kernel-stacks.rst
index 6b0bcf027ff1..be89acf302da 100644
--- a/Documentation/x86/kernel-stacks.rst
+++ b/Documentation/x86/kernel-stacks.rst
@@ -105,6 +105,8 @@ The currently assigned IST stacks are:
   middle of switching stacks.  Using IST for MCE events avoids making
   assumptions about the previous state of the kernel stack.
 
+* ESTACK_IST. bla bla
+
 For more details see the Intel IA32 or AMD AMD64 architecture manuals.
 
 
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 462fc34f1317..a373e8c37e25 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -10,6 +10,8 @@
 
 #ifdef CONFIG_X86_64
 
+#define IST_MAIN_STKSZ	THREAD_SIZE
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define VC_EXCEPTION_STKSZ	EXCEPTION_STKSZ
 #else
@@ -30,6 +32,8 @@
 	char	VC_stack[optional_stack_size];			\
 	char	VC2_stack_guard[guardsize];			\
 	char	VC2_stack[optional_stack_size];			\
+	char	IST_stack_guard[guardsize];			\
+	char	IST_stack[IST_MAIN_STKSZ];			\
 	char	IST_top_guard[guardsize];			\
 
 /* The exception stacks' physical storage. No guard pages required */
@@ -52,6 +56,7 @@ enum exception_stack_ordering {
 	ESTACK_MCE,
 	ESTACK_VC,
 	ESTACK_VC2,
+	ESTACK_IST,
 	N_EXCEPTION_STACKS
 };
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index f05339fee778..3413b23fa9f1 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -26,11 +26,12 @@ static const char * const exception_stack_names[] = {
 		[ ESTACK_MCE	]	= "#MC",
 		[ ESTACK_VC	]	= "#VC",
 		[ ESTACK_VC2	]	= "#VC2",
+		[ ESTACK_IST	]	= "#IST",
 };
 
 const char *stack_type_name(enum stack_type type)
 {
-	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
+	BUILD_BUG_ON(N_EXCEPTION_STACKS != ARRAY_SIZE(exception_stack_names));
 
 	if (type == STACK_TYPE_TASK)
 		return "TASK";
@@ -89,6 +90,7 @@ struct estack_pages estack_pages[CEA_ESTACK_PAGES] ____cacheline_aligned = {
 	EPAGERANGE(MCE),
 	EPAGERANGE(VC),
 	EPAGERANGE(VC2),
+	EPAGERANGE(IST),
 };
 
 static __always_inline bool in_exception_stack(unsigned long *stack, struct stack_info *info)
@@ -98,7 +100,7 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
 	struct pt_regs *regs;
 	unsigned int k;
 
-	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
+	BUILD_BUG_ON(N_EXCEPTION_STACKS != 7);
 
 	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
 	/*
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 7316a8224259..62341cb819ab 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -148,6 +148,7 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 	cea_map_stack(NMI);
 	cea_map_stack(DB);
 	cea_map_stack(MCE);
+	cea_map_stack(IST);
 
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
 		if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
-- 
2.19.1.6.gb485710b

