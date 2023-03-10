Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A416B3CEC
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjCJKz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjCJKy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:54:56 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AD3110506
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 02:54:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u5so5122391plq.7
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 02:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678445679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QRufKAyLxjKGlTDzNK5hk1ALQxFTVsjBVFZl5h8MydA=;
        b=Pd8khHHe5CImWDnZWtfulUJX5UhYX8a7z564TFkj8Nt/QHu4iWBP1qTs2ck/5aXTuY
         IoSWRiUJGc36qr67An4Ji9vkC6Cv4BsF2osXvmRXm1qU6XFKBCqcuX3S7XHGI1+ldQD9
         sHbsIjfY0wPmX0PftJwvCRCPXo2iYo3Y9pl2aS9RPQoYGATkbSjhOpRPgITIJXfiD0Yv
         axkO6LPNwbmFMUwnsoO0a8QUvu3S8FM4CzGS62qGwEuHFHIUsHC+Y4vROskyawvgPsV4
         eq7ssqy4+VdhLHd5hXeBO8uVT3fAnVFE9Rj8tyl3WDwnTszGgaj/iXcCGS0IRlnw0ORR
         QpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678445679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRufKAyLxjKGlTDzNK5hk1ALQxFTVsjBVFZl5h8MydA=;
        b=sPcGiwU2IBXgfrFHZAMFcw+MnKToRBiktz5LSz/M8/L1eOiUIXQORrklWOPqTI5OFM
         z4zFokwHzwbZhvOtstAYP3tysGPAKH0vLO4kkC1Q+CjhyavCY7pxhQcrL3diV9wuk58c
         Q0sP3vMyNGaQwpHIYjySEwXItFYWqb7+Dh8hSD14Z9caK12R/NooO0ldULKvMrimPwuc
         DGa93xXGWq5oh+UjzAN3hMIzohrwK8Y0GvdUMC6SqewIdbUphUjfgdzrsginJaNdl2iJ
         Qs3Szmn1MfSo00HWq0GaBb1eOC394vvmmq+6kAAd5nbsHTs5kW4ztwSErhdbqN3RjNL0
         P5Bw==
X-Gm-Message-State: AO0yUKUWFh5DP4evr+DwPn86aCrBU7m91Uto8z54MKoQT0jj/RxhiRoB
        cBbQDaSRkmpzkYYbff1HaH0=
X-Google-Smtp-Source: AK7set/RBLqWR0HY4X5t25XP0S1kcx8Er/mPJE7Jhr235ZJDdcnvw9Xl/Wq8hhReib8559oSP8MDlw==
X-Received: by 2002:a17:90b:4b44:b0:237:72e5:61bd with SMTP id mi4-20020a17090b4b4400b0023772e561bdmr26849538pjb.49.1678445678848;
        Fri, 10 Mar 2023 02:54:38 -0800 (PST)
Received: from fedlinux.. ([106.84.129.9])
        by smtp.gmail.com with ESMTPSA id j9-20020a654309000000b00502e6bfedc0sm1081397pgq.0.2023.03.10.02.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:54:38 -0800 (PST)
From:   Sam Li <faithilikerun@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     stefanha@redhat.com, damien.lemoal@opensource.wdc.com,
        Hanna Reitz <hreitz@redhat.com>, hare@suse.de,
        qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dmitry.fomichev@wdc.com,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PATCH v7 0/4] Add zoned storage emulation to virtio-blk driver
Date:   Fri, 10 Mar 2023 18:54:27 +0800
Message-Id: <20230310105431.64271-1-faithilikerun@gmail.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
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

This patch adds zoned storage emulation to the virtio-blk driver.

The patch implements the virtio-blk ZBD support standardization that is
recently accepted by virtio-spec. The link to related commit is at

https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad15db65af8d7d981

The Linux zoned device code that implemented by Dmitry Fomichev has been
released at the latest Linux version v6.3-rc1.

Aside: adding zoned=on alike options to virtio-blk device will be
considered as following-ups in future.

v6:
- update headers to v6.3-rc1

v5:
- address Stefan's review comments
  * restore the way writing zone append result to buffer
  * fix error checking case and other errands

v4:
- change the way writing zone append request result to buffer
- change zone state, zone type value of virtio_blk_zone_descriptor
- add trace events for new zone APIs

v3:
- use qemuio_from_buffer to write status bit [Stefan]
- avoid using req->elem directly [Stefan]
- fix error checkings and memory leak [Stefan]

v2:
- change units of emulated zone op coresponding to block layer APIs
- modify error checking cases [Stefan, Damien]

v1:
- add zoned storage emulation

Sam Li (4):
  include: update virtio_blk headers to v6.3-rc1
  virtio-blk: add zoned storage emulation for zoned devices
  block: add accounting for zone append operation
  virtio-blk: add some trace events for zoned emulation

 block/qapi-sysemu.c                          |  11 +
 block/qapi.c                                 |  15 +
 hw/block/trace-events                        |   7 +
 hw/block/virtio-blk-common.c                 |   2 +
 hw/block/virtio-blk.c                        | 410 +++++++++++++++++++
 include/block/accounting.h                   |   1 +
 include/standard-headers/drm/drm_fourcc.h    |  12 +
 include/standard-headers/linux/ethtool.h     |  48 ++-
 include/standard-headers/linux/fuse.h        |  45 +-
 include/standard-headers/linux/pci_regs.h    |   1 +
 include/standard-headers/linux/vhost_types.h |   2 +
 include/standard-headers/linux/virtio_blk.h  | 105 +++++
 linux-headers/asm-arm64/kvm.h                |   1 +
 linux-headers/asm-x86/kvm.h                  |  34 +-
 linux-headers/linux/kvm.h                    |   9 +
 linux-headers/linux/vfio.h                   |  15 +-
 linux-headers/linux/vhost.h                  |   8 +
 qapi/block-core.json                         |  56 ++-
 qapi/block.json                              |   4 +
 19 files changed, 765 insertions(+), 21 deletions(-)

-- 
2.39.2

