Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF169333A76
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 11:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhCJKm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 05:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232566AbhCJKmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 05:42:24 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B73564F51;
        Wed, 10 Mar 2021 10:42:24 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lJwII-000jdD-1H; Wed, 10 Mar 2021 10:42:22 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 0/2] KVM: arm64: Assorted IPA size fixes
Date:   Wed, 10 Mar 2021 10:42:06 +0000
Message-Id: <20210310104208.3819061-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a rework of an initial patch posted a couple of days back[1]

While working on enabling KVM on "reduced IPA size" systems, I realise
we have a couple of issues, some of while do impact userspace.

The first issue is that we accept the creation of a "default IPA size"
VM (40 bits) even when the HW doesn't support it. Not good.

The second one is that we disallow a memslot to end right where the
IPA limit is. One page less and you're good, but that's not quite what
it should be.

I intend for both patches to be backported to -stable.

Thanks,

	M.

* From v1:
  - Don't try to cap the default IPA size. If userspace uses 0 with an
    expectation that it will get 40bits, we should abide by it and
    return an error immediately (noticed by Andrew)
  - Added a new patch to fix the exclusive nature of the IPA limit
  
[1] https://lore.kernel.org/r/20210308174643.761100-1-maz@kernel.org

Marc Zyngier (2):
  KVM: arm64: Reject VM creation when the default IPA size is
    unsupported
  KVM: arm64: Fix exclusive limit for IPA size

 Documentation/virt/kvm/api.rst |  3 +++
 arch/arm64/kvm/mmu.c           |  3 +--
 arch/arm64/kvm/reset.c         | 12 ++++++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.29.2

