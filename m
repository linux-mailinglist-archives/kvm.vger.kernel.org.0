Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532B94579D7
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhKTACN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbhKTABj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:39 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502D5C06175E
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:33 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id q2-20020a056a00084200b004a2582fcec1so6456880pfk.15
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=907pw9qKzH1wGLGqMFvCzKM8gYj98bpyPMmwUQUZ+H8=;
        b=gbpk8jWnIl4njyuLIyTnd7OaVlUgBgzPcG1SWhfuug0e11AuYP5dRnZZm7gCoNnu+D
         H4tOA9vVkPPEaKKU5aX4z31B7YtJjDUkgylae+zJAxUJ3c96NwjsaiA003E/d34G82I3
         wF2Vu6psZ3x+bmJlnZ0HhAWYImEbuR2d2/r4OwbdnBLA5hudmU4H9oc3ozcQydfubPgT
         iBrh+Ma9Uv2w4pk3jd/oAD//S4QHja3k/iXePv7AOavIS4NHxPMFViViaVu3wtz+3/os
         NTjkzDlpZDjSQLs0SrwFGZC+x2ZaZShUEIe4ghsP09hiXtpvdQjqcdWZwqoXSCuC23Xt
         NaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=907pw9qKzH1wGLGqMFvCzKM8gYj98bpyPMmwUQUZ+H8=;
        b=RIH8HgDsDJ+1+/f8eBYU3fza8g1lFrNgnNSgFlp1X4ubn962SySRcSDSoPkRrBSS80
         Y5L6Hw4KXBRP6YlIZRwZVEYhyhvMnUjaN9/uXn0ZMJf/gU3iHS+B4S9dQOndy+2uERn8
         /j/vfSS9YDEiigHWupkoz7dWWIrRgIHAD8txq106qCLdBcj/LMuOAMgnGm9GohJwJRUG
         IMS92+g8iyRIoml6/6++EbcasUnomKSTrP0jFOxhl11mtJpvk873tVh87wY6DvFc3/vb
         N5dWVC2q8Yx0LkUKNIZQsCr29M5fV+w6w7nLZAMNIMxivyda71qmi8VQKJVGVZVA24zO
         Fk0g==
X-Gm-Message-State: AOAM531NKpxTA3Dafp08wNWIlY9pPw4zws7H/00xKUdHfg5N7A4BWCZS
        wuboxKOe+xrmY1BxzVRaYCOHZ4imAcG6/Q==
X-Google-Smtp-Source: ABdhPJw3Jmz2av0uQKnM0ABopk5NJT4vWMk0To2NoBoGrb0U3lrALLjdUXWi8GMq/m4XrP7MlUMyehzYK5k1yA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:bd87:b0:143:c6e8:4110 with SMTP
 id q7-20020a170902bd8700b00143c6e84110mr57007798pls.23.1637366312753; Fri, 19
 Nov 2021 15:58:32 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:58 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 14/15] KVM: x86/mmu: Add tracepoint for splitting large pages
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a tracepoint that records whenever we split a large page.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 20 ++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index b8151bbca36a..4adb794470ae 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -416,6 +416,26 @@ TRACE_EVENT(
 	)
 );
 
+TRACE_EVENT(
+	kvm_mmu_split_large_page,
+	TP_PROTO(u64 gfn, u64 spte, int level),
+	TP_ARGS(gfn, spte, level),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, spte)
+		__field(int, level)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->spte = spte;
+		__entry->level = level;
+	),
+
+	TP_printk("gfn %llx spte %llx level %d", __entry->gfn, __entry->spte, __entry->level)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 366857b9fb3b..8f60d942c789 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1284,6 +1284,8 @@ static bool tdp_mmu_split_large_page_atomic(struct kvm *kvm, struct tdp_iter *it
 
 	BUG_ON(mmu_split_caches_need_topup(kvm));
 
+	trace_kvm_mmu_split_large_page(iter->gfn, large_spte, level);
+
 	child_sp = alloc_child_tdp_mmu_page(&kvm->arch.split_caches, iter);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

