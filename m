Return-Path: <kvm+bounces-8665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E02854924
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B61701C22A90
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7441A2C69F;
	Wed, 14 Feb 2024 12:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SKeGNsv6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51029431
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913330; cv=none; b=WtcDPG6lgWBEVm+m8C+0Zz0VgMZNL1nz8mqa5Azh0BjHKr441Wngu2xdMlaB6+v0brJCkuDQ8SXlffWtdmjmqrFT8v51lXYAi5M9A8JpssxVF3jWtFCfI10zWCx375Dbx+DlqfpVBJA4qD0+ugryJf7KlMqOFkWMiM2kSIGHyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913330; c=relaxed/simple;
	bh=GhGdAUJaOiPDL7I3RUQVxMbYQNtDhrZQZB5dDsOTdi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B6crEB0Va0y2e925/j8nejOggGFvKaXURaVSnvvgY5mhWmnmrbtGczyUZmvLUJjMWcgEYgtzpvHRIxHPGqxpUM7E2+pTLTRu1lGMOm+6N9uo1i3PVnw8BCtBjUI/OYf/uuc5cyNuImr43Og4FGI5GXlmaE1OnWNeJ3t70OYXMnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SKeGNsv6; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e10614c276so762162b3a.3
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913328; x=1708518128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9/do4dc4JDGvXceYSvpkZtB8ISeycNbs9VMo8Y3ia8=;
        b=SKeGNsv6GUliiiyjM+EaDRasZ82fLvbD6lfjJrdKQ/dAg1r6vO5/3MPZVK5gZTvGz7
         RWn/lzSL376Kb5MngRSGxCDtN8rajI/Y5da8BVHwOw91NqpbtKG5vAdxRAnYU9HUL8As
         y5iV1lkHhwdYUKEMT3/sBoXBj99LHuEV7U9KQkLvKquzi/NKB11Nogie3d+TJa4oJFVY
         dqq32UtNWwTMv1qkaXYQn2OdgYC+evflJLCcu0It5RzUdG3XSClKrmZxPpZ84mC2Ngqr
         pX8fN8N0W11U57gnHdxivpppW+huTgUgWDLeARm/uXyF+UZ3Xaot3p7hwQnkQXscWqvL
         bugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913328; x=1708518128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9/do4dc4JDGvXceYSvpkZtB8ISeycNbs9VMo8Y3ia8=;
        b=Wi8p+NgTf24CqM6nmeWiI7T+Jbzo4973HsujxUGu8iuQFJZwR38Fqkqhz555Ua2HGl
         C4r9HBOGh1Y4D9Amjwltnjc5SkV1WFl3/+3AwJXr0xL7fe6n27dgA+nkP8+8dRg53Eqe
         rm2sYsxNO1+wcx6xdGro84robGmpRnzBv+KR5skdFvofX9kDzmqyXGcPccH6zlg44I/1
         iJLeSDG6jwodq1MEuqim7h4Z0C3XSVyRq6FZcwyozN2NJVx2H5sd51Qr+X8aA3saHAhX
         SSm+aXtFbEqNRBI7+ZsqL5qk36YxwUof1cBANxyCE7TV8/2hMBN+YsyFuHI3Lj+ci/Sm
         9CIA==
X-Forwarded-Encrypted: i=1; AJvYcCVP22cJnOnXfUtONi1gU2vYi21DjbL1WrC4/ADIUrU/C+mMwwUnqcgz2PdaTi7uVzQN3Vj7iEcyia1d/dt0vZhjfzT4
X-Gm-Message-State: AOJu0YwI95ZFyKID8RIiGmOZTvCfcKh+2Ug6OhUXVz7OxZwB4XpkHQq8
	7+SghtOLjjYRpCGyHo4rk/CzU/RzrHHCGptJ48dtnCASubQoYwfX6pTMFVGJaBg=
X-Google-Smtp-Source: AGHT+IEo9LvuSGjYo7apnUnwhO8hBIzhPN+7NgSbQFuAByJTEI70yE2tz86KtDMb9U/a3nPU7sfyGg==
X-Received: by 2002:a05:6a21:2d08:b0:1a0:70db:43dc with SMTP id tw8-20020a056a212d0800b001a070db43dcmr681995pzb.6.1707913328136;
        Wed, 14 Feb 2024 04:22:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXyRyu6/DexPKhGlQ1N8Z34F3Ov0gMHYOY2+oDruiWsrXcwyWzJgZ+9HvHkNRFzXOeWOAEIZtFS9SsdiA4R24K2fe2DJjfs7f94jtVDiJ6uX0Cai2/q85XR1KkcTaxOcJVtRji+6qmebl59ec2N01g+BWvxgxv+2JhnLlHgObcy9+6Wp7ey9dWrmBzDFq9D8h7PgYL1f5ChshmuG2fgn0+PAkvuQ8ZUzPBg32fQba+OjCU6X2+i0M5MosVACrbrWG2NQFd2qkMNr96Xe+0TzhQgzdZ6GDc9Iuk72xx0zizgP++eQxnh1DLUvHotzajZTw==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:07 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 05/10] riscv: Add vector crypto extensions support
Date: Wed, 14 Feb 2024 17:51:36 +0530
Message-Id: <20240214122141.305126-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214122141.305126-1-apatel@ventanamicro.com>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the vector extensions are available expose them to the guest
via device tree so that guest can use it. This includes extensions
Zvbb, Zvbc, Zvkb, Zvkg, Zvkned, Zvknha, Zvknhb, Zvksed, Zvksh,
and Zvkt.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 10 ++++++++++
 riscv/include/kvm/kvm-config-arch.h | 30 +++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index be87e9a..44058dc 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -44,6 +44,16 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
 	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
 	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
+	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
+	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
+	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
+	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
+	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
+	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA},
+	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB},
+	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED},
+	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH},
+	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 3764d7c..ae648ce 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -109,6 +109,36 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zkt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKT],	\
 		    "Disable Zkt Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvbb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBB],	\
+		    "Disable Zvbb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvbc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBC],	\
+		    "Disable Zvbc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvkb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKB],	\
+		    "Disable Zvkb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvkg",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKG],	\
+		    "Disable Zvkg Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvkned",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKNED],	\
+		    "Disable Zvkned Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zvknha",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKNHA],	\
+		    "Disable Zvknha Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zvknhb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKNHB],	\
+		    "Disable Zvknhb Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zvksed",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKSED],	\
+		    "Disable Zvksed Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zvksh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKSH],	\
+		    "Disable Zvksh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvkt",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKT],	\
+		    "Disable Zvkt Extension"),				\
 	OPT_BOOLEAN('\0', "disable-sbi-legacy",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],	\
 		    "Disable SBI Legacy Extensions"),			\
-- 
2.34.1


