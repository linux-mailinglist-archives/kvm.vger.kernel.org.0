Return-Path: <kvm+bounces-57819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 434B8B7D884
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A00E152771C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 06:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA4F2E8DE2;
	Wed, 17 Sep 2025 06:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUeD/zrD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3912D2485
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 06:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758090680; cv=none; b=QzZ1/JpYcz7s2ZyRigNLUoVU9oLN0oRE2bFnbVg7ZJuJGCGU79tgrSBhotJLYw3GTi+fNDpETTMzBTiXe493fRK9swTmesPJZ1U3v1M4ThwpvqvWRaNatWSfDvUiKgtCg1I2yF8UERW16UaWI2BRaCSTU4sQomctHDrmHRnKD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758090680; c=relaxed/simple;
	bh=ouyMYCdLQIcRDAqIcwZZP1KPiEFKEwFXxBmuN8zGta0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpNlJA7Xow0Sn94y4i0o4MWxdCyJABJM1b5CofKMQyD11iuvJFdgzxc86AMWFPuz8RI9cGimgyU5N6DTHGn2wI9oymq8Dl+/ipgfLSRPqfkE2yFPI2ONUfm8yTe0vWnKqKcGwtfnIuTv/zBYzTmN5oIH5Ucq+OBSjTsqVXfzYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XUeD/zrD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758090677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFe97yqsIQyTslAhCCMaVN1g2YwFm85PG7BtqHClxB0=;
	b=XUeD/zrD+qS8vYEa69iTTtasvmS1MwMo7oTFRVXZ61GxWL1cNWpfOwk2JlkMN3lfSRuZ64
	4OTR0o/JOqjTBhfafBvRU1fCZSK8IsYvtc/GFqWRQFs/oAlMY9i2kCOl2YXv8cuCb6wPzD
	frqxfox0l7bEDaAGeLrmTFW7desyyO4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-OTWcmQoVNBCgDovWsDhtyA-1; Wed,
 17 Sep 2025 02:31:14 -0400
X-MC-Unique: OTWcmQoVNBCgDovWsDhtyA-1
X-Mimecast-MFC-AGG-ID: OTWcmQoVNBCgDovWsDhtyA_1758090673
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1700719560BE;
	Wed, 17 Sep 2025 06:31:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.239])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E781195608E;
	Wed, 17 Sep 2025 06:31:07 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: jonah.palmer@oracle.com,
	kuba@kernel.org,
	jon@nutanix.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH vhost 3/3] vhost-net: flush batched before enabling notifications
Date: Wed, 17 Sep 2025 14:30:45 +0800
Message-ID: <20250917063045.2042-3-jasowang@redhat.com>
In-Reply-To: <20250917063045.2042-1-jasowang@redhat.com>
References: <20250917063045.2042-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
sendmsg") tries to defer the notification enabling by moving the logic
out of the loop after the vhost_tx_batch() when nothing new is spotted.
This caused unexpected side effects as the new logic is reused for
several other error conditions.

A previous patch reverted 8c2e6b26ffe2. Now, bring the performance
back up by flushing batched buffers before enabling notifications.

Reported-by: Jon Kohler <jon@nutanix.com>
Cc: stable@vger.kernel.org
Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 57efd5c55f89..35ded4330431 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -780,6 +780,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
+			/* Flush batched packets to handle pending RX
+			 * work (if busyloop_intr is set) and to avoid
+			 * unnecessary virtqueue kicks.
+			 */
+			vhost_tx_batch(net, nvq, sock, &msg);
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(&net->dev,
-- 
2.34.1


