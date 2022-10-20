Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D084E6061DF
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiJTNjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiJTNjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973091A6528
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F74B82661
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8374C4347C;
        Thu, 20 Oct 2022 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273150;
        bh=D98B/XDbjtjpYvc3FakwRJPTw+9knWIZ7Q7ABfJdGtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sveL7bSVV6fgDU1Qxv24cr21wuyTIl67rfjVLsSfFP2mfdLHciGuOCZh0YxTJq5Fo
         8Bq2U3z+AQKnaVLZhVn4SE0vg813pSvGbroq2CPyst9km3H/0c6iQdvxpBKp/YW4xO
         LEoNqdLppYI0qpmn0sTN6ZmnzCKF6w8FzKFPWeB5v05O2Jb4RV5I2RjwRaw1M31liQ
         7X0IMqmpp/F0TV9uocfd5Qn9Qp2JYtNMeI5pJ3/8mNCGVcFXgzJQM2HM9IobP4jTRG
         7XkHd66SGh6n1gWsdUCieTKL9DPVQuQ+TQ+sYUJBzBFyd9PYzGCJssipJ7RoFIL0xS
         e3WiQc8DiD8qQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 09/25] KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
Date:   Thu, 20 Oct 2022 14:38:11 +0100
Message-Id: <20221020133827.5541-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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

