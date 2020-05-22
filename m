Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DFF1DDC86
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 03:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgEVBSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 21:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 21:18:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E9BC061A0E
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 18:18:40 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z18so7185732qto.2
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 18:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Puv1BV91r6SjZkjuOU7H5cmGIu56s9jB/MY9elYkgSk=;
        b=bCOGh4IBnzxtvHN6uHYYXFvOkvGLA05aypKg9VveLlImf/EjhsiWQEZqEaDxx0hFBw
         oS/O9Js/qJmDaoEi1Vf9HnVAjgflpNI5PzXwdpd0f6UqWPphMZ8DSMUZPdUd0fnSf90a
         G6H4rG0ew2DZu7LNTTIOriEl4v0aZi3QI5AXLz2PZxxszXiGSBiS4g+L56Yr0QIrKuLw
         ezr/H1TDBLZi3n/LG/7H206p26KCSI3+wsjmT5k/IRnUlDysOU1c57Hxfe/Cbyzp/jd7
         5t8GNCOgNNYyprLix4KNSCg3rmb8EzxhGaqXe6iqofMcf/RxC6yGeoL1L4pqHcthN8+k
         i3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Puv1BV91r6SjZkjuOU7H5cmGIu56s9jB/MY9elYkgSk=;
        b=XdP/SStYHWFlxXaVADPY95BMDmRtWCFOOJF8Z827hKFAouKuaBR60PvMIkzJOZ6MQa
         dRmblDuUQ4MPD6QTVM5EfzMKRtYGVBCrUBlu+E2bmXbh1dbtB+kdKZoW6uh9CCsuYjKn
         kQNE6c026+jQ+Tkc/YwRKb+lNGXMEbXhXbAmTYl4nM3HUqFmpOpvxeO1r7qBT3gTu9DK
         TMBRAD1uFbHiL2hW973Edb7TWIY3n6SLdPm8ywl/v/EKIy2Gpgyuf0cfJekulzydujnp
         VQphyly/e0TJ31VgNg3IQ3kCrnKUCndPZSkc10C0Ey+YW/kedamSRK2KVflyl+7CSojF
         XsaQ==
X-Gm-Message-State: AOAM533T88JogfbJZc1aW2GOB5yO2rEqZwTYbaV0frLi1PnTjwh/g7QC
        9Qlmix27pOzxfqYtkM+Y63A7v+U49S1YnA==
X-Google-Smtp-Source: ABdhPJwMoUeBYjRzyp9R0VCrKxKw3AszW5mQi04RCM1s4y0bzosHq3N+Y/7dGmnHCVVDXVF3pf9Tqw==
X-Received: by 2002:ac8:b48:: with SMTP id m8mr13649501qti.206.1590110319843;
        Thu, 21 May 2020 18:18:39 -0700 (PDT)
Received: from ovpn-112-192.phx2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id f43sm60212qte.58.2020.05.21.18.18.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 18:18:39 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH -next] vfio/pci: fix a null-ptr-deref in vfio_config_free()
Date:   Thu, 21 May 2020 21:18:29 -0400
Message-Id: <20200522011829.17301-1-cai@lca.pw>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible vfio_config_init() does not call vfio_cap_len(), and then
vdev->msi_perm == NULL. Later, in vfio_config_free(), it could trigger a
null-ptr-deref.

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 RIP: 0010:vfio_config_free+0x7a/0xe0 [vfio_pci]
 vfio_config_free+0x7a/0xe0:
 free_perm_bits at drivers/vfio/pci/vfio_pci_config.c:340
 (inlined by) vfio_config_free at drivers/vfio/pci/vfio_pci_config.c:1760
 Call Trace:
  vfio_pci_release+0x3a4/0x9e0 [vfio_pci]
  vfio_device_fops_release+0x50/0x80 [vfio]
  __fput+0x200/0x460
  ____fput+0xe/0x10
  task_work_run+0x127/0x1b0
  do_exit+0x782/0x10d0
  do_group_exit+0xc7/0x1c0
  __x64_sys_exit_group+0x2c/0x30
  do_syscall_64+0x64/0x350
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: bea890bdb161 ("vfio/pci: fix memory leaks in alloc_perm_bits()")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/vfio/pci/vfio_pci_config.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d127a0c50940..8746c943247a 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1757,9 +1757,11 @@ void vfio_config_free(struct vfio_pci_device *vdev)
 	vdev->vconfig = NULL;
 	kfree(vdev->pci_config_map);
 	vdev->pci_config_map = NULL;
-	free_perm_bits(vdev->msi_perm);
-	kfree(vdev->msi_perm);
-	vdev->msi_perm = NULL;
+	if (vdev->msi_perm) {
+		free_perm_bits(vdev->msi_perm);
+		kfree(vdev->msi_perm);
+		vdev->msi_perm = NULL;
+	}
 }
 
 /*
-- 
2.17.2 (Apple Git-113)

