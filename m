Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5329A79B6A6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjIKUrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbjIKLod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10299CEB;
        Mon, 11 Sep 2023 04:44:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 98e67ed59e1d1-273527a8fdeso2783039a91.2;
        Mon, 11 Sep 2023 04:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432668; x=1695037468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SAz7AqRb92UNH52P26F16CmzE8miVyK1O5zcpgPMdsM=;
        b=J90N/GKqlL3g25y8PvLhbcRsZYJlHr7LqcI2q3GuS3jBEmgM+NXz+/feY9AQ949IWw
         ND4krYvMVwfXZFEuM/2YBNPoG8EuwQnsjIgiUNFuv4iNGibv4axdgs6bjW9rdB4iy/lp
         vfpFIf0ikswevcd4El8lP6/l2MXI4Ilux0rlU+UXVZEA/y+O1osSQsFVXUG3BseJv0hH
         mXgKFCPfvLbwhM3QpDaaaHMVeMloJicY/7ehEPZBMBLyhHmjXrB+kEdnyh20yzJjLSpo
         QFrzuaYMFsUhLHZMEMprpmalDMl0KncBQnYKHWZp1RAq5CwngvhsuIETPnraypo18O6+
         i8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432668; x=1695037468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SAz7AqRb92UNH52P26F16CmzE8miVyK1O5zcpgPMdsM=;
        b=oTPXC02fjKFWZAH8thE/aM9uk26EZ+0NrIvZNeAZ6sclHR0ZfOT+ioM/TE9C5ugcct
         BW50fC5iZQdRIz99R0r6p7jmbu6CN7GM6U30e321H9nTjJ1+xfrdmHy0PuudNpPK/a02
         NggucKvhlO4gpmnyfvBP1WfyjgybFN69G0H34IH3lF4VCPU5fFLwXfd6vJ5xSZwH96ht
         3l1dyFPQcm2/IMLTLRYSqjZoPYnhnviKe1rwIO4tHXA9ERRmzNlgBeRWoEtXVQucfjdK
         bHKC6S8EpoSckfBZNGSIXUrElwvsk7U8ZMyTaN8xo71bsLZ75rSaaQem3S3Jko6gc95G
         MjKg==
X-Gm-Message-State: AOJu0YzT43id6ryZRsa3UhTZTnQ5QgxPUI6Ckfl5c4+mqWwLVqqZz0eE
        EsVKtcyOUFTWz7ZDG8G6bNQ=
X-Google-Smtp-Source: AGHT+IG1QYsw3Y4bXEH5ydr9690hvmjg5zy6DD42VxAT5pwaewGbbn06iOITJF3eDwciAIXGvimEAg==
X-Received: by 2002:a17:90b:11d1:b0:26d:61:3aad with SMTP id gv17-20020a17090b11d100b0026d00613aadmr6714104pjb.4.1694432668448;
        Mon, 11 Sep 2023 04:44:28 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:28 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/9] KVM: selftests: Test the consistency of the PMU's CPUID and its features
Date:   Mon, 11 Sep 2023 19:43:38 +0800
Message-Id: <20230911114347.85882-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The KVM selftests show advantages over KUT in terms of finding defects through
flexible and varied guest settings from the KVM user space.

This patchset tests whether the Intel vPMU works properly with different Intel
CPUID.0xA configurations. It also provides test scaffolding and a sufficient
number of PMU test cases to subsequently offer adequate code coverage of AMD
vPMU or Intel complex features, such as LBR or PEBS, in selftests.

These patches have been tested and have passed all test cases. AMD related tests
will be completed in the future, please consider merge these patches before that.

Any feedback or suggestions are greatly appreciated.

Sincerely,
Jinrong Liang

Changelog:

v4:
- Rebased to e2013f46ee2e(tag: kvm-x86-next-2023.08.25)
- Separate AMD-related tests.
- Moved static arrays to a new file lib/pmu.c and used more descriptive names
  like intel_pmu_arch_events, intel_pmu_fixed_pmc_events, and
  amd_pmu_arch_events. (Sean)
- Clean up pmu_event_filter_test.c by including pmu.h and removing
  unnecessary macros.
- Modified the "anti-feature" framework to extend this_pmu_has() and
  kvm_pmu_has() functions. (Sean)
- Refactor guest_measure_loop() function to simplify logic and improve
  readability. (Sean)
- Refactor guest_wr_and_rd_msrs() function to simplify logic and improve
  readability. (Sean)
- Use GUEST_ASSERT_EQ() directly instead of passing the counter to ucall and
  back to the host. (Sean)
- Refactor test_intel_oob_fixed_ctr() test method. (Sean)
- Avoid using half-baked helpers and optimize the code structure. (Sean)
- Update variable names for better readability and consistency. (Sean)
- Rename functions to better reflect their purpose. (Sean)

v3:
https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com/T/

Jinrong Liang (9):
  KVM: selftests: Add vcpu_set_cpuid_property() to set properties
  KVM: selftests: Extend this_pmu_has() and kvm_pmu_has() to check arch
    events
  KVM: selftests: Add pmu.h for PMU events and common masks
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of gp counters
  KVM: selftests: Test consistency of CPUID with num of fixed counters
  KVM: selftests: Test Intel supported fixed counters bit mask
  KVM: selftests: Test consistency of PMU MSRs with Intel PMU version

 tools/testing/selftests/kvm/Makefile          |   2 +
 tools/testing/selftests/kvm/include/pmu.h     |  96 ++++
 .../selftests/kvm/include/x86_64/processor.h  |  42 +-
 tools/testing/selftests/kvm/lib/pmu.c         |  38 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  14 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 431 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        |  34 +-
 7 files changed, 623 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: e2013f46ee2e721567783557c301e5c91d0b74ff
-- 
2.39.3

