Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0A04A7D2A
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348692AbiBCBBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348674AbiBCBB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:27 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CEDC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:26 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id em10-20020a17090b014a00b001b5f2f3b5ffso805379pjb.1
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0l1gqv5EOwd7xJV6eVY8d2Pk48r8BizOfmRGLMRqKB4=;
        b=QjPBEa8FnfTxC06z6gyVawJMYzwITsMZ7gHrkdBJjAPjmPqsQtW2vt+ornPjsq9l/o
         XVDGKPEWRXsZ++nImCs1pv7Cz0NPF1EZkSIUb4s/DtAOejGEdj1GlSV7V6VQ6MUjL0vf
         dgS3FsWgZK3J9YmofNxs7KN61nzmE0G/RNBaSIamwLcUyX8BmUOBMF4GhQi/+cCEvlyh
         pNqBc+cmWqSS6ld9M7Lod5CcYeqqtusz+bA6mkpbVZqwGkWw6g8oLW/A6cLTQ6NYNhMS
         mwYBcSjoTqQdwNenRtdMqZ5a+wQBxEHEqqwzzSVui89kXYZt20Gk0/IyjiVQ/EeALdIi
         /XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0l1gqv5EOwd7xJV6eVY8d2Pk48r8BizOfmRGLMRqKB4=;
        b=G+luk39NGw7CcVMA7WtgSTYDq1j1GDiHoSrcxmViq/bwedMxq6zLdCJwxCZXqbjTNd
         TSj+3Il7d9rwQSCGXqzS4OxrSTDjq27+bcMTd+bljKmcbI8JfJ5kUiHFDH6HSxl0YWpO
         mgzHFV196+1WPddK1x1ZYw4hRMLDfUp0JwC5RLocfzCDswkpoDfrJOp4pM+dGFndvfgM
         5imQxE30MS9flKchgr5YDwoyb6zhdzYKhIVa+cl4FxeBEkgnLXGCNz35PCx4x+x3hDh5
         fHnC4yFWUseMcKbyhMSXI9iJEPnjSWGl60HWjdVdAi3ni58DpoNmrYqDmj/l/3IETKdK
         AGtw==
X-Gm-Message-State: AOAM533+s1fdnXpjdWgyTVCOz/jie7c4BpHXHFOlEt/uFOue2EkoDdKK
        XkutZF+7TURYP0rmokv32m5yLNXriatpmg==
X-Google-Smtp-Source: ABdhPJwYe2XqR1jNLCi5DnX59bLGtbJ4Lg9q6Gc/kHR/d015B28h15jzCJG3v4lXTuungdSN4oLHLf21539SCg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:2e03:: with SMTP id
 q3mr11023002pjd.184.1643850086506; Wed, 02 Feb 2022 17:01:26 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:44 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-17-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 16/23] KVM: x86/mmu: Zap collapsible SPTEs at all levels in
 the shadow MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
in the rmap). This leads to correct behavior because KVM never creates
intermediate huge pages during dirty logging. For example, a 1GiB page
is never partially split to a 2MiB page.

However this behavior will stop being correct once the shadow MMU
participates in eager page splitting, which can in fact leave behind
partially split huge pages. In preparation for that change, change the
shadow MMU to iterate over all levels when zapping collapsible SPTEs.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2306a39526a..99ad7cc8683f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6038,18 +6038,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	return need_tlb_flush;
 }
 
+static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
+					   const struct kvm_memory_slot *slot)
+{
+	bool flush;
+
+	flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
+				  PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL, true);
+
+	if (flush)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+
+}
+
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		/*
-		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
-		 * logging at a 4k granularity and never creates collapsible
-		 * 2m SPTEs during dirty logging.
-		 */
-		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_rmap_zap_collapsible_sptes(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

