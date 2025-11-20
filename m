Return-Path: <kvm+bounces-63976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BAFC76083
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8141B4E2135
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D56836C59B;
	Thu, 20 Nov 2025 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQtw2aKc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C68369202
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666039; cv=none; b=EKgaeoAyLrQVpsQPQL/Btl6FStajCE5eRJmHym3QQy6qtgP3P+ldU8sFzCFnwH7vZk2mqpIj5ayuyWGgUwZn3KXOj27+H1PH3kcqT61dL2KgQB8p0jpR0ht9UpMXzg5dgG0c9xxipXgpKpNcLE90/BHbkiFJvCRBTF3IXK3MhRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666039; c=relaxed/simple;
	bh=WWert2UmtSLR+3S7igH5gRbvlm9O/q3RojWG5DGSyXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmBSh0Ylfl8sI9BrDwE+h90NvKh2tTU0nMtVydXkdTGgHJFA580Fv/MZEtsI7uZzyxObjA+PFzrdIe+PKVFuuUyc3NBxkKtd4kG3lVGX9egHCnYi0lfIpk82hUKQLtj47w8656mIgUmGvAoybKZIVMkCXNJ9e2wVj2Dn8rv0p4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQtw2aKc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xtGdog7VgzIfQmeSQKWrv+vlf3j6c1d+FLveMONGz8=;
	b=DQtw2aKcLFDkRm2rs4YU3c7j+6jnEpz0Fn6pQl+kbweTTF1211mDV2thiZchzeh2+B2Vs7
	O3UCkYOSgP4dOGv07nY4KqdVOqRmtqkPRpsvwfjOLfHMcuMCCOcOZzuHssLC28UN/TO4gJ
	GYKAeAcE5rdiaLyP0sg+o2v4mJVwhuY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-gSO2B6tkNASi5AxKkflOCA-1; Thu,
 20 Nov 2025 14:13:52 -0500
X-MC-Unique: gSO2B6tkNASi5AxKkflOCA-1
X-Mimecast-MFC-AGG-ID: gSO2B6tkNASi5AxKkflOCA_1763666027
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB4CF1955F28;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09C651955F66;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 612BE21E66B9; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 06/14] hw/virtio: Use error_setg_file_open() for a better error message
Date: Thu, 20 Nov 2025 20:13:31 +0100
Message-ID: <20251120191339.756429-7-armbru@redhat.com>
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

    vhost-vsock: failed to open vhost device: REASON

to

    Could not open '/dev/vhost-vsock': REASON

I think the exact file name is more useful to know than the file's
purpose.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/virtio/vhost-vsock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 107d88babe..7940b60d8a 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -153,8 +153,7 @@ static void vhost_vsock_device_realize(DeviceState *dev, Error **errp)
     } else {
         vhostfd = open("/dev/vhost-vsock", O_RDWR);
         if (vhostfd < 0) {
-            error_setg_errno(errp, errno,
-                             "vhost-vsock: failed to open vhost device");
+            error_setg_file_open(errp, errno, "/dev/vhost-vsock");
             return;
         }
 
-- 
2.49.0


