Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB7352D4E8
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiESNrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238941AbiESNq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D155141FBC
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA8E617CB
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A424CC385AA;
        Thu, 19 May 2022 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967999;
        bh=ykWIkC/B0e9kSshvdCfgGdw5lw0ICxc/NqaNlHqBpS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8HYojTSxMlrrGKq7Yb57Pih7CxPJahzenwHlNqXjii2CspaJWdBeQnPSfIWbAL0H
         H0Sxdhyh+1uCPzcskuvc2ktDETJgRSohx1uZMaZsx7D6vixCUpQNsQ34fDquJ5EN0n
         2jjA9AcGAdmu91H75D+WpWsthclh+zUAqLlCFKnogsMiSCAFfPZG6OzgjR8VbMHF9D
         9+UoMXUGEhwH1/bEcGRnAwrgQ6s11InLEaPBsltjyAFlT+u/X8iMZM6DSRPbtPg+z/
         jcgoMl9xbOwz1K+SbLiSSdWz3JL+B7Z9kK+U864SDAjN2D0MKR0ab7S3yOfm5kplCc
         Ssmdi4fsmyCDw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 64/89] KVM: arm64: Advertise GICv3 sysreg interface to protected guests
Date:   Thu, 19 May 2022 14:41:39 +0100
Message-Id: <20220519134204.5379-65-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advertise the system register GICv3 CPU interface to protected guests
as that is the only supported configuration under pKVM.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 6f13f62558dd..062ae2ffbdfb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -43,11 +43,13 @@ void kvm_shadow_destroy(struct kvm *kvm);
 /*
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
+ * - GICv3(+) system register interface
  * - Data Independent Timing
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_GIC) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_DIT) \
 	)
 
-- 
2.36.1.124.g0e6072fb45-goog

