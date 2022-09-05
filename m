Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22A15AD30B
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbiIEMny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbiIEMnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:43:16 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E537205D8;
        Mon,  5 Sep 2022 05:40:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so12089958pjq.3;
        Mon, 05 Sep 2022 05:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=aoTzHdLt5DRebdwUakbgXg4mutD8fgnwel4A07FWh8A=;
        b=YP+GI+PZD68LiZV+mKGFc3n9MmjJjDOgzWVLfAMp9ezXyruct+aofJkOeaeSfXYBAr
         tBIuas43c5aD6fjjKTm36FCg4w6k+ke0L557wGPOUj8TFRhNvliG3pdwdg3HGHZn+GFH
         xHOAgM/EI+2nyG156wwBJvi9QfkXAZmKN3j93RNM8r1m8qtsZtU7Dv6elnVfP20slGAi
         hKnXbYPzLafTB4CWj9X75E2o07D5BauTAqi0ck/IDzlNFgCWQD4SIyCTH0sLeIuUHNZQ
         0+jZVQBgsHdecJpKi52NHuii6l3C7Fo3URTWKTRfPWtbqp29uFh90qss9gmtCun9t2I6
         1OUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=aoTzHdLt5DRebdwUakbgXg4mutD8fgnwel4A07FWh8A=;
        b=AuggDX1SadltLywBJO7K86Gjg0jYWRnqk5LV9ZOAZtoQPxt7mZVo5cpmvSCBMIm2i0
         hCaqe8NhOMOViM0ffIm7HFBYMTfMtaPiiXLeMI+USyveo4XUrxQC6FiKWs6eSD5wYEJJ
         s+inzxCDxPbymB6MHHSydXZWOYzUr+tXbfTIL0TFvF9zu6RGT07ZbjZ1+RDw68ZVyl4o
         LaHlwksE2K9afTVrDKg8cYgA40ZY++S/irKGzN4BpF6pnZ5bMAk/ja8LLEooEwgA8JbT
         uWhsxNMwHOveWv+cjTekEHmsqnC1nZumRhqCSML0xH2kRekF7MpkS3PYIgWIHbcFbOOS
         02Yg==
X-Gm-Message-State: ACgBeo1i8BeCJJQwXlnpD928/rTfk3oxW/6d1UcZaumwCsKx0uN+6X8p
        ESYkZEWu9mWqvt0taGqrdU0=
X-Google-Smtp-Source: AA6agR6GS4DHBPTb/Pu7fslZp/5au+4ELJiwVVmuqW96L5t9mm2AFVsTpDwgybvI07yVl3LWgL5D3g==
X-Received: by 2002:a17:902:cf4c:b0:174:9c44:97fa with SMTP id e12-20020a170902cf4c00b001749c4497famr40369551plg.125.1662381604473;
        Mon, 05 Sep 2022 05:40:04 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b00168dadc7354sm7428431plg.78.2022.09.05.05.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 05:40:04 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: x86/svm/pmu: Add AMD Guest PerfMonV2 support
Date:   Mon,  5 Sep 2022 20:39:40 +0800
Message-Id: <20220905123946.95223-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
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
the kvm-unit-test patch relies on preemptive test cases effort [2] for
testing leagcy AMD vPMU, which didn't exist before.

All related testcases are passed on a Genoa box.
Please feel free to run more tests, add more or share comments.

[1] https://lore.kernel.org/kvm/20220831085328.45489-1-likexu@tencent.com/
[2] https://lore.kernel.org/kvm/20220819110939.78013-1-likexu@tencent.com/

Like Xu (3):
  KVM: x86/svm/pmu: Limit the maximum number of supported GP counters
  KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
  KVM: x86/svm/pmu: Add AMD PerfMonV2 support

Sandipan Das (1):
  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/include/asm/perf_event.h      |  8 ++++
 arch/x86/kvm/cpuid.c                   | 21 +++++++-
 arch/x86/kvm/pmu.c                     | 61 ++++++++++++++++++++++--
 arch/x86/kvm/pmu.h                     | 32 ++++++++++++-
 arch/x86/kvm/svm/pmu.c                 | 66 +++++++++++++++++---------
 arch/x86/kvm/vmx/pmu_intel.c           | 58 +---------------------
 arch/x86/kvm/x86.c                     | 13 +++++
 8 files changed, 173 insertions(+), 87 deletions(-)

-- 
2.37.3

