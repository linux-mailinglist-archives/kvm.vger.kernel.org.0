Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A95BC574
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiISJfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiISJfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:35:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3931D1145F;
        Mon, 19 Sep 2022 02:35:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so6430726pjk.4;
        Mon, 19 Sep 2022 02:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=hRPZk+KsgaTNvpzIDcMIBDM8evngQw0ucdqWQB57Y6Q=;
        b=TH30QO8FPGbKoPzmBwqqoXAyrEBCNtUuyH3VlcIDVL2q8MsC23+bxiiRSvdw9gZ89K
         ar1ic3GRHYd9QtgjhIZBAYDl2cf+oB98QYOrRn7QXl3ToGE6heovorbofwzl9hfV1jBE
         aPbUFJxp40vpbtSy2l5NPd5RZb8Sge1oEYjAZ15GB6QMql8RP3Y8oIQkRDb7EZRFSWK0
         UBuDgCdDWwYkBB+EADpioUZ0X7lIF5HYIcnZtLYN9AbHQTHtiQKzFG4Y4j/3GovQ4E6V
         IDQdRvuZlxf/ibgQIFVmz8S/pBkoKPnGqziIwOd4nt3+CICDVIRFUhtfw0LrvBVX0rmo
         5LiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=hRPZk+KsgaTNvpzIDcMIBDM8evngQw0ucdqWQB57Y6Q=;
        b=CvW7ztodR2DDRdnmukjgL6BkDJGDGpXUejfiuCRxQtEqsWiCeq1DsUNshfiHP5Zkvc
         xuHv+Q3TDL2pPkG3TunMxTzU9n9o9rmu7aJitrRR8V5jdsZgs0iPreQ+zEHmSRemQ3CM
         C9eii3vZ2hm4EBhUygpbKRKnOaPXG+nmeVKGDAYut+ZDiVU6REDFm/zFmMF3/BshpmDD
         E96KV7MLj85uEFeBQIkpXnBPAjPZDn0oK+e8SaDNLDW8fl4dDEfnXTxenbaOBXfqPAzy
         2WVZlfGrsf3QIZiCrZvxR81PhQBNDuycjD8odZvwNfrWFdQ+WZIarEl/OlAIcVVgCKE7
         GVlA==
X-Gm-Message-State: ACrzQf1aIHJ+bZY3CCeM1K6gPS8gLzlJv/Qok0uqLDRjmys483l/OLzV
        ojoGhpjHE9EOaD3Lc3QiiY4=
X-Google-Smtp-Source: AMsMyM6/mr8PBDNVAgPcjBHlyNonJG8u3QWyGpDKU900iLi/wrgvq2JWxsI0bXQjkZuLJNYFCS9vEw==
X-Received: by 2002:a17:902:e549:b0:178:6d7c:abf6 with SMTP id n9-20020a170902e54900b001786d7cabf6mr12573942plf.131.1663580110763;
        Mon, 19 Sep 2022 02:35:10 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w5-20020aa79545000000b0053818255880sm19815434pfq.193.2022.09.19.02.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:35:10 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Date:   Mon, 19 Sep 2022 17:34:50 +0800
Message-Id: <20220919093453.71737-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
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

The KVM part is based on the latest vPMU fixes patch set [1], while
the kvm-unit-test patch has been move to the preemptive test cases
effort [2] for testing leagcy AMD vPMU, which didn't exist before.

All related testcases are passed on a Genoa box.
Please feel free to run more tests, add more or share comments.

[1] https://lore.kernel.org/kvm/20220831085328.45489-1-likexu@tencent.com/
[2] https://lore.kernel.org/kvm/20220819110939.78013-1-likexu@tencent.com/

Previous:
https://lore.kernel.org/kvm/20220905123946.95223-1-likexu@tencent.com/

V1 -> V2 Changelog:
- The patch limiting the x86 GP counters is moved to specific patch set;
- MSR scope is bounded by pmu->nr_arch_gp_counters (Jim);
- Fn8000_0022_EBX can never report less than four counters \
  (or six, if Fn8000_0001_ECX[PerfCtrExtCore] is set); (Jim)
- Use "kvm_pmu_cap.version > 1" check instead of "guest perfmon_v2 bit";

Like Xu (2):
  KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
  KVM: x86/svm/pmu: Add AMD PerfMonV2 support

Sandipan Das (1):
  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h        |  1 +
 arch/x86/include/asm/perf_event.h      |  8 +++
 arch/x86/kvm/cpuid.c                   | 32 ++++++++++-
 arch/x86/kvm/pmu.c                     | 61 +++++++++++++++++++--
 arch/x86/kvm/pmu.h                     | 30 +++++++++-
 arch/x86/kvm/svm/pmu.c                 | 76 +++++++++++++++++++-------
 arch/x86/kvm/vmx/pmu_intel.c           | 58 +-------------------
 arch/x86/kvm/x86.c                     | 14 ++++-
 9 files changed, 193 insertions(+), 88 deletions(-)

-- 
2.37.3

