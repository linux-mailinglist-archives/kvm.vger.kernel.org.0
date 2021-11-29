Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093A646289D
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 00:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhK2Xz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhK2Xzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 18:55:54 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D569C061714
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:52:36 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id bf17-20020a17090b0b1100b001a634dbd737so10469927pjb.9
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=0Gmtrp3NH5uXwCtG181ObBI/n19QY3gSbtUjJkb+q2M=;
        b=D5xlL7hwJPlgWEiwJTo08vPV9G0H5ZA+oRdXuIj9NCStElLvjUsHJ7NA9Xav/D5RHa
         fyZ7B7YsMaeg9SEzLMOHwCBeKNRRxlK92Tn4CI3MezwnPW18upIXoDvfLVYsFqSd40sH
         xBMA3kGHIYnIulZDhOsboTHQubK7mLy5ndSJMPzFA3twmpxfds9XDEm9AxrTFc3m5BSe
         W25Hzq5llNSSCRXt27wFUTBkCxXWXArULqojzDivAU+A0QIS+qQKh09FGs6lu+1ACgej
         UFJEl5MiN/aDsW2KyWVQpUQrIa8tlnK8JJ1KG70wNsmArRKqFPI2sh59z2XQqdpT2i7l
         8N3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=0Gmtrp3NH5uXwCtG181ObBI/n19QY3gSbtUjJkb+q2M=;
        b=isV33kyd439jrkCP6lgoFGXSrXBUtBtL6REyTXwKEbOW+RcRpguBNwqw0D3X+ViwEr
         Q6pwKZF86iPlLeF2NSz5LxIZue5gJvNdLsWpg+Vdb7GBpKV04PQWYlBZCcdm/4BQv4OZ
         k77lrmU4Y9jGoRsDhjilXZS84YuJZglvag4xvf5prl6K5Hptt3GBqnOsBZ0cTuF8uDqR
         kY4JwujMJeJ7Rop9DujaMzRC7++8+i5Af2zhHAa8CSn+dwOTFrP1ryg1ea7xtblMZQtY
         KmZ4bN9LOHC9m5s7EsYN15z4UNL2jSoNTDuMHVkG4Cp6KdxmLQQpobTrc8SFPHEnIRud
         rU2w==
X-Gm-Message-State: AOAM533T9P8VPgw/fXfd46JVHxwxnTxfocDR7BS+nN7mTaiBWCIfv7e0
        xlFIpDUmuNELBN5Iyi0LVPdr6SwY7yw=
X-Google-Smtp-Source: ABdhPJx5/Zc7ZiQKs9kKczsYqMkf748/5k1+Bg3UxWj5lVtqGKqQRrhURDo1NOy8lml7KuRt5m2jB2Rr6ic=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8c2:b0:4a8:3013:145a with SMTP id
 s2-20020a056a0008c200b004a83013145amr4172981pfu.5.1638229955970; Mon, 29 Nov
 2021 15:52:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 29 Nov 2021 23:52:33 +0000
Message-Id: <20211129235233.1277558-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v2] KVM: x86/mmu: Update number of zapped pages even if page
 list is stable
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When zapping obsolete pages, update the running count of zapped pages
regardless of whether or not the list has become unstable due to zapping
a shadow page with its own child shadow pages.  If the VM is backed by
mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
the batch count and thus without yielding.  In the worst case scenario,
this can cause a soft lokcup.

 watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
   RIP: 0010:workingset_activation+0x19/0x130
   mark_page_accessed+0x266/0x2e0
   kvm_set_pfn_accessed+0x31/0x40
   mmu_spte_clear_track_bits+0x136/0x1c0
   drop_spte+0x1a/0xc0
   mmu_page_zap_pte+0xef/0x120
   __kvm_mmu_prepare_zap_page+0x205/0x5e0
   kvm_mmu_zap_all_fast+0xd7/0x190
   kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
   kvm_page_track_flush_slot+0x5c/0x80
   kvm_arch_flush_shadow_memslot+0xe/0x10
   kvm_set_memslot+0x1a8/0x5d0
   __kvm_set_memory_region+0x337/0x590
   kvm_vm_ioctl+0xb08/0x1040

Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
Reported-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2:
 - Rebase to kvm/master, commit 30d7c5d60a88 ("KVM: SEV: expose...")
 - Collect Ben's review, modulo bad splat.
 - Copy+paste the correct splat and symptom. [David].

@David, I kept the unstable declaration out of the loop, mostly because I
really don't like putting declarations in loops, but also because
nr_zapped is declared out of the loop and I didn't want to change that
unnecessarily or make the code inconsistent.

 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0c839ee1282c..208c892136bf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5576,6 +5576,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
+	bool unstable;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
@@ -5607,11 +5608,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			goto restart;
 		}
 
-		if (__kvm_mmu_prepare_zap_page(kvm, sp,
-				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
-			batch += nr_zapped;
+		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
+				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
+		batch += nr_zapped;
+
+		if (unstable)
 			goto restart;
-		}
 	}
 
 	/*
-- 
2.34.0.rc2.393.gf8c9666880-goog

