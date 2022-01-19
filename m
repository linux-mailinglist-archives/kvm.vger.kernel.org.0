Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2489C494398
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbiASXJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344397AbiASXIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:16 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502F6C061769
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:16 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso2497663pgv.14
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MhfdLV2MTzZVWycYse2Rj3CRq19OgFZ+cwv24VRJY58=;
        b=aZfYz7IJbgQradgseDLIlHc/MdP1bw5kgVTbegaBGLOSHtCi30radQFvyRg9VqsOLw
         AlL5F0kN5xODLebfzI1SgLI+Y8pum+n99PQzG1o8MxUtkJSnnu5MWX6z3eUHiPqVe6Ag
         iZpGlUV78ee8+em2avbVTibi06XlZh9A42M8OCwyQFnmOQlEdBTlx618KJcdaKXsmrvx
         jxMDJrZta+leB4xrjag7WoHlwOWLvb0b2Ijz2iuUJPMFJz/n1NoHrdlPWUANsxtYbVPK
         7zXh/otZ3oiY9oGlK3CG+nT32bp0cVLv0PFdoltK/9tYA6gWgIBF6gcQEU/CpxCI+ktV
         yo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MhfdLV2MTzZVWycYse2Rj3CRq19OgFZ+cwv24VRJY58=;
        b=7pfR5zP6/ET2Icvjy/CWoQvRn082Y9axblHuMW5a+5QPVPEBATu4qRMU6l+hCO956g
         GTLvlyA+j+zhzcVYu8JVAvEMpl01zOxXZg4+O72XYEDDYyo9ixXk3lg37fbxTgHwtPaT
         gOCj2//CJH+eaPwDPyH6bvEyEE8PBIEEFNxfM9sw20LVqPG/9JujKtdPAX5Mr20OdVYq
         lbagi6HHq6uVWTFIGFaTXF8ubhprofd190qgLlW7pfaeJ5ghoHI8IqMJgE8u2VQ13x35
         BhqreFU2VfThMUvWFGXfuaf3SZUj18aklJodhOdFo+gp/0e1amiH/8j5z0WcJvIVbv/6
         IhFw==
X-Gm-Message-State: AOAM532bZWqVtNm/0XL7QAL6+lOOtl+FGZ8JrgKS7AO2vdfNljfpiwnp
        5R/r7z/st9bsKBS3REY8B67rpGPDVeAqKA==
X-Google-Smtp-Source: ABdhPJxbRD3heZAlfS9i1V5faPgoS+9fkxWd67rk0P0mqu91fowvZvxnW2DMrNThlZBBrifhXG0lyYXhFqM4MA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4f44:: with SMTP id
 pj4mr3583pjb.1.1642633695542; Wed, 19 Jan 2022 15:08:15 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:38 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 17/18] KVM: x86/mmu: Add tracepoint for splitting huge pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a tracepoint that records whenever KVM eagerly splits a huge page
and the error status of the split to indicate if it succeeded or failed
and why.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 23 +++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 10 +++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index de5e8e4e1aa7..12247b96af01 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -416,6 +416,29 @@ TRACE_EVENT(
 	)
 );
 
+TRACE_EVENT(
+	kvm_mmu_split_huge_page,
+	TP_PROTO(u64 gfn, u64 spte, int level, int errno),
+	TP_ARGS(gfn, spte, level, errno),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, spte)
+		__field(int, level)
+		__field(int, errno)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->spte = spte;
+		__entry->level = level;
+		__entry->errno = errno;
+	),
+
+	TP_printk("gfn %llx spte %llx level %d errno %d",
+		  __entry->gfn, __entry->spte, __entry->level, __entry->errno)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d5e713b849e9..1ed8e20270f0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1332,7 +1332,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 */
 	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
 	if (ret)
-		return ret;
+		goto out;
 
 	/*
 	 * tdp_mmu_link_sp_atomic() will handle subtracting the huge page we
@@ -1341,7 +1341,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 */
 	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
 
-	return 0;
+out:
+	trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level, ret);
+	return ret;
 }
 
 static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
@@ -1378,6 +1380,9 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, shared);
 			if (!sp) {
 				ret = -ENOMEM;
+				trace_kvm_mmu_split_huge_page(iter.gfn,
+							      iter.old_spte,
+							      iter.level, ret);
 				break;
 			}
 
@@ -1401,7 +1406,6 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	if (sp)
 		tdp_mmu_free_sp(sp);
 
-
 	return ret;
 }
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

