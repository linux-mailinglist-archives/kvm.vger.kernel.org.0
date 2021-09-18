Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4883B410273
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbhIRA6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242844AbhIRA6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB0DC061574;
        Fri, 17 Sep 2021 17:56:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w8so11195896pgf.5;
        Fri, 17 Sep 2021 17:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=25aWXLCbUHXS2COaXtckpEQG8G6M9yqF57CffvGsPlw=;
        b=ZgIbePrF8l3FOoDwCAT3VRuaZWCM2Yw/8R7mhTQbGGOdUQsPKVB6BHnKEVZlGKSwZb
         6tPPThIYZI8h10y98fNU2PILmm7jphW1ny13eYg5k8F3VVwNvSiutkOF2KFpmwMr8tsk
         pmWkq/6m1uULi/Cfm2fYcDHqnpMrgEy4EYidWTC56kzmrri2G7Z6Sz6VB9C5HPiF++2T
         OQUG/LX+TDAjEIuhaKiT5ji/GicpMM+c19sI6xY7POAqmrzIeCEgeVL6y+LoyvoUz8aK
         0Xmc6O+nXn6F1GO5qjclqQ0ZSB0UpWgvZ3OjkoqP8Zkw8cWYy7DhRJO9rPSnzBjHD3Rs
         mJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=25aWXLCbUHXS2COaXtckpEQG8G6M9yqF57CffvGsPlw=;
        b=lziegG0b/x39kCpDO1oXU/2SW6LfjEqR4tR5kkOSFCzjnKYip3SYh9V+6Z2EXS5rFu
         uudHdX1Z55/6QgvgpBoskPgWy1dNwNuEJN9qJkTNOOfHS/xAZyZ7Zco+GCn/0im3J/WH
         CwUzozknP0n7mcLylO13242C+uoPPbxHXxqsEMj3Lwp+zHzoJJO6hSAGKoWyRs+LL1Au
         gEeYDZ+ZwOLuMyGx44x/iUWO3d410hA9cgrzSTg+/fGl3u6ZLihWliv+8so/OnSsBDIx
         UhRB1ll1XSqZY2KKZmgQwXngAdp6XEoP6QFOLs8ku5Q1Lo2XXzGlox75LYFWomkZBCGx
         TeCA==
X-Gm-Message-State: AOAM530WtlVuJzy37LsL7oRoaswuXiAcFcWho4gDikQpyrm/BpwB6Vcs
        zicuAulCD+YGZyMbSDNh1mmKHUcUw3M=
X-Google-Smtp-Source: ABdhPJxYDQgaCXZhES8TeSRNbeR4xtQXH3AkrtMJyYpbvhVLrCJbK1PPhDEqME6ifvqB5cEk5Sp0bA==
X-Received: by 2002:aa7:8097:0:b029:3cd:b205:cfe9 with SMTP id v23-20020aa780970000b02903cdb205cfe9mr13851638pff.1.1631926606145;
        Fri, 17 Sep 2021 17:56:46 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id e13sm6841682pfc.137.2021.09.17.17.56.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:56:45 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH V2 02/10] KVM: X86: Synchronize the shadow pagetable before link it
Date:   Sat, 18 Sep 2021 08:56:28 +0800
Message-Id: <20210918005636.3675-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If gpte is changed from non-present to present, the guest doesn't need
to flush tlb per SDM.  So the host must synchronze sp before
link it.  Otherwise the guest might use a wrong mapping.

For example: the guest first changes a level-1 pagetable, and then
links its parent to a new place where the original gpte is non-present.
Finally the guest can access the remapped area without flushing
the tlb.  The guest's behavior should be allowed per SDM, but the host
kvm mmu makes it wrong.

Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V1:
	Don't loop, but just return when it needs to break.

 arch/x86/kvm/mmu/mmu.c         | 15 ++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h | 22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 26f6bd238a77..3c1b069a7bcf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2024,8 +2024,8 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 	} while (!sp->unsync_children);
 }
 
-static void mmu_sync_children(struct kvm_vcpu *vcpu,
-			      struct kvm_mmu_page *parent)
+static int mmu_sync_children(struct kvm_vcpu *vcpu,
+			     struct kvm_mmu_page *parent, bool can_yield)
 {
 	int i;
 	struct kvm_mmu_page *sp;
@@ -2052,12 +2052,16 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 		}
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
 			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+			if (!can_yield)
+				return -EINTR;
+
 			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
 			flush = false;
 		}
 	}
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+	return 0;
 }
 
 static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
@@ -2143,9 +2147,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 
-		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-
 		__clear_sp_write_flooding_count(sp);
 
 trace_get_page:
@@ -3642,7 +3643,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		write_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
-		mmu_sync_children(vcpu, sp);
+		mmu_sync_children(vcpu, sp, true);
 
 		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 		write_unlock(&vcpu->kvm->mmu_lock);
@@ -3658,7 +3659,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		if (IS_VALID_PAE_ROOT(root)) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
-			mmu_sync_children(vcpu, sp);
+			mmu_sync_children(vcpu, sp, true);
 		}
 	}
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5962d4f8a72e..87374cfd82be 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -704,6 +704,28 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
 					      it.level-1, false, access);
+			/*
+			 * We must synchronize the pagetable before link it
+			 * because the guest doens't need to flush tlb when
+			 * gpte is changed from non-present to present.
+			 * Otherwise, the guest may use the wrong mapping.
+			 *
+			 * For PG_LEVEL_4K, kvm_mmu_get_page() has already
+			 * synchronized it transiently via kvm_sync_page().
+			 *
+			 * For higher level pagetable, we synchronize it
+			 * via slower mmu_sync_children().  If it needs to
+			 * break, returns RET_PF_RETRY and will retry on
+			 * next #PF.  It had already made some progress.
+			 *
+			 * It also makes KVM_REQ_MMU_SYNC request if the @sp
+			 * is linked on a different addr to expedite it.
+			 */
+			if (sp->unsync_children &&
+			    mmu_sync_children(vcpu, sp, false)) {
+				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+				return RET_PF_RETRY;
+			}
 		}
 
 		/*
-- 
2.19.1.6.gb485710b

