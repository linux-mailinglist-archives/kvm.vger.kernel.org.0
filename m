Return-Path: <kvm+bounces-49849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA78ADEA4F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA115189E2AA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DCA2DF3FF;
	Wed, 18 Jun 2025 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hrFvLU7n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517912DBF6D
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246551; cv=none; b=iFSP4kKJCtgHJwojmrhA8cQgtT9BSFOD8UrewvrBFz5xC1tcwRSSGYr2wDT/3XExdPC+7zBFK535YIWBaUyBuwB9c09lv2wTIv0F9HsjU00wPSC6KBkI3+AGe1v1Egz3eo2iQRuai7ndgnorHg8fgZ2aQ7KtF7itmlczZC26TXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246551; c=relaxed/simple;
	bh=staaIYNl2k7avfOSLFZ5XPO76ZWP6t7i2gV9awbxnvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFyloEodop74f7P/4MQ/QkRIO8tDXl1NrSb5GxYaHjDCdPMO/UYDKQGzIhwfWTe2+lnC1Rt/c1tyVfU3Lle3KFpZ/GmD59iud3j6v/RIbTfum/85rrlxtT2qpRKmLMvzAx8fbuaQwATfOgt8DgjX7iIAxRO5YIJJ98y4qWoExSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=hrFvLU7n; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-234d366e5f2so90102915ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246549; x=1750851349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymMx2/Jj5SWc9oh0oJCNF6LPBe8+NWhSuF7K3lIaf9M=;
        b=hrFvLU7ndT1wxlxnaoRF8EgTDSCoqLC6uIxMToww4QSnUjUzfqRrQ5N+5elvfN8I4x
         NEwwPvbQzKMYGtbpGgD5ufXTZsTR6Zq7Ill/TBFF+DD4J/e6dJmlnLaK2apEgEIGDI1q
         A4l/xrLRTH06dc2YYI/ECzDRKgIG9g1gXr6m0L5maMeMIvDA+hkGuDDA1YIRgfagBUy8
         4S69HYW6G9JF4Ptv+nek0yfO4ZWaRepeR9gs+k5cEJVU2M4cARhZRjZEFLAPILvX2vPh
         oTkeunWzbrlVbKONa86TaqqLIKeeF/i2W0qvHWOHeEdmkKnQzf8vJRXevU9z9l/137tq
         JF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246549; x=1750851349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymMx2/Jj5SWc9oh0oJCNF6LPBe8+NWhSuF7K3lIaf9M=;
        b=f1nx332uUs7Ub4KnSD0F107/lv5q9Z0sYATcQrARLnzrsoMcoITNKoIwVAMPUK3ZiT
         peuv1nzHtcjeWlDYwxQubi2yl08zOl/QhbVwVviuou2/Yxu4z5wFt0YbTnRo1wd7SH80
         hQlJPsRG80yyo5wY3OhmbiqHqY9Xf210T0bJZGX0amv6lUJAnfBjW7o0ESyCIXxlPqC6
         5oWkO6vJxktGgfs+VXMi4aH21d+DzBcM6wEW/1zlRQZRUvbXLdw9PKzCYAuFBCnS5Wpu
         hMDL4qs2BAqkWUJPGbOhK5nvUj+ugh0TI67oyRkJpPECkgy3QZxbv9O13I8QhGW2KKrj
         XGtA==
X-Forwarded-Encrypted: i=1; AJvYcCW8aDsizwL5mps5ko0d+nR/fQRSMo0zH6Bc6pkD/G4K9gHPXuwjKmZ351cwOg4+RIweVIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFZhZ4FC0olVDHZw/IspsfI/YbXBLcGzO6OHVLKrl9wAIPpyoK
	VjUplxZVvzyqS3Kb4adrrV1Pd6KgCNwozaM5T1WvxS8MB6hPqkcrEZOroSLV1h75qjQ=
X-Gm-Gg: ASbGncuDWp5n8fRNE7qFoWmNfcpNJlGlg/JCcjXEuX8Xa/ahpCxMh5oSt/m3gMTvInG
	8oMFMlXRgWhiCk5W/BHpgF97iRt/1GjIsdyTWGvwmURIa+6d2bjP6KPkcd5Sne7cc9qWg+a7hOE
	CYebvu0zPMG96M7EI9BoutpPxxZ18MWC6WK7F7D5CwPlzl3oO7f5W19lAdaMFRk1mkD54rsGkgX
	5WDD+1I1kjYyuG1cj8Lt/mJpms/aTteNAqubpeo2Qqm7pxRVUQ4nbhK5o/ce6o5uHq14rg7SevM
	Dr2yCiV2IpiYoyj0J7S4hWcSSAozONmquMqfpIiD5nyFs7kdVPaBA+WtYY9FlI9wAySa/wOrjUu
	uKo+3ijnT6CbTJEdLtg==
X-Google-Smtp-Source: AGHT+IHpQurN4dARXEVEkELnBd1/eFKHOQXO7K5ZeHZVbZ7n3gcsWaLN1FmavIalixJDtUnrPtlsSQ==
X-Received: by 2002:a17:903:b8f:b0:234:a44c:ff8c with SMTP id d9443c01a7336-2366b329f71mr223770515ad.18.1750246549511;
        Wed, 18 Jun 2025 04:35:49 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:35:49 -0700 (PDT)
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
Subject: [PATCH v3 01/12] RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
Date: Wed, 18 Jun 2025 17:05:21 +0530
Message-ID: <20250618113532.471448-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
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
 arch/riscv/kvm/vcpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 303aa0a8a5a1..b467dc1f4c7f 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -148,8 +148,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	spin_lock_init(&vcpu->arch.reset_state.lock);
 
-	if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
-		return -ENOMEM;
+	rc = kvm_riscv_vcpu_alloc_vector_context(vcpu);
+	if (rc)
+		return rc;
 
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
-- 
2.43.0


