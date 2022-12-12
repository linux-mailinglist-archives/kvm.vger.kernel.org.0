Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A6649F2F
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 13:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiLLM7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 07:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiLLM7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:13 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAED9C2A;
        Mon, 12 Dec 2022 04:59:12 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d7so11973203pll.9;
        Mon, 12 Dec 2022 04:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fqd7rV/LIZQRhBND1wfi4ZK3s862aHDRSXa+Hfs3x/0=;
        b=d2mgt4Cm3rJ0WcxSsZxqXfIUEu+wiv6uIRONxo/jNgTpK6sDFgWpgj9F1xUHLYj168
         c+KZZ3anW7HFmcjRNy1H991RyOD58xofnivxlE0WyBFp5R92LEwWB188uSTAmcO8SL0X
         Uz6frgZlmo/ekNLv5DqDImjtlKyLTtTIyAvMzHKLRw/YwKmQtElGir7VkPOp6OnyDe+M
         kqhqFynH3NeBGyhN/kUzpR2G5syuw+oiHQKRMdLKipn8E5fL1REcN5DjCyqoOmcA1Iwg
         BauZ0WtBIbXAmmURP5+DX7EO+UFuvAVJsi/hbn1+/2iqpOCXTnGtiGogYjns1SofZGTN
         F4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fqd7rV/LIZQRhBND1wfi4ZK3s862aHDRSXa+Hfs3x/0=;
        b=jcIetMcvGY/xRjEWI67/oB2ruP/rzWF+awgrfnLcbsmOJkQ3LcAVqlLrPuY51eyRdg
         us2LSJ9+5hRUkO9E6NfIfm/ZN8XSmbCR8l34TajZU7u6b/au2QixwZL1G27twPJ+SK0a
         4sI8opWUiZ0aqajD5vi4XBM360t6JUbsbv9NcgbVAh+7G1VUDbZtvjy2HPNsem5Ozsox
         /u/vjaM0crvZ2AKXwHhCvQNvwdPvPSbjlq7kyFWFrnBqj/XoSq3f2CdQT18E8w8nR7dP
         7T3YYVq1n4OFNQCziJGlKwe45y0WHcCEF5sIN71OjgSXoarCT3Q+lEuqvLUHdP4KyR0D
         CNDw==
X-Gm-Message-State: ANoB5pnxpxn261StDrWW17RVgCc+ZGhX+2LNnk9EaxnEGNYrdYTVBvg/
        9o3wmcjqW1OZUS2vKnH07s4=
X-Google-Smtp-Source: AA0mqf77GZIw7gQFedXZs86HhHJyGeXNzAanu5XUe83msXQOsjZh99qJsuAVkWNAlkekTtkUrbqqcw==
X-Received: by 2002:a17:903:324c:b0:189:d0fa:231b with SMTP id ji12-20020a170903324c00b00189d0fa231bmr17227594plb.67.1670849952078;
        Mon, 12 Dec 2022 04:59:12 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:11 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RFC 0/8] KVM: x86/pmu: Enable Fixed Counter3 and Topdown Perf Metrics
Date:   Mon, 12 Dec 2022 20:58:36 +0800
Message-Id: <20221212125844.41157-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Hi,

The Ice Lake core PMU provides built-in support for Top-down u-arch
Analysis (TMA) method level 1 metrics. These metrics are always available
to cross-validate performance observations, freeing general purpose
counters to count other events in high counter utilization scenarios.
For more details about the method, refer to Top-Down Analysis Method
chapter (Appendix B.1) of the Intel® 64 and IA-32 Architectures
Optimization Reference Manual. (SDM 19.3.9.3 Performance Metrics)

This patchset enables Intel Guest Topdow for KVM-based guests. Its basic
enabling framework remains unchanged, a perf_metric msr is introduced,
a group (rather than one) of perf_events is created in KVM by binding to
fiexed counter3 to obtain hardware resources, and the guest value of
perf_metric msr is assembled based on the count of grouped perf_events.

On KVM, patches 0004/5/6 may be reviewd independently if KVM only
enable fixed counter3 as normal slot event for count and sampling. 
Patch 7 updates the infrastructure for creating grouped events in KVM,
and patch 8 uses group events to emulate guest MSR_PERF_METRICS.

On Perf, Patches 0001-0003 are awaiting review for tip/perf/core, and
could be accepted separately if they make sense. TBH, I don't think our
perf/core is fully prepared to support kernel space grouped counters,
considering comments around perf_enable_diasable(). But after much
exploration on my part, this is probably the most promising way to get
KVM to create slots plus metrics events. If the addition of *group_leader
messes things up, please shout at me on your needs.

More details in each commit messages may answer code-related questions.

A classic perf tool usage on a linux guest is as follows:
$ perf stat --topdown --td-level=1 -I1000 --no-metric-only sleep 1
#           time             counts unit events
     1.000548528         34,505,682      slots
     1.000548528         14,208,222      topdown-retiring                 #     41.5% Retiring
     1.000548528          1,623,796      topdown-bad-spec                 #      4.7% Bad Speculation
     1.000548528         14,614,171      topdown-fe-bound                 #     42.7% Frontend Bound
     1.000548528          3,788,859      topdown-be-bound                 #     11.1% Backend Bound

Related KUT will follow if there are no obstructive negative comments.

Nit, pre-patches includes:
https://lore.kernel.org/kvm/20221207071506.15733-2-likexu@tencent.com/
https://lore.kernel.org/kvm/20221205122048.16023-1-likexu@tencent.com/

Please feel free to comment and share your feedback.

Thanks,

Like Xu (8):
  perf/core: Add *group_leader to perf_event_create_kernel_counter()
  perf: x86/core: Expose the available number of the Topdown metrics
  perf: x86/core: Snyc PERF_METRICS bit together with fixed counter3
  KVM: x86/pmu: Add Intel CPUID-hinted Topdown Slots event
  KVM: x86/pmu: Add kernel-defined slots event to enable Fixed Counter3
  KVM: x86/pmu: properly use INTEL_PMC_FIXED_RDPMC_BASE macro
  KVM: x86/pmu: Use flex *event arrays to implement grouped events
  KVM: x86/pmu: Add MSR_PERF_METRICS MSR emulation to enable Topdown

 arch/arm64/kvm/pmu-emul.c                 |   4 +-
 arch/x86/events/core.c                    |   1 +
 arch/x86/events/intel/core.c              |   3 +
 arch/x86/include/asm/kvm_host.h           |  14 +-
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/include/asm/perf_event.h         |   1 +
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |   4 +-
 arch/x86/kvm/pmu.c                        | 149 ++++++++++++++++++++--
 arch/x86/kvm/pmu.h                        |  31 +++--
 arch/x86/kvm/svm/pmu.c                    |   1 +
 arch/x86/kvm/vmx/pmu_intel.c              |  53 +++++++-
 arch/x86/kvm/vmx/vmx.c                    |   3 +
 arch/x86/kvm/x86.c                        |   9 +-
 include/linux/perf_event.h                |   1 +
 kernel/events/core.c                      |   4 +-
 kernel/events/hw_breakpoint.c             |   4 +-
 kernel/events/hw_breakpoint_test.c        |   2 +-
 kernel/watchdog_hld.c                     |   2 +-
 18 files changed, 239 insertions(+), 48 deletions(-)

-- 
2.38.2

