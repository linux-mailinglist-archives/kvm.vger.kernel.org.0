Return-Path: <kvm+bounces-11193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CFD28741B7
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E68C31F22264
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 21:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB55919478;
	Wed,  6 Mar 2024 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TtESa4oe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C7C1B80F
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759702; cv=none; b=TNIpbdPmxpUt9/Q2rim8ifQUdvSxVm0cRpIt9nNGmfhCcjOZkkaMk6kQPOKVv/yb4dK/qatnjoKIKalLmCtKWhUc7/mM9LlqgfgbBIrHeu2uH5+UYzBhNlf9SIhqMfF2sSG7vzmO4B8KLRcXcb1+9aKQK67VNOHa0rMT4rDOt20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759702; c=relaxed/simple;
	bh=tss029arMELf8P9oZyMNbDbxJhT3vnM9uBRT/uTHhek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XLSOD40K13xlKOXGbabnVU8n+frXpuA9iIvnW5V6ihuBVP2bbfC3vBQPZsWksY96IFveuVkFsATvtQ9ynMbwZeDQV2qJApryYwKdLHP4Rf9m98WjHrmIiXGv2tYO64c9AbsCHbDN2UchmkmVhj6mCH3CP7xmV/sOQk9Cp9pUjP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TtESa4oe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709759699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YYGc9sw6diBEdmxwj5a1wA/JSw+mtRCurx6p6ClaHxU=;
	b=TtESa4oe/x3RoRAjk3fGOsL5cChtcckfkYkwA7O8CNr1ah8xB4c5EsHKUCuURR52KHQoJZ
	011Sz1Rz1pDLlG5qbg2YM/zihebQ/G8aZKd1uqFk7oGXt1Evwss9llcXS5ifMXPacX7r5i
	c4zqsnny+T5NncKdEbZLzNUK/fS43ZE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-w1TPYdHIP-qLUAL86kANSQ-1; Wed,
 06 Mar 2024 16:14:55 -0500
X-MC-Unique: w1TPYdHIP-qLUAL86kANSQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5A9D386A0A8;
	Wed,  6 Mar 2024 21:14:54 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.99])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C78C537F6;
	Wed,  6 Mar 2024 21:14:53 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	kevin.tian@intel.com
Subject: [PATCH 0/7] vfio: Interrupt eventfd hardening
Date: Wed,  6 Mar 2024 14:14:35 -0700
Message-ID: <20240306211445.1856768-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

This series hardens interrupt code relative to eventfd registration
across several vfio bus drivers, ensuring that NULL eventfds cannot
be triggered by users.  Several other more minor issues were discovered
and fixed along the way.

Thanks to Reinette for identifying this latent vulnerability.  Thanks,

Alex

Alex Williamson (7):
  vfio/pci: Disable auto-enable of exclusive INTx IRQ
  vfio/pci: Lock external INTx masking ops
  vfio: Introduce interface to flush virqfd inject workqueue
  vfio/pci: Create persistent INTx handler
  vfio/platform: Disable virqfds on cleanup
  vfio/platform: Create persistent IRQ handlers
  vfio/fsl-mc: Block calling interrupt handler without trigger

 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    |   7 +-
 drivers/vfio/pci/vfio_pci_intrs.c         | 176 +++++++++++++---------
 drivers/vfio/platform/vfio_platform_irq.c | 109 ++++++++++----
 drivers/vfio/virqfd.c                     |  21 +++
 include/linux/vfio.h                      |   2 +
 5 files changed, 209 insertions(+), 106 deletions(-)

-- 
2.43.2


