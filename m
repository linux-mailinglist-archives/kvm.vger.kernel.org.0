Return-Path: <kvm+bounces-8668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE99D854927
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A6A829013D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0C533CCA;
	Wed, 14 Feb 2024 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lJGFvVGB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58111BDD6
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913341; cv=none; b=AvO7rY5EhPWacsnEjV/GNo0Pwz0jdPG6SVzIJTUaY3LI6sMJkATx8mQZGg/rNfwLwFZwXPtYtlYgazlCbP+ksb9iyaDWSX8s0YBEiljcT2aBuBqfaewSznV7z//GlOUV9tEdX8c1Z+0K0lXiu6Lp+9ZBnFLs9Pi43FfeJxKx0NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913341; c=relaxed/simple;
	bh=HvRyYGFpjro27IO9DodrXZqLWvpLPTxHX9oPCUZIVXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5JzAVvt7CKpfuuzvaTDvfeONRtJprTLB3+X+cimpeColIdyqOOC4YNgd2RH5WW9LRkKmoe6Bbu5GTpxXyHj3/2kpaoIPSyXHLU+DRYaAroNGyOOOQ8QNRgyCVxKoDzuQKdSO0M13NLTbEO/e8t1PG8nnuNkmh2jlNQFbNsd5r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lJGFvVGB; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e10614c276so762295b3a.3
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913339; x=1708518139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwZk29D7fDiwtPISRLXLV92+Pgyhvl1ktMadRkygXHo=;
        b=lJGFvVGB5JSgYddYTUGKiIz8fXpBYZTaMFgl3Rkxyx2cPHMgW3MaJ/rFx4reeA4SUV
         b7hbCcWiidTn9ueiwhLn90Yj/JyzSbL3LFXpRfPGSAquPbbtwo6fpH7KI/7x1haEs0Vs
         OLuxfkS1PS/VhovpzfWM3+bSXstzSlHO9vUds/tPHszmlkMdxBdmNUhZ6JOFak7QKv8O
         jjI374nWGVMOA+Q9wynRahz/rR2Tb86L/GUHLiH/mOF/O5vWAX5V2HjRSzEMGnJS4erl
         ozOLBrRCY2IFir4t3tjgkL1XIwhfu5pk8Xo5NVhA34SM+J6Ber101uVOaQh6I/IT0bUt
         qRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913339; x=1708518139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwZk29D7fDiwtPISRLXLV92+Pgyhvl1ktMadRkygXHo=;
        b=MMx1i0M6t1yreRfh++k3gzB3LpykiuneZgYP6O1aQDSspD+stV6AG6ziEOFRRbWDhe
         YAKkGEZtfPiEmQTcNUyfN+ophIbca8hLujH+St2l8OJ9V9hHbHiHG13iMdyYmYRYXJNt
         zhjEx70HO73PcAvLKI0fqqbtqIF02HVBnrvJbn4EBj7OXah0ly+Z6jLPFbbQmKdjpynd
         ccUA5dG2pzvuCG4kedSk1fmkIczH61LPzqvIMzSlQgUi29CpjoPCNMbeJIMVOsegyKQD
         HJJfPzsKImHxkAu333ROZpLnAe0i7EWOsTXIC5wpZyMad8ZjHhA/tqA5qx3R41SLZHXt
         BzOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUkVDCVfbve+63ZPg6xekVqNr61y5e2hkhSSlneJNRIPU3rsp0BD2j2tNPEcFJd6BxacJ0/6Czk1Ws7QR780E1aFJ3
X-Gm-Message-State: AOJu0YzFOSU1BuBuGuF4PGSW8YbAsQ+Z+3KcBGIBd4AwZUCuep7h2PB6
	OKJgz4ug3RqCWB0zgC51iZH5ISNeM1uDcox9Vow/E7BBMc4pBRwVwNtYjzErby0=
X-Google-Smtp-Source: AGHT+IFXEup+ygQBhG8RG/CmNF54QhSb5MczyRDZQDIjov2Ofqd95iexN1vN5scmhnOu40Q8F6PxOg==
X-Received: by 2002:a05:6a20:be99:b0:19f:f059:c190 with SMTP id gf25-20020a056a20be9900b0019ff059c190mr1984396pzb.24.1707913338915;
        Wed, 14 Feb 2024 04:22:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVHkP2GyUogWJDisi/6ilstay2olYoo2aUNfzDPWxxnUPv0/R1CS1bmgE4opDx0Q6D7gRaZ36suH+3Nu8AZhokZmO9gZ+N+hwrfRT7PvfE7N0BZF/pJ1sgQC05LqVKHMQGeeqgpLsMA+23ZlS08wR+5aiRYazYTQ0wkd1wqWv1KZUcJe22B8eVGcY3RbXqcoHFTIS4rn97yXRfkGcT9dkYLLekQ/aOKLKt2tlPA/LNywjaEnQPm0dNi6MmsllU5UK0a+83fnd02pc8ZBeKRRt0KM3KUgEyQRi4L7Zlw3qt94UEzK8T6eNjA0Go6y9aG4A==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:18 -0800 (PST)
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
Subject: [kvmtool PATCH 08/10] riscv: Add Zvfh[min] extensions support
Date: Wed, 14 Feb 2024 17:51:39 +0530
Message-Id: <20240214122141.305126-9-apatel@ventanamicro.com>
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

When the Zvfh[min] extensions are available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 80e045d..005301e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -49,6 +49,8 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
 	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
 	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
+	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH},
+	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN},
 	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
 	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
 	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 2935c01..10ca3b8 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -124,6 +124,12 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zvbc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBC],	\
 		    "Disable Zvbc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvfh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVFH],	\
+		    "Disable Zvfh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvfhmin",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVFHMIN],	\
+		    "Disable Zvfhmin Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zvkb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKB],	\
 		    "Disable Zvkb Extension"),				\
-- 
2.34.1


