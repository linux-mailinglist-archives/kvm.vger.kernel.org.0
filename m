Return-Path: <kvm+bounces-12363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C4A5885735
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 11:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B605E1F21DB5
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 10:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B84A56B69;
	Thu, 21 Mar 2024 10:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cW+DnKQG"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009415674D;
	Thu, 21 Mar 2024 10:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711016146; cv=none; b=u45pqDKFLiVt9A/TElaoAOJtgNMVdBLMuLq1ieQCY8XVTBe2AdwZEy8h/97PnTuwe0mPjnUXtgAjsF+3sUOlv6Ant5C2/P05YkXZVaGaQCmcCabhol/6j6iRK9Shnid9U5mgRq3LX0W46NaAsj3Kll29nFm/od4X/BzTaV90b+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711016146; c=relaxed/simple;
	bh=Ytjv8h8VxWFEtKyURrSyYJai3ajSqv0ktqO6cwRpnLU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=otBgS+uzhuoMNSUtY1SHVyOkw6oKqwFrUYjOyRzcUz2EFLTM1amcwgWarSIqkPfzRYB6LMEMTlYkFuORzIfzJ11qr5tV9rw09JqMTSK+y+C6rt5OlNwsQCIoD3MPL8nMV2ecAZHvTq8dU5MJULpTzb6mKRWIsg1FVllT+atIeFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cW+DnKQG; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711016135; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=wTxDitpguc7D9IOv4I5f29Qm8gzbpWNMt1WDDHf3HJ8=;
	b=cW+DnKQGQ2T6P7z4VjeNzcoBHtQlBaOSJEEToiw8p6TXwtvSr+9nwQF1tAbXngtDQHzwkFe3VeE05963e6fR2mGPyzACMK4+hayaf0LOBJLa+J1eIWnhTsm0kImr6q7uygARAApXv4AY6w+bUyIlLcJIHgyQBB2qPE0QyqElQUw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W3-MA6N_1711016132;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3-MA6N_1711016132)
          by smtp.aliyun-inc.com;
          Thu, 21 Mar 2024 18:15:33 +0800
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
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH vhost v4 0/6] refactor the params of find_vqs()
Date: Thu, 21 Mar 2024 18:15:26 +0800
Message-Id: <20240321101532.59272-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Git-Hash: 571c18a30348
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

v4:
  1. remove support for names array entries being null
  2. remove cfg_idx from virtio_vq_config

v3:
  1. fix the bug: "assignment of read-only location '*cfg.names'"

v2:
  1. add kerneldoc for "struct vq_transport_config" @ilpo.jarvinen

v1:
  1. fix some comments from ilpo.jarvinen@linux.intel.com




Xuan Zhuo (6):
  virtio_balloon: remove the dependence where names[] is null
  virtio: remove support for names array entries being null.
  virtio: find_vqs: pass struct instead of multi parameters
  virtio: vring_create_virtqueue: pass struct instead of multi
    parameters
  virtio: vring_new_virtqueue(): pass struct instead of multi parameters
  virtio_ring: simplify the parameters of the funcs related to
    vring_create/new_virtqueue()

 arch/um/drivers/virtio_uml.c             |  33 ++---
 drivers/platform/mellanox/mlxbf-tmfifo.c |  25 ++--
 drivers/remoteproc/remoteproc_virtio.c   |  34 ++---
 drivers/s390/virtio/virtio_ccw.c         |  35 ++---
 drivers/virtio/virtio_balloon.c          |  41 +++---
 drivers/virtio/virtio_mmio.c             |  33 ++---
 drivers/virtio/virtio_pci_common.c       |  62 +++-----
 drivers/virtio/virtio_pci_common.h       |   9 +-
 drivers/virtio/virtio_pci_legacy.c       |  16 ++-
 drivers/virtio/virtio_pci_modern.c       |  37 +++--
 drivers/virtio/virtio_ring.c             | 173 ++++++++---------------
 drivers/virtio/virtio_vdpa.c             |  48 +++----
 include/linux/virtio_config.h            |  75 +++++++---
 include/linux/virtio_ring.h              |  93 +++++++-----
 tools/virtio/virtio_test.c               |   4 +-
 tools/virtio/vringh_test.c               |  28 ++--
 16 files changed, 351 insertions(+), 395 deletions(-)

--
2.32.0.3.g01195cf9f


