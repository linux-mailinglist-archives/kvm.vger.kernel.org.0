Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0917277DC6
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 04:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgIYCAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 22:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgIYCAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 22:00:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608FC0613D4
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 19:00:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x1so1266406ybi.4
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 19:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Y06C3d8gRlVIiH+a/DZUSriRyLlq/Qy1nRNdUsM+sAw=;
        b=GXfea3Qo5SPVCB6zPnPqFml4mMW4ETxCYvtg6DkSi8qUGa1Zwf9u6NLZJsEukeZZLO
         9ozz3hSeWFxj2yzhjImj8k1WGGPrJq+u+ncjP0sWrEb1gSFusuBGk1k/JQFIwfVlxYbb
         nopXxvAEt2X3V6ShgrPyWnxP23jSmaAbt4En49JyFwCYca6Smxa1V37vrwXa8eKDhuE+
         jZeIdWLYYapx1aH+qtubvC3Gzc76YFMhbNMl47t3s43mmYU5K7XD4QERdLROZUwhI/Pv
         3R1nJ/KXxngXUsjI4UpazW297HMCdW3XBTGhx2NjcC+7NRbfPExV1pzqYCDjcjWO1Ws5
         JThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y06C3d8gRlVIiH+a/DZUSriRyLlq/Qy1nRNdUsM+sAw=;
        b=I93R/KJ8YSEuuAkPWv1FMnsaQ5IWETdhoXPPR1BVyS+hmvDDv7/hGSRSDvAfs20FGB
         gSO89mn62SZtosLsOQAn/oyq7qh/By8XKwDPDlIi/CQC+52Nve59Fp2FOwFP6ndh/0OW
         FcddXbCT0/QqDCmHjp78yea0QRSglCnaohT08W0+E3S7lpY0QaZgwaW3yCjdu2/PS99Z
         /SBlqo+J/ha32kVQS8a65sfVV/O3XLcJe7TCUAKxgCjkxuSlFD6dmgJRNgMfyNocOTri
         nF95nCKYnRzF/APP+nim331h07ALsJ5VdLJjD4mBWZ2gbSSm0N9gMFazsAA0RsCIZdWW
         VG5Q==
X-Gm-Message-State: AOAM532wadchfz7XIVyCob7TiDePlZQHEpZ03p5GBA6S3+98tF6umx8Y
        1umvjDgkL2s8yNq8+RA4xPHP6O/VIASFymjOgTJM9xYJu7GijzzW21HrkzzI43DiWI1ykHxxMEN
        tLftkX4FR0qQnpfFj1W4BehtG/+WgixrFywrU7omd0W5zTsKsX8mv
X-Google-Smtp-Source: ABdhPJz5rQ1t0pb1JJRyVoLVT/N/+7t6zAsJOr3F9AwPqot8pRccyoYZLojtSZ41PDH3NySyRqTRfjIN
Sender: "cfir via sendgmr" <cfir@cfir.sea.corp.google.com>
X-Received: from cfir.sea.corp.google.com ([2620:15c:158:202:a6ae:11ff:fe11:da08])
 (user=cfir job=sendgmr) by 2002:a25:e80d:: with SMTP id k13mr2135631ybd.179.1600999237042;
 Thu, 24 Sep 2020 19:00:37 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:00:11 -0700
In-Reply-To: <20200807012303.3769170-1-cfir@google.com>
Message-Id: <20200925020011.1159247-1-cfir@google.com>
Mime-Version: 1.0
References: <20200807012303.3769170-1-cfir@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
From:   Cfir Cohen <cfir@google.com>
To:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>
Cc:     Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Cfir Cohen <cfir@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LAUNCH_SECRET command performs encryption of the
launch secret memory contents. Mark pinned pages as
dirty, before unpinning them.
This matches the logic in sev_launch_update_data().

Fixes: 9c5e0afaf157 ("KVM: SVM: Add support for SEV LAUNCH_SECRET command")
Signed-off-by: Cfir Cohen <cfir@google.com>
---
Changelog since v2:
 - Added 'Fixes' tag, updated comments.
Changelog since v1:
 - Updated commit message.

 arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5573a97f1520..55edaf3577a0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -440,10 +440,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 	/*
-	 * The LAUNCH_UPDATE command will perform in-place encryption of the
-	 * memory content (i.e it will write the same memory region with C=1).
-	 * It's possible that the cache may contain the data with C=0, i.e.,
-	 * unencrypted so invalidate it first.
+	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
+	 * place, the cache may contain data that was written unencrypted.
 	 */
 	sev_clflush_pages(inpages, npages);
 
@@ -799,10 +797,9 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		}
 
 		/*
-		 * The DBG_{DE,EN}CRYPT commands will perform {dec,en}cryption of the
-		 * memory content (i.e it will write the same memory region with C=1).
-		 * It's possible that the cache may contain the data with C=0, i.e.,
-		 * unencrypted so invalidate it first.
+		 * Flush (on non-coherent CPUs) before DBG_{DE,EN}CRYPT reads or modifies
+		 * the pages, flush the destination too in case the cache contains its
+		 * current data.
 		 */
 		sev_clflush_pages(src_p, 1);
 		sev_clflush_pages(dst_p, 1);
@@ -850,7 +847,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	struct kvm_sev_launch_secret params;
 	struct page **pages;
 	void *blob, *hdr;
-	unsigned long n;
+	unsigned long n, i;
 	int ret, offset;
 
 	if (!sev_guest(kvm))
@@ -863,6 +860,12 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!pages)
 		return -ENOMEM;
 
+	/*
+	 * Flush (on non-coherent CPUs) before LAUNCH_SECRET encrypts pages in
+	 * place, the cache may contain data that was written unencrypted.
+	 */
+	sev_clflush_pages(pages, n);
+
 	/*
 	 * The secret must be copied into contiguous memory region, lets verify
 	 * that userspace memory pages are contiguous before we issue command.
@@ -908,6 +911,11 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 e_free:
 	kfree(data);
 e_unpin_memory:
+	/* content of memory is updated, mark pages dirty */
+	for (i = 0; i < n; i++) {
+		set_page_dirty_lock(pages[i]);
+		mark_page_accessed(pages[i]);
+	}
 	sev_unpin_memory(kvm, pages, n);
 	return ret;
 }
-- 
2.28.0.681.g6f77f65b4e-goog

