Return-Path: <kvm+bounces-48478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 623AAACE9F2
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4DCC3AB3C6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92CAA1FBC92;
	Thu,  5 Jun 2025 06:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="HTSk9tVC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B8D1F8BC6
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104130; cv=none; b=j2Zbcyw70Uizx1mdKBrl7CsgfUpL//ZGKBbdM81YKWj9IQlQtrdG862D1DK+Y6VfatqZqigdAMW7WATOK6+A+dN2oL49U/6y5ooYicg17/MqRaYrKqoxQ92cxh24GFaL1pCtDloRMXy35/Aq6c9YoPWhemxLtT2oRSvHA8X4oEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104130; c=relaxed/simple;
	bh=n+hVNyfTxOTl8t9HsAlkU/sRe5K71i50QL7DtkhI3a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqDRPqwNny/4i7oSP4aUeJEGbWxcbbY98yZDjxsCWwpH2fLtKFlWxV7wS3NQMzo4BMCccFBPFV5ghKPYauB/ReeqFOqkRU90kIQlCNumGFJjaENGsME1rpPswgVfXI1003ovSHdupp+KEd1V4vF5UvqWxl+tH4zlsGlVXC/PmrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=HTSk9tVC; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-311da0bef4aso626684a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104128; x=1749708928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfGplfZ+lMzzXGz+lH1cECvXBoEmz2/+/610R8byNic=;
        b=HTSk9tVCIr2WlM3syf0Cy9+R7xP+bhP70jWuAcLQXeNEtW+UWCdzByWQVEl40nXn00
         c5ssio1WRT5y0Yi1R4nZKH/wdqOQKXsnsDhMpfkzhloOtsWCVTrfqhHf8j8epkQSKTKm
         iIgsCqeSaVGK2Ru0boWe7BJdDboqJ12a1Qmp/85LFMUaoDl85P2WpGSijV5lMUWMcfi4
         l7rT++AEIz1mVJkHDP/kN6dJzunmN5QhBPnA75W+YU3/SRRx86JZuMnbD876mfTukARG
         iH6iKw9gd4UtoICuwA9BD4OGwMqpp0MyIQiu0e2oYT0kXIfmp7uNKn7DEjrAf7k+E49K
         hDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104128; x=1749708928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfGplfZ+lMzzXGz+lH1cECvXBoEmz2/+/610R8byNic=;
        b=gsEPqzSPfIspzWyYcq+n8m3DUmTUgXOtafxG95zmXC3tieIYoHGlaZa1+PSyYFdkVE
         mo3hABItREs4WKrAYv7PcV9EokVsDYuQA/TYoWXMpAJauqBPe2wx3baXAZRNGPVsvjFw
         kq+M5QwkZgokCCamRY7XlvI+KHMlxcyt85FnzG7QAsMt2AATPaYhZ3oc7NcCUdPQN2sX
         caX/q+X+Dqbc+FrN8e2jYa+aNG8YbFrGjf4DEwmBlvRP+65WBdb7hbfVtgAeErFoxpzy
         b+16DsIy5UVQWflJ+ikpX0PNFtZP2Y4iDg8wqyKXnVaxuGCq64qRSnnknoUoGQPOMXsH
         6rXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD+8pNfVX7rDyyaE00lIg4nhJxkABMRTlmxG3bFnvbxoHjCBVv3tpyrjmwzVtKhwhWd8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRuiga7HRfCBsijGM8lLGsPKPoG0sy4giyx89ph2ps3Jjn0jX5
	2LYWHm4cidS3yMmOdeKn5ilotUxtO7sAndtOk1LjeiZR40j8l2cCmoGDxKuzfyh2dmk=
X-Gm-Gg: ASbGnctoTwelbVWgvWWV5c6BSpQL70swQuznwceKn3nlPwRv5iSs793rv51Qa8RvyCx
	/aJw+4ED8gdtYmB1f/H0ESzScDs2pCYtZkWyRdWfA0cI5FEezqUO+e0qmPytlFI1utWMKAjMTxo
	hFOf9MbTKo51c8kwHnPjyQ3A3WVV4qm4pCi8+44Va+ojrwKVpq1y7aVUB3xqsJ2u9ILNKzGpUN2
	YrJ6F+MW8Q93qpox5HaPoYiwr2KeYIGkRp/R25z/KaV/c/TumxuhwTG9MYox1u4ervFTzsCme6G
	cU+FDPVGcQBPXLHVTyz7P+A2upxhlC5+qU38zUZOXD5ZcuHAhjGAvCNrIvdihNfebzY9yiltdYJ
	UhedP7w==
X-Google-Smtp-Source: AGHT+IE6sSz9BENpf7WiYfh4yg2SFV4ZB167RNBBbzwVLW1gNWfnra1do1zIt/5EOyVuGPon2+FyaA==
X-Received: by 2002:a17:90a:2d0:b0:313:14b5:2525 with SMTP id 98e67ed59e1d1-31314b532a1mr4987134a91.35.1749104128373;
        Wed, 04 Jun 2025 23:15:28 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:27 -0700 (PDT)
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
Subject: [PATCH 06/13] RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_FLUSH
Date: Thu,  5 Jun 2025 11:44:51 +0530
Message-ID: <20250605061458.196003-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM_REQ_HFENCE_GVMA_VMID_ALL is same as KVM_REQ_TLB_FLUSH so
to avoid confusion let's replace KVM_REQ_HFENCE_GVMA_VMID_ALL with
KVM_REQ_TLB_FLUSH. Also, rename kvm_riscv_hfence_gvma_vmid_all_process()
to kvm_riscv_tlb_flush_process().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h | 4 ++--
 arch/riscv/kvm/tlb.c              | 8 ++++----
 arch/riscv/kvm/vcpu.c             | 8 ++------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 134adc30af52..afaf25f2c5ab 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -36,7 +36,6 @@
 #define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
 #define KVM_REQ_FENCE_I			\
 	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_HFENCE_GVMA_VMID_ALL	KVM_REQ_TLB_FLUSH
 #define KVM_REQ_HFENCE_VVMA_ALL		\
 	KVM_ARCH_REQ_FLAGS(4, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HFENCE			\
@@ -327,8 +326,9 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
 				     unsigned long order);
 void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
 
+void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu);
+
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
-void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
 
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index b3461bfd9756..da98ca801d31 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -162,7 +162,7 @@ void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 	local_flush_icache_all();
 }
 
-void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu)
+void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
 	unsigned long vmid = READ_ONCE(v->vmid);
@@ -342,14 +342,14 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
 	data.size = gpsz;
 	data.order = order;
 	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
-			    KVM_REQ_HFENCE_GVMA_VMID_ALL, &data);
+			    KVM_REQ_TLB_FLUSH, &data);
 }
 
 void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask)
 {
-	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_GVMA_VMID_ALL,
-			    KVM_REQ_HFENCE_GVMA_VMID_ALL, NULL);
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_TLB_FLUSH,
+			    KVM_REQ_TLB_FLUSH, NULL);
 }
 
 void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index cc7d00bcf345..684efaf5cee9 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -720,12 +720,8 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_FENCE_I, vcpu))
 			kvm_riscv_fence_i_process(vcpu);
 
-		/*
-		 * The generic KVM_REQ_TLB_FLUSH is same as
-		 * KVM_REQ_HFENCE_GVMA_VMID_ALL
-		 */
-		if (kvm_check_request(KVM_REQ_HFENCE_GVMA_VMID_ALL, vcpu))
-			kvm_riscv_hfence_gvma_vmid_all_process(vcpu);
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+			kvm_riscv_tlb_flush_process(vcpu);
 
 		if (kvm_check_request(KVM_REQ_HFENCE_VVMA_ALL, vcpu))
 			kvm_riscv_hfence_vvma_all_process(vcpu);
-- 
2.43.0


