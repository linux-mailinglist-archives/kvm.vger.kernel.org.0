Return-Path: <kvm+bounces-4134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8267F80E2DE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 04:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3975028254A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95759467;
	Tue, 12 Dec 2023 03:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jo0hKuo4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3B1CD
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 19:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702352391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SYJnIxx9HNtjukWsV4aCNXJVjuhHUs4t6AEcodIHtHc=;
	b=Jo0hKuo4Z4bhHCg47HcWXq8aul0Bf14yoSGKXBI4Yf4xnw5xfL0O4RVJQgQ+2ENBD32HAA
	sPerTNw4JrARl+RKYrYCUMX/Da3LHXYQuH+E+VwFvUGoqSdLouQ1Vmsj0r6AsrEDz+aVCY
	9qkLque4gfIfPwZXIC1igU9kPw/u2DA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-fBJ-f-y1NHS2akoNxDJTPQ-1; Mon, 11 Dec 2023 22:39:49 -0500
X-MC-Unique: fBJ-f-y1NHS2akoNxDJTPQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7b71ab7c6b9so579475839f.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 19:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702352388; x=1702957188;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SYJnIxx9HNtjukWsV4aCNXJVjuhHUs4t6AEcodIHtHc=;
        b=mdNgQP4xNYHbK997/EXVS9um/bOBRdnLBREmsy6sBUjEnHaL5DRT/BVtmq+7+Snrcz
         ax3+ZG+XYCAEeRX9YwXeQ5VrnT5Zk0FFVrUrFrUZS0+nkrcvyEzBQYVab0RV1AEnbH2l
         z1GFVOoOYLF7hWoxeLuKcKcZBqANs4EUNsP/fFGWJOy5fQ/4AGc7/XUvUxMs0jG+nbCO
         LvGERup3HTLeLAxF6CjtS/L480Dxqaj/mCm9BhTRL6nK6HDtdmIJnxVn5K6YI0/k8+fc
         5AkPY/F0C5cf72jQMTFY9/qcNbLGxJv2rPMCaKWE150EWueHQkCN8mSuHoMupGZaI42v
         dPJg==
X-Gm-Message-State: AOJu0YzCWM4tCxQxNE+FeNv2tnzx1WfgKLDncRFKnr+YSunV5VWK0RI3
	jC46iHbuYBPvxPqgZxJ/LNimTeKrUal2iHUu9M7iAm5KB6iUQ9bQe8qyjqrZz4JD/9Mc+FgeIPt
	Ubl4wrVyAQnFB
X-Received: by 2002:a6b:dd19:0:b0:7b7:1db4:be12 with SMTP id f25-20020a6bdd19000000b007b71db4be12mr6454360ioc.27.1702352388274;
        Mon, 11 Dec 2023 19:39:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZ71ahGWruZR9wQXJoOb1wDE8WklJ6ZoG4h11zsbQ+dgua70VtFkqtegvadsapT7fi8mxQuQ==
X-Received: by 2002:a6b:dd19:0:b0:7b7:1db4:be12 with SMTP id f25-20020a6bdd19000000b007b71db4be12mr6454342ioc.27.1702352388042;
        Mon, 11 Dec 2023 19:39:48 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fw16-20020a0566381d9000b0043978165d54sm2242042jab.104.2023.12.11.19.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 19:39:47 -0800 (PST)
Date: Mon, 11 Dec 2023 20:39:46 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "cohuck@redhat.com" <cohuck@redhat.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
 <nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>, "peterx@redhat.com"
 <peterx@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "lulu@redhat.com"
 <lulu@redhat.com>, "suravee.suthikulpanit@amd.com"
 <suravee.suthikulpanit@amd.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
 <linux-kselftest@vger.kernel.org>, "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>, "Zeng, Xin" <xin.zeng@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 3/3] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20231211203946.35552183.alex.williamson@redhat.com>
In-Reply-To: <SJ0PR11MB674458A8B7319F30A67FE55F928EA@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20231127063909.129153-1-yi.l.liu@intel.com>
	<20231127063909.129153-4-yi.l.liu@intel.com>
	<20231211110345.1b4526c6.alex.williamson@redhat.com>
	<SJ0PR11MB674458A8B7319F30A67FE55F928EA@SJ0PR11MB6744.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Dec 2023 02:43:20 +0000
"Duan, Zhenzhong" <zhenzhong.duan@intel.com> wrote:

> >-----Original Message-----
> >From: Alex Williamson <alex.williamson@redhat.com>
> >Sent: Tuesday, December 12, 2023 2:04 AM
> >Subject: Re: [PATCH 3/3] vfio: Report PASID capability via
> >VFIO_DEVICE_FEATURE ioctl
> >
> >On Sun, 26 Nov 2023 22:39:09 -0800
> >Yi Liu <yi.l.liu@intel.com> wrote:
> >  
> >> This reports the PASID capability data to userspace via  
> >VFIO_DEVICE_FEATURE,  
> >> hence userspace could probe PASID capability by it. This is a bit different
> >> with other capabilities which are reported to userspace when the user  
> >reads  
> >> the device's PCI configuration space. There are two reasons for this.
> >>
> >>  - First, Qemu by default exposes all available PCI capabilities in vfio-pci
> >>    config space to the guest as read-only, so adding PASID capability in the
> >>    vfio-pci config space will make it exposed to the guest automatically  
> >while  
> >>    an old Qemu doesn't really support it.  
> >
> >Shouldn't we also be working on hiding the PASID capability in QEMU
> >ASAP?  This feature only allows QEMU to know PASID control is actually
> >available, not the guest.  Maybe we're hoping this is really only used
> >by VFs where there's no capability currently exposed to the guest?  
> 
> PASID capability is not exposed to QEMU through config space,
> VFIO_DEVICE_FEATURE ioctl is the only interface to expose PASID
> cap to QEMU for both PF and VF.
> 
> /*
>  * Lengths of PCIe/PCI-X Extended Config Capabilities
>  *   0: Removed or masked from the user visible capability list
>  *   FF: Variable length
>  */
> static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
> ...
>         [PCI_EXT_CAP_ID_PASID]  =       0,      /* not yet */
> }

Ah, thanks.  The comment made me think is was already exposed and I
didn't double check.  So we really just want to convey the information
of the PASID capability outside of config space because if we pass the
capability itself existing userspace will blindly expose a read-only
version to the guest.  That could be better explained in the commit log
and comments.

So how do we keep up with PCIe spec updates relative to the PASID
capability with this proposal?  Would it make more sense to report the
raw capability register and capability version rather that a translated
copy thereof?  Perhaps just masking the fields we're currently prepared
to expose.  Thanks,

Alex


