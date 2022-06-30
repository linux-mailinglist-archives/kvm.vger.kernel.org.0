Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C05561D24
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbiF3OOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiF3ONn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AC25F9B
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 657B4B82AF3
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C0C341CC;
        Thu, 30 Jun 2022 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597561;
        bh=DH4XkNsCYymvyFFe0cqjxw8F+dRDDN7dxIqHUgu9Es4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvUE8ibucs56/VWPU1IyQq6UG+YPaYp0zR5VS/L6/WhF9tPYSNWt21rkEtK79gFS/
         v4TM6cQYKOAumjALEACmh2hZyWIGlujxURTD/IVouxJdQvPrR13jkFtm5yl9gPAzaE
         W2J7qOx6xJIiXXsdVF1nHykwshxcschFKY32CVBXj9mx/W916W9ykHJXRzUG6OArWR
         3bdVYUvgwb7wzf6RMjderkEx5fdMSKMntTRwzCVHLbrUR0TUFLrqGHVl1dPVO81O35
         EyIwFFKUpPpYzQW7SyknMIOccp3us1sByT027FOsMtNAA4BkqHDsmrxOgfRH3SiFtj
         /4lIWf2EzaeNA==
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
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 22/24] KVM: arm64: Explicitly map kvm_vgic_global_state at EL2
Date:   Thu, 30 Jun 2022 14:57:45 +0100
Message-Id: <20220630135747.26983-23-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The pkvm hypervisor may need to read the kvm_vgic_global_state variable
at EL2. Make sure to explicitly map it in its stage-1 page-table rather
than relying on mapping all of the host .rodata section.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 3f689ffb2693..fa06828899e1 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -161,6 +161,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	ret = pkvm_create_mappings(&kvm_vgic_global_state,
+				   &kvm_vgic_global_state + 1, prot);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

