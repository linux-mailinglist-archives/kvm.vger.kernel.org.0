Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6442C69B4
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgK0QmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbgK0QmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 11:42:04 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18717C0617A7
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:04 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id u12so6231147wrt.0
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WIwM+CgtjulX00So/rnZs3CK8iFlbmt4b5FI8jtD7Z0=;
        b=UsmTBv70+0yVDRoJJ7S15WMQxg6E1LErgv9pqqIkQadtiUgYBrporCiAo60oAloUR0
         hypKZlv6JVJHYO7NbUucNAxekNi/+UcXEeC0lL9RNeCmL4gLXd2f1Uvy8w0ttja7AT3u
         fXbx7NQgScpue4f5z44auD2zsQqryDSerpCHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WIwM+CgtjulX00So/rnZs3CK8iFlbmt4b5FI8jtD7Z0=;
        b=WzVNom/Zv2sRN71iGF95+QlgO0iWmE+HC9fQCXUQo3t50qdUS3ye7FPYx1ZPw728kx
         spbrfcI2IBbwiTv5yqF65FqVb0D38p9i0yk/vXQ2n2N7CWoA7WVvueD4kfKe4JZv/R3D
         JkdwoDMgXI2ZalpoWUTO3BTaU2eC3rmGA+KhJtwQ2zKRGWA3mD7NRpKScgby9MyAb05l
         i7tioMlieLTYn02Px5pPSOZTEaL9hro5wkMOpgQ5tJEpHPy0myvzMuke31uXacWiM/A3
         1D6so/frA2ju79HWR8D1CN2DmMv34CnOZfhVK0kOqEs1vaVdG4RSKXErFYh5dfiFpfBh
         4nwA==
X-Gm-Message-State: AOAM530fsdyl6CKiTyyQP2KpOS13SOIHzHII/OarYHCd4DrkhWA2SQyL
        /oNT0xDf6o9hF3FtjzFmsx4t6A==
X-Google-Smtp-Source: ABdhPJyAXEAYiKOSNg8sjsJugGFFuhRB8ve58iZQChHUSl54iRJGMo2vJlzEY8x9JKPdy66sWXRf8w==
X-Received: by 2002:adf:8284:: with SMTP id 4mr11448134wrc.386.1606495322891;
        Fri, 27 Nov 2020 08:42:02 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q12sm14859078wrx.86.2020.11.27.08.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:42:02 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oded Gabbay <ogabbay@kernel.org>,
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
Subject: [PATCH v7 04/17] misc/habana: Use FOLL_LONGTERM for userptr
Date:   Fri, 27 Nov 2020 17:41:18 +0100
Message-Id: <20201127164131.2244124-5-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are persistent, not just for the duration of a dma operation.

Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
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
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/misc/habanalabs/common/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 2c59fa869684..0d25ae1d5f3e 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1296,7 +1296,8 @@ static int get_user_memory(struct hl_device *hdev, u64 addr, u64 size,
 	if (!userptr->pages)
 		return -ENOMEM;
 
-	rc = pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
+	rc = pin_user_pages_fast(start, npages,
+				 FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
 				 userptr->pages);
 
 	if (rc != npages) {
-- 
2.29.2

