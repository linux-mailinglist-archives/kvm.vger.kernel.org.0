Return-Path: <kvm+bounces-53939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F5EB1A948
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 20:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC49E18A0384
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 18:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CED22E3FA;
	Mon,  4 Aug 2025 18:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uyt0Tq8X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFB51B4F2C
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754333361; cv=none; b=f/pLbVXoViFH5J8ywNqF2hHZkf5L4fRgSIEA1YmqJIe01lOUG+psoBjIyau0lQwVfDVkaSk7dpzIsrqmDlMCBXpZv3ioXf3OkUQ3cugRZiGcfPs0OTuqNsVLz0crYm/SUYWGW710+rrXFN4BGMfqFCFPmhTJMeIOdNWW3HTY5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754333361; c=relaxed/simple;
	bh=mxoOhLuIw8rWoKZgdBH6lPC8GdnX258T9d6YWQ17rQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXy/Pxv93SDZH7gQh6ZnbL5r7ODvZZ9BtoI2egxtAr2EuWSyJ1M7fypeYS7mupbk2kp6z5M3QZaNgChjbheHMNjEdFxCH47vQsNfVVSVbL+2Xtnmg/GJvWcoy0JlGU+rLfXxqZgJZttnso5T5zCjDTpb8LWcJG3yOvvrBtc/EzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uyt0Tq8X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754333357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJDe8K3Z03PmfkDcNgadpGiomyFb1KQUtuQanP+NQHk=;
	b=Uyt0Tq8XXI1eNLvkBVSB0vY1Xjqa5nx98qqxjNiZ33m9dDl56ay+01rR5UCx34XyFhtXPY
	R09F7cD3SxhJVIgIANLAPc/gLwKCffipLt+Qpa6xsm54V1+BHa3S8JVhuApb6mtCdx0Zve
	Hj4kt72RmlosmNyFQxugL2Jkmp6dBsQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-c-GOO9xGP466-eprcA0F9Q-1; Mon, 04 Aug 2025 14:49:16 -0400
X-MC-Unique: c-GOO9xGP466-eprcA0F9Q-1
X-Mimecast-MFC-AGG-ID: c-GOO9xGP466-eprcA0F9Q_1754333355
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e40d266505so5890855ab.1
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 11:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754333354; x=1754938154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJDe8K3Z03PmfkDcNgadpGiomyFb1KQUtuQanP+NQHk=;
        b=Da0SHVK9bFl5+DpUgR6nzYgtxCDWgRm/xhZd8E1FRzgcFB8X4hBtDUok+YrMMggmW3
         p0ITMij8vQbjzKiKM1ulgNbvI27If1NNZF9gg+94AMVXFHawnDe8sQLnQD7uOlkRg49e
         dC59CROYq0xth0XNRUICRTsCrNjxqs/GGW3QeNwsYE2iv0TyeZHR238Jn0akmjVB3j7x
         N6lVnYyANTzXZeG36OvhO2E47E9vV42AhKpMqiVQqjLSy2R4bLR8uJ+u0Nyz9u0Gkx+t
         Q22LJL1tuIQdkupdB14GU9u6eGZn+vWivPJOm90nizeOIGFBvYwgGFvxEYhXQ7/yYT3Y
         7EoQ==
X-Gm-Message-State: AOJu0YzUi/F67tB32nN9qvyqlRtrnoGiFvNHIjPCUuyhnJSfjtZKXpeM
	jFwHwMFoCNLQ1mF8m1+1SnixRP5LuBfE3G5tCZpOy29dyv1d3TTub9zi6D2EYq101K9qO0Quvpy
	iS+JvxBh0/1wi78uzaeWxTUeKAlA5c8nJX/8GHDfFiEdE5gKSGcPoZ9H9s1QJNA==
X-Gm-Gg: ASbGncuw7DfnpyhaeQbWbyQHoXVWo3kU3/sL3tDUtKjzkBXpOVpPjOOVCpefL5BTVad
	+ppicymjemYCilEGAoxb6AZ8OyW4MFwYYpmj9/NIFdUsMobYPigRLGPoMPHWQXYGn8mtsT4y6yC
	OSSodyTbvcIFscpD4MM0rafmmkjmy4ObsIZNAX2hUTwu9X2P9OrBsrr54yXH8kWMd/KT2Uh7StC
	ZzvDO71FrY9ke0LrqyJSAwZid9YTVKDtBfbuFyOaHzAcF9SY2Qv9N0VbFd3KZim47pWNpcyff8e
	5qboodQuONBeE2n1v8KVpaTlhhkVrgK3471gJM9qrO8=
X-Received: by 2002:a92:c24b:0:b0:3dc:8bd3:3ce7 with SMTP id e9e14a558f8ab-3e41609c666mr57314575ab.0.1754333354185;
        Mon, 04 Aug 2025 11:49:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvIWZB22UWNWQlYP68ouJnlu2KwVbgtv0DGWEf6VGsAnux4DpPJO6C/bN7bvYJ2LP1viFxjw==
X-Received: by 2002:a92:c24b:0:b0:3dc:8bd3:3ce7 with SMTP id e9e14a558f8ab-3e41609c666mr57314415ab.0.1754333353699;
        Mon, 04 Aug 2025 11:49:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da3351sm3412283173.87.2025.08.04.11.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 11:49:12 -0700 (PDT)
Date: Mon, 4 Aug 2025 12:49:09 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mahmoud Adam <mngyadam@amazon.de>
Cc: <kvm@vger.kernel.org>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>, David
 Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>, <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250804124909.67462343.alex.williamson@redhat.com>
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Aug 2025 12:39:53 +0200
Mahmoud Adam <mngyadam@amazon.de> wrote:

> This RFC series proposes the implementation of a new mechanism for
> region mmap attributes using maple trees, based on Jason's suggested
> maple tree and offset cookie approach[0]. The primary motivation is to
> enable userspace applications to specify mmap attributes=E2=80=94such as =
Write
> Combining (WC)=E2=80=94prior to invoking mmap on a VFIO region. While the
> initial focus is on WC support, this framework can be extended to
> support additional attributes (e.g., cachable) in the future.
>=20
> Core concept is: a maple_tree instance is introduced per file
> descriptor within vfio_device_file, allowing per-request ownership and
> control of mmap attributes. Via new VFIO device operations (ioctl &
> mmap), each vfio device populates its maple_tree, primarily during the
> DEVICE_GET_REGION_INFO ioctl. The kernel returns a unique offset key
> to userspace; userspace can then pass this offset to mmap, at which
> point the kernel retrieves the correct maple_tree entry and invokes
> the new mmap op on the vfio device to map the region with the desired
> attributes.
>=20
> This model also enables a new UAPI for userspace to set attributes on
> a given mmap offset, allowing flexibility and room for future feature
> expansion.
>=20
> Because these changes alter both internal region offset handling and
> the ioctl/mmap interfaces, a staged approach is necessary to manage
> the large scope of the update.
>=20
> This RFC implements:
>     - Integration of the maple_tree mechanism and new VFIO ops, along
>       with required helpers.
>     - Initial onboard support for vfio-pci.
>     - Introduction of the new UAPI supporting WC.
>=20
> Planned follow-up work:
>     - Extending new ops support to all vfio-pci devices.
>     - Updating usages of VFIO_PCI_OFFSET_TO_INDEX and VFIO_PCI_INDEX_TO_O=
FFSET.
>     - Migrating additional VFIO devices to the new ops.
>     - Fully removing legacy ioctl and mmap ops, renaming the new ops
>       in their place once migration is complete.
>=20
>=20
> For now, legacy and new VFIO ops coexist. Legacy ops will be removed
> following full migration across all relevant devices.
>=20
> This RFC marks the start of this transition. I am seeking feedback on
> the core implementation to ensure the direction and design are correct
> before proceeding with further conversion and cleanup work. Thank you
> for your review and guidance.

I'm lost.  AIUI, there was a proposal to manage region offsets via a
maple tree, specifically to get a more compact mapping, which I think
is meant to allow new regions (mmap cookies) to be created which are
effectively aliases to other regions with different mapping attributes.

Here we have a partial conversion to a maple tree, but the proposed
ioctl is only specifying a mapping attribute for an existing offset.
How does this require or take advantage of the maple tree?

We should be able to convert to a maple tree without introducing these
"legacy" ops.  Ideally we'd have a compatibility mode where we retain
the existing offsets, but otherwise the maple tree should compact the
region layout within the device fd and be used ubiquitously, mmap and
read/write.  That's only useful though if we decide on a uAPI that
actually wants to allocate ranges of the device fd for use with
alternative mapping attributes.  Thanks,

Alex


