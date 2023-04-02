Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934DB6D39D5
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 20:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjDBShy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 14:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBShw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 14:37:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EA5B45E
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 11:37:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e23-20020a25e717000000b00b66ab374ba1so26934904ybh.22
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 11:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680460670;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cERiSljImwXqUKykLWPZ6VGQrBCja3Ipm+emrnE/BlI=;
        b=FiWF2Fj7xPSBOTeWQcq7DXuuWyfzKfG0bZep6wO70DsbiBn6MKq1oGfFNUJwgE8B6R
         b1iNIR0qEwnzRaJ1B+v6mgeZQsPkH19qRy42vpfW+bNg89eLduoUC6Q2r8QaSuOrCJdP
         uvLUg7HvyKrtp5YOM/thBrSrDCtmqYYIV+cDrasWCn5XjCIIdCw3qv59B+MPwr8UsqSV
         Afqj4jw1+M+5Dw5jzmL4vHodQEgkjaQ9W8DpxVaWND/xcY+pNbx7Rg3wtbJYYd/h6cYa
         YjnLJRJ7Or1pmFRd03tPhEuWUEh5PblOEbKKzQfBpeiAUIwfG4iQ7zz42ZlfHX+CdR5n
         N6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680460670;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cERiSljImwXqUKykLWPZ6VGQrBCja3Ipm+emrnE/BlI=;
        b=jrRRSevBf7W2R6b85+eYSljaqbTBuPMus+GWhFTBJrijMGpsOgWxTodgzgSKUYqQxQ
         dDPYboXb157Ck8I3Db4x6PMj05UcGZq5Q30B3ZrGQfLFbkpId1DH2rXVKhxM2Vg1BLZr
         WGMGzkTUbOTW7FrEZtKEqGGN+SEk0xLjSCW6NGBHMTuXn2u1JzwhhrW4nujb1ADjl31K
         mkAo5XxienX7IgYDZjrnt66L5JzSnbHs0rURo81/pgKb5wSVSMt1AoLUO9Yj/ue76JEs
         zTJVoW5TYid925KGh5yZnxRmj8uA9BU7ejApm6QttVfG/bttmYx7iM8hk3yuTFNVPxUI
         kFHg==
X-Gm-Message-State: AAQBX9eOwqWtlQS1rfB8ua6k7FoBiuQD5F5mbv7eqgAh4Uu5sMAP3Mw0
        W3KWfeih36ZYdR4zIDymiraTak9Bahzh43wTv5vEQPtZ/508Y+B9hMP29MSVJsSjtT2H6P/GEX/
        H18pHS3qU+lMpmNsGP3o6bb1VSbpYbgmlyfZ1EaH/QFEL2WQ2DZwZLjXCx+OX5jLD4p8XzvE=
X-Google-Smtp-Source: AKy350Ylo4IJob0aFKk5xXLNtVoU61BjTIMtGwhBKAkNcnoQXzyYGCNJ3ynvPsaWLP71QbxTmp0MHCYFd1jB981mxQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:18d5:b0:b75:3fd4:1b31 with
 SMTP id ck21-20020a05690218d500b00b753fd41b31mr22357355ybb.1.1680460670266;
 Sun, 02 Apr 2023 11:37:50 -0700 (PDT)
Date:   Sun,  2 Apr 2023 18:37:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230402183735.3011540-1-jingzhangos@google.com>
Subject: [PATCH v5 0/6] Support writable CPU ID registers from userspace
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
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

* v4 -> v5
  - Rebased to 2fad20ae05cb (kvmarm/next)
    Merge branch kvm-arm64/selftest/misc-6,4 into kvmarm-master/next
  - Use kvm->arch.config_lock to guard update to multiple VM scope idregs
    to avoid lock inversion
  - Add back IDREG() macro for idregs access
  - Refactor struct id_reg_desc by using existing infrastructure.
  - Addressed many other comments from Marc.

* v3 -> v4
  - Remove IDREG() macro for ID reg access, use simple array access instead
  - Rename kvm_arm_read_id_reg_with_encoding() to kvm_arm_read_id_reg()
  - Save perfmon value in ID_DFR0_EL1 instead of pmuver
  - Update perfmon in ID_DFR0_EL1 and pmuver in ID_AA64DFR0_EL1 atomically
  - Remove kvm_vcpu_has_pmu() in macro kvm_pmu_is_3p5()
  - Improve ID register sanity checking in kvm_arm_check_idreg_table()

* v2 -> v3
  - Rebased to 96a4627dbbd4 (kvmarm/next)
    Merge tag ' https://github.com/oupton/linux tags/kvmarm-6.3' from into kvmarm-master/next
  - Add id registere emulation entry point function emulate_id_reg
  - Fix consistency for ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon
  - Improve the checking for id register table by ensuring that every entry has
    the correct id register encoding.
  - Addressed other comments from Reiji and Marc.

* v1 -> v2
  - Rebase to 7121a2e1d107 (kvmarm/next) Merge branch kvm-arm64/nv-prefix into kvmarm/next
  - Address writing issue for PMUVer

[1] https://lore.kernel.org/all/20230201025048.205820-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230212215830.2975485-1-jingzhangos@google.com
[3] https://lore.kernel.org/all/20230228062246.1222387-1-jingzhangos@google.com
[4] https://lore.kernel.org/all/20230317050637.766317-1-jingzhangos@google.com

---

Jing Zhang (6):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Introduce ID register specific descriptor
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

 arch/arm64/include/asm/cpufeature.h |   5 +
 arch/arm64/include/asm/kvm_host.h   |  34 +-
 arch/arm64/kernel/cpufeature.c      |   8 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 -
 arch/arm64/kvm/id_regs.c            | 790 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 466 ++--------------
 arch/arm64/kvm/sys_regs.h           |  29 +
 include/kvm/arm_pmu.h               |   5 +-
 10 files changed, 897 insertions(+), 473 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 2fad20ae05cbcbd1a34272ddd8e27975b4ddcabf
-- 
2.40.0.348.gf938b09366-goog

