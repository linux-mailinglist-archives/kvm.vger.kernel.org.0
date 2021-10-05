Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B51E421BB5
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhJEBVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJEBVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:14 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1964C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:24 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z10-20020ac83e0a000000b002a732692afaso6463875qtf.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+Xq4ieF79Hu5t0nEenR0yeDcfTGhycSUF4gpxiOxUYo=;
        b=nnDSuIoHAfanSEj2WNy7oPNPLqfy+1x7rjHR+af7cQksG884Qn7u7QWI53zxXmRL4w
         pWDS+E539GppvAkqZ0pdcq5mx6hyrjp+aTkPu8ZltgwC1chkZR/Xthe4oKbQu3B2WyhF
         aM3OE8K0jJ6QLugCKjQ7HzneM+VR/btro557en1Q/eqjXHMl4guwWmuOYFmxvyevQqdD
         AplBjVSPbTT9u95eoUhke1P0D4mxxOaQ1jTAU5YAXYLsvRlIJHrXRaZ/5Q/WHzutOaQa
         /ApyixCzjH9Z/AIL26kuLVvz+LuEZk2XgPwCTQbJAN6LgYrym6KsGKXVSZ8tktcKEepe
         yEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+Xq4ieF79Hu5t0nEenR0yeDcfTGhycSUF4gpxiOxUYo=;
        b=fC/XqauaOE1B0uOHqMI+k4gItq849jiaKARqy8FNFC83Jz2X/w3ydfR+2qYNE1qsus
         4LepauIcaKtpISe7AXqyotNJB1g+o0x2aZDUTY/MvgYHGsiBuLrEPcetxPkCAxsPZzOv
         gbzBV0XK8v/cpvGkbEEFBQNNW2v8p6fI+/Gn+EJzgcyNFELG6hRnUpze5EuAg4+091gH
         QquzWD8hx0OpXXzHQAVGJ17w9o3Zx0oYH4Cwx3OlxYnD7WUlTL0XYw/wfVNGbj8CTvNK
         haKv32Q6Ua9aha3d2yxCVb1obHWpOMjCMPSSloS0NabNUljOu/0VvQomw46/SqBN1yRU
         OM8g==
X-Gm-Message-State: AOAM530/QD17XT4Bw1jmPh/HpLkkhwDkjgidVa6yNsrcAa2avYOcVbpV
        yUyB7ox0uJDyNwIObAFJBw+fFXrKp4XqCdP3pS6c24uzWeKAoyrA3RAasQFglMe+xBuE+KO4qwH
        I34gIs0YYMeHiL2zjfilKJ00EElEmrpCahXw3NZsUSY279+dK7Mjmxcyxnvklzb4=
X-Google-Smtp-Source: ABdhPJzFw/sz3sZ2EUwtotAzAzKfu65MaG03b8HZKr9el2QVmz+8eBTzv5wSBtqXxzSDzMzDZRsguBh0KNE9ng==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:9d4d:: with SMTP id
 n13mr25322131qvf.40.1633396763877; Mon, 04 Oct 2021 18:19:23 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:10 -0700
Message-Id: <20211005011921.437353-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 00/11] KVM: arm64: vgic: Missing checks for REDIST/CPU and
 ITS regions above the VM IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM doesn't check for redist, CPU interface, and ITS regions that extend
partially above the guest addressable IPA range (phys_size).  This can happen
when using the V[2|3]_ADDR_TYPE_CPU, ADDR_TYPE_REDIST[_REGION], or
ITS_ADDR_TYPE attributes to set a new region that extends partially above
phys_size (with the base below phys_size).  The issue is that vcpus can
potentially run into a situation where some redistributors are addressable and
others are not, or just the first half of the ITS is addressable.

Patches 1-5 fixes the issue for GICv2 and GICv3 (and the ITS). Patches 6-11 add
some selftests for all these fixes. While adding these tests, these add support
for some extra GICv2 and ITS device tests.

Changes:
v4: better vgic_check_iorange, drop vgic_check_ioaddr, minor changes on the
    selftests patches (better comments, title).
v3: add missing checks for GICv2 and the ITS, plus tests for the fixes.
v2: adding a test for KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, and returning E2BIG
    instead of EINVAL (thanks Alexandru and Eric).

Ricardo Koller (11):
  kvm: arm64: vgic: Introduce vgic_check_iorange
  KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
  KVM: arm64: vgic-v2: Check cpu interface region is not above the VM
    IPA size
  KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
  KVM: arm64: vgic: Drop vgic_check_ioaddr()
  KVM: arm64: selftests: Make vgic_init gic version agnostic
  KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
  KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
  KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above
    IPA range
  KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially
    above IPA range
  KVM: arm64: selftests: Add init ITS device test

 arch/arm64/kvm/vgic/vgic-its.c                |   4 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  25 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
 arch/arm64/kvm/vgic/vgic.h                    |   5 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c | 366 +++++++++++++-----
 6 files changed, 298 insertions(+), 114 deletions(-)

-- 
2.33.0.800.g4c38ced690-goog

