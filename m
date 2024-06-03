Return-Path: <kvm+bounces-18617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A878D7FD6
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AD121F2542D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5CE81735;
	Mon,  3 Jun 2024 10:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBTxbl5T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A026B67D
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 10:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717409939; cv=none; b=LD/gZAYJ4Ljpc7/2x4fPPPb4MmqwAhzE/l+CfZFzAPW5ESpj3E/qff9BDFBuRtbj43TtgR78ja4j0I54U8jPDo4ajB9Mvoa4frtb4dAssdjr2g9NIBMafEVD1C/zd247gZvmL5MQP8TnL9W5NNIyl/yN/EA9nRGGxONu65P195I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717409939; c=relaxed/simple;
	bh=g/CjRDEINR1mFothcgpAQA1od7K1A3W1SlUQohyyyI8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LDOw756luwQ5QJBBKL3RbW19imn+GAq+CLorUIR9t5As9ngtJGZu7l1rA7AnXnJMCx2bE/sq0z8ZGtCCjFXx15WRHCU9ITldY0clJKicSmxQGsdBoU/Jvq6/DC3tRZig4qWsBzeW3SlwmhNfBdE5uj0rUKqvTA9MvtWNH763Egk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBTxbl5T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717409937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9FkfC5nUoN2l2Y+0sVTyXpUe0KqqQRGZfHfBbcFMAXE=;
	b=YBTxbl5TG80NpksbLyETB1C2RItn6+3KrU0vdLo9DxJ7PLtcCQYqpYsyVNGOPp4zE+431o
	vhYBEBfmY7DIZiWkM3LzAo+CGTtdQk1QcGP2Iy/h2zEyWCVXorwFOtwkU6y8bKL1116I4f
	rmhLdK59YmdOkMqQoCNAB40+SQAZV0c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-aly-xXvlNwCC6K_AAbxHSA-1; Mon, 03 Jun 2024 06:18:54 -0400
X-MC-Unique: aly-xXvlNwCC6K_AAbxHSA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a68e5b46222so51289566b.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 03:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717409933; x=1718014733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9FkfC5nUoN2l2Y+0sVTyXpUe0KqqQRGZfHfBbcFMAXE=;
        b=ICk8L7CgkDQ92zTOA2YcZPx6LYrDcykgUCQZxA1+SkqmZe0P7It0CSSZAYS6MCqVXQ
         v2UtYwsoAs7nrSJ1mPy5hm9tSU/Xha915eOgCVi+BMh0wHqX1M5s+DDUYzOUtpdgCWJO
         SSmUI1JRkhFefObNXGVNuK+kdXoRdIV3ii0KZK3HkDdM/SPB8/hUf6BqqmY5evGvcXz/
         W6o3gNUmwGHLEbkmh1MW0bQ/UMFHxOkx+Oq5rKOu8BYR6/qQ5pxZFpFKofqRYJoiBQLm
         uiiTM7guzVCSZPAlo0CNuMikZzGDo9XeJrvP+gHPg9O6p6tfvTXCre0YOLvo6tvc61TQ
         aMug==
X-Gm-Message-State: AOJu0YxGzLRaszRaJN2nzy26upjPtZyx1RHJxDKSLMEcLZbHzSzkfIZ8
	oNA383+6XZzTMbWuebJqFH+aZ+pNchttfmmztwq+Rvfd4XNTIYiVQhAjDBAeQTTNs/KFx9hcOpq
	+wKd/rnFiDYc9sI4HLLXPkogY/wLNQb2OSAyIfu5II6Yafah/IUuL3+iXncXsH4PnoereGVn1IT
	3ZejYxhIflOG5m8ci/CQmxKInwERub9iZyOw==
X-Received: by 2002:a17:906:aac1:b0:a62:a63c:18f0 with SMTP id a640c23a62f3a-a681fe4e408mr543406566b.1.1717409933321;
        Mon, 03 Jun 2024 03:18:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElnof7cPNLH8mPy31+n27Rl41+xSRYwPLgw6k5LCjOYZ1ZFHyf8tgVRVVwZBk+CUcoVkOtiQ==
X-Received: by 2002:a17:906:aac1:b0:a62:a63c:18f0 with SMTP id a640c23a62f3a-a681fe4e408mr543404666b.1.1717409932811;
        Mon, 03 Jun 2024 03:18:52 -0700 (PDT)
Received: from avogadro.local ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68f39b9294sm217783466b.180.2024.06.03.03.18.52
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 03:18:52 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] debug: add testcase for singlestepping over STI;HLT
Date: Mon,  3 Jun 2024 12:18:50 +0200
Message-ID: <20240603101850.621723-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Test that HLT sets RIP correctly when returning from singlestep.
QEMU's emulation is currently not injecting a #DB exception
for single-step at all after an HLT instruction.  Also, after
single-step is injected EFLAGS.IF might very well be zero,
meaning that the CPU would not have to leave HLT.  Check
that the emulation is not confused, i.e. that it remembers
that it has _already_ left HLT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/debug.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index 65784c5a..f493567c 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -85,6 +85,7 @@ typedef unsigned long (*db_test_fn)(void);
 typedef void (*db_report_fn)(unsigned long, const char *);
 
 static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void);
+static unsigned long singlestep_with_sti_hlt(void);
 
 static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 {
@@ -97,8 +98,12 @@ static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 	start = test();
 	report_fn(start, "");
 
-	/* MOV DR #GPs at CPL>0, don't try to run the DR7.GD test in usermode. */
-	if (test == singlestep_with_movss_blocking_and_dr7_gd)
+	/*
+	 * MOV DR #GPs at CPL>0, don't try to run the DR7.GD test in usermode.
+	 * Likewise for HLT.
+	 */
+	if (test == singlestep_with_movss_blocking_and_dr7_gd
+	    || test == singlestep_with_sti_hlt)
 		return;
 
 	n = 0;
@@ -352,6 +357,58 @@ static noinline unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
 	return start_rip;
 }
 
+static void report_singlestep_with_sti_hlt(unsigned long start,
+						const char *usermode)
+{
+	report(n == 5 &&
+	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 6 &&
+	       is_single_step_db(dr6[3]) && db_addr[3] == start + 1 + 6 + 1 &&
+	       is_single_step_db(dr6[4]) && db_addr[4] == start + 1 + 6 + 1 + 1,
+	       "%sSingle-step #DB w/ STI;HLT", usermode);
+}
+
+#define APIC_LVT_TIMER_VECTOR    (0xee)
+
+static void lvtt_handler(isr_regs_t *regs)
+{
+        eoi();
+}
+
+static noinline unsigned long singlestep_with_sti_hlt(void)
+{
+	unsigned long start_rip;
+
+	cli();
+
+	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
+	apic_write(APIC_LVTT, APIC_LVT_TIMER_ONESHOT |
+		   APIC_LVT_TIMER_VECTOR);
+	apic_write(APIC_TDCR, 0x0000000b);
+	apic_write(APIC_TMICT, 1000000);
+
+	/*
+	 * STI blocking doesn't suppress #DBs, thus the first single-step #DB
+	 * should arrive after the standard one instruction delay.
+	 */
+	asm volatile(
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"sti\n\t"
+		"1:hlt;\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b(%%rip),%0\n\t"
+		: "=r" (start_rip) : : "rax"
+	);
+	return start_rip;
+}
+
 int main(int ac, char **av)
 {
 	unsigned long cr4;
@@ -416,6 +473,7 @@ int main(int ac, char **av)
 	run_ss_db_test(singlestep_with_movss_blocking);
 	run_ss_db_test(singlestep_with_movss_blocking_and_icebp);
 	run_ss_db_test(singlestep_with_movss_blocking_and_dr7_gd);
+	run_ss_db_test(singlestep_with_sti_hlt);
 
 	n = 0;
 	write_dr1((void *)&value);
-- 
2.45.1


