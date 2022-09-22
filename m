Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C65E6911
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiIVRCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiIVRCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DD1F8C0D
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63370B83923
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1239DC43141;
        Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663866116;
        bh=4h2yrh9uXpAdDMveyhUMC+93vyBJ6X9Tx36xTLyyCEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+TkNljhuXiD7olbxVvnxsCAYPjTV/48hLtLdp4926o1NYQE0ezc1jjCPBbNAV2H3
         ioZsxeVmv0E+11eiAUrZMsZZMslvxg7SfrIsimCw9jwUTXS40B0s/NUNDbrSG6GNC4
         UKZOX/UgpJw9GjAbO8g4xi+2cklCUCPTLmsGpOs+4mY0nkAKV5CFwNRdaSWk9pO5Lh
         TDjuVxTO83HN7Jif0+3ntWomCda/CcMNQofnHRXFq8YiEJoZjG8d4SGp9f6oxpyXFi
         iDceNQUQAAU6wT8TgBaA7pVnEbJ7a+8oUZJ19hN3gcqpMW/VPcBiFlJFTzTeWvzELb
         4IfP/g1DaE+aQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1obPaE-00Bxdo-2t;
        Thu, 22 Sep 2022 18:01:54 +0100
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
Subject: [PATCH 4/6] KVM: Document weakly ordered architecture requirements for dirty ring
Date:   Thu, 22 Sep 2022 18:01:31 +0100
Message-Id: <20220922170133.2617189-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
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

Now that the kernel can expose to userspace that its dirty ring
management relies on explicit ordering, document these new requirements
for VMMs to do the right thing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..0912db16425f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8019,8 +8019,8 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
 
-8.29 KVM_CAP_DIRTY_LOG_RING
----------------------------
+8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ORDERED
+----------------------------------------------------------
 
 :Architectures: x86
 :Parameters: args[0] - size of the dirty log ring
@@ -8076,7 +8076,10 @@ The userspace should harvest this GFN and mark the flags from state
 to show that this GFN is harvested and waiting for a reset), and move
 on to the next GFN.  The userspace should continue to do this until the
 flags of a GFN have the DIRTY bit cleared, meaning that it has harvested
-all the dirty GFNs that were available.
+all the dirty GFNs that were available.  Note that on relaxed memory
+architectures, userspace stores to the ring buffer must be ordered,
+for example by using a store-release when available, or by using any
+other memory barrier that will ensure this ordering
 
 It's not necessary for userspace to harvest the all dirty GFNs at once.
 However it must collect the dirty GFNs in sequence, i.e., the userspace
@@ -8106,6 +8109,13 @@ KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
 machine will switch to ring-buffer dirty page tracking and further
 KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
 
+NOTE: KVM_CAP_DIRTY_LOG_RING_ORDERED is the only capability that can
+be exposed by relaxed memory architecture, in order to indicate the
+additional memory ordering requirements imposed on userspace when
+mutating an entry from DIRTY to HARVESTED states. Architecture with
+TSO-like ordering (such as x86) can expose both KVM_CAP_DIRTY_LOG_RING
+and KVM_CAP_DIRTY_LOG_RING_ORDERED to userspace.
+
 8.30 KVM_CAP_XEN_HVM
 --------------------
 
-- 
2.34.1

