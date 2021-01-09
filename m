Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F0F2EFC6D
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbhAIAtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbhAIAtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:39 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7B7C0617AA
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:48:08 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o8so17219460ybq.22
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fVKJcIBGyQ8ofth+2r+58SAdhl2FPbPE0WCNDEMMDk4=;
        b=sV2kXazNx3+wC2Yq0tFCfvFkxuQ8uXG6rdN9zX9NROD55PWnPh0AprGhmarvvrE/Ks
         srn/Y6hNixdWjZTmVJ7muGoFZ8Y2hVc645/zNmkyR+beufPJ/zSPTPJuLharLBkugmvg
         kBwiMT3XRfhsnHEuUNh8KkhGlHZwZX8EijET8Vi0AkNpX28n/ZQij+4/fdsEhC5K161y
         YrtOpmHIbDWQ6sIYluL6KJfdJo4h2nER3g3BkRS2UvRgqMbQjNBMWM1LAovL62/sCMKI
         1GM+jxKOyBr3luJeuF1iy4bYYqD6cdjeBXn3RSgV67SvlDWQutqGDxRzBaSIGFCh5hKg
         6EAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fVKJcIBGyQ8ofth+2r+58SAdhl2FPbPE0WCNDEMMDk4=;
        b=kb+ks/q4x41HHuxd3/rcwqrxmmqlHstAMAL7J2HC94h5Y+GvmSZ/SFzGHEURtZGTi3
         y5zfVQ0DJMuOEcViGRCEFhaiaCYoxNKkmNeCBGzmCyzgvRR3K5mglizsq3tzwS5+1Cfd
         CQcf6p0YrkhzJ1s7udP6dFHVbDv1az5jn6GvJD1pQ4dxYgf25h0YxKZfxQ3/Y70SuIri
         vnGxRaB7VDQt5y2vRDWlAOMARDD67RMaEPidekdeF7dUVzf/Zx8XRR6rHZHS7RYPk60w
         lcrGqzQOrfIywBZnzT/DY/OEakTMdczdQmv0+LjQJnZpWKdmhtxlmc3wtRxeaxI7vLpA
         Rjpg==
X-Gm-Message-State: AOAM530jtY+a8Am46MaO2xwqzqO3JTHXMeZG25PD4z2On0RwIjo9dsvr
        AjbzorYA5gI3oAGSUuOfvGL8TjpP0Qk=
X-Google-Smtp-Source: ABdhPJwkUpCfLMqhX7OFP7/TPxLCfPGVqnIV++qq6RbW6+AzZ8TZu4ZGF0NRg7hqrAiAuHqTHJm1tlBGHBk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:3ac3:: with SMTP id h186mr8587398yba.155.1610153288080;
 Fri, 08 Jan 2021 16:48:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:14 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 13/13] KVM: SVM: Skip SEV cache flush if no ASIDs have been used
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
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
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
index b4a9c12cf8ce..eb8e4dca4bf2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -51,9 +51,14 @@ struct enc_region {
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
@@ -75,14 +80,7 @@ static int sev_flush_asids(void)
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
@@ -1316,10 +1314,10 @@ void sev_hardware_teardown(void)
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

