Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E1F6D9CAA
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbjDFPtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 11:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbjDFPtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 11:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20FB9ECD
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 08:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6BB617E5
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 15:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5F7C433D2;
        Thu,  6 Apr 2023 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680796138;
        bh=34/Zlt4htBGJgLYgA2mf1PBt32s5lUf3YI5evv+PwzE=;
        h=From:To:Cc:Subject:Date:From;
        b=D7zxynq8HRn4kJeQhHBvFnLHjZ8ju+Eb7dFz232hmOrhF/MqeZ5wmrKIBfeSQiOnt
         CUSXgqKQcQXJ9sOmgzzvu3n1/kuJwDE7WkZxA4LwlnWK1+msnF8UsaEXHUwBPDEZ8d
         XsaOo5wLs8EYeXr1xxdaSMh0bwwvQnpRDWOE118o9UvsZ09MygGW4CjVwg0OPknKif
         m62k+njaTviZs7niYwjZk4JRrQvH4kO39brIrVd9scMiiqkz0D2lim2+Zg/SNIEPLU
         Ikn+5w1eXq6RdVfdxfWk0HnNt3I77T//IqX+xrEUKyOxHYUSA/GFGdBaOh9vlnerTi
         ZtLvTmxy9Hbiw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pkRr6-006MBX-Jj;
        Thu, 06 Apr 2023 16:48:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vhe: Drop extra isb() on guest exit
Date:   Thu,  6 Apr 2023 16:48:53 +0100
Message-Id: <20230406154853.3860511-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__kvm_vcpu_run_vhe() end on VHE with an isb(). However, this
function is only reachable via kvm_call_hyp_ret(), which already
contains an isb() in order to mimick the behaviour of nVHE and
provide a context synchronisation event.

We thus have two isb()s back to back, which is one too many.
Drop the first one and solely rely on the one in the helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index cd3f3117bf16..3d868e84c7a0 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -227,11 +227,10 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/*
 	 * When we exit from the guest we change a number of CPU configuration
-	 * parameters, such as traps.  Make sure these changes take effect
-	 * before running the host or additional guests.
+	 * parameters, such as traps.  We rely on the isb() in kvm_call_hyp*()
+	 * to make sure these changes take effect before running the host or
+	 * additional guests.
 	 */
-	isb();
-
 	return ret;
 }
 
-- 
2.34.1

