Return-Path: <kvm+bounces-53735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE00B16270
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 16:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78B3F543F41
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 14:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632BE2D7813;
	Wed, 30 Jul 2025 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1NzCILdJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45D92D948A
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884912; cv=none; b=JHUnoBF6T4L1Qzh85czHezJ0gYyYCGaN+dAyWOqapKlHFkl0JC58H5RPCU7nORo1BNpV1ZYalLS4tbcTslCRWP0m8P+cL35S5U+QRwXAj9fAxCs3u/omLD6VWfAN20wRMobUtURxOT5ARhCUFzlB2auw+S3ANHfmNfCOlgmzZew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884912; c=relaxed/simple;
	bh=rFY8u9iWewEE+Mg94w3JME4UErpCxpUtLiq2kGsOFPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkzBKrqIongLW6E0rQdbFwuj9mKgEGf+mgicZl1qXIXeAihiBJOWa00Ga3GX21f8U1VmxGLfkMAyVChYfRsE9VE5qjHjLZPpTdpzUiN0t9BrOpPj+QyhtxQbPvIw2cGFQL2+2RwZIvnVEmPfMRWRgU4mAKxLOGVr4xCQSwpAn6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1NzCILdJ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-455b63bfa52so48565e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 07:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753884908; x=1754489708; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I4+L0TRrbKfeMptWOF+KOHxeAqWzgf2LgjSdfKaxF7M=;
        b=1NzCILdJaWVRImpDaD6CyNO330T2Fethb7v9lhFBoTy+TAMzZk+Tw3fVCY794/W5CX
         HK2kVU3hnYy7CDnkan0Y/5Va/HHDEVSyoDK4iXg/kpp3wBGW4KJAS2wWDtBLk9Z0Sv9n
         Oeh6fgGtgXAZej1y+et+zlHbAr5CpLgyGrZd7R7g1RjLkzrObSJO0Kn3W4XaTHv15ojv
         Tf0HFz7kSbpE/0NBhVZ9WOOBmtsMSO0NRZpdq5TTUWAMcHCyD48SARJ5UYxpAcrhnjFX
         B2OBWGjeoigp8i0jZJJH9FwmGiz+ZwBbx6UxsSvylfQHKHZayWsvb50MDCSl1ENB8PI8
         rXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753884908; x=1754489708;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4+L0TRrbKfeMptWOF+KOHxeAqWzgf2LgjSdfKaxF7M=;
        b=hZmHA81Tt0PVq16RPM5fWp+8aAWxfIKpz448ANyxyQcN27pePgcJKOjXn48wtG7RH+
         5IFd5arh3+/lK2BtulA0orW5fRDw1aCGS7RE+NCSZVlevYzWfa0PN5rIQry9qTs38Cjz
         dkD/QdtJIgjtYWfCxTEAIfqH//klRlcEOX5mQsxQR3MWbhMtoel3OUfHMjdOWVuJfe8p
         tt5ogwxgFnddXGtchdKS9LGOXGGxXtPks60ds3NQjDrpiBYI19+99yGs0PDsBerJzuiE
         Qqj3rQIL1gH4OZP8z/hQgM9Nvq133zA0sUxjao88N9kgFmt36Oe2qyVjwbQ7Lz1uN5dw
         6TdA==
X-Gm-Message-State: AOJu0YypP+sSKG38M9SzYMzyxaioLp/hIQg9N6uya89G2DkvARMdR4Nc
	mE1ceykW+xGadA82QjC+brYP3JoBrUnhxntoG7LArXg260kDx4K0W4AedsLdF4NQwQ==
X-Gm-Gg: ASbGncsr/qNio/lizFgDuGAzFCJF6y5m6PITkLzygKoj0GcHkT+2UEieNqUJCLCe7mT
	H1wRvDHPJUSprzV/dP5Tlgrj4iQWxhPH3nIQoHUxPm81d8ZYiAux7qWFqZ+gXoaZdNCPg6Ese+K
	6BtceKbd3Osozrlu6+ZmJcUipSDfWGI5M+dsxooVjp94RJa3yFtY8hVO/wm9Z7tdZLyNYI7kN1P
	rwNLznVgD3OeL9EC1CDaJTwpxlHcX/DjCSFVVl5F6zQ32hTC5H/MG80aUP0awNVl5Z/olyG3d3q
	qSME+rKVkCLHzt472Q+xEmb+oXG73YBM7y1pZarITGAp7msUQ9ssvY66b+/S6efOEZ4owf9jY/i
	Tz4xhNWN1NJVQZb34JCr8SCJa4nEochlJ87eSZt4Qmf7XZFqykxLLr/x7nw==
X-Google-Smtp-Source: AGHT+IGf+nqk8hUUYOT/Ug8jvnz/rvBUPLPdvrKiWSmfs0dNw1c+zXNNijUymnunrKKYuXHG602Q/g==
X-Received: by 2002:a05:600c:c0ca:b0:453:65e6:b4a6 with SMTP id 5b1f17b1804b1-4589add191bmr854275e9.6.1753884907947;
        Wed, 30 Jul 2025 07:15:07 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778f0c866sm15495639f8f.55.2025.07.30.07.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 07:15:07 -0700 (PDT)
Date: Wed, 30 Jul 2025 14:15:03 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Message-ID: <aIoo59VdZ24F4nsB@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aIZxadj3-uxSwaUu@google.com>
 <yq5a8qk7bml8.fsf@kernel.org>
 <aIiXSNgqt_6xuaRD@google.com>
 <yq5att2u9jvi.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5att2u9jvi.fsf@kernel.org>

On Wed, Jul 30, 2025 at 01:43:21PM +0530, Aneesh Kumar K.V wrote:
> Mostafa Saleh <smostafa@google.com> writes:
> 
> > On Tue, Jul 29, 2025 at 10:49:31AM +0530, Aneesh Kumar K.V wrote:
> >> Mostafa Saleh <smostafa@google.com> writes:
> >> 
> >> > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> >> This also allocates a stage1 bypass and stage2 translate table.
> >> >
> >> > So this makes IOMMUFD only working with SMMUv3?
> >> >
> >> > I don’t understand what is the point of this configuration? It seems to add
> >> > extra complexity and extra hw constraints and no extra value.
> >> >
> >> > Not related to this patch, do you have plans to add some of the other iommufd
> >> > features, I think things such as page faults might be useful?
> >> >
> >> 
> >> The primary goal of adding viommu/vdevice support is to enable kvmtool
> >> to serve as the VMM for ARM CCA secure device development. This requires
> >> a viommu implementation so that a KVM file descriptor can be associated
> >> with the corresponding viommu.
> >> 
> >> The full set of related patches is available here:
> >> https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstream-post-v1
> >
> > I see, but I don't understand why we need a nested setup in that case?
> > How would having bypassed stage-1 change things?
> >
> 
> I might be misunderstanding the viommu/vdevice setup, but I was under
> the impression that it requires an `IOMMU_HWPT_ALLOC_NEST_PARENT`-type
> HWPT allocation.
> 
> Based on that, I expected the viommu allocation to look something like this:
> 
> 	alloc_viommu.size = sizeof(alloc_viommu);
> 	alloc_viommu.flags =  IOMMU_VIOMMU_KVM_FD;
> 	alloc_viommu.type = IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
> 	alloc_viommu.dev_id = vdev->bound_devid;
> 	alloc_viommu.hwpt_id = alloc_hwpt.out_hwpt_id;
> 	alloc_viommu.kvm_vm_fd = kvm->vm_fd;
> 
> 	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
> 
> Could you clarify if this is the correct usage pattern, or whether a
> different HWPT setup is expected here?

I believe that's correct, my question was why does it matter if the
config is S1 bypass + S2 IPA -> PA as opposed to before this patch
where it would be S1 IPA -> PA and s2 bypass.

As in this patch we manage the STE but set in bypass, so we don't
actually use nesting.

> 
> >
> > Also, In case we do something like this, I'd suggest to make it clear
> > for the command line that this is SMMUv3/CCA only, and maybe move
> > some of the code to arm64/
> >
> 
> My intent wasn't to make this SMMUv3-specific. Ideally, we could make
> the IOMMU type a runtime option in `lkvm`.

Makes sense.

Thanks,
Mostafa

> 
> The main requirement here is the ability to create a `vdevice` and
> use that in the VFIO setup flow.
> 
> -aneesh

