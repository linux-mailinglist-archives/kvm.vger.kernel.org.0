Return-Path: <kvm+bounces-8359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A24C84E6CD
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 18:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CDEBB29FE0
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F51823DE;
	Thu,  8 Feb 2024 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Daj4e0hN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCCC7EF19
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707413430; cv=none; b=hHRwrSXS78sv/h9XcKl0CYYMjaXYmZLlpmduP8bKG+JQDx46ma3/QYi0ZpMnaCU3AqnNeWVPV+V18t3XuAzTNoU6Dn4OjkAApsQjL8WD+426BqsFWsCE76QmWLY/eRo5ncTLWZRTAnHAyiD2/YDH5SK+solxMiqTKZcbNhaB4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707413430; c=relaxed/simple;
	bh=KCRPEybqpLTnPIWw5roFcTQswnqgqagIK2IZEulcn+I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FBZsuTJ/ZftdWfWJftVXU/pQI57Da73f/bB6cvMJuzNFT0+ofsB9eaCb//mO6OThO1HPjNdc1Z3/Bd5ESDK8ShfNUq+F0jZzQ/CK6izLMm3IIYrX56opQn7c7AbnNAs0OnIh25xxSbkzo/kcozgbPqe/+vhPd+QQgFDx8RCqgus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Daj4e0hN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707413427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WO5yVARso2Jg8Z0OQG5achjKt7tNGYabD1QNw/gc16k=;
	b=Daj4e0hNnbtuw1hN2W/ULHNpainup4niQbuRGxVrAwM7RKWIn2gIVUUHAx+ET5NgSrhbKN
	AKs9FAbkxwC4jiITNxnrNmOSMdRBqruXfjLDZxBTi4Wk4pT+SlZrq5pJTI0DSRhjEvEr+5
	tYify7C7vFpF++HK82KdumbYh6Kjqqs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-FMP39uP-PqCTWidoZQ2-jQ-1; Thu, 08 Feb 2024 12:30:26 -0500
X-MC-Unique: FMP39uP-PqCTWidoZQ2-jQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7becfc75cd4so167560339f.3
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 09:30:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707413425; x=1708018225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WO5yVARso2Jg8Z0OQG5achjKt7tNGYabD1QNw/gc16k=;
        b=s20eszs6fOG9Tt4JLrzu5hjyBXuVtAznnL6tsu94GJv47ov/e7gAifxuKZWOVe+870
         2CKdMSCXTaPCrl9oSw51JDDIbMLngORzklhM4MJZETJVUJVRVj+olXqD6M71BkKyOW0+
         4MQt1+/9edjI3pCSRKMvwaInfQqtpk1c8IO/TrulCfkmZpOl8xL22YjEhptlpxBsv6Q8
         CLEmwUEZVmxc02+8xQwq+n+0XAW2412iTVGKxd+Y44szy+iesey7dJW4ukUkS50YUIWa
         CrtTpr4evzf+A1aCRXabZbB2unfXoDRdYViRWxAfG7NF+S4NnXdsvB17V84q955CS6Y0
         MO4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+VA2JjXmIh3sQVVD7odawb32fL75rKqRgeoipq10PiIc9DppLyFk29AKWsMhOX7ovEOewT3YuhmNztlcCtRsjOBYW
X-Gm-Message-State: AOJu0YxNeWjmRFdiwSHXbUpfrIDQWlSVr9xwGvfe09wF9JY/k1NUSBJh
	DtZ+/AHSnQt/nsmKRT0hE+UIQUQdLyUkWzr0QqyRBfoy8ug7/cYbO0ESCYixPCq7H2sayaR+isM
	w95QK0kQGFBxZTIQSQ4exDDCoChUHe+7gIye2FUHNmH0dp55EzA==
X-Received: by 2002:a5e:c015:0:b0:7c3:ec35:8df7 with SMTP id u21-20020a5ec015000000b007c3ec358df7mr316081iol.3.1707413425279;
        Thu, 08 Feb 2024 09:30:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5cjmBmVzOqD9itRTqfUhfQRTZ1e6fo4necDLXqiHFxdWo0ezcppkqw1/b39eYhNrgHWeqZA==
X-Received: by 2002:a5e:c015:0:b0:7c3:ec35:8df7 with SMTP id u21-20020a5ec015000000b007c3ec358df7mr316054iol.3.1707413425002;
        Thu, 08 Feb 2024 09:30:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXsISWUx7+IbC4yWXLMIWdDubVunoNs0LamFRSmQHr/gq05or7/HwqOdJrrI7pQBSHJpi9tpnPqrfcgnndV++FpnI0A+XQmbrKQ43C4hGgaLaPvagxEPWQLWW56VJoy6E7RsYEFYxz9pjZSy+AjG0QWEIlNERpQxR5S3LZcgAzNBjq1hMLhXa/UFH/xd/a1SSxG4Q8k2nPztDLBNUInVOQkxtBcKotGfo7OKFejQfUS6h1J9OoM8ESlyTBQQ5w1IUAJtfga9XvDD70WSfCy4nqvj6SZjjA/SBVVIou7d1Bu8R2QyUMtY/8PHHGw7uTNsYp+OjNEv72Hai3e60llbXarCHiFbpbTD/Vo7YXdORPvdUR6Xqs2hQvGpQUtd8D7xgmnTXZXtrqEjty5iXgh72u5BXKPCFIMsRmpI63NtWN1V1iNchA4B0vUSI4uhi868kHoZqWoWuFoVXKfvEPf8tzSJMq/8VC63Znrj7a7j1jDE3AHby3SDniICgaLs1W401btgaav0KbqJyitTzx7irAEuL5xwNv2ftYUvxCykaFHMYvwJ/KDKnMOT7iydK21L8gd4e/joTLvoiyB+dEZhMtl/lpTVpUWtcvqsHpE9BssR269GYgXBUnsakMQJD4ltrWn3JYGgpIqLcYILsChNywx8xGPJydZi71+SxB40Nk1GXnJY+uD4taEfwa4FViWKOrtvPA6+txZ3hwmQkM2iZOFZMrhYKqOq0Qq7koCzMSO7rTLhuINcpV0GdSClcGxYa1UKsjIkwjyH5s9SHlQ3Tw+FkxieeHLXrA9mFxYWS07xwPfr1OFSNdMhtrAKMcS97HXlRAldNP1OS+0d6QczdkXN9IAOajk60SR8iWYiILXxbPOCfysj85ecfzdeVGI9XiRHzfM6BgnGmVS+3aa9xurS7THRYAkMcI3huwcHOs2QX/Vhe+zBU2hUUStkn6sDKVnnq
 6LOIAsRALIOLFClLe35uMH0XBzvzIR6a2NOcOc5hhg2cPAI1s2LTiuTVXbLWmaAuO3AAh36/6dsRdG1fITBEeXY1QgHbfWxTkJVyvW6mOXuWMg5qK7r3uur5NMapW1hneooWpQrZSW47GvNnta61AY24w5t9GodVHVSgyx1C5K6rkVf99WE1rxOny6XPUYCTxc+hzSIBk3rmzZdBYSCImCrf1x
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id a18-20020a056638005200b00470fe9f837fsm972435jap.29.2024.02.08.09.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 09:30:24 -0800 (PST)
Date: Thu, 8 Feb 2024 10:30:22 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
 <james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
 <reinette.chatre@intel.com>, <surenb@google.com>, <stefanha@redhat.com>,
 <brauner@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <mark.rutland@arm.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
 <ardb@kernel.org>, <akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
 <wangjinchao@xfusion.com>, <gshan@redhat.com>, <ricarkol@google.com>,
 <linux-mm@kvack.org>, <lpieralisi@kernel.org>, <rananta@google.com>,
 <ryan.roberts@arm.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <kvmarm@lists.linux.dev>, <mochs@nvidia.com>,
 <zhiw@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <20240208103022.452a1ba3.alex.williamson@redhat.com>
In-Reply-To: <20240207204652.22954-5-ankita@nvidia.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
	<20240207204652.22954-5-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Feb 2024 02:16:52 +0530
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The code to map the MMIO in S2 as NormalNC is enabled when conveyed
> that the device is WC safe using a new flag VM_VFIO_ALLOW_WC.
> 
> Make vfio-pci set the VM_VFIO_ALLOW_WC flag.
> 
> This could be extended to other devices in the future once that
> is deemed safe.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..c3f95ec7fc3a 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1863,7 +1863,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
>  	 */
> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_VFIO_ALLOW_WC | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_ops = &vfio_pci_mmap_ops;
>  
>  	return 0;

The comment above this is justifying the flags as equivalent to those
set by the remap_pfn_range() path.  That's no longer the case and the
additional flag needs to be described there.

I'm honestly surprised that a vm_flags bit named so specifically for a
single driver has gotten this far.  It seems like the vfio use case for
this and associated FUD for other use cases could all be encompassed in
the comment where the bit is defined and we could use a name like
VM_ALLOW_ANY_UNCACHED or VM_IO_ANY.  Thanks,

Alex


