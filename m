Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894E450C35B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiDVWPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiDVWPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C619E31A15A
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:06 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id ij17-20020a170902ab5100b00158f6f83068so5391729plb.19
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kWwdM6A6P8/IuSsS3ESiLqrrdzrHfrWJ/AAbUmXSl2Q=;
        b=R5R30ofn1vT0B52vHAVy90sP8NWeAZk6uMpASj40sPxLLgzd2ZuOhesc6L/vaSciGX
         87A3/3Qkbiw1Jk6/rP7+fnq2RGGkxxQAxUHvI0b1BWtmszbA0LwIv3qS7ZaWzCx0KLaL
         VK5tmwOU/bgQEzGPKc94RnF/A3q/3k7LFK3VARKssk6TAFHeYXKTzl0zRj3Q3p3xHuKj
         ASu3Vi4NipZHZTd78zSj5VH0uaJlnVnRVoaWpMPez2YoRLrby2DeUwBQ56WSIMTywDqq
         QSQk+xMkFSDdB3EgCE3L0r1ViEw6ieR9wK4UKK8wJZZxeRSsEhnpihM85gN+RwfYexCl
         p7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kWwdM6A6P8/IuSsS3ESiLqrrdzrHfrWJ/AAbUmXSl2Q=;
        b=RN0tb5c0vil9Rm5Orb+1D00p1y/Vq+Ry2Q1njfVMRaeXa4TXnjpLwTFb6jJTzRyeIm
         SKlTgk33J9gjtVQXLDM2KUOXQdjqu4yyUJ4snyP+ez2nSO/jceAHq+wGbGNwk2jszTfZ
         2n47koOTa6a34V0BPNB8bhslYSLVKN68sRBW5QvWKmnSuUudOQvo2CQ+6sK/IrRoPsq8
         IRoFbKCd8fAYe8y9A+cfoHGoF/ccqAh6kNIdZBvbzEwvjZXv7TjD2DbyTBzbeSH0SCBP
         hIzo/8a+SDxGbj4yrh+esoXgndrHoClW8XTmfvmK8462ldvARy9hQ/c6ulzEqERcbBDB
         6ZNQ==
X-Gm-Message-State: AOAM532ZBO16/ppQcqGXi90KFnuxFtOG5UlImzU40Ce4lvwTJqacrjpb
        Okb7UQe44tzu2yCmHX6UC0yjVNP+WVxBzQ==
X-Google-Smtp-Source: ABdhPJyrKsBSTehaAqfzYOFua5pU71lBgPsCafuSicdpbjxOGLjE18EgDYm93QHLrLLvseNhpIztJ+Y4kBHGiw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:10d0:b0:4f7:5af4:47b6 with SMTP
 id d16-20020a056a0010d000b004f75af447b6mr6733898pfu.6.1650661566123; Fri, 22
 Apr 2022 14:06:06 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:37 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in __kvm_mmu_get_shadow_page()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
it to vcpu_or_null to prevent future commits from accidentally taking
dependency on it without first considering the NULL case.

The vcpu pointer is only used for syncing indirect shadow pages in
kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
correctness since unsync pages can simply be zapped. But this should
never occur in practice, since the only use-case for passing a NULL vCPU
pointer is eager page splitting which will only request direct shadow
pages (which can never be unsync).

Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
called to get an indirect shadow page with a NULL vCPU pointer, since
zapping unsync SPs is a performance overhead that should be considered.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04029c01aebd..21407bd4435a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			 struct list_head *invalid_list)
+static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
+			   struct kvm_mmu_page *sp,
+			   struct list_head *invalid_list)
 {
-	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
+	int ret = -1;
+
+	if (vcpu_or_null)
+		ret = vcpu_or_null->arch.mmu->sync_page(vcpu_or_null, sp);
 
 	if (ret < 0)
-		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+
 	return ret;
 }
 
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			 struct list_head *invalid_list)
+{
+	return __kvm_sync_page(vcpu->kvm, vcpu, sp, invalid_list);
+}
+
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 					struct list_head *invalid_list,
 					bool remote_flush)
@@ -2004,7 +2015,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
 }
 
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
-						     struct kvm_vcpu *vcpu,
+						     struct kvm_vcpu *vcpu_or_null,
 						     gfn_t gfn,
 						     struct hlist_head *sp_list,
 						     union kvm_mmu_page_role role)
@@ -2053,7 +2064,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			 * If the sync fails, the page is zapped.  If so, break
 			 * in order to rebuild it.
 			 */
-			ret = kvm_sync_page(vcpu, sp, &invalid_list);
+			ret = __kvm_sync_page(kvm, vcpu_or_null, sp, &invalid_list);
 			if (ret < 0)
 				break;
 
@@ -2120,7 +2131,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 }
 
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
-						      struct kvm_vcpu *vcpu,
+						      struct kvm_vcpu *vcpu_or_null,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      union kvm_mmu_page_role role)
@@ -2129,9 +2140,22 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
+	/*
+	 * A vCPU pointer should always be provided when getting indirect
+	 * shadow pages, as that shadow page may already exist and need to be
+	 * synced using the vCPU pointer (see __kvm_sync_page()). Direct shadow
+	 * pages are never unsync and thus do not require a vCPU pointer.
+	 *
+	 * No need to panic here as __kvm_sync_page() falls back to zapping an
+	 * unsync page if the vCPU pointer is NULL. But still WARN() since
+	 * such zapping will impact performance and this situation is never
+	 * expected to occur in practice.
+	 */
+	WARN_ON(!vcpu_or_null && !role.direct);
+
 	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
-	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
+	sp = kvm_mmu_find_shadow_page(kvm, vcpu_or_null, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
 		sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

