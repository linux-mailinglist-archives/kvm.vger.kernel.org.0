Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34185A084B
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiHYFJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiHYFJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:09:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827869E699
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:09:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33580e26058so325470957b3.4
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=A7tujPj3gCcslYboIVJEpUnfbTygKXV5SjxwsoVRgPU=;
        b=RA1O0inPqFeLIGQY94aBQVZ8guQpSivAkXorCz90PUXbN9cTieKHfJ1TDbwOg/8TB0
         eP/znMpGKvABSMGtpONSl7cKa3FFjJ5Yns3lEND+didHb0J58sOo35iln4zklcV7iMmA
         KJ36X/BPnhE1PXM0ySnr81ivez7ZW3k/8tJ/5EBFE6tpvVgM5UvRZPBpsFtMT+JDwDP4
         pLDKQNtuNcJGBPrG4f+lV4mlOEv4I26SP+aP7NKGLZ71I/PI/rxuOwju1KeCJy6dlKCN
         5a5g2uSvPR7tID72BJvRohdWoQScMpHW8XTHUNMEjtmnRAy+MbrLA5hI/cIlNA2j7qeY
         a2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=A7tujPj3gCcslYboIVJEpUnfbTygKXV5SjxwsoVRgPU=;
        b=qcKmmOePGVNcx7QqCYAiUAdIjcOgI5ItPn/jlAHQfoJrHOFkwsH9Cwrcqu1Z01nvUW
         tULpMPUbZMRIYSEPdxlifY77PnTZS17wjtFj7EJn/90coKBE03L+5UwyikTf365N4zgG
         MIOawLouqYve/yoxf92sCAUNVtBDyqw/t5yJ9XUX9eFILv4YcSVGvxJiuO5yUXcXaq8u
         w+Tn7k/Ojp8jtXw5mOvoSaeAYCPf/Je3YFJKJ/FGN23UbxrQZTAx0XRtA/OKyPqM34Zs
         iahlgsp5LbvuZQb1ngVbRsyFY7V6csdYMredQuD7Q1k6izfRlWaLQeUrqaXjRXMO62HZ
         ihGA==
X-Gm-Message-State: ACgBeo1ogjEuuvo3KMgyXlVizGAnFdnscRhbm8xA20uzQyqMdDifW4Jf
        +SSPZAdb1Hr1Lvpr+/GoMSaFb4dg14o=
X-Google-Smtp-Source: AA6agR6mA/YLJIHg107zS6XG+THNR8WdRCDmQxkfaR1R/eAzKUfb6FtOdr5p90shIKZNaqWdlGvutxoDXpk=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:aa81:0:b0:695:88e0:caa1 with SMTP id
 t1-20020a25aa81000000b0069588e0caa1mr1924184ybi.448.1661404146792; Wed, 24
 Aug 2022 22:09:06 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:37 -0700
Message-Id: <20220825050846.3418868-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 0/9] KVM: arm64: selftests: Test linked {break,watch}points
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

This series adds test cases for linked {break,watch}points to the
debug-exceptions test, and expands {break,watch}point tests to
use non-zero {break,watch}points (the current test always uses
{break,watch}point#0).

Patches 1-6 add some helpers or do minor refactoring for
preparation of adding test cases in subsequent patches.
Patches 7-8 add test cases for a linked {break,watch}point.
Patch 9 expands {break,watch}point test cases to use non-zero
{break,watch}points.

Reiji Watanabe (9):
  KVM: arm64: selftests: Add helpers to extract a field of an ID
    register
  KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in
    debug-exceptions
  KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from
    debug-exceptions
  KVM: arm64: selftests: Add helpers to enable debug exceptions
  KVM: arm64: selftests: Have debug_version() use cpuid_get_ufield()
    helper
  KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
  KVM: arm64: selftests: Add a test case for a linked breakpoint
  KVM: arm64: selftests: Add a test case for a linked watchpoint
  KVM: arm64: selftests: Test with every breakpoint/watchpoint

 .../selftests/kvm/aarch64/debug-exceptions.c  | 281 +++++++++++++++---
 .../selftests/kvm/include/aarch64/processor.h |   2 +
 .../selftests/kvm/lib/aarch64/processor.c     |  15 +
 3 files changed, 262 insertions(+), 36 deletions(-)


base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
-- 
2.37.1.595.g718a3a8f04-goog

