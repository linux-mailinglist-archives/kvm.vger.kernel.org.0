Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D42AD55FC
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfJMLm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 07:42:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbfJMLm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:27 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 707933B464
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 11:42:27 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id x77so14048888qka.11
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 04:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LyPdJiu+Pv3Ms2s+9K7y5cFNFk6/oEkuyO+dRyVq8dg=;
        b=JvSayOAsSNCMMtM5CvbB4jB5QhXHK2ysSXDq9uRvqnrs+rOieQFI56Q6SRAPKwEIB2
         afUUsTC3vXvg1/uW7tDewAWJ3XT0coD1V0ymQVBzycu7P2gtm4yBqzNFmbUiJoU9geli
         nL1YNasiGyMt4J0d9fBNa2JMNLU2rJF6pd1dC4G9p+kRNC6/G6yOAUbhKXEPmh3+CXu9
         /vYRevewbaTR4JgyxrXCjyo3QCRDdJTr0/P3iTeArNvc6hWsSy4MMVOeNE+vRg8mpw91
         duNIPn8341P65EKg6a7FQasSBLwx19SCU2DvubfXDUGiQl8DAK04NWY2zql17PUOmCGw
         JiqA==
X-Gm-Message-State: APjAAAX1PpHMJluz0DiLzPAAWvoLyn+9AA8ObTK24TwLavsqJlBJNMDt
        glhq770D/Vhu+aIk49oLE36ZmVQUarIXc3CrRvbIvAjXX+nfrdyPwD4y4jat0JwMqdplPEVd7HO
        tcnGta8vwr0FV
X-Received: by 2002:a0c:c792:: with SMTP id k18mr25297612qvj.154.1570966946778;
        Sun, 13 Oct 2019 04:42:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyhx3XLFozvF0Fexkmjc2uJBOUXPVXIPjvAKX3RiiVhxNpPC56P8T4wN2MQG4g59b9OLo3Gdg==
X-Received: by 2002:a0c:c792:: with SMTP id k18mr25297597qvj.154.1570966946584;
        Sun, 13 Oct 2019 04:42:26 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id z5sm7213125qtb.49.2019.10.13.04.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:25 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:42:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 5/5] vhost: last descriptor must have NEXT clear
Message-ID: <20191013113940.2863-6-mst@redhat.com>
References: <20191013113940.2863-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013113940.2863-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fetch_buf already guarantees we exit on a descriptor without a NEXT
flag.  Add a BUG_ON statement to make sure we don't overflow the buffer
in case of a bug.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d46c28149f6f..09f594bb069a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2656,6 +2656,8 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 			break;
 	}
 
+	BUG_ON(i >= vq->ndescs);
+
 	vq->first_desc = i + 1;
 
 	return ret;
-- 
MST

