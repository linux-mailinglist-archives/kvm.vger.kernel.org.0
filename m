Return-Path: <kvm+bounces-12599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF5488AA91
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F14F21C3B898
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA5974BF3;
	Mon, 25 Mar 2024 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BGttq1v4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650EB4DA11
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380738; cv=none; b=O8sygA04anEZMYxdXkagprmk+bL9YGjYsa7rfG7TvjtHO8X0ncpgp8XiVjQb/pd4wzp+C6Vout71A2U0W1+KEQAjgKhAWiiHzA5r1yyAYWLd8/i5Ts2dXDo8Xdhi4Gzo+EEA+dX+H+eK1BNKgtSj7pZL5QeOFA6mtfXNmoEuPz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380738; c=relaxed/simple;
	bh=e2Jv2Q9FlU7BqxLJngPORhZDXnMQKyhhnHvDE++gJoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uiLj+/ZBwKVmDtsFUzMNs07Vj1PmUDxfjtldCH/BXAuaOWvDsiHS3tLspixK0dGYHpMDc3GQHFkv6H40x65s19d/CWypQx2XX9NCLKtjCZ2FJz2C6CKX9wovYHPx7jbb8EDR+YZXlIJopEn5EaFB+gYCUQ+7iyiGIpBGadAMZTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BGttq1v4; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1def89f0cfdso40004445ad.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380736; x=1711985536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UNZw1HKonYlBZvv+pVqlr0cHdA9JysAQAhjF4txKvY=;
        b=BGttq1v47P8Vsnmdc7wD2L55fvLE03a89N2pe55pnAPtY5YCRRF+CBrkMlW6yZe8si
         79Dxu81JKi1TB40SPp5CKZnCb9fvRYoF1gEBbC3Xo5X3xFItv26qpzxdaZWDNhapaWhc
         amfP5Qy3ivzY5gDKr5oxGUp3ik62h2kYmgXgErOhR14gtXlBL5YH1qANFit6nHzQDq8s
         23a6JvMMfVzmRlNCTzK7q4sja0FX8ia/dak4AGQR5xO7BVBBDOiObZXq8hjWUI4ttj7z
         8UWJJhPy7HuHrReI7LqOh0koPEhwkZPG+QzsmQgxymYu7uwThnZnT4xWKZdu1Ab4cDjZ
         MLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380736; x=1711985536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UNZw1HKonYlBZvv+pVqlr0cHdA9JysAQAhjF4txKvY=;
        b=TulmIuNER8QJYC1AYaW0qaQRz8w1/7kF2Sa1aqYi38x24Y36rN6BKgBGLZIL3OdDeV
         nfw2gqoQ1hH/L1ES6T8ASY+SMDQhV+qbW7MMnHNSJmDGP0JsRcfVi0RY7eUENmdFJbZm
         JsFDlacxnK8n6dYkb07bhal/LlDxYNDWXsdvTdE3VkUZLi6MVv9bEPrPaZcJTBJS4Vvo
         +RssjBawqoeB/IbvRg027PWMpJsf0uWaW2P+Ck5+mvH5rPD9WSI0ft5eUuUduQuAOpRn
         2rlzIEESTDnyBPFutxr2YcSX3XY7UOYAHii+oBk0Q92xXAXHAzf8h0Dyboc2U2GBc/Z/
         Ltcw==
X-Forwarded-Encrypted: i=1; AJvYcCVKzwemdXoDfa9PGmlnItc6Fz852S5tCb91jVTgi1cPt3Bj3JAdaaR+WPLIwnI/to9QiQGSoZFTinachk+w8rP6p4xz
X-Gm-Message-State: AOJu0YyUKrtlAp6LwWBwkFSQB/dlyFGvYCTMsg6QtniSf2THDbjEHPT5
	kvcpP0c+9B+ISZpwLAoY3uG2AL+UvwvGGU53S9gOwOtPhRjqsMFPulsGyEGFMPE=
X-Google-Smtp-Source: AGHT+IHPwsrs49S6yyD6ygszSBABqNrykpVi23D9o/WsfTyjh2IAWOZRtu/n8Y8pCF6s1suY+ra4iA==
X-Received: by 2002:a17:902:f54d:b0:1e0:b697:d3ae with SMTP id h13-20020a170902f54d00b001e0b697d3aemr5903113plf.19.1711380736537;
        Mon, 25 Mar 2024 08:32:16 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:16 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 06/10] riscv: Add Zfh[min] extensions support
Date: Mon, 25 Mar 2024 21:01:37 +0530
Message-Id: <20240325153141.6816-7-apatel@ventanamicro.com>
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

When the Zfh[min] extensions are available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 44058dc..7687624 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -29,6 +29,8 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
+	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index ae648ce..f1ac56b 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -64,6 +64,12 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zfh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFH],	\
+		    "Disable Zfh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zfhmin",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFHMIN],	\
+		    "Disable Zfhmin Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
-- 
2.34.1


