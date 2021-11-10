Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1044CB38
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhKJVXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbhKJVW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:22:58 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C5EC061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:09 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k22-20020a635a56000000b002df9863aa74so642514pgm.19
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=snzSCWk849MQll6yLKrYuxCyE2OCmcQd3IuDmO+ENMg=;
        b=EtjOCb18plV0mfDxRroDlrTiBCClhquhMA9uw/kKgourm85G5SnHiYXMkxElwBatYR
         PFRCedxHSXz7N7sF20OkFGJoeL1Sc8CFVf9z0UQvMnWK52+vPGwEk3LIkOPdZd+9MDgA
         vo+Xd04bAs1aMNW6i7UH2GqB3nbK5Ylr3Cw6JNmVp01beblj4/+2lr8Aj/Pk86Og2jw5
         Ddw/CDxmN9wYiNzp2yNiabvLLGY5KN6X717polSB4L7AQAwHpzJqTiNugoi5Vkbqr6T7
         Wx8L67KfS4udWU975Nx9W1N+tDKbFH4f8wv2/+qIguqwy3uFydEqVsgvdTXILwRkjN53
         rJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=snzSCWk849MQll6yLKrYuxCyE2OCmcQd3IuDmO+ENMg=;
        b=IUPVj/Ru/GtzL71C/YFvupmyWHRWZwyJFrE4aQRqB5iWEvg6tvdMtX1+zUVlcfip9x
         hakZppP5qiMANbZZRKWtzVIzeXIJ+LvoeZDCfhWhfKkgAvRzwqbRCD1NsiHP0L+DeQbp
         YjYu26JIqb43BTrl6oaDVHxhxwcxFNFv6hTeZaS+IrpdoQXUHzAfF3pCvnTLi6PKjebe
         HM3KAA5WNLfAJVrXjnGP7TCQWluMhllYVB6FG/Bn1WRuEU9v1WWsmPS0Sfcye2QC6sQ1
         ggakkWa9hiw5xjQ86WrpfVNJtngmPwkkOPDQ//oNYLSgVT9wN1/XarHgK+DaVvIE5ons
         mLLQ==
X-Gm-Message-State: AOAM533PLQNUSnE7A+u8459B2s3JneAm6UQe2fSsz6lH8WLHLXkDpBT3
        V6fuzZ5NjpOR2DIcLHBvosxmhzh9TklNf+nP3odj1nqNZl1dpSjzYvAlXTzdsnNLGuuJgzrfK1S
        hbOSkJr/Dq7Uetj9jbaKxwLD7vAHNSctX3YS7evZbPkdT978QmCw1RGHspIjGWI5OVfCO
X-Google-Smtp-Source: ABdhPJyz1645zIeIfF68a4vK7P+qRbezHv8oy0kk3UXwFQBjnZnkLrhdz3THdhSY0lI0gu4onOWIHgcH0HRRqYeW
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:aa49:b0:142:5a22:428f with SMTP
 id c9-20020a170902aa4900b001425a22428fmr1970413plr.39.1636579208392; Wed, 10
 Nov 2021 13:20:08 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:48 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 01/14] x86: cleanup handling of 16-byte GDT descriptors
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Look them up using a gdt_entry_t pointer, so that the address of
the descriptor is correct even for "odd" selectors (e.g. 0x98).
Rename the struct from segment_desc64 to system_desc64,
highlighting that it is only used in the case of S=0 (system
descriptor).  Rename the "limit" bitfield to "limit2", matching
the convention used for the various parts of the base field.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.h         |  4 ++--
 x86/svm_tests.c        | 12 ++++++------
 x86/vmware_backdoors.c |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38..1755486 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -172,7 +172,7 @@ typedef struct {
 	u8 base_high;
 } gdt_entry_t;
 
-struct segment_desc64 {
+struct system_desc64 {
 	uint16_t limit1;
 	uint16_t base1;
 	uint8_t  base2;
@@ -183,7 +183,7 @@ struct segment_desc64 {
 			uint16_t s:1;
 			uint16_t dpl:2;
 			uint16_t p:1;
-			uint16_t limit:4;
+			uint16_t limit2:4;
 			uint16_t avl:1;
 			uint16_t l:1;
 			uint16_t db:1;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index afdd359..2fdb0dc 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1876,22 +1876,22 @@ static bool reg_corruption_check(struct svm_test *test)
 static void get_tss_entry(void *data)
 {
     struct descriptor_table_ptr gdt;
-    struct segment_desc64 *gdt_table;
-    struct segment_desc64 *tss_entry;
+    gdt_entry_t *gdt_table;
+    struct system_desc64 *tss_entry;
     u16 tr = 0;
 
     sgdt(&gdt);
     tr = str();
-    gdt_table = (struct segment_desc64 *) gdt.base;
-    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
-    *((struct segment_desc64 **)data) = tss_entry;
+    gdt_table = (gdt_entry_t *) gdt.base;
+    tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
+    *((struct system_desc64 **)data) = tss_entry;
 }
 
 static int orig_cpu_count;
 
 static void init_startup_prepare(struct svm_test *test)
 {
-    struct segment_desc64 *tss_entry;
+    struct system_desc64 *tss_entry;
     int i;
 
     on_cpu(1, get_tss_entry, &tss_entry);
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index b4902a9..b1433cd 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -133,8 +133,8 @@ struct fault_test vmware_backdoor_tests[] = {
 static void set_tss_ioperm(void)
 {
 	struct descriptor_table_ptr gdt;
-	struct segment_desc64 *gdt_table;
-	struct segment_desc64 *tss_entry;
+	gdt_entry_t *gdt_table;
+	struct system_desc64 *tss_entry;
 	u16 tr = 0;
 	tss64_t *tss;
 	unsigned char *ioperm_bitmap;
@@ -142,8 +142,8 @@ static void set_tss_ioperm(void)
 
 	sgdt(&gdt);
 	tr = str();
-	gdt_table = (struct segment_desc64 *) gdt.base;
-	tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
+	gdt_table = (gdt_entry_t *) gdt.base;
+	tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
 	tss_base = ((uint64_t) tss_entry->base1 |
 			((uint64_t) tss_entry->base2 << 16) |
 			((uint64_t) tss_entry->base3 << 24) |
-- 
2.34.0.rc1.387.gb447b232ab-goog

