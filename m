Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403B461DF2A
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 23:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiKEWtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 18:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKEWte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 18:49:34 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E6EEE21
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 15:49:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 78so7337589pgb.13
        for <kvm@vger.kernel.org>; Sat, 05 Nov 2022 15:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KCz0wUGGf9DFLKPEgbuOihHp2vtjFuyghOURg6hGh0c=;
        b=O+yztz4GayyXI45/6kkclITGdL3k7Tx5/OS6qwzAjs3j4afTCnZs8nkJlUYrajkFg8
         u9QFw+QndH8GVKdEBSgvIioCmuOEYTMAgoFi3VUmOvbY4cJV/u4TILBtcyNDsqBnYZOF
         5bywkcNdUHL9aD4UBwfOpu0iy4ScwzIS0WfHaiT8ckxRi35yiN/QGFgS+YtbLOe31p9a
         nKXFBS4EPwchlQL8EMga/qt8xK5cR73vC7heXKVWWcOPriMzqZ8soyowLze2iz6v1jtj
         UACTe5wJt3TM//R3B9Xv7oYZeuHgVmlJ2qGl/+5gXmCUgW2KpF632/hsenvXaGcY5+I6
         +aQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCz0wUGGf9DFLKPEgbuOihHp2vtjFuyghOURg6hGh0c=;
        b=KEBAFRe+jmz2yZ36efEUMjnGUoPKR/mzWzH9qe3AeJ3o8I/KCOWFUS+eNG0aReZ8xC
         3EdVsBvYpIvDELwYrj+a51HufTYN4Rw8N0W/pebvIiNxRnd+EXkVuBBnSz2XrNRZo0H0
         xYFPt7Q9bGcHX3tBo4K3LyL0zI18c6MXrnHBhYQCW+8Px1ejtpv3THcP2Rih+avQLi2Z
         Hl1ATHoelFDbGvX1IaiRKAklE6jLarMPZOgmyCRJaWCWBzdtdLAVy59VR6geh6pX5oad
         3Ror0x5wYCQjPTYP7ek7zaF0ttS1VlL2KuC2zXOnJEekbN2shg2UoLMc+36u93POJcEK
         O2TQ==
X-Gm-Message-State: ACrzQf0VAWQa/avdbbkOAMGoV2OHfJ4OQVV47tqA4JS1OVi+uVFfxFrC
        osctiEbjQPo070eJFMUJNXsVv4AXE+SJOw==
X-Google-Smtp-Source: AMsMyM623OdXGdSzpzxYeIQb5xZelTwoH5BrWMyUXcw8cn3G27/mzX8OqdfE3nBpIcencDzSyluOPQ==
X-Received: by 2002:a63:174b:0:b0:46f:b6df:3107 with SMTP id 11-20020a63174b000000b0046fb6df3107mr567702pgx.454.1667688572681;
        Sat, 05 Nov 2022 15:49:32 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id rj14-20020a17090b3e8e00b001fde655225fsm14716728pjb.2.2022.11.05.15.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 15:49:32 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v5 0/3] vfio/pci: Check the device set open count on reset
Date:   Sat,  5 Nov 2022 15:44:55 -0700
Message-Id: <20221105224458.8180-1-ajderossi@gmail.com>
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

This revision replaces the patch that introduced an open_count field in
vfio_device_set with one that exports a new function that can be used for the
same purpose, i.e., determining whether any device in the set is in use.

The first patch in this series fixes a life cycle issue that was discovered in
an earlier revision of the series.

Anthony

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
 drivers/vfio/vfio_main.c         | 24 +++++++++++++++++++-----
 include/linux/vfio.h             |  1 +
 3 files changed, 25 insertions(+), 10 deletions(-)

-- 
2.37.4

