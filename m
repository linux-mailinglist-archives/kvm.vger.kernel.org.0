Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D1C204DA8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgFWJRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:17:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731887AbgFWJRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592903849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yiRnWHa9VVB1e8yxG1o2k5x8axs0i04jT/k6YjjG0Ms=;
        b=F0tg31KlJEWsT8ByuvUPbpq2SI4IVldwNOxJHQzEkJmrhfgNly8KMPgFFUMCouaENj2Jz/
        ylQAOyIt1lpSvyVR+rdOXFusNbnwWnlURHsJxW5URc/3onmtCYhy/bSkktmKIuDk2b7ln1
        cxPW0kpfmw4JQ5fUltMeE90Ha6OrtFA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-BsDaQ65hNNuuXgpF2hlGSw-1; Tue, 23 Jun 2020 05:17:27 -0400
X-MC-Unique: BsDaQ65hNNuuXgpF2hlGSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68A0619057A0;
        Tue, 23 Jun 2020 09:17:26 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12D887166D;
        Tue, 23 Jun 2020 09:17:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: x86: report sev_pin_memory errors with PTR_ERR
Date:   Tue, 23 Jun 2020 05:17:25 -0400
Message-Id: <20200623091725.271605-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Callers of sev_pin_memory() treat
NULL differently:

sev_launch_secret()/svm_register_enc_region() return -ENOMEM
sev_dbg_crypt() returns -EFAULT.

Switching to ERR_PTR() preserves the error and enables cleaner reporting of
different kinds of failures.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a893624b9275..2b4916ffa906 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -320,7 +320,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	unsigned long first, last;
 
 	if (ulen == 0 || uaddr + ulen < uaddr)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	/* Calculate number of pages. */
 	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
@@ -331,11 +331,11 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
 		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n", locked, lock_limit);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	if (WARN_ON_ONCE(npages > INT_MAX))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
@@ -345,7 +345,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		pages = kmalloc(size, GFP_KERNEL_ACCOUNT);
 
 	if (!pages)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/* Pin the user virtual address. */
 	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
@@ -360,11 +360,13 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	return pages;
 
 err:
-	if (npinned > 0)
+	if (npinned > 0) {
 		unpin_user_pages(pages, npinned);
+		npinned = -ENOMEM;
+	}
 
 	kvfree(pages);
-	return NULL;
+	return ERR_PTR(npinned);
 }
 
 static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
@@ -864,8 +866,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EFAULT;
 
 	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
-	if (!pages)
-		return -ENOMEM;
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
 
 	/*
 	 * The secret must be copied into contiguous memory region, lets verify
@@ -991,8 +993,8 @@ int svm_register_enc_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
-	if (!region->pages) {
-		ret = -ENOMEM;
+	if (IS_ERR(region->pages)) {
+		ret = PTR_ERR(region->pages);
 		goto e_free;
 	}
 
-- 
2.26.2

