Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D8B6052DB
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiJSWNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiJSWNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:13:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67883180248
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:13:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-35076702654so181665377b3.17
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ECnXqaoUc3FrJthXHiHp4vtuJH8bpgR4U584ly5OySg=;
        b=l5qe7WwvZofLbgHotWxESKAQOANHYT9l9zSHXcWReGARu32COLVNQ6PIrYLi57mS6t
         Z0WDySm9Dx0sOM/h9FI7KbDr942Ere5fuWaok5d5ZV6kM9/+aAZY7Lrf1Zm3IuaYNq3w
         yuI4MSCs85Y56prZpsspYmoPUb5w1ivYjPpAfqPZ3KOTsp35y01hwDCOmv8GZcgopWU+
         LliE9dQZDuFKvBEEGn3AnNq/5zGVk9dLNOSmWWFZOpfbjjemSF/QQ+7CnLiO7sQ3K5w8
         4CROkveI5qZ6H3xyr1ChhZam/vqZRfqITiAMmi9cw0yqRHXSL/PZZNI6XppwupLA/KTh
         4zLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ECnXqaoUc3FrJthXHiHp4vtuJH8bpgR4U584ly5OySg=;
        b=WWN7zBU+g4KucJZMmoQwi/K+5vMVB1pqyrKGHKLg56a8Ut38mpxdwMkQwVDtXdZpEm
         iKTA6zqytVQjnJ2FMycflqShhppHO0+ixMD2MKAqju5qUaawkc7iUT0xNknQ5egZaSmu
         kTD2EyxBCRC/YK3gl+1GHwbS5R7VNVl8ppj2g8qrT+vHQtWjuamHuGzeYg1kMUhuFlZQ
         vqafb2oquVd1dIJih99ZH79j6x9rCdgbgDmkXngtGj3wSk3fxC1RtMCqcXhXoW3Cg8Su
         NdN7ebG7HapvXBf7cRRZCEnI/ye89MUBfc7QNOi46qAOgyninK8rKnmNj+vLC0RyK6Ji
         jJmA==
X-Gm-Message-State: ACrzQf1xi5ooUmv9qneXREyN1DQbQ48Ky0LXgRFhLGyU1PghQj2CYFR/
        UHm4sw2fWVNVmEaAIpLYRojn9ynzYqhK0PyfBgnbzQQq23blJ+/0qw+ih9IOXNXB9FKDr2tYL4y
        rLuT0tJQJM8Y7/7YhKampldtxNbkWab0zzsDnHggmgwNEMK2P9/8PuLLAf1agPCbBGYCOLck=
X-Google-Smtp-Source: AMsMyM5dXbH+2IxeXBuU5Jbi3pKMJuw+uMqO91WEideQJXn5o9eR89+WgPdGz0Q6wFg3Tkasjp2y015PP8IRh861RA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a0d:cad5:0:b0:367:5fee:9b54 with SMTP
 id m204-20020a0dcad5000000b003675fee9b54mr3333075ywd.101.1666217628606; Wed,
 19 Oct 2022 15:13:48 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:13:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019221321.3033920-1-coltonlewis@google.com>
Subject: [PATCH v7 0/3] KVM: selftests: randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written.

v7:

Encapsulate the random state inside a struct. Add detail to names of
those functions. Change interface so random function returns the next
random number rather than using an out parameter.

Rebased to kvm/queue to ensure freshness.

Colton Lewis (3):
  KVM: selftests: implement random number generation for guest code
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 58 ++++++++++++++-----
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  7 +++
 .../selftests/kvm/lib/perf_test_util.c        | 32 ++++++++--
 tools/testing/selftests/kvm/lib/test_util.c   | 17 ++++++
 6 files changed, 100 insertions(+), 24 deletions(-)

--
2.38.0.413.g74048e4d9e-goog
