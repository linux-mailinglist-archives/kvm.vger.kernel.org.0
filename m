Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97E4275EB8
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIWReH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgIWReH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600882447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ldfka2JU/8jYBcA7GSDSVnVY22PnP+CZq+UK9hEXQUs=;
        b=A/P9ypsalSVVr7L7mTSqSfPCFiaoVl1tpzQ6uQu10CZbN0XfzpSYYA6y4XpC1CGOGp103l
        jKAAN/lpIcgsrJgEuGpYpQyMY6M9zKniTmnXAgXe6KhVDig2GmgsH6dJXmvtf/NCcY5fXB
        1yLyAWkIJzAbf0t3VAaFJsH/nVS/q/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406--llZzXH6MFadSR-JdG7y4w-1; Wed, 23 Sep 2020 13:34:04 -0400
X-MC-Unique: -llZzXH6MFadSR-JdG7y4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BCDE1800D42;
        Wed, 23 Sep 2020 17:34:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D24D5C230;
        Wed, 23 Sep 2020 17:34:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: SEV: shorten comments around sev_clflush_pages
Date:   Wed, 23 Sep 2020 13:34:01 -0400
Message-Id: <20200923173401.1632172-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Very similar content is present in four comments in sev.c.  Unfortunately
there are small differences that make it harder to place the comment
in sev_clflush_pages itself, but at least we can make it more concise.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bb0e89c79a04..65e15c22bd3c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -446,10 +446,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 	/*
-	 * The LAUNCH_UPDATE command will perform in-place encryption of the
-	 * memory content (i.e it will write the same memory region with C=1).
-	 * It's possible that the cache may contain the data with C=0, i.e.,
-	 * unencrypted so invalidate it first.
+	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
+	 * place; the cache may contain the data that was written unencrypted.
 	 */
 	sev_clflush_pages(inpages, npages);
 
@@ -805,10 +803,9 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		}
 
 		/*
-		 * The DBG_{DE,EN}CRYPT commands will perform {dec,en}cryption of the
-		 * memory content (i.e it will write the same memory region with C=1).
-		 * It's possible that the cache may contain the data with C=0, i.e.,
-		 * unencrypted so invalidate it first.
+		 * Flush (on non-coherent CPUs) before DBG_{DE,EN}CRYPT read or modify
+		 * the pages; flush the destination too so that future accesses do not
+		 * see stale data.
 		 */
 		sev_clflush_pages(src_p, 1);
 		sev_clflush_pages(dst_p, 1);
@@ -870,10 +867,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return PTR_ERR(pages);
 
 	/*
-	 * The LAUNCH_SECRET command will perform in-place encryption of the
-	 * memory content (i.e it will write the same memory region with C=1).
-	 * It's possible that the cache may contain the data with C=0, i.e.,
-	 * unencrypted so invalidate it first.
+	 * Flush (on non-coherent CPUs) before LAUNCH_SECRET encrypts pages in
+	 * place; the cache may contain the data that was written unencrypted.
 	 */
 	sev_clflush_pages(pages, n);
 
-- 
2.26.2

