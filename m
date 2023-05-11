Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5B76FF49A
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbjEKOh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 10:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238415AbjEKOhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 10:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2174C106FA
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 07:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B34C64DE1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB984C433D2;
        Thu, 11 May 2023 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683815816;
        bh=mUNqzMhvbJdK3NJYcIHALgFTFkjdxLhN/do6OyaUVjo=;
        h=From:To:Cc:Subject:Date:From;
        b=lAh3E5QjFdI3+D3LkF6nr16xtVnjWw83kof5WIxKOPkk65CKcwHKO2yCM3zJCNiv6
         V1R/ysz6FAFkxcZ/HyX1m89vUeuJmjZtd3Alj4tP6p71hJuhN+e5wt5/dU+BuLGmmB
         jOL4oas555iLX5JiNxL82GUic4UA9vRqF+RgN+akxSPbGHqcZR9oKWWFaVl+yHLGAw
         azuAzIaG7g1wBwMg45CMyhaouGGbuQ1UANQvKYFVlj2S4Ia64J0Y4PwndWDqE5QXDN
         mtTAkxNkSsWODROnEAr/pmieBCUR25icsx0BVll6+VCsBSLIXokdPmbffwbV5VK6Xt
         4P0K0n4tMJzXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1px7PZ-00EM0w-Bh;
        Thu, 11 May 2023 15:36:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jingyu Wang <jingyuwang_vip@163.com>,
        Mark Brown <broonie@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.4, take #1
Date:   Thu, 11 May 2023 15:36:38 +0100
Message-Id: <20230511143638.350228-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, christophe.jaillet@wanadoo.fr, jingyuwang_vip@163.com, broonie@kernel.org, quic_mojha@quicinc.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's a first set of fixes, most of which has been simmering in -next
for some time now. The most important one is a series from Oliver,
plugging a (hard to trigger) race that would result in the wrong
mapping being established at S2.

The rest is a bunch of cleanups and HW workarounds (the usual Apple
vgic issue that keeps cropping up on new SoCs).

Please pull,

       M.

The following changes since commit ac9a78681b921877518763ba0e89202254349d1b:

  Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.4-1

for you to fetch changes up to c3a62df457ff9ac8c77efe6d1eca2855d399355d:

  Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes (2023-05-11 15:26:01 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.4, take #1

- Plug a race in the stage-2 mapping code where the IPA and the PA
  would end up being out of sync

- Make better use of the bitmap API (bitmap_zero, bitmap_zalloc...)

- FP/SVE/SME documentation update, in the hope that this field
  becomes clearer...

- Add workaround for the usual Apple SEIS brokenness

- Random comment fixes

----------------------------------------------------------------
Christophe JAILLET (2):
      KVM: arm64: Slightly optimize flush_context()
      KVM: arm64: Use the bitmap API to allocate bitmaps

Jingyu Wang (1):
      KVM: arm64: Fix repeated words in comments

Marc Zyngier (4):
      KVM: arm64: Constify start/end/phys fields of the pgtable walker data
      KVM: arm64: vgic: Add Apple M2 PRO/MAX cpus to the list of broken SEIS implementations
      Merge branch kvm-arm64/misc-6.4 into kvmarm-master/fixes
      Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes

Mark Brown (3):
      KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
      KVM: arm64: Restructure check for SVE support in FP trap handler
      KVM: arm64: Clarify host SME state management

Oliver Upton (2):
      KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
      KVM: arm64: Infer PA offset from VA in hyp map walker

 arch/arm64/include/asm/cputype.h        |  8 +++++++
 arch/arm64/include/asm/kvm_pgtable.h    |  1 +
 arch/arm64/kvm/fpsimd.c                 | 26 +++++++++++++--------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++--
 arch/arm64/kvm/hyp/pgtable.c            | 41 +++++++++++++++++++++++++--------
 arch/arm64/kvm/inject_fault.c           |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c           |  4 ++++
 arch/arm64/kvm/vmid.c                   |  7 +++---
 8 files changed, 76 insertions(+), 25 deletions(-)
