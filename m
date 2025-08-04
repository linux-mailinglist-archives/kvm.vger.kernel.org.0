Return-Path: <kvm+bounces-53925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9AF0B1A57F
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 17:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A48B93BB851
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A6A218AAF;
	Mon,  4 Aug 2025 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0eccJ3t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4496E946C
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754320084; cv=none; b=ucf6/vmpU326y6bZ8MK0T58AaA+KXKypuiW1Zy72zEOM/iSxKksVpXC7Q5dfDhenmvYw7wYsK/g3Mo3grNHDaivSUTr6vEnYkAl2H7DKysm9maGutucDTJq7rwxWFsEyYjT9gHyCbPfYvu/tWx3x9lIi23Qa5sDmODKIa+DU7+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754320084; c=relaxed/simple;
	bh=X8XbtzEPmNwh6If14c0GFUDwqgAhGQei09Ag+s+DqvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p06VS7d857pIDAzyOQ+vJUFwDkq9/2vVUAmvY/75azHU2Qw3Ci1Ev/8HBKArwNDLcgxCgmCgj1XsxYqIGJP/QdAW7l93e90lrrIBLnKdidwbRpPzNXbhsOYd6hcXBoPBKPjO96ONAvH70RXeqv6k65iZF9X/ifCO9mSrzcjwcSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0eccJ3t; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so116365e9.1
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 08:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754320080; x=1754924880; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bXyXMSsShDr1jpkAA4IK8VwJHC1yMjlD0xj/ZYYhP8k=;
        b=H0eccJ3tc3wHG965Cjz9bguTLdvlWDU3TMjPiQUyjRYFCOPi2vfyY0tWUj+aXMqZee
         mzxRNzIFGOpLC+F8e/2xqnp8x2qUkNkLdmGKfww59Z4eALBIxgX/yLL2v9iGx9bhaWCO
         qJ8GwffA+pzSoui10XHot5mH8vv21ncloHl2KfKz+lfqDVZLljbU0yBBY1NQsuP0omDv
         yr22kzjwfJOZh9TNWv/Mvq+CTNca8WRj1S++IPbqUNNjvyjfjXjwFQ3dmEI9GgyW6VLx
         B8p/b1rpu8OwfJhFkHexD+Lv1UNTxocCwA3IjnE+kCNyzdo86+DB8HNBVk4rssVjUKX0
         lG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754320080; x=1754924880;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bXyXMSsShDr1jpkAA4IK8VwJHC1yMjlD0xj/ZYYhP8k=;
        b=m/9WElIn/bQsYgL2DKX1sZqn02N4uv4Ixnu4cZJHeh34w6V1Mr4c2GBF6GEyATO+a2
         9lxzdujm9/esfmPGZF9YcXwZF8uARW2CDRX2GpIB4g4UNKcR84LSz1g4ZA9F49qh+toU
         RMc0OET3s5S5kcLbu9Z9s+fYUuGnpdy+ttHV1mMJjDd0NZiFNeRAjxrLKIy8L/RgUDo8
         XjZgtnrvxR9pvG2gWnY/jo5buzlHKh0goHjIF4RxTgs4MSGCWhmc24sBImcaEmqSG6hD
         8EKqLL+yfnx00VgWfojbHw2O+rmMzUZsltlKFp9idKtxdZi3MvaNllN+qlctUaAQmUpg
         I7Jw==
X-Gm-Message-State: AOJu0YwD4TGgR1+P4rp3VYG3VxgvIxcAW1ILGTRFz38UbYkhFRCZWg0Z
	VagyxMJLuc/Bq37GF7qCptH7sN6OK9V/C5uKPpLRd84r2MOhAsSV2+TXMWd+DgBWPg==
X-Gm-Gg: ASbGncuhlkhTF408TfhPfFljdmm465vFXg5Wb77IuyZHXFNdlmK75UH5NUWD1+7/UIS
	i3+P/UENcwJf7i+4SyWcMf+FOg/HkGoPKikOowVVesaNecy9mz5f4TvTqgg0ming56+TbP8LsJt
	gANVH0QRM5PRY/yo9lF4mrxX6uAgHmJpZURM09n2So9zqI/p1qL7+Ip4WvIJ6NlNOPnfJxqwd6j
	cz9DvRe+hN2Sh8rI3GWv5dF8jmkgl5mtJSFtV4eollmYJZrPBlUAmHhtc1s2OO2k2f44jNjjeuK
	ZhLWzX8NgcPJefURVcRs3buS3aZqwpT0Y0UT7pJWAh1fKrFbSfiquFEFY97lQxldrft7toSc+5h
	ZpWdKwOVEPx5rYjUz9KZpwH3/EfazmhbR91W8SiZ3UF7XExcgoUjtp4BvTKIcz8oKz7awz2ubcp
	t+
X-Google-Smtp-Source: AGHT+IF+XqKWTb7+dykCeDRtGjJKhy27aXtSckToeepbFnsdPqLLjOyjgtL8f5AgCarhCM8/HMkpfQ==
X-Received: by 2002:a05:600c:4917:b0:455:fd3e:4e12 with SMTP id 5b1f17b1804b1-458b71a7ca8mr2936585e9.4.1754320080302;
        Mon, 04 Aug 2025 08:08:00 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac093sm16510913f8f.9.2025.08.04.08.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:07:59 -0700 (PDT)
Date: Mon, 4 Aug 2025 15:07:56 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Message-ID: <aJDMzKiXZ7Pf0TCm@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aIZxadj3-uxSwaUu@google.com>
 <yq5a8qk7bml8.fsf@kernel.org>
 <aIiXSNgqt_6xuaRD@google.com>
 <yq5att2u9jvi.fsf@kernel.org>
 <aIoo59VdZ24F4nsB@google.com>
 <yq5aldo59do7.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5aldo59do7.fsf@kernel.org>

On Thu, Jul 31, 2025 at 10:09:36AM +0530, Aneesh Kumar K.V wrote:
> Mostafa Saleh <smostafa@google.com> writes:
> 
> > On Wed, Jul 30, 2025 at 01:43:21PM +0530, Aneesh Kumar K.V wrote:
> >> Mostafa Saleh <smostafa@google.com> writes:
> >> 
> >> > On Tue, Jul 29, 2025 at 10:49:31AM +0530, Aneesh Kumar K.V wrote:
> >> >> Mostafa Saleh <smostafa@google.com> writes:
> >> >> 
> >> >> > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> >> >> This also allocates a stage1 bypass and stage2 translate table.
> >> >> >
> >> >> > So this makes IOMMUFD only working with SMMUv3?
> >> >> >
> >> >> > I don’t understand what is the point of this configuration? It seems to add
> >> >> > extra complexity and extra hw constraints and no extra value.
> >> >> >
> >> >> > Not related to this patch, do you have plans to add some of the other iommufd
> >> >> > features, I think things such as page faults might be useful?
> >> >> >
> >> >> 
> >> >> The primary goal of adding viommu/vdevice support is to enable kvmtool
> >> >> to serve as the VMM for ARM CCA secure device development. This requires
> >> >> a viommu implementation so that a KVM file descriptor can be associated
> >> >> with the corresponding viommu.
> >> >> 
> >> >> The full set of related patches is available here:
> >> >> https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstream-post-v1
> >> >
> >> > I see, but I don't understand why we need a nested setup in that case?
> >> > How would having bypassed stage-1 change things?
> >> >
> >> 
> >> I might be misunderstanding the viommu/vdevice setup, but I was under
> >> the impression that it requires an `IOMMU_HWPT_ALLOC_NEST_PARENT`-type
> >> HWPT allocation.
> >> 
> >> Based on that, I expected the viommu allocation to look something like this:
> >> 
> >> 	alloc_viommu.size = sizeof(alloc_viommu);
> >> 	alloc_viommu.flags =  IOMMU_VIOMMU_KVM_FD;
> >> 	alloc_viommu.type = IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
> >> 	alloc_viommu.dev_id = vdev->bound_devid;
> >> 	alloc_viommu.hwpt_id = alloc_hwpt.out_hwpt_id;
> >> 	alloc_viommu.kvm_vm_fd = kvm->vm_fd;
> >> 
> >> 	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
> >> 
> >> Could you clarify if this is the correct usage pattern, or whether a
> >> different HWPT setup is expected here?
> >
> > I believe that's correct, my question was why does it matter if the
> > config is S1 bypass + S2 IPA -> PA as opposed to before this patch
> > where it would be S1 IPA -> PA and s2 bypass.
> >
> 
> Can we do a S1 IPA -> PA and s2 bypass with viommu and vdevice? 

Sorry I was not clear, my point is that this patch adds support for vdev
only to set the STE to bypass, which has the same effect on the device SID,
so why add such complexity if the assignment will still work without it.
AFAIK, the use of such feature will be to present an emualted SMMUv3 to
the guest.

Thanks,
Mostafa

> 
> >
> > As in this patch we manage the STE but set in bypass, so we don't
> > actually use nesting.
> >
> >> 
> >> >
> >> > Also, In case we do something like this, I'd suggest to make it clear
> >> > for the command line that this is SMMUv3/CCA only, and maybe move
> >> > some of the code to arm64/
> >> >
> >> 
> >> My intent wasn't to make this SMMUv3-specific. Ideally, we could make
> >> the IOMMU type a runtime option in `lkvm`.
> >
> > Makes sense.
> >
> > Thanks,
> > Mostafa
> >
> >> 
> >> The main requirement here is the ability to create a `vdevice` and
> >> use that in the VFIO setup flow.
> >> 
> >> -aneesh
> 
> -aneesh

