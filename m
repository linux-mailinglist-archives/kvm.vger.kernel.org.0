Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069FD625846
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiKKK1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiKKK1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0BCDA6;
        Fri, 11 Nov 2022 02:27:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so4355449pjl.3;
        Fri, 11 Nov 2022 02:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d6jL93WhMTa53i1uq6NCcbu86kzvp1Qe47BB/9+T3QA=;
        b=I+xa3NAS/H9eAqReqRxPZ/78s51TEa09qxfItml9L7FFX/JKBHiw4SMZ7kKpSb6Xj2
         A44V0obeGpwfazdzEQZSD68d9urrdYaI3eNcR2jJ8gBghJYKpoexcnc7utvdyBuS4eJ8
         26Was24z6zn/UcmTIfAxtTu5+RgNJT6pmKpKn2kJZBIcspVKPUAFEBj5vkvP2JJvBAL9
         fxczHvBrc/FfM5XbHXpHRgMXTI1WDd36c3Lb9yBjYamqEuja1jPIrsvEedfbeVzMjD40
         Xyh7fgB1bwkC/S78jiPbJ8WykV1I6YziCKz5+ogbGy1VV5eo0yLIu0mqQlJej4ZYpfDE
         LEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d6jL93WhMTa53i1uq6NCcbu86kzvp1Qe47BB/9+T3QA=;
        b=4WI6QuxqLgFAxXWUyhSxquOZ2+m0xKLHcHd34iwXdb/1HJlCRxKRmV5N0+/Blk4GOm
         mBAFkojQjVDme4LzlD9Ka4S9nh16zGjwuzepOjK3sokD5mSXzY/BLeBTT5R5f1XBFQY4
         XKOo+vaic3PLJeyTrWXVRxcO5Rjgt0gT3d33/DQVQWl1M3++1i3UQddx/XDHUA2r1SZ2
         SdV02xxJBEaCcQ57xAjazGcJhHO7GXatelFvZ/PAD6s/cPYATIObqNepO7euiWzrv9Dx
         8J0vDM/N8h95aVVSl7FZilZom8TLL+lqZGePbgHfLGc2abiKeQsUfpFC0Y0iNIyc5Sk+
         3CQg==
X-Gm-Message-State: ANoB5plREGiFgUVNqJuST8E4EX1PiDYUNwNs1sRX1SdLkTKAy2T9YGX2
        2Ze6cB7Rdgj0gtxKm8Vo9I8=
X-Google-Smtp-Source: AA0mqf7i+h8rNkD1jRtsH4VQqDXiODW9SeekNaaR4w/dCext3dHpHFlP9VGDsTbL1WcoOQFBj1OUrg==
X-Received: by 2002:a17:902:8645:b0:17f:8097:83c1 with SMTP id y5-20020a170902864500b0017f809783c1mr2026376plt.10.1668162424502;
        Fri, 11 Nov 2022 02:27:04 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:03 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Date:   Fri, 11 Nov 2022 18:26:37 +0800
Message-Id: <20221111102645.82001-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting with Zen4, core PMU on AMD platforms such as Genoa and
Ryzen-7000 will support PerfMonV2, and it is also compatible with
legacy PERFCTR_CORE behavior and msr addresses.

If you don't have access to the hardware specification, the commits
d6d0c7f681fd..7685665c390d for host perf can also bring a quick
overview. Its main change is the addition of three msr's equivalent
to Intel V2, namely global_ctrl, global_status, global_status_clear.

It is worth noting that this feature is very attractive for reducing the
overhead of PMU virtualization, since multiple msr accesses to multiple
counters will be replaced by a single access to the global register,
plus more accuracy gain when multiple guest counters are used.

All related testcases are passed on a Genoa box.
Please feel free to run more tests, add more or share comments.

Previous:
https://lore.kernel.org/kvm/20220919093453.71737-1-likexu@tencent.com/

V2 -> V3 Changelog:
- Renme pmc_is_enabled(); (Jim)
- Move the reprogram_counters() changes as a separate patch; (Jim)
- Refactoring to align with other set_msr() helper; (Sean)
- Fix the issue if userspace wants to expose v1 for whatever reason; (Sean)
- Add the feature flag X86_FEATURE_AMD_PMU_V2; (Sean)
- Check enable_pmu for intel 0xa as well; (Sean)
- Limit AMD pmu's KVM support to version 2 as well;
- Other nit changes around C code taste; (Sean)

Like Xu (7):
  KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
  KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
  KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
  KVM: x86/cpuid: Add X86_FEATURE_AMD_PMU_V2 as a KVM-only leaf entry
  KVM: x86/svm/pmu: Add AMD PerfMonV2 support
  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
  KVM: x86/cpuid: Use fast return for cpuid "0xa" leaf when !enable_pmu

Sean Christopherson (1):
  KVM: VMX: Refactor intel_pmu_set_msr() to align with other set_msr()
    helpers

 arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 -
 arch/x86/include/asm/kvm_host.h        |   1 +
 arch/x86/kvm/cpuid.c                   |  32 ++++++-
 arch/x86/kvm/pmu.c                     |  65 +++++++++++++--
 arch/x86/kvm/pmu.h                     |  28 ++++++-
 arch/x86/kvm/reverse_cpuid.h           |  10 +++
 arch/x86/kvm/svm/pmu.c                 |  73 +++++++++++-----
 arch/x86/kvm/svm/svm.c                 |  11 ++-
 arch/x86/kvm/vmx/pmu_intel.c           | 111 +++++++------------------
 arch/x86/kvm/x86.c                     |  14 +++-
 10 files changed, 228 insertions(+), 118 deletions(-)

-- 
2.38.1

