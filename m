Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB584059D8
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbhIIPBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236457AbhIIPBI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=87Mua4NbTS7oP3gkDXZZUnEGgyi6Qj+P+zd/pBlYJc8=;
        b=FpGBdYz/HjsO4EyPamMU62OuOTP78JvuHayIeLEHuzLvCBqz5ONw5qzY8TY//ocs3LLRKf
        2JbvJSa+DvYCMNK9YRBFDHTLvtA4Z0YCvFcpE9fitLgOavZLVaWw2WYD9h0Q5wCMlxYEGB
        5bBqpE/Wk1BMHEwi9RcKjaOnMkwk+So=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-7CI0ihIfP--BTgnMoCek5A-1; Thu, 09 Sep 2021 10:59:57 -0400
X-MC-Unique: 7CI0ihIfP--BTgnMoCek5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BC28BBEE5;
        Thu,  9 Sep 2021 14:59:56 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0203E1981F;
        Thu,  9 Sep 2021 14:59:54 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC 2/9] s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()
Date:   Thu,  9 Sep 2021 16:59:38 +0200
Message-Id: <20210909145945.12192-3-david@redhat.com>
In-Reply-To: <20210909145945.12192-1-david@redhat.com>
References: <20210909145945.12192-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... otherwise we will try unlocking a spinlock that was never locked via a
garbage pointer.

At the time we reach this code path, we usually successfully looked up
a PGSTE already; however, evil user space could have manipulated the VMA
layout in the meantime and triggered removal of the page table.

Fixes: 1e133ab296f3 ("s390/mm: split arch/s390/mm/pgtable.c")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/gmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index b6b56cd4ca64..9023bf3ced89 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -690,9 +690,10 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 
 		/* Get pointer to the page table entry */
 		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
-		if (likely(ptep))
+		if (likely(ptep)) {
 			ptep_zap_unused(gmap->mm, vmaddr, ptep, 0);
-		pte_unmap_unlock(ptep, ptl);
+			pte_unmap_unlock(ptep, ptl);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(__gmap_zap);
-- 
2.31.1

