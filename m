Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3666DC5DF
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDJKvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDJKvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE8730F0;
        Mon, 10 Apr 2023 03:51:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j14-20020a17090a7e8e00b002448c0a8813so8145273pjl.0;
        Mon, 10 Apr 2023 03:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123877; x=1683715877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+cp0LISv+vmAv0weVi7Q9coFk87WvNHn1cuZazLIFrQ=;
        b=UWZnw8gSDXYiAJ+8F2FvaYplF/UPRX47cLChbsqgLgkFRS2MVmAOJgXDRZbHY+l4eQ
         1MsRhefnbEuq7Axvoyuo58h3+0kwmPgC6mLaimjSLyyw3P5CK8kW+AISyfq8GIZ85N2x
         dvIYSbGiStrSxMF/A/RpeKoO7mb9L9meC9pQbZf38N34/MwmyvQyX/F2eTSLAPXpwu7f
         QhOeVXFL937ptHt/zK3g80/AM50yxyHDyEoWavE05DyAhDT7dcC9T9PGK1OULuIWdbkL
         256MpQFzzVHSXt1nzluElYayliiZFFKmaofztVQEtvAmQQr4QUnMzwv+FCHxSiPlqf6G
         zPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123877; x=1683715877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+cp0LISv+vmAv0weVi7Q9coFk87WvNHn1cuZazLIFrQ=;
        b=jv+3Tt3Jvs4BOD05rJRmpPZmfjsX2skVCfcxBw3d17IHtDb4r6WzhpVxKt8XQk7pCf
         GT7dK8cl15qHH8O9WtFIqMeAPgp/53IHADb2z7RiERdlWdkPmxa+3mlpAeq6OorXuJzt
         ZBiUEsRcS/a3YCZfo9Y2+Y1rntJCM1/QOsos1kC8mVIyYH8XJDdQlsj9jebeif9EVHE1
         gqcGZfu0TVEoVcUrBzGYvpobgkDX0Ik2JvM8/gSjfkldPK74lJcCVk9c1zuZAR39WsWU
         Pznc2d6e9X2rmOHn4e4T5mHQQQfE6Qxu1Kfbg0gn0e2OqP1MAOOLryB2J/friPRgfnm3
         KMQg==
X-Gm-Message-State: AAQBX9c5n0sonu22imSZMcjZO3bx0Ql1xRmZcpW5z5zFKKSki8BHR489
        jXGe3rbY2TO7pSZXjFVjSow=
X-Google-Smtp-Source: AKy350ZuICfQJZzyZu9eJdhs0SVyCK/YqIlcqrfog3QvwFuUCEJL3RvaveYKWc/BuC2HsaZrSqTOVg==
X-Received: by 2002:a05:6a20:49a8:b0:cb:ec5f:3c5b with SMTP id fs40-20020a056a2049a800b000cbec5f3c5bmr7381349pzb.18.1681123876827;
        Mon, 10 Apr 2023 03:51:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 00/10] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Date:   Mon, 10 Apr 2023 18:50:46 +0800
Message-Id: <20230410105056.60973-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting with Zen4, core PMU on AMD platforms such as Genoa and
Ryzen-7000 will support PerfMonV2, and it is also compatible with
legacy PERFCTR_CORE behavior and MSR addresses.

If you don't have access to the hardware specification, the commits
d6d0c7f681fd..7685665c390d for host perf can also bring a quick
overview. Its main change is the addition of three MSR's equivalent
to Intel V2, namely global_ctrl, global_status, global_status_clear.

It is worth noting that this feature is very attractive for reducing the
overhead of PMU virtualization, since multiple MSR accesses to multiple
counters will be replaced by a single access to the global register,
plus more accuracy gain when multiple guest counters are used.

All related testcases are passed on a Genoa box.
Please feel free to run more tests, add more or share comments.

Patch 0001-0007 could be applied earlier, which may help reduce
the burden on industrious reviewers.

Previous:
https://lore.kernel.org/kvm/20230214050757.9623-1-likexu@tencent.com/

V4 -> V5 Changelog:
- Avoid pronouns in the changelogs and comments; (Sean)
- Drop the assumption that KVM can blindly set v2 without changes; (Sean)
- Grab host CPUID and clear here (instead of setting); (Sean)
- Clarification of behaviours from spec-defined and HW observations; (Sean)
- Drop the use of the intermediate "entry"; (Sean)
- Use BUILD_BUG_ON() to avoid potential null-pointer deref bug; (Sean)
- Add a patch to cap nr_arch_gp_counters in the common flow; (Sean)
- Add sanitize check for pmu->nr_arch_gp_counters; (Sean)
- Rewrite changelogs which doesn't depend on the shortlog; (Sean)
- State what the patch actually does, not "should do"; (Sean)
- Drop the useless multiple line comment; (Sean)
- Apply a better short log; (Sean)
- Drop the performance blurb; (Sean)
- Drop the "The", i.e. just "AMD PerfMonV2 defines ..."; (Sean)
- s/hanlders/handlers; (Sean)
- s/intel/Intel; (Sean)
- Drop useless message on pmc_is_globally_enabled(); (Sean)
- Tweak "return 1" to follow the patterns for other MSR helpers; (Sean)
- Add assumptions about reusing global_ovf_ctrl_mask; (Sean)

Like Xu (10):
  KVM: x86/pmu: Expose reprogram_counters() in pmu.h
  KVM: x86/pmu: Return #GP if user sets the GLOBAL_STATUS reserved bits
  KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
  KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
  KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
  KVM: x86/pmu: Forget PERFCTR_CORE if the min num of counters isn't met
  KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
  KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
  KVM: x86/svm/pmu: Add AMD PerfMonV2 support
  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/cpuid.c                   | 30 +++++++++-
 arch/x86/kvm/pmu.c                     | 83 +++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     | 32 +++++++++-
 arch/x86/kvm/reverse_cpuid.h           |  7 +++
 arch/x86/kvm/svm/pmu.c                 | 67 +++++++++++++++------
 arch/x86/kvm/svm/svm.c                 | 19 +++++-
 arch/x86/kvm/vmx/pmu_intel.c           | 32 ++--------
 arch/x86/kvm/x86.c                     | 10 ++++
 9 files changed, 221 insertions(+), 60 deletions(-)


base-commit: dfdeda67ea2dac57d2d7506d65cfe5a0878ad285
-- 
2.40.0

