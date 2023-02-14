Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE376695821
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjBNFIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBNFIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:17 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F12D9F;
        Mon, 13 Feb 2023 21:08:16 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e17so7018278plg.12;
        Mon, 13 Feb 2023 21:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X5n+jvgwzHhfcQJm6aBOCFtWcaHPxO00U9XzDwao8fo=;
        b=jaqDDOOfADatjVlU2431Moq+L+6RdpA6FohQpIxGo9961E/SPTv0aslb6reuPwQyTz
         0DcUQij0RsmAcWOjl8g/IaSODON87psPeWQSmUfmhj3zxfnysOikydXpS10heGjFMGWx
         wIj5j3kcq7C+RCNtuEG0NhrjnXqTWGVsL8KSt/HhYs5sz7+4pzrcR5EMS6oGqAULNCtr
         CtbWEwKPHTdxWar9WSpGXDvNx2hnul9WDZ4ldzS5WqiBpdfixGCZz+s6xytimzaZ305d
         55TS+MhkoL9HDAHBZUsJjtHVBk7GyEMh4DGlpAliUfvcnIr5wNcLxHtX20IGhkXoStDv
         CWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5n+jvgwzHhfcQJm6aBOCFtWcaHPxO00U9XzDwao8fo=;
        b=TyMGddlcy/if7r78MENBJawAlb6thpU8xhAgrYIy0OIkRX6V6Uhu7aJUJNyxbwSCDR
         j9ZrmTpt/QdHIwM9XkmhDDfMaW5dsHgwzo1L2fLhz0EphL8akRfu/GuGEaONtNZSbpY0
         Y6v+fcSMmufg2ygxSVuGJE5R3dTydwyICM0FwJUyYThQeRcQ6tRyfo/Mfd3DBSiDASv4
         ZXd8JDKujufJlrPdrQftAXmXkeN3zy9ZcsX33nA3g8E+0u3RlgFR7yv0JTumU6MSzlhw
         lKi3X148ZcTtPnhh/TPm6hO8ixhWq8DFRn9Kt4j4Hu0n7RaBj5FgPpy3W+t3Bz6adHXS
         06Rg==
X-Gm-Message-State: AO0yUKUGbJnKE+JdJ27cgUkJL77jLtU7tTbxkzdNy7RlEazqXLindNh8
        hc4i/0U8ofDmrXYr9zJsMPE=
X-Google-Smtp-Source: AK7set+JwIAlV4az4ioF103e4r7vhVxRJuwo2USM7XrCeraLEVBHeLxyhdlIi1kAPMNFdxjmsgIw9w==
X-Received: by 2002:a05:6a20:3ca3:b0:bc:ebd8:4c8b with SMTP id b35-20020a056a203ca300b000bcebd84c8bmr1276792pzj.14.1676351295534;
        Mon, 13 Feb 2023 21:08:15 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:15 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/12] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Date:   Tue, 14 Feb 2023 13:07:45 +0800
Message-Id: <20230214050757.9623-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
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

Patch 0001-0009 could be applied earlier, which may help reduce
the burden on industrious reviewers.

Base: kvm-x86/pmu
Previous: 20221111102645.82001-1-likexu@tencent.com

V3 -> V4 Changelog:
- Compilability of each patch is retained; (Sean)
- Apply "if (!diff)" style and use the atomic set_bit(); (Sean)
- First optimize the helper, then expose it in pmu.h; (Sean)
- Just use scattered X86_FEATURE_PERFMON_V2; (Sean)
- Drop use of kvm_cpu_cap_has() when refresh; (Sean)
- Use tweaked kvm_pmu_cap.num_counters_gp; (Sean)
- Sanity check the number of counters enumerated by perf; (Sean)
- Apply an if-elif-else sequence for number of counters; (Sean)
- Refine commits messages to provide hidden information; (Sean)
- Apply kvm_cpu_cap_check_and_set() when enable_pmu; (Sean)
- Fix a coner case when user sets GLOBAL_STATUS reserved bits;
- For AMD GLOBAL_STATUS, writes are ignored as host does;
- For AMD GLOBAL_CTL, none #GP on writes as host does;
- For AMD GLOBAL_STATUS_CLR, none #GP on writes as host does;

Like Xu (11):
  KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
  KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
  KVM: x86/pmu: Expose reprogram_counters() in pmu.h
  KVM: x86/pmu: Error when user sets the GLOBAL_STATUS reserved bits
  KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
  KVM: x86/cpuid: Use fast return for cpuid "0xa" leaf when !enable_pmu
  KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
  KVM: x86/pmu: Forget PERFCTR_CORE if the min num of counters isn't met
  KVM: x86/cpuid: Add X86_FEATURE_PERFMON_V2 as a scattered flag
  KVM: x86/svm/pmu: Add AMD PerfMonV2 support
  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

Sean Christopherson (1):
  KVM: VMX: Refactor intel_pmu_set_msr() to align with other set_msr()
    helpers

 arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 -
 arch/x86/kvm/cpuid.c                   |  26 +++++-
 arch/x86/kvm/pmu.c                     |  69 +++++++++++++--
 arch/x86/kvm/pmu.h                     |  35 +++++++-
 arch/x86/kvm/reverse_cpuid.h           |   7 ++
 arch/x86/kvm/svm/pmu.c                 |  62 +++++++++-----
 arch/x86/kvm/svm/svm.c                 |  17 +++-
 arch/x86/kvm/vmx/pmu_intel.c           | 114 +++++++------------------
 arch/x86/kvm/x86.c                     |  10 +++
 9 files changed, 223 insertions(+), 118 deletions(-)

-- 
2.39.1

