Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D422298AE3
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 11:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772756AbgJZK6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 06:58:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43019 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1772585AbgJZK6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 06:58:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id g12so11870374wrp.10
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 03:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fm+L1OZ5vnKeOGH1XwjpH65CAXQE2qGCwQHeV0BfCbo=;
        b=WDXic3xEelIUmmKBuCaAQhWAocM+J6l4Fj4ebPaY2TA7KjqktouI6kx1cuzB8y9UHb
         BFENQYpFYRrnf8V4M8FMdw5d3WVXp99ZQMaG9LdvbhHrDb1RPzEBMwS3mFEVGyKOFx19
         gvYOzFywjU6mguxvCAHNCjVghPiiwoY0kNQWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fm+L1OZ5vnKeOGH1XwjpH65CAXQE2qGCwQHeV0BfCbo=;
        b=Hc4IWDa2a+e5jynK5lh4KfNJ571UQn9Cd9x4vFV+ABnJ63y30/Zy/LymF7ozXZ1ofu
         5ISSL3u9DW36RdDhkts44yZAUy+awv7eVpadnJTjqFE1n8eDrTNhDQY11FjgGP6V4/Gr
         juwMMpNjP2syvzGPY5rj/yq4FY6Ki37xavt6QuRjge5EduiNA71NaUbN1bWySYX+KMpD
         ecvwvzYDdFm/exKJj9W5PR1B7j7J0LZ8f+ga0OPUzYouCfr3nED4Q1HaEx9qr2NYazUO
         eY/DIspovnCYa6mobwwZYAdgJKRaEiGHXk4caUgh+i7MI4vlhGhVQrVJtirYPpgfVnde
         E2eA==
X-Gm-Message-State: AOAM5319+nLd/pGjvUclHxwf5QIJpB8oR0Smwqj7WBN2JDYsxilAYKkh
        nSRyrZwG5Z1f5+VdzzsMmmHYNQ==
X-Google-Smtp-Source: ABdhPJweUKS7rePvehoYbUjnZ9k8M/DdLl55bpzabm8YcXT6EbKByVlIbEgXWPVVGpbtM3F7y6c03w==
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr16288559wrr.134.1603709911230;
        Mon, 26 Oct 2020 03:58:31 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id w83sm21165156wmg.48.2020.10.26.03.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:58:30 -0700 (PDT)
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
Subject: [PATCH v4 04/15] misc/habana: Use FOLL_LONGTERM for userptr
Date:   Mon, 26 Oct 2020 11:58:07 +0100
Message-Id: <20201026105818.2585306-5-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
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
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
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

