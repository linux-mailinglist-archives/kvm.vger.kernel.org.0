Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1321123F58E
	for <lists+kvm@lfdr.de>; Sat,  8 Aug 2020 02:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHHAhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 20:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHAhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 20:37:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53611C061756
        for <kvm@vger.kernel.org>; Fri,  7 Aug 2020 17:37:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e3so2695425pgs.3
        for <kvm@vger.kernel.org>; Fri, 07 Aug 2020 17:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qAWBHy/YDwId+EQliujOzvzt7GbHETyF7ZMnV7H8r4I=;
        b=ZbCKesn1vTPY1aHBijollqglxQcxq5k+YuhetvBKh0GklCvIt4ThY4Rk5dGH5baAd9
         bwda8nPqy9p8Zq4zs2JhLSHt5LBithwKbXS5HtyfG2yGdghjNPUkP98CDX9/Q1rAmhCZ
         q1c4WyB2E+9DTAKUwKSmL+PgduqDo50uVJiULU5t2dPkXaCkcSVxDRBpz5YDO4Q2oCPH
         kYkrjOg2SzYtL58uL4bRhc3Z0Amf+NDPgv5ZfAvxBGMV/MiXOeL8aWfsKGV815Mt0Vjj
         FCIH2gRlXfn+MtVJKxhcrk65rxyNGDkJ3UepUyryM5VSrtZKAGiSB/CM0PjWqUzXWfB3
         wXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qAWBHy/YDwId+EQliujOzvzt7GbHETyF7ZMnV7H8r4I=;
        b=qtUTaCzDtKeaOC6YyPGL8UKp78n5gYfUETCQsxDv+aeuUOGsOJzJFC0gbNO1/+ehw9
         iNxtZbE8UpymF1FzrJROMPa5KOBZZiP/4oeBKjNyDThVtNzgHgCoOtd0SMQs5MYME4J1
         X4MfVcrDV/JGnfGUMJcJReAAMwHFvyLYqS3tNSrlv3MAm53YiiU4eITGwiEACr+msd7/
         Fj6mjHMnyziB2j0JGOV0af3t4oL1vSxp2+e1ORGexfV0lScfA0QcfwzAIFYT9mAOKldu
         dRbdTN6IUVKgq8NtKhS6NXuFgNXjc4jb0SxLPOZrK9nShLru71SW7C6L8Vvat8IjUpKd
         fcHg==
X-Gm-Message-State: AOAM531CGt/kYZZmTaKKBlqd8moFCtQWDNevwhB5NAMxbkPYp9KtTqLG
        psajWpo5qrLQGcV5xQLhOpZ6T16B4je2/nYXR2g/xsn/y/mPEvsOpjbLPnByUTOTI/qQzYDhVJW
        qp5aNEwJ0a9zRhXy2e0g7bKq+WRTtlske64pKOlj79TJvJ/S6cX5s
X-Google-Smtp-Source: ABdhPJz2ntewJM4SNFgvJLgp2ChRpBaoUTmjHDtlsktdAVNUMdI1n/Z7oy9JwmiOKi4FiLZ1l0AT6kas
X-Received: by 2002:a17:90b:4a0a:: with SMTP id kk10mr15916872pjb.30.1596847070432;
 Fri, 07 Aug 2020 17:37:50 -0700 (PDT)
Date:   Fri,  7 Aug 2020 17:37:46 -0700
In-Reply-To: <20200807012303.3769170-1-cfir@google.com>
Message-Id: <20200808003746.66687-1-cfir@google.com>
Mime-Version: 1.0
References: <20200807012303.3769170-1-cfir@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2] KVM: SVM: Mark SEV launch secret pages as dirty.
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
This matches the logic in sev_launch_update_data().

Signed-off-by: Cfir Cohen <cfir@google.com>
---
Changelog since v1:
 - Updated commit message.

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
2.28.0.236.gb10cc79966-goog

