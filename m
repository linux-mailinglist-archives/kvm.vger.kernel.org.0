Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C3625C5F1
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgICP4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgICPz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:55:58 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F8652072A;
        Thu,  3 Sep 2020 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148558;
        bh=UawhsvvU+Wr870f+1lUBnJMX3SK6C5mCIOxqnEgbrsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMS0YyIG5G3YiDZO/NbUPiMufx4BuhOSssh8LXtEPBuM1jXbQSIljZeMSSnTXPxqU
         FPdoKtUwXC0rUL0OBW/O5Ah/o/SVcl9FLxJZIbYCOXWtAnl8Rdo3t0Ilf3MVc8cwRH
         kvJFmO4usBmSn+6M7LmldEi46maewGvHBC1a1ztM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr8D-008vT9-MV; Thu, 03 Sep 2020 16:26:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 21/23] KVM: arm64: Tighten msis_require_devid reporting
Date:   Thu,  3 Sep 2020 16:26:08 +0100
Message-Id: <20200903152610.1078827-22-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although it is safe for now, do condition the returning of
a msis_require_devid capability on the irqchip being a GICv3.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d625904633c0..0d4c8de27d1e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -195,7 +195,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (!kvm)
 			r = -EINVAL;
 		else
-			r = kvm->arch.vgic.msis_require_devid;
+			r = (irqchip_is_gic_v3(kvm) &&
+			     kvm->arch.vgic.msis_require_devid);
 		break;
 	case KVM_CAP_ARM_USER_IRQ:
 		/*
-- 
2.27.0

