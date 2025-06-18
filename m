Return-Path: <kvm+bounces-49852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E08ADEA63
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 219E5400140
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067292E425F;
	Wed, 18 Jun 2025 11:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bgWbqVDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C6F2E3B03
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246567; cv=none; b=e561nd6unTrWF8HTEIc1IETjhoJJ6w56b9lULgsiMjsrvfTqGVkgOuBmEE15SUtBPCIqEFYJY2ZCbtbQCzPrxNQP8kwOnJahERyvlLKVQ05tCKDu2DUU6zzAs65m3OvOPidScQuT6eliKPHoeVn/RDfR8nmGTROytmKSz7UVN2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246567; c=relaxed/simple;
	bh=UNJDgyGRwKsBGAVSWW07IY+xb3iaC5t5L0oSJfwXEpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUVTi0/QL88CgI2SL+7p21PiSe4+Xixmd/+kL/LjGzWWaVIlividVfTXJXkJwhRTVcVNZzHHUmlLfabafuCyknl5XkN/JfURukGsrLOQPkK2Be7JXkZ4Dwh+kXiJWcrbNW0wHcI8b4K5OyG9U0wy33vP19YrfTpUXdJjrN2yNc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bgWbqVDr; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-234b9dfb842so62385575ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246565; x=1750851365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0APR23xoSpRoPrmHOoIW/fZKPHEwlO7VgBzBq3Nrcg8=;
        b=bgWbqVDrTp7hXRpfiE6dz9Ppqhehpuu2FOuEAO4DM5Z7SHw319uT/XmZuhOgabyQXy
         hDWkB6MVn9WDk+VDYA9FrEsOMcybASmW+dvYGBm3LFKLo7SuFylkHcl+E3+w+3nwnUch
         ETrW7wNsPZWtEnQIQOHWBpA5u9yMKJjv67Lq3snb/9YW+0CXtCE9hsUMngaUUHzxTZZY
         2sWSWl6fomLI3USzJRKh82hixJyZMEFimSSOfFBL5/aNGCgYAP3mSgj+M6LSpCHKbXGm
         RkRBXSnDmSKIWOEUhHoIMKB9BiCNtpFfarDp3zWMQJW5u9+eAvn8iCRnQVUjmfF0/57w
         P+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246565; x=1750851365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0APR23xoSpRoPrmHOoIW/fZKPHEwlO7VgBzBq3Nrcg8=;
        b=a3ihsMRTVsIatRa/ABElHhBfvba5TvQ4EIr5OHYqjYSCKFLEF0ZygSqklUli+9Qmpe
         ULkIaYfLyEeX+3Og7LjYeZ/OYYwKWZdTeGNZ+l7RZZ5/DLE75QLWehAiHU3iQd5+SEiL
         qWJUiP9XUE1ji+hzDg+pAYVHJTpOfjFI0b6Ui2AzBRt0HtpDCBAAF8Z///St1G7CyyJV
         M2sJ4DQDFNY5vCA1B7+s9RHtsGj3fPKHFayF+R8gawDBeIBYVWWtcx0FT63bn8z2YXtt
         6LqudqrTHLKE1yupLVfOyO7N2WhtSuxkpomu4sxUVTuJ4ZtE+Wxnmk4MZrqIYvBWFUi0
         hkuw==
X-Forwarded-Encrypted: i=1; AJvYcCXZcEI0kjIOeHRKFriLVeP3LyCHWuiLRI1pwhJcmqhZTWSAv89l2ZyNeCJj47YPxmwawFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPS9f8UyzQOfUtr5gLQS2Ak3z53Bw8tnkpPO3jKifCsN0s4sbn
	0fQrMoxo9I4suSi8PBFEhxmB0YPA81mvPnBVGbIi6uZlDAqZPRn3+64pShOoHsWZjHA=
X-Gm-Gg: ASbGnctp646rzyjB28giHcXhbQn4wx6dj3+GT0nIsg/DHhjwCmF+IRKXigplZHJl0BR
	CDmQxx93fGtDNFz9fhaNTpOvbtkCdlbZ0o0SMvjOltg1ZLjGNlZ+TRGnu2+kB2hSoY68P4Wddks
	75CoC6OfMDujpRyipBA/9TushMfhayoAE/N3h8OiMuuxp9Mh5BPdDn029FtiFmBQ8di2NfWWogj
	zogVZfvpbcbgdsltrH9x1ojf8YoNL5frLbKF9zyBIVMBFpJseSsEhz3yslzhG0+PfHPTABCODex
	7E85pLNE0Iww0qmFqJL0P83F69rorYxEmEnM+6d5uQLjMJf0YuRBrp7QzIuMfcaT85UUY4rZR0k
	zPobbuHszQORa7fb5QAHp998lpUaO
X-Google-Smtp-Source: AGHT+IEI/VNLAuRLYdIAweMxNEdH8gXS8v8LyQf6sVKwZcSZW1oY61MqIeM//ad3SI9TL8TSIJCUlw==
X-Received: by 2002:a17:903:1ac5:b0:234:bc4e:4eb4 with SMTP id d9443c01a7336-2366b3e2ff9mr227196035ad.51.1750246564794;
        Wed, 18 Jun 2025 04:36:04 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:04 -0700 (PDT)
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
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 04/12] RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_FLUSH
Date: Wed, 18 Jun 2025 17:05:24 +0530
Message-ID: <20250618113532.471448-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
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

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h | 4 ++--
 arch/riscv/kvm/tlb.c              | 8 ++++----
 arch/riscv/kvm/vcpu.c             | 8 ++------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 8aa705ac75a5..ff1f76d6f177 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -37,7 +37,6 @@
 #define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
 #define KVM_REQ_FENCE_I			\
 	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_HFENCE_GVMA_VMID_ALL	KVM_REQ_TLB_FLUSH
 #define KVM_REQ_HFENCE_VVMA_ALL		\
 	KVM_ARCH_REQ_FLAGS(4, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HFENCE			\
@@ -331,8 +330,9 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
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
index a2dd4161e5a4..6eb11c913b13 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -721,12 +721,8 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
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


