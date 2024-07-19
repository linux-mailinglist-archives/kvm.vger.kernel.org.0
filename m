Return-Path: <kvm+bounces-21951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99202937A81
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC2C51C21CB5
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBB314A092;
	Fri, 19 Jul 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="A3TPCTPM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87C149DFC
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405409; cv=none; b=MXyxs9n/XEB0+5UKBrp5zQkYZR0c/ES6SxZ7HBGfwYzIjquIxmV2VFK12EVSXkfn2a4cLDPq9ZYNvNJUa2xv6bSqyCImbjTDNEEAhyT7Hlvqxr/ZLOFVI7AibhogslS9t99YDPuSeaOzmS1VF5MDOSiMZsgJIMs+yKIFWSq6Kdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405409; c=relaxed/simple;
	bh=MUBhotZqWn2Td7UfLd32uWl94lJVKC3WAxJbMEuRmZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hLoPB0BW8zcoUwqQ7poUJkgXyC+SgX9EKoZ/HrqkvDYK50vLJgqt+0SGG1kkKQaU/mIOeg0ITslybVML9HUnll8dQLAFnB7Crqe7ft7Do7f0B08TDV8ipDb515TgXxm1GpSQWY11meIyAKVjZRl/IPDtRWs6xO01WLiuEuiTz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=A3TPCTPM; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fc56fd4de1so16476245ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405407; x=1722010207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4NP08UX/w85iYkbIVPDnOkRGbucYck2yHjBnwqEXTo=;
        b=A3TPCTPMxHKMuf6yv6MHh18KMVJRr1BWO+HfnxDoTFIvHlySUprhxedhgQz8CODtPz
         t2GWF9Da5HiqFXUocU1uooVV8CJWPD/u6+nKa1nPTSPEiVW3Q77Zf6FWk96pIP8Tey5n
         8BZVUbLWJEZRnyakO059hFcaoz/P4OzCYvgE560hQR57qAojT3yw0WK/83HOQvQokvzA
         B0QL59Yg349s/DwMknEMUFuw3HTFP7k4fHB3PtDXjwGjgjwNRz5wIF+ywGO/7UttEqjc
         Bk4kPPf//rjcdJP8HrUrdmC7SYtwVdGcRa8GnTVmMmADxNVOOpjWk3u8jaIdPJhoLtxA
         A2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405407; x=1722010207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4NP08UX/w85iYkbIVPDnOkRGbucYck2yHjBnwqEXTo=;
        b=wp3r3C0UpJILOX47FS2arZartpoHflLyctKw3FdfqRNwcgmSQw4zeETeDxr2dgtt/Q
         4D1lg8WxjwyF6L5IggG279OMjWxd5evY/ZtyrG9bqx53pMq/7fMQJSw069EAP7NOvXal
         fb0V8OKqsyXbufLSmRpLe2OWpMS0mkJGvGJyUXM0mPLpU0gqYekFnfHTZ5oZN/8JAeLs
         GBvoju1LmUEcpO74PywbbDaG5k/wL3KbO411qCYIf81SUE3vD7BcO6ViwuJSOK7CvFU0
         1UdgJQ5+9BA9yuvwsIC7tl2qH9413ACsXY+ihlZnmyFnvb1zqZm7nL5P9H73Jd9xmV5F
         GMow==
X-Forwarded-Encrypted: i=1; AJvYcCXsTnt3Prej13Z2tLP5fCEJlYZoH8ArxdRBnSwqmMF3oJiDmELuaX0E1mBg7iebJ1/UuZfmWWbjwa5DclwvDGmhA/2V
X-Gm-Message-State: AOJu0Yz0VLYNuELJb+UZFy9Scpxy72gl5sdSqJPuEkZEwpChyW+TU23l
	PiCOUwdTPGwXEQMz907fRPCdg2gNpX7kml2r+OlZPLckXdhL/5ue0pToG0QIufc=
X-Google-Smtp-Source: AGHT+IE+xJaOF5e+dz9ph4mEQcMOaOJS+xXUFim+WrfebsgXUwhG7R+IIRODL08tQgBfyTXBjU6Aqg==
X-Received: by 2002:a17:903:32c5:b0:1fb:80a3:5826 with SMTP id d9443c01a7336-1fd74cff03bmr2252485ad.4.1721405406717;
        Fri, 19 Jul 2024 09:10:06 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:10:06 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 12/13] RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
Date: Fri, 19 Jul 2024 21:39:12 +0530
Message-Id: <20240719160913.342027-13-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
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
---
 arch/riscv/kvm/vcpu.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index fe849fb1aaab..854d98aa165e 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -757,12 +757,21 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
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
 
@@ -805,14 +814,24 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
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
@@ -929,22 +948,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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
2.34.1


