Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4858C4FE713
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiDLRfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358212AbiDLRfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:35:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB48C62103
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:32:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 64CAF1F856;
        Tue, 12 Apr 2022 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pFXfUXu/vz1zLE9GWCvC1fGrTciKuC4HIFFLsdpaco=;
        b=pwYLAm05u5+/SDhv9B26QJAZtl1ggzn0HECef4eS8isWev7BGS2SNXDvH0Xdrk1CwUx9rQ
        OViEk126Wjik12wU4tHAZyloSfaQtpAWbq7yFQvL2xh/26ddj5p5oFFxvTvyqvwKnMqQKY
        7RMz1rZ0VjbxhtzGujFPzcL3FrHvSHY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD85013780;
        Tue, 12 Apr 2022 17:32:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uNbNL6i3VWJJewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:32:24 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [PATCH 03/10] x86: desc: Split IDT entry setup into a generic helper
Date:   Tue, 12 Apr 2022 19:32:14 +0200
Message-Id: <20220412173221.13315-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173221.13315-1-varad.gautam@suse.com>
References: <20220412173221.13315-1-varad.gautam@suse.com>
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
2.35.1

