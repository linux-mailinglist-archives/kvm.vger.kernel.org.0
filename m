Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633C017DD5A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCIKYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:24:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45228 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726632AbgCIKYt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 06:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583749488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUPGPmIvaDDGzVaAE49y1ve21avwQxlD6sBJrt5aqiw=;
        b=XBLDp+FuW+9wH+gbQD6gUv6nxuWE7n57xXYn+Nid01IswqGMCTX7VjW9OGONoNnpdaSFYI
        Sys9EmZa9qYFoxW9Ke9QRjQ9BEXn76vrAFL6eeXU5o10fgDskZt+fvOnEAsQ3C85lo8inZ
        bLWJzmFqmIq6LnwDfHhcc8JDM85apPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-kn_oEwKnOn2anCLGpUgNTg-1; Mon, 09 Mar 2020 06:24:44 -0400
X-MC-Unique: kn_oEwKnOn2anCLGpUgNTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FDD0800D48;
        Mon,  9 Mar 2020 10:24:42 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1269587B08;
        Mon,  9 Mar 2020 10:24:36 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 02/13] page_alloc: Introduce get_order()
Date:   Mon,  9 Mar 2020 11:24:09 +0100
Message-Id: <20200309102420.24498-3-eric.auger@redhat.com>
In-Reply-To: <20200309102420.24498-1-eric.auger@redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the power of 2 order of a size. Use it in
page_memalign. Other users are looming.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/alloc_page.c | 7 ++++++-
 lib/alloc_page.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index ed23638..7c8461a 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -155,7 +155,7 @@ static void *page_memalign(size_t alignment, size_t s=
ize)
 	if (!size)
 		return NULL;
=20
-	order =3D is_power_of_2(n) ? fls(n) : fls(n) + 1;
+	order =3D get_order(n);
=20
 	return alloc_pages(order);
 }
@@ -175,3 +175,8 @@ void page_alloc_ops_enable(void)
 {
 	alloc_ops =3D &page_alloc_ops;
 }
+
+int get_order(size_t size)
+{
+	return is_power_of_2(size) ? fls(size) : fls(size) + 1;
+}
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 739a91d..e6a51d2 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -15,5 +15,6 @@ void *alloc_pages(unsigned long order);
 void free_page(void *page);
 void free_pages(void *mem, unsigned long size);
 void free_pages_by_order(void *mem, unsigned long order);
+int get_order(size_t size);
=20
 #endif
--=20
2.20.1

