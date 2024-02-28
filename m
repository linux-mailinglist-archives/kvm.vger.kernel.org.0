Return-Path: <kvm+bounces-10277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B836186B2A4
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E40631C25FA7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53ED215D5C5;
	Wed, 28 Feb 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P6CxIScy"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2AF15B10F
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132688; cv=none; b=JKBOjVujzQGrLai/ksuZy7zOG8d3iXmsGV5vQYJZNmuEehtLhD/9bFP50/wnlOxis0Qsns+0Pfwfg73jtVDO0j+o6LxCRgd8BKMlG4InOxITrU9wKY6Vbz90qsuBspnEl+6qxBQ+3Wdh64W+ipjQVYHIIGm5zXmsVopDxs0xLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132688; c=relaxed/simple;
	bh=SF46SACvCYi0qVyxekhbN1GgwIPsU2q1L/owS53bYwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=nO8vG1vw/0FQoz0VyqU7PChAec9EgsU9MB/cqJQQnLZe4JYPsop7DrPfUW9I/PpPPShZla4ayCgxLBj1q3j51fqU49ug31km1Eax6V9L/xpZ19FQKjvaY+wUYD62xBVX8LsZNHQQhaCHibc4fq+7uPpbtS/oplKSFwbel94WCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P6CxIScy; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zLj+MnchB/t7dGQsunecmxj+nVdvCSLI2wlcyi2JSHs=;
	b=P6CxIScyFBSn4/Ckz75VaYL0UkR0mZFSLLklntmlpCnfGKBVWJ4F/1z4R5sj0MlmdKVvYI
	BHUBj3I0d2m0w8t5h1z/Qg4Jc222uuLp/IpscRBWA2I1CYA/vLKlbecpgkDF9qbr74B08g
	LaGgtgsjfFey/Ytflg1vzq+plwaWGrE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 08/13] riscv: efi: Switch stack in _start
Date: Wed, 28 Feb 2024 16:04:24 +0100
Message-ID: <20240228150416.248948-23-andrew.jones@linux.dev>
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

Modify gnu-efi's _start to switch the stack. This allows us to not
map memory regions which have EFI memory type EFI_BOOT_SERVICES_DATA,
as the stack will be in the EFI_LOADER_CODE region instead. We'll
still map the stack as R/W instead of R/X because we'll split the
EFI_LOADER_CODE region on the _etext boundary and map addresses
before _etext as R/X and the rest as R/W.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/efi/crt0-efi-riscv64.S | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/riscv/efi/crt0-efi-riscv64.S b/riscv/efi/crt0-efi-riscv64.S
index cc8551a43c6a..4ed82b14a1d6 100644
--- a/riscv/efi/crt0-efi-riscv64.S
+++ b/riscv/efi/crt0-efi-riscv64.S
@@ -164,7 +164,20 @@ _start:
 	bne		a0, zero, 0f
 	ld		a1, 8(sp)
 	ld		a0, 0(sp)
+
+	/* Switch to our own stack */
+	mv		a2, sp
+	la		sp, stacktop
+	mv		fp, zero
+	push_fp zero
+	addi		sp, sp, -16
+	sd		a2, 0(sp)
+
 	call		efi_main
+
+	/* Restore sp */
+	ld		sp, 0(sp)
+
 	ld		ra, 16(sp)
 0:	addi		sp, sp, 24
 	ret
@@ -172,6 +185,11 @@ _start:
 // hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:
  
  	.data
+
+.balign 16384
+.space 16384
+stacktop:
+
 dummy:	.4byte	0
 
 #define IMAGE_REL_ABSOLUTE	0
-- 
2.43.0


