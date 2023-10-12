Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6107C782D
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 22:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442780AbjJLUyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347397AbjJLUyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 16:54:36 -0400
Received: from out-195.mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6803C9D
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 13:54:35 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697144073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j8joI2FU7W3rzo87zRemNZDf7BE+155GgP5KVsnPNxg=;
        b=aXsjxWP8U/V6ZvSQscjtcnXuR5RseopbAzmt1mWVVQduuvKUoigWENFKarAtkCHAJzqVAt
        Wn8txwL2N8cTvEyFOFAtCVAkFiC+uOLbgq/uWI/82H+/77/u1wvnOJVr+qtm5U2yyr82Oq
        cHJUg/swJcbsPAxT96M3TWtBlBKvFJg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/5] KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
Date:   Thu, 12 Oct 2023 20:54:18 +0000
Message-ID: <20231012205422.3924618-2-oliver.upton@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
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
no need to explicitly zero VTTBR_EL2.

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
2.42.0.655.g421f12c284-goog

