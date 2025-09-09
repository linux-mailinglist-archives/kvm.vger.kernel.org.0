Return-Path: <kvm+bounces-57055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B116DB4A2DC
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FF3B4E4A05
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDB4307AEA;
	Tue,  9 Sep 2025 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="N1E/HJe2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316A4305954
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401409; cv=none; b=TvLI6/fzKswnQpSQQxSuspw35sHRREO9JItZDcGsTdpLHRhh7ChtMUZzIM8pE2/9eG1xJYBEPqqd/FH/84wHx95yj/KVq84b1nNHqHsJ5RmGWH0Bac5MsqZmCZEROqPNOUE4hA6AIhFjxMHmpqZPv3YuS92JnAUBtizUdqTq+PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401409; c=relaxed/simple;
	bh=e7KhWyihGNeHQtmANrYGamMrWZjvNUfv+srLihtniBI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rR7m/wWuxSMvw3sImlsBm8hWWYtyEzYGv9t6BrYwoKEiIjNiO6nqNu/6WVwLiXmhMOtm02vtgfvqPC7Avh+kSDBtJkkWe2rKmCWVX0U8q/FzABQ4+J2aXNg4AI3U0xtByJWOz9FYdic4xA9CJan/Vwm3HaADlnelR746+WIduQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=N1E/HJe2; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7722f2f2aa4so6785029b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 00:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757401407; x=1758006207; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=goqLKtDob+ZNX+w3rmmnq6+zF8DlfuvYjDiKv2ieDbU=;
        b=N1E/HJe2XfSWukdNA17LW04R5vXX2EnQM/AjD6fK6Uv4HKXw6MCiXmp35efxtGosCe
         tzJwq7qowlNgMg3NKlnPrN2HiW+/wEWliiFq63hdtmc5Ap+gGHNOSVWPFqn2m1c+Uf2Z
         A2DvjJp8how1xD9zw7u8LP4tni9+dN47NOwYbMBiRQw/BzG1G2pcaiBrOkRiM7TAbAEH
         ijw8+k3C/1nhuPhfLJ1KcFCFerxcYgkhPWxPcZsblCugurdHDcwqiMQFKNdvfet95XTP
         rkskltf+8STQilT4lxOx720khqEZhW0kpyza5WMw84hRVtqQuudNjhXWsJZIsq8sE4LK
         QUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757401407; x=1758006207;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goqLKtDob+ZNX+w3rmmnq6+zF8DlfuvYjDiKv2ieDbU=;
        b=SwOpZEdVYh8bIjXOM1S+s4dAlraNLiUimx7pBesHIALcnnTRvvNeeUCq7wDJ98J7t+
         WS8b64s9Y2Tx94C99KzyPgHQzwbak42JZI5vPmMjhsvQeuvwXGtstij6jMlggUWz9Tkl
         Fd2SQIk6NRv5V6ipNzYOrfU0J+G4Xn1T9WGVuwVgNkOi3iR2lrz3Z6kkmAfFvS2SE6jt
         ZnMZNg/AyGSXCBrvXKhL1kstFoX8mmPqgHF4NnYHDyiW1qFf1RwrghSrd+iS6T/gwStU
         v539JPwQdKrkoaRSy3ap7Djoc+Ej47KjIJndyX8/paeLRh4aGkFrjrwt+2g2gE5M2wBg
         Nv3w==
X-Forwarded-Encrypted: i=1; AJvYcCV4XHD9+7N57lrHHbXv4XgQKk7kA7UHIIW0diJGZXJ4sE2N8R98l+7NFcHjq4FXvw4qL48=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLnEYjcuOOkWTaAAAY7LwhncT7kPRV7Bahj1/4lQchr0H7A1CT
	1VT86v2vu2StAJ+Bmf6FLBEftjupN9jlyfDDhjZXP5GtdGzvWnHoserInEmBtmkpW38=
X-Gm-Gg: ASbGncsjJL+SPKGmx7KdAiQP2KlB4vppy1IBcYN0g4bU27t4WL1rOr+NfTwgb8op0pQ
	scthEhOElIv1X9cGs7i29a6aRVi4gOIL9E2Upd8882wzpzFLRRGa1jcNhcZylXQf0pV6/9WoFPn
	eSIpaw18z6HJgvpnhutubVhx0iRJ/IvqWubIpxt5yRmNDIxyFZ2RzjzH+pDEU7BF0EfytgsGg4k
	h3pqJ5CSfrSKTTFyQA6upvJ9gIp6s/PuMSumXVSMJBYUuPKSwNhxYLjvip3K2NN3gzE39a2T3Bz
	33VuY4o8W9siB1QKbuHsg2wtms8F5kphVoxTgeedRwysEfVHEwby/AwOL9z4BPycw8kl93MJZTZ
	RogR46Xb8kZ6QYb4i5idfHA7asty9rJ2sfgc=
X-Google-Smtp-Source: AGHT+IGJbDnkT5SHhTAhiO5Q6ljc1ugcvXc+gcWNPs7wch9qaoN42+cmkfKz9M/HNQWQv+Jtvr6PpA==
X-Received: by 2002:a05:6a20:3d83:b0:250:429b:9e56 with SMTP id adf61e73a8af0-2533e9476eamr16763215637.8.1757401407457;
        Tue, 09 Sep 2025 00:03:27 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c7158sm1025535b3a.72.2025.09.09.00.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:03:27 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 09 Sep 2025 00:03:22 -0700
Subject: [PATCH v6 3/8] RISC-V: KVM: Add support for Raw event v2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-pmu_event_info-v6-3-d8f80cacb884@rivosinc.com>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
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


