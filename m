Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42FA69990F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBPPk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBPPkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:40:23 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CAF442F8;
        Thu, 16 Feb 2023 07:40:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gd1so2274000pjb.1;
        Thu, 16 Feb 2023 07:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/IHRnlveZmpXPbh7NfGCDFcLzaUFNSKaJFAnpbfK4s=;
        b=Zy+XA6p0t+9jMxNIRNnZ+E9JkpTIEVSfz+F6h+4e2k4kEGWzj5a5ymGwnZi10vB0ua
         ikL0VWqXrD7snVCGS9palqBGFr0YdjbTtX4VJ+gFvwnoLsKXMDWyoYGy/t9JwKZlWC3u
         B+KJmCcXRX/W7hMdm268z7I0KT7bizDZPU3U8uaOcqu3JgsbCCMFChQuDWEqi6NoRqqR
         ZhFDH6r+XK3JhGOvUyLbqiFbtrK6RXt/u2rzdjT6iFxGWcDuTxDorp5oFspL90VyWEIb
         dzNtQwQ1j10LLdVuPQKL1JgmfNwqvQzmTgBGTWEE69ZgCk4KNOQN3VErZXf6P+Acg1MF
         +sgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/IHRnlveZmpXPbh7NfGCDFcLzaUFNSKaJFAnpbfK4s=;
        b=kAcDMY6FBamviO/BZfmoYvJsV/u3sDyubBlAPu7EwJoyTr89tI4ayH9s/r0UOcXplc
         YpgQDcea/c/9v/rVMgYx4Xd9YRcbOxpivrILHeubwl4KMGvQrMCLQd6Dv7xyt/npxxBL
         WdpBhxi7FhTqdlb1TwnweuiRJYUkyX5cF54mqUN/cERzGgLHwj5bBrdiF1X4Bm8vOZlg
         SgwD8uASNn+v1Fsq+UXH6JZYwGWzGpHkw+BQLRJwLisnTNapPzdbkwSZUBLj1W67l6AS
         dEl8Ofg2GZQpAGAUHFe0peIxfJkxG2DX4V8PzBD9+r2oX3KVfXvud0CK5HDJkTFQn2Cy
         bvQA==
X-Gm-Message-State: AO0yUKVoKHqGw9pswDJ91PtYoox5IJ6ZxUrTMWSLFHsO2FVGQoAKDShg
        Oyhf08sGAlmnhnALoxziVYFal6velt4=
X-Google-Smtp-Source: AK7set/estWXJ8U86Q9aRtEr8qUlKEKbZwDhRRfwcjJkiUbCoipRO/C40uGFb/YTyXFdx4V0y2Zgyg==
X-Received: by 2002:a17:903:22c9:b0:19a:a6ec:6721 with SMTP id y9-20020a17090322c900b0019aa6ec6721mr7425834plg.16.1676562020969;
        Thu, 16 Feb 2023 07:40:20 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001992b8cf89bsm1482669plj.16.2023.02.16.07.40.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:20 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 02/14] kvm: x86/mmu: Move the check in FNAME(sync_page) as kvm_sync_page_check()
Date:   Thu, 16 Feb 2023 23:41:08 +0800
Message-Id: <20230216154115.710033-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Prepare to check mmu->sync_page pointer before calling it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 43 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h | 27 ---------------------
 2 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 91f8e1d1d4cc..ee2837ea18d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1914,10 +1914,51 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
 
+static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
+
+	/*
+	 * Ignore various flags when verifying that it's safe to sync a shadow
+	 * page using the current MMU context.
+	 *
+	 *  - level: not part of the overall MMU role and will never match as the MMU's
+	 *           level tracks the root level
+	 *  - access: updated based on the new guest PTE
+	 *  - quadrant: not part of the overall MMU role (similar to level)
+	 */
+	const union kvm_mmu_page_role sync_role_ign = {
+		.level = 0xf,
+		.access = 0x7,
+		.quadrant = 0x3,
+		.passthrough = 0x1,
+	};
+
+	/*
+	 * Direct pages can never be unsync, and KVM should never attempt to
+	 * sync a shadow page for a different MMU context, e.g. if the role
+	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
+	 * reserved bits checks will be wrong, etc...
+	 */
+	if (WARN_ON_ONCE(sp->role.direct ||
+			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
+		return false;
+
+	return true;
+}
+
+static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	if (!kvm_sync_page_check(vcpu, sp))
+		return -1;
+
+	return vcpu->arch.mmu->sync_page(vcpu, sp);
+}
+
 static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
-	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
+	int ret = __kvm_sync_page(vcpu, sp);
 
 	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c7b1de064be5..e0aae0a7f646 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -984,38 +984,11 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
-	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
 	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
 	bool flush = false;
 
-	/*
-	 * Ignore various flags when verifying that it's safe to sync a shadow
-	 * page using the current MMU context.
-	 *
-	 *  - level: not part of the overall MMU role and will never match as the MMU's
-	 *           level tracks the root level
-	 *  - access: updated based on the new guest PTE
-	 *  - quadrant: not part of the overall MMU role (similar to level)
-	 */
-	const union kvm_mmu_page_role sync_role_ign = {
-		.level = 0xf,
-		.access = 0x7,
-		.quadrant = 0x3,
-		.passthrough = 0x1,
-	};
-
-	/*
-	 * Direct pages can never be unsync, and KVM should never attempt to
-	 * sync a shadow page for a different MMU context, e.g. if the role
-	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
-	 * reserved bits checks will be wrong, etc...
-	 */
-	if (WARN_ON_ONCE(sp->role.direct ||
-			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
-		return -1;
-
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
-- 
2.19.1.6.gb485710b

