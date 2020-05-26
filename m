Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24A1CCC32
	for <lists+kvm@lfdr.de>; Sun, 10 May 2020 18:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgEJQRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 May 2020 12:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728123AbgEJQRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 May 2020 12:17:07 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20B4C061A0C
        for <kvm@vger.kernel.org>; Sun, 10 May 2020 09:17:07 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id v4so4980331qte.3
        for <kvm@vger.kernel.org>; Sun, 10 May 2020 09:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JpYYcxBZr7TCP2ENX63uBdQLllRDV18FrRXkes3kPkc=;
        b=iHK7iF0PjUPS4eJxdGh+6gxsf97besUffeTmdryBOgmkZiFoyLXL4CRssiZR8lsPD4
         E9WhvbtWztWO5TaFNPMf5YkZN32iZcFaw5xzfMbAiy8TGX1d0c1xtl8ABjXU0OUD8f7e
         Y8SiMUtrim7Zr33uOPGCzgFUTQMK0tH0fcl7BRNDIqMhVYmIsTBRqTaXGtRBdpbXEnTS
         lnVX5wJYTtEsa28KSBXy9e4RWbWTOYX8DaLCwkqN5mDB9diFfsFCdidCk+7FAW7QBp6m
         kQ8zlrR9fH5Bst0pk7i7cmSh3nq2EM0nPbSHnRJ2ooQoCvP6ATivGeve+bvv4Mg3cHfJ
         w3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JpYYcxBZr7TCP2ENX63uBdQLllRDV18FrRXkes3kPkc=;
        b=AKqbXCsC8YA7czqWmM7FG9+/lTxAYIW9wlmNBpkMOFtm/GXoCRWv8pbUH2+NSKEX8x
         7fX+0UY9LzGjvVVem5a/eEEiXaUZc3oytrEI5f91N0rT18/09PEUriXh0Mfczqt35J3b
         lzFgNrz2FnZbIfZXu/rnDzw/ErJwSJjXzblhLP3TZPHb+u/ruPDPBZiEsYOhC7BwEV0B
         gYw5HgLSwOF5VQ6gYkcuflsPjU3lv8gE7+C6qZglXF7fXMdflUQJY7t8lHaEqhSlEslJ
         xDqtmnqPBGI1p/Sx7QRPhRx1D+4EA9MCtvmGfKS/iKtb4BUaA9i2k0awx9wrLrgukKdK
         p7eg==
X-Gm-Message-State: AGi0Pub08Pp/BbcV3cCrN7C8P5sfue6S4lvHHDV1gCcH8dP1HpsLcDja
        XJLVXzaqwhFlxf0lHdwxQ1aBMdjyHOolbQ==
X-Google-Smtp-Source: APiQypIszZjwLtfzKWJkbg6ANv4kgjHqMD9Iqqo/jM+kZ4lEgybs++KRtUkURoZq/TIboSANZ+BeLg==
X-Received: by 2002:ac8:5208:: with SMTP id r8mr12614851qtn.11.1589127426897;
        Sun, 10 May 2020 09:17:06 -0700 (PDT)
Received: from ovpn-112-210.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id t67sm6225872qka.17.2020.05.10.09.17.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 May 2020 09:17:06 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] vfio/pci: fix memory leaks in alloc_perm_bits()
Date:   Sun, 10 May 2020 12:16:56 -0400
Message-Id: <20200510161656.1415-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_disable() calls vfio_config_free() but forgets to call
free_perm_bits() resulting in memory leaks,

unreferenced object 0xc000000c4db2dee0 (size 16):
  comm "qemu-kvm", pid 4305, jiffies 4295020272 (age 3463.780s)
  hex dump (first 16 bytes):
    00 00 ff 00 ff ff ff ff ff ff ff ff ff ff 00 00  ................
  backtrace:
    [<00000000a6a4552d>] alloc_perm_bits+0x58/0xe0 [vfio_pci]
    [<00000000ac990549>] vfio_config_init+0xdf0/0x11b0 [vfio_pci]
    init_pci_cap_msi_perm at drivers/vfio/pci/vfio_pci_config.c:1125
    (inlined by) vfio_msi_cap_len at drivers/vfio/pci/vfio_pci_config.c:1180
    (inlined by) vfio_cap_len at drivers/vfio/pci/vfio_pci_config.c:1241
    (inlined by) vfio_cap_init at drivers/vfio/pci/vfio_pci_config.c:1468
    (inlined by) vfio_config_init at drivers/vfio/pci/vfio_pci_config.c:1707
    [<000000006db873a1>] vfio_pci_open+0x234/0x700 [vfio_pci]
    [<00000000630e1906>] vfio_group_fops_unl_ioctl+0x8e0/0xb84 [vfio]
    [<000000009e34c54f>] ksys_ioctl+0xd8/0x130
    [<000000006577923d>] sys_ioctl+0x28/0x40
    [<000000006d7b1cf2>] system_call_exception+0x114/0x1e0
    [<0000000008ea7dd5>] system_call_common+0xf0/0x278
unreferenced object 0xc000000c4db2e330 (size 16):
  comm "qemu-kvm", pid 4305, jiffies 4295020272 (age 3463.780s)
  hex dump (first 16 bytes):
    00 ff ff 00 ff ff ff ff ff ff ff ff ff ff 00 00  ................
  backtrace:
    [<000000004c71914f>] alloc_perm_bits+0x44/0xe0 [vfio_pci]
    [<00000000ac990549>] vfio_config_init+0xdf0/0x11b0 [vfio_pci]
    [<000000006db873a1>] vfio_pci_open+0x234/0x700 [vfio_pci]
    [<00000000630e1906>] vfio_group_fops_unl_ioctl+0x8e0/0xb84 [vfio]
    [<000000009e34c54f>] ksys_ioctl+0xd8/0x130
    [<000000006577923d>] sys_ioctl+0x28/0x40
    [<000000006d7b1cf2>] system_call_exception+0x114/0x1e0
    [<0000000008ea7dd5>] system_call_common+0xf0/0x278

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/vfio/pci/vfio_pci_config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 90c0b80f8acf..f9fdc72a5f4e 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1728,6 +1728,7 @@ void vfio_config_free(struct vfio_pci_device *vdev)
 	vdev->vconfig = NULL;
 	kfree(vdev->pci_config_map);
 	vdev->pci_config_map = NULL;
+	free_perm_bits(vdev->msi_perm);
 	kfree(vdev->msi_perm);
 	vdev->msi_perm = NULL;
 }
-- 
2.21.0 (Apple Git-122.2)

