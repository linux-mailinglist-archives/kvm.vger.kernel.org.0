Return-Path: <kvm+bounces-56313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B0174B3BE1E
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 758474E25BC
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4297E313E0A;
	Fri, 29 Aug 2025 14:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="EtK8PRuo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E114B31CA73
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478473; cv=none; b=SQokvEbYjmAuULC2mjZB3JxIuVblDmp6TfxjMZEDF0mWX44YcisET4TG55NsoIp8XKgmFVWywWcSp1eVC5vcP2k+wPfb1DbiAJSY+x1BciiDtsOJM33TtA7HuBi7vGrPdu49TEQ+eIGyO4SRGTvd8ot1gN+syhavLEq0itTHHe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478473; c=relaxed/simple;
	bh=e7KhWyihGNeHQtmANrYGamMrWZjvNUfv+srLihtniBI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OrsDWjKJRrYmy1h9eSywnHqI/exyN0IE+J86lw6ylpFk0ww6IiLKkQaJV/lOFykOaTHoanRxtwLHiU7CpAwU6JdI9yiGWYAuvwTCprKqpXYzxIHU6RlQZAR2MuL6ASsY9m01k/gtf5pnQ8+/1mneXQayhtoUgZ4sPDFQ/lMnHCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=EtK8PRuo; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7722f2f2aa4so892876b3a.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478471; x=1757083271; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=goqLKtDob+ZNX+w3rmmnq6+zF8DlfuvYjDiKv2ieDbU=;
        b=EtK8PRuoWOe95IqWtOpL1KDEh2Pv3PO+5PrWMXKT/e+2YbjNsIRDwLBkgVQIxjvmzq
         6WVDsFecW5MYzFjYAHag/p/IKLpCSnnCTNZ7vs/AfxVDUnnuJlcB42VhRWcflO3TfNDq
         VDBspTSvPpdaDfmpW0hyd9s6mw/zJ7Ulu5Tv987en4c0yRnSuLDgTQ9pFRLJXOjPPSKm
         k/mUUMT4AndDNwpO9TmKLQMAgl/bR2jcs1Lr+CeO259qwJ4RMqlTCqzVP+hcGwDjlZ+4
         k0Rq9QXNBSzi9ohKZTY98Zbo15iK6jhsGDwbnLOYYvez9PCbTIk8LSVgP+1CPglTBiih
         XvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478471; x=1757083271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goqLKtDob+ZNX+w3rmmnq6+zF8DlfuvYjDiKv2ieDbU=;
        b=JsAAh/C4pFtXC18y8eIcRy3nBDG/K27uWrW8Lj1Dbsdt7ONlIK6FkeYZmVVdxRevH7
         TS1r5SiIJLEpPcCAd1ENPi7dkxHDTBtZUdI3F+hevm0YHQWLh4MsiRkScFoVFzebnkq8
         2S16xvtGPz6ONigxAz43BC5MbYx+MwKDPCyn1EjyZuU75XVoJvSuY/O/NWVniwO59n60
         orF8NKk3/+R31RqTithRYaPwyr/0WasKZReZvRA+x8od7x+1v5U516dl6X+kW3T8+UGd
         mr/rsBAcVLl7ZOaLJxYjWBifvM2U+c69M40ik36mee160tUUlXr+vRBvkucJycbAEOf/
         f2tA==
X-Forwarded-Encrypted: i=1; AJvYcCX7FIVsJtNmm5IRcBvAfCEJwYstEmFnk8VtUCcBQg4pH+5AvQqNK0ZyOGh5xMWL5SPzDAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6duFufxQFNNJVZMzL83SdBBFo3tItcHF9yAFLDm72Ky2Sh0m6
	p2/T1KQpQsqxOS1De36QmiggTRGXRWJ6yITnxr0lC9Pxe6bM/ovwuQCIAtD2m0teZOg=
X-Gm-Gg: ASbGncsw3d9u68Al9FUpqYcDQGtCUib10aL8FZBVqp/QHQ0SMajAS9EPIGh3itKNjnW
	xrC/eLdXr6Pml7IFpui/W5IyBQGLzdO3VzKgU90trLOtyskpqzeNIqArH/yDhITl2OM8p6LJdxx
	kkVyw05cibILQDDA1h8zLPn+W4qhKoyZmcmCTPjA8YYkwWaktQCsqJsY9dD7mLMqjuLS5MZFaCa
	MY5weOQO2BXYybf7hxIKMXyLcntOcNS70k5ZXqUE5oISkmsMQaO4utD+D0IEWMOxuOUUibbzvWO
	36L7V8KohmCRXxiKDKp6ppdhZN+QvcnqNe9rG4XCtISuPwZmr6m5ac3mOadA8ddr79aQWVNCan1
	T2rCiXIeCJvFYjeIRFMQfSVEpR8Ae3HpTYdeIMX0nS5wthruO5Dxu4RGn
X-Google-Smtp-Source: AGHT+IEjIYlQyj5LF8L5OMDqDMzS8FXoLsXKsGZxQnXqTFQeAwVRK9v09HJ44UP8l3p9Cu40jXYhVg==
X-Received: by 2002:a05:6a00:4f92:b0:772:38a9:4d98 with SMTP id d2e1a72fcca58-77238a950ebmr927358b3a.13.1756478471237;
        Fri, 29 Aug 2025 07:41:11 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:10 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:04 -0700
Subject: [PATCH v5 3/9] RISC-V: KVM: Add support for Raw event v2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-3-9dca26139a33@rivosinc.com>
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
In-Reply-To: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-50721

SBI v3.0 introduced a new raw event type v2 for wider mhpmeventX
programming. Add the support in kvm for that.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 78ac3216a54d..15d71a7b75ba 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -60,6 +60,7 @@ static u32 kvm_pmu_get_perf_event_type(unsigned long eidx)
 		type = PERF_TYPE_HW_CACHE;
 		break;
 	case SBI_PMU_EVENT_TYPE_RAW:
+	case SBI_PMU_EVENT_TYPE_RAW_V2:
 	case SBI_PMU_EVENT_TYPE_FW:
 		type = PERF_TYPE_RAW;
 		break;
@@ -128,6 +129,9 @@ static u64 kvm_pmu_get_perf_event_config(unsigned long eidx, uint64_t evt_data)
 	case SBI_PMU_EVENT_TYPE_RAW:
 		config = evt_data & RISCV_PMU_RAW_EVENT_MASK;
 		break;
+	case SBI_PMU_EVENT_TYPE_RAW_V2:
+		config = evt_data & RISCV_PMU_RAW_EVENT_V2_MASK;
+		break;
 	case SBI_PMU_EVENT_TYPE_FW:
 		if (ecode < SBI_PMU_FW_MAX)
 			config = (1ULL << 63) | ecode;

-- 
2.43.0


