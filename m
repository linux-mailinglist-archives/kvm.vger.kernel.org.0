Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4A6641E5A
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiLDR4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiLDR4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:56:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FE4140D0;
        Sun,  4 Dec 2022 09:56:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2956560EDD;
        Sun,  4 Dec 2022 17:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449FEC433D7;
        Sun,  4 Dec 2022 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176588;
        bh=pXsh8SVW/sBp/P3v6mc5bVyqy/bCl/0yI5e+z8DIwis=;
        h=From:To:Cc:Subject:Date:From;
        b=tQtG9KFpqkqGYmeGkTRbDw7dFD2tA0xqcHOa0rvlzLlRNlTklMnnb7Hra23zr673O
         UCxXyY7ZxAa3ZBtBTYDJeszodPtvzxBSViHCAcKhduKrmfuYT1ucDpKIVxQQLWlZPd
         /9Fa9kenqy3+BcN/nvOQNhPzOqI6CW+73bWJsAwuB7sTGorl3ggYWGdz+JXhI2Ut44
         NUveSgkXxxfHMYikHN1Kj5TUi2lieXGxvSO2FtsArZzbtAzrh056c/CR3gkcp3n0T2
         DFgdkDRbbkub+pvLLVU2PtGrbkQl2iXvvfC71aTAThHCKS9kwApzekms9ahM4gjg7T
         Cf803DYekHhSw==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 00/13] riscv: improve boot time isa extensions handling
Date:   Mon,  5 Dec 2022 01:46:19 +0800
Message-Id: <20221204174632.3677-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.37.2
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
platform, that's to say, the hart features won't change any more
after booting, this chacteristic make it straightforward to use
static branch to check one specific ISA extension is supported or not
to optimize performance.

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

Since v1
 - rebase on v6.1-rc7 + Heiko's alternative improvements[3]
 - collect Reviewed-by tag
 - add one patch to update jal offsets in patched alternatives
 - add one patch to switch to relative alternative entries
 - add patches to patch vdso

[1]https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@sholland.org/
[2]https://lore.kernel.org/linux-arm-kernel/20220912162210.3626215-8-mark.rutland@arm.com/
[3]https://lore.kernel.org/linux-riscv/20221130225614.1594256-1-heiko@sntech.de/


Andrew Jones (1):
  riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()

Jisheng Zhang (12):
  riscv: fix jal offsets in patched alternatives
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

 arch/riscv/errata/sifive/errata.c           |  4 +-
 arch/riscv/errata/thead/errata.c            | 11 ++-
 arch/riscv/include/asm/alternative-macros.h | 20 ++---
 arch/riscv/include/asm/alternative.h        | 14 +--
 arch/riscv/include/asm/errata_list.h        |  9 +-
 arch/riscv/include/asm/hwcap.h              | 96 +++++++++++----------
 arch/riscv/include/asm/module.h             | 15 ++++
 arch/riscv/include/asm/switch_to.h          |  3 +-
 arch/riscv/include/asm/vdso.h               |  4 +
 arch/riscv/include/asm/vdso/processor.h     |  2 +-
 arch/riscv/kernel/alternative.c             | 63 ++++++++++++++
 arch/riscv/kernel/cpufeature.c              | 82 +++---------------
 arch/riscv/kernel/module.c                  | 15 ----
 arch/riscv/kernel/setup.c                   |  2 +
 arch/riscv/kernel/vdso.c                    |  5 --
 arch/riscv/kernel/vdso/vdso.lds.S           |  7 ++
 arch/riscv/kvm/tlb.c                        |  3 +-
 17 files changed, 191 insertions(+), 164 deletions(-)

-- 
2.37.2

