Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2AC5EABEC
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiIZQDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiIZQCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2416772864
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 07:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A068360E73
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C87DC43144;
        Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664203886;
        bh=2nD7W3IQ7HMmPnSDsoc7819nZQUSrYQak/JFb33CcAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6T5ewI1eyvjuHjnq7ZM1V3TfQwnIi+ofkpU5seW+ixOYST/cB9QhzIB+uxvXNgWs
         lZAxb35piLhBQTabzBYb1rYudbnj3TOV715MNJqL0UeT3GpMJv9AfFns1V495Z8Yms
         HRiC5PhvEnktckge+jvYtsplCCNfT/5P1hRnpGXnMGe6pf3gfR+ZbxBQznWe3bhxTv
         GSy7qluQkFDi44QoDUaKXRKAodo+4xbdNR8vrMAF6elf+dMRIKXeJ1nb7qdA7u+ylp
         Wdqorztojk4Ae6KJLi8ttoorXMs24YOvAq+V56HW82PDdPG/LUU5l5+s1n8Da2J9hG
         ink/3kmkSBHFg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ocpS8-00Cips-6S;
        Mon, 26 Sep 2022 15:51:24 +0100
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
Subject: [PATCH v2 4/6] KVM: Document weakly ordered architecture requirements for dirty ring
Date:   Mon, 26 Sep 2022 15:51:18 +0100
Message-Id: <20220926145120.27974-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..32427ea160df 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8019,8 +8019,8 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
 
-8.29 KVM_CAP_DIRTY_LOG_RING
----------------------------
+8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
+----------------------------------------------------------
 
 :Architectures: x86
 :Parameters: args[0] - size of the dirty log ring
@@ -8078,6 +8078,11 @@ on to the next GFN.  The userspace should continue to do this until the
 flags of a GFN have the DIRTY bit cleared, meaning that it has harvested
 all the dirty GFNs that were available.
 
+Note that on weakly ordered architectures, userspace accesses to the
+ring buffer (and more specifically the 'flags' field) must be ordered,
+using load-acquire/store-release accessors when available, or any
+other memory barrier that will ensure this ordering.
+
 It's not necessary for userspace to harvest the all dirty GFNs at once.
 However it must collect the dirty GFNs in sequence, i.e., the userspace
 program cannot skip one dirty GFN to collect the one next to it.
@@ -8106,6 +8111,14 @@ KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
 machine will switch to ring-buffer dirty page tracking and further
 KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
 
+NOTE: KVM_CAP_DIRTY_LOG_RING_ACQ_REL is the only capability that
+should be exposed by weakly ordered architecture, in order to indicate
+the additional memory ordering requirements imposed on userspace when
+reading the state of an entry and mutating it from DIRTY to HARVESTED.
+Architecture with TSO-like ordering (such as x86) are allowed to
+expose both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL
+to userspace.
+
 8.30 KVM_CAP_XEN_HVM
 --------------------
 
-- 
2.34.1

