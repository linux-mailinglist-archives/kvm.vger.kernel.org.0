Return-Path: <kvm+bounces-54850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5F3B29303
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 470611B22797
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CDD22A7E4;
	Sun, 17 Aug 2025 12:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nI1rJkiV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD991226CFE
	for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755434040; cv=none; b=F5IEIAzCoKep6MydxcafvEHvd3pfR5Edcg9/IddXKB/2hKrHMZgLsV3URkcpAWfY36OStPGBucclSZJ8ZK18Zq4GKp4qhGJdx63zx5uWJIFr7OIZGHu9ozc+ovTQrZtpeRauzTnadcavw8b5C41mKELnq74YhW4pOMUcU6vca7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755434040; c=relaxed/simple;
	bh=ke6/4vsRmstkufw/5UJSuEHrjx++zNB2oSSSsB/FhtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6BW7hcgAT3LE7TmAqE8iS/7CZZ5y2KJNt6JlRBjt9dnajDHMh2qRO+HTh+o6TdkgotossZpLxcqbVKro3UW/dg4tXmFEBNX6MZwD/yoWD9aAwv2+snbxaQ6Hk3BWSGb2ILaPOnjHs0gZomQnpqJR/6CWC1Hz3flh78QKXj+HZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nI1rJkiV; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32326e06496so3814245a91.2
        for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 05:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755434036; x=1756038836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeWbesZsojxgQXw5riX+npRx+uBwxYUwx2cWc/0S0Q0=;
        b=nI1rJkiVnBTMUrJBbWjoqF8bZvJPrVR0ut3OsQTuqqv2oM6pwA4na3vprbEoD13GBM
         HEjRVEm3hz8zF9y1h8H9XoCVH+gTKdZZUdxuIMrFPURPcWxh22XCJuksqdlmujzIun4o
         wrczA+gBi0i24Svgiq87nRIDtfj5xbKAYSRHfvPkgUVL1tbGNAfDsuubc0YzkEcOGCq/
         6it6maSyHPJVbpbD3xqjDBZeHuMg9VVoNTIc/DtC+LIGgQM7ztnDpVFrTqXNJgSvaJNu
         RRt5GAL534DVUdKceE30fQ5foYRXwpVeCi7U/kHP7FD2922Pk65S3q1uIBlQ/HDTPynV
         PE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755434036; x=1756038836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeWbesZsojxgQXw5riX+npRx+uBwxYUwx2cWc/0S0Q0=;
        b=EdHz3OFh/u5OIRrkOm9lttoFaYxdcv0O793qmgOuTyCeGVoDUX7MY2VLbbv8osJbNx
         o/QxHuvaFXnoeR4wy2o0+OngJOMR/IlcxdecaWWfHpWmIMERtfKSAqNMq9qpuhbp2yE+
         Y8/65kSQCSqTk6yP9EppTVQb6kVV7NNnpiV57q1hs5OA8XXeW4VqT1fbw3O8Lj/F8vB3
         msmQnLM65xvpTCg8oo92NBkpxR5NSt7fhrvyP+OSuO/w+I7WcSYFKHi1lOFDT23pDjcy
         eurfaZGfTYpZu6Jg7wxthOS0Giylyb3CXdb0MeJeq9agwW+zwrcspmeT6q5FrycD1Ceo
         YRig==
X-Forwarded-Encrypted: i=1; AJvYcCVhoCMwzUXhUd6eoYQj01sJgOKoC4UFjn36wX+VePilT8UKMkDMhTt9DEqQ7LSGvnkOR+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJp9eTtncA90EIrzKS6XbIZ3YWiAi0uisK+bWeeqaUcS8Kqb3P
	/sw0YlQLzR9cz/+gvB6jiQHBJevGa4zF4EneFm5bvXGIiLlgF6JZ8QNcFELAaq5vbs+Y3iMaJUE
	Zt0Vh
X-Gm-Gg: ASbGncv3pCqW/bhYZZF2t4WZqfTBAUNU2HUH6OqE1HJ5zXqXfyB3AkOZRM3niXcNctB
	zO2B9EGvLnB6SgpbLbo8KhfQkKg5Fi6q2ijkXsRAqbt1tdQz5/moL+cYGYUJ6MXYp4kMSrxz3Dj
	/78z1L1s4a/cQtp1nKt4a4GX3QOfaaFaOZbPcD7N48zzqtQt1XUht1J1iB1mTXkmN+hxEjpNunN
	o0ESbf5eJ9XRnBGpgqMgqXYp1h8VznOhXT++eDaIFy4Ih5+qaROxWydyjacPWVP5yKVD/3TGDUR
	enC1WtlsqtO2KmJraCCION+lKuMbBbXVDZqHcjIHregrDmK1HJYdDAGwZUGT2WDrWgmCkExSN8k
	bwmY8Qm9ZXlsc32tDPYW41WFfC4XoW10Kls6iHYCNI2v1ThzG6C0YtOM=
X-Google-Smtp-Source: AGHT+IFXQEU9LNaAUTbq9ypqgf2DVyuDqacLa0u6cp8/0IIJ09pS5qkXvZDDusPn59ysb0I3gqjkSg==
X-Received: by 2002:a17:90b:2784:b0:31f:210d:2e56 with SMTP id 98e67ed59e1d1-32341ef60bemr12179741a91.28.1755434035946;
        Sun, 17 Aug 2025 05:33:55 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.202])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232b291449sm4480912a91.0.2025.08.17.05.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 05:33:55 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 3/6] RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extensions
Date: Sun, 17 Aug 2025 18:03:21 +0530
Message-ID: <20250817123324.239423-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250817123324.239423-1-apatel@ventanamicro.com>
References: <20250817123324.239423-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI extensions can have per-VCPU state which needs to be saved/restored
through ONE_REG interface for Guest/VM migration. Introduce optional
ONE_REG callbacks for SBI extensions so that ONE_REG implementation
for an SBI extenion is part of the extension sources.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  20 ++--
 arch/riscv/kvm/vcpu_onereg.c          |  31 +-----
 arch/riscv/kvm/vcpu_sbi.c             | 145 ++++++++++++++++++++++----
 arch/riscv/kvm/vcpu_sbi_sta.c         |  63 +++++++----
 4 files changed, 176 insertions(+), 83 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 766031e80960..8970cc7530c4 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -59,6 +59,14 @@ struct kvm_vcpu_sbi_extension {
 	void (*deinit)(struct kvm_vcpu *vcpu);
 
 	void (*reset)(struct kvm_vcpu *vcpu);
+
+	unsigned long state_reg_subtype;
+	unsigned long (*get_state_reg_count)(struct kvm_vcpu *vcpu);
+	int (*get_state_reg_id)(struct kvm_vcpu *vcpu, int index, u64 *reg_id);
+	int (*get_state_reg)(struct kvm_vcpu *vcpu, unsigned long reg_num,
+			     unsigned long reg_size, void *reg_val);
+	int (*set_state_reg)(struct kvm_vcpu *vcpu, unsigned long reg_num,
+			     unsigned long reg_size, const void *reg_val);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -73,10 +81,9 @@ int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
 				   const struct kvm_one_reg *reg);
 int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
 				   const struct kvm_one_reg *reg);
-int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu,
-			       const struct kvm_one_reg *reg);
-int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu,
-			       const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_reg_indices_sbi(struct kvm_vcpu *vcpu, u64 __user *uindices);
+int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 				struct kvm_vcpu *vcpu, unsigned long extid);
 bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
@@ -85,11 +92,6 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu);
 
-int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
-				   unsigned long *reg_val);
-int kvm_riscv_vcpu_set_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
-				   unsigned long reg_val);
-
 #ifdef CONFIG_RISCV_SBI_V01
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
 #endif
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index b77748a56a59..5843b0519224 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -1090,36 +1090,9 @@ static unsigned long num_sbi_ext_regs(struct kvm_vcpu *vcpu)
 	return copy_sbi_ext_reg_indices(vcpu, NULL);
 }
 
-static int copy_sbi_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
-{
-	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
-	int total = 0;
-
-	if (scontext->ext_status[KVM_RISCV_SBI_EXT_STA] == KVM_RISCV_SBI_EXT_STATUS_ENABLED) {
-		u64 size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
-		int n = sizeof(struct kvm_riscv_sbi_sta) / sizeof(unsigned long);
-
-		for (int i = 0; i < n; i++) {
-			u64 reg = KVM_REG_RISCV | size |
-				  KVM_REG_RISCV_SBI_STATE |
-				  KVM_REG_RISCV_SBI_STA | i;
-
-			if (uindices) {
-				if (put_user(reg, uindices))
-					return -EFAULT;
-				uindices++;
-			}
-		}
-
-		total += n;
-	}
-
-	return total;
-}
-
 static inline unsigned long num_sbi_regs(struct kvm_vcpu *vcpu)
 {
-	return copy_sbi_reg_indices(vcpu, NULL);
+	return kvm_riscv_vcpu_reg_indices_sbi(vcpu, NULL);
 }
 
 static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
@@ -1247,7 +1220,7 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcpu *vcpu,
 		return ret;
 	uindices += ret;
 
-	ret = copy_sbi_reg_indices(vcpu, uindices);
+	ret = kvm_riscv_vcpu_reg_indices_sbi(vcpu, uindices);
 	if (ret < 0)
 		return ret;
 	uindices += ret;
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 01a93f4fdb16..04903e5012d6 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -364,64 +364,163 @@ int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu,
-			       const struct kvm_one_reg *reg)
+int kvm_riscv_vcpu_reg_indices_sbi(struct kvm_vcpu *vcpu, u64 __user *uindices)
+{
+	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
+	const struct kvm_riscv_sbi_extension_entry *entry;
+	const struct kvm_vcpu_sbi_extension *ext;
+	unsigned long state_reg_count;
+	int i, j, rc, count = 0;
+	u64 reg;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		entry = &sbi_ext[i];
+		ext = entry->ext_ptr;
+
+		if (!ext->get_state_reg_count ||
+		    scontext->ext_status[entry->ext_idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED)
+			continue;
+
+		state_reg_count = ext->get_state_reg_count(vcpu);
+		if (!uindices)
+			goto skip_put_user;
+
+		for (j = 0; j < state_reg_count; j++) {
+			if (ext->get_state_reg_id) {
+				rc = ext->get_state_reg_id(vcpu, j, &reg);
+				if (rc)
+					return rc;
+			} else {
+				reg = KVM_REG_RISCV |
+				      (IS_ENABLED(CONFIG_32BIT) ?
+				       KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64) |
+				      KVM_REG_RISCV_SBI_STATE |
+				      ext->state_reg_subtype | j;
+			}
+
+			if (put_user(reg, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+
+skip_put_user:
+		count += state_reg_count;
+	}
+
+	return count;
+}
+
+static const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext_withstate(struct kvm_vcpu *vcpu,
+									    unsigned long subtype)
+{
+	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
+	const struct kvm_riscv_sbi_extension_entry *entry;
+	const struct kvm_vcpu_sbi_extension *ext;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		entry = &sbi_ext[i];
+		ext = entry->ext_ptr;
+
+		if (ext->get_state_reg_count &&
+		    ext->state_reg_subtype == subtype &&
+		    scontext->ext_status[entry->ext_idx] == KVM_RISCV_SBI_EXT_STATUS_ENABLED)
+			return ext;
+	}
+
+	return NULL;
+}
+
+int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	unsigned long __user *uaddr =
 			(unsigned long __user *)(unsigned long)reg->addr;
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_SBI_STATE);
-	unsigned long reg_subtype, reg_val;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+	const struct kvm_vcpu_sbi_extension *ext;
+	unsigned long reg_subtype;
+	void *reg_val;
+	u64 data64;
+	u32 data32;
+	u16 data16;
+	u8 data8;
+
+	switch (KVM_REG_SIZE(reg->id)) {
+	case 1:
+		reg_val = &data8;
+		break;
+	case 2:
+		reg_val = &data16;
+		break;
+	case 4:
+		reg_val = &data32;
+		break;
+	case 8:
+		reg_val = &data64;
+		break;
+	default:
 		return -EINVAL;
+	}
 
-	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+	if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
 	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
 	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
 
-	switch (reg_subtype) {
-	case KVM_REG_RISCV_SBI_STA:
-		return kvm_riscv_vcpu_set_reg_sbi_sta(vcpu, reg_num, reg_val);
-	default:
+	ext = kvm_vcpu_sbi_find_ext_withstate(vcpu, reg_subtype);
+	if (!ext || !ext->set_state_reg)
 		return -EINVAL;
-	}
 
-	return 0;
+	return ext->set_state_reg(vcpu, reg_num, KVM_REG_SIZE(reg->id), reg_val);
 }
 
-int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu,
-			       const struct kvm_one_reg *reg)
+int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	unsigned long __user *uaddr =
 			(unsigned long __user *)(unsigned long)reg->addr;
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_SBI_STATE);
-	unsigned long reg_subtype, reg_val;
+	const struct kvm_vcpu_sbi_extension *ext;
+	unsigned long reg_subtype;
+	void *reg_val;
+	u64 data64;
+	u32 data32;
+	u16 data16;
+	u8 data8;
 	int ret;
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+	switch (KVM_REG_SIZE(reg->id)) {
+	case 1:
+		reg_val = &data8;
+		break;
+	case 2:
+		reg_val = &data16;
+		break;
+	case 4:
+		reg_val = &data32;
+		break;
+	case 8:
+		reg_val = &data64;
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
 	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
 
-	switch (reg_subtype) {
-	case KVM_REG_RISCV_SBI_STA:
-		ret = kvm_riscv_vcpu_get_reg_sbi_sta(vcpu, reg_num, &reg_val);
-		break;
-	default:
+	ext = kvm_vcpu_sbi_find_ext_withstate(vcpu, reg_subtype);
+	if (!ext || !ext->get_state_reg)
 		return -EINVAL;
-	}
 
+	ret = ext->get_state_reg(vcpu, reg_num, KVM_REG_SIZE(reg->id), reg_val);
 	if (ret)
 		return ret;
 
-	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+	if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
 	return 0;
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index cc6cb7c8f0e4..68486f90a61e 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -151,63 +151,82 @@ static unsigned long kvm_sbi_ext_sta_probe(struct kvm_vcpu *vcpu)
 	return !!sched_info_on();
 }
 
-const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta = {
-	.extid_start = SBI_EXT_STA,
-	.extid_end = SBI_EXT_STA,
-	.handler = kvm_sbi_ext_sta_handler,
-	.probe = kvm_sbi_ext_sta_probe,
-	.reset = kvm_riscv_vcpu_sbi_sta_reset,
-};
+static unsigned long kvm_sbi_ext_sta_get_state_reg_count(struct kvm_vcpu *vcpu)
+{
+	return sizeof(struct kvm_riscv_sbi_sta) / sizeof(unsigned long);
+}
 
-int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu,
-				   unsigned long reg_num,
-				   unsigned long *reg_val)
+static int kvm_sbi_ext_sta_get_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
+				   unsigned long reg_size, void *reg_val)
 {
+	unsigned long *value;
+
+	if (reg_size != sizeof(unsigned long))
+		return -EINVAL;
+	value = reg_val;
+
 	switch (reg_num) {
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
-		*reg_val = (unsigned long)vcpu->arch.sta.shmem;
+		*value = (unsigned long)vcpu->arch.sta.shmem;
 		break;
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
 		if (IS_ENABLED(CONFIG_32BIT))
-			*reg_val = upper_32_bits(vcpu->arch.sta.shmem);
+			*value = upper_32_bits(vcpu->arch.sta.shmem);
 		else
-			*reg_val = 0;
+			*value = 0;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	return 0;
 }
 
-int kvm_riscv_vcpu_set_reg_sbi_sta(struct kvm_vcpu *vcpu,
-				   unsigned long reg_num,
-				   unsigned long reg_val)
+static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
+				   unsigned long reg_size, const void *reg_val)
 {
+	unsigned long value;
+
+	if (reg_size != sizeof(unsigned long))
+		return -EINVAL;
+	value = *(const unsigned long *)reg_val;
+
 	switch (reg_num) {
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t hi = upper_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = reg_val;
+			vcpu->arch.sta.shmem = value;
 			vcpu->arch.sta.shmem |= hi << 32;
 		} else {
-			vcpu->arch.sta.shmem = reg_val;
+			vcpu->arch.sta.shmem = value;
 		}
 		break;
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t lo = lower_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = ((gpa_t)reg_val << 32);
+			vcpu->arch.sta.shmem = ((gpa_t)value << 32);
 			vcpu->arch.sta.shmem |= lo;
-		} else if (reg_val != 0) {
+		} else if (value != 0) {
 			return -EINVAL;
 		}
 		break;
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	return 0;
 }
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta = {
+	.extid_start = SBI_EXT_STA,
+	.extid_end = SBI_EXT_STA,
+	.handler = kvm_sbi_ext_sta_handler,
+	.probe = kvm_sbi_ext_sta_probe,
+	.reset = kvm_riscv_vcpu_sbi_sta_reset,
+	.state_reg_subtype = KVM_REG_RISCV_SBI_STA,
+	.get_state_reg_count = kvm_sbi_ext_sta_get_state_reg_count,
+	.get_state_reg = kvm_sbi_ext_sta_get_reg,
+	.set_state_reg = kvm_sbi_ext_sta_set_reg,
+};
-- 
2.43.0


