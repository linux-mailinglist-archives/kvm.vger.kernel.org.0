Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC653715542
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjE3GEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjE3GEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:04:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B73B0;
        Mon, 29 May 2023 23:04:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25692ff86cdso1125812a91.2;
        Mon, 29 May 2023 23:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426684; x=1688018684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l5DvF5nRUAHGx88VoVPEHaXDuUCJAAyEDMoMTP8mSMc=;
        b=VDmCpDoN6dS9PJO5mUynEi5uP8I/Frv9ODJADqgChkCty6YOaz5f++QApaKjKywFdl
         MQ4NAqPLkAZLuktfDOHmUqcILYidDRvaiuXYuM82VfOn/Q5UeQwcGRL162Azsizdh6p6
         O6easG1ZGBRAHDQgP2SioLpgWvOsh6Fvk4P+bE4MmyufSW9kjti40axMIXtXMKZBvLOu
         9arFNPgjMQRWyS0cUBuANOFizFHcKE4G9hypPmGC4ieeLpkRn2Od91mro7rxBb7fJmC4
         1ztZN0QZx8b5UiI4xPgn6ip6bCF+4kz1N8+qZ1jZzZO9fruzqVrLKT1LWDIsRgS7//sk
         nkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426684; x=1688018684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l5DvF5nRUAHGx88VoVPEHaXDuUCJAAyEDMoMTP8mSMc=;
        b=CsLZZkGU0+j1FqR+HJqBINpaVdxWweC3NUUgPZYIutlxlMV5e4PSeZbHbpOytMdCoL
         lnzOq0bZpWvEPvovv3zQlCWubruD2SWltdCKpbJ1nak7I7lmFKzbx12m51pMLJjf8IlP
         bSgrApDcMXVv3oS/Yj2m3WRja7p5B1DDfPW7JVm0l8ftxPhK7Kq2pZ9/U65N8yNMOBgL
         5UWecyfNaXt9TfcBBv2/G93fEP2oJ970GTXP0xraVCjmuwPyLK1zT7J8KOGQ2emb74Gt
         bM2iyIWIuTgSZUzPpmSQ9r5fo3zHbxEqVJGZRMx6q1fqAwyzrhyOrdqpV+77Z6CO2nLo
         e6XQ==
X-Gm-Message-State: AC+VfDysv1nFPBddJGMyflq+MDoj+tO33LOKqKRbJ8ye70QjYNFUdYKT
        Khd1p0oOkp4g+BsvRJifeUI=
X-Google-Smtp-Source: ACHHUZ6KKvm1xXTZNzlSWhT9/by/zJH5txUaeDjy1Le5wlGSPLNPxDg5e26LN+vQKKPZeR+2Us7YBA==
X-Received: by 2002:a17:90b:3a85:b0:256:8e2d:1ec8 with SMTP id om5-20020a17090b3a8500b002568e2d1ec8mr1347662pjb.41.1685426683825;
        Mon, 29 May 2023 23:04:43 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:42 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/10] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Date:   Tue, 30 May 2023 14:04:13 +0800
Message-Id: <20230530060423.32361-1-likexu@tencent.com>
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

V5 -> V6 Changelog:
- Introduce pmu_ops->MIN_NR_GP_COUNTERS and WARN_ON_ONCE; (Sean)
- Set MIN_NR_GP_COUNTERS = 2 instead of 1 for Intel Arch PMU;

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
 arch/x86/kvm/pmu.h                     | 43 +++++++++++--
 arch/x86/kvm/reverse_cpuid.h           |  7 +++
 arch/x86/kvm/svm/pmu.c                 | 68 +++++++++++++++------
 arch/x86/kvm/svm/svm.c                 | 19 +++++-
 arch/x86/kvm/vmx/pmu_intel.c           | 33 +++-------
 arch/x86/kvm/x86.c                     | 10 ++++
 9 files changed, 230 insertions(+), 64 deletions(-)


base-commit: b9846a698c9aff4eb2214a06ac83638ad098f33f
-- 
2.40.1

