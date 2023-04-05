Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66546D84C3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjDERVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDERVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:21:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C01B59C4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 10:21:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54c072e3d57so3719687b3.18
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 10:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715309;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D3r10cm7fAHZK5D31KGbqV3r9nbkx+Y20r9KdjeSnd0=;
        b=jo7pPq5qM5gLK0AVnmUwM02HwmbJ7YlsjF4FrMFjqynY3C1W0CeRsJRPj+VXoMZk7K
         H1tiodbzp6ix7sqbBsp61kgk38NmwbO07JNngeJcAYpvtun0UJ6IFp9MQASMzK9p+i3Y
         MNGLPpqgxUQroCivjZrOsMij2MbnJeBZ1XaIIrpxQ/0/iOVghrAD0R4f9Cmna7Y4TytA
         HOc5sC5gZ47CMrIIzxdYFLt8mThsVazQFkf5fDoIUx4KkedqlNY4MDKfo7hYk1iS9ckx
         I2CJ0EyLXoj94dEzk63MN84NX+SegVGLZXQlyH/aoHm05+plfepLCccEf5ct/9H6eQZe
         lVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715309;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D3r10cm7fAHZK5D31KGbqV3r9nbkx+Y20r9KdjeSnd0=;
        b=DzUIxBTtW0wIM9zXQQ5DGGbOAKEfvQbgOrAX1QhGlFs8OvmY2vEzu5wvUY6eGcvVRB
         0aeb+j8b+KD1ZvHv6ds552dZ22Xw+1nXxRgRSAtNoxBtJOYBswqaXx0kk4StlVPi0QdI
         3K0SfXOlLGXa2aHzjEdMlH1uoQtTBzJDZo0DUeoX06K/DtLu6WiGiwUsKCIoWQv8j2Ru
         bZKEzkfDVeKJfqmuZ/RHBieWv0dSX390kW1B+wGJIBWjvSbAQqrfLu+6XqS/z41KUuyI
         0bcC6XrrZUNppweiXeo9rxDYQdZvxp9J8Gz6KnaJMB8VCWwWv1pPCyLWp1Qyb/O7LLJj
         HLSA==
X-Gm-Message-State: AAQBX9f3IUkfZMq8mJF+YyIfM1cEAn0ZO7JyxjaKdzyBehH6SyY50144
        Y8IASnXPuVGRo+pHq5HwJCxnIJRHXJa+vUNxlUPDkGZDxImME9qn8ZQlphwfgE6CAdA7r8NM1oW
        1P8QHj26RxeWqC7QKrERT+GhwQO2RQCR17XaPWeetX5xxsLac1OGxRUMCcSY5aneuuPr/noY=
X-Google-Smtp-Source: AKy350ZsmL1wjm9wtYxtsRzrT48NB3/lrdHktGDRLEsJ5qmBrnGhsSqr30Yge03JnFunnf6+baS9bp4bGcu3LsycFA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:d412:0:b0:b8b:e931:7762 with SMTP
 id m18-20020a25d412000000b00b8be9317762mr767239ybf.13.1680715308829; Wed, 05
 Apr 2023 10:21:48 -0700 (PDT)
Date:   Wed,  5 Apr 2023 17:21:42 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-1-jingzhangos@google.com>
Subject: [PATCH v3 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
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

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1.

It is based on below series which add infrastructure for writable idregs:
https://lore.kernel.org/all/20230404035344.4043856-1-jingzhangos@google.com

---

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1

 arch/arm64/kvm/id_regs.c | 68 ++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 10 deletions(-)


base-commit: 8ee379b1b7b23b0cffdfc988cbe94108188f68b5
-- 
2.40.0.348.gf938b09366-goog

