Return-Path: <kvm+bounces-48475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59729ACE9EA
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1449F3AB673
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079101F63C1;
	Thu,  5 Jun 2025 06:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Vilb6tQy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14401FF1BF
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104119; cv=none; b=krA8bYMfLCwg9tTnkkoSe+Xc060ynzgA0XKzEEBAxaPbs8aAR+2uVGxpvIaDxm38RaHLXjLC1lRloA61yCmBCjZlkuq41fNd4c8Y/b2ZHUlGO0YKXu6F7kBRSj4fKfPdgktKpK5JBgF6owOGjZGTMl45nuEykia0knE1dWzHvgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104119; c=relaxed/simple;
	bh=mRQoz8hGC8K4ob6BUuQVFp4blnARaI6s2Lx2a7QTqbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtbXVeN6ChfkKyYFKXEpk6PWO6nV0TVGDnG3e6eRMmAitOAL2T9Jq+fUTC1dYJNHEY1Kle6tbBmpJPxiMhbeTtxPAjGKYJgM80VDXevNhC4N4ZLVU5dkzLYf/kVtxVCsGNaPaLKtq5WPFdUAlF6HcviOmBIoGXnE6ZhvDMIdac8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Vilb6tQy; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3114c943367so718117a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104117; x=1749708917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pY/L4bm+P9Rr6i37e8lfQjnEvic7ox3vmCP9UKIlwY4=;
        b=Vilb6tQyxWLFKZiVdZu43u1i2/TFgpZ2bXh+gm3IWmIP+h2XH1LTsVRcr4CplrSeaG
         oqZz+camKuqd70VtAZQE30zU7qzpkR7eAi2+REFSiA6HFfy6tGyIzPflgUj3BbS4TOzz
         imYMsj6fhs8s951gsYzM8d8SYAnvdlzmDbe4IebwCrj2L8ZjLH4l1E4fDoMIGfKFCWTO
         jvAeO6w7iUvMsDdvg306hVJUX1C8Ssqz2+4UdUPVnghkuTMiP+D7N2fAVPbzukBLhLCa
         H5sb3+rklHdv8gaoSZQ13eCsZidbN8oyL9kO7qkHwdDyitsTkwS5WiYbFnXd/Am4VY++
         Tmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104117; x=1749708917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pY/L4bm+P9Rr6i37e8lfQjnEvic7ox3vmCP9UKIlwY4=;
        b=Jowdv7nsZhH8duLF92xr6OZMXTfANbfHu0PS+1rxMSSo/O/6vV3DkCJrizVtkaR3e5
         oLODqMBYe1Dnb1qNzbVI0vPgaR0ApzppaU6hWd2TcRE3yT8J9SV8rxChpJsMHdRLe3MR
         xJg8mPIDN58VaPuhK4pCtJ43rFD2RNutCGCcBCk9yi6qNuiEqUi3o+hqV7m6PtwGUSD9
         dlhapMicusdW6iMXPlkhAEviKXCXh6SNGiCOJgAjrC/rzot7yIdWnFIh2UY+ePRZhyWL
         U/7T/assNoJToqU75hXyPFTv9Y3poI7dz17URnCAHxi8LjXmzFd1ahPoZeVysoloshcI
         OKFA==
X-Forwarded-Encrypted: i=1; AJvYcCU/Orm0fZq9JuaBy4OPoTiuLWO8VoauCrkvRaeHaG4VT7VoyPzWH/pHhtGFTrKpu5v/m6U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz9+VKDCPBlrki7h8/XhxocvXV+1N9MLYbUtXnuTbk8B6iENOM
	bb/stSyftBVvQwHlnTebJcDNOpL5viWMIRNppTOBf1njIi5Zj1ejhVifDSj64a1vGds=
X-Gm-Gg: ASbGncu8jSZUJHU46jpdAPjFQFWiv6y+f6XgPqXorvupakkDZXySegKobXpCAlur5da
	lumswexXm5R+PJ/U8fpzd0W3lE9VkGRxHi2mJ2z4XazWBiuHjfveXJrjRTN080jEO6T+sPSQ0LL
	qPs7YMitj3iklV/BCd3haGvBOuFxSRSRLAMxNHfBCCpGUbFKLMqwsa5iEC7VzQiuG2eXU4gl1Be
	1nuJyUfdhTDN0lZE/WAb7zcjqOX5yqYnRz2zuuEgmD0YAxlq/jcSFcY28W0Brn32GVsJ5CGzEbg
	VjTFIsq8U3FVFuQI3/es+x7yP5/R7pIqBKiArCUAcvsjSb/x1eoQ6Dpr/6rDEWFgv9s8JpPIjhQ
	bR8Rjj7+DUhADCDzGUMHmbWxZEDc=
X-Google-Smtp-Source: AGHT+IH+eTAD19cy9DJlja/MN5YACVJ9sgwSL2k4cnnE8LZ5kPurak1nzFsWixYBq+aRFevEKulw1A==
X-Received: by 2002:a17:90b:5587:b0:311:f99e:7f4b with SMTP id 98e67ed59e1d1-3130cd6d86bmr8229933a91.28.1749104116821;
        Wed, 04 Jun 2025 23:15:16 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:16 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 03/13] RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
Date: Thu,  5 Jun 2025 11:44:48 +0530
Message-ID: <20250605061458.196003-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kvm_riscv_vcpu_alloc_vector_context() does return an error code
upon failure so don't ignore this in kvm_arch_vcpu_create().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e0a01af426ff..6a1914b21ec3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -148,8 +148,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	spin_lock_init(&vcpu->arch.reset_state.lock);
 
-	if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
-		return -ENOMEM;
+	/* Setup VCPU vector context */
+	rc = kvm_riscv_vcpu_alloc_vector_context(vcpu);
+	if (rc)
+		return rc;
 
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
-- 
2.43.0


