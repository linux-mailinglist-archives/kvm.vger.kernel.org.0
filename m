Return-Path: <kvm+bounces-17366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5458C4C14
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 07:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D91B1C23143
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 05:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B521CA92;
	Tue, 14 May 2024 05:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="af8FGiD7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077EB1BC39
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 05:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665860; cv=none; b=KMvFImk1gNLt5ehK26RYXb0tZ8FVHZyJNA39TU1F5h8zcqhbDJ7odqSBHuFqZBZnB7Vn5LNJ8tcApf1H82wXnw1hl8R2H+ouTE/vmX5JLMcsN/JQFM47dVijN66fi+4neA7fF44SuN21H/ejMeOOGsqpXYJG74sf2uWxURgj0HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665860; c=relaxed/simple;
	bh=GUkJ4IWY9EpSK0OwqT/Dr2GF00OHHaC1BFftaKgdOGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cwri9nQ2QApZn5GC5GXQvQ6u4xJWgAnxdSJw863tsf7I+EaHCvGhE1RLqJo8VdV7HVwXFaukZM3nSHU4+t4Clh+gMgeGvPselaPTkyCI61lfgBcvVF0BsFXWj2+CSarNiI1HhXypZYbE4KCEpYWc2rf2wIAAInnW/Yd111Kl2r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=af8FGiD7; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f4472561f1so4749924b3a.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 22:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1715665858; x=1716270658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DfIrpkWACzR2puMJkGg1Xnd11pljfe3Xljjryqmgcn8=;
        b=af8FGiD73h8K/POMcelzuDGdd9kEqs/y1BDG1ILmMzPaF7i+LMloVsgeD+8sstT8Xj
         AeVk8wcyVH7HeoFkKRKjJQg1Duc0QWOfZoXNejGEIQM/UDoC30xFNlahxDxkWopSaNEp
         ulE5fLYYab72GL/azPRqNLG+U19TxXteiJreQ8Hzros7oizFPkkGOCbn69VO0p+eaXuv
         esLtyb4lc7eaJdVGMFfy372IMJ5VYh7KzI/CP/Pek/Sbr2ImxDtmR0AMw6mbw7tfChn2
         98WV7hulz1yI/2a7eKGFSKgbjtkJkoRtXSjSKo14LO2XIANN4gE7DJHdOpP0GHvGztS7
         9P8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665858; x=1716270658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfIrpkWACzR2puMJkGg1Xnd11pljfe3Xljjryqmgcn8=;
        b=XwL1OeMVMRYaLvgT8+BoxiGolTjpP1uHd4jTgV9p50fMlJP7UwGN1/ZrhH/o8RRBjx
         jXR/YAZq/zYOQjylZs52oUMJHGNSXSTtSo2IdMAA5kweZRjJKozQebdtDJo+meD/xyS0
         g5Wf9a/vB0mu5DPQanOa3X7elAwwOs0kiNWhTVDfFZb7uM831ndAVHRA9dj/T3u9nR9f
         sdFM87XKGGmBHgdcv39c33T2iH983QIQkPtyHKHkgUYPVXK1I1GhGedH8y+9zdPi3b3/
         yWXdJQsv0D9hGkV3weDctV0yD9Js/k4JaLwMU96xGmGl27rcA4HDrt/lmayPc5X/dhwj
         pfmA==
X-Forwarded-Encrypted: i=1; AJvYcCUWrD+c2/Ja/m38O3or9Hxg6q3c3VLBGyzVP8dTkQfgY1GN+UPsJ5N5LjJ2GOiKazerzsGmHbjDVAEILMuCKD74Xn6a
X-Gm-Message-State: AOJu0YzGWevzY0ZT0jt1nWnu8qZyZuOIVp+SLPCq2fqAFMo10zl3FYEI
	oFH0ffvPNQfUQm/jOlWKSFY18bHqmyjgnJ4NF3LRMaJrmpJ5CKMxu41au+pQnTo=
X-Google-Smtp-Source: AGHT+IGDeCXQiyyb4hYkNlCwykJ2G3BGUQhS6Mw+XYtTCvB0oupEx4U7YFpcR0M48NXf1Dq8OAKkxA==
X-Received: by 2002:a05:6a20:430e:b0:1aa:7097:49e2 with SMTP id adf61e73a8af0-1afde196759mr19414564637.50.1715665858115;
        Mon, 13 May 2024 22:50:58 -0700 (PDT)
Received: from localhost.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2de1csm8689246b3a.204.2024.05.13.22.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 22:50:57 -0700 (PDT)
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
Subject: [kvmtool PATCH 3/3] riscv: Add Zacas extensiona support
Date: Tue, 14 May 2024 11:19:28 +0530
Message-Id: <20240514054928.854419-4-apatel@ventanamicro.com>
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

When the Zacas extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 418b668..cf367b9 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -22,6 +22,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 7cfbf30..17f0ceb 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -43,6 +43,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zacas",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
+		    "Disable Zacas Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zba",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBA],	\
 		    "Disable Zba Extension"),				\
-- 
2.34.1


