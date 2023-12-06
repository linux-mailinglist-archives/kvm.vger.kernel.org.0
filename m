Return-Path: <kvm+bounces-3649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AB38063C7
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D4B21F2175E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 00:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3D7EBB;
	Wed,  6 Dec 2023 00:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zzdzN9X0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E641BC
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 16:57:37 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3b2e330033fso3691232b6e.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 16:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701824257; x=1702429057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=15PtUMzm1CCv273Hbndys2UZ7tBEJDNkUXj6E0nA6q4=;
        b=zzdzN9X0wYgI7bU788cMONfZeYWGQdoZixtZQTFRKPuZlWy1Evsad3idByUApFqjo+
         grH6fsjW6WnqzXgwhevN5SPB1Sp5cNLo+8EXEI8p9btiDOwj5AYOTTDT4LZR0d9PvQhP
         W79ht6sK/V2c0/fUfxL6NU5VlRc6VOg71e9+Ina5yV6d8A9Ufwd69xUdsaGUtJcsL3xE
         Ixrz5PybaF//fw3yrwQXIt/VuAaKefeNCT2ySVvNfh+hsK/EBvpENY+tdbHzukiFBGK2
         QuUh9Mr7MXwmEwFyaKQt1AHPnTqbREdoy8oHyPeo4aqqJuEiRlzGCi1cQe1Lb1mGyoUk
         QaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701824257; x=1702429057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15PtUMzm1CCv273Hbndys2UZ7tBEJDNkUXj6E0nA6q4=;
        b=vJYqEh7GIBeWrpqWg3U+aMdkU3a0PTWusf0CmzoklGnEbuSGsSyXxSBSwxOx6XCj2b
         8TWqRhuZQK8ogHo1Gxsb0dMCeZxRr7i+xxXy/Fbya/4oLavmobbi4RGWoswFjxPNem8r
         PrFGAT/pvPPeW6g5PD69VqO/eFVW99eEogN5WTHN4ppO0SflT2Zv+8ETSzgVhKo1tOED
         6hERI4gve/hXDCla4NpNG81mf0/mC6DDCDx0r/eBoyswkgCsqmltS60Q4onTTd3Ik7IU
         PLY9Y4jg5pfrYv6WJjBUSoz6qU9So6GtqJDQCR5Ks6KO00rM60VdJpDry5rsQf4NGIbx
         eeCA==
X-Gm-Message-State: AOJu0Yzc/wsn4HSxegKS9te0tNN8+/gFe3Ejwh4G7ja0AuA/HtdDHuYi
	p589979oR4WwbX2mMuDdWgtdA0jyrlYEUVtiCjSGvHD+
X-Google-Smtp-Source: AGHT+IE5ulwG4V0s2m8jeafUFyOjHpVi+hGh+noPkhcaG114A6cDiNvh20aA9d+SEUvHswrSwKpRqQ==
X-Received: by 2002:a05:6808:319b:b0:3b8:b063:6bb8 with SMTP id cd27-20020a056808319b00b003b8b0636bb8mr185810oib.103.1701824256810;
        Tue, 05 Dec 2023 16:57:36 -0800 (PST)
Received: from localhost.localdomain ([36.5.194.73])
        by smtp.gmail.com with ESMTPSA id fe18-20020a056a002f1200b006cddecbf432sm3569583pfb.96.2023.12.05.16.57.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Dec 2023 16:57:36 -0800 (PST)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	jean-philippe <jean-philippe@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
Date: Wed,  6 Dec 2023 08:57:27 +0800
Message-Id: <20231206005727.46150-1-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wenkai Lin <linwenkai6@hisilicon.com>

In the stall model, invalid transactions were expected to be
stalled and aborted by the IOPF handler.

However, when killing a test case with a huge amount of data, the
accelerator streamline can not stop until all data is consumed
even if the page fault handler reports errors. As a result, the
kill may take a long time, about 10 seconds with numerous iopf
interrupts.

So disable stall for quiet_cd in the non-force stall model, since
force stall model (STALL_MODEL==0b10) requires CD.S must be 1.

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7445454c2af2..7086e5fa41ff 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1063,6 +1063,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	bool cd_live;
 	__le64 *cdptr;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
+	struct arm_smmu_device *smmu = master->smmu;
 
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
@@ -1077,6 +1078,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (!cd) { /* (5) */
 		val = 0;
 	} else if (cd == &quiet_cd) { /* (4) */
+		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
+			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
 		val |= CTXDESC_CD_0_TCR_EPD0;
 	} else if (cd_live) { /* (3) */
 		val &= ~CTXDESC_CD_0_ASID;
-- 
2.39.3 (Apple Git-145)


