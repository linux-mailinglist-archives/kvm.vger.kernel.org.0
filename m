Return-Path: <kvm+bounces-51727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5A5AFC31A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E765B3BC14D
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 06:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA18B22539E;
	Tue,  8 Jul 2025 06:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GbZWQ/j+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9BC2222D4
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 06:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751957316; cv=none; b=Os+Wbcx7njchwpJ0HKH0qwZcuwwFqP1dT1Mydzl4AevXRRnmqkXwO6IjB5U/6PI3ryIbdrQfeVJwJj0o3STxyTZcTmWPVu9/Lj/GDI/U6K2o1nf03PsvjkOEC5LYbJ37dpuu//T6RqLxLKXj9cggMcIuX8dGjqe4KaH4tX3XagY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751957316; c=relaxed/simple;
	bh=yGVJxfUZE1KtHEBfNS5jt0mdIntrUHouPZnqSr2FpaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KkxQesav2oLp76Js8rPRW8a/iY9Cq/9sbyCzVtS7Q7ImcEUrIzY5u7FuAMhyMDpyDI0DciTxiKu49nkdKb6DQoAZaoc53lsVSZSFbXJdqeDyFCCAGfLH3tlFokJCUzUF9URXzmhnlaHVbjXI7TvxgFueiKVBBwhjtPk9c106dx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GbZWQ/j+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751957312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tsum3ML/FjoVgbok+3MjXVB4I8gHTKKd+8yAm4t36GE=;
	b=GbZWQ/j+qtjWqx4TGhT1XfjFWrT+0TL+M2/pqWJcfAjNju1patKbvKqH2OY4V2kF6P5k0A
	BHmNaYXnYY8aXvE8Q8nShK9Ux6WZ8NAhBY2OWfolwk06z3xogv6ibA5a56yetiT6bKs2Nk
	rk7DPtuVbohxhcsXqXRZOTasIkYYbFI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-539-4pB-6n1FMB-tQg3X6MkRvw-1; Tue,
 08 Jul 2025 02:48:29 -0400
X-MC-Unique: 4pB-6n1FMB-tQg3X6MkRvw-1
X-Mimecast-MFC-AGG-ID: 4pB-6n1FMB-tQg3X6MkRvw_1751957308
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 740891944AAD;
	Tue,  8 Jul 2025 06:48:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.173])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F218219560AB;
	Tue,  8 Jul 2025 06:48:23 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jonah.palmer@oracle.com
Subject: [PATCH net-next 0/2] in order support for vhost-net
Date: Tue,  8 Jul 2025 14:48:17 +0800
Message-ID: <20250708064819.35282-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi all,

This series implements VIRTIO_F_IN_ORDER support for vhost-net. This
feature is designed to improve the performance of the virtio ring by
optimizing descriptor processing.

Benchmarks show a notable improvement. Please see patch 2 for details.

Thanks

Jason Wang (2):
  vhost: basic in order support
  vhost_net: basic in_order support

 drivers/vhost/net.c   |  88 +++++++++++++++++++++---------
 drivers/vhost/vhost.c | 121 +++++++++++++++++++++++++++++++++++-------
 drivers/vhost/vhost.h |   8 ++-
 3 files changed, 170 insertions(+), 47 deletions(-)

-- 
2.31.1


