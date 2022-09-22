Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3954C5E690B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiIVRCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiIVRB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:01:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B72F8590
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA489636C3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8D6C433D6;
        Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663866115;
        bh=Ck/O3xTFyNsn3pXALp+pBC+2zu95kxeuiXwd91ircVE=;
        h=From:To:Cc:Subject:Date:From;
        b=qgVvrTZzYqRKg9l5SRppQrZihLSM/6L11xeZWJAqw/kafrlfShjitaODMY2YgpmDZ
         ZG4v1mm+Rwsw/KftVstcNI7lGAvuG4H+AS3S14mhHywQ8VXeoeWOZfp/BOv4R3+Juc
         IwEjmczXjmmUQGDkN135NyWpnTkI5JEFGfjUCp0+ya3tG+vC9YPQTzP4WUKmAa6KAe
         GEPdqqfQV0vRoA7CpjIqYnGdjLAZs90lcQYvHl2CQ1nocaoIo8H5Co7XxuBRSHFejc
         4yRFf57tmM26c44snlLmX0mOnRKRPfRc3I+7Y3k3fJRcOORiOVo/80k46KuM8Aqr6+
         RZGCiPymk8ilg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1obPaC-00Bxdo-Ru;
        Thu, 22 Sep 2022 18:01:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, gshan@redhat.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/6] KVM: Fix dirty-ring ordering on weakly ordered architectures
Date:   Thu, 22 Sep 2022 18:01:27 +0100
Message-Id: <20220922170133.2617189-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
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

[Same distribution list as Gavin's dirty-ring on arm64 series]

As Gavin started posting patches enabling the dirty-ring infrastructure
on arm64 [1], it quickly became apparent that the API was never intended
to work on relaxed memory ordering architectures (owing to its x86
origins).

This series tries to retrofit some ordering into the existing API by:

- relying on acquire/release semantics which are the default on x86,
  but need to be explicit on arm64

- adding a new capability that indicate which flavor is supported, either
  with explicit ordering (arm64) or both implicit and explicit (x86),
  as suggested by Paolo at KVM Forum

- documenting the requirements for this new capability on weakly ordered
  architectures

- updating the selftests to do the right thing

Ideally, this series should be a prefix of Gavin's, plus a small change
to his series:

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 0309b2d0f2da..7785379c5048 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,7 +32,7 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
-	select HAVE_KVM_DIRTY_RING
+	select HAVE_KVM_DIRTY_RING_ORDERED
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING

This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.

[1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
[2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com

Marc Zyngier (6):
  KVM: Use acquire/release semantics when accessing dirty ring GFN state
  KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability and config option
  KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
  KVM: Document weakly ordered architecture requirements for dirty ring
  KVM: selftests: dirty-log: Upgrade dirty_gfn_set_collected() to
    store-release
  KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ORDERED of
    available

 Documentation/virt/kvm/api.rst               | 16 +++++++++++++---
 arch/x86/kvm/Kconfig                         |  1 +
 include/linux/kvm_dirty_ring.h               |  6 +++---
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c |  6 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c   |  5 ++++-
 virt/kvm/Kconfig                             | 14 ++++++++++++++
 virt/kvm/Makefile.kvm                        |  2 +-
 virt/kvm/dirty_ring.c                        |  4 ++--
 virt/kvm/kvm_main.c                          | 11 +++++++++--
 10 files changed, 52 insertions(+), 14 deletions(-)

-- 
2.34.1

