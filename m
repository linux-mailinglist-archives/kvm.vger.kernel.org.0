Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894FA608044
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJUUvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJUUvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8713727D4D0
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:14 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k16-20020a170902c41000b00184987e3d09so2287850plk.21
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1+zIYmJEV+nUZqUxoS3ih+KaqnftixLJPR1KW6w/SDg=;
        b=ieHP/CnW6ihQir4MEKTx46fhwsBsmblygghCwfUVNOaxFhzD2ID8DKWHBSYw4d6jCV
         wUlKfru5hZ4naITqelTyJ7dzZVQsmolrDtSREupN2TKwd6yzIoMqauH//i6QZyti3AhD
         h/PzkkU3pWIRdy6k+nNTsS3cYcKwNXeUH0f9l8x2K97BQElHCDj2bSLE8nFuoFkLmN/d
         dQA+QqgVbztHyfdLqPUi86UzEGSXBQFqh5k7GmKDIKqrDW2qA5BW3/XpqljQewtOranG
         1Ng0sjoCRWW66+0pYDe7LZhwEPEP4Wk8uhfdvkSbXdviv3Kmh4GQeg1l0MNs2CkmQ0Am
         rp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1+zIYmJEV+nUZqUxoS3ih+KaqnftixLJPR1KW6w/SDg=;
        b=D3dWEVuuWEIHq0YBROV44+wCNAjg1zo3Sg61FMrymKa7UUk5XPJUNfqoN2vrZoWYan
         55Nsl0aOBiPPQnrhqTIqZxRJcfLNiN4BQaWr/Toxqtq/dICXjsRGVeDuL/HOTK+2rlDB
         QDxlBK0XokBYYJlfYCL5lcQ5cn1WHBTUYBagAMXty0pIZKnAXNnvSvbgZEdDoI/lNCjd
         wQXD3qfwZ4ti2bJzrr/wZ/Z9ujJFJAdK8GP795lovKfVZk7ZUR81TuQqSRKuX43bqBG2
         2vdkBV02qyZh9MvyN+nZQ+35fKg8oE6ownF4qlkQZqlcwVFw+Q9LCFcWV7wtWMBvfnji
         qHnA==
X-Gm-Message-State: ACrzQf0sHS1BsnQld7HIthSYs9LIvRao3k9AFDsPg1iSoDbPE11BZN/o
        2KePps0NtSfujeUIAj/KhSiGokxMNhfH4Mh2UL4tsn68jotjurI02Tt3s3BLxzbBd0OhkXTWn9s
        c7xWAZhuS8ysLI49uuhi4Hlf/QUlOOoe/lli78ymU4MCSeBKM2Npz7YPAl+Ts8CjpCHoX
X-Google-Smtp-Source: AMsMyM5P4ynXuNNTMY2GJlXSYvWIQqKGnNHoqkOTdjY1bYarjoKWWjVV4mm4ar2gOVtkF59bYx88jLxAerdvyv3x
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:aa7:9397:0:b0:562:cbf1:1186 with SMTP
 id t23-20020aa79397000000b00562cbf11186mr21287967pfe.5.1666385473936; Fri, 21
 Oct 2022 13:51:13 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:50:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-1-aaronlewis@google.com>
Subject: [PATCH v6 0/7] Introduce and test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
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
 .../kvm/x86_64/pmu_event_filter_test.c        | 387 +++++++++++++++++-
 10 files changed, 703 insertions(+), 51 deletions(-)

-- 
2.38.0.135.g90850a2211-goog

