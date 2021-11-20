Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE8E457B68
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhKTEyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbhKTEyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:38 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C61AC0613F8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:01 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id u6-20020a63f646000000b002dbccd46e61so5041285pgj.18
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WeqhnXqLRprnd57wZJzwg+Xm5qcUdWW75YwTMtbvUiU=;
        b=PZj/Mul87sRboOfPzTwBNyENaNNerV6nZx0pxkmHeCwsRBSy4JHncEVpQmwypRwqNi
         DmlOC2AQd597ZnsCbsifzDwpqrwqy76yhUicKpzez5ontFk5W49xmNYkX2jla/Mu6WuI
         TFZjaWFKEYw0lHhg1tVX22zGhej9kqa8AbiwRGMduDdzEDl7AQqmkjqkIOlbojwDyLJl
         IA+CYnaVDz6sZtQtX+Ce6iD7g32gKbn3BoFTeh+3yAf+an3rLP2lEfDy8EeQsNl41agp
         Y4vRa4IfZm1d+sebZ0A/3vP9c6jAyhVtGzTrAgNd5+8qUFd2SvtuFHIOvtN+oE9UlxRl
         2wuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WeqhnXqLRprnd57wZJzwg+Xm5qcUdWW75YwTMtbvUiU=;
        b=gssGGAbno1bFAo4LuSJyjp72hA7owMBq0NH4HQMxyqbI1VZGhUnHlZmirIpdbLk0iv
         cHO2fNYCnVU6Crpk9fXVwxksGVhqC04vWB3PaZ/as3GMQvMAzBwa1aW2fr1HVfB/UqBG
         s1wvW+1uRWfg2JhxQj6e7nn0zNS5Sl2KqEUDO5OwYTGM8bVkMSVpeOOezlZiGSnABbPf
         YalrtVpVLmbUhJyOF1CgtF+Eo1LRyuX8/zYrUlR8OoeiFVvLC9M3qd1hpiXza5IpKoC6
         Sx6e7+0f1kThvz8o1XulmYLf08k9GPzKrIXGff41aVbw9lmvuYI9nCfFrHTP/JcP2ONu
         Wrzw==
X-Gm-Message-State: AOAM531EJ/KYnSFAXO07og8GDEhu6eQA2fX9GKdk/nAckUji3tUTJxVN
        8HAfJTgdrlXt7ZCC9uZHHcZbmNXCe64=
X-Google-Smtp-Source: ABdhPJzj2s/HTixbl93w6AaGUy+KqMlJzDnwDFoD8ys7BSIlrDvYwYpy01Om2m9cXYwvFfJcebuHD0oTKDc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c78a:b0:142:1b7a:930 with SMTP id
 w10-20020a170902c78a00b001421b7a0930mr84382356pla.8.1637383860785; Fri, 19
 Nov 2021 20:51:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:22 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 04/28] KVM: x86/mmu: Retry page fault if root is invalidated
 by memslot update
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bail from the page fault handler if the root shadow page was obsoleted by
a memslot update.  Do the check _after_ acuiring mmu_lock, as the TDP MMU
doesn't rely on the memslot/MMU generation, and instead relies on the
root being explicit marked invalid by kvm_mmu_zap_all_fast(), which takes
mmu_lock for write.

For the TDP MMU, inserting a SPTE into an obsolete root can leak a SP if
kvm_tdp_mmu_zap_invalidated_roots() has already zapped the SP, i.e. has
moved past the gfn associated with the SP.

For other MMUs, the resulting behavior is far more convoluted, though
unlikely to be truly problematic.  Installing SPs/SPTEs into the obsolete
root isn't directly problematic, as the obsolete root will be unloaded
and dropped before the vCPU re-enters the guest.  But because the legacy
MMU tracks shadow pages by their role, any SP created by the fault can
can be reused in the new post-reload root.  Again, that _shouldn't_ be
problematic as any leaf child SPTEs will be created for the current/valid
memslot generation, and kvm_mmu_get_page() will not reuse child SPs from
the old generation as they will be flagged as obsolete.  But, given that
continuing with the fault is pointess (the root will be unloaded), apply
the check to all MMUs.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 23 +++++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d2ad12a4d66e..31ce913efe37 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1936,7 +1936,11 @@ static void mmu_audit_disable(void) { }
 
 static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	return sp->role.invalid ||
+	if (sp->role.invalid)
+		return true;
+
+	/* TDP MMU pages due not use the MMU generation. */
+	return !sp->tdp_mmu_page &&
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
@@ -3976,6 +3980,20 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	return true;
 }
 
+/*
+ * Returns true if the page fault is stale and needs to be retried, i.e. if the
+ * root was invalidated by a memslot update or a relevant mmu_notifier fired.
+ */
+static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault, int mmu_seq)
+{
+	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
+		return true;
+
+	return fault->slot &&
+	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
+}
+
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
@@ -4013,8 +4031,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
+
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f87d36898c44..708a5d297fe1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -911,7 +911,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
-	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+
+	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-- 
2.34.0.rc2.393.gf8c9666880-goog

