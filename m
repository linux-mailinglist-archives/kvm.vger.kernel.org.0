Return-Path: <kvm+bounces-14183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7195A8A046F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 02:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 001DE1F23EE8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22248175AD;
	Thu, 11 Apr 2024 00:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BCBKNXIb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63BE171C1
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712794105; cv=none; b=sTNe/XeeWZtPMe9zcrNdvNfqyxtbuw0s3ghhFCQ63v6m0BW2W6DNrV80ggPB8d1xO7UswxQ4kO93LeLc4/+zhHj+BFw8LkQ/36Cdgncyr3sIvmS02PpRz9QdVaLG8X/9cg7x1ldgM6EllQjn1obwwHnuUYi++SHqh7JyPDwA9yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712794105; c=relaxed/simple;
	bh=akgdKSazpCJozBL9deA+0ximAc5a6b6WW9ag1TZQiU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bzfj1P54uyleoPNCuOOa8Ds7Z+ylhPwTmrQdHwUHwhObZRhUtRq6OFrxhDElnPct7eg17qcmM38IBKoefCsjlLwFT3spu7102vvLRidSzvjnupAn9dgPyU0UiKjaecElq4riCfZGDeu++9MmRuanVQbrvFE+CLmG3tMw7Wb1JiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BCBKNXIb; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e3ff14f249so2792295ad.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 17:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712794103; x=1713398903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkMvEzo278xPIa/MSXztYs2ivQ6wYMeKBg/aNDTTbzU=;
        b=BCBKNXIbkZntYOTh3cUZPuq6pjHIynaCZrVPAwz9HusMxPrsd8XsoTnr9GRGlH7beI
         n53PcAN8vW3S+pq2WqN1FsS5njPPtaEgmArHHGNfsNYlbRUA5gQWN0UDSiluYSJ52qpB
         iM26epDvTGAeBhzDvuVAF8gTbIpBpXSGajb+auoxq1EQo1HF3Wsq3kuOOMTuUIlW6q+g
         T3E7VxR//A774kmeJ/bmCbQ7psD6rGBfKr2z+KqBHB2j7mdOdoDCnhTDr9Z454uDWWqg
         AMsCeXlmm0ESOUyXxb5F6jZiVYXG9gZ0y32pjIViwxJJjwKSTDmHo6WcPFZwNXW/p/+E
         RoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712794103; x=1713398903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkMvEzo278xPIa/MSXztYs2ivQ6wYMeKBg/aNDTTbzU=;
        b=YPrMS3b0YuyH9sy3YdymcCDs9Lq6GAarX56lI6dfXFRko2aVMht+uYGQdqaU1OlOBZ
         2NBNf6sBmaY4nxRTsekLI0ouUEnwpFiO39dQqk+YCrGWpXmmZYKLEBWCU4aBmPZdfu0U
         YXJ9Bg+i35MM3ITkNhqQ26aBDIFh8r3di5EP4bLeG+H4dqIWihFWdkq6c1G32QJZsBBa
         1wxPI9BZkrTnM2gMemwgkPHoiF9X/qLud5eAviT1UWkQtUDUgnFAdAUZKI0Y+p4Czps7
         QpEmkk4umtO/38HtiocZrmYHDpMBn6UOlMjE9p3J286SIcX46xLxqDryil28TwzPLr3q
         z45A==
X-Forwarded-Encrypted: i=1; AJvYcCWF2zzfbuEMi/eP8bNUWftQNNxm2BQPbLeiPxeUBVZ4sxnlE/J68Qeqyk69L1L68tlHGH3+iWGIELkPofG+KxZpbyG7
X-Gm-Message-State: AOJu0Yy7MrPNEIf+5NNd1UYqVyntHNSjhPHtBZUY+Ijtrc+HDWY5Eeic
	idpQx6hJ/VJP/WHKs7mxCIca4c4z7pvokLbcSguEvxpGyZ/vbH8yUHLNGgeJrJd+1QmIKM8RXlc
	L
X-Google-Smtp-Source: AGHT+IGgRaxQYW8bBoO59l6g97lF6DWJlZ8qPVf66iIYAUNC2ixkF2eOsdNbKg8PB+Igg7J274SeEA==
X-Received: by 2002:a17:902:ec8b:b0:1e2:bdef:3971 with SMTP id x11-20020a170902ec8b00b001e2bdef3971mr1459480plg.16.1712794103281;
        Wed, 10 Apr 2024 17:08:23 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b001e3d8a70780sm130351pln.171.2024.04.10.17.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 17:08:22 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v6 06/24] RISC-V: KVM: Rename the SBI_STA_SHMEM_DISABLE to a generic name
Date: Wed, 10 Apr 2024 17:07:34 -0700
Message-Id: <20240411000752.955910-7-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411000752.955910-1-atishp@rivosinc.com>
References: <20240411000752.955910-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI_STA_SHMEM_DISABLE is a macro to invoke disable shared memory
commands. As this can be invoked from other SBI extension context
as well, rename it to more generic name as SBI_SHMEM_DISABLE.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h  | 2 +-
 arch/riscv/kernel/paravirt.c  | 6 +++---
 arch/riscv/kvm/vcpu_sbi_sta.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 9aada4b9f7b5..f31650b10899 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -277,7 +277,7 @@ struct sbi_sta_struct {
 	u8 pad[47];
 } __packed;
 
-#define SBI_STA_SHMEM_DISABLE		-1
+#define SBI_SHMEM_DISABLE		-1
 
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
diff --git a/arch/riscv/kernel/paravirt.c b/arch/riscv/kernel/paravirt.c
index 0d6225fd3194..fa6b0339a65d 100644
--- a/arch/riscv/kernel/paravirt.c
+++ b/arch/riscv/kernel/paravirt.c
@@ -62,7 +62,7 @@ static int sbi_sta_steal_time_set_shmem(unsigned long lo, unsigned long hi,
 	ret = sbi_ecall(SBI_EXT_STA, SBI_EXT_STA_STEAL_TIME_SET_SHMEM,
 			lo, hi, flags, 0, 0, 0);
 	if (ret.error) {
-		if (lo == SBI_STA_SHMEM_DISABLE && hi == SBI_STA_SHMEM_DISABLE)
+		if (lo == SBI_SHMEM_DISABLE && hi == SBI_SHMEM_DISABLE)
 			pr_warn("Failed to disable steal-time shmem");
 		else
 			pr_warn("Failed to set steal-time shmem");
@@ -84,8 +84,8 @@ static int pv_time_cpu_online(unsigned int cpu)
 
 static int pv_time_cpu_down_prepare(unsigned int cpu)
 {
-	return sbi_sta_steal_time_set_shmem(SBI_STA_SHMEM_DISABLE,
-					    SBI_STA_SHMEM_DISABLE, 0);
+	return sbi_sta_steal_time_set_shmem(SBI_SHMEM_DISABLE,
+					    SBI_SHMEM_DISABLE, 0);
 }
 
 static u64 pv_time_steal_clock(int cpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index d8cf9ca28c61..5f35427114c1 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -93,8 +93,8 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_vcpu *vcpu)
 	if (flags != 0)
 		return SBI_ERR_INVALID_PARAM;
 
-	if (shmem_phys_lo == SBI_STA_SHMEM_DISABLE &&
-	    shmem_phys_hi == SBI_STA_SHMEM_DISABLE) {
+	if (shmem_phys_lo == SBI_SHMEM_DISABLE &&
+	    shmem_phys_hi == SBI_SHMEM_DISABLE) {
 		vcpu->arch.sta.shmem = INVALID_GPA;
 		return 0;
 	}
-- 
2.34.1


