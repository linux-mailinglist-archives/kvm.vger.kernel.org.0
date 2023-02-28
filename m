Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BDD6A52E9
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjB1GXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1GXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:23:11 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD63A5E8
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:10 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 6-20020a631046000000b00502afcf62easo2879829pgq.8
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z1r0WYjM0/VuU6mjjmazkwKNGOGVwqzV6mT22M8W4HM=;
        b=ZFNOO/o/ltYsu0BFmlqYaS8vPvFTGoTzsGcyXISkHPwECMTSRPdw4vUf8ovrkojsT/
         1k/Qjevt63qym/E8HT4vbrSCwnlY8O+vAfWuFeAYgzRjnRU9IhzniSfc5PtL3bRdnUB0
         QBU6bB0XXeM0x0bBPO7R6uZHOuiIzvUyTn3ty2BliT8MkTRhxkCXht63vLmk4FK+L7SX
         Gxu2ggr4pjuNw36sK22qjz45RJrlradUaXbtrxovt4ii0qcHwOV4bpErk9ERA6ItS/aZ
         UIf6PsxS4DlHWUZFjmw7t1zB9qFVOr4D6L2i4H2jWS5io/I1CE+Q/GXtKHcfBYbcnw/7
         /3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z1r0WYjM0/VuU6mjjmazkwKNGOGVwqzV6mT22M8W4HM=;
        b=ucaG0A4lKKgac3NUPHYpw0JYHsPTfyjOx2vml35AWydWAqRgoWRQ50p7Z8sgUzNusF
         3ZXaRBCDqWqp4dYXI3AQWEOfPk5QzyIiccnUvlGe8WNvg6pY56oRgHtes4AKAs3E12bY
         90bDsx13iKafRzed0PGgskB69PITAXKvI7Wbe1Rq5Z/iZsBNGWqDV5ofhYbDbCHn5Ygs
         GXj2CeA7PscASPdKbbv+0w24MyF8LEylZUudo3H9xn5jJx0M7+JP5J29edoyWI+XU422
         DbzCcCHVtyTATAyrBxabeJmhIuZlF3iZr9DaB4ldPnCN1YjWxtyHcHJpkZqXytNJ8eQL
         qOtQ==
X-Gm-Message-State: AO0yUKVxDD/kAmKwCwvTHHc47fjCJr8gxXACn3wLxMx5T60IXnIAZL+1
        vZoKYMTTsq4T6+HHIRov42nZ3DGnL3IaIStFDwNo+Td12u8xwY+qiMOxNxJk7kqoXH1BQbupqNF
        T+/ytBa9dntg9LwaKfNowYONkQp/vypCdf76skw7DCuATaEY0nXZr+6guOiZG6qrO0FRSzMQ=
X-Google-Smtp-Source: AK7set/Y8JQI650TtbbpqiexJqxUzV9QvzDrDlEdyJoNTnpnPtmzuwiT6BP+OQD0RdOWSAnNFehFE11GjFdSTnqsuQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e8d0:b0:19b:da7:d8cb with SMTP
 id v16-20020a170902e8d000b0019b0da7d8cbmr537061plg.8.1677565389938; Mon, 27
 Feb 2023 22:23:09 -0800 (PST)
Date:   Tue, 28 Feb 2023 06:22:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-1-jingzhangos@google.com>
Subject: [PATCH v3 0/6] Support writable CPU ID registers from userspace
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
 arch/arm64/kvm/id_regs.c            | 801 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 469 +---------------
 arch/arm64/kvm/sys_regs.h           |  43 ++
 include/kvm/arm_pmu.h               |   6 +-
 10 files changed, 927 insertions(+), 502 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 96a4627dbbd48144a65af936b321701c70876026
-- 
2.39.2.722.g9855ee24e9-goog

