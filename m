Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DC52C69D5
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbgK0QmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731915AbgK0QmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 11:42:21 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C02C061A51
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:19 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id m6so6195296wrg.7
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r9CpIi9VXsG+zuZeNFc6wtzpnBA/KWk/gpfUTZT1Zjk=;
        b=QYSE9ahtLKl5EGqlS1wxqny1lcMayoTshiQPV4fpDlmhPBNcviZXZr4Hw/D0VvV1nZ
         SlhSkjL1LPH6m8vp1Ns0BA38yTfYlhhdthl3ANf0Zfah59++5CuB09/jCSZWOACnz6YY
         w3HN6kMl99DtY/VTvVNMApS0itb5pUGMEw+wM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r9CpIi9VXsG+zuZeNFc6wtzpnBA/KWk/gpfUTZT1Zjk=;
        b=V04GzDzPzRV2iy77hrQXm0vzDvb33iuXw5nK9CIVBbId/12k33u/KNQu8LdXXFAs81
         ueh9sn4mMfNV+OhnVsvIIMtmIE1NnSgIO86c8H1lucA2yrEMCdjiWf4hSzsTotgmAZH/
         B1NeA40JfR5FOH67bMmM37gcC+47jk+9U7B7m4oOy8PqrQcSgSzx58oYXjUCEsrQyX89
         m3Qv1r9QgPeJ/khvY9CMOv/e+lcGf+ysOU6W0Rb//17qoMxEWdVVnkW/Tja8vriDLXir
         wj9cDjm+kPceVbsQ7EmS1frU0j6XxHXLtO8eRp2t0mepej6dT4XOYKvrDQm0Fg2eo4gm
         acdA==
X-Gm-Message-State: AOAM5333Mv38wJSAyhD1nOglD3jwToGkBWtwG85MZwW6409iHBIm/BNM
        8LfuI+wM1fmEfxOFWJS9Dda67g==
X-Google-Smtp-Source: ABdhPJwcuwkwTEGjFtq/EaV85N+PVRZBWU4U/IYqc96jNDCQ+Wh7QXU+d6PyrzBG7/osel2wfk3tIQ==
X-Received: by 2002:a5d:5651:: with SMTP id j17mr11831109wrw.221.1606495337823;
        Fri, 27 Nov 2020 08:42:17 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q12sm14859078wrx.86.2020.11.27.08.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:42:17 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v7 15/17] vfio/type1: Mark follow_pfn as unsafe
Date:   Fri, 27 Nov 2020 17:41:29 +0100
Message-Id: <20201127164131.2244124-16-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code seems to stuff these pfns into iommu pts (or something like
that, I didn't follow), but there's no mmu_notifier to ensure that
access is synchronized with pte updates.

Hence mark these as unsafe. This means that with
CONFIG_STRICT_FOLLOW_PFN, these will be rejected.

Real fix is to wire up an mmu_notifier ... somehow. Probably means any
invalidate is a fatal fault for this vfio device, but then this
shouldn't ever happen if userspace is reasonable.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/vfio/vfio_iommu_type1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 67e827638995..10170723bb58 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -421,7 +421,7 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 {
 	int ret;
 
-	ret = follow_pfn(vma, vaddr, pfn);
+	ret = unsafe_follow_pfn(vma, vaddr, pfn);
 	if (ret) {
 		bool unlocked = false;
 
@@ -435,7 +435,7 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
-		ret = follow_pfn(vma, vaddr, pfn);
+		ret = unsafe_follow_pfn(vma, vaddr, pfn);
 	}
 
 	return ret;
-- 
2.29.2

