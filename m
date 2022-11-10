Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9D2623902
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiKJBky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiKJBku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:40:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C63643D
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:40:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso392488pjc.2
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=McTwQph3CTf+9xjii6/A+k7sMMV3kDJaUpMswvqyoTc=;
        b=Be2S2x6UpUnSRVCz5nU/gkUMtduVfVI1FTUXeFA85iDmtTsXpOF0jEKEO1XrE+ZeWw
         Ad0u9IB+Ic/y/30PXCMA/06kVYbHeogHlgA1nTvVc0ME+EOwzi4ghw1CY4IHHdvOXpp4
         bBzycrPwz2cPhnXrYDYpsPTeccTNyxsePscuFiEuwQzbVdLvh4cUoin2HgjIqAcEYfLb
         Fhg9F7XFNp/dmMC5RdwtwnG/iP3pblgLAwpPFt9U6ibqx1vcB0HidVi+6HJXBIzAhlT0
         ZKJjmWyepZ9Ky88We1D9SH57Wu/f3+c+pa86YTFZj+XPi5wf+iNBx2QAcfiVSWvYfxli
         w4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=McTwQph3CTf+9xjii6/A+k7sMMV3kDJaUpMswvqyoTc=;
        b=Ft3sLWQoBtRMvyAOB6IYPkAHBz+ifa7My+aJDZMfCr/9W7XCzCFaQkjTkbTPdWU/vS
         pZqGvGqLU+M78F+2Jv3s51c9IKUqx4Xnu+m/68jNpJEwyXs2GJ+fqhT1In3+zX8JYGw0
         o4svb33YDY8SHtEUG+06irTENQmNL0hqRHsi33jNcOvKjwLMbuLgql4rqCPLUvgpzYan
         6zlXMsa6a9s0/sF+mLYdWdd9B+IcqlBSW3S+gc0UgmwCpGl2u4UFdm/ynAzbzvotdWSL
         B3tdx8PCBZo1eC+AuBhv4SxSBT+YnNO0WZ1qsDa3mAf7l9TzSvGW6Y1KcYYs+fDXGY12
         RddQ==
X-Gm-Message-State: ACrzQf1e4vZXqHSBUJA1dw+WJRkykRGvqOjMBYR6R4eKnB8ip82ZsBjr
        Gc/+sPwAtocchRNm2D9vTMMH5kOuCxTUng==
X-Google-Smtp-Source: AMsMyM7tlVeWAfMgR/jHJ/6OzSjFMSKh9xrgnuqHSmKkzpxcVdv3b0Yj3pX8jx7fh0JXg15dB8k6Rg==
X-Received: by 2002:a17:90b:1bc1:b0:213:e2af:b1f4 with SMTP id oa1-20020a17090b1bc100b00213e2afb1f4mr55918535pjb.47.1668044449588;
        Wed, 09 Nov 2022 17:40:49 -0800 (PST)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id pj4-20020a17090b4f4400b00212cf2fe8c3sm3091836pjb.1.2022.11.09.17.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:40:48 -0800 (PST)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v6 0/3] vfio/pci: Check the device set open count on reset
Date:   Wed,  9 Nov 2022 17:40:24 -0800
Message-Id: <20221110014027.28780-1-ajderossi@gmail.com>
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

This series fixes an issue where devices bound to vfio-pci are not reset when
they are released. Skipping the reset has unpredictable results depending on
the device, and can cause errors when accessing the device later or binding to
a different driver.

The first patch in this series fixes a life cycle issue that was discovered in
an earlier revision of the series.

Thank you Alex, Jason, and Kevin for your reviews and feedback. This revision
includes the changes suggested on v5, but without any changes to
vfio_device_set_open_count().

Anthony

v5 -> v6:
- Added a call to lockdep_assert_held() in patch 3
- Corrected "vfio_container_device_register()" in the patch 1 commit message
v5: https://lore.kernel.org/kvm/20221105224458.8180-1-ajderossi@gmail.com/

v4 -> v5:
- Replaced patch 2 with a patch that introduces a new function to get the
  open count of a device set
- Updated patch 3 to use the new function
v4: https://lore.kernel.org/kvm/20221104195727.4629-1-ajderossi@gmail.com/

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
  vfio: Export the device set open count
  vfio/pci: Check the device set open count on reset

 drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
 drivers/vfio/vfio_main.c         | 26 +++++++++++++++++++++-----
 include/linux/vfio.h             |  1 +
 3 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.37.4

