Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEEF4CA2EA
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbiCBLO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiCBLO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17C54BB87;
        Wed,  2 Mar 2022 03:13:44 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so363504pju.2;
        Wed, 02 Mar 2022 03:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=24rkf0ybzja72MMqLa1zp/S8buaWnl1mP/xdfxdfVF0=;
        b=O1zgz2ddWY2bq4wVtAz52CefJ0HwcbiFgyZuepTllU9HgiF77dhA/7wK+ttZDOw5M6
         ri8lZgo4G/kx1+8dqutyDQs7she7D4AU+GeVYGXcoA6K6pobc0mdPVWzD9kQ0rzLmXiY
         9j9jWojuAc174INa3ZAozWJMoK81O8NkdDmmqQVPVaAkrJCCwlBqE718fQUPHNhiJES4
         f5AELMQA30qIPfZJNDbBTGY6PSMfMWrVI5XKLUV8TEw6fHGaYn9Qut85JUr71/V3EsbI
         6gkp71QEhWkZokV8V/Cm5HFVkKVqPTGTV7H8qTwVUFAozMd3Cwj2MEOmDoNjnwlsIzFN
         H/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=24rkf0ybzja72MMqLa1zp/S8buaWnl1mP/xdfxdfVF0=;
        b=I02xedIjO/CvJ1g4DsoFTZ8PgLY6Zu5jTj6IULa8l4GfvZ3LKKoBn8jDxCffnFKgXQ
         8AJEnqrp9EznCRIinV98bjdFPrvAp9fQVcSkn6yIAFql68pN7kI1tMktl829WfTfw3zi
         1eR2nuILvE1x4+0ifIBGpAurrwdexzH5+RtfN7U/f+mNWukvWoZlz2mFlcMwIpvaDVmp
         ZUDtxliv9ZrAHgq+cRN13jvVcJPYnFbmzWqsNB8sYOP4knYOiqBwGBl24PC/APFiG3N2
         WeQ9QxA9a93H4P4axih6tpE8Hkn+Eq6f2NQs7W/Ej57pwqxwvHBrcaJRqQUBrDrQYmc1
         YYqQ==
X-Gm-Message-State: AOAM533fBieGjNPhoIgm4HtSqhU4KFlHLGNhoiqRR+FLVQwSeszfXuGi
        l4i3qE+sXmOiS19Vv7kOuOw=
X-Google-Smtp-Source: ABdhPJwIYnFlQKTJF/TVkYneHZfeVoZVJvtyEE1BOzno43+MLDZY/z/jxEHEwcadFbb1BJwYVRrIqw==
X-Received: by 2002:a17:902:7d81:b0:14f:e18b:2b9e with SMTP id a1-20020a1709027d8100b0014fe18b2b9emr29710059plm.160.1646219624340;
        Wed, 02 Mar 2022 03:13:44 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:43 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 00/12] KVM: x86/pmu: Get rid of PERF_TYPE_HARDWAR and other minor fixes
Date:   Wed,  2 Mar 2022 19:13:22 +0800
Message-Id: <20220302111334.12689-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

This is a follow up to [0]. By keeping the same semantics of eventsel
for gp and fixed counters, the reprogram code could be made more
symmetrical, simpler and even faster [1], and it also fixes the
obsolescence amd_event_mapping issue [2].

One of the notable changes is that we ended up removing the
reprogram_{gp, fixed}_counter() functions and replacing it with the
merged reprogram_counter(), where KVM programs pmc->perf_event
with only the PERF_TYPE_RAW type for any type of counter
(suggested by Jim as well).  PeterZ confirmed the idea, "think so;
the HARDWARE is just a convenience wrapper over RAW IIRC". 

Practically, this change drops the guest pmu support on the hosts without
X86_FEATURE_ARCH_PERFMON  (the oldest Pentium 4), where the
PERF_TYPE_HARDWAR is intentionally introduced so that hosts can
map the architectural guest PMU events to their own.

Some code refactoring helps to review key changes more easily.
Patches are based on top of kvm/master (ec756e40e271).

The 11nd patch removes the call trace in the commit message while we still
think that kvm->arch.pmu_event_filter requires SRCU protection in terms
of pmu_event_filter functionality, similar to "kvm->arch.msr_filter".

Patch 0012 is trying to expose some reserved bits for Milan use only, and
the related discussion can be seen here [3], thanks to Jim and Ravikumar.

Please check more details in each commit and feel free to comment.

[0] https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/
[1] https://lore.kernel.org/kvm/ebfac3c7-fbc6-78a5-50c5-005ea11cc6ca@gmail.com/
[2] https://lore.kernel.org/kvm/20220117085307.93030-1-likexu@tencent.com/
[3] https://lore.kernel.org/kvm/c7b418f5-7014-d322-ea47-2d4ee9c2748c@gmail.com/

Thanks,

v1: https://lore.kernel.org/kvm/20220221115201.22208-1-likexu@tencent.com/
v1 -> v2 Changelog:
- Get all the vPMC tests I have on hand to pass;
- Update obsolete AMD PMU comments; (Jim)
- Fix my carelessness for [-Wconstant-logical-operand] in 0009; (0day)
- Add "u64 new_config" to reuse perf_event for fixed CTRs; (0day)
- Add patch 0012 to attract attention to review;

Like Xu (12):
  KVM: x86/pmu: Update comments for AMD gp counters
  KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
  KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
  KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
  KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
  KVM: x86/pmu: Use only the uniformly exported interface
    reprogram_counter()
  KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,
    fixed}counter()
  perf: x86/core: Add interface to query perfmon_event_map[] directly
  KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
  KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
  KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
  KVM: x86/pmu: Clear reserved bit PERF_CTL2[43] for AMD erratum 1292

 arch/x86/events/core.c            |  11 ++
 arch/x86/include/asm/perf_event.h |   6 +
 arch/x86/kvm/pmu.c                | 182 ++++++++++++------------------
 arch/x86/kvm/pmu.h                |   6 +-
 arch/x86/kvm/svm/pmu.c            |  57 ++++------
 arch/x86/kvm/vmx/pmu_intel.c      |  64 ++++++-----
 6 files changed, 149 insertions(+), 177 deletions(-)

-- 
2.35.1

