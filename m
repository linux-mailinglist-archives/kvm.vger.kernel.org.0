Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A85B6DAA08
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjDGI0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 04:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjDGI0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 04:26:05 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D806AD1F
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 01:26:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id go23so1260199pjb.4
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 01:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680855960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhVv6WlDwJL96Zy7vKftB7CwaSpSxc9eBC1kxbXoR8g=;
        b=Lx7+IWlNZLpFPLspcDDgNsLn9e2v//1yXAAvdd8sSWT6nYo0r3FYRVcNZihGKzv4Ya
         Zz510KNt69TIkVFlEBKaCAx50782oYI6nDQxlm4P/KbgoTTmZ8eiVdRB9BshokftPO5e
         npmDH8wZEFXuY2E0FRBVxQa5fWcLLovMCxrd6M61+EhLv6bmeft8Civ2ErDKQavpkh95
         sp/Bml5QNBieWS9je9OAoEUlHmwMZ5vACf1ZlSLfVuvakaCtfGW1HrxHZd5oZ/zmjGqv
         CCDchGWS4FDgeIEteVgfPjf+8nH8QDQTjFjLl7Fd9Amu/ktTnV1onIYSp5W9fVRybr5G
         tGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680855960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EhVv6WlDwJL96Zy7vKftB7CwaSpSxc9eBC1kxbXoR8g=;
        b=YmsRXWaq9g3MrrzyqJPD0CmU3IU4Yjr2/daAiXZ8+RsjaPemeV8txKYM4Y0/aZOU2w
         eGiat/MZlO+MJBrFjIMxEVnJ3mA7Oz3wefMswVlUNsvTmfFdu4TYA81+7rITtXKOSNvP
         0gNVZDmSzsnK2tg68vS55LgKKSymyLp/XvVPtjAKdHjlROnYfUyhoXt+CnHSHBptcF9j
         cSYWU70ymqhEEJWjpjuaorS12EOiaLzA/+2YTwRzPlovgtG+YhjM5SZHR0kZA6Z3mKV/
         pj7X1yxJHZjO9WW5NO9DdSJlQ46Qrs7G5jqwsjwCMPm65f5zzifDJ3hK223hNNSs9hZ/
         3Bgw==
X-Gm-Message-State: AAQBX9czK4J5+mFCV7YkfTlGK2iD9IzJ+ul3NyXrAJMW5+hwNH9yY2OQ
        8rR0O14Ft/BF4rHMULYLZ7k=
X-Google-Smtp-Source: AKy350b7xmI9h98+hauaLK6B8e+TPhEgpy3X5dFcvJxzYydogAVxS9xPpHLoTYKTkebcQN6udPPapA==
X-Received: by 2002:a05:6a20:8593:b0:d3:45f8:256 with SMTP id s19-20020a056a20859300b000d345f80256mr1844602pzd.60.1680855960384;
        Fri, 07 Apr 2023 01:26:00 -0700 (PDT)
Received: from fedlinux.. ([106.84.131.166])
        by smtp.gmail.com with ESMTPSA id fe12-20020a056a002f0c00b0062dcaa50a9asm2521331pfb.58.2023.04.07.01.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 01:26:00 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        damien.lemoal@opensource.wdc.com, qemu-block@nongnu.org,
        Eric Blake <eblake@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, hare@suse.de,
        "Michael S. Tsirkin" <mst@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v10 5/5] docs/zoned-storage:add zoned emulation use case
Date:   Fri,  7 Apr 2023 16:25:28 +0800
Message-Id: <20230407082528.18841-6-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407082528.18841-1-faithilikerun@gmail.com>
References: <20230407082528.18841-1-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the documentation about the example of using virtio-blk driver
to pass the zoned block devices through to the guest.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
---
 docs/devel/zoned-storage.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/docs/devel/zoned-storage.rst b/docs/devel/zoned-storage.rst
index 6a36133e51..05ecf3729c 100644
--- a/docs/devel/zoned-storage.rst
+++ b/docs/devel/zoned-storage.rst
@@ -41,3 +41,20 @@ APIs for zoned storage emulation or testing.
 For example, to test zone_report on a null_blk device using qemu-io is:
 $ path/to/qemu-io --image-opts -n driver=host_device,filename=/dev/nullb0
 -c "zrp offset nr_zones"
+
+To expose the host's zoned block device through virtio-blk, the command line
+can be (includes the -device parameter):
+    -blockdev node-name=drive0,driver=host_device,filename=/dev/nullb0,
+    cache.direct=on \
+    -device virtio-blk-pci,drive=drive0
+Or only use the -drive parameter:
+    -driver driver=host_device,file=/dev/nullb0,if=virtio,cache.direct=on
+
+Additionally, QEMU has several ways of supporting zoned storage, including:
+(1) Using virtio-scsi: --device scsi-block allows for the passing through of
+SCSI ZBC devices, enabling the attachment of ZBC or ZAC HDDs to QEMU.
+(2) PCI device pass-through: While NVMe ZNS emulation is available for testing
+purposes, it cannot yet pass through a zoned device from the host. To pass on
+the NVMe ZNS device to the guest, use VFIO PCI pass the entire NVMe PCI adapter
+through to the guest. Likewise, an HDD HBA can be passed on to QEMU all HDDs
+attached to the HBA.
-- 
2.39.2

