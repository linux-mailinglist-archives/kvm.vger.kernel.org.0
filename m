Return-Path: <kvm+bounces-25667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5163696840B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 12:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 057581F210B4
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1E913C9DE;
	Mon,  2 Sep 2024 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JP+PMrWb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7AB13B7AE
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 10:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271463; cv=none; b=g3QMp48F0tyhGxu4ni/X8RiR/YXPmNOW6neRubvAxqFYnpoXt4hJbfpWSZMOnklykDcrx4viJUBOeA2tH+ao30URMXIJ6wBdcnrpOy55JE/NCTBiMuUMRxXGggNc+dfXw2MvK4pA15KCWrpP3PolhtX6ckHqZED0k2hTgNPJn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271463; c=relaxed/simple;
	bh=1Gy5ROiwQJJO9oMaCCxrG7aibSYEu/UpXyiNyunXbfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hCrT7+Hw9Ka5fwl9F2sRP3aRrXE9LvJmC4Q9w3hhwwOUupLC5FIfsnZ7mc03z8wkU9ZuJ8XYOjnWxODhi56/qt2jX0AurGuSpay8A2qoolrerChPqfZGFEt8SOrwEBpQ44TGx0KMCtFyX17q46OKYsnHYGqXLSoI6nUMhnaGEKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JP+PMrWb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725271460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ie8OFN0GPfRB9t4uKG5JuFRs18zAhr60LEccBUs+PdU=;
	b=JP+PMrWbwkPVsakMurOBNqAAdcK8fW5pf1FkSGq9cC88vAZk1oynBrriuR3nSXpuQTMEUu
	80y48dMF0GJcTXtTWhlQ8Mw8KuCWz+rx3dXVYIkuVTaHIs06TrrROaAZp2sMsXFtnnZXXT
	ZmanH49bMJ66iwM1EBCKvYwm1+sI5U0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-CzKsWq_nPoar1bVlRHrtoA-1; Mon, 02 Sep 2024 06:04:19 -0400
X-MC-Unique: CzKsWq_nPoar1bVlRHrtoA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a86f0c0af53so367059366b.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 03:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271459; x=1725876259;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ie8OFN0GPfRB9t4uKG5JuFRs18zAhr60LEccBUs+PdU=;
        b=dBhxBvrFwrjZHS80XnxDzL9I0rNyr/+P5MUotnyjZFboz6ze3l8GOSLWmJ7/ZbDSYE
         DLDZ4kVInFJmMUlZj/wpyzxpnihaidnMV7VUx+GEOzN9UHchqpmKYgToVB3aWG/TI1M/
         UKVe5BBHHKCpK/4f4at0wCNQG5KGMNfc/cVLcL5DamFWv3eWOtBvEGj7zxGcdKhlywTr
         bQnIU71Gcg770fgj1WcFC5ikFtqD/HzA1fdHQHWpi3NRj+KMw3+ykSbpy1zbYkzquFzw
         SDNFLLhuvNIojqvAgMKfbRv4QQ4psEHUXA89aPXuRCrWiUcCbOF12CztvmG58sLaioh6
         ohPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD///PnCOvljkwKZlPQgoH2y/UA6ts1xlXfKcTZCsvGvYtuNu000Cfr4OYkzxP5rQkNJo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyzszLkrFpnkO2Y2f9Rqei/G4xGs5QVO7PqXsSmkx6QOfr0tgn
	wprj+ngPDKN9I6sq2ulZ/6Zg0v0slfZrA+jeUdWHZJI67f9RhmP5HccpFjpZoSz1LRlrDt/yjyq
	u0wy45nS8EGpJkZh6zgAoEqsoR9LSNSRGUTOA2InFDivEUhv1ASECULHHctlNWPsOknGDx89iNw
	lTrajemeUlZrXncg7ukAyfPJT9
X-Received: by 2002:a17:907:72d3:b0:a88:a48d:2b9a with SMTP id a640c23a62f3a-a897fa74459mr988546766b.52.1725271458517;
        Mon, 02 Sep 2024 03:04:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1kxKnbkvEfLFVflp4jaSLPmVyXctTqLe0cqw7LvdiW4hckvb1eweF4ThQJBsaRbv4+DVAoodYhVeTUKoFzuc=
X-Received: by 2002:a17:907:72d3:b0:a88:a48d:2b9a with SMTP id
 a640c23a62f3a-a897fa74459mr988542066b.52.1725271457591; Mon, 02 Sep 2024
 03:04:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
In-Reply-To: <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
From: Lei Yang <leiyang@redhat.com>
Date: Mon, 2 Sep 2024 18:03:41 +0800
Message-ID: <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com>
Subject: Re: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device suspend/resume
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Michael Tsirkin <mst@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Hi Dragos

QE tested this series with mellanox nic, it failed with [1] when
booting guest, and host dmesg also will print messages [2]. This bug
can be reproduced boot guest with vhost-vdpa device.

[1] qemu) qemu-kvm: vhost VQ 1 ring restore failed: -1: Operation not
permitted (1)
qemu-kvm: vhost VQ 0 ring restore failed: -1: Operation not permitted (1)
qemu-kvm: unable to start vhost net: 5: falling back on userspace virtio
qemu-kvm: vhost_set_features failed: Device or resource busy (16)
qemu-kvm: unable to start vhost net: 16: falling back on userspace virtio

[2] Host dmesg:
[ 1406.187977] mlx5_core 0000:0d:00.2:
mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
[ 1406.189221] mlx5_core 0000:0d:00.2:
mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
[ 1406.190354] mlx5_core 0000:0d:00.2:
mlx5_vdpa_show_mr_leaks:573:(pid 8506) warning: mkey still alive after
resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
[ 1471.538487] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
428): cmd[13]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
a leak of a command resource
[ 1471.539486] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
428): cmd[12]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
a leak of a command resource
[ 1471.540351] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
8511) error: modify vq 0 failed, state: 0 -> 0, err: 0
[ 1471.541433] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
8511) error: modify vq 1 failed, state: 0 -> 0, err: -110
[ 1471.542388] mlx5_core 0000:0d:00.2: mlx5_vdpa_set_status:3203:(pid
8511) warning: failed to resume VQs
[ 1471.549778] mlx5_core 0000:0d:00.2:
mlx5_vdpa_show_mr_leaks:573:(pid 8511) warning: mkey still alive after
resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
[ 1512.929854] mlx5_core 0000:0d:00.2:
mlx5_vdpa_compat_reset:3267:(pid 8565): performing device reset
[ 1513.100290] mlx5_core 0000:0d:00.2:
mlx5_vdpa_show_mr_leaks:573:(pid 8565) warning: mkey still alive after
resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2

Thanks
Lei




> This series parallelizes the mlx5_vdpa device suspend and resume
> operations through the firmware async API. The purpose is to reduce live
> migration downtime.
>
> The series starts with changing the VQ suspend and resume commands
> to the async API. After that, the switch is made to issue multiple
> commands of the same type in parallel.
>
> Then, the an additional improvement is added: keep the notifiers enabled
> during suspend but make it a NOP. Upon resume make sure that the link
> state is forwarded. This shaves around 30ms per device constant time.
>
> Finally, use parallel VQ suspend and resume during the CVQ MQ command.
>
> For 1 vDPA device x 32 VQs (16 VQPs), on a large VM (256 GB RAM, 32 CPUs
> x 2 threads per core), the improvements are:
>
> +-------------------+--------+--------+-----------+
> | operation         | Before | After  | Reduction |
> |-------------------+--------+--------+-----------|
> | mlx5_vdpa_suspend | 37 ms  | 2.5 ms |     14x   |
> | mlx5_vdpa_resume  | 16 ms  | 5 ms   |      3x   |
> +-------------------+--------+--------+-----------+
>
> ---
> v2:
> - Changed to parallel VQ suspend/resume during CVQ MQ command.
>   Support added in the last 2 patches.
> - Made the fw async command more generic and moved it to resources.c.
>   Did that because the following series (parallel mkey ops) needs this
>   code as well.
>   Dropped Acked-by from Eugenio on modified patches.
> - Fixed kfree -> kvfree.
> - Removed extra newline caught during review.
> - As discussed in the v1, the series can be pulled in completely in
>   the vhost tree [0]. The mlx5_core patch was reviewed by Tariq who is
>   also a maintainer for mlx5_core.
>
> [0] - https://lore.kernel.org/virtualization/6582792d-8db2-4bc0-bf3a-248fe5c8fc56@nvidia.com/T/#maefabb2fde5adfb322d16ca16ae64d540f75b7d2
>
> Dragos Tatulea (10):
>   net/mlx5: Support throttled commands from async API
>   vdpa/mlx5: Introduce error logging function
>   vdpa/mlx5: Introduce async fw command wrapper
>   vdpa/mlx5: Use async API for vq query command
>   vdpa/mlx5: Use async API for vq modify commands
>   vdpa/mlx5: Parallelize device suspend
>   vdpa/mlx5: Parallelize device resume
>   vdpa/mlx5: Keep notifiers during suspend but ignore
>   vdpa/mlx5: Small improvement for change_num_qps()
>   vdpa/mlx5: Parallelize VQ suspend/resume for CVQ MQ command
>
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  21 +-
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  22 +
>  drivers/vdpa/mlx5/core/resources.c            |  73 ++++
>  drivers/vdpa/mlx5/net/mlx5_vnet.c             | 396 +++++++++++-------
>  4 files changed, 361 insertions(+), 151 deletions(-)
>
> --
> 2.45.1
>


