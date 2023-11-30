Return-Path: <kvm+bounces-2871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAF97FEB76
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7A351C20D27
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5303F3B2B1;
	Thu, 30 Nov 2023 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBMaz2Bj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372B710E2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHFy7l3/5ZTvD59ydZrD2IN8QQe0B4M21kQ4dHgfeYA=;
	b=SBMaz2Bj0+b8fu7uzN1NUrcWZIkBSb+boI7cXeNxTbJ3/NLWyP3uyGcE4uWg8lyNMLhqGx
	X9+GIPQmTrdxb/+MPJZqnKjYEqJqby0CcK4SHlZdEfRMbjioGKv7cmXOIeZ843yYn+aAOx
	bi8tZkzANF4+dgyum0PEJLwA2M283Y4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-xgrAwIs7NQa1BlbkXanrcA-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: xgrAwIs7NQa1BlbkXanrcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCD3F82A621;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6D931C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 08/18] lib/alloc_phys: Expand documentation with usage and limitations
Date: Thu, 30 Nov 2023 04:07:10 -0500
Message-Id: <20231130090722.2897974-9-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

The physical allocator has gotten simpler, document its limitations and
current/expected usage.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 86b3d021..861959cf 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -4,10 +4,17 @@
  * phys_alloc is a very simple allocator which allows physical memory
  * to be partitioned into regions until all memory is allocated.
  *
- * Note: This is such a simple allocator that there is no way to free
- * a region. For more complicated memory management a single region
- * can be allocated, but then have its memory managed by a more
- * sophisticated allocator, e.g. a page allocator.
+ * Note: This is such a simple allocator that there is no way to free a
+ * region, and concurrent allocations are not supported. As such, it is
+ * mostly suitable for the architecture setup code, and less so for
+ * allocating memory in a test. For more complicated memory management a
+ * single region can be allocated (or the entire free memory), but then
+ * have that memory managed by a more sophisticated allocator, e.g. the
+ * page or the vmalloc allocators.
+ *
+ * Because of its simplicity, phys_alloc can easily perform cache
+ * maintenance on the state tracking variables it maintains, making it
+ * suitable for architectures which require such operations.
  *
  * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
-- 
2.40.1


