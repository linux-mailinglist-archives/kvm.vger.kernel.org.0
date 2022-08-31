Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BE25A8306
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiHaQVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiHaQVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:31 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9F040575
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id a17-20020a17090abe1100b001fda49516e2so6607526pjs.2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=sCiA4MTOrnXwQYXV+hOJsLz+FHEM50SuOafWbV7pV/s=;
        b=bYLn2r7+bBtre+fFhvxlsbitxgvodM2qGwKG/O+0h6KkcpQdDHpaUAskvuq6Fr1ZEz
         Iqp/phiknuHsVGoE26yYE0CR+c7ylIwM58XmQirBpr+v0rsBEfxzyJpwjz2QT5kwEz47
         qMkonJiTMvWBMcUEv1Gl8YEIJD1vkGSAeqF4jIjGij6el/0hdkTUxAnL7Ieas53icmlp
         jN/9Ge7+/p+k/eKfzicU+Dc5yFU/YPug9w3jcxHPazu6P+ZKRcJCQzO/T67149GGf0Nd
         fGht8uFBeuRlTcOt93nKMvqDBFSs4MQoQm4bdPbFsjCXkmKedeWe/1dhxjtRtPwnVcSx
         vP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=sCiA4MTOrnXwQYXV+hOJsLz+FHEM50SuOafWbV7pV/s=;
        b=OowrgiC6GhW0XlV91r77sAscvP4VPfIUuQSUSY4wu6Y7LyRZArkaZrU/zmFmp/Z/Jb
         EgX3hGL5idk0QV/64v0tvVtTNquq6uahEChieWF/OrjHEq71hIUiyuVtHF0PwMynyQoN
         9q9xGgBMnx//77iPby7q4uphO3ChHHTJJMk2+k9LRcU7liX8eTeZfZoWY46p2XJOWupk
         3ii0JJsdBin9TQXHSrYPOJNgnY6At/zMlJBOFsapl+5+UdAsovqoV+Aikks8qlWZJZDc
         80QF/wHjJc4oV/9j1LC1q0zQQjv9VbYrsli2tfwvWz1yz5l/lMzzOd9UtCeHdI6k0AQ+
         GUWg==
X-Gm-Message-State: ACgBeo205wMb/gTH/5C7CgEy2sMBfDZjNntVD89tNq6+mmEIAhu79te4
        WAp9Y9RLaAw2h+9i1Xv9Ujono8LtLJi6ZM40G01cVG3pSkn/vj/VE2C/LI/AVvyZ4KMHrhGxdPw
        YtY4i5ZIGGnGhDdGTlZpAw8wGLiJxz8arX67bnwsT78ZczkNmyW4sXdrP3PwsIW7fEf1l
X-Google-Smtp-Source: AA6agR6KnqXPaqX15AXJ419PmGYCpqyWYJsOY3MNhmccy7C1UMpBBRTXWh8oqLtpQOC9uLzJ2DvTjbwdO6hwQ5wF
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:ce11:b0:172:6f2c:a910 with SMTP
 id k17-20020a170902ce1100b001726f2ca910mr27126910plg.156.1661962889802; Wed,
 31 Aug 2022 09:21:29 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-1-aaronlewis@google.com>
Subject: [PATCH v4 0/7] Introduce and test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

This series introduces the concept of masked events to the pmu event
filter. Masked events can help reduce the number of events needed in the
pmu event filter by allowing a more generalized matching method to be
used for the unit mask when filtering guest events in the pmu.  With
masked events, if an event select should be restricted from the guest,
instead of having to add an entry to the pmu event filter for each
event select + unit mask pair, a masked event can be added to generalize
the unit mask values.

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

 Documentation/virt/kvm/api.rst                |  81 +++-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 +
 arch/x86/include/uapi/asm/kvm.h               |  28 ++
 arch/x86/kvm/pmu.c                            | 262 ++++++++++--
 arch/x86/kvm/pmu.h                            |  39 ++
 arch/x86/kvm/svm/pmu.c                        |   6 +
 arch/x86/kvm/vmx/pmu_intel.c                  |   6 +
 arch/x86/kvm/x86.c                            |   1 +
 include/uapi/linux/kvm.h                      |   1 +
 .../kvm/x86_64/pmu_event_filter_test.c        | 374 +++++++++++++++++-
 10 files changed, 756 insertions(+), 43 deletions(-)

-- 
2.37.2.672.g94769d06f0-goog

