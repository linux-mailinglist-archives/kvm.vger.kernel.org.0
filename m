Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF038078A
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 12:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhENKmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 06:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhENKl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 06:41:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5030861457;
        Fri, 14 May 2021 10:40:48 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lhVFO-001N6Q-7B; Fri, 14 May 2021 11:40:46 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 0/2] KVM: arm64: Fixup PC updates on exit to userspace
Date:   Fri, 14 May 2021 11:40:40 +0100
Message-Id: <20210514104042.1929168-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, tabba@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We recently moved anything related to PC updates into the guest entry
code to help with the protected KVM effort. However, I missed a
critical point: userspace needs to be able to observe state changes
when the vcpu exits. Otherwise, live migration is a bit broken and
vcpu reset can fail (as reported by Zenghui). Not good.

These two patches aim at fixing the above, and carry a Cc stable.

* From v1:
  - Sanitized flag checking
  - Added comment about relying on __kvm_adjust_pc() being preempt-safe
  - Dropped superfluous includes

Marc Zyngier (2):
  KVM: arm64: Move __adjust_pc out of line
  KVM: arm64: Commit pending PC adjustemnts before returning to
    userspace

 arch/arm64/include/asm/kvm_asm.h           |  3 +++
 arch/arm64/kvm/arm.c                       | 10 ++++++++++
 arch/arm64/kvm/hyp/exception.c             | 18 +++++++++++++++++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ------------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  8 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           |  3 +--
 arch/arm64/kvm/hyp/vhe/switch.c            |  3 +--
 7 files changed, 40 insertions(+), 23 deletions(-)

-- 
2.29.2

