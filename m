Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FD25D6CE
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgIDKsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgIDKqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 06:46:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25CF82084D;
        Fri,  4 Sep 2020 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599216362;
        bh=hwGXasGI3vXuxzwR0fHBe/7NmPWta8DzMPNFt/WIVgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0FfVPp/FmurwSKrvSZ9N7lthPNpqqJd63RIhw6bd5GelQ0tHuTSdCClt/qF5V6z3
         4dd+PH2xU0Dw6X7d468qEWIi54HKZXY6srQ5KJmIHXvF5koaSFsjWdcl6EsoRV6mks
         1Pq7it2Urg/hKH+ZJK+AwolS7Bak52XjNquyEBII=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kE9EG-0098oH-Ja; Fri, 04 Sep 2020 11:46:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 1/9] KVM: arm64: pvtime: steal-time is only supported when configured
Date:   Fri,  4 Sep 2020 11:45:22 +0100
Message-Id: <20200904104530.1082676-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
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

From: Andrew Jones <drjones@redhat.com>

Don't confuse the guest by saying steal-time is supported when
it hasn't been configured by userspace and won't work.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200804170604.42662-2-drjones@redhat.com
---
 arch/arm64/kvm/pvtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index f7b52ce1557e..c3ef4ebd6846 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -43,7 +43,8 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 	case ARM_SMCCC_HV_PV_TIME_ST:
-		val = SMCCC_RET_SUCCESS;
+		if (vcpu->arch.steal.base != GPA_INVALID)
+			val = SMCCC_RET_SUCCESS;
 		break;
 	}
 
-- 
2.27.0

