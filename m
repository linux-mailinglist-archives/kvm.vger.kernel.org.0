Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5B43344D
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 13:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhJSLEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 07:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbhJSLE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 07:04:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9EEC061746;
        Tue, 19 Oct 2021 04:02:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso1703205pjb.4;
        Tue, 19 Oct 2021 04:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+dHCDTEpaqypxNMT0rcakQRNLfKZkzPn3pC3wuFQcc=;
        b=lZUef7uP6DnHKHtQNFD//yOobud2THUXMHhReFuEJQcYd+0HOhZZLour/WAmoEof9Y
         fsPxT9VE0Hd9oClD0utwcrT8LjAl7Ogo1Qgl4Lwt9u72WEtLdKS5N7VabcihnFCOSQPo
         gGJUoLBDVetehQOiOqxbCxlFmaU55cmMWL61rVTQWF6xrKUGJHD3IPHc7XD48tg8sPLE
         bgOexpKOBSDE3hx+FRR/74+uRlWVhJNPVUae6AqiHvLbYNIPE1gQmLugGDFeZrS+gcAf
         1eKIcOoIMMJJwABe2lI8uL6NQJYuIZtxdmkRbR9NcD+plP4FfIkQYrvtauC705aKUh6c
         66Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+dHCDTEpaqypxNMT0rcakQRNLfKZkzPn3pC3wuFQcc=;
        b=TNlt3GXqIX+ttqGo3uDrksNr5GVkbG8Pb4G5n9zl0lYWfESR4V1QAdrHa7u/SyY+uL
         3QUcElXzEBVfJDAcLa/DnZAaWfWOy89XYErO245THBy+byAfzl9eNM3IA7v5KnpanY1K
         rp4JisRixoeGdhc6ykUoiotZtfvfhpxMj6hkGNRvVCJnkjwbiNv5wgSu7ViQMiLyR19d
         3pCFG3Fan1V2mqO7JR7WxkF9ajTInyZ6u2WxJsE5cLzS6q4YqnnQ43o6Aa5ZpMORCyVd
         MgTAZHUuuGVbz18KlmBexv9mVrx0PkrxGjmoSUFM3lW2m3e5Sah4uJ3tmb+SFcMy+D/z
         NZVg==
X-Gm-Message-State: AOAM533vUkCOYPC0iyT2lgoaK1vNxE5xgeOKT+1Dx8gNKkzwWpTDFj05
        7cX0W0XvjNcYknsQcoOZ426UPL/nD1s=
X-Google-Smtp-Source: ABdhPJwtN8VkQB3KsRA3kACXZEYdwRab04jxqJ8CX8CSk2Jg0mm/AyFNLVHgC0Hr0yY4VhKJLxcYBQ==
X-Received: by 2002:a17:90b:1910:: with SMTP id mp16mr5702421pjb.30.1634641336151;
        Tue, 19 Oct 2021 04:02:16 -0700 (PDT)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id i124sm16462896pfc.153.2021.10.19.04.02.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:02:15 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/4] KVM: X86: Don't unload MMU in kvm_vcpu_flush_tlb_guest()
Date:   Tue, 19 Oct 2021 19:01:54 +0800
Message-Id: <20211019110154.4091-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211019110154.4091-1-jiangshanlai@gmail.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

kvm_mmu_unload() destroys all the PGD caches.  Use the lighter
kvm_mmu_sync_roots() and kvm_mmu_sync_prev_roots() instead.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
 arch/x86/kvm/x86.c     | 11 +++++------
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1ae70efedcf4..8e9dd63b68a9 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -79,6 +79,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
+void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 900c7a157c99..fb45eeb8dd22 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3634,6 +3634,9 @@ static bool is_unsync_root(hpa_t root)
 {
 	struct kvm_mmu_page *sp;
 
+	if (!VALID_PAGE(root))
+		return false;
+
 	/*
 	 * Even if another CPU was marking the SP as unsync-ed simultaneously,
 	 * any guest page table changes are not guaranteed to be visible anyway
@@ -3706,6 +3709,19 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
+void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
+{
+	unsigned long roots_to_free = 0;
+	int i;
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		if (is_unsync_root(vcpu->arch.mmu->prev_roots[i].hpa))
+			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+
+	/* sync prev_roots by simply freeing them */
+	kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
+}
+
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gpa_t vaddr,
 				  u32 access, struct x86_exception *exception)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13df3ca88e09..1771cd4bb449 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3251,15 +3251,14 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.tlb_flush;
 
 	if (!tdp_enabled) {
-               /*
+		/*
 		 * A TLB flush on behalf of the guest is equivalent to
 		 * INVPCID(all), toggling CR4.PGE, etc., which requires
-		 * a forced sync of the shadow page tables.  Unload the
-		 * entire MMU here and the subsequent load will sync the
-		 * shadow page tables, and also flush the TLB.
+		 * a forced sync of the shadow page tables.  Ensure all the
+		 * roots are synced and the guest TLB in hardware is clean.
 		 */
-		kvm_mmu_unload(vcpu);
-		return;
+		kvm_mmu_sync_roots(vcpu);
+		kvm_mmu_sync_prev_roots(vcpu);
 	}
 
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
-- 
2.19.1.6.gb485710b

