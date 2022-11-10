Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F99624A1E
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKJTDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiKJTDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:03:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FC413D34
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A7AA61E13
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796D1C433B5;
        Thu, 10 Nov 2022 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107021;
        bh=QQWrljJUDPTW8Fqhy1sB16bt5Z2ZLpBG0A9XOoNLh/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMcBNOrY4P3xGXPNhtA8x67PVzfmG37qIV8PWNH0z1+8baXtmidv/hFqKDTpsHqJQ
         Rb9z1B3Nq4iVDdDo8Nlmg1vHD0PLGVpY0m/H3nBSLQfYuBtcxq2an+qq/jVlSs//C4
         9rggPoID5+9J7+Gvp4sQiYEmdsykAZOMYSctTpy+gmlzIGmmdsHljyVkGeCYwbmstG
         NrKw78fzU84AxgrucvqoMaC2a2UEJiKpUdWup2Al1SGIs9rfSiOPMToA9nWbuA3PHp
         CVPagrEpiAky9432Isyk6QKeFlMuKMMi+CfirrFMnho9lreTrsqmFqDNzYhS+/fMaf
         Dxyqebz4q7tkw==
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
Subject: [PATCH v6 09/26] KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
Date:   Thu, 10 Nov 2022 19:02:42 +0000
Message-Id: <20221110190259.26861-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.38.1.431.g37b22c650d-goog

