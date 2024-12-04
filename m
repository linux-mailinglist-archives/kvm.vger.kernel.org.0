Return-Path: <kvm+bounces-33019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD7E9E3A7A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC5B165B6C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAB11CCEEC;
	Wed,  4 Dec 2024 12:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnayN7k+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D785B1C1F13
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316898; cv=none; b=JTFanQmADcS7GJv/p9OeWRdmg6A/uWS3PYIdYxnlyUjGTA7BRWujSjYCEyl0aeCII5IjkooQhSj7i3Y37wD85R/XTzx8LvVCORV1sJaCNSHxxFfUYarbY6u1WyaJxLYCHjMWmFHhN5kqAkSPe+eE4lwsatVzaYf25AvO+e6hloo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316898; c=relaxed/simple;
	bh=DemhL4cc1sp6Aqy2pgRkUydsYoG35xqCQwkgVd3ioow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/hb+QMrtRjQ+7pKAAO4Jxl80zy4W0wuChVgL3tUD8Xh2Esx9p+43IaKCRHbB2RrS2gpyNpyEx8YfH0p8uxcY0obkqK2E2nAmTqKSUqnkvL1EZz1rQWBHX/bD8noU2pYNrNp6XMMpR53nxjyVFjWgbVDkJWD7c9iOV3vN/W7nvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HnayN7k+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OXGsdvv3AOb25EXWN4EjEJfR5qBP9EzuVcsjQaH9awM=;
	b=HnayN7k+tcXIF6+UDCnAf8zqToNWA/JNoroCHliIBG/Q2tfzQerYfB5vuS0W+P8UuNWXGW
	XHaiV7+hXb0LgIOEOkP2oblpB0Usd+yFnoWFZG2uP3lx8CdQ36zui9vUaZdWpzfwsdavzW
	jgTKajr3jOm4NRp6EbkSDUvr4pU5gyc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-fg7IE8kLPqqAn4HxOa8wcA-1; Wed, 04 Dec 2024 07:54:52 -0500
X-MC-Unique: fg7IE8kLPqqAn4HxOa8wcA-1
X-Mimecast-MFC-AGG-ID: fg7IE8kLPqqAn4HxOa8wcA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-434a5ca6a67so48160055e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:54:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316891; x=1733921691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXGsdvv3AOb25EXWN4EjEJfR5qBP9EzuVcsjQaH9awM=;
        b=k98pOTaZiPEkuQuvNxiB3OumoU+2B8E7hXVCbOeBxvmR5pVNQj2cRoiVURNTCpoUP1
         lEklBbbZEv8KiAr6YO3mWOqXp+xFIFVQ09bJjxr6YIwpQBFUKNxRxiEqpeQB2AHc/zH2
         SJfx7ylkwCWkltc8AiiCLQJmUWyx7OdMSYJs2sF0g24PPCMRuWx13WucuR4Ch0KymvhQ
         vHjcJQyMhQWvNqkj5AwD7dhHGudpW2HSlexTeYyDAfDISi1POSyRf6YTSW5I2ym3hCzu
         KLw8ll3fLMrRpjLPI8uVOZ0cHngZxx7fmJ8S00XtczpxJ7ewb9uNZ8NE491y8cORF33g
         tHsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/xbvo0mh4pXElB2CBl0Kb24ukMrcoTBKIl5XW4eUZEL+WeICmdKkrpsWIZeKZNTVA7ws=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLaFNpIseWbpIUh6JuSdAD+mBtqxLfnkVwA3xpO6By/rayBiGN
	QXbPn80PcEKIRbUWPweV2Ex8q+AgLRWbgQ5i+gMnD0SsiMamXqnX9l6gJB/Q6wXI7NccpilAysX
	P1jAbLi8aKAfltZG8D/R/GyAJxeRyt1gt3MJQ2wwanSG4wzpBrA==
X-Gm-Gg: ASbGncs+b9Xesr8Atj5rDDJRchQznmWtl2pDmnSM/p0SYiqnxahEZzWzOe6S/j0YDCl
	X3yPkpSivsk40QKPQ386hDOGcoVBBzOilgD7SUpA5kvUgrUQdout47QFuiockuC5esA6UIdz4J4
	MbiSMEYU/fMmsRyeQncVpb3kqz1QerVP1mW7KFx1wUhWTeo57TQogZo8Djfe5piTgFcZWvBJYbX
	BVAux4Ub9hAEmsIp9QVAZ5Z9LXHa8XYX2FGFFrTWZJMwnIRNXfU9kRcaC5elFiBrZUHKtv7WpOR
	dj1WaXbzbvUIw87BcdWbP9Wk1sknDddeN/E=
X-Received: by 2002:a5d:6d08:0:b0:385:f280:d55 with SMTP id ffacd0b85a97d-385fd418db2mr5360083f8f.37.1733316890952;
        Wed, 04 Dec 2024 04:54:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGOcFoEjkEw+PoNC+LLaws3waLwovX9iW85k260HP1nxTmH4H7ZaUgV85wmWvqw6YlLZ08+Q==
X-Received: by 2002:a5d:6d08:0:b0:385:f280:d55 with SMTP id ffacd0b85a97d-385fd418db2mr5360063f8f.37.1733316890620;
        Wed, 04 Dec 2024 04:54:50 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ea9c5952sm11045422f8f.67.2024.12.04.04.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:54:49 -0800 (PST)
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
Subject: [PATCH v2 01/12] fs/proc/vmcore: convert vmcore_cb_lock into vmcore_mutex
Date: Wed,  4 Dec 2024 13:54:32 +0100
Message-ID: <20241204125444.1734652-2-david@redhat.com>
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

We want to protect vmcore modifications from concurrent opening of
the vmcore, and also serialize vmcore modification.

(a) We can currently modify the vmcore after it was opened. This can happen
    if a vmcoredd is added after the vmcore module was initialized and
    already opened by user space. We want to fix that and prepare for
    new code wanting to serialize against concurrent opening.

(b) To handle it cleanly we need to protect the modifications against
    concurrent opening. As the modifications end up allocating memory and
    can sleep, we cannot rely on the spinlock.

Let's convert the spinlock into a mutex to prepare for further changes.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/proc/vmcore.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index b4521b096058..586f84677d2f 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -62,7 +62,8 @@ core_param(novmcoredd, vmcoredd_disabled, bool, 0);
 /* Device Dump Size */
 static size_t vmcoredd_orig_sz;
 
-static DEFINE_SPINLOCK(vmcore_cb_lock);
+static DEFINE_MUTEX(vmcore_mutex);
+
 DEFINE_STATIC_SRCU(vmcore_cb_srcu);
 /* List of registered vmcore callbacks. */
 static LIST_HEAD(vmcore_cb_list);
@@ -72,7 +73,7 @@ static bool vmcore_opened;
 void register_vmcore_cb(struct vmcore_cb *cb)
 {
 	INIT_LIST_HEAD(&cb->next);
-	spin_lock(&vmcore_cb_lock);
+	mutex_lock(&vmcore_mutex);
 	list_add_tail(&cb->next, &vmcore_cb_list);
 	/*
 	 * Registering a vmcore callback after the vmcore was opened is
@@ -80,13 +81,13 @@ void register_vmcore_cb(struct vmcore_cb *cb)
 	 */
 	if (vmcore_opened)
 		pr_warn_once("Unexpected vmcore callback registration\n");
-	spin_unlock(&vmcore_cb_lock);
+	mutex_unlock(&vmcore_mutex);
 }
 EXPORT_SYMBOL_GPL(register_vmcore_cb);
 
 void unregister_vmcore_cb(struct vmcore_cb *cb)
 {
-	spin_lock(&vmcore_cb_lock);
+	mutex_lock(&vmcore_mutex);
 	list_del_rcu(&cb->next);
 	/*
 	 * Unregistering a vmcore callback after the vmcore was opened is
@@ -95,7 +96,7 @@ void unregister_vmcore_cb(struct vmcore_cb *cb)
 	 */
 	if (vmcore_opened)
 		pr_warn_once("Unexpected vmcore callback unregistration\n");
-	spin_unlock(&vmcore_cb_lock);
+	mutex_unlock(&vmcore_mutex);
 
 	synchronize_srcu(&vmcore_cb_srcu);
 }
@@ -120,9 +121,9 @@ static bool pfn_is_ram(unsigned long pfn)
 
 static int open_vmcore(struct inode *inode, struct file *file)
 {
-	spin_lock(&vmcore_cb_lock);
+	mutex_lock(&vmcore_mutex);
 	vmcore_opened = true;
-	spin_unlock(&vmcore_cb_lock);
+	mutex_unlock(&vmcore_mutex);
 
 	return 0;
 }
-- 
2.47.1


