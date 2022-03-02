Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3734CA786
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbiCBOJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242788AbiCBOJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:09:55 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E89338BD
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:08:51 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id b7-20020a05600003c700b001efac398af7so678138wrg.22
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lp9zEaIv1S7ZBdqtPNsd+5mYg9mGXB6Zu8tr2wXg9a4=;
        b=DRaPF5fNY/BernAWTuDUoEGJ+DCvOQP/R6LOZXSoloKXxCxKNTf7P4DIAyXln1G4qT
         fBtxpuEVmqlR74bOGGsqTH+1RellxjU4iM9z8GdjSw9ltdCbeSsCUTJ+tAilJJErt71/
         jy73Nx7nXSIWhT4tbAfblXGAT7pULkeFFFQReA8HKM/9WQBlYlvsbuaMWy09nYmxzCM1
         MtGFpfuAx9r6ACNG5FPKQft5s4ggMv2a284dJnT5Vm2wNo3zsTXFBt5zqLvUrDyJfSzN
         ycGWqFCBCAwPIPpAfjGkcft8kvOva4eLWIxq8vcdHiIvzxxoFmlme9MRkqlx98ZXyQ33
         LKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lp9zEaIv1S7ZBdqtPNsd+5mYg9mGXB6Zu8tr2wXg9a4=;
        b=00+mtqRVuGnk1JM6/UUTD1txz+dClmyWQBoOmD6X2Wxq/Tf7VZaa6KW5Tvs8YdxHuH
         KNqaxmdvaSy8AeQ6ZzDHa97jYUD/d69QZveRc/N/XGueUCqPPgW65o3K4jpdIek5ZLdK
         OpwsTMbLo960X+4dfJss8dvHQPwIHy58WQPYcgRbrZI2JIDXfKmjjkoGSA6EnVjGarIu
         U0NiDMvMYX75/HUGDEfk7RPp/LKBdLDM6iQH0FRi6/bcltQf9lzw1d48KaBOkIMW8kYg
         NuKCLCujv28z/Yzsqmwa7nwxPJXh9ZQB9zGkF5gAtUdUhKZR746hu4i2jDMy8NvFMQ5u
         BMAA==
X-Gm-Message-State: AOAM533uC+akBXpadUysg/3W/JivHzdcUpp9ybNnffjJXDzvW19beZp9
        MvK8JDfV3VmbBkqWHdBWcgCY7ZjD/U+gpmOUvLNn6cWAK9pIi6klGW+jmT/6kPBwYSueDi6p4WL
        Hq5iIg+gTiv8IUwQFJuMFQlCRUSEvO6JY3Ty/noYG11hwwqeWJOVi7clIuob1cbDxEWU89cvUKQ
        ==
X-Google-Smtp-Source: ABdhPJw6N9e7jtLkHBc4dWy0BeHH2pQI2EHtLYbs8cEU56ynxaYFdF3wbWy63gxs9iGvZsPsey1G4jU0Bh98dAjfmMI=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a1c:4603:0:b0:381:19fe:280b with SMTP
 id t3-20020a1c4603000000b0038119fe280bmr20695290wma.67.1646230126801; Wed, 02
 Mar 2022 06:08:46 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:07:32 +0000
Message-Id: <20220302140734.1015958-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v7 0/3] aarch64: Add stolen time support
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches add support for stolen time functionality.

Patch #1 moves the vCPU structure initialisation before the target->init()
call to allow early access to the kvm structure from the vCPU
during target->init().

Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
new MMIO device PVTIME after the RTC region. A new flag is added in
kvm-config.h that will be used to control [enable/disable] the pvtime
functionality. Stolen time is enabled by default when the host
supports KVM_CAP_STEAL_TIME.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

Changelog since v6:
 - fix perror number of arguments

Changelog since v5:
 - propagate the error code from the kvm_cpu__setup_pvtime() when the
   host supports KVM_CAP_STEAL_TIME but if fails to configure it for
   stolen time functionality.

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |   1 +
 arm/aarch64/arm-cpu.c                  |   2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |   1 +
 arm/aarch64/pvtime.c                   | 103 +++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |   6 +-
 arm/kvm-cpu.c                          |  14 ++--
 builtin-run.c                          |   2 +
 include/kvm/kvm-config.h               |   1 +
 8 files changed, 121 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.574.g5d30c73bfb-goog

