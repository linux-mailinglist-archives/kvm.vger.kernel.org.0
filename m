Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F875B27EE
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 22:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiIHUyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 16:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiIHUyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 16:54:43 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3942827B39
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 13:54:42 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id z9-20020a921a49000000b002f0f7fb57e3so13459864ill.2
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 13:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=zk7qHZA/O/hifOOYPfoOBILVsNoa6+C94y7Sdfh+dJM=;
        b=dfgRo1EosVb/UrWFij5QeCTPpA+aLp7Vv0AFWEUO70jlpEli1SV6air5ugoL8Hsx4c
         XbnD+lHPTa591qrSK5dOuUofYH/rg5lE91VILghIPW9d7zfX7kvHAVPFqUl2vrYaxzU/
         BR1EbLMwyGPDO5A4oLo73z0e1AN9U8C2g80tZ+g6lIu/NsTkuJi7joA7ne4U0RWWo0rG
         9aGFoH1Kc3jj0+E9ktYdNmXO/rJB02HAx2204Q7Tq9wP7fzF+guhz2oJBQmobcI/cJCk
         BhbXkVc/sgK5X6ZwOkTramLSQztkvvz1E7QocKCBgpu3/oZ2cEr6wFU2FRPNy+1LDQUw
         wedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=zk7qHZA/O/hifOOYPfoOBILVsNoa6+C94y7Sdfh+dJM=;
        b=H+UpafhyroQZnZTkazgqEeY5HOtyBpFJSOMyglKY/cnJlwDB7hmXKAx6GIiPwgGHRM
         /ucp7aQIcvgy9YQxHTof60gJvZkHrDygFndKHvbJKfwkQAfydf5qgYWWAlR9fIwtRveQ
         /NOGUk3krygZrm/qs+GMKthtjAL9IPMJcBMuFoW/ZEOqw5BuYHI+4haV02dcdfmxAkcz
         seYqF8iqFXUYPFzKJjUIRHU67Y4F02NWAZ48bBR6TuEIJ/5FJvbL8aIdv0ejV2OMdgUm
         x2szX4m0ebFARhbmAvfc1kjhtRFIJC8TKydrd/qXhImdiC9QgkqcPdSuc30N34kk5uYh
         c7Lg==
X-Gm-Message-State: ACgBeo347RmF9asmXptXpt4WbbPzvvlsze6gGHnXfe1X9LzCYJO2YRq9
        GzpbXK5NJGIh8CZaJwfl0stRrcFrOcNTxOlb7t8lhRipuRNhPFI+fmhoBIlBvpCSUaqqmUzOEJM
        O2Hx3fjFEHhmt1BcLLOG6QyS4HgQpaVM0UtxbPc8Uz5xtXsqrpypKvCBuARf5HcCGrmADHuA=
X-Google-Smtp-Source: AA6agR429iO8k9lZG7Rtz/Ef/nHcTjgG2oYiPX+ByGJA2IRAUhzmKInyV746ikESpR0ZfPAssBpd1Jmalhufe5kF+g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1304:b0:2eb:2f1d:a9a8 with
 SMTP id g4-20020a056e02130400b002eb2f1da9a8mr2937590ilr.137.1662670481625;
 Thu, 08 Sep 2022 13:54:41 -0700 (PDT)
Date:   Thu,  8 Sep 2022 20:53:44 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908205347.3284344-1-coltonlewis@google.com>
Subject: [PATCH v4 0/3] KVM: selftests: randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev, Colton Lewis <coltonlewis@google.com>
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

Add the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written.

v4:

Ensure all randomization is off for the populate phase (write_percent
= 100 and random_access = false).

Move random number generator to test_util.{c,h} and rename to
guest_random. Make it destructively modify its argument to cover the
most common (probably only) use case.

Make the perf_test_set* functions more efficient by only syncing the
field they change.

Improve style and consistency.

Colton Lewis (3):
  KVM: selftests: implement random number generation for guest code
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 49 +++++++++++++------
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  2 +
 .../selftests/kvm/lib/perf_test_util.c        | 30 +++++++++---
 tools/testing/selftests/kvm/lib/test_util.c   |  9 ++++
 6 files changed, 75 insertions(+), 25 deletions(-)

--
2.37.2.789.g6183377224-goog
