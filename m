Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3953ABF4B
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhFQXWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhFQXWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:22:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059C6C06175F
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:19:59 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f6-20020a6310060000b0290221a634c769so404124pgl.19
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7ozmI8swoBDof9JfAPjd74vw6ODk/Ie9rh7HVUnD/+o=;
        b=qrr+xv7lLPCroy1+APdAOC/BgNDXZyumuBm9pfvzgbfrBbazORnRyVH+/JUIO89TML
         izXnfgCjVylnOa0MtgCx4OKQeMLOUSlsKR3IUXzG1xhDSM4BYjRvwaQgQtby3sDgWzQ0
         zY7XXDE8yTFYBhxppDpkhv5InTgOOF6RUWaemuNQtYGrA2MWdK7KrPNb/HnI0E1EkZWq
         5hCZW/MlRUri5BajxTQGto0la7GX9gozK/c7ms0tOAIn9xKlN9lltkSP5UfKbbapCh9b
         JmS7O0ajWx5d3LSdWgsdihbQ0NucCeIRpwpfPSJB8S8KgSzsxi+TxiIs5z7j4wJ2CTTF
         wBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7ozmI8swoBDof9JfAPjd74vw6ODk/Ie9rh7HVUnD/+o=;
        b=L8jhkTr2MWZahlt+u1ly7/ajaI1ZRm0i/1k4YpS8CQUGmbo61Qla92rNFymwpY6etd
         gq3EeNqUfXj6qsXfahOk/DH5pSal5YK/CqItOmxtMzrBCJzYl6NT2BjG9AWcWlnwYzxl
         3BthIHiNPb+yKnDeN9e8htDospqUxiTgr5BohUq0ZqdBnlL5BAJV9GJ9mejMROtXsLvM
         t1vx83ZVDPSj9E3lGuKRN4/tDrU1s/ayp4+XEqubn2BTDyjhREzo7UNa2Qq0ykjiE/I2
         wUCrlcKdnVo59FT7yXcloqdjwV95ig/0BllzygrOs/+hX0RcFpUZrOtf76tu+yk8fCsd
         3jrQ==
X-Gm-Message-State: AOAM5305Unafhe/Rf1HBAoUp9DoIoKLsarzCBtNTkLe+D6ZBgq+08Qi1
        hLFhIvtiviBSIBZlwdGYxaa2jAwL/Ip9ielpzJpfoYf/AIfu/0ZRP2VxVnXwhVGSAFMf9W5AZJ+
        NrqUBp3fQSbJ3hQGooDPwhwlDmjN8/MU6C2g50MjdIHp5Zel5JcqNpKUx/pm2yeE=
X-Google-Smtp-Source: ABdhPJxloI/3xnhjS/PxQYPEAhuKJVqjQZWvdCLH9ZmuB7xCxheay4bzoQMu1y9nJRyVSayiSDrGIuqPp5bniw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:c9d5:b029:11e:7a87:205 with SMTP
 id q21-20020a170902c9d5b029011e7a870205mr1966933pld.37.1623971998432; Thu, 17
 Jun 2021 16:19:58 -0700 (PDT)
Date:   Thu, 17 Jun 2021 23:19:46 +0000
In-Reply-To: <20210617231948.2591431-1-dmatlack@google.com>
Message-Id: <20210617231948.2591431-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210617231948.2591431-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 2/4] KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled check
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This check is redundant because the root shadow page will only be a TDP
MMU page if is_tdp_mmu_enabled() returns true, and is_tdp_mmu_enabled()
never changes for the lifetime of a VM.

It's possible that this check was added for performance reasons but it
is unlikely that it is useful in practice since to_shadow_page() is
cheap. That being said, this patch also caches the return value of
is_tdp_mmu_root() in direct_page_fault() since there's no reason to
duplicate the call so many times, so performance is not a concern.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 11 ++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h |  4 +---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..1e6bf2e207f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3545,7 +3545,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		return reserved;
 	}
 
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_tdp_mmu_root(vcpu->arch.mmu->root_hpa))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
 		leaf = get_walk(vcpu, addr, sptes, &root);
@@ -3717,6 +3717,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			     bool prefault, int max_level, bool is_tdp)
 {
+	bool is_tdp_mmu_fault = is_tdp_mmu_root(vcpu->arch.mmu->root_hpa);
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
@@ -3729,7 +3730,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
+	if (!is_tdp_mmu_fault) {
 		r = fast_page_fault(vcpu, gpa, error_code);
 		if (r != RET_PF_INVALID)
 			return r;
@@ -3751,7 +3752,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_tdp_mmu_fault)
 		read_lock(&vcpu->kvm->mmu_lock);
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -3762,7 +3763,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (r)
 		goto out_unlock;
 
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
 				    pfn, prefault);
 	else
@@ -3770,7 +3771,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 prefault, is_tdp);
 
 out_unlock:
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_tdp_mmu_fault)
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5fdf63090451..843ca2127faf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -91,12 +91,10 @@ static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif
 
-static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
+static inline bool is_tdp_mmu_root(hpa_t hpa)
 {
 	struct kvm_mmu_page *sp;
 
-	if (!is_tdp_mmu_enabled(kvm))
-		return false;
 	if (WARN_ON(!VALID_PAGE(hpa)))
 		return false;
 
-- 
2.32.0.288.g62a8d224e6-goog

