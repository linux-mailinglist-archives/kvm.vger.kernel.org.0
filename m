Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B4965BDBF
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 11:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbjACKNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 05:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbjACKNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 05:13:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C418E91
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 02:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46AD1B80E64
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D27C433F2;
        Tue,  3 Jan 2023 10:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672740790;
        bh=/36RZNkiPAxwtJXfCBhVvkMEDyUrBPHpASIPH0DBj1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjT73yj6JSjz9uV37Vt7kNnqDBn5vDcYZPWPHHY8okMHqMl58/pj+yEoowL2ZnUnp
         IyreHta2bDrXSA7fjsnD9hJ9q5KEtTQ+MICXlxjye81rVv3VQF6tGzHlarwUgvaMC/
         EU7nVXWVA74sWsrYTvq39WCAKJ4jUdXdgkv34AhbaiZJVq4G2MZnMrj684yJ5bMthC
         +qusl0brQvqmTfRtFWxLiPWpt5KG4IKRve/bcGoZFRU6NMcVCyCppxnNDjlNvI6PlX
         A5R2NUOLP3kpTifk/hwBmutO7zCGewpOrEKv1MwMF1bw8ILRk+RQLMGSoOj2nCUI94
         FjUTi680ybQAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pCeI8-00GTpw-Sk;
        Tue, 03 Jan 2023 10:13:08 +0000
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
Subject: [PATCH v2 2/3] KVM: arm64: Document the behaviour of S1PTW faults on RO memslots
Date:   Tue,  3 Jan 2023 10:09:03 +0000
Message-Id: <20230103100904.3232426-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103100904.3232426-1-maz@kernel.org>
References: <20230103100904.3232426-1-maz@kernel.org>
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

Although the KVM API says that a write to a RO memslot must result
in a KVM_EXIT_MMIO describing the write, the arm64 architecture
doesn't provide the *data* written by a Stage-1 page table walk
(we only get the address).

Since there isn't much userspace can do with so little information
anyway, document the fact that such an access results in a guest
exception, not an exit. This is consistent with the guest being
terminally broken anyway.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0dd5d8733dd5..42db72a0cbe6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1354,6 +1354,14 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
+Note: On arm64, a write generated by the page-table walker (to update
+the Access and Dirty flags, for example) never results in a
+KVM_EXIT_MMIO exit when the slot has the KVM_MEM_READONLY flag. This
+is because KVM cannot provide the data that would be written by the
+page-table walker, making it impossible to emulate the access.
+Instead, an abort (data abort if the cause of the page-table update
+was a load or a store, instruction abort if it was an instruction
+fetch) is injected in the guest.
 
 4.36 KVM_SET_TSS_ADDR
 ---------------------
-- 
2.34.1

