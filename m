Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713281F9135
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 10:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgFOIUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 04:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgFOIUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 04:20:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D2B2053B;
        Mon, 15 Jun 2020 08:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592209204;
        bh=rn6yKK06LpzRw/3dsq0h1xocnLbW3SUFTAd2Sa8+1Js=;
        h=From:To:Cc:Subject:Date:From;
        b=YWtLZGQyd7nbuuYsMvmTnST0IZDFzzhO9C/apw+MIVjPu8F//TT/q/odf8KcBnu/g
         kQRjs69i3amQsA177aT9+pF5TTUI85VSEjMlFL679jKIVBEIn9BlrjaJ1Qvbun4oL/
         UOZwW4WuBQ5zAmwPQLaPAf3q1FKAxQMcQCjeiQ4A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jkkLb-0031ew-1k; Mon, 15 Jun 2020 09:20:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/4] KVM/arm64: Enable PtrAuth on non-VHE KVM
Date:   Mon, 15 Jun 2020 09:19:50 +0100
Message-Id: <20200615081954.6233-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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

The last patch is just an optimisation which I've lobbed with the rest
of the series in order not to forget it.

Marc Zyngier (4):
  KVM: arm64: Enable Pointer Authentication at EL2 if available
  KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
  KVM: arm64: Allow PtrAuth to be enabled from userspace on non-VHE
    systems
  KVM: arm64: Check HCR_EL2 instead of shadow copy to swap PtrAuth
    registers

 arch/arm64/Kconfig                   |  4 +---
 arch/arm64/include/asm/kvm_ptrauth.h |  4 ++--
 arch/arm64/kvm/hyp-init.S            | 11 +++++++++++
 arch/arm64/kvm/reset.c               | 21 ++++++++++-----------
 4 files changed, 24 insertions(+), 16 deletions(-)

-- 
2.27.0

