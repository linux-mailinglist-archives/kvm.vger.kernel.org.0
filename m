Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E7977D279
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbjHOSuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbjHOSuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554021FC3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 038B065FAD
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EACC433CB;
        Tue, 15 Aug 2023 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692125237;
        bh=bt9yIg8D3y0GaD7G73OsycJX8kphyb5Bx+Xjt+x6OZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFmUMdwcgx2gJoK9EeOYG2wjV2vSRKNotnWtXhC99fXsbzPUHVLBWKfSMLlBS63Dh
         JL0nqzTJdPCykXdcuTYkHFy1RBDUy8V9c4TJvk6LUsnGk5EckWJR0YxNFBquwqiHVu
         3Lo8O4TxyZMN1k58Wi63t4pr8QXzCuOveHLmalnok2qW12yeQqgF18IJluQPPajAn9
         ZYEtOWTBJjCQD94qpOavZ8VsN2aJmHNpo+CzUTz9mSWBnZsetPDKDEfwIqLfR77dZB
         yRkBF4XtmlyCFliaRUJ4Hhn/Z//iyNuWuLnrRCH6ztrNezHI3RUgV6KnoGL0XPfY34
         BezNGQR3Xs84g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywq-0055Sd-Bc;
        Tue, 15 Aug 2023 19:39:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 19/28] KVM: arm64: nv: Add fine grained trap forwarding infrastructure
Date:   Tue, 15 Aug 2023 19:38:53 +0100
Message-Id: <20230815183903.2735724-20-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fine Grained Traps are fun. Not.

Implement the fine grained trap forwarding, reusing the Coarse Grained
Traps infrastructure previously implemented.

Each sysreg/instruction inserted in the xarray gets a FGT group
(vaguely equivalent to a register number), a bit number in that register,
and a polarity.

It is then pretty easy to check the FGT state at handling time, just
like we do for the coarse version (it is just faster).

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 90 +++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 860910386b5b..0da9d92ed921 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -423,16 +423,23 @@ static const complex_condition_check ccc[] = {
  * following layout for each trapped sysreg:
  *
  * [9:0]	enum cgt_group_id (10 bits)
- * [62:10]	Unused (53 bits)
+ * [13:10]	enum fgt_group_id (4 bits)
+ * [19:14]	bit number in the FGT register (6 bits)
+ * [20]		trap polarity (1 bit)
+ * [62:21]	Unused (42 bits)
  * [63]		RES0 - Must be zero, as lost on insertion in the xarray
  */
 #define TC_CGT_BITS	10
+#define TC_FGT_BITS	4
 
 union trap_config {
 	u64	val;
 	struct {
 		unsigned long	cgt:TC_CGT_BITS; /* Coarse Grained Trap id */
-		unsigned long	unused:53;	 /* Unused, should be zero */
+		unsigned long	fgt:TC_FGT_BITS; /* Fine Grained Trap id */
+		unsigned long	bit:6;		 /* Bit number */
+		unsigned long	pol:1;		 /* Polarity */
+		unsigned long	unused:42;	 /* Unused, should be zero */
 		unsigned long	mbz:1;		 /* Must Be Zero */
 	};
 };
@@ -929,6 +936,28 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 
 static DEFINE_XARRAY(sr_forward_xa);
 
+enum fgt_group_id {
+	__NO_FGT_GROUP__,
+
+	/* Must be last */
+	__NR_FGT_GROUP_IDS__
+};
+
+#define SR_FGT(sr, g, b, p)					\
+	{							\
+		.encoding	= sr,				\
+		.end		= sr,				\
+		.tc		= {				\
+			.fgt = g ## _GROUP,			\
+			.bit = g ## _EL2_ ## b ## _SHIFT,	\
+			.pol = p,				\
+		},						\
+		.line = __LINE__,				\
+	}
+
+static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
+};
+
 static union trap_config get_trap_config(u32 sysreg)
 {
 	return (union trap_config) {
@@ -957,6 +986,7 @@ int __init populate_nv_trap_config(void)
 
 	BUILD_BUG_ON(sizeof(union trap_config) != sizeof(void *));
 	BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
+	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
 
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
 		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
@@ -990,6 +1020,34 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
+	if (!cpus_have_final_cap(ARM64_HAS_FGT))
+		goto check_mcb;
+
+	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
+		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
+		union trap_config tc;
+
+		if (fgt->tc.fgt >= __NR_FGT_GROUP_IDS__) {
+			ret = -EINVAL;
+			print_nv_trap_error(fgt, "Invalid FGT", ret);
+		}
+
+		tc = get_trap_config(fgt->encoding);
+
+		if (tc.fgt) {
+			ret = -EINVAL;
+			print_nv_trap_error(fgt, "Duplicate FGT", ret);
+		}
+
+		tc.val |= fgt->tc.val;
+		xa_store(&sr_forward_xa, fgt->encoding,
+			 xa_mk_value(tc.val), GFP_KERNEL);
+	}
+
+	kvm_info("nv: %ld fine grained trap handlers\n",
+		 ARRAY_SIZE(encoding_to_fgt));
+
+check_mcb:
 	for (int id = __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITIONS__; id++) {
 		const enum cgt_group_id *cgids;
 
@@ -1056,13 +1114,26 @@ static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
 	return __compute_trap_behaviour(vcpu, tc.cgt, b);
 }
 
+static bool check_fgt_bit(u64 val, const union trap_config tc)
+{
+	return ((val >> tc.bit) & 1) == tc.pol;
+}
+
+#define sanitised_sys_reg(vcpu, reg)			\
+	({						\
+		u64 __val;				\
+		__val = __vcpu_sys_reg(vcpu, reg);	\
+		__val &= ~__ ## reg ## _RES0;		\
+		(__val);				\
+	})
+
 bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 {
 	union trap_config tc;
 	enum trap_behaviour b;
 	bool is_read;
 	u32 sysreg;
-	u64 esr;
+	u64 esr, val;
 
 	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
 		return false;
@@ -1085,6 +1156,19 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	if (!tc.val)
 		return false;
 
+	switch ((enum fgt_group_id)tc.fgt) {
+	case __NO_FGT_GROUP__:
+		break;
+
+	case __NR_FGT_GROUP_IDS__:
+		/* Something is really wrong, bail out */
+		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
+		return false;
+	}
+
+	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
+		goto inject;
+
 	b = compute_trap_behaviour(vcpu, tc);
 
 	if (((b & BEHAVE_FORWARD_READ) && is_read) ||
-- 
2.34.1

