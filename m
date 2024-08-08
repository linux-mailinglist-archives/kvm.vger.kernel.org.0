Return-Path: <kvm+bounces-23624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB9F94BE1E
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E06FC1F23AF5
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B72F18CBFE;
	Thu,  8 Aug 2024 13:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eK+6voUl"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F7518CC04
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 13:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723122171; cv=none; b=rw74KNESrr87OiauVF5mLdioqACl3DT0RqczGqZa651h4Hcp2d3MTC1noiP7X/501JW61/IG0PgnLQf+yaXOWeb/LMAJiu/Jz+VrHI41bh6h0Rn8zEzX/44P1Ycev4bLZo1UJ2f4j281UoJU8VaiQGp2BY2lW1qHU4icc/PQAyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723122171; c=relaxed/simple;
	bh=CgK8IQsCFIqZyQM74+tfbF6V14abW0bGt2YLw7wtktQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti4C+eLGSHZh5jdOPYla142HYKfrbDGATJ1+vVXkMuhlWXz7szVpNpIw9CNxHqAggzxiI97Pi/p5IXAX2hejrZgiU13oH4+Hmx+fnAI0w7avtIWi6K6GCodZ6ZmDE1Y5uuYQU4nLs6XcrH4LY8Q85amBThd/My2AT+BvY9DyvFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eK+6voUl; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723122164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HzOqAtg2J4AwG0o9+R6F8Ao/GNJA6cEB1EV+uLHrR9g=;
	b=eK+6voUlAQAFDJWcVObJNNagx1HJp0V/94MIslPF8AgyQtKN9x0NbRZ2X5/NUwNTf1nzmW
	zyp3jaHOveh6VGXL1OMTagZYZ07HjGZdLg0SsZl/7JVVwtimtaXORCozqSn/0A68U9ZDxl
	aunyfqoVrn92SmGBdvhzHeiuZddCaws=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/3] riscv: Build with explicit ABI
Date: Thu,  8 Aug 2024 15:02:32 +0200
Message-ID: <20240808130229.47415-7-andrew.jones@linux.dev>
In-Reply-To: <20240808130229.47415-5-andrew.jones@linux.dev>
References: <20240808130229.47415-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we add -mabi to the command line then compilers that are built
to support multiple ABIs may be used for both rv32 and rv64 builds,
so add it for that reason. We also need the right linker flags, so
add those too and throw in a trimming of the ISA string (drop fd)
in order to keep it minimal.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/riscv/Makefile b/riscv/Makefile
index b0cd613fcd8c..7906cef7f199 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -64,13 +64,15 @@ define arch_elf_check =
 		$(error $(1) has unsupported reloc types))
 endef
 
-ISA_COMMON = mafdc_zicsr_zifencei_zihintpause
+ISA_COMMON = imac_zicsr_zifencei_zihintpause
 
 ifeq ($(ARCH),riscv64)
-CFLAGS += -march=rv64i$(ISA_COMMON)
-CFLAGS += -DCONFIG_64BIT
+CFLAGS  += -DCONFIG_64BIT
+CFLAGS  += -mabi=lp64 -march=rv64$(ISA_COMMON)
+LDFLAGS += -melf64lriscv
 else ifeq ($(ARCH),riscv32)
-CFLAGS += -march=rv32i$(ISA_COMMON)
+CFLAGS  += -mabi=ilp32 -march=rv32$(ISA_COMMON)
+LDFLAGS += -melf32lriscv
 endif
 CFLAGS += -DCONFIG_RELOC
 CFLAGS += -mcmodel=medany
-- 
2.45.2


