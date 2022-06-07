Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D9353FFC9
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbiFGNOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244439AbiFGNOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0733CEAD0C
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C405613F8
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 13:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1DDC385A5;
        Tue,  7 Jun 2022 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654607673;
        bh=RiFpv4ti8o+54/PIi4uIAl7GNNSk/w0np3Cg3vPA0Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxcKuQHTPYMDTWg7lUSCrAi28fydKer9Ii4G5fABeknMBwms4mnpvGCQiWM+Kkpgw
         E6d/cf/8LjwtwyAid5yw2/lc+lVVsF2mLQq0Y8PplgHAm8DHigcd8XzPkvGg3kmDfz
         HkGH/KML3kErO/OECw9jcCjyTJfxV0TY2d7ErO1JDdS4bCxPr1AZaTG8nkS/Dx5RbK
         RYxVBviQzvFQTkv5Bp7j5VliniLEdhan2M2ZCebrriO4gpHh+2IkGqmgBr8GMjlaRo
         BMn8YyaOZOzLxBmY6o4+dU/XX5cA1oKo0M4DSxoF9c0ldH4J4vWINnFEuo4SMS1iND
         wfXfeAdubhPMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nyZ2V-00GBUI-AH; Tue, 07 Jun 2022 14:14:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
Subject: [PATCH v2 3/3] KVM: arm64: Warn if accessing timer pending state outside of vcpu context
Date:   Tue,  7 Jun 2022 14:14:27 +0100
Message-Id: <20220607131427.1164881-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220607131427.1164881-1-maz@kernel.org>
References: <20220607131427.1164881-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eric.auger@redhat.com, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A recurrent bug in the KVM/arm64 code base consists in trying to
access the timer pending state outside of the vcpu context, which
makes zero sense (the pending state only exists when the vcpu
is loaded).

In order to avoid more embarassing crashes and catch the offenders
red-handed, add a warning to kvm_arch_timer_get_input_level() and
return the state as non-pending. This avoids taking the system down,
and still helps tracking down silly bugs.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4e39ace073af..3b8d062e30ea 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1230,6 +1230,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct arch_timer_context *timer;
 
+	if (WARN(!vcpu, "No vcpu context!\n"))
+		return false;
+
 	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
-- 
2.34.1

