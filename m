Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068BB685D85
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 03:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjBACvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 21:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjBACvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 21:51:36 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1000438B5A
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:51:36 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y20-20020a170902cad400b001962668ef33so9328527pld.22
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LaP6UGWbTD10e1OyoaV1e3UmuIhEKvQpKR8HoIxWv8s=;
        b=WIQSwC90/5ph697U1bEFRHaGaZygrT2HvrBFSbsnFgG1H8P/agynaK+5JcKFlPT2iU
         ITRf9YRiYDG3yMa2hY5Ui2OuXdfZcHb6MIPZQakqB/9ypkvLaD4mt1K1/cNSzQIStvj6
         ythK6zLhGVPoWX6iGVVv7M+fpqBJit9/qizzorUm5gQJILQUOyWYgFWKF8EbiU9yh5Ya
         ieGVzSiED1ihUbt4BV6lUIIOOYYheUFl0Sn5Vp65novFb2mX9tTEtm/ldbAjfH6gf9qT
         mOtHd9PZklEMo5Q2jpTtbm/oNetyfUttqNt+HUQWdqCbGSj3l2xNIEcaQMNfjf+yYV+u
         CDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LaP6UGWbTD10e1OyoaV1e3UmuIhEKvQpKR8HoIxWv8s=;
        b=givX+XvcMDj2JbtXVHuNpKFNYUttPX7J2fuu56TpOuW+USzmkohye9+r9Fxp8oxM1g
         uo85ECL429xJzciGRQCf5FbF2uaKPzzqPdnuWzH3RDwfAwH1ZrNuBa8sRpHhwKhCvst3
         UmA7jDY7vh2iwdQHdEopsXNqX+fv+bOBsu7f7DA9wfzgZraeqxxwt895aoEqLuwQ5SX2
         LISdMibC8OmsSXynLQiDhwR8250Zf6NRQgAmJEZfPQ3DvM+TyHIkcUaq5mc0VDH7JuZr
         cYbmxf7jq+nWESi1SOd29JAcwxPXQnFedTUq+W+9QdaQzvC/m/dTZnCAj3ktu35E9W8G
         62mg==
X-Gm-Message-State: AO0yUKVjHrOiahJKS2DcZhEx9ahWch17bkdzJFKuu9CkurUa9AiAidRS
        Hj+i5Q69Qvei9DGVqOFnfvGJImGhK5O/1sdVIowAtkZFc8eq3+PGw57SuLM6TXNttCtAt8F/IaK
        yexfXg+ABymoB/GHEunhemrN5306RaDLYbHq8X42fYS6BR4TKQeL0bvRX8ncF6FAGIXThRNM=
X-Google-Smtp-Source: AK7set//OUlrCGsRZVlbjKb/TulSgb0a5vpDdpGr1twCKcH888EF1pKlJS1/FAFnxxbIGEW365AT5BeG/XiGnGKSUQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c94e:b0:189:6df9:4f85 with
 SMTP id i14-20020a170902c94e00b001896df94f85mr229357pla.27.1675219895426;
 Tue, 31 Jan 2023 18:51:35 -0800 (PST)
Date:   Wed,  1 Feb 2023 02:50:42 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-1-jingzhangos@google.com>
Subject: [PATCH v1 0/6] Support writable CPU ID registers from userspace
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

This patchset refactors/adds code to support writable per guest CPU ID feature
registers. Part of the code/ideas are from [1].
No functional change is intended in this patchset. With the new CPU ID feature
registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does before.

Writable (Configurable) per guest CPU ID feature registers are useful for
creating/migrating guest on ARM CPUs with different kinds of features.

---

[1] https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com

---

Jing Zhang (5):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Introduce ID register specific descriptor
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

Reiji Watanabe (1):
  KVM: arm64: Save ID registers' sanitized value per guest

 arch/arm64/include/asm/cpufeature.h |  25 +
 arch/arm64/include/asm/kvm_host.h   |  20 +-
 arch/arm64/kernel/cpufeature.c      |  26 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 +-
 arch/arm64/kvm/id_regs.c            | 738 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 465 ++----------------
 arch/arm64/kvm/sys_regs.h           |  30 ++
 include/kvm/arm_pmu.h               |   6 +-
 10 files changed, 844 insertions(+), 499 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: a875b2475abff82b2318886da6d29c34db678dd5
-- 
2.39.1.456.gfc5497dd1b-goog

