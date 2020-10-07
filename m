Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030D2286528
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgJGQqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgJGQoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:44:39 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5426C0613DA
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:44:36 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p15so3041636wmi.4
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xCribZCwI3aUgI2eueSnhSAx0iK7WRTlleTX9tsbcR8=;
        b=AEi0JhgJ/wano87gBRhR1tEZu/2EKduKDu6Ltn89c4up88D2DvP8uOVpNqsDXBFtnE
         uBotxUV1Gtcupqn+vwnQ//qkEuBYFfn9hAA4wfcNAvQjAmgdjCuFhd1GGP6T/Ewlm2E/
         JGXPzVAxru77FUj56UyGwJmL4Ut534V3QbOHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xCribZCwI3aUgI2eueSnhSAx0iK7WRTlleTX9tsbcR8=;
        b=fgOHo4QsX35bCt+/Ul6JDmc32K1Ek8aGCvcuiotQylQ0/ftQKVrYdmy+/RGvk7NThH
         8VUZOe53RdKpCuZUemJ/urHYZwV+tAH8U4FEXRb1oMHl7VNhtD4lmCpqcr3O3rhMdzAP
         50hX/EB4XXGsB5ok1ZDIS898acA5OGoDpiKl+R5GtA3jHUZLLlhpYfMuhHIvdZjSKAxI
         yXsd5/Itk4bcCTtheSx6EMo6J17ZmtEhHpkmP5+HKmq3XvqEoYw7pfnjL32FSuRerKOS
         hzlQnPD6B3yIG2Eh9rnZmT/h1zQjk4ZDMCRq87AO8x+SzfZ71Xx3AKIpO5YRQ+nvXxlx
         7u/g==
X-Gm-Message-State: AOAM5305mAYjNOixuB/ZVbFsLX3iFIDhtWKL+4XYBWqpgiEudh20zKGR
        bSaikvwQsgfSEVdiOwJT/+TNOg==
X-Google-Smtp-Source: ABdhPJyKKkQ5Sn3LlEIAOp+pYCQMLBXLV3Rqf2bnTEOKXc6oZdqFUt1FUSyG1jw/hndeOdOxOW/8zw==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr4194920wma.70.1602089075637;
        Wed, 07 Oct 2020 09:44:35 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z191sm3332280wme.40.2020.10.07.09.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:44:35 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 02/13] drm/exynos: Use FOLL_LONGTERM for g2d cmdlists
Date:   Wed,  7 Oct 2020 18:44:15 +0200
Message-Id: <20201007164426.1812530-3-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The exynos g2d interface is very unusual, but it looks like the
userptr objects are persistent. Hence they need FOLL_LONGTERM.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index c83f6faac9de..514fd000feb1 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -478,7 +478,8 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct g2d_data *g2d,
 		goto err_free;
 	}
 
-	ret = pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
+	ret = pin_user_pages_fast(start, npages,
+				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
 				  g2d_userptr->pages);
 	if (ret != npages) {
 		DRM_DEV_ERROR(g2d->dev,
-- 
2.28.0

