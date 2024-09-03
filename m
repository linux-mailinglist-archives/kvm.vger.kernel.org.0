Return-Path: <kvm+bounces-25723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAACE969696
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 920F6285E3F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0914A205E2C;
	Tue,  3 Sep 2024 08:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1mW0ifZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19C920125C
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351052; cv=none; b=VUqjsOv8NKC6+78+zF2rSX5itDU/2nBk62xnqG9cCIL48nXTq6Ep3eokQ9G2BpJR7hkz0Faj9Cl8HNNwwkdgagk8IUvuYhFfHjN5/8blkTq7/ySeRR/ZbAaMrkePjh+2DiZjEmSOTJoiqoCfUTQy8BL9WdShfAN4iU1P2iZf9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351052; c=relaxed/simple;
	bh=6mmc7di+pQIdeFxJ+VyEzy/XD6Ldgilncnnc07MXG7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EsD1F5FSUe+EDt3EsghZbUVDJJXwWGR5Kiqit3lAgQ9MWUWXsN8Ypv1XjTRZtQYapDysT2hppEF8JARUQCxwOyMSduXlEOIDUub731P4ot7F0oMoKNWZXIU3XZCkNC5Yqomtp+DJpFVULGI4jTvdHgHIOqhjTdNiMjkx/+ffs94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1mW0ifZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725351049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6mmc7di+pQIdeFxJ+VyEzy/XD6Ldgilncnnc07MXG7c=;
	b=L1mW0ifZmfrMa8n6D7eMnQrSn7CTGqEjiyzdhdTrm9YCnV4xe+a1witRws0ge65C52gPx0
	QDCLTqpf21+K7kPB5DKXNe38BRBPt7FXBveuEvQNBvLgx3teAo8oApIyyEyEAb6fQsVBMX
	I53kseAUFqCW24rqdJLTxbvQvGuqoDc=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-zhvqTg-9MaCphpDr7_XqAA-1; Tue, 03 Sep 2024 04:10:48 -0400
X-MC-Unique: zhvqTg-9MaCphpDr7_XqAA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-6d5fccc3548so26599447b3.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 01:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725351048; x=1725955848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mmc7di+pQIdeFxJ+VyEzy/XD6Ldgilncnnc07MXG7c=;
        b=L26ylb154kj05m0IIyBjR323IAvY1daCtptStsJUAGxiVkeHuHGth108VOQEcMULX6
         UndEvNFgidxmjgjfF0Ex8fKOcMqnxY5vISxxH1PYlfkdSa+nO7s5C4gY3GFn4HMS+ras
         JOUpjdmHIA7PY/aF5kWTAxIitrFloOJsv2nIa3xjBNf2jeNI7s/IBIX0hqvl0xygIqNI
         5M4hwXUOPuWdAkWZMbOeDAiVlHR3IKcco2DZrUKgE8DEF7ESscGf8snqpa/HLANoxj9d
         PP7WdM2ArGwyoEDiF71WQp1Gsf40NwaikoVfiPrNTTl5wdRHdKmsDL0OtBTVWpzeMFEp
         +P6w==
X-Forwarded-Encrypted: i=1; AJvYcCWIPQId8wAvu3GV+v+TQpHA/qurFlL3z/lo9QLoxTvaMiWO4606ynyjWLdq2p0TYAwSQvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUikIOEeSxSrypIcJq4b+/6QEhKtyAWuRcOQdkIf+FX38BsaDs
	hRYDJKichjybW8ZCmGsf6ReaxRAZbkvCzqk/j1FAsoIUOG3pmcrJs0GcaEZaL6gAhRf2HDwD6XT
	l6PPU2FTTDN/AfPb7+rMDX7s4c1wwQzbsDMqDX1YT4pK8O1lF7mci4/j3TcbnKmQBL67/z2oecQ
	NJU8N/iVbo3IKvKYZ/d9c6UlRU
X-Received: by 2002:a05:690c:6089:b0:65f:cdb7:46a7 with SMTP id 00721157ae682-6d3fb00cd8dmr106367567b3.22.1725351047951;
        Tue, 03 Sep 2024 01:10:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8YUCke3AcOv2qy5ss1glBiO/5O8+6bG94dYgmaYGhOtdUneJ8MXedoPtfwNtK/AfOFzg2JTuMsyHPl+8F7HI=
X-Received: by 2002:a05:690c:6089:b0:65f:cdb7:46a7 with SMTP id
 00721157ae682-6d3fb00cd8dmr106367467b3.22.1725351047631; Tue, 03 Sep 2024
 01:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
 <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com>
 <ea127c85-7080-4679-bff1-3a3a253f9046@nvidia.com> <CAPpAL=wDKacuWu-wgbwSN3MORSMapU8=RAdzp3ePgPo=6EMFbg@mail.gmail.com>
 <e08c5cc6-27e7-43b7-8337-095a42ed9698@nvidia.com>
In-Reply-To: <e08c5cc6-27e7-43b7-8337-095a42ed9698@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 3 Sep 2024 10:10:11 +0200
Message-ID: <CAJaqyWd-gc+BDx+DWvBLOEYP+q_Rb+L5n4txf1fcvrcbcE=_Nw@mail.gmail.com>
Subject: Re: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device suspend/resume
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Lei Yang <leiyang@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Michael Tsirkin <mst@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 9:48=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
>
>
> On 03.09.24 09:40, Lei Yang wrote:
> > On Mon, Sep 2, 2024 at 7:05=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.=
com> wrote:
> >>
> >> Hi Lei,
> >>
> >> On 02.09.24 12:03, Lei Yang wrote:
> >>> Hi Dragos
> >>>
> >>> QE tested this series with mellanox nic, it failed with [1] when
> >>> booting guest, and host dmesg also will print messages [2]. This bug
> >>> can be reproduced boot guest with vhost-vdpa device.
> >>>
> >>> [1] qemu) qemu-kvm: vhost VQ 1 ring restore failed: -1: Operation not
> >>> permitted (1)
> >>> qemu-kvm: vhost VQ 0 ring restore failed: -1: Operation not permitted=
 (1)
> >>> qemu-kvm: unable to start vhost net: 5: falling back on userspace vir=
tio
> >>> qemu-kvm: vhost_set_features failed: Device or resource busy (16)
> >>> qemu-kvm: unable to start vhost net: 16: falling back on userspace vi=
rtio
> >>>
> >>> [2] Host dmesg:
> >>> [ 1406.187977] mlx5_core 0000:0d:00.2:
> >>> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
> >>> [ 1406.189221] mlx5_core 0000:0d:00.2:
> >>> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
> >>> [ 1406.190354] mlx5_core 0000:0d:00.2:
> >>> mlx5_vdpa_show_mr_leaks:573:(pid 8506) warning: mkey still alive afte=
r
> >>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> >>> [ 1471.538487] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
> >>> 428): cmd[13]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will caus=
e
> >>> a leak of a command resource
> >>> [ 1471.539486] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
> >>> 428): cmd[12]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will caus=
e
> >>> a leak of a command resource
> >>> [ 1471.540351] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
> >>> 8511) error: modify vq 0 failed, state: 0 -> 0, err: 0
> >>> [ 1471.541433] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
> >>> 8511) error: modify vq 1 failed, state: 0 -> 0, err: -110
> >>> [ 1471.542388] mlx5_core 0000:0d:00.2: mlx5_vdpa_set_status:3203:(pid
> >>> 8511) warning: failed to resume VQs
> >>> [ 1471.549778] mlx5_core 0000:0d:00.2:
> >>> mlx5_vdpa_show_mr_leaks:573:(pid 8511) warning: mkey still alive afte=
r
> >>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> >>> [ 1512.929854] mlx5_core 0000:0d:00.2:
> >>> mlx5_vdpa_compat_reset:3267:(pid 8565): performing device reset
> >>> [ 1513.100290] mlx5_core 0000:0d:00.2:
> >>> mlx5_vdpa_show_mr_leaks:573:(pid 8565) warning: mkey still alive afte=
r
> >>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> >>>
> >
> > Hi Dragos
> >
> >> Can you provide more details about the qemu version and the vdpa devic=
e
> >> options used?
> >>
> >> Also, which FW version are you using? There is a relevant bug in FW
> >> 22.41.1000 which was fixed in the latest FW (22.42.1000). Did you
> >> encounter any FW syndromes in the host dmesg log?
> >
> > This problem has gone when I updated the firmware version to
> > 22.42.1000, and I tested it with regression tests using mellanox nic,
> > everything works well.
> >
> > Tested-by: Lei Yang <leiyang@redhat.com>
> Good to hear. Thanks for the quick reaction.
>

Is it possible to add a check so it doesn't use the async fashion in old FW=
?


