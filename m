Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF264CFD86
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbiCGMAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiCGMAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:00:23 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436A830F70;
        Mon,  7 Mar 2022 03:59:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e2so13531829pls.10;
        Mon, 07 Mar 2022 03:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2zk0cr3osCX7PCsQB15bnL2mvAmdG4lxJqZkNMdXitg=;
        b=TCIiOnk7YelhGnyplC/OTyhyVibMfjgSeizgxCGWK1elwtngyCy4uE6FEKJ6nmGgFL
         p/LsBMY4hub2j+BzhdMEmw5yzXbjR71RwPT3p5mAoYB5X68xzV9ygQUQCjBtxhuGqVgh
         /tN7cBtwvi3JcMgnbgXrLItR6dJHCYAwOAOnl7uU3We+htpoig0tSwPfAjEsGbPV7eW5
         IIiZZSNzFgugQ2S9gB8nQlSHy2ju+uz3AFmd3pxMdI1vDgMcELsZupMvlzvZt1DeHSwS
         cxPJidThndJfuf6DzNp4Kg/NXOVfbV6PE9OGYv3vB2XviMDDiQfvuYbub17qY0ILdmBq
         DwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2zk0cr3osCX7PCsQB15bnL2mvAmdG4lxJqZkNMdXitg=;
        b=GqWqZ0iV/rh74bUGbuShtU73Waw1yWUse+lHPA6wulCohL3J1OrFzoqldPMRibiXK9
         TMeyBoFNZAWijvo/UM/D1yXkY3yOl00PnQ1W0gaJWiYuU8MBjIXX7tx8ONiL28S6rADg
         5NkZAGVqCZLt72FMXaJt7c9TP+LDomoa151ljSzJmFvz2f9WSzHTuT9AWWDHpvcmDWYX
         xw1gETk4qRBcN0rWchctJDkCvgr+FkQBd3SVB2xwsiKiqS+Q7g7mxX3YUAgNYD+Ad8yx
         xhd4bsFWQI1YWHx01mJmBc0BDJU3HgQXzH/xMl2B/4PPEaT8z9iP/joKBvm0xDdYQqdc
         TTAw==
X-Gm-Message-State: AOAM532VC5e17nMVgiKQhetuu3tUFLDgi/Uvv5cGiYbau76IoeCZo9Dt
        DSmdMTwUC/R5f8kJlpYJmlo=
X-Google-Smtp-Source: ABdhPJx506SUZJzLgFoNnFn3YzpOKErDsnc5PaSP0W4F/oOrv3zyK57Br7kNTPhXR5PFJ90AYl5IJg==
X-Received: by 2002:a17:90b:1d90:b0:1bf:2e8f:9bb5 with SMTP id pf16-20020a17090b1d9000b001bf2e8f9bb5mr15659899pjb.236.1646654368731;
        Mon, 07 Mar 2022 03:59:28 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b004e152bc0527sm15323164pfh.153.2022.03.07.03.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:59:28 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
Date:   Mon,  7 Mar 2022 19:59:16 +0800
Message-Id: <20220307115920.51099-1-likexu@tencent.com>
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

This is a successor to the previous patch set [1] from Jason Baron, which
converts kvm_pmu_ops to use static_call. A typical perf use case [2] for
an Intel guest shows good performance gains (results are in patch 0004).

V2 -> V3 Changelog:
- Refine commit messages for __initdata; (Sean)
- Merge the logic of _defining_ and _update_; (Sean)
- Drop EXPORT_SYMBOL_GPL(kvm_pmu_ops); (Sean)
- Drop the _NULL() variant in the kvm-x86-*-ops.h; (Thanks to Paolo and Sean)
- Drop to export kvm_pmu_is_valid_msr() for nVMX; (Thanks to Sean)
- Based on the kvm/queue;

V1 -> V2 Changelog:
- Export kvm_pmu_is_valid_msr() for nVMX [Sean]
- Land memcpy() above kvm_ops_static_call_update() [Sean]
- Move the pmu_ops to kvm_x86_init_ops and tagged as __initdata. [Sean]
- Move the kvm_ops_static_call_update() to x86.c [Sean]
- Drop kvm_pmu_ops_static_call_update() [Sean]
- Fix WARNING that macros KVM_X86_OP should not use a trailing semicolon

Please note checkpatch.pl complains a lot about KVM_X86_*_OP macros:
- WARNING: macros should not use a trailing semicolon
- ERROR: Macros with multiple statements should be enclosed in a do - while loop
which could be addressed as a one-time follow-up if needed.

Previous:
https://lore.kernel.org/kvm/20211108111032.24457-1-likexu@tencent.com/

[1] https://lore.kernel.org/lkml/cover.1610680941.git.jbaron@akamai.com/
[2] perf record -e branch-instructions -e branch-misses \
-e cache-misses -e cache-references -e cpu-cycles \
-e instructions ./workload

Thanks,

Like Xu (4):
  KVM: x86: Move kvm_ops_static_call_update() to x86.c
  KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
  KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tag as __initdata
  KVM: x86: Use static calls to reduce kvm_pmu_ops overhead

 arch/x86/include/asm/kvm-x86-pmu-ops.h | 31 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h        | 17 +--------
 arch/x86/kvm/pmu.c                     | 48 +++++++++++++++-----------
 arch/x86/kvm/pmu.h                     |  9 ++++-
 arch/x86/kvm/svm/pmu.c                 |  2 +-
 arch/x86/kvm/svm/svm.c                 |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c           |  2 +-
 arch/x86/kvm/vmx/vmx.c                 |  2 +-
 arch/x86/kvm/x86.c                     | 23 ++++++++++++
 9 files changed, 94 insertions(+), 42 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h

-- 
2.35.1

