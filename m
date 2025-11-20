Return-Path: <kvm+bounces-63972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2819EC7607A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 538974E1704
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBDE36922E;
	Thu, 20 Nov 2025 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GhIcUS9K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5E1368E00
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666037; cv=none; b=akDO8Rm4PgiOXSajf8WyvsuYlgMdUhcGr5Pr8+xkq7u7AlzapIQtOQDwoR22wHRPY940VNt2Q1T5T5gIi5Lt+n5dcdy3kUQcW+l7SxdWq3G3OVLrbcNb2d3M9fiHZHpUmZ02/8TGaCrwJuKcnf1MyL46qKo5U4f4V7cEojWiE3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666037; c=relaxed/simple;
	bh=fDqBSsb3l9/+HBeW3xGIN8EotdmD0CB7b6IShXTzFvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XP78bolzlFi1uVU0Euum6y7DA/6TDrnshnI3Gg72AX4KKFQdJ4sfq32hLRVOVC3goyiCtxHa8tZ50RA/YceP7SDYgTcyLbI6NvFAG+UEkBGibBawJWAypWZfcDI3vhINXBrO/NE3RA55MXUFZyMoAgGqeFV/36YI3S0GVQEFIbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GhIcUS9K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ECBnpLLCj16fpj21fI+h9tBul9riCpuU3pZvsycdoc0=;
	b=GhIcUS9Ksoq7tPOnt3raW5KN7LB0CKRsfT9yvMG5cNBhVr6SZXj4H5pnkfcNF2ZOQsp6Iw
	XvsjCQgMes8QIIJz2rSPjNEL1LnIFPm6ieP1sltkfmCh7x1S5Xgrp9mMgNT5bxlS13h4JE
	Kx0o5N+QiZnVNeXOEQn9kHiwigCA14c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-jEDqh1RKOraiJsp9TZW5JQ-1; Thu,
 20 Nov 2025 14:13:51 -0500
X-MC-Unique: jEDqh1RKOraiJsp9TZW5JQ-1
X-Mimecast-MFC-AGG-ID: jEDqh1RKOraiJsp9TZW5JQ_1763666027
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAA1218002D0;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D23C1801747;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 768B121E65DF; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 10/14] net/slirp: Improve file open error message
Date: Thu, 20 Nov 2025 20:13:35 +0100
Message-ID: <20251120191339.756429-11-armbru@redhat.com>
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

This error reports failure to create a temporary file, and
error_setg_file_open() would probably be too terse, so merely switch
to error_setg_errno() to add errno information.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 net/slirp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/slirp.c b/net/slirp.c
index 120eef6122..5996fec512 100644
--- a/net/slirp.c
+++ b/net/slirp.c
@@ -1034,8 +1034,10 @@ static int slirp_smb(SlirpState* s, const char *exported_dir,
 
     f = fopen(smb_conf, "w");
     if (!f) {
+        int eno = errno;
+
         slirp_smb_cleanup(s);
-        error_setg(errp,
+        error_setg_errno(errp, eno,
                    "Could not create samba server configuration file '%s'",
                     smb_conf);
         g_free(smb_conf);
-- 
2.49.0


