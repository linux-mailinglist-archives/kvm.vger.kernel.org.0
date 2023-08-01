Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0D876B872
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjHAPUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbjHAPUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B36A1FC3
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d390abf3319so562775276.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903211; x=1691508011;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9bccqF6ZETP6L8iCBAyZklNgWPnV99usCe2NbK3B7qU=;
        b=ni12vwrh4WCyCOzKlXXO+IyaWmPJIcRzAgoQsvsnGMs2wj7MJfruA43KZbkSsda12h
         GR1ZwNeGk0z7aWVT9P/e8VvlOTyYaGRKSJP8dDLq2m/jMoMLJalDZXftU2oUL7s98ws4
         BdSxyKpKgIsO1MnuRdqXsW2naV/FmLSbL+gtr7GIcmVZI1xHKg9L96WSEpBEEhax/pUh
         Q71yVF65mgCp9lMt5f+0hvoCCc2ilGayVZGBiBPofVEN+jYqcoSQ4mm2W+5dmEOC3qaX
         3yj0jm4eumJBnSio/SvZ2R86AZoJkSTVJNgLMYi7nWXKKDaP+vWMwDG3GoH+XdIrwBWw
         5m2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903211; x=1691508011;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9bccqF6ZETP6L8iCBAyZklNgWPnV99usCe2NbK3B7qU=;
        b=PAi5s0tvXrdwLLOXdzGXlnh+BdILkzGttzF4UbMBZNauyhnoyk8lUtvqsIFyVPvdv7
         C0rBMwIHBTD1z7D47aeYvhsogb46iRpjnjUq5qwbhD3T7cJ3X4v927OpUbMc7PHH0j6c
         ZPbK0VkwXyI1hSgmScgj3UMCw3nEOKHRxz15s8csTwC2R5GO3eUFS5baILWwwgU0S4NL
         unuFmKtJHT8cHW1JbnTQX8FtLEJGe4OWfdgNi2UO2W8xEB8ukRMTPl6WZEfvKd236o84
         0DOQFjso6R7dNvzpmAjt/+aLAo08WT8RLnok9wFPK9lpcB34dbnIsBidJsxuq+54vE5L
         tP9Q==
X-Gm-Message-State: ABy/qLaKuixZmDrmsJ4ef4otYv06qe4f4lZdo7HvGMEAfDND4FAJD6c9
        Y3sG7tN9KmEbCFXvjuECdeNxpXq3Zg4cyV1fEd4tXI+ki6MX31mX9FEXiEg/0bsG5bjDXiAwI57
        cDxuooXbkJdOJg9tsdWp+GZhKi1fSF7UeHbsdtZRb21bd9clqJwFXfjOsiPS9PnnGNDPNXqk=
X-Google-Smtp-Source: APBJJlE0Wc30ZjJoWXKkO+YDWTlvYE845ycMEBcUTKdlvCemAbv8pSUYmrcxJ54JJWoniJy4wnFQXWxFzyQzHR5teg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:70b:b0:c6c:6122:5b69 with
 SMTP id k11-20020a056902070b00b00c6c61225b69mr106675ybt.8.1690903211311; Tue,
 01 Aug 2023 08:20:11 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:19:56 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-1-jingzhangos@google.com>
Subject: [PATCH v7 00/10] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2,3}
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
It is based on v6.5-rc4 which contains infrastructure for writable idregs.

---

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

---

Jing Zhang (8):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Refactor helper Macros for idreg desc
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (2):
  KVM: arm64: Reject attempts to set invalid debug arch version
  KVM: arm64: Bump up the default KVM sanitised debug version to v8p8

 Documentation/virt/kvm/api.rst                |  26 +++
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/uapi/asm/kvm.h             |  25 +++
 arch/arm64/kvm/arm.c                          |   3 +
 arch/arm64/kvm/sys_regs.c                     | 191 ++++++++++++------
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |  25 +++
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 191 ++++++++++++++++++
 10 files changed, 408 insertions(+), 60 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
-- 
2.41.0.585.gd2178a4bd4-goog

