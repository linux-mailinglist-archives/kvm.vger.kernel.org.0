Return-Path: <kvm+bounces-33025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B809E3A91
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13ADC2813AA
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9911FC7E7;
	Wed,  4 Dec 2024 12:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HW9TwMYZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1801F8ACE
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316914; cv=none; b=qdjYAcmTU2MwtfIani/fIkE3ezrkWtUFhTtxieutFtyX3VKFrzIOgL1I/XNPwS/PUiYLhjxCpGZmhomu8RMwozNpaq5g9xXswxTNN0AT9A6UlRSecNIKFYSc/8nuzJtA31C9lTT+TKPgP8Q2a4z5vYNjSpfbjAwvmfVnR/tDIvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316914; c=relaxed/simple;
	bh=8EJBn/hbfhsOHacsaBstPaeEQTFd5MZoCB7W0faV+24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJXqr9Pz7VTg7EfLZD1xWIom/jeERxqUPqyEJiz7WWIKnYbWVboWRDeJn4ULiP2H4evfqunu3lfpKcN+k6GccTzR6XJ6NBlBDghbG39Hkp+t54m85mqTxBL6G6d4j2xKBbjmWZF36E2yPULcj1jxIN29n768UWUXXtjHIlgkkkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HW9TwMYZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hPjJFLUCb0ZdSDAqGVI3uh+hCPNkczr7XmzIQmCEzE=;
	b=HW9TwMYZcntEQr7xS7j4/OtJZ/LxnuMjXcoifWK0hbxH3ifBovz2sKwBlhzTulR+yA0BAc
	nSd/tDtSw8MB2kOt2TcE0DKXl9jhTkMv2wojCjz1KBGy/Fls8+n44PORqicAKaDoKosuvE
	Gq2EmsKtWgsd+tuS01suX2Knx1B1IMo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-ORv5kIEqNfijGcDWRxadvg-1; Wed, 04 Dec 2024 07:55:10 -0500
X-MC-Unique: ORv5kIEqNfijGcDWRxadvg-1
X-Mimecast-MFC-AGG-ID: ORv5kIEqNfijGcDWRxadvg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4349fd2965fso62448975e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:55:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316909; x=1733921709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/hPjJFLUCb0ZdSDAqGVI3uh+hCPNkczr7XmzIQmCEzE=;
        b=auhncHdeI9JIwA0smR6jezpksFtig8MTJTzqLt8JyaZa4SN/OYxvPzrUREBd42xxMs
         bmQyrAnvVWaJ/86JKWKZLACsdnI3a0Ozba/7s7te2onCPExgIc4YSiGWBILxoC00FfEQ
         6FLVrKaW0x2C1uBN6f0xR5akmKG7eJvEfgnN8yVH6UNKwAuMQyXzfhY7CasWDJIlSJjh
         XfM3oj4v8LILqpWemU2pS83NWxgElqaoJHvPgIqdUbcAu88bmfCQsgR6Z3pAMhXoEyUI
         9cY0zDtgcPwJha5JZBr392HjFH1epqwyP5wVqU3H8ATFq+7i/3kddciAhwCNFT7zEr6s
         UUaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVcMAhjH0e6ptIC+hHXzCIIZALtD/NrW0B7YRYDZFIcix4GaC1V7O97fLHNDCKbljt/Kg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7zwA6hx4njk7NC7/N30UzsWz0mkN7mnH2sVEUw5v3fK8yHQa/
	7qjKJey11n+469gkPv9iu7dRvRK16dSLvIt73lMgsSioChPpcI9qEV8y5VqDsZSL1dvfFNJxFky
	TJ49WHCxQOGmaxkmchnELu2BVB3JQwXZJEd6Ypa6BNpXgYq44WA==
X-Gm-Gg: ASbGnctA+PPa1JzCCrazO7pp+AvQa/BvAg3oqc1NmY2Q/r1aQscMBfuHWJvazNSB2TU
	LjSXsO2DO0w/jQuSOryXi2ZvCEWEmvHl3oOC/krRHSq0E0UwG/tVNv4FDhuTRbS3HsmdrWbS/rp
	BxN9QikRqVW6za/5qLJqrs6fEEUKOe+qUKOkJcql1+P45KHkz9fZOxlwVrmE0m+pna0GOHh/TsM
	KzBvC4RxBBew+x3xdZSTpV7bbJo0A+aBd2f56hQAtF/Nd8+3SiwWgCJUo6bmosrZ/+V+XoqpQBL
	VSq/jbiKKc8ouuyGiicNkZXWNotIrfy8CXo=
X-Received: by 2002:a05:600c:1989:b0:431:6083:cd30 with SMTP id 5b1f17b1804b1-434d09b2a75mr60274855e9.6.1733316908759;
        Wed, 04 Dec 2024 04:55:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKlYOU/tZlshqWyJGjVsl03zkEzffSPE/+D71b9Tfd5+g4TqcfXtmwO5t6x/22DC/lF4E/bA==
X-Received: by 2002:a05:600c:1989:b0:431:6083:cd30 with SMTP id 5b1f17b1804b1-434d09b2a75mr60274425e9.6.1733316908112;
        Wed, 04 Dec 2024 04:55:08 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385db7f86dasm16267209f8f.66.2024.12.04.04.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:55:06 -0800 (PST)
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
Subject: [PATCH v2 07/12] fs/proc/vmcore: factor out freeing a list of vmcore ranges
Date: Wed,  4 Dec 2024 13:54:38 +0100
Message-ID: <20241204125444.1734652-8-david@redhat.com>
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
 fs/proc/vmcore.c           |  9 +--------
 include/linux/crash_dump.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 9b72e255dd03..e7b3cde44890 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1592,14 +1592,7 @@ void vmcore_cleanup(void)
 		proc_vmcore = NULL;
 	}
 
-	/* clear the vmcore list. */
-	while (!list_empty(&vmcore_list)) {
-		struct vmcore_range *m;
-
-		m = list_first_entry(&vmcore_list, struct vmcore_range, list);
-		list_del(&m->list);
-		kfree(m);
-	}
+	vmcore_free_ranges(&vmcore_list);
 	free_elfcorebuf();
 
 	/* clear vmcore device dump list */
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 9717912ce4d1..5d61c7454fd6 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -135,6 +135,17 @@ static inline int vmcore_alloc_add_range(struct list_head *list,
 	return 0;
 }
 
+/* Free a list of vmcore ranges. */
+static inline void vmcore_free_ranges(struct list_head *list)
+{
+	struct vmcore_range *m, *tmp;
+
+	list_for_each_entry_safe(m, tmp, list, list) {
+		list_del(&m->list);
+		kfree(m);
+	}
+}
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline bool is_kdump_kernel(void) { return false; }
 #endif /* CONFIG_CRASH_DUMP */
-- 
2.47.1


