Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E638176DBC6
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjHBXod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjHBXo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:44:27 -0400
Received: from out-95.mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9DA35B7
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=530qr48J72r5k8clKCa4qpNKEiXQWBugRyBBXbuZckA=;
        b=DwYnojwT22y5h/bK75IJrdySthugoybtr+ixrxuFN5e6Rr+U7WM63mo8lvdogPfzsdDRpQ
        qu5+6D3rNU8rPkwoGjtPat/6OVXCdb/nF7yoq+H3KBcTHrXBsxb3Vl9sORg2Des69udSBI
        ygGrW/POORJhkYh1hQQDrgiMCqKgduY=
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
Subject: [PATCH kvmtool v3 16/17] aarch64: psci: Implement SYSTEM_{OFF,RESET}
Date:   Wed,  2 Aug 2023 23:42:54 +0000
Message-ID: <20230802234255.466782-17-oliver.upton@linux.dev>
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

Add support for the PSCI SYSTEM_{OFF,RESET} calls. Match the behavior of
the SYSTEM_EVENT based implementation and just terminate the VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index bfd4756ea056..b73c28729ddc 100644
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
@@ -195,6 +197,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
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
2.41.0.585.gd2178a4bd4-goog

