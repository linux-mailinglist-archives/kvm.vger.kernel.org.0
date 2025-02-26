Return-Path: <kvm+bounces-39402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26296A46C5A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29A6516D640
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE9725A32D;
	Wed, 26 Feb 2025 20:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BXQPDPNZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3F6EEBB
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 20:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601514; cv=none; b=Ztj+wN81QMAMnC5rc1flr/d1yWoVltj8bR1nCKYBS+bAFv2fTTCTqdGfVkHz6JwTCjG2EWM2M7lNENLcyBh6s594sJ6CtTohsFe5nRansRaHdHaA5xG8eJb6hVBAtso58Avv96jOoXyNCffcXqq0u9F9G31voZRfvmH7U+0TTAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601514; c=relaxed/simple;
	bh=13OFkK4DG9rlwr0Q6UrPqb9K5Q7tJkO1UyK3M9GC5A8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=imqmPCTUvLhMAXbtnVKDskkK8yKkic+dbmMAtjRcrC/KtHCzKOe92qaXdWfo2E88RNWdNHDOJBriercTKZ3Go1SyA79YyoZFsNPenDYJz/BT1/0rAUUMgr/1Mtori6CDvQQFlayUvVJILzRv4ollS1W1O577tqu3So9H1dqZtxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BXQPDPNZ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2234e4b079cso1362625ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1740601511; x=1741206311; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9sbKkO5vslqQzNclWEzfBDF/g1FIfkcy+q0e0Bhe+Aw=;
        b=BXQPDPNZbX13CwkrIyYIjEg+U58EB6MUFXSyyF9WOWONVJYXG5FuaygjySUX46g8Go
         h+WXZwMOubdtLoc4mE9A1a23bHPjBGqn8iY2KWCKOqYrV1OT+DonxYw7cnubFWMnZu9O
         yJsqqt8hvmdp3kPThziblnH87SBYXi95v1isx+/xb3jFLQayUgsz5mbPR0/3oA+qorhq
         1gZHnB2NwnsmONtzMFa/z75gUekNWiMHWw1sk0KqMmMR2KF4JKxwfVoQ1GvN9UlwvUzb
         M7sNYLyLogYSBQHqTsHN6mzXpkfRsHkUpbpRTHruXuima+Clf2WDylAT5NtweNcOOk+Y
         1t3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740601511; x=1741206311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sbKkO5vslqQzNclWEzfBDF/g1FIfkcy+q0e0Bhe+Aw=;
        b=eYlCAUXm+8g1ayg3oyDT9XBksDyeZKwOiVFz2sN/NzHtJtLi6CsJfOiAF7+T8U9d80
         mTShHghQHmklCiwrlpnvqm2IZMJdNUjWmfRRiNC5eSmoCUOgoyiSb80Qsh+9fp1Hyamk
         40+hgDqIiV5t8IO8klnTO4dn2VxtsnKIuWKKCl4mq1FSdsqxXqKRDfctTDwsm5Y0Luez
         irRax0tHooGiiIuPEc8qQDNcHpLe99JefY/Yhjc3PkYq/MVxPXlrIFUEoKu381r6eiYu
         houPiTZiuriJA6qWZcBQIijRAT/PxsN7fbWqy5dPlelKc36EAbuy2P+86G6WYwqnVO69
         gp8w==
X-Gm-Message-State: AOJu0YyLzpxLYtXzjgFVH/+r9MPiB+H6Ir2bsn5dB0lvLgRQUHGDDwXr
	R/6UWqIbVLQ/MUy+SHQ6AwyV6X9VOUMO8eV0Oeogvp0T3VJVlCL1owGsHRsCGsgXuuxbbC2uDgw
	v
X-Gm-Gg: ASbGncsp4u4mOpQn0ycnzuVgUAMS+9fsekj++Mbon4FnHN6DxG654HPOP9hQLzX4I/T
	ZAUG9wvtvFRV7GRRIdrlytVcH7zOpBxUXsVML7K49uRVW+IPBDOCKJlw3H8gw7vlcCFVLXQ6vlH
	LXEAmWRejSA0smPGGZW0gRek0x7M/25w62xsicqkjns21wOq7xWfQprG5D0zVR+Sxlkcw3Nj+3j
	PXu7xhQ5VxY539pMYejP1DRk0mydPEzoIIoPoSqBRZnod0sSg6Wc0TzF6CMrPe/FlfoZhgrLI8G
	ofKWPacomf85wEXBtaqKPR8Ct/n+58nLOZlCfpg=
X-Google-Smtp-Source: AGHT+IEWIj7IHjMpuZgHnt8pmhZWNooJK4EQmrGTIUbek2AswW1q0QzF8a3PR6HcOQhdoiMYN4qKxA==
X-Received: by 2002:a05:6a00:1ad4:b0:730:888a:252a with SMTP id d2e1a72fcca58-7347918d99bmr11980276b3a.15.1740601511484;
        Wed, 26 Feb 2025 12:25:11 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a7f7de2sm4100963b3a.106.2025.02.26.12.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:25:11 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 26 Feb 2025 12:25:03 -0800
Subject: [PATCH 1/4] RISC-V: KVM: Disable the kernel perf counter during
 configure
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-kvm_pmu_improve-v1-1-74c058c2bf6d@rivosinc.com>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
In-Reply-To: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

The perf event should be marked disabled during the creation as
it is not ready to be scheduled until there is SBI PMU start call
or config matching is called with auto start. Otherwise, event add/start
gets called during perf_event_create_kernel_counter function.
It will be enabled and scheduled to run via perf_event_enable during
either the above mentioned scenario.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 2707a51b082c..78ac3216a54d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -666,6 +666,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		.type = etype,
 		.size = sizeof(struct perf_event_attr),
 		.pinned = true,
+		.disabled = true,
 		/*
 		 * It should never reach here if the platform doesn't support the sscofpmf
 		 * extension as mode filtering won't work without it.

-- 
2.43.0


