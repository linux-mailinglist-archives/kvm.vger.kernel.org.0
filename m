Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7504CA6F3
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiCBOEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242250AbiCBOEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:04:48 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46617EA1B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:04:04 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id o1-20020adfe801000000b001f023455317so683911wrm.3
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hPKuRtrZ7FciAHN0houkzwDHAjhc6VOJutEOMHbNfWA=;
        b=jbv65BHk8GqJHm2EmtbEtTPoARICcpi/WQbKKS7FdWkuEKfUHNCM48Q0jsI78A8yES
         4vRerRTJR0n75FIpBbWVkuk/iCG6UzT7EbwwcSveeIB9NRMBrZx/aDW4FQ+GptlpOzp5
         IWo9O9SLj9jKlhLeW7vEVl+Eggj9RlwN+5BElRSd84yMsO2D3T1TUCxrs9QShQOj37fZ
         Fxy7Jn5p3ZHFTXwIRDF5O25joN6L1FttWSE2bitSxTsUbxhjfRhc/BHdM6WVK++qXrq7
         GElNl7Uvw/Dapkyo9GSKF8shRbFBBeYiy9q3uY2udVW8kvAuHnOl4xFwhSOP70f+dx/N
         SoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hPKuRtrZ7FciAHN0houkzwDHAjhc6VOJutEOMHbNfWA=;
        b=m0eorSD3KiGPwVV6X6EVN2m9yOvLJtx0NfFjPCN9GkhnoEK+1/AFF8urWDQ2WsS3z4
         E6F4nSMGvPQPfcNyaRy1BKcVxkFFwWnCV25NeBwSdHS5m4KzvmUBrSXdyWSglVZ1Ndlg
         U+8ThVKDsg4RbHbXMAyh4goHIZ+ibGPlMEVg2fgULazW7j1wSUCAsVuuy+UOpRFX55um
         XtuALf9Y4cEYqPZGT3+/ed2j6ccReKGIe0wbOkDbkRzAugIGr7jnE/E+HjhRN4thKyWK
         z8rghSoPno9xyA8FmhylOPfRcRM+wUrWlLCEHWh4hN6B0OlbcXo9Is7oFQyiKPauAlnC
         L+Uw==
X-Gm-Message-State: AOAM531vqu8LQ/M48QTqB1mLC5cBM9zk4pn6v1bW6Yf1IOy2d6ofQ1CQ
        WqBivvgdr+WP2BNA3I6939PuFT2olHX4zwJUjj8mnGfMCWRwSCVgrhj1pFpTbAzvlaxwSkBkOPE
        lnnaHJ0n4zWPLFiJ6j8Ba6D1JhztpYYThmV//DH0U/MkKZoZMNSpspM3Wv6m2PLQlneMPZhzdBg
        ==
X-Google-Smtp-Source: ABdhPJwCwe0Ivn4oxuYW85DCZt8LEkoCUulaqDf9S/0R2XreVsB1ACODvonVA/kCsqzYygLXLLlKNtB9xtvojYGmmqM=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3203:b0:381:b544:7970 with
 SMTP id r3-20020a05600c320300b00381b5447970mr5936255wmp.144.1646229843153;
 Wed, 02 Mar 2022 06:04:03 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:03:22 +0000
Message-Id: <20220302140324.1010891-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 0/3] aarch64: Add stolen time support
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

