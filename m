Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB70165BDB7
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 11:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjACKLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 05:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbjACKLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 05:11:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FD6288
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 02:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F3A3B80E63
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F3DC433D2;
        Tue,  3 Jan 2023 10:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672740670;
        bh=WIRV9KeB+qBR1jtRqfl+nRZmcaTal+PfFn3fayW3MbA=;
        h=From:To:Cc:Subject:Date:From;
        b=aD+3j0aGED8xAJEtKKQsSDWuHJH5cdS2wOM0FGzxKFLLYw9R+EQwt1g4O+1a/RK3f
         7N47+cdsKzrhBzz1XYSyVl6YgbfvK3/keai+86uJ3SDsG8Nld9ybVkiZ7k9MQsaeyC
         qaMtL+EFKi3b7gV+XgbP5MD7cijBDXqMjnFIqzi0LY/SM8uZUqO47XSkuUGckA8t0t
         hkJRpma3Y4rR6MERm2vkraygD9tkM/+R5pwu90YN1PQ83yVkiqOJ+kWvyVMFtRE0jm
         +fMVxCQA/Q2yOWpeWiFQ6xsTmvdCHOR6hvp1qYBpv9WO4P5WybpUhij6CRLEstREHK
         J9uXF/S3RWz2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pCeEF-00GTpw-PU;
        Tue, 03 Jan 2023 10:11:08 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v2 0/3] KVM: arm64: Fix handling of S1PTW S2 fault on RO memslots
Date:   Tue,  3 Jan 2023 10:09:01 +0000
Message-Id: <20230103100904.3232426-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ardb@kernel.org, will@kernel.org, qperret@google.com, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent developments on the EFI front have resulted in guests that
simply won't boot if the page tables are in a read-only memslot and
that you're a bit unlucky in the way S2 gets paged in... The core
issue is related to the fact that we treat a S1PTW as a write, which
is close enough to what needs to be done. Until to get to RO memslots.

The first patch fixes this and is definitely a stable candidate. It
splits the faulting of page tables in two steps (RO translation fault,
followed by a writable permission fault -- should it even happen).
The second one documents the slightly odd behaviour of PTW writes to
RO memslot, which do not result in a KVM_MMIO exit. The last patch is
totally optional, only tangentially related, and randomly repainting
stuff (maybe that's contagious, who knows).

The whole thing is on top of v6.1-rc2.

I plan to take this in as a fix shortly.

	M.

* From v1:

  - Added the documentation patch

  - Dropped the AF micro-optimisation, as it was creating more
    confusion, was hard to test, and was of dubious value

  - Collected RBs, with thanks

Marc Zyngier (3):
  KVM: arm64: Fix S1PTW handling on RO memslots
  KVM: arm64: Document the behaviour of S1PTW faults on RO memslots
  KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*

 Documentation/virt/kvm/api.rst          |  8 +++++
 arch/arm64/include/asm/esr.h            |  9 ++++++
 arch/arm64/include/asm/kvm_arm.h        | 15 ---------
 arch/arm64/include/asm/kvm_emulate.h    | 42 ++++++++++++++++++-------
 arch/arm64/kvm/hyp/include/hyp/fault.h  |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    | 21 +++++++------
 7 files changed, 61 insertions(+), 38 deletions(-)

-- 
2.34.1

