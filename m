Return-Path: <kvm+bounces-14939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 816D98A7D5B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E0E11F2242F
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E82574C09;
	Wed, 17 Apr 2024 07:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="OZwNnNNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AC76F071
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 07:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713339945; cv=none; b=th1v9QRu18dNnrtTl41TAvKEsPVq0x0vw5YMyVDdKPlT0Jy3tBZFhKWju7xa+58nQnU38KvOzTtnD5h6xs6zkXzaDA7nUYTCc5SrLE3ifF61HLtCr6FsirTho8jWEF0FkjanJ9d9cVYSCm9E706xQpUJco8PYkNFsOUWzKSuZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713339945; c=relaxed/simple;
	bh=UcfSSKgSMVF14Y6OAH1JXuFj4weQWxdKz8OR0Z4ZBaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=c2tdkl0E8JuYh5vCXzb8P9VqqPssVMu3wuHzBejZSxsSZdvREqxtACrmuoosrbvioJzvOZxr5r62pxNkbvOEr24uVvQmmMR37ZZvgqK0MZHaG31BhILCZAVkdm9xo4H6uP3q260B8umN2TjG0RPLsDmR2dplbBhxA8Xf58tVWvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=OZwNnNNO; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e3e84a302eso35945425ad.0
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 00:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1713339943; x=1713944743; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VAeQZBydta2YFx0doefh2m6FBjLjSICAoI5LdWB4tXo=;
        b=OZwNnNNOnYmYKExz6R15KiW6xDsMI/0C56OEgteF6M09MOC4BIsc6o/99QthOIz4cm
         5Ho/ixA28rY1ZZOYurObo93kPiOktLngMNFYYx1nhdgo42ngsfy8hjkAgndp+S/pV2No
         Um12adLXYAfGIHqBiMgi3S19JqcO/HOgfBW7v1MHbkbBh8J9K1hzLFQrUwqm+3+uy1CI
         jsfrSoVSwCijM7X+xDt9u5B092ZbnO/+nQ4d94uyq51O7B+5rFF+K0miXtJJPSSYFAhU
         9Lt787BAYH/uaUwEKCABEara6t76wna0VeTLo2GCMHkPheKPCWVKa7pE0E2vbnj4TopA
         MRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713339943; x=1713944743;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAeQZBydta2YFx0doefh2m6FBjLjSICAoI5LdWB4tXo=;
        b=ewZKsdKfCFR4Om4I0V9mMfPRMEgaBYg1eaKGyJ6dB4NEG2b3HByoqxCW7KZXTM7MtD
         lDPpqZt3uf1oVJgU7TOjn2Ddc16jroeD1sjBpbF/u/UgwdkA0yd0oJzii381yyJleZl0
         XxJJk1lSl1bqXAanKtvKtHW1FXyrBnbAZISzk+09ufIqKyAmjmaXxSuJXckXI4HQb9d8
         l0t0S17wRxh7B0aleTc3w8H7qCIk5NXq6H6HtNCGl5mNTianVwS3JieFS8ROnOoWg1oT
         ddHEj1Z2hdOEDhALhPLqeRIVLT5+Ow6DMxBDSQLdnXvumPQ78cilvkI4BuzLqbINUk1T
         3JBA==
X-Forwarded-Encrypted: i=1; AJvYcCVcHFsbx2ssCgDUfS0LUl0VSUYA8loBQuf8CbDOAY+PzBsjLPkSb8IUYrTsGxG3w3HyVlBgtiVFNzpWcW1eJZaxOfUZ
X-Gm-Message-State: AOJu0YzaLYC96lSHqDrIZTVyf4Bvmy1aFmbGOpvzwi7c+8kwj6N2YxSU
	mtA1cwJyDhLgWot3IooUujWCSYfaQHHUG+86DcsC8DYRxKN0w8vIbl0nHvTBDzc=
X-Google-Smtp-Source: AGHT+IHpmzOz+XE19YaszuPGpeIKZss/3nG6ZbZ124xvH4CupAZWA+/yLBOehGNjqDTH689T/W6l9A==
X-Received: by 2002:a17:903:2352:b0:1e8:2c8d:b74a with SMTP id c18-20020a170903235200b001e82c8db74amr840861plh.10.1713339942755;
        Wed, 17 Apr 2024 00:45:42 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id g21-20020a170902c39500b001e7b7a79340sm3166065plg.267.2024.04.17.00.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 00:45:42 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] RISCV: KVM: Introduce vcpu->reset_cntx_lock
Date: Wed, 17 Apr 2024 15:45:26 +0800
Message-Id: <20240417074528.16506-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240417074528.16506-1-yongxuan.wang@sifive.com>
References: <20240417074528.16506-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Originally, the use of kvm->lock in SBI_EXT_HSM_HART_START also avoids
the simultaneous updates to the reset context of target VCPU. Since this
lock has been replace with vcpu->mp_state_lock, and this new lock also
protects the vcpu->mp_state. We have to add a separate lock for
vcpu->reset_cntx.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/include/asm/kvm_host.h | 1 +
 arch/riscv/kvm/vcpu.c             | 6 ++++++
 arch/riscv/kvm/vcpu_sbi_hsm.c     | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 64d35a8c908c..664d1bb00368 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ struct kvm_vcpu_arch {
 
 	/* CPU context upon Guest VCPU reset */
 	struct kvm_cpu_context guest_reset_context;
+	spinlock_t reset_cntx_lock;
 
 	/* CPU CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_csr guest_reset_csr;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 70937f71c3c4..1a2236e4c7f3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -64,7 +64,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	memcpy(csr, reset_csr, sizeof(*csr));
 
+	spin_lock(&vcpu->arch.reset_cntx_lock);
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+	spin_unlock(&vcpu->arch.reset_cntx_lock);
 
 	kvm_riscv_vcpu_fp_reset(vcpu);
 
@@ -121,12 +123,16 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	spin_lock_init(&vcpu->arch.hfence_lock);
 
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
+	spin_lock_init(&vcpu->arch.reset_cntx_lock);
+
+	spin_lock(&vcpu->arch.reset_cntx_lock);
 	cntx = &vcpu->arch.guest_reset_context;
 	cntx->sstatus = SR_SPP | SR_SPIE;
 	cntx->hstatus = 0;
 	cntx->hstatus |= HSTATUS_VTW;
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
+	spin_unlock(&vcpu->arch.reset_cntx_lock);
 
 	if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
 		return -ENOMEM;
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 115a6c6525fd..cc5038b90e02 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -31,6 +31,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	spin_lock(&target_vcpu->arch.reset_cntx_lock);
 	reset_cntx = &target_vcpu->arch.guest_reset_context;
 	/* start address */
 	reset_cntx->sepc = cp->a1;
@@ -38,6 +39,8 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 	reset_cntx->a0 = target_vcpuid;
 	/* private data passed from kernel */
 	reset_cntx->a1 = cp->a2;
+	spin_unlock(&target_vcpu->arch.reset_cntx_lock);
+
 	kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
 
 	__kvm_riscv_vcpu_power_on(target_vcpu);
-- 
2.17.1


