Return-Path: <kvm+bounces-63978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 747BCC7608F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BF15B4E3E21
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BFD36E547;
	Thu, 20 Nov 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epT6d98V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E84369983
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666040; cv=none; b=VXlSGaAAHw6TgEWnCNz4UwzRm1xKwjVbzZM0ICxqDjD66SbHdtAOBqSATwi5mA6s5c/l9a5UqjoItS7pfvxEsuKXk2SKMkVzEABF7y6Yt2GMZRe6KpwjiUrGorTPlSfl9arIFzJHYnbcw8ZY7N8hRjR+l8H+pcuWanRRF3SYChE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666040; c=relaxed/simple;
	bh=ncnIpnq4p53jzYE1FTnhA8sPXcRd78/xTHxJgaXYjYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A62HM/2iLbPZ2T39Mfm1L49446NNJkAzPIfynTC8KIk15C6O3iDPTolGs8MCnBPcILx5ECTVxNYM/whB+LHb0AB62zmWpuEXj0S5B7Ky/qbdASr3gx0nCsX+2g/6FTcQy64olxlHTcm/Zzm3VZ2XNs5C1tnQ+7QcWx0vqaJjn3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=epT6d98V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+f/YPMyhiw0MODLrT/W+QVnkFDpo2Q2VNPNda433v0=;
	b=epT6d98VlrmCWnXJprpJ/aArsiaAKhaNh789m/ge+38H/a+r4Tpcak8ESaqxR0mwasruB1
	GE5Op6q3JJhLZgspFjDJaRV70nJmz1op8OnjvH7la1bpXR9/wQjeaOQSqfu39rVPR0LzSH
	nqZ5K7PYK0oVv/NkWhz+zBju9pV1ksU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-m10SDGhuPzaFE5VhiICI4w-1; Thu,
 20 Nov 2025 14:13:53 -0500
X-MC-Unique: m10SDGhuPzaFE5VhiICI4w-1
X-Mimecast-MFC-AGG-ID: m10SDGhuPzaFE5VhiICI4w_1763666027
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DEFC1800650;
	Thu, 20 Nov 2025 19:13:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB2471955F67;
	Thu, 20 Nov 2025 19:13:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6C27521E65DA; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 08/14] blkdebug: Use error_setg_file_open() for a better error message
Date: Thu, 20 Nov 2025 20:13:33 +0100
Message-ID: <20251120191339.756429-9-armbru@redhat.com>
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

    Could not read blkdebug config file: REASON

to

    Could not open 'FNAME': REASON

I think the exact file name is more useful to know than the file's
purpose.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 block/blkdebug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blkdebug.c b/block/blkdebug.c
index c54aee0c84..8a4a8cb85e 100644
--- a/block/blkdebug.c
+++ b/block/blkdebug.c
@@ -288,7 +288,7 @@ static int read_config(BDRVBlkdebugState *s, const char *filename,
     if (filename) {
         f = fopen(filename, "r");
         if (f == NULL) {
-            error_setg_errno(errp, errno, "Could not read blkdebug config file");
+            error_setg_file_open(errp, errno, filename);
             return -errno;
         }
 
-- 
2.49.0


