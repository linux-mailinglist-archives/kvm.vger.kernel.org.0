Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9022480DF1
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 00:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhL1XnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 18:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbhL1XnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 18:43:03 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD479C061574
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:43:02 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p2-20020a17090a2c4200b001b1866beecbso16558379pjm.5
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 15:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=hxQmFeIwf3esrSd5J2l5mPzvcKGSO/++GjUWx0VZyWk=;
        b=bbNSTV1jXwxK4ma61iX0n9HHBpfFt6kMZ2SWKCKvXd7URYZIAalBesyioxSh9BH/1F
         iDchbU2d/fdnwe6Z58E2S85lGfdWkkrItR1U+oKBrSP7JjNsek5TpkiZX3xGBxr/ymkT
         vMdclFxpH5uyUbjrt6BIu0SeN3WD8xBVC5I+ZIlbSnBaYL2IMTXiet1wfhJ9t0cx8eQb
         IpExaQm5ZSTLvYYk/z1z9+tGmQuMTq78uPUfOqMlxQUX4QS3jNuDCtuIO0rRb0hDrus8
         TkgUe2f/MxDd/BZ4VZkKHl0o4APJWVu9Dj0is+dnTIDN5gj/DPL1qQb8SV5iR8WdA3IS
         yV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=hxQmFeIwf3esrSd5J2l5mPzvcKGSO/++GjUWx0VZyWk=;
        b=vFgpBxPUi9OrD/X5mzjZiFroN8U85TtGp26bTMjkZBd2xYl/ia8xeqw+l3BsZHBMqA
         TWq4AcdPZYddb8lazuuiu5CCTI1K4f9/4fekx32qJOCq7Q5xzDn5Lnr7OkYqhG35Czbc
         eRv7ShaML81EzUtcf0xqAS8cEZekeFfkqaJoD9gk95cdDgxEP7JsxfooXPWeHgikoZUO
         9K/hGCjyAOovqSr6yv6Y+zJL2RTe1x2XYsdU6V5Ecevg03bXTTpbERVau0NhyCYaeJco
         PJHkYo8HBE95zX39OLSTjVT6CvauwiDUtp9Pr9WIhQz7iPUNFG2TAUhahLEv/ki0wVAx
         kL3Q==
X-Gm-Message-State: AOAM5329iaqYTBjfq4QmTfTVxg881XCGXtRRnB3F4vPGqgGx/ZlC6jtb
        76DeTKjv02ZJ48iNU49uFWHttUUsytc=
X-Google-Smtp-Source: ABdhPJwDpDnZN4cEd+lEACn3LAcXlkvF2YIkyrpOxWsam3E8ZTm3loa/pj0uPGr2k8xnfafdKHayGAtGOIw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f0cc:: with SMTP id
 fa12mr4771690pjb.134.1640734982346; Tue, 28 Dec 2021 15:43:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 28 Dec 2021 23:42:57 +0000
Message-Id: <20211228234257.1926057-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH] hugetlbfs: Fix off-by-one error in hugetlb_vmdelete_list()
From:   Sean Christopherson <seanjc@google.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass "end - 1" instead of "end" when walking the interval tree in
hugetlb_vmdelete_list() to fix an inclusive vs. exclusive bug.  The two
callers that pass a non-zero "end" treat it as exclusive, whereas the
interval tree iterator expects an inclusive "last".  E.g. punching a hole
in a file that precisely matches the size of a single hugepage, with a
vma starting right on the boundary, will result in unmap_hugepage_range()
being called twice, with the second call having start==end.

The off-by-one error doesn't cause functional problems as
__unmap_hugepage_range() turns into a massive nop due to short-circuiting
its for-loop on "address < end".  But, the mmu_notifier invocations to
invalid_range_{start,end}() are passed a bogus zero-sized range, which
may be unexpected behavior for secondary MMUs.

The bug was exposed by commit ed922739c919 ("KVM: Use interval tree to do
fast hva lookup in memslots"), currently queued in the KVM tree for 5.17,
which added a WARN to detect ranges with start==end.

Reported-by: syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com
Fixes: 1bfad99ab425 ("hugetlbfs: hugetlb_vmtruncate_list() needs to take a range to delete")
Cc: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Not sure if this should go to stable@.  It's mostly harmless, and likely
nothing more than a minor performance blip when it's not harmless.

 fs/hugetlbfs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 49d2e686be74..a7c6c7498be0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -409,10 +409,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end)
 	struct vm_area_struct *vma;
 
 	/*
-	 * end == 0 indicates that the entire range after
-	 * start should be unmapped.
+	 * end == 0 indicates that the entire range after start should be
+	 * unmapped.  Note, end is exclusive, whereas the interval tree takes
+	 * an inclusive "last".
 	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
 		unsigned long v_offset;
 		unsigned long v_end;
 
-- 
2.34.1.448.ga2b2bfdf31-goog

