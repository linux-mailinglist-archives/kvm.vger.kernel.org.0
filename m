Return-Path: <kvm+bounces-26058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E197F96FF25
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 04:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CB321C22625
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C3618030;
	Sat,  7 Sep 2024 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1hksnPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9287BB657
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 02:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725675216; cv=none; b=Ax2Vzx+25Ww1Jy0eQtchCJxG6FqBB+BedR+Dz1oPQoM4E5QOIP+cBcftTHVT6mtuiaJkYqKcMB4S/5fmUcKrS1Mo0Wlh263u5dhlVZH7DH8WdDu+H6y3dAswchWpoQMEo5FWjKUujSju1JiFt6RPyQOayGKk1YZDbUgvwdS/eXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725675216; c=relaxed/simple;
	bh=zgEzgYLSAchG5PJB2AbhaR1UbSHiMBkVsMmMzgtnIkk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSFlTKAGndtV2KACFp9wgbhfXnbig97TkdE1pBPMFVCg1hgtJ4kSUwiPcxIUUyS3X7exSOgPVnY5wxZ8dc3/faRQttrzCN6xkn8b8LjODWJeyGGxJzBC3sGyxTPez9sk5evO1dTP5WXDFnvtU2OJPFLmEf3qYr8gTvkiGu8b8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1hksnPQ; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-7b0c9bbddb4so1960998a12.3
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 19:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725675214; x=1726280014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fBGwH5aWbuMHbi0Io1NaVUmOBYWFUf8E5xda+muzUlU=;
        b=V1hksnPQWFYxOZdBmouSFQIayGWJsLdBHJ7IEGkIH9wlFclSPvvBJoqErFIO4tKuBJ
         R/fQT+unT3nXBpw0lxDgk7+RUkQDPcPyJ8u+wLMGwW9fTB9gibwz7QRd8oOtv3ScFMIq
         vUG1SL1ZxxLZryXn723sz8ZwZZZwu+uD1zh6yWdYRSVLzQB9mnYeLK3EVrQtMdyLb1go
         L5z9DVrMXPGY4xwhre30Y6ckfcgqCzIQU3JX8zotCJK4iJulSeXfdRsMICpIGtYth+9l
         TSM3n19R0XGyfTsgeB17/LFI0tdj9hUHJr33BZLz5zPGtQEuMYif5okUf90r//jdsxFd
         bRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725675214; x=1726280014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBGwH5aWbuMHbi0Io1NaVUmOBYWFUf8E5xda+muzUlU=;
        b=po6B19rXPCZw18KZQUcwAboNL0uYdJnFLStF9UWAl42v7Foy9rqQYVqla5Br3jlErc
         VISjcIZZDdgyThxEObTf2R6TAWuqDsy3GsVIfSNZM67PLlttsn/d3VCRoJjWdY8bvQw3
         NB3opex+i9Lg2xaw6Zvcd+sHKwXvRKGTQVdoR/5LTVIuhP+FuNhnZ5UXU/awg0rCZ1zA
         duWKKkARxEcyPeXYlPUw+1gRgVX2GUE2DhW4i6lJR9H4B7Q+Q+qWNvxEme10GBrHe4Wg
         WzaJzVz/Cw6rwWujX/4VPPkDqPqDDWNgPLd9iauxSXmhuEMlCYRduBRs1s02zlVJXmoS
         0a+Q==
X-Gm-Message-State: AOJu0Yy2IkBBwzmBBrHcFR3qJBFqI14oMIfwErTMzlAbgN6AX13VDAJH
	yEd7xkKnSjFNXEL7jMSgVRN/igPj5++lz6Cg6iIqaEPwYvxgua+ufjz4ndXwGyoAMA==
X-Google-Smtp-Source: AGHT+IHQT2uPrHRywLkhuJoHLE16hMx9eNG44SsAiV6yjVlv2a+C4PIVODDLy8PoMJZxEMEolw42mw==
X-Received: by 2002:a17:903:110e:b0:207:14a8:4e9e with SMTP id d9443c01a7336-20714a84ff6mr128985ad.29.1725675213249;
        Fri, 06 Sep 2024 19:13:33 -0700 (PDT)
Received: from localhost.localdomain ([14.154.195.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f20104sm1215845ad.233.2024.09.06.19.13.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 19:13:33 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 2/4] x86: Add the ISA IRQ entries of mptable
Date: Sat,  7 Sep 2024 10:13:19 +0800
Message-ID: <20240907021321.30222-3-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240907021321.30222-1-sidongli1997@gmail.com>
References: <20240907021321.30222-1-sidongli1997@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Missing ISA IRQ entries will cause the guest kernel to report some warnings
or errors, for examples:

1, If none of the pci devices are registered, the guest kernel will report:

[    0.022503] BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)

2, If the guest kernel cmdline does not have the "noapic" parameter and
one or more pci devices are registered, the guest kernel will report:

[    0.033913] BUG: kernel NULL pointer dereference, address: 0000000000000004
[    0.034313] #PF: supervisor read access in kernel mode
[    0.034614] #PF: error_code(0x0000) - not-present page
[    0.034911] PGD 0 P4D 0
[    0.035062] Oops: Oops: 0000 [#1] SMP
[    0.035277] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.10.0 #95
[    0.035628] RIP: 0010:setup_IO_APIC+0x23e/0x7e0
[    0.035892] Code: ff e8 16 f6 ff ff 89 45 88 e8 5e f6 ff ff 83 3d e3 93 e1 ff 00 8b 1d d9 23 f1 ff 89 85 78 ff ff ff 44 8b 25 d0 23 f1 ff 78 1b <41> 8b 76 04 8b 4d 88 41 89 d9 45 89 e0 89 c2 48 c7 c7 70 fe 8e 81
[    0.036965] RSP: 0000:ffffffff81a03e20 EFLAGS: 00010002
[    0.037267] RAX: 00000000ffffffff RBX: 00000000ffffffff RCX: 0000000000000001
[    0.037681] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
[    0.038092] RBP: ffffffff81a03eb0 R08: 0000000000052da5 R09: 0000000000000000
[    0.038503] R10: ffffffff81a920c0 R11: 0000000000000000 R12: 00000000ffffffff
[    0.038918] R13: ffff88800205f628 R14: 0000000000000000 R15: 0000000000000005
[    0.039329] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[    0.039798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.040130] CR2: 0000000000000004 CR3: 0000000001a13000 CR4: 00000000000000b0
[    0.040542] Call Trace:
[    0.040692]  <TASK>
[    0.040818]  ? show_regs.part.0+0x1d/0x20
[    0.041053]  ? __die+0x52/0x91
[    0.041234]  ? page_fault_oops+0x56/0x1b0
[    0.041469]  ? exc_page_fault+0x3d9/0x5f0
[    0.041707]  ? asm_exc_page_fault+0x27/0x30
[    0.041952]  ? setup_IO_APIC+0x23e/0x7e0
[    0.042181]  ? clear_IO_APIC_pin+0x127/0x1f0
[    0.042430]  ? clear_IO_APIC+0x34/0x60
[    0.042656]  apic_intr_mode_init+0xb5/0xc0
[    0.042896]  x86_late_time_init+0x16/0x30
[    0.043131]  start_kernel+0x546/0x5b0
[    0.043345]  x86_64_start_reservations+0x29/0x30
[    0.043619]  x86_64_start_kernel+0x78/0x80
[    0.043858]  common_startup_64+0x13b/0x148
[    0.044097]  </TASK>

This is because there is no ISA IRQ 0 entry in the mptable which is
required by the PIT. In addition, interrupts for the 8250 serial device
will also be unavailable because there is also no ISA IRQ 4 entry in
mptable.

Solve the above problem by adding all standard ISA IRQ entries.

Fixes: 0c7c14a7 ("kvm tools: Add MP tables support")
Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/mptable.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/x86/mptable.c b/x86/mptable.c
index f4753bd..82b692e 100644
--- a/x86/mptable.c
+++ b/x86/mptable.c
@@ -171,10 +171,8 @@ int mptable__init(struct kvm *kvm)
 	nentries++;
 
 	/*
-	 * IRQ sources.
-	 * Also note we use PCI irqs here, no for ISA bus yet.
+	 * PCI IRQ sources.
 	 */
-
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
 	while (dev_hdr) {
 		unsigned char srcbusirq;
@@ -189,6 +187,23 @@ int mptable__init(struct kvm *kvm)
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
+	/*
+	 * ISA IRQ sources.
+	 */
+	for (i = 0; i < 16; i++) {
+		if (i == 2)
+			continue;
+
+		mpc_intsrc = last_addr;
+		if (i == 0)
+			mptable_add_irq_src(mpc_intsrc, isabusid, i, ioapicid, 2);
+		else
+			mptable_add_irq_src(mpc_intsrc, isabusid, i, ioapicid, i);
+
+		last_addr = (void *)&mpc_intsrc[1];
+		nentries++;
+	}
+
 	/*
 	 * Local IRQs assignment (LINT0, LINT1)
 	 */
-- 
2.44.0


