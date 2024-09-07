Return-Path: <kvm+bounces-26052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 467BB96FEC3
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F16A51F23BF9
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E96D29E;
	Sat,  7 Sep 2024 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8gnfmtD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944D5A92D
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670489; cv=none; b=U85e2qxM/MTffIzOpXAzeyZ6ylY3i3+ocjwInNKrEWuig2Q71bRaQMCWljVOowtbZFScTMjaHCcQdUZIUtPH4ivw2/W2ROkpp9+0uHLCficgsibWUAfoBqx4JlKSUY09oO9RMlV8gomvCu2PaayLabh7xaKAzpzIwwwr7ihs3EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670489; c=relaxed/simple;
	bh=OsdQ1yj4JSnzx5SG0hg8J9bx/31o5WGXXyh6SF5GT04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DYMsUy3+g0wTl09HSjLF1KxnykbwrGrWqxZYPdeUtloUq6WO6qNW1WHB+umLnlIMDyU54FR0wSYtWT93oqcfxN2mtYPmnf/zruNLiKsmNMweG4aGF59Ga+7ndS5tfm7sBcl6/gwrN/fZ9dK35rHGUMn9HbnbPkIAGetB3lHqURM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8gnfmtD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725670486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+P8w1LwrK/piZdxoBKsUBjaw9FgpEeIXszfCDXcGJMc=;
	b=h8gnfmtDu4lZDFOuAoloBO1fJ4s64cFPBme5YgxwOW+YW7G8N/fu5Ewp75wjSjP2Ezvgdy
	1F5JOEfkpN8rdgoyV3Y6y931Ef2hf9XI/PHWv8AsflI9qMrLUW4Os8zl0O37L57edwDJf5
	b8HoLmPdXxWOTUvyK3Q+XNbrREwiLQk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74--C7svMowN8GHpe3hfh1Ixw-1; Fri,
 06 Sep 2024 20:54:45 -0400
X-MC-Unique: -C7svMowN8GHpe3hfh1Ixw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F9921956096
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:44 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5267219560AA;
	Sat,  7 Sep 2024 00:54:43 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH 2/5] x86: add a few functions for gdt manipulation
Date: Fri,  6 Sep 2024 20:54:37 -0400
Message-Id: <20240907005440.500075-3-mlevitsk@redhat.com>
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add a few functions that will be used to manipulate various
segment bases that are loaded via GDT.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/desc.c | 39 ++++++++++++++++++++++++++++++++-------
 lib/x86/desc.h |  5 +++++
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index d054899c6..52e33f201 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -338,7 +338,7 @@ bool exception_rflags_rf(void)
 
 static char intr_alt_stack[4096];
 
-void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
+void set_gdt_entry_base(int sel, unsigned long base)
 {
 	gdt_entry_t *entry = &gdt[sel >> 3];
 
@@ -347,10 +347,6 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
 	entry->base2 = (base >> 16) & 0xFF;
 	entry->base3 = (base >> 24) & 0xFF;
 
-	/* Setup the descriptor limits, type and flags */
-	entry->limit1 = (limit & 0xFFFF);
-	entry->type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
-
 #ifdef __x86_64__
 	if (!entry->s) {
 		struct system_desc64 *entry16 = (struct system_desc64 *)entry;
@@ -360,6 +356,25 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
 #endif
 }
 
+void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
+{
+	gdt_entry_t *entry = &gdt[sel >> 3];
+
+	/* Setup the descriptor limits, type and flags */
+	entry->limit1 = (limit & 0xFFFF);
+	entry->type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
+	set_gdt_entry_base(sel, base);
+}
+
+void clear_tss_busy(int sel)
+{
+	gdt_entry_t *entry = &gdt[sel >> 3];
+
+	entry->type_limit_flags &= ~0xFF;
+	entry->type_limit_flags |= 0x89;
+}
+
+
 void load_gdt_tss(size_t tss_offset)
 {
 	lgdt(&gdt_descr);
@@ -483,14 +498,24 @@ void __set_exception_jmpbuf(jmp_buf *addr)
 	exception_jmpbuf = addr;
 }
 
-gdt_entry_t *get_tss_descr(void)
+gdt_entry_t *get_gdt_entry(u16 sel)
 {
 	struct descriptor_table_ptr gdt_ptr;
 	gdt_entry_t *gdt;
 
 	sgdt(&gdt_ptr);
 	gdt = (gdt_entry_t *)gdt_ptr.base;
-	return &gdt[str() / 8];
+	return &gdt[sel / 8];
+}
+
+gdt_entry_t *get_tss_descr(void)
+{
+	return get_gdt_entry(str());
+}
+
+gdt_entry_t *get_ldt_descr(void)
+{
+	return get_gdt_entry(sldt());
 }
 
 unsigned long get_gdt_entry_base(gdt_entry_t *entry)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 5349ea572..a50c8f61b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -246,6 +246,8 @@ void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
 void set_gdt_entry(int sel, unsigned long base, u32 limit, u8 access, u8 gran);
+void set_gdt_entry_base(int sel, unsigned long base);
+void clear_tss_busy(int sel);
 void load_gdt_tss(size_t tss_offset);
 void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
@@ -268,7 +270,10 @@ static inline void *get_idt_addr(idt_entry_t *entry)
 	return (void *)addr;
 }
 
+extern gdt_entry_t *get_gdt_entry(u16 sel);
 extern gdt_entry_t *get_tss_descr(void);
+gdt_entry_t *get_ldt_descr(void);
+
 extern unsigned long get_gdt_entry_base(gdt_entry_t *entry);
 extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 
-- 
2.26.3


