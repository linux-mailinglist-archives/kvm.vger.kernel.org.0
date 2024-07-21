Return-Path: <kvm+bounces-22022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E4C9383AD
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C07291F213FE
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 07:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DE38801;
	Sun, 21 Jul 2024 07:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7r5wanU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B9579DE
	for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 07:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545605; cv=none; b=ac59kjJMLtFNJ2PppOOWJssSnkoBT6r6kwoqvfwvjFHT4aSiL1DFTcVK0g93PcRVZgXK3F7rH9HNVqsaJ1sCk0Sli+5ul/CY13lOkvhOVXcoOuc1AW52qVxnGV509AjiucobMQpFk7Is+sHNfRWXPGxk3OrGtwGn9KBvpH1FPlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545605; c=relaxed/simple;
	bh=+n3qbfDTrboEdcvpcY3rZAfV/jBQ7snQ9EH7EftH8lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn6LUj38owVQVw6M7AFvEkgxiktrRNmBHWFb3cVs8gRpfXlpym+8yKqQOX4CXZ+r3FglH5knQGFTQ8BVsmAir3iiWNkzLm18LsswANqE8TncKMHBQ2Wlt2DgRhtfC4my7igP+2iEIam+EBsuyG7dP+nzPzg7l2/ZQyp15RrpVaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7r5wanU; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d162eef54so297855b3a.3
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 00:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721545603; x=1722150403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=R7r5wanUgqgcUjBr6XxYRYFGuQ2v3TimpNoW5EkmHdyaBHupnNgmbXdYhzm0WwOBI2
         K/G4QoivkM2CmoHYAkrq7ox3GhQDPfXUq/4HdGf74YXKhl8Wkn3peOtmiSZ06mnplHT7
         2NtG1dGoluaLGmRW1Jwv8JAiB2/dUva5dP5bznU7zsze6PS2oCIP5ahG2PsUcbTdto/C
         C2ME9mhRXt6e+RpDcxJQxBVDf1lJVYDwR4iZC9KKA/lzxQF80H5X3nIQVEPcdgZe8aRd
         PI56K4ZpTVluEG+M18HHpIBu2VNmzu1giet3rTZEs/v/6oeXhZI+9xx2YPrm+d/f121Q
         WuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721545603; x=1722150403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=qOAhXkH+/coJIaxjs09SO7A1xCRvgYsK/HTfZDc7lwhsG23A7e0G4va7X2WswMfTXy
         svAsYOhtCgWv+Uc3g7Zj0OdTOy4LHUmfTxUK1OKU1n5FQ7D/7bKU/jopu03wtWV4fedX
         itcZn1gwqtwFHPJAxC6b9CaRyWQpPl/YjUgKGHOz+ta4KBri03kxZe0BLUKttB7GZR0Y
         jkCzoDTYNBbj0rYYOj8oc/nqCsDNL/12vnLFXLi969s85Tyyz1rhApG8rXdsqK86b6tK
         G/PlyYkxq+fNsfINBvUa7wuW8/Ziih9EY40lKj4/NBsydPtSoqm2pXycskfheNlz47Ov
         EklQ==
X-Gm-Message-State: AOJu0YyPBhkxxA5Agdhj7KJw9VLQQzfRaYG5ahyJNUUKlRyXy494BoU5
	o/D2W2WxZLIsOn9IDBrcACdN0N+QngQOy0jOuGPxyzhlaq1dwABgU8j3obw5
X-Google-Smtp-Source: AGHT+IE3oS77IFsILowoEEOxHGX2hEBQPecGS32oyXyjCa+VZh+RcoTDPe3ttc2tgNOV3HU0a/svFA==
X-Received: by 2002:a05:6a20:12cb:b0:1c3:b0d6:e496 with SMTP id adf61e73a8af0-1c4285ef1c1mr2301170637.45.1721545573585;
        Sun, 21 Jul 2024 00:06:13 -0700 (PDT)
Received: from JRT-PC.. ([180.255.73.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77492bc6sm4891461a91.1.2024.07.21.00.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 00:06:13 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 2/5] riscv: Update exception cause list
Date: Sun, 21 Jul 2024 15:05:57 +0800
Message-ID: <20240721070601.88639-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240721070601.88639-1-jamestiotio@gmail.com>
References: <20240721070601.88639-1-jamestiotio@gmail.com>
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


