Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48565BEC34
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiITRqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiITRqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:46:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF16642E1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k126-20020a253d84000000b0068bb342010dso2829224yba.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=5do7vRFgX3lapBnmpL/cqjSoiD5wQu4utGUAjAWhoRk=;
        b=GFPrNc+AiIk5M3Xb9pQUq+U/WCdK+1ZE39LecEhg0R6RlhW0GYtuI9miElnZR4AL4g
         faeqO8FCZrJ5NF6vfbvfFe71Jy3hOqeDExsnWCqpJbpUCBjMWTYIdZk/rX/wau+xd2AU
         SIv4OPzrV4iteo0HzZ2F41Meq/eKnfyBnLMdFORX7JWwGLULvEm9+wAX7b0gV0LH9rjT
         uXOiAWh/zOLP/v6sQIBaKJGtUBVCLptt1+9OYdCo9LZ3BaQ/vUxVENVT/9ZccZUJZM8k
         8Uci0PvTvH29YxQkPG7x9Co4UdJwAI9NMKW0KT6TlKU/Ku34BA4kVvX+rX9M7qqMWBQv
         FYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=5do7vRFgX3lapBnmpL/cqjSoiD5wQu4utGUAjAWhoRk=;
        b=np/oxROcHbNH1PakLgGYP9KdntW3wi+k2/1g3NWuA3Q/R/2OpZ2HYRjaIoMUCph6gJ
         cX35KWieCGScAOGuQHETj6vffLYpCTgAMkPQdPuiEteP+iuLFWE4Tqp+orzJawdDQgBk
         KR9G/pxxyXSTLIkyqNGIjKj4Pfw54YPvMtcdzPP7/oap+Jy5IwuC7QxaVrBW3SC/WfSs
         SaacBfCAvrUlroMmOE52EZSazeE6+xFlPT6kHcv4yqp9ya284MwxPWm7IMN8zP7NFw+M
         qDkgORp4TzpRiK4CWuXU1d6uGr4wOb3+goVi0Ty7iRV7NwJM79OtP4WGI5kc89ORAnZk
         Z3uA==
X-Gm-Message-State: ACrzQf0u8qCZxi5OHXKyQFwDvXRVCFWgEOriw6yh70WcnbyjmFOJ39ve
        +7RauK44y3nt/ezzjM+LK/0RrymQ8DqcmzLDTPYF4nSXw2CrJ/mCL2T/NmUZ3shPm+Tb6NLunxf
        DYRhS7Gnq3/ukMGMbbH5PxhMelZsmXPsIUKBo03onpU+mpEbW7hUAGHWGL2lkimGU7mvZ
X-Google-Smtp-Source: AMsMyM4VwtQHBXlXpp+WWPW/y716ho84l4TtNWESMCPQHfiseHG2bNdcP529vVe2e2c7e00THxHY19ZnIGMwfMD2
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a81:148c:0:b0:345:3561:8f4 with SMTP id
 134-20020a81148c000000b00345356108f4mr20544057ywu.76.1663695970909; Tue, 20
 Sep 2022 10:46:10 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:45:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920174603.302510-1-aaronlewis@google.com>
Subject: [PATCH v5 0/7] Introduce and test masked events
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
  kvm: x86/pmu: Remove invalid raw events from the pmu event filter
  kvm: x86/pmu: prepare the pmu event filter for masked events
  kvm: x86/pmu: Introduce masked events to the pmu event filter
  selftests: kvm/x86: Add flags when creating a pmu event filter
  selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
  selftests: kvm/x86: Test masked events

 Documentation/virt/kvm/api.rst                |  82 +++-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 +
 arch/x86/include/uapi/asm/kvm.h               |  28 ++
 arch/x86/kvm/pmu.c                            | 262 ++++++++++--
 arch/x86/kvm/pmu.h                            |  39 ++
 arch/x86/kvm/svm/pmu.c                        |   6 +
 arch/x86/kvm/vmx/pmu_intel.c                  |   6 +
 arch/x86/kvm/x86.c                            |   1 +
 include/uapi/linux/kvm.h                      |   1 +
 .../kvm/x86_64/pmu_event_filter_test.c        | 387 +++++++++++++++++-
 10 files changed, 771 insertions(+), 42 deletions(-)

-- 
2.37.3.968.ga6b4b080e4-goog

