Return-Path: <kvm+bounces-8663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC3B854921
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B5B11F2A2E5
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C685D1C6A7;
	Wed, 14 Feb 2024 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VFInAbee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CB01BDD5
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913323; cv=none; b=rwAQWd3JHjv8hDWjOL/ZxeXQC3Hy9PueyoHm+0vAFYh2rtuiRrxFFPvf5D97PkDJFhdqwr7ZbbgipQC6NmfZPNUvOLY86BjxcQpIRIcUzFF8UgNBpfocONhox6Poyl6AdNgB4LOHgGnl38DWZqBwFZAlZT6wOLhpdjQRTbNeFco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913323; c=relaxed/simple;
	bh=S4oA+1bymS3gdRGx34gZrT0AIwBm0mwDi4op0z+exN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e3RNQ2b7sfj6HBToO1OhuAbNTbBhujUgzl/zBTn51nmDBoZ3o1fw7jGN5BdzYs1pMm4fccss/ZhrJ0Fq8nBYouRCrEAJIvVbERidrImFqkvB7URrG2738VAuzyLiWfw6x8eFJ1huIhc5AV0y1Y9CmH+468NiZ1kz4G7tkaifmu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VFInAbee; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e0a4c6c2adso2075495b3a.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913321; x=1708518121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZyXdwC+1687r0DWdyyihI8jDTPcrLnDk2dDeYIy6R4=;
        b=VFInAbeec0ivUFSj53MxWJSmU5hXM1GM1Gwp3ooIAULlMVWIc4O7Pc5hk6py4FkgNu
         uw5vZi/7YrBCXhNbMNBvhoa4DUDjUeNRcAUKML+xWLzWPWUAsUEPMuvAMqO8sPRR958x
         mEHQYf2+cxf0h8s8ODcR9ijjeckQyfanjuthWDh+JhiRe078R+F39KY9HKMzzcxazL/x
         eYOYOeVil3HWh3Y6Ie+7OC+kXSXaGIEvlD7LbW2C6DduDdSc33oFYVG5/k4INkJq8PKw
         96sM8cgF70A6qa7NW0RJUbVWYyGiJLblUALoUHIhei2hSvX59glsmmMotX+9daCf+iKg
         8Sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913321; x=1708518121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZyXdwC+1687r0DWdyyihI8jDTPcrLnDk2dDeYIy6R4=;
        b=HQM9nyvvmDvmvtOPPi83FeO+fhLUbqmM/zduWN2LZFmliBEOZD4ZS3Zdb08Cn/0CRz
         4r6ugvDtmNVz63VFcQnuLeYCip1izrKPVdIv+dtz/fVAf71XpPgl3O29B8fnbbYCI8lL
         Y5FJDxj3zyWIMGPGSpG4S6qYFeA+2bgbeoFSq6qP9obMe6caCCezMddSmTGQGCOa6fCE
         uBL+iBghAuBtuRAIK+enKVmxtZOvPzRzkEvlanLKgPFyJMJOutDYT4R9cD8sl6hGjlvp
         PSwZuBwqAucWU14awjLVURbN4dBggJP1IL7Xe8qUZnuz9s3QqDupMrDxBoILBn25YZtl
         oQ7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUUSO+e8LXT1MLo7xcvHFyapDybcjVHK51eTXw3Ghnrd3ryRW3BBwmyBO300H2ZBPUqn4Y+isCVK9yfoG8tBKiDZ8/o
X-Gm-Message-State: AOJu0Yx5cVnf0fKSOF18AwV5HVo6WI5BClrxVWQbWGwtiZPoA4x4D9JC
	keNPUmhu57hO2fAtPdFVo9UvJ6upsimVrOS6rC4wmi3IqS6kWGViHpv2O09AHjPbvGA+5t0IDcO
	J
X-Google-Smtp-Source: AGHT+IFwrXYvob739M8Fd2iW5zrG5JU1zA3mZGQ/M8qWCKM/S4tE5Lgo0PHVYouee4PG3t7Ks3v2eQ==
X-Received: by 2002:a05:6a00:1797:b0:6e0:6b0d:455 with SMTP id s23-20020a056a00179700b006e06b0d0455mr2383028pfg.13.1707913320847;
        Wed, 14 Feb 2024 04:22:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXt/p1y8f9YaagutOaBSmse37NARIUi3dBUY65j8yFYtexjTv1O28+xR6+hWYS+h6WfXt0q+CfFbG48SnpZTRnY5z6ye3d4dpWA6Sx0SBEGi0EUO2ut4OUgeM2cMU4YPArU6BUo2yBh6y0uEe+czq90BdJqKq3vko/c9dhhM3pW8r23GhYYUXfc5WP+gp78oQ88GJERN9pMnHJ209n8BNodhkIYfBGdGqp0SmtL+3SyAgQpgWsqlA/DIDLgFEQSHqgK2wHxCSd2cZe3hIhoAR+oVrUZJNyE8AbNQSvUUl1oinMh1+nfzLL9PKvs1bflbA==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:00 -0800 (PST)
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
Subject: [kvmtool PATCH 03/10] riscv: Add Zbc extension support
Date: Wed, 14 Feb 2024 17:51:34 +0530
Message-Id: <20240214122141.305126-4-apatel@ventanamicro.com>
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

When the Zbc extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 8485acf..84b6087 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -24,6 +24,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
+	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index d2fc2d4..6d09eee 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -49,6 +49,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
 		    "Disable Zbb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zbc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBC],	\
+		    "Disable Zbc Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
-- 
2.34.1


