Return-Path: <kvm+bounces-10275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD41B86B2A2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD5ED1C259D0
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B69E15CD42;
	Wed, 28 Feb 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="skoxnggH"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0204715AAAC
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132686; cv=none; b=ZlT0LJOlaerqpFfiBpVwfWfr7MQtM6du+2bRuzvXUgzXOFa59CYTpl7SShZwLYX1sHZiH9GFjWL9jSsyjcrYqlGxI7BsVfljjZYl7ilAdtyreCEBpdKeFLwo1ihseGbDzrPWQ7SAMFVZh6ULhG8cW/7d453SwgbY5u0j6Jmu1PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132686; c=relaxed/simple;
	bh=m1NNgqn8GbsO5SnDgqtg48JezOAP1dYXnWWv+N3UaT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=V3/et5Nnp1piZZsIWduhBIR5JYkOPFHTAq9sVKmY4Ctp8K3rIE1AwFDxdhoxAhgIeoe9hXcKrHuISFH4/wCoblMQSbNBBv+QSmoz5LTWX+PFVwrsfx7o6/HpVpInn/0Lrwe052/o0w3QJl7flvJ/MZWfNX7jf2K1ESZx7Zgc4P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=skoxnggH; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ykwsl0F2m9+gdVtWH8miRYdFoTg7bR7yVkPyTpkLmcs=;
	b=skoxnggH3pL8EyKu949p9m6lrXeCh+jb4hwm2SqZ3nbAk4q1NFXnbA9HP9QGfYLsdWOsVl
	kQ568W8SI4jQp8PcEfm2Q8RAc/VfKi/+qPEZsHYXPkUlVDl+SV7kcqp0+WeNmhz8C1/qW3
	paYX0WO4Sc9dFAvNN1d40JsUCgR28kU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 06/13] riscv: Tweak the gnu-efi imported code
Date: Wed, 28 Feb 2024 16:04:22 +0100
Message-ID: <20240228150416.248948-21-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Change _relocate to match the prototype in efi.h (it doesn't
matter that 'handle' and 'sys_tab' are unused). Also add
R_RISCV_RELATIVE to efi.h and replace '_entry' with 'efi_main'.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/elf.h                    | 5 +++++
 riscv/efi/crt0-efi-riscv64.S | 2 +-
 riscv/efi/reloc_riscv64.c    | 3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/elf.h b/lib/elf.h
index 7a7db57774cd..fee20289e1fc 100644
--- a/lib/elf.h
+++ b/lib/elf.h
@@ -65,4 +65,9 @@ typedef struct elf64_rela {
 /* The following are used with relocations */
 #define ELF64_R_TYPE(i)		((i) & 0xffffffff)
 
+/*
+ * riscv static relocation types.
+ */
+#define R_RISCV_RELATIVE	3
+
 #endif /* _ELF_H_ */
diff --git a/riscv/efi/crt0-efi-riscv64.S b/riscv/efi/crt0-efi-riscv64.S
index 712ed03fc06e..cc8551a43c6a 100644
--- a/riscv/efi/crt0-efi-riscv64.S
+++ b/riscv/efi/crt0-efi-riscv64.S
@@ -164,7 +164,7 @@ _start:
 	bne		a0, zero, 0f
 	ld		a1, 8(sp)
 	ld		a0, 0(sp)
-	call		_entry
+	call		efi_main
 	ld		ra, 16(sp)
 0:	addi		sp, sp, 24
 	ret
diff --git a/riscv/efi/reloc_riscv64.c b/riscv/efi/reloc_riscv64.c
index e4296026e2a4..8504ad595e51 100644
--- a/riscv/efi/reloc_riscv64.c
+++ b/riscv/efi/reloc_riscv64.c
@@ -44,7 +44,8 @@
 #define Elf_Rela	Elf64_Rela
 #define ELF_R_TYPE	ELF64_R_TYPE
 
-EFI_STATUS EFIAPI _relocate(long ldbase, Elf_Dyn *dyn)
+efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle,
+		       efi_system_table_t *sys_tab)
 {
 	long relsz = 0, relent = 0;
 	Elf_Rela *rel = NULL;
-- 
2.43.0


