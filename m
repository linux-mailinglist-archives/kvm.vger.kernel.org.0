Return-Path: <kvm+bounces-60343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB7DBEAD40
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ED8C74871A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401FE33CEB5;
	Fri, 17 Oct 2025 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="TEgLE79o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD15337112
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716799; cv=none; b=PuQQeSTHCq3tpzpB4Q8CbXPU7rMrGxzIFJOlpkv4W8+V/S+kAagGsgNOAnThTenrCudUp7ar+ONvlAIIwpItm3cMg7JJt6QYFr0TaerT2SPoUJneLTIGvmRIUkTiBOcILveBXf/kCABu1MycvpucSZ0iR3hgh1EhQYfADKjwcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716799; c=relaxed/simple;
	bh=mljYXy3IxITmRqF+iKLm3Yh6cbzzCUWnVlBHoIsPH6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayevu0Bbt0gma67krdJohBHNKZbnNnp0M6qkPDnsH75fHPstnYWNwYPZUp5mWvjlcp40wc7Sk3JPpbQNdGrKxOIKUHSTKiUHpv0tjJ9UZzhZGZhocXXAiqyDPlYjl0nU91DOtqZNaw7vkwjSoEK5ylTuLMYIzNW7D3B4wGVY7ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=TEgLE79o; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33bb1701ca5so1675314a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760716797; x=1761321597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOxr4kUrx3o2qKQ3zJr2xwhR1Y/B5zgWnTBkv0V7+0s=;
        b=TEgLE79oyLTIzTpaYpateLbqAEvaFcyC039NNpYrHFNurzIgWGMPJTZDZyBhtckAzA
         Ojulz74rg4qqqdfFqyC/iorXtkH4KKkHuizS0h4H6R7x1tWQ5zr/QhVuv3dib4Zmc/xe
         md8n2iIzKKRafPuM5MM5kWoBv55z/3/ft61+XGPB5H8TYRSsb5e/c+8UMV2aK5Pfm4v9
         hebCPmGfUuDAVkjmocMVZCI/FH+8SzmDvsJeEQrCWGFAUjeiKqJlZ47NxFGLavHbJ+oA
         LM/RoXSveacFH/VeatMPjovVaRCslviJzFnvtNaodV1eSczveprCM7Fv+KMnQk8zoFHu
         jvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760716797; x=1761321597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOxr4kUrx3o2qKQ3zJr2xwhR1Y/B5zgWnTBkv0V7+0s=;
        b=NcvoMCIT0VaIJc7JqAz4MD9jZuVW/ZEAo3+SYsT6kkCAPs25nYpeuJymGunRb1+zeH
         97HVWGuOyxD0HLJHTmEgf1Nq/WG5b4+6I3YbP2Vk80kugrcqXgWYlw+wAu5ZssbLg+pC
         IfN1NU1hJ1li+p7FAFyM+QJRRepi7g+OVciRyQWm7RZdEHbjGxF0XvjJ/MpU8aqqXRpQ
         sEqeBcZ4FW0j/+LOWil0rxSa9V+j/DE2H00bkm1brAGV9vu/3nldz9TmgHYHfLFAMd7a
         3wrICiy6qf0mikRLeti/h5jKAvgNh+x4LxfPCptEy1eRmyIc6WQQPrcsf33nu8UB7v2F
         e6MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUO/KyrcYLuk5Gu9qdJpVPtEDO89WaJdjU/lQ2bgqLO7bljululd7PVeMbxwTvB/ET7pU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVoRiM6LzvOrv9/VDUZHwlCSuLvM5BvouGn+xavTaYJQCoEShL
	HPRr2cd729DL51fH+Llg7sSqQZ1zJq6YapxdmAzXixqwPYGginNKlwE8ZIZiWVquVQ8=
X-Gm-Gg: ASbGncvLfLZ15yhxUwSyo2a3s+Y6dR4sqaTqEBcw6/iLdxpLuvmosTRVHuFLDZvewHv
	9s6QVOBvTuR/9ZxUKPIu3P3THPFsJOI5+OTGYQLxK315RWD9fo00PEcNCAEqevF5+Z91MAMnx9F
	fOdts0X81i3o0ddF4JysWcoeJR5ANsJxTu/A9o22aV+HcH92AMknI0YkmocXbqg/w6dbdNU7Twq
	EJZc/E1S2Pc2hiY2CyIMAKuwfWKI8hmSYm3FEGk4HhrmWbGiqbSFp5JiztL/iY0+2S73IPZ1V7K
	b4+1RVcYTfkSRQtS3rZoaN9oCSNOAo97AOjNSWEXBJVfoQJ0/dQ4q6ysbhir6v8n+7IAXKaJwUh
	idCYeUqqDyw0d0EjhCQHvU2L0zS6nNtKRr3tnlfdHJl53cR2PhCoVf6J4gfeqTwKqtJ42qTtq+T
	gmSmVGIz4pywc9EzM819R67EYnI3wGJNpj
X-Google-Smtp-Source: AGHT+IFoCPBiPeGQQLQ+fG7ai4z/yEAOOUIjHcz+WvJaH5Mkp92XTCRypBxB5qA/CcWwuixBEctClg==
X-Received: by 2002:a17:90b:2690:b0:33b:a5d8:f1b8 with SMTP id 98e67ed59e1d1-33bcf86ce26mr4729546a91.15.1760716794026;
        Fri, 17 Oct 2025 08:59:54 -0700 (PDT)
Received: from localhost.localdomain ([122.171.18.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a7669392csm151067a12.18.2025.10.17.08.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 08:59:53 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <ajones@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 4/4] KVM: riscv: selftests: Add SBI MPXY extension to get-reg-list
Date: Fri, 17 Oct 2025 21:29:25 +0530
Message-ID: <20251017155925.361560-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251017155925.361560-1-apatel@ventanamicro.com>
References: <20251017155925.361560-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows SBI MPXY extensions for Guest/VM so add
it to the get-reg-list test.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 705ab3d7778b..cb54a56990a0 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -133,6 +133,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_SUSP:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_STA:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_FWFT:
+	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_MPXY:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_EXPERIMENTAL:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_VENDOR:
 		return true;
@@ -639,6 +640,7 @@ static const char *sbi_ext_single_id_to_str(__u64 reg_off)
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_SUSP),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_STA),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_FWFT),
+		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_MPXY),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_EXPERIMENTAL),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_VENDOR),
 	};
@@ -1142,6 +1144,7 @@ KVM_SBI_EXT_SUBLIST_CONFIG(sta, STA);
 KVM_SBI_EXT_SIMPLE_CONFIG(pmu, PMU);
 KVM_SBI_EXT_SIMPLE_CONFIG(dbcn, DBCN);
 KVM_SBI_EXT_SIMPLE_CONFIG(susp, SUSP);
+KVM_SBI_EXT_SIMPLE_CONFIG(mpxy, MPXY);
 KVM_SBI_EXT_SUBLIST_CONFIG(fwft, FWFT);
 
 KVM_ISA_EXT_SUBLIST_CONFIG(aia, AIA);
@@ -1222,6 +1225,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_sbi_pmu,
 	&config_sbi_dbcn,
 	&config_sbi_susp,
+	&config_sbi_mpxy,
 	&config_sbi_fwft,
 	&config_aia,
 	&config_fp_f,
-- 
2.43.0


