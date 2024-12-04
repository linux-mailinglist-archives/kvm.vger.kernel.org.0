Return-Path: <kvm+bounces-33023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8771A9E3AC9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F17B3B37A6D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD93A1F7547;
	Wed,  4 Dec 2024 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aoNuebCb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1937C1F6662
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316908; cv=none; b=aNJkXcrLYaRsylXxTv9bLF+fW3sF0HQJ64fHf8+R68xi/bW5AoMRWC07pTi6Fkk/weKo7fgG+FDVBcHb7u/mT3/AEjOhYvwgEefd+RR7AUcNuaKJTx5DU4Vcyaij4HjVDFfBBqeUqCtOWFY3Ak8aK3c1yZ5tzX7gJCKRUeWcFTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316908; c=relaxed/simple;
	bh=HA0N1cA5be1rrj+6WYs2Tt0NgjsLsDLvBhYCgodIfoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK26sOLBTN5xn2oErobZVEtMs9Ll3KXlRmGd+iziDmzvODhxlqeicg40wwh0ZEW+9iHtTDkC2cmeqVmd75S2hW3i21IBKLzEx8OrhmE21wu1i04MXSJQCNrgR5LU7C4H+uHYy9RgdGKKjbz5a4jYLNyAdzdC9Gzj0Dt3iKVryOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aoNuebCb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVSVbg92vBS9ECQ/qpyBYmAQmSQp+EsDoLv4fB2tW0Q=;
	b=aoNuebCbUhApNLiPTj4ptjq5FK+7D7hTpv7bVT/Ad+r1SZOaRp7aCFx3kxIbbgeglRwwKy
	a867A07M2iQKOBJlJoW9lw60ZqR3MHk+G/pdt1tfK2V+qSjbEFT0h+6bjm90vNx5Yro4jS
	lxdDmYP2gYaSML4pyWNd2GIYAm4+j6M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-SN4ALKA6OFGQLW0BAXZhmA-1; Wed, 04 Dec 2024 07:55:04 -0500
X-MC-Unique: SN4ALKA6OFGQLW0BAXZhmA-1
X-Mimecast-MFC-AGG-ID: SN4ALKA6OFGQLW0BAXZhmA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434a96889baso38557765e9.2
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316904; x=1733921704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AVSVbg92vBS9ECQ/qpyBYmAQmSQp+EsDoLv4fB2tW0Q=;
        b=wq11DEYAwBLeb3KDQAynYkGzrGuMwK1WvxAPl5B2jAn3+u4sGCCtkJiTzZLegqaB9F
         4AjBJLMw5HcAjLYYmV28lwe3mugX2C78fRWnDP9yjneGBdeoiEljfr9v/DSnVD5YCHep
         UyEtab8bOnqPIFdZJlyp+c50k+DDCx8JU4Yd2LFcH5bw0yaKIUrqzSrW20Xq8F7LxZzH
         j2QPP8HqyU3P8Y4pB7Tk94HobQWkJvME/Z7AsA34ImrdF6XaMCaGUKys9Gy0v+vWO2JW
         QjD6vY7F6Mk3CBVVLfUaIQjSmAwvYvtQf2xr2Jy/DYYvayBmb0ZRabVV1YRZ+4Cd40hm
         EIrw==
X-Forwarded-Encrypted: i=1; AJvYcCWccXpOVcjQj5kG13xc4+cN/yuOSVoNPQQjBa5ybXF2fF6nEg/R9o1Gus0yN39shagnKt8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi1vZQOomDHLp5WVttNFBF1RPfIpKZsLKLHvjoTOg9VME9MDjs
	sOCCGet31BmAL/vpsFnugjtQ8WU7qLRmB9YxcKYtZqjKri4SfNFenfhb9ZNGjzFbSlgE+wfZkRG
	i3mtDRgQSm8h55OevPXZDt6e6bTivePyq0/AP8MFydZmZI+efOw==
X-Gm-Gg: ASbGnctxbjqcTvO9XapCdupc1x/SVHTgF5JSNcQFe3+r5t2J0l6MSS+vgOd8bnoxf7M
	9Lnmd3XdyGMajfAAeNkszCCPmU3rymWPr/V2RxjsXg64W2/P0DXsSgp3zKChJtrZR2fEMUT7OB3
	FrI/AywL0w5K9/lQf+y+BMuGr0mWnuxFy7c6GAxni06AQKMNWYg0DAZxuyJ7K8KlQQa/K60bbXI
	Zb/qo0jgiC0waockKIYBP8IhEyJA9+wvjLTw8e8u4pSBGSqvTte3aALLoMi6jCxusstp8jiZNDC
	g1+jQ7mFmAgqo5KvkmVp5sktJb/XV93hHkk=
X-Received: by 2002:a05:600c:1906:b0:434:942c:1466 with SMTP id 5b1f17b1804b1-434d3fe3665mr34089955e9.29.1733316903710;
        Wed, 04 Dec 2024 04:55:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHp2zQuzmhokkabZpnrzoR4CmRg7d0WsOdBj322Nwyq7pIMtC1YAe5DPX1PH/Wsn3EpBmq5yA==
X-Received: by 2002:a05:600c:1906:b0:434:942c:1466 with SMTP id 5b1f17b1804b1-434d3fe3665mr34089715e9.29.1733316903376;
        Wed, 04 Dec 2024 04:55:03 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434d52b66ecsm23469265e9.39.2024.12.04.04.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:55:02 -0800 (PST)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kexec@lists.infradead.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 05/12] fs/proc/vmcore: move vmcore definitions out of kcore.h
Date: Wed,  4 Dec 2024 13:54:36 +0100
Message-ID: <20241204125444.1734652-6-david@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241204125444.1734652-1-david@redhat.com>
References: <20241204125444.1734652-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These vmcore defines are not related to /proc/kcore, move them out.

We'll move "struct vmcoredd_node" to vmcore.c, because it is only used
internally. While "struct vmcore" is only used internally for now,
we're planning on using it from inline functions in crash_dump.h next,
so move it to crash_dump.h.

While at it, rename "struct vmcore" to "struct vmcore_range", which is a
more suitable name and will make the usage of it outside of vmcore.c
clearer.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c           | 26 ++++++++++++++++----------
 include/linux/crash_dump.h |  7 +++++++
 include/linux/kcore.h      | 13 -------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 13dfc128d07e..8d262017ca11 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -53,6 +53,12 @@ static u64 vmcore_size;
 static struct proc_dir_entry *proc_vmcore;
 
 #ifdef CONFIG_PROC_VMCORE_DEVICE_DUMP
+struct vmcoredd_node {
+	struct list_head list;	/* List of dumps */
+	void *buf;		/* Buffer containing device's dump */
+	unsigned int size;	/* Size of the buffer */
+};
+
 /* Device Dump list and mutex to synchronize access to list */
 static LIST_HEAD(vmcoredd_list);
 
@@ -322,10 +328,10 @@ static int vmcoredd_mmap_dumps(struct vm_area_struct *vma, unsigned long dst,
  */
 static ssize_t __read_vmcore(struct iov_iter *iter, loff_t *fpos)
 {
+	struct vmcore_range *m = NULL;
 	ssize_t acc = 0, tmp;
 	size_t tsz;
 	u64 start;
-	struct vmcore *m = NULL;
 
 	if (!iov_iter_count(iter) || *fpos >= vmcore_size)
 		return 0;
@@ -580,7 +586,7 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
 	u64 start, end, len, tsz;
-	struct vmcore *m;
+	struct vmcore_range *m;
 
 	start = (u64)vma->vm_pgoff << PAGE_SHIFT;
 	end = start + size;
@@ -703,16 +709,16 @@ static const struct proc_ops vmcore_proc_ops = {
 	.proc_mmap	= mmap_vmcore,
 };
 
-static struct vmcore* __init get_new_element(void)
+static struct vmcore_range * __init get_new_element(void)
 {
-	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
+	return kzalloc(sizeof(struct vmcore_range), GFP_KERNEL);
 }
 
 static u64 get_vmcore_size(size_t elfsz, size_t elfnotesegsz,
 			   struct list_head *vc_list)
 {
+	struct vmcore_range *m;
 	u64 size;
-	struct vmcore *m;
 
 	size = elfsz + elfnotesegsz;
 	list_for_each_entry(m, vc_list, list) {
@@ -1110,11 +1116,11 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 						size_t elfnotes_sz,
 						struct list_head *vc_list)
 {
+	struct vmcore_range *new;
 	int i;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
@@ -1153,11 +1159,11 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 						size_t elfnotes_sz,
 						struct list_head *vc_list)
 {
+	struct vmcore_range *new;
 	int i;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
@@ -1195,8 +1201,8 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 static void set_vmcore_list_offsets(size_t elfsz, size_t elfnotes_sz,
 				    struct list_head *vc_list)
 {
+	struct vmcore_range *m;
 	loff_t vmcore_off;
-	struct vmcore *m;
 
 	/* Skip ELF header, program headers and ELF note segment. */
 	vmcore_off = elfsz + elfnotes_sz;
@@ -1605,9 +1611,9 @@ void vmcore_cleanup(void)
 
 	/* clear the vmcore list. */
 	while (!list_empty(&vmcore_list)) {
-		struct vmcore *m;
+		struct vmcore_range *m;
 
-		m = list_first_entry(&vmcore_list, struct vmcore, list);
+		m = list_first_entry(&vmcore_list, struct vmcore_range, list);
 		list_del(&m->list);
 		kfree(m);
 	}
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index acc55626afdc..788a45061f35 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -114,6 +114,13 @@ struct vmcore_cb {
 extern void register_vmcore_cb(struct vmcore_cb *cb);
 extern void unregister_vmcore_cb(struct vmcore_cb *cb);
 
+struct vmcore_range {
+	struct list_head list;
+	unsigned long long paddr;
+	unsigned long long size;
+	loff_t offset;
+};
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline bool is_kdump_kernel(void) { return false; }
 #endif /* CONFIG_CRASH_DUMP */
diff --git a/include/linux/kcore.h b/include/linux/kcore.h
index 86c0f1d18998..9a2fa013c91d 100644
--- a/include/linux/kcore.h
+++ b/include/linux/kcore.h
@@ -20,19 +20,6 @@ struct kcore_list {
 	int type;
 };
 
-struct vmcore {
-	struct list_head list;
-	unsigned long long paddr;
-	unsigned long long size;
-	loff_t offset;
-};
-
-struct vmcoredd_node {
-	struct list_head list;	/* List of dumps */
-	void *buf;		/* Buffer containing device's dump */
-	unsigned int size;	/* Size of the buffer */
-};
-
 #ifdef CONFIG_PROC_KCORE
 void __init kclist_add(struct kcore_list *, void *, size_t, int type);
 
-- 
2.47.1


