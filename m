Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3228876745C
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjG1STc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjG1STV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:19:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607233ABD
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d1d9814b89fso2290807276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568359; x=1691173159;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rBQV49SOR42QKJzPhh41wMJSTrzIZuQ00mtidD8N2XM=;
        b=6opsBea8GRXD2We8vqmJWkRvqQH67+YaaVfYQUyvCA+puzndvhs0EI/ABVbhf/zf7w
         qihaG0zKmWaKGIh5XxdWzAl6zRWgDmdN2/ArETbiDmdnfcpWo9RtIGG4he5D3ol0SgXI
         IJa252lfqbfLczfYkvnWWiOebVg63oRkzURD70V74J0eXCiEv4EiB9LOcHdb8iC9h7Kj
         DYvqDUZe2IerZx+0JDp6C+SvGZK342OQtkdeznEO4dp3j5XvKeTU3pcEIzCbada7WrKB
         3tkzVb7SEc4KXKIba1OfiRyCsC+1iSLd4VR/srr4GfGI7pkSlAwotV7MqxU82qvNJZcw
         xL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568359; x=1691173159;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rBQV49SOR42QKJzPhh41wMJSTrzIZuQ00mtidD8N2XM=;
        b=ah7qY6LnOUyKWV0bp6TNJspu2YrfbJbhY+Y08+iw10bpKea3hqsDIRrOfTbPRbpDzM
         /n8ilFsvSxamoz7udC/4rP/KwvdW04tOY5wh/GM1dw04G0X5SPoxjdAcPxF/WJ7Ubcw1
         uRaRfZ3OQXIvKE+/3OYshVPJ6VKTXBqlvOHJYf+5P986SCnTFEhDOcAhZwDftLTceSl4
         K/4dy8inYEiuEKWK5UjUjqa9hhCQKNMvssYUhtuy0qxU7+q17+697qa6Of2d3UZfgXpZ
         pEeEwM/g/BneWm+Pd0wWc5anIjrAV9GR2IrRZaF3uKHNOidbuaM1iruoBtMCBCQEr7X7
         k0Eg==
X-Gm-Message-State: ABy/qLa8qTCcsBUimAMl3BwiuLgys5sEUUEDWe1F9oaPhxKwrxxEG0kh
        ErHhR2xe/XNcDLiqYaijDQBvcRD/8ok=
X-Google-Smtp-Source: APBJJlHgy87ZIulzDCKRfOMr7SIddiJkpyFfJopQjGYNAQz1ySEW7Aq0RA9oddYeo/R8Mk0CnZ5/HTYiLsY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:69c6:0:b0:d0f:cf5:3282 with SMTP id
 e189-20020a2569c6000000b00d0f0cf53282mr14549ybc.1.1690568359638; Fri, 28 Jul
 2023 11:19:19 -0700 (PDT)
Date:   Fri, 28 Jul 2023 11:19:02 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-1-reijiw@google.com>
Subject: [PATCH v2 0/5] KVM: arm64: PMU: Fix PMUver related handling for vPMU support
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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

This is a consolidated v2 of two separate series, [1] and [2].

On systems where the PMUVer is not uniform across all PEs,
KVM currently does not advertise PMUv3 to the guest,
even if userspace successfully runs KVM_ARM_VCPU_INIT with
KVM_ARM_VCPU_PMU_V3.
The patch-1 and patch-2 will address this inconsistent
behavior by disallowing userspace from configuring vPMU,
as such systems would be extremely uncommon and unlikely
to even use KVM (according to Marc [3]).

The patch-3 will fix improper use of the host's PMUver to
determine a valid range of PMU events for the guest (the
guest's PMUver should be used instead).

The patch-4 and patch-5 will try to hide the STALL_SLOT*
events unconditionally per Oliver's suggestion [4].

Presently, KVM hides the STALL_SLOT event depending on the
host PMU version, instead of the guest's PMU version, which
doesn't seem to be accurate, as it appears that older PMU than
PMUv3p4 could implement the event according to the Arm ARM.
Exposing the STALL_SLOT event without PMMIR_EL1 (supported
from PMUv3p4) for the guest won't be very useful though.
The patch-4 stops advertising the event for guest unconditionally,
rather than fixing or keeping the inaccurate checking to advertise
the event for the case, where it is not very useful.
The patch-5 stops advertising the STALL_SLOT_{FRONT,BACK}END
events to the guest, similar to the STALL_SLOT event, as when any
of these three events are implemented, all three of them should
be implemented, according to the Arm ARM.

This series is based on 6.5-rc3.

[1] https://lore.kernel.org/all/20230610061520.3026530-1-reijiw@google.com/
[2] https://lore.kernel.org/all/20230610194510.4146549-1-reijiw@google.com/
[3] https://lore.kernel.org/all/874jnqp73o.wl-maz@kernel.org/
[4] https://lore.kernel.org/all/ZIm1kdFBfXYMdfbV@linux.dev/

Reiji Watanabe (5):
  KVM: arm64: PMU: Use of pmuv3_implemented() instead of open-coded
    version
  KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
  KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
  KVM: arm64: PMU: Don't advertise the STALL_SLOT event
  KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}

 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c | 44 ++++++++++++++++++++++++++-------------
 include/kvm/arm_pmu.h     |  3 +++
 3 files changed, 34 insertions(+), 14 deletions(-)


base-commit: 6eaae198076080886b9e7d57f4ae06fa782f90ef
-- 
2.41.0.585.gd2178a4bd4-goog

