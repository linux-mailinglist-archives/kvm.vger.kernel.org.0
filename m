Return-Path: <kvm+bounces-58354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D554B8F113
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26D637A7C1B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 06:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FBFB27467D;
	Mon, 22 Sep 2025 06:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhRnF6ng"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AF224A063
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 06:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758520977; cv=none; b=VmSJCXnP74TJxeyMvXGyh5lieaoIOkKcFeHfmoi1CdPMu12tTduE/wSVRXHohnAHeGpxh7UnOnCVFl8a+QPXgESx+jrc7AABB1rrkXc5Zn3qLzay4qnzyJXxLO++FuTVovEKldPd24uxe9wuwGIjpF4ZrH1Y1+Tt8v4fM0zifHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758520977; c=relaxed/simple;
	bh=Sg2ZhJJNOixI58F9DAvglK5f8T6LuEby3v5Alaffuzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rRqZgmcpvQhxEWnezmo3r6TT88DNxsqtFZocC2ZumPq1e8m9W07iK8e4hMUGx8s8i3FgEN45pkUJNB77ldN7LKWO2+hll0cFgK/hPHO4ZlLepPJR3rPWaPQyG20rXNz4UTeLq8AD2Pt77F9o0eZJDJaQYSL0ov8iWbRdfGmw9DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhRnF6ng; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758520974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXtgiVIDZQsTyx5yaIcOjWi6WHQD/mD1mUw/FWs9+uA=;
	b=BhRnF6ngQo83d+KJ6TkL3Okph81Q0RCVZ+uOm15wiHcBI2r/nxo7IiJLoxj5m1aKoR/ijd
	mdxPI3RxT2XeKgLKVy4gB9RA/PwuJIZK0pjNh7ehxQymP42GfEQtXZYObWZ0sLJFlz9CNI
	9PyBBpLUKxdtaPJFQeqNgz/G8coteyA=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-gWDsHRHiP9OBPekpvvJGRA-1; Mon, 22 Sep 2025 02:02:52 -0400
X-MC-Unique: gWDsHRHiP9OBPekpvvJGRA-1
X-Mimecast-MFC-AGG-ID: gWDsHRHiP9OBPekpvvJGRA_1758520971
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e934323e6d8so5870965276.0
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 23:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758520971; x=1759125771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hXtgiVIDZQsTyx5yaIcOjWi6WHQD/mD1mUw/FWs9+uA=;
        b=DqyzjS4/8dppOH1mSPE9MBniUv5lId/0Olb8HIlLklWZYXnP5l0FsqRNupEYoBLkMZ
         QuFsogxOUnHwgYaof6thsEFCwJMT5Sb4WL9BGbOczu5J7246G3Aqz/pn6JK1GhSya10R
         GHjEW1c0qHLS9ruo6K0UoFcz3HwBr5ZAd06ZXiASPBDnwfaHxvUvmAZsMz5QXwS9dHlZ
         yvrrQdcpwOw+20Cbi+AlzXtI8uLo0L5MGhwZcjbDBnBROtDVfhO+hCwFjuIWdwEqCI8O
         dYmip8j9US9wY2S0+hsPhgiKJIw3Uir4Svru1J5v3u7wz+ccreERkaLCGYpt6nWW7gQH
         jtnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAIEWPUtsmZVAD2CQNX96D050mfb9AKk6S3TzkDXKUjhWCpFP1k6ia8YVZvPiuJfuUCyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLzhwpq8NJGDEIkX0my6Ks5fd1nwe7ksWxjK845tWtSN199OvS
	kzVE0Fwm0RLeMUrqZAH2ZJX9LbCruX4onjjNmVXpbz1prd9jLIDiI/w8/d8UV91QmB1UIgXclHL
	R5mOlFFyoqd1CjmDFDJeDOT4/8MFE624rfj5c4sEYjYrPziFYMh90p+TMTiOVZjN056ChWMfJXi
	cxz9hRaswuNacUOv3PInmcKU4xTwq6
X-Gm-Gg: ASbGnctFkOYGUZeO39j8QQpMedI10ppUiR5iQjUb3VUolyQ+GAPNOcOy098vT1AkNiH
	0AO+TyKlgum+smf15/AVa/qNHPuLwvgUlrhI5ozcShgCdxO+5NpOesObq/OIt/s2SIIJOvtunVR
	eV/PU0/jXUKkKIUy8GxJQaIHyWEAScKNAOcFyZkTenFbPPGEQc+oBhh9jIpV1mrwf4HH7ASj7PO
	Un2M3oL
X-Received: by 2002:a05:690e:1542:20b0:633:b9eb:85e9 with SMTP id 956f58d0204a3-6347f6ba46cmr8112821d50.32.1758520971444;
        Sun, 21 Sep 2025 23:02:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0kBUfTEwsGXZ2XE31k1sbK8b37mZcOhbe2/vAmhg4wuOIDphXzxvRzQgRorZGwG9/RWuF10EUngTVdtkcfO0=
X-Received: by 2002:a05:690e:1542:20b0:633:b9eb:85e9 with SMTP id
 956f58d0204a3-6347f6ba46cmr8112812d50.32.1758520971019; Sun, 21 Sep 2025
 23:02:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202509202256.zVt4MifB-lkp@intel.com> <20250921173047-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250921173047-mutt-send-email-mst@kernel.org>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 22 Sep 2025 08:02:13 +0200
X-Gm-Features: AS18NWCc_27M-TzG_mmHLopTufIzWqfZX3OigDEEb-tvxhI6YUlzAbD54FDcadY
Message-ID: <CAJaqyWcGLKoa0mWivac5BfBTJbyAnW14FvAmA0EteunidMc6NQ@mail.gmail.com>
Subject: Re: [mst-vhost:vhost 41/44] drivers/vdpa/pds/vdpa_dev.c:590:19:
 error: incompatible function pointer types initializing 's64 (*)(struct
 vdpa_device *, u16)' (aka 'long long (*)(struct vdpa_device *, unsigned
 short)') with an expression of type 'u32 (struct vdpa_device *, u16)' (aka ...
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 21, 2025 at 11:31=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Sat, Sep 20, 2025 at 10:41:40PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git v=
host
> > head:   877102ca14b3ee9b5343d71f6420f036baf8a9fc
> > commit: 2951c77700c3944ecd991ede7ee77e31f47f24ab [41/44] vduse: add vq =
group support
> > config: loongarch-randconfig-001-20250920 (https://download.01.org/0day=
-ci/archive/20250920/202509202256.zVt4MifB-lkp@intel.com/config)
> > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project=
 7c861bcedf61607b6c087380ac711eb7ff918ca6)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20250920/202509202256.zVt4MifB-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202509202256.zVt4MifB-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> > >> drivers/vdpa/pds/vdpa_dev.c:590:19: error: incompatible function poi=
nter types initializing 's64 (*)(struct vdpa_device *, u16)' (aka 'long lon=
g (*)(struct vdpa_device *, unsigned short)') with an expression of type 'u=
32 (struct vdpa_device *, u16)' (aka 'unsigned int (struct vdpa_device *, u=
nsigned short)') [-Wincompatible-function-pointer-types]
> >      590 |         .get_vq_group           =3D pds_vdpa_get_vq_group,
> >          |                                   ^~~~~~~~~~~~~~~~~~~~~
> >    1 error generated.
> >
>
> Eugenio, just making sure you see this. I can not merge patches that
> break build.
>

Absolutely, I forgot to enable all the vdpa drivers in my test. Silly
mistake, fixing it right now. Thanks!

> > vim +590 drivers/vdpa/pds/vdpa_dev.c
> >
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  577
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  578  static const struct vdp=
a_config_ops pds_vdpa_ops =3D {
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  579        .set_vq_address  =
       =3D pds_vdpa_set_vq_address,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  580        .set_vq_num      =
       =3D pds_vdpa_set_vq_num,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  581        .kick_vq         =
       =3D pds_vdpa_kick_vq,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  582        .set_vq_cb       =
       =3D pds_vdpa_set_vq_cb,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  583        .set_vq_ready    =
       =3D pds_vdpa_set_vq_ready,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  584        .get_vq_ready    =
       =3D pds_vdpa_get_vq_ready,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  585        .set_vq_state    =
       =3D pds_vdpa_set_vq_state,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  586        .get_vq_state    =
       =3D pds_vdpa_get_vq_state,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  587        .get_vq_notificat=
ion    =3D pds_vdpa_get_vq_notification,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  588        .get_vq_irq      =
       =3D pds_vdpa_get_vq_irq,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  589        .get_vq_align    =
       =3D pds_vdpa_get_vq_align,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19 @590        .get_vq_group    =
       =3D pds_vdpa_get_vq_group,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  591
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  592        .get_device_featu=
res    =3D pds_vdpa_get_device_features,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  593        .set_driver_featu=
res    =3D pds_vdpa_set_driver_features,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  594        .get_driver_featu=
res    =3D pds_vdpa_get_driver_features,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  595        .set_config_cb   =
       =3D pds_vdpa_set_config_cb,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  596        .get_vq_num_max  =
       =3D pds_vdpa_get_vq_num_max,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  597        .get_device_id   =
       =3D pds_vdpa_get_device_id,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  598        .get_vendor_id   =
       =3D pds_vdpa_get_vendor_id,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  599        .get_status      =
       =3D pds_vdpa_get_status,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  600        .set_status      =
       =3D pds_vdpa_set_status,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  601        .reset           =
       =3D pds_vdpa_reset,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  602        .get_config_size =
       =3D pds_vdpa_get_config_size,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  603        .get_config      =
       =3D pds_vdpa_get_config,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  604        .set_config      =
       =3D pds_vdpa_set_config,
> > 151cc834f3ddafe Shannon Nelson 2023-05-19  605  };
> > 25d1270b6e9ea89 Shannon Nelson 2023-05-19  606  static struct virtio_de=
vice_id pds_vdpa_id_table[] =3D {
> > 25d1270b6e9ea89 Shannon Nelson 2023-05-19  607        {VIRTIO_ID_NET, V=
IRTIO_DEV_ANY_ID},
> > 25d1270b6e9ea89 Shannon Nelson 2023-05-19  608        {0},
> > 25d1270b6e9ea89 Shannon Nelson 2023-05-19  609  };
> > 25d1270b6e9ea89 Shannon Nelson 2023-05-19  610
> >
> > :::::: The code at line 590 was first introduced by commit
> > :::::: 151cc834f3ddafec869269fe48036460d920d08a pds_vdpa: add support f=
or vdpa and vdpamgmt interfaces
> >
> > :::::: TO: Shannon Nelson <shannon.nelson@amd.com>
> > :::::: CC: Michael S. Tsirkin <mst@redhat.com>
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
>


