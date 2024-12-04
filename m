Return-Path: <kvm+bounces-33020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4C89E3A7B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 733AE281A5B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20371D63EC;
	Wed,  4 Dec 2024 12:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ry8Lvbc/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFD31B87F8
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316898; cv=none; b=nFg6+3WWUNpyNJwLUzr9NuWIXefqcnqQ7BT97fe6e8XzupXTvsFdjibzRhDytW6NJi393hwnDwPpsLWvcOAKBgMDclLUI8KTEQsK22vwuiyQqb4XXsXHPJ/UxXGmdFs7aCGbNl8fl7TAL3EpnrNTV17FcMTI6sXiGIebnIvCETg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316898; c=relaxed/simple;
	bh=WdYleG7wq0/QsvZ4l+B0SUHHNWJZ0MpP6g4l1w+mx3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC9+jMKb+zWhJAqVpINFSHgV6H/XTRx9euxwMBucnxE8KP46DQHyNTGYnR/mN3VVCM3yZ0bPFJMce3X7hTNI3CliOSDoJYSws4/G1O5vb37HdESJfiUkrFBL+RrZgN+JwhB1EoFvOYu6oAkWQLYgIoM42VbYujMOruUPetPA63k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ry8Lvbc/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EkAK23ba+nOdc62V3txwBduSNZiyWl3c9gCUE/mLOOA=;
	b=Ry8Lvbc/4A4t3QfMJ38n0KwNzqGE8sqEgxZUzMqcUIR856SBB9KaNUTZk6dY8yD7Ksvt38
	uAPawgoAUof7gY/71uQ9uCUd2Tjp5K5K6+JsC2pBIh7FzS/oe65T+alQ6AtubrnglQ7DdE
	BIhpKIH0IQ9FhPgdGSJSaf7XxCyMVoY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-cibusNZ9PKql9Zd-9haFIg-1; Wed, 04 Dec 2024 07:54:55 -0500
X-MC-Unique: cibusNZ9PKql9Zd-9haFIg-1
X-Mimecast-MFC-AGG-ID: cibusNZ9PKql9Zd-9haFIg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385e0f3873cso2818187f8f.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316894; x=1733921694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EkAK23ba+nOdc62V3txwBduSNZiyWl3c9gCUE/mLOOA=;
        b=pNiw+lhgzcqQhgBpYHhfZm5ZAP7GXRQRXmyecTHEXeZhyCUkjLnPB74RYAwBpwbhxk
         Obh+fM6pNxuE5ibEbB3o2xqEpf8bF97dEBDF10BShYRMHxwoiyZTHNY+mj4WQFmIhCCi
         1e7Oq7WT5KrnLtMlljZ0WSAaNz8GukeM+//y9sTY67LTHnGhLitEJBNok10c+N0GQEne
         wflVS40oijFsuUD41fdUieeQqB9scRQY0gl8My7utX8xvEaZBXidG1Fy4WkwqpNTdrC1
         Hg49ldS6iCSt3ERJVTQ1wAQPsSWiCtbzKNAza2Z1mF7NUJk5RHbx4gYmov6G2gSqCh9K
         pK0g==
X-Forwarded-Encrypted: i=1; AJvYcCXH2Pco06Qm3ftTW4LDTzYrowfxW+x6O6nqUB7LKn1UBTSSJSTndSBCEqS0eUQTUEz6OiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdjTSXTSrbVTj7EpXi0WZw9M54PwLju9bhLlXvnEXr4bMBL5L/
	q//8qrCpJvMaXAhqw5632wZ3KK2fLJyZD5s9yNukehpO7m9YazhH89ATTqrfMx/YXGHHHUhXujk
	xXRH1tH/HTiIqjbt75bUeLALD5ypExEeWQHKB2C2fjbU2Kb0www==
X-Gm-Gg: ASbGncvvrt58aXgP/YKNTgfqVAo6bdeBTR2HUWzNvq0gBgCDIhE5uCTvYU4mDPl46Ku
	nAFZxbwqFskPl7AmufSRt8UMTG1FoT6jHW5JEHBxfJI7L+qsNorbeEcp1dn5tcgaofM6no8rWXo
	/NRfs3mVTzgBgRYxxC4ziP81L09PZN+/BYOQxBa2gk2HHX4NpRq2JZI3h96VG4F0wwmHrBrA901
	QtOgDqmxVDoin8JBItM3WLaPORo8kr9pcPB7MzvlVCaRh95fShkvT6bMLTFScKZEPKfE+jzUScY
	sMxv+9Wq776VuSdAw7NrrXWeQG8ydool16A=
X-Received: by 2002:a05:6000:1847:b0:385:ecdf:a30a with SMTP id ffacd0b85a97d-385fd3ee334mr5400381f8f.33.1733316893958;
        Wed, 04 Dec 2024 04:54:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvdtkWkEwxi8mpcTLDx5Tk+eqhyWjoc+BX5ypLCUE7CH8mOKCeowIphEqt4hXFtq1npl/2WQ==
X-Received: by 2002:a05:6000:1847:b0:385:ecdf:a30a with SMTP id ffacd0b85a97d-385fd3ee334mr5400356f8f.33.1733316893544;
        Wed, 04 Dec 2024 04:54:53 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434d52c12a4sm23880495e9.30.2024.12.04.04.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:54:52 -0800 (PST)
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
Subject: [PATCH v2 02/12] fs/proc/vmcore: replace vmcoredd_mutex by vmcore_mutex
Date: Wed,  4 Dec 2024 13:54:33 +0100
Message-ID: <20241204125444.1734652-3-david@redhat.com>
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

Now that we have a mutex that synchronizes against opening of the vmcore,
let's use that one to replace vmcoredd_mutex: there is no need to have
two separate ones.

This is a preparation for properly preventing vmcore modifications
after the vmcore was opened.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 586f84677d2f..e5a7e302f91f 100644
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
@@ -1518,9 +1517,9 @@ int vmcore_add_device_dump(struct vmcoredd_data *data)
 	dump->size = data_size;
 
 	/* Add the dump to driver sysfs list */
-	mutex_lock(&vmcoredd_mutex);
+	mutex_lock(&vmcore_mutex);
 	list_add_tail(&dump->list, &vmcoredd_list);
-	mutex_unlock(&vmcoredd_mutex);
+	mutex_unlock(&vmcore_mutex);
 
 	vmcoredd_update_size(data_size);
 	return 0;
@@ -1538,7 +1537,7 @@ EXPORT_SYMBOL(vmcore_add_device_dump);
 static void vmcore_free_device_dumps(void)
 {
 #ifdef CONFIG_PROC_VMCORE_DEVICE_DUMP
-	mutex_lock(&vmcoredd_mutex);
+	mutex_lock(&vmcore_mutex);
 	while (!list_empty(&vmcoredd_list)) {
 		struct vmcoredd_node *dump;
 
@@ -1548,7 +1547,7 @@ static void vmcore_free_device_dumps(void)
 		vfree(dump->buf);
 		vfree(dump);
 	}
-	mutex_unlock(&vmcoredd_mutex);
+	mutex_unlock(&vmcore_mutex);
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
 }
 
-- 
2.47.1


