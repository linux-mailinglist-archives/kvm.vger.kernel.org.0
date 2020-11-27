Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224522C69C0
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731793AbgK0QmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731765AbgK0QmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 11:42:11 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C613FC061A4F
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:10 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id x22so5629330wmc.5
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lUo9ncFU/nKq3MG4mWQrX8BX1Csq/yukMRd1xs72MQA=;
        b=U7CnpbD00qEoN/vUsVW+I4243+W/JnXoGNjkeopzZQU5so09mhertht0Ptz/Y9CU97
         QBJjqG6J8HVGWhflVJAnSEhJA51fquUA/rLUSiFGQ3D16s3hdHYPSCDYykR5ivgrpzt5
         UNuqMwTHX4nMkYA9iGIVY8KW3+QGNck+OCdBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lUo9ncFU/nKq3MG4mWQrX8BX1Csq/yukMRd1xs72MQA=;
        b=I8P2tbXL18MmQhpHNqcFt9cJhIh8OVOHgbE9h28+8w30rjKf4RRr+0IbbKtcdYUiwV
         AVmYLGieBNeSXvAVvMiv/1L2/DfA712QSO8NZnBBIkk2j0Hx0Odq0f/34Rkh8EMbEreK
         Hb/sufAyJLVQUCyqGL3eOAAmm1D71pJ63BJPU2svBfbEkWqqRUAzkhrwXynEZYWdy6PH
         J12y0rOKQnkRBjOB4LMAyGBCk1UV1R59h3jF3PVhTTobYhpdCRa9zLQZ/0MHDbnHHw9w
         Sj1UhbxaBrLYDjtytMRYymtosohMi1qE0R7XsC/lzho/c5Nlc3hwLYcOxf/vDA1wgLkQ
         5mlA==
X-Gm-Message-State: AOAM531VSr1wljZZd8qEuWjPOGOJPEhE67jEBMhO7yALm4ij79GbxtmK
        JWlI9vuXhR9H9oQBGLlrPTrEHw==
X-Google-Smtp-Source: ABdhPJxKU2LEPA3ycZu0g6uNTdSP1FwFa6HvSU/jo43OGE9w8xBQTe6/Vk/r7mX9FCsKkcy0le5iyg==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr9963982wmi.186.1606495329592;
        Fri, 27 Nov 2020 08:42:09 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q12sm14859078wrx.86.2020.11.27.08.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:42:08 -0800 (PST)
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
        Jan Kara <jack@suse.cz>
Subject: [PATCH v7 09/17] /dev/mem: Only set filp->f_mapping
Date:   Fri, 27 Nov 2020 17:41:23 +0100
Message-Id: <20201127164131.2244124-10-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we care about pagecache maintenance, we need to make sure that
both f_mapping and i_mapping point at the right mapping.

But for iomem mappings we only care about the virtual/pte side of
things, so f_mapping is enough. Also setting inode->i_mapping was
confusing me as a driver maintainer, since in e.g. drivers/gpu we
don't do that. Per Dan this seems to be copypasta from places which do
care about pagecache consistency, but not needed. Hence remove it for
slightly less confusion.

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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/char/mem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 94c2b556cf97..7dcf9e4ea79d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -891,7 +891,6 @@ static int open_port(struct inode *inode, struct file *filp)
 	 * revocations when drivers want to take over a /dev/mem mapped
 	 * range.
 	 */
-	inode->i_mapping = devmem_inode->i_mapping;
 	filp->f_mapping = inode->i_mapping;
 
 	return 0;
-- 
2.29.2

