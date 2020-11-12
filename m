Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3652B2B1156
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 23:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgKLWWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 17:22:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKLWWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 17:22:38 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7C9206C0;
        Thu, 12 Nov 2020 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605219758;
        bh=UQUwiBq8tWwyGEtWdZsI4uMA1qJTbHpjR+jMnbG5eV0=;
        h=From:To:Cc:Subject:Date:From;
        b=PzAwW5y5g8PIPo7brxJe6bZfQKtV0doSsNjkQ5xD82Gpf5Z9mCx5pDt7ErnHxy3T+
         YpMPKR7/PowNZS0MkKQV5FpyEUTPk86H4dcUFT9tL3xSVAFUeNfmUIkRY9AKnt+J1c
         SG1wrRYXJ8PO37cjjC0VfyRvgIN8R4teHCwlygos=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kdKzD-00ABHn-Np; Thu, 12 Nov 2020 22:22:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peng Liang <liangpeng10@huawei.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] KVM/arm64 fixes for 5.10, take #3
Date:   Thu, 12 Nov 2020 22:21:36 +0000
Message-Id: <20201112222139.466204-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, liangpeng10@huawei.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's another small set of fixes for 5.10, this time fixing some
corner cases of the Spectre mitigation rework. Note that I had to pull
5.10-rc1 into kvmarm/next in order to avoid some annoying conflicts.

Please pull,

	M.

The following changes since commit 4f6b838c378a52ea3ae0b15f12ca8a20849072fa:

  Merge tag 'v5.10-rc1' into kvmarm-master/next (2020-11-12 21:20:43 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-3

for you to fetch changes up to ed4ffaf49bf9ce1002b516d8c6aa04937b7950bc:

  KVM: arm64: Handle SCXTNUM_ELx traps (2020-11-12 21:22:46 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for v5.10, take #3

- Allow userspace to downgrade ID_AA64PFR0_EL1.CSV2
- Inject UNDEF on SCXTNUM_ELx access

----------------------------------------------------------------
Marc Zyngier (3):
      KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2 from userspace
      KVM: arm64: Unify trap handlers injecting an UNDEF
      KVM: arm64: Handle SCXTNUM_ELx traps

 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/sysreg.h   |   4 ++
 arch/arm64/kvm/arm.c              |  16 ++++++
 arch/arm64/kvm/sys_regs.c         | 111 +++++++++++++++++++++++---------------
 4 files changed, 89 insertions(+), 44 deletions(-)
