Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC11971625B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjE3NnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjE3NnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1EC116;
        Tue, 30 May 2023 06:43:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 98e67ed59e1d1-2566f66190dso2238317a91.1;
        Tue, 30 May 2023 06:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454188; x=1688046188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j/RmtovxmE8eT6l9DRcjDNrWbdMnULzP4ChgiJqFcdg=;
        b=dmHMQh81VpALgHOBDUrPrBE+3Q+fHHBiETOxy1N7TXjLigp0f1/v1Z7M9OTdBBmW4W
         luZw1odu9vsUzWUZy0Uee64Uqc7rrPkkoIon3VHOU4zEb9KqLSJMV4Ce69anUnQA0dQ4
         wdXmVJO5Z1+jyJUZUY31mA5lRTslWqWkCvSDT8Jc1XpeR/wa9YwFotxBkuAn1yPPa0gf
         PmlzqTXDOa3FUPtJH09ntt/ddRXjw8nj94TxIokIIW5d9pg4v4vSCw7zgLur9xXtRl5P
         6wSlibNUscz9YZw6tE7xFgDfwDdYxRSeG7EX6rCD28BeVl+EEckQxcUIaGnswJmo7/dm
         D3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454188; x=1688046188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/RmtovxmE8eT6l9DRcjDNrWbdMnULzP4ChgiJqFcdg=;
        b=QM+SnI9jMTZ5IvbISIIDYaBIlyg017bckogmXHfHN5y0pa1GkZCn/vu5SKC6qCy7Bk
         jfAE8q4LpBmlvUSuOIqgmiE4nM0iu0O+rBITjxz8Ko7XCSTneHix6lLjZ/i5KSljpBFI
         n5R76M6dckUC6FfjNTT+Hkua4FfZgZyuKUzmEHPikW908j3LAlw1E2IQsZM3If5KTN5D
         VIJVFcQqOHQZcB8McHttEcsjLXI8r2oIBhl/6zTw1QqiTaXnrLnlDXI8Pup4y+xaJ5ah
         LYHdK/WcYOymS1QSDlyyuDB0tZQyu+zJm2H0DU69InVMi+y3qcCCsJkEI4NGfyc2lWsh
         ROJQ==
X-Gm-Message-State: AC+VfDxn9dBVK0MfElA4Iy5s2GARbhrGGzS6dfSZGX+Wq0VbmnLziEC1
        B617Ub6S76VWj2VyTwvZQAs=
X-Google-Smtp-Source: ACHHUZ532ULIvp+OsfTkCENDDHv8JXFbEAtMYlbdbt4meBrOkZuV72xBunDG/srIGBdQuVxq7xK4nA==
X-Received: by 2002:a17:90a:8583:b0:256:6f2a:c85c with SMTP id m3-20020a17090a858300b002566f2ac85cmr2248116pjn.48.1685454188369;
        Tue, 30 May 2023 06:43:08 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:07 -0700 (PDT)
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
Subject: [PATCH v2 0/8] KVM: selftests: Test the consistency of the PMU's CPUID and its features
Date:   Tue, 30 May 2023 21:42:40 +0800
Message-Id: <20230530134248.23998-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Please feel free to add more tests or share valuable comments.

Thanks

v2:
- Rebased to 5c291b93e5d6(tag: kvm-x86-next-2023.04.26)
- Added a new patch to add macros to processor.h to obtain the number of fixed
  counters and fixed counters bit mask. (Sean)
- Added a new patch to introduce a new pmu.h header file to better organize the
  PMU performance event constants and common masks. (Sean)
- Changed the file name to pmu_basic_functionality_test. (Sean)
- Replaced new_vcpu() with the new function pmu_vm_create_with_one_vcpu() and
  replaced free_vcpu() wrapper with kvm_vm_free(). (Sean)
- Modified the run_vcpu() wrapper to return the first ucall param. (Sean)
- Defined KVM_X86_CPU_PROPERTY macros where possible to avoid opening code in
  multiple places. (Sean)
- Optimized the comment. (Sean, Jim)
- Modified the guest logic to have the guest return the counter value and
  perform the assert in kvm user space. (Sean)
- Used goto instead of the ternary operator in intel_guest_run_arch_event(). (Sean)
- Added a test to check that KVM drops writes to MSR_P6_PERFCTR[0|1]. (Sean)
- Used rdmsr_safe() and/or wrmsr_safe() instead of installing a dedicated handler. (Sean)
- Optimized variables that do not need to be initialized. (Sean)
- Removed patch KVM: selftests: Test Intel counters' bit width emulation.

Previous:
https://lore.kernel.org/kvm/20230323072714.82289-1-likexu@tencent.com/T/#u

Jinrong Liang (5):
  KVM: selftests: Add macros for fixed counters in processor.h
  KVM: selftests: Add pmu.h for PMU events and common masks
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of fixed counters
  KVM: selftests: Test consistency of PMU MSRs with Intel PMU version

Like Xu (3):
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test consistency of CPUID with num of gp counters
  KVM: selftests: Test Intel supported fixed counters bit mask

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/pmu.h        |  56 +++
 .../selftests/kvm/include/x86_64/processor.h  |   2 +
 .../kvm/x86_64/pmu_basic_functionality_test.c | 455 ++++++++++++++++++
 4 files changed, 514 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/pmu.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c


base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.31.1

