Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6A6C7CE7
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbjCXKyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjCXKyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:54:35 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E896524BC5
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:54:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso1206086pjb.2
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679655273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhVv6WlDwJL96Zy7vKftB7CwaSpSxc9eBC1kxbXoR8g=;
        b=gXVgrp02erv9bGOl+1wrQaqYmvmK5Q2Bt6FFIwqwsS9539pxlPyZ95K+66UNYRZI2b
         BfZdbgr1dxScQopCUo5DGu0LLK4tvsWQAO26r277nZGU3ohS+8E+cOIpXbdX8gPSe+B2
         Dj8ueMkC/1161X3FIXLMZ1sNk15ZU4wCPejt6IKIvUmTy9u30/aFFn7yjY7GnM6reAAL
         u29U5hyO/Nb1hDP9c79IWQ3PVyEOt9hsTkRdLX+qw0zlTKc2vvhczJ7QKl4j4iii+5Mp
         VHFyIr4vJ/0AGyprg7IHp/oA6AjHDGrxtSizkAgFzLWhhkkgtrLcuDF9crxno3llsSIH
         lWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679655273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EhVv6WlDwJL96Zy7vKftB7CwaSpSxc9eBC1kxbXoR8g=;
        b=1SqxOLXImZQmB/zxdUgYcQzEYnYE/gYBuo6/FHujOAGqFHi/D4WebcW7rMaXQlq4/7
         BzIsGWqp6WRL4z//VlpzJCzc13obS2QDLe6v/dbRjvoU4WAtY75U0p1uhFvOMJwodMxA
         ma9nNyOaMkWL+FvLVfkis+KJyoJSwjz0Nk61vQJEkNjf0ShPJMK1LO01B5OKv4zOXw6W
         rEDlQiR9/IOKBL7P+EJti3G+bp9+VnC9HvAbaCm9TBV+T9m3yTeXXJYD36YvkMuBxcsp
         pdQKBHs1ePuy9BKbY747CMbFM3NFaQto4sK9C24SOaeu/eLCnuZTuV5gCIJ8aW05jMGB
         HAOQ==
X-Gm-Message-State: AO0yUKUT7fH3z2uEa1pNs3jHi+m0wXG9JA3G11o8Rftr1MtommQp1pGD
        CymYNt34sIpMdHHLycIxtO0=
X-Google-Smtp-Source: AK7set8RuwFJg1oKhPOf2dU/0CUWCkXcuPlzpmAxnKmcGZX+OPLOwf46uNOtDyknLd31iRliBhDubg==
X-Received: by 2002:a05:6a20:c525:b0:d4:b5dc:2909 with SMTP id gm37-20020a056a20c52500b000d4b5dc2909mr2824300pzb.28.1679655272943;
        Fri, 24 Mar 2023 03:54:32 -0700 (PDT)
Received: from fedlinux.. ([106.84.130.185])
        by smtp.gmail.com with ESMTPSA id bn10-20020a056a00324a00b005d72e54a7e1sm13617355pfb.215.2023.03.24.03.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 03:54:32 -0700 (PDT)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, stefanha@redhat.com,
        Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        damien.lemoal@opensource.wdc.com, hare@suse.de,
        kvm@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        dmitry.fomichev@wdc.com, Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v9 5/5] docs/zoned-storage:add zoned emulation use case
Date:   Fri, 24 Mar 2023 18:54:18 +0800
Message-Id: <20230324105418.3752-2-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324105418.3752-1-faithilikerun@gmail.com>
References: <20230324105418.3752-1-faithilikerun@gmail.com>
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

