Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7AF5B8304
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiINIgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiINIfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978BC1C937
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6754B81670
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC8BC43470;
        Wed, 14 Sep 2022 08:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144541;
        bh=WjDSl2IWwcr7W+r8QvB3Qm7fgtYs/dW3NUchy/iPukU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5yRJAWYwZmcV97CvysUfSOedMWUZ1XWAxuHan+88ij9QWZJknORjd6SckjhjvCMK
         zF58tQqIqKtPiqhED+CYo79PLaE/j4ZnrB21SzMqZSFc9nOccEi1oVAx2K4nAYpQMC
         GIne3wG/+U5XN3Cf7VDS5CpwWroD4oxT9J9RlojEl8sWURCmU3jEPcCH/R60evkvC3
         O6DQlMWmAZVjChjm7ppT81FuucRsxWI5vlktpEbZFiK2xCO1DvNjK953MYJNSBKjoa
         zGz1GUcCNREfV1lus6iqJwELVtOhol2lz+p0kE/I8iUif/nIlEMKVXpBw+FuLTlj5s
         rn8e5Og4Y5wkw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 09/25] KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
Date:   Wed, 14 Sep 2022 09:34:44 +0100
Message-Id: <20220914083500.5118-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nvhe/mem_protect.h refers to __load_stage2() in the definition of
__load_host_stage2() but doesn't include the relevant header.

Include asm/kvm_mmu.h in nvhe/mem_protect.h so that users of the latter
don't have to do this themselves.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 998bf165af71..3bea816296dc 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -8,6 +8,7 @@
 #define __KVM_NVHE_MEM_PROTECT__
 #include <linux/kvm_host.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
 #include <nvhe/spinlock.h>
-- 
2.37.2.789.g6183377224-goog

