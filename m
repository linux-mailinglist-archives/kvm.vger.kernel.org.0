Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE67D34963A
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhCYP5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhCYP5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 11:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616687827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPA+uyojNtSFesWMBqX3x1IF65Zx0Aig92kBXSlFOsA=;
        b=XBm3B5iieJEzduinlLBE5EsZplOPlI5DOcqRwemH+kMc0/x0XIaf+lb+u++TEY4r8uFTa8
        YyJBn8crS56FYe8CKSLGWThoN5W0h9QN1e/kLtLev4Bl+aFGIf0mGm2+pZPAFRRxsiOEsT
        9X7s7QoM0v4r3QGBM4CJ5ogbfxIl8Ck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-cHYoI80mO86W63aUakuDQA-1; Thu, 25 Mar 2021 11:57:05 -0400
X-MC-Unique: cHYoI80mO86W63aUakuDQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 198FA18C89E1;
        Thu, 25 Mar 2021 15:57:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC0A25D736;
        Thu, 25 Mar 2021 15:57:02 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests 2/2] arm64: Output PC load offset on unhandled exceptions
Date:   Thu, 25 Mar 2021 16:56:57 +0100
Message-Id: <20210325155657.600897-3-drjones@redhat.com>
In-Reply-To: <20210325155657.600897-1-drjones@redhat.com>
References: <20210325155657.600897-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since for arm64 we can load the unit tests at different addresses,
then let's make it easier to debug by calculating the PC offset for
the user. The offset can then be directly used when looking at the
disassembly of the test's elf file.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/flat.lds          | 1 +
 lib/arm64/processor.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arm/flat.lds b/arm/flat.lds
index 4d43cdfeab41..6ed377c0eaa0 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -1,6 +1,7 @@
 
 SECTIONS
 {
+    PROVIDE(_text = .);
     .text : { *(.init) *(.text) *(.text.*) }
     . = ALIGN(64K);
     PROVIDE(etext = .);
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index ef558625e284..831207c16587 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -99,12 +99,19 @@ bool get_far(unsigned int esr, unsigned long *far)
 	return false;
 }
 
+extern unsigned long _text;
+
 static void bad_exception(enum vector v, struct pt_regs *regs,
 			  unsigned int esr, bool esr_valid, bool bad_vector)
 {
 	unsigned long far;
 	bool far_valid = get_far(esr, &far);
 	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
+	uintptr_t text = (uintptr_t)&_text;
+
+	printf("Load address: %" PRIxPTR "\n", text);
+	printf("PC: %" PRIxPTR " PC offset: %" PRIxPTR "\n",
+	       (uintptr_t)regs->pc, (uintptr_t)regs->pc - text);
 
 	if (bad_vector) {
 		if (v < VECTOR_MAX)
-- 
2.26.3

