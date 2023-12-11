Return-Path: <kvm+bounces-4094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC0B80D8FA
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 101B5281F5E
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77F25103A;
	Mon, 11 Dec 2023 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CL3+qhbW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2D7E3
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702320594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XB9mhIvJlXIIux4LJMz0ThVUKKa3x07C77ea6R/b5W4=;
	b=CL3+qhbWdFALQhmyM2vBfmgPxZOzgAzYsJxg5sAEPbtRp03kDIDBZQZKre04jlPcd0FqRy
	qjN6Dmq4gOziEHFWlM5AvecMkvhCem3+MFllHtWJExKnh9xrpMAniEsJepEHGQkYb1k310
	JYbry6nYgoYnfp/F0U//Pnhmpq+cthE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-QabM_tEnMFmddg3WiwnNWg-1; Mon, 11 Dec 2023 13:49:52 -0500
X-MC-Unique: QabM_tEnMFmddg3WiwnNWg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7b34d2f6e07so524673439f.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:49:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320592; x=1702925392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XB9mhIvJlXIIux4LJMz0ThVUKKa3x07C77ea6R/b5W4=;
        b=tD/7GP2J/jNo8RoqGMa0HrX5PepNsle9rLSQhmiMNo+iZVya0LVXmUU5JjFNm8QLK1
         vf48SNlWrdP7DwSgctOJecc3eDt+Y3wsgHBSaEh71gucZTgy3BgjlaZt+fMTnnKooqxD
         vaZXxK571j0+8cpVeFwUHTeTV+76gsuL0l+mkYY+nlUNA+btW9iKF2XJWMsIwwbSdIAr
         4ZejS160keeWOdL33OimQO8a6TiSXF+WyesaDObO/mD2Q7md8PYDINr133FTvFdkgjSi
         X44Tsbx1Hnqq8oQactJArAC37f7OytkAWobnwVGhUHyXXzQD3gLdPBQQMo7mq4ZsN1vI
         X+3Q==
X-Gm-Message-State: AOJu0Yw/dc1r/DNysD8KvIu6weWy0l6kJiU4cOjlyIKosyRc1iF5RQu9
	O2Vtohbdptucjoj54NFlv5LJWb8OZQ2Zt6pvSS/DhsrwBW/kYcOk0Ux16g9RrM8Y8Mge0Qxh1rN
	6OqFoRk9y79NX
X-Received: by 2002:a05:6602:5c4:b0:7b7:cd9:69e4 with SMTP id w4-20020a05660205c400b007b70cd969e4mr5869244iox.17.1702320591919;
        Mon, 11 Dec 2023 10:49:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG9BStqyJrk+wPBnz2NVGzUjSM91G8zGRKaMo7y/fs+I/Qqz3zD2APq+aikOivF1KWpRzNeLg==
X-Received: by 2002:a05:6602:5c4:b0:7b7:cd9:69e4 with SMTP id w4-20020a05660205c400b007b70cd969e4mr5869225iox.17.1702320591628;
        Mon, 11 Dec 2023 10:49:51 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id k18-20020a056638371200b0046921815eb5sm2056817jav.62.2023.12.11.10.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 10:49:51 -0800 (PST)
Date: Mon, 11 Dec 2023 11:49:49 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
 robin.murphy@arm.com, baolu.lu@linux.intel.com, cohuck@redhat.com,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
 yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
 shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
 suravee.suthikulpanit@amd.com, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 zhenzhong.duan@intel.com, joao.m.martins@oracle.com, xin.zeng@intel.com,
 yan.y.zhao@intel.com
Subject: Re: [PATCH 3/3] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20231211114949.273b21c0.alex.williamson@redhat.com>
In-Reply-To: <20231211181028.GL2944114@nvidia.com>
References: <20231127063909.129153-1-yi.l.liu@intel.com>
	<20231127063909.129153-4-yi.l.liu@intel.com>
	<20231211110345.1b4526c6.alex.williamson@redhat.com>
	<20231211181028.GL2944114@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Dec 2023 14:10:28 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Dec 11, 2023 at 11:03:45AM -0700, Alex Williamson wrote:
> > On Sun, 26 Nov 2023 22:39:09 -0800
> > Yi Liu <yi.l.liu@intel.com> wrote:

> > >    the PF). Creating a virtual PASID capability in vfio-pci config space needs
> > >    to find a hole to place it, but doing so may require device specific
> > >    knowledge to avoid potential conflict with device specific registers like
> > >    hiden bits in VF config space. It's simpler by moving this burden to the
> > >    VMM instead of maintaining a quirk system in the kernel.  
> > 
> > This feels a bit like an incomplete solution though and we might
> > already posses device specific knowledge in the form of a variant
> > driver.  Should this feature structure include a flag + field that
> > could serve to generically indicate to the VMM a location for
> > implementing the PASID capability?  The default core implementation
> > might fill this only for PFs where clearly an emualted PASID capability
> > can overlap the physical capability.  Thanks,  
> 
> In many ways I would perfer to solve this for good by having a way to
> learn a range of available config space - I liked the suggestion to
> use a DVSEC to mark empty space.

Yes, DVSEC is the most plausible option for the device itself to convey
unused config space, but that requires hardware adoption so presumably
we're going to need to fill the gaps with device specific code.  That
code might live in a variant driver or in the VMM.  If we have faith
that DVSEC is the way, it'd make sense for a variant driver to
implement a virtual DVSEC to work out the QEMU implementation and set a
precedent.

I mostly just want us to recognize that this feature structure also has
the possibility to fill this gap and we're consciously passing it over
and should maybe formally propose the DVSEC solution and reference it
in the commit log or comments here to provide a complete picture.
Thanks,

Alex


