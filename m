Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED87665246C
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiLTQMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiLTQMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:44 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A4C10C8
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id v17-20020a17090abb9100b002239a73bc6eso7496667pjr.1
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qPAxDrxjuJlP56I6HP/6RAeVZ6SGw8T6Im2JAaf462o=;
        b=j/ZMrlKX0RnXTjDoowPDsOobxKL030EqTSd0SKz/r+HWP20KuXrzu9/kOmLb+n2xxB
         H0ZyEMm1C8+wcsKKvs1C1qx2lFVexyOgh8kmQV+AXLgGTkBOqHb4vkj1tIWbol+RxBq4
         B3mJkxznR0o4WCYofGe1qaj8ckCrFesX3oncDB8fmj3XWTsVV3if65WPrpLyefNLJ75M
         zckGx1q7KQX3U8equLjuyAAVgPWw+QFlAkZaA4zqI9DxFGIzwJ0fSV60T/6rg/UkTXC7
         qXW8C63xS9e9SH7+0jGSi/LgbC8150Bi58iAGWDaTnxdwEl5h4/DoLeITqNs6hY9B044
         GTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qPAxDrxjuJlP56I6HP/6RAeVZ6SGw8T6Im2JAaf462o=;
        b=oSY6+ZMWYIr/e+5/3MFtGtElbnfWcDWZn7FYLGYNGtr6GPkMl2oiJYtH+K9zwwS2Y2
         lhycn7BsUQUv55TqKJ3yRLz6xXYg6KSUjFGR29WRiHaTWt0fgfa8hkT0wfVwIcFpIrQl
         VgBVvqU3GdolcEzih+68tgAevfO9VL+BV8jtefTN9W3ZWsvo43jbmstLPF7Vv2pSLwFH
         5dRdTsnBpOOm3KD/bw+lzzIZd9bcu9SADIrAOeHieNyjeAj1f1Fy0wj20rl+fCm5GAYb
         zUAh7jHrj+h3hW3roz8/kTWpSBFuIAr+KfcHVJNIWVQAEdQK3P6xrR7G/g3sJyi8hgwL
         yUdA==
X-Gm-Message-State: AFqh2krBFomXRzj6QrrUqP/V+lqbsTwI9w+PMCxqrE4DsDEqAGEsi1+F
        FBoZnI9vqa/58wZpicqKSvQsCgIIHbKzUzHbskbiI2qIQVGu0IDCA/dZCwI7/4KjhZjOyjs7CCe
        TPy774wrBSGEF6j8vSHbkaa8HRmyu/IVgCyiHAcoonfz4khTfrzgv8TwevhH/5eRr3QOE
X-Google-Smtp-Source: AMrXdXuUpUIlFp1MfanSFR7Z+o2/7WYpjFQh4JqAmcsoXHU/V27Z+f3aCbPciujMgUqehGILDfLbsmAw0dyM4upI
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:cf97:b0:213:f398:ed51 with SMTP
 id i23-20020a17090acf9700b00213f398ed51mr2686895pju.216.1671552761184; Tue,
 20 Dec 2022 08:12:41 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-1-aaronlewis@google.com>
Subject: [PATCH v8 0/7] Introduce and test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

v7 -> v8
 - Rebased on top of the latest in kvm/queue.
 - s/num_gp_counters/X86_PROPERTY_PMU_NR_GP_COUNTERS/ in the masked
   events test.

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
 .../kvm/x86_64/pmu_event_filter_test.c        | 381 +++++++++++++++++-
 10 files changed, 697 insertions(+), 51 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

