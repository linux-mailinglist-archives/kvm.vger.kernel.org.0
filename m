Return-Path: <kvm+bounces-49850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18175ADEA5C
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7761401A3A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A0D2E06E0;
	Wed, 18 Jun 2025 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bBytFe2Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732692DE1E6
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246558; cv=none; b=P/xxpX0/kEhVY896kFw2/jvYtUEsN6bEWOPvc/SWFnAQD++7lnfDCizzMWiWkv1mlf6C+ktpbNUiebknkE9+0HaTWZnv749g8G/AeTeVvJTtu0GJTOv4dmEM8QO08TuW9772mlWNkBMFC7yIjivvsUknw/K93JmUJ3iJ5P90Ero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246558; c=relaxed/simple;
	bh=S4GPuCe590xZl2EuRNnIMDQ2EGVo96MnzdBawsw3VME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKdh4NtRz0Bw9YEgEjMe33JRqZVcI2eu9oWCfqYXcmMehwB0itcKWNFgwtyxQuAijJ0PBl98yqTcIdRWpR8wTaCS2oGwyW6Y9u+lgrZteBdGhJ8u5WXdp5VtNTHenKGteM1kCLUFECeeKrUjfP7IvD9sJKRxw/+tPyGV+UN7V1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bBytFe2Q; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-234b440afa7so68005785ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246555; x=1750851355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKQfZHKenjLPRqEIi0Ln2Cx1EmVsnnUE8sKaMZB78eg=;
        b=bBytFe2QjfFEFI4RZpfNa1cQd2QllB2l8bXWjggpC7IFo69TPBg+RGNwzRHQ2bG8r+
         2DJPj21rpI0D74uaHqWG1oNTsg33x5XV0WutyNnLmm6Q33eiiQQohAi2iM8FlTHAoJS4
         REW3sn4Bx7jb+37sZlGZJ605wxAYzbPOvwJKrMAHkAzURlZYxsR0poB86d/wScPgBy+u
         ILqJo70Mhohjiw0wJVNcUHH84k0Rn8vRSpGRKjiC28d8Pd/3E4Jo6CGI6qTH8I6hgDc9
         gchsyh6GizHIEYuiEfUZP/tWZCE/tuR74A41aRAhiRevoVVMas5FuQtpdgFRNzb9ABPq
         nXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246555; x=1750851355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKQfZHKenjLPRqEIi0Ln2Cx1EmVsnnUE8sKaMZB78eg=;
        b=IYbP1vOoKDC/8dRRcpQfylDNkKreRpZ9l0CWQNeFwgVHMN3gPFl4T9P3c1mLxHp0jx
         JjBtA1QgvigFdyhoYCNXLjuEQA/8ZZpirjbSrFgeayh8RVt12IUIW1197iucjXFLa3qk
         m7lUIXVWgAcMQJP+EfzO3rYRPhP5nc00ixFwkxLAfo2FlWsNEnJJ40yFMr1XfO4WdQzQ
         ofESPYytBwFKITxSTZuHhqorh6VtCJHo1ethnK1HTDqWro+IQG3MzQLdIF+duprFMV1i
         4nxYahmQBzIbsf0eTV7Q15cRZCQfcpHlUhiNbW1c96rN+8fZS3qMAZp94uFJH6oP3nLI
         2WvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXsoazvv0UhQVplM8p0pLRFOvCs3LR1CxVEJxVOwjKzeIYQ6kb28OBxvBqr9x/91+QOZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLMzOG8iLaExfD/rHX0cF90BNo9WQfxdBGfS1OUaSHie6mtlG4
	IJOz8bf4hG5RVTAUFItQpwkr9iUzqFgpNcfsYlF9okEhyYOhU+BoDlJbMoGQkBZpcGQ=
X-Gm-Gg: ASbGnct+BgOoCNiBj5ywwgNHYdPjA1Fw6wwfr68E5xOOC67UHsqjp9atI5fFob3PorS
	ZwEljH2pG4SgbnXGkvxr2dEhLdIywXgSp0WX6dwpX/BSqKMzDRMDL9ucfHrQNJhm/XoC0FJ9TGV
	E6zWEdr57+3dY+CxmwUPAPxR6Bf5hVXhZFXdjIMk2+R03wGuZNHqyam6Mbh6F40E2AB4xOG9rMV
	HyhjwXRpp3q1MxBh8p1kOe8Puqucu4fFodg2YC7Jzg7dABU89uL8pTOlG+vZnIKM4WA61RHtQ/Y
	9Gn0dc1o7sj5X3i3g8gGyPVm5ao488Qga7IPIV6tXAu3KGUBAbTEihGgaik1bRZ6YGy4d6oyFxU
	ABbhlJEvWpVB07IXwOw==
X-Google-Smtp-Source: AGHT+IGDxSM7ATGEf8luR6FsHBoP9Rz03O76JFYYcytYYgv6CqHzBB2u3MegIdGDixYFe2vIN2X5yg==
X-Received: by 2002:a17:902:dad1:b0:235:e9fe:83c0 with SMTP id d9443c01a7336-2366b3de5damr236240735ad.27.1750246554649;
        Wed, 18 Jun 2025 04:35:54 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:35:53 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>
Subject: [PATCH v3 02/12] RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
Date: Wed, 18 Jun 2025 17:05:22 +0530
Message-ID: <20250618113532.471448-3-apatel@ventanamicro.com>
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

The kvm_riscv_vcpu_aia_init() does not return any failure so drop
the return value which is always zero.

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h | 2 +-
 arch/riscv/kvm/aia_device.c      | 6 ++----
 arch/riscv/kvm/vcpu.c            | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 3b643b9efc07..0a0f12496f00 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -147,7 +147,7 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 
 int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
-int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 806c41931cde..b195a93add1c 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -509,12 +509,12 @@ void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_aia_imsic_reset(vcpu);
 }
 
-int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
+void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
 
 	if (!kvm_riscv_aia_available())
-		return 0;
+		return;
 
 	/*
 	 * We don't do any memory allocations over here because these
@@ -526,8 +526,6 @@ int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
 	/* Initialize default values in AIA vcpu context */
 	vaia->imsic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
 	vaia->hart_index = vcpu->vcpu_idx;
-
-	return 0;
 }
 
 void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b467dc1f4c7f..f9fb3dbbe0c3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -159,9 +159,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_pmu_init(vcpu);
 
 	/* Setup VCPU AIA */
-	rc = kvm_riscv_vcpu_aia_init(vcpu);
-	if (rc)
-		return rc;
+	kvm_riscv_vcpu_aia_init(vcpu);
 
 	/*
 	 * Setup SBI extensions
-- 
2.43.0


