Return-Path: <kvm+bounces-50786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA66AE93F3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 04:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14EAF1C404C7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B222036E9;
	Thu, 26 Jun 2025 02:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClKN8hNr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BA01E521D
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 02:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750904111; cv=none; b=iNzFgh2/5V/2I6QvZazyYLMzIEH0HJfzHGZYZgQpYrawTBWNlpxawS2yh3O4W4nOkCALCmR0CxJKOZZSzKib+QEU2s/kKNVoJ9UEtcxU+XBMprhS9BfPGRVyZOzrbJ0LtDDlx8ycHLTeN6iBGGaMKd3ULNyJVq7hCT3xlR5L0GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750904111; c=relaxed/simple;
	bh=lZtfrUzdtKa2dc1veBMHMFFXhGyABRCLdrad9t+rpE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvxjzxHNH3cQmKNv/10DQzM327e9WGsgyFKRdXQfMN3qRCyxBO0wpnmlcZ6xc/8+DDsVZ/JyqWwh0LX/tUipwlCgJLMw7M0Ny/pz98AU0YNl3ag9vJu3niXNJATmIRze3ZWfFpj3zN7Wr6XAVH1pjrpmV2hIYHCeaElUk434X4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClKN8hNr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750904109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xnv5Y0gY1WjGlCiy0+9RTcm9way0yzjnbceB3ew7Pq4=;
	b=ClKN8hNrCKQIzSziqFxRSxYsT8kN18cUvy+WCkku79YEByX5NrEjfxyTSB72V1vE28mctd
	MLG9bR5y87207MnpPX5L7cBUff4P4lOBmsj49WAE598DAUAEjs9OJrwBpyCJq9lO+AGRYL
	EZL1FG72tLHMtD+pvlI8DCnTQLyq608=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-otEP-VNYNEyzBzLp7R7pKA-1; Wed,
 25 Jun 2025 22:15:04 -0400
X-MC-Unique: otEP-VNYNEyzBzLp7R7pKA-1
X-Mimecast-MFC-AGG-ID: otEP-VNYNEyzBzLp7R7pKA_1750904103
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD1CC195608C;
	Thu, 26 Jun 2025 02:15:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.68])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 82BAA19560A3;
	Thu, 26 Jun 2025 02:14:56 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: willemdebruijn.kernel@gmail.com,
	jasowang@redhat.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: mst@redhat.com,
	eperezma@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>
Subject: [PATCH V2 net-next 2/2] vhost-net: reduce one userspace copy when building XDP buff
Date: Thu, 26 Jun 2025 10:14:45 +0800
Message-ID: <20250626021445.49068-2-jasowang@redhat.com>
In-Reply-To: <20250626021445.49068-1-jasowang@redhat.com>
References: <20250626021445.49068-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

We used to do twice copy_from_iter() to copy virtio-net and packet
separately. This introduce overheads for userspace access hardening as
well as SMAP (for x86 it's stac/clac). So this patch tries to use one
copy_from_iter() to copy them once and move the virtio-net header
afterwards to reduce overheads.

Testpmd + vhost_net shows 10% improvement from 5.45Mpps to 6.0Mpps.

Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V1:
- Add a comment to explain no overlapping when using memcpy
---
 drivers/vhost/net.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 777eb6193985..a33a32a1e488 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -690,13 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	copied = copy_from_iter(buf, sock_hlen, from);
-	if (copied != sock_hlen) {
+	copied = copy_from_iter(buf + pad - sock_hlen, len, from);
+	if (copied != len) {
 		ret = -EFAULT;
 		goto err;
 	}
 
-	gso = buf;
+	gso = buf + pad - sock_hlen;
 
 	if (!sock_hlen)
 		memset(buf, 0, pad);
@@ -715,12 +715,8 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 		}
 	}
 
-	len -= sock_hlen;
-	copied = copy_from_iter(buf + pad, len, from);
-	if (copied != len) {
-		ret = -EFAULT;
-		goto err;
-	}
+	/* pad contains sock_hlen */
+	memcpy(buf, buf + pad - sock_hlen, sock_hlen);
 
 	xdp_init_buff(xdp, buflen, NULL);
 	xdp_prepare_buff(xdp, buf, pad, len, true);
-- 
2.34.1


