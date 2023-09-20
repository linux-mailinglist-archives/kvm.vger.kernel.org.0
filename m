Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6E7A8D24
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjITTvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjITTvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:51:01 -0400
Received: from out-216.mta0.migadu.com (out-216.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C9DC9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aasfXlonvSkL1RHsBXJRHP4jP4IZ28o3XMxhlXBFnnE=;
        b=iPPFEExSStJGWchOmXbAE66iDoFXYqlCLYUSjtZhhiBWV1wp9eB6B8pRIRL9qi6dIglKM+
        th8/9ER4ChBcp3FT1pUVQTIDuoKv+q9bt7wPDoVo35dp/eCz8L52tZODGpjDfJOJ6CfqAq
        BriX3uR1RJdjjF6a9PcNc4TnzqbNu/Q=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5/8] KVM: arm64: Prevent NV feature flag on systems w/o nested virt
Date:   Wed, 20 Sep 2023 19:50:33 +0000
Message-ID: <20230920195036.1169791-6-oliver.upton@linux.dev>
In-Reply-To: <20230920195036.1169791-1-oliver.upton@linux.dev>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
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

It would appear that userspace can select the NV feature flag regardless
of whether the system actually supports the feature. Obviously a nested
guest isn't getting far in this situation; let's reject the flag
instead.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e40f3bfcb0a1..ef92c2f2de70 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1208,6 +1208,9 @@ static unsigned long system_supported_vcpu_features(void)
 		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
 	}
 
+	if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
+		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
+
 	return features;
 }
 
-- 
2.42.0.515.g380fc7ccd1-goog

