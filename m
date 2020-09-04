Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D94625D6C2
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbgIDKqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgIDKqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 06:46:03 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4D882087C;
        Fri,  4 Sep 2020 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599216362;
        bh=mIOES2oHYEYo5N/ys71QEEfVp16YdoOph7z6Wrougfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDUxXl55pS8P0i2mXv8eXiPFRnDlSsjvAB+5QhghbY4LOy55VUh4gNHr+qKYIqp2C
         ZQ0aCYrmuGeToF3qJsRxuR0V4jHl+tYvra5QyGZkSMc84716glwQPrjmrWNUEZ56ZU
         zccPHA1SUcz94hNN9twx6JN82PZz34Y5Twp2LR7c=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kE9EH-0098oH-4r; Fri, 04 Sep 2020 11:46:01 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 2/9] KVM: arm64: pvtime: Fix potential loss of stolen time
Date:   Fri,  4 Sep 2020 11:45:23 +0100
Message-Id: <20200904104530.1082676-3-maz@kernel.org>
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

We should only check current->sched_info.run_delay once when
updating stolen time. Otherwise there's a chance there could
be a change between checks that we miss (preemption disabling
comes after vcpu request checks).

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200804170604.42662-3-drjones@redhat.com
---
 arch/arm64/kvm/pvtime.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index c3ef4ebd6846..95f9580275b1 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -13,6 +13,7 @@
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
+	u64 last_steal = vcpu->arch.steal.last_steal;
 	u64 steal;
 	__le64 steal_le;
 	u64 offset;
@@ -24,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 
 	/* Let's do the local bookkeeping */
 	steal = vcpu->arch.steal.steal;
-	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
-	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
+	steal += vcpu->arch.steal.last_steal - last_steal;
 	vcpu->arch.steal.steal = steal;
 
 	steal_le = cpu_to_le64(steal);
-- 
2.27.0

