Return-Path: <kvm+bounces-25714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 541B09695D7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 785E01C21356
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570A51DAC69;
	Tue,  3 Sep 2024 07:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAemEf41"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84D61C62B1
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 07:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725349290; cv=none; b=nFMH0ZVXXmi9wXLM9qWdtuvmi0wr0SCL0wWXN6lXjR/3ivZaopl0m/WAPfzBn7Cc4e+rLGs35Lz+F4VrzcuaS79CuHlAW2hzJxeA1iqOi7x54I8UrPTzlQdqi1bWtWvew/o0/aIAc4dL5XpArbualZU9ZA6qmTg/jkJgennxBxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725349290; c=relaxed/simple;
	bh=NmZGb+MA+mXou1jnaR60KfjaG6/mC67CXIvC/9dCxeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XzF/VA9v9XEm8mY/4IbylKjn/xRq6bPFpokjgv4ng2p1gbBHCLBQqxA0AVEHkaOTRtxAdMS7dHbb7PR+PwSXF/8nOk4KFmJyOtlHV7HBoWD+9Kn3WtmWKo2WgCfGnpW6SXLAOVm5v1KuNfyLJKxi8X0XEReou2BQzIoUwbmsdYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAemEf41; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725349287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmZGb+MA+mXou1jnaR60KfjaG6/mC67CXIvC/9dCxeQ=;
	b=OAemEf41WHyuZDGx6cWSegDDr1WkmFrjiMhHj8FajN/b2DDF74gClnYmv6TNaI98GEp4Bw
	L6dJWSHl2/lrZzvLzevG7wMkPqnTaJdGnNi+xmJV8MagRWGwfjcXzYF4LYd3mxzS730RsH
	sW6sfLFxaPsslaNVzPy6yYVUtsRo9Y0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-MMcq_F3yOrq10qgTxT_B9g-1; Tue, 03 Sep 2024 03:41:26 -0400
X-MC-Unique: MMcq_F3yOrq10qgTxT_B9g-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2f3f61b42c2so58404391fa.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 00:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725349284; x=1725954084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NmZGb+MA+mXou1jnaR60KfjaG6/mC67CXIvC/9dCxeQ=;
        b=EmxzBvNacbIIVwgbzkk6tHFkbowFUB+x3X5+TV22IMTGoBAXekYAPvYhk1W1DucMW0
         fCLJ2mruhlydpwaTC3El1b9tsn+NlYhkB+j756yXJrVY+5KsgOk9MBzXdyVwp2FRIRpX
         hK9zTURuAHWMJqg3Sql0AML6tiTIcs+Oje0fzKQfpUAvcKqpY8SjkuC6G4Y3dtZeBmCS
         KLUpsSEBGxvSgfvPQzz1F4ZYPxhztvJ+LL3dqqVZa6TelGsoIP9uIcp3A+n3UlZdT4IJ
         wVrdUHm5heH17rIoblc3Lyx8jpMVHzl7DOf5fI4FAH7HpoEhvjWd7fQgHQGWpWXlkuj5
         4R3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUWwDSEG2mQkE/ja6RPxZfzK5GVmC3dTxEMFkHlKG6LQUb03X/SiA5QKwZHTqL3GD8UUIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuutUL3BBfr6i+7IxyRdehc+7zkHD4JPM95caerwh/MoGgU5qh
	cMCiAOnAaZGgUWINBM/+egKMlaJ9iSuMQBplsiOq71SOy1KofzrprW5DzSoh+AP2aH26NrZeE3Q
	Or1lo+4bkyz3UY+DEAcAj11/Q17ctX7R8DfX8EI07tC081wdfDi9nk5Ye0hk3wib+Nz8qcj696E
	uy5ugj4xt5MdnfxG4AmE9GLHbt6jUoDiEt9RslTodE
X-Received: by 2002:a2e:a9a8:0:b0:2f3:ed2d:a944 with SMTP id 38308e7fff4ca-2f6105d7638mr150706171fa.15.1725349284135;
        Tue, 03 Sep 2024 00:41:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+2y0Ox29ncWXSJQ27vWedil4q1hbIeNw26N6BH7DRSWODvYcgpZIEbdqPrK/1dWOWpcepNHdpzljzxOVI1xg=
X-Received: by 2002:a2e:a9a8:0:b0:2f3:ed2d:a944 with SMTP id
 38308e7fff4ca-2f6105d7638mr150705531fa.15.1725349283019; Tue, 03 Sep 2024
 00:41:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
 <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com> <ea127c85-7080-4679-bff1-3a3a253f9046@nvidia.com>
In-Reply-To: <ea127c85-7080-4679-bff1-3a3a253f9046@nvidia.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 3 Sep 2024 15:40:45 +0800
Message-ID: <CAPpAL=wDKacuWu-wgbwSN3MORSMapU8=RAdzp3ePgPo=6EMFbg@mail.gmail.com>
Subject: Re: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device suspend/resume
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Michael Tsirkin <mst@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 7:05=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> Hi Lei,
>
> On 02.09.24 12:03, Lei Yang wrote:
> > Hi Dragos
> >
> > QE tested this series with mellanox nic, it failed with [1] when
> > booting guest, and host dmesg also will print messages [2]. This bug
> > can be reproduced boot guest with vhost-vdpa device.
> >
> > [1] qemu) qemu-kvm: vhost VQ 1 ring restore failed: -1: Operation not
> > permitted (1)
> > qemu-kvm: vhost VQ 0 ring restore failed: -1: Operation not permitted (=
1)
> > qemu-kvm: unable to start vhost net: 5: falling back on userspace virti=
o
> > qemu-kvm: vhost_set_features failed: Device or resource busy (16)
> > qemu-kvm: unable to start vhost net: 16: falling back on userspace virt=
io
> >
> > [2] Host dmesg:
> > [ 1406.187977] mlx5_core 0000:0d:00.2:
> > mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
> > [ 1406.189221] mlx5_core 0000:0d:00.2:
> > mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
> > [ 1406.190354] mlx5_core 0000:0d:00.2:
> > mlx5_vdpa_show_mr_leaks:573:(pid 8506) warning: mkey still alive after
> > resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> > [ 1471.538487] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
> > 428): cmd[13]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
> > a leak of a command resource
> > [ 1471.539486] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
> > 428): cmd[12]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
> > a leak of a command resource
> > [ 1471.540351] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
> > 8511) error: modify vq 0 failed, state: 0 -> 0, err: 0
> > [ 1471.541433] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
> > 8511) error: modify vq 1 failed, state: 0 -> 0, err: -110
> > [ 1471.542388] mlx5_core 0000:0d:00.2: mlx5_vdpa_set_status:3203:(pid
> > 8511) warning: failed to resume VQs
> > [ 1471.549778] mlx5_core 0000:0d:00.2:
> > mlx5_vdpa_show_mr_leaks:573:(pid 8511) warning: mkey still alive after
> > resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> > [ 1512.929854] mlx5_core 0000:0d:00.2:
> > mlx5_vdpa_compat_reset:3267:(pid 8565): performing device reset
> > [ 1513.100290] mlx5_core 0000:0d:00.2:
> > mlx5_vdpa_show_mr_leaks:573:(pid 8565) warning: mkey still alive after
> > resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> >

Hi Dragos

> Can you provide more details about the qemu version and the vdpa device
> options used?
>
> Also, which FW version are you using? There is a relevant bug in FW
> 22.41.1000 which was fixed in the latest FW (22.42.1000). Did you
> encounter any FW syndromes in the host dmesg log?

This problem has gone when I updated the firmware version to
22.42.1000, and I tested it with regression tests using mellanox nic,
everything works well.

Tested-by: Lei Yang <leiyang@redhat.com>
>
> Thanks,
> Dragos
>


