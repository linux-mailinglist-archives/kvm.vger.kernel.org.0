Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE1D23E57D
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 03:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHGBXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 21:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHGBXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 21:23:24 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38C1C061574
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 18:23:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b11so227415plx.21
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 18:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yC5jYNAZ2LkpJAay2cVTHRBar69NJbTlP8o5uIXB6/g=;
        b=dbhUZ4AdddRmmfM5MZeqGAPEKz9pXzfFnWWvVwOcBdaX6SgkOX4BLQ1qmjaI2Vv/RE
         lI810NuPrU8cba8i0YMXSkn1Ohkr+DXWdTHizneQgoirhCfkZmKKIefeuWQqwM6d5p46
         5ScI/Z3lLN/VuwpppPg52ErsiS6PbguN4Kopt6kIWm0mDIDHjOFb1h27WrIDbRLRHP2v
         z/Nof0CVwzKkv+LKjBfCzacBwcSdazISEWZKgHJuaT4pwK6Fsdwez25g9dP4eiWSO7hC
         qCfmyEflLkUT16wBzHw+kRlqSt1miYrr3Hnn1UbC94AfE7oJaTUr/YGJlqf9blZYhnkg
         PqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yC5jYNAZ2LkpJAay2cVTHRBar69NJbTlP8o5uIXB6/g=;
        b=JSyk+ndIwfESRaL3c74JocAnxhrhf7/ndlk+YLV2/IG2zKS4D+r/zmF6lG6V+tk3Qu
         J0CjaLfX8ZaZSq/AKqf+IDgzFk2XP2YylMQOsImpvnkU+tgTSyn/ciXd7aV1tQH7R4Qy
         Scc6WAoJ0opLeNL2g6gL8lJS2OU4Tf0LEP57z+8W1evrCxJQcxKb1bhHMt0gW1V0T7yk
         kXPekYn0h6fDTk9r2cM5EcM5Uy7n2V1/bq0v8LgklihDkMSA64GJ0zS1NglPaWDLBJfI
         SRhSInxxHVP1il6dpsd7zayjg1gIwOJnmk1cNiCpe8cfqJ7BZqMzdSBrk+kQAwhLDjMO
         YPJw==
X-Gm-Message-State: AOAM531YIfqDVm1POBTq8wwYeK2yRbIT20bXKkzVhh6HtA23i/X5O9mD
        JhkrxlIkAYB3PYAzSA6fP1rP08YrFNVdYiV97xe6XoFADuy+twl087F7eAgYH3PNb+aUtw0s8UQ
        Wg1xZuRWmOTeFY24Oa34Z34KBQ5jdFaMAKdjCQngFVIkeF0qEav5T
X-Google-Smtp-Source: ABdhPJzX3Q/EZzrTsL+psZOfV6Qe3oGEelBpSTkxN0LrcRBxKGusOhF5mZvdOdGnh5l977FkZGlm/weK
X-Received: by 2002:a17:90a:6343:: with SMTP id v3mr11046672pjs.163.1596763402902;
 Thu, 06 Aug 2020 18:23:22 -0700 (PDT)
Date:   Thu,  6 Aug 2020 18:23:03 -0700
Message-Id: <20200807012303.3769170-1-cfir@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
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
        linux-kernel@vger.kernel.org, Cfir Cohen <cfir@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LAUNCH_SECRET command performs encryption of the
launch secret memory contents. Mark pinned pages as
dirty, before unpinning them.
This matches the logic in sev_launch_update().

Signed-off-by: Cfir Cohen <cfir@google.com>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5573a97f1520..37c47d26b9f7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -850,7 +850,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	struct kvm_sev_launch_secret params;
 	struct page **pages;
 	void *blob, *hdr;
-	unsigned long n;
+	unsigned long n, i;
 	int ret, offset;
 
 	if (!sev_guest(kvm))
@@ -863,6 +863,14 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!pages)
 		return -ENOMEM;
 
+	/*
+	 * The LAUNCH_SECRET command will perform in-place encryption of the
+	 * memory content (i.e it will write the same memory region with C=1).
+	 * It's possible that the cache may contain the data with C=0, i.e.,
+	 * unencrypted so invalidate it first.
+	 */
+	sev_clflush_pages(pages, n);
+
 	/*
 	 * The secret must be copied into contiguous memory region, lets verify
 	 * that userspace memory pages are contiguous before we issue command.
@@ -908,6 +916,11 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
2.28.0.163.g6104cc2f0b6-goog

