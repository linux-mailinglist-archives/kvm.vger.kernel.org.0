Return-Path: <kvm+bounces-11619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D245A878CDA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 729681F21C85
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA0EB642;
	Tue, 12 Mar 2024 02:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="B+cUXyME"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3414D6FB9;
	Tue, 12 Mar 2024 02:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710209425; cv=none; b=qCvFsIFkZsrBXy8WcoVAEqcA4DoQqMN0LFuju9K1FuY6y4ofTxP9PSWLItNLl7AQb8sbde+x+px8BmWVPIA8q74cCDuW+JSbXmhFYX0ucJty3nc5lrGQBoVCW2nMiXVyasw9oIQaFFhK3FMPzsxZEXh6DpBVpIwaV6bkNbSSiok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710209425; c=relaxed/simple;
	bh=7sM4it/sLlFJgMn6vXgBs9cjjyYlwmbxnWNAQnNS6to=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fO0kdCoPewrWmzeNFmjpxdcZpDe91Qu39BiEaxHtyzC8VjFH5B8riONx12fNlddUy7j87WSQuu9R/pM2e07VjbK9IxCnkELU1E4LgmM3wemUtLYBdUdZ7PMCuemL5gepuT+skz9Pxdd5Pl3onC8G6qGAdPkg5mO0BcSelLtQmrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=B+cUXyME; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710209415; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=93N4BPytBZxlC/Q2oeD9Rd8EctJjuaPCcnJKvMa7iTk=;
	b=B+cUXyMEIbHlJuKhgv5FhbA9dv85kXWxnl4dNBmU08iaAii7xROrlkXHDgOgQnrfNLcBnSrpVLiqyHpalg4TqqnyMWz4v0RtIbR/kUWBxe9LDbpnbQ45YcTc3ix73C+vE1AMXTDh/ti8LU5why8oTHSj05ztjm44TpCACESVphY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W2JwVQv_1710209413;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2JwVQv_1710209413)
          by smtp.aliyun-inc.com;
          Tue, 12 Mar 2024 10:10:14 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH vhost v3 0/4] refactor the params of find_vqs()
Date: Tue, 12 Mar 2024 10:10:09 +0800
Message-Id: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 8d1a4cfe2924
Content-Transfer-Encoding: 8bit

This pathset is splited from the

     http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.alibaba.com

That may needs some cycles to discuss. But that notifies too many people.

But just the four commits need to notify so many people.
And four commits are independent. So I split that patch set,
let us review these first.

The patch set try to  refactor the params of find_vqs().
Then we can just change the structure, when introducing new
features.

Thanks.

v3:
  1. fix the bug: "assignment of read-only location '*cfg.names'"

v2:
  1. add kerneldoc for "struct vq_transport_config" @ilpo.jarvinen

v1:
  1. fix some comments from ilpo.jarvinen@linux.intel.com



Xuan Zhuo (4):
  virtio: find_vqs: pass struct instead of multi parameters
  virtio: vring_create_virtqueue: pass struct instead of multi
    parameters
  virtio: vring_new_virtqueue(): pass struct instead of multi parameters
  virtio_ring: simplify the parameters of the funcs related to
    vring_create/new_virtqueue()

 arch/um/drivers/virtio_uml.c             |  31 ++--
 drivers/platform/mellanox/mlxbf-tmfifo.c |  24 ++--
 drivers/remoteproc/remoteproc_virtio.c   |  31 ++--
 drivers/s390/virtio/virtio_ccw.c         |  33 ++---
 drivers/virtio/virtio_mmio.c             |  30 ++--
 drivers/virtio/virtio_pci_common.c       |  60 ++++----
 drivers/virtio/virtio_pci_common.h       |   9 +-
 drivers/virtio/virtio_pci_legacy.c       |  16 ++-
 drivers/virtio/virtio_pci_modern.c       |  38 +++--
 drivers/virtio/virtio_ring.c             | 173 ++++++++---------------
 drivers/virtio/virtio_vdpa.c             |  45 +++---
 include/linux/virtio_config.h            |  85 ++++++++---
 include/linux/virtio_ring.h              |  93 +++++++-----
 tools/virtio/virtio_test.c               |   4 +-
 tools/virtio/vringh_test.c               |  28 ++--
 15 files changed, 363 insertions(+), 337 deletions(-)

--
2.32.0.3.g01195cf9f


