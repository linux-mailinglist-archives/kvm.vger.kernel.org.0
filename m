Return-Path: <kvm+bounces-14187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6E08A0480
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 02:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43B95B2233F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11DA2209F;
	Thu, 11 Apr 2024 00:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="l6q4d0pp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A371D529
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712794116; cv=none; b=WVwgXseQhNvrrBpMaESzXHmV6wroyUk3usagKErx0GG8LPhKxGkaIaYa4l1bDULKYjvY5g0fXCIO0hFC9Ikz/xkU3snS2oK1hwUXxhGxao2fmJsXAq93MHqeVrvogpj8GMB3rj9xwVK+uRDsqf/suqG5iiofQUcqs1DdPHWbuRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712794116; c=relaxed/simple;
	bh=i4/+SnhxIOkVH6jnqRPVGKLSvQvEdBjQqHeh5YP3SQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MNtHG9Ll/kYsfLFD3ZkV3CTcdqwvtoWGBbGanlptmQNVZdDcbhgVxKFtgr4phLDRYrUbJfzhlcmUvk17UO/rZfOizA1Sx93bBoVR9WtsM2+FVPjFrcghtJ+upnBnTIQ7Oa53TMadXFw78NpRtGpF7QTcLDTat5qnlZYqqkPUO14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=l6q4d0pp; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso5381115a12.3
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 17:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712794114; x=1713398914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3Hu7DESDZEmcgrq2jc0sr2sorL47aa7h3H8SzaxXXM=;
        b=l6q4d0ppNxosr61PxpO+nUwCvp8BuauMe8AT/gF+ws53u+i1hRcpLbAxgLL/RR9FNM
         I2ehD7DsI9uFFtzN6CmfRs0UQs23vpNYKPCV57cGjhERXd1jCXhEJT2XFyXnERDqU9qr
         hDX27UVa/IAVTggAs3avcEOHN+5kbilri8uxj9GTd4MxtBzOYq5BfIxhtGBbRNNxF0aC
         wxUA2/IWKnkYOblTYQWHV9V0yVhMugliuiLDTPpoiAiGaf7gwPk1BOQlymixilBoEsco
         ZIa3OcH8XGoBnSDo99fhtXchf3E5jKN4U/1Tgx5MpbrQaf8hHA/losih3lakGF2Xx5UE
         TcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712794114; x=1713398914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3Hu7DESDZEmcgrq2jc0sr2sorL47aa7h3H8SzaxXXM=;
        b=nib+grnwTWrd05TzKrMN49eShfDuWv8Pqrh5qbfvsN1F/1kI5/8HFSrFOWJD4yhkyD
         NNl1Iph6i4fSHnjuepthG3QjVFXbvUvTuFvXX6qffn0Gg3k7Sf2YsSb6yRA7336o0tls
         LYp7YH7wn62vgvqoYi8jFP7xt8oD4U4vlPxv28ixlWl1da6E5/0IOtTr/R/iS3b/YRJA
         rc6vFf0gFSVtu78rfuyxLvBdFJdb3DaaDkYqvW6B8HSAlAcul6XsOmu0rW0SVpO0+skx
         L5X9y/F8f/+EHxf98UH5CL3G+lr2bHbcXgL6jxZHKhXjy3EvdX+1UXPD78xS7NqTD5gz
         cE0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMpnHU7LyAKnNt0gvw0cSKcNZ3OXvtlQYNju76UJ5F/wY5QVV3y43Y4newsYx4k3px0voBW3CpzR04KORhZkcd5Nf2
X-Gm-Message-State: AOJu0YyUcJ/VOlMIcYLLkNhf9yhweIX3nj8gCBu+bQe9V1MfBjAndsyw
	04w/ZAG073dzQZK1N9MXAW99DGgSut8BF/ea3a887ay7MVzeor3/lgvVIkBbzUY=
X-Google-Smtp-Source: AGHT+IGlZjUnG/cOH6oxCvOCuQrtoKifdSzPlvvNyoKqm+NzGiaKMBomwqkIVAChpjCW/s39Q+Uflg==
X-Received: by 2002:a17:902:8490:b0:1e0:119e:f935 with SMTP id c16-20020a170902849000b001e0119ef935mr3564608plo.15.1712794114043;
        Wed, 10 Apr 2024 17:08:34 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b001e3d8a70780sm130351pln.171.2024.04.10.17.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 17:08:33 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v6 10/24] RISC-V: KVM: Fix the initial sample period value
Date: Wed, 10 Apr 2024 17:07:38 -0700
Message-Id: <20240411000752.955910-11-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411000752.955910-1-atishp@rivosinc.com>
References: <20240411000752.955910-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The initial sample period value when counter value is not assigned
should be set to maximum value supported by the counter width.
Otherwise, it may result in spurious interrupts.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dd..cee1b9ca4ec4 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -39,7 +39,7 @@ static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pmc)
 	u64 sample_period;
 
 	if (!pmc->counter_val)
-		sample_period = counter_val_mask + 1;
+		sample_period = counter_val_mask;
 	else
 		sample_period = (-pmc->counter_val) & counter_val_mask;
 
-- 
2.34.1


