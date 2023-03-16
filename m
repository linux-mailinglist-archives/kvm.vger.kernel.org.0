Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE54E6BDBAF
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCPWaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCPW35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:29:57 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8866820A1D
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:29:22 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id w4-20020a5d9604000000b0074d326b26bcso1622196iol.9
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679005750;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mbBhsxjoYHdH9a6hyOtmhFGeIjVnNWhiWRqDIPmqkSY=;
        b=YQIrXJ4R0u0oP5Mus93ZNLBl4dkFSgj447jRT4s8PiGPSOXyU9y1RazZ0+Dnpz26gA
         4tlPuT5jq0+5gLWalAVL7pC++YA1lzKtY5JtdKvTQH70IBfhY3WLHuYZ+1R10YzLPPxV
         IeHfC8fv5HDioCaBeIRdSrAgRBr4ullQxpSfsJbRxXvW5uPkK87mlm88xyc7pxhDXZt3
         nkBF3JlLkLAIOIa2fZaGTkOSzmdFvRUYKmXdoqZIKL5nJon0JraAP1KY/MjEJWBVM8MC
         edOeMgBRjYh4ZPtd6krFYzJSTUXEoIxUSrc5aggVS1hGC6RMuuHHsUtdjbWW3K0mPL9Y
         jKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005750;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mbBhsxjoYHdH9a6hyOtmhFGeIjVnNWhiWRqDIPmqkSY=;
        b=1NdbBHYfp6yktBK6U/J8xbD0IUoM7CA25t+edOFpfM+0YzJ6X+h+xx1zTzdiV3ubRS
         v4YlZRZgzz7G4bQt3YIA40jNLZ8tA/B1hvK8F779l8GWfq6mSNNqHdOrG0vkQ69Vk48t
         fXMedKxR2SBSJRpw5AXQj3ooTTeNuSbTW2RTfbG/P3cRws4nEthztOhR5dfFClxpyOs5
         CDxoLN4mX0XTZg2EE52sk1h7FcNR9j8QezP6vqVpv9zA1DsgPukHFYJRwDuV8uUAUK3u
         gA8TBxLk9LnyLpDWsBrwR++s1DP3REcN3jxvYi5kG+n1UPB6FSHwcYNOuZBd4oIVj7fu
         69mQ==
X-Gm-Message-State: AO0yUKVVECL7bIQ33cakjWAPJTrhhwx4E3tVtt66cwj7LYAlnkp9MWsI
        8ZPbw4C62IS6gX7A357s1ET0A90AuMhEpg/52Q==
X-Google-Smtp-Source: AK7set9K+vB42eV66rh0U4zEfJpuZl82kpvCnIU+I8ci8KaRIwgijB1FbFxvoUM/lNIPokYtTMgLqueps2FGXog8Zw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:7307:0:b0:323:24cc:6345 with SMTP
 id o7-20020a927307000000b0032324cc6345mr4423769ilc.2.1679005750045; Thu, 16
 Mar 2023 15:29:10 -0700 (PDT)
Date:   Thu, 16 Mar 2023 22:27:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230316222752.1911001-1-coltonlewis@google.com>
Subject: [PATCH v2 0/2] Calculate memory access latency stats
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org
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

Sample the latency of memory accesses in dirty_log_perf_test and
report summary stats to give a picture of the latency
distribution. Specifically, focus on the right tail with the 50th,
90th, and 99th percentile reported in ns.

v2:
* rebase to v6.3-rc2
* move counter measurement to common code helpers
* fix page allocation math for only the exact number needed
* add command line argument to control number of samples

v1: https://lore.kernel.org/kvm/20221115173258.2530923-1-coltonlewis@google.com/

Colton Lewis (2):
  KVM: selftests: Provide generic way to read system counter
  KVM: selftests: Print summary stats of memory latency distribution

 .../selftests/kvm/access_tracking_perf_test.c |  3 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 10 ++-
 .../testing/selftests/kvm/include/kvm_util.h  | 15 ++++
 .../testing/selftests/kvm/include/memstress.h | 10 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 30 ++++++++
 tools/testing/selftests/kvm/lib/memstress.c   | 68 ++++++++++++++++---
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 .../kvm/system_counter_offset_test.c          | 10 +--
 9 files changed, 128 insertions(+), 22 deletions(-)

--
2.40.0.rc1.284.g88254d51c5-goog
