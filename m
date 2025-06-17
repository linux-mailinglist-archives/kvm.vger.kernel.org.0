Return-Path: <kvm+bounces-49758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86AB4ADDCD0
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 22:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EB121883E33
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7292EBB96;
	Tue, 17 Jun 2025 20:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M48bd1k2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476802EF9A7
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 20:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750190482; cv=none; b=nL3a4OZJ2sdqvOjNA61s/O+nLGkI2QrUjnowtC9qbRHyfgWIqAUzl5X4dX/wHSUlSqKbZBWb7yLm3DOrr/UREVi6nZh4TNEp05ysI0jPSIa0D3XeJ495o1SYYqqZq8SI4cXnKl/JSGJIU4Qm1IBDe8OTwCXKZdNidSRPXlqHaPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750190482; c=relaxed/simple;
	bh=9qlryhIHS0Cc2X2BC+ex+dW7dnay/Akl42iZ5dW4L3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCVlb37HfuUdbtru2yvxYQFVdfng1UpJLKrX4VwfJPYvXAkQxtTfShJrvessMhVtMVwVPInFvyF/YPCuHUfG0OB4/Fqv7BlAf2QpkjPU+SFxU+Wc2Vzr/BJS3oAH2jLiYRJELdA9E7T9xlROUkZGdE7oKF2SBGGRNC18q1o0Wyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M48bd1k2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750190480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Dm/YTY2gnD+c/gsISARFM2WYB8H4Eho9ZAM8VM6ubM=;
	b=M48bd1k2d7gqfSNZ0dcClnpM/ZHvdIrRWS3NzQY4m4QgFXPw+aH5o6Kwmus2SSY7pFqF0K
	fsMRyuJBP8tAIRzDGT3uwv0VWI7Igf2fcz/ZYwCkzrl/qwLaR+Zt3J6S6eXAwgNOTRmiEW
	OOuqpuj9jZd6oRl6Bc9N5gwBI6Cy7hU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170--w_dvJ8LNi6qqG4Sfehkvw-1; Tue, 17 Jun 2025 16:01:18 -0400
X-MC-Unique: -w_dvJ8LNi6qqG4Sfehkvw-1
X-Mimecast-MFC-AGG-ID: -w_dvJ8LNi6qqG4Sfehkvw_1750190478
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so6191803a91.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 13:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750190477; x=1750795277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Dm/YTY2gnD+c/gsISARFM2WYB8H4Eho9ZAM8VM6ubM=;
        b=oKuz4ovfTWEnJC6tMFE7zk2d4jA6psIUGG5YmqMfU8h12tCfzzaSzN7tIArnkMdoDg
         ttXEsuAXlCmrx0+KovhdcbWmRJWLNiAi79bK9EQGfp8mgbp2p+9XmA0blNmhc5gyhh5n
         Z+cretdENQosSMrhXZA3pXEp9AS9OInmey9CNgmgoo4oTtB7VRcQkW0uSAj58yhB0K2N
         FCHhud+87659JJ55cVawYzuj+LTr+gpje1gklfgItbCs+h9M3oc6Y0xWiD31FovtME9f
         6fsFs1iEsjJEGBVP6//kKa/ciQxDMYAerX0dsosaNN4PpxVEK21Q7DBLTOE3QT3SV1HC
         jTGw==
X-Forwarded-Encrypted: i=1; AJvYcCWir5XObR0Umyr+PkTgPXZOg5y/CQcmQyxT2fQ59RUMHTbaTjbf+b8PBhcXFI1hyvS/kVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWk6xDey4CiiG3Knwh36PxLsMHbqO6r6bvIVSMqtVlG1gn15T0
	ZiULD6Hmt8Jq+SELHC06IEKGbrq93sdlDiW/Rou0kxTQNojKwYlwxOFt9NFO3sUL3LBrvl1gudW
	Xyz9Rbhcm5S738KTbx2Axgg50dUCXPdXzaCHVpEca73e1FX+l39n/+A==
X-Gm-Gg: ASbGncuomEneFzg0Tly/oL3r7FnUiM5BJr+rhVZh7JywqKZYkC3Hq0ntSrTgQrCpTDj
	q9UtYfQJU273wcClm7G0EdF/5PzccF5PcY80hYeC4p7/eR73/sPkoWJWCvwO3Xfp/no5IXoykBH
	MfKTRy/UYS1WKZWYxaDZ7vy4c/PHSst7vv6IRiTjbUvkCPodmgQDje3br7IO/nntLI4rggljNCw
	4fxcvttvuIkWr1KHuDqzMrL7L51rw4THMwDho2Of4YdhnKZVJFjnDvNzxYzKPX/U4OFSy7qO6lT
	LKxe40T+5TdHMQ==
X-Received: by 2002:a17:90b:39cb:b0:312:ec:412f with SMTP id 98e67ed59e1d1-313f1cc6475mr24162731a91.14.1750190477476;
        Tue, 17 Jun 2025 13:01:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9mPY0K5+r6ESf4SrogrsmJ9SaqRUqc0sTfpN2AxqMlGxDMB0nD5J8Sn7aF0/Lb+05TfOe/g==
X-Received: by 2002:a17:90b:39cb:b0:312:ec:412f with SMTP id 98e67ed59e1d1-313f1cc6475mr24162674a91.14.1750190477030;
        Tue, 17 Jun 2025 13:01:17 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3142874a4f3sm2156795a91.22.2025.06.17.13.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 13:01:16 -0700 (PDT)
Date: Tue, 17 Jun 2025 16:01:11 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <aFHJh7sKO9CBaLHV@x1.local>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
 <20250617154157.GY1174925@nvidia.com>
 <aFGcJ-mjhZ1yT7Je@x1.local>
 <aFHEZw1ag6o0BkrS@x1.local>
 <20250617194621.GA1575786@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250617194621.GA1575786@nvidia.com>

On Tue, Jun 17, 2025 at 04:46:21PM -0300, Jason Gunthorpe wrote:
> > I just noticed this is unfortunate and special; I yet don't see a way to
> > avoid the fallback here.
> > 
> > Note that this is the vfio_device's fallback, even if the new helper
> > (whatever we name it..) could do fallback internally, vfio_device still
> > would need to be accessible to mm_get_unmapped_area() to make this config
> > build pass.
> 
> I don't understand this remark?
> 
> get_unmapped_area is not conditional on CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP?
> 
> Some new mm_get_unmapped_area_aligned() should not be conditional on
> CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP? (This is Lorenzo's and Liam's remark)

Yes, this will be addressed.

> 
> So what is VFIO doing that requires CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP?

It's the fallback part for vfio device, not vfio_pci device.  vfio_pci
device doesn't need this special treatment after moving to the new helper
because that hides everything.  vfio_device still needs it.

So, we have two ops that need to be touched to support this:

        vfio_device_fops
        vfio_pci_ops 

For the 1st one's vfio_device_fops.get_unmapped_area(), it'll need its own
fallback which must be mm_get_unmapped_area() to keep the old behavior, and
that was defined only if CONFIG_MMU.

IOW, if one day file_operations.get_unmapped_area() would allow some other
retval to be able to fallback to the default (mm_get_unmapped_area()), then
we don't need this special ifdef.  But now it's not ready for that..

-- 
Peter Xu


