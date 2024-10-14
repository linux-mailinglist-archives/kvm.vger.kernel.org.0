Return-Path: <kvm+bounces-28774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC7699CF1D
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C46BF1F222B7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4595B1CEAB0;
	Mon, 14 Oct 2024 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xcgtso2C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26A71AC884
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917253; cv=none; b=KQoctHhKT92CrDduzywwnIWQNjvwLGXAAfdWbBQHLRtNgH395Cn9UgYkiai1BAem5eKDqsjs4KcYie+WC/63KkMSmcQRp6O8OzUH2LxPth7pe+dlFG/XiTzniguMtzcxDWqDwQtzttSXjyG4U+0mTMODYn22APA2ZNxYP33HIbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917253; c=relaxed/simple;
	bh=I15jUcBUdXnJzCptx9GLa3TxQW1EuBqxNZMGYFsaP7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uo5MRYAd84zrCJ/VJP4Pli7NqYZwAANVhN+oB4/aJRCGPQXPe8FdaOWBNIYrK+B/SFfppkxTW0DXAXF3IL1RBWh1PELmotenb95Up3reh7XRL5eTyaxgECLReBAIsr36+yYL2Ey6l0HPq5UllNot/5LC96SPTcylAcLbFWSA73U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xcgtso2C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728917250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vLbVvz73tLbmbnaPx4ieOXFlBDH6z0eEi0A+B6nUW0=;
	b=Xcgtso2CPr3HpKcRZ0gM0ztTPXozzLlgCR3ZOYTfjVjcl/6gfmsj1ZTvsMDNCvSKMOQ5Mn
	FTq5TCRuB4FHMjBTZ8WG79tLodF+cZ4lAIRcrp9xlCcOgPnpNVGdtgcDypMd8TRBRpz625
	taOPGWG/3TLuJC2bhKIm6Af4+Vrvq7o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-8KXKzAUyOoGjGD-HwYImmg-1; Mon,
 14 Oct 2024 10:47:27 -0400
X-MC-Unique: 8KXKzAUyOoGjGD-HwYImmg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F38F1955F07;
	Mon, 14 Oct 2024 14:47:25 +0000 (UTC)
Received: from t14s.cit.tum.de (unknown [10.22.32.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F09031955E8F;
	Mon, 14 Oct 2024 14:47:17 +0000 (UTC)
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
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mario Casquero <mcasquer@redhat.com>
Subject: [PATCH v2 7/7] s390/sparsemem: reduce section size to 128 MiB
Date: Mon, 14 Oct 2024 16:46:19 +0200
Message-ID: <20241014144622.876731-8-david@redhat.com>
In-Reply-To: <20241014144622.876731-1-david@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Ever since commit 421c175c4d609 ("[S390] Add support for memory hot-add.")
we've been using a section size of 256 MiB on s390 and 32 MiB on s390.
Before that, we were using a section size of 32 MiB on both
architectures.

Likely the reason was that we'd expect a storage increment size of
256 MiB under z/VM back then. As we didn't support memory blocks spanning
multiple memory sections, we would have had to handle having multiple
memory blocks for a single storage increment, which complicates things.
Although that issue reappeared with even bigger storage increment sizes
later, nowadays we have memory blocks that can span multiple memory
sections and we avoid any such issue completely.

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
x86-64 and arm64 feels like te right thing for now.

Note that the smallest memory hot(un)plug granularity is also limited by
the memory block size, determined by extracting the memory increment
size from SCLP. Under QEMU/KVM, implementing virtio-mem, we expose 0;
therefore, we'll end up with a memory block size of 128 MiB with a
128 MiB section size.

Tested-by: Mario Casquero <mcasquer@redhat.com>
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


