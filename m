Return-Path: <kvm+bounces-3648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8594B8063B3
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 218DEB2119A
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 00:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3922805;
	Wed,  6 Dec 2023 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PLT6jQt5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FE3181
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 16:55:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-286d6c9ce6dso1746883a91.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 16:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701824129; x=1702428929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=15PtUMzm1CCv273Hbndys2UZ7tBEJDNkUXj6E0nA6q4=;
        b=PLT6jQt5lBtDmJWR4zna9tUQ4t+9BOTp7P0puXIekVpNNheBUmvuxSUZis++584N/t
         C/3Qaw+g1XID+0W35ubYhPHzKCxaA/R9KZJOzRtJFWlC3O3udB17/xeyZe1OpnwhfpaQ
         uJCo6CFSDeobJENulyPsRIOwvn8u7B/btpp6FWiWGFkXcMUIvPWQFt8uQfHUJtiZUjQx
         1sp5jYSmMyQ8KY25zsqQSNBdQ813Qs7jpqil387poEI+bK3eBx1e7VFKqU9amrP6bxYZ
         Ll/+WdvHcEO7MQN83FRoTE2wJ6kwG++XZ/gL5SVHOtUnVD5RzNYzMfTN43iuQkAC24qa
         IgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701824129; x=1702428929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15PtUMzm1CCv273Hbndys2UZ7tBEJDNkUXj6E0nA6q4=;
        b=LJ/2rGHy4AAboHvDVYN3AjMxNs1trtDPuA+ob+/wEeghU7CZVO4/eWTQyHq8BgSwhU
         GS1aRQHRruejatgT8x47WeFRxl0qwDmYTSfV8GP2gj/dXSNlCSgREiQh9EuxvNtsSIZm
         MtoXh7cuwCHWONOOJVSEIO3vDeO1WAnxVLVbF68HTEhDX5XWqp3QirrJWMfPrtP294qu
         1RzgllU7Xo+lOCtQ3Q6MLsJyBBDuOKTVRWNXHyZhffdNjhgWQobKruWBEMBbzo9UepnF
         XoSQvAhY822rXoz9FUzDf0mLa9bBRNbOQ34E8Ae5bvieaVcR0gWMDBg/NEg1EHhBCp5a
         qZvA==
X-Gm-Message-State: AOJu0YzV0aTyt/UKLsLxMmBC6hyQbnm/+Ovv68oJyt8K9PmT1i1GgZvC
	7sBrV7qdneRLTcpBgnzNa/WXtQ==
X-Google-Smtp-Source: AGHT+IFJpvS0//lC+jQEm1CMudUH4oSrQdoEC3s358uWqkhMDqHOB/vWNoPmZGrDFAyrxtSODmf59g==
X-Received: by 2002:a17:90b:4d87:b0:286:c54a:a20d with SMTP id oj7-20020a17090b4d8700b00286c54aa20dmr166213pjb.21.1701824128923;
        Tue, 05 Dec 2023 16:55:28 -0800 (PST)
Received: from localhost.localdomain ([36.5.194.73])
        by smtp.gmail.com with ESMTPSA id z23-20020a17090a015700b00285be64e529sm6748897pje.39.2023.12.05.16.55.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Dec 2023 16:55:28 -0800 (PST)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	jean-philippe <jean-philippe@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux-foundation.org,
	kvm@vger.kernel.org,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
Date: Wed,  6 Dec 2023 08:55:17 +0800
Message-Id: <20231206005517.46005-1-zhangfei.gao@linaro.org>
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


