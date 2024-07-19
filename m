Return-Path: <kvm+bounces-21910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC0293728B
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 04:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 352FC1C20893
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2151863E;
	Fri, 19 Jul 2024 02:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsNd6IX+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CECC17BD9
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 02:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721356804; cv=none; b=E3wbDYS3O+L5I0MJKkEv/DiaJWfjmic7rD8rOLfKVsiVIKle8dIBj8fD0HDRTVVJM8QX7zRDsZyWq/UOM36U8fNUrM3iBj52e2MIvmYMxtfBK7GZcqa3U7+tmrnuTW13iMa4pf95x/yScykjWuIK/WAK9tgZQfLysj7/dJvthlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721356804; c=relaxed/simple;
	bh=+n3qbfDTrboEdcvpcY3rZAfV/jBQ7snQ9EH7EftH8lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMvePzzfxM72mYZgsIRPOcOJrq6YwLC+vx9ejxzOKeo8lEGf5OksWCCvLhAL1Mkw3pqmQaWFLqb/D2/1NACbFhPtljfzH9HqGvQRjnuP8Ow1P5HvidAPeNGWDVPvLviRzV9c0+PuXLVWygjmbU4jUgIiFUy52iMVQJmQShgUHII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IsNd6IX+; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3d92d1a5222so845518b6e.1
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721356801; x=1721961601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=IsNd6IX+g2bA8nDJD2ax4ZEHyInvy+2UXYlwPoKxOPMs94AmmWbkuaoQzeELs+VK6M
         ZGOQ5NoJf64rKdWoF5K2bztqRfZWBUK2yME/Rp9Z/ZuFRh6ynfwfcDz1EhjCvPv5Lv+8
         qLzJuMLGqCVZK5G9AY091bluraA5K5SDK6o/JUOSKfhSEIDzHbq/B7TOKngTUPLsIpHN
         rOeuN3aiojdYPls5zNp1Hun43m4WMy41AGZaZ+DzwAhyvVsAzlvCfpI8AYqRpN7ZRVjS
         flzfUGcgPPe+1jUBslfaT5+hQSI1sOUTEKlgWttQoYAjUlQ3u9W0lCjC38/spdwlPFuy
         G4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721356801; x=1721961601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=Q4RkTw1yMDAD+/9+tAcCw1dRaPhqws+G0G9EkvnHMeQ/tCpDul0Axyr6M2a/sirqnm
         HlbbkCR+PQFAK2WbEDtz6NlM5U9QcbC0Q6Ps5sqhVU+vwdKfsOlEtCelh1W5HuXRGgA6
         G/UN6oguwzDGfGjRxdiVe4LQCxvTnKFgjOkN/JYcIyX0mo5fvFUBF66cSbmc44GVdeTe
         Qgq1Di1+PpTd06OhA64ccjFPt6M+DqYLQymx+LZ3yjaVGWVXoXSebFnV0efpU3zcZYVA
         0Ggm7a/BcgGj/TuIQE4AnE5yPmiUgBB1ZavlS5rIERoHisZL2SknfLm8tZTlCkQZYUPM
         h2Yg==
X-Gm-Message-State: AOJu0YxElTyFlSE8sLP0QBtYCetI6SaUjb6DtVMgNz81ItmfFU7A6Lp4
	d2gYMKMx0wOUYYkoxW6v7cm2SaS5ddZPan+C5/X/DB2GSjbIirnYUpSgGAKw
X-Google-Smtp-Source: AGHT+IEgSdUOdRVWVRUT3GsQg5RO6N/d5Cu5ZrjCn7Ff/U+19qpx6zxyOovgaJBR5b8ea7A23+A4+Q==
X-Received: by 2002:a05:6808:1395:b0:3d6:2e85:5c34 with SMTP id 5614622812f47-3dad9a2d485mr4024788b6e.38.1721356800727;
        Thu, 18 Jul 2024 19:40:00 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff491231sm234930b3a.31.2024.07.18.19.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 19:40:00 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 2/5] riscv: Update exception cause list
Date: Fri, 19 Jul 2024 10:39:44 +0800
Message-ID: <20240719023947.112609-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240719023947.112609-1-jamestiotio@gmail.com>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
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


