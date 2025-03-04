Return-Path: <kvm+bounces-40083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95161A4EF3A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42CA77A3271
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0968326B09A;
	Tue,  4 Mar 2025 21:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EbPB9hUu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28D71F76A8
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122833; cv=none; b=fP8qNi4Z7lF8PElVkoPED+ykHWm+AFPrnff9yBhqTCOr4uSaFO8eUYKvrIGq3mASB+/wbDLzjwZsh938IcIfqpY7JFAR1Z/yd6mZ1iy1imqZ6YEhcQgL37SQhl7Zp9V9uK1fJJsYLJZ8EP56vHgvU3F4XeFZcDPx29NWC9qvWYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122833; c=relaxed/simple;
	bh=TCAAE6gsjgeclNBdvjOox4Bwi0mPdD4n0SDCQ0gB+qc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ge6PNMt/x+Z6fV1Dt/WXaQeZFlXAj51R6rLpQyxvDFIA7hbMZT4gu+CYL/Uv+pyy4yhitE4QdkUiggW935qlcpg/iYTgwvQqVjYT4dGNC6cF85Fg6NfO5fsXvbdHgH/mkDvHukpBls26LJDxs6TGRS4iN2eRV6gMgJe4vFFBqTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EbPB9hUu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2234bf13b47so116206375ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 13:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741122831; x=1741727631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AS2FCaw0bw5shMN56ZiPoQPh04ebZNABk2sKJln1VXU=;
        b=EbPB9hUug9yRPprSwohhhT2hO/1eQndmKio8XsLURM0ZzAFFxW7NEWXuZUafuP7/En
         nfOy5/9i8EwG34HBtr6324mlKLaj1FHVF9D2bJHccXkG3GtXNxbWa2OEF/lkUoHv48xK
         rRw2dIG/FvYqb1FOQuz1vk1XTjYKOJM2HPhuzNf1b4++65ElR3xmpxgqHpLt+/FnjHwp
         GWR4AVUDVD3/GepCgSvaEvK0/WaEQPli26WwSiqYveMwN6C/gVbkLm/Ko1kbCoF0E2b6
         aFQQSsbNx4q3zvC4rJAhq6lb9K1ISqkYL4myDZuZhwYy6DPJoAu0OE/WZPDdBR+xrZDG
         OQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741122831; x=1741727631;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AS2FCaw0bw5shMN56ZiPoQPh04ebZNABk2sKJln1VXU=;
        b=VEqJJRhMGr7uiIuRsB4F+Thh/oZgZcaWfKD3kzM11Q6+6YTwDN+3uNPk5xGdVl7qO8
         1ITcsYnBaXf0v2FfVgVoSaRIhJWLlNi9qJg1vlre9aOB/00tGRAOCKNDNf4wuGdeqmml
         s76lecjDuSJ6IlWFNENrcEjRdKF6OhEUBh617jKRvSMIUzO5cO7ZJhVPf7+iLO9/uM9r
         o6ClvfQ/WO+mX0T8JeH/5s8lN4m3C8qPcFh9J1+bRDeqfL2z+xArKA/YhPGMM4K2NT+X
         WtHnz7oS3lTqhQXVS/IaRbyawqvgDJzgepZPyMqsmM9F4LzdfiNv5Ga6SqwP1s6iLeOb
         Ss8A==
X-Gm-Message-State: AOJu0YxY5Qic/hZAB4ldncW6TJupwRZHxLp1R75SJzlGsfEcklLc3XtP
	n19vt1ENij4P4sWMGjuLbtdAuuxZMFPKm2qxQGit6pd3DHI/bMym3bruM+R2A0PsXZzAr+RGnJx
	kAA==
X-Google-Smtp-Source: AGHT+IHeNHjc8m3CUtFP4FnljCokGYSDGhlX1rnsnOaX0epdL6xXOTbCk6HlVSXsp2TFbeQ3ofPZJ0Kem7s=
X-Received: from pfbhu52.prod.google.com ([2002:a05:6a00:69b4:b0:736:3cd5:ba37])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:170c:b0:736:3184:7fe8
 with SMTP id d2e1a72fcca58-73682b54a53mr598154b3a.2.1741122831110; Tue, 04
 Mar 2025 13:13:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  4 Mar 2025 13:13:48 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304211348.126107-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: ioapic: Expand routing reconfiguration =>
 EOI interception testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the testcase that verifies KVM intercepts EOI for in-flight level-
triggered interrupts across routing changes to test multiple interrupts,
e.g. to ensure KVM isn't processing only the highest priority interrupt,
and to test both in-service (ISR) and pending interrupts (IRR).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/ioapic.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/x86/ioapic.c b/x86/ioapic.c
index 7d3e37cc..e46eae2f 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -373,28 +373,58 @@ static void test_ioapic_level_retrigger_mask(void)
 	set_mask(0x0e, false);
 }
 
-static volatile int g_isr_84;
+static volatile int g_isr_64, g_isr_84;
 
-static void ioapic_isr_84(isr_regs_t *regs)
+static void ioapic_reconfigure_dest(int line)
 {
-	int line = 0xe;
 	ioapic_redir_entry_t e;
 
-	++g_isr_84;
 	set_irq_line(line, 0);
 
 	e = ioapic_read_redir(line);
+	report(e.remote_irr == 1, "Reconfigure Remote IRR set");
+
 	e.dest_id = 1;
 
 	// Update only upper part of the register because we only change the
 	// destination, which resides in the upper part
 	ioapic_write_reg(0x10 + line * 2 + 1, ((u32 *)&e)[1]);
+}
 
+static void ioapic_isr_64(isr_regs_t *regs)
+{
+	/*
+	 * Raise the IRQ line for the higher priority interrupt, *before*
+	 * reconfiguring the I/O APIC routing.  KVM should intercept EOI for
+	 * both the in-service vector (line 0xd, vector 0x64) and the requested
+	 * vector (line 0xe, vector 0x84).
+	 */
+	set_irq_line(0x0e, 1);
+
+	ioapic_reconfigure_dest(0xe);
+	ioapic_reconfigure_dest(0xd);
+	eoi();
+
+	++g_isr_64;
+}
+
+static void ioapic_isr_84(isr_regs_t *regs)
+{
+	report(g_isr_64, "Higher priority IRQ should be blocked until IRET restores RFLAGS.IF");
+
+	++g_isr_84;
 	eoi();
 }
 
 static void test_ioapic_self_reconfigure(void)
 {
+	ioapic_redir_entry_t d = {
+		.vector = 0x64,
+		.delivery_mode = 0,
+		.dest_mode = 0,
+		.dest_id = 0,
+		.trig_mode = TRIGGER_LEVEL,
+	};
 	ioapic_redir_entry_t e = {
 		.vector = 0x84,
 		.delivery_mode = 0,
@@ -403,11 +433,21 @@ static void test_ioapic_self_reconfigure(void)
 		.trig_mode = TRIGGER_LEVEL,
 	};
 
+	handle_irq(0x64, ioapic_isr_64);
+	ioapic_write_redir(0xd, d);
+
 	handle_irq(0x84, ioapic_isr_84);
 	ioapic_write_redir(0xe, e);
-	set_irq_line(0x0e, 1);
+
+	set_irq_line(0x0d, 1);
+
 	e = ioapic_read_redir(0xe);
-	report(g_isr_84 == 1 && e.remote_irr == 0, "Reconfigure self");
+	report(g_isr_84 == 1 && e.remote_irr == 0, "Reconfigure self highest priority");
+
+	d = ioapic_read_redir(0xd);
+	report(g_isr_64 == 1 && d.remote_irr == 0, "Reconfigure self lower priority");
+
+	poll_remote_irr(0xd);
 	poll_remote_irr(0xe);
 }
 

base-commit: 68fee697b589b7eb7b82e8dd60155c5ccf054275
-- 
2.48.1.711.g2feabab25a-goog


