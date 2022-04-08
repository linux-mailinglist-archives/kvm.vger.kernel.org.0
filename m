Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272D44F9303
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbiDHKdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbiDHKde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22C231BBAF
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5184621600;
        Fri,  8 Apr 2022 10:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ajrcFcg4feIDsNdks5z0AMX3rYi1DSPUJay4TEHMDA=;
        b=HAzLzilOknZpBxVdms+olEj/P0t6S5HcPgM9jbZt0YxtvZfyviF0AUeUMSDOcaizJ6D6HJ
        6j5xgv7Dsd0XU3viAI82nq2VpXkxcj2uaxLx0iKRckjqtIp/AT/U9qxlKzBGTVOM2N8aO1
        tQRMs1xot8oIzKdsn+xd3CF0/CmCsSg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A71A9132B9;
        Fri,  8 Apr 2022 10:31:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WDG5Jv4OUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:26 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 3/9] x86: desc: Split IDT entry setup into a generic helper
Date:   Fri,  8 Apr 2022 12:31:21 +0200
Message-Id: <20220408103127.19219-4-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408103127.19219-1-varad.gautam@suse.com>
References: <20220408103127.19219-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
index 355a428..713ad0b 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -56,22 +56,38 @@ __attribute__((regparm(1)))
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
-    idt_entry_t *e = &boot_idt[vec];
-    memset(e, 0, sizeof *e);
+    memset(e, 0, e_sz);
     e->offset0 = (unsigned long)addr;
-    e->selector = read_cs();
+    e->selector = sel;
     e->ist = 0;
-    e->type = 14;
+    e->type = type;
     e->dpl = dpl;
     e->p = 1;
     e->offset1 = (unsigned long)addr >> 16;
 #ifdef __x86_64__
-    e->offset2 = (unsigned long)addr >> 32;
+    if (e_sz == sizeof(*e)) {
+        e->offset2 = (unsigned long)addr >> 32;
+    }
 #endif
 }
 
+void set_idt_entry(int vec, void *addr, int dpl)
+{
+    idt_entry_t *e = &boot_idt[vec];
+    set_idt_entry_t(e, sizeof *e, addr, read_cs(), 14, dpl);
+}
+
 void set_idt_dpl(int vec, u16 dpl)
 {
     idt_entry_t *e = &boot_idt[vec];
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 602e9f7..5eb21e4 100644
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

