Return-Path: <kvm+bounces-64114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF90C79009
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3B65F4EBA61
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CA134CFAB;
	Fri, 21 Nov 2025 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJJMHGu+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A5D2D739D
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727294; cv=none; b=cg6KLWbiqzwCb5bhkrIOIyp+FWHJg7s+rx8iTFmb/c44UcgHpSu++ktnJ/GmK/qViaqJtl+8Tma9YJG+P6cSW4HXOdi6Gll4QVZnIz2zKyfLskjHBzMrq5svHO/C/DxquOTlHmiSKile0b55i1ToqjM2qm5cLsF1rXj4fXN3Xk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727294; c=relaxed/simple;
	bh=D8RKFJLgRm9LtxLDL3Jz9k2QEi5WiPUsyaTLsnFWgCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlXqaLhs7ZCeIim+9UNZctNi+PV9ouz7Dv/CE9IENvSViiD3tdPEU+YkeaA9H7P1moLzHme876YTx/LNINbmpqCa6G9t8KdBwMa55YEfwfIWUk4SOx4cRoLPifQH86/xFtN1YtDn8nKA5rT0H9vVFNQ5KBDnegqigBzV+Ectvwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJJMHGu+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LvfjndzC9yIe2vReLTAtPHT920hAL1fUKXGYa8VIiFA=;
	b=BJJMHGu+w5E4AN7NpeSWwrF3qWHCBJvlkDXH3QtGT90VDyZt9VyhAH4euZzldULzIlyVuv
	tlYGc+KwV06walXr7khFsWIzWQRVM//hLDi+uQsasZA4/PfHRx/e4NIpsB7asDWxNHmFI2
	O5bWi/Q+3HXsyMXhXfxfEv8qYCfmpxk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-J3mo8o2FOba0ZJnznZes4g-1; Fri,
 21 Nov 2025 07:14:47 -0500
X-MC-Unique: J3mo8o2FOba0ZJnznZes4g-1
X-Mimecast-MFC-AGG-ID: J3mo8o2FOba0ZJnznZes4g_1763727284
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FF25180034A;
	Fri, 21 Nov 2025 12:14:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05D4030044DC;
	Fri, 21 Nov 2025 12:14:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9569B21E66F8; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
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
Subject: [PATCH v2 04/15] tap-solaris: Use error_setg_file_open() for better error messages
Date: Fri, 21 Nov 2025 13:14:27 +0100
Message-ID: <20251121121438.1249498-5-armbru@redhat.com>
In-Reply-To: <20251121121438.1249498-1-armbru@redhat.com>
References: <20251121121438.1249498-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Error messages change from

    Can't open /dev/ip (actually /dev/udp)
    Can't open /dev/tap
    Can't open /dev/tap (2)

to

    Could not open '/dev/udp': REASON
    Could not open '/dev/tap': REASON

where REASON is the value of strerror(errno).

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
---
 net/tap-solaris.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tap-solaris.c b/net/tap-solaris.c
index 75397e6c54..faf7922ea8 100644
--- a/net/tap-solaris.c
+++ b/net/tap-solaris.c
@@ -87,13 +87,13 @@ static int tap_alloc(char *dev, size_t dev_size, Error **errp)
 
     ip_fd = RETRY_ON_EINTR(open("/dev/udp", O_RDWR, 0));
     if (ip_fd < 0) {
-        error_setg(errp, "Can't open /dev/ip (actually /dev/udp)");
+        error_setg_file_open(errp, errno, "/dev/udp");
         return -1;
     }
 
     tap_fd = RETRY_ON_EINTR(open("/dev/tap", O_RDWR, 0));
     if (tap_fd < 0) {
-        error_setg(errp, "Can't open /dev/tap");
+        error_setg_file_open(errp, errno, "/dev/tap");
         return -1;
     }
 
@@ -107,7 +107,7 @@ static int tap_alloc(char *dev, size_t dev_size, Error **errp)
 
     if_fd = RETRY_ON_EINTR(open("/dev/tap", O_RDWR, 0));
     if (if_fd < 0) {
-        error_setg(errp, "Can't open /dev/tap (2)");
+        error_setg_file_open(errp, errno, "/dev/tap");
         return -1;
     }
     if(ioctl(if_fd, I_PUSH, "ip") < 0){
-- 
2.49.0


