Return-Path: <kvm+bounces-64113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF5DC79006
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 91874361FEB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7735F34C9AB;
	Fri, 21 Nov 2025 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MC+oXQIu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3B3334C2A
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727294; cv=none; b=i8UM1IWgvknK01LnmpjIDLVdSZzFmpWD+tcoHtQQdjEROUfG1OcSqND9gos8DL/O8vxxJt7eGan/HQUAX5uIsMH4J4bFzl2jo4M1w8lAD+Rdoj9+7bVVxWyQM8ovGsCWwKsl8eB1EOgDibNpCpbpzPjieyrs0mNvAkT4uCCELc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727294; c=relaxed/simple;
	bh=l15bQKcGnIad+7Uo7xetK0Kko5tXY2PCiJoyy5Bi6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXo3rctc4aDFISXUyOpkucj6Ql5qbfvWwsilSbQohkdaFshBAXUqFHZThmiBE8Zs6t0qPzmUJoTqTBDSOU5dXH7IaHE1TvtZrz5/TaAACKU0dO/WOjIzUuW0gEup+D+ieEj84XsooJkEGvraCRMBh7YXkmw/Optu5sJ9BYsX/WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MC+oXQIu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tDP8FM9QFpX4om5r6DeJVNNuFVvQYDlKs2mHtRlqAfQ=;
	b=MC+oXQIu5l5AHwlQMDd+p0HBGlPsrIiTcNr6iI0Wn1bEOf/+OCK+uLcu4y1/3wPyNIRArf
	YVYI4VLpALik01WoSDbfAjVcc8TIgjSZza+4lQCMaV66uTS35YyFk5cNas/y2a39OQyYE3
	jae140S1bA/b3Oi+a2pQqVnNCXoz0ME=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-5hh7LVJnPmWjjIuQzCm6LQ-1; Fri,
 21 Nov 2025 07:14:50 -0500
X-MC-Unique: 5hh7LVJnPmWjjIuQzCm6LQ-1
X-Mimecast-MFC-AGG-ID: 5hh7LVJnPmWjjIuQzCm6LQ_1763727286
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 439A7195605B;
	Fri, 21 Nov 2025 12:14:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C40981940E82;
	Fri, 21 Nov 2025 12:14:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D147221EC346; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com,
	zhenwei.pi@linux.dev,
	alistair.francis@wdc.com,
	stefanb@linux.vnet.ibm.com,
	kwolf@redhat.com,
	hreitz@redhat.com,
	sw@weilnetz.de,
	qemu_oss@crudebyte.com,
	groug@kaod.org,
	mst@redhat.com,
	imammedo@redhat.com,
	anisinha@redhat.com,
	kraxel@redhat.com,
	shentey@gmail.com,
	npiggin@gmail.com,
	harshpb@linux.ibm.com,
	sstabellini@kernel.org,
	anthony@xenproject.org,
	paul@xen.org,
	edgar.iglesias@gmail.com,
	elena.ufimtseva@oracle.com,
	jag.raman@oracle.com,
	sgarzare@redhat.com,
	pbonzini@redhat.com,
	fam@euphon.net,
	philmd@linaro.org,
	alex@shazbot.org,
	clg@redhat.com,
	peterx@redhat.com,
	farosas@suse.de,
	lizhijian@fujitsu.com,
	dave@treblig.org,
	jasowang@redhat.com,
	samuel.thibault@ens-lyon.org,
	michael.roth@amd.com,
	kkostiuk@redhat.com,
	zhao1.liu@intel.com,
	mtosatti@redhat.com,
	rathc@linux.ibm.com,
	palmer@dabbelt.com,
	liwei1518@gmail.com,
	dbarboza@ventanamicro.com,
	zhiwei_liu@linux.alibaba.com,
	marcandre.lureau@redhat.com,
	qemu-block@nongnu.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org
Subject: [PATCH v2 14/15] qga/commands-win32: Use error_setg_win32() for better error messages
Date: Fri, 21 Nov 2025 13:14:37 +0100
Message-ID: <20251121121438.1249498-15-armbru@redhat.com>
In-Reply-To: <20251121121438.1249498-1-armbru@redhat.com>
References: <20251121121438.1249498-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

We include numeric GetLastError() codes in error messages in a few
places, like this:

    error_setg(errp, "GRIPE: %d", (int)GetLastError());

Show text instead, like this:

    error_setg_win32(errp, GetLastError(), "GRIPE");

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qga/commands-win32.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/qga/commands-win32.c b/qga/commands-win32.c
index acc2c11589..0fd0c966e4 100644
--- a/qga/commands-win32.c
+++ b/qga/commands-win32.c
@@ -1798,8 +1798,8 @@ void qmp_guest_set_time(bool has_time, int64_t time_ns, Error **errp)
     tf.dwHighDateTime = (DWORD) (time >> 32);
 
     if (!FileTimeToSystemTime(&tf, &ts)) {
-        error_setg(errp, "Failed to convert system time %d",
-                   (int)GetLastError());
+        error_setg_win32(errp, GetLastError(),
+                         "Failed to convert system time");
         return;
     }
 
@@ -1810,7 +1810,8 @@ void qmp_guest_set_time(bool has_time, int64_t time_ns, Error **errp)
     }
 
     if (!SetSystemTime(&ts)) {
-        error_setg(errp, "Failed to set time to guest: %d", (int)GetLastError());
+        error_setg_win32(errp, GetLastError(),
+                         "Failed to set time to guest");
         return;
     }
 }
@@ -1834,13 +1835,12 @@ GuestLogicalProcessorList *qmp_guest_get_vcpus(Error **errp)
         (length > sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION))) {
         ptr = pslpi = g_malloc0(length);
         if (GetLogicalProcessorInformation(pslpi, &length) == FALSE) {
-            error_setg(&local_err, "Failed to get processor information: %d",
-                       (int)GetLastError());
+            error_setg_win32(&local_err, GetLastError(),
+                             "Failed to get processor information");
         }
     } else {
-        error_setg(&local_err,
-                   "Failed to get processor information buffer length: %d",
-                   (int)GetLastError());
+        error_setg_win32(&local_err, GetLastError(),
+                         "Failed to get processor information buffer length");
     }
 
     while ((local_err == NULL) && (length > 0)) {
-- 
2.49.0


