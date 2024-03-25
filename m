Return-Path: <kvm+bounces-12572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6EC88A306
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EB201F3CC31
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC92F16A1F6;
	Mon, 25 Mar 2024 10:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kPomgpyb"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD5313D8A7;
	Mon, 25 Mar 2024 09:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711357468; cv=none; b=dcR/kmLLWJJMJ3zM3IgQ7ROB5AgXbhLxhpcW9u6UWGwTIuZ9xtmPTMKE+NFU5KHAfVo7mpCv1+sYPsQ9m4C1K8ko2XQJefLbwwS/k59C1EEGtF33SnvQkFj8GHKm08ZeCPUAU0Dcb03w/UskjpBf+Ue2xiBn5D8CI8arRGhqorU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711357468; c=relaxed/simple;
	bh=HxOxxHtwVTH5u8oyYo/vK/0ecb1qPMW3FQ3ShCMKQr4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=jfZLZ23VrlnqGbw5eTkf3kYNkDS8ptMXoMsMXHzii7ARyMPDpSMoKVRNhmPw36zUnUvBERAWubwdqrLHsyjBbl4nyNbneMaUCvVbo3wtLlBHjzyIXI/eFjRBg6ZloDqQzap4If9biooaEOM2y/KEEOyfA6oZQVK9DDwG5l+kqvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kPomgpyb; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711357462; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=zomPIhh8ug+890y2faVExtzUOonFoyYDwub4qOBIFXQ=;
	b=kPomgpybCS725LynUKNxXHxQ8p+FpeXk8zuBRtJpO3IldxRYOcAuCrodvZKpUKR3S8BNXiZMEmmdZhGMF+3xZk4hZ2dY/f5DcHmS8faPzXXTGl7WXGeZg6c/PD01MIgKqvvkLL5a/2VdVMsp9NNTNFjSIBIeyonwhYk2S+RnLY4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W3DYNxR_1711357459;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3DYNxR_1711357459)
          by smtp.aliyun-inc.com;
          Mon, 25 Mar 2024 17:04:20 +0800
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
Subject: [PATCH vhost v5 0/6] refactor the params of find_vqs()
Date: Mon, 25 Mar 2024 17:04:13 +0800
Message-Id: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Git-Hash: f38b33f54e32
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

v5:
  1. virtio_balloon: follow David Hildenbrand's suggest
    http://lore.kernel.org/all/3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com
  2. fix bug of the reference of "cfg_idx"
    http://lore.kernel.org/all/202403222227.Sdp23Lcb-lkp@intel.com

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
 drivers/virtio/virtio_balloon.c          |  46 +++---
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
 16 files changed, 350 insertions(+), 401 deletions(-)

--
2.32.0.3.g01195cf9f


