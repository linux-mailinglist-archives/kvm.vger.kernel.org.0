Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86822A0238
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 11:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgJ3KI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 06:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgJ3KIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 06:08:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046D6C0613D7
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:52 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k10so4459711wrw.13
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m0CY9Rbr42q+4kNNTVsBTqYTrcmWIBY8OlDR+PQ4LSY=;
        b=TCm1S5Q7agrMsYkVTr7D/78UXLblZmPqCiWDzvPwYxD9GCU1GNc8Jjvxv5svMDEe6v
         bkYAumdxmSMbSz/KtmN4VJ6fYcfYHsikuHnOoHLDbTMb+p4tqzZuBTIgrbDMQOuqzhBn
         cumsnxGZIRqSCkE4bbQitc4OwUhZCXYmYGs/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m0CY9Rbr42q+4kNNTVsBTqYTrcmWIBY8OlDR+PQ4LSY=;
        b=a3++hkcz1JAo7HEyP/mzhnfIACpEOUiA1ejMwnaUdlQeo4ChNP7FxHsQmRPeCD5Xn4
         hdYuja3+epItA9w9gpynDEVZNpUD72y3NGddCLFcnsZ71imLjbjzMPcxge8ZwXJrkLDf
         ylW3rDq/JdF7rqKiflR1PYOigmVh8fBkPxyEHH+nTgD0ps0DkOS+4vgwikibHAivQLdl
         KR4Fnkn5Xh++dAmNB4fbPPw5anjlgFoZbP9SEz+GXHu5f13FTdWZRGOB2Yn85r9o/Pj7
         r6xV/Ffb81leBMH3PsQym9n5HykyxF9ILUetsTe1NwK3lWfD+FJaS9WZCOmiUwMiui1Q
         bfwg==
X-Gm-Message-State: AOAM532jIQHXAHAMQYd1B7ec6Hf3Si/vzliLAVPlhgeb1Xe/FoyuyNbB
        76RG0X39ORoWPewvcUwn0dmvcA==
X-Google-Smtp-Source: ABdhPJze4w/SEShvJOPYtwgGA/3KAJaz2wKox27V+EQ3sUl5PRWykP71hEze6EAWF5/h69RPN40mYQ==
X-Received: by 2002:adf:db03:: with SMTP id s3mr2209689wri.152.1604052530739;
        Fri, 30 Oct 2020 03:08:50 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v189sm4430947wmg.14.2020.10.30.03.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:08:49 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v5 09/15] media/videbuf1|2: Mark follow_pfn usage as unsafe
Date:   Fri, 30 Oct 2020 11:08:09 +0100
Message-Id: <20201030100815.2269-10-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The media model assumes that buffers are all preallocated, so that
when a media pipeline is running we never miss a deadline because the
buffers aren't allocated or available.

This means we cannot fix the v4l follow_pfn usage through
mmu_notifier, without breaking how this all works. The only real fix
is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
tell everyone to cut over to dma-buf memory sharing for zerocopy.

userptr for normal memory will keep working as-is, this only affects
the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
videobuf2-dma-sg: Support io userptr operations on io memory").

Acked-by: Tomasz Figa <tfiga@chromium.org>
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
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
--
v3:
- Reference the commit that enabled the zerocopy userptr use case to
  make it abundandtly clear that this patch only affects that, and not
  normal memory userptr. The old commit message already explained that
  normal memory userptr is unaffected, but I guess that was not clear
  enough.
---
 drivers/media/common/videobuf2/frame_vector.c | 2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
index a0e65481a201..1a82ec13ea00 100644
--- a/drivers/media/common/videobuf2/frame_vector.c
+++ b/drivers/media/common/videobuf2/frame_vector.c
@@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 			break;
 
 		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
+			err = unsafe_follow_pfn(vma, start, &nums[ret]);
 			if (err) {
 				if (ret == 0)
 					ret = err;
diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 52312ce2ba05..821c4a76ab96 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 	user_address = untagged_baddr;
 
 	while (pages_done < (mem->size >> PAGE_SHIFT)) {
-		ret = follow_pfn(vma, user_address, &this_pfn);
+		ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
 		if (ret)
 			break;
 
-- 
2.28.0

