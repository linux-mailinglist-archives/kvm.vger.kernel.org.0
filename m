Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3732884AB
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbgJIIBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 04:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732705AbgJIIAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 04:00:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC6DC0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 00:59:59 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so8883105wmj.5
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 00:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uX5hiQf2/6+JGMu7ibulF4yjLrHkS7bzKXomqQaTHWE=;
        b=LUs8gW8poh/U88b/yPCV1unTccMuHSzIpHlM9z2+BrGZRpT9/SgX900ntWxsVp0THA
         6pATcrsdZsxLyB+PObFVC/LN2SqZ3pUmcbdagnolKeMah/pcR69O+r6i8uxjKGpoKgMW
         IouGPHyDlnYWeMW6lK51rglfKepWnaslSuqQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uX5hiQf2/6+JGMu7ibulF4yjLrHkS7bzKXomqQaTHWE=;
        b=svQYTBPjwXqXvlJ0Bltv9lspSyI59pqRtZQ/noK91HZh8ztW+zalrlhlIvMQiWMfas
         TqmiCh2+KYuFOm2RLHwSYmmlq2q3bXDC06olz+N7KSps0PWPmyqn4resrJfi1bEVbDZk
         R52iPnv5y2trNa1UPHPA0xTEY7XQBJ55PByf28d5EpMusrLpNaPEBPPyvteA9e3t/6CT
         kWN3+yMk21e07Xezn781fiyFXrg59PrdwPtm7XHhPwmZe/Orlu/JSqcMWyfU9GrvZ1zu
         Ti9tFBuLqoBEfveAPPV2L4ctXJC0FMDp8hhTmlGfD4175x5/yJKCGDCZ7lubxpgX531s
         wJ4g==
X-Gm-Message-State: AOAM532DE+EcgdT7A6jYZtk757N/2RyOplnadixbunIiukaQVwqtHCH6
        9bvhYQ32ZP6ETuXykIVUGSCgNQ==
X-Google-Smtp-Source: ABdhPJzgf8p51mqg8LMpEmZ8q3ui41jSdEp5wqDSyAI+GdHX93E/LMoGG5UPxz3MA259SCYbT0mGJw==
X-Received: by 2002:a7b:c14f:: with SMTP id z15mr13474049wmi.73.1602230397816;
        Fri, 09 Oct 2020 00:59:57 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id u17sm11634118wri.45.2020.10.09.00.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 00:59:57 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>,
        Ofir Bitton <obitton@habana.ai>,
        Tomer Tayar <ttayar@habana.ai>,
        Moti Haimovski <mhaimovski@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Piskorski <ppiskorski@habana.ai>
Subject: [PATCH v2 04/17] misc/habana: Use FOLL_LONGTERM for userptr
Date:   Fri,  9 Oct 2020 09:59:21 +0200
Message-Id: <20201009075934.3509076-5-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are persistent, not just for the duration of a dma operation.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Omer Shpigelman <oshpigelman@habana.ai>
Cc: Ofir Bitton <obitton@habana.ai>
Cc: Tomer Tayar <ttayar@habana.ai>
Cc: Moti Haimovski <mhaimovski@habana.ai>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pawel Piskorski <ppiskorski@habana.ai>
---
 drivers/misc/habanalabs/common/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 327b64479f97..767d3644c033 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1288,7 +1288,8 @@ static int get_user_memory(struct hl_device *hdev, u64 addr, u64 size,
 		return -ENOMEM;
 	}
 
-	rc = pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
+	rc = pin_user_pages_fast(start, npages,
+				 FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
 				 userptr->pages);
 
 	if (rc != npages) {
-- 
2.28.0

