Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAE776DBC7
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjHBXof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjHBXo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:44:27 -0400
Received: from out-85.mta1.migadu.com (out-85.mta1.migadu.com [IPv6:2001:41d0:203:375::55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B883E35B5
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rbC1VLEbfs8NLG+69kh7bsslTbnLgAwVxM41Gwv/hSQ=;
        b=Cj8HSopN7fdcBVTt+gCuxPc4AQD/sZs/oTbCHn9uzAW1WOtexfrruBZu+ukvCAjJen92MF
        SdWcKj78lXzelQqp06VG+GaZNFycEdxeZJ7RVv+a4FFdsve7wsNKJh9Je9C/vUBpWfQJwi
        ZqZDBROJRPfFf2nxnyfIWvGJip3zqVQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 15/17] aarch64: psci: Implement MIGRATE_INFO_TYPE
Date:   Wed,  2 Aug 2023 23:42:53 +0000
Message-ID: <20230802234255.466782-16-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let the guest know that our PSCI implementation is entirely oblivious to
the existence of a Trusted OS, and thus shouldn't care about it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index ac49d7aa8f22..bfd4756ea056 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -32,6 +32,7 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_ON:
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -190,6 +191,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 		affinity_info(vcpu, res);
 		break;
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+		/* Trusted OS not present */
+		res->a0 = PSCI_0_2_TOS_MP;
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.585.gd2178a4bd4-goog

