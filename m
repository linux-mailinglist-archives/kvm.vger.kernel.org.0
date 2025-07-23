Return-Path: <kvm+bounces-53246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC854B0F411
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1402964F30
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3178D2E7F21;
	Wed, 23 Jul 2025 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3l+6eyk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F002E7196
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753277587; cv=none; b=L+zdUbZtArOTnc/dPw9j5rrGhHevl0g53tLbODsSrPrKnelx7rQcxVODAJbvD1C48OyZ+QYedU6Es1+3Vr/evEuW99uBeD1u8cH3ea7oxXk2FfdGXMPyTLdbbMxTpxC+/dS3clE7GIbR/CggygetZ/ItU22l5BlarfsPskD9wxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753277587; c=relaxed/simple;
	bh=ESVvhiqz3OqvO84U3lZIPwFgNvO9nZ3Y+9ZeHaR3cEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i14D2faXRmLH5ozY4JcxilHOw9/4x29AUdBnxJdu7MnMZbKZaK6lvpJiDKQ4daZ80fogtRX+43XutlI0HoupCXqvT0TOlywPA2qc/1DuOMxwhp1r5Xkbt7cToi4P8AOWQacxhJ9YK56bt6Zge93bshaaViQRjxxvsQ+5bpQjF/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3l+6eyk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753277584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogFYsziT8XOCULnkNwfAFSSK14n0ye3fZUdNChpWgfE=;
	b=b3l+6eykGoDe8xLtBaFqMwPU4gnCwLv5cwCR2yIzBxCsPDaQoZfM+6AqJQC2xpWKQjpR58
	feEhnzzLE/fOq+XadOjeIhyhBSJoqdZqVkgs7DY+TyB0PM+djF9yNStROegwmugXETZ1Iw
	/HQUbZC1V5YI3l+NikVGWHoYZDXXR5c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-eXztY510Pjq68YfWb_abeg-1; Wed,
 23 Jul 2025 09:33:02 -0400
X-MC-Unique: eXztY510Pjq68YfWb_abeg-1
X-Mimecast-MFC-AGG-ID: eXztY510Pjq68YfWb_abeg_1753277581
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BDF11956095;
	Wed, 23 Jul 2025 13:33:01 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D54D91966650;
	Wed, 23 Jul 2025 13:33:00 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 0362F21E6924; Wed, 23 Jul 2025 15:32:58 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,
	mtosatti@redhat.com,
	kvm@vger.kernel.org,
	aharivel@redhat.com
Subject: [PATCH 1/2] i386/kvm/vmsr_energy: Plug memory leak on failure to connect socket
Date: Wed, 23 Jul 2025 15:32:56 +0200
Message-ID: <20250723133257.1497640-2-armbru@redhat.com>
In-Reply-To: <20250723133257.1497640-1-armbru@redhat.com>
References: <20250723133257.1497640-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

vmsr_open_socket() leaks the Error set by
qio_channel_socket_connect_sync().  Plug the leak by not creating the
Error.

Fixes: 0418f90809ae (Add support for RAPL MSRs in KVM/Qemu)
Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 target/i386/kvm/vmsr_energy.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/i386/kvm/vmsr_energy.c b/target/i386/kvm/vmsr_energy.c
index 58ce3df53a..890322ae37 100644
--- a/target/i386/kvm/vmsr_energy.c
+++ b/target/i386/kvm/vmsr_energy.c
@@ -57,13 +57,9 @@ QIOChannelSocket *vmsr_open_socket(const char *path)
     };
 
     QIOChannelSocket *sioc = qio_channel_socket_new();
-    Error *local_err = NULL;
 
     qio_channel_set_name(QIO_CHANNEL(sioc), "vmsr-helper");
-    qio_channel_socket_connect_sync(sioc,
-                                    &saddr,
-                                    &local_err);
-    if (local_err) {
+    if (qio_channel_socket_connect_sync(sioc, &saddr, NULL) < 0) {
         /* Close socket. */
         qio_channel_close(QIO_CHANNEL(sioc), NULL);
         object_unref(OBJECT(sioc));
-- 
2.49.0


