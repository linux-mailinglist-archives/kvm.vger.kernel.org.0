Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276486A7ADA
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCBFup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCBFuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:50:44 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADE11423B
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 21:50:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c192-20020a25c0c9000000b0092aabd4fa90so3007486ybf.18
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 21:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K3JIxiC0M77Pk7ywc3uQ/jzPAxcPYJAhKiYM9zf/wCk=;
        b=jtb5+/An/yu3T9m7m/98dfEoSfuJeWhdUaRVOkoGjRKDvvstUFT30gKnyCyPqji8bu
         r1SKTDK+uCcJwQdfJWLgq+f1XJfKKzkkCEw5xIUD2aYGbcdXPNRPscejOngrX+2zjXw2
         EOyUIU2i36AqfQpsykEPTMZUOTBER32Skq7/LQ027yvSPNTax/FK6RBq4yZI/F5NAgJH
         Or3F/CKKOQQxblmFknMTwfV/8DUie08mPTvPu/whwZxDHKj9urdpJcesJhwgiqxarYD7
         G1CmC6TabyRzkso/6vItQ6+qDNwWmLUYoEV8MwmOXzIjKSMTqbBH7FgtiwresKIPm9Xy
         Oq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K3JIxiC0M77Pk7ywc3uQ/jzPAxcPYJAhKiYM9zf/wCk=;
        b=rU1TCxQHAKwdG7GC/93vdC/+fYanf4cjXZrBIvjiLAozUR2lE8aGRmsFD4hnypvUzm
         mo8yzrlgU24qjIIc/cFlg8I3eLp5IQLjS/Q0k/VVm3zsOYVjt7sTIttQqlIz70b874Kw
         3TO/hiqSXHsMsQbWBUYZhJjqC4u5QrqwtSFeg+PGLtxVF7WuoEJ5sjN9JkGCiYzl3W7R
         A55sY3VR7JZE++1ckwszQ8t8Z85fAA3r7/y1miGvlROxUFaSOIO0bUYCkVA++fKPGLSU
         BnKX8QKb0votxeAabI+qkWrWapwqE6aospr6+GTbDsDQjRB407CaaTsQtfmYBtynR16Y
         XKhg==
X-Gm-Message-State: AO0yUKWwrDgCpAzXGHXmSXtFIfAGDIl4UISeLV8ceWMkYnM7OcIKycBn
        xfpJFrFot8FiGUPBvmju1IBC0Fr+VE8=
X-Google-Smtp-Source: AK7set9c8XVwEZFWDGh+9kXnrdAHO4gC875qJEsTWGDCD3+FYSzJT6DG3+/6LXrhQag+NTWGMPw4lFdcm8Y=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:211:0:b0:91d:98cd:bfe4 with SMTP id
 z17-20020a5b0211000000b0091d98cdbfe4mr4832176ybl.10.1677736242502; Wed, 01
 Mar 2023 21:50:42 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:50:31 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302055033.3081456-1-reijiw@google.com>
Subject: [PATCH 0/2] KVM: arm64: PMU: Preserve vPMC registers properly on migration
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

The series is based on v6.2.

Reiji Watanabe (2):
  KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current
    value
  KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

 arch/arm64/kvm/pmu-emul.c |  4 +++-
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)


base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
-- 
2.39.2.722.g9855ee24e9-goog

