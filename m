Return-Path: <kvm+bounces-24660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB8A958CB2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 19:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2190C287509
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 17:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37871B9B5C;
	Tue, 20 Aug 2024 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wyJO7ml/"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF17194ADB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173317; cv=none; b=I0pbnR0G6vzdulDmjNSMsD+QEXN9DAmvHFCSqSeu0Xd97e9rHK+qP2WNbSr+IhSHq6245teXYEFJg2oU8B/GyDNGRFFzDCIK7/Lf+3fh3NLmWsmxa+NiER0vyJhciAKGcZpvb06BcMZeFVIG9ipRHq6UAnQBcrbkSIOly8aCvLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173317; c=relaxed/simple;
	bh=2/aFjMrkgGhmC4u0/g+3iEXDhvvqoZdXSJP5gpMv7aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GIM/bJPMI3Sz+BjQZH1AxULGGLTzUW4+Lw4hPBHM9dWbG4eoJ61TbPbwjHd0YFkrn2ubJ0f496cONClB+yJbExSMndYk2OiQEGxQ2tLOaI5IVDGTPJaOiBudppm22tO8eHHyxjjF1yfvLwtK/MWC2BaY8M/b1sRmBDwv8OBXD6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wyJO7ml/; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724173312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ffjiH+w0RQrA/Op0HSZ3lh7h7WKn/rLox1bPjyeZuIE=;
	b=wyJO7ml/ra1egCeWWzzkqONU3DuwWiJN8blCH80dr/loVdlZx3qIMSOdMrnBnXtztUrnWu
	6fCfyx55W8RgI3x9sCv2iIyZgJ40uNZfz0rGxhL8PVZG0q/5uqZwJ8ZGNJFJnNHfbRmh2Y
	6KqJgPOtChXD2gSLdtF8M99swviiMo8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] riscv: Make NR_CPUS configurable
Date: Tue, 20 Aug 2024 19:01:51 +0200
Message-ID: <20240820170150.377580-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unit tests would like to go nuts with the number of harts in order
to help shake out issues with hart number assumptions. Rather than
set a huge number that will only be used when a platform supports
a huge number or when QEMU is told to exceed the recommended
number of vcpus, make the number configurable. However, we do bump
the default from 16 to 2*xlen since we would like to always force
kvm-unit-tests to use cpumasks with more than one word in order to
ensure that code stays maintained.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure             | 8 ++++++++
 lib/riscv/asm/setup.h | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 27ae9cc89657..6a8d6239a3cb 100755
--- a/configure
+++ b/configure
@@ -77,6 +77,8 @@ usage() {
 	                           Specify the page size (translation granule). PAGE_SIZE can be
 	                           4k [default], 16k, 64k for arm64.
 	                           4k [default], 64k for ppc64.
+	    --max-cpus=MAX_CPUS
+	                           Specify the maximum number of CPUs supported. (riscv64 only)
 	    --earlycon=EARLYCON
 	                           Specify the UART name, type and address (optional, arm and
 	                           arm64 only). The specified address will overwrite the UART
@@ -168,6 +170,9 @@ while [[ "$1" = -* ]]; do
 	--page-size)
 	    page_size="$arg"
 	    ;;
+	--max-cpus)
+	    max_cpus="$arg"
+	    ;;
 	--earlycon)
 	    earlycon="$arg"
 	    ;;
@@ -496,8 +501,11 @@ cat <<EOF >> lib/config.h
 
 EOF
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
+	[ -z $max_cpus ] && max_cpus='(__riscv_xlen * 2)'
+
 cat <<EOF >> lib/config.h
 
+#define CONFIG_NR_CPUS $max_cpus
 #define CONFIG_UART_EARLY_BASE 0x10000000
 
 EOF
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index a13159bfe395..43b63c56d96f 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -2,9 +2,10 @@
 #ifndef _ASMRISCV_SETUP_H_
 #define _ASMRISCV_SETUP_H_
 #include <libcflat.h>
+#include <config.h>
 #include <asm/processor.h>
 
-#define NR_CPUS 16
+#define NR_CPUS CONFIG_NR_CPUS
 extern struct thread_info cpus[NR_CPUS];
 extern int nr_cpus;
 extern uint64_t timebase_frequency;
-- 
2.45.2


