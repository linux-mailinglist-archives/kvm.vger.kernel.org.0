Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6067F9EE
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 18:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbjA1Rj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 12:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjA1Rj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 12:39:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657222C67A;
        Sat, 28 Jan 2023 09:39:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C7ABB80B76;
        Sat, 28 Jan 2023 17:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA35C433D2;
        Sat, 28 Jan 2023 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674927563;
        bh=ruMajGKo9fKh9qOX5EAiUg1Bz+Tnu4CuwV/123f8+VE=;
        h=From:To:Cc:Subject:Date:From;
        b=KFEIwgcKA0ItOFr9Jav08fn/1KjGY9hZJyrFbsFlkCGfgFk5R34kLozx0eieYz0IJ
         ywR2AIAM4mAyw2+www4puC/dPy745T0vvZDR29/mOhXgIZQVRffWMcx75ttHocXtOZ
         MoqRzE9Fja33O3giu9EqkqhJDtlj53NadIGN9HSLEy667Nq3v52yjYZr92MXI/y0ON
         bZNVbcMmtx1t7A/Popt7loN93KtmO7JFjmco/bejkJTN8MWidfiKZyJhZXip2T9pi+
         LSOTiFRZhA6P90HsqWvs+Pyin8upNpHjt+/2pIkHHURFSIBXCQcgmcNMhJmF36woYb
         myTqctgp9FYdQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Date:   Sun, 29 Jan 2023 01:28:43 +0800
Message-Id: <20230128172856.3814-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, riscv ISA extensions are fixed for any specific hardware
platform, so a hart's features won't change after booting, this
chacteristic makes it straightforward to use a static branch to check
a specific ISA extension is supported or not to optimize performance.

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


Since v4
 - collect Reviewed-by and Acked-by tag
 - rebase on the latest riscv for-next
 - add Andrew's patch to add ADD16 and SUB16 rela types
 - adopt Conor's nit comment to patch9

Since v3
 - collect Reviewed-by tag and remove Heiko's reviewed-by from patch5
 - address Conor and Andrew comments
 - fix two building errors of !MMU and RV32 

Since v2
 - rebase on riscv-next
 - collect Reviewed-by tag
 - fix jal imm construction
 - combine Heiko's code and my code for jal patching, thus add
   Co-developed-by tag
 - address comments from Conor

Since v1
 - rebase on v6.1-rc7 + Heiko's alternative improvements[3]
 - collect Reviewed-by tag
 - add one patch to update jal offsets in patched alternatives
 - add one patch to switch to relative alternative entries
 - add patches to patch vdso

[1]https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@sholland.org/
[2]https://lore.kernel.org/linux-arm-kernel/20220912162210.3626215-8-mark.rutland@arm.com/
[3]https://lore.kernel.org/linux-riscv/20221130225614.1594256-1-heiko@sntech.de/



Andrew Jones (2):
  riscv: module: Add ADD16 and SUB16 rela types
  riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()

Jisheng Zhang (11):
  riscv: move riscv_noncoherent_supported() out of ZICBOM probe
  riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
  riscv: hwcap: make ISA extension ids can be used in asm
  riscv: cpufeature: extend riscv_cpufeature_patch_func to all ISA
    extensions
  riscv: introduce riscv_has_extension_[un]likely()
  riscv: fpu: switch has_fpu() to riscv_has_extension_likely()
  riscv: module: move find_section to module.h
  riscv: switch to relative alternative entries
  riscv: alternative: patch alternatives in the vDSO
  riscv: cpu_relax: switch to riscv_has_extension_likely()
  riscv: remove riscv_isa_ext_keys[] array and related usage

 arch/riscv/errata/sifive/errata.c           |  3 +-
 arch/riscv/errata/thead/errata.c            | 11 ++-
 arch/riscv/include/asm/alternative-macros.h | 20 ++---
 arch/riscv/include/asm/alternative.h        | 17 ++--
 arch/riscv/include/asm/errata_list.h        |  9 +-
 arch/riscv/include/asm/hwcap.h              | 98 +++++++++++----------
 arch/riscv/include/asm/module.h             | 16 ++++
 arch/riscv/include/asm/switch_to.h          |  3 +-
 arch/riscv/include/asm/vdso.h               |  4 +
 arch/riscv/include/asm/vdso/processor.h     |  2 +-
 arch/riscv/kernel/alternative.c             | 29 ++++++
 arch/riscv/kernel/cpufeature.c              | 79 +++--------------
 arch/riscv/kernel/module.c                  | 31 +++----
 arch/riscv/kernel/setup.c                   |  3 +
 arch/riscv/kernel/vdso.c                    |  5 --
 arch/riscv/kernel/vdso/vdso.lds.S           |  7 ++
 arch/riscv/kvm/tlb.c                        |  3 +-
 17 files changed, 176 insertions(+), 164 deletions(-)

-- 
2.38.1

