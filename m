Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473AB61A1CE
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKDUCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKDUBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:01:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C72A45EDE
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:01:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so4336099pjs.4
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EvGUrMa/u0hxMIUmorY6igvGoFq7HvQHH8kTghmCjRk=;
        b=Pr2mWixRvOM0jggMca/E3p9Bwz7vdYnnSab4wzzmO96xO+Ewjqj5XQU1ls+RSg0vGP
         Ae19OvcFG35sRgf4QpD8ve29iKnbuuWFT3FOwo2UqKoPUz4PVnlwHWckU7xhxSdXwi7J
         SPxHLR0igvjkzmESYvyEptgs9Fd7oyAiVmBLgdbB4pL6C+CGdIrZOjoVzTk7g0DLRYJS
         d6VI1tcun07cI2e5KljOSXJGuM6v5//hbiuJJpiancGxAs9lHOuQ7Oz69Ma98INkNBQf
         8/r2jZZPbUzOFrHt4gFrMSck3B7zzplZywpMki6a01w9ISH225rNSXWYeeOSWrWduCyP
         0yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvGUrMa/u0hxMIUmorY6igvGoFq7HvQHH8kTghmCjRk=;
        b=0QEJXToOVESkGr7V0FXG8jm2fU68FoHs4McDJcMcNnqKDREtTRRie4RjQSuUgCLC70
         G7YuuQjXdj6FmrRZzwlxHpgHkVF2WrTZff+l7nYZwBfW2nNke3bJ35tGPtlYNA6Rdeha
         LIFwHDg441jOlOtoOl4kSwX8xuKYbozReP64f941jXlyAghs/mRXzK70qMD/wwQtmnAh
         yujKWwO1yF9YcgblnpO0lLBogAvSbB/V8A+snt6R2xd7ZHcrp16j48YLTB1Jd6+Amrk0
         DLYrN8Uk6bW1XHLWMJK3YstX3TQW253fXPjIvaOe68+RAP4D5JrVJyjfjfXXuinlysRK
         zjlA==
X-Gm-Message-State: ACrzQf2v7yUMZhOxRfrvPzAmzDpwACRZFCWNNhtY9ZxGNdlRVCXx11kW
        Tv7hNOK37jGSvn16+LRFzZ3/o0Au4mTItQ==
X-Google-Smtp-Source: AMsMyM7Y69yjiL6xl7L1jLUQlYk0BDivoWNT6AQpZET+Xkz/B8hi4R4+CtWxYxs4Z/MOSgNX/vngYg==
X-Received: by 2002:a17:90a:f001:b0:213:bf4:ee29 with SMTP id bt1-20020a17090af00100b002130bf4ee29mr54528400pjb.98.1667592086991;
        Fri, 04 Nov 2022 13:01:26 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id q23-20020a63cc57000000b0046f6d7dcd1dsm122545pgi.25.2022.11.04.13.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:01:26 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v4 0/3] vfio/pci: Check the device set open_count on reset
Date:   Fri,  4 Nov 2022 12:57:24 -0700
Message-Id: <20221104195727.4629-1-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I took Alex's suggestion on the v2 patch to add an open count to the device
set. This simplified the final patch and might generally be useful for other
drivers.

The first patch in the series fixes a life cycle issue that was discovered
while adding open_count to vfio_device_set. It is also fixed by a patch [1] in
Jason's "Connect VFIO to IOMMU" series.

The third patch is a rework of the original fix that uses the new device set
open_count instead of the private open_count in vfio_device.

[1] https://lore.kernel.org/kvm/1-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com/

Anthony

v3 -> v4:
- Added a patch to fix device registration life cycle
- Added a patch to add a public open_count on vfio_device_set
- Changed the implementation to avoid private open_count usage
v3: https://lore.kernel.org/kvm/20221102055732.2110-1-ajderossi@gmail.com/

v2 -> v3:
- Added WARN_ON()
- Revised commit message
v2: https://lore.kernel.org/kvm/20221026194245.1769-1-ajderossi@gmail.com/

v1 -> v2:
- Changed reset behavior instead of open_count ordering
- Retitled from "vfio: Decrement open_count before close_device()"
v1: https://lore.kernel.org/kvm/20221025193820.4412-1-ajderossi@gmail.com/

Anthony DeRossi (3):
  vfio: Fix container device registration life cycle
  vfio: Add an open counter to vfio_device_set
  vfio/pci: Check the device set open_count on reset

 drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
 drivers/vfio/vfio_main.c         | 16 +++++++++++-----
 include/linux/vfio.h             |  1 +
 3 files changed, 17 insertions(+), 10 deletions(-)

-- 
2.37.4

