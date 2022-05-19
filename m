Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C1852D4DA
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbiESNrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbiESNqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10C22CE02
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DE15B824A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E56C36AE3;
        Thu, 19 May 2022 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967979;
        bh=B36GaRnGRujL+MHDMxoxbcIaaln4Kn+Z0GYJ4GdQl5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/cD/rpj+xe2AzYsja4gh8SJLDatcI9W6clm8PO0qstElAz/8qaq/DJmS1qfFiyTY
         SZ9d5rK+4KSZ4MdWaFdgHMlZNyBQl71XC/ZhqBRJJyZSjEfNWhRBIE4rsHV//YJqly
         agcpCwUC+8yYKpN63DB5DpNsWYIi+UH/rQ+M7vtGVMG8hjgwCK2vhWMw63Ubq+d7B1
         gEdDkdBYB4AOvMBe05r2ST2rPp+sbdisS3rQVDf+AZpNh99DNpB1Gyw6u/JLuCyWxB
         9SDet6wxT1EHJtRAV8toHQMYWGxDr4IhOezHOipLbuA2xYvILtTSCNwiMvCQftzW+8
         dTtLc1xekzv5A==
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
Subject: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
Date:   Thu, 19 May 2022 14:41:34 +0100
Message-Id: <20220519134204.5379-60-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Return an error (-EINVAL) if trying to enable MTE on a protected
vm.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 10e036bf06e3..8a1b4ba1dfa7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
+		if (!system_supports_mte() ||
+		    kvm_vm_is_protected(kvm) ||
+		    kvm->created_vcpus) {
 			r = -EINVAL;
 		} else {
 			r = 0;
-- 
2.36.1.124.g0e6072fb45-goog

