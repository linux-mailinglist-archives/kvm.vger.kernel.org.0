Return-Path: <kvm+bounces-23637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 128F794C1A7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B109B212B3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530A618FDBF;
	Thu,  8 Aug 2024 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IEhBCwlo"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06B918FC8C
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131758; cv=none; b=LbvXku+TuaFIx0KNRraADAFqbkWgMBzwR2cNxkbQvXUMt+ZKkRT7GHLyNAX0E9UQQWaR8IhBZ9+vfrcq4I+LsixCaUxMK9etJYylRiDVsfOyUxzVPIrZPSLPbj/x53fTZqdRteUc+owCP2hGenQmrr7B53VN+n9z46mBpcbMNeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131758; c=relaxed/simple;
	bh=CgK8IQsCFIqZyQM74+tfbF6V14abW0bGt2YLw7wtktQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wzggd/tpsxt8RLgQoWKoHl3weJxLxb5yll5MqCPTogwwFVopP8A8grJTlrChXgi86jDBUPVen/5GFsrTpz/kC7CRkvg+W0OTRsRWyUDlIoaLnUdQA8k0ErW0Bt9ePCLBbIg8Rf/OQh8Sv+KzGNlsI39Xw4foSUZlHo2W1Yg9Ic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IEhBCwlo; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723131754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HzOqAtg2J4AwG0o9+R6F8Ao/GNJA6cEB1EV+uLHrR9g=;
	b=IEhBCwloanW/93UZXk0oJNfWI1BGtyZxUGck6bpD+/Ic/lkltssMpVab4L0Ik5qReKitFL
	AfskR2H2gS2kIcXqqK3jwWvtbeqTIYWeAFGn0DrcHw2QRsBZlprlxOtr1r6GOPhBAbEa+W
	BXx/DrqCQj5tF3qrFfhkNSlab/HvYag=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 2/4] riscv: Build with explicit ABI
Date: Thu,  8 Aug 2024 17:42:26 +0200
Message-ID: <20240808154223.79686-8-andrew.jones@linux.dev>
In-Reply-To: <20240808154223.79686-6-andrew.jones@linux.dev>
References: <20240808154223.79686-6-andrew.jones@linux.dev>
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


