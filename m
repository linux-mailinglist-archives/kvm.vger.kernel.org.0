Return-Path: <kvm+bounces-63974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E505FC76089
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A7CBF35D3A0
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940C3368E00;
	Thu, 20 Nov 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QofNWpS8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FE9368E1C
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666038; cv=none; b=PgwDraGL2WllXMdZXQ3Gt4UVlqRKUkSdgaaY51FHqSh0GgIdsgNkWxF2MhOZBeAChi9V3kYl24X8Z/a8OFrv/ddD3D3u0L08y55ESQ5i/y22m5UqQIp3QwqcsU06clHoTqKGhUHBwX6N6L2iI9i4U8q4G0VrdFtHm3XZJJ1FOAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666038; c=relaxed/simple;
	bh=7oAAq3P8kQ416abmaYIVobem1hCkFSKNFLYTdDWZjcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzcnPsd+uBeyseWIUQ8kdgRItKY4PjamBIbC1SQLRSWv/6HR0zQJhV3IHR8h63/VUEfvMgHjEL5tg4abU/1WKBn/y9/zwIoJP6Lh5NUGnKTP1afKUCtyoex/bk2n4uZ0OWwe0wi9pkqVGBwoB569qnQgVnUKZ+dGFGsn7bW/qQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QofNWpS8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qZGp8vuRR8VrNmTSQmIzBXvqSkRg69sI4h/KDVaUFuE=;
	b=QofNWpS8uLA29ixW7+s300bBUtOuQzkPmSnndpYo4NhkSuTk+wIFN55NLsat1DbDP11XQX
	SOSeP3VKzAFn+AUaLx90le50doz8B+j8n894I+ZP0JvhvPMLx/yLJETET0x+7Q+2XydQhA
	vVKKhLHoEladdGasz+4Fceq6UbXdMe4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-LvjNWB7rPgenSYGmtZdSaA-1; Thu,
 20 Nov 2025 14:13:52 -0500
X-MC-Unique: LvjNWB7rPgenSYGmtZdSaA-1
X-Mimecast-MFC-AGG-ID: LvjNWB7rPgenSYGmtZdSaA_1763666027
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5935195607A;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFDEB1956045;
	Thu, 20 Nov 2025 19:13:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 5BDDA21E66A9; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 05/14] hw/scsi: Use error_setg_file_open() for a better error message
Date: Thu, 20 Nov 2025 20:13:30 +0100
Message-ID: <20251120191339.756429-6-armbru@redhat.com>
In-Reply-To: <20251120191339.756429-1-armbru@redhat.com>
References: <20251120191339.756429-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The error message changes from

    vhost-scsi: open vhost char device failed: REASON

to

    Could not open '/dev/vhost-scsi': REASON

I think the exact file name is more useful to know than the file's
purpose.

We could put back the "vhost-scsi: " prefix with error_prepend().  Not
worth the bother.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/scsi/vhost-scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index cdf405b0f8..239138c931 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -245,8 +245,7 @@ static void vhost_scsi_realize(DeviceState *dev, Error **errp)
     } else {
         vhostfd = open("/dev/vhost-scsi", O_RDWR);
         if (vhostfd < 0) {
-            error_setg(errp, "vhost-scsi: open vhost char device failed: %s",
-                       strerror(errno));
+            error_setg_file_open(errp, errno, "/dev/vhost-scsi");
             return;
         }
     }
-- 
2.49.0


