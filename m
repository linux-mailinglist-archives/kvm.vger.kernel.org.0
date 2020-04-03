Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E2C19DAF1
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 18:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404167AbgDCQKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 12:10:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404145AbgDCQKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 12:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585930235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LeoeQF7GvDwmPkvw2R/S0QmAmK/0A59bm6nJYVibxX4=;
        b=YaQS3HoCjO2iL1lU7Qq7OhPLDUUaBwoAwkNybr+IuwdEnH2wxZNEVb1/kw38svlLXP3CjD
        lh4pzbjGOQhMzZIO+CRTHgERlZ+BjDfax2n30Egkg5rjb4prKerS3q8Sd8jA/jj+pJreJe
        820xIVsp2x9aCs78l030SstRy9sb8jU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-lNdGiufyOTaa4E5zV4wHNw-1; Fri, 03 Apr 2020 12:10:34 -0400
X-MC-Unique: lNdGiufyOTaa4E5zV4wHNw-1
Received: by mail-wr1-f72.google.com with SMTP id y1so3318178wrp.5
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 09:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LeoeQF7GvDwmPkvw2R/S0QmAmK/0A59bm6nJYVibxX4=;
        b=tSlLARsT6tAwS8XkJSRKY6QFiSMeYU/s3HQgQV3InVJYvyGpQ5ZYVuqcuAq4fj+zre
         p805h/5ip+iXdo05on/LW3AFnRkU8SxTzJ9gvjL35A83bJz7P2oapA9gaXv9em+dY41q
         Mp65XONd8YO7j9a/zD/cMASECdSnr9BBkitUKhr09nHrnIQar9L/BkUsqGiCs8GhL04K
         1D9R7LCWkyXKgKa1AczWZruLec4qT4q5+ffwJUk5TOjWB9C6INlrtzQ+bMXV+poLCLcw
         mfV2YQ/agMz4aPolvha9MMblmCWRTdEt1yw+ons4b5v1MISRdRDbekFE+6rlyVAub+PR
         eaYQ==
X-Gm-Message-State: AGi0PuZXDqdsLz3JPRPf0kKX692o39Cy89xGUwRD6Hcyja/rwPV7KVzz
        qd9fxytj7QYoJ9IxAnxzsdrUHMJVJP3INJS3f4mkS8JVPK0rXRyjDr02dquNbbWzs8pFJNGcr+a
        uxxHQbxIhu+ae
X-Received: by 2002:a5d:4401:: with SMTP id z1mr9663503wrq.259.1585930232866;
        Fri, 03 Apr 2020 09:10:32 -0700 (PDT)
X-Google-Smtp-Source: APiQypJPQpWckOqFouWM2ty3+B/I0oJ8XkRO7qyavBWXix0tAnRF2g6JD6t97ZbwvnEPMH4gZoU5vw==
X-Received: by 2002:a5d:4401:: with SMTP id z1mr9663491wrq.259.1585930232684;
        Fri, 03 Apr 2020 09:10:32 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id b187sm13009825wmc.14.2020.04.03.09.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:10:32 -0700 (PDT)
Date:   Fri, 3 Apr 2020 12:10:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 2/2] vhost: drop vring dependency on iotlb
Message-ID: <20200403161011.13046-3-mst@redhat.com>
References: <20200403161011.13046-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403161011.13046-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vringh can now be built without IOTLB.
Select IOTLB directly where it's used.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vdpa/Kconfig  | 1 +
 drivers/vhost/Kconfig | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index 7db1460104b7..08b615f2da39 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -17,6 +17,7 @@ config VDPA_SIM
 	depends on RUNTIME_TESTING_MENU
 	select VDPA
 	select VHOST_RING
+	select VHOST_IOTLB
 	default n
 	help
 	  vDPA networking device simulator which loop TX traffic back
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index f0404ce255d1..cb6b17323eb2 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -8,7 +8,6 @@ config VHOST_IOTLB
 
 config VHOST_RING
 	tristate
-	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
-- 
MST

