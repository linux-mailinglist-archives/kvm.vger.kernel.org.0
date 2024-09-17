Return-Path: <kvm+bounces-27033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E988E97AE11
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC57028248A
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D0A1649CC;
	Tue, 17 Sep 2024 09:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwjxy8Xw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FA915D5B6
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565945; cv=none; b=GyY5AT2+g3tF+4CIGbujk7QvNR/ZwjlNsDknhcCYvsZOly1z85oRv7R/d5CikpqqyOCz2gczI8dJAnbtBnEfI9S0XJl7ozTjKn+YrzILRyW54mBZ/8uYRQrkT8vdicFf5YYBh1D7Ii0Usr/QmMULqP20H5gV1HcRYsSpC0hoIeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565945; c=relaxed/simple;
	bh=DrxIO17XlQ+Q1eqW5QuFcldZBs8Mcn6xKSOxC0VuVTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Un5YVBFoF8YDRpdA8BNvmrB9BUiPF2S07Izb7RxAzG3yBiJ6kyU7iqXF2vB6sRoi4ikB9XEZN1XWv4/oVPB3XIentm1DTdccP8T+bCB/Or7y/VYK/KfBb4Dl5UGg4HhTEH4Br7FtDCn+fc3hz9NHJU2f0Om6QxPHjPKIdxqNxjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwjxy8Xw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726565943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jb0UIHWYv75Rf6wAiNKq1+bNbkhxHnGY3h6/ppQ5u64=;
	b=gwjxy8XwFQEWOBg6+4LYWHJzggO+n4k7gA4m0cEH5d7gLY7AyQ9IOH74zm4zgmlQNMAXwH
	rg5jzomjNtYMv5ziSL8QkRsP2kmc4VD0C0u6T9wpYfv+dWg3o5XPHheLXdqrCm8lay135O
	2+J5Yy8bzv3wskMpzuHLtECM8doea34=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-06Ok1l6aNwyJKIiEfq3Caw-1; Tue,
 17 Sep 2024 05:39:00 -0400
X-MC-Unique: 06Ok1l6aNwyJKIiEfq3Caw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A55581956048;
	Tue, 17 Sep 2024 09:38:58 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A198E30001A1;
	Tue, 17 Sep 2024 09:38:53 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	jonathanh@nvidia.com,
	mperttunen@nvidia.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	clg@redhat.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com
Cc: msalter@redhat.com
Subject: [RFC PATCH v2 0/6] vfio: platform: reset: Introduce tegra234 mgbe reset module
Date: Tue, 17 Sep 2024 11:38:08 +0200
Message-ID: <20240917093851.990344-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

We introduce a new vfio platform reset module for the tegra234
Multi-Gigabit Ethernet (MGBE).

This reset driver is more complex than previous ones because some
resources need to be prepared and released (clocks and reset). The
existing infrastructure was too simplistic to do that. So this series
extends the original single reset function to an ops struct enhanced
with optional init/release callbacks.

There the reset and clocks are handled. the callbacks are called
respectively on vfio_platform_init/release_common().

The actual reset toggles the mac reset, disable mac interrupts,
stop DMA requests and do a SW reset.

The reset code is inspired of the native driver:
net/ethernet/stmicro/stmmac/dwxgmac2_dma.c and
net/ethernet/stmicro/stmmac/dwmac-tegra.c

This series can be found at:
https://github.com/eauger/linux/tree/tegra234-mgbe-reset-module-rfc-v2

The qemu series to test with can be found at
https://github.com/eauger/qemu/tree/tegra234-mgbe-rfc

Best Regards

Eric

---

History:
v1 -> v2:
- rename reset_ops into of_reset_ops
- Move region initialization to vfio_platform_init_common
- Use init/release of_reset_ops callbacks instead of open/close


Eric Auger (6):
  vfio_platform: Introduce vfio_platform_get_region helper
  vfio_platform: reset: Prepare for additional reset ops
  vfio-platform: Move region initialization to vfio_platform_init_common
  vfio_platform: reset: Introduce new init and release callbacks
  vfio-platform: Add a new handle to store reset data
  vfio/platform: Add tegra234-mgbe vfio platform reset module

 drivers/vfio/platform/reset/Kconfig           |   7 +
 drivers/vfio/platform/reset/Makefile          |   2 +
 .../platform/reset/vfio_platform_amdxgbe.c    |   7 +-
 .../reset/vfio_platform_calxedaxgmac.c        |   7 +-
 .../reset/vfio_platform_tegra234_mgbe.c       | 234 ++++++++++++++++++
 drivers/vfio/platform/vfio_platform_common.c  |  88 +++++--
 drivers/vfio/platform/vfio_platform_private.h |  43 +++-
 7 files changed, 349 insertions(+), 39 deletions(-)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_tegra234_mgbe.c

-- 
2.41.0


