Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E9658CC54
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiHHQrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHHQrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835E413E25
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3282fe8f48fso81842597b3.17
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=21T0lLwfpFcDdGp7iyIEH8TXI8vyushZ5PUV2QIwO1I=;
        b=msmRk7imkEx/dJZX6xagFoNej2MiSCvDNqbfglHJuC5OYu/4e2YqdvSwkZkgTbgCaU
         oIqKxg8LGXqVyilujgfYxV92W7oAPuBeNknnYMXsoQzYHkt4zKGKWOhFzG898tPM93bV
         e04X7rSq2hti63YSVhTS4tyv54/jkhw/CW9UYyLcjyukZ/Opn7lY3BbgjIHUy9+RbKVN
         9v3Lx7y6Q6ZRWWufqnO9vCzuIw9B4luFrCuFRrjS94gGmhrPkNIl866sdl6gGKmsNgJj
         0ZdH3PcolFG1mD66TEZW1x6CyoTEINxWOweS+LeNb/Z4uJFUiVTSAOxfOh2ugBem7aRz
         fmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=21T0lLwfpFcDdGp7iyIEH8TXI8vyushZ5PUV2QIwO1I=;
        b=CmppkK1hCagRaOmphfpBKNPimWeCOy+H0z38/mvgfiQa0zvr7jORDxRM8gfqL1X/Bz
         PeXbl8liWXtzR/aF08dRiRbPBat/jSYCdrSuGy5bsDkw19mTcnKi89CSBKtRo98t3ilP
         /3wdtZYbSjae1/o65PaDE/XITpALw/pver5CjODIwwfMJMxUz5spDpj2rsUDDSeSPtV/
         cfVnqOZIjiEqQeiVrdxTNbb1Fu/D9ybL/UydEuRtSVRf3yKf0YMpeT3+Ys45+gEiKuYc
         3tGgouZ/2LP9JbKWvf0lFEkW/335sj3m2tCmJyPnq4EbRtEjupa5I/uJHWWNfVZ+FYNU
         A2qA==
X-Gm-Message-State: ACgBeo0enYYNlunLdQx05sLB6HP0HZFSCV+5DDZ+ERoHoI+ULp23+wA4
        z0rTFaziyaHG/wSa5IwLh7ea7c5h6bM=
X-Google-Smtp-Source: AA6agR4pk46G3DGzfaMO+qy1QtRBmJaNcG1qphi2H63gZKWuvLSne99PdT19GJUFCZAHoqrSZa1jJ7HFT9Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:2597:0:b0:328:2f39:6852 with SMTP id
 l145-20020a812597000000b003282f396852mr19232525ywl.404.1659977230861; Mon, 08
 Aug 2022 09:47:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:00 +0000
Message-Id: <20220808164707.537067-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 0/7] x86: Illegal LEA test and FEP cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

Slightly reworked version of Michal's series clean up the FEP mess and add
a testcase for illegal LEA.  Core ideas are all the same, just moved the
common FEP functionality to desc.h to make it easier to use in other tests.

v3:
 - Define __ASM_SEL/__ASM_FORM in desc.h to fix circular dependency.
 - Move ASM_TRY_FEP() to desc.h
 - Add is_fep_available() helper to simplify probing FEP.
 - Use is_fep_available() in PMU test.

Michal Luczaj (4):
  x86: emulator.c: Save and restore exception handlers
  x86: Introduce ASM_TRY_FEP() to handle exceptions on forced emulation
  x86: emulator.c: Use ASM_TRY() for the UD_VECTOR cases
  x86: Test emulator's handling of LEA with /reg

Sean Christopherson (3):
  x86: Dedup 32-bit vs. 64-bit ASM_TRY() by stealing kernel's
    __ASM_SEL()
  x86: Add helper to detect if forced emulation prefix is available
  x86/pmu: Run the "emulation" test iff forced emulation is available

 lib/x86/desc.h    |  52 ++++++++++++++-----
 x86/emulator.c    | 127 +++++++++++++++++++++++-----------------------
 x86/pmu.c         |  18 +++----
 x86/unittests.cfg |   7 ---
 4 files changed, 110 insertions(+), 94 deletions(-)


base-commit: a106b30d39425b7afbaa3bbd4aab16fd26d333e7
-- 
2.37.1.559.g78731f0fdb-goog

