Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7724D01A3
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbiCGOoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243343AbiCGOoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:44:03 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45705C364
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:43:08 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id l10-20020a05600012ca00b001f1e4669c98so942128wrx.23
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 06:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=tMeXsZqDb75ACGRy/sIWlewY6GCrVT1yFLrhXMTRT7w=;
        b=p0BnNyp2RCikZ7LWvPb49qd3X9/0vxwZAXMMyLUCVHQBcwSIyzmnb422xQuAXfHN97
         E3Kxw9Z4nU8qdPr4udJGiR9I4o+dxtzGy+O6PZruMBjCIG57vDtC+yz6oTwgTqkxhp1p
         lNJPoLKHoJ+AeP4qeaUI8xlpcuKC+p1aRFHw9GuEqxpSVpnvs3d9l0Z2aNR5HrhccQR+
         JNRr+OglCzjnK32/Up4jbu6DzOwegGAR8rFc2CpRwm1zu+kbiczSYegCebzhvhLk2BS3
         uLyVtPG1c7b9Yi84uHg+xs1GSL5j1B/JPy48ezS8g3ry1IzXRELRkK/+iC+aGqAukpb2
         4I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=tMeXsZqDb75ACGRy/sIWlewY6GCrVT1yFLrhXMTRT7w=;
        b=W8csfXGNKtZSMS9KPWB623h+NK/wnVvs5xY3ywxNxYLOMZUysJyGbS4x93RX1tdPoH
         oJEf6xgUqxyVm8Sy2VYjkD1jbzSRyWxl/vlzrKhwL3hI9OwwQ2nlRA05igwtIsz42193
         1AuK3xdkYgapewJ2zUfLkyD3PTV42FPzCyLZdyXWocBVXkW2dtB6baCM6Ggd5M1IWwEF
         RAK+fAUxsZgDOWWUZAVvxA3og4dRyqdNzrBQ+48s+d4D7gtFVcN9W9h+HSMBINL8jqUR
         vrU1z2loJHYkBZf+v2xMupDKNjkY9xD07Yp1JpNf6Hbfz5bNErITNl5JsNcXwM+IOLOJ
         KhQg==
X-Gm-Message-State: AOAM530RFVoLpFzhv/vKDqyETNRpmyra1ZJMBjuS9YlfTmF3z5kSBVfV
        s5MEDnTyBy92kcmNU0fTyC9CN+JCIZeRpTXaDWbEuEagr4L5Ajb3uF2T1l3DC1SYlFGHIf9oDdm
        O9RswyNzaBmhOMUp2D+KbiaIaC44PIlKTlajvRz/RJ1NpxoRvxianKs0J8nQ2ysFMaI40C6CM+A
        ==
X-Google-Smtp-Source: ABdhPJz3h7ACGFY05PU/VbgMi3gxENh8oNI1n1Bl2UxsVd5ehg0ma82ciZIHJK6iNc1Gq1U3oqDMBBrFNEG0xldLIyE=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:adf:a445:0:b0:1f0:3271:d612 with SMTP
 id e5-20020adfa445000000b001f03271d612mr8432829wra.325.1646664186892; Mon, 07
 Mar 2022 06:43:06 -0800 (PST)
Date:   Mon,  7 Mar 2022 14:42:41 +0000
Message-Id: <20220307144243.2039409-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v8 0/3] aarch64: Add stolen time support
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
functionality. Stolen time is enabled by default when the host
supports KVM_CAP_STEAL_TIME.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

Changelog since v7:
 - patch #2:
   - move teardown to kvm_cpu__delete()
   - don=E2=80=99t call kvm__supports_extension for the remainig cpu=E2=80=
=99s if it failed
     once and force 'no_pvtime' to 1
   - replace variable name 'is_supported' with 'is_failed_cfg'

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |   1 +
 arm/aarch64/arm-cpu.c                  |   2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |   2 +
 arm/aarch64/pvtime.c                   | 108 +++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |   6 +-
 arm/kvm-cpu.c                          |  15 ++--
 builtin-run.c                          |   2 +
 include/kvm/kvm-config.h               |   1 +
 8 files changed, 128 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

--=20
2.35.1.616.g0bdcbb4464-goog

