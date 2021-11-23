Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F59445A57C
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 15:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbhKWO0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 09:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhKWO0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 09:26:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E976052B;
        Tue, 23 Nov 2021 14:22:58 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mpWhE-007Ijf-9C; Tue, 23 Nov 2021 14:22:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Fuad Tabba <tabba@google.com>, kernel-team@android.com
Subject: [PATCH 0/2] KVM/arm64: Early PSTATE evaluation fixes
Date:   Tue, 23 Nov 2021 14:22:45 +0000
Message-Id: <20211123142247.62532-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org, qperret@google.com, tabba@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are a number of cases where we evaluate PSTATE early on guest
exit. Nothing wrong with that. Except that we actually synchronise
KVM's view of PSTATE pretty late, way after we needed it. Oopsie boo.

Thankfully, there are only two paths that require it: GICv3 emulation
for 32bit guests, and trap handling of 32bit guests in protected
mode. There is no known need of the former (though you could enable it
on the command line), and the latter is still a work in progress. In
any case, this needs fixing.

Funnily enough, this is something that I had already solved on NV, so
the solution isn't that different from what I have there.

Unless someone shouts, I intend to merge these as fixes.

Marc Zyngier (2):
  KVM: arm64: Save PSTATE early on exit
  KVM: arm64: Move pkvm's special 32bit handling into a generic
    infrastructure

 arch/arm64/kvm/hyp/include/hyp/switch.h    | 14 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  7 ++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  8 +-------
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 ++++
 4 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.30.2

