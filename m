Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2190367742
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhDVCNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhDVCMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:37 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E058C06135B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:12:01 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l61-20020a0c84430000b02901a9a7e363edso6566191qva.16
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CxobN34GNkA19G2Vph12+PTqHZch+dEzVbCgj+ROQB8=;
        b=lAk04Jm/r7CGDxFvlXBFLbnmWqTdmHmbZY0IPLuHUWrY3GV+Lx9j5bfKpOYmLZD0DG
         pHm7NOZxo7ybbsRm9on6Gt7VeXTKBWagFj2ASP4SNoIcwvON82Szdx/El/bF4oI+DTlD
         CZpGxtyQLWOiZiMr6cbusboV02VQIFtsJ4GJRfe15UGx7/I0n3Cbzr3zauNvWXYkEj+Q
         MmTkLzlyPS+A9OknS29sfT+7jChOCPec+gVZwNH7wQpqq07NUVqkb2C4ZGOXW5Ut1mYi
         r13W8zAXvlOSue9UviJbdE/mztePapkakprwNeS2NdgkaYBTofxLbCUfL6AsTmDzmDX1
         GzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CxobN34GNkA19G2Vph12+PTqHZch+dEzVbCgj+ROQB8=;
        b=DBcFDUbMuQEChDXYMSkSn4+tm1VZxcFNj6WqHcmb6TuaNEazvOVuWyFAKKq6As0qtT
         DBS0zgdJy+uDrPRh2okKd10SmGo7G639dfXrO7hhKkJGUlx6D7OZ8n4s76lGhcpCkTLQ
         ok72L5vRuS1+Xv2ia9s3GGW3as5129P+evLkzmtDaLaEmw0QXIG/XcFbRB9R+3nYdMTs
         pkoQMyWuRiZHgPGBGnzz5yxwgVV7JbuITHS9v2B0cHeyDarC6EiyQ7APISq887Yy07PF
         kmrTUMMFSJ7DaHkD9DvgoAMIBaWg+joMbH9f0rY4anqe44EpludfBpo5sVJpsZo4etGx
         SsZA==
X-Gm-Message-State: AOAM5319mjjldzw6LWQDtowvg3f4ybdIvWiF67gv0tAQKDBYiPAgZ5El
        Ltp62nPcMneihWPWCVi3l4bUnijGvy0=
X-Google-Smtp-Source: ABdhPJyodOYiKyqtqbjR7u/XaYU4h4ztyCQswSqpqhstVtPxG4yFFXENRpREfEjIxnysbPpSa6qveEabSU0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a05:6214:12d3:: with SMTP id
 s19mr1171434qvv.26.1619057520374; Wed, 21 Apr 2021 19:12:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:25 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 15/15] KVM: SVM: Skip SEV cache flush if no ASIDs have been used
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
 arch/x86/kvm/svm/sev.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5cdfea8b1c47..d65193a4ea17 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,9 +58,14 @@ struct enc_region {
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
@@ -87,14 +92,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
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
@@ -1846,10 +1844,11 @@ void sev_hardware_teardown(void)
 	if (!sev_enabled)
 		return;
 
+	/* No need to take sev_bitmap_lock, all VMs have been destroyed. */
+	sev_flush_asids(0, max_sev_asid);
+
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
-
-	sev_flush_asids();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.31.1.498.g6c1eba8ee3d-goog

