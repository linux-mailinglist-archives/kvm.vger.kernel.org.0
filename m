Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932CE536C95
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiE1Liv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiE1Lik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:38:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E29167FA
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D934CE1C46
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C726C341C0;
        Sat, 28 May 2022 11:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653737916;
        bh=p0/Z96QLuUnjfzpou5qfF4Pu/aafkp4ZE/VEpJVwk5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBOqe5zvN52Cu5/QJHxRVD+vRlT6ywEpOq4NwfDr+LULL5HPZnLcN0NlOwmuP1Gyr
         Qe18h4wkcKBP1M2rUGaT85JhM//vLYyP0QywKwEdoGKouOybBuSwCp67iusGT84Hnm
         tsQxAn79plOdvGrk5XIB08IpQWVrptzoJoQ21XEJKiK7qdG8sA3NuNTRb24+FrmhIE
         +bcSYZAuLAICWR5OfMb1Sb1doXeUPT1EEyDdLzxdOjh5me6ujcpbkTdabYHlpzgG8M
         wci+6M/XsuCzDzVhzWnsjVheyzyrekU7QvzxRJ4KiUB0Rmq07io7N2EX+cZnAo92LX
         8dC+BnL8yjjgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumA-00EEGh-Ix; Sat, 28 May 2022 12:38:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 05/18] KVM: arm64: Add helpers to manipulate vcpu flags among a set
Date:   Sat, 28 May 2022 12:38:15 +0100
Message-Id: <20220528113829.1043361-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Careful analysis of the vcpu flags show that this is a mix of
configuration, communication between the host and the hypervisor,
as well as anciliary state that has no consistency. It'd be a lot
better if we could split these flags into consistent categories.

However, even if we split these flags apart, we want to make sure
that each flag can only be applied to its own set, and not across
sets.

To achieve this, use a preprocessor hack so that each flag is always
associated with:

- the set that contains it,

- a mask that describe all the bits that contain it (for a simple
  flag, this is the same thing as the flag itself, but we will
  eventually have values that cover multiple bits at once).

Each flag is thus a triplet that is not directly usable as a value,
but used by three helpers that allow the flag to be set, cleared,
and fetched. By mandating the use of such helper, we can easily
enforce that a flag can only be used with the set it belongs to.

Finally, one last helper "unpacks" the raw value from the triplet
that represents a flag, which is useful for multi-bit values that
need to be enumerated (in a switch statement, for example).

Further patches will start making use of this infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a46f952b97f6..5eb6791df608 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -418,6 +418,39 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+#define __vcpu_get_flag(v, flagset, f, m)			\
+	({							\
+		v->arch.flagset & (m);				\
+	})
+
+#define __vcpu_set_flag(v, flagset, f, m)			\
+	do {							\
+		typeof(v->arch.flagset) *fset;			\
+								\
+		fset = &v->arch.flagset;			\
+		if (HWEIGHT(m) > 1)				\
+			*fset &= ~(m);				\
+		*fset |= (f);					\
+	} while (0)
+
+#define __vcpu_clear_flag(v, flagset, f, m)			\
+	do {							\
+		typeof(v->arch.flagset) *fset;			\
+								\
+		fset = &v->arch.flagset;			\
+		*fset &= ~(m);					\
+	} while (0)
+
+#define vcpu_get_flag(v, ...)	__vcpu_get_flag(v, __VA_ARGS__)
+#define vcpu_set_flag(v, ...)	__vcpu_set_flag(v, __VA_ARGS__)
+#define vcpu_clear_flag(v, ...)	__vcpu_clear_flag(v, __VA_ARGS__)
+
+#define __vcpu_single_flag(_set, _f)	_set, (_f), (_f)
+
+#define __flag_unpack(_set, _f, _m)	_f
+#define vcpu_flag_unpack(...)		__flag_unpack(__VA_ARGS__)
+
+
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
-- 
2.34.1

