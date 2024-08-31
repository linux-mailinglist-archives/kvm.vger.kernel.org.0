Return-Path: <kvm+bounces-25625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77492967143
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C6872840EC
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE2D17E009;
	Sat, 31 Aug 2024 11:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DIhltsDY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756A133EA
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103701; cv=none; b=Iz4GZkf85PDTK3BIjRY11pt+DbqzOk/ykXuobJ6dWMOPhOxNmOcM37ugm64Xylt4ICYjHqAw7fe3LJl5q6QmUUSNurTjaamYeA3VJ87WabwwnY06++1d+MNtiqfBaZpho9FcPqkWK1mSEmCs52NQWvywlScOVSBFuvu7RyObf/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103701; c=relaxed/simple;
	bh=TzG26ZihbX4+X9A95svLiNCwHMUILN2mfzdeI8nIjCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VapcwDAKsKYu1PKRH0c27GuokCL+vklh6GFpBzZyUo8mxEITEBrlQ6cFhm2brqSgKZA1wa9HqFrO0lzUcee0OQaw+h6lBIz34EDIIeIdOs4elzAjOb2NG1VWxY3aagV2cr/C57+gk8AqFhOcYVD0WLpI/SUlmx7LBP3pDAX3D+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DIhltsDY; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-714262f1bb4so2172702b3a.3
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103700; x=1725708500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IN9zWgfThfW7vB975JaElm6zTXWCeSIChlwuRZr9WjQ=;
        b=DIhltsDYNY9kIEB7UuBJtR2hbWkkGLMiW2t0B62EKf/yfRO4cYPkFW1timuSS+NUzg
         dBUO8hiHYUYknl3gGAWrkNBh/1s5D8Zhva1GhP7RpI2g4DmKlekqOqrd/m8gE7Z65V4S
         ZkptJHraDNQfs8Wp09TzcOrALpO4EvcJpoHqBpaLLeesy0bJGVboTeocuyYv81w3jC+8
         +fmGc/Uh9Wz45yr4PfQmMc0oZowPOtyRa6v7XxuFsxbSBkG1CxSa5LiISwLDjL+m5whp
         s5V4dol03L9Qpcus7Uccgx7MGDUiJj2OxcNcJ2jONmaGNqIQIVp/OMlJAQsP3vLLrEWB
         fsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103700; x=1725708500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IN9zWgfThfW7vB975JaElm6zTXWCeSIChlwuRZr9WjQ=;
        b=NXxcGBbiCvIlePQokp9/fIIi28oeaZ4ZFpazjSvUtvq14qs9ltJOhkZmcBMp5Sivuk
         24Igt6w5seZy+xbZeiKSsRZLKnoxq6yE1Jo4wZBIk4Uf2faoPdxSClCIj0BClLNv8ri2
         B6kEAnEfQZCBsfNj8hVvSdRUesydcqXuvClmtjCZA+DsYQRQ2tmRixv60jSy1xwARmYl
         VYfklDLAE7IJ9UJ+Qz0KoY2u6y2vCEZNnedPISPWWQYFY4qNaL1a+6wtRJlmuSftb3gR
         2PoXljfIRz8y/MsJ46Sxts3Qa7K5mWKO9Ku5iUDTfOuFBlhnRYOMive36sMI44zgtLsC
         57RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDGzJPRv7Rdp8/c3sk1qJQdH6TSFZSWwE3bddOOCmMHEko9kA66WC6yZcVd1V4lZo2NNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVIvZMZZWBUCfydeaMCc3qeWOQXMuUoc7pSSq0zA1HNsJbUsYd
	iKEOJpIj1/xGwlDAPLrgqwlc/cwrwtV68kg+OlaqjvL5uXMAna+B1BB8/iaUl5g=
X-Google-Smtp-Source: AGHT+IF4Fve2vOx5CS/sqFIy/XsxZ/BrevhiyP3Y+gnDhrSyaPt5YS2F96MtmxwIKsKduhz5mXw+qQ==
X-Received: by 2002:a05:6a21:6b0c:b0:1c2:8d33:af69 with SMTP id adf61e73a8af0-1cece5d1678mr2539298637.41.1725103699429;
        Sat, 31 Aug 2024 04:28:19 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:19 -0700 (PDT)
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
Subject: [kvmtool PATCH 5/8] riscv: Add Zcd extension support
Date: Sat, 31 Aug 2024 16:57:40 +0530
Message-ID: <20240831112743.379709-6-apatel@ventanamicro.com>
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

When the Zcd extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index c62d4a3..5587343 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -34,6 +34,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zca", KVM_RISCV_ISA_EXT_ZCA},
 	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
+	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 68fc47c..155faa6 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -79,6 +79,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zcb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCB],	\
 		    "Disable Zcb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcd",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCD],	\
+		    "Disable Zcd Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


