Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE79600E2E
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiJQLxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiJQLw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC881570E
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D823D6108F
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B2AC4347C;
        Mon, 17 Oct 2022 11:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007574;
        bh=8f0p130EJ4EPgnQoABkRw1xEzbZ5piYUHc7zA8Cjng4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njjAERXRRVn2n0XAb9kvgVw45DF4V7i3juqdjfan5ZZTzWOGrsuSQrQQfFcUbNUVn
         DXhc1SwRb7l9UofUcZ2gZ6RE7uM+wFzM8cZJ6xronCMSBJw2tQ8o+Fdv3SYrkZ1YU/
         sSlKW76kS52sNpC2gW1t5sA2DnOmEycOrZ2jxo1y/z8uKWlBdWSQKJRyBXaU8PCo/F
         Okz1zRIQYhR38oAABLD/3dHKl6/NnXCoTxIBNm7wRrUHn5Lf7Lke7YeIQjfe28R8fC
         Tx46VWk+db9taIiwNmrqAayGRXsXI1uX4YpZNTN57QHu+SCD0v1XO+/4nSA7LGba4c
         JFFKfvgfg3i/Q==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
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
Subject: [PATCH v4 09/25] KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
Date:   Mon, 17 Oct 2022 12:51:53 +0100
Message-Id: <20221017115209.2099-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nvhe/mem_protect.h refers to __load_stage2() in the definition of
__load_host_stage2() but doesn't include the relevant header.

Include asm/kvm_mmu.h in nvhe/mem_protect.h so that users of the latter
don't have to do this themselves.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
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
2.38.0.413.g74048e4d9e-goog

