Return-Path: <kvm+bounces-48473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4FEACE9E3
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38A571897FA6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD7A1FA14E;
	Thu,  5 Jun 2025 06:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="l4bA4+qY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486F1F6667
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104111; cv=none; b=LULsaCgtQOjtoRXH7fCAIQ/B93O41S9BSCicIyR/73gCxiATMXrUVq1CnhWfZjROvGtOZgzcNYAAj4OkUNnamzNw0uBporSQijs2IlXsnVge1/Q9rTyNMF+msm5iQkwXQ/C/OMTHTeYkUFv2RdGnjQbtMm3rR32XxLOqulcfrX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104111; c=relaxed/simple;
	bh=nvXXcrrM+yiGZgmItj7EWeNmKUo3VFTr1hB5yq1cosQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpwv+rf/B3d0aVGcztAdqi/H8WTGw976lBdgNdGw5KL5hkPUpLR5vS+Rplm9DVdSYOG1nQXfJAgQWF98oQGSwKmbzGHldKSwqhB2HtWEPubMyqS/emaJJvXkPj3jQWlFp1fKHb2YExj904aRvVUrbHJK5vPp6EiQbhqOXYjsjvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=l4bA4+qY; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3115a6db4d6so468224a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104109; x=1749708909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/Iwx8NoDTniX1jxmQ6HvQXY8SuCaJi4qXxXEsxBkb4=;
        b=l4bA4+qYBkwW6/PsdkIoOtg04m4GEWjerAWvd/U5a8ct16ijZy4+nhfiUDe7nGnMOj
         SYIBdcjK+DQoAynNcSIDM7W9/OeuF7/P0Uvt+y8OAbqNqAJBx7+QOtUXFkFnuc+KMXz7
         e/aLxlwJ163TIYO1dHQGrV2oDXar1el+1uGxB05akjDGi0d2SCg4035RHAJh5ZfcNsZl
         BdTfK/3P+vtKuARLYICveMfPH++Uu3v6pm8K8/UQQ5eRHTlzfSb++j89En1T2PGA6ZNT
         cY30MyrmU3AS14zJNnJrY/dNZm4mpwY47U6x21SubIhz8fse7gpVHgNLSdiHttUsm1jG
         thUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104109; x=1749708909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m/Iwx8NoDTniX1jxmQ6HvQXY8SuCaJi4qXxXEsxBkb4=;
        b=rIGRELi3JJqZUUWZBrxXqeglum5BsWbP8aje8xZdeq0bSribSuNA/DLv3buM29r7lh
         kzrNXq5XRekSBj9ikmLojwRAx/0LiC/XarSfs/uWX06AppXw290EPu1nhxKkMoiuV8lW
         ePpCDH8/0PazpbjytTbXoXi89fO6mZbb+O1m1U4zQJIGIJ9qmhbWwubCCvhqlxITK+sL
         LyWSvQLOdQmEpiQDLHeirTn3YmDsZpJILxhmZ8pSYywp84uBTAPkYYOlzYZhej30AcKA
         4iZXxRCgE1WJlgiBOIvW6QEALPW+kOlWZv3DEi1pRtfiDku+sJPAS+DnH8eHVhDN3+dN
         TMWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaplPDwXA0R/uCD5BbNK3gbm11bJntEe4pwrrQ+mj7WngUIZEdoq80gAb8y3/W4WHSR+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHvnSoQQkYfmsBkTo6av/fxBEGp1bwvRez17hZe8jfBh80R6DI
	aXYEW1+hbtaKPxBBJDgWyB5YJZvhLD7fs38xyGNPeQy8q9xSFjP1ELvmwwii33Q501A=
X-Gm-Gg: ASbGncvrApoPMhF0KbQb0ohNvutrXdAHNYSWqHqwJebw1yXS57gYHhbE7BasMd7vvRh
	2kJm72FzEXc9NmPB8ILN7HlYQmnHzA2tRPYQGuAE2k0f+vdtrH5JGfRzwJH0u/yyHQrWyTMaPzh
	3dc7jdVGQk9lNDxh4ovk3KrswrFD+QloJ1V+8XoMUou+1/Chyyy3FBFbtVN2nXtaqHMAAH5vAg5
	hO+O2NkVfYsWZiwi/OOtcD4zhryTSjSrtr6tnClqZ51VHT5e7HEMzZqninRMXWRv1MUuxG1BiKZ
	TDXfdyPy8Sk4KGCyq1WfDJRzCJ3lvC4EXqHA30IMyFxVJh4T1Nhr2n7xng47fJhoLiwb37Urjq2
	g1H90DuMKThO8SAlK
X-Google-Smtp-Source: AGHT+IE5uPZLOAhVuqWaFE8UdeKOXIRbJ0H8KWIVX2JV+WCepOe45QIRWAIT5GZJ2vN2n4ZWB/B3YQ==
X-Received: by 2002:a17:90b:4ccb:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-3130ccf5055mr7616893a91.5.1749104109337;
        Wed, 04 Jun 2025 23:15:09 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:08 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 01/13] RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls
Date: Thu,  5 Jun 2025 11:44:46 +0530
Message-ID: <20250605061458.196003-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As-per the SBI specification, an SBI remote fence operation applies
to the entire address space if either:
1) start_addr and size are both 0
2) size is equal to 2^XLEN-1

From the above, only #1 is checked by SBI SFENCE calls so fix the
size parameter check in SBI SFENCE calls to cover #2 as well.

Fixes: 13acfec2dbcc ("RISC-V: KVM: Add remote HFENCE functions based on VCPU requests")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 5fbf3f94f1e8..9752d2ffff68 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -103,7 +103,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
-		if (cp->a2 == 0 && cp->a3 == 0)
+		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
 			kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
@@ -111,7 +111,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
-		if (cp->a2 == 0 && cp->a3 == 0)
+		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
 			kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
 						       hbase, hmask, cp->a4);
 		else
-- 
2.43.0


