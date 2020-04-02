Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FD219C4A2
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388677AbgDBOqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:46:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34242 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388266AbgDBOql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 10:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585838801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=247fWnWaIxGLXiVh3d5vG20xrpndo7qpcBC/YB6ZW/8=;
        b=hNLZRZMoh/KlmXmn2eLYhAFPwdJQeUBxRGJkoJjt7RBW4GrkcQL2foIwL5Nyynufi2Fhec
        YYkkQBW/6+NXlIfKjX88YH+ql3/c7vFcV/pvUoU1jCyGp/cq8pR8lvTkbovw7b0l3PAUzs
        g26rDWpDJENlqcECLXaEUJzx6hQ51sM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-6vqCAa3uMRukcLjodLV63A-1; Thu, 02 Apr 2020 10:46:39 -0400
X-MC-Unique: 6vqCAa3uMRukcLjodLV63A-1
Received: by mail-qv1-f70.google.com with SMTP id bp6so2853029qvb.17
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 07:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=247fWnWaIxGLXiVh3d5vG20xrpndo7qpcBC/YB6ZW/8=;
        b=TI5ZlbsIQ6C0oi5KddK6hspn1rJU3dxOOp/beZ3vderAw39oWpxHH3sHmGIAv1dbyD
         dyDYUkqqzF9i10wwXDkdlqR0aPvgrc2u9RGaMqEiSGzqtk27yOBMExHCVTVN0EiYmdg6
         xEWz59goELWy1LRf/6gmCWb+jvNtdPerXuKDDAd3ZfdYYc3MNmYCoXl+TlFfpLkp2QRH
         1jzI+XHkmgswg9QEXoU3XsYDxwvu3uIKdsPu7003DfDtpvMEvKQEMti9y9veNqgMWcjo
         NxjQYeht9de27Z1qhwWwadObVrDCbU2656j3ZrTOOcKtL+XP/wnkCkKlOPfhhJ+4oOJY
         9N9Q==
X-Gm-Message-State: AGi0PuaBgRb4R071jDp3Qy2dagzId1UAwlXLFExDQZ5B7ApcLdqfG0h9
        qzTvZMowKmvI0nYkjG8nIMspf8yGxWdi4PPpNg8a7osaGIONT/dNw54ytaeSXbD1FKNmHj+sSFt
        hs29qDeXPZUbZ
X-Received: by 2002:ae9:dd83:: with SMTP id r125mr3878505qkf.105.1585838799295;
        Thu, 02 Apr 2020 07:46:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypJrCvrYOfccOPc0wjpUe4Jhvl0Nl/n0u9FB6DDdrO18srx7Gu82PDrBByu2qXM5kAyNldGtag==
X-Received: by 2002:ae9:dd83:: with SMTP id r125mr3878453qkf.105.1585838798775;
        Thu, 02 Apr 2020 07:46:38 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id p9sm3672571qtu.3.2020.04.02.07.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:46:37 -0700 (PDT)
Date:   Thu, 2 Apr 2020 10:46:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] vhost: drop vring dependency on iotlb
Message-ID: <20200402144519.34194-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Applies on top of my vhost tree.
Changes from v1:
	VDPA_SIM needs VHOST_IOTLB

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

