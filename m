Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD9623311
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiKIS7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiKIS7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:59:10 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3031929B
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:59:09 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-37360a6236fso170923037b3.12
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 10:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nx8WXRIsCDq/f9+P8kq+/4W5w5mWx9NShm2xH4k9+d8=;
        b=P+RdhvXA2ZYk1e/xVI1ZM0GpIwnCNsy9g0x18mCDOD3VQaa6c+64BbeaZmeO/eqwTb
         1RDQ7aeENt2DAQ7oToBlR5LnMsXBIH/LGIGOLM22IT1l4rz2LaqOJblNYdxY6OxYdqsj
         WWQU7XhjeQ91IFQ38b/UijxTDqQS+zhkE0holrg3YAFkL21kehE+89cxJRRXXAtpJV+N
         +4t+bwPqSuTxJgBtfdyHcqT6dqQEjO85DACGecxhvC8+uIU27s3Z1fSZmfMehSABa/F5
         jvGP4vMDkO48S0+wYGj9F4/TEi83wbbHU8HUTiZo0I8e8BtA9qUMUopYFzh54VPjLznZ
         L84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nx8WXRIsCDq/f9+P8kq+/4W5w5mWx9NShm2xH4k9+d8=;
        b=LcTN9Gb00TEvk9BQzLLuvkUfU/0/C1FLphDTbWWp5yO/UphmAxhZbuYJIAKsp4/9Ao
         OhugiEZghKWC4NjKQxWnyEqxDyBYX4Fdj95gTtmnZYmkJ5BA4PsLw138OKWuXXbawiYb
         aUKPaP8U9O83jY6ftl4h2kWGldqiJsHlaUKBgawMcv0LaSrSunXZtlq7Dlxx37t/h2m8
         2A+7GpNn+GHk0P1P+oBaHK9PUFmPYfywNwbOlpnpdWkxyWuYKHndueWCXXMix4C9aJrz
         JbWjJlejsxyk7kOsOyn/1aBerNZl3PvVBreOaceOfT0WoNPQFND+rlcUT5iw/+br8qLP
         mV3A==
X-Gm-Message-State: ACrzQf3xvgYH/fFZsH3n1K8IMvfU0ezgjTiOHvWKWdHdzjjyUmbFkkx7
        I5VRBDeJUG6Ovq3GMejXOL7ojGP3IcTpRA==
X-Google-Smtp-Source: AMsMyM4KGJ6dUj2ubvdVZd8Ecm+cdHyCP6j4sbc3+lzVTCpFF6gUoi2q0ANq2nYAMXajZDaUKX5hebaOcRvuLQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:d:b0:36b:999a:da62 with SMTP id
 bc13-20020a05690c000d00b0036b999ada62mr1167865ywb.249.1668020348305; Wed, 09
 Nov 2022 10:59:08 -0800 (PST)
Date:   Wed,  9 Nov 2022 10:59:03 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109185905.486172-1-dmatlack@google.com>
Subject: [PATCH v3 0/2] KVM: Split huge pages mapped by the TDP MMU on fault
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
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

Now that the TDP MMU has a mechanism to split huge pages, it is trivial
to use it in the fault path whenever a huge page needs to be replaced
with a mapping at a lower level.

The main beneficiary of this change is NX HugePages, which now no longer
unmaps huge pages when instructions are fetched from them. This means
that the VM does not have to take faults when accessing other parts of
the huge page (for whatever reason). The other beneficiary of this
change is workloads that set eage_page_split=N, which can be desirable
for read-heavy workloads. The performance impacts are discussed in more
detail in PATCH 3.

To validate the performance impact on NX HugePages, this series
introduces a new selftest that leverages perf_test_util.c to execute
from a given region of memory across a variable number of vCPUS.

This new selftest is short but contains a lot of duplicate code with
access_tracking_perf_test.c, and the changes to perf_test_util.c to
support execution are a bit gross. I'd be fine with deferring this test
to a later series, but I want to include it here to demonstrate how I
tested the TDP MMU patch.

Tested: Ran all kvm-unit-tests and KVM selftests.

Cc: Mingwei Zhang <mizhang@google.com>

v3:
 - Rebased on top of latest kvm/queue.
 - R-b from Mingwei.
 - Add comment about sp initialization [Mingwei]

v2: https://lore.kernel.org/kvm/20221019234050.3919566-1-dmatlack@google.com/
 - Rebased on top of Sean's precise NX series
   (https://lore.kernel.org/kvm/20221019165618.927057-1-seanjc@google.com/)

David Matlack (2):
  KVM: selftests: Introduce a selftest to measure execution performance
  KVM: x86/mmu: Split huge pages mapped by the TDP MMU on fault

 arch/x86/kvm/mmu/tdp_mmu.c                    |  73 ++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/execute_perf_test.c | 185 ++++++++++++++++++
 .../selftests/kvm/include/perf_test_util.h    |   2 +
 .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
 6 files changed, 247 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c


base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.431.g37b22c650d-goog

