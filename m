Return-Path: <kvm+bounces-11047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BB5872550
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FAE1B270D2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5ECD18638;
	Tue,  5 Mar 2024 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YERdQQ5S"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F491429F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658559; cv=none; b=n0r10hd0WLIPPrno+xtOkkjWOgXzzoy6kKKAr1e3X48AIIjJ/FnyrzlDEQe6kHxoif0BTLNSqf1kV5yt/EhhPuzm9YrTBs7YsUqXcE7jZ7xdkTeYGwx6lpcuvJs5cb4H8fxnz28UC43UAEL+14roUyfrB4juCwMVrWvRdJ/cW/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658559; c=relaxed/simple;
	bh=NQKR9uiwQKQcBaNtvzjCEYVzArwzcFKNv2EW+ukbIAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=tp+PnW+cfo+NiHgCvfNRByVylYaUvOxU0oIBepOqC3F8tpjWpcvKwsV52uSKTf5H3NxBsPKA4SrgbKJ3wO4q8YKAOXbyn+YRqY80O/Ab25V6Wr7B3J1egrhq2rreuoInhknid5A8pd3KzsTj7lgG2NGUEGZ4JGUQl0lzB++ZixI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YERdQQ5S; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TSzY6c0NTNFPm5RO7QsohC8jXB7go0VxC3RrrYX+zZU=;
	b=YERdQQ5Sf1Fx2gpQlmRs99lChwm3tBVTra6wIOzWP82p6JFiqMTzuo8SV/wENYSmMrBQb0
	roZQNMpcvHRscwdDOetlkrmuGNYr/mWafwWG38xcsk+wkA5nMe04VnVaMUmtexcxhj8voV
	427Z8wvWhuITneCYQ/8Li9fEDF0edCM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 06/13] riscv: Tweak the gnu-efi imported code
Date: Tue,  5 Mar 2024 18:09:05 +0100
Message-ID: <20240305170858.395836-21-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
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
2.44.0


