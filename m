Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29E9476F18
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhLPKpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:45:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44494 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbhLPKpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:45:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE9D61CFA
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 10:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCFCC36AE2;
        Thu, 16 Dec 2021 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639651512;
        bh=k0sivyjWD6szjwF7EGZwTgDdQ7orNpZ4z/eWXEe5lP4=;
        h=From:To:Cc:Subject:Date:From;
        b=d/RWKPI8UWWAp5WprshmvvrNmHGQsazv9wZDjUQydw4QCzWknLcdlyr+klXfvyhdz
         v+Isb31JYbR2RAhcFLkRNU2ydhKduXWVGMshNlP9Lpwtw5cASQBs4cKPUebubLHVgi
         Ng8afvuGuYgziZmm00YN0xnbblzxhYWumw5GML6xhD5Pz+D80HmHzNCBmHtQnB2hPR
         Bvb7KDdulgett2y0/CMIefxQTMSPpPhz0gRODa5YGywfVtYzcBVVcmBen+rC759Ha/
         i7cX73n9e9TsOKWCkQ2VLGS5u8pwvgBc1az+zdTxUogfwc+QdL0l/WCP6tfkLFwskZ
         TMTwsoHo60Xyg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mxoG6-00CUsg-7H; Thu, 16 Dec 2021 10:45:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: vgic: Demote userspace-triggered console prints to kvm_debug()
Date:   Thu, 16 Dec 2021 10:45:07 +0000
Message-Id: <20211216104507.1482017-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running the KVM selftests results in these messages being dumped
in the kernel console:

[  188.051073] kvm [469]: VGIC redist and dist frames overlap
[  188.056820] kvm [469]: VGIC redist and dist frames overlap
[  188.076199] kvm [469]: VGIC redist and dist frames overlap

Being amle to trigger this from userspace is definitely not on,
so demote these warnings to kvm_debug().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 4 ++--
 arch/arm64/kvm/vgic/vgic-v3.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 95a18cec14a3..280a708631cd 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -293,12 +293,12 @@ int vgic_v2_map_resources(struct kvm *kvm)
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
 	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
-		kvm_err("Need to set vgic cpu and dist addresses first\n");
+		kvm_debug("Need to set vgic cpu and dist addresses first\n");
 		return -ENXIO;
 	}
 
 	if (!vgic_v2_check_base(dist->vgic_dist_base, dist->vgic_cpu_base)) {
-		kvm_err("VGIC CPU and dist frames overlap\n");
+		kvm_debug("VGIC CPU and dist frames overlap\n");
 		return -EINVAL;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 04f62c4b07fb..97ab7c02e189 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -554,12 +554,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
-		kvm_err("Need to set vgic distributor addresses first\n");
+		kvm_debug("Need to set vgic distributor addresses first\n");
 		return -ENXIO;
 	}
 
 	if (!vgic_v3_check_base(kvm)) {
-		kvm_err("VGIC redist and dist frames overlap\n");
+		kvm_debug("VGIC redist and dist frames overlap\n");
 		return -EINVAL;
 	}
 
-- 
2.30.2

