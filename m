Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF4609D8E
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJXJNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJXJNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA255A2D4
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso6742375pjz.4
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=roYgQ6uEHRHf5dq23vxxiO0ozXruOY12B23w8EAwmFg=;
        b=SZLsdvUny9tzqP4CGdlHHCRdoRK00oX+ICx5goV3L312V0zSTX69BUJZBM1pwAD8nU
         b5BtORzSM9PTICeBrRmmOMUkKTULkdWXZ8VQbji4btnojhz7kGIFNuCPXubmXQdD5yiJ
         AIcG7j7ojrVDxrhL5tW/BLHr3JvQ2yks8yXBgxWS1+V9LamwUN1a9gMLIbcHNRspzpop
         YSnPrSROvj9VEn7T6mP4ejHMV8vvCj8one/hgfzYREOraEHDJaco2HKqrYtOkVqfqv4A
         CVZOAwQ2GmB0ZvMrBccIuTAJEZLyI+PkqZCQJCurAT9NyuI7k9rlnLv7nKvF+h/F5fy5
         44aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=roYgQ6uEHRHf5dq23vxxiO0ozXruOY12B23w8EAwmFg=;
        b=8JOKz+cXLVhyxcS6Q7el8YxOd03TlI5396pdrShQ+ktK2lvqLGFSmCE+SWy/0yTXMq
         /Kl0thEFWppDjlo4dl4iyCShslTxUplE8ZRa0s6sBViKlo6lHKKoud5D7znONJ23GQqh
         jgrMRTItyh7EutuDtSDWPe/IGFyhbZFuG0eWxnNG7G6cIoKt205rAY8hXkIkFQqrxtsC
         chU5b6P0fM7loLzJRvsdUAUeAcVNAXdcSEw5hhTMYSH1abIYjy9WLU7TlkaygXuxnw4E
         /N71YORCwbYTalG3VjNUBHj+lZ9mwGXgH1E5YqSDv205Fpf8VAIActtOPA1bQk6ZvJfG
         3MlA==
X-Gm-Message-State: ACrzQf2/WSmYpVURC8PmFdFzB9hOYnNtz6fF3HH+I6TdrpGhKpkpdvYq
        qAvJtHLSAbXfZHeyHh8/D6M=
X-Google-Smtp-Source: AMsMyM5kF8aKq1Q7kq/jiPlgny8LA3iGBSG/KtUt3htRTZ5GlAZjiK3SA3WAZ5XmDe0oy80gikZ81A==
X-Received: by 2002:a17:90b:4c8b:b0:213:ec:4431 with SMTP id my11-20020a17090b4c8b00b0021300ec4431mr6987488pjb.20.1666602781584;
        Mon, 24 Oct 2022 02:13:01 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:01 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 00/24] x86/pmu: Test case optimization, fixes and additions
Date:   Mon, 24 Oct 2022 17:11:59 +0800
Message-Id: <20221024091223.42631-1-likexu@tencent.com>
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

The patch set includes all the changes on my side (SPR PEBS and AMD
PerfMonV2 are included, except for Arch lbr), which helps to keep the
review time focused. 

There are no major changes in the test logic. A considerable number of
helpers have been added to lib/x86/pmu.[c,h], which really helps the
readability of the code, while hiding some hardware differentiation details.

These are divided into three parts, the first part (01 - 08) is bug fixing,
the second part (09 - 18) is code refactoring, and the third part is the
addition of new test cases. It may also be good to split up and merge
in sequence. They get passed on AMD Zen3/4, Intel ICX/SPR machines.

Please feel free to test them in your own CI environment.

v3: https://lore.kernel.org/kvm/20220819110939.78013-1-likexu@tencent.com/
v3 -> v4 Changelog:
- Add more helpers to the new lib/x86/pmu.h and lib/x86/pmu.c;
  (pmu_cap, perf_capabilities other pmu related stuff)
- Refine commit message and report_ messages;
- Code style fixes (curly braces, #defeine, GENMASK_ULL,
  ternary operator);
- Add more message for "the expected init cnt.count for fixed counter 0"
  (measure_for_overflow() is applied);
- Rename PC_VECTOR to PMI_VECTOR;
- Snapshot pebs_has_baseline() to avoid RDMSR on every touch;
- Drop the idea about is_the_count_reproducible() for AMD;
- Add X86_FEATURE_* in the KUT world;

Like Xu (24):
  x86/pmu: Add PDCM check before accessing PERF_CAP register
  x86/pmu: Test emulation instructions on full-width counters
  x86/pmu: Pop up FW prefix to avoid out-of-context propagation
  x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
  x86/pmu: Fix printed messages for emulated instruction test
  x86/pmu: Introduce __start_event() to drop all of the manual zeroing
  x86/pmu: Introduce multiple_{one, many}() to improve readability
  x86/pmu: Reset the expected count of the fixed counter 0 when i386
  x86: create pmu group for quick pmu-scope testing
  x86/pmu: Refine info to clarify the current support
  x86/pmu: Update rdpmc testcase to cover #GP path
  x86/pmu: Rename PC_VECTOR to PMI_VECTOR for better readability
  x86/pmu: Add lib/x86/pmu.[c.h] and move common code to header files
  x86/pmu: Read cpuid(10) in the pmu_init() to reduce VM-Exit
  x86/pmu: Initialize PMU perf_capabilities at pmu_init()
  x86/pmu: Add GP counter related helpers
  x86/pmu: Add GP/Fixed counters reset helpers
  x86/pmu: Add a set of helpers related to global registers
  x86: Add tests for Guest Processor Event Based Sampling (PEBS)
  x86/pmu: Add global helpers to cover Intel Arch PMU Version 1
  x86/pmu: Add gp_events pointer to route different event tables
  x86/pmu: Add nr_gp_counters to limit the number of test counters
  x86/pmu: Update testcases to cover AMD PMU
  x86/pmu: Add AMD Guest PerfMonV2 testcases

 lib/x86/msr.h       |  30 +++
 lib/x86/pmu.c       |  36 ++++
 lib/x86/pmu.h       | 306 +++++++++++++++++++++++++++++++
 lib/x86/processor.h |  80 ++------
 lib/x86/smp.c       |   2 +
 x86/Makefile.common |   1 +
 x86/Makefile.x86_64 |   1 +
 x86/pmu.c           | 297 ++++++++++++++++++------------
 x86/pmu_lbr.c       |  20 +-
 x86/pmu_pebs.c      | 433 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +
 x86/vmx_tests.c     |   1 +
 12 files changed, 1022 insertions(+), 195 deletions(-)
 create mode 100644 lib/x86/pmu.c
 create mode 100644 lib/x86/pmu.h
 create mode 100644 x86/pmu_pebs.c

-- 
2.38.1

