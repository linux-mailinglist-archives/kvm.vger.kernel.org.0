Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85681546295
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346678AbiFJJfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348646AbiFJJfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38412215
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB075B83355
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C7DC34114;
        Fri, 10 Jun 2022 09:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853741;
        bh=Hy44ebNJtdRyimKZ0wHSwqsYAjTWcKc/GaO9BGQt+IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNRMoinxrv8cCVH6ckQlh6bO6wu08NptrV2+KQU5zwQgQbIaZHTwZ+T2rvno+lQBk
         7ZrbiVH8zRilig5kXhd8FxZT+LsXLi96I5bRpd0XJ8A6mfxKEPcv7UsNim9eurJmxG
         nOPgtRag4pOeERMnLVwcr8205DMQXpoDGvEBlOpfNFTlunHZjB5fXnxXp1lYreQT2L
         7hPiFPyYQmZNBKqdvawNGqBOoVlqcJf4+7pr13u6oK1/Zna7Ipg22PP2qRhy7Z3+6L
         AxM9G30f0Vj/tUOWNSZgakU/yNXLAWSvjDDviHUEwCr/qD7Y8IEfDzY1j0vaIFqwaV
         ppdlhgHac4gJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawr-00H6Dt-Nl; Fri, 10 Jun 2022 10:28:57 +0100
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
Subject: [PATCH v2 16/19] KVM: arm64: Add build-time sanity checks for flags
Date:   Fri, 10 Jun 2022 10:28:35 +0100
Message-Id: <20220610092838.1205755-17-maz@kernel.org>
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

Flags are great, but flags can also be dangerous: it is easy
to encode a flag that is bigger than its container (unless the
container is a u64), and it is easy to construct a flag value
that doesn't fit in the mask that is associated with it.

Add a couple of build-time sanity checks that ensure we catch
these two cases.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ffbeb5f5692e..6a37018f40b7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -433,8 +433,20 @@ struct kvm_vcpu_arch {
 #define __unpack_flag(_set, _f, _m)	_f
 #define unpack_vcpu_flag(...)		__unpack_flag(__VA_ARGS__)
 
+#define __build_check_flag(v, flagset, f, m)			\
+	do {							\
+		typeof(v->arch.flagset) *_fset;			\
+								\
+		/* Check that the flags fit in the mask */	\
+		BUILD_BUG_ON(HWEIGHT(m) != HWEIGHT((f) | (m)));	\
+		/* Check that the flags fit in the type */	\
+		BUILD_BUG_ON((sizeof(*_fset) * 8) <= __fls(m));	\
+	} while (0)
+
 #define __vcpu_get_flag(v, flagset, f, m)			\
 	({							\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		v->arch.flagset & (m);				\
 	})
 
@@ -442,6 +454,8 @@ struct kvm_vcpu_arch {
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
 								\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		fset = &v->arch.flagset;			\
 		if (HWEIGHT(m) > 1)				\
 			*fset &= ~(m);				\
@@ -452,6 +466,8 @@ struct kvm_vcpu_arch {
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
 								\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		fset = &v->arch.flagset;			\
 		*fset &= ~(m);					\
 	} while (0)
-- 
2.34.1

