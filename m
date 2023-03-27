Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21AB6CA81E
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjC0OrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbjC0Oqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:46:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D1A468F
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:46:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x15so7892296pjk.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679928409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhVv6WlDwJL96Zy7vKftB7CwaSpSxc9eBC1kxbXoR8g=;
        b=jkMkTrmMDfu7jcduhsdp0OdpMDt3QaUHq6SNx6capV/KEJVdEWW7XfEzF33Ywt1pBl
         +W6mn7o9xMvYrk7fLUkQVuO8CdXWQGm0qoInrCzclweQ33w/Du0ENry7MFi6vOntnRnu
         g8mHpc0ELD0ExuFJOftOuK2MQjxJS8xDkKhvfO3ZN8oqF1Np2YrN7fNk9e6dVYKF6qlc
         0Qnb0aAYq2sI7/x+GB1MCbX/3rbFKXl93gpetxoELhg2MXe6cKzhLLwL1OJw0fXkaU36
         lJRSSgO+lQphOT3l2tMf7jOrEdM8qoS5j7PaHQi6x5HD6c7NESyriBeCWKD2UcuMXqyl
         qSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679928409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EhVv6WlDwJL96Zy7vKftB7CwaSpSxc9eBC1kxbXoR8g=;
        b=6CZf5co8C7h8kGMUbnp/F7GtlybU/ynlfIYpgnBZi3YkPUJFpxeDHiFemONWJm8Idf
         LTka4il/1TPdR+DLcB/8Qs04cTM9vpSmYHtrZdoT5g0TSD7UkFvR3GpMuCcOovnERM6R
         xJMNfuLBde7xWqj0rI2BQ0DY7JUZqSkrs/JDbzVTEsGm+G9CSknNtzsUqhFm3GFj33Z1
         od5NGpAbSzzGwb6hvp/EbvIuOE3pNKUa7BRStlV1QfGkzyEJbiNrvaYWLD3uChYMEn/f
         1dDM90CikkshgsnJK15jA/AUFrV8S9UHWv0DteyJLwgt9okJw+iZcHN5G0fcHfxlYJlc
         i+OA==
X-Gm-Message-State: AAQBX9ecxj2eEZKfmIfgIA5jmacde0gZIr+FYsgOGn3SDiEsxSmG5Uht
        cN91oP+GQ44cMnwb5YTc3TQ=
X-Google-Smtp-Source: AKy350aV3IBryUWOhK8ye7hkpcR3bqYjgYOmYRSs7lgKumH3OA+cjpGUaC5zPEf6K59so4r+eOvSQw==
X-Received: by 2002:a17:902:e749:b0:19d:244:a3a8 with SMTP id p9-20020a170902e74900b0019d0244a3a8mr14196693plf.10.1679928409088;
        Mon, 27 Mar 2023 07:46:49 -0700 (PDT)
Received: from fedlinux.. ([106.84.130.102])
        by smtp.gmail.com with ESMTPSA id s21-20020a170902b19500b00183c6784704sm17368276plr.291.2023.03.27.07.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:46:48 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        hare@suse.de, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v9 5/5] docs/zoned-storage:add zoned emulation use case
Date:   Mon, 27 Mar 2023 22:45:53 +0800
Message-Id: <20230327144553.4315-6-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327144553.4315-1-faithilikerun@gmail.com>
References: <20230327144553.4315-1-faithilikerun@gmail.com>
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

