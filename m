Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C35F5088F3
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376471AbiDTNOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiDTNOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:14:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FE43D1E1;
        Wed, 20 Apr 2022 06:11:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s14so1726089plk.8;
        Wed, 20 Apr 2022 06:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2C18i9mk0AxmdYsk78ordW23WD/zuKFKPHlUE7fZPyo=;
        b=WD6f7zl5bfuQMvqTkd7lGqrYDhWxkwK5FurI28K5hrO3bAL3d4R+mAnaEzcSRXYpfl
         Vv0UkkW3Q6ztlZQO/N2koOPS7tp5Sdy1jSIEzLUkLu8ot3UCauPD20DBidyBMVMHxrjY
         5YJr6fLD01AyVDEjOYMHiSSY66mjiZrHVPS3yljnwwlXt7eQ+smIrcl7+siKWq841E3i
         iZb3fQTwXnUdp6Ywv3qHpuXhP6MI/uOGyA8ZjrgW9woV9+h+/iGOaRsJn0m+Z4P7qU8c
         VlKOBoXq3ATqSaO2Av9+CSmfQxHAUJ7zQLMk4rqZYB7OaYE51PbLzrYkZm5RtIMXVydA
         sCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2C18i9mk0AxmdYsk78ordW23WD/zuKFKPHlUE7fZPyo=;
        b=ygxNSLojoOVUJsftKQMeyaJc/2hBEwe9JezO4if0Wvt8lGpc615TijiQQXeLQR+kVg
         XCoy4WVikiZA1wPhQXg9wssG6tM76wqma4xcqL41sEhDSSeb9hPr94G7B9fHgOoKLuWK
         CmcGAeZTQ5UbeIHaX5urT3CiI0gjNdpiH0iMKJMJ0vd36oh/QRXI+2zhsLMvfexkUDPO
         sNQpiUQlMJD2pwAg7HZGo+CQzIYWXRkmnOQ1F6z15/3jG3DNq1gJh+B++Vt24xaMgYe2
         mVDjBquzl5pAkcw0HfVad6g6VlxMajI4un4FEo1dm99V1nQm0m6chNPUMW2X9E3hMu28
         RF2Q==
X-Gm-Message-State: AOAM531SVG5jxUVmezmzX26JxkoU+bMSCDcLYNh70Sn1Ikfd+yPV39A3
        0Is/gE2jFSc0hunbG0LGF9HKrU/oMxk=
X-Google-Smtp-Source: ABdhPJztmDRLIWjd/9493LpkAI13JE3NTwegVBUXFfFHlEble9ySj3WpWUcF08Rbg0ejNDZwpCGqvA==
X-Received: by 2002:a17:90b:4b07:b0:1d1:8a08:5096 with SMTP id lx7-20020a17090b4b0700b001d18a085096mr4321458pjb.91.1650460281335;
        Wed, 20 Apr 2022 06:11:21 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id s190-20020a625ec7000000b005061c17c111sm20299959pfb.71.2022.04.20.06.11.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:11:21 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] KVM: X86/MMU: Add sp_has_gptes()
Date:   Wed, 20 Apr 2022 21:12:03 +0800
Message-Id: <20220420131204.2850-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420131204.2850-1-jiangshanlai@gmail.com>
References: <20220420131204.2850-1-jiangshanlai@gmail.com>
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

Add sp_has_gptes() which equals to !sp->role.direct currently.

Shadow page having gptes needs to be write-protected, accounted and
responded to kvm_mmu_pte_write().

Use it in these places to replace !sp->role.direct and rename
for_each_gfn_indirect_valid_sp.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..1bdff55218ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1856,15 +1856,23 @@ static bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
+static bool sp_has_gptes(struct kvm_mmu_page *sp)
+{
+	if (sp->role.direct)
+		return false;
+
+	return true;
+}
+
 #define for_each_valid_sp(_kvm, _sp, _list)				\
 	hlist_for_each_entry(_sp, _list, hash_link)			\
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
-#define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
+#define for_each_gfn_valid_sp_has_gptes(_kvm, _sp, _gfn)		\
 	for_each_valid_sp(_kvm, _sp,					\
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
-		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
+		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
 
 static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
@@ -2112,7 +2120,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (!direct) {
+	if (sp_has_gptes(sp)) {
 		account_shadowed(vcpu->kvm, sp);
 		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
@@ -2321,7 +2329,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	/* Zapping children means active_mmu_pages has become unstable. */
 	list_unstable = *nr_zapped;
 
-	if (!sp->role.invalid && !sp->role.direct)
+	if (!sp->role.invalid && sp_has_gptes(sp))
 		unaccount_shadowed(kvm, sp);
 
 	if (sp->unsync)
@@ -2501,7 +2509,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
 	write_lock(&kvm->mmu_lock);
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
+	for_each_gfn_valid_sp_has_gptes(kvm, sp, gfn) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
@@ -2563,7 +2571,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * that case, KVM must complete emulation of the guest TLB flush before
 	 * allowing shadow pages to become unsync (writable by the guest).
 	 */
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
+	for_each_gfn_valid_sp_has_gptes(kvm, sp, gfn) {
 		if (!can_unsync)
 			return -EPERM;
 
@@ -5311,7 +5319,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	++vcpu->kvm->stat.mmu_pte_write;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
+	for_each_gfn_valid_sp_has_gptes(vcpu->kvm, sp, gfn) {
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
-- 
2.19.1.6.gb485710b

