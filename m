Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE133B0C02
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhFVSBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhFVSAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:38 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723B6C061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p14-20020a63fe0e0000b0290223af1026abso997804pgh.20
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WckRIopBZujqPimPvM/oO/U/oSKI+UjuEVuOH/hGa7M=;
        b=T9yfHpqlRV49gaT9p3DmZYwhIi1zHM045117HZQdXfkWe97BxhPoL5Hr+sN7dkzCEv
         f5alEzpKIictZXcSdK8iO/LI6fCxUq0Yf07xSrfxFrCI9sVf3biZPBX8ZA/XKBK3JXyJ
         1ymPPY0G8qOhD36obQqknBUOEfJCZPPIO1TbH9wVthEUGgsD0/r140V6+aHsf/Xoc4cz
         acSaRWRw2JCC/CMkb8vGIAxlhv/8zPHDDpKvluzKVu/IEoocC9EexgGlbxA5cJFvbGvy
         E8EO+lfTRurlih+hQQh62ngeczQ2RVeDrlv43liawU0EjECbHiBY3YKHDfmk+uoQ08Zp
         Eb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WckRIopBZujqPimPvM/oO/U/oSKI+UjuEVuOH/hGa7M=;
        b=QySTb5FSROD7MV3PZ6YEcgcfZeWEqvcS5EbGBTUv9GBorueoZMALJNsq5S05zpnS4a
         OAvSoj7ePfPYd27kTXJNaKb/FaR4yJxdpVx0iXli7MBPT3jYzFRQXsUOZ8++HNn6TWkT
         BndhOTYpruPHVYEgz3Thp/CWUVcBEHhAmgGPey3TsqF33nAygxN7niA1kv0ekbTHV42B
         TTwURKyEbPQPs6/0TMsUYRpTfmEuKU02d/SZhHXXKuhUrGEZe6eS71kwoDW+FmPLTfa8
         2sAnBtwJsLjZozIkMEWKDlu7vp5VmWcEb+Bcn5W4di9PKeLlyAVWvdQPqfZqXOoPczHe
         98LQ==
X-Gm-Message-State: AOAM5314fsEZtzNX9SqA5d0GGTEGSjkfhS6BuNLp6meYAEubNt31O2EP
        C2SOFMBrdfsysnabqAg8s3lHUMR8G2E=
X-Google-Smtp-Source: ABdhPJy8FvZRNmaIg8SNCQdNGVcEAG0m88+/R6/1ZpHaizYReKVRFaYUzt3lqk/OieeiNu450WJ3KxZxfSw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c796:: with SMTP id
 gn22mr92986pjb.0.1624384698638; Tue, 22 Jun 2021 10:58:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:55 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 10/54] KVM: x86/mmu: Replace EPT shadow page shenanigans with
 simpler check
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the hack to identify nested EPT shadow pages with a simple check
that the size of the guest PTEs associated with the shadow page and the
current MMU match, which is the intent of the "8 bytes == PAE" test.
The nested EPT hack existed to avoid a false negative due to the is_pae()
check not matching for 32-bit L2 guests; checking the MMU role directly
avoids the indirect calculation of the guest PTE size entirely.

Note, this should be a glorified nop now that __kvm_sync_page() is called
if and only if the role is an exact match (kvm_mmu_get_page()) or is part
of the current MMU context (kvm_mmu_sync_roots()).  A future commit will
convert the likely-pointless check into a meaningful WARN to enforce that
the mmu_roles of the current context and the shadow page are compatible.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/mmu.rst |  3 ---
 arch/x86/kvm/mmu/mmu.c         | 16 +++-------------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 20d85daed395..ddbb23998742 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -192,9 +192,6 @@ Shadow pages contain the following information:
     Contains the value of cr4.smap && !cr0.wp for which the page is valid
     (pages for which this is true are different from other pages; see the
     treatment of cr0.wp=0 below).
-  role.ept_sp:
-    This is a virtual flag to denote a shadowed nested EPT page.  ept_sp
-    is true if "cr0_wp && smap_andnot_wp", an otherwise invalid combination.
   role.smm:
     Is 1 if the page is valid in system management mode.  This field
     determines which of the kvm_memslots array was used to build this
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 99d26859021d..9f277c5bab76 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1780,16 +1780,13 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-static inline bool is_ept_sp(struct kvm_mmu_page *sp)
-{
-	return sp->role.cr0_wp && sp->role.smap_andnot_wp;
-}
-
 /* @sp->gfn should be write-protected at the call site */
 static bool __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			    struct list_head *invalid_list)
 {
-	if ((!is_ept_sp(sp) && sp->role.gpte_is_8_bytes != !!is_pae(vcpu)) ||
+	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role.base;
+
+	if (sp->role.gpte_is_8_bytes != mmu_role.gpte_is_8_bytes ||
 	    vcpu->arch.mmu->sync_page(vcpu, sp) == 0) {
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return false;
@@ -4721,13 +4718,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.guest_mode = true;
 	role.base.access = ACC_ALL;
 
-	/*
-	 * WP=1 and NOT_WP=1 is an impossible combination, use WP and the
-	 * SMAP variation to denote shadow EPT entries.
-	 */
-	role.base.cr0_wp = true;
-	role.base.smap_andnot_wp = true;
-
 	role.ext = kvm_calc_mmu_role_ext(vcpu);
 	role.ext.execonly = execonly;
 
-- 
2.32.0.288.g62a8d224e6-goog

