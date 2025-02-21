Return-Path: <kvm+bounces-38875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E0BA3FBB0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D96BA86780A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9E71F03CC;
	Fri, 21 Feb 2025 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CplyT0LA"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712F51DE4E5
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155295; cv=none; b=UiNc73Az5xdnTAu04apa/X41fBcNBVHGJQxYr47al6w0v4m6t175Us1Ck7+Hf6zhA3SDTogEfY3UVQ7b4ej1pHAZYeevLEAgk9hpKvcqmiSUo3ZX2dy62/Cd23s6Ms1hgIRqMFgN2ovt+xlUXYXhaqdiet5mlSyQbgDnVHxeOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155295; c=relaxed/simple;
	bh=xgB10XgTEp0Er+2vX1VBUXrSWNPYzktBBdP+/cMZvpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hiqq+an+yWerSgfppoGO3GFybr3O5BgbxLUelhX4AfH94DFaGkhceTUd2BqzEfTQE3wFvwWPXoV5OgTynlf2WSkPK6k7mIBwE2a7EXwxfW7A3ueX43E6mFvjXqopKLvpC3JqrTRC4Ps+N94PsjhZ72WnppFOr9UuffFMHeKo6/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CplyT0LA; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vn1FEnDRGik68LJLDBAQGF/TsL5Y6BbtDhdl0uXVpLU=;
	b=CplyT0LAD8EI6ezTBgStuYQDrzqWjOBeNroi1+vA48eOwXqFbPa/tnzVBIBeHrPzsBGCT0
	KKbcep5jgAwaFvxnAVbs0oKCz54DhV1qjdIaTV2s8lWB1Nfevni/khdah+WRlKE3vmcNXU
	XcYA6E4LULrNAEwoT8IArkpDM+5+voI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	atishp@rivosinc.com,
	cleger@rivosinc.com,
	pbonzini@redhat.com,
	thuth@redhat.com,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [kvm-unit-tests PATCH 2/2] riscv: Introduce MACHINE_OVERRIDE
Date: Fri, 21 Feb 2025 17:27:56 +0100
Message-ID: <20250221162753.126290-6-andrew.jones@linux.dev>
In-Reply-To: <20250221162753.126290-4-andrew.jones@linux.dev>
References: <20250221162753.126290-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Andrew Jones <ajones@ventanamicro.com>

Allow riscv tests to use QEMU machine types other than virt.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/run | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/riscv/run b/riscv/run
index 73f2bf54dc32..e2f5a922728c 100755
--- a/riscv/run
+++ b/riscv/run
@@ -10,10 +10,12 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 
 # Allow user overrides of some config.mak variables
+mach=$MACHINE_OVERRIDE
 processor=$PROCESSOR_OVERRIDE
 firmware=$FIRMWARE_OVERRIDE
 
 [ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
+: "${mach:=virt}"
 : "${processor:=$PROCESSOR}"
 : "${firmware:=$FIRMWARE}"
 [ "$firmware" ] && firmware="-bios $firmware"
@@ -23,11 +25,11 @@ set_qemu_accelerator || exit $?
 acc="-accel $ACCEL$ACCEL_PROPS"
 
 qemu=$(search_qemu_binary) || exit $?
-if ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
+if [ "$mach" = 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
 	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
 	exit 2
 fi
-mach='-machine virt'
+mach="-machine $mach"
 
 command="$qemu -nodefaults -nographic -serial mon:stdio"
 command+=" $mach $acc $firmware -cpu $processor "
-- 
2.48.1


