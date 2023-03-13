Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B866B6DFB
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 04:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCMDaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 23:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCMDa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 23:30:26 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F14311F5
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 20:30:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i7-20020a626d07000000b005d29737db06so6076875pfc.15
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 20:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678224;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SdlPWktROsh+JmiviRgnNdVxeIIiPFplxaQO79O6Ksw=;
        b=qScfWVRHtaNZ7LeoilFi7KVFQvfj43FymK5EnBRDSXjBmUm8JlatP9MRZ64qcejuLs
         XjA/8aKDew9t3Y4rRzL1Y3CsHlQC044bLOfeJpafYcgptPgqGAl0dCIWR5Na2kzN4jjw
         mUGTFwbyUpbno31gPjx4teUokKWQmaHTEHkjPGY6/kN5/KU1jIDLN1tSLLcedvR7biMn
         NDpB3sQh+hWtvRr81AyGceLKKshSMcNhlbUCvNmcXgXyknyICmNYe+sakKSgs2zYUPUa
         Hc4Zh4O5Q/VExhRDjA1KE7/bxKWxfjIQ3pKMVWwBBwSQW299zecsEtI3z8VmE9ZIKmYJ
         U+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678224;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SdlPWktROsh+JmiviRgnNdVxeIIiPFplxaQO79O6Ksw=;
        b=UjVSqxBt3YC0l3f7CuQhizwKXzMBS+LlXK0V3fuNBJuqYwFOdgreN0d/9kciaDj7El
         Hp+yHlxZRRtlz5Z0w+sRKN1+2HbVXyWZGp5n3gWjnpimBUZS3YH0xHb+CCtm83LzBUt9
         hlEdRc0im16mEwcoGkZ+ECXfsT8B9Dw2RkgR7WNg5hpyGbegZfrEeRe3T67+mAJNYfxt
         8dl/SfjmXeL2/JreY2s771Mz7QivcudXQ9kbHmDtMEAk8WNRCh+xFYBIT0fAWMPtPMlp
         sTeBEKRssZ+Nq2OmRmPyufAjDecvWsc746SDvx8HwRw4k326bSjC68f2jJNWAWvaa8nV
         ahww==
X-Gm-Message-State: AO0yUKWW/kX8nX3ITPJEI8v403GubmLFrQEAJMZ88Cnlb1G7XWEXSWFM
        6zN8iCMM9DDLIPwgoiYo/igz4J2Zomw=
X-Google-Smtp-Source: AK7set+gdEoQhj3SJOTWehpvE/gjAq+U6uimdq+vWRo8HEF76CvzRWY0PsNw6/QMUrCk/0uJgQ7FfVNmZ6I=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:420b:b0:237:29b1:188f with SMTP id
 o11-20020a17090a420b00b0023729b1188fmr11930655pjg.8.1678678224493; Sun, 12
 Mar 2023 20:30:24 -0700 (PDT)
Date:   Sun, 12 Mar 2023 20:29:03 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313032905.1474705-1-reijiw@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: PMU: Preserve vPMC registers properly on migration
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series fixes two problems in preserving vPMU counter (vPMC)
registers (PMCCNTR_EL0/PMEVCNTR<n>_EL0) during migration.

One of the problems is that KVM may not return the current values
of the vPMC registers for KVM_GET_ONE_REG.

The other one might cause KVM to reset the vPMC registers on the
first KVM_RUN on the destination. This is because userspace might
save PMCR_EL0 with PMCR_EL0.{C,P} bits set on the source, and
restore it on the destination.

See patch-1 and patch-2 for details on these issues respectively.

The series is based on v6.3-rc2.

v2:
 - Collect Marc's r-b tags (Thank you!)
 - Added "Fixes:" tags
 - Added Cc: to stable
 - Cosmetics change (remove one line break in kvm_pmu_handle_pmcr())

v1: https://lore.kernel.org/all/20230302055033.3081456-1-reijiw@google.com/

Reiji Watanabe (2):
  KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current
    value
  KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

 arch/arm64/kvm/pmu-emul.c |  3 ++-
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)


base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.40.0.rc1.284.g88254d51c5-goog

