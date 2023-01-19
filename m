Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C977674019
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjASRga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjASRgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:36:21 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CB18F7C6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:20 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id u7-20020a17090a410700b002291f69fbb5so1221611pjf.2
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c0SS1XLwsBFZ40upMmt6qRjU4c0qpX4m+4RA3lz+crc=;
        b=bRTUL9THslA1WY3C6zfQ1MAdQYPay9Jt3idYcFlPDFpT0P4o1+XdpDhUeIk2USmwqG
         D3KWQ2FFy3WJkFP9lARnX3e2e5+KhWdYytuOptPQtHynN/RZhg3lvRYJ1+tDBSadgtps
         wX3mEXowuzhodMcGekL2PsM6hfEXUHRivXQGF0Q29dG33K4Rv5+lelnHW3mcP/8E3OxY
         qNPsUHH4GMaFwBF+QLlhLNR1zHxYzEPnBpWfOlG2W1lShRazOpwLppupOCoEm3ciHxk3
         OsbBJeAM+1GFVBPMGCcS7Q866gvCz+lnaIzAW6Qyf3Bq9YevZj2TcF9nD2jvuYi68kxn
         b2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0SS1XLwsBFZ40upMmt6qRjU4c0qpX4m+4RA3lz+crc=;
        b=6lhZTj0XAA6MF9uuSTwjMZ7WF4xwRVNxzdDeKH4dvUWLG5UgXDAM6yjhyzVMo4DHoC
         NMS4MYilpwGlYHqHAC72jyTtRIEtLSM2uPveBW6fVJ/oj4PfbY1cA9gdXzIE5URmO7Jp
         NXby1XTy78+BstHEF6cBjUGxzhFXw6fspewAitt3xim5n3hhIvkrPXd4cyZmphdNzYZ7
         3pFkKxslhTW1YG/GoYJfSjKeUIdRrEUjTwsG9ftfkSpoEKPa38ulqTi2dEF+0VFy85da
         YKlex65qmd5lQTiFWOJRvNIvttQ/Mq3sJF2TnJrzwMpbwzcmjdJA5CABekrRXcJ7EBMy
         DvJA==
X-Gm-Message-State: AFqh2kqhxOC6sX9u+NmlV3wZZV0IlbBXIz4EsK08edw61dQi7Jetyygg
        5MEUxPrrRVSGVXZaneciy6rYfUO1Ew76YA==
X-Google-Smtp-Source: AMrXdXvbTmwzuJAuBPKJsyHR0snVOekSSTxs16QNlqhF8cG4iLKN5DvuKgwpJj8AOixc6btzxFQ4Hm+pmC9GRQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a62:ae10:0:b0:580:9b0b:4fde with SMTP id
 q16-20020a62ae10000000b005809b0b4fdemr1243710pff.49.1674149779734; Thu, 19
 Jan 2023 09:36:19 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:35:57 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-6-dmatlack@google.com>
Subject: [PATCH 5/7] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Use gfn_t instead of u64 for the start_gfn parameter to
kvm_flush_remote_tlbs_range(), since that is the standard type for GFNs
throughout KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36ce3110b7da..1e2c2d711dbb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -246,7 +246,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e606a6d5e040..851982a25502 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -164,7 +164,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
-- 
2.39.0.246.g2a6d74b583-goog

