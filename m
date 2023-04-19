Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915886E7113
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 04:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjDSCTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 22:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDSCTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 22:19:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76079AF
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:19:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54faf2e22afso167113977b3.7
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681870739; x=1684462739;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uIQVFmX2aoFoB7i2FrXfQsGBMoh8PIBdIK2tuO4hjcE=;
        b=CqkfmgshtxXCDoumegN3GvSg7vBd4yCTTTm8UpwCMPCCVp/+QHAP9RorSdNPlx2Wxq
         oa3W/9rcPxRhN9uVS6DS3+wDEsjjrmdvTpM505bOpJhFyREhyCUQRSoja6211lvE0uwp
         MLyZ29Ez/o6xihqBuvIELX4fo4yx0SVROkrEiGa9TBOugFnouJamqyFmrw+TXpFoDbJ4
         nHlfWBq/UX0RaPCsqDYkrvcz1CnYoQosrNzHaq5QLLegTTtEV0xt+sVpe9MYllWKdN82
         tAMVDYBE7a9Y3nH/KMAQcjpuIUcxFgfeAfPPyANOafHx7Unfra7dj46EYLyHR172zvVv
         HJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870739; x=1684462739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uIQVFmX2aoFoB7i2FrXfQsGBMoh8PIBdIK2tuO4hjcE=;
        b=Zs0fsNMLktsg6lzu1GIoBklGIJf1r7Dwr1utMSP801i2Ou26NhXtXipn5OI9+KdfCy
         GLoqTZ1sgqODTYyq5yJQ8/xkwst7AKijmj4lXe1XCHjw8cncjMbbEs8tbRA5e0OixCkX
         0WOUyJQHAxI7XtuK71JP8XHDz4vj8u+GRz/iyT4jmjW5A6xnoDqSWt8hOieg9WoLW9il
         jmsAwxNx16NyMVgb/3x2vQ75l8MzThvk2e9RF612vbsQkhGj4RNMoRshkl8uFwL6+MUl
         C411oyCeTzfs7K4wu5cY57zwXeDwI2t2MaDhePp9beHyEs6jSjjTQiHigw8RLtJCY6eV
         2s0Q==
X-Gm-Message-State: AAQBX9fDUP+MV5ZlOYq65gLPzCgi7HOK2wDvucEW/oPqvPjrjfArOVhi
        QpEzOH7sQASd1iX9NryodDiFGZM8In4=
X-Google-Smtp-Source: AKy350ZLWc6OkYyhEAgKi+QBFBzZGsmT+IJkc0Q/GXXtRpvSXCQVykIPCe0taP5PrBoHwrlqYeadfzkeFv0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:690c:2787:b0:54f:e2ca:3085 with SMTP id
 dz7-20020a05690c278700b0054fe2ca3085mr649642ywb.1.1681870739753; Tue, 18 Apr
 2023 19:18:59 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:18:50 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Message-ID: <20230419021852.2981107-1-reijiw@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Fix bugs related to mp_state updates
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds fixes that were missing in the patch [1].

The patch [1] added the mp_state_lock to serialize writes to
kvm_vcpu_arch::{mp_state, reset_state}, and promoted all
accessors of mp_state to {READ,WRITE}_ONCE() as readers do not
acquire the mp_state_lock.

Since the patch [1] didn't fix all the relevant code, fix the
code that weren't addressed yet.

This series is based on v6.3-rc7 with the series [2] applied.

[1] https://lore.kernel.org/all/20230327164747.2466958-2-oliver.upton@linux.dev/
[2] https://lore.kernel.org/all/20230327164747.2466958-1-oliver.upton@linux.dev/

Reiji Watanabe (2):
  KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
  KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update
    mp_state

 arch/arm64/kvm/arm.c  | 5 ++++-
 arch/arm64/kvm/psci.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.40.0.396.gfff15efe05-goog

