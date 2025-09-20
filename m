Return-Path: <kvm+bounces-58331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A142B8D110
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 040A31B26D44
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE57B2E1EFD;
	Sat, 20 Sep 2025 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hyVqy17M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEDF2DFF19
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400749; cv=none; b=Pnn673MV8uf8S97tfqNpoyROuPQ7bkJVwHrT6a9SzEal0JpCjN8HuKlAvXfFHuPLUdYS8w2PgM+QczSKzav9ULPCgm5rckQFdw9mKCI+fnHPSqpaTLT5lr/HJl/7CaleP5ykD0mkYk3l5Cr690Xl7JLfg+Q63rk8XkSSw9Y+XQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400749; c=relaxed/simple;
	bh=L4Ep+IlxKlKfQcYtfM7Ox88ty3BpmqbADwu0iQdcKxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/3ONb0W56ypoqstafQBWrx6mJKSZfnHQPhyR+nzDVd9XdGC+SVtJzBnwUMXykc36cuQC5r1EcObOuNK7GNchthX19ee6se+LqBiHP/riwS0RRavVvpBo1/Sn+prMFfqE5vkOGQ735r5ZhU91/1DAAWRrsTsZvQOMTGfBOscfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=hyVqy17M; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-424081ae9f2so14537255ab.0
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400747; x=1759005547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLOgLIfPePBzUWNKI9OUk1ZH4Tzzj3tfMuaJlKPwZCo=;
        b=hyVqy17MBgMMZ8I/dHzoK9xAOziNo0FckFXDRTvkuaehre9j8ybyUll9eNL+TvF7Kw
         kT0wZhzNyaHzMfxYBZFZ3I9xFUJlDx7mU6K0QKC0E945bW37WLOEnXD5EjADpKhEf4gR
         ERiKQTwWUVgrrYiXQwmBDJa4e7nJzeS9FsN8f8OvrK36ceTFELI4DefOPgIcrqovKVSp
         ywusVJyaHgUWYIO6tujfHNql5w9vDtkFsVmK4kIKzB781rmLT2TB0qL0CSmzZ5cBXBx8
         szkTZmEehjD+IeGPOtehiCr+DA6ZB6fGD+NnT4+Y5NCkmzyTy7jVfYfjf+CbAzAVBKs5
         Tq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400747; x=1759005547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qLOgLIfPePBzUWNKI9OUk1ZH4Tzzj3tfMuaJlKPwZCo=;
        b=dh3hF6gvCWG4IP5jeIxT9x4jdwirgX7i40Hdt7DxRqgHlYOO+n2d8nibH3Nqnju9G8
         xf0PddXrQXZDVFjCeTYiCOSbYpmwHB/m+4h9mU9tOLnKwtqNiHZhPSju6PXN1WiHv8Ex
         E//LZbXdL7Rfmqxl2yzcWgROjnbdR0ANmqXtrSdpbyDa5CRvnRTyFxY+0xYsRZM5l+Q7
         SsnHnFeQrr6eZOCho+nC+l8i6kMsoUKt27PmQKTN8Ddu9HUXQpidcWNdYo94LooBMkgW
         KA5tkngz2ZI3ILBySoA5QM2ogrNO3xYIX5jumTX8IuZTiXfif8y+2ipH1DoKYqkRLfqY
         p5wA==
X-Forwarded-Encrypted: i=1; AJvYcCXYX2PG3UlTlVTEqocezK1ia8eatXFLaLjTKb/BLe6RtAK/kMNOn4dzOKV8bW6zqLvY7y4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5YgWgazFW4D1CUUG+awTSIDtey0i9d4OF/zOzPujKmWl1IrFK
	LbUPAx1Fnn6EfzYZFIdr5tWlHRP/Un69r9zz0446hXccrWIIP8WNjRoStV1jle0Dg60=
X-Gm-Gg: ASbGnctJHIwyY+aYQLRWA+hie/LkBuWZqm5JggvXEJj30c8ZTt3wFoUmvFZeMQ3POAF
	t/PhfbpKGpkjlOFMZQ3P/JTsYga5PsRvnL7fllLWfACbGFNCMHY7ywYCYict0Q9osw8fp5mUDjh
	IaDQEYu2VLkZFfszlLWMaQrnNhLlywHtwEEyc0rq1l5DAbkHTtXBIm3GXMinyXXvyU20C8vsdyD
	OUduqJbgz9kahShRzYi6YnbRD1Hl3KzFcfuZIJhbPdKgin2Tl5gshGVfdIr0Gqzrh897jO/zPzF
	O3P75Bw67F+p5coXHcHk1DE3NSJ3KffedTjRgQiCGi+9ZE8DKI8xnuIr9SJ6aQ+x0LAjYQ7QcvL
	zBJ59u4E7IT09xL7UsmoxBmBE
X-Google-Smtp-Source: AGHT+IEWlWgkYSGO8sbLjeEJVsqweL0Gl+KFRCXKq/6gJAMJHxAY6N4lyWxDMwaZbg9QR7K4TJrpzg==
X-Received: by 2002:a05:6e02:1a64:b0:423:5293:5739 with SMTP id e9e14a558f8ab-424819748bamr113626355ab.19.1758400746834;
        Sat, 20 Sep 2025 13:39:06 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244a4938b4sm38308745ab.11.2025.09.20.13.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:06 -0700 (PDT)
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
Subject: [RFC PATCH v2 11/18] iommu/riscv: Maintain each irq msitbl index with chip data
Date: Sat, 20 Sep 2025 15:39:01 -0500
Message-ID: <20250920203851.2205115-31-ajones@ventanamicro.com>
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

Track each IRQ's MSI table index in the IRQ's chip data of the IR
irqdomain along with a generation number. This will be necessary
when support for irq-set-vcpu-affinity is added as the msitbl
configuration will change to match the guest. When a configuration
changes then it may no longer be possible to compute the index from
the target address, hence the need to stash it. Also, if an allocated
IRQ is not mapped with irq-set-vcpu-affinity after a configuration
change (which will unmap everything), then we need to avoid
attempting to unmap it at free-irqs time.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu-ir.c | 75 +++++++++++++++++++++++++++++-----
 drivers/iommu/riscv/iommu.h    |  1 +
 2 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-ir.c b/drivers/iommu/riscv/iommu-ir.c
index b97768cac4be..059671f18267 100644
--- a/drivers/iommu/riscv/iommu-ir.c
+++ b/drivers/iommu/riscv/iommu-ir.c
@@ -164,11 +164,42 @@ static void riscv_iommu_ir_msitbl_inval(struct riscv_iommu_domain *domain,
 	rcu_read_unlock();
 }
 
-static void riscv_iommu_ir_msitbl_map(struct riscv_iommu_domain *domain, size_t idx,
-				      phys_addr_t addr)
+struct riscv_iommu_ir_chip_data {
+	size_t idx;
+	u32 config;
+};
+
+static size_t riscv_iommu_ir_irq_msitbl_idx(struct irq_data *data)
+{
+	struct riscv_iommu_ir_chip_data *chip_data = irq_data_get_irq_chip_data(data);
+
+	return chip_data->idx;
+}
+
+static u32 riscv_iommu_ir_irq_msitbl_config(struct irq_data *data)
+{
+	struct riscv_iommu_ir_chip_data *chip_data = irq_data_get_irq_chip_data(data);
+
+	return chip_data->config;
+}
+
+static void riscv_iommu_ir_irq_set_msitbl_info(struct irq_data *data,
+					       size_t idx, u32 config)
+{
+	struct riscv_iommu_ir_chip_data *chip_data = irq_data_get_irq_chip_data(data);
+
+	chip_data->idx = idx;
+	chip_data->config = config;
+}
+
+static void riscv_iommu_ir_msitbl_map(struct riscv_iommu_domain *domain,
+				      struct irq_data *data,
+				      size_t idx, phys_addr_t addr)
 {
 	struct riscv_iommu_msipte *pte;
 
+	riscv_iommu_ir_irq_set_msitbl_info(data, idx, domain->msitbl_config);
+
 	if (!domain->msi_root)
 		return;
 
@@ -186,9 +217,17 @@ static void riscv_iommu_ir_msitbl_map(struct riscv_iommu_domain *domain, size_t
 	}
 }
 
-static void riscv_iommu_ir_msitbl_unmap(struct riscv_iommu_domain *domain, size_t idx)
+static void riscv_iommu_ir_msitbl_unmap(struct riscv_iommu_domain *domain,
+					struct irq_data *data, size_t idx)
 {
 	struct riscv_iommu_msipte *pte;
+	u32 config;
+
+	config = riscv_iommu_ir_irq_msitbl_config(data);
+	riscv_iommu_ir_irq_set_msitbl_info(data, -1, -1);
+
+	if (WARN_ON_ONCE(config != domain->msitbl_config))
+		return;
 
 	if (!domain->msi_root)
 		return;
@@ -219,11 +258,11 @@ static int riscv_iommu_ir_irq_set_affinity(struct irq_data *data,
 {
 	struct riscv_iommu_info *info = data->domain->host_data;
 	struct riscv_iommu_domain *domain = info->domain;
-	phys_addr_t old_addr, new_addr;
 	size_t old_idx, new_idx;
+	phys_addr_t new_addr;
 	int ret;
 
-	old_idx = riscv_iommu_ir_get_msipte_idx_from_target(domain, data, &old_addr);
+	old_idx = riscv_iommu_ir_irq_msitbl_idx(data);
 
 	ret = irq_chip_set_affinity_parent(data, dest, force);
 	if (ret < 0)
@@ -234,8 +273,8 @@ static int riscv_iommu_ir_irq_set_affinity(struct irq_data *data,
 	if (new_idx == old_idx)
 		return ret;
 
-	riscv_iommu_ir_msitbl_unmap(domain, old_idx);
-	riscv_iommu_ir_msitbl_map(domain, new_idx, new_addr);
+	riscv_iommu_ir_msitbl_unmap(domain, data, old_idx);
+	riscv_iommu_ir_msitbl_map(domain, data, new_idx, new_addr);
 
 	return ret;
 }
@@ -254,11 +293,16 @@ static int riscv_iommu_ir_irq_domain_alloc_irqs(struct irq_domain *irqdomain,
 {
 	struct riscv_iommu_info *info = irqdomain->host_data;
 	struct riscv_iommu_domain *domain = info->domain;
+	struct riscv_iommu_ir_chip_data *chip_data;
 	struct irq_data *data;
 	phys_addr_t addr;
 	size_t idx;
 	int i, ret;
 
+	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL_ACCOUNT);
+	if (!chip_data)
+		return -ENOMEM;
+
 	ret = irq_domain_alloc_irqs_parent(irqdomain, irq_base, nr_irqs, arg);
 	if (ret)
 		return ret;
@@ -266,8 +310,9 @@ static int riscv_iommu_ir_irq_domain_alloc_irqs(struct irq_domain *irqdomain,
 	for (i = 0; i < nr_irqs; i++) {
 		data = irq_domain_get_irq_data(irqdomain, irq_base + i);
 		data->chip = &riscv_iommu_ir_irq_chip;
+		data->chip_data = chip_data;
 		idx = riscv_iommu_ir_get_msipte_idx_from_target(domain, data, &addr);
-		riscv_iommu_ir_msitbl_map(domain, idx, addr);
+		riscv_iommu_ir_msitbl_map(domain, data, idx, addr);
 	}
 
 	return 0;
@@ -280,14 +325,22 @@ static void riscv_iommu_ir_irq_domain_free_irqs(struct irq_domain *irqdomain,
 	struct riscv_iommu_info *info = irqdomain->host_data;
 	struct riscv_iommu_domain *domain = info->domain;
 	struct irq_data *data;
-	phys_addr_t addr;
+	u32 config;
 	size_t idx;
 	int i;
 
 	for (i = 0; i < nr_irqs; i++) {
 		data = irq_domain_get_irq_data(irqdomain, irq_base + i);
-		idx = riscv_iommu_ir_get_msipte_idx_from_target(domain, data, &addr);
-		riscv_iommu_ir_msitbl_unmap(domain, idx);
+		config = riscv_iommu_ir_irq_msitbl_config(data);
+		/*
+		 * Only irqs with matching config versions need to be unmapped here
+		 * since config changes will unmap everything.
+		 */
+		if (config == domain->msitbl_config) {
+			idx = riscv_iommu_ir_irq_msitbl_idx(data);
+			riscv_iommu_ir_msitbl_unmap(domain, data, idx);
+		}
+		kfree(data->chip_data);
 	}
 
 	irq_domain_free_irqs_parent(irqdomain, irq_base, nr_irqs);
diff --git a/drivers/iommu/riscv/iommu.h b/drivers/iommu/riscv/iommu.h
index aeb5642f003c..130f82e8392a 100644
--- a/drivers/iommu/riscv/iommu.h
+++ b/drivers/iommu/riscv/iommu.h
@@ -36,6 +36,7 @@ struct riscv_iommu_domain {
 	struct riscv_iommu_msipte *msi_root;
 	refcount_t *msi_pte_counts;
 	raw_spinlock_t msi_lock;
+	u32 msitbl_config;
 	u64 msi_addr_mask;
 	u64 msi_addr_pattern;
 	u32 group_index_bits;
-- 
2.49.0


