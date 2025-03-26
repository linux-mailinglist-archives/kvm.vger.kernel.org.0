Return-Path: <kvm+bounces-42024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4ADA710E6
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52FB53B0017
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9111819CC02;
	Wed, 26 Mar 2025 06:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="T39AzHYN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD619ADA2
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972232; cv=none; b=eEwBAEryn3lLDoNUgEhBCiIgCZjvyz8WK4umAarp9a3nVmO+sBtDJdzqnSxdhVS4PWcsEYbrL3tiE6T/cf988PT892fYM3ROr7PEWVgHO/xKZFbpD9q5rSd40ZnbSJVfOXD9sD/rlMt9s9KfQx3d+5XXJ+rTIMm/VzBIFSqGHu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972232; c=relaxed/simple;
	bh=7YMG73SSONCfBE/7mbWSrP4372SjjKlIwkdUjs9Xdj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5CNs6h4STl4SEmWwhurweX/oBQH/knIozLN1slrra5L4eOI8r+FIxRm6kifd/vGabgYGvy3R4ZCAGn6XNyMT4vEsoko7P63nJcKoM1GSVneIN4tjJSOXt18kUzoH6aVK5Gf/YLafWuiSeQe8+BvvdF2DyZEt6ZTottSHHEOfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=T39AzHYN; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-227a8cdd241so9708055ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972230; x=1743577030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JMdKo0ukTUZVJpakOidJHpNdO3nq4lSPuscKE86G7E=;
        b=T39AzHYN9TmBLUTM3AZmsaUauxbye6705pAt40smSJvKz9ZseYLgBwX4kAnDqm0iwq
         js0h3NuGhiJc7rMImn0aNPT+2IgDBWY63hz44LvhEkY/BeR4fRZj3cjZsYO/iBxaruQo
         zhtorag6CoiA4g9ezK0SCuYoD9WusamYhF0uqVkb+yhLBjxViGNWgBGLN9bedYOL4ZpD
         lVfofwJTwXymeVX2F8LlyV4yxyO7rUMz7ptHBXTNwIJ+DxWKIKYEBt0OKhss2hR2/XNw
         wkdSt5I4Ca08g20O5yOGqXjIRphcigyrc23kEnJosZRLuOQkLhgIukjw0oCTY0zp/zPw
         MeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972230; x=1743577030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1JMdKo0ukTUZVJpakOidJHpNdO3nq4lSPuscKE86G7E=;
        b=dB6SqOfyWiCA/i//g8MDFj3Xo89T+YIUi4sQnQOjjEYmB7XlS4Age2DOsA9ExSSDn7
         LMztwWxhXjoUuTlDHvSkcTHyMrqq9c6Gy+BjghumDT66xJh/UBDQKvhyHJDb6v6vK+Ic
         bsg5bTcZVuST2zOxsFhTWBxg5/PnmzXB7onCNqk2rnkHpNoOuoteH3txn6WCjr9ymHro
         23VSb64LZGWo+AGLZN5glzfSnwOD/bA7K9V9BZq4guuCDvqGu1dRQOsL32KaQc2RIZpK
         iTo7L81grtGpdl0hpKD2/9yDRC8NsmeU8Z29E5OZgCxG5118TtxQUIaQb+M7mN7b3124
         SCQA==
X-Forwarded-Encrypted: i=1; AJvYcCUErb1Y9wyPmSaPjzdiH4HF9KZqaiBp99hvWj76hf5ErhSiATz7LZI3SYiR47fm5H2Ucvw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF70d/OpfpWY8ZB4mVDa5uN8j4wA8ysUOBObDgy1sRBqHhkJlR
	p39DS5cudn8nytDI9y2XB+5eXbO3MWdjuAw5ygJtppa+vWUJ9Y/zpzuKWFHRdOBBOlFLbpvOshT
	L
X-Gm-Gg: ASbGncttHJ+3OJKkRiGocs1Q60v0rmBdP/lsU6N7RsV7j9BrxZ7Fjd4+X47xD3G10lc
	HP5UCQUgxPfKDr+hGOgMzScXHLlIqglq+mUZ75Y2AIKTq0vhtVxRfJ2xzy+HtltOg+DdYpnFBBt
	KrDwEFfQDB1SOxFcziGbcIbVbsYvU3NG0Od0+MFZxMTYs0AYqcUqI04hB5n98hEmgqrIoDCm37f
	UNOV5lASjtj9LPgU+bhkmbyeaTRvR8zQd9IcDi4r37SfY22vGu7Vfv+dShwokmtOCjvJ+K+E0ka
	6bI+AieT+aeOGvDkJgcUckfKw15Wmqvu09TGoB/IC0FY5FdmSRemxyShFnomiVgX7FwixM3LLsH
	jrRlnBA==
X-Google-Smtp-Source: AGHT+IFa2pCVIIu2o6x+sV4R8hNo3rsH35W5vMtmxz4iiJ7DdjwThxn86EFdSC/Y1OeyjpBFDC40HQ==
X-Received: by 2002:a05:6a00:22d0:b0:736:6043:69f9 with SMTP id d2e1a72fcca58-73905a2ae3fmr29731979b3a.19.1742972229622;
        Tue, 25 Mar 2025 23:57:09 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:09 -0700 (PDT)
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
Subject: [kvmtool PATCH 04/10] riscv: Add Ziccrse extension support
Date: Wed, 26 Mar 2025 12:26:38 +0530
Message-ID: <20250326065644.73765-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Ziccrse extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index ddd0b28..3ee20a9 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -48,6 +48,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
+	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
 	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
 	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index d86158d..5badb74 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -121,6 +121,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicboz",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
 		    "Disable Zicboz Extension"),			\
+	OPT_BOOLEAN('\0', "disable-ziccrse",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICCRSE],	\
+		    "Disable Ziccrse Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zicntr",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
 		    "Disable Zicntr Extension"),			\
-- 
2.43.0


