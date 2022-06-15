Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8776E54D545
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348243AbiFOXaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348173AbiFOXaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:30:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8684213E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c4-20020a170902d48400b001640bfb2b4fso7248261plg.20
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NAYu/p++KbYQKAixptTixDluswnneyi65Qx5LtCiF4Q=;
        b=mEzQoZmMyBjJ/XTXXmFSR6U6gQLEhjwjSPEiLW45ounxRqklw3lMszhk3VvNt9ml7c
         uiXOys2f+dCEsYX2EaLc+uYrU326AG2Oilx8Fmk9vJHF5d4khbkicE3w0t/xsxOPK8c0
         ZUyjpypfXhLOH6XaHYXChpeX56NGaw4/GYS91uQ0zNrUY7ZACerOYtkw9u3q01ilLoyU
         ALON4bw9yZpZ1wBDhaAZb6tkuInXXhwygPciQ8TXaHnbNDwBbLxR/PCHsdGuL8mr6LpB
         O0rZ5hAXMx9QhOPGVApzVyAJznf1vIjR4t3aCB2jT5d6ks0gH5SfNhtJHs3nP/dl9fZ5
         vxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NAYu/p++KbYQKAixptTixDluswnneyi65Qx5LtCiF4Q=;
        b=pKcDUSgPbdQkDOiPi8zE/lG2k14plBGdVFtvlfFaH1F33OVYy9oYS49OY7BzsTJbIq
         sy0KjGUu+Iewjj0LhkoGfGFledmPQxjm9Cl40VfCXsKlEUk3jraLK815NkpQD9Xc0Ka2
         59oW4a/GrDWzntul4MaOrrXZZoRTG8GU7RTpN09wUe40tIjxIIIK78XQBqVxAW8j7inP
         NS93sdu267wdrz/KoOH672zqBiiQAawDBFvI0UE0OYvIa6kySKXdoE9kD1GFLBKTDPIi
         /747JSO+H8diGBL+6mQ1LXcXEZmZwi4TzMyXwuIdP9mqn3E1MCAIX1Fo09rEa3HGgGuz
         Ke+g==
X-Gm-Message-State: AJIora/n5MYsU2YoadKWXvG3iLtUsqd1ZGy2mOrBKlDusbF594ch1gm1
        MymGjEyMNHYsTp/yedQMQvibEa/yqGQ=
X-Google-Smtp-Source: AGRyM1ul/GbgiEo77mjIG6Tvgrlwl2QDswwsE2i/gweEfPxZ4ZLtukTi1+JKDm+oyR3EDWlET4dHj7PoqWk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b48:b0:1e8:7df8:1e25 with SMTP id
 mi8-20020a17090b4b4800b001e87df81e25mr1915351pjb.186.1655335799016; Wed, 15
 Jun 2022 16:29:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:35 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 05/13] x86: desc: Split IDT entry setup into
 a generic helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>

EFI bootstrapping code configures a call gate in a later commit to jump
from 16-bit to 32-bit code.

Introduce a set_desc_entry() routine which can be used to fill both
an interrupt descriptor and a call gate descriptor on x86.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 27 +++++++++++++++++++++------
 lib/x86/desc.h |  2 ++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 087e85c..9512363 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -57,22 +57,37 @@ __attribute__((regparm(1)))
 #endif
 void do_handle_exception(struct ex_regs *regs);
 
-void set_idt_entry(int vec, void *addr, int dpl)
+/*
+ * Fill an idt_entry_t or call gate entry, clearing e_sz bytes first.
+ *
+ * This can be used for both IDT entries and call gate entries, since the gate
+ * descriptor layout is identical to idt_entry_t, except for the absence of
+ * .offset2 and .reserved fields. To do so, pass in e_sz according to the gate
+ * descriptor size.
+ */
+void set_desc_entry(idt_entry_t *e, size_t e_sz, void *addr,
+		    u16 sel, u16 type, u16 dpl)
 {
-	idt_entry_t *e = &boot_idt[vec];
-	memset(e, 0, sizeof *e);
+	memset(e, 0, e_sz);
 	e->offset0 = (unsigned long)addr;
-	e->selector = read_cs();
+	e->selector = sel;
 	e->ist = 0;
-	e->type = 14;
+	e->type = type;
 	e->dpl = dpl;
 	e->p = 1;
 	e->offset1 = (unsigned long)addr >> 16;
 #ifdef __x86_64__
-	e->offset2 = (unsigned long)addr >> 32;
+	if (e_sz == sizeof(*e))
+		e->offset2 = (unsigned long)addr >> 32;
 #endif
 }
 
+void set_idt_entry(int vec, void *addr, int dpl)
+{
+	idt_entry_t *e = &boot_idt[vec];
+	set_desc_entry(e, sizeof *e, addr, read_cs(), 14, dpl);
+}
+
 void set_idt_dpl(int vec, u16 dpl)
 {
 	idt_entry_t *e = &boot_idt[vec];
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 3044409..1dc1ea0 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -217,6 +217,8 @@ unsigned exception_vector(void);
 int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
+void set_desc_entry(idt_entry_t *e, size_t e_sz, void *addr,
+		    u16 sel, u16 type, u16 dpl);
 void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
-- 
2.36.1.476.g0c4daa206d-goog

