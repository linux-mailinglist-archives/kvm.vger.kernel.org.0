Return-Path: <kvm+bounces-10226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3FD386AC88
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81FBD1F24369
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFC512FF98;
	Wed, 28 Feb 2024 11:05:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D824A12EBDF;
	Wed, 28 Feb 2024 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709118316; cv=none; b=lIGoLjChXW2mIkNtYU7HdPqflGVATShqJNzHNEHHNNi6BqaCmSMM16E4xQMI5OAQQt0BDCP+Fy93IktQlUC3b8jYh3brL6wCbz1DL95SmJvB/Vy0t2mzrenFssSTqibyNov8XPXwDy1CY79Hs0WvIKtzPC55Tzd1kmpELiruukM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709118316; c=relaxed/simple;
	bh=fzby08iFoLHHuRG0MLFoUXRbZcJapueKM6rj/Q2uFY4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N4dWvm/T6B5USSBI5JDNMgkftcmdGoC6F3RxpFctxGDz3QkO0StLWsPNrfvDfvzPMIScXoadsRh2fb3YGKj6907qLYyNi0LHyy4NofQmGBZBAJJNOvPJmyPSMbrCiwJr+yA4/r1ta7qR2bFpdmKHTtnol1KndbIxqDvoc2PORTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TlBK83Vw5z2BdmP;
	Wed, 28 Feb 2024 19:02:52 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id 813BE18002F;
	Wed, 28 Feb 2024 19:05:07 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 28 Feb
 2024 19:05:07 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <bjorn@kernel.org>,
	<magnus.karlsson@intel.com>, <maciej.fijalkowski@intel.com>,
	<jonathan.lemon@gmail.com>, <davem@davemloft.net>
CC: <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <xudingke@huawei.com>,
	<liwei395@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next v2 0/3] tun: AF_XDP Tx zero-copy support
Date: Wed, 28 Feb 2024 19:04:41 +0800
Message-ID: <1709118281-125508-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500008.china.huawei.com (7.185.36.136)

Hi all:

Now, some drivers support the zero-copy feature of AF_XDP sockets,
which can significantly reduce CPU utilization for XDP programs.

This patch set allows TUN to also support the AF_XDP Tx zero-copy
feature. It is based on Linux 6.8.0+(openEuler 23.09) and has
successfully passed Netperf and Netserver stress testing with
multiple streams between VM A and VM B, using AF_XDP and OVS.

The performance testing was performed on a Intel E5-2620 2.40GHz
machine. Traffic were generated/send through TUN(testpmd txonly
with AF_XDP) to VM (testpmd rxonly in guest).

+------+---------+---------+---------+
|      |   copy  |zero-copy| speedup |
+------+---------+---------+---------+
| UDP  |   Mpps  |   Mpps  |    %    |
| 64   |   2.5   |   4.0   |   60%   |
| 512  |   2.1   |   3.6   |   71%   |
| 1024 |   1.9   |   3.3   |   73%   |
+------+---------+---------+---------+

Yunjian Wang (3):
  xsk: Remove non-zero 'dma_page' check in xp_assign_dev
  vhost_net: Call peek_len when using xdp
  tun: AF_XDP Tx zero-copy support

 drivers/net/tun.c       | 177 ++++++++++++++++++++++++++++++++++++++--
 drivers/vhost/net.c     |  21 +++--
 include/linux/if_tun.h  |  32 ++++++++
 net/xdp/xsk_buff_pool.c |   7 --
 4 files changed, 220 insertions(+), 17 deletions(-)

-- 
2.41.0


