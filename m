Return-Path: <kvm+bounces-35933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4200A1659D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 04:23:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DCB71886080
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 03:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1256613D297;
	Mon, 20 Jan 2025 03:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IOj+DmVs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FCA12C470
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 03:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737343382; cv=none; b=LASQ/fqHu8RrqUBbngTIj0XM6+kPyrNRn4ULTfDBaE/EkaIwILfbYrLt9I5T6Jw8veEuZmTHa9W9EzKbopzxkOLDa8VBCeaSE32ohl3D9li52LU/gva6+quYOOI7DepKEz/WsVfWMaSTJoIbEsQu/kai94uG+XuXXlRm/g+rAVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737343382; c=relaxed/simple;
	bh=F6ciFg3hAuwdX0ZKemRnI7x9YzSzb9QiCt4f93x+6OI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOuBXv77Fz7n89eK5KWCm9eGOvi5AijK23cJBlClN50RN/UGCvXVdPIS7KsfjB6jXViFsMtC513TQz3V7v/VbbxcDltX8qJNmciCyJtdOPFHUp6vRaAo05+JyUEtTmv1rxWSB6VUuEC1Z6A2BPr9CvFg4zgLSnch1UnUzhoTz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IOj+DmVs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737343379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pwwl19AaaKu4HzuuwrsgT5HElZKZa/OIvc4KEOt9e80=;
	b=IOj+DmVsvCTZW8LW+O5fhYHvUlvC4YrycVjgszd30n4Twg9aFtJhcqJ3XwTAULLFaoZCZg
	HYtwMxo9/0oYefIX+vwZDpMscvAgZo7p4k9xmwtty/cks3+IiFYNEMvOguzsZPnjFBKqbf
	tT7DjiByVcys7a1CQhuWKgFHpYDjB/0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-Qh_jk2FNM-i80E1a3Fvtcw-1; Sun, 19 Jan 2025 22:22:56 -0500
X-MC-Unique: Qh_jk2FNM-i80E1a3Fvtcw-1
X-Mimecast-MFC-AGG-ID: Qh_jk2FNM-i80E1a3Fvtcw
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ce848b708fso3456525ab.3
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 19:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737343376; x=1737948176;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pwwl19AaaKu4HzuuwrsgT5HElZKZa/OIvc4KEOt9e80=;
        b=fuSWxTHDknSp6/tosXQayjdg4/e5++lhBo4hWO0wO5ocowx2m6fEdnNVM5U3ViKKlF
         i2NcvQrlIizIqRgTK24aZrvW18k/6y5SydbwOHyiUq5ohFJlap5ITSsXBarclyc2+pip
         J6XBu+DHvDZqDwQDiCExF52/TikWnIx0P5dMbYC7gQc7aZI3PbcvV2LxznMgTj4PfSKH
         5f2Dh6AYVLiySmp/uizRxJcmrrlTrrRopI8ba2uHqAsgJxO20m8YydkU+KS1vfjRk0W7
         BoQ6EzBlpEzBYGCih3xS2jwboMX7QKHFfIHv9ZmSer89klaH2H0ccG3M1bi3Ovn53jzR
         Eqmw==
X-Forwarded-Encrypted: i=1; AJvYcCVaZYBny9er4vs2r5YX/i9cl7Ho9i8GsKGQIAGjIMaALEzY7lXeUhdbuuy+OjG+c7dVgtc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0BZwYwCg7XUKEJS3C6g+68kHmOlFJjKC5LfPU4FuMrRmnKD2w
	yi9tFM6l4ve1U0rritIVSQAgOreDP97AUU9mtMPZ1CAap5h0NJQ14a5MZz1H4A2Iyv7C+cSsKdd
	zMXxn1L2GomxZCYH8VZb1RpKd6MQ/sYVO9lxNlXILsk5xxDp/Wg==
X-Gm-Gg: ASbGncsYhQqSuLvI3T4ATCjXa4bW2qVMnYJyAGiPSH2tW2i45+d3F8BH/Lk7WNvoxsg
	pq/7yjASILoI8dcbd/bn80p6HjRH5JfMibmuuaSCJ9VKgzUC2lchc3no20eFJGiamjMzQe/Q6u9
	iOth2RYqao7BRM+RKu2ZDsCHdMO90nsOfONzunrqr4gWclfLA9vBwqZBkxB/u/szIRTV80elKFU
	TkXAI50QwwpZaMDrKQ5JCsR9ATVSHJnFwhHhhVBZL9OGl2pRj3yHRpcQDCJqMe7te2An19oog==
X-Received: by 2002:a92:c24b:0:b0:3ce:7881:8e4f with SMTP id e9e14a558f8ab-3cf74491fc3mr23599205ab.4.1737343376245;
        Sun, 19 Jan 2025 19:22:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFoy+f7ncR9DdVnV/msIVRo2MH5BTJNYOLGY5guqVOfx8Pb5teqSByGFWH5WOALwTRkCpuUQ==
X-Received: by 2002:a92:c24b:0:b0:3ce:7881:8e4f with SMTP id e9e14a558f8ab-3cf74491fc3mr23599155ab.4.1737343375891;
        Sun, 19 Jan 2025 19:22:55 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea753f65e0sm2220375173.13.2025.01.19.19.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 19:22:54 -0800 (PST)
Date: Sun, 19 Jan 2025 20:22:52 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
 <kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
 <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
 <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Dan Williams <danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)"
 <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250119202252.4fcd2c49.alex.williamson@redhat.com>
In-Reply-To: <20250119201232.04af85b2.alex.williamson@redhat.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
	<20250117233704.3374-4-ankita@nvidia.com>
	<20250117205232.37dbabe3.alex.williamson@redhat.com>
	<SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20250119201232.04af85b2.alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Jan 2025 20:12:32 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 20 Jan 2025 02:24:14 +0000
> Ankit Agrawal <ankita@nvidia.com> wrote:
>=20
> > >> +EXPORT_SYMBOL_GPL(vfio_pci_memory_lock_and_enable);
> > >>
> > >>=C2=A0 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_d=
evice *vdev, u16 cmd)
> > >>=C2=A0 {
> > >>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_write_config_word(vdev->pdev=
, PCI_COMMAND, cmd);
> > >>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_write(&vdev->memory_lock);
> > >>=C2=A0 }
> > >> +EXPORT_SYMBOL_GPL(vfio_pci_memory_unlock_and_restore);
> > >>
> > >>=C2=A0 static unsigned long vma_to_pfn(struct vm_area_struct *vma)
> > >>=C2=A0 {   =20
> > >
> > > The access is happening before the device is exposed to the user, the
> > > above are for handling conditions while there may be races with user
> > > access, this is totally unnecessary.   =20
> >=20
> > Right. What I could do to reuse the code is to take out the part
> > related to locking/unlocking as new functions and export that.
> > The current vfio_pci_memory_lock_and_enable() would take the lock
> > and call the new function. Same for vfio_pci_memory_unlock_and_restore(=
).
> > The nvgrace module could also call that new function. Does that sound
> > reasonable? =20
>=20
> No, this is standard PCI driver stuff, everything you need is already
> there.  Probably pci_enable_device() and some variant of
> pci_request_regions().
>=20
> > > Does this delay even need to happen in the probe function, or could it
> > > happen in the open_device callback?=C2=A0 That would still be before =
user
> > > access, but if we expect it to generally work, it would allow the
> > > training to happen in the background up until the user tries to open
> > > the device.=C2=A0 Thanks,
> > >
> > > Alex   =20
> >=20
> > The thought process is that since it is purely bare metal coming to pro=
per
> > state while boot, the nvgrace module should probably wait for the start=
up
> > to complete during probe() instead of delaying until open() time. =20
>=20
> If the driver is statically loaded, that might mean you're willing to
> stall boot for up to 30s.  In practice is this ever actually going to
> fail?  Thanks,

On second thought, I guess a vfio-pci variant driver can't
automatically bind to a device, whether statically built or not, so
maybe this isn't a concern.  I'm not sure if there are other concerns
with busy waiting for up to 30s at driver probe.  Thanks,

Alex


