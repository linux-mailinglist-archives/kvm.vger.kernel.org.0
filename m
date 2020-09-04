Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C584425D6C0
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIDKqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgIDKqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 06:46:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8925320770;
        Fri,  4 Sep 2020 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599216361;
        bh=emfYI5A6yt/uyLK8UfzYiitooNVKksAc8FkL2+qvA7c=;
        h=From:To:Cc:Subject:Date:From;
        b=SUl1fEUncq5ywbwQWlGS/ZWBgkfbdJEAjcRUbgtxQSI7GWWZfG/Kk5YwcUYYM7rU1
         ll/ao5a925iM+qCX2vT6IIXVqcTs+GxWI/Rd8XiJLVob1aGeV96ggS923pKuClssM0
         bkQSHTFQ2ySdZw7AO8uK7DHTxLKZTZKxP/m15g5g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kE9EG-0098oH-0a; Fri, 04 Sep 2020 11:46:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.9
Date:   Fri,  4 Sep 2020 11:45:21 +0100
Message-Id: <20200904104530.1082676-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, steven.price@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's a bunch of fixes for 5.9. The gist of it is the stolen time
rework from Andrew, but we also have a couple of MM fixes that have
surfaced as people have started to use hugetlbfs in anger.

Please pull,

	M.

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.9-1

for you to fetch changes up to 7b75cd5128421c673153efb1236705696a1a9812:

  KVM: arm64: Update page shift if stage 2 block mapping not supported (2020-09-04 10:53:48 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for Linux 5.9, take #1

- Multiple stolen time fixes, with a new capability to match x86
- Fix for hugetlbfs mappings when PUD and PMD are the same level
- Fix for hugetlbfs mappings when PTE mappings are enforced
  (dirty logging, for example)
- Fix tracing output of 64bit values

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Update page shift if stage 2 block mapping not supported

Andrew Jones (6):
      KVM: arm64: pvtime: steal-time is only supported when configured
      KVM: arm64: pvtime: Fix potential loss of stolen time
      KVM: arm64: Drop type input from kvm_put_guest
      KVM: arm64: pvtime: Fix stolen time accounting across migration
      KVM: Documentation: Minor fixups
      arm64/x86: KVM: Introduce steal-time cap

Marc Zyngier (2):
      KVM: arm64: Do not try to map PUDs when they are folded into PMD
      KVM: arm64: Fix address truncation in traces

 Documentation/virt/kvm/api.rst     | 22 ++++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h  |  2 +-
 arch/arm64/kvm/arm.c               |  3 +++
 arch/arm64/kvm/mmu.c               |  8 +++++++-
 arch/arm64/kvm/pvtime.c            | 29 +++++++++++++----------------
 arch/arm64/kvm/trace_arm.h         | 16 ++++++++--------
 arch/arm64/kvm/trace_handle_exit.h |  6 +++---
 arch/x86/kvm/x86.c                 |  3 +++
 include/linux/kvm_host.h           | 31 ++++++++++++++++++++++++++-----
 include/uapi/linux/kvm.h           |  1 +
 10 files changed, 83 insertions(+), 38 deletions(-)
