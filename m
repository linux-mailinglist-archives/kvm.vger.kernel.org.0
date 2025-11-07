Return-Path: <kvm+bounces-62264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A49C3E5C5
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 04:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8FBC14E76D1
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 03:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA69287505;
	Fri,  7 Nov 2025 03:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aelGNvjz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63CA13D891
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762486662; cv=none; b=KmsNBiSGen7JEjDIlUBbUGuVTWMSSKHFF9CT6ycYP3zHrZ9Or5agegBcVJAPKniBE/Iak+3J2V0xou3Lxj3PwvIQSMExubTKKHpNDTuPDqqd2L0D+rWr243mQdtivp5Ve4iQFGK29pUBFQs4H0yJ82Yb49qggdYt64Av9ghaV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762486662; c=relaxed/simple;
	bh=pezSjl+AmWtiF/cSi2GKJdxk5Qp/bbc6QBZVZDY86U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2r+3XzdFBoLJOXkBCAPUYxSBjfaoqQ5gwiefeWxXD26SJklZqXWaRaPVNh3R5ZkK3Y2Kft6qkZ/k+XO/ccfUZx59fAHygCernjuglGDk0jFbke0g/EE30fehgspe8PeCRjPvrRa+7+F4XL4aA7FqoSflLJKoThCS99o5OxSx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aelGNvjz; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-294f3105435so61755ad.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 19:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762486660; x=1763091460; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5/YhEJ0ZtZ+6ZJfakScW52ymjZHpdIPE3Y2nD9gx7zc=;
        b=aelGNvjzBQzDIcHNfhIKSfgUsyuY4Yb2euSrg1Loxo7dMtBMzpogktfMcz5aG1nney
         tTra009MALfkwyjwjvdWDqMtIaQwGtnF3nAZasHFLLJnok9jt5ya8ehWg5bd/4H1ApP6
         9ONhRfTP+CVW2GeIivkWhiECXYsijRwiH0Us6w9/MFqdzRMmF5JRbh+aCAwi9SkBDyN5
         vezw2WC+XwKhjMXhozkuk+3bGn1JDT71cIMU2hONx11dn6Q1927Rm7RIKM7HDkdMJsVK
         EDL+gCA7IuWpfTElvpPgNXrvWJctwyuwikb1v4fHG4On5yrQhwnagO3xZ70c5JCub1tB
         I7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762486660; x=1763091460;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/YhEJ0ZtZ+6ZJfakScW52ymjZHpdIPE3Y2nD9gx7zc=;
        b=Nbin7DInL8an9tAHmWDJefrLGlTZAMuAZoivjZiG832TYfaCrgwXeZ5hKxoIM6kVsB
         ixsKYTealY31dBpC9bJcbOMP18HPoKoZlcRiVNJ6zrt9iHLDgprk1lgEokOHo8dBPpt+
         FMCOZ5xzTTG4DsARnaiS85UADlbFPWSllN+dbrQhted469iB2yOX2pmpDEIjJZMnDjdi
         s27b7nFO2V3ZnayJ5GVqhletqxtra83moptBHDKEtsFBu3ug9pqHpK/U3FKPGJNpbcPz
         7bpIn7hbLGVYDSGqmvE2wTJ+Iy/WcEOF0tjSdOWJT4oEyG+uO3d2qYinX6rpHST9UNua
         hYFg==
X-Forwarded-Encrypted: i=1; AJvYcCVOHjKQR+F2eksQ2crlqxLWjOVqtCfAwPpcF9Wu4OlOJzdjEH0c5c14j7he3t1xYYkMZUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkUqUJN2le9M2OwohkcHXIJIb1MrGw6qo8CrqPofc03sIPLN2x
	VRsYLUT/NIkUCwVgMgdgJqmwmzz0Yc5fCcptbXL6H7u7peSXPcHPq5gD4/sucOIY
X-Gm-Gg: ASbGncs5Lke+MQROuxfo6y+4abM7gDE3eOgXX8Pk4Q5BCGeJzV9I9OaMeSYQ2vTZ68M
	OkiUouUAy7mGp1vNP8yqlItEapkoJBrWxW6/qo+aMaMGrlMtpcQiG5RldeYDcKlydFSNeGD1ax2
	COYdp61GYBvtQ9wHISvmG4IEZDGGoINFM4exYVrvv1r0xSTkVr4NvS48/Ib8Nq0zWEygUD4ZnIi
	rSj6mjYA3XSOflFHraosWrmuwxPoaQbCExEC3OCFVVySUPXxT1tY2w20bNOno8Flq32BxqctMse
	asmk0sEWjg6yj4DUKLR/+zVVSf9q4MWqIJukdxB3zh6QaOwFihcqevuehj+jmi36+4yLjvEb+Un
	hrUuz7ZuhYC0Ioi62QOqGe1olKgaNV71MNsJZh6ciNPWy0S88UFqNGpIAYS2gDNhYFQQ0cgU/i5
	JPbDjMqcj4z/lZXJRRnYtvIafla7oMw5BXyg==
X-Google-Smtp-Source: AGHT+IFtTreRsIf/AiDaNShkrN4Fv1+apfy+9Es9ZIZ5stDdgKb7R//RLIrlPHnITb8JF3eIFpN67g==
X-Received: by 2002:a17:903:185:b0:274:1a09:9553 with SMTP id d9443c01a7336-297c558a569mr2096975ad.6.1762486659786;
        Thu, 06 Nov 2025 19:37:39 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650968269sm43456115ad.17.2025.11.06.19.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 19:37:39 -0800 (PST)
Date: Fri, 7 Nov 2025 03:37:35 +0000
From: Josh Hilke <jrhilke@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 05/12] vfio: selftests: Support multiple devices in the
 same container/iommufd
Message-ID: <aQ1pf03danXkVpvQ@google.com>
References: <20251008232531.1152035-1-dmatlack@google.com>
 <20251008232531.1152035-6-dmatlack@google.com>
 <CALzav=fZYTZOSwV_xac400YKkvj1=4H5n5M93m7pzXoCG=BQOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=fZYTZOSwV_xac400YKkvj1=4H5n5M93m7pzXoCG=BQOw@mail.gmail.com>

On Mon, Oct 27, 2025 at 09:21:57AM -0700, David Matlack wrote:
> On Wed, Oct 8, 2025 at 4:26 PM David Matlack <dmatlack@google.com> wrote:
> 
> > For backwards compatibility with existing tests, and to keep
> > single-device tests simple, vfio_pci_device_init() and
> > vfio_pci_device_cleanup() remain unchanged.
> >
> > Multi-devices tests can now put multiple devices in the same
> > container/iommufd like so:
> >
> >   iommu = iommu_init(iommu_mode);
> >
> >   device1 = __vfio_pci_device_init(bdf1, iommu);
> >   device2 = __vfio_pci_device_init(bdf2, iommu);
> >   device3 = __vfio_pci_device_init(bdf3, iommu);
> 
> After using this code internally for a few months, I think it would be
> better to just require all tests to call iommu_init() and then
> vfio_pci_device_init(). It is not really that much new code to add to
> tests, and that will leave the function name __vfio_pci_device_init()
> available for other use-cases (like [1]).
> 
> [1] https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com/

I'm fine with that. I see what you're saying regarding [1].

