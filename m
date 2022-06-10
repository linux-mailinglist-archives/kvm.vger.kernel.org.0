Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D606546294
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347417AbiFJJfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346650AbiFJJfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAE119C29
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40EB5B83354
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5751C34114;
        Fri, 10 Jun 2022 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853735;
        bh=ErpX+RM4dDI/TGveq0+Tk6YUv51bo2psubFmJTZaCJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpLFw8vcQqSPhFYCfYBzaw1DXEH4Sl/1CGiaa8IPoEe2mHY29cKrg1O8u/cC9G3HU
         fuF7+UZofnQWCEEHqN7krmMfJNoKeVBLiyRD7bszh0Yues66cZombwv51H1yWyJa8J
         c3v97ufSrQmEG92SYgIPm1T4ivyD58iK0JOEbqR+qToC2H+/Ct2JplJ8ph7azpUkbb
         M+U6hxpFQtTKf9Cf99cp3yiXSSxP9jDzjfSUDMfFCdcRgN3+CfomMFOWrw5iNw0D0O
         qE0rGZJ0nktNWqs0ObSa6La9XRzXLArGFYnfJnAuXp0vbFF9sme8WEz+aa3lrOiai+
         kRIk/xhfUgJYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawq-00H6Dt-VZ; Fri, 10 Jun 2022 10:28:57 +0100
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
Subject: [PATCH v2 13/19] KVM: arm64: Kill unused vcpu flags field
Date:   Fri, 10 Jun 2022 10:28:32 +0100
Message-Id: <20220610092838.1205755-14-maz@kernel.org>
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

Horray, we have now sorted all the preexisting flags, and the
'flags' field is now unused. Get rid of it while nobody is
looking.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0fb1a5b86f16..39da28f85045 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -332,9 +332,6 @@ struct kvm_vcpu_arch {
 		FP_STATE_GUEST_OWNED,
 	} fp_state;
 
-	/* Miscellaneous vcpu state flags */
-	u64 flags;
-
 	/* Configuration flags, set once and for all before the vcpu can run */
 	u64 cflags;
 
-- 
2.34.1

