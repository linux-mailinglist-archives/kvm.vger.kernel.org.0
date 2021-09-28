Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E4E41B694
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbhI1Stu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhI1Str (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:47 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2039CC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so101314994qtm.19
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qgqb6YKppRB8NfJVVv7xfeFr8BtHiKUWj2cOAf7GOM8=;
        b=TLC2VRgTW9eZlhKSjXJgG6luzYm1j8ILJoYprMicHRJoF5l8NyLTLIX2KZegIO/n/Y
         dv8/Z+h+iE5VBQP2KtRDTqg88Y6iS7IgJz7+69qP1G6FycrEVvhHCO34pqMP0JRZl64l
         8+gnFDiA+Vyfud7PCbBBzuAL1TUDBqHcnpO5WDzEPDGa5JzrVrNFijCCgSXjbvbA7bFB
         ixGCjz5lzQKTqRVXoELXTADjslwCiLxJzaCiEx1+sNRDekV9NuU0Qv3wvVlZr9CpLoJD
         5+rzFq4vU+Bo+PgypWAUMgHTb1+6dZN/g4RoQnF05tSkT3Y3zDxenkP2jgYAF12de9Rl
         EvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qgqb6YKppRB8NfJVVv7xfeFr8BtHiKUWj2cOAf7GOM8=;
        b=K117fyny3awpBWKNT3R53nN9NC+BiCHJ3be+q058u/VIZQBqKlqG4geqLGHyVCtFNd
         tXelb6UFRGHdXRzjuYpcBHH2VZFsuLvetbHf8S21EDLs4HeujJ+3uwXM633q3R2/6hjJ
         Mq/qLPK1+zto/AsfN7ZKrI4npgv1ilmkv+xql9UEvKKgPh5x5jErh0PynZZsV3BXsWD6
         zFwWR52JB0JBP030HlhN+7LeMbO7SlofqNyldC79k5/h8lNGVFl11xRgJIyalRc0KFGa
         VEcvNmk6lN6A9i/uqp/GB6NTDOsmxVDf6+9kuBIzxTZdcmPNu8PqtnvtbG66XSyMZwpr
         rlOg==
X-Gm-Message-State: AOAM5326E+2pmey39D/NDPnw0PN/wwqObgHOHqv5hxcHatm7UtABsAcG
        o3ez2GeVBngWz5rHj/af4srbQ8zkSvOs6hwysEv9TBDng2WnaAZHBOfR3+ehutekEnv5ONNdZ7D
        vVYoa3Ga8aQ7JXvqV619hkG2Se+GPwKJaDzJVMTJYIpNkuH6U870ssWfYGvsWN7U=
X-Google-Smtp-Source: ABdhPJxmw0t3Ktxkm3ZcxHbs/rMQve8y9VxdIkWB/eXtfkGFPpQjbY6Vqo64auyj0jWhjiH+kb808xRC3FZlAA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:12ac:: with SMTP id
 w12mr7283357qvu.44.1632854887215; Tue, 28 Sep 2021 11:48:07 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:47:54 -0700
Message-Id: <20210928184803.2496885-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 00/10] KVM: arm64: vgic: Missing checks for REDIST/CPU and
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

Patches 1-4 fixes the issue for GICv2 and GICv3 (and the ITS). Patches 5-10 add
some selftests for all these fixes. While adding these tests, these add support
for some extra GICv2 and ITS device tests.

Changes:
v3: add missing checks for GICv2 and the ITS, plus tests for the fixes.
v2: adding a test for KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, and returning E2BIG
    instead of EINVAL (thanks Alexandru and Eric).

Ricardo Koller (10):
  kvm: arm64: vgic: Introduce vgic_check_iorange
  KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
  KVM: arm64: vgic-v2: Check cpu interface region is not above the VM
    IPA size
  KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
  KVM: arm64: selftests: Make vgic_init gic version agnostic
  KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
  KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
  KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above
    IPA range
  KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially
    above IPA range
  KVM: arm64: selftests: Add basic ITS device tests

 arch/arm64/kvm/vgic/vgic-its.c                |   4 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  29 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   4 +
 arch/arm64/kvm/vgic/vgic.h                    |   4 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 372 +++++++++++++-----
 6 files changed, 317 insertions(+), 102 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

