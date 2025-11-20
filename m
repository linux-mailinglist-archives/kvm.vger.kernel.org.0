Return-Path: <kvm+bounces-63973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F874C76086
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F3D2735D314
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CA636C0C2;
	Thu, 20 Nov 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORB6UC/h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6318368E1B
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666038; cv=none; b=LyJOMFHcT1L1J8Y4lW46H/hVuu1Am7IJtrPi2cbWv9njJ8h+3P15Pct7peyRZhOY2rHM9EhkUZnbzwzPKwmLKJ4BtS3I0VKI9WrvvOvSh6BrOCYzwy89K84LZc/WQiCJPHQ6PrmuKIarky4V2FwrRt84SfF4Uh8ROtcDVSS9o1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666038; c=relaxed/simple;
	bh=n5ieai0oOuZYyNZCJeslW+M/vh4VieMur+A1oVEebmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akEaLM+lcV5PmfO0S//Snt5p9FdTfRWlfOAb8eoDasrITtyXX36FuYP7RDZGFJ41qurGoCFPENwua4DcsAE5smCiNRbPQoYBbKxf89PGcbYQTAxDBt1ajYrK8xNWNz4fPjBP197uE73mQWf3A/lrcV7ZJh6HEpDZTpyLgl3cdrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORB6UC/h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oeDPJTEK/mbRoQ9G1reQyHyjo6pRRwMOwFAV76+b8w0=;
	b=ORB6UC/haVNSznERM9gxooPixSyCo6vDQb3XxAK7AVc43iTyLxjxVnhLoAMenT3TnSHfH2
	4eVsBjoonsufUWVGhe1zToUFnSdaUTwfnGYmqXUKe6QYbuZb1KMMfOntBB6ZmNYcOvQd6/
	201CJrPGiaiGvh8Irnkbvdc9rwu6TQg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-M7p59jwPOHWlO-WKfumvYQ-1; Thu,
 20 Nov 2025 14:13:54 -0500
X-MC-Unique: M7p59jwPOHWlO-WKfumvYQ-1
X-Mimecast-MFC-AGG-ID: M7p59jwPOHWlO-WKfumvYQ_1763666027
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A8F11955F17;
	Thu, 20 Nov 2025 19:13:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEF1F18009BC;
	Thu, 20 Nov 2025 19:13:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8D09221EC346; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 14/14] block/file-win32: Improve an error message
Date: Thu, 20 Nov 2025 20:13:39 +0100
Message-ID: <20251120191339.756429-15-armbru@redhat.com>
In-Reply-To: <20251120191339.756429-1-armbru@redhat.com>
References: <20251120191339.756429-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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


