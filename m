Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC974059E3
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhIIPBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237343AbhIIPB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLdqt4rseRM/GIF92UYXv6b/tK6ZasqjgOzH1i0jC0Y=;
        b=dVKGaWY+racbC655LqIRlEVT602/lkSjwE1pL7UEtiWoWq3I7gzuhx+iHTA0aTTClKHi8N
        BOLdd/VOZmqSYKuS0WG/+pGUVNmxXIn7Sw5mqXJKQdJA3Fpg9eATDiGS825DiZndex5HTh
        WKU9IIZIjai/0cCmmIEavtR/DEv7fhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-J-Q8Tv1KN0mvtRrQVZeeOA-1; Thu, 09 Sep 2021 11:00:18 -0400
X-MC-Unique: J-Q8Tv1KN0mvtRrQVZeeOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 317161006AA0;
        Thu,  9 Sep 2021 15:00:17 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF17B6F923;
        Thu,  9 Sep 2021 15:00:12 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC 5/9] s390/uv: fully validate the VMA before calling follow_page()
Date:   Thu,  9 Sep 2021 16:59:41 +0200
Message-Id: <20210909145945.12192-6-david@redhat.com>
In-Reply-To: <20210909145945.12192-1-david@redhat.com>
References: <20210909145945.12192-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap").

find_vma() does not check if the address is >= the VMA start address;
use vma_lookup() instead.

Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kernel/uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index aeb0a15bcbb7..193205fb2777 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -227,7 +227,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	uaddr = __gmap_translate(gmap, gaddr);
 	if (IS_ERR_VALUE(uaddr))
 		goto out;
-	vma = find_vma(gmap->mm, uaddr);
+	vma = vma_lookup(gmap->mm, uaddr);
 	if (!vma)
 		goto out;
 	/*
-- 
2.31.1

