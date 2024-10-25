Return-Path: <kvm+bounces-29718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 090329B0577
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9DD51F24A72
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 14:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5086920D510;
	Fri, 25 Oct 2024 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cpy55fY5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2761FB8B0
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865760; cv=none; b=KPVrA9bDksDyujDMtztM1ZD7xkxVo2lTuz3aK7JKxZuKNDgHfirgUGPoCY2mEUDZeaiw8j+pqCU9K6+O83b4FVvaW0CNCrpdVKUonb2EE5wpvIQZ5PI2IlpJFoQN9dOiMkMNkWxADoOTjh36+aSrKqUvz9WqQhUhnGmbRb1VP+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865760; c=relaxed/simple;
	bh=2GXCUlyOi24cr84KtLR76IrFQ4bDh/2Fz1VgOJWs5Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZE8+4QvPAozb2Z9EsYZ5UiUECNYz84oTuhmcsOrbAVmz27nTNJ4iqGn01LVWVJaSq2FUXv6JdEZZ8GhLt7jGFL5h1+l1K9aNl6Y7wsnRYhaAPKkyMCP/YnHfgnBS7AXUuc7AA3mU3RxjUgjpqlURokHT8tA3Wh2PTPrAsdDb0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cpy55fY5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729865757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=minQPvjcAw7BmTU59AI15v5UYV4aItz4WqTTQMtatbA=;
	b=Cpy55fY5LI2w/vkgUGLC2Yg9qDCeAoy6mlb6SiIYbrtEy6pIIAeEsniwQPQnhqmozs2zlB
	ih4L2iSoMpHR07vKdGw60oxI52JI2yyeRYIiUX6zplGKR/jub0v5ERXm66/jHbQ0L53YHX
	y16COZyQ1BuMHzA2dfL5Bw/o6uWqoU8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-cIntWAoSP6e3AMrL0U5dWA-1; Fri,
 25 Oct 2024 10:15:54 -0400
X-MC-Unique: cIntWAoSP6e3AMrL0U5dWA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8804419560B5;
	Fri, 25 Oct 2024 14:15:50 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.65.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2754819560A2;
	Fri, 25 Oct 2024 14:15:42 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mario Casquero <mcasquer@redhat.com>
Subject: [PATCH v3 6/7] s390/sparsemem: reduce section size to 128 MiB
Date: Fri, 25 Oct 2024 16:14:51 +0200
Message-ID: <20241025141453.1210600-7-david@redhat.com>
In-Reply-To: <20241025141453.1210600-1-david@redhat.com>
References: <20241025141453.1210600-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Ever since commit 421c175c4d609 ("[S390] Add support for memory hot-add.")
we've been using a section size of 256 MiB on s390 and 32 MiB on s390.
Before that, we were using a section size of 32 MiB on both
architectures.

Now that we have a new mechanism to expose additional memory to a VM --
virtio-mem -- reduce the section size to 128 MiB to allow for more
flexibility and reduce the metadata overhead when dealing with hot(un)plug
granularity smaller than 256 MiB.

128 MiB has been used by x86-64 since the very beginning. arm64 with 4k
base pages switched to 128 MiB as well: it's just big enough on these
architectures to allows for using a huge page (2 MiB) in the vmemmap in
sane setups with sizeof(struct page) == 64 bytes and a huge page mapping
in the direct mapping, while still allowing for small hot(un)plug
granularity.

For s390, we could even switch to a 64 MiB section size, as our huge page
size is 1 MiB: but the smaller the section size, the more sections we'll
have to manage especially on bigger machines. Making it consistent with
x86-64 and arm64 feels like the right thing for now.

Note that the smallest memory hot(un)plug granularity is also limited by
the memory block size, determined by extracting the memory increment
size from SCLP. Under QEMU/KVM, implementing virtio-mem, we expose 0;
therefore, we'll end up with a memory block size of 128 MiB with a
128 MiB section size.

Tested-by: Mario Casquero <mcasquer@redhat.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/sparsemem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/sparsemem.h b/arch/s390/include/asm/sparsemem.h
index c549893602ea..ff628c50afac 100644
--- a/arch/s390/include/asm/sparsemem.h
+++ b/arch/s390/include/asm/sparsemem.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_S390_SPARSEMEM_H
 #define _ASM_S390_SPARSEMEM_H
 
-#define SECTION_SIZE_BITS	28
+#define SECTION_SIZE_BITS	27
 #define MAX_PHYSMEM_BITS	CONFIG_MAX_PHYSMEM_BITS
 
 #endif /* _ASM_S390_SPARSEMEM_H */
-- 
2.46.1


