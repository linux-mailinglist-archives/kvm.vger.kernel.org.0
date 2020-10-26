Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E87298B0B
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 12:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772838AbgJZK6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 06:58:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40927 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1772802AbgJZK6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 06:58:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id k18so11940611wmj.5
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 03:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hp7lChw6Uow+58XPniSHemIeAoNErbB/sdK6im80Iug=;
        b=Cr+pmJXJLsWocfKRIRa/5RHLA7hSR2O/V8a+9H+OfOBLfntuyYXq0XvJAi9z0VTfHT
         o6muhLbGVgMDDFHz7pi7g0wbMI0xim0wkiLglb6gq1U7avKTlbLZaGt6brXdeBhZPYiG
         7tcXzotmBBEhyDhg4r894G/MEQ31CzKNdntL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hp7lChw6Uow+58XPniSHemIeAoNErbB/sdK6im80Iug=;
        b=MA6tLT40GHeosIQzBymnXFcjKU6p2n7UH8wWPXPGEZqWWppUb7Fy5NpNiIwAv9OIRV
         xsQx05gyt6fuTAp622SEBVhfqZG/W0xa0ae1DlLW7DWFLC/tyyyEvwVrS3WMs1ZeDp2s
         rwKgtzAE8N4CcTq3eVTcgBRFIZD3/5bAVjJu+3RAeisnI+vHueBQ6YlV+8tyXY4qobiD
         p1OIJYIdVM2Lr6GOWC8Z54eS4YWicsNgQ2Hkv8ksM+h7Yhfpudr1cfxUBRyJXxbaGvGb
         dAnpN7h8xY1QK7w4EshebbQaeumtDyIMvFVtU6puqsF+5K8Z14TmhIhDqY6f9CtN0alC
         uJqA==
X-Gm-Message-State: AOAM5322aNIOo79gj5DEPO/ivwbHE4qUoDsFnFfzjS1JnMz33mP1FErK
        dkbv1Ri+a3LxOUGUw6Z2IbsFPAbon+K36OZR
X-Google-Smtp-Source: ABdhPJyXE1xnVL9rMrbjHo2QW8UsY5WSv6Qb5ykdefmn1P9qttdIUjS9wMyJqMVtlrB26EUB1SiNdg==
X-Received: by 2002:a05:600c:25a:: with SMTP id 26mr14957501wmj.39.1603709919599;
        Mon, 26 Oct 2020 03:58:39 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id w83sm21165156wmg.48.2020.10.26.03.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:58:38 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
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
Subject: [PATCH v4 10/15] vfio/type1: Mark follow_pfn as unsafe
Date:   Mon, 26 Oct 2020 11:58:13 +0100
Message-Id: <20201026105818.2585306-11-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
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
index 5fbf0c1f7433..a4d53f3d0a35 100644
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
2.28.0

