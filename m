Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849545B2DAD
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 06:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiIIEq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 00:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIIEqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 00:46:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85F9FDB84
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 21:46:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e1-20020a17090a7c4100b001fd7e8c4eb1so292522pjl.1
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 21:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=QJB73MLDhafVA5mzk0y7NRG1yy1AsLNoloEV+fqwUaA=;
        b=IYHa6MwCs2cLrpdrnCoumxBXe9npI1GWJqBc7iHtrCKZGdhnamRw7ygg7mk67IFO0D
         CTL0FLaT9eObj1mrMFt9EryTVC8NUm+WsK2nG+L+xWJy6RrH6NGeAhl2DkdWJWiM/HKM
         BqRTFp2qkCawdUae1SBp+qy9ipxtkEOPUcwU0wjr3ilxXjXGeANeV3GbE2es41/wZlDP
         0YlrUFK80JucWbwCSrMpX4K4tmUJxN4Zquvt9ecAylsdxe//KfHKhmyodN8wYOlgCJ8f
         5HJyE1c/clPUjzMKSiRThQFUAOOt1leM62vSiTuvcF0Vm7eqxUndojfAZxjm14DQtJJV
         xoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=QJB73MLDhafVA5mzk0y7NRG1yy1AsLNoloEV+fqwUaA=;
        b=Mz36pkxbipm/53L+L0n+XTkiET+soVv3Nhn7NTWOOdkb8DFbGUYM7qs1Dmv5sjgD+c
         VyhaD4SUBJvDMHGA+8PmOME/gipvO04gELUCt/4/X0RkrVCAj6CyKbBOILpyS4NHWeB7
         OyI3OyRWFVYavZGEfVT5xUn5GruiBJRfe50UcVBrirPhe/L7q5zhi/Esxqny/oBlgcfP
         aNwUDT5PN2GFZ6N0coknQ97aphOtWm66niFN1zczojGWpxYfqsPtjrxlF0aVXcxn45qV
         UmYTYNi+rXOfonBsWQcdqmlvaLYGFVaOLkWkYbqApB5U0IFqb7/4jh7y45CYDFmCdiFd
         /axg==
X-Gm-Message-State: ACgBeo0Uft8rrwTRmmQZND8ezO8e9+ChSED0NjslD/h19Hy8QNK+yLhT
        pmUyjnTWbhaknzmhpzxb9/CkYL6o3hU=
X-Google-Smtp-Source: AA6agR67XHqJPDelywKoy02FeiedN0d6WTuCg15FUtrlXR/yHe1DDpqixxtKRWyEF/Iu/+vIeepM+t92WtM=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a65:68c8:0:b0:438:744d:b340 with SMTP id
 k8-20020a6568c8000000b00438744db340mr3297212pgt.142.1662698803471; Thu, 08
 Sep 2022 21:46:43 -0700 (PDT)
Date:   Thu,  8 Sep 2022 21:46:33 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-1-reijiw@google.com>
Subject: [PATCH 0/3] KVM: arm64: Fix a bug of single-step execution enabled by userspace
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug that KVM could erroneously perform an extra single step
execution (without returning to userspace) due to setting PSTATE.SS
to 1 on every guest entry, when single-step execution is enabled for
the vCPU by userspace.

Add a test for KVM_GUESTDBG_SINGLESTEP to the debug-exception test
to verify the single-step behavior.

The series is based on 6.0-rc4.

Reiji Watanabe (3):
  KVM: arm64: Don't set PSTATE.SS when Software Step state is
    Active-pending
  KVM: arm64: selftests: Refactor debug-exceptions to make it amenable
    to new test cases
  KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/debug.c                        |  19 ++-
 arch/arm64/kvm/guest.c                        |   1 +
 arch/arm64/kvm/handle_exit.c                  |   2 +
 .../selftests/kvm/aarch64/debug-exceptions.c  | 149 +++++++++++++++++-
 5 files changed, 169 insertions(+), 5 deletions(-)


base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
-- 
2.37.2.789.g6183377224-goog

