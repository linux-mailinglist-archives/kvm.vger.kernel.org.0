Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749C56DB8A5
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 05:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDHDte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 23:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHDtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 23:49:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A87CC13
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 20:49:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso36270725ybf.23
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 20:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680925769; x=1683517769;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mG6DQun3X6e8Ycs1sxk5r+7eU2NYVjbJa0bqr1sphFc=;
        b=a7N4k+eWIN2ClbGZHuEu4ZylavHenpxLMS7+ncTPOK+Dgz/TJT+rakguvQnf4r8UMr
         +sAwlaXxOS5HDwmahTMQ9qvsjBsDdMIn1ezJaSwYH2YaSKDe72mbZxO6kt9EdA1odxKj
         cxm+2byY8NLxVOwoJMDosZ4Or2SqtYgYAClM6j1UfaP9VGVERyXZjoQo43L5CFGhzO9E
         1hIfWsbdAehKuulLfbpHWccJMAhnl6uZY8ZMP6BQiNr78nw/v1jkKLOD+s5F0a/EjOjn
         w3/YQNPt6PbXh7fcCxohoua1sMi3KpK5DORyHYDnl4ZvW3gQl2z99XMfCyI75+y40WMX
         SNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680925769; x=1683517769;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mG6DQun3X6e8Ycs1sxk5r+7eU2NYVjbJa0bqr1sphFc=;
        b=drXxms60l8fjdDpRMjQmaJRnffvopJ7OpfwA10/8CvVuCzPa7ncg6OU8A2SLB1CnPt
         CIDkqgxhzI7JfbgOeY8VN3hmkr6pDaBtTlBMHogSR3A55+glaa1moLfrAWOk9D8j8JP+
         JIREpvbgKtv495T68qFx7TSKapmV64VVxg3PPBGYDLHjYT6ylsjOZ9Mgu0/viAx5JbL8
         tBRA7GyvqFW22aCEWh5BwPuZA9kz9F6XZ0Fh9lx3J35EJWsk+SUBK/xr9Ful3VYwdiHm
         CPQCLhxZZDrjpx601JCiJ+W+HH84PF+1gRC2lwizDjkE9D2MgjOSXX0SvpM05wFHcqLe
         EK/w==
X-Gm-Message-State: AAQBX9cg8CvSZknm9FHjq/vB7g3gimb4BFeIla/UpDhtmH8nZyZfpi7u
        1rbcUVScu5pQPILZGw6rhkrPjC9iDVk=
X-Google-Smtp-Source: AKy350b2b+kyoeKDHcQVC1s0YQ5cKbQc+CXh/czLHlf4GwnSo/hMjwzF33oizSPx/1fq1ueUiauYfHjnrYw=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:c845:0:b0:b4c:9333:2a2 with SMTP id
 y66-20020a25c845000000b00b4c933302a2mr2288924ybf.9.1680925769001; Fri, 07 Apr
 2023 20:49:29 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:47:57 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230408034759.2369068-1-reijiw@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
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

This series will fix bugs in KVM's handling of PMUSERENR_EL0.

With PMU access support from EL0 [1], the perf subsystem would
set CR and ER bits of PMUSERENR_EL0 as needed to allow EL0 to have
a direct access to PMU counters.  However, KVM appears to assume
that the register value is always zero for the host EL0, and has
the following two problems in handling the register.

[A] The host EL0 might lose the direct access to PMU counters, as
    KVM always clears PMUSERENR_EL0 before returning to userspace.

[B] With VHE, the guest EL0 access to PMU counters might be trapped
    to EL1 instead of to EL2 (even when PMUSERENR_EL0 for the guest
    indicates that the guest EL0 has an access to the counters).
    This is because, with VHE, KVM sets ER, CR, SW and EN bits of
    PMUSERENR_EL0 to 1 on vcpu_load() to ensure to trap PMU access
    from the guset EL0 to EL2, but those bits might be cleared by
    the perf subsystem after vcpu_load() (when PMU counters are
    programmed for the vPMU emulation).

Patch-1 will fix [A], and Patch-2 will fix [B] respectively.
The series is based on v6.3-rc5.

v2:
 - Save the PMUSERENR_EL0 for the host in the sysreg array of
   kvm_host_data. [Marc]
 - Don't let armv8pmu_start() overwrite PMUSERENR if the vCPU
   is loaded, instead have KVM update the saved shadow register
   value for the host. [Marc, Mark]

v1: https://lore.kernel.org/all/20230329002136.2463442-1-reijiw@google.com/

[1] https://github.com/torvalds/linux/commit/83a7a4d643d33a8b74a42229346b7ed7139fcef9

Reiji Watanabe (2):
  KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
  KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm64/include/asm/kvm_host.h       |  5 +++++
 arch/arm64/kernel/perf_event.c          | 21 ++++++++++++++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 +++++++++++--
 arch/arm64/kvm/pmu.c                    | 20 ++++++++++++++++++++
 4 files changed, 54 insertions(+), 5 deletions(-)


base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
-- 
2.40.0.577.gac1e443424-goog

