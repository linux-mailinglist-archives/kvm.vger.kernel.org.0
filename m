Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D327712FE2
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjEZWU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbjEZWUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:20:17 -0400
Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CD2119
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:19:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WFb2eDJlQFs4CNm8WapwB+xv3uzHxr4upqkpB9oFXWI=;
        b=H/SQlLa5CYGQzUP5yLMR0CeH+F19gPrbqtlq1IUvlHmLXH9CwNSWCTWNg74yuOMahBMdPa
        eWIjrQuzK3+Cu4WUUvOBkhoIMHz8WN+U2ptwX427vdMF0L9N1tCDoMnmX7gAvbEeXc9wFH
        zdzGW2YCm1OEyIFPWpg2UX4fFloadgM=
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
Subject: [PATCH kvmtool 20/21] aarch64: psci: Implement SYSTEM_{OFF,RESET}
Date:   Fri, 26 May 2023 22:18:49 +0000
Message-ID: <20230526221849.317435-1-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for the PSCI SYSTEM_{OFF,RESET} calls. Match the behavior of
the SYSTEM_EVENT based implementation and just terminate the VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index c33e63bdc3ef..daeb6f11f2d0 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -33,6 +33,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -194,6 +196,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		/* Trusted OS not present */
 		res->a0 = PSCI_0_2_TOS_MP;
 		break;
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+		kvm__reboot(vcpu->kvm);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.rc0.172.g3f132b7071-goog

