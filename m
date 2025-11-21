Return-Path: <kvm+bounces-64119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 76320C79015
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 006FC4EDE3D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2473C34D917;
	Fri, 21 Nov 2025 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FH5wVs9I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6184E2FF17D
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727297; cv=none; b=knVlq/BaViYLBExwdk376UtXN0XnM0vj1MAHARlbTZJpV1j3CRIPe8xORGeaKEnWFJkjqoQUcis5pG2h1RFgq7xVx0FAACPeM9Nhyjo1CE/8AkwF8sulcMcZeDisyUtF1BewQCl6ZvRxzhYbydQOOarjUJ1dqIcDSzyY1y0aqp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727297; c=relaxed/simple;
	bh=XFGGU1BUQFQrtMap0f5F9BzV6GSKkP67Mnm9FDqdYOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlDLBfhsZvwWpSJaNIzgCoK1Oe98tDKDJj4R82+GyvdCFBvhzBeDl1JO5DW7RwnACC1DHjPwNhsUSzyI78eErLmhCH+xNrcYM3lYA4KPVIKipZYW26yEC1ansFzdBWbhOVSqDlhss6jXB7MzebR1SWNc+2PfrVqTUpXB5yMt6ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FH5wVs9I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jq+qsu9NDrfjYMe8jH6z7ShPmZi4eWzdQ6ZA1QbTE4A=;
	b=FH5wVs9IKIKVm0+sta350bxaULryvppnGNMqFMH0BCnEBgSklpuqB3MXk779f+YJ/Eerrm
	tBcHyW/7wHirywgyJFqN7DwPGXULYe6jYKxaFYEbcuSL5g/3aS10Zs4N1WvwxqF1BJe8tH
	yLR+psCf5c3P1ZV4y1DCrJNg5IJQIC4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-xMZFCiGKODWbluovOjm9cg-1; Fri,
 21 Nov 2025 07:14:50 -0500
X-MC-Unique: xMZFCiGKODWbluovOjm9cg-1
X-Mimecast-MFC-AGG-ID: xMZFCiGKODWbluovOjm9cg_1763727286
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6738E1956080;
	Fri, 21 Nov 2025 12:14:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 976641940E8F;
	Fri, 21 Nov 2025 12:14:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9B3D421E668C; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
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
Subject: [PATCH v2 05/15] qga: Use error_setg_file_open() for better error messages
Date: Fri, 21 Nov 2025 13:14:28 +0100
Message-ID: <20251121121438.1249498-6-armbru@redhat.com>
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

Error messages change from

    open("FNAME"): REASON

to

    Could not open 'FNAME': REASON

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
Reviewed-by: Kostiantyn Kostiuk <kkostiuk@redhat.com>
---
 qga/commands-linux.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/qga/commands-linux.c b/qga/commands-linux.c
index 4a09ddc760..5cf76ca2d9 100644
--- a/qga/commands-linux.c
+++ b/qga/commands-linux.c
@@ -1502,14 +1502,15 @@ static void transfer_vcpu(GuestLogicalProcessor *vcpu, bool sys2vcpu,
 
     dirfd = open(dirpath, O_RDONLY | O_DIRECTORY);
     if (dirfd == -1) {
-        error_setg_errno(errp, errno, "open(\"%s\")", dirpath);
+        error_setg_file_open(errp, errno, dirpath);
         return;
     }
 
     fd = openat(dirfd, fn, sys2vcpu ? O_RDONLY : O_RDWR);
     if (fd == -1) {
         if (errno != ENOENT) {
-            error_setg_errno(errp, errno, "open(\"%s/%s\")", dirpath, fn);
+            error_setg_errno(errp, errno, "could not open %s/%s",
+                             dirpath, fn);
         } else if (sys2vcpu) {
             vcpu->online = true;
             vcpu->can_offline = false;
@@ -1711,7 +1712,7 @@ static void transfer_memory_block(GuestMemoryBlock *mem_blk, bool sys2memblk,
     dirfd = open(dirpath, O_RDONLY | O_DIRECTORY);
     if (dirfd == -1) {
         if (sys2memblk) {
-            error_setg_errno(errp, errno, "open(\"%s\")", dirpath);
+            error_setg_file_open(errp, errno, dirpath);
         } else {
             if (errno == ENOENT) {
                 result->response = GUEST_MEMORY_BLOCK_RESPONSE_TYPE_NOT_FOUND;
@@ -1936,7 +1937,7 @@ static GuestDiskStatsInfoList *guest_get_diskstats(Error **errp)
 
     fp = fopen(diskstats, "r");
     if (fp  == NULL) {
-        error_setg_errno(errp, errno, "open(\"%s\")", diskstats);
+        error_setg_file_open(errp, errno, diskstats);
         return NULL;
     }
 
@@ -2047,7 +2048,7 @@ GuestCpuStatsList *qmp_guest_get_cpustats(Error **errp)
 
     fp = fopen(cpustats, "r");
     if (fp  == NULL) {
-        error_setg_errno(errp, errno, "open(\"%s\")", cpustats);
+        error_setg_file_open(errp, errno, cpustats);
         return NULL;
     }
 
-- 
2.49.0


