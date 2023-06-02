Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2B720BC9
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbjFBWPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbjFBWPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:15:09 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797D71BC
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685744108; x=1717280108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HVajRo8XvA6o1Hf7ztsb8kI06QIJmMblpNYA1lMUgkw=;
  b=eNXE9L0nWZUuCKFQMSAW4j/y/zY7W6S4DcGFok0s0WLIz0SlwZ8TvAAA
   7OCcneP/P69Q8PIFVpoaSXS4VtK54HGZ70lHkZ5Wsl1fQzH8k8NjyWbuH
   NTT20iP8KaM5X2NknRaEiLv7bOvucMK0oXYmgQbGHF0Hxa/9jx6tDzIGD
   8=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="7805059"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 22:15:06 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id B05B9C16E0;
        Fri,  2 Jun 2023 22:15:01 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:58 +0000
Received: from u1e958862c3245e.ant.amazon.com (10.187.170.26) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:58 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <jingzhangos@google.com>
CC:     <alexandru.elisei@arm.com>, <james.morse@arm.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <oupton@google.com>, <pbonzini@redhat.com>, <rananta@google.com>,
        <reijiw@google.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
        <will@kernel.org>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>
Subject: [PATCH 1/3] KVM: arm64: Update id_reg limit value based on per vcpu flags
Date:   Fri, 2 Jun 2023 15:14:45 -0700
Message-ID: <20230602221447.1809849-2-surajjs@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602221447.1809849-1-surajjs@amazon.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602221447.1809849-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.26]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are multiple features the availability of which is enabled/disabled
and tracked on a per vcpu level in vcpu->arch.flagset e.g. sve, ptrauth,
and pmu. While the vm wide value of the id regs which represent the
availability of these features is stored in the id_regs kvm struct their
value needs to be manipulated on a per vcpu basis. This is done at read
time in kvm_arm_read_id_reg().

The value of these per vcpu flags needs to be factored in when calculating
the id_reg limit value in check_features() as otherwise we can run into the
following scenario.

[ running on cpu which supports sve ]
1. AA64PFR0.SVE set in id_reg by kvm_arm_init_id_regs() (cpu supports it
   and so is set in value returned from read_sanitised_ftr_reg())
2. vcpus created without sve feature enabled
3. vmm reads AA64PFR0 and attempts to write the same value back
   (writing the same value back is allowed)
4. write fails in check_features() as limit has AA64PFR0.SVE set however it
   is not set in the value being written and although a lower value is
   allowed for this feature it is not in the mask of bits which can be
   modified and so much match exactly.

Thus add a step in check_features() to update the limit returned from
id_reg->reset() with the per vcpu features which may have been
enabled/disabled at vcpu creation time after the id_regs were initialised.
Split this update into a new function named kvm_arm_update_id_reg() so it
can be called from check_features() as well as kvm_arm_read_id_reg() to
dedup code.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/arm64/kvm/sys_regs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 50d4e25f42d3..a4e662bd218b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -42,6 +42,7 @@
  */
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd, u64 val);
+static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 id, u64 val);
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
@@ -1241,6 +1242,7 @@ static int arm64_check_features(struct kvm_vcpu *vcpu,
 	/* For hidden and unallocated idregs without reset, only val = 0 is allowed. */
 	if (rd->reset) {
 		limit = rd->reset(vcpu, rd);
+		limit = kvm_arm_update_id_reg(vcpu, id, limit);
 		ftr_reg = get_arm64_ftr_reg(id);
 		if (!ftr_reg)
 			return -EINVAL;
@@ -1347,10 +1349,8 @@ static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sy
 	return read_sanitised_ftr_reg(reg_to_encoding(rd));
 }
 
-static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
+static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 encoding, u64 val)
 {
-	u64 val = IDREG(vcpu->kvm, encoding);
-
 	switch (encoding) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
@@ -1402,6 +1402,13 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 	return val;
 }
 
+static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
+{
+	u64 val = IDREG(vcpu->kvm, encoding);
+
+	return kvm_arm_update_id_reg(vcpu, encoding, val);
+}
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
 {
-- 
2.34.1

