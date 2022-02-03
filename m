Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D594A7D12
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348695AbiBCBBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348682AbiBCBBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:30 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0801C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:28 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id h11-20020a170902eecb00b0014cc91d4bc4so275640plb.16
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5i4VY2bHCiSczZZRyAsjbx+sp+PsOe+n0ifiX66TGKQ=;
        b=JZjr3o/Xj0ZRx0suwEy6bYbMd9qW24xXIJPQHNr1KXJ0UewxNeP9Ctdvx+E57Vwn7p
         bA6O/ilFcBB7nikhezvMGjcNUt9zmq4WM8Od2Nf/DYpMKe3H5FHlsKtTnxRY3OZdAUF1
         Cb6yZ7H2REBHyiIMe0vZRU6iojZnWGP5O5RDb4ymtaJNHQqgl1pzwv9ln3FXcvfG+fdS
         eAdSmMwfwpLdhOCjnkUXWqF6Uuxz3W/Sp+SxXoz2Tsa6B52RcYILQlj1kGaoNQlLA79b
         M2CDemAUsjgJwlAF0kKTR+wlZ8nLYKHeSmJjIy3hx8Ec15jLeMILAUQhGxPkLeOqaKPD
         9z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5i4VY2bHCiSczZZRyAsjbx+sp+PsOe+n0ifiX66TGKQ=;
        b=o//V7+WMkyrzx1al+Z6vo42mpwKrUqVGv1CMWLOxDQkq6nbLR3+4jVrtTSsIHm6gm9
         ApE/ODUOI1ThFR2RvQGD4mwwzN7Fd1L0jzDl7sB1iPH0u6zK59tVfZwjIv/whKKqsnzA
         LGHd2m3HyREKdWTJuKl2C0mcsuDh6ABIv+O2TLvnqNfWMsE3pezGeWbPkQcJykZRqZ6D
         2BAvw3wuixCXSzUQ2KVGY+RwAPzECa8yti5e3xE0HA6y8jm3PNTpifmyNlXxPJFV4LeA
         hA8OsJBqlZ+x0a/D/Z98MOYlmCRJ5QQfCEDgFhRIz+A3Sfx6JKJl/ZAiqsF+HzDXIKKb
         9kUQ==
X-Gm-Message-State: AOAM530k5rpJgXRhdftMRE+voOpvnZAk1SrMegLMpfmu8JAkUBig0453
        sq3AOic+nPFyCMYSFauOc0slIN48rUYL5w==
X-Google-Smtp-Source: ABdhPJzRpt54nGYwo/AmMVwVGQneUJIFBBVlhMoEm1c2aqnch/FkFPkJfXePf85np72f8WDCgNjRrmAJTB+Rwg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:c215:: with SMTP id
 21mr31892573pll.134.1643850088211; Wed, 02 Feb 2022 17:01:28 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:45 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 17/23] KVM: x86/mmu: Pass bool flush parameter to drop_large_spte()
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush. This difference is not obvious from the name.

To make the code more readable, pass an explicit flush parameter. Also
replace the vCPU pointer with a KVM pointer so we can get rid of the
double-underscore helper function.

This is also in preparation for a future commit that will conditionally
flush after dropping a large SPTE.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 25 +++++++++++--------------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 99ad7cc8683f..2d47a54e62a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1162,23 +1162,20 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 }
 
 
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
-}
+	if (!is_large_pte(*sptep))
+		return;
 
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
+
+	drop_spte(kvm, sptep);
 
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	if (flush) {
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
@@ -3051,7 +3048,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (it.level == fault->goal_level)
 			break;
 
-		drop_large_spte(vcpu, it.sptep);
+		drop_large_spte(vcpu->kvm, it.sptep, true);
 		if (is_shadow_present_pte(*it.sptep))
 			continue;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 703dfb062bf0..ba61de29f2e5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -677,7 +677,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		gfn_t table_gfn;
 
 		clear_sp_write_flooding_count(it.sptep);
-		drop_large_spte(vcpu, it.sptep);
+		drop_large_spte(vcpu->kvm, it.sptep, true);
 
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
@@ -739,7 +739,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 		validate_direct_spte(vcpu, it.sptep, direct_access);
 
-		drop_large_spte(vcpu, it.sptep);
+		drop_large_spte(vcpu->kvm, it.sptep, true);
 
 		if (!is_shadow_present_pte(*it.sptep)) {
 			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
-- 
2.35.0.rc2.247.g8bbb082509-goog

