Return-Path: <kvm+bounces-63969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 226EBC76064
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 842E1356178
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DA4368E0B;
	Thu, 20 Nov 2025 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AGjoQtCj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E8E364047
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666035; cv=none; b=m8EQ94tSI4Wb4SkQKeog9dlYz3Lj8SHo9cDrj6aEN/fy8BDjnd92+rjyodf6AjM5n/Xg8YbKm8H6cgE8rNEqmGMa7C3RSA9AZ7+L2Lqv1dQ21k1Ikm4NQKCFXOyZxeuf7nUbUlx2zlfOmOEcy3G5xTmnmY+I/0JOrQ8wc8JHQ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666035; c=relaxed/simple;
	bh=9ijGG8m+FELYjaf3MyuBk7g4f5JfU9ssoo2gEJFpswI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+whrkoQU9dWfAD5tSEg0fSrXSxiR/xZ2gHSBpt9VdJ9e+s8OfLI8skVpx9PTMKcM806ySY1HTpdSDq4WvyvofbbG5vjGuJE6mZ0n44lKGDtHOZAxCHZcrUoDEWjDNf5CFja37fm6WDpWqjnEl3FVDUmofZ8H2rlHH0S0F1nJpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AGjoQtCj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sx8qN/rQg9K32+B1nXrTKMNVKMJAAYsg2jr2Y0IDjq8=;
	b=AGjoQtCjrDqkjEJU4eNe4MxZdOxTojCeaDQPPejx65n1oaX6TYySgmhVF88Mr9S2btXXok
	QzPDKK5Y6OmTyKPXymIB0dCro68HEcxVdSVGaQ0cEkIAr8iwtUJnaA12xcf1d05Oj4+Pr7
	+TsZ8psu3ctmrk1UGucXBV2FCyz62Qs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-399-AavvAK_sPLGzx3xXYBncyQ-1; Thu,
 20 Nov 2025 14:13:48 -0500
X-MC-Unique: AavvAK_sPLGzx3xXYBncyQ-1
X-Mimecast-MFC-AGG-ID: AavvAK_sPLGzx3xXYBncyQ_1763666024
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72F7B19541AF;
	Thu, 20 Nov 2025 19:13:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8119818004D8;
	Thu, 20 Nov 2025 19:13:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 5665A21E66F8; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com,
	pizhenwei@bytedance.com,
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
Subject: [PATCH 04/14] qga: Use error_setg_file_open() for better error messages
Date: Thu, 20 Nov 2025 20:13:29 +0100
Message-ID: <20251120191339.756429-5-armbru@redhat.com>
In-Reply-To: <20251120191339.756429-1-armbru@redhat.com>
References: <20251120191339.756429-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Error messages change from

    open("FNAME"): REASON

to

    Could not open 'FNAME': REASON

Signed-off-by: Markus Armbruster <armbru@redhat.com>
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


