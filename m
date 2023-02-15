Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081A5697317
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjBOBHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjBOBHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:21 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37682596A
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:20 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so12553153ild.16
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IyNPeLOdyUSRCloXmM+8l8tMrO7/92CcJQeGkdKd/vw=;
        b=a3RFuz2JUP+kYHqqv6Gl99pOIwgDCa05eLIbj2NAByamb9c87BYsdvwxSsltqlpuTj
         G5bChEn3dvtuU/Zn/BWCKyZk07px3NCmu8Z7Eyewl9O+etu7BOXo/pGAhhwDWb+RofUf
         UY6O8BrPc0LpoYEbfvBh3vYBSpVnCO+zJ/76Ecmegs8MzRSqk+w1yE103NepU7HN1/6e
         VwSD+ZVgh1SJWgb7GFmq2TZjZaYbfX9ne88fw/xhK+Lh0frKX3CYWN6CjCp7QgJ66mhA
         8ld3bdlRiq0Mh27BOLutcQQ4BHuJ1jQWhO3HqmaP7p3TrxwMal8Rk0LRiM2xuK3+aI3A
         fsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IyNPeLOdyUSRCloXmM+8l8tMrO7/92CcJQeGkdKd/vw=;
        b=TIKiNd1l32b8Drqn7PEZsVvlABtafeyK8RX8UOWrcijxutz0JRyYYG8Y4PEN/fyVA0
         VPVkuxd/C3VuPwNS+EUVyzDS7vDfuySFsQ0ApBqp55ICPQVJm0cDi1me4Qgm0JTnZWxV
         9A7xW1jC1x4noF+uFo4bagHmpkia0m+h4KC7bWrI485ZgTKk+DK+AcR1+3BwXt7ofqCF
         6XIoqiAh6prIe5HIpojr9C/SV1fCoDPbWyRRQUpvLvAlP0ru3laVl+WgWRBJAVd2LYwh
         6ZiImV/R9CFMYb9aDdYUt7zR26F4sD85v9KhH80p52jXe3gYAj6bMnjNxV8QjP2acXA0
         r0jg==
X-Gm-Message-State: AO0yUKX68SIzKiuLA/jah2+I7nw5IxVMNbW9epwcWLX9b6b/df8XOGae
        teeYNxqfnLIcUZALab9AsXYx4kKhFVA2
X-Google-Smtp-Source: AK7set/hhwzs3tBETMRfIHWDYFlERciNM8DL4xWOpJy9YppTznI6bpJLKBiVPnqbNBCyVEoxYd0Fj8xSX5cn
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a6b:4015:0:b0:6df:2c9f:f8fc with SMTP id
 k21-20020a6b4015000000b006df2c9ff8fcmr306048ioa.4.1676423240257; Tue, 14 Feb
 2023 17:07:20 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:01 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-1-rananta@google.com>
Subject: [REPOST PATCH 00/16] Add support for vPMU selftests
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The series aims to add vPMU selftests to improve the test coverage
for KVM's PMU emulation. It includes the tests that validates actions
from userspace, such as verifying the guest read/write accesses to the
PMu registers while limiting the number for PMCs, and allowing or denying
certain events via KVM_ARM_VCPU_PMU_V3_FILTER attribute. It also includes
tests for KVM's guarding of the PMU attributes to count EL2/EL3 events,
and formal KVM behavior that enables PMU emulation. The last part validates
the guest expectations of the vPMU by setting up a stress test that
force-migrates multiple vCPUs frequently across random pCPUs in the system,
thus ensuring KVM's management of vCPU PMU contexts correctly.

As suggested by Oliver in my original post of the series [1] (and with
Reiji's permission), I'm re-posting the series to include the
selftest patches from Reiji's series that aims to limit the number
of PMCs for the guest [2].

Patches 1-4 are unmodified patches 11-14 from Reiji's series [2],
which introduces the vPMU selftests that adds a test to validate
the read/write functionalities for the guest accesses to the
implemented and unimplemented counters.

Patch-5 refactors the existing tests for plugging-in the upcoming tests
easily and rename the test file to a more generic name.

Patch-6 and 7 add helper macros and functions respectively to interact
with the cycle counter.

Patch-8 extends create_vpmu_vm() to accept an array of event filters
as an argument that are to be applied to the VM.

Patch-9 tests the KVM_ARM_VCPU_PMU_V3_FILTER attribute by scripting
various combinations of events that are to be allowed or denied to
the guest and verifying guest's behavior.

Patch-10 adds test to validate KVM's handling of guest requests to count
events in EL2/EL3.

Patch-11 introduces the vCPU migration stress testing by validating cycle
counter and general purpose counter's behavior across vCPU migrations.

Patch-12, 13, and 14 expands the tests in patch-8 to validate
overflow/IRQ functionality, chained events, and occupancy of all the PMU
counters, respectively.

Patch-15 extends create_vpmu_vm() to create multiple vCPUs for the VM.

Patch-16 expands the stress tests for multiple vCPUs.

The series has been tested on hardwares with PMUv3p1 and PMUv3p5 on
top of v6.2-rc7 plus Reiji's series [2].

Thank you.
Raghavendra

[1]: https://lore.kernel.org/all/20230213180234.2885032-1-rananta@google.com/
[2]: https://lore.kernel.org/all/20230211031506.4159098-1-reijiw@google.com/

Raghavendra Rao Ananta (12):
  selftests: KVM: aarch64: Refactor the vPMU counter access tests
  tools: arm64: perf_event: Define Cycle counter enable/overflow bits
  selftests: KVM: aarch64: Add PMU cycle counter helpers
  selftests: KVM: aarch64: Consider PMU event filters for VM creation
  selftests: KVM: aarch64: Add KVM PMU event filter test
  selftests: KVM: aarch64: Add KVM EVTYPE filter PMU test
  selftests: KVM: aarch64: Add vCPU migration test for PMU
  selftests: KVM: aarch64: Test PMU overflow/IRQ functionality
  selftests: KVM: aarch64: Test chained events for PMU
  selftests: KVM: aarch64: Add PMU test to chain all the counters
  selftests: KVM: aarch64: Add multi-vCPU support for vPMU VM creation
  selftests: KVM: aarch64: Extend the vCPU migration test to multi-vCPUs

Reiji Watanabe (4):
  tools: arm64: Import perf_event.h
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 tools/arch/arm64/include/asm/perf_event.h     |  265 +++
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 1710 +++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |    1 +
 4 files changed, 1977 insertions(+)
 create mode 100644 tools/arch/arm64/include/asm/perf_event.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_test.c

-- 
2.39.1.581.gbfd45094c4-goog

