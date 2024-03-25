Return-Path: <kvm+bounces-12602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E01688AA93
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E41831F61924
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003E476035;
	Mon, 25 Mar 2024 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WgQ1CDrb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11F874C04
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380750; cv=none; b=eJimvJID9ao7tvfNAl/NwScA++hORIJ660XZ0UzptTinrcobjsSOJrx9mGDH6S3XEOgGSvU732U4Nc4Tz82I1GSBqYsTI0h6g6yHNkj6GJOQVeLXxWWJAftlelPx630fHZow/APN96dMzjL0pF5HdGoLMqaeH/ePANqFYRw+u4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380750; c=relaxed/simple;
	bh=qForT4ksltydvu0puy+RU/ZpC2kYWAEmcusFk3Kzzpc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LL0GJIBxU5DR+ok8iXlcKrTWVE66CLm20sDhdA/3NxKuib+lCXw3+U3XOErPOavbmo1xNH/56Ww2N2CkQ5StoQFnkAyGR0UPgEoMQOoRLxLMHBwE1vF/FLVcMbJx3MvPzjxrBHNcABJn3D5ovOsNLANOIOIz/cs/FNra501ANTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WgQ1CDrb; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e0bec01232so7505775ad.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380748; x=1711985548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcmWDFYi+hIpyADRApkiB2/o3ThAebVDFFRbt0ZWsYY=;
        b=WgQ1CDrbAfqu6qMbTER1n7sJ5G/cBe2B+AZ+XOSQtj3Z+QwAMrwfkNs4nC+WCREmws
         bx4BsSFGkLml5nukwuhl0ShJurDzDWG7a0vd0lVFSFU/pfzlmg8m+bb8If22lzvd4vH3
         XsDFTXWnizBJlYJ8R4Rh/O0TKZxDS0cKMsMvs8aVn1rfbQmUcnXK4wdd7WjqNJafrJj4
         wkSGpcxrJkh7Go8eit2hLGnkGvbv/51IvtrSXuemZ+9lhA+ayVwRrZTCctqiF+67i26L
         8Fe8MR/WsBLoMlXVakPeRaozZNsFbk36cfTdekT9DzKqoIA5EwTZVdRVUpp7dUZWxIAn
         Yecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380748; x=1711985548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcmWDFYi+hIpyADRApkiB2/o3ThAebVDFFRbt0ZWsYY=;
        b=KJFkaW+Ada+REPXN5/rFACh7tf0kGdYMfBZM+EP/vG4f0izvigxP9btZHPvwFHsVAH
         J0LS+3OorHlgVeVmK5w1OeGEWkmEc/EqoDKgwRBHWZM+MtXg8ZdyJ0ftORm+D6jTqASV
         j7axCL/fQutSZNbs93fVBVycu4QSvMqFDcVPZwwK1JpHDFlWpBXrscqj+B+2qD/OKNNJ
         IiSwKmyydosbMk3nsLqJ1U4i9weKitzT2U+KpW4DEita5euObwguEuPtXjUGQcUzoH2A
         oIopLGpEn7TGsBd2m3MbIvYeiyoHEvh0nbFl7glVYGpchUVGsquA5swb/TRe4n6sJ5jm
         a6sQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXeMYniGb1mJ8+ne8R7hs5Cl/Y0oMJeHXErFEMqWh2YaR8nISQhIBnrWCOvwC/A/PnDmR7jo0sdznoBPuRnGTay33I
X-Gm-Message-State: AOJu0Yy/FCWXJ/LFMmnby1z/gQO59D+Pb8JJdX6G9fU5CSVy9GOXmOJ7
	R45Ly5ouhY9SCWbAl+h+Xk3voYyoafntTT+tIOSyEjUeanbc3chxMX1RD/iUuhs=
X-Google-Smtp-Source: AGHT+IFVdUkAk33D26gezJZrNf6ao4CtxELl8NKowvX10lhTx+jlPG1vjmw8qYy4gPp1ygye7HQRJw==
X-Received: by 2002:a17:903:1111:b0:1e0:939d:3d3a with SMTP id n17-20020a170903111100b001e0939d3d3amr7604828plh.33.1711380747847;
        Mon, 25 Mar 2024 08:32:27 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:27 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 09/10] riscv: Add Zfa extensiona support
Date: Mon, 25 Mar 2024 21:01:40 +0530
Message-Id: <20240325153141.6816-10-apatel@ventanamicro.com>
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

When the Zfa extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 005301e..cc8070d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -29,6 +29,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 10ca3b8..6415d3d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -64,6 +64,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zfa",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
+		    "Disable Zfa Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfh",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFH],	\
 		    "Disable Zfh Extension"),				\
-- 
2.34.1


