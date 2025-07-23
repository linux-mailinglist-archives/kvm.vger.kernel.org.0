Return-Path: <kvm+bounces-53248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBB8B0F412
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33ACE964DFC
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F43B2E8E00;
	Wed, 23 Jul 2025 13:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCJ5kaoY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E722E2E8DF2
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753277590; cv=none; b=fpnbCbNQ6/chvMIfXnzGGMFf6UsIHC0gb8puNlCfh1LoEKiSPIvaNQFw6prN5dvmJu/P2zD6/1Balp87ytspAWbRISRCVs4aVraRZ/JNDNw5zEhdsMasuCnInNHG+AQ/UtYN7tR12cAyxsCqpp8/J6PBELHBVSq76qOO13vBChg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753277590; c=relaxed/simple;
	bh=zEfGpcEDG/wapwwk0+lOXd8UU2GyhntF1fgTklUUhVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsYoLozxnWEMnw+VYRelV7ikn6RSpRAnooiLmr8Qbqe6wt8987dIk3XAr/o8R0nZ7HUt8yEsRsklts58hbLdgB+Zjj50VcQxY3CL8DXLkbKncgm+0Wgs3HZQl85J1+tHPgLrnBUiwDbltme7+BaEhySB1ueN8M3rSEL4givAd4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UCJ5kaoY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753277587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FODRQNCnTMr2DNYg0zQMcKWGKTJnag5io3LmsuPTNg=;
	b=UCJ5kaoYl3gqLLyW/7eIVAB9AIjPFJ+D9a3MZpuQNsULnjxfUejJAE8Hdiw4+SgJfOkFXl
	P7vxpkuOj4pnmdUdOqwuGYqG5MwlWa6Hg8PWL92KcPGUtKgwDIeFg2ZgueqGY3+GIQDGPB
	xiyh+PRqH405yC3UkVK/BRLOpcXdzDA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-QfZDVVgkOnKkk2K_SAoO4A-1; Wed,
 23 Jul 2025 09:33:02 -0400
X-MC-Unique: QfZDVVgkOnKkk2K_SAoO4A-1
X-Mimecast-MFC-AGG-ID: QfZDVVgkOnKkk2K_SAoO4A_1753277581
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 253961944D04;
	Wed, 23 Jul 2025 13:33:01 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.2])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEC3C19560A0;
	Wed, 23 Jul 2025 13:33:00 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 079A521E6925; Wed, 23 Jul 2025 15:32:58 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,
	mtosatti@redhat.com,
	kvm@vger.kernel.org,
	aharivel@redhat.com
Subject: [PATCH 2/2] vfio scsi ui: Error-check qio_channel_socket_connect_sync() the same way
Date: Wed, 23 Jul 2025 15:32:57 +0200
Message-ID: <20250723133257.1497640-3-armbru@redhat.com>
In-Reply-To: <20250723133257.1497640-1-armbru@redhat.com>
References: <20250723133257.1497640-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

qio_channel_socket_connect_sync() returns 0 on success, and -1 on
failure, with errp set.  Some callers check the return value, and some
check whether errp was set.

For consistency, always check the return value, and always check it's
negative.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/vfio-user/proxy.c     | 2 +-
 scsi/pr-manager-helper.c | 9 ++-------
 ui/input-barrier.c       | 5 +----
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/hw/vfio-user/proxy.c b/hw/vfio-user/proxy.c
index 2275d3fe39..2c03d49f97 100644
--- a/hw/vfio-user/proxy.c
+++ b/hw/vfio-user/proxy.c
@@ -885,7 +885,7 @@ VFIOUserProxy *vfio_user_connect_dev(SocketAddress *addr, Error **errp)
 
     sioc = qio_channel_socket_new();
     ioc = QIO_CHANNEL(sioc);
-    if (qio_channel_socket_connect_sync(sioc, addr, errp)) {
+    if (qio_channel_socket_connect_sync(sioc, addr, errp) < 0) {
         object_unref(OBJECT(ioc));
         return NULL;
     }
diff --git a/scsi/pr-manager-helper.c b/scsi/pr-manager-helper.c
index 6b86f01b01..aea751fb04 100644
--- a/scsi/pr-manager-helper.c
+++ b/scsi/pr-manager-helper.c
@@ -105,20 +105,15 @@ static int pr_manager_helper_initialize(PRManagerHelper *pr_mgr,
         .u.q_unix.path = path
     };
     QIOChannelSocket *sioc = qio_channel_socket_new();
-    Error *local_err = NULL;
-
     uint32_t flags;
     int r;
 
     assert(!pr_mgr->ioc);
     qio_channel_set_name(QIO_CHANNEL(sioc), "pr-manager-helper");
-    qio_channel_socket_connect_sync(sioc,
-                                    &saddr,
-                                    &local_err);
+    r = qio_channel_socket_connect_sync(sioc, &saddr, errp);
     g_free(path);
-    if (local_err) {
+    if (r < 0) {
         object_unref(OBJECT(sioc));
-        error_propagate(errp, local_err);
         return -ENOTCONN;
     }
 
diff --git a/ui/input-barrier.c b/ui/input-barrier.c
index 9793258aac..0a2198ca50 100644
--- a/ui/input-barrier.c
+++ b/ui/input-barrier.c
@@ -490,7 +490,6 @@ static gboolean input_barrier_event(QIOChannel *ioc G_GNUC_UNUSED,
 static void input_barrier_complete(UserCreatable *uc, Error **errp)
 {
     InputBarrier *ib = INPUT_BARRIER(uc);
-    Error *local_err = NULL;
 
     if (!ib->name) {
         error_setg(errp, QERR_MISSING_PARAMETER, "name");
@@ -506,9 +505,7 @@ static void input_barrier_complete(UserCreatable *uc, Error **errp)
     ib->sioc = qio_channel_socket_new();
     qio_channel_set_name(QIO_CHANNEL(ib->sioc), "barrier-client");
 
-    qio_channel_socket_connect_sync(ib->sioc, &ib->saddr, &local_err);
-    if (local_err) {
-        error_propagate(errp, local_err);
+    if (qio_channel_socket_connect_sync(ib->sioc, &ib->saddr, errp) < 0) {
         return;
     }
 
-- 
2.49.0


