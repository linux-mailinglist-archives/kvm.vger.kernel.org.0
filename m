Return-Path: <kvm+bounces-5218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D267E81E0AF
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74DFC1F222C7
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E1856391;
	Mon, 25 Dec 2023 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYOnsCqw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269C456380;
	Mon, 25 Dec 2023 13:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B638FC433C7;
	Mon, 25 Dec 2023 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509205;
	bh=StaFuzcUuHAmdOS1W5kvlQVaB4JSpyMdgCSoJ5pjJQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYOnsCqwgW1tcB47qW116GGBQZB/reWYmeKv8UYPQHedatg3VxtJfbdBfVGXMQevr
	 JeywBCUgiEQ3YDWKXmC6KX2u2QKvcmgG9DWgQj7ygvxrpF99qol9yCZrgIg0tJZ38w
	 RygQO05nm3btR9KtQ9RSuhb+KX474IW6gTMveqDA0D92U8yTKieklcIcwsz1Rxngwe
	 Nqq4IW5JlgtqZh5FI+f4t1Oen+Q/EgnW2Cx+hx5SEW5sOEYCL3p94rgX59YmVKukbk
	 s3HQ08nKf8P5EWFKjk8tAXFqELPR5S1t26WTmTy+BbHx4uXCoyk7ATebs4LR3cBS+l
	 2a9uuVpXNhkLw==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	panqinglin2020@iscas.ac.cn,
	bjorn@rivosinc.com,
	conor.dooley@microchip.com,
	leobras@redhat.com,
	peterz@infradead.org,
	anup@brainfault.org,
	keescook@chromium.org,
	wuwei2016@iscas.ac.cn,
	xiaoguang.xing@sophgo.com,
	chao.wei@sophgo.com,
	unicorn_wang@outlook.com,
	uwu@icenowy.me,
	jszhang@kernel.org,
	wefu@redhat.com,
	atishp@atishpatra.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH V12 13/14] RISC-V: paravirt: pvqspinlock: Add kconfig entry
Date: Mon, 25 Dec 2023 07:58:46 -0500
Message-Id: <20231225125847.2778638-14-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231225125847.2778638-1-guoren@kernel.org>
References: <20231225125847.2778638-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

Add kconfig entry for paravirt_spinlock, an unfair qspinlock
virtualization-friendly backend, by halting the virtual CPU rather
than spinning.

Reviewed-by: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 arch/riscv/Kconfig         | 12 ++++++++++++
 arch/riscv/kernel/Makefile |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index b7673c5c0997..7df3d50733c6 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -780,6 +780,18 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config PARAVIRT_SPINLOCKS
+	bool "Paravirtualization layer for spinlocks"
+	depends on QUEUED_SPINLOCKS
+	default y
+	help
+	  Paravirtualized spinlocks allow a unfair qspinlock to replace the
+	  test-set kvm-guest virt spinlock implementation with something
+	  virtualization-friendly, for example, halt the virtual CPU rather
+	  than spinning.
+
+	  If you are unsure how to answer this question, answer Y.
+
 endmenu # "Kernel features"
 
 menu "Boot options"
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index fee22a3d1b53..2e0754e422cf 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -102,3 +102,4 @@ obj-$(CONFIG_COMPAT)		+= compat_vdso/
 
 obj-$(CONFIG_64BIT)		+= pi/
 obj-$(CONFIG_ACPI)		+= acpi.o
+obj-$(CONFIG_PARAVIRT_SPINLOCKS) += qspinlock_paravirt.o
-- 
2.40.1


