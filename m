Return-Path: <kvm+bounces-38249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D167BA36AFF
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67B2C18903D2
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98A114A62A;
	Sat, 15 Feb 2025 01:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VJG7mAQA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE79013FD72
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583026; cv=none; b=NO70tDDxkyAM9BCDq4CxKmV1iuNmIOTR80qT68NtiYYQUbi5y3Z2GmpXERv6rdIC6iQWHn1UVZobQEUkSwWXhvgCQXfy/QxsiBZ8/w9/gjaBsLi4vu+FGSK+mNm062gk5NvXrRlLk/Osl5sd6VRWaUt2YGrXgN3E8DW+lxEiQQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583026; c=relaxed/simple;
	bh=DHIuIRI+ndOnIUw/E1wdY2QcqzXJN92i2bk9NrSFkak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qeV+V7BywnJBWTzKZshaFJSX0AS3oXKjZ6sKt5bNjgu/gQOSjm3eGrbncSZNJ6IHW8wgJ0B21NdKZ9FBl2kFq4RKBn/njT6qWDiL78jBzwc9PvRKw9isna2/PeLKfe1dDAV1EdyhpssTiM4C71DIzCa9QXz6GMmrSXahwqeT+kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VJG7mAQA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1c3b3dc7so4433033a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583024; x=1740187824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nozmXbxSIKpXqMg01+BWyfff9AU705l9LcnoqO5/Xco=;
        b=VJG7mAQAlu9CUygG+w3Gx8B62n5IGIr5WEnVj3xgQoEFYoJ7titAYaSd2ffKmPZ3D2
         oNON6lOD3ulV0HG4VEhGvLX5vtNvoix33gWd5kJankt69bz2nnZSJShe65CA1vBJQqEm
         9+aDaiuD7wqqdjifK3acGAtks8BnYFeKDtWs+G5GkuELm+jM3K/mzdNRABQX/EDH0Avd
         aZvd9b7jmO+sxiUk/G7KFe36+xfEeq3aOIviRvYXR4ZTaifiGfgPzc7QBRxqpvKjeQLW
         c3gpjUTZo0HpjqLqn87t689+smRBd+Ym9QHsWd8MQ1Aswf21pipj21xsmIytQrm1yMJX
         jmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583024; x=1740187824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nozmXbxSIKpXqMg01+BWyfff9AU705l9LcnoqO5/Xco=;
        b=BKBTj8rBlh/81glmBBa6GdhdJ9TDRdosQnF91s46kl1WV2Ty66hvsmaOucqkZSOHj2
         e89Jn8K/fxc5IglCwOkX4ptgtZeUwd/CD6+uHhzfF1305+NLEs7BKqhwM2SF9WwH7D6o
         TYHXf+ql+c/dl+8bhQ7d08P6+U+8KjWKpBRQckdUt66Bvn72nbheLunE4jf3JHOfG/ey
         bZ4ak0LGr6l9SMCH8uebELTS2OnadBg9DIfXIZNhh+MP+FtWgHNKfuxm6xWRvbErDDld
         g3E6g1q+QCTqdTUPnbJRd3H5A0t6QrBLPnYexx7IREXYbskZXhAdd7MArCebZow3O/5o
         0EpQ==
X-Gm-Message-State: AOJu0Yxgn8iaV3Veq4SdEvjOcBEvfQ5+c7ZNajg2W4mvv1kzdGjzEoKC
	TwlsLP4F3KnnpGJB/Rzj9Pyjx1vBqgCLpHn5lLGfbYXeaqgySSDE4ieHV1fTbmJxyjFzQLdNdqv
	H4Q==
X-Google-Smtp-Source: AGHT+IHdTPrucKczM4E1WKm8Q2HUHogK4sU3LcaivRQ2CnoUdgGgrs013nwBUJiXrLRCOmU750ocFsur+Tg=
X-Received: from pjbmf13.prod.google.com ([2002:a17:90b:184d:b0:2fa:26f0:c221])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4b:b0:2f2:3efd:96da
 with SMTP id 98e67ed59e1d1-2fc41045e35mr2132033a91.24.1739583023983; Fri, 14
 Feb 2025 17:30:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:14 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 2/6] x86: Add a few functions for gdt manipulation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Add a few functions that will be used to manipulate various
segment bases that are loaded via GDT.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240907005440.500075-3-mlevitsk@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 38 +++++++++++++++++++++++++++++++-------
 lib/x86/desc.h |  5 +++++
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index d054899c..acfada26 100644
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
@@ -360,6 +356,24 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
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
 void load_gdt_tss(size_t tss_offset)
 {
 	lgdt(&gdt_descr);
@@ -483,14 +497,24 @@ void __set_exception_jmpbuf(jmp_buf *addr)
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
index 5349ea57..a50c8f61 100644
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
2.48.1.601.g30ceb7b040-goog


