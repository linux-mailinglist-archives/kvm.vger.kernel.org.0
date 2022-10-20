Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5964605BC6
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiJTKCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 06:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiJTKC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 06:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF411D63BA
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 03:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D38F61AAC
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE44C433D7;
        Thu, 20 Oct 2022 10:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666260121;
        bh=F7qx70jEHbzt/vc3VSIRa/2M9FvcpGx818RT/QyMnn4=;
        h=From:To:Cc:Subject:Date:From;
        b=rNottOnkoOUnHqL2cat/ocezSae1gieJhPortC8i2O3LbkolVLygfoh/4eklacETr
         JbFIH+nwTlqdrva6oqX7J5wBTgsSIyJ8x9dfy9p9qqqkBablet4Hs8pR6zfk4UIPVF
         beZBtBI1oXftI7RcRAxDP8bsYGoiI47/+qGLOvG57BwD9hkpYo0u5ybs2ilVDZrOFk
         nvCSuuBSa0kK38dboyew8mqKsfWkhU7ErmOA1moqz0RazP8UoxFZ/Y/tGwSzhgk9rr
         8T9Ua0ilUGokFok6oz0LKfWrUriDqC04YAAB7y5BF+ymoriNC4iBZDW2KKpObZ8b/5
         CXMzHGdxo92iA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olSNC-000Cz4-Ru;
        Thu, 20 Oct 2022 11:01:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Denis Nikitin <denik@chromium.org>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.1, take #2
Date:   Thu, 20 Oct 2022 11:01:25 +0100
Message-Id: <20221020100125.3670769-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, denik@chromium.org, eric.auger@redhat.com, renzhengeek@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's a couple of additional fixes for 6.1. The ITS one is pretty
annoying as it prevents a VM from being restored if it has a
convoluted device topology. Definitely a stable candidate.

Note that I can't see that you have pulled the first set of fixes
which I sent last week[1]. In order to avoid any problem, the current
pull-request is a suffix of the previous one. But you may want to pull
them individually in order to preserve the tag descriptions.

Please pull,

	M.

[1] https://lore.kernel.org/r/20221013132830.1304947-1-maz@kernel.org

The following changes since commit 05c2224d4b049406b0545a10be05280ff4b8ba0a:

  KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test (2022-10-13 11:46:51 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-2

for you to fetch changes up to c000a2607145d28b06c697f968491372ea56c23a:

  KVM: arm64: vgic: Fix exit condition in scan_its_table() (2022-10-15 12:10:54 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.1, take #2

- Fix a bug preventing restoring an ITS containing mappings
  for very large and very sparse device topology

- Work around a relocation handling error when compiling
  the nVHE object with profile optimisation

----------------------------------------------------------------
Denis Nikitin (1):
      KVM: arm64: nvhe: Fix build with profile optimization

Eric Ren (1):
      KVM: arm64: vgic: Fix exit condition in scan_its_table()

 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
 arch/arm64/kvm/vgic/vgic-its.c   | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)
