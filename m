Return-Path: <kvm+bounces-53058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9685BB0D020
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 779761AA2494
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C4528CF47;
	Tue, 22 Jul 2025 03:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="s5YeUef6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9628C2A5
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154130; cv=none; b=ZIpSpOOp2KzmCG5UkR9z6iWX2ykuBC8yTH0tnKmHk3WIuxmKramMzrYONkCqCV3j8a6wRV1HTHXlJNEcbUQ+RV4Py256C4gv0eurnN1uM6Lh2mL4+pIIao8nZGzhQsy+yuCFYpk2bPorwJFSkbHj2idmk0hJnzsLpWPTPhFS6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154130; c=relaxed/simple;
	bh=e7KhWyihGNeHQtmANrYGamMrWZjvNUfv+srLihtniBI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KxsN5lT0mG4nvJZ9tzBZdOcZKxotzG5XyPPMFLrliirL8UDFK29ZGu5FkxazbGkT56byh/oDn5nYBXBW/nDE34RqKSga6BvpplwLyT3RiBr6ID16LP/9cB21o94uqxL5KXGoVM4NQTIGiqVLa6LAeosw6NMnC1FFPLX99G6BRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=s5YeUef6; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-74ad4533ac5so3241362b3a.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154128; x=1753758928; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=goqLKtDob+ZNX+w3rmmnq6+zF8DlfuvYjDiKv2ieDbU=;
        b=s5YeUef6RTO6GfWIMiC1SiGduaDJSwIs1PcaM2diW9VDyubdNMNxwdhu9BO/1p4Fhx
         BWY8qJlBnPphX1opyliabfp2IxHk/PGGZZyImCMH4P/xTzPQtFqNH4r2ONmMh8nz4oqJ
         f/K54DY7ACvjc1a/NqZl1UqFaKDntienWU6mAUD+DlEY9h89kFx/8c9rxg3aYJ7HgMqR
         tzvR72wtEurfepWaZdH6YrW8dJY93iv8A3ixcqJvdqnBArXSODGveH8sIKvkTCg4xIuG
         t6uC0DUghYrFCPH48gM32fX1cNIqWyX30vRrrnyxd7aJdbpDULtFTaJR6qei6lfhwrGq
         D8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154128; x=1753758928;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goqLKtDob+ZNX+w3rmmnq6+zF8DlfuvYjDiKv2ieDbU=;
        b=tcostPwmk5xzWi6OG3+lM03NK9ymnSUeEbe1AhuMgUuJZoAHJjoKFjXCjPOR6M3wmA
         xyCwlrS/969mTcuCX1CPAmjPPwNB0js4HELhLw4eG+k431sPNxFGm+5ryM5aQpM0lV8x
         vaswbswK7lSjTBn1XVVV89UeQD0nWGbfc6ixx6oJmgCv9cuVBFMo7MLFshS2hpUpwYpX
         PKADA/LM4ZElZ7QzqdiQtZgwzOm+ep18yjYg6kiDjt4KyytatnYEZYkjz48wbp+iMH5X
         OEwzRVTxc03RY6qWL8S7RNrFVTlgMnLsX6WulXtM9Gz26t1Rb/WFw1eaeETv+YBrIlBu
         6mMw==
X-Forwarded-Encrypted: i=1; AJvYcCUiHQqTE5qjAN7J39rvzM2G6zfUu82QgwvFcsokZo20+m518cGeomRZai09S7kbN0x2kFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCpRThgx+JQjwXMBQfRWcrvtEBNoVg8G+hajUkXy29X8J+v4OB
	WJ+QhQHVDjrKh/4UxiMqelHaZJTV7Zp53mqylG7XwVPASdujHHsicAnMAW5dc8pSi9c=
X-Gm-Gg: ASbGncuSNzuzAfi9nQs9zCLpq5FkSIwT/2aR8ueCS5mf02Y1kp/clH3wms1XRtiM/aD
	x06nbNuYfeRCxBR0Qie62oeNk+ZJ6rJn+Hwqs1bNUZoG8ZW9oNX9BfQ8b8X9FwOfz+NmxqCj7D6
	73vHZfkUMw+9mX8HOKNzlqECGFDJ5+D+vKM9OX2WHdKkaV0VOXznr4meRYIe3b861U/XJZafXXA
	cwScd1WY/6Tf6uIdbL7AKdAhDgbxDMZ7mizMfrSp14ammugb5Gva2OJSH2oaLVDH1+VjYQgGPdZ
	47qAdBXmnrdvJGFZHA02T082V4P1kQT+KHF+fZfRuOcs27WaAB0j+W3XFY46OR28zxwQ0hujO8j
	d8T8UgzPyW0ofH/gdj+3Y4ZWHSuhPUsa1rek=
X-Google-Smtp-Source: AGHT+IHQyL4rtGfOdMFXQZYZwkkphmY+Xgv9oIObvrdf8R89tWOPveRkw6OvWr9uZxH2fTwJdfujLw==
X-Received: by 2002:a05:6a20:9186:b0:235:7452:5867 with SMTP id adf61e73a8af0-23d37d7e90dmr2717183637.20.1753154128287;
        Mon, 21 Jul 2025 20:15:28 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:28 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:19 -0700
Subject: [PATCH v4 3/9] RISC-V: KVM: Add support for Raw event v2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-3-ac76758a4269@rivosinc.com>
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
In-Reply-To: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

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


