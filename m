Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE619C3AC
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388331AbgDBONA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:13:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44855 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgDBOM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 10:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585836779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Lsas7jxJ1WMu8rRlGVbgJ8eIsxujsCQQeq8BgBAYBkI=;
        b=TWz9U+cRrADAROTxO/jIEurRypEO+HCiCxkVY4DLlFxx4Sqg8t5w+nNEcS+3GCoOJ1r9cm
        2SGneoW8OYJ3+ylNg8oHock4GKw86cAiseShJ4RA/0HVRiEUo/PEjcLJ3tOoYFwvNgQzgt
        iPC1PNTNWIxktqguNnNKgrMNkYJ6DQs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-bVML2w1uNmGiCtFmIIyQbw-1; Thu, 02 Apr 2020 10:12:55 -0400
X-MC-Unique: bVML2w1uNmGiCtFmIIyQbw-1
Received: by mail-qv1-f70.google.com with SMTP id bp6so2764820qvb.17
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 07:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Lsas7jxJ1WMu8rRlGVbgJ8eIsxujsCQQeq8BgBAYBkI=;
        b=k3I54TOzHFVH4kwEAx7fiokHUoxKY5ZEXtaS+B1yWbks+JMLE5Ytw3E3LgQcH9Phe8
         5wxhuVRaggYpnuuVRF9gfrhPLtmNFGbhOJkl9tAd0v6a5XIXLEgtgkqZF+0EXrrI5cMT
         x+RbWsK8qI6HqR3PNJZ35/+TzjskcirNvmA6d9mO6iZjPV60z+5xc3C+uI8RMPXx9+kc
         Q4DbV8NvQ8xrNxSgjcUYMEF+hDsGQoV9GNeew+c1vLfrSrUtdwKolLsVprx9vYWObYHf
         BKH9HOBKToTAIFadzSDs5vXc5kBPIdlvMMRQ5lz9cO/d4jvLHeHQLfe3sEbaWTyr0sVD
         wcog==
X-Gm-Message-State: AGi0Pub6ZS2kzfDNpmabImXDdW1Iqgy+RjRAFwThlq4C6OYuGTj20mFx
        ORmZ4lUJGu9Svs2rv8rstPh6JIK343o13lMfaKYt3EwiiRqk8GDkbi/ZrVXZie2/YCKz1XKE6d9
        IzizwRVu5UyO9
X-Received: by 2002:a37:7c81:: with SMTP id x123mr3569432qkc.287.1585836775419;
        Thu, 02 Apr 2020 07:12:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypLfJWfDXTGKKPJbCvXgetpUrdL/5Wc33Wc2j+KEgqsWojCWykGbIs6gJg6z/V4LYFVIdSjzNQ==
X-Received: by 2002:a37:7c81:: with SMTP id x123mr3569380qkc.287.1585836774834;
        Thu, 02 Apr 2020 07:12:54 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id b7sm3553494qkc.61.2020.04.02.07.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:12:53 -0700 (PDT)
Date:   Thu, 2 Apr 2020 10:12:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost: drop vring dependency on iotlb
Message-ID: <20200402141207.32628-1-mst@redhat.com>
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

This is on top of my previous patch (in vhost tree now).

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
index 21feea0d69c9..bdd270fede26 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -6,7 +6,6 @@ config VHOST_IOTLB
 
 config VHOST_RING
 	tristate
-	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
-- 
MST

