Return-Path: <kvm+bounces-26051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7236C96FEC4
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F0E01C22066
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2609CD512;
	Sat,  7 Sep 2024 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvhmUoM8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260DDA927
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670489; cv=none; b=ioT2EuW4C2VKpC60CgNEB9I2aTodjhTPtFB+04/F+wtn+hTEr/Orc8n6NFkzH3YVWdL33vYMkglMsoD1C1/l1sCtNbJZSHXuR9q+diIaAiphe2lKJDzFd2uLiAHZ588+dGaKfweQVGSna6DXlO+68BmxCL/2VHofOzVEpzLe0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670489; c=relaxed/simple;
	bh=7VD03Qntmthy9Q7Vyr/9df/LJOaQhqhvOBK94YTE8to=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FCA/cJJF9/9mBSCxXl0T02DqQ8rS8YaVZo4MNq3PYycNbEbSBstsIP3MiHvhyRX8oXzZyeilkVFrXJS6b7PUqVmcRmFGPHBIBDy3iB6qAptgIJF/Nk+IcbHBXuvzJxxmBK5Ms6x+pBhv8scqiJUqwz23e3n8vg5D1PVu7bKpfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PvhmUoM8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725670485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EEzbdXP/pX9sHfOe1VBFNARTLHFaigbuH1Y/01sWsrM=;
	b=PvhmUoM8J60zjo6zl8P0tZHZjIJmHFzlpNQByoNudkBL4fE6LYk7oxhmUY9dFadl+f8opB
	kc7rA5p0RJdy7locxFMp9/wAxXJHHFpk6GRvd8g/2Nuyu9vQXs5pMAC2IdwEBYnqGOvXWt
	lUrFL15Rj4CjRJK7QoLA5XpK5Nc/wB0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-vfWr-JEsMiaaVXSGvFnezQ-1; Fri,
 06 Sep 2024 20:54:44 -0400
X-MC-Unique: vfWr-JEsMiaaVXSGvFnezQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 460FD19560B0
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:43 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4565619560AF;
	Sat,  7 Sep 2024 00:54:42 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH 1/5] x86: add _safe and _fep_safe variants to segment base load instructions
Date: Fri,  6 Sep 2024 20:54:36 -0400
Message-Id: <20240907005440.500075-2-mlevitsk@redhat.com>
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

_safe and _fep_safe functions will be used to validate various ways of
setting the segment bases and GDT/LDT bases.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/desc.h      |  4 ++--
 lib/x86/processor.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 92c45a48f..5349ea572 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -286,8 +286,8 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 #define asm_safe(insn, inputs...)					\
 	__asm_safe("", insn, inputs)
 
-#define asm_fep_safe(insn, output, inputs...)				\
-	__asm_safe_out1(KVM_FEP, insn, output, inputs)
+#define asm_fep_safe(insn, inputs...)				\
+	__asm_safe_out1(KVM_FEP, insn,, inputs)
 
 #define __asm_safe_out1(fep, insn, output, inputs...)			\
 ({									\
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index da1ed6628..9248a06b2 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -468,6 +468,11 @@ static inline int rdmsr_safe(u32 index, uint64_t *val)
 	return rdreg64_safe("rdmsr", index, val);
 }
 
+static inline int rdmsr_fep_safe(u32 index, uint64_t *val)
+{
+	return __rdreg64_safe(KVM_FEP, "rdmsr", index, val);
+}
+
 static inline int wrmsr_safe(u32 index, u64 val)
 {
 	return wrreg64_safe("wrmsr", index, val);
@@ -597,6 +602,16 @@ static inline void lgdt(const struct descriptor_table_ptr *ptr)
 	asm volatile ("lgdt %0" : : "m"(*ptr));
 }
 
+static inline int lgdt_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_safe("lgdt %0", "m"(*ptr));
+}
+
+static inline int lgdt_fep_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_fep_safe("lgdt %0", "m"(*ptr));
+}
+
 static inline void sgdt(struct descriptor_table_ptr *ptr)
 {
 	asm volatile ("sgdt %0" : "=m"(*ptr));
@@ -607,6 +622,16 @@ static inline void lidt(const struct descriptor_table_ptr *ptr)
 	asm volatile ("lidt %0" : : "m"(*ptr));
 }
 
+static inline int lidt_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_safe("lidt %0", "m"(*ptr));
+}
+
+static inline int lidt_fep_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_fep_safe("lidt %0", "m"(*ptr));
+}
+
 static inline void sidt(struct descriptor_table_ptr *ptr)
 {
 	asm volatile ("sidt %0" : "=m"(*ptr));
@@ -617,6 +642,16 @@ static inline void lldt(u16 val)
 	asm volatile ("lldt %0" : : "rm"(val));
 }
 
+static inline int lldt_safe(u16 val)
+{
+	return asm_safe("lldt %0", "rm"(val));
+}
+
+static inline int lldt_fep_safe(u16 val)
+{
+	return asm_safe("lldt %0", "rm"(val));
+}
+
 static inline u16 sldt(void)
 {
 	u16 val;
@@ -629,6 +664,16 @@ static inline void ltr(u16 val)
 	asm volatile ("ltr %0" : : "rm"(val));
 }
 
+static inline int ltr_safe(u16 val)
+{
+	return asm_safe("ltr %0", "rm"(val));
+}
+
+static inline int ltr_fep_safe(u16 val)
+{
+	return asm_safe("ltr %0", "rm"(val));
+}
+
 static inline u16 str(void)
 {
 	u16 val;
-- 
2.26.3


