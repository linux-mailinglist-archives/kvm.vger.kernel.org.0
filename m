Return-Path: <kvm+bounces-47404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D51AC1432
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE5EA40674
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B90B29CB56;
	Thu, 22 May 2025 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="smORANQo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A6529B21D
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940634; cv=none; b=PV18TXvMd/37JH4esbrVSs5wgDGYIZ5VpFbqkEcCRgI4ZeDRuJKVRWppmtkGN3AkRA5zKIwgQ0i2OmUtP/YSGhDfUtTgUfYtzJWSLrcQU2Se419KAuW9ADDyBpVTiWi+iDktgrKKm29J72GchPch1DAHjEf7eFX0ciIIR1HKUFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940634; c=relaxed/simple;
	bh=Ty1W0taSmzUHkELzUxGMfb+RxYmgPja/Am3sZkteGZQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cpQTztH0JfQnVie1kxC1ahOJaPa74oTtz1rJU7d5PzqkI5y26Tvr0iw7VwtwxChF7VoD7Q4D8nTz4ocLKhgqk4JyoI4gNLb582uiX9b5/dlsFGoGxTIibdzf6JeR1FdBGAnDH8WVqZqnZIKgLkYtLmTzFk9/bnP8I74MAtLq3sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=smORANQo; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-23035b3edf1so69334865ad.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940631; x=1748545431; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZzBI2/8zxd6TBktJeo9hVnWnoPSXGrqMFkDVMKCuo8=;
        b=smORANQojjDNT7Kdq/AI/RG3vh94JHZcxgEm42nIVhhO7C8NkECpvqPD41lRuNiote
         LvttFFVfv9YTdB94FpGFPhn/1VnfzJlNvhNaVJDQWqwT2aaH+SbDQJsTeOMil29H+jGO
         BJezZrElHD3/eiz6Zs7JkTDP+rbqJ1ye8Dh07BcgyPsmWh4BAd3HcnnSM0sm3jodH2N5
         hNkySnun8Vap8oAsb+kSiYamzgeQaSdOU+SbXfu++0cEiJY+R8AfNAP5VNCGOOWLnKRm
         WRhoZmUwQES88Cl8irIi1LakFDirhVL+CKW3ZoQ3Uj2Pr/WQeYQeio1++3Y9JZLBE9jU
         1lAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940631; x=1748545431;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZzBI2/8zxd6TBktJeo9hVnWnoPSXGrqMFkDVMKCuo8=;
        b=VHbWXJT8vFBEWCnZ39wB8DqwRu4dRTrqSLPY40IH6pg/GeG0lNCiKMCEA9ZGF2IS+9
         bamRBYF5qneLgFyqJq2cG1QNW8WIYLwqvdEbd7g/VgkFZuD8ge3VPPcyAs3VsPVjh6oa
         xOFSV7kqfOh0CQAJGTDpvhKcn2SepTxEYbedMf5lHlhB663ngekp/lc6EhvE6h2Ba4zD
         hPZ6yvHvdYqEahg4t/t6mA65UyKv3480LRYeC/x7ajgaX7FKMdUHUjbAwWHy2Ux8lsxJ
         /pDSGgdjqx0z0FFp17lJUBEo3m76YYPIrBxzVCBKJhAhZNxmZdIBKbjYV2yTjjKu1TVh
         IVqw==
X-Forwarded-Encrypted: i=1; AJvYcCX8FN7CLCYI5EW1nAsJo6WkPuyEKUESGUVwf7QmnFdMoHbVJuxoSR/os0XRJWxGkehvpJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoK1ozulU+CTHCUrgo9gJ3pQzokxRphKbcxfY67uUws5GInl1l
	utRE4UH3NMFggtjQwUFBfxrXbutouYxHcglMkigpuENT1jb8y5qforIqOIIsiDsfdVQ87uK3I/5
	QeuZY
X-Gm-Gg: ASbGncuJl+WODdPOiYkbBymGDOj8ka7/TegACuqh3EeTRu01IhoZmPJrj+MKIYVrzpr
	P+Z2ZLeIdMGT21qURbxvYt6VRfqOpMoITyKl6Hdsy2LgZKG8ID8688+62X16JTjk+KjwgFnUAoa
	cOfXdRD+PchKvqcfJ5W1/JVtuXExSe2CcH7CIaviQPu5u7oNRpos522UDX2hav1pvYfuh+SLaMb
	NOCrSSdorPcgDRbZU0WeS871IaoIfVrFxQ/mhAcAX+1qZpH+v7WxeAIR+Vv3r6QfoqqunHl4tOc
	52b7ibJJBRN320cIAixcexTiU/xoq9OgFNnzWC0MZW+fGqibboKv/eRkCy/5OVjJ
X-Google-Smtp-Source: AGHT+IEr79nTwwFBEJoxFRK5RNwqD1jq2SDcjYk7D0rQW6WwVVGL0IpJIiwt2oBQtuzcW3AhD+odEw==
X-Received: by 2002:a17:903:94f:b0:22c:3609:97ed with SMTP id d9443c01a7336-231d43d9bccmr330946415ad.30.1747940631058;
        Thu, 22 May 2025 12:03:51 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:50 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:40 -0700
Subject: [PATCH v3 6/9] KVM: Add a helper function to validate vcpu gpa
 range
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-6-f7bba7fd9cfe@rivosinc.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

The arch specific code may need to validate a gpa range if it is a shared
memory between the host and the guest. Currently, there are few places
where it is used in RISC-V implementation. Given the nature of the function
it may be used for other architectures. Hence, a common helper function
is added.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b9bf05..adda61cc4072 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1383,6 +1383,8 @@ static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
+int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
+				bool write_access);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
 			     int len);
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa, void *data,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..3f52f5571fa6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3301,6 +3301,27 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
 
+int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
+				bool write_access)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int seg;
+	int offset = offset_in_page(gpa);
+	bool writable = false;
+	unsigned long hva;
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		hva = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, &writable);
+		if (kvm_is_error_hva(hva) || (writable ^ write_access))
+			return -EPERM;
+		offset = 0;
+		len -= seg;
+		++gfn;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_validate_gpa_range);
+
 static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 				       struct gfn_to_hva_cache *ghc,
 				       gpa_t gpa, unsigned long len)

-- 
2.43.0


