Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26457546247
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbiFJJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347871AbiFJJaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:30:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2F14AA5A
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60FB161ED8
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D20C341C4;
        Fri, 10 Jun 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853336;
        bh=P3Qxslc70t7szyihyigEdSCT8f++FwiYBUbMe+9p1Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=repJdJP+3B+b4bA+4zepxK2ntoRGYJnX4W1cq5592Se+BAcPe+M0tggogGKF/p1FL
         C8e6G1C8h9VZbNqFiLL/NfbAj42KpntD+4b1kwaHN6TnDChgwtmArV7agqoAnU7CCO
         RXSvCDxOC24XGlOZD6+4eZ/FyJAnMLHppDC76DoN7NYCF8WmQrrcXpZIkknd5kdJCv
         pdyl6qIrYEpLmy9lefGhHW5kEbrk+2U5Inf4mo9UDf4AQBeVnZPKd7l/dzZT271HUb
         MNBMSP/ksmpbT/sLPufrhHyF1FD3cBfsxyakpFL9mEqhsqiFsNxqJq23RjyjbFwsmE
         chzQLvXz9RfNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawo-00H6Dt-U1; Fri, 10 Jun 2022 10:28:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 05/19] KVM: arm64: Add helpers to manipulate vcpu flags among a set
Date:   Fri, 10 Jun 2022 10:28:24 +0100
Message-Id: <20220610092838.1205755-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/include/asm/kvm_host.h | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 372c5642cfab..6d30ac7e3164 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -415,6 +415,50 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+/*
+ * Each 'flag' is composed of a comma-separated triplet:
+ *
+ * - the flag-set it belongs to in the vcpu->arch structure
+ * - the value for that flag
+ * - the mask for that flag
+ *
+ *  __vcpu_single_flag() builds such a triplet for a single-bit flag.
+ * unpack_vcpu_flag() extract the flag value from the triplet for
+ * direct use outside of the flag accessors.
+ */
+#define __vcpu_single_flag(_set, _f)	_set, (_f), (_f)
+
+#define __unpack_flag(_set, _f, _m)	_f
+#define unpack_vcpu_flag(...)		__unpack_flag(__VA_ARGS__)
+
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
+#define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
+#define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
+#define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
+
+
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
-- 
2.34.1

