Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7924D3A9DBD
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhFPOkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 10:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhFPOk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 10:40:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F32DC061574
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 07:38:21 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a127so2366359pfa.10
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 07:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=oBV8BMNG17jQpDc2Z9mJ7iOyNaaQ3dbfVhC8dxppwpw=;
        b=GXj+LbmIzNStnKhQkl3zrV8ozqhhcrKqh7SvYRN6ctSmh0OzbK4OJ4eVJjvqLNH8lW
         XuRuwFNElrIdpEGQzkzTrpdfS0u/9MLOrpbkQfvfY+vAb8SLkNXedkRXfruOCdG63sjS
         0B8B9GstQDTdILpNy8/Jy9+kbsh1TwddlLAy0MYUrel7blvlnzahu6JHc4Oxumt4HE4/
         Ibzf45zrfTv3HexMT3BMtGyBhAVn4fGyNB3cKLYZKviRq1HYEovehFopeRNwOWoaY47M
         Npr+s5yg+NTo2R85+l+0rZJ0g/29En2tI1LtR1JQa3rKjkgpOOvNtZJ6WBcPGW9mgAV2
         4eLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oBV8BMNG17jQpDc2Z9mJ7iOyNaaQ3dbfVhC8dxppwpw=;
        b=AJZROJzrWNG+wV6pHNyyg9wH1x9fwBlIDbFj8gEjcB6YHvU2bpX5QBqmof3ws6JdAR
         W1adyVjEzFgB+ogzfEi31FFRJPuqPK5auqtnAa2yDCm9Tr1eoqhe8G6+nkzDxyyy2Fq7
         XRG0kPlmGspeNZZOAD4XsZUFiAepYFvG2LaqbJZT1nAHarF0pb68atxzVFweoTebnTnL
         NlF9blvT9ODUqjAo4bsN/OVfSYAqQTpf3ul8VJl3lr5jmjPNZcyXIBerc9/hrl+Gnwwq
         z1PlO1yXGDcVsullUhr0V5wVpTMBQm2iB64HGlRZUSjCjHOiWC4hH+islwEpXWV0FcDo
         fSfQ==
X-Gm-Message-State: AOAM532dlY8qd4ouH2cBcAdS16BbNwOwlj9SXJtUAFiloOtfmcbhnPXI
        jaMKqFgARzx1KL7TK56945Uxww==
X-Google-Smtp-Source: ABdhPJwXVpPd88OHpJz/W5LE8otngNl59ImAIj0cVI1N3R15at/MbzFshEuQOZC+FS2/rPO4fk0/oQ==
X-Received: by 2002:a63:f955:: with SMTP id q21mr5348896pgk.448.1623854298753;
        Wed, 16 Jun 2021 07:38:18 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.116])
        by smtp.gmail.com with ESMTPSA id d15sm2473084pfd.35.2021.06.16.07.38.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jun 2021 07:38:18 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Auger Eric <eric.auger@redhat.com>,
        jean-philippe <jean-philippe@linaro.org>
Cc:     iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [RFC PATCH] iommu: add domain->nested
Date:   Wed, 16 Jun 2021 22:38:02 +0800
Message-Id: <1623854282-26121-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add domain->nested to decide whether domain is in nesting mode,
since attr DOMAIN_ATTR_NESTING is removed in the patches:
7876a83 iommu: remove iommu_domain_{get,set}_attr
7e14754 iommu: remove DOMAIN_ATTR_NESTING

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---

Nesting info is still required for vsva according to
https://patchwork.kernel.org/project/linux-arm-kernel/patch/20210301084257.945454-16-hch@lst.de/

 drivers/iommu/iommu.c | 8 +++++++-
 include/linux/iommu.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 808ab70..ba26ad0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2684,11 +2684,17 @@ core_initcall(iommu_init);
 
 int iommu_enable_nesting(struct iommu_domain *domain)
 {
+	int ret;
+
 	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
 		return -EINVAL;
 	if (!domain->ops->enable_nesting)
 		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
+	ret = domain->ops->enable_nesting(domain);
+	if (!ret)
+		domain->nested = 1;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_enable_nesting);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 32d4480..179f849 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -87,6 +87,7 @@ struct iommu_domain {
 	void *handler_token;
 	struct iommu_domain_geometry geometry;
 	void *iova_cookie;
+	int nested;
 };
 
 enum iommu_cap {
-- 
2.7.4

