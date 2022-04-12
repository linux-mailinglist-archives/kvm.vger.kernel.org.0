Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BA04FE728
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346507AbiDLRga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358317AbiDLRg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:36:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991465FE5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:34:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C3ABC1F858;
        Tue, 12 Apr 2022 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvUsZfwIL9Qpdua+ZRp1gB21bGhaqwBGI5AuTGyAQqs=;
        b=MogfAY8wsyszfMZD3+NGm7FL7Q9QN2lsrJ048IJBMZ2T+hIhF3ibTBNDnEJdQoNaHJmB8N
        mnVTLEqzZ/3K+ZGagV9MrKLrk7Ufc5zDUQ2++d4DrV02MARfTTkFkxVBt4LDecwogg8zS0
        sVv1rYtN1WZMB+aROQ9swOv+8rNg5fg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3BC9813780;
        Tue, 12 Apr 2022 17:34:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KPSkDA64VWLAewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:34:06 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 03/10] x86: desc: Split IDT entry setup into a generic helper
Date:   Tue, 12 Apr 2022 19:34:00 +0200
Message-Id: <20220412173407.13637-4-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173407.13637-1-varad.gautam@suse.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFI bootstrapping code configures a call gate in a later commit to jump
from 16-bit to 32-bit code.

Introduce a set_idt_entry_t() routine which can be used to fill both
an interrupt descriptor and a call gate descriptor on x86.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/desc.c | 28 ++++++++++++++++++++++------
 lib/x86/desc.h |  1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 087e85c..049adeb 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -57,22 +57,38 @@ __attribute__((regparm(1)))
 #endif
 void do_handle_exception(struct ex_regs *regs);
 
-void set_idt_entry(int vec, void *addr, int dpl)
+/*
+ * Fill an idt_entry_t, clearing e_sz bytes first.
+ *
+ * This can also be used to set up x86 call gates, since the gate
+ * descriptor layout is identical to idt_entry_t, except for the
+ * absence of .offset2 and .reserved fields. To do so, pass in e_sz
+ * according to the gate descriptor size.
+ */
+void set_idt_entry_t(idt_entry_t *e, size_t e_sz, void *addr,
+		u16 sel, u16 type, u16 dpl)
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
+	if (e_sz == sizeof(*e)) {
+		e->offset2 = (unsigned long)addr >> 32;
+	}
 #endif
 }
 
+void set_idt_entry(int vec, void *addr, int dpl)
+{
+	idt_entry_t *e = &boot_idt[vec];
+	set_idt_entry_t(e, sizeof *e, addr, read_cs(), 14, dpl);
+}
+
 void set_idt_dpl(int vec, u16 dpl)
 {
 	idt_entry_t *e = &boot_idt[vec];
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 3044409..ae0928f 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -217,6 +217,7 @@ unsigned exception_vector(void);
 int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
+void set_idt_entry_t(idt_entry_t *e, size_t e_sz, void *addr, u16 sel, u16 type, u16 dpl);
 void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
-- 
2.32.0

