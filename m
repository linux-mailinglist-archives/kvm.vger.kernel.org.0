Return-Path: <kvm+bounces-35594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D107A12AF3
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:33:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CF1C1889BE5
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D938B1DBB2E;
	Wed, 15 Jan 2025 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="jGKDLbGz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBA21D9A6D
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965868; cv=none; b=msoLAHM71jjbHOR0bLZ8gfl0Mg1j74u27Lc+/vevHeCJZ4CoCjmGMxeH6+GwoXMb6wxh8uGAVhV3UfWBn/ro3ZmcAKrDOguGMEA2+THfphMtzHQsz3urTEnoJHTf55NxrLlfzCt9yOPDVcqRDruVjy4JeJl7RW3H6nRSjnSVHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965868; c=relaxed/simple;
	bh=I61ANzW3mMGNw+TsEklnF5HMFHS9Ft60jqTehlaG7hM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Iimlr04l7lyqhrTv2S2awmDnjFW0YLpcM6bomB/0MuOO/WNxqgjY4YhVpmLxN9HLmALH31M2C4PN08EfH0gv1+K9Fs6I/ahNEs72toAo+0l8OccAMY79fqRpRzIceuY3/CjrOIcbMjA9AP+rhjsZqPRtbMYFl3McH+eFXKzX5rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=jGKDLbGz; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21619108a6bso126527795ad.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965866; x=1737570666; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oS1moOcp9ct9rXCWQSjf/GhpQtGR0rWY3wjXVfG0zao=;
        b=jGKDLbGzpt+hAXvSI7EJJsBDiNY+gcB6fdufauX8OC66i9m2xfN/6fD4f35YpNon2W
         1nPfAClCYuczg6HPMJMiNbai2enhvYVmDTwbDBc4/v+Lx6B+xKJzq6GlTkvtCPyAqGmY
         d3OpwsSQNo6gx671qQ9yropgpwksWpRUHk0zuWlFcy+VEK0fF10yb6BqWd0hxnnD4cCf
         Kj/6CrvhoIEPl4OhjifC4o8k9SK8kIbCM61J7TV9iNIk+dN8LlT1POsiEwMxbuZ5arXv
         0cBf731ZnRvJOX3u+VpG1o3KsMuUuFHWToQWVJ19m6j42gwwk3YNBnNXaSEkYdeafJ1J
         MGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965866; x=1737570666;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oS1moOcp9ct9rXCWQSjf/GhpQtGR0rWY3wjXVfG0zao=;
        b=rz/TWprUcvJn3BFkja/E0uXhrjhkbh91i0aTPwvL/+KFpA373TQ95rlFj7hXi5wR7O
         N1g3HvXbg8959Dyh4q5/K3/eObOGLkMB9ruNjxI4HrI3xj548B7GgSRjYQGqaCtgH+ZE
         Nk+eqEf5Rxv1P8Tpy1UmclOE8yFJckoU9gcbxJTHsZ+hrZK38ZMqgi4uhEcY+Wtviwfx
         OYoX9pb/1a2EykHwze24+hBX61EvBRvyH8aj0E0/FeCmUGNz52UNgI9LfJvm+mMRf7/2
         7RlpHSM7ODtp3CKrQMsUGQB9gPr44bYOTpst4Jz58JwJ0XvEPxLaGQJWVId6gDQS7MV7
         tV/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUffm1zWzhGy6Abdhy+81OblBA4zScTUNvq3tJKD5cKjvl2DuuHpTEAuBStqlHexH4dWos=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq2wbCwmbX3O43auaZtX39aoxbUpzZY61PL7A7ZQaSW9lCL+NK
	zku6LNSNn1en+ika5xG7yIxxbdmGwU12CsMqr32hjp9rOoRmV/1aNY9kfYz5YgI=
X-Gm-Gg: ASbGncsxV+t35SJERDrfLYEqHVYHi9q7RHUUUUwrwEDEZSfFAN6BN+DBTX60ZzRBiTy
	v+VfhnJ78EDVvAXVQd2Z2mWw5fGBtv8qAS/qhYdH+RqwcJQteV1IJYmrYTa7qdwyPGi6wmjq0AB
	IvsJOAI65R1FQocpZTaXH5MCwnQgUsdPKs0G8z8wFajUeY/GEMi955emKJGJhywxs2ALvS4tTfE
	LLKgAzgx0jjgRRPsQ6txWOUO1oeZ2X1VpGoyljtpxy3tmKaNw2dJLneNrbToB7eF0w2Aw==
X-Google-Smtp-Source: AGHT+IGUgwpGj/plYJTZ8pJ5gD95k5t13F6GWcCCeHibqJhYXgtv9S5eRA0RKAcOGIqFSWIv1IyJjA==
X-Received: by 2002:a17:902:fc8f:b0:215:787a:f91a with SMTP id d9443c01a7336-21a83fd1e96mr525986085ad.44.1736965865659;
        Wed, 15 Jan 2025 10:31:05 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:31:05 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:49 -0800
Subject: [PATCH v2 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-9-84815b70383b@rivosinc.com>
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

Upgrade the SBI version to v3.0 so that corresponding features
can be enabled in the guest.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index b96705258cf9..239457b864d7 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -11,7 +11,7 @@
 
 #define KVM_SBI_IMPID 3
 
-#define KVM_SBI_VERSION_MAJOR 2
+#define KVM_SBI_VERSION_MAJOR 3
 #define KVM_SBI_VERSION_MINOR 0
 
 enum kvm_riscv_sbi_ext_status {

-- 
2.34.1


