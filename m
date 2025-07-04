Return-Path: <kvm+bounces-51606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A76DDAF9714
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EB4C562118
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE3C2F9484;
	Fri,  4 Jul 2025 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="HHCkA/GO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26D62DE6EA
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643539; cv=none; b=kPPm3UuUcfc2soxim59hr+mFUWZGqIdFWJuAMPLJ5oCaSQeRZDgKTWQhY4VyzUVzz+AXqyH95dpN0YMJC7V7YCmIYxPCqJT0k+NcBz9F6eUDhDsttnpLp52IhEedtBCOKGF6SI7QAUq1VmbfSy/DHzeKKrlFvX93KutcPS+8aHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643539; c=relaxed/simple;
	bh=Rn0ct3v4rW64OlY7++1Oc0LAQJA4hk8QYtJnzRwiqYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbpaVVSxss0ptrDQtbw9cSK4j5qzjX/f4gzQ2oD0AkPPuVEBTiMH2WB8UeqodmXZx0J4ny8DqGm4ayJlPZzuUB0y6C50uWi3Dy8ZbuhneiJWiuwO0/Gzx5TcFI9sjc4f35Syf7K8ZqSalsF2RhOlyh9YZPxRSfwCuXuWJln6EuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=HHCkA/GO; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-747fba9f962so883113b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 08:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751643536; x=1752248336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zp7uD1poiW059gGzU86bprSx2F9Pa7gwCpaEXnEz8mU=;
        b=HHCkA/GOZXOkxIV/OVBar8WxFX4UU10HhVy9r1NiTIpqR8B8PYIbuhF7WHfM517tCp
         QovJGsdJqljBllpUi5QprabMLvxVssEt7xCRxC5KiOysrYPrZyUFkH3veorfgko79Q4h
         99hr5MbjdSxCTsUsfLT9TagYoFUUuwwVs3NFXiXItEQdywEG/AldsZNOT5RqKqjY+UN5
         jgFigWf2+j+3brebVCPZF55prJwKPNvqSI9D/hZHCU8jreqUpqdOlNe8G2cOa4bX0nnt
         WUFcfiBhZLG3XtyLGKsOhYPxy0I3Cytof/cVKEAZrCgeNuuwH/o4HN3+Ey2Hl1ybF7XO
         DjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751643536; x=1752248336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zp7uD1poiW059gGzU86bprSx2F9Pa7gwCpaEXnEz8mU=;
        b=dDzhbmXWnD8I5adKHxREQExSzGBRD97n/wFiVykXIMPqrF4uduDvniX8KyDNnsYcH9
         aeaaQR3JJNbDL8T1pYd+fPYFxHN0hiVMwnlEEKzsJ1ObCSr3oPSowRfBQCmvefkiIdC/
         pCTuESJ5HsQPFAW9URLoV5qTm0B8jbx+MqXainCh47fSDpuiu6Z75MpqtpQiBjd5BpFi
         Lr7qR4fcGw0VxAtMqD6XnSPyUhlwpkUsAU2psbqX49eimhARPjG2/IWtq0nTMiWRsX9S
         a59bn9PpnGrCiPCF213pZNGh1dP3cAPbjNw0/n4E5eUEToZ4oq3y6zzRovjeTvNy4h5H
         n1Tg==
X-Forwarded-Encrypted: i=1; AJvYcCVLvIrjUts6iGFHHF3Gzwx7PXExJx9JGiwFSxE0Y+E0gFo/bvbalAMpA3p2dJTriTovscU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPOUn7elrSdPDOlG0GY+MNj2B8G+uebzddXTj06wnNrp2a9PnG
	JnaXXfux9ALGobFYhbkOx/AA8QLMBVhPkYpEnb8H0q/0lQf4zBHxBW6TDh1NkInLLAQ=
X-Gm-Gg: ASbGncsIjGABxyWJQhq83ELiwZehx6M6wGbpWT8I7c6Qx4AWcGTAooKV0gSziOGDHc9
	x+8D/b3AffKTr6xc6nGjlTzvivGhP+jDweXQBYamTahti9rj8BW2Qn+I52YhK/4KY4jQdS+upGr
	hPzR1uEQeLSoAG60PUAg93la7tCKAstmnmkCGUXch74dprUWAZ4kf2kMXk1naEPzz23cDa8bhdh
	qUW687yyJH39/BT9KM/o8DVrE/fTSOkXRSz7GgUXbkFTst0LSAjF+RZz7iGNYgvmcCd6A4G1ngN
	nfrPsRLDwIEXtqRDg09WkHUFIVJCF6iUycHcXjcw11zhctIdzwPVKpdTnszZhcMtSKvZQ9OZ9A7
	Wtgv24NqNiyWk6ZaMqw0=
X-Google-Smtp-Source: AGHT+IGIXVrx9PSDrG3EEvpjwpw1PdozZsTf2OUe+pqrmlHyZJisYpgboZx4tCy5PCWnKNZpHdxUDw==
X-Received: by 2002:a05:6a20:a11d:b0:220:3804:f3d6 with SMTP id adf61e73a8af0-22595173066mr5303101637.2.1751643535243;
        Fri, 04 Jul 2025 08:38:55 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee63003bsm2084818a12.62.2025.07.04.08.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 08:38:54 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 1/2] RISC-V: KVM: Disable vstimecmp before exiting to user-space
Date: Fri,  4 Jul 2025 21:08:37 +0530
Message-ID: <20250704153838.6575-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250704153838.6575-1-apatel@ventanamicro.com>
References: <20250704153838.6575-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If VS-timer expires when no VCPU running on a host CPU then WFI
executed by such host CPU will be effective NOP resulting in no
power savings. This is as-per RISC-V Privileged specificaiton
which says: "WFI is also required to resume execution for locally
enabled interrupts pending at any privilege level, regardless of
the global interrupt enable at each privilege level."

To address the above issue, vstimecmp CSR must be set to -1UL over
here when VCPU is scheduled-out or exits to user space.

Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
Fixes: cea8896bd936 ("RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc")
Reported-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2112578
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_timer.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index ff672fa71fcc..85a7262115e1 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -345,8 +345,24 @@ void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
 	/*
 	 * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
 	 * upon every VM exit so no need to save here.
+	 *
+	 * If VS-timer expires when no VCPU running on a host CPU then
+	 * WFI executed by such host CPU will be effective NOP resulting
+	 * in no power savings. This is because as-per RISC-V Privileged
+	 * specificaiton: "WFI is also required to resume execution for
+	 * locally enabled interrupts pending at any privilege level,
+	 * regardless of the global interrupt enable at each privilege
+	 * level."
+	 *
+	 * To address the above issue, vstimecmp CSR must be set to -1UL
+	 * over here when VCPU is scheduled-out or exits to user space.
 	 */
 
+	csr_write(CSR_VSTIMECMP, -1UL);
+#if defined(CONFIG_32BIT)
+	csr_write(CSR_VSTIMECMPH, -1UL);
+#endif
+
 	/* timer should be enabled for the remaining operations */
 	if (unlikely(!t->init_done))
 		return;
-- 
2.43.0


