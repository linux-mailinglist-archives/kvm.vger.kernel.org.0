Return-Path: <kvm+bounces-22477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AAFD93EA21
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 01:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F82C1F21907
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 23:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B2E79B9D;
	Sun, 28 Jul 2024 23:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqygtvB3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729762AF18
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722208810; cv=none; b=CbJF42DUr+V1xAwoG1q51VzXyH9+bp7Y/x2+mtmW12tbcGkwNlRp2KCz6HYKOoF0MRA3zU8utzWKl0fRChvookt2J4vq8zuioUDzMpdMwqR+6Ylj2qudisMt9Rq+tN0GOIZp+aGjVJoWipVmy+GM1QaMyd3K07T40fJWokvF4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722208810; c=relaxed/simple;
	bh=+dP40l89F19I3cNbdMF63OXjKsihv2/8PwPxnwj6LNc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dADBP9460cB5kQjB3NVei8o31lqNSSWtzcPlRDxZVlHMqBohTEkmrFBbU/x7/+L7zbKJbvM2io5XpZJGXDVEEiiZpXqk8FXhD+Avt4iYVzAhMYwoEfAXTTZDVSIfr7OMyByvsRaJ81PVz6jTS/eRq88T2TQ+6khpLS/rRKD6Nvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqygtvB3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722208806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=+eRbOioU+yVUzmrkos9cLIO1XQ0vF0g/0lgz70sgOCo=;
	b=cqygtvB3T5WwlWeiQKBqnu5uIVWep6apQRd60pb/Z3v6848NogHzWYpDaqV0RAtYAh3BqI
	6TbA8B160LB9JPfoRCjASVqLqFQJ7h7b9h0SYuRtkeKk1UA+84cwavhKr6oJWorF8cP0iD
	ZzSv4ZJc/WIQ2+24yYYXKXyju9Iy3WI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-VCOyNU_3MeqXZWeVH1jGZA-1; Sun, 28 Jul 2024 19:20:04 -0400
X-MC-Unique: VCOyNU_3MeqXZWeVH1jGZA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42816096cb8so15066165e9.0
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 16:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722208803; x=1722813603;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eRbOioU+yVUzmrkos9cLIO1XQ0vF0g/0lgz70sgOCo=;
        b=qVoNMOIp6O08Mfe1EHqHa0UI2A7u3mIW218GhFSbSZPJr+jXFGX9TMEjuRlT9KjVQ/
         18MrPBMiR2g/dhR2oNOFrQPU3z+OSG7ySQLBpOS5RH1KxWq1NSYJd3W+7REmEAg5YJdA
         NKK0mzTFnlN/l6xCLPGEmsF1T5m2+NY93Mx4HlZxI1y4DsPHWCLrenmyX86xQqpX5vWb
         Dm80ccipSOlkyP/lUdWSNzFxeVuswzAZDoFD0z68+GBLNWL6UPlOOiVpTd5EnaxkQYuB
         Q3E4lFMT2xG99tkKrvF2n4kE/BPyv6nAF1DpcufGUWYvpr9lWHFyoru9s38m8DTeRLT5
         kS8g==
X-Gm-Message-State: AOJu0YxCd5i9D7Nz5faaeub76EfbS8xAMUoU0jUj6Ppf+AAUBussA3UM
	vaOocWpgZTTo63YVC6jPvwqvn4qsYeVqf5ava5ImQVHyvtEUD/0JT2pvLvN09khCddiYtieGpsS
	x57bHclOwflSjVAOoRC1+k0Y8uyitKnW6X/JnI3YFqqOB6diJqQ==
X-Received: by 2002:a05:600c:19c8:b0:426:6fd2:e14b with SMTP id 5b1f17b1804b1-42811d8c0d7mr48465245e9.11.1722208803525;
        Sun, 28 Jul 2024 16:20:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJQeBFE1Ei3wW/3T05Gw1tpFuinUnNFeeMy1TSpz7EYl+J4w9ikvZ++fHV9MkZAfomQa2gNg==
X-Received: by 2002:a05:600c:19c8:b0:426:6fd2:e14b with SMTP id 5b1f17b1804b1-42811d8c0d7mr48464915e9.11.1722208802271;
        Sun, 28 Jul 2024 16:20:02 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:55d:98c4:742e:26be:b52d:dd54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4281a26e1bcsm33145835e9.34.2024.07.28.16.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 16:20:01 -0700 (PDT)
Date: Sun, 28 Jul 2024 19:19:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dan.carpenter@linaro.org, jiri@nvidia.com, jiri@resnulli.us,
	mst@redhat.com, quic_jjohnson@quicinc.com
Subject: [GIT PULL] virtio: fixes for rc1
Message-ID: <20240728191956-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent


The biggest thing here is the adminq change - but it looks like
the only way to avoid headq blocking causing indefinite stalls.


The following changes since commit 6c85d6b653caeba2ef982925703cbb4f2b3b3163:

  virtio: rename virtio_find_vqs_info() to virtio_find_vqs() (2024-07-17 05:20:58 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6d834691da474ed1c648753d3d3a3ef8379fa1c1:

  virtio_pci_modern: remove admin queue serialization lock (2024-07-17 05:43:21 -0400)

----------------------------------------------------------------
virtio: fixes

This fixes 3 issues:
- prevent admin commands on one VF blocking another:
  fixes a huge scalability issue with large # of VFs
- correctly return error on command failure on octeon
  fixes a corruption if any commands fail
- fix modpost warning when building virtio_dma_buf
  harmless, but the fix is trivial

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dan Carpenter (1):
      vdpa/octeon_ep: Fix error code in octep_process_mbox()

Jeff Johnson (1):
      virtio: add missing MODULE_DESCRIPTION() macro

Jiri Pirko (13):
      virtio_pci: push out single vq find code to vp_find_one_vq_msix()
      virtio_pci: simplify vp_request_msix_vectors() call a bit
      virtio_pci: pass vector policy enum to vp_find_vqs_msix()
      virtio_pci: pass vector policy enum to vp_find_one_vq_msix()
      virtio_pci: introduce vector allocation fallback for slow path virtqueues
      virtio_pci_modern: treat vp_dev->admin_vq.info.vq pointer as static
      virtio: push out code to vp_avq_index()
      virtio_pci: pass vq info as an argument to vp_setup_vq()
      virtio: create admin queues alongside other virtqueues
      virtio_pci_modern: create admin queue of queried size
      virtio_pci_modern: pass cmd as an identification token
      virtio_pci_modern: use completion instead of busy loop to wait on admin cmd result
      virtio_pci_modern: remove admin queue serialization lock

 drivers/vdpa/octeon_ep/octep_vdpa_hw.c |   2 +-
 drivers/virtio/virtio.c                |  28 +----
 drivers/virtio/virtio_dma_buf.c        |   1 +
 drivers/virtio/virtio_pci_common.c     | 192 ++++++++++++++++++++++++++-------
 drivers/virtio/virtio_pci_common.h     |  16 +--
 drivers/virtio/virtio_pci_modern.c     | 161 +++++++++++++--------------
 include/linux/virtio.h                 |   3 +
 include/linux/virtio_config.h          |   4 -
 8 files changed, 243 insertions(+), 164 deletions(-)


