Return-Path: <kvm+bounces-58330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BEFB8D10D
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8937E7B4967
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF842E1F06;
	Sat, 20 Sep 2025 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Se3l/gSg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3312D9492
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400749; cv=none; b=HKx+ie2hVWtSY8bxN3for1v2IWxOA4P2/2sOAdtY9l8kYHWSiUd73aGQ0rPE+L0Ts4vbLYNof2jw2YNXr50/jSNkhOo7ku7GRaChUr5hcnBvW2MVzrKnNCcLZbZe7SjLRD72CC8HfhmvxEZ2/6HrMLdHUJPAxPrW70LQ53tgJjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400749; c=relaxed/simple;
	bh=tTMgpRJRAH5vDgnhSX3ZRgd44nfq1rpFBPS4f/QxglI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS01nj5YJHpUAl4OpcdvwzwSEuzT6q711tUms6o6YooJIDMYTlCtNib4MiN+HPtsoRBPvor/Qq6cIvexg0zS4K+G403s1f80iMGeD5my6wTeLhGP75lamT74DeE01OpzhhKQBGLeE7ZVbInc1b372TuD6/m8aWBdCMh2JhtCFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Se3l/gSg; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-4256f499013so2189965ab.1
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400745; x=1759005545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfEiik7U1UfCLLRy1SfBX6A4ZldZkp0tuNOLkoczFfo=;
        b=Se3l/gSglcRTnjswM51KDYs2LchjfnohP1LsfbGyVgnl1+ZN9ThEfHCDobmES1cEs8
         8pyLiJmhKRbxRolXIZuEd8oUnZB/G81ipSIpr4jddGiwAJHT+uBXSC5WGSoJlB+eM0Je
         Yh6mG9UbhpkZeSwk6XDRfCaHHUWE/iIJkU9kRVb25rZkwY8wr4Nzw6tyL9kmRWB3hMZ1
         OxRcRC3GEJViZP1PTm89MMaXziG6KKApbrITMvqpGVbXT56QUhPtF1DbTOZd2LcGcSZ8
         jeuubM5YfE8BfQW79Gg0mgelD6a44009n0O5p+O6DNK7fpGIwQxAMKXX8opKBzofU4O2
         4CMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400745; x=1759005545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfEiik7U1UfCLLRy1SfBX6A4ZldZkp0tuNOLkoczFfo=;
        b=R0axnunt6YA1/Qm2UyZ+kIAlKBphiazhcuVHfVekarzyOR/tDs8fZo9kWnkX5+ZE0A
         ps0H2rJhXcEIMtkb74GbPM0rqTSXAs/k/Ji3JLaMtEqbodK/LicsgUuJqzL7c/Mev/xB
         wqp9qTraSFV5yXq3T0Fl9DgVmPVJTGUMeqGEUi09U4Gbz6yunohmhPqmOQDh/B1esMuY
         owgN6LpGtlNv/1Jt41oT2t72YZcQc/W7/4cH3lKSwwuLmmXpJ9N3A/6qyxvaY/KMolvC
         vXdxNuIYAOTNrLlNfnoCUcjAJnHZofIdfyETqYJubldSZWS9bZR4lQNDc1qJhUDsCg0z
         xQqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGAxJyvuDohlIORWcxeW1ezSRWX3zxipS5OPhH/KZb7sBSFwivV77twoYw2PKGyJ3JQ78=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK7v723xYmmWusHrNMqtiwlVAHwMjRJPeD9D11afcGL0K4ct+O
	9MiKHOpR0cGp/3QMF9JtoDUgIDjvizYwXpwtJcWdGGhp8mNFUmqR5NHt6uBmXNne5J8=
X-Gm-Gg: ASbGncth+FS0DxKFZQiQMGnUMHkVAQ8Jwpg+QQd3/i5ABfpczMuGdhmcxqM7ymtPyr7
	rzrVgIAdgGHeKJSVyDCQUuDymMsG8dbSnGiGyinkCLCDrpjaELwaAKLvogEJURlmcXVaYbqLq0R
	jaVIAAl5AExJksHsQQ8+R5gXYG6HsSsFdxFFSdwDdHA1EJSla2FH0nrLxIp9FrLp7LRa/pswmkh
	bB4pUDfBoSsWiIwlrctp9YHlaJWd//WBL9ad3HR7ZZDCVSsPTnCpnXt2DJmJGps5fT+nq/fdS1m
	pOkISa1o/4a8vN4d8xkOCEVRYLOBAFRH9lWSGh5nz6aB5a395W+Kw1PHycg8KjGglUmxYcNAPXH
	sZGoOmLQHbDIF5KGCeV0ZkKN/
X-Google-Smtp-Source: AGHT+IE581P0AkyphXbszugWZqZNJhwWmOr5TRI9ATozw6M+qkg0V/7BRnonU41e1GD3hHsR2JSR+w==
X-Received: by 2002:a05:6e02:1b09:b0:424:69b:e8bb with SMTP id e9e14a558f8ab-42481936b23mr116504325ab.9.1758400745560;
        Sat, 20 Sep 2025 13:39:05 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3a590fcfsm3682210173.11.2025.09.20.13.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:05 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com,
	zong.li@sifive.com,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	alex@ghiti.fr
Subject: [RFC PATCH v2 10/18] RISC-V: Define irqbypass vcpu_info
Date: Sat, 20 Sep 2025 15:39:00 -0500
Message-ID: <20250920203851.2205115-30-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920203851.2205115-20-ajones@ventanamicro.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vcpu_info parameter to irq_set_vcpu_affinity() effectively
defines an arch specific IOMMU <=> hypervisor protocol. Provide
a definition for the RISCV IOMMU.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/irq.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/include/asm/irq.h b/arch/riscv/include/asm/irq.h
index 59c975f750c9..27ff169d1b77 100644
--- a/arch/riscv/include/asm/irq.h
+++ b/arch/riscv/include/asm/irq.h
@@ -25,6 +25,15 @@ struct fwnode_handle *riscv_get_intc_hwnode(void);
 int riscv_get_hart_index(struct fwnode_handle *fwnode, u32 logical_index,
 			 u32 *hart_index);
 
+struct riscv_iommu_ir_vcpu_info {
+	u64 gpa;
+	u64 hpa;
+	u64 msi_addr_mask;
+	u64 msi_addr_pattern;
+	u32 group_index_bits;
+	u32 group_index_shift;
+};
+
 #ifdef CONFIG_ACPI
 
 enum riscv_irqchip_type {
-- 
2.49.0


