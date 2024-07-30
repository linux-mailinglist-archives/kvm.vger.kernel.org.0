Return-Path: <kvm+bounces-22585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 012D694082E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0F26283D43
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 06:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4507018F2E8;
	Tue, 30 Jul 2024 06:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="noy18f/3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02E18E776
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722320314; cv=none; b=Eus5igskBrif4zPMnUeHXyHG+juDFUoMrUg1xM5EfoMB5XYsyudAxsPmXd98uDaOFe0nslCgyCMMzQtM+9jSRyWEZNgB1iAxwBjoYCHWTdIFGci9xPxVjUHL4DF0pwSmNh7YjCXUVK+4wmZCf2c4c+gV9LHwFhsHiDyxJ496Hno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722320314; c=relaxed/simple;
	bh=+n3qbfDTrboEdcvpcY3rZAfV/jBQ7snQ9EH7EftH8lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCIplHifVgpbEvUeF+nj7FOR+4HPmX3AgqE/H4tvubmjQghqbh87oM2dPe/ry6caLHLR3St9ODph33YjZuAEOGA8hBOwa7tSJxd45qP3cyu8SsFh+JAE0KGX1J2ZHS9hWasFt9xnIl5tXpXbf3KnOHpyrwTXVw84Z2jNaAXz7ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=noy18f/3; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d1c8d7d95so2532721b3a.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722320312; x=1722925112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=noy18f/3UvPO7AyjOEVcqlWoQnPA78468gD2rp011xBHk7oJi9gDdgy6Ub+MXElEAy
         wxEjcQ0EuWypBiwMLzdujU2nJKuBrBicwGI5KiXbUJptAhwdtX0dtUxgiBlmJe0SvQgs
         MsOOYUlGZwLD13Qwy6acnxClLaT5wVMLlRNwvXPnlNq1JJOX2vTvmzbrGTuR7w7y1UCu
         0wJFXQJlkZt1q/JQRvkSBHeVY3CUS/XtJA750Fk8s+2y/jopLAy7F30t2TBqWncAcNYw
         AyFP5dntuNppsUmuzy5LqoIFSaGOyFwZ7mmJEK/UR2oxHskkp4vIyEvlo04AhFjVh9fr
         xolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722320312; x=1722925112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=WPDXEO27TVAVy9N1oqMmI0g5Vqd32+uxAgSm9qoiggGbmyrC7iDLaoPQYHviueKeCT
         wVVHPg/Z38UfqB26vfGBqrt/wJ0ba3LuLfXmFIx3UuG4L1/QTZDSFsMhWME1pS2x92f7
         gyRyJC3LYTTL2Z813SlreHAGvWG/G4MZmBaIDP5foTq8vYfqejKIBREtHUg4ZmYbeVGd
         /gAao+2LXISAuXEIfcp+IiZOOL70Bb7GRjuO3f6IqgnZo375AKlrYwit7N4pfEKiuFyy
         4wV+wKcFzvlcHU8oMONTjazm64sSjTKFlumrxjCf5zg5pP2+ol42SKOQ8wI32SzFz8CE
         ZfZg==
X-Gm-Message-State: AOJu0YzG01UVnjCm6dhOZXWSDvVV+wBLpwOzwmRrzRLFYJzIBvx0lMQq
	rVpHcVlFeLdf3QKdqKRVRjP3edX19uVAOhEhJHJz8JBls93au1yPS70LgxX3IZg=
X-Google-Smtp-Source: AGHT+IGueUZNpYqBiwQ62P95Q5NRqthBhu516As+jDWGSNvqn1Hw5DPqrLuTQBmoOvfL7J5BmHJ/oA==
X-Received: by 2002:aa7:88c5:0:b0:70d:262e:7279 with SMTP id d2e1a72fcca58-70ecea01412mr10223964b3a.3.1722320311581;
        Mon, 29 Jul 2024 23:18:31 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e161dsm7732781b3a.42.2024.07.29.23.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:18:31 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 2/5] riscv: Update exception cause list
Date: Tue, 30 Jul 2024 14:18:17 +0800
Message-ID: <20240730061821.43811-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240730061821.43811-1-jamestiotio@gmail.com>
References: <20240730061821.43811-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the list of exception and interrupt causes to follow the latest
RISC-V privileged ISA specification (version 20240411 section 18.6.1).

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h       | 10 ++++++++++
 lib/riscv/asm/processor.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index d6909d93..ba810c9f 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -36,6 +36,16 @@
 #define EXC_VIRTUAL_INST_FAULT		22
 #define EXC_STORE_GUEST_PAGE_FAULT	23
 
+/* Interrupt causes */
+#define IRQ_S_SOFT		1
+#define IRQ_VS_SOFT		2
+#define IRQ_S_TIMER		5
+#define IRQ_VS_TIMER		6
+#define IRQ_S_EXT		9
+#define IRQ_VS_EXT		10
+#define IRQ_S_GEXT		12
+#define IRQ_PMU_OVF		13
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 6451adb5..4c9ad968 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -4,7 +4,7 @@
 #include <asm/csr.h>
 #include <asm/ptrace.h>
 
-#define EXCEPTION_CAUSE_MAX	16
+#define EXCEPTION_CAUSE_MAX	24
 #define INTERRUPT_CAUSE_MAX	16
 
 typedef void (*exception_fn)(struct pt_regs *);
-- 
2.43.0


