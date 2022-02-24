Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4394C3245
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiBXQzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiBXQzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:55:51 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DF621A2
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:21 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so136910wrp.10
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8eG3BHpM/pHHc3R0ch/z2uogmexgsI2rbr+g5HBXYag=;
        b=XDg+9ijjvQJ8968p7ma+EgrSHPv8bdl0Cs4Wd6KCPT21KVG7X2eJoSMUVJKWrQilIn
         qcBb3OX7yM7Vac5du9WJs1A08yBLwJFJAEepzTsoQzzhUE9YtfVCXSs+LTc4nXZeRq4x
         V2Dm78BNYzIGznFLloWx3Lv8odGkXx+a4LxYrNpuAamMt+WyKJRv8nOZ+mRCSqQ+Dp2k
         tQcmc+TI4c8tzq5UY6gHZ5iQrz/I0UBbpOEt1VQqeCvE/bgwrAiVuP/YF//e9nQZqeUI
         Oiv7tLpSswoxrlS7vyem9XLQo2kOkb99osJhP+sRuPR42II1ixRBgXXIMYqGybLVPHLN
         1vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8eG3BHpM/pHHc3R0ch/z2uogmexgsI2rbr+g5HBXYag=;
        b=lXp4kjWj6VDxqnmqojlXkWbbxBOFdoy9xIxeawSOYAECoQGPsKY+4pmhknyKmquW83
         /Qy32wOlc5KycdBWnkfdXeqgmVRb5UOQMvb7BaQVPM++jNClZ+wVWIyYf/eMCHNcKK98
         u6FwptsOH4F4FsZwPA61ddewQeN6ThjhRu5K0mnNSjQ93Meaq2j+LlkrGJv8lgdL2ww9
         BNDaOnBITLKuQegD1bJ/uL8rpb+vO5CgWtdTUNs+JZG3jepN1XLrifzDOpWkwiUOy/oc
         +yVxDQ4MWedCmyB9vNktr3YB/algxDQBDsYamDvhJjUBpF5eu9Zh8i3BLziS0cB/Wd+L
         lTdA==
X-Gm-Message-State: AOAM531Oo1JZKA0boOMZJrXTeAq4Kry79oYSaFhQSwQemmHtlzuosRMp
        aKaVMsgWAYZi0Y79GPgis3hlDHlsG1kB7MAwVpoXl5/pzsF3s+fAoP2bRu+e5yShQCMuqAZl7rT
        NgBBk0gFqtwIcR1tuDJXkzJybATL6qvqC/0583MqTAzoQnQ0TqMpPfSsKg0k9UaeonLQb6UBdGQ
        ==
X-Google-Smtp-Source: ABdhPJwTaBY56IPy5g8BXFs7IGGuJhg6CZOzWvHj9FmXWSTwQINWGl7hsZPpTiBeipVyFPcYOnMmrn6/IEV3NbLyR/I=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a5d:47ac:0:b0:1ed:164f:8ed0 with SMTP
 id 12-20020a5d47ac000000b001ed164f8ed0mr2932127wrb.622.1645721720231; Thu, 24
 Feb 2022 08:55:20 -0800 (PST)
Date:   Thu, 24 Feb 2022 16:51:01 +0000
Message-Id: <20220224165103.1157358-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 0/3] aarch64: Add stolen time support
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

These patches add support for stolen time functionality.

Patch #1 modifies the memory layout in arm-common/kvm-arch.h and adds a
new MMIO device, PVTIME after the RTC region. A new flag is added in
kvm-config.h that will be used to control [enable/disable] the pvtime
functionality.

Patch #2 moves the vCPU structure initialisation before the target->init()
call to allow early access to the kvm structure.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

 Changelog sinde v3:
 - Avoid the pvtime overlap with the PCI(AXI) region by moving the
   peripheral in the MMIO zone, after the RTC.
 - Split in a separate patch the change affecting the vCPU structure
   population
 - Added a new command line argument in a separate patch.

 Changelog since v2:
 - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h to
   arm64/pvtime.c as pvtime is only available for arm64.

 Changelog since v1:
 - Removed the pvtime.h header file and moved the definitions to kvm-cpu-arch.h
   Verified if the stolen time capability is supported before allocating
   and mapping the memory.

Sebastian Ene (3):
  aarch64: Add stolen time support
  aarch64: Populate the vCPU struct before target->init()
  Add --no-pvtime command line argument

 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  1 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 94 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 14 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 8 files changed, 112 insertions(+), 8 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.473.g83b2b277ed-goog

