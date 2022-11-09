Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846A462344F
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiKIUOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiKIUOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:14:50 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC2D1DDF0
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:14:48 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r126-20020a632b84000000b004393806c06eso9982922pgr.4
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=43V+WrgmSTCR2GMr/iD31Azag0STw4hSIPC/mSBEQCo=;
        b=UTdfpYt18D++rtBPynnE3oKbyANst8ljpr3zlZoHOSqpKX2l2Se8Evwi4hG9XKvDk+
         xI5XJZdHWIj2tY5uF1b4/sC3wQJ3VB5l/JEhje2AgMO0gnGHD7wEPsIWFgw3FPkAk97g
         0R3aWh0SnAZ6jb3aqUVTgcWO6OJuDdLT9feVfyqcjULXSTCd2SfrFBkIUzyKe9mHGJ89
         iCYWZQXWM6IX6ocLCw0zJQY5Tx1CuDmTVyRS2lu0+mJJojYYJk9AOtkqiu7uruSFP49P
         PJSBDvFr2SxblYkTvSF5Pq78liaXEWLQEXQaSbUr8kLANKY5KlIUP+KZj7qQnmjUnRm+
         M93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=43V+WrgmSTCR2GMr/iD31Azag0STw4hSIPC/mSBEQCo=;
        b=Y2y7NJQmC+ny461oSpnaA3t8zcxeXf0NyFy41cPKkztr4IFFCWHRxRG0U8J4wgFpwY
         ArBB60hcGMhqlNObxdVcjzwJcKenPyxjlfIOc9hWoUhfKhWv+//TahlMEARXcjcOqyZB
         x7Pcsmtl84LBvfOagj42VaYCrDAtPnHClQqeplygNBBNdXA/yd4w1Jg70TX9RsDoF47a
         +ZMQl7vpIRs4l3EOfNEk8TtBcHvhn+LX2YI5NJM5CAMDYfXJcJ8rif0liKJTjx4IHJvx
         KaWTBZz5OG7qaG+R024xw2obJ+5IzVVX/8XsnB+ilQSQRgxTmSqcavdcVKzjVwUR44iZ
         u84w==
X-Gm-Message-State: ACrzQf2RdtxfUwPLTXs6DCFuEbEBINycocRwtVVP8BAbvdpI1Dyalneu
        OWmnlFsQWHTyT8RmJHW9hiIkYSbAWECt+RozfvKsIS0AgVB2P+AMG3KNdjPoRgdm7oPydT813vX
        sgUk6WoX6uPEuVIxDcEKMkXvBVOYBn+t1Qx7Pw6X495ngZGw3E2XWLuM6NEuhdSO35hbs
X-Google-Smtp-Source: AMsMyM60hLZo4/PUHwNoi4OxR7Lth41PSxjr9qc7q8AjZrpQp4KileuI7K5Qo8ZKTvQpS/1TPZ5TNeb4L01fVgDN
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:33c7:b0:214:1ddc:c6bd with SMTP
 id lk7-20020a17090b33c700b002141ddcc6bdmr45438881pjb.151.1668024888197; Wed,
 09 Nov 2022 12:14:48 -0800 (PST)
Date:   Wed,  9 Nov 2022 20:14:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109201444.3399736-1-aaronlewis@google.com>
Subject: [PATCH v7 0/7] Introduce and test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

This series introduces the concept of masked events to the pmu event
filter. Masked events can help reduce the number of events needed in the
pmu event filter by allowing a more generalized matching method to be
used for the unit mask when filtering guest events in the pmu.  With
masked events, if an event select should be restricted from the guest,
instead of having to add an entry to the pmu event filter for each
event select + unit mask pair, a masked event can be added to generalize
the unit mask values.

Reviewed-by: Sean Christopherson <seanjc@google.com>

v6 -> v7
 - Rebased on top of the latest in kvm/queue. [Like]
 - Patch #7, Added comment about how counters value are used. [Sean]

v5 -> v6
 - The following changes were based on Sean's feedback.
 - Patch #1, Use a const for EVENTSEL_EVENT rather than a callback.
 - Patch #2, s/invalid/impossible and removed helpers.
 - Patch #3, Ditched internal event struct.  Sticking with arch layout.
 - Patch #4,
     - Switched masked events to follow arch layout.
     - Created an internal struct for the pmu event filter.
     - Track separate lists for include events and exclude events.
     - General refactors as a result of these changes.

v4 -> v5
 - Patch #3, Simplified the return logic in filter_contains_match(). [Jim]
 - Patch #4, Corrected documentation for errors and returns. [Jim]
 - Patch #6, Added TEST_REQUIRE for KVM_CAP_PMU_EVENT_MASKED_EVENTS. [Jim]
 - Patch #7,
     - Removed TEST_REQUIRE for KVM_CAP_PMU_EVENT_MASKED_EVENTS (moved it
       to patch #6).
     - Changed the assert to a branch in supports_event_mem_inst_retired().
       [Jim]
     - Added a check to make sure 3 GP counters are available. [Jim]

v3 -> v4
 - Patch #1, Fix the mask for the guest event select used in bsearch.
 - Patch #2, Remove invalid events from the pmu event filter.
 - Patch #3, Create an internal/common representation for filter events.
 - Patch #4,
     - Use a common filter event to simplify kernel code. [Jim]
     - s/invalid/exclude for masked events. More descriptive. [Sean]
     - Simplified masked event layout. There was no need to complicate it.
     - Add KVM_CAP_PMU_EVENT_MASKED_EVENTS.
 - Patch #7, Rewrote the masked events tests using MEM_INST_RETIRED (0xd0)
   on Intel and LS Dispatch (0x29) on AMD. They have multiple unit masks
   each which were leveraged for improved masked events testing.

v2 -> v3
 - Reworked and documented the invert flag usage.  It was possible to
   get ambiguous results when using it.  That should not be possible
   now.
 - Added testing for inverted masked events to validate the updated
   implementation.
 - Removed testing for inverted masked events from the masked events test.
   They were meaningless with the updated implementation.  More meaning
   tests were added separately.

v1 -> v2
 - Made has_invalid_event() static to fix warning.
 - Fixed checkpatch.pl errors and warnings.
 - Updated to account for KVM_X86_PMU_OP().

Aaron Lewis (7):
  kvm: x86/pmu: Correct the mask used in a pmu event filter lookup
  kvm: x86/pmu: Remove impossible events from the pmu event filter
  kvm: x86/pmu: prepare the pmu event filter for masked events
  kvm: x86/pmu: Introduce masked events to the pmu event filter
  selftests: kvm/x86: Add flags when creating a pmu event filter
  selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
  selftests: kvm/x86: Test masked events

 Documentation/virt/kvm/api.rst                |  77 +++-
 arch/x86/include/asm/kvm_host.h               |  14 +-
 arch/x86/include/uapi/asm/kvm.h               |  29 ++
 arch/x86/kvm/pmu.c                            | 241 +++++++++--
 arch/x86/kvm/pmu.h                            |   2 +
 arch/x86/kvm/svm/pmu.c                        |   1 +
 arch/x86/kvm/vmx/pmu_intel.c                  |   1 +
 arch/x86/kvm/x86.c                            |   1 +
 include/uapi/linux/kvm.h                      |   1 +
 .../kvm/x86_64/pmu_event_filter_test.c        | 392 +++++++++++++++++-
 10 files changed, 708 insertions(+), 51 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

