Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E751A7BB451
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjJFJgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjJFJgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:36:17 -0400
Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D17E4
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 02:36:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696584975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gh+eX+ye68Toig4xSoi3CtBNU7Eq4Xn2gkTUvNbjh7I=;
        b=koun1LXsbd4Y7oJYgKMhtstXSmdhGHvYhdzO6GgLo/W33z2/MmBEvAqHImCCPPqhOciwiZ
        PsRVZGzbTyxxWJSJjRWSHyn5GjWf7NqTtkmwWJJ5S7DR8RZ7WYvr2f+TkClZ4UUQjyRVRE
        YFJO2lIUoQ5tdmaitopHNfyxSYhlxos=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
Date:   Fri,  6 Oct 2023 09:35:58 +0000
Message-ID: <20231006093600.1250986-2-oliver.upton@linux.dev>
In-Reply-To: <20231006093600.1250986-1-oliver.upton@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HCR_EL2.TGE=0 is sufficient to disable stage-2 translation, so there's
no need to explicitly zero VTTBR_EL2. Note that this is exactly what we
do on the guest exit path in __kvm_vcpu_run_vhe() already.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 46bd43f61d76..f3f2e142e4f4 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -66,7 +66,6 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
-	write_sysreg(0, vttbr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	isb();
 
-- 
2.42.0.609.gbb76f46606-goog

