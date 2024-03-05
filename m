Return-Path: <kvm+bounces-11049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECAB872553
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A05FD1C22DCB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3526A18E3A;
	Tue,  5 Mar 2024 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vvmIDvs5"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DD318E14
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658565; cv=none; b=Q4mzIx4y38xMBXQ9zjkbg8qNGu1SdByGZGiwT221uiqLuXUJc6ZUEEsAFst3RnrBvmSeGFu1Et4khLNJmY6yJ1jGChVvkj0fmj+n/bnDDDBlUMqdh5g+1UrPtpGJtxeTah6Qo97Sr+p3SH+XTqDsJ8WdXQykz7tjqNesU4naJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658565; c=relaxed/simple;
	bh=t4qs1j1Jaf7RIelbQmV+6dKsnEXYutJ25gzZT+FJKo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jWADRwoDIet8g181xKDEu4dwITu5hrHZ8KITnyeTdPrSHazkGoil+wbVQ/SdB5l0fzsOcNS1N9nBMOHetSzNW+6Eq9zilClZISZ0wAQ8xtzLj9u1TzbXPX2I4RyCfMKqEKkLB2RfogTNV4BX+pbRIyfL1zqU/cf3T5EEkq7a37A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vvmIDvs5; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=60erSBumokDdrzjlqC5ZP+QvOuHbufETq/jMNeBQ/NY=;
	b=vvmIDvs5rFqIDCkmOpDKsPS++4vCt8uFCkUHvpqB05TY9EB367Pt4zX1Urxc0+tG+mEQSg
	RmqrgrjkmqqC4zJ6dRx7nurOUkEbwpKYI/c7tiMDeYpEJtxvdNoETNTT7pJfJgshEKcAAi
	5VxHMmPuanhBEWquUwRos3ZT1RYrFKc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 08/13] riscv: efi: Switch stack in _start
Date: Tue,  5 Mar 2024 18:09:07 +0100
Message-ID: <20240305170858.395836-23-andrew.jones@linux.dev>
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
2.44.0


