Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7124F4E44F5
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiCVRYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbiCVRYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:24:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD9E13F4F
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:23:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id r17-20020a170902ea5100b00153f493fa9aso5370616plg.17
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UeIt97cm1BRk6/PsYhB1LZn33tpqzrs0+uoJF47O1VA=;
        b=h9KxQnjhkxAfeU5hS3Bb2LHL5TmRVM1hLrf/f828/4dpBa0R1bpbOUBDaw62jbWOVm
         MrmGHyiDNEq2lqWab+oonCHuy1DD4q6J5ltQurZ3QOyJnPRah0ZTZq5DUW9M1dQuHfFv
         txl1OLK1476sSMKGofvd1ECM5eovOFHVw8l4iOIBE08e2gWyDr3tSEAVxDuikIF3HbvL
         0JPD3PkqKnJy67BR/FGhZgBqdZTq6I8hxP4okdS4E0jWbX8NLTZ/IhwG5mCletRIuxiU
         Q7P7TDLbrEpbcqPnV0o5N3DALwqHjsQZ3pb/wxlF1ahzePyG5BPRoYp74izk3zUPlNjR
         xe3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UeIt97cm1BRk6/PsYhB1LZn33tpqzrs0+uoJF47O1VA=;
        b=s+MWVGYJMI4pzD5PnqE9A6IELFbRnle9M4QYKOztrgS5enOF/QR8KVFr5Ap3elCENK
         Bg1JNCjpr/hQYul3lCt6irFGz69Hg5nNW2vAC9I0ue1GokhKtwzXSaO1F1+cKxeTuFYp
         dHsY+A/AaS7DjQ3LvMObzMxV0fbr5z11ZuIsD/dj4yWMSedjDqp3QlKoU83VVQBCII74
         YT4lwvi8ZSrwgfUdLmCw3vL9wxmSqupAuiltkKU+JTswqBMhMRm98OR1SwuBufP9daJm
         oUS6c8Lt/EpCbwQg5+04/TtCaFUDpTdNlZtUdIGrvQmwfch4T+I2ojqJlE+Y/AlX5adT
         18zw==
X-Gm-Message-State: AOAM530njWAsf/CRVgXVcgW72zOOlVkR4hcTdIi8clvtZY5IZ10OFZAd
        39Uye4VtfuNWqP/iQnJc3tZseNcJ+1OLfOzII9tKsJNMG7W8mWKgeze4FoSzozRLYDh3bMQZfqn
        KQanXrBM/RQygHftYCV0RJleaBzdPVqdxr3WUq5TunOkIt4tWQdcVaXhfhkYBqU4=
X-Google-Smtp-Source: ABdhPJwR2LEhQxUGrhAGf+33uw31jUQRxS9+Gf1ipPFzFOQGFcAaO0HtkQJ9SAD981hJNcbkoBCeMCztgTXsWQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f682:b0:154:8500:80bf with SMTP
 id l2-20020a170902f68200b00154850080bfmr4553264plg.112.1647969802560; Tue, 22
 Mar 2022 10:23:22 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:23:15 -0700
Message-Id: <20220322172319.2943101-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v3 0/4] KVM: arm64: selftests: Add edge cases tests for the
 arch timer
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
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

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- having the same timer condition firing multiple times.

The tests run while checking the state of the IRQs (e.g., pending when they
are supposed to be) and stressing things a bit by waiting for interrupts
while: re-scheduling the vcpu (with sched_yield()), by migrating the vcpu
between cores, or by sleeping in userspace (with usleep()).

The first commit adds a timer utility function.  The second commit adds
some sanity checks and basic tests for the timer. The third commit adds
the actual edge case tests (like forcing rollovers).

v2 -> v3:
- Add missing isb when polling for IRQ being handled. [Oliver, Marc]
- Wait for a counter pass by polling on it (instead of the previous isb).
  [Oliver, Marc]
- Edits in some comments. [Oliver]
- Dropping the msecs_to_usecs macro. [Oliver]
- Skipping test if desired pcpus are not online. This needed adding a
  library function (is_cpu_online). [Oliver]

v1 -> v2: https://lore.kernel.org/kvmarm/20220317045127.124602-1-ricarkol@google.com/
- Remove the checks for timers firing within some margin; only leave the
  checks for timers not firing ahead of time. Also remove the tests that
  depend on timers firing within some margin. [Oliver, Marc]
- Collect R-b tag from Oliver (first commit). [Oliver]
- Multiple nits: replace wfi_ functions with wait_, reduce use of macros,
  drop typedefs, use IAR_SPURIOUS from header, move some comments functions
  to top. [Oliver]
- Don't fail if the test has a single cpu available. [Oliver]
- Don't fail if there's no GICv3 available. [Oliver]

v1: https://lore.kernel.org/kvmarm/20220302172144.2734258-1-ricarkol@google.com/

Ricardo Koller (4):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: selftests: add is_cpu_online() utility function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 904 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  18 +-
 .../testing/selftests/kvm/include/test_util.h |   2 +
 tools/testing/selftests/kvm/lib/test_util.c   |  16 +
 6 files changed, 941 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.894.gb6a874cedc-goog

