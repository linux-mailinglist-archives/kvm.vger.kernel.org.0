Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7973421B36C
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGJKs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 06:48:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43632 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727943AbgGJKs6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 06:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594378136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=zH+SoJc9FA+IxVxr5cux+vmHnM4kK2aczPlNcB2fA0g=;
        b=GVnyIem8Rc/LebOyLDXJmWiZQrlDorG1nSYF4iG1Ku+EsaODON8fC6GBM3gFkqcHoJ5cA5
        ETuRqtgRyowzQRY0GCdbKcQ2hQPG8mtq40BIPBAtQzic0hY0mahw/gymxYmEQ6UtXHtO1F
        ppjEDPnO22gFpSxTnmSRCH6/LJxNcPY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-_G5YgMRyNxKkAiSjn0HnUw-1; Fri, 10 Jul 2020 06:48:55 -0400
X-MC-Unique: _G5YgMRyNxKkAiSjn0HnUw-1
Received: by mail-wm1-f70.google.com with SMTP id g138so6251258wme.7
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 03:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=zH+SoJc9FA+IxVxr5cux+vmHnM4kK2aczPlNcB2fA0g=;
        b=G84nq29x4I5R81MZuU4Idsr10n7kwKLQT9A5vmSJcz+zQA91QuSVVrbiPwvbySZoNJ
         WqP5Slcjg+UfoKFwgIUK3VLW81H4T2/1MjDHekI8GgOIyYTkEGjnfFBRNKqrgBjusXMi
         MJj2QgOtzrtWA+gyHq2iVX20KJD+lsRY6xDOUmO6nkplyp3w17iGddP/IXcMnngVMtK4
         I8QxL4AFbPuKxqsUXLGpN18CqioyqJv/XELElIegZorrdw/L+T6lO1/FHMTk4hzKrPEt
         kwfYimfrMjCRd/Out8roYa464G1w/gKFS2W1mQhXGYNwYo+FpFOXyXUdJy4MA+J86vZH
         Tv4A==
X-Gm-Message-State: AOAM531uS9bHs4+oS2RQ2lerPmjzR94dvC+wvKe1iRGig7fEksVXbw02
        JBapp0jPE7c4EOrNVTgx10vkcVbRMhMR+hFxW07rfPVdzvYN/2gcWKLvYwdg92b7gAbFprHKg/m
        sTrJAcge+te9C
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr55214236wrx.235.1594378134132;
        Fri, 10 Jul 2020 03:48:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw4fIgUrx6Lb8RIpTWJ39EeNc2fRHHzE0+AdkrVCaNR8Aj75HUF42WJR8yehI/TNv6QqsbOQ==
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr55214221wrx.235.1594378133933;
        Fri, 10 Jul 2020 03:48:53 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id 68sm8898710wmz.40.2020.07.10.03.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 03:48:53 -0700 (PDT)
Date:   Fri, 10 Jul 2020 06:48:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost/scsi: fix up req type endian-ness
Message-ID: <20200710104849.406023-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost/scsi doesn't handle type conversion correctly
for request type when using virtio 1.0 and up for BE,
or cross-endian platforms.

Fix it up using vhost_32_to_cpu.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 6fb4d7ecfa19..b22adf03f584 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1215,7 +1215,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			continue;
 		}
 
-		switch (v_req.type) {
+		switch (vhost32_to_cpu(vq, v_req.type)) {
 		case VIRTIO_SCSI_T_TMF:
 			vc.req = &v_req.tmf;
 			vc.req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);
-- 
MST

