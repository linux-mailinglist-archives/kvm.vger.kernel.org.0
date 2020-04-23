Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2071B5FA1
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgDWPkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbgDWPki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:40:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1CFD216FD;
        Thu, 23 Apr 2020 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587656437;
        bh=GNXG5kPdn9LeEq52oGgCF3JivlMErksaY8YYinNLtkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4oJBwUWiUHbzkM5SMOQwsCpLLIqGCSFsVzTZOWsY5WKzxn1XCR52lrJ7EMKy4cml
         NHp+i73dqh2ltLXe1krJzju+7C5rzDLd+A9yZrITaBMvmckkZNwg2fbkufSpnXQ6zc
         A7cIafOk6eC91BNnlRQVb/XvQGg/mzLQRrlkPbCI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRdxr-005oPM-RY; Thu, 23 Apr 2020 16:40:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Grall <julien@xen.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 8/8] KVM: arm64: vgic-its: Fix memory leak on the error path of vgic_add_lpi()
Date:   Thu, 23 Apr 2020 16:40:09 +0100
Message-Id: <20200423154009.4113562-9-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200423154009.4113562-1-maz@kernel.org>
References: <20200423154009.4113562-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

If we're going to fail out the vgic_add_lpi(), let's make sure the
allocated vgic_irq memory is also freed. Though it seems that both
cases are unlikely to fail.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200414030349.625-3-yuzenghui@huawei.com
---
 virt/kvm/arm/vgic/vgic-its.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d53d34a33e35d..c012a52b19f57 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -96,14 +96,21 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in
 	 * the respective config data from memory here upon mapping the LPI.
+	 *
+	 * Should any of these fail, behave as if we couldn't create the LPI
+	 * by dropping the refcount and returning the error.
 	 */
 	ret = update_lpi_config(kvm, irq, NULL, false);
-	if (ret)
+	if (ret) {
+		vgic_put_irq(kvm, irq);
 		return ERR_PTR(ret);
+	}
 
 	ret = vgic_v3_lpi_sync_pending_status(kvm, irq);
-	if (ret)
+	if (ret) {
+		vgic_put_irq(kvm, irq);
 		return ERR_PTR(ret);
+	}
 
 	return irq;
 }
-- 
2.26.2

