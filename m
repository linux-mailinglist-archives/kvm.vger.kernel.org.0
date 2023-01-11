Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140EA6661B6
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbjAKRVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbjAKRVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:21:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FC8321B2;
        Wed, 11 Jan 2023 09:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9786B81B79;
        Wed, 11 Jan 2023 17:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B50C433D2;
        Wed, 11 Jan 2023 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457682;
        bh=iakCU13SXpMb3pcvjfiiLXGeB5RnCPEYfg/spzK7YxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyqAUwJGdNtBpzR4nntbs1iPUTkBKiOHAmXK9MifYRWMELikATG4WriMLqpDgxpov
         cHYLSZFLH9EHn+oPMBvxgIhq8JwB69mMxlGzCWFVKKq5oUvR6NH/KoHX0MPpkBDaQu
         j4Z0J//elt3BJwT1UORJJ0DODp8Jh2NMZOlPbOeTRciGJfooU/7fF3FQLKz3+7BxtO
         YHcf4fCfc5HvTlUc8IQlW1PW5Nemzwft1lPPwWrdHYdLhltZif8x69g+9WgKM0ezE+
         kjAConnZz54KiT8BYnQ/k4YcSufpdk1aw3s3x0HWqArA+muds8k8lw81cVsfeS4DLU
         XT5HZ9ozU1fdg==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH v3 12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
Date:   Thu, 12 Jan 2023 01:10:26 +0800
Message-Id: <20230111171027.2392-13-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230111171027.2392-1-jszhang@kernel.org>
References: <20230111171027.2392-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <ajones@ventanamicro.com>

Switch has_svinval() from static branch to the new helper
riscv_has_extension_unlikely().

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
---
 arch/riscv/kvm/tlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 309d79b3e5cd..aa3da18ad873 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -15,8 +15,7 @@
 #include <asm/hwcap.h>
 #include <asm/insn-def.h>
 
-#define has_svinval()	\
-	static_branch_unlikely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_SVINVAL])
+#define has_svinval()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVINVAL)
 
 void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
 					  gpa_t gpa, gpa_t gpsz,
-- 
2.38.1

