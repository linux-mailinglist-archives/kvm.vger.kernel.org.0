Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E313A693A58
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 22:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBLV6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 16:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBLV6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 16:58:51 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4400BD539
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 13:58:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id s24-20020a17090aa11800b00230ffd3f340so4023024pjp.9
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 13:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YlglMKTBSy12XB1b+5wjrUnRuLDhCORhwljl/9ofDP4=;
        b=fg4iEQUEI6uRQPWJascXrHqAOjfylcnqkirBcXA4bf7F4YXaurC3gikjLEMg5yhv9W
         UngABhzKDARAknK1KFEvsbkxH2bvYuJwPPa1OjjwB1NcKNIh92feHjgZ6SK1lsbqvnTT
         EA0LBvoW0Q+nie38Ml4jed37/w6kcMm9KJlx4utIKlD01MAOWvovxETxCfNZg9Z40Swz
         +MPWohMUsNKniQ63qREqxTYjcodN0TMXgjo3jzNd3y7bQPWutOJu5ZzIn2gDlpQM/SFe
         +42RRm2WzJUXiUR380iEXkmh9cvPLzjzMVsortlMcr5dLptVzIByQ2+etEXuG5MpeZfO
         HajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YlglMKTBSy12XB1b+5wjrUnRuLDhCORhwljl/9ofDP4=;
        b=P2LZ+y+d7guVcColo66noJ9/g87CfCGWWxucI4EcWOsAh+4mstuXNupedtJ3SBoya1
         GCnclB2SohKH+8Jl4vmoJN0/wZvid2y4es+bduj+8Z6pCRL2lX/7tpCIKOjNLYcoHt+H
         PCyTk6X3DmwRtI49KfoKm6HiL5/nCpo18g3N8oL/6XdkNk2hnYACQTmAvSzb544lVWE2
         tMTNR51tVD5vnZWv2rQsnc41HHgMWobj5/0Du9CmoUcTF/5G5UM6EBbbxP0OYlG2oXz9
         5xYWo9ekoZ4IldtYQwCylolsFKb4tK9YKL3l9P0lx2hoc7+BFBA7Mf64H2dfmMMLPsr4
         03Xw==
X-Gm-Message-State: AO0yUKW9b2oeVzV4vo8iELGgHHssJ/I2Dk6XPcXQUweH186V3SFDJwW+
        +z+OP0nL8u8yvGzgLqZO6iWu7XlG6L69pO/ctLWrYNYBcw7p1Nv+1JfFgm5TqTHeMNC9mTC2pWV
        0SzMG0rEx2LorYdhuYoFcNFYw8WG51ExorQkjsBjAGJRUWhWxX7gF/o7nE96PSl6Gz40v3/g=
X-Google-Smtp-Source: AK7set9cS1waxyICeG1y/DFOllHWcaq/wqpbaF1RIoIWYgZrGicMuxIaDDjV3RKI47OBuvh1WW2Ap8YTRYdnzP2DkQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:8ece:0:b0:5a8:5e12:a12e with SMTP
 id b14-20020aa78ece000000b005a85e12a12emr2291938pfr.11.1676239126157; Sun, 12
 Feb 2023 13:58:46 -0800 (PST)
Date:   Sun, 12 Feb 2023 21:58:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230212215830.2975485-1-jingzhangos@google.com>
Subject: [PATCH v2 0/6] Support writable CPU ID registers from userspace
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
registers. Part of the code/ideas are from
https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com .
No functional change is intended in this patchset. With the new CPU ID feature
registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does before.

Writable (Configurable) per guest CPU ID feature registers are useful for
creating/migrating guest on ARM CPUs with different kinds of features.

---

* v1 -> v2
  - Rebase to 7121a2e1d107 (kvmarm/next) Merge branch kvm-arm64/nv-prefix into kvmarm/next
  - Address writing issue for PMUVer

[1] https://lore.kernel.org/all/20230201025048.205820-1-jingzhangos@google.com

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
 arch/arm64/include/asm/kvm_host.h   |  26 +-
 arch/arm64/kernel/cpufeature.c      |  26 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 +-
 arch/arm64/kvm/id_regs.c            | 773 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 468 +----------------
 arch/arm64/kvm/sys_regs.h           |  30 ++
 include/kvm/arm_pmu.h               |   6 +-
 10 files changed, 885 insertions(+), 502 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 7121a2e1d1070913f692d32806a36b8b3b3f0008
-- 
2.39.1.581.gbfd45094c4-goog

