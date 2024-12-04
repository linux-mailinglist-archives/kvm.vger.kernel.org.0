Return-Path: <kvm+bounces-33024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC6A9E3B40
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE227B37F6F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E791C07F1;
	Wed,  4 Dec 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O6nHUCsJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64091F7077
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316910; cv=none; b=QjAppafRdi6tnF93X/KQbqyEbZOj9T/XXXlFUYXX3WfSQW89mJoQyxhmPmQyplG80nzmdsP1jevY4slGBV2E7yb+YQ0jr1l6mB0rV8G5NdgC1k33CepG3HeId9CTe0SgzZlv9Mz7KAfpzFJ9/j4cNnlkp3y0vfULBCp/nHApRTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316910; c=relaxed/simple;
	bh=GU+EylrtNkBl0PCgVUrji2d7nB4cQuMPE/K3NHw4YGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMAfUbaE3swduQoiz7um/zkgu0JmHYDNVGZdRg4bZcMr2kXz3TWYo8Wm8DZ7nglZMqYQk4FRctTRxuR6qREPBqbK/SnZk57X91BX1fJAvARecpbQNT2uEIwFpvJSuFQKUOcRYpw5voM0GkJ7J1sz0UzpCvrHHtYOkpub/CegNWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O6nHUCsJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TMBFu0zsYs/BK8mI3BuEemyVvVnFxsrbDwOUtwonV0=;
	b=O6nHUCsJ7VBy/f4+kT+4tfTdhK/ev61TkwjjZmbff2s2hSLFi7tSIAgK3HtznPqESiFD67
	3GPit59iFITU0dpq2t2encr920VrsREEynoNQas1dY6Twbx1LmfOX6U7FTd0C2wr16YROs
	ko1dwVeLZENjU3yZ0sIbtda2Qki/U44=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-T5LvoyFHP2-im7i1q7l_mw-1; Wed, 04 Dec 2024 07:55:06 -0500
X-MC-Unique: T5LvoyFHP2-im7i1q7l_mw-1
X-Mimecast-MFC-AGG-ID: T5LvoyFHP2-im7i1q7l_mw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385dcae001fso2825618f8f.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:55:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316906; x=1733921706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3TMBFu0zsYs/BK8mI3BuEemyVvVnFxsrbDwOUtwonV0=;
        b=qab0Bl7XAsSwY4LKrcS/BIscfbdH5Cf6tQ6YPLe46T7riIZB4//wEXDAEexOQFfjxb
         ddcLkr3vO5GiHO76OGQUFXdf4d4uJoINGMolgq6wJNLaC960lKvKD5l4qyLboZClXdj1
         vVmiC38sOvUn3E4K/s3Ko/36CXbHtirGVajjDu5P2kKNIK4N8kgLZDSJyh7tR/yM6eVw
         jOQpyKX6/bDtAjyBIf79e9XV6qPdvQ6+qr6GDgvUoRSJf6FzhSgn+eKIcHWkHHztJQMk
         yzUcHhaQEr2YCMtLzJRl6Kqwk6v9BlM1LCnCbCcXT2o9oM8arxOrBuLcds2YLw53/Gdv
         HHKA==
X-Forwarded-Encrypted: i=1; AJvYcCXWQ9ZaKE/OtaUGcl4lk7zIKkmKqYlJEEfnEiehqWXNJ6+I85OAX/vxMlT5zugtRkOKBhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOmNMsfCG5M0/AnNBeKQ3boXWMJE89H3vBXU5FvP3ynM7PbZtk
	hZD0cNusTWBAu7O+l1w4fRkV56U9Zd8OKg/oqggKVKUnoPt2DSeSazyEEDR1aSMrU36k7v/v85A
	tr7xNl6A/FbsccDOCtkHCXn1+AjetuT/b0eiTeGIQ3xY0GqPoQw==
X-Gm-Gg: ASbGncuQ0XQCYNRIZ/15zWmWIOG/t/kRjzpxwLYes2D1t9pq/0wT8Uw+CSN/zoiPvo7
	Q3z86o2hpb30tJ/Kk0mE1ajyD5GSY9VNZG8+Jh6qRttq7RA6qVsp/VX4Q8QxBRZNX2MgoAVsciW
	E7PUsoOa0OXo6GfDuvRsEwy1LAYhUf1fPZOdJGNMTuCQbZIpohLPJKYp6wb26xRG7of60p4Qp3u
	AZBqy9glpPnAef5DG9bnixW+6c5y8448cxRr1VXGc1eb9LpGoPmXQIm6AUYeEg0N7XDD183qLiz
	Bk4de47S3y0lzuQ3xAoWtRgLlGtBB37IzG4=
X-Received: by 2002:a05:6000:156e:b0:385:fa2e:a33e with SMTP id ffacd0b85a97d-38607c0e1e7mr3561597f8f.43.1733316905753;
        Wed, 04 Dec 2024 04:55:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3Vs5XvVpD9wVjl4Do+O4dwdUFKsmLeUCgsK0LBk5udBDNdRPox9DV3gXL42llKQONJirIJg==
X-Received: by 2002:a05:6000:156e:b0:385:fa2e:a33e with SMTP id ffacd0b85a97d-38607c0e1e7mr3561572f8f.43.1733316905408;
        Wed, 04 Dec 2024 04:55:05 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ed8dee66sm10241947f8f.104.2024.12.04.04.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:55:04 -0800 (PST)
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
Subject: [PATCH v2 06/12] fs/proc/vmcore: factor out allocating a vmcore range and adding it to a list
Date: Wed,  4 Dec 2024 13:54:37 +0100
Message-ID: <20241204125444.1734652-7-david@redhat.com>
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

Let's factor it out into include/linux/crash_dump.h, from where we can
use it also outside of vmcore.c later.

Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c           | 21 ++-------------------
 include/linux/crash_dump.h | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 8d262017ca11..9b72e255dd03 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -709,11 +709,6 @@ static const struct proc_ops vmcore_proc_ops = {
 	.proc_mmap	= mmap_vmcore,
 };
 
-static struct vmcore_range * __init get_new_element(void)
-{
-	return kzalloc(sizeof(struct vmcore_range), GFP_KERNEL);
-}
-
 static u64 get_vmcore_size(size_t elfsz, size_t elfnotesegsz,
 			   struct list_head *vc_list)
 {
@@ -1116,7 +1111,6 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 						size_t elfnotes_sz,
 						struct list_head *vc_list)
 {
-	struct vmcore_range *new;
 	int i;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr *phdr_ptr;
@@ -1139,13 +1133,8 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
 		size = end - start;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
+		if (vmcore_alloc_add_range(vc_list, start, size))
 			return -ENOMEM;
-		new->paddr = start;
-		new->size = size;
-		list_add_tail(&new->list, vc_list);
 
 		/* Update the program header offset. */
 		phdr_ptr->p_offset = vmcore_off + (paddr - start);
@@ -1159,7 +1148,6 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 						size_t elfnotes_sz,
 						struct list_head *vc_list)
 {
-	struct vmcore_range *new;
 	int i;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr *phdr_ptr;
@@ -1182,13 +1170,8 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
 		size = end - start;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
+		if (vmcore_alloc_add_range(vc_list, start, size))
 			return -ENOMEM;
-		new->paddr = start;
-		new->size = size;
-		list_add_tail(&new->list, vc_list);
 
 		/* Update the program header offset */
 		phdr_ptr->p_offset = vmcore_off + (paddr - start);
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 788a45061f35..9717912ce4d1 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -121,6 +121,20 @@ struct vmcore_range {
 	loff_t offset;
 };
 
+/* Allocate a vmcore range and add it to the list. */
+static inline int vmcore_alloc_add_range(struct list_head *list,
+		unsigned long long paddr, unsigned long long size)
+{
+	struct vmcore_range *m = kzalloc(sizeof(*m), GFP_KERNEL);
+
+	if (!m)
+		return -ENOMEM;
+	m->paddr = paddr;
+	m->size = size;
+	list_add_tail(&m->list, list);
+	return 0;
+}
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline bool is_kdump_kernel(void) { return false; }
 #endif /* CONFIG_CRASH_DUMP */
-- 
2.47.1


