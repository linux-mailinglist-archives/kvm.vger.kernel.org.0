Return-Path: <kvm+bounces-64118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D247FC79012
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4A9004EDBCA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC1534D4FD;
	Fri, 21 Nov 2025 12:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exsoh4z6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FFE34C9B7
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727297; cv=none; b=cSsN8NoZI1vy4IABOMINKsF+taVSjyw9jLO0CWIyRhBBxMvx2X2PiYkHTEMyjpFsPxX4YfByJqmIaTbBLfi+BuK6CMSypVVA6von1LOOJ5ti3TqEODJjinC+IVVPmRwD6SvLlucOkpwb9pPDRYlZkJEU2UCZu0V8n1dou+GU3m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727297; c=relaxed/simple;
	bh=fDqBSsb3l9/+HBeW3xGIN8EotdmD0CB7b6IShXTzFvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEAyiQ0mY0l+Lcgc1aQq27NNXiZX2vj7K6n5kqJGFkr+fE8lPJrf+M6QhSTfhWyf4GgbeCpmgrfDB0YKsAfHJFV8JjYza7QlPxph/sRaxvj24ocyYW+UyE6zuHtmn772IqRJgxr0BKK3Gvk04iAPpssJLGmaoJzY9nL4t3I9Cfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=exsoh4z6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ECBnpLLCj16fpj21fI+h9tBul9riCpuU3pZvsycdoc0=;
	b=exsoh4z6R6yPlzgIs2BSEuPTxUiwmBhRHF+mRgNRK8H+b6MYo+wsc88PVzXQJpWzvvpQhA
	G4QztL7NT/k/13Sd6HCfudpqTw197UpUMhEHs97TH12Ffam7liQ87yUwE3LFBycvgQ3ACW
	RbA4PXA1OdY4xCV5sEylcUeoLTjwPy8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-A-3AMTmXM8abc48Y8X2Neg-1; Fri,
 21 Nov 2025 07:14:50 -0500
X-MC-Unique: A-3AMTmXM8abc48Y8X2Neg-1
X-Mimecast-MFC-AGG-ID: A-3AMTmXM8abc48Y8X2Neg_1763727286
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7C701801233;
	Fri, 21 Nov 2025 12:14:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA2DF1940E88;
	Fri, 21 Nov 2025 12:14:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id BFCBD21EC342; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
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
Subject: [PATCH v2 11/15] net/slirp: Improve file open error message
Date: Fri, 21 Nov 2025 13:14:34 +0100
Message-ID: <20251121121438.1249498-12-armbru@redhat.com>
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


