Return-Path: <kvm+bounces-49380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18445AD8379
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4766A3A160D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B232580D2;
	Fri, 13 Jun 2025 06:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gtjJGXfp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8233825E461
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749797909; cv=none; b=Yuy1PagMPs8N7aIfpnQfip0RkXlDoH1nELDJ0sXbGpdp4e6LUDsw9pFcaXumM+5WNUXhtf2quc/aNInjegEBcWC9lBrMSF1+XUNMVQO3jLw/rpR7fTC+x2twt7U4k/bmJZkhJlyue/5VU8PI4wBlfqzoSwpUbzhB+uPNTSwvbz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749797909; c=relaxed/simple;
	bh=qTPZRepGLDx8d3DYNhCymSXfQSTRSyyKFvfeW+3S2AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx02M7xmZEgt+kvqRikenNIrMN/7K+Ms0TpAPBYPwegS8i+G6lzbJpnpsA3KwcwRHV8w3l21ur45T4Kkdlo9t9yf2BDV/XvvjgTH4tcoV99PvtJDYQdeN9FOINKrmjldUJFlIOkALWlCSIdq/bvHlu5NUq9X6iqW264zv1RyeD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gtjJGXfp; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-311c95ddfb5so1519834a91.2
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749797907; x=1750402707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9NuUqyMjDjOZ8RZ5AE6YpvMfKBxH1jx9BmTdXWsOf0=;
        b=gtjJGXfpiXGwTK7oENzX7mCPiRVNvNLhV5Et5pgvxhM9hGwCKqAIVtpeTQbBVEhVTO
         1Gi/YLzkHDo2qMesuleDicqYu7Bmty6Ea64RNsoTsRiSAYvG0QQ4uYKNKwPIYj9nfIAw
         AFkbKbHxC3cesIPsdcznWDyrBHjMKCQVWC+rKdV9tx6WGp0VAYKbwoijBFrzavIViwdi
         1whXwll/rnSaaP/qZGT6CTzTN0k+rsz90FT+FTExMTR2v7FgGCY+MImmxFuz+qAUOlNv
         IicPDTUfuVKrpeT1YK63t78aXPWfJEbX9qaOYV/EYY8anRZw/cJ70zN+uhV27XlN/Wf9
         wLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749797907; x=1750402707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9NuUqyMjDjOZ8RZ5AE6YpvMfKBxH1jx9BmTdXWsOf0=;
        b=j0YjXApDY0cUHLwGYVCF+l5bS/K8eGp0JMuk/4J2HzcTtUAR5iTC9mlP7mYkAP7zEa
         O4dxv09RTC1sfWHzdx3dHpJnrOREGBYGpNnUtSW0aQyfOE/XgvWCjDuZ4mc2hU2dkUIZ
         Zf8vUAbY6Z8HzLmYVKQCA5Nl6amQjbEh56ZXHO8m2lQDY5mOLdpvAxjp3UUIu681OZ4M
         T9lAuWQv5kFcn2eM2h10bVmWDd8bdnkjS8RPTkOJCRBfl2a9/SkGB5BflvEOuLEX/9vt
         TYxUQTXKYdt2GfE0GAjfIFrwAkfq+oOcxwJC7nY8d3fK6UN+XT135pHsUIdadtqSJKYL
         Z3iw==
X-Forwarded-Encrypted: i=1; AJvYcCXnCAJyXbAA6dqwrOQAXdQDGrbQO4VkUeUGlbaipkkPzwybHTzShk2slckGt7DXGcFyt6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPN63WiZDC12jAxOkGvkEBSVYgKQsqqS3PEiyivC3HLgaR7oun
	n2Ci46MczrCS703wKXxmXasEZYSOflLjDUyWs3o/2/BsSijKqodoefldUt8dh4t7i/o=
X-Gm-Gg: ASbGncuJw01m8FH1I4adAx0m5/Nmnx/lsYJ/MhWgkXaSpbLQPvaNZ6DUSt4fEjWA8wn
	gZFwnEDGgIe03UFflSorw8oyfD5bCypM2gAA2+0THyEsxZO9ScyI0QHxweGewazJkiqlbsObVLE
	REF+8nigsBywnoCaqXAlkKkY+qx0c+RrwNoB/vsygXHv/ccqd/88kAXGS28DkMgSmLy/iO2rHxy
	51M8RZiG4iQhxVdnVqctZtZc+25ZgLpXQQX6JRJBTjfgKVuTjXYSLK454nyBmE8r0Y05otPErEf
	XEA+3ZAn2Rx/OsFrYW+OLnH7kjlpQxc0fsDZmvESyeEQ0cQ1/c+o7MMB1NodWygjo51unpy1Qdp
	b7sJqxA+6jLV3ztNnJ2c=
X-Google-Smtp-Source: AGHT+IE8a5t2vAc7uHbhW52m189RNr8N2yqc2jJGrHdRdfFv50kYLOdkbxH34MMXUkyP4JTNM1l//w==
X-Received: by 2002:a17:90b:2686:b0:313:db0b:75d8 with SMTP id 98e67ed59e1d1-313db0b77acmr2060784a91.32.1749797906744;
        Thu, 12 Jun 2025 23:58:26 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49b7fsm2653022a91.24.2025.06.12.23.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:58:26 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 07/12] RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
Date: Fri, 13 Jun 2025 12:27:38 +0530
Message-ID: <20250613065743.737102-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250613065743.737102-1-apatel@ventanamicro.com>
References: <20250613065743.737102-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The H-extension CSRs accessed by kvm_riscv_vcpu_trap_redirect() will
trap when KVM RISC-V is running as Guest/VM hence remove these traps
by using ncsr_xyz() instead of csr_xyz().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_exit.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 6e0c18412795..85c43c83e3b9 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -9,6 +9,7 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 #include <asm/insn-def.h>
+#include <asm/kvm_nacl.h>
 
 static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			     struct kvm_cpu_trap *trap)
@@ -135,7 +136,7 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
 void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 				  struct kvm_cpu_trap *trap)
 {
-	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
+	unsigned long vsstatus = ncsr_read(CSR_VSSTATUS);
 
 	/* Change Guest SSTATUS.SPP bit */
 	vsstatus &= ~SR_SPP;
@@ -151,15 +152,15 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 	vsstatus &= ~SR_SIE;
 
 	/* Update Guest SSTATUS */
-	csr_write(CSR_VSSTATUS, vsstatus);
+	ncsr_write(CSR_VSSTATUS, vsstatus);
 
 	/* Update Guest SCAUSE, STVAL, and SEPC */
-	csr_write(CSR_VSCAUSE, trap->scause);
-	csr_write(CSR_VSTVAL, trap->stval);
-	csr_write(CSR_VSEPC, trap->sepc);
+	ncsr_write(CSR_VSCAUSE, trap->scause);
+	ncsr_write(CSR_VSTVAL, trap->stval);
+	ncsr_write(CSR_VSEPC, trap->sepc);
 
 	/* Set Guest PC to Guest exception vector */
-	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
+	vcpu->arch.guest_context.sepc = ncsr_read(CSR_VSTVEC);
 
 	/* Set Guest privilege mode to supervisor */
 	vcpu->arch.guest_context.sstatus |= SR_SPP;
-- 
2.43.0


