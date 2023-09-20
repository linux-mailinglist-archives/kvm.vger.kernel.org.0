Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5657A8BE4
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjITSdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjITSdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:33:50 -0400
Received: from out-226.mta1.migadu.com (out-226.mta1.migadu.com [IPv6:2001:41d0:203:375::e2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DB2DC
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:33:43 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695234821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fiKDFw4FmI+YtcrQ14r5/ooshFPZ0x9Ux0zjbxVWoc=;
        b=eZkEXG6RQHNcI7uAk0MWsubVlvgC9Cy9n8Qg9INUrQ21fpZ1l5MUqjWYsqB4LGHvYvE2BW
        BZMWL1VOawiGsnqY2cBKObU9FbQtvNRac2jq5dSyAqNdq2T6QLgZDq9unjKoZlydI+Kv2u
        B+DN1CAETEWICGURc4a7YdHKVKMexXo=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v10 08/12] KVM: arm64: Allow userspace to change ID_AA64PFR0_EL1
Date:   Wed, 20 Sep 2023 18:33:05 +0000
Message-ID: <20230920183310.1163034-9-oliver.upton@linux.dev>
In-Reply-To: <20230920183310.1163034-1-oliver.upton@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
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

From: Jing Zhang <jingzhangos@google.com>

Allow userspace to change the guest-visible value of the register with
some severe limitation:

 - No changes to features not virtualized by KVM (AMU, MPAM, RAS)

 - Short of full GICv2 emulation in kernel, hiding GICv3 from the guest
   makes absolutely no sense.

 - FP is effectively assumed for KVM VMs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
[oliver: restrict features that are illogical to change]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5758cff479d3..8738b0a0cf5c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2061,7 +2061,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = ~(ID_AA64PFR0_EL1_AMU |
+		   ID_AA64PFR0_EL1_MPAM |
+		   ID_AA64PFR0_EL1_SVE |
+		   ID_AA64PFR0_EL1_RAS |
+		   ID_AA64PFR0_EL1_GIC |
+		   ID_AA64PFR0_EL1_AdvSIMD |
+		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.42.0.515.g380fc7ccd1-goog

