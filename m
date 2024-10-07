Return-Path: <kvm+bounces-28073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A046A993208
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E25D281105
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 15:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DB71D9A44;
	Mon,  7 Oct 2024 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K4JUALLg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B02F1D7E25
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728316328; cv=none; b=mhO0MjEg1r/jCqpKySiWd0EgwDVGgLPgT9skPVZQL939pRtNE9l8kV4HSaH5yrG7Jc1xTI/uqPCLq2L5NtpMLxM7dFb8kmXPJl5SBMYLfksosvmv8e34S+KzJtjX+pmqrer/3pMPEFlvJtrQBTHROJ92XxTXCgsGRHcrNM3xzEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728316328; c=relaxed/simple;
	bh=/EZ8uL9G3hFtdF20Zk/ubx5oExJilk/BwdV79vc3cnc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XkK70TVY0M557niD8rSdrnlrZjtwj8uOhPJaFsuKxhtJ1DWLuvRmvHGkmREG1p90J3Io5FxLwDcFKYK5VaER8yzfQ/AcPFDcG0Racahli62J1/t6rOM1TsaiWwG0rof//j5nKmSx9f86azyJiDxPo2WqCIYuy07zEvVSgYdvWyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K4JUALLg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728316326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=G9TXcvGmMkyb4Jec0+mQTLksqLLOXrKvoY/7ZxCB8eE=;
	b=K4JUALLgNwKkiTZJCXHOITztXW1y+9CUCd99Z0DMEwZjZo/8CYa2mjOlbRSg607y8wxOxA
	A3quqvuLwjIxwodV2VMwuRQ7PwC5UJbHdZWXLbjwKC1HMuBhyPiHgcnY2uJx0FvoTvXx0D
	ulsQ+DuydqjfwH6BlTmsnOgazEcxIDI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-wW4efmzkMEWO5Eu4zkWl4Q-1; Mon, 07 Oct 2024 11:52:05 -0400
X-MC-Unique: wW4efmzkMEWO5Eu4zkWl4Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb5f6708aso29374985e9.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 08:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728316324; x=1728921124;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TXcvGmMkyb4Jec0+mQTLksqLLOXrKvoY/7ZxCB8eE=;
        b=opHLPPbBX2GIazeLhtfDWQ9X4JaskJmfCGg592UQN0q4fKTsBTz/6XZFj7QizEYT8I
         ZShUe7pEmXrVx2dKoNF5ju/IylqerhrRxxjX46F0z2kt7F7PtNELpkKwSJxyzvo0QJvW
         heVdtqXyQkkh69pphhgMfjWa3LCE2F2RYGHo2Urqrs8p3S8zta94pRGaV3L9QkwqEowN
         j55z7aPKGGdnxMGKArxsmTiEXLYz3eDeRqG+ayyzGCfV5Q2uZRTCYpFN6auXspF5Pwgs
         ema0/2mhX31m/rVDk9aeaZ4kkVaTcBIkj3OItfxwJSWoX95k1ygTmS6i4DjgfyrW1jJn
         O+SQ==
X-Gm-Message-State: AOJu0YwehMA9Qwv0ceR7KaTTXk0WTL8ek9q1m80nf4WLzfr3HVYP7Tjv
	OMMo0+CH2nDNxdmYPc8VEsnAxSPqh36z2iN9ijrw3XoYTlHiVhcHxAiFpEjQBGdyL7hYxknr1xH
	q1TCbBGDXW6v496IJ+rsm8RAEkf98sKcAojhwxB2GJtMOTYIezA==
X-Received: by 2002:a05:600c:350c:b0:42e:8d0d:bca5 with SMTP id 5b1f17b1804b1-42f85aa1a76mr80142225e9.2.1728316323915;
        Mon, 07 Oct 2024 08:52:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6www5QFkt0BJe4rLwpAGtQvp+gL9TCRDjcvZWpHi7aBIelswHzZJHbt+bvyCApLkp6Y2R5Q==
X-Received: by 2002:a05:600c:350c:b0:42e:8d0d:bca5 with SMTP id 5b1f17b1804b1-42f85aa1a76mr80141915e9.2.1728316323509;
        Mon, 07 Oct 2024 08:52:03 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:8906:45ec:feb4:98e4:6184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b1d7aasm95666195e9.27.2024.10.07.08.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 08:52:03 -0700 (PDT)
Date: Mon, 7 Oct 2024 11:51:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	brauner@kernel.org, dan.carpenter@linaro.org, elver@google.com,
	jasowang@redhat.com, lkp@intel.com, luigi.leonardi@outlook.com,
	michael.christie@oracle.com, mst@redhat.com, schalla@marvell.com,
	sgarzare@redhat.com,
	syzbot+8a02104389c2e0ef5049@syzkaller.appspotmail.com,
	wh1sper@zju.edu.cn
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20241007115158-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit efcd71af38be403fa52223092f79ada446e121ba:

  vsock/virtio: avoid queuing packets when intermediate queue is empty (2024-09-25 07:07:44 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 221af82f606d928ccef19a16d35633c63026f1be:

  vhost/scsi: null-ptr-dereference in vhost_scsi_get_req() (2024-10-07 11:47:56 -0400)

----------------------------------------------------------------
virtio: bugfixes

Several small bugfixes all over the place.
Most notably, fixes the vsock allocation with GFP_KERNEL in atomic
context, which has been triggering warnings for lots of testers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Haoran Zhang (1):
      vhost/scsi: null-ptr-dereference in vhost_scsi_get_req()

Michael S. Tsirkin (3):
      virtio_ring: tag event_triggered as racy for KCSAN
      virtio_console: fix misc probe bugs
      vsock/virtio: use GFP_ATOMIC under RCU read lock

Srujana Challa (1):
      vdpa/octeon_ep: Fix format specifier for pointers in debug messages

 drivers/char/virtio_console.c          | 18 ++++++++++--------
 drivers/vdpa/octeon_ep/octep_vdpa_hw.c | 12 ++++++------
 drivers/vhost/scsi.c                   | 25 ++++++++++++++-----------
 drivers/virtio/virtio_ring.c           |  2 +-
 net/vmw_vsock/virtio_transport.c       |  8 ++++----
 5 files changed, 35 insertions(+), 30 deletions(-)


