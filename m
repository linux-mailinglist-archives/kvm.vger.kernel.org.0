Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43255203161
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFVIGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFVIGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:06:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D60E207C3;
        Mon, 22 Jun 2020 08:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813213;
        bh=Ii14i7vMt5G0blEY8jOOtv2hk5ArajPnLztxOTdDv4o=;
        h=From:To:Cc:Subject:Date:From;
        b=tofBpQcybBeOKxwi8eoUa+ScRMUGCbQlt4sgu/nO4mJqbCzrEuGE1DgnIgIYns6VG
         Y+7ifpP6U5+arBiWpI32ti/Y2LlZa6Ve+oiwtHz2lO/zCvssW41I0leGdPqyVobmom
         2SP3RE7P4Ucv/BmtBeQRSRMIN7daLpqlPS2cOpGQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnHTf-005FG8-Br; Mon, 22 Jun 2020 09:06:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: [PATCH v2 0/5] KVM/arm64: Enable PtrAuth on non-VHE KVM
Date:   Mon, 22 Jun 2020 09:06:38 +0100
Message-Id: <20200622080643.171651-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not having PtrAuth on non-VHE KVM (for whatever reason VHE is not
enabled on a v8.3 system) has always looked like an oddity. This
trivial series remedies it, and allows a non-VHE KVM to offer PtrAuth
to its guests.

In the tradition of not having separate security between host-EL1 and
EL2, EL2 reuses the keys set up by host-EL1. It is likely that, should
we switch to a mode where EL2 is more distrusting of EL1, we'd have
private keys there.

The last two patches are respectively an optimization when
save/restoring the PtrAuth context, and a cleanup of the alternatives
used by that same save/restore code.

* From v1 [1]:
  - Move the hand-crafted literal load to using a mov_q macro (Andrew, Mark)
  - Added a cleanup of the alternatives on the save/restore path (Mark)

[1] https://lore.kernel.org/kvm/20200615081954.6233-1-maz@kernel.org/

Marc Zyngier (5):
  KVM: arm64: Enable Address Authentication at EL2 if available
  KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
  KVM: arm64: Allow PtrAuth to be enabled from userspace on non-VHE
    systems
  KVM: arm64: Check HCR_EL2 instead of shadow copy to swap PtrAuth
    registers
  KVM: arm64: Simplify PtrAuth alternative patching

 arch/arm64/Kconfig                   |  4 +---
 arch/arm64/include/asm/kvm_ptrauth.h | 30 ++++++++++------------------
 arch/arm64/kvm/hyp-init.S            |  5 +++++
 arch/arm64/kvm/reset.c               | 21 ++++++++++---------
 4 files changed, 27 insertions(+), 33 deletions(-)

-- 
2.27.0

