Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90024579CA
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhKTABW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbhKTABP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:15 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDA3C061748
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y68-20020a627d47000000b004a2f6a1551cso6427048pfc.23
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+HxitEmGbj7Id7UQJr+hxa1o5D7b2Er3V4lZLdOvJG8=;
        b=EK/bV7ojvgVmkLrNi00TKk1XmZpxKHttG8Bc1EYVUrOnNsWdM46gHGNguTCjaR++Ii
         JHaMc4EX7/DVj3TlWbdgC12Dn5zoXTi8dj0h2Qlkq37JH0ICJtLp5oSfbFhgFiP00WqL
         GsXsISE9PuL8ZTLvYyP3b7yTEGO7LV92K2pbJ5sSnvsH6UngvfdBzqedesbryjQxyBIm
         mJWc3fsTxYVsFuPyGTVCWhWySzgMsTVpTHOKjsjUYL5doqCmqsgddSKMgGfoxCXUTEso
         dgs0xhNzVObQ0K7QOiDkps/gee+y/8UeSe4Ci478GvEw7z5BJAOkJxaPMT68Jl5m1xt3
         VRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+HxitEmGbj7Id7UQJr+hxa1o5D7b2Er3V4lZLdOvJG8=;
        b=h9v4L6Zb+ZERwdEJzCNF0tJxJ5EZQCxr6TXHqaJ3nZNmYye6qpvbojFdy6q+K14Ja5
         CcP0vm0eV1B7SCvcfXkFOmKQp1RwTiQBlGXFKK512TE3skb/YXmU3mGQ5OoDMk5sS3hu
         gwPj9OeceH0TOf8loZIxc5RTyfg97rkmPLsUcikEAl+6dzjxrV+/z+s+jjkDGpIg4VU/
         Gzz0x2Wcg14dhpmiPqsVG2Bh8WyfiB5qGnWdExBkc7/XWcL65KMJBeAwMsZBRCvI3vFN
         B9YPM05EvzK6n7Kq/smD4zJIdDeWbkT5VuD08f2FraT1CjqLxdiVr1uasjMtACHxW2xc
         aBXw==
X-Gm-Message-State: AOAM5339vfZ9AI8At6ykCCfsvRBDcHflajv759/FYVR1vaRuo1mfruSM
        mBRg5SVd89lTDd9KpmP3fq4vJH2c4LSsVg==
X-Google-Smtp-Source: ABdhPJyJj/jj6PyPdfLsTctRVdRlpXqWMEKRuU5wE1dWY6q2mnCQ8u+lhrPPEHegii0T+HEf93zFFAoJRfnL1g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr597329pjf.1.1637366291551; Fri, 19 Nov 2021 15:58:11 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:45 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 01/15] KVM: x86/mmu: Rename rmap_write_protect to kvm_vcpu_write_protect_gfn
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rmap_write_protect is a poor name because we may not even touch the rmap
if the TDP MMU is in use. It is also confusing that rmap_write_protect
is not a simpler wrapper around __rmap_write_protect, since that is the
typical flow for functions with double-underscore names.

Rename it to kvm_vcpu_write_protect_gfn to convey that we are
write-protecting a specific gfn in the context of a vCPU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f0035517450..16ffb571bc75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1427,7 +1427,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
-static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
+static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
 
@@ -2026,7 +2026,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 		bool protected = false;
 
 		for_each_sp(pages, sp, parents, i)
-			protected |= rmap_write_protect(vcpu, sp->gfn);
+			protected |= kvm_vcpu_write_protect_gfn(vcpu, sp->gfn);
 
 		if (protected) {
 			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, true);
@@ -2153,7 +2153,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		account_shadowed(vcpu->kvm, sp);
-		if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
+		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
 	trace_kvm_mmu_get_page(sp, true);
-- 
2.34.0.rc2.393.gf8c9666880-goog

