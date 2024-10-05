Return-Path: <kvm+bounces-28011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09533991533
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B8231C21EEA
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A26F913CABC;
	Sat,  5 Oct 2024 08:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="J4J+59Oc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803B13BBE5
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115256; cv=none; b=BOagxp/keD1M2hd5UeTlpI4/AGuYc8amaM5+Y3RbfeGwr4GmpbLeSAE2IRKV/0N0jBG3U+0aEpjb+PdEGRnDW3P2p6p4j8Qebpi2KZtpYcEgCt4qJvCCgwQsFgvFstJPz80UzWeCvdYcuM19iJkTZ71bBhPAQ8zVEEr4X0wp6Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115256; c=relaxed/simple;
	bh=XVF1WQ9KZ76Jsfv7PwKbQ/OrWT6WhW3brR0QdvN3BAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J29g22tG4KSd6j44M0u1Kv5w21VOqvufNHg7tUvVe1ayWkOloct7DaNDls69/teov2v7UPCmqofw6XfyySLRzZrjGxHp0CsJC+sj2koXYIjOyUDP6sHEyWz3i5RLOdzjThtW8hEQRoy2EibsGFWM4+aj2V+27v63ZnkMHv+vz4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=J4J+59Oc; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7e9ad969a4fso1738118a12.3
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115255; x=1728720055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmybTeLafIZrz52+nkI2/NJw79JJM3DNNtuVN/7MlKI=;
        b=J4J+59OcsgbQv5RbyuYHaBYvnRgTfuB75cSZnwSHqtlD9soXDPnYCKfFBpJjcTBB+4
         8KJqgyHPV+sg6FVi2b5c48DJSHKmMsX6UU4ra1k9A5kdquYm/BbA92DQoqZLkgCK+ezU
         c07juHtYI442QwpuXp8SwyzklRncHNhiZ6fSZ1zb9lpd9jK8vCHCOGi/Ksc+YuvbaQRf
         GAsbFki9CkYEYb1MzU1dqESI0jdZrkJk4BHZEllbGVta7K+S0lhv2epMys4t+j20Z0tt
         H/Z/+IJyCqfiE/+pd2mTs+gdK3SgkgNdjNguIuHNf3ALGs9uJBUE3cG71mW3Dak7qO9n
         ZOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115255; x=1728720055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LmybTeLafIZrz52+nkI2/NJw79JJM3DNNtuVN/7MlKI=;
        b=ZZR+8CJigWIZwQ+6E6rCKlTT5ONHjtP7vgdojmh/tSFX1ypoctVB5uUqJK37iiHYmw
         NWBl5hkX8+fejUP1M8t4OBT1zPvxl40EFpRXXnVXYcP0ENpz5Bu/yh8kX46WCJOCCKHP
         HdQYEmpgcq6ztjRHRb+RRsAK0m4EcOMBVBQFo949LS26CP6uefDJ0O3LAiNSiLArfM+M
         COGMQ8jEnnowM4RBlS0U+gLNLFqy0w6Ii8I3wwiXBxsVMM6AovUvlQJE8hX6ZE+zfrhO
         BnjldkBRSkfX5TnPJloq6kTz6iT5lS0Pg30jneNWnKRAmhWQSfwc/d1gufSeOjzz4JZL
         q1ag==
X-Forwarded-Encrypted: i=1; AJvYcCWj7KLh9Ssnag/9GHZ2FTGShQ6xGP7vAFFJOHzutBz+iCZyHkSX4W8A994l98gNjfrEQaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQmbEl/ECWfONu/R2GjHLxI3AyQtY+8zIFOs8dV141NaJTR9O9
	lN4TPOVP1jO+U89NNoZ9oKnK2+76WYFJ6Agam0YTn0R014qyGUgH74lr8CThsZo=
X-Google-Smtp-Source: AGHT+IErnaAyF3ld/LYVn+AMd6izGlb8aMyu0/kmBAaADlnMthfegJsNXGpxI4wvBmpB1P+W7Bh17g==
X-Received: by 2002:a17:90b:4c0d:b0:2d3:b438:725f with SMTP id 98e67ed59e1d1-2e1e62a978bmr6436964a91.24.1728115254716;
        Sat, 05 Oct 2024 01:00:54 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:54 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 6/8] riscv: Add Zcf extension support
Date: Sat,  5 Oct 2024 13:30:22 +0530
Message-ID: <20241005080024.11927-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241005080024.11927-1-apatel@ventanamicro.com>
References: <20241005080024.11927-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zcf extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
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


