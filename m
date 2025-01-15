Return-Path: <kvm+bounces-35589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D38ECA12AE8
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 498197A2F47
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800B81D8DE0;
	Wed, 15 Jan 2025 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="SafW0OEp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAFD1D79B3
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965862; cv=none; b=W4sw4NL4M9OxfwweUgd7VfAV6+/EWy68XbvpPpb0U9bQVgOhzJyfpsapxTX201xBNmgtE2LKLbPxErY6uGbLitZeUeCX43qvHF1EZuvTrgks//VlXvGtwYQKN2hg449r4UczUA7B8kCjgdYk862JhpBMmKb3APsz2CBziH8Lh74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965862; c=relaxed/simple;
	bh=rkpDrsA/PVcggHd7+EAEFge1PhxYTYtvQjpCCjdH2MQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f8WPEr5MLd1WYx04wjynrfOKVadtbvYSYsngAaZO52C/3U7ZSioFub5Ow+qTOE3O2NvqPmaUum+MGgHh5KPCkoCjlTzF2MKAvtfOalh/qu/z8h2cmjRuX3LmIzi5x2cYNr5dQq56/baGz19RpXN9xq/F83IYFFm6PHlDc6p8wog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=SafW0OEp; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21634338cfdso128148795ad.2
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965860; x=1737570660; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hCeV16Tw9Ue2BbFuxP2Jm0elvtAXwe5u9EmpHjH7wzE=;
        b=SafW0OEplxokJRfKhuKd8E1XPRTF0Vmf+rwKUxy7Bql4BO/Bm6g1JH9f8IM8UnOh0k
         fP/obteDSt2zfXPDzdxr9iQGSeOtIa1extE3vgjzWjMFZvzHutWSmU+sV7rZTsMqHpLM
         DxzSp4k9rcX//dgChIPPB+lqUsK0dJG5QhhtuHi1gIL8FFZ9/z5wzUoxjBYYar/qm3um
         VaJgf/T3iHUScBAlH+xyPiVOc0iqsI6DmlJieU+Xbk6l3RlVn/5Zg6jEByIo54MZu28S
         XvkqQezAF+QQieHQ5Dh8NFESYwqFdDPL3+6E0Jckyyd1l1bRT75yGmbHJYQY33q7me9+
         X/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965860; x=1737570660;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hCeV16Tw9Ue2BbFuxP2Jm0elvtAXwe5u9EmpHjH7wzE=;
        b=okZrp2BwMZlvCkq0RSYt2VXGbWcmQk8JJyoN6DdICQUdyyj/PSN8npgWhQUvs2jEBy
         Eyv6WarjU6JC5HFc753fItj8aN40kJZMc4r76H0K96MKPXOK+ao5FktoCZJptPf2SFLh
         OvqeN6oxwrfA6o0kBcDQ37bsqtd/lBOw+jwsg+DokgG2solUM5BMFz46lvb7UPfNh5pV
         DDeaalYovPLoOYCO+xUsxk3mxeGtgEPeqqg8rZvOO1UtFQWInPM5vbTqz7SyKD9O+6T4
         +8chAJBTkHo7izaxAg7fkAuK/9onw4Njswydw+otwzkTFgHmS5AbUA7nfSAVVsJ1du1g
         HX1g==
X-Forwarded-Encrypted: i=1; AJvYcCUTTHqMUJVmCtDUn388cvywI3Iwyu0nyWhuYVszzu+Rvd1OywYaIv3LXUEiI0/nhPuNklI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhnGYFJHVbfG9pED+0sFusTxHXIkZdXJPDAz0VrusDxDQNpVpq
	5uNCR1n6LgQDSZ04aBLhyUMt9o5iV4Fpdz3XgMx0OfiKWNbviKx0Su8hQbSS3fY=
X-Gm-Gg: ASbGncscMCYUBbJ9F8PFICbMSXp9x+Zy8rLPqhNdLOA+w//XVmbU2Dy0cCoIjSa0AF4
	DnQkqNicQXMjwzTxvMrJnndYkpvCzbXWKzfjazrazzj2QhMYUCQQfp468IeumBsq+QmTBdaIkSD
	J/fyBB/nHVbmgZ/dG9062I0iUd+hNNlTbLIBC7tc5BbB0lufF05L6JYzV9Fbg2NKAmFc9kpIVU9
	2ArSuNNNAElUf+bUVU4z/fUBhur/XUaY4eDtsf+9KqmVxdEiwX4qDLJk4a3MhSlNVl+RA==
X-Google-Smtp-Source: AGHT+IFhv3d+iNN38adFn+dH29zIS7C6pmY5MPy1fONgMvFeK1H10VHPHqcDN6p90NhFpRdpeycXlA==
X-Received: by 2002:a17:902:f68b:b0:216:32c4:f807 with SMTP id d9443c01a7336-21a83fdea82mr472230285ad.45.1736965858786;
        Wed, 15 Jan 2025 10:30:58 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:30:58 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:43 -0800
Subject: [PATCH v2 3/9] RISC-V: KVM: Add support for Raw event v2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-3-84815b70383b@rivosinc.com>
References: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
In-Reply-To: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

SBI v3.0 introuced a new raw event type v2 for wider mhpmeventX
programming. Add the support in kvm for that.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 2707a51b082c..efd66835c2b8 100644
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
2.34.1


