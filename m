Return-Path: <kvm+bounces-25627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE18F967145
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6990D2832F8
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B4D17DFF8;
	Sat, 31 Aug 2024 11:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GVdQwYIo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6F417C7CB
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103710; cv=none; b=YVp0cvPpYhunZEb282rN9Mt0HCy1EWsTNX1XtN19KtsLc1r0nIPlReuAmMBuuUI0aLr4SA1LpxexcAabnNM65jT7zWpOxAOcYYlN3pmIPlCV91wFubVqgYiXd+TuzhAaIikKCw+Vjl69sKcgnnki12reI03AFjc7HgnW7RRR39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103710; c=relaxed/simple;
	bh=s5xEf5d/1JLhg/SRbuetF1Kted25wh7fSZ7aRRXSA1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6TS56f6oF7rHOfWoQit9xcvAsci1dKsqTEVzczfKkY6X+Yl6ZdMz9iLYK4cdTa50m5vWMe2tH1SU2qDybHrIE/zgkj6MV32zZkd/q15lSZTixYUbcx3wy/YthxqSFsrvLaL7CvHlwNBewjcBdMkMeVqvynTq8E+UFHkH7dPhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GVdQwYIo; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7141d7b270dso2218237b3a.2
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103708; x=1725708508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dSG2mOQ3WcTVmUmPxjtLmw3x1sU5mFnJXlTn3zaT6k0=;
        b=GVdQwYIoxpHOw34LgB4HGyOaOaN1vHOxWAAn2ztB9W8D+7jkq6nuFekcahK26tlWdt
         5YqMVAISfc6IoPNb6Qt+UHtngXqncmh5kz7DAC3tPTKv+FwU5r4cTGk9zhlwpuRkDiFV
         otcF3S0xms/NseuNcE5XFWnOhlr6P8Sxy+IGeBgF8wWLfW8ZBuRf5Mzs2lBCCjofm6D3
         xROFMAFyhmFx+9GlC2s3A1RiuQElElIJoTknKB8mzbsjZYjOX9WhKJVgZRWEOJxYbw7k
         apqn3u+H78kf7y4TCphF1mnwBx8CPvgYFVfGS6kD16crsTLseNb6mTD9kP1Wkh8eCjPg
         zKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103708; x=1725708508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dSG2mOQ3WcTVmUmPxjtLmw3x1sU5mFnJXlTn3zaT6k0=;
        b=Tr6r+HdToDo1Zp0AZHAe2Tr9L3oULdLeZK8hm7wv47+cXZgZYcqg7I3wHTU6yTjJzm
         ymWYZMf/QpMknE9idlJdeNEijdTquVDuOLOiqftvNn65HxzZs9yU/RTdXe5RQqm7EsU+
         oPtyvzKA/JdBXRmJ0m+jPmLHxzuJhb6M8vGFpB3duEO+/mZYFwoZxvbTN3I5Masc5sEA
         EBllkoH6G/UjoT8a16QSlfsTnPQ9ks8k37diipN5JBKGMApxRU4YLD59SMFT0tKoR19z
         5bMv/0dDEnStA/Y0agEvoeqYFojVpB2FKVz/6sT32oR3/NL/CuED5PT56INWrOQOX6w6
         7rzw==
X-Forwarded-Encrypted: i=1; AJvYcCWErpMjH0dwQ4zAqVGXOeo65ratutbKp3z2AT+5yiqeiuQSoJfrgVOYRUc6bjcd8qAQv+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeoI6PcEULWs6p3JZeeNcXhcTCOhs51pDEIQA+F6g8JC60cv0X
	o+M0EY5nlyIcr1s5qxuygS2z0MmicXJ7k+HpPS9K6BGOY6iJYO3u+sfy53MQvdI=
X-Google-Smtp-Source: AGHT+IFh9Ai8wStJ+N534RDR5PveZM8RSUWaPoQXrVQAjBv83RkO2n3cEqrD7NyYR6ioJJxN+V+nYw==
X-Received: by 2002:a05:6a21:6e4b:b0:1c6:ac08:8dd2 with SMTP id adf61e73a8af0-1ced6087aaemr528545637.15.1725103707810;
        Sat, 31 Aug 2024 04:28:27 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:27 -0700 (PDT)
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
Subject: [kvmtool PATCH 7/8] riscv: Add Zcmop extension support
Date: Sat, 31 Aug 2024 16:57:42 +0530
Message-ID: <20240831112743.379709-8-apatel@ventanamicro.com>
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

When the Zcmop extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 7d8a39d..768ee1f 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -36,6 +36,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
 	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
 	{"zcf", KVM_RISCV_ISA_EXT_ZCF},
+	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 09ab59d..5d655cf 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -85,6 +85,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zcf",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCF],	\
 		    "Disable Zcf Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcmop",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCMOP],	\
+		    "Disable Zcmop Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


