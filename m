Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FFE74A266
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjGFQom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjGFQok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:44:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4900A1730;
        Thu,  6 Jul 2023 09:44:33 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E1AAD228CC;
        Thu,  6 Jul 2023 16:44:31 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 5FC671058F9;
        Thu,  6 Jul 2023 16:36:18 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: kvm: Fix build error with KVM_MIPS_DEBUG_COP0_COUNTERS enabled
Date:   Thu,  6 Jul 2023 18:36:10 +0200
Message-Id: <20230706163610.106938-1-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference") missed
converting one place accessing cop0 registers, which results in a build
error, if KVM_MIPS_DEBUG_COP0_COUNTERS is enabled.

Fixes: e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/kvm/stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/stats.c b/arch/mips/kvm/stats.c
index 53f851a61554..3e6682018fbe 100644
--- a/arch/mips/kvm/stats.c
+++ b/arch/mips/kvm/stats.c
@@ -54,9 +54,9 @@ void kvm_mips_dump_stats(struct kvm_vcpu *vcpu)
 	kvm_info("\nKVM VCPU[%d] COP0 Access Profile:\n", vcpu->vcpu_id);
 	for (i = 0; i < N_MIPS_COPROC_REGS; i++) {
 		for (j = 0; j < N_MIPS_COPROC_SEL; j++) {
-			if (vcpu->arch.cop0->stat[i][j])
+			if (vcpu->arch.cop0.stat[i][j])
 				kvm_info("%s[%d]: %lu\n", kvm_cop0_str[i], j,
-					 vcpu->arch.cop0->stat[i][j]);
+					 vcpu->arch.cop0.stat[i][j]);
 		}
 	}
 #endif
-- 
2.35.3

