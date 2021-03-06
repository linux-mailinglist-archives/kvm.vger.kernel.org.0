Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A510232F7B8
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhCFCAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 21:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhCFB7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:51 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29314C061760
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:51 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id e9so2908546qvf.21
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RGBGjRYcLpzZKmmikFQwZLPbNnCzmLhMB1ZnNSdMI9Q=;
        b=B2slHV0TDG3kCxdpO6MqS6MEA29EPE00hM4j4eEMMirvy2nvf7tYOlXFK4t7AKTH61
         nMDnUJOW7I1l8Vktzb0QZJu3TyjCcXTPS5+FI/IciWJiQKIUtzK6jYZvQUL1DmegzDqp
         +vhGN2JmcZQhDvROioiZ/J4XABwioYcsMJdMNXC3/0kGW0EQWkY7se41i+AYVxOGfpvY
         dYa/j2sfIWGAm4yaAIOXGN+DOtXzBMbi1QmKGymC5+IdFHQtq99lMKP+GfKE53N1Gnp2
         RSDvByxJoeXjiLlLKqv4CUQS6shOb5RyQsnCZPgsgqwdgSLgy2KL5veo0QwI2SMUitD4
         cGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RGBGjRYcLpzZKmmikFQwZLPbNnCzmLhMB1ZnNSdMI9Q=;
        b=IuWrq+jbSSQLPs+Po05Zk7ryOcKPXNo8OHR3iP5kkPyHP7hb0tt/dILjZniVWNQV+0
         Nr52eycuPaWYDDjPCEhUvT8FneytcI6+rD2c1gxkBQGr61z+RvsSS/wbiHC9qI4xv2Ap
         1SCYub6/HNcOOqJS3YBqesDNRNPevmHXCGX2IW/goODEUsdG02C1MmgOYSeZyXT+8n7b
         z1pB1QmVb0xjHvcv6s5sM5h6OnNjr0WA3H89HMuJFNFS0QbXEj/v+aPtKL5V0+iLp1Yf
         NippSRD2j0V8rqTD0kszB0jPMhKc4k+M8z0mU5b7sBDWrLvmV2d+TkVOd/pRjCx3Kwjq
         Clkg==
X-Gm-Message-State: AOAM533aC5wABMMIPCXV/qU85Rh0tElxbYlrOE4sgDw630dxwxr32UG2
        SpB7aLsgXAB213nwRQaK62sgSPOAlUI=
X-Google-Smtp-Source: ABdhPJwSoKByoD4fhMYtVv7nTAckUzrERAauGnDMgwYEfWPsbSLGyNIuvE+yfkt8C2ng8lyhOS/O+n+WuEA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1085:: with SMTP id
 o5mr11740761qvr.5.1614995990308; Fri, 05 Mar 2021 17:59:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:59:05 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 14/14] KVM: SVM: Skip SEV cache flush if no ASIDs have been used
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
index 3bf04a697723..f8ebda7c365a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,9 +57,14 @@ struct enc_region {
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
@@ -81,14 +86,7 @@ static int sev_flush_asids(void)
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
@@ -1399,10 +1397,11 @@ void sev_hardware_teardown(void)
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
2.30.1.766.gb4fecdf3b7-goog

