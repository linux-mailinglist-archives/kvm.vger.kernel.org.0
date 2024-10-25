Return-Path: <kvm+bounces-29724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6DA9B0794
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 17:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D334C284E4A
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 15:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9859618660B;
	Fri, 25 Oct 2024 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UsaE3Eit"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED871FB89E
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729869131; cv=none; b=PUGc/jkYOlXX8FD9MesMYv9bekXJ5DuOntDHv/WHpu3lo87dF8uz+p7IE4wwwAl4sYqgXth0zP8RQh/cDjoaHwvhtp0cSelnV4gCLe9ZRgBCcIGXX/f9y9NjGza3hV+PGK0Paggd8RpuUB/N7L3b0gBK4l4oDSs1El6LDj01WoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729869131; c=relaxed/simple;
	bh=SF9SnI1mj3HkmaMMxMaZqomPiNLKbAE+IaaqQT0ldrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTQZxaXdyONMff3TIN2IsCt6+A3f6KZcpB6oDicBj2HlaF2Yz5q8uMfWsIHMXVRHE4fOdbNL4P3s5YAiRG1izuT2iRNrftuoPSB75J9/nxqi2rn12pKV/qMXDgy87hrtrybV8GmPw4JoJVLnf5d/9kXUC+Sh5nHD650aSAcuLGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UsaE3Eit; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729869128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pKboAP4By7PRQHzx/JKVUBvBNHAppZRg9bKS5h/5DI=;
	b=UsaE3EitaXk2oGAbpTGlS3NH7PENHCon4ffUtNSw8L9qYj9fXlwi31kW+0LLrIizrr2Aj2
	1l7j8HPu6EqYCeFqTHIB6we/KyuoX4AwXIO+fJcwzl84aBBw5WO6k4ZVFKhKtRNtCHZYPE
	wwneuWl+8cn5iYtEQYs00Z/h3/lCKWI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-505-2i6VTHzzNouTjIokigDSJA-1; Fri,
 25 Oct 2024 11:12:04 -0400
X-MC-Unique: 2i6VTHzzNouTjIokigDSJA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B3F51955F3F;
	Fri, 25 Oct 2024 15:12:02 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.65.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CD01300018D;
	Fri, 25 Oct 2024 15:11:53 +0000 (UTC)
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
Subject: [PATCH v1 02/11] fs/proc/vmcore: replace vmcoredd_mutex by vmcore_mutex
Date: Fri, 25 Oct 2024 17:11:24 +0200
Message-ID: <20241025151134.1275575-3-david@redhat.com>
In-Reply-To: <20241025151134.1275575-1-david@redhat.com>
References: <20241025151134.1275575-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Let's use our new mutex instead.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 110ce193d20f..b91c304463c9 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -53,7 +53,6 @@ static struct proc_dir_entry *proc_vmcore;
 #ifdef CONFIG_PROC_VMCORE_DEVICE_DUMP
 /* Device Dump list and mutex to synchronize access to list */
 static LIST_HEAD(vmcoredd_list);
-static DEFINE_MUTEX(vmcoredd_mutex);
 
 static bool vmcoredd_disabled;
 core_param(novmcoredd, vmcoredd_disabled, bool, 0);
@@ -248,7 +247,7 @@ static int vmcoredd_copy_dumps(struct iov_iter *iter, u64 start, size_t size)
 	size_t tsz;
 	char *buf;
 
-	mutex_lock(&vmcoredd_mutex);
+	mutex_lock(&vmcore_mutex);
 	list_for_each_entry(dump, &vmcoredd_list, list) {
 		if (start < offset + dump->size) {
 			tsz = min(offset + (u64)dump->size - start, (u64)size);
@@ -269,7 +268,7 @@ static int vmcoredd_copy_dumps(struct iov_iter *iter, u64 start, size_t size)
 	}
 
 out_unlock:
-	mutex_unlock(&vmcoredd_mutex);
+	mutex_unlock(&vmcore_mutex);
 	return ret;
 }
 
@@ -283,7 +282,7 @@ static int vmcoredd_mmap_dumps(struct vm_area_struct *vma, unsigned long dst,
 	size_t tsz;
 	char *buf;
 
-	mutex_lock(&vmcoredd_mutex);
+	mutex_lock(&vmcore_mutex);
 	list_for_each_entry(dump, &vmcoredd_list, list) {
 		if (start < offset + dump->size) {
 			tsz = min(offset + (u64)dump->size - start, (u64)size);
@@ -306,7 +305,7 @@ static int vmcoredd_mmap_dumps(struct vm_area_struct *vma, unsigned long dst,
 	}
 
 out_unlock:
-	mutex_unlock(&vmcoredd_mutex);
+	mutex_unlock(&vmcore_mutex);
 	return ret;
 }
 #endif /* CONFIG_MMU */
@@ -1517,9 +1516,9 @@ int vmcore_add_device_dump(struct vmcoredd_data *data)
 	dump->size = data_size;
 
 	/* Add the dump to driver sysfs list */
-	mutex_lock(&vmcoredd_mutex);
+	mutex_lock(&vmcore_mutex);
 	list_add_tail(&dump->list, &vmcoredd_list);
-	mutex_unlock(&vmcoredd_mutex);
+	mutex_unlock(&vmcore_mutex);
 
 	vmcoredd_update_size(data_size);
 	return 0;
@@ -1537,7 +1536,7 @@ EXPORT_SYMBOL(vmcore_add_device_dump);
 static void vmcore_free_device_dumps(void)
 {
 #ifdef CONFIG_PROC_VMCORE_DEVICE_DUMP
-	mutex_lock(&vmcoredd_mutex);
+	mutex_lock(&vmcore_mutex);
 	while (!list_empty(&vmcoredd_list)) {
 		struct vmcoredd_node *dump;
 
@@ -1547,7 +1546,7 @@ static void vmcore_free_device_dumps(void)
 		vfree(dump->buf);
 		vfree(dump);
 	}
-	mutex_unlock(&vmcoredd_mutex);
+	mutex_unlock(&vmcore_mutex);
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
 }
 
-- 
2.46.1


