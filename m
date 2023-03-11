Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCCB6B610F
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 22:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCKVlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 16:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKVlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 16:41:18 -0500
Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [IPv6:2001:41d0:203:375::28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B19662D97
        for <kvm@vger.kernel.org>; Sat, 11 Mar 2023 13:41:17 -0800 (PST)
Date:   Sat, 11 Mar 2023 13:41:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678570875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=OIfr38RQbr2XXVcmEhQx3zmzDnnSyVR94dBmvVhONCc=;
        b=IFX7soddA5zpXP8JmmrAoXVD3b+xKHeGFDkDD1KN32IDgVOF4LS54rCLqB9jFaVaTTgJ5K
        MaAyiPc80JdWLup/UL3P70fZd94rAk2vTXLaZIoEu5MecqYooAO6lf9r7I81VYQBfVRZaY
        xCSwv4P48PTogn9UHZVaqtHE1HLrrC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     pbonzini@redhat.com
Cc:     maz@kernel.org, reijiw@google.com, joey.gouly@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.3, part #1
Message-ID: <ZAz1duOOOTu+5LW5@thinky-boi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Paolo,

First shot at sending a pull request to you, please let me know if anything
is screwed up :)

A single, important fix for guest timers addressing a bug from the nested
virtualization prefix that went in 6.3. 

Please pull,

--
Oliver

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-1

for you to fetch changes up to 47053904e18282af4525a02e3e0f519f014fc7f9:

  KVM: arm64: timers: Convert per-vcpu virtual offset to a global value (2023-03-11 02:00:40 -0800)

----------------------------------------------------------------
KVM/arm64 fixes for 6.3, part #1

A single patch to address a rather annoying bug w.r.t. guest timer
offsetting. Effectively the synchronization of timer offsets between
vCPUs was broken, leading to inconsistent timer reads within the VM.

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: timers: Convert per-vcpu virtual offset to a global value

 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arch_timer.c       | 45 +++++++++------------------------------
 arch/arm64/kvm/hypercalls.c       |  2 +-
 include/kvm/arm_arch_timer.h      | 15 +++++++++++++
 4 files changed, 29 insertions(+), 36 deletions(-)
