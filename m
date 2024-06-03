Return-Path: <kvm+bounces-18619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31CAF8D7FE0
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 300D11C2243A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47D08288D;
	Mon,  3 Jun 2024 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="harCH/i4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D45CB67D
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 10:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717410151; cv=none; b=ftloBWI3LZM6UmcUr+8hO7/hDkHaxq8rQ5VelbdMWpObA9dIvGwBLX4i1XTmt8U5O2mD9OylSf6acd2Ak4He+6PLTBIsjwZACaTVbxqFQbCwAqDTe8i9Ft6baA+CoP8VyyZqYXdp4jN1u3J1asianM3+Bs4jvfY4J80CWOA5g2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717410151; c=relaxed/simple;
	bh=k0zxbc2RJezG4w+iAbuVq3nGJQl/k/Zcyd86t/ztZsE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IWEeq1WwK3E7LZ/7HzljRx7YG7lu9eSmMVPEluYTDHv1DUrdVr1WfmSuv5LQ6Y30dPKNniIKhayrQi5gerbq8YELsQ41wzFq7GhZvDhG6/d3Vf13N657eIZijlBkpOSZqSt6467sMukVW0NU+sjxQQNO7WfaaFWJEwc4DLw+jKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=harCH/i4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717410148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=27JGLriBJMxT8MblOmtUxKoDGIQDmb0ccG+nttq/m8M=;
	b=harCH/i4e1j7izXB+SEwq0jJ+pfSXP/997Yw8+hmleQYsNy/W7G5+Ly5ZlTviSQUN3OGUc
	IhjPNzoGilq2zhXg4/SN27MIBe9eFZJzj5XSqQ0JWuwIAFF/Od3tyJ4DJ7MMxg7kLQfrxJ
	4tNvqItcxlGZECP2XKtOtyQbFojrUr8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-HmUbBpfgOKWghtlrK-nfXg-1; Mon, 03 Jun 2024 06:22:26 -0400
X-MC-Unique: HmUbBpfgOKWghtlrK-nfXg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a68f2d64342so44820266b.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 03:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717410145; x=1718014945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27JGLriBJMxT8MblOmtUxKoDGIQDmb0ccG+nttq/m8M=;
        b=kNDvH1yhYdDcKE3Cw4S/VPHSdqDtgHi3r8KkhJRH4C2SpD/wAh1SYoEO6CnmE+hAFo
         CxJBm4uCQD5t81bsFnwnhBffRcY7lGioLP0CeEyZ/tQN8rZy2DkeJ9ThzrOepLCMDN5k
         6E1AsP8DFN9jDakjkAjZhbAbPQ/mk3BBMEN7LXx/erI7Kc56dY89pwWl4TjjXs0vHybL
         gCeZBi7yrnkGdgsLbnp0AX0NRH04ZLI7oO8JScuu1uCkdRohxYWHsxG2SG9jOZdVTDYi
         6yC+em0MNn8m5C8EMdM0M7Zs/jaNntNGcN+Nwo6CBq5pLf8OM/Wt7UiQU6eK8yMjDuU5
         j5dw==
X-Gm-Message-State: AOJu0Yz3O6Om6RxiIS8GDiu2B5pimW+nhyY9sDGfOEyn7NTLkoAF32cV
	GePXaV4hWqnGrns8rLcHicp+4oZVLaqBCrki8dTZvi+NmdCXrCu0EM2Fn/g8ICoa06l9xKOepWa
	DJ8gHX71Wuqa1EUftBsF/bFBxHjA2PO5cyLxRQMKH8zVtpNSUp28o/8mS/bqMURTPWQikrVUzJF
	J9rAkid/nOm5dLxXEJzv445wp0gM46fC2h5A==
X-Received: by 2002:a17:906:da89:b0:a59:a85d:31c6 with SMTP id a640c23a62f3a-a68224460b9mr684098366b.66.1717410145031;
        Mon, 03 Jun 2024 03:22:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+RYelkxK/CQmvrLms6c3qPK9vLmZjGwuQ4pA0jCVn1HipmZ8lhZm6GbQcSUHD0oAP3bPhKg==
X-Received: by 2002:a17:906:da89:b0:a59:a85d:31c6 with SMTP id a640c23a62f3a-a68224460b9mr684095966b.66.1717410144573;
        Mon, 03 Jun 2024 03:22:24 -0700 (PDT)
Received: from avogadro.local ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68cb5cf540sm283106266b.54.2024.06.03.03.22.24
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 03:22:24 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm: add test for VMRUN with interrupt shadow enabled
Date: Mon,  3 Jun 2024 12:22:22 +0200
Message-ID: <20240603102222.622196-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c81b7465..33b25599 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1554,10 +1554,12 @@ static bool exc_inject_check(struct svm_test *test)
 }
 
 static volatile bool virq_fired;
+static volatile unsigned long virq_rip;
 
 static void virq_isr(isr_regs_t *regs)
 {
 	virq_fired = true;
+	virq_rip = regs->rip;
 }
 
 static void virq_inject_prepare(struct svm_test *test)
@@ -1568,6 +1570,7 @@ static void virq_inject_prepare(struct svm_test *test)
 		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
 	vmcb->control.int_vector = 0xf1;
 	virq_fired = false;
+	virq_rip = -1;
 	set_test_stage(test, 0);
 }
 
@@ -1678,6 +1681,45 @@ static bool virq_inject_check(struct svm_test *test)
 	return get_test_stage(test) == 5;
 }
 
+static void virq_inject_within_shadow_prepare(struct svm_test *test)
+{
+	virq_inject_prepare(test);
+	vmcb->control.int_state = SVM_INTERRUPT_SHADOW_MASK;
+	vmcb->save.rflags |= X86_EFLAGS_IF;
+}
+
+extern void virq_inject_within_shadow_test(struct svm_test *test);
+asm("virq_inject_within_shadow_test: nop; nop; vmmcall");
+
+static void virq_inject_within_shadow_prepare_gif_clear(struct svm_test *test)
+{
+	vmcb->save.rip = (unsigned long) test->guest_func;
+}
+
+static bool virq_inject_within_shadow_finished(struct svm_test *test)
+{
+	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL)
+		report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+	if (!virq_fired)
+		report_fail("V_IRQ did not fire");
+	else if (virq_rip != (unsigned long) virq_inject_within_shadow_test + 1)
+		report_fail("Unexpected RIP for interrupt handler");
+	else if (vmcb->control.int_ctl & V_IRQ_MASK)
+		report_fail("V_IRQ not cleared on VMEXIT after firing");
+	else if (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
+		report_fail("Interrupt shadow not cleared");
+	else
+		inc_test_stage(test);
+
+	return true;
+}
+
+static bool virq_inject_within_shadow_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 1;
+}
+
 /*
  * Detect nested guest RIP corruption as explained in kernel commit
  * b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
@@ -3352,6 +3394,9 @@ struct svm_test svm_tests[] = {
 	{ "virq_inject", default_supported, virq_inject_prepare,
 	  default_prepare_gif_clear, virq_inject_test,
 	  virq_inject_finished, virq_inject_check },
+	{ "virq_inject_within_shadow", default_supported, virq_inject_within_shadow_prepare,
+	  virq_inject_within_shadow_prepare_gif_clear, virq_inject_within_shadow_test,
+	  virq_inject_within_shadow_finished, virq_inject_within_shadow_check },
 	{ "reg_corruption", default_supported, reg_corruption_prepare,
 	  default_prepare_gif_clear, reg_corruption_test,
 	  reg_corruption_finished, reg_corruption_check },
-- 
2.45.1


