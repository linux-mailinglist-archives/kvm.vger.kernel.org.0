Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5C72A94B
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 08:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjFJGPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 02:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjFJGPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 02:15:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72B53AAF
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 23:15:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb39316a68eso3160912276.0
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 23:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686377740; x=1688969740;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+DLblTLkyid4xi77mptvky8xPiYLH98cRQBJONV33+M=;
        b=5trV4LUBPAk2oZ2MNDsq0hNSHwU9CDjeR+EXZeul7HOMAixCsZXeusHHWFB76Pw3qi
         hYeZDf/LgRGUK5pCQFEUzwhfsYUiKm0fEQh6LGGGtZi+chULiJc8ZjICCjm1JHc5aCiB
         YMYKQgtHwPSm60jtVtIIFU5sfyE+CFz6aun2E0Rb8ALC0FqD8pDTsCcxeU9qXtBOHhi1
         cDuWxl2keBkONTHkDOrDQ3/yPOloujM8T09AbD2Nq9tAGTqDnd1kHrseHSRlCr7xZVVx
         7thnf51PBcHtBD3bcjkK/uzXxDPEWXT92OPqp4DMVLC4nCEpq8oKouP4gjtq4TFUpIOI
         w09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686377740; x=1688969740;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+DLblTLkyid4xi77mptvky8xPiYLH98cRQBJONV33+M=;
        b=EKVDXN4lUQrO+TTp/P8a2QP7iwo+wnEgM25cy3OuhhkvtHN1HVE03F81uUR2hXj2jf
         ubuX++RTNwcz0RPeoCwP0RcIB9z2N2btG5bQrXbVrSTlB4bPUVvlD7eKvhb2CgvV2oQF
         cZpTNneIZB58khrFMjo56lt0pmBZ0Iu7eDjZLmgNhNwhY4MhxZAmsWYiO4OwDjcck9dc
         JVXIpJcRcZjNMKC2XBiT6KLjQMkXgKL5Jv7vhFKUmCo+9J+sdfQwO0+4tc2IPW1eu1Nv
         E6QPSBlKb5OWXfWer8JpCq+B/yqAap0f/DPpuUoVD7XjbwMB9KTVHdjpO5U8Z7PLY3zH
         CiaQ==
X-Gm-Message-State: AC+VfDynvsNeMYAzdAkCBdE0KTxU8km1IpcoEgrrjtC0k9iO76Wy5IgD
        d4bpK6fcp06mzZ3haEPUW5nFLP4O/9Y=
X-Google-Smtp-Source: ACHHUZ4WAaaRBANzh1YtIO3Ah8WyAfBy7JqoJgzUoXbqmI3wb/BNso2nkXQfZadKKhNUquplRIS9fKP8yrQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1085:b0:ba8:918a:ceec with SMTP id
 v5-20020a056902108500b00ba8918aceecmr971640ybu.4.1686377740149; Fri, 09 Jun
 2023 23:15:40 -0700 (PDT)
Date:   Fri,  9 Jun 2023 23:15:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610061520.3026530-1-reijiw@google.com>
Subject: [PATCH 0/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
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

On systems where the PMUVer is not uniform across all PEs,
KVM currently does not advertise PMUv3 to the guests,
even if userspace successfully runs KVM_ARM_VCPU_INIT with
KVM_ARM_VCPU_PMU_V3.

In such systems, KVM should either disallow userspace from
configuring vPMU, or advertise PMUv3 to the guest.
This series addresses this inconsistent behavior by implementing
the former, as such systems would be extremely uncommon and
unlikely to even use KVM (according to Marc [1]).

The series is based on v6.4-rc5.

[1] https://lore.kernel.org/all/874jnqp73o.wl-maz@kernel.org/

Reiji Watanabe (2):
  KVM: arm64: PMU: Introduce pmu_v3_is_supported() helper
  KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems

 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c |  6 +-----
 arch/arm64/kvm/sys_regs.c |  2 +-
 include/kvm/arm_pmu.h     | 18 ++++++++++++++++++
 4 files changed, 21 insertions(+), 6 deletions(-)


base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
-- 
2.41.0.162.gfafddb0af9-goog

