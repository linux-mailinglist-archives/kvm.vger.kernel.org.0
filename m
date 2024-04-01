Return-Path: <kvm+bounces-13290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CF08945C6
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BF5028205F
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C1253E0C;
	Mon,  1 Apr 2024 19:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmrkzcUm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D56339B1
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712001253; cv=none; b=ro5JBqVTSz3Y12KoEWCUIqtXywSi1HEb83KNBVSXh6YTVrvq0xM1qvhvY87UgroRqDRUh/3zeGabjI0w3FrcXYZmKX81UlovqyVq0ttEriosxlMh+Fg7ZI6no6i+3eSOHMYLYsLEN96BTdFB4fEcmiUxazMfQc0pYtJ9yKvlXMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712001253; c=relaxed/simple;
	bh=HbRVqQE1EV16RcohXbUt7WAwP79IiVHV4lafbt7aH08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F7okcjqzreXLkSC0A+TV0crjqNpDnWXjxCM//frp/Fkveu/UCfrovQlXILgs1dBN/5n1lI+T3THY+OGaHNGHrHaAQoUkqnsoxqnkesfKf+yVILPWvMgq7lCf4cPL22TAlgcmltsxdY8HUqvayWqoW3GsB5kdqEGsInU6riIm4Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TmrkzcUm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712001250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=afsrJRwR5vMiIQi4YOQOSeVi5uveXzbpM83HdBD8sGU=;
	b=TmrkzcUmKk98jIkt+w3bhNbBu2vQ81uruTWIleFheQaM3XhcIQxoRSXujXJ2BLWFhuZSQc
	Jc6A+XGVonqxfIx5GN4k21zm59kvHIjcy8K9xutwR+Ro5JzvsKOBZBnOZPKbHFOsgF0S24
	xdtS3dSz1PhTCGgTLFREjajErf6q5PM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-i2EY1ZI-PHeQXDTGDnzd1Q-1; Mon, 01 Apr 2024 15:54:09 -0400
X-MC-Unique: i2EY1ZI-PHeQXDTGDnzd1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24AF800269;
	Mon,  1 Apr 2024 19:54:08 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.212])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B543112C5;
	Mon,  1 Apr 2024 19:54:08 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	reinette.chatre@intel.com
Subject: [PATCH 0/2] vfio/pci: Improve INTx opaque data use
Date: Mon,  1 Apr 2024 13:54:01 -0600
Message-ID: <20240401195406.3720453-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Now that the interrupt handler and eventfd context object are persistent
across the configuration of INTx, make better use of the opaque data
fields when registering the IRQ and irqfd to avoid lookup of the eventfd
context object.  No functional change intended.  Thanks,

Alex

Alex Williamson (2):
  vfio/pci: Pass eventfd context to IRQ handler
  vfio/pci: Pass eventfd context object through irqfd

 drivers/vfio/pci/vfio_pci_intrs.c | 57 +++++++++++++------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

-- 
2.44.0


