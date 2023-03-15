Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B116BA516
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjCOCSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjCOCSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B51B2ED57
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54476ef9caeso11770097b3.6
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R7PbkkBFGhCnK5frH2DUXaaJljM3hiPgZ3cGoBNbkII=;
        b=Kts1MUs2Prw/gLPbxugZ4kB0qWpj6Rn94SuTJ8epb2RjFhorZC2vo7Ji/P92V2sbYW
         CyW7u2jy+ih9/5Vc4klfO+VRJyPYmeNmP4BOzDRGfKNNi1iobVo7AAxptHq0sqjiqjrY
         ulUuHgE0rpBYlElLFMUkQZA6nDq8Da/3tBsLjg3B69EpJuuhYDVKOGpHiVdURJ7M71s/
         KiIfnly5Cf/qJ+r5gs80fKjZMMEohv/rOwW6Bv6lX/hIoYraH69H2DGJAZ+Y5XiO2wQa
         m5S3dawN4LUyfgp4xkmLS3iPeNjRB5YDwgUVlac5NY7zJsOJvWAx/yinsmA3nAR1CtCX
         m3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R7PbkkBFGhCnK5frH2DUXaaJljM3hiPgZ3cGoBNbkII=;
        b=KgqXD0GoQyNAV3CWLvy04+8kW5EvKaUaDbU6kNwjAii59lREJZx/gSNkWLhXwZdeJ7
         4xAHbcaKHfp+wGsvfEHq3fsE5tHh+YD4Xdw9lioVY3ltuYOL7h6lt9jqBpG5WVY70/cv
         NF57ZaajlOlA3GzUQBS+0orXkyNirakD2W0EofaMdNJtH8QpuisbiT7hclnWRMnMKroW
         J9S2DY40ACh6e+BbLGCQT6EkZ/lSuHQhN+nK6QtGU4f0m5LzNx/jBRQv3ZxC6NF5+hd+
         vXfFAKzZizHyMWGMgmWueQIMAZxPg8OFyYEzN1wYcvPECKTKhqxbipzSAcCA7aQFnyOQ
         0j1g==
X-Gm-Message-State: AO0yUKWIQ6hRLtQYig7JQhoqpnmZlQrfkuQOfA3iretoAXegb6euSpq8
        aYXL4kNSh8GkcQxBrUKCg51lqCKsh4+OYQ==
X-Google-Smtp-Source: AK7set9AJwkbREOX0A5bda+owuTYtXQ9O0hh2FTBNC++1Iw7pbTeuYgVBi5v/OnQ1FtY+85j06UfWLTXZTFwbw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1024:b0:b4a:3896:bc17 with SMTP
 id x4-20020a056902102400b00b4a3896bc17mr1226659ybt.0.1678846691855; Tue, 14
 Mar 2023 19:18:11 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:36 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-13-amoorthy@google.com>
Subject: [WIP Patch v2 12/14] KVM: arm64: Implement KVM_CAP_MEMORY_FAULT_NOWAIT
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a memslot has the KVM_MEM_MEMORY_FAULT_EXIT flag set, exit to
userspace upon encountering a page fault for which the userspace
page tables do not contain a present mapping.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/arm.c |  1 +
 arch/arm64/kvm/mmu.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf0872..f8337e757c777 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_MEMORY_FAULT_NOWAIT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 735044859eb25..0d04ffc81f783 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1206,6 +1206,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool exit_on_memory_fault = kvm_slot_fault_on_absent_mapping(memslot);
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1303,8 +1304,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_memslot(
+		memslot, gfn, exit_on_memory_fault, false, NULL,
+		write_fault, &writable, NULL);
+
+	if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
+		vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+		vcpu->run->memory_fault.flags = 0;
+		vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
+		vcpu->run->memory_fault.len = vma_pagesize;
+		return 0;
+	}
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 1;
-- 
2.40.0.rc1.284.g88254d51c5-goog

