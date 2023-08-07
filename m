Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A486C772A76
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjHGQWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjHGQWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:19 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2859A10CE
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bc49d9e97aso41687755ad.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425334; x=1692030134;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CYFU6bv8pwt4NvkXXCWK7C5GIbxtGOwXTh1972qGl6s=;
        b=xY/I46rWtwWBTdOGDb6K0HFam0Khyb1W4Yxt8yTMDImzn3KOUVs5daYYyTKd1fgJgS
         VXdRS3/UYVT6ipQGXfpf/2FHypwUC8hmy9eVsc3XSmO9Nioifmo9h5LQ5yg+KOhnw3yN
         mq1S8p879UpfgtXLRLpFp2Q8fsiN0PBxphQ4n4grzevcuBrldykJSSU0bb5UUDWRLEwk
         vTH6CZAVEVEgeHMSujWjB/ce8qyPQ60UwQIe2frLCYdZnmk1H0oC6x+6SskTlFk+/6oh
         oomcqg87rsXsg+RXjefUTuC/x6ION5xeEaqvrxZFx31Sx6xIauIcli8gOMP9Sn+qAMJN
         BPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425334; x=1692030134;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CYFU6bv8pwt4NvkXXCWK7C5GIbxtGOwXTh1972qGl6s=;
        b=Hsh5mbsasNw74eIsaK3O/K0lbQekVWUohsRGzDX+Hx89Vd7whNru/K/bvXx0EVHyRP
         8yxoQ2D+ED8xrGDUsGnkiDQhqJgE9yHonTdjotGD2HZlrv3onbxoG0YCCyrVf1/xPXca
         2qTIAyqWk0ftXkEcvmUOe9tJDLwfYQhkw7RY0YTC8tjFomY22T6ElcDtUMiHzvsWXguF
         sDlqUl85CJs+maO3TtR6T3cUdHuZqSYSUSavxzaIe3kmLkvNbLeWMAniKL7UBV4NyYsd
         nr635Ed8JJNC3TeurZoRrbROyLZUocmtI3yvOvVF73rdveM8mOn2EjW4GMGD6T1nb86F
         5u2Q==
X-Gm-Message-State: AOJu0YzFcWYnoF2NGdAFYFZh3+KbxiGQnMWOfOEBOnzZBMUc10NUiFhr
        FGArrWCUXve40Lh3UKBksi0NfzEJgnfrKbuYITEvWmzlyJmLvyyesDgLsX90x6L9/lqYAqRrJkY
        0nV98vphMlsrS4mJkhbSwKdtR9HjgU+3+TOLSwooQMtryQDHm3FlvUuqXyj30ORrBqmANcUk=
X-Google-Smtp-Source: AGHT+IEChF1DtnHpie76mYHzLSLfp5pnGrRuLzshpX224Lbsn5+SW8ivD0hye+cneqOPBmu5PVzvcF9PEw6k1apBtg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:2349:b0:1bc:4c3d:eb08 with
 SMTP id c9-20020a170903234900b001bc4c3deb08mr40231plh.8.1691425334254; Mon,
 07 Aug 2023 09:22:14 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:21:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-1-jingzhangos@google.com>
Subject: [PATCH v8 00/11] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2,3}
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
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

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.
A vm ioctl is added to get feature ID register writable masks from userspace.
A selftest is added to verify that KVM handles the writings from user space
correctly.
A relevant patch from Oliver is picked from [3].

---

* v7 -> v8
  - Rebase on v6.5-rc5.
  - Add reserved parameters to UAPI to get writable masks for future expansion.
  - Import system regiesters definition automatic generation from kernel to
    selftests.
  - Refactor the selftest for verifying ID register writable from userspace to
    cover all writable ID register fields.

* v6 -> v7
  - Rebase on v6.5-rc4.
  - Add a vm ioctl to get feature ID register writable masks from userspace.
  - Split the change for debug version in ID_{AA64}DFR0_EL1.
  - Addressed some bugs in selftest.

* v5 -> v6
  - Override the type of field AA64DFR0_EL1_DebugVer to be FTR_LOWER_SAFE by the
    discussion of Oliver and Suraj.

* v4 -> v5
  - Rebase on v6.5-rc1 which contains infrastructure for writable idregs.
  - Use guest ID registers values for the sake of emulation.
  - Added a selftest to verify idreg userspace writing.

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com
[3] https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@linux.dev

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com
[v4] https://lore.kernel.org/all/20230607194554.87359-1-jingzhangos@google.com
[v5] https://lore.kernel.org/all/20230710192430.1992246-1-jingzhangos@google.com
[v6] https://lore.kernel.org/all/20230718164522.3498236-1-jingzhangos@google.com
[v7] https://lore.kernel.org/all/20230801152007.337272-1-jingzhangos@google.com

---

Jing Zhang (9):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Refactor helper Macros for idreg desc
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Import automatic system register definition
    generation from kernel
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (2):
  KVM: arm64: Reject attempts to set invalid debug arch version
  KVM: arm64: Bump up the default KVM sanitised debug version to v8p8

 Documentation/virt/kvm/api.rst                |   29 +
 arch/arm64/include/asm/kvm_host.h             |    2 +
 arch/arm64/include/uapi/asm/kvm.h             |   26 +
 arch/arm64/kvm/arm.c                          |    7 +
 arch/arm64/kvm/sys_regs.c                     |  197 +-
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/.gitignore           |    1 +
 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg.h         |  839 ++----
 tools/arch/arm64/tools/gen-sysreg.awk         |  336 +++
 tools/arch/arm64/tools/sysreg                 | 2497 +++++++++++++++++
 tools/testing/selftests/kvm/Makefile          |   16 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       |  453 +++
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 17 files changed, 3734 insertions(+), 724 deletions(-)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100755 tools/arch/arm64/tools/gen-sysreg.awk
 create mode 100644 tools/arch/arm64/tools/sysreg
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
-- 
2.41.0.585.gd2178a4bd4-goog

