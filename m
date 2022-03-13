Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345344D76B2
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 17:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiCMQWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiCMQV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 12:21:57 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFAB8189F
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:20:49 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id 187-20020a1c19c4000000b0037cc0d56524so8350807wmz.2
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7Wuv74yKEdjvXwkDK4Px5jJ6apmvoxE3JexOVM2IrlA=;
        b=iY3hG+5rhqP1jTbLxBqEjg7UKqAVd3z1+Xn1s989OYEoEP58Mt06JFjWzVY9NaHdvx
         UYKBUJeJBjZMNIv4z1pwHDUuGgRrEn78BScFyF3hRQjsSUQu9wqB/C+y61zUYUGP4A1P
         hh1/8TMy633VEWtNzhec4Y5CtClTWkv1ADQjYxCDIBOQyb96WN4GXMJflCNxJw1R+/s+
         oBDvqgblv75f2euQZLZtk1YJUoS+jL3mj8xX/0iB6VYPi0q3KeJT6TWqwPuPrklBih55
         o7S5ZlQig3NOqekLUo2GEDjpPAONDx/QJrhS+q0pTixqVuFGTKIDHc6ixnMAwaGDFAGy
         p4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7Wuv74yKEdjvXwkDK4Px5jJ6apmvoxE3JexOVM2IrlA=;
        b=ir+6C5qC47WoeHctY6jkrQLKo27OVYxikTCUvTirIifJAIk3yBueQXDXWrI38eoSc4
         rqunevnvB6icBb4fsL852GlzQBUhRAsTc+0dXzG82zX7n+Nono3To+ukFyld+Ff13gRs
         x4mkyM+ku/9aC+2HpZDAlvKAFLEsq9968lgQUM05RO95Zhm7FIB/b6I+/sPl0SQPmw8T
         X8UaNFKX+pNJuyByo/RDxhqXyhgPWxN65Q/Moq7LCfXM7iwkIK5djvUbhhNlIW6NbyRn
         0ZOk9qXoIsqnCSFd4Dq9GnMliJMFVuY01o8+x+zt8Vo2v6w0UDvs+EwxwoCQ4O5xPy8A
         yMuA==
X-Gm-Message-State: AOAM5327O+O6NYbE6QrbXilfxX5Lhml0iRsM8htG/nb/BNLkFlGKrzI8
        /WqnTNVahq465oR8yLB3JQGeZmmvt8UKsU6iTR77++4MgnTlEv5RYoHdcOQmX3oeyvvtVIS9Ds9
        VY/atJq4DxUo+kKlo4nVv+4Gsxlvgt9GUqMR6ExZQP1bi3RVeuz3HC5w0206dzJWM0p+Lmuxvzg
        ==
X-Google-Smtp-Source: ABdhPJzhl0gG4Adi0f1C2JUggqNP47tmOd8Uoc7ehQMllk4ZVnR5xcuRb7esdtvPuDku6DzyyiErK0ckKl/qUiNOx2w=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3589:b0:389:cf43:da61 with
 SMTP id p9-20020a05600c358900b00389cf43da61mr17863422wmq.203.1647188448234;
 Sun, 13 Mar 2022 09:20:48 -0700 (PDT)
Date:   Sun, 13 Mar 2022 16:19:47 +0000
Message-Id: <20220313161949.3565171-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
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

Changelog since v10:
 - set the return value to -errno on failed exit path from
   'kvm_cpu__setup_pvtime' 

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
 arm/aarch64/pvtime.c                   | 98 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 15 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 9 files changed, 123 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.723.g4982287a31-goog

