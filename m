Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF24D1BC1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbiCHPeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiCHPeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:34:02 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4581FA79
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:33:05 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id 26-20020a05600c22da00b00388307f3503so1253083wmg.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pFCZMIKsmv1NgfuYif6jC89cFJGtwVMy/ZQFUs6rUg4=;
        b=Og4X5EgvD6ZGnF9GYC/nSoXWWIbI4ubeynG4LVZBHsNwEt4N7WDD3JAnr/aGH1N+Or
         20btxSIx1YnatFPfC1Nb43bQhN9YFnTy/nFjuM+SebBb+LFTPUFDfJdP5U8WIqju5nF/
         eCHZ7ylSKeqIxFi+A94QL848mgzxpx+aoIa3tkNNJQxmKmDy+znXZOfcJel212hss7F/
         Fi3B2zqr3X48oXAcFKaFp0QqhZxPuEVe0+6/LEV6BQoE4DDIhsKkIlFiTMP1WP7eVC3O
         6oBI+ym/FWJ8MVxOhuj0USkRJw4fId7JXtvGetAdqEIkeLvpiZtFiHhV/+ObaTg1fyKA
         9NIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pFCZMIKsmv1NgfuYif6jC89cFJGtwVMy/ZQFUs6rUg4=;
        b=PNFGiCjau6S8jie29q1WULN+ri3qOu8gtlcQ3273YCWRKx38WNuSKDmPdtZ09cqVtc
         qbGyPl+ror8PQKqquerW6TX14DD3T6zLqqz44VdZhKD4x1ORnUa3sA0I2ZP2ePuaglQP
         0UucEWFobr8dGI+BFWcMK19zNUnClITyZsXLlvYoe/+6ezYjrMgRhlguyjpZcI+fibQl
         o3LdL1lTXJDSyCRM5T+Vpqng3KRHRmzOrSGn0fE+Pv0K6JinBsqwL4w7reS0EP6wukDg
         XT2tKo1sHohsV/EhL/EerrQprce6hJFxk0RKSMJHdIkSSJjp6m1zzMeFWRMRyH3uAuS4
         t1AQ==
X-Gm-Message-State: AOAM533XUyJssumQ8AYI/15NZgqXHcLZ0mKVQSNrHUXImMnviVp11tdc
        v9cOCeqFtq/gFBWgzuB2TvKaLetlWpmvvlxzSKIv+zCU8itdbPAiygwkfcQTJiOBbuhI9qBZXd5
        Y6tCB6tk+vM31D6uFPDR0V5cX0f0eoX3c1BGWnH+lDdZr5dzMwz2aZ9/zig4/45Z3/b1g6BxRng
        ==
X-Google-Smtp-Source: ABdhPJx+g3OUSF7ALEGrRok8o/uMoGiAUjj9sAb9rq2nfBww3UXx3vC6KKRHWk18QkFJyTvY1IYcyHhcvw2iFZPUTJU=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:35cf:b0:389:b5f1:ce68 with
 SMTP id r15-20020a05600c35cf00b00389b5f1ce68mr4042505wmq.149.1646753584000;
 Tue, 08 Mar 2022 07:33:04 -0800 (PST)
Date:   Tue,  8 Mar 2022 15:32:25 +0000
Message-Id: <20220308153227.2238533-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 0/3] aarch64: Add stolen time support
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

