Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319EC2A024C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 11:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgJ3KI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 06:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgJ3KIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 06:08:55 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B531C0613D4
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p22so2305121wmg.3
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oGBzVmmcnUwoCpcjwMRu//j69ndtXtCP0NS2ElhXzwU=;
        b=ddb3ur1/6UNkfQr4L91EGkmgAJ2WFlh64b3krQrxHdXICPqGD1U7KSjV8mliOcYT2T
         IQK1rF0Fay6IRnqi6Z1rjQW4mkT8UrxQsAja5X4I4Zb0BD7E8rZgI9L3j1sWoJXQiFP2
         XQzGN/xa46QCrVP1PNnx5Jw7AGsn+9JT27UuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oGBzVmmcnUwoCpcjwMRu//j69ndtXtCP0NS2ElhXzwU=;
        b=OzHnxo7sY+JQgL343JiXPTLp0Jf3Mn//+oxrTVhsmgkXTakGdYZiV26X8vgzh81g7w
         VUVG4SGDnUQdDr7qWy8PCP42hgaHbPWYm2yMEAO5adZZEIRdwQncnjhcum1+hnehiRih
         FObY/P0JeP+W1iRwgZnUpak5Ztrsfp6kcmby9/uY0TCJfoMvvXLc0vitky6pjQVITtWo
         a7/uwAms+prstbghEXSHbiBPXH1oQnfR4j7QlRyhinLBYRqTW44zfcymcFgKd7TdxE3A
         fHLYJKlbXEygAnNfO/w45WgD6x/EAt3UbVFdWvSTUiSCDWv5FmUdF1wVqLiP0W55PGKP
         PbFQ==
X-Gm-Message-State: AOAM531vJDIgJvJRtwzZVL0iqJuGaUSTZ0o8ydcOpb26+9aLwc9S4Nrt
        KtQybF4a6PtnnTOVAIc9U/N40Eu7J8XqO+I8
X-Google-Smtp-Source: ABdhPJwf6UH/CcQRHOKUtt59ycYpiu3snU7M2hjeYaaPa8vODJopyC6lafOLMLKP7+MR3NDzcDgM5Q==
X-Received: by 2002:a7b:c309:: with SMTP id k9mr1632728wmj.125.1604052532224;
        Fri, 30 Oct 2020 03:08:52 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v189sm4430947wmg.14.2020.10.30.03.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:08:51 -0700 (PDT)
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
Subject: [PATCH v5 10/15] vfio/type1: Mark follow_pfn as unsafe
Date:   Fri, 30 Oct 2020 11:08:10 +0100
Message-Id: <20201030100815.2269-11-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
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
index bb2684cc245e..eccfee900033 100644
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

