Return-Path: <kvm+bounces-31861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 325CF9C8F8F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5D6E28B09B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727DD18E359;
	Thu, 14 Nov 2024 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FN9smk4z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C487418C326
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601137; cv=none; b=clOVWIIBksvYvkkErncL0yN2fRAGSXZGOkLhYNVYPJJqPtVseZoB+PYdGVX1kdFhlWcGYNIjW2lDJzM9Gm6bEzhMwC6An05/S38cKd6hxcF/q32EWoZp1MGo+f55KlFp+TdVmkQHniVrd+luk7DrHZZ5mLhD3+g7jdHZ+GlfhKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601137; c=relaxed/simple;
	bh=Eb4pr4WluxpATHyk/B5wEDuQM3N608Zzf1YYtlCp/dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQwkYnjmy+KfbgSxZKj8ewDOjnMtu0v6Nx8S2yxmi6nDQ8boCUZIDYgO01B6xp0BYj33lSt4MoECfhdgnc9ujQSBvofvzbPx0NRLKGmqanzaQhjD6soxVQFw6fiSUMkXCpGGpWApBLL+uoRjtE+VIKk+LbiX1GHw9fn8NsEWG4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FN9smk4z; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539f84907caso848309e87.3
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601134; x=1732205934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ro7v641M+HDwWifuZZcr9Q07sHhkgURxU5TLhKMU2Mo=;
        b=FN9smk4zEni5TTrZlNz/bPZesL1r0schg0VCtLsT1Ss0GKqYVMWxVIGZ9GDk/0oW6z
         +3pubecEYYIEauGVHH6c0p0d90Ri0lpSqstQ2dCTPAiKDRzRW1vLw5KijY1Ax8SP2XBQ
         qLp7rvt5OZhY8wpXRKOlNYGXMBdPoWokQ15lTpPt18RSbSXQeTGUMXtm9pu1ED+NNEqD
         EeNtDVRFBHnSs3AZbePAugFxVaYKqk+hePSCqG1ov1PwuqNcQuIl0UyflcLvf3GVzDT3
         LbP68PDi9bEpbDLcbfipe5GipoIt2cIVM9memB2NPIJHhHrtGWwcsrsKTytqqhCr5iQB
         ccHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601134; x=1732205934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ro7v641M+HDwWifuZZcr9Q07sHhkgURxU5TLhKMU2Mo=;
        b=aVY5xTu7Jiw3U8Z23Uhqy2BwjUOhwuiWLLJ+q4+ZhVt4nG/kJlwRN6xnEY7WA4H550
         GscP3leo2TFkxDvIbuLUJvALIAx195iNPD83i7i6CA0DqtHjZleH/QptON6TKJIrFBP4
         Q87V6zW9fyIk6o0pIq5697bSVYqhaTjhW4xJCztrgMnt/N7/1cuqS0GUnMISMjpEpDQp
         qqeht+YrL0vEzDgYlktG1F5d5Y1mDeHESdax1e05V6mw0W5HIuph+3/6STRz8kKsXKkS
         3jCCxQ+H29zzGJMepuKFG8HNmqVHe7Y+aOU7B8dBpfFx1eDStPSICjqUySf+pVV+O5Tq
         OHHw==
X-Forwarded-Encrypted: i=1; AJvYcCVkiIcCKKsAzLqKhkZGKsX9Z2A50R7WDgZAIV1aRv05QVAHWaNJ/HOlgTN5wgM+jEogMhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvkJgzK4VGAQYspqPpUeu7KgwGVgSERYfHmMF4RoUTbFUcMjKQ
	I+PGvpktNCsQHgyUAeHu7FwMn3LFMDHBDcfEooJxHhpwTYh5kFUioy70LyqhIHk=
X-Google-Smtp-Source: AGHT+IErvh7GZ5g5xv9y/mHNwbC72YxK/U2el7s2R5QBHLBxBaMXMwoD7jtczGtgvCVqx0SU+SjOAw==
X-Received: by 2002:a05:6512:baa:b0:53d:a34d:9faa with SMTP id 2adb3069b0e04-53da34da11emr2749757e87.45.1731601133876;
        Thu, 14 Nov 2024 08:18:53 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265e16sm28762605e9.12.2024.11.14.08.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:53 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 05/15] iommu/riscv: use data structure instead of individual values
Date: Thu, 14 Nov 2024 17:18:50 +0100
Message-ID: <20241114161845.502027-22-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zong Li <zong.li@sifive.com>

The parameter will be increased when we need to set up more
bit fields in the device context. Use a data structure to
wrap them up.

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 3fe4ceba8dd3..9d7945dc3c24 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1001,7 +1001,7 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
  * interim translation faults.
  */
 static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
-				     struct device *dev, u64 fsc, u64 ta)
+				     struct device *dev, struct riscv_iommu_dc *new_dc)
 {
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct riscv_iommu_dc *dc;
@@ -1035,10 +1035,10 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
 	for (i = 0; i < fwspec->num_ids; i++) {
 		dc = riscv_iommu_get_dc(iommu, fwspec->ids[i]);
 		tc = READ_ONCE(dc->tc);
-		tc |= ta & RISCV_IOMMU_DC_TC_V;
+		tc |= new_dc->ta & RISCV_IOMMU_DC_TC_V;
 
-		WRITE_ONCE(dc->fsc, fsc);
-		WRITE_ONCE(dc->ta, ta & RISCV_IOMMU_PC_TA_PSCID);
+		WRITE_ONCE(dc->fsc, new_dc->fsc);
+		WRITE_ONCE(dc->ta, new_dc->ta & RISCV_IOMMU_PC_TA_PSCID);
 		/* Update device context, write TC.V as the last step. */
 		dma_wmb();
 		WRITE_ONCE(dc->tc, tc);
@@ -1315,20 +1315,20 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
 	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
-	u64 fsc, ta;
+	struct riscv_iommu_dc dc = {0};
 
 	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
 		return -ENODEV;
 
-	fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
-	      FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
-	ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
-	     RISCV_IOMMU_PC_TA_V;
+	dc.fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
+		 FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
+	dc.ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
+			   RISCV_IOMMU_PC_TA_V;
 
 	if (riscv_iommu_bond_link(domain, dev))
 		return -ENOMEM;
 
-	riscv_iommu_iodir_update(iommu, dev, fsc, ta);
+	riscv_iommu_iodir_update(iommu, dev, &dc);
 	riscv_iommu_bond_unlink(info->domain, dev);
 	info->domain = domain;
 
@@ -1419,9 +1419,12 @@ static int riscv_iommu_attach_blocking_domain(struct iommu_domain *iommu_domain,
 {
 	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
 	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
+	struct riscv_iommu_dc dc = {0};
+
+	dc.fsc = RISCV_IOMMU_FSC_BARE;
 
 	/* Make device context invalid, translation requests will fault w/ #258 */
-	riscv_iommu_iodir_update(iommu, dev, RISCV_IOMMU_FSC_BARE, 0);
+	riscv_iommu_iodir_update(iommu, dev, &dc);
 	riscv_iommu_bond_unlink(info->domain, dev);
 	info->domain = NULL;
 
@@ -1440,8 +1443,12 @@ static int riscv_iommu_attach_identity_domain(struct iommu_domain *iommu_domain,
 {
 	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
 	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
+	struct riscv_iommu_dc dc = {0};
+
+	dc.fsc = RISCV_IOMMU_FSC_BARE;
+	dc.ta = RISCV_IOMMU_PC_TA_V;
 
-	riscv_iommu_iodir_update(iommu, dev, RISCV_IOMMU_FSC_BARE, RISCV_IOMMU_PC_TA_V);
+	riscv_iommu_iodir_update(iommu, dev, &dc);
 	riscv_iommu_bond_unlink(info->domain, dev);
 	info->domain = NULL;
 
-- 
2.47.0


