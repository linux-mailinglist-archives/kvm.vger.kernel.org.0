Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17BE405AC6
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbhIIQZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:25:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237109AbhIIQYx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 12:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631204623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6g4VWCrzU/h/qyBDenztolU1cZPMwHWOEhuFKokN2bQ=;
        b=R1i6yFakVicAUrI63EBOIv1baOvwT0jH7oCltH3/DZKmnXx2/p9eWyujEbRzS8SZkznwCP
        NzcHpft1yRR2XaEvW3GCimqSCb8Q/ee1FSYKgc2H/KjtFI+rum0YS8qlsXifHi2qqq1shX
        cDC5WL5YOt10OubD27EcJ17OuybXoBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-0MTA3mPBNC2oDkUS9eTzCg-1; Thu, 09 Sep 2021 12:23:42 -0400
X-MC-Unique: 0MTA3mPBNC2oDkUS9eTzCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C8E91092872;
        Thu,  9 Sep 2021 16:23:18 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F00B818FD2;
        Thu,  9 Sep 2021 16:23:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: [PATCH resend RFC 7/9] s390/mm: no need for pte_alloc_map_lock() if we know the pmd is present
Date:   Thu,  9 Sep 2021 18:22:46 +0200
Message-Id: <20210909162248.14969-8-david@redhat.com>
In-Reply-To: <20210909162248.14969-1-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pte_map_lock() is sufficient.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/pgtable.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 5fb409ff7842..4e77b8ebdcc5 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -814,10 +814,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	}
 	spin_unlock(ptl);
 
-	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
-	if (unlikely(!ptep))
-		return -EFAULT;
-
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	new = old = pgste_get_lock(ptep);
 	pgste_val(new) &= ~(PGSTE_GR_BIT | PGSTE_GC_BIT |
 			    PGSTE_ACC_BITS | PGSTE_FP_BIT);
@@ -912,10 +909,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
 	}
 	spin_unlock(ptl);
 
-	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
-	if (unlikely(!ptep))
-		return -EFAULT;
-
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	new = old = pgste_get_lock(ptep);
 	/* Reset guest reference bit only */
 	pgste_val(new) &= ~PGSTE_GR_BIT;
@@ -977,10 +971,7 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	}
 	spin_unlock(ptl);
 
-	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
-	if (unlikely(!ptep))
-		return -EFAULT;
-
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 	pgste = pgste_get_lock(ptep);
 	*key = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
 	paddr = pte_val(*ptep) & PAGE_MASK;
-- 
2.31.1

