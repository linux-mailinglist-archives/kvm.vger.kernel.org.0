Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6043828F5
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 11:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhEQJ5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 05:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbhEQJ5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 05:57:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6BCC06138B
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 02:56:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v12so2829650plo.10
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 02:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7/sgPn1niIyplx/MCCBp/NxUC1m49ShQY4FddeicFg=;
        b=VtwX03C0ISBBYjMp9XrXXlg71h/dLD+Iw0BunstvVMTQaRODx4ebdUoHqalwuhZLrr
         c6dwQDJogEeD8IEYI5BVoSc848OKx+OElBQio9tTZdwuqKQ0c7pwHtONHQSD07vEDGtY
         HN+viIpqfyoeqR4A27UylxzodLAKfRlI/f+XLIm363PsM6oqelH6yU9zb92L1sJwUSq7
         abxZhuME3e0rEDw0VLQtTiSVtO+eqRv2k1gs0aSRfId3eS75sHzQWNeLdSh2x86GyLUO
         mNu7bb5U26Dzx7s112VDNFcaoK/enWL+0vWA8YXtLtU2B5IfIOdx+soCEqxWkBtw/wkI
         SfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7/sgPn1niIyplx/MCCBp/NxUC1m49ShQY4FddeicFg=;
        b=OULFCdLw7P7tVlLRu7UHdy4kjSu7GrxOXNsHL1flL3NJSyr1s4IG2oE58aq/Gmy6Oq
         eiqUyb8bKmnfGoskK+IOOlLICfczMT0sBIlqm2GPmufEQWHa67cxn2BdnHZagD9oKPbT
         JCw/QthGvqZ1RZmzIcdoczz8Vm2HZokNc+WVC/huxQTMoHr/i7vw4ftnF9tzC59GitTt
         NyN5/fWKirRodX1f7uZ7McYZaX61nT1CGmBbjAPu7MlVdPp/YYCcT3vrlO3QIO7PNey9
         fBmM7etlJJMA08Ub5zHy6r+wdug5+SqQuq5t35X0uwVWwjJCUKXXh5HB0FlVmOnybzRL
         BSEQ==
X-Gm-Message-State: AOAM532YtvjyIziWr7oSh5moXHYOO44Gz4hq9XkMthq5qT0ybxcVRrEc
        XGu2wo7Wrva8XsoYrwsYRgOf
X-Google-Smtp-Source: ABdhPJxaWd2Kn5/peSswOCwRKMHxtXfg5xbq6uIlNzE6im+gipuz3QFRX9Bwo9Y9e12+QeRiGNwVIQ==
X-Received: by 2002:a17:90b:1992:: with SMTP id mv18mr9044020pjb.137.1621245376019;
        Mon, 17 May 2021 02:56:16 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id s184sm10234381pgc.29.2021.05.17.02.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:56:15 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 05/12] virtio_scsi: Add validation for residual bytes from response
Date:   Mon, 17 May 2021 17:55:06 +0800
Message-Id: <20210517095513.850-6-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517095513.850-1-xieyongji@bytedance.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This ensures that the residual bytes in response (might come
from an untrusted device) will not exceed the data buffer length.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index efcaf0674c8d..ad7d8cecec32 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -97,7 +97,7 @@ static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
 static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 {
 	if (resid)
-		scsi_set_resid(sc, resid);
+		scsi_set_resid(sc, min(resid, scsi_bufflen(sc)));
 }
 
 /*
-- 
2.11.0

