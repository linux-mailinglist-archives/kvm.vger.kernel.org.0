Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708E630D90C
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhBCLnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:43:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234309AbhBCLn2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 06:43:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612352522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OfqkjnbtlUpza4EJUYhtV6VOU79DHIWSQvvvHKGSL+o=;
        b=RDo+UGja+iBHPnOFFS76RKo0A4L+lt/XwD83vdY2Jl055rLiuB8XNmZqPcP+8qY4DkiYcK
        WCJvERwlH/VQI7YBBnuJ3YLj2RMqgcECS1Lrr9rGX4S/CRj363iPWtcX0IOLWr7XHzjHSO
        5nP7zZke6Qn1I0BYMwydsdIM7Jk9uCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-3kcqkNX4MCeKeWSwBXHHnQ-1; Wed, 03 Feb 2021 06:41:59 -0500
X-MC-Unique: 3kcqkNX4MCeKeWSwBXHHnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7BE6801817
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 11:41:58 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 866975B692
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 11:41:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: add CR4.DE test to debug.flat
Date:   Wed,  3 Feb 2021 06:41:57 -0500
Message-Id: <20210203114157.132669-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check whether reading/writing DR4 generates an undefined opcode exception.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/debug.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/x86/debug.c b/x86/debug.c
index 9798e62..382fdde 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -18,6 +18,14 @@ static volatile unsigned long db_addr[10], dr6[10];
 static volatile unsigned int n;
 static volatile unsigned long value;
 
+static unsigned long get_dr4(void)
+{
+	unsigned long value;
+
+	asm volatile("mov %%dr4, %0" : "=r" (value));
+	return value;
+}
+
 static unsigned long get_dr6(void)
 {
 	unsigned long value;
@@ -36,6 +44,11 @@ static void set_dr1(void *value)
 	asm volatile("mov %0,%%dr1" : : "r" (value));
 }
 
+static void set_dr4(unsigned long value)
+{
+	asm volatile("mov %0,%%dr4" : : "r" (value));
+}
+
 static void set_dr6(unsigned long value)
 {
 	asm volatile("mov %0,%%dr6" : : "r" (value));
@@ -72,12 +85,35 @@ static void handle_bp(struct ex_regs *regs)
 	bp_addr = regs->rip;
 }
 
+bool got_ud;
+static void handle_ud(struct ex_regs *regs)
+{
+	unsigned long cr4 = read_cr4();
+	write_cr4(cr4 & ~X86_CR4_DE);
+	got_ud = 1;
+}
+
 int main(int ac, char **av)
 {
 	unsigned long start;
+	unsigned long cr4;
 
 	handle_exception(DB_VECTOR, handle_db);
 	handle_exception(BP_VECTOR, handle_bp);
+	handle_exception(UD_VECTOR, handle_ud);
+
+	got_ud = 0;
+	cr4 = read_cr4();
+	write_cr4(cr4 & ~X86_CR4_DE);
+	set_dr4(0);
+	set_dr6(0xffff4ff2);
+	report(get_dr4() == 0xffff4ff2 && !got_ud, "reading DR4 with CR4.DE == 0");
+
+	cr4 = read_cr4();
+	write_cr4(cr4 | X86_CR4_DE);
+	get_dr4();
+	report(got_ud, "reading DR4 with CR4.DE == 1");
+	set_dr6(0);
 
 	extern unsigned char sw_bp;
 	asm volatile("int3; sw_bp:");
-- 
2.26.2

