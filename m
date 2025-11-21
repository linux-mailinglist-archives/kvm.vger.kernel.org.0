Return-Path: <kvm+bounces-64117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A67C78FC9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 457852BB65
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4419D34D3B5;
	Fri, 21 Nov 2025 12:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T4W2SIFG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9A734C816
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727296; cv=none; b=nkILN2zsh64bwaNEUKO7yOx7v0eJ825djsXguc1vHxlct4P5uBVUZkblX5Y2gXYaB2IFBNo93Q8GVGSiIsnq7CoKwe+gwebQbyJb9il6l0qZ6O0HbAbyi7eKJLC23S8aFThwpw3MzZEGf31+2+K6emHwKmSCGLrYx23FIqDsDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727296; c=relaxed/simple;
	bh=vUEfE8rbgu9z9wRKEmNEehtjAoRbitazjv+qSM4hrLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYwqeg6fyWnKlVYQggc4kVcrh449DcJWlCETjGiPrlZQrIlmKxTZ+8zFuUenvjn/DbWDJ6jORLzKRVB3kTVwVKmsgL4SHxYiiFXmSAs8mF428C1pG+9zTaZMqQ/af6zliKSPARJbXQz3bQoAt8CkIQfLIUIDkQCvmdndEdCntxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T4W2SIFG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fcIBzXudHPYvY6QmF4OmsaPzhsA+4LiQymdChLvcMTo=;
	b=T4W2SIFGoX08jlLDUOV/kEe2uLY0RtBaBdyRDrqIQ8cZYdYrBBQvk818qFefH012Jqccp4
	kstHrv2pmH56sSgrPin4l8kUxijYrjxO3hHwbWTmUCgHIWJRQAngWZ6YvV/zyIc7Au8xkg
	fgPjPAv1zhmPYpk1v/54xZmKTnQM9N0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-Dq2pCknkP6KXf0MRWBD_yw-1; Fri,
 21 Nov 2025 07:14:48 -0500
X-MC-Unique: Dq2pCknkP6KXf0MRWBD_yw-1
X-Mimecast-MFC-AGG-ID: Dq2pCknkP6KXf0MRWBD_yw_1763727284
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FD4B1800650;
	Fri, 21 Nov 2025 12:14:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19398180049F;
	Fri, 21 Nov 2025 12:14:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 835E221E6935; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
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
Subject: [PATCH v2 01/15] error: Strip trailing '\n' from error string arguments (again)
Date: Fri, 21 Nov 2025 13:14:24 +0100
Message-ID: <20251121121438.1249498-2-armbru@redhat.com>
In-Reply-To: <20251121121438.1249498-1-armbru@redhat.com>
References: <20251121121438.1249498-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Tracked down with scripts/coccinelle/err-bad-newline.cocci.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/audio/es1370.c | 2 +-
 ui/gtk.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/audio/es1370.c b/hw/audio/es1370.c
index 9873ffadab..566f93f1ea 100644
--- a/hw/audio/es1370.c
+++ b/hw/audio/es1370.c
@@ -228,7 +228,7 @@ static void print_sctl(uint32_t val)
 #undef a
         error_report("es1370: "
                 "%s p2_end_inc %d, p2_st_inc %d,"
-                " r1_fmt %s, p2_fmt %s, p1_fmt %s\n",
+                " r1_fmt %s, p2_fmt %s, p1_fmt %s",
                 buf,
                 (val & SCTRL_P2ENDINC) >> SCTRL_SH_P2ENDINC,
                 (val & SCTRL_P2STINC) >> SCTRL_SH_P2STINC,
diff --git a/ui/gtk.c b/ui/gtk.c
index 48571bedbf..e83a366625 100644
--- a/ui/gtk.c
+++ b/ui/gtk.c
@@ -1197,7 +1197,7 @@ static gboolean gd_touch_event(GtkWidget *widget, GdkEventTouch *touch,
         type = INPUT_MULTI_TOUCH_TYPE_END;
         break;
     default:
-        warn_report("gtk: unexpected touch event type\n");
+        warn_report("gtk: unexpected touch event type");
         return FALSE;
     }
 
-- 
2.49.0


