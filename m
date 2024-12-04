Return-Path: <kvm+bounces-33021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0069E3A81
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D4982814C6
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C331EE00E;
	Wed,  4 Dec 2024 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JzwCi8/7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935201BC08B
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316904; cv=none; b=HwkxsVG3GlpJfsLmrVgNriwAC2+sg1XyDTjdTwdhdoncd5948CzmsohGK8FITGi69J4Dhb/9JJeovFExK/MeI8TWoie2CjmiRxJ7sslXWZ6pEGtQxkgWaSif5ZohEsKtan8aXdZ3w6r39COPiXm4opQ2Bxcr5u8BtqVGsXAWKTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316904; c=relaxed/simple;
	bh=xNCoAGkL25Y87LMlQW3va8oiEgJuCLqo1bQEZDQgP2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rknq4NNDTgovd01Y2ic7//LAZ5XsfLbR6RB1dLN1pYXm7ZM3zsr7PZqK7B0wYAXD8xqd2d9dfJ7gveWBmhVGCR+yES7AU6uPiSGADdALueRSBKUp50IW5lGkkAdmEWSQuF/oLMN7pWmgOyXY3tYqlIBeNVlBn0PuOGvFHkCtLls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JzwCi8/7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9g+9cVRXvhHLgxGSqrQTBE7Bw6RR/sxdLnnaInZE9Y8=;
	b=JzwCi8/73XhuoaeYOsima5YwSAm8Rtwqb0OF6XJlmyywgu4U+E5vWRzM6ITv6bH268EMHU
	Blpvxu0XbJhLh+ww+p8/Qj8HAje2gjmNM8iXU60iSMRGnr9rAqmbnWFFrJ+4MptFdeCksT
	v3DP9mfYiBdKAjl8TqZH1HKiO7yaD4w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-r1dWu3bsO-u7vLbtEDCwRQ-1; Wed, 04 Dec 2024 07:55:00 -0500
X-MC-Unique: r1dWu3bsO-u7vLbtEDCwRQ-1
X-Mimecast-MFC-AGG-ID: r1dWu3bsO-u7vLbtEDCwRQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-434a90febb8so38583715e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316899; x=1733921699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9g+9cVRXvhHLgxGSqrQTBE7Bw6RR/sxdLnnaInZE9Y8=;
        b=aUUuiP41w6bVXdyHPJ//xR27uGHXpJMd6gipwBHY2zkPw2M3hsgcb+uudrYT7MrR5U
         Pxrojh8Yrwc6rvt2b0P5TsLZ/z1zxL5FGbrVLPQNTR7VbSH48ha3/YllCyMS4XhFgG3G
         aEXBwrjfyh/COrCUe2A8tyr4J3FLQPH0AIbQOgYBCcsHiOIMU3DaeEJVm5UdA8uu4u+B
         EHeqt9IjHbfu65b0BJgOfhb0+Ooqs4wb6bCeolTLdC3Pge8DBch1GdwvLMsIVw52ts3F
         FAOGabmK8eQ8upnYhRl5Erg6U2WFXjtXfcsmTG8BQctk+13Ti5bbGGjvp5CePZmjgplE
         8V1g==
X-Forwarded-Encrypted: i=1; AJvYcCUNY17bAcN1za82JyQUCz0ITg6P8+2XH541auYENAe3X1u1S43PC+8wbvzi8VBcu+BOQWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFrWclPrfoQc87KOzOPGYQQDoBtOcFBwVWFcxqUm2+nrsM672b
	ieZrkKfzB9CB0h3Hs9Ewxmb4uQfqwGQs9emI6dIn5DrF9TrDEcUo9yvM8sRkS1Ay7UDAtOAh7QC
	FwXXH5D2b4OO0pU7U6zvWFgfsvZ27Ncaslwle7JV9Spoh2Yi/1A==
X-Gm-Gg: ASbGnctcjKkG3GHSeKW4R1a+wbiBs7fxv1g0szhm8kU9LVRyEnQphWk4KBHLasPQfLQ
	1unrkQqHEYqaQ4KfBk7lPRVR2e2yxdFK3smJTp/5KlGAqk78TRpsW34+JOBS9HessjnRTvvcKCU
	HEFEc7j8pfcYPIeJA8KRkRKq0azcObsfkNPCJxBm/1kmdM+pr7KPmXmjCnsuzptcq1FbIBsvy25
	XJFgObyXsGkOL7lWPe+ZiUFk5OXVSt5hvBwOuLSKeh9Prf2YrRjV8vCS7WGC+EdQtSkYoKnmQA/
	u0oFEVQIG8bv9qfwKCVqO9AwFq7uYW/6rPk=
X-Received: by 2002:a05:600c:a46:b0:434:9e17:18e5 with SMTP id 5b1f17b1804b1-434d3f015c9mr39711655e9.0.1733316899003;
        Wed, 04 Dec 2024 04:54:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeFWcM8kn1L8FVMwX9bQLaSRcl3tsS9Ol6XIyBOc2az2VjBMSNXd7wAhtLStmYUmhz8yBnag==
X-Received: by 2002:a05:600c:a46:b0:434:9e17:18e5 with SMTP id 5b1f17b1804b1-434d3f015c9mr39710705e9.0.1733316897137;
        Wed, 04 Dec 2024 04:54:57 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434d52c0dc8sm23581375e9.27.2024.12.04.04.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:54:55 -0800 (PST)
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
Subject: [PATCH v2 03/12] fs/proc/vmcore: disallow vmcore modifications while the vmcore is open
Date: Wed,  4 Dec 2024 13:54:34 +0100
Message-ID: <20241204125444.1734652-4-david@redhat.com>
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

The vmcoredd_update_size() call and its effects (size/offset changes) are
currently completely unsynchronized, and will cause trouble when
performed concurrently, or when done while someone is already reading the
vmcore.

Let's protect all vmcore modifications by the vmcore_mutex, disallow vmcore
modifications while the vmcore is open, and warn on vmcore
modifications after the vmcore was already opened once: modifications
while the vmcore is open are unsafe, and modifications after the vmcore
was opened indicates trouble. Properly synchronize against concurrent
opening of the vmcore.

No need to grab the mutex during mmap()/read(): after we opened the
vmcore, modifications are impossible.

It's worth noting that modifications after the vmcore was opened are
completely unexpected, so failing if open, and warning if already opened
(+closed again) is good enough.

This change not only handles concurrent adding of device dumps +
concurrent reading of the vmcore properly, it also prepares for other
mechanisms that will modify the vmcore.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c | 57 +++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index e5a7e302f91f..16faabe5ea30 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -68,6 +68,8 @@ DEFINE_STATIC_SRCU(vmcore_cb_srcu);
 static LIST_HEAD(vmcore_cb_list);
 /* Whether the vmcore has been opened once. */
 static bool vmcore_opened;
+/* Whether the vmcore is currently open. */
+static unsigned int vmcore_open;
 
 void register_vmcore_cb(struct vmcore_cb *cb)
 {
@@ -122,6 +124,20 @@ static int open_vmcore(struct inode *inode, struct file *file)
 {
 	mutex_lock(&vmcore_mutex);
 	vmcore_opened = true;
+	if (vmcore_open + 1 == 0) {
+		mutex_unlock(&vmcore_mutex);
+		return -EBUSY;
+	}
+	vmcore_open++;
+	mutex_unlock(&vmcore_mutex);
+
+	return 0;
+}
+
+static int release_vmcore(struct inode *inode, struct file *file)
+{
+	mutex_lock(&vmcore_mutex);
+	vmcore_open--;
 	mutex_unlock(&vmcore_mutex);
 
 	return 0;
@@ -243,33 +259,27 @@ static int vmcoredd_copy_dumps(struct iov_iter *iter, u64 start, size_t size)
 {
 	struct vmcoredd_node *dump;
 	u64 offset = 0;
-	int ret = 0;
 	size_t tsz;
 	char *buf;
 
-	mutex_lock(&vmcore_mutex);
 	list_for_each_entry(dump, &vmcoredd_list, list) {
 		if (start < offset + dump->size) {
 			tsz = min(offset + (u64)dump->size - start, (u64)size);
 			buf = dump->buf + start - offset;
-			if (copy_to_iter(buf, tsz, iter) < tsz) {
-				ret = -EFAULT;
-				goto out_unlock;
-			}
+			if (copy_to_iter(buf, tsz, iter) < tsz)
+				return -EFAULT;
 
 			size -= tsz;
 			start += tsz;
 
 			/* Leave now if buffer filled already */
 			if (!size)
-				goto out_unlock;
+				return 0;
 		}
 		offset += dump->size;
 	}
 
-out_unlock:
-	mutex_unlock(&vmcore_mutex);
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_MMU
@@ -278,20 +288,16 @@ static int vmcoredd_mmap_dumps(struct vm_area_struct *vma, unsigned long dst,
 {
 	struct vmcoredd_node *dump;
 	u64 offset = 0;
-	int ret = 0;
 	size_t tsz;
 	char *buf;
 
-	mutex_lock(&vmcore_mutex);
 	list_for_each_entry(dump, &vmcoredd_list, list) {
 		if (start < offset + dump->size) {
 			tsz = min(offset + (u64)dump->size - start, (u64)size);
 			buf = dump->buf + start - offset;
 			if (remap_vmalloc_range_partial(vma, dst, buf, 0,
-							tsz)) {
-				ret = -EFAULT;
-				goto out_unlock;
-			}
+							tsz))
+				return -EFAULT;
 
 			size -= tsz;
 			start += tsz;
@@ -299,14 +305,12 @@ static int vmcoredd_mmap_dumps(struct vm_area_struct *vma, unsigned long dst,
 
 			/* Leave now if buffer filled already */
 			if (!size)
-				goto out_unlock;
+				return 0;
 		}
 		offset += dump->size;
 	}
 
-out_unlock:
-	mutex_unlock(&vmcore_mutex);
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_MMU */
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
@@ -691,6 +695,7 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
 static const struct proc_ops vmcore_proc_ops = {
 	.proc_open	= open_vmcore,
+	.proc_release	= release_vmcore,
 	.proc_read_iter	= read_vmcore,
 	.proc_lseek	= default_llseek,
 	.proc_mmap	= mmap_vmcore,
@@ -1516,12 +1521,18 @@ int vmcore_add_device_dump(struct vmcoredd_data *data)
 	dump->buf = buf;
 	dump->size = data_size;
 
-	/* Add the dump to driver sysfs list */
+	/* Add the dump to driver sysfs list and update the elfcore hdr */
 	mutex_lock(&vmcore_mutex);
-	list_add_tail(&dump->list, &vmcoredd_list);
-	mutex_unlock(&vmcore_mutex);
+	if (vmcore_opened)
+		pr_warn_once("Unexpected adding of device dump\n");
+	if (vmcore_open) {
+		ret = -EBUSY;
+		goto out_err;
+	}
 
+	list_add_tail(&dump->list, &vmcoredd_list);
 	vmcoredd_update_size(data_size);
+	mutex_unlock(&vmcore_mutex);
 	return 0;
 
 out_err:
-- 
2.47.1


