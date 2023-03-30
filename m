Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF806CFF4E
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjC3I6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjC3I6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:58:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C1472A9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:58:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so21261542pjb.4
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680166700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uuafki+29cUKaQO0uBXDUvz3IdimYT6pah8riQ/iK4=;
        b=XWRGFBVjmIZuyZ3Ya48quyoPniEx9j7UWv6hygUlARVxXnsydbG7vAKY/q29p8rYQ3
         mRfqICN98s7dHIVZcDAO9RmXf+rxtWc5XaqCouT8GxFxwoPkBWKJkthWVTfwW4z2XTO4
         nVjOM6P2+oqctx4yIpaqFnrI8m0o6OOakHDPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680166700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5uuafki+29cUKaQO0uBXDUvz3IdimYT6pah8riQ/iK4=;
        b=CqroWafbgHd/7JDkcuw5OX1XMvn8h3jjz6kPWorHnjbOnx5hTT0TfdiaHEPatu4kP7
         dSU5qPyWO9IUDgj3muXbjfmR+K1vAho+Vty1ErhKvuvq0ftF2gvuD5ROAFWe5JrCC/3V
         i8lIu9s90uLNLyEs2GwddHd/SI6CuuOCd9XMdy8UhX6M6uQih3Zoa725fTXySOqtzZFZ
         YT0u1AfIuvM9U7IHTTFCQteZaUSI8LugVcYCOucQE5x8Ela1nwfNGkaxVu7rf1XMMUBP
         cn2jz/C/Yuy2/j973Q2UnmrDEBQ7mEYhNTfv+VTj/62yVG5c7MQr9u57Kj/hbOudZKr9
         8S7g==
X-Gm-Message-State: AAQBX9cZO1TcPmJYGvKvGQjkgLirtUw0VvrzNMi4ORGkujiX29yWxs7d
        /BNuNyKI07bszNxuZaaG+2/t9DlIiRHTHo7WL6A=
X-Google-Smtp-Source: AKy350YvPl5vVV29XJXPQ2Tc3Qx4pyJcTRMviqLTjFxIdm3DnqKJCl1Uv0CFsVTX1vk0V4Ml679diA==
X-Received: by 2002:a17:90a:190f:b0:233:c301:32b3 with SMTP id 15-20020a17090a190f00b00233c30132b3mr24295355pjg.3.1680166699779;
        Thu, 30 Mar 2023 01:58:19 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1320:eef8:d0bb:b161])
        by smtp.gmail.com with UTF8SMTPSA id g10-20020a17090a7d0a00b00234115a2221sm2718564pjl.39.2023.03.30.01.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 01:58:19 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v6 2/4] KVM: x86/mmu: use gfn_to_pfn_noref
Date:   Thu, 30 Mar 2023 17:58:00 +0900
Message-Id: <20230330085802.2414466-3-stevensd@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230330085802.2414466-1-stevensd@google.com>
References: <20230330085802.2414466-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Switch the x86 mmu to the new gfn_to_pfn_noref functions. This allows IO
and PFNMAP mappings backed with valid struct pages but without
refcounting (e.g. tail pages of non-compound higher order allocations)
to be mapped into the guest.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c          | 19 ++++++++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 ++++---
 arch/x86/kvm/x86.c              |  5 +++--
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 144c5a01cd77..86b74e7bccfa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3114,7 +3114,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (unlikely(fault->max_level == PG_LEVEL_4K))
 		return;
 
-	if (is_error_noslot_pfn(fault->pfn))
+	if (!fault->page)
 		return;
 
 	if (kvm_slot_dirty_track_enabled(slot))
@@ -4224,6 +4224,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		if (is_guest_mode(vcpu)) {
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
+			fault->page = NULL;
 			fault->map_writable = false;
 			return RET_PF_CONTINUE;
 		}
@@ -4239,9 +4240,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	fault->pfn = __gfn_to_pfn_noref_memslot(slot, fault->gfn, false, false, &async,
+						fault->write, &fault->map_writable,
+						&fault->hva, &fault->page);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4261,9 +4262,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	fault->pfn = __gfn_to_pfn_noref_memslot(slot, fault->gfn, false, true, NULL,
+						fault->write, &fault->map_writable,
+						&fault->hva, &fault->page);
 	return RET_PF_CONTINUE;
 }
 
@@ -4349,7 +4350,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_noref_clean(fault->pfn, fault->page);
 	return r;
 }
 
@@ -4427,7 +4428,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 
 out_unlock:
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_noref_clean(fault->pfn, fault->page);
 	return r;
 }
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2cbb155c686c..6ee34a2d0e13 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -239,6 +239,7 @@ struct kvm_page_fault {
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
+	struct page *page;
 	bool map_writable;
 
 	/*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a056f2773dd9..e4e54e372721 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -525,6 +525,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	unsigned pte_access;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -540,12 +541,12 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!slot)
 		return false;
 
-	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
+	pfn = gfn_to_pfn_noref_memslot_atomic(slot, gfn, &page);
 	if (is_error_pfn(pfn))
 		return false;
 
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_noref_clean(pfn, page);
 	return true;
 }
 
@@ -830,7 +831,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_noref_clean(fault->pfn, fault->page);
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b1230..53a8c9e776e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8458,6 +8458,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	gpa_t gpa = cr2_or_gpa;
 	kvm_pfn_t pfn;
+	struct page *page;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -8487,7 +8488,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * retry instruction -> write #PF -> emulation fail -> retry
 	 * instruction -> ...
 	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	pfn = gfn_to_pfn_noref(vcpu->kvm, gpa_to_gfn(gpa), &page);
 
 	/*
 	 * If the instruction failed on the error pfn, it can not be fixed,
@@ -8496,7 +8497,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (is_error_noslot_pfn(pfn))
 		return false;
 
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_noref_clean(pfn, page);
 
 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu->root_role.direct) {
-- 
2.40.0.348.gf938b09366-goog

