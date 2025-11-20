Return-Path: <kvm+bounces-63981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C37D9C7607D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id DC53928F73
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1713E36E9D8;
	Thu, 20 Nov 2025 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilMJUrUP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0036C589
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666041; cv=none; b=OP+hqt6lNkxYRlolxj+K3+jCdJPvjzD5qLsUSH9xOmgjHkcV3dVNs0gUnkIlwLBrd7TtfuzXEDNdY410cWPmnktwkfwCkUCFhnUY+x3J8VZfxoQsCDbYZFQPsNgIHXj0pPhBjBOKmnZEFt0wx5Kl4E3VrOwUm/TeAXaqfKXPZig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666041; c=relaxed/simple;
	bh=Gq35ZRGg1ytmuhKCNE8Zyf7AjHRmH1b/10qQcgQRaAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8xZ1K8G5C6Uwp45LDnu2j78qOJa//7npGAWKQQxtGJtOYRywGRt9FyJJc5Hj0RrQfr+BoYw1VVQWhjkSuPbRAHH0prY8ingmnjmNhSquH+JGWNYJnYGV435iEc4gbUBpUy9iIl0FrhC8PDno5fLS7ejIVgJabgc8AFDD6+3N5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilMJUrUP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i91/aRc2V0WW39WS58hSriJ7oXz4L2KTH569rGq9FSU=;
	b=ilMJUrUPdFiflo5LNUnSH0hv0I4PKWTzlXMiebs+u+0JAC+0MMSGEkioRuK4Htit6nQrsZ
	SLXmI85Xj0caGEf6GITv4qtAMdE2rNkY+enOZnR23CqDMmPVoTpFt3J2gFNGLLx+5xQfuB
	F9dgtND2LgHAdKjUXzKjPKr9+zFVEmE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-Sn9f2AgJO2O1Hmg4rwq_2Q-1; Thu,
 20 Nov 2025 14:13:52 -0500
X-MC-Unique: Sn9f2AgJO2O1Hmg4rwq_2Q-1
X-Mimecast-MFC-AGG-ID: Sn9f2AgJO2O1Hmg4rwq_2Q_1763666027
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D46EC1954B0C;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17EDA30044E7;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 66E4C21E660B; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
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
Subject: [PATCH 07/14] net/tap: Use error_setg_file_open() for a better error message
Date: Thu, 20 Nov 2025 20:13:32 +0100
Message-ID: <20251120191339.756429-8-armbru@redhat.com>
In-Reply-To: <20251120191339.756429-1-armbru@redhat.com>
References: <20251120191339.756429-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The error message changes from

    tap: open vhost char device failed

to

    Could not open '/dev/vhost-net': REASON

I think the exact file name is more useful to know than the file's
purpose.

We could put back the "tap: " prefix with error_prepend().  Not
worth the bother.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 net/tap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tap.c b/net/tap.c
index abe3b2d036..bfba3fd7a7 100644
--- a/net/tap.c
+++ b/net/tap.c
@@ -747,8 +747,7 @@ static void net_init_tap_one(const NetdevTapOptions *tap, NetClientState *peer,
         } else {
             vhostfd = open("/dev/vhost-net", O_RDWR);
             if (vhostfd < 0) {
-                error_setg_errno(errp, errno,
-                                 "tap: open vhost char device failed");
+                error_setg_file_open(errp, errno, "/dev/vhost-net");
                 goto failed;
             }
             if (!qemu_set_blocking(vhostfd, false, errp)) {
-- 
2.49.0


