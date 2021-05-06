Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE8C375D56
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhEFXQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhEFXQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:16:46 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D537AC061761
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 16:15:46 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l61-20020a0c84430000b02901a9a7e363edso5305761qva.16
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 16:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=S0EFe95CIa83FH/uR0CK5DeEnOSiVvW2gb1ym2pZaOs=;
        b=YI8500gjXbsMPkTWeUd9d4qkOvRGR55b+Blh1YjsV7bTdx2Uu23DX43NCLrLm8jXNX
         8IwQG+Bw3nBl+X9aSivNLLmVZ4aePC8vIMnLBJso7IoGPJHNUHQxR4Fo93zJ6LEqOCOV
         KjfjSvbBKo/0uxcH+ynv1MPrfLtpVxaY1U7WrYpsym+YZ6nZJNwptq2kobYrsamRb4WH
         WofcJtCp6Na3+C3ZVcnu8OhoLH0Cv8FYlYU0TO29X6W/mfqDiBXQzoOhHPFWxa0MmrVP
         D0WIIU3/McDobkN5q+u7omIzNr8cfySOmNoDuo4YsM5NRbUHPxabYK6uR7lVtANCaRcF
         y97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=S0EFe95CIa83FH/uR0CK5DeEnOSiVvW2gb1ym2pZaOs=;
        b=TvcdFKEBTNtdnJ3H0Bytc6jakFFCFUGLY/HwX2ah6MtTwNKcGN9dwuqdZ5rtOGOL/r
         WCgjVy/X3l1qBWbaiW/TJGvz+THYt61YexjHoxZhnnLX1OJa+EjbrT2cIVr+4OSWf8Z7
         mykKxRGQGsPkC83qRZLWhg+RBa0fxLxrVjht0LIY1A09Kf52veNNDVqk8dDVjzZsDECU
         sPtCc/e8yKaK8RxSpVj+ZGLksTWdrWhC38qh9OceiNN55eRZHf/KtgTXYFGVnRLvaIAM
         24sjRd8vDUpynkLQa3A/9pYqGMja/OBgY+RpMYVE0WrGGv3vsGKyn9Gs5GOGvdJWJBa/
         ZwHw==
X-Gm-Message-State: AOAM530hZdB/VOlV3oVSHiGLz6ph3FypoXgAHKKVTkj29biIgpUb/0dK
        Jo6lA98ULbmpmiLaXuyYz95cGNFKsvE=
X-Google-Smtp-Source: ABdhPJx/QMmmBfM7/niLPM9tz2+a7Ayuom0BmFJwoWUMdwo30QH3UjsA/dZPrPqzpkWJgIJB/5IQp304d9c=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:818d:5ca3:d49c:cfc8])
 (user=seanjc job=sendgmr) by 2002:a05:6214:241:: with SMTP id
 k1mr7031611qvt.29.1620342945773; Thu, 06 May 2021 16:15:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 May 2021 16:15:42 -0700
Message-Id: <20210506231542.2331138-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH] KVM: SVM: Invert user pointer casting in SEV {en,de}crypt helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invert the user pointer params for SEV's helpers for encrypting and
decrypting guest memory so that they take a pointer and cast to an
unsigned long as necessary, as opposed to doing the opposite.  Tagging a
non-pointer as __user is confusing and weird since a cast of some form
needs to occur to actually access the user data.  This also fixes Sparse
warnings triggered by directly consuming the unsigned longs, which are
"noderef" due to the __user tag.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a9d8d6aafdb8..bba4544fbaba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -763,7 +763,7 @@ static int __sev_dbg_decrypt(struct kvm *kvm, unsigned long src_paddr,
 }
 
 static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
-				  unsigned long __user dst_uaddr,
+				  void __user *dst_uaddr,
 				  unsigned long dst_paddr,
 				  int size, int *err)
 {
@@ -787,8 +787,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 
 	if (tpage) {
 		offset = paddr & 15;
-		if (copy_to_user((void __user *)(uintptr_t)dst_uaddr,
-				 page_address(tpage) + offset, size))
+		if (copy_to_user(dst_uaddr, page_address(tpage) + offset, size))
 			ret = -EFAULT;
 	}
 
@@ -800,9 +799,9 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 }
 
 static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
-				  unsigned long __user vaddr,
+				  void __user *vaddr,
 				  unsigned long dst_paddr,
-				  unsigned long __user dst_vaddr,
+				  void __user *dst_vaddr,
 				  int size, int *error)
 {
 	struct page *src_tpage = NULL;
@@ -810,13 +809,12 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	int ret, len = size;
 
 	/* If source buffer is not aligned then use an intermediate buffer */
-	if (!IS_ALIGNED(vaddr, 16)) {
+	if (!IS_ALIGNED((unsigned long)vaddr, 16)) {
 		src_tpage = alloc_page(GFP_KERNEL);
 		if (!src_tpage)
 			return -ENOMEM;
 
-		if (copy_from_user(page_address(src_tpage),
-				(void __user *)(uintptr_t)vaddr, size)) {
+		if (copy_from_user(page_address(src_tpage), vaddr, size)) {
 			__free_page(src_tpage);
 			return -EFAULT;
 		}
@@ -830,7 +828,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	 *   - copy the source buffer in an intermediate buffer
 	 *   - use the intermediate buffer as source buffer
 	 */
-	if (!IS_ALIGNED(dst_vaddr, 16) || !IS_ALIGNED(size, 16)) {
+	if (!IS_ALIGNED((unsigned long)dst_vaddr, 16) || !IS_ALIGNED(size, 16)) {
 		int dst_offset;
 
 		dst_tpage = alloc_page(GFP_KERNEL);
@@ -855,7 +853,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 			       page_address(src_tpage), size);
 		else {
 			if (copy_from_user(page_address(dst_tpage) + dst_offset,
-					   (void __user *)(uintptr_t)vaddr, size)) {
+					   vaddr, size)) {
 				ret = -EFAULT;
 				goto e_free;
 			}
@@ -935,15 +933,15 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		if (dec)
 			ret = __sev_dbg_decrypt_user(kvm,
 						     __sme_page_pa(src_p[0]) + s_off,
-						     dst_vaddr,
+						     (void __user *)dst_vaddr,
 						     __sme_page_pa(dst_p[0]) + d_off,
 						     len, &argp->error);
 		else
 			ret = __sev_dbg_encrypt_user(kvm,
 						     __sme_page_pa(src_p[0]) + s_off,
-						     vaddr,
+						     (void __user *)vaddr,
 						     __sme_page_pa(dst_p[0]) + d_off,
-						     dst_vaddr,
+						     (void __user *)dst_vaddr,
 						     len, &argp->error);
 
 		sev_unpin_memory(kvm, src_p, n);
-- 
2.31.1.607.g51e8a6a459-goog

