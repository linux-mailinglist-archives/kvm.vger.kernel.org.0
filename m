Return-Path: <kvm+bounces-29715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C44A39B0563
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21EFDB23C8B
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 14:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51D520BB3B;
	Fri, 25 Oct 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ds8kipDp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD821FB8B3
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865740; cv=none; b=aqsHCdU8CujrMh2Y12bCpTyujgbIJpZCsFOjWVOoLVGB/cQLbo9iT78dmZzJE+Opvmp2R2rPoM8GmBqJ33YeNnzp4hbi+GeH6cczjcGRbIghD2+eDWPMIL9FV4wkSGgyXqPOS6un3LR5NZjhh3eWFyKaQWo3VIAMt883pCpYfis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865740; c=relaxed/simple;
	bh=hdJNjHxHrqFfbuBDQMj2y+0Jbs3d9VzzPDOB1Kovk/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT5emQOnBRVdOaag4nJ8gO+Vx1HeQ0cFg0r00DjI2rPpqHAJEgPgAP78AzgJXLJRjSApBYLzgs8zKHF4p9U5cZPTb/3xTwAo7YJ86YB4ZRytciIr8WRKO1NQrczyrMAWXOC+5IDE/srG/UZg0J17pSLx6QM59Wheygpvltpy4iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ds8kipDp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729865736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P/OWBKgNxsqut2xHOcIgEvQRSrYiossJkI+amYxch/4=;
	b=Ds8kipDpbfjYEWY5jY1RGOxLt41HdxtmJVjhSfvE4mDzE+Qe9ucUteSSRWSSryKP1GNDMZ
	fvmfSTLPHypbeUn0NEfQa/DqP0LDmcjAVn8gOXMq32DJFcZOe8D9PBKOjofNjF7jRcLn97
	4hQU1oDwilVbIsJACPCoqDh3xuk9pxo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-u59Cgv1VPbS7mn3iPCL1Vg-1; Fri,
 25 Oct 2024 10:15:33 -0400
X-MC-Unique: u59Cgv1VPbS7mn3iPCL1Vg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4636A1955F3B;
	Fri, 25 Oct 2024 14:15:26 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.65.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C14B519560A2;
	Fri, 25 Oct 2024 14:15:18 +0000 (UTC)
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
Subject: [PATCH v3 3/7] s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM memory devices
Date: Fri, 25 Oct 2024 16:14:48 +0200
Message-ID: <20241025141453.1210600-4-david@redhat.com>
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

To support memory devices under QEMU/KVM, such as virtio-mem,
we have to prepare our kernel virtual address space accordingly and
have to know the highest possible physical memory address we might see
later: the storage limit. The good old SCLP interface is not suitable for
this use case.

In particular, memory owned by memory devices has no relationship to
storage increments, it is always detected using the device driver, and
unaware OSes (no driver) must never try making use of that memory.
Consequently this memory is located outside of the "maximum storage
increment"-indicated memory range.

Let's use our new diag500 STORAGE_LIMIT subcode to query this storage
limit that can exceed the "maximum storage increment", and use the
existing interfaces (i.e., SCLP) to obtain information about the initial
memory that is not owned+managed by memory devices.

If a hypervisor does not support such memory devices, the address exposed
through diag500 STORAGE_LIMIT will correspond to the maximum storage
increment exposed through SCLP.

To teach kdump on s390 to include memory owned by memory devices, there
will be ways to query the relevant memory ranges from the device via a
driver running in special kdump mode (like virtio-mem already implements
to filter /proc/vmcore access so we don't end up reading from unplugged
device blocks).

Update setup_ident_map_size(), to clarify that there can be more than
just online and standby memory.

Tested-by: Mario Casquero <mcasquer@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/boot/physmem_info.c        | 47 +++++++++++++++++++++++++++-
 arch/s390/boot/startup.c             |  7 +++--
 arch/s390/include/asm/physmem_info.h |  3 ++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/arch/s390/boot/physmem_info.c b/arch/s390/boot/physmem_info.c
index 1d131a81cb8b..f3ea5dbff10b 100644
--- a/arch/s390/boot/physmem_info.c
+++ b/arch/s390/boot/physmem_info.c
@@ -109,6 +109,42 @@ static int diag260(void)
 	return 0;
 }
 
+#define DIAG500_SC_STOR_LIMIT 4
+
+static int diag500_storage_limit(unsigned long *max_physmem_end)
+{
+	unsigned long storage_limit;
+	unsigned long reg1, reg2;
+	psw_t old;
+
+	asm volatile(
+		"	mvc	0(16,%[psw_old]),0(%[psw_pgm])\n"
+		"	epsw	%[reg1],%[reg2]\n"
+		"	st	%[reg1],0(%[psw_pgm])\n"
+		"	st	%[reg2],4(%[psw_pgm])\n"
+		"	larl	%[reg1],1f\n"
+		"	stg	%[reg1],8(%[psw_pgm])\n"
+		"	lghi	1,%[subcode]\n"
+		"	lghi	2,0\n"
+		"	diag	2,4,0x500\n"
+		"1:	mvc	0(16,%[psw_pgm]),0(%[psw_old])\n"
+		"	lgr	%[slimit],2\n"
+		: [reg1] "=&d" (reg1),
+		  [reg2] "=&a" (reg2),
+		  [slimit] "=d" (storage_limit),
+		  "=Q" (get_lowcore()->program_new_psw),
+		  "=Q" (old)
+		: [psw_old] "a" (&old),
+		  [psw_pgm] "a" (&get_lowcore()->program_new_psw),
+		  [subcode] "i" (DIAG500_SC_STOR_LIMIT)
+		: "memory", "1", "2");
+	if (!storage_limit)
+		return -EINVAL;
+	/* Convert inclusive end to exclusive end */
+	*max_physmem_end = storage_limit + 1;
+	return 0;
+}
+
 static int tprot(unsigned long addr)
 {
 	unsigned long reg1, reg2;
@@ -157,7 +193,9 @@ unsigned long detect_max_physmem_end(void)
 {
 	unsigned long max_physmem_end = 0;
 
-	if (!sclp_early_get_memsize(&max_physmem_end)) {
+	if (!diag500_storage_limit(&max_physmem_end)) {
+		physmem_info.info_source = MEM_DETECT_DIAG500_STOR_LIMIT;
+	} else if (!sclp_early_get_memsize(&max_physmem_end)) {
 		physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
 	} else {
 		max_physmem_end = search_mem_end();
@@ -170,6 +208,13 @@ void detect_physmem_online_ranges(unsigned long max_physmem_end)
 {
 	if (!sclp_early_read_storage_info()) {
 		physmem_info.info_source = MEM_DETECT_SCLP_STOR_INFO;
+	} else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
+		unsigned long online_end;
+
+		if (!sclp_early_get_memsize(&online_end)) {
+			physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
+			add_physmem_online_range(0, online_end);
+		}
 	} else if (!diag260()) {
 		physmem_info.info_source = MEM_DETECT_DIAG260;
 	} else if (max_physmem_end) {
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index c8f149ad77e5..76c33c7442df 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -182,12 +182,15 @@ static void kaslr_adjust_got(unsigned long offset)
  * Merge information from several sources into a single ident_map_size value.
  * "ident_map_size" represents the upper limit of physical memory we may ever
  * reach. It might not be all online memory, but also include standby (offline)
- * memory. "ident_map_size" could be lower then actual standby or even online
+ * memory or memory areas reserved for other means (e.g., memory devices such as
+ * virtio-mem).
+ *
+ * "ident_map_size" could be lower then actual standby/reserved or even online
  * memory present, due to limiting factors. We should never go above this limit.
  * It is the size of our identity mapping.
  *
  * Consider the following factors:
- * 1. max_physmem_end - end of physical memory online or standby.
+ * 1. max_physmem_end - end of physical memory online, standby or reserved.
  *    Always >= end of the last online memory range (get_physmem_online_end()).
  * 2. CONFIG_MAX_PHYSMEM_BITS - the maximum size of physical memory the
  *    kernel is able to support.
diff --git a/arch/s390/include/asm/physmem_info.h b/arch/s390/include/asm/physmem_info.h
index f45cfc8bc233..51b68a43e195 100644
--- a/arch/s390/include/asm/physmem_info.h
+++ b/arch/s390/include/asm/physmem_info.h
@@ -9,6 +9,7 @@ enum physmem_info_source {
 	MEM_DETECT_NONE = 0,
 	MEM_DETECT_SCLP_STOR_INFO,
 	MEM_DETECT_DIAG260,
+	MEM_DETECT_DIAG500_STOR_LIMIT,
 	MEM_DETECT_SCLP_READ_INFO,
 	MEM_DETECT_BIN_SEARCH
 };
@@ -107,6 +108,8 @@ static inline const char *get_physmem_info_source(void)
 		return "sclp storage info";
 	case MEM_DETECT_DIAG260:
 		return "diag260";
+	case MEM_DETECT_DIAG500_STOR_LIMIT:
+		return "diag500 storage limit";
 	case MEM_DETECT_SCLP_READ_INFO:
 		return "sclp read info";
 	case MEM_DETECT_BIN_SEARCH:
-- 
2.46.1


