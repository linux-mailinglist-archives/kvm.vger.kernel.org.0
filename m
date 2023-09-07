Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD68E7977EA
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbjIGQgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241619AbjIGQgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:36:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFFB35A9
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:11:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157C1C4166B;
        Thu,  7 Sep 2023 10:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694081396;
        bh=VnRY7EVjDxQnjy59aA3/M9OwNwE3hcD6p0d+NJE1MBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ja+wdiYX5Cm2NHtNJaFjsOTVDpel+AtB0+1I9yi7O7+X1oSO5eGH/Z63zGCev3q4x
         lwZjgaUYabPnHiDbNViaTGaYvfaXrRY4/+1cWIxxocpMELrRlbDNoIO3NvcLnH/ywy
         +GUTNU2oJ8FQym5JC7Qq8CH/+S/OGGkQJC8/kdq/TN27lU51siTZn0zF6Ifku3aqD1
         HRkfyfKHrUKe1LauO7YC7ypGaYD1xFgSNv9EXHntfy8v7LNIi58ppreld26tTFsayo
         JXUbuIIoRy43GykaPZaElrw/c9SxY1qj2dyB32NCVc3n9Z8qVFSIZe4U5bB5fUC24c
         56MnEEyob/cbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qeBxS-00B37Y-1w;
        Thu, 07 Sep 2023 11:09:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: [PATCH 3/5] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
Date:   Thu,  7 Sep 2023 11:09:29 +0100
Message-Id: <20230907100931.1186690-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230907100931.1186690-1-maz@kernel.org>
References: <20230907100931.1186690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, zhaoxu.35@bytedance.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
use it to recover the corresponding vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 30ce394c09d4..5b75b2db12be 100644
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

