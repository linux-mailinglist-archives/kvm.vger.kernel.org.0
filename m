Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC257A8B7E
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjITSRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjITSRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD53CC
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AFCC433C9;
        Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233860;
        bh=eAFhYdYPK7xFl+776FskY4IDP549/3Ym7n8sQg2d9bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iop30yaCZsWLzwY0A/VUzzh9MyQHiCFXiAoutqtG0GtJedsiZiAj2R5knpMqb9nmY
         ynUQtJxyWMkWd5z4QPsi1wg4LqO6PauQYn4OPRDtilO50ZYNUVVuPN2pzPNM3mu6sK
         ioFNQEqvKk0hJUUCaz77F2B+gquk9lyWQ6uToWFhaXLws9R2t9/2p3tiSORpespo0d
         9jIgphjpQCzw1xZG4XOQG82B5nTlN1lqYKClEODnplkoWSxi9zilYqjvkkN3SfWom8
         t/4XXpoNEUeK1xBTphto1MBrTVqTW1yqbzf0EkUCz8U4+TAjPSMtEACTvclnLUokmv
         zMgIBoFp3mbjw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1la-00Ejx0-U0;
        Wed, 20 Sep 2023 19:17:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 09/11] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
Date:   Wed, 20 Sep 2023 19:17:29 +0100
Message-Id: <20230920181731.2232453-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
use it to recover the corresponding vcpu.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d9de4d3a339c..28f3940fa724 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2395,6 +2395,18 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	unsigned long i;
 
 	mpidr &= MPIDR_HWID_BITMASK;
+
+	if (kvm->arch.mpidr_data) {
+		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
+
+		vcpu = kvm_get_vcpu(kvm,
+				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
+		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
+			vcpu = NULL;
+
+		return vcpu;
+	}
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
 			return vcpu;
-- 
2.34.1

