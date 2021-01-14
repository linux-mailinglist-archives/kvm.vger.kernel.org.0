Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1612F5672
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbhANBsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbhANAlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:41:13 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450D1C061389
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:38:11 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id e14so2973877qtr.8
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GWAuLMH7Ls1Ey0iR5g9WiKswv9AMybZldn+rr0xf6ac=;
        b=EA5dGny0b2252/x6CNsCPKBTA7REUvSuQY/vkBnPivTVuhM8e9yuI+i12+7oOOBfFs
         Odc8VO6oCuwkhgHeMO+Kxl6qhi2hPsfF3AMD/AelinGodE7PUAjSE2Hbn6mYPuzD+w4d
         LW+nnVBmYuL7Q9TFywnfbudkkng1w4GhDAzXOBhadAtiu9hGgckJrjPvsivW2pFpifvX
         h6E0oo6T0I6oQ0JDleuIMT5bTm+bToe6ZTjz8pFVJZzaiJJwRGcqDwuTYFwkyCcriWBq
         RRUBgVnbMg3apSIZ/HOwOt7LW/AeIm7+/suFXahOMBLws5n4KwAcBrIv8PxRySYRViTF
         k6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GWAuLMH7Ls1Ey0iR5g9WiKswv9AMybZldn+rr0xf6ac=;
        b=HABQokuQez8XvMNdQoUIwfZjGNjpsdy6ROCqygbx+hUKOQ2fni19TZxL7gACn/4687
         8fMh86hwssMZ7DVPqyKOM0Q6fFjnNJ0LHjMddlAYfVzYA4XGsuOGDCTdexFvSB0Q1ySu
         fe7lTDV1XUGIg8k9DAY3BNrdGIxZF7Os/2brPqv8AI3OigSCs3hE8KdZj2jh8r5IF9BS
         yCVKRYbtx66lNvTHgS36PXO2YQH+CJz3SDV7A88+2DgcuhyRD2smx+QduovoonC5m02C
         O8VeX9jkfEoEIcYnVxnObIR4mKjQpPre+qVPyyrmUZDMIqfVtZSReZXva7djY+ouQmao
         6w/A==
X-Gm-Message-State: AOAM5306Nbf9MGOCgFMavMz56bSHHcYHA2MW4CcbJgjKXioMTPStkA+5
        LUpUnQ1/h7ikbVqqNukYCJouNgKNTdE=
X-Google-Smtp-Source: ABdhPJxd26knuMip8++7sqtHgt8IOL56+LllnVUDn9Zy+jMdU8upn1suW+wnmfnhT20jDRW580FRWd3GuJ0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:cf08:: with SMTP id f8mr7105191ybg.210.1610584690440;
 Wed, 13 Jan 2021 16:38:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:08 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 14/14] KVM: SVM: Skip SEV cache flush if no ASIDs have been used
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip SEV's expensive WBINVD and DF_FLUSH if there are no SEV ASIDs
waiting to be reclaimed, e.g. if SEV was never used.  This "fixes" an
issue where the DF_FLUSH fails during hardware teardown if the original
SEV_INIT failed.  Ideally, SEV wouldn't be marked as enabled in KVM if
SEV_INIT fails, but that's a problem for another day.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 23a4bead4a82..e71bc742d8da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -56,9 +56,14 @@ struct enc_region {
 	unsigned long size;
 };
 
-static int sev_flush_asids(void)
+static int sev_flush_asids(int min_asid, int max_asid)
 {
-	int ret, error = 0;
+	int ret, pos, error = 0;
+
+	/* Check if there are any ASIDs to reclaim before performing a flush */
+	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
+	if (pos >= max_asid)
+		return -EBUSY;
 
 	/*
 	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
@@ -80,14 +85,7 @@ static int sev_flush_asids(void)
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(int min_asid, int max_asid)
 {
-	int pos;
-
-	/* Check if there are any ASIDs to reclaim before performing a flush */
-	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
-	if (pos >= max_asid)
-		return false;
-
-	if (sev_flush_asids())
+	if (sev_flush_asids(min_asid, max_asid))
 		return false;
 
 	/* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
@@ -1323,10 +1321,10 @@ void sev_hardware_teardown(void)
 	if (!sev_enabled)
 		return;
 
+	sev_flush_asids(0, max_sev_asid);
+
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
-
-	sev_flush_asids();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.30.0.284.gd98b1dd5eaa7-goog

