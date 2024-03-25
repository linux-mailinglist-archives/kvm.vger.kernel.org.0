Return-Path: <kvm+bounces-12598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C1C288AA90
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD87E1F2984D
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CDA6F514;
	Mon, 25 Mar 2024 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="AS57uGVl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D164DA11
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380734; cv=none; b=ZhbtyzdbAUDH7RglDQ36agWJzsAnVzgVmJHGGOn7ksl4fQSJ9hRH0xh7zuEkXrlr0RCus4mkwagQvT+GB+QmbpE7iUz5x7PeM5LhRa3v44coxvghnUMyUqrVETPgefNEA10HvpLWxa+hhbDdHMfoHOXQ3Sw6TK17IkxzXdHFv7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380734; c=relaxed/simple;
	bh=G9ZBiWINEVrRqOgA1UbsuWhoUIZXZTJ716OEPxAhhPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EnkZhSSZdgL7uybqCty1TJ9fRjGEtXQ23jFA0vU7yi9cUHpM4+4bek5ayU34VYmtxHRR8rV/btZruPLTZMYI/YP4SrmFlD/zAY65kDfcnu5RzTQqvjKEbNeerecm9mMCKDanlHqvSTNwEykZ7ThJ0yZ9/IZowidmB1+PQg0qnAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=AS57uGVl; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ea9a60f7f5so1501617b3a.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380732; x=1711985532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KR4qc/aD91W6fk1Y+xlYy6RF781gGiM4VPBpe+upgXQ=;
        b=AS57uGVlW0urrd2Oy6yVAe/Fnzq5mA5D7i299Re2kP2Ou4fTBfLFKl/ycQxLOe+x+R
         qpnKqglCPxAFV5GqoK4nh5X9Un/KE06lsPyTR8ZZjy0D/TZw1lMW5Q/JD8ibQiqCv3/o
         sg3R1AzcdCSBTGJWBZiyHB91Hv0pVb/M1Kt/Czg/rpI6Ob98UeH8PR4ih/BSCAFuw376
         5x3n38E0aB8mNMzpTCPKA+9UR4aGRDbY/0XbjDnXHUc0yuPQirMGfD+Zu4ib1sSmH8fM
         D5FfMQQkKnh2qyhqLXbdna0GLqbeDd3mD9rhUF8L9OKCPl/MZ2r+bIcdmkkCV/HcNRiY
         oIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380732; x=1711985532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KR4qc/aD91W6fk1Y+xlYy6RF781gGiM4VPBpe+upgXQ=;
        b=luPKdk6qcMfETwXSAWZ0e4rbF5bXCot3Jj1t3q1GSMOKfCl8Y3pbd5gkFORfrtLQJa
         1JaNQEb3BPxC5SQNQTXnXePGArY9yednN/CCc22yd2unkv9mRiCqLpdfieyPY8rFp4Sc
         5eWjrmLFHv55mIUBwMdJUJljxx78zoQ1wP4ZNjQtSBRAXsrhMoOd7IZLxHf+e4gYt6gs
         kR94C8Nqp5AdoZ2pANUIe/GJVZJMqQ6hXtidh7EpPkJ7mnOKbeAtBp9OPkrncZhHnWhH
         vaZo8Cs0iz1r/lc5WOp+6dDIL6LZiiNbufu6el3wKzy3UdRRfzNiRvBjvUMyVLbGyBFr
         aA5A==
X-Forwarded-Encrypted: i=1; AJvYcCXqEYgQ8PZQCLU4ghjhF0gQ3EcpCIRTPkjc2K4HAf6Xsl7o2vXlOiqmowAbKSq3xKdSVLv4hntPuK3UnWLz25Lacr+L
X-Gm-Message-State: AOJu0YyjaJjFuhPLPqKQN3YQ1/XeiaCB5fVGLp07dyeXg5rmVa+pFU7n
	XEDdl2HYpAvmFurv0T8NVGb/Zptd3bzLyTQEc2GM1GOqB6NE72aoenCwVgz+TcE=
X-Google-Smtp-Source: AGHT+IFP1hGItMy4B6xNWlor7LmXK8dO/OvBS60IrBHLuP2fJtoPNchUrxpOLKst7t8A4NrYscXhnQ==
X-Received: by 2002:a17:902:9888:b0:1de:e84b:74e1 with SMTP id s8-20020a170902988800b001dee84b74e1mr5793979plp.29.1711380732227;
        Mon, 25 Mar 2024 08:32:12 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:11 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 05/10] riscv: Add vector crypto extensions support
Date: Mon, 25 Mar 2024 21:01:36 +0530
Message-Id: <20240325153141.6816-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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


