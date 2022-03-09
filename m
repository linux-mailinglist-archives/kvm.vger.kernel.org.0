Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93D54D3005
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiCINfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiCINfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:35:48 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9185313CA09
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 05:34:48 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id h131-20020a1c2189000000b003898de01de4so794162wmh.7
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 05:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dokf1L1DcB0O0VLOB3TkhFW+LY85aXQ0eck+ZVRatB8=;
        b=YpBphMrptWtHb7Tzy/ZX5BIQjBBk41hsObZ38Mb+lx+0WzAaPxube1C8l5QTA0q8QY
         NEMy9cnU/6JNxG+Jg0zDGwbWRKScx0AA4SMChZ6k/qIkYU0r1dL5A5f8kLsRdH7mSRMF
         R4ISB4AUBGDOju1MFcSFG7ldWl3UgvA8NKM0phSYOWt3eOQSVy3NvJMzV7blLzRMgmox
         NzfoMvDwmptvzsWKKGimKoeHoQvNiCZhRlKCEaXoZneKCaN2RjhUPQcZoFdYFJC2r+qd
         pXQM1FyIOSba948R8merQO84LF/zITx7q95YGNzfXpqIYjavHyjPrbCw/pXwJzd3R+xD
         KF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dokf1L1DcB0O0VLOB3TkhFW+LY85aXQ0eck+ZVRatB8=;
        b=nrl3l+Amygvn7IJ3McppMLXeY2Np7FFzNBwYkrGldOImYCt18j+K1/AGLIrK28yFRM
         akLhuaiOmufTwepD5kMZbbMU4lNutZ2SjmH9Pn3wMbZOXFBMt7lcPLm99qHOLpwElty2
         fZo/FX/FGDjlJoQIqZhkZuQ1PDR2X9pqssXaTLeXBZRtV6ycFiWoSxckxH+2WEpt2j1f
         TU2ObGnZyKTudUhYXhMC5eS120GBeMg8LEix8+raZbtNJD9QV1rfbAc6FHiz+1664Fve
         3b6Wa8VSprOv1/M7Jz6llwHejiIqrUN0/ZsAtwpBgtHbMTNamlMlVE2EDlYA8Jg2vCMQ
         X7Qg==
X-Gm-Message-State: AOAM531z3FSbCw5LPCAlLmSYRa9ZnF/wRJCqYcR0V74hTpBlHh59lB/x
        lNu4R4kfz7fngma56EqKi2WbgDeDA7Ah8UQtrCL187NnAKJtME+9hUtNrGD24JiSBIPduKM+cMd
        HghDSododc/xk3x4WvGuuSKX+GuvehRBgFu4PP+D5TH04zgyg6OCUT3xpWrRzd8bh8spc144w4w
        ==
X-Google-Smtp-Source: ABdhPJzkoT06S2zRXct/lGgKvjH2V/DC4CxhP4eldTjDyxbrfGwfBjeqyyUvG3t6ZRZCmNMjS24IDOd99cUM43UTK/s=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3203:b0:381:b544:7970 with
 SMTP id r3-20020a05600c320300b00381b5447970mr3375662wmp.144.1646832886940;
 Wed, 09 Mar 2022 05:34:46 -0800 (PST)
Date:   Wed,  9 Mar 2022 13:34:20 +0000
Message-Id: <20220309133422.2432649-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v10 0/3] aarch64: Add stolen time support
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds support for stolen time functionality.

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

Changelog since v9:
 - use the `attr` field for the 'struct kvm_device_attr' initialisation
   with KVM_ARM_VCPU_PVTIME_IPA instead of the `addr` field

Changelog since v8:
 - fix an error caused by kvm_cpu__teardown_pvtime() not beeing defined
   for aarch32
 - cleanup the pvtime setup by removing the flag 'is_failed_cfg' and
   drop the 'pvtime_data_priv' definition
 - add missing Review-by tag 

The patch has been tested on qemu-system-aarch64.

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |  1 +
 arm/aarch32/include/kvm/kvm-cpu-arch.h |  5 ++
 arm/aarch64/arm-cpu.c                  |  2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  2 +
 arm/aarch64/pvtime.c                   | 96 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 15 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 9 files changed, 121 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.616.g0bdcbb4464-goog

