Return-Path: <kvm+bounces-17365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B4B8C4C13
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 07:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B8B281C44
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 05:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97FD1BC49;
	Tue, 14 May 2024 05:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eFlgskfn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4CF1D52D
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 05:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665855; cv=none; b=YhirvDIJ+6NvltsZg8HjB9R/MoJckquK8l2SToLbHi/LXKfIj4vMXzxB4C1gTiekOivNhNbw/DBWYdSIqgUJsP2g4n7Osrja7EXDTK+rCUvdMaiEQY1alk13jfx3R/y5mClH+AyUh9Jmqj4dycVO2ECIoXMzRK5YA6GX1G4yOz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665855; c=relaxed/simple;
	bh=CHB5kLk8StPwEtrIpc7aj6dd3ghVhgGXhd9GJIN/k/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AAD/J9OgmtQs9115d9hmetBpCd+/oaGUVypqqQ6XPg/YUTB+IE3Fh9nJZCweIdw3/iHb77w3uIwuOAd5LrKeFXy1UCpX7Yur4Vlx6s8OTgpWs1FmEaBoG79ftsUxfvmKI4KnzeCKYzwATSXMvKzwAPwTyT/5Vgs874Fr7hqSy3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=eFlgskfn; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f43ee95078so5011828b3a.1
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 22:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1715665853; x=1716270653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIPq0OwAhmVc4vzAewGAaL7fS7IEYUtLmyXTZiLlYu0=;
        b=eFlgskfnYK2t31SToObL90l1Jfe9eS6myWmZ3mGNM/WC0iQM1QhpuqEs20urATexfV
         72IeQRplD4lJIAT9PsBppcMhAFsWGHL6kZdhpB+lFzGDaJzNKOvQ8F59Vz7bFIWL5iCS
         zzXzvgrNIB6bs9YfchadAeCet6ujnCwsfqFKC3J/SgykxxcoSGlRe1lCwqEn+hDJ3CxW
         UZOtEJHWQwineQ8MG/7+UyzxwKsnTztIVyc1x6Me0KZ0u80wQSFr45+3tRM9/5YPdSlC
         BhHoWL1WPW4TUhso0GQAF7aL2BhkS/QprG2C3kpsLHIWEtOd8VxnIWZPdet9/7tf2RTS
         ub5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665853; x=1716270653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIPq0OwAhmVc4vzAewGAaL7fS7IEYUtLmyXTZiLlYu0=;
        b=mlPj54qPAXZ/bUOzVIHBuokLfyBMtgKj51OKHGmGMCyqY7RPmjj1p8uKDhvcBAvuzY
         NW1Oib5M68A9giz2MZeXcQi1FWKibKHau9adTY1B8K80ZJifSkBfyc0NQ75DvBMVbCfw
         Nxjcz7kfFhtG/wl3F+HXkJnlANtr26jxJ5uTFjLMJRjDBRI1NioM2X5OSejBuX+uYwg6
         vHgG94wEtFt5r0kRqzX/c7JfR7wGeZD4cSXx6OVy6aSHocWyD1L08tnuVkUZUeG7E4Fl
         QpA/bTK1y+Myk/UUvVz8599sgV2spxlgIvnb2cQ9X1POtZNNxhoekMj0YY6qufYb8gxb
         W+gw==
X-Forwarded-Encrypted: i=1; AJvYcCWxSNsolQyHrBiozV1XTeUL88JNVXkvbWK4QmPh6haBTBgPr3oxJN8SRk8IZ+Fpj6TDvdptrAmbSUyDhh/HjCiiT16H
X-Gm-Message-State: AOJu0YxXINtDdPe6nVyYN6wq/C+u7da7E9ZWih2RmkpcmV7IAiuFaUPP
	se1mn0ZwTFyFgQx/fV83pMFvxCs2tFl1dPTEoyolmYb/wl7DQeWvDkB1h3huZ6g=
X-Google-Smtp-Source: AGHT+IGdrmYK6Wqbz7ZF9wL3IAMZNCYlHyS0YyHmkJnz65+OHEBQCeTWqh83D97y8VQG6IakFQrCgA==
X-Received: by 2002:a05:6a00:1904:b0:6f4:490e:6 with SMTP id d2e1a72fcca58-6f4e03830admr12586291b3a.30.1715665852968;
        Mon, 13 May 2024 22:50:52 -0700 (PDT)
Received: from localhost.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2de1csm8689246b3a.204.2024.05.13.22.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 22:50:52 -0700 (PDT)
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
Subject: [kvmtool PATCH 2/3] riscv: Add Ztso extensiona support
Date: Tue, 14 May 2024 11:19:27 +0530
Message-Id: <20240514054928.854419-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514054928.854419-1-apatel@ventanamicro.com>
References: <20240514054928.854419-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Ztso extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index cc8070d..418b668 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -48,6 +48,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
 	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
 	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
+	{"ztso", KVM_RISCV_ISA_EXT_ZTSO},
 	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
 	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
 	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index e562d71..7cfbf30 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -121,6 +121,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zkt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKT],	\
 		    "Disable Zkt Extension"),				\
+	OPT_BOOLEAN('\0', "disable-ztso",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZTSO],	\
+		    "Disable Ztso Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zvbb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBB],	\
 		    "Disable Zvbb Extension"),				\
-- 
2.34.1


