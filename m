Return-Path: <kvm+bounces-63971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0538C76056
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id D524E28F06
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5984E368262;
	Thu, 20 Nov 2025 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5Epx5Kw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA100363C6F
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666036; cv=none; b=h/5jp8mCFlteom1u1nY7kJpzL8n/zIHqUAiPR2kaqTvGqwCQ19ZiHEAl/kzPthHU9hOaIS2GKdZdoftyF1nAoj8hnnUwbVxzO3MME0/bV5r8hebPa9Bt7BtT1kBOhZ2TmCj1TWE3dWbIBtejJRVtcqB4i1WBsoiYhU7lES7h8JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666036; c=relaxed/simple;
	bh=kzNgGF7MLjBDUm4uiRa3PKpI2Q0XLJmJQuuxP9HEkbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbGwoA6FUPskTO6z6+9Qn467Nmje3SrUJtvxle6MXpcZHjBjxrA0IM9OzteYOkG5v9Y4TPRsARep6uv6xTc2mYhj40DJ8SWaLGOysdIPCI70zYG3X7Wv0kkIQ8hjz5peeapz6479ypwpXtw5KuB6ye7DF8yDLU5MTnVP1F9IqG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5Epx5Kw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4lLXR0s+PhRAM8v+Y3wk6pvI0Xo8xxxorF5WwAF7BFI=;
	b=P5Epx5KwsPTVicfM1Amcg/HGKTVlq7/jTNYOCaPGj6XlaNnArP/ixXt/f3lbq+E/J3MVsw
	RD48X7Wzi1xn/o8b3cdtKbowNFxVzG8yyC1G67ARk4Y42KL1CsF25vc2StrkY5Ql3L6TEb
	qJ8oY6n9H/M0exWxx6PDJzIuBcEtRJE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-QWJXJjopMraUZ211FtOGkg-1; Thu,
 20 Nov 2025 14:13:48 -0500
X-MC-Unique: QWJXJjopMraUZ211FtOGkg-1
X-Mimecast-MFC-AGG-ID: QWJXJjopMraUZ211FtOGkg_1763666024
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D9F619560A2;
	Thu, 20 Nov 2025 19:13:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B20DA1940E82;
	Thu, 20 Nov 2025 19:13:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4AFF521E6741; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 02/14] hw/usb: Use error_setg_file_open() for a better error message
Date: Thu, 20 Nov 2025 20:13:27 +0100
Message-ID: <20251120191339.756429-3-armbru@redhat.com>
In-Reply-To: <20251120191339.756429-1-armbru@redhat.com>
References: <20251120191339.756429-1-armbru@redhat.com>
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

    Could not open 'FILENAME': REASON

where REASON is the value of strerror(errno).

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/usb/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/usb/bus.c b/hw/usb/bus.c
index 8dd2ce415e..47d42ca3c1 100644
--- a/hw/usb/bus.c
+++ b/hw/usb/bus.c
@@ -262,7 +262,7 @@ static void usb_qdev_realize(DeviceState *qdev, Error **errp)
         int fd = qemu_open_old(dev->pcap_filename,
                                O_CREAT | O_WRONLY | O_TRUNC | O_BINARY, 0666);
         if (fd < 0) {
-            error_setg(errp, "open %s failed", dev->pcap_filename);
+            error_setg_file_open(errp, errno, dev->pcap_filename);
             usb_qdev_unrealize(qdev);
             return;
         }
-- 
2.49.0


