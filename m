Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBAA4C46BC
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbiBYNib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241534AbiBYNib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:38:31 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370991E7A45
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:37:58 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so894105wrg.20
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lRlQkk/1FSOqAzIUi1czdjgNvITE2xn5+VNcHfuDD5Y=;
        b=jlI2EM7HSlyX4dSYqNmsyrFd9+NFAD4FVNu1xxOXa3WHMWckhd4lnGBA2GsI1YGkza
         EzZBMbpMFm36wcuDn0mw+CeEypUG8gH7ZKYko/ahL2cqaMWg71YIHpN2VUBDDXzyH0zn
         97Ch9EU7TgYImdQWAtqxrm+hn5Q9PQcc7MyPZgJyElFBCHVNRT2j+uq27ycs9eJgY7S+
         of2NHcJ+ZjG0FCPODgoosiJoM1kF9VNQUIEAzZM6LK6rlLRaOznUfrrh/dmToA+TvhET
         LvujdBM5wREjhh9kR4vSYUSUo9ZC2IATQ8FK5sy/PgzbJ2UoOJetuX2nOnYarbejNhrR
         hc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lRlQkk/1FSOqAzIUi1czdjgNvITE2xn5+VNcHfuDD5Y=;
        b=KuP83O9qwzPemXT0jCX+EYaNPqwarRa6BODkm3btULnrrybUwamqpHsnUZvwS3Omvb
         9ASiDRRYAagoU+DXs11JNqglnmij9mgvw9uZRxSA8/gZEugjb29b50oXbHXBFMztY02f
         oBQb3PzDIb40eG49Ao9K5+io+lgqhm1c4nf8FEyTm/FXi9RoJdk6pCt9VY2DWC/e+lYA
         694t6mrHUKSHE49SgpQBArSCpIbP7r17E3dWgFUQHj6OZBFkj5UJGADOjcR137d9m50Z
         Uq9DyJbl9CSQqAJvb+Ug1Z7SnX7s3iqcATRFvHHBowaue8dm2CrUDPUv+NnxFlUhlmRY
         7zUg==
X-Gm-Message-State: AOAM532ct2nhnoDBdQ0FYjxzEHrdei4Ejb9EaJEUi0RZaKRmET4+EnTp
        bgOiJwS9tZPhqhJNq14V7tYex287zQYHVWTy6N/U0/VfpMfBQQ5xvfRBgoW2bsQJYV1j7jyp0bO
        bMnTKN2yhA5sNRlBZWuyq7Fw36xrNPfdC2Twdr2gFT7VKawVy/rvO+GymR+H8QINb1HH3IOw7+Q
        ==
X-Google-Smtp-Source: ABdhPJwfwchkdTKFsc11KLrjn8H+lwQn8CWI0f5dbYvQx5QSMn7mF8EoUBRhpLgnEozNKNffOPpBzSzHScSBxPC0OU0=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a7b:cb44:0:b0:37c:4e2d:3bb2 with SMTP
 id v4-20020a7bcb44000000b0037c4e2d3bb2mr2810750wmj.96.1645796276423; Fri, 25
 Feb 2022 05:37:56 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:37:41 +0000
Message-Id: <20220225133743.41207-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v5 0/3] aarch64: Add stolen time support
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

Patch #1 moves the vCPU structure initialisation before the target->init()
call to allow early access to the kvm structure from the vCPU
during target->init().

Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
new MMIO device PVTIME after the RTC region. A new flag is added in
kvm-config.h that will be used to control [enable/disable] the pvtime
functionality.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

Changelog since v4:
 - Propagate a return code from kvm_cpu__setup_pvtime to target->init(vcpu)
 - Change the order of the patches as the vCPU structure initialisation
   needs to be done before the PVTIME setup
 - Return -errno from pvtime__alloc_region(..)
 - Verify if the system supports KVM_CAP_STEAL_TIME

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 98 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 14 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 8 files changed, 116 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.574.g5d30c73bfb-goog

