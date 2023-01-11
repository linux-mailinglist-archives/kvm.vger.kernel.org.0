Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A566661AB
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbjAKRVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235919AbjAKRVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:21:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A25E1573A;
        Wed, 11 Jan 2023 09:21:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B04ACB81C8A;
        Wed, 11 Jan 2023 17:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC636C433EF;
        Wed, 11 Jan 2023 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457663;
        bh=mINO93PYoIl2Le02IWiuk8J2800U31qq9j/6NT8h4Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8O0/kRMnkMh6I08+s4abnchp7uRi0Y69jnQCXoxMYVSjkHdoUObVkpuPS/Z7FlJo
         N+cevInTRe40SvOKdCAWROfrbl7JT4HHuaMZI3kHcF1gnr8UTAi5Gx2i0RRmXvKyWp
         iY65QJ4r30iOqO9EQbCBX0Ukaljf+s22gwj/O59SJcReuTyzkhpDBSeOeLc5ICa+Oi
         vjn27YoSkrZpu8XZWnWA2pmmwPxP4zSrjt3FvnIyCPuaGHA07jW9pF6iLAFBN8xVx3
         TDQwRCSfekPthJawpjziENNYx3+6fkIrq9e5PzrTz/xSlS1zdpcuyz8Muflrrt6+fW
         iqnfyjvrjMFIQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 06/13] riscv: introduce riscv_has_extension_[un]likely()
Date:   Thu, 12 Jan 2023 01:10:20 +0800
Message-Id: <20230111171027.2392-7-jszhang@kernel.org>
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

Generally, riscv ISA extensions are fixed for any specific hardware
platform, so a hart's features won't change after booting. This
chacteristic makes it straightforward to use a static branch to check
if a specific ISA extension is supported or not to optimize
performance.

However, some ISA extensions such as SVPBMT and ZICBOM are handled
via. the alternative sequences.

Basically, for ease of maintenance, we prefer to use static branches
in C code, but recently, Samuel found that the static branch usage in
cpu_relax() breaks building with CONFIG_CC_OPTIMIZE_FOR_SIZE[1]. As
Samuel pointed out, "Having a static branch in cpu_relax() is
problematic because that function is widely inlined, including in some
quite complex functions like in the VDSO. A quick measurement shows
this static branch is responsible by itself for around 40% of the jump
table."

Samuel's findings pointed out one of a few downsides of static branches
usage in C code to handle ISA extensions detected at boot time:
static branch's metadata in the __jump_table section, which is not
discarded after ISA extensions are finalized, wastes some space.

I want to try to solve the issue for all possible dynamic handling of
ISA extensions at boot time. Inspired by Mark[2], this patch introduces
riscv_has_extension_*() helpers, which work like static branches but
are patched using alternatives, thus the metadata can be freed after
patching.

Link: https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@sholland.org/ [1]
Link: https://lore.kernel.org/linux-arm-kernel/20220912162210.3626215-8-mark.rutland@arm.com/ [2]
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/hwcap.h | 37 ++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 09a7767723f6..1767a9ce1a04 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_RISCV_HWCAP_H
 #define _ASM_RISCV_HWCAP_H
 
+#include <asm/alternative-macros.h>
 #include <asm/errno.h>
 #include <linux/bits.h>
 #include <uapi/asm/hwcap.h>
@@ -97,6 +98,42 @@ static __always_inline int riscv_isa_ext2key(int num)
 	}
 }
 
+static __always_inline bool
+riscv_has_extension_likely(const unsigned long ext)
+{
+	compiletime_assert(ext < RISCV_ISA_EXT_MAX,
+			   "ext must be < RISCV_ISA_EXT_MAX");
+
+	asm_volatile_goto(
+	ALTERNATIVE("j	%l[l_no]", "nop", 0, %[ext], 1)
+	:
+	: [ext] "i" (ext)
+	:
+	: l_no);
+
+	return true;
+l_no:
+	return false;
+}
+
+static __always_inline bool
+riscv_has_extension_unlikely(const unsigned long ext)
+{
+	compiletime_assert(ext < RISCV_ISA_EXT_MAX,
+			   "ext must be < RISCV_ISA_EXT_MAX");
+
+	asm_volatile_goto(
+	ALTERNATIVE("nop", "j	%l[l_yes]", 0, %[ext], 1)
+	:
+	: [ext] "i" (ext)
+	:
+	: l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
 unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
 
 #define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
-- 
2.38.1

