Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298CB52D45D
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiESNnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiESNmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A874C3EF0A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3967E617A2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31739C34116;
        Thu, 19 May 2022 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967756;
        bh=a1MY3h8a9S0aqHMlLAuerB2YDvdA2T/4rKK2cTmBIjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc3H0+shhVFHwPMvinJmw9KbK6Wd7pCcy7vGlnghkhkcYdvjkbWike3yQLEVQW/Zd
         +xTv76VIhV8wzancT/VpPkQSaRc2hPgeEq+DEzIRWp1qNVZJKC2X+vguZgJsgt5K4N
         RuW1gVyHFNT5pPzS9EeXBzHZLgm+tTodQLi4iY7ykFYqazZZNg3ezntCT+VMph2EVq
         6D5ndeU/zh68orEiPXpJ68UrZmixn3sj/sk82MlJl1T7SLL78GZNXWs3X2mQMbGBKL
         ddi+x9x7ms5SyBzeyRNknIwAUS90I+I7CMPUxFTJklU8O5St8Go29zvFMWEWS0hhtV
         /MGeeBdpnzACw==
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
Subject: [PATCH 03/89] KVM: arm64: Return error from kvm_arch_init_vm() on allocation failure
Date:   Thu, 19 May 2022 14:40:38 +0100
Message-Id: <20220519134204.5379-4-will@kernel.org>
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

If we fail to allocate the 'supported_cpus' cpumask in kvm_arch_init_vm()
then be sure to return -ENOMEM instead of success (0) on the failure
path.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..775b52871b51 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -146,8 +146,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
-	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
+		ret = -ENOMEM;
 		goto out_free_stage2_pgd;
+	}
 	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
 
 	kvm_vgic_early_init(kvm);
-- 
2.36.1.124.g0e6072fb45-goog

