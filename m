Return-Path: <kvm+bounces-21079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCAC5929C6A
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 08:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6831D1F21745
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 06:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0071946F;
	Mon,  8 Jul 2024 06:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N18IGfC5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B6C14267
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 06:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720421318; cv=none; b=OBUv3oA1PAUlgBzVeWH9MSRbIYZn9s5V/HLjgb/lqwUUhtcfoNRxmxMzpmZkF7mLXFy71kC1GEnJ2LWsiTU/mYZVrN86sZfjk44uMlTORumxPix8gcGNdw+q9SoYM7E034lUUl8r5DOddsWfVoZXlVrfUzFKAtRpPeL8ZsWoZxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720421318; c=relaxed/simple;
	bh=4ShB6meswCjftVRMVFjKdbXdfBv81ojN5q8D4ctp9ag=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tZSU46I2DbiLGQKqPHAyaxpUIa+PNOHHFkvA6Ws/1X3KJ2yc/mz84XkXnztlL0aMNuMz9BmuDtj6PMDyvvaCuSn5PPff4LQ4tXdjy1dcEsbbak30gzq/AXggF7t2RSHr69q8ApwIWGH3mM+BArah1RW7ekZNdwlSa8Dq/ALiPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N18IGfC5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720421315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=czPcvFUg2hkmMF4g7Cr9gKigFvbmolIFBJvqgLDCt4I=;
	b=N18IGfC5ge6PL7XkCwOXBydUmP38XUInEOrSMlcJVy+GDCAYWZsCXcRDHi7Ne6HD+pRtAa
	+jYpwGfLHSdhUOev/FCAit3GfDIoD8Bu1mhRg5nS7LXB20tJtVLXFkByyTAgHtbEhfigRf
	X+d9xoOH4WUwfnAnXkBSlHUYW0uUVEc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-IYfyWGgWNs2Jz9A9w-ucxw-1; Mon,
 08 Jul 2024 02:48:32 -0400
X-MC-Unique: IYfyWGgWNs2Jz9A9w-ucxw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0323E19560A2;
	Mon,  8 Jul 2024 06:48:31 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.123])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 520FA19560B2;
	Mon,  8 Jul 2024 06:48:24 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	parav@nvidia.com,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Date: Mon,  8 Jul 2024 14:47:01 +0800
Message-ID: <20240708064820.88955-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add support for setting the MAC address using the VDPA tool.
This feature will allow setting the MAC address using the VDPA tool.
For example, in vdpa_sim_net, the implementation sets the MAC address
to the config space. However, for other drivers, they can implement their
own function, not limited to the config space.

Changelog v2
 - Changed the function name to prevent misunderstanding
 - Added check for blk device
 - Addressed the comments
Changelog v3
 - Split the function of the net device from vdpa_nl_cmd_dev_attr_set_doit
 - Add a lock for the network device's dev_set_attr operation
 - Address the comments

Cindy Lu (2):
  vdpa: support set mac address from vdpa tool
  vdpa_sim_net: Add the support of set mac address

 drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++++++++++++
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
 include/linux/vdpa.h                 |  9 ++++
 include/uapi/linux/vdpa.h            |  1 +
 4 files changed, 109 insertions(+), 1 deletion(-)

-- 
2.45.0


