Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43685405AD1
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbhIIQZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238605AbhIIQZF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 12:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631204635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5eD9QSjHB/obRO2RHdOXDtwX2b2cRaWyG1OuiS09Ls=;
        b=eenK4tTsin34/Uj5QLU/E+iIcj20hqvFfZ53mj6TbIBPE3uvua5ZuIHAufPZ9sSm66GjZr
        oaJr4t4lpt4TXuI/MQZf3Q0OzX2BbVIIAl5Exdr7aoPRqZZ1fsbY+Uiq9eSWBCAdWArT80
        a5KJS5fQUU3e4IZVU7vF9K8FhiYBqyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-PFKvmvgKODWZU5lV8fdRBw-1; Thu, 09 Sep 2021 12:23:54 -0400
X-MC-Unique: PFKvmvgKODWZU5lV8fdRBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0B1AE7D67;
        Thu,  9 Sep 2021 16:23:25 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 739D318FD2;
        Thu,  9 Sep 2021 16:23:22 +0000 (UTC)
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
Subject: [PATCH resend RFC 9/9] s390/mm: optimize reset_guest_reference_bit()
Date:   Thu,  9 Sep 2021 18:22:48 +0200
Message-Id: <20210909162248.14969-10-david@redhat.com>
In-Reply-To: <20210909162248.14969-1-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already optimize get_guest_storage_key() to assume that if we don't have
a PTE table and don't have a huge page mapped that the storage key is 0.

Similarly, optimize reset_guest_reference_bit() to simply do nothing if
there is no PTE table and no huge page mapped.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/pgtable.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 534939a3eca5..50ab2fed3397 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -901,13 +901,23 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep;
 	int cc = 0;
 
-	if (pmd_lookup(mm, addr, &pmdp))
+	/*
+	 * If we don't have a PTE table and if there is no huge page mapped,
+	 * the storage key is 0 and there is nothing for us to do.
+	 */
+	switch (pmd_lookup(mm, addr, &pmdp)) {
+	case -ENOENT:
+		return 0;
+	case 0:
+		break;
+	default:
 		return -EFAULT;
+	}
 
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
 		spin_unlock(ptl);
-		return -EFAULT;
+		return 0;
 	}
 
 	if (pmd_large(*pmdp)) {
-- 
2.31.1

