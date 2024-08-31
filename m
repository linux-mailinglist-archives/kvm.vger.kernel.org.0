Return-Path: <kvm+bounces-25626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11314967144
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C34D628159F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896BB17DFEE;
	Sat, 31 Aug 2024 11:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GSEiFf15"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757A017DFE4
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103705; cv=none; b=QUWxy+iaXek94AKu8KfvM94Gz9wPgEgrGy5PolYUXfRV7ybLupj9LGKvUD4+5qVjqUdVvv+WjEe4t6hBp/Ic7klkm6VTPl1ecaVFN6dhb+/DbPN12l04UPJofwi52R+35HdJvvBBeU/ATjU+XWxs20m0XlVezIZ44bARsxErvyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103705; c=relaxed/simple;
	bh=+bJpXEISItHxh9KYf0g3+4m6Lw2Yo1O/Sx4mIWVm6s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9cchnVokvdDeLXJVatI1bqRsIlQ/fboiN8Gr0oU6rsBv2pbbTo2mZGF5cqkjbaSeeHPeQ+4V0/4nbguW+RlAuGwcEpUhz25Y07MZp+nz/10u57uFtveGqfxrqh8qZ2FM6L5eR4wB8I5j/MuEzWH36K55TML3YWGJX76FqyZASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GSEiFf15; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20551eeba95so1600845ad.2
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103704; x=1725708504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tuRFySUd5303Km4p+Lb412XdEn4ed1XKXd6/Xjv+mkE=;
        b=GSEiFf153G8evRdr5iGWGDfnDHe0DyJDUZ8P/RixzG0s/F80eL4vOTAv9CkX8Z45/4
         zjw1RRPraZzb8H//AG9jjNEfv/Z0rJhtjyEkLDVYFrnnFPGjJCMNkgV+tCf5Pij9xCto
         4Jz7ftsN8Tr6KGKasyL8tsLN6/jY2OUNh6luXZWemcawugjLwReRso5RrZwWCtPrJWMW
         U6dIfwt2Wp4tMCb/+yAGI3HD1FmEKQ4Cx1JnueBsmX+MUEoAfkW5pRdkdbsNcuYGpqay
         FtQE9zsutmlOEbC6Xxu5QLBR4VaVfnTi6LvohihUZ+mNf+xN5VHHoVuJ1c1fplTKi+aI
         OcwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103704; x=1725708504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tuRFySUd5303Km4p+Lb412XdEn4ed1XKXd6/Xjv+mkE=;
        b=unlJyH4jyNFZymNeIjGUaYQ2GGY9R4zVu3qtu2rRUZgapQPwxIBQ3awMrBQK439xRu
         +NAscaqN/M7Ih8aO4EovlKFwyDrNaP0TsWWRG1Qji3nobiqh2xjPq7KH0WDIE9+EY6C+
         apOoEA5dSHRmH0Wt6NPNZFqaYnlaVQrOgDs2G1WF/+DEEBRZ7PbXyjeSo50dyZftjPsd
         2TxO82s7PezUswRcgJkSZweJMiGcBsw9W5SqbMmIm8H8oEqxrknufQKMvi0XzUVaJKWV
         a8LF4AA42sbk1bQxO5y2ItOj3SR4rIjPsjTBm1ZNzcfiNNsXOjhlVte9eJnbf9Kvcaxb
         imdg==
X-Forwarded-Encrypted: i=1; AJvYcCVhS/kJG7sh1gwnSlVgLKVcGd+Ow2PUNUR5como/8ipOfY0LGeLFvTKLNImNp7bBK1NO5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz2bjFxnaSVy0H0KfJsaHA162HePJR/mEHhAMo6h7UMP4jbwID
	jxkHxG0MQSdOao4cQg4kys3wKZ5cZGBvQq+Hifqzuys57LqN3xgRWdYexbq0VdU8gXS2wWl5COw
	PmJ0=
X-Google-Smtp-Source: AGHT+IEaSOkI/cI6vZxDuGm0bHQEb2cbDyK5243XEeb3lPa/1FsXdIRjrM+XMXSYUJC/OBQjDjGeng==
X-Received: by 2002:a17:903:3643:b0:202:47a4:7a1e with SMTP id d9443c01a7336-2054bcbbaafmr9803955ad.16.1725103703655;
        Sat, 31 Aug 2024 04:28:23 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:23 -0700 (PDT)
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
Subject: [kvmtool PATCH 6/8] riscv: Add Zcf extension support
Date: Sat, 31 Aug 2024 16:57:41 +0530
Message-ID: <20240831112743.379709-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240831112743.379709-1-apatel@ventanamicro.com>
References: <20240831112743.379709-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zcf extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 5587343..7d8a39d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -35,6 +35,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zca", KVM_RISCV_ISA_EXT_ZCA},
 	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
 	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
+	{"zcf", KVM_RISCV_ISA_EXT_ZCF},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 155faa6..09ab59d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -82,6 +82,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zcd",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCD],	\
 		    "Disable Zcd Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcf",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCF],	\
+		    "Disable Zcf Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


