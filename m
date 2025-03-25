Return-Path: <kvm+bounces-41878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3F9A6E7AC
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:41:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B253717518E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 00:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8454718B47D;
	Tue, 25 Mar 2025 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="i934I2iE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16F1149E16
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742863248; cv=none; b=h8tZNH29C7q5Evpji5WarAuU0D200W9VBfi1kt1+e0rmOptF+H2b1HUJGOe2bJS9bh8UAutA0UfM+jNSNzf+QILTCDRG7yjh3mSPt7gdptRuOJKlQUf7go+W+TKv3ACVF0qhVest/3NcN0vGKsxaX3+qsqSAdhed9jxtEu1Sf6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742863248; c=relaxed/simple;
	bh=qRWvFNmtF//vHxX52E+O6O7fduE/eyyjc2L4rSswFs4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ckQu9Pc45Aeih1d51UytuebMSMnckAJGh0wZEmM0WsKn6s9ItAi8KpMXoPhDCq2+PhOjMwK5c0jctCnztydQGtcOloueS84LnYbUh/Bb7FxObLqDDDhTVfe7orKFjlo+CeCpu/Zx/NxL1/PZPfOulht3pGfmpn8fcR9Hj0zDtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=i934I2iE; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240b4de12bso25691635ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742863246; x=1743468046; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=itl/W4XiPHQgafNA6elnqIZsMFzXb5vTM+wl8RewrvY=;
        b=i934I2iEwTP/NysO1QuVEsoVlLLPMjwKHz/H+LpVuuNba5P6DE2z34s9K8CUBaXzPu
         F0LhPM1rf3T5/3+g4CHn+eyl9Zilqcr3aWsOAi7wfvfLdYUA+iJ1F+UWTsSn37NVD5V4
         NA8CLfuJuzvG2ZLY5L1EsX4KQbrxlhMZWTb4norNuyjEasxf6KwQP2WkL+R9YvQDwiob
         wcqZ0TKiiXzEX+ZHOXM/UvObq2Hi9Yho6EYMNUE6eUYAe4YSfVHh0yh0Nm+KPvE0M7fz
         63HR+InKy4Zmnef0aOsYAwcum6DJfHeWcwuOEtPINn4s9zM7shNkmM9EFMj7Nx0KQgKS
         J1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742863246; x=1743468046;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=itl/W4XiPHQgafNA6elnqIZsMFzXb5vTM+wl8RewrvY=;
        b=lXx3g/GoFHh0PoUxHdQkxP4RBUovyeyIuv9cBJrojmAH6tszq+nIngCa96y0pk1LlB
         4rMfOKm47ZMWgY7oOXe/7zFkb1viUuocwGe+6uDpwixMCMTXUHG45efH1lqAZe9jrAuK
         bqnraeAIc6RLP2+Non2O/mWmQ5QPDzlB2cNQ8N0sP53RJew4xrxbIf4YoXA+uakgu5Xa
         GXV8gHAY/rWBRUl4DQn+QBuVj0DWIMijo37cbCHL8vm7spPuifGkjQMl5/QJgJhrCHbN
         nc2Tz6EaeAbiPLH9UVOUobnsg2t4mVLsYBvn0b+Vf3JMEet14X7wQ7TtcKOGS6WX0Asb
         lw+Q==
X-Gm-Message-State: AOJu0YzVtw9eHIvA3Wz7dnHxhUOZ3nogpY+s2ZlbolQTQCNFCLat+GGi
	mhtuA7anhcxPJXPS3iT7q49JDmNjT9cjNbimJCdC7mFC2wHfPW5qkaZrJAK+Njs=
X-Gm-Gg: ASbGncuoWeMW+NfmoZ50aYnaK6zRFiY7MSMrEiGIfv2kDBS5yums/kVwyLN5dvpWJ5X
	utR/xHxwQH5BV+Z1LeRsy0Tyq/FMvkIPTSUVCJHu1K+bZ2/lERw7z4r+5BnHAzC7qNKwfYsVwn2
	s+Yey851K9Tk27mL241Zrw0MgWv83JnzZyc5+Yu9TO93ZDGaodTtOehOH91HdMczFNXG7/9xL7m
	LaR5/c6I+uJf0pzaJ9kb+bwflNLn/NR6A2sb4oA2tb4vrT5QjBrA+80bDxp7xYyGNTVJy9jfKbN
	ed8ul+aNNylhb0vFo78x9AjblVORN25hJJW1ApaWz03PsKNlwJZ8nXYC0A==
X-Google-Smtp-Source: AGHT+IFGW52sOnfDnF40+MnlNb+49O0NM6Hh5OhPgbLG38/LdNTWeRaD7LR3pQqJksaPXkInel2pCQ==
X-Received: by 2002:a05:6a00:4648:b0:736:a973:748 with SMTP id d2e1a72fcca58-73905a2515emr21659592b3a.22.1742863245956;
        Mon, 24 Mar 2025 17:40:45 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390600a501sm8705513b3a.79.2025.03.24.17.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 17:40:45 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 24 Mar 2025 17:40:31 -0700
Subject: [PATCH 3/3] KVM: riscv: selftests: Add vector extension tests
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250324-kvm_selftest_improve-v1-3-583620219d4f@rivosinc.com>
References: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
In-Reply-To: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Add vector related tests with the ISA extension standard template.
However, the vector registers are bit tricky as the register length is
variable based on vlenb value of the system. That's why the macros are
defined with a default and overidden with actual value at runtime.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 111 ++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 8515921dfdbf..576ab8eb7368 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -145,7 +145,9 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 {
 	unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] = { 0 };
 	struct vcpu_reg_sublist *s;
-	uint64_t feature;
+	uint64_t feature = 0;
+	u64 reg, size;
+	unsigned long vlenb_reg;
 	int rc;
 
 	for (int i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++)
@@ -173,6 +175,23 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 		switch (s->feature_type) {
 		case VCPU_FEATURE_ISA_EXT:
 			feature = RISCV_ISA_EXT_REG(s->feature);
+			if (s->feature == KVM_RISCV_ISA_EXT_V) {
+				/* Enable V extension so that we can get the vlenb register */
+				__vcpu_set_reg(vcpu, feature, 1);
+				/* Compute the correct vector register size */
+				rc = __vcpu_get_reg(vcpu, s->regs[4], &vlenb_reg);
+				if (rc < 0)
+				/* The vector test may fail if the default reg size doesn't match */
+					break;
+				size = __builtin_ctzl(vlenb_reg);
+				size <<= KVM_REG_SIZE_SHIFT;
+				for (int i = 0; i < 32; i++) {
+					reg = KVM_REG_RISCV | KVM_REG_RISCV_VECTOR | size |
+					      KVM_REG_RISCV_VECTOR_REG(i);
+					s->regs[5 + i] = reg;
+				}
+				__vcpu_set_reg(vcpu, feature, 0);
+			}
 			break;
 		case VCPU_FEATURE_SBI_EXT:
 			feature = RISCV_SBI_EXT_REG(s->feature);
@@ -408,6 +427,35 @@ static const char *fp_d_id_to_str(const char *prefix, __u64 id)
 	return strdup_printf("%lld /* UNKNOWN */", reg_off);
 }
 
+static const char *vector_id_to_str(const char *prefix, __u64 id)
+{
+	/* reg_off is the offset into struct __riscv_v_ext_state */
+	__u64 reg_off = id & ~(REG_MASK | KVM_REG_RISCV_VECTOR);
+	int reg_index = 0;
+
+	assert((id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_VECTOR);
+
+	if (reg_off >= KVM_REG_RISCV_VECTOR_REG(0))
+		reg_index = reg_off -  KVM_REG_RISCV_VECTOR_REG(0);
+	switch (reg_off) {
+	case KVM_REG_RISCV_VECTOR_REG(0) ...
+	     KVM_REG_RISCV_VECTOR_REG(31):
+		return strdup_printf("KVM_REG_RISCV_VECTOR_REG(%d)", reg_index);
+	case KVM_REG_RISCV_VECTOR_CSR_REG(vstart):
+		return "KVM_REG_RISCV_VECTOR_CSR_REG(vstart)";
+	case KVM_REG_RISCV_VECTOR_CSR_REG(vl):
+		return "KVM_REG_RISCV_VECTOR_CSR_REG(vl)";
+	case KVM_REG_RISCV_VECTOR_CSR_REG(vtype):
+		return "KVM_REG_RISCV_VECTOR_CSR_REG(vtype)";
+	case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
+		return "KVM_RISCV_VCPU_VECTOR_CSR_REG(vcsr)";
+	case KVM_REG_RISCV_VECTOR_CSR_REG(vlenb):
+		return "KVM_REG_RISCV_VECTOR_CSR_REG(vlenb)";
+	}
+
+	return strdup_printf("%lld /* UNKNOWN */", reg_off);
+}
+
 #define KVM_ISA_EXT_ARR(ext)		\
 [KVM_RISCV_ISA_EXT_##ext] = "KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_" #ext
 
@@ -635,6 +683,9 @@ void print_reg(const char *prefix, __u64 id)
 	case KVM_REG_SIZE_U128:
 		reg_size = "KVM_REG_SIZE_U128";
 		break;
+	case KVM_REG_SIZE_U256:
+		reg_size = "KVM_REG_SIZE_U256";
+		break;
 	default:
 		printf("\tKVM_REG_RISCV | (%lld << KVM_REG_SIZE_SHIFT) | 0x%llx /* UNKNOWN */,\n",
 		       (id & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT, id & ~REG_MASK);
@@ -666,6 +717,10 @@ void print_reg(const char *prefix, __u64 id)
 		printf("\tKVM_REG_RISCV | %s | KVM_REG_RISCV_FP_D | %s,\n",
 				reg_size, fp_d_id_to_str(prefix, id));
 		break;
+	case KVM_REG_RISCV_VECTOR:
+		printf("\tKVM_REG_RISCV | %s | KVM_REG_RISCV_VECTOR | %s,\n",
+		       reg_size, vector_id_to_str(prefix, id));
+		break;
 	case KVM_REG_RISCV_ISA_EXT:
 		printf("\tKVM_REG_RISCV | %s | KVM_REG_RISCV_ISA_EXT | %s,\n",
 				reg_size, isa_ext_id_to_str(prefix, id));
@@ -870,6 +925,54 @@ static __u64 fp_d_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_D,
 };
 
+/* Define a default vector registers with length. This will be overwritten at runtime */
+static __u64 vector_regs[] = {
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_VECTOR |
+	KVM_REG_RISCV_VECTOR_CSR_REG(vstart),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_VECTOR |
+	KVM_REG_RISCV_VECTOR_CSR_REG(vl),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_VECTOR |
+	KVM_REG_RISCV_VECTOR_CSR_REG(vtype),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_VECTOR |
+	KVM_REG_RISCV_VECTOR_CSR_REG(vcsr),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_VECTOR |
+	KVM_REG_RISCV_VECTOR_CSR_REG(vlenb),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(0),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(1),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(2),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(3),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(4),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(5),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(6),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(7),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(8),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(9),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(10),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(11),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(12),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(13),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(14),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(15),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(16),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(17),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(18),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(19),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(20),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(21),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(22),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(23),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(24),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(25),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(26),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(27),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(28),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(29),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(30),
+	KVM_REG_RISCV | KVM_REG_SIZE_U128 | KVM_REG_RISCV_VECTOR | KVM_REG_RISCV_VECTOR_REG(31),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE |
+	KVM_RISCV_ISA_EXT_V,
+};
+
 #define SUBLIST_BASE \
 	{"base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), \
 	 .skips_set = base_skips_set, .skips_set_n = ARRAY_SIZE(base_skips_set),}
@@ -894,6 +997,10 @@ static __u64 fp_d_regs[] = {
 	{"fp_d", .feature = KVM_RISCV_ISA_EXT_D, .regs = fp_d_regs, \
 		.regs_n = ARRAY_SIZE(fp_d_regs),}
 
+#define SUBLIST_V \
+	{"v", .feature = KVM_RISCV_ISA_EXT_V, .regs = vector_regs, \
+		.regs_n = ARRAY_SIZE(vector_regs),}
+
 #define KVM_ISA_EXT_SIMPLE_CONFIG(ext, extu)			\
 static __u64 regs_##ext[] = {					\
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG |			\
@@ -962,6 +1069,7 @@ KVM_SBI_EXT_SIMPLE_CONFIG(susp, SUSP);
 KVM_ISA_EXT_SUBLIST_CONFIG(aia, AIA);
 KVM_ISA_EXT_SUBLIST_CONFIG(fp_f, FP_F);
 KVM_ISA_EXT_SUBLIST_CONFIG(fp_d, FP_D);
+KVM_ISA_EXT_SUBLIST_CONFIG(v, V);
 KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
 KVM_ISA_EXT_SIMPLE_CONFIG(smnpm, SMNPM);
 KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
@@ -1034,6 +1142,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_fp_f,
 	&config_fp_d,
 	&config_h,
+	&config_v,
 	&config_smnpm,
 	&config_smstateen,
 	&config_sscofpmf,

-- 
2.43.0


