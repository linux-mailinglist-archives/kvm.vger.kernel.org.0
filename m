Return-Path: <kvm+bounces-22466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B8B93E8AA
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7B0B1F219D7
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 16:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7146F2E7;
	Sun, 28 Jul 2024 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIAfft2j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A216EB4A
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 16:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722185437; cv=none; b=VbI1opy4AnZkzhTNHNPTcG9WQZWuoQFvFZWw8A93T6d0axicWH4u/BJR4AasNRAi89VA1PmSG00mCN9053caPIpO2rZBehNY21XgRmbigUco8mz2mktlycUequDZ/WAcp897HRC4KOK0isznB21bGr7VPXliqeDBp0tbyVpHP9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722185437; c=relaxed/simple;
	bh=+n3qbfDTrboEdcvpcY3rZAfV/jBQ7snQ9EH7EftH8lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGaQ1B1h2fr15H4yAPr8awaWP7GUlNlLtrPoMxb+FnBMxVkS4kEoItIk6PaSQBYQT/FCruZ/fAMYffNJLahNuuybCO2AcPB6n9s6XwfPiAeLDviSjhMSN/64A18G0iWA/kEfNGoh6lsIpb811f66rmMehYDbt5qJ2vgf9lROg9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIAfft2j; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7a1be7b7bb5so1815716a12.0
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 09:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722185434; x=1722790234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=SIAfft2jb58ia4cjIQdpsT2bgHFdouuYoHM9yfprFtxQppcCeK1gE6ZUJEhGBX7Fky
         pa6moHeRoAo0XfOz7wCSDj3vKRAP8GpMt89FhpJd73BBrTaYxdq/vFr7N+GB+e23/s+i
         hcQq/oQYW5tFKCq4Lhy1VdLg/DZwe84C0fvn0gCVLypQ6BG2jVszk0jx5nrAl6Ap7A41
         cwrPbBpG4QTELtYKZ5JPvseZjffL8Pnjy9gmGOn1Px6XPtuJKaK8LkLEy36PbDDTRBFW
         U3m7REsJkt2RsD3Y1cJnnJBE4zQIG8UCeUVKVqV8PS3TZUeKOIWbIaMGEZcha1U6SMau
         9mcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722185434; x=1722790234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOqEXJYpkIexGhOwSJXzU52SvIkIRl2QtZdZCBi6Nm8=;
        b=GMKjHAullGgNkMiBzJSBdKJUGB7AfA5qADwjGxrQ8O/DDY7Mt4tQtXUivkQGNsHOeh
         Nx0YOOeEBRkL97Gz6CaeVqYhllBMFmmrNYYPdxKEPlmdScZKMi5I7W7YQuE0QBFuKLQU
         WFQlrSJoYbi57oFeFslklfcFcUNDc+p9v77dlDp/Wrnao/QfM5ve9vDU7olKFxictVlN
         yvp0uPopcAYFWfnk3T+0lWWXg7ByEDDHOxlaekTTVSmt2dYaOF3zH0UC9bBKoZYHYocK
         hKzlmP/Nx0KBFNbdUXwwUCcXWIpcmSRL0rt8MEWmWU8a0bDskpFoaXUuDkAwC+D12R5j
         SmGQ==
X-Gm-Message-State: AOJu0YwwKASMxpPJh0yHXtZ5Uu655Tx6NPEbqoCmJKJmmixnyAyspRCj
	mYTOlDdiy0TArhmQLGC0vTq6Zut8rAyiixb9vbtUoJEEhOCBfNxvUBZoo4wYOnA=
X-Google-Smtp-Source: AGHT+IHBehQfUl43pl87MBLoudRTrQi+1NmSaB0NMvafYFNyG5eqBWcRyS9up0/MAd+jD3xhfsygUg==
X-Received: by 2002:a17:90b:a49:b0:2c8:6bfa:bbf1 with SMTP id 98e67ed59e1d1-2cf7e21686fmr6427272a91.23.1722185433915;
        Sun, 28 Jul 2024 09:50:33 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c7b0besm6969413a91.14.2024.07.28.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 09:50:33 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 2/5] riscv: Update exception cause list
Date: Mon, 29 Jul 2024 00:50:19 +0800
Message-ID: <20240728165022.30075-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728165022.30075-1-jamestiotio@gmail.com>
References: <20240728165022.30075-1-jamestiotio@gmail.com>
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


