Return-Path: <kvm+bounces-29222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 871269A5687
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C5841C24A5D
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509A619D09F;
	Sun, 20 Oct 2024 19:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NlXB87Xt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8351419CC16
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453689; cv=none; b=OJxfezE5ZWDiRF8pZtHlVq5jLa53BWn4AIroRtALsxLG1FqRxRRBav1n1soe2xf3PULS+TCgoJa0aaOHDWU89zL0H9lmO3mYOZ5eDraFf7zv1NWJrn+gplG96/ASjT0kJCQWmaTNvnaVMLFyM5ivxGYnTfO0gGk2Vjz7BWtEZ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453689; c=relaxed/simple;
	bh=9EjN8nh7V085+BqZAjVob3h2z871sk5Vbt3ysNlVGJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S48vyYxR6DWQ4fh42te6mcGrL7zod4qmFitWLYW58hXRdrD0n8WXbAq0KDDx49l5nsr83y+EGDpiDdvrbZXeixct4LMjvyW0iJlf4HIS9WqtPI/q2HEYBLLWiSnFbCbhIWk5M7AI20lpxdfID9uhKDTIQ99vk1uylyBxsO/oiQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=NlXB87Xt; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e5a0177531so544818a91.2
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453687; x=1730058487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yr2xZkoHB0nVswj42oFFwW3NpuvwZ9N4MbvDwoyulOQ=;
        b=NlXB87XtQ5tLb4SEZpxyqpk7lhf2Dp5tYj3DavcFwpmYSGx5j9EIrdLTP4BsT/YSTV
         LpNPFkdmOt110WUTUjwBN0LCxSr2iZ9rZsr0VGlHuXMBaS4Trp1z5BQc1YkCrrP54qax
         3p72Q3KuVT58BQ05Z4jN6Z1wxaaFzuP3K3bmwjNeRjkeQNObYKtcucjbYPDusMH34yik
         iQcu6OZ0hm99ZC2PQl/eHHfyt6e1frZGw3gu9Q7yjGbnxOzMqAnGvehChurQSRqfWN2V
         eGDRgOs4TgccjkP+8Ymiwrne10iXY4s1Blz62IA5lv8bsma34aoGGk+iF/Kni9yODfbx
         9jsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453687; x=1730058487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yr2xZkoHB0nVswj42oFFwW3NpuvwZ9N4MbvDwoyulOQ=;
        b=VH426SCkaZB8JwGhD2A8uUViJ1YUNK6Y2q2EVxMyHx6V5YDJL0sOxMbULh4vcBtI1y
         YVJPo60aE47YSyt/S/CsQsaWWgDdoxhUrI3TJm1ATy41L65PHqnaHXQbDc/Wmr1T6dDW
         T7vG1j18Fnwe0q4OQxEcyr1ECbRQTNctpP4Lo3dPjARv3vToLakeYBEiNDGpM1assbmg
         3Qz86I0jGjZTlGQRFbL1Doi/Rys+1y7LCLmsJdZ3j/ZsiO5oK1m1fVCRLFdDcogqOX4h
         GHexFWoWSDXSRTyEnUl4D8m0DsowQnmsHakQLSjHPO5VeH/a0ob67smGSxSPWk1sQyjP
         4bUg==
X-Forwarded-Encrypted: i=1; AJvYcCVwbrOqT3vJYeZkoJeICS8gY6qS5f4B+kqGOkocMCslwIpwC0Shrtl1/dEi9dBDWkamPU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzokRGPg0jPqWohfqPizXivMeXcIhyxWdmlj71GsTmYkn49QAg2
	9UjXy5joUTnBY12wWx5jBJUwt9cpstKI9enUIGv1VQigX+KF3WbdKKa9mT8b0Ao=
X-Google-Smtp-Source: AGHT+IGOwsMImEEUFZ7X9qPpWtzyIIzNSFMp0fMdMzDbnnBwV6JmeAnM7Csv5DyXHIZDDlryM2Wx1g==
X-Received: by 2002:a17:90a:5147:b0:2e2:c6a6:84da with SMTP id 98e67ed59e1d1-2e5617269c6mr10776191a91.34.1729453686738;
        Sun, 20 Oct 2024 12:48:06 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:48:06 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 12/13] RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
Date: Mon, 21 Oct 2024 01:17:33 +0530
Message-ID: <20241020194734.58686-13-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241020194734.58686-1-apatel@ventanamicro.com>
References: <20241020194734.58686-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save trap CSRs in the kvm_riscv_vcpu_enter_exit() function instead of
the kvm_arch_vcpu_ioctl_run() function so that HTVAL and HTINST CSRs
are accessed in more optimized manner while running under some other
hypervisor.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e191e6eae0c0..e048dcc6e65e 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -768,12 +768,21 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
  * This must be noinstr as instrumentation may make use of RCU, and this is not
  * safe during the EQS.
  */
-static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					      struct kvm_cpu_trap *trap)
 {
 	void *nsh;
 	struct kvm_cpu_context *gcntx = &vcpu->arch.guest_context;
 	struct kvm_cpu_context *hcntx = &vcpu->arch.host_context;
 
+	/*
+	 * We save trap CSRs (such as SEPC, SCAUSE, STVAL, HTVAL, and
+	 * HTINST) here because we do local_irq_enable() after this
+	 * function in kvm_arch_vcpu_ioctl_run() which can result in
+	 * an interrupt immediately after local_irq_enable() and can
+	 * potentially change trap CSRs.
+	 */
+
 	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
 	guest_state_enter_irqoff();
 
@@ -816,14 +825,24 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		} else {
 			gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
 		}
+
+		trap->htval = nacl_csr_read(nsh, CSR_HTVAL);
+		trap->htinst = nacl_csr_read(nsh, CSR_HTINST);
 	} else {
 		hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
 
 		__kvm_riscv_switch_to(&vcpu->arch);
 
 		gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+
+		trap->htval = csr_read(CSR_HTVAL);
+		trap->htinst = csr_read(CSR_HTINST);
 	}
 
+	trap->sepc = gcntx->sepc;
+	trap->scause = csr_read(CSR_SCAUSE);
+	trap->stval = csr_read(CSR_STVAL);
+
 	vcpu->arch.last_exit_cpu = vcpu->cpu;
 	guest_state_exit_irqoff();
 	kvm_riscv_vcpu_swap_in_host_state(vcpu);
@@ -940,22 +959,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		guest_timing_enter_irqoff();
 
-		kvm_riscv_vcpu_enter_exit(vcpu);
+		kvm_riscv_vcpu_enter_exit(vcpu, &trap);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 
-		/*
-		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
-		 * get an interrupt between __kvm_riscv_switch_to() and
-		 * local_irq_enable() which can potentially change CSRs.
-		 */
-		trap.sepc = vcpu->arch.guest_context.sepc;
-		trap.scause = csr_read(CSR_SCAUSE);
-		trap.stval = csr_read(CSR_STVAL);
-		trap.htval = ncsr_read(CSR_HTVAL);
-		trap.htinst = ncsr_read(CSR_HTINST);
-
 		/* Syncup interrupts state with HW */
 		kvm_riscv_vcpu_sync_interrupts(vcpu);
 
-- 
2.43.0


