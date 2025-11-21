Return-Path: <kvm+bounces-64112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E9AC78FF8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 85AA34EB548
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A841034C806;
	Fri, 21 Nov 2025 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bOlYG1dX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461CB2FF17D
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727293; cv=none; b=ipKkELyBpxqXZnFsKQz4qT3Qa83lxom0U7XglErxYuzMstjcSaH9o++iqyvbdBFS0Gs/NTg2llblcMbvFP44GHcFOIqG1mwxDyYUhzgvCDujC6iGREcO4T5fku7xcn9Nyu9gAFsqPECifiVlMhLkMeFHCSyw0dG8+uAIVskT12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727293; c=relaxed/simple;
	bh=1YAGZ497UGApBegwfLn0Pu265V2V2CyN+D397GAYOSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlByCN5xGT+XyeANza31sPvMfpTs8YUsuQtVQtu8Aq3Hiah1xG3vApvHVHSip3sInh5qQ3S+EW/x9gKWogyZzfMi8Ri2kZ1H/tZBcBYr/EqpYTkOZJk+Nd8Up1CmyLaNG/8H5d3Vx9nwhykH7KjsUhhAROMzZfFYzkcsocpE5/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bOlYG1dX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntoFJE6ZYqJ4DvoW2xAiFU9EOotBPF/P3xBSz1dTmbg=;
	b=bOlYG1dXNZsSCeE6JNxyx3UPQSobJnD9LKSlFNeuKnGjUnRcNdmlnzvLhTVqDnH21+tMXb
	fcjmzsuUhetXFNBSvulc7bQdArSHrydqK4DKmv6xwCzgqk66puAnUNFbflaovsQbsohvjR
	7j63LBwekxjSa7Q1Yma8fcb73K5/Yk0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-_S2sFyzUNkyrsijPiS4IYQ-1; Fri,
 21 Nov 2025 07:14:48 -0500
X-MC-Unique: _S2sFyzUNkyrsijPiS4IYQ-1
X-Mimecast-MFC-AGG-ID: _S2sFyzUNkyrsijPiS4IYQ_1763727283
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29D471954B11;
	Fri, 21 Nov 2025 12:14:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 010191940E88;
	Fri, 21 Nov 2025 12:14:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 89C0021E6741; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
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
Subject: [PATCH v2 02/15] hw/usb: Convert to qemu_create() for a better error message
Date: Fri, 21 Nov 2025 13:14:25 +0100
Message-ID: <20251121121438.1249498-3-armbru@redhat.com>
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

The error message changes from

    open FILENAME failed

to

    Could not create 'FILENAME': REASON

where REASON is the value of strerror(errno).

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/usb/bus.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/hw/usb/bus.c b/hw/usb/bus.c
index 8dd2ce415e..714e33989f 100644
--- a/hw/usb/bus.c
+++ b/hw/usb/bus.c
@@ -259,10 +259,9 @@ static void usb_qdev_realize(DeviceState *qdev, Error **errp)
     }
 
     if (dev->pcap_filename) {
-        int fd = qemu_open_old(dev->pcap_filename,
-                               O_CREAT | O_WRONLY | O_TRUNC | O_BINARY, 0666);
+        int fd = qemu_create(dev->pcap_filename,
+                             O_WRONLY | O_TRUNC | O_BINARY, 0666, errp);
         if (fd < 0) {
-            error_setg(errp, "open %s failed", dev->pcap_filename);
             usb_qdev_unrealize(qdev);
             return;
         }
-- 
2.49.0


