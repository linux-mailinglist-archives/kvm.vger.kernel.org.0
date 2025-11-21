Return-Path: <kvm+bounces-64124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8532CC7901B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1BED73661F4
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604AE34DB7E;
	Fri, 21 Nov 2025 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDFYrp2h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0F34D386
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727298; cv=none; b=inH9V5Ol4gM4kI7b9Zd13Yxe6voRBSrAg0FtoGvY6HmAJ2BD2YLbjWFO2RieimwSL6flXbIWd0hJPraJ+Fp8v9jLZPJV0eXO1IShav7uc5XVGBTot5zt/szJYHDxLc9u4MDGxhUSLpTlph3gHNYjOGz0IcREkdbaaslnMFdAHDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727298; c=relaxed/simple;
	bh=n5ieai0oOuZYyNZCJeslW+M/vh4VieMur+A1oVEebmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrhqedRl2vhSntTjLFt9wJaq/GTiqCCrEItiU8vm8tOZMGDCW+0ZSh6KYyrRf3TmorJMgx98wmNBkw0c7lv+K2t4qkAiULarEGNm+dDjoidu5Q8gHHUEZSqp6DSH+afAot57m9dl1G03buryB8attyoFcqzbg8z7LUD7+OEAuOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDFYrp2h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oeDPJTEK/mbRoQ9G1reQyHyjo6pRRwMOwFAV76+b8w0=;
	b=gDFYrp2hetNotCnwDrusBW9leknAAoD8QxGBwGTuvw4fBQ6TcEDfdmdnXA42738eFJiDCE
	VV/k9BEFGVnIa9QSed0nbzhB/vU8kBeFP0liye+4Jk1izJIW/APbufxMCRMDchxgUo+cmm
	BrnlEIEViVa1r0HnDZHDsLwTFzsmXSs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-9KVhRz1PNjG4B1qvQhE2_Q-1; Fri,
 21 Nov 2025 07:14:53 -0500
X-MC-Unique: 9KVhRz1PNjG4B1qvQhE2_Q-1
X-Mimecast-MFC-AGG-ID: 9KVhRz1PNjG4B1qvQhE2_Q_1763727289
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F29621956061;
	Fri, 21 Nov 2025 12:14:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A221C1800451;
	Fri, 21 Nov 2025 12:14:48 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D6F9B21EC348; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
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
Subject: [PATCH v2 15/15] block/file-win32: Improve an error message
Date: Fri, 21 Nov 2025 13:14:38 +0100
Message-ID: <20251121121438.1249498-16-armbru@redhat.com>
In-Reply-To: <20251121121438.1249498-1-armbru@redhat.com>
References: <20251121121438.1249498-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Two out of three calls of CreateFile() use error_setg_win32() to
report errors.  The third uses error_setg_errno(), mapping
ERROR_ACCESS_DENIED to EACCES, and everything else to EINVAL, throwing
away detail.  Switch it to error_setg_win32().

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 block/file-win32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/file-win32.c b/block/file-win32.c
index 0efb609e1d..78961837c8 100644
--- a/block/file-win32.c
+++ b/block/file-win32.c
@@ -904,7 +904,7 @@ static int hdev_open(BlockDriverState *bs, QDict *options, int flags,
         } else {
             ret = -EINVAL;
         }
-        error_setg_errno(errp, -ret, "Could not open device");
+        error_setg_win32(errp, err, "Could not open device");
         goto done;
     }
 
-- 
2.49.0


