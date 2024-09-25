Return-Path: <kvm+bounces-27418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6B09857B3
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 13:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0673A2815E8
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 11:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5981591FC;
	Wed, 25 Sep 2024 11:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3Na/vPK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE9C86252
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 11:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727262686; cv=none; b=B5YL19ug1yuirhvRNBezM5K8GeJWLQHPe2ZcUJOkdMLRsZWZZaAoMS5QJetJA9dMFcq6PFN96r2gwNgliuWp9igjyLNvDHC0oBrooNhI6eMTOJQJ3IsbyvW0CHR3rANEveamY9CpKaHZPuz2x5bw6LCJyi/bGkHBND5zOVBljZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727262686; c=relaxed/simple;
	bh=KxXb61FAQz73vWD6iz+3YIxIH9LHwmthexAgAZxB96U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hs8CsTfRmGksg0Q9bPjOtGdG7ZMVOkVAul/G6PoWMwORNa/8k+5+eJ5KVWY67AiVtGEjflOAv37eGjnPUZOPKWhJpqMIdf7SRhX6v7c8SmuPz8e2PdubZeQa+eQWZ9GEljVKIbZ0EsQySjyDhZBI4wMccXgejWcGnUbvTyTw9Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3Na/vPK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727262683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrgmjBMekMZhsTk36YB1tFATV8bsekZPfFmvOHdNLxc=;
	b=A3Na/vPKdMzonf5fmuKaGnOqhDXe7qlmwoD9xbGlE/T04ijdlyukz+RgG28pp7aZoPtiVB
	sY5QdRN/iRFuW1aFNuI+l/ZDX1nfhORn7J+4CXU9ATIJoXrS9HG57hFb1h5dNG34SBQ3vd
	D7hxoxsZlK/7N+JiUwxzCPAObrZOOPM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-wm1AmvUoNAeteboeUPolBQ-1; Wed, 25 Sep 2024 07:11:22 -0400
X-MC-Unique: wm1AmvUoNAeteboeUPolBQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-378929f1a4eso3373344f8f.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 04:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727262681; x=1727867481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrgmjBMekMZhsTk36YB1tFATV8bsekZPfFmvOHdNLxc=;
        b=e/xgjVIDMKZOXYrJtP999h1YjHybwMN1GoPnRaSiCYyWRmBDHnQgTLbQYt4Na0mEi0
         Aoe+u6J8/Xdj3zNU80iGqmYwgZ68UtRH3Ch+Hcxqm7ixVW9hESd7nlp0ZiHb9I3ntnnS
         wMnjAGDO0xkZEweI10MXwyQ2IDr1D6jnpauLpqW3UBozf7PviGjLf0hpHGGxqoe8BxWk
         Lo9sKDizTtGmaI0bz9TWy7g9a5dxS5Xdry7A6wqf9oXDHQZS2EzrhD0c8pMKw5lBmwIz
         y22yU5kGrAC/CZBQJdlkAIzQ2ruonnT1ScsD9zph+1sN1qvNRQ+effXihlYmo8rnDRPk
         h/eA==
X-Forwarded-Encrypted: i=1; AJvYcCUILN00phptINzyTZ2s6CrjkItC77yYUWc/N5CqxfcH6mwqjirsRXZSUySrNnOpXhfNkX4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT4oV131N+iLm0Ha94v1hghx2dFRckOBbFqFXNtlEFiBzgf68C
	2HezuOEUZFVpQg8LWOWMmfAPVQ0fWFkDzn9O6kTAevKUJ/3uXIU+o3aBa6yU41iDqHyI/TVxBdn
	qBKd7v3p23yn8f9DQjnEAFP6ahHDcX1raijCPdZo9qWFkVag9CA==
X-Received: by 2002:a05:6000:ccd:b0:374:c16d:6282 with SMTP id ffacd0b85a97d-37cc24c77a6mr1259207f8f.55.1727262681297;
        Wed, 25 Sep 2024 04:11:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKf6HgXDgT9Q2MhhcNUKK2fTxzihTzqJd9EDbYBP2zW/FIpi2gHaOGeN8FwCr5rqMSmYRAag==
X-Received: by 2002:a05:6000:ccd:b0:374:c16d:6282 with SMTP id ffacd0b85a97d-37cc24c77a6mr1259173f8f.55.1727262680773;
        Wed, 25 Sep 2024 04:11:20 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7405:9900:56a3:401a:f419:5de9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2a909asm3693458f8f.22.2024.09.25.04.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 04:11:20 -0700 (PDT)
Date: Wed, 25 Sep 2024 07:11:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, david@redhat.com, dtatulea@nvidia.com,
	eperezma@redhat.com, jasowang@redhat.com, leiyang@redhat.com,
	leonro@nvidia.com, lihongbo22@huawei.com,
	luigi.leonardi@outlook.com, lulu@redhat.com, marco.pinn95@gmail.com,
	mgurtovoy@nvidia.com, pankaj.gupta.linux@gmail.com,
	philipchen@chromium.org, pizhenwei@bytedance.com,
	yuehaibing@huawei.com, zhujun2@cmss.chinamobile.com
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20240925071019-mutt-send-email-mst@kernel.org>
References: <20240924165046-mutt-send-email-mst@kernel.org>
 <fqvpau7doh7lf7mytane7n5yww7w2lrc4y6pyshainrl52rfyl@xi6kk7hbwyhc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fqvpau7doh7lf7mytane7n5yww7w2lrc4y6pyshainrl52rfyl@xi6kk7hbwyhc>

On Wed, Sep 25, 2024 at 09:38:49AM +0200, Stefano Garzarella wrote:
> On Tue, Sep 24, 2024 at 04:50:46PM GMT, Michael S. Tsirkin wrote:
> > The following changes since commit 431c1646e1f86b949fa3685efc50b660a364c2b6:
> > 
> >  Linux 6.11-rc6 (2024-09-01 19:46:02 +1200)
> > 
> > are available in the Git repository at:
> > 
> >  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to 1bc6f4910ae955971097f3f2ae0e7e63fa4250ae:
> > 
> >  vsock/virtio: avoid queuing packets when intermediate queue is empty (2024-09-12 02:54:10 -0400)
> > 
> > ----------------------------------------------------------------
> > virtio: features, fixes, cleanups
> > 
> > Several new features here:
> > 
> > 	virtio-balloon supports new stats
> > 
> > 	vdpa supports setting mac address
> > 
> > 	vdpa/mlx5 suspend/resume as well as MKEY ops are now faster
> > 
> > 	virtio_fs supports new sysfs entries for queue info
> > 
> > 	virtio/vsock performance has been improved
> > 
> > Fixes, cleanups all over the place.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > ----------------------------------------------------------------
> > Cindy Lu (3):
> >      vdpa: support set mac address from vdpa tool
> >      vdpa_sim_net: Add the support of set mac address
> >      vdpa/mlx5: Add the support of set mac address
> > 
> > Dragos Tatulea (18):
> >      vdpa/mlx5: Fix invalid mr resource destroy
> >      net/mlx5: Support throttled commands from async API
> >      vdpa/mlx5: Introduce error logging function
> >      vdpa/mlx5: Introduce async fw command wrapper
> >      vdpa/mlx5: Use async API for vq query command
> >      vdpa/mlx5: Use async API for vq modify commands
> >      vdpa/mlx5: Parallelize device suspend
> >      vdpa/mlx5: Parallelize device resume
> >      vdpa/mlx5: Keep notifiers during suspend but ignore
> >      vdpa/mlx5: Small improvement for change_num_qps()
> >      vdpa/mlx5: Parallelize VQ suspend/resume for CVQ MQ command
> >      vdpa/mlx5: Create direct MKEYs in parallel
> >      vdpa/mlx5: Delete direct MKEYs in parallel
> >      vdpa/mlx5: Rename function
> >      vdpa/mlx5: Extract mr members in own resource struct
> >      vdpa/mlx5: Rename mr_mtx -> lock
> >      vdpa/mlx5: Introduce init/destroy for MR resources
> >      vdpa/mlx5: Postpone MR deletion
> > 
> > Hongbo Li (1):
> >      fw_cfg: Constify struct kobj_type
> > 
> > Jason Wang (1):
> >      vhost_vdpa: assign irq bypass producer token correctly
> > 
> > Lei Yang leiyang@redhat.com (1):
> >      ack! vdpa/mlx5: Parallelize device suspend/resume
>        ^
> This commit (fbb072d2d19133222e202ea7c267cfc1f6bd83b0) looked strange
> from the title, indeed inside it looks empty, so maybe the intent was to
> "squash" it with the previous commit acba6a443aa4 ("vdpa/mlx5:
> Parallelize VQ suspend/resume for CVQ MQ command") to bring back the
> Tested-by, right?
> 
> Thanks,
> Stefano

Good catch Stefano, the intent was to add the ack to all
commits in the series, I created an empty commit to
record that and then forgot to remove it.
Updated the tag, thanks!


> > 
> > Luigi Leonardi (1):
> >      vsock/virtio: avoid queuing packets when intermediate queue is empty
> > 
> > Marco Pinna (1):
> >      vsock/virtio: refactor virtio_transport_send_pkt_work
> > 
> > Max Gurtovoy (2):
> >      virtio_fs: introduce virtio_fs_put_locked helper
> >      virtio_fs: add sysfs entries for queue information
> > 
> > Philip Chen (1):
> >      virtio_pmem: Check device status before requesting flush
> > 
> > Stefano Garzarella (1):
> >      MAINTAINERS: add virtio-vsock driver in the VIRTIO CORE section
> > 
> > Yue Haibing (1):
> >      vdpa: Remove unused declarations
> > 
> > Zhu Jun (1):
> >      tools/virtio:Fix the wrong format specifier
> > 
> > zhenwei pi (3):
> >      virtio_balloon: introduce oom-kill invocations
> >      virtio_balloon: introduce memory allocation stall counter
> >      virtio_balloon: introduce memory scan/reclaim info
> > 
> > MAINTAINERS                                   |   1 +
> > drivers/firmware/qemu_fw_cfg.c                |   2 +-
> > drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  21 +-
> > drivers/nvdimm/nd_virtio.c                    |   9 +
> > drivers/vdpa/ifcvf/ifcvf_base.h               |   3 -
> > drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  47 ++-
> > drivers/vdpa/mlx5/core/mr.c                   | 291 +++++++++++++---
> > drivers/vdpa/mlx5/core/resources.c            |  76 +++-
> > drivers/vdpa/mlx5/net/mlx5_vnet.c             | 477 +++++++++++++++++---------
> > drivers/vdpa/pds/cmds.h                       |   1 -
> > drivers/vdpa/vdpa.c                           |  79 +++++
> > drivers/vdpa/vdpa_sim/vdpa_sim_net.c          |  21 +-
> > drivers/vhost/vdpa.c                          |  16 +-
> > drivers/virtio/virtio_balloon.c               |  18 +
> > fs/fuse/virtio_fs.c                           | 164 ++++++++-
> > include/linux/vdpa.h                          |   9 +
> > include/uapi/linux/vdpa.h                     |   1 +
> > include/uapi/linux/virtio_balloon.h           |  16 +-
> > net/vmw_vsock/virtio_transport.c              | 144 +++++---
> > tools/virtio/ringtest/main.c                  |   2 +-
> > 20 files changed, 1098 insertions(+), 300 deletions(-)
> > 


