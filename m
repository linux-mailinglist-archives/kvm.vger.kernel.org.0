Return-Path: <kvm+bounces-8566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B0B851ADE
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 183DE1F24053
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768394F88D;
	Mon, 12 Feb 2024 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJwkiqz+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E44F615
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 17:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757510; cv=none; b=qwdutmEUBX21befCBO4dhwhfq2hcq9FDANHcvMSx+94EcAxyteuuTvS9ipatTxCBHb66DUGVjMyYgta5EwofNxjZl+ODcQRYavEcEczkYijGuV7G5Po72KJ3gi10VzUFgJo5ExQhauZAZU5Tdekl5bn4ifZcoqMOW3622ohyCK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757510; c=relaxed/simple;
	bh=/ppasOObi1vl2zoLkHHxsigE/xVlK8tLer+NXGAx/2E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RlABn/JNahW5m82unDK492MZ+qRvjh/WGga9N3Fv4oMHiouTKWHOa2Db9nk5NadXV2U5LTuL4vEAxVMBfgZFTxQ98P79luKN03szA4GC8Ml6SY/7v7M9oqqas7qod9VnBCjN6rRFQY9+5vxRdaOv9fFCP5qfN/HC/yl827InlYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJwkiqz+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AOauPAOUW8xmwdezNoz+IWSD863XpUK91dsGE3R14Gg=;
	b=BJwkiqz+FdLvAn0xYXWPsEFTnhsviBjAS3z7y4R4w3R7cdO6/PNuYYHkMh/lktjzm5Xac8
	/SQa7DzRweIK50F50R7LYqHlIpB5tCYrEegr86EUR0GNl6vY+c4coMKUW+Zax1uv96hSQZ
	uVva3i+5auzqM9sTSHzQTa9neqUK8jo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-54e5Ay1CPy-VVeQ7wvwgqA-1; Mon, 12 Feb 2024 12:05:06 -0500
X-MC-Unique: 54e5Ay1CPy-VVeQ7wvwgqA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-363b68b9af3so28568115ab.1
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 09:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757506; x=1708362306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOauPAOUW8xmwdezNoz+IWSD863XpUK91dsGE3R14Gg=;
        b=A1DjtR+hZSas/tapZppgtt156M2WeQtuyB6Gjdfy2ez1Th/pRCfVnjLaFSuoYRK1ZK
         PJjDOOnfiRKQZHHLoVqoHJ4TIqy1LgJQX7HXqO/NibcVYMeVgNpdJdBkDY+6dhiZN79n
         EryQ8+gg6TaBu7yxAl4IYjP7SLtIdmeqnvwWa4s2DR0SIDdcULJ4hV9gE1atHc+v3mA0
         GXg0dYNz9jCOpkUCtxabgU1El7F9+CI6Q6Gn6w2ePVioUV+VRtwCGO+uiUQrK7KHd4DE
         JlNXs3yMQgpAGBI4Z9OsSVvx9m/FYPsil287kDE8W/O+hr2sQMvDoKEArUSii7mMvA6P
         QPnw==
X-Forwarded-Encrypted: i=1; AJvYcCUwVPEbt4xmYxbN7XFCngrRimnbOuOKKi9rHdIX/m+qA49+uNOBvGYqlw8GUBEhY5F837cWkCJMN1y+vGxelTVzGZOX
X-Gm-Message-State: AOJu0YyM+4Wi30hIZr6DymhSdbGAdiBhNL+a5YJWhAsd7WRRk8Mt//kv
	5N/HPiOUqW3auifrym1GPC4jluya8pQEkQTgpClxPPBDoYByAsnHOvBylTUeDV7uG8+EYUgYIkd
	Gc/gNykEAtjlUSPCHa2ZGYGcjeUaUiNhIudIx0lQbQH4uZS7afQ==
X-Received: by 2002:a05:6e02:1c0f:b0:363:bf4f:9242 with SMTP id l15-20020a056e021c0f00b00363bf4f9242mr12359147ilh.0.1707757505969;
        Mon, 12 Feb 2024 09:05:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTr7BKAunXGu61vRYhJINkTJcmaRk0uei4AcQbQ44MkhVmZ5mwHzO7IldqcHZ1n+fHrehwBg==
X-Received: by 2002:a05:6e02:1c0f:b0:363:bf4f:9242 with SMTP id l15-20020a056e021c0f00b00363bf4f9242mr12359090ilh.0.1707757505683;
        Mon, 12 Feb 2024 09:05:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWTKjfqO4rkuhd2GHVkqqBNv4+4iVoZcGlDpy3HDG1uMMhT2d1jmDXMdgoX5DAWSe6wNqaoupDoOAQYGfaqx0u2YxoUAD4jOURcBV59dRJ0I84dPyAqjUa503odT/ihzOsHVyPnNOPJoHdYRT0Rkp1ITk30Z0jK0uQhOT8ZxCTTsDwHyplbhVXKzzWJ+5KLI0CW6tCa0uQX8eZY5XNRWRGf+QNcHvIm3yhzArCWF1+twWZ8ZnjPN50CfZ2MfWdE75xZdbBSioYKg/nzKmtiQE3HF/9lKHwRBYl6QkNkUBjfurx86zdYaK+ehhpNI3KCup/fqQW91N+qdWpE6M/4gD15NJDcY+cT9NbrcP/cidh0BMgG50wNuXrmnkXpm4oifG69lW1OlbPuCF3FwTEvBEMdMJNhwGJUq73Fb0yEEC3moByn74AQRxFN2+lKgvS7f3ETe1xbUchqRjQJYKyPvAv5d54L1Slq5ySDW0gE8KXZDMWQOLPNjP8lfWTWVQz2cegkBDFZnvSicLwrm7kx6Uyn4iQRg2Q2+2S092z+9EVssL4dTBcBiSfvzP4WR8BM9x2Cnj61ySifZP2b3sit2kXjDiHOKSpVT3XvUxV2NbiqyqaykRhfqoQWedicpEy2bUk4+6LGqp11TmwKitHZJVqrpjqEY5C20DTsYEiFK61AzM8/cBavnY1uHrFpyCAogoztCVgiLv6dR1pGSea50FebaaEoxsF0FdNhpT2In60GDbjrIIPJw9Yq3LE+A7pRuI8M2Pv2xba1cBmYG5BrQ/9vAC0AeyPnL/EjsEcqAD861Ut39qWpRqvM0jpvnlygSo13H7bWAWmrMWzOqUYutqVrxS1vCjbuNPAk4KPe0BHXnX+ou2Ou1LDGvKclXyNuba+zNe/6NIkiQ9tFgwZQWrO6cdbtM29KCOYYYy6I1yQguArOSxd54yZMFBXbHqlvq68ZD7
 s5Ogdlm3vmILJeBjg6GR7Gfseo5SInXkPEJuISfamgJq1cKmYEkWiLHdpEXsU2z2bxLv6UizINdscavVhxNtO+f3YWyq67/6mkIHGegdJtwSQkFTQE38Qc6rY4wjyj3IoWWIw3JoTW1arS4PnomVhrCPLrZRuUcqKd4YW697swDORpqc5pjtaQmDUFd3HjddzZ2ykwrVpXhQU0MTWWohfdS3VaXxvAHWG/+cPs5+gvAChdu1Syik831EdMmJCOOtGu+BcmXFq/EhhR6d91D/vA9vXazLvjYergDYBNbDpREevkFO/zUNlr5Hb5RaVHWWDvXX9c
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id bf12-20020a056e02308c00b0036275404ab3sm2025858ilb.85.2024.02.12.09.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:05:04 -0800 (PST)
Date: Mon, 12 Feb 2024 10:05:02 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
 <james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
 <reinette.chatre@intel.com>, <surenb@google.com>, <stefanha@redhat.com>,
 <brauner@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <mark.rutland@arm.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
 <ardb@kernel.org>, <akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
 <wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
 <ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
 <rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
 <linus.walleij@linaro.org>, <bhe@redhat.com>, <aniketa@nvidia.com>,
 <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <vsethi@nvidia.com>, <acurrid@nvidia.com>, <apopple@nvidia.com>,
 <jhubbard@nvidia.com>, <danw@nvidia.com>, <kvmarm@lists.linux.dev>,
 <mochs@nvidia.com>, <zhiw@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <20240212100502.2b5009e4.alex.williamson@redhat.com>
In-Reply-To: <20240211174705.31992-5-ankita@nvidia.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
	<20240211174705.31992-5-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Feb 2024 23:17:05 +0530
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The code to map the MMIO in S2 as NormalNC is enabled when conveyed
> that the device is WC safe using a new flag VM_ALLOW_ANY_UNCACHED.
> 
> Make vfio-pci set the VM_ALLOW_ANY_UNCACHED flag.
> 
> This could be extended to other devices in the future once that
> is deemed safe.
> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..eba2146202f9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1862,8 +1862,12 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	/*
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
> +	 *
> +	 * Set an additional flag VM_ALLOW_ANY_UNCACHED to convey kvm that
> +	 * the device is wc safe.
>  	 */

That's a pretty superficial comment.  Check that this is accurate, but
maybe something like:

	The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64,
	allowing stage 2 device mapping attributes to use Normal-NC
	rather than DEVICE_nGnRE, which allows guest mappings
	supporting combining attributes (WC).  This attribute has
	potential risks with the GICv2 VCPU interface, but is expected
	to be safe for vfio-pci use cases.

And specifically, I think these other devices that may be problematic
as described in the cover letter is a warning against use for
vfio-platform, is that correct?

Thanks,
Alex

> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_ops = &vfio_pci_mmap_ops;
>  
>  	return 0;


