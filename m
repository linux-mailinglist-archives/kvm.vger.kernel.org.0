Return-Path: <kvm+bounces-28766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4DB99CEE6
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30D661F24212
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AF61ADFF1;
	Mon, 14 Oct 2024 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hzBgj/fk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE141B85C0
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 14:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917207; cv=none; b=PLw7lDYrwJLtKq3tMB9tALAw8Ho+lVQrdSoRGM1N8iLyBdVfPRsU47E3vgtQDEobzNXUAZm7V6i+wsy3CZn2hGhUD75FXW9qwhf9XZVUVFqfwULZS9I+ciwAa7eMwYhLCEdKcWp/00QLpF9rSypfDwrm7ZBL1rqmYQdwTz2zQ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917207; c=relaxed/simple;
	bh=6GrjvwYuZlk/X09sJDTfx4n347qy2DjePjJCHFD6X+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcWZz2sEC59a0BCggnbwaVXKTqdQmuhe8Tv6PIgfUzYYpCW8b09KpTjX/sD/fbmVOGhxFM8dZ0gGwVkbtKs6FtMoHyZZW16SjTFip6oLZQBga2M5dMmn+2aybgyokf79PRBOS/Qzm0MDPt1h/sH+XMGcpBsuQPIybLPVppNNY6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hzBgj/fk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728917205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvU7hgH0NcVyT2s8439e7eS1PoyrARDWsEuaW/yYTUo=;
	b=hzBgj/fkyAB0LsB+jzD2H3hcNlkuM1GoWefIPv9b24TGlHrkwOfjSEUpDp88CQ9qnB79Df
	oejHqqpjit+y40jIOuI070jjYLSQ3aq1XeE/Ok6y+r5GTg4PH5R3owUhx7htiivOjfYQvp
	EBXTAsdq5m0VmLkU0mRblJv8SbkpgXY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-d5FnqCvGOkSv9Gj83elS0A-1; Mon,
 14 Oct 2024 10:46:41 -0400
X-MC-Unique: d5FnqCvGOkSv9Gj83elS0A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5198B19560A7;
	Mon, 14 Oct 2024 14:46:39 +0000 (UTC)
Received: from t14s.cit.tum.de (unknown [10.22.32.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1ADD21955E8F;
	Mon, 14 Oct 2024 14:46:31 +0000 (UTC)
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
Subject: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
Date: Mon, 14 Oct 2024 16:46:13 +0200
Message-ID: <20241014144622.876731-2-david@redhat.com>
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

s390 currently always results in is_kdump_kernel() == false, because
it sets "elfcorehdr_addr = ELFCORE_ADDR_MAX;" early during setup_arch to
deactivate the elfcorehdr= kernel parameter.

Let's follow the powerpc example and implement our own logic.

This is required for virtio-mem to reliably identify a kdump
environment to not try hotplugging memory.

Tested-by: Mario Casquero <mcasquer@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/kexec.h | 4 ++++
 arch/s390/kernel/crash_dump.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 1bd08eb56d5f..bd20543515f5 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -94,6 +94,9 @@ void arch_kexec_protect_crashkres(void);
 
 void arch_kexec_unprotect_crashkres(void);
 #define arch_kexec_unprotect_crashkres arch_kexec_unprotect_crashkres
+
+bool is_kdump_kernel(void);
+#define is_kdump_kernel is_kdump_kernel
 #endif
 
 #ifdef CONFIG_KEXEC_FILE
@@ -107,4 +110,5 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
+
 #endif /*_S390_KEXEC_H */
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index edae13416196..cca1827d3d2e 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -237,6 +237,12 @@ int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
 						       prot);
 }
 
+bool is_kdump_kernel(void)
+{
+	return oldmem_data.start && !is_ipl_type_dump();
+}
+EXPORT_SYMBOL_GPL(is_kdump_kernel);
+
 static const char *nt_name(Elf64_Word type)
 {
 	const char *name = "LINUX";
-- 
2.46.1


