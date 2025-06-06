Return-Path: <kvm+bounces-48678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2205AD0A29
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72440175855
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8E223D293;
	Fri,  6 Jun 2025 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jstj1ls3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6BC1624DD
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749251154; cv=none; b=PsIX7nFbkDZm8zW8r/UBC1KmkBMyb6alhufUmwHjtQMsuoshrzx6n9wuHxXwe3qJIpBeoibykKhG39EAR4T53cprWpk7iy+fFphl4sHYGnLEB/u4FFtKxa0DLF/4XuqDW0cSxEc5BNZ9HP6TId+6RwDT6tRrV6NI8i0DyosAcVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749251154; c=relaxed/simple;
	bh=MW2wNb43ypWSdufjoPAtH5Ju1OuPQquVw5NL7Ah2DOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mu+cQ0+apoJ6lRC2Re/zxxQJ1eVfoGioBqWDweFrUoUc/ZLhjCFQUSmzjJHfdFX6o1tKHj4n/PNQIpKreIm8kOrMN4R8DffX3JFrNY4n1y0j0Pgm0BFfFJLInJXSyJ737bjdYX/wxr0jffBOaQ7wRsSDu+8++8Nf68yrfofUaRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jstj1ls3; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af908bb32fdso1808995a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749251152; x=1749855952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0KcYnorcCYmwOfCT2vfZqpyW+O1lNC3ODlw57DQvoE=;
        b=jstj1ls37+b0ljHgs1FVN8vUogS6+mRWa6UsUgac1qk0wDCF6HzBMEk40Fem+iJ0dZ
         P4eucJdBHwisN1wEDDZ/XKz/BbbrgIKkEZ0WZVAS4OJuCMkr1y4IBhSBW/rzao4rfwqM
         3v2bB+dq4ErzT5No65utgJd6HoRGkngfibJmLgldKUmajKWoLK2bOw5czOu8pWkLZXlS
         JnyfWIj0M/2YcGbRyAywy/otv97MmykCO8f5x5MDCYRXSO8OnYz6YtLIG+OonSG2uME0
         e1RZAvz+V2pUgZ0diP4GQkMNw9TEjI8noDO/2UOs8W0rSz3TsqEVMrxWlqY4Jv3VPjxb
         TFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749251152; x=1749855952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0KcYnorcCYmwOfCT2vfZqpyW+O1lNC3ODlw57DQvoE=;
        b=Z/NB1QcyCcN5dS88Ug/qWZtcvW0tdx63rvvq4CEmdukx4ddzERG2UdgtBQ0teY2enK
         tOsY8nMhPsledeTf+5QMbhRYkVKaTwHVLYVc6cX8Cf9nk2Tjh+yqc91mBEuLsXXFYmFE
         7QwFTzqw/u7S6DS7vV3CFKw4mej0o5NlUlRjciVMw9WcKxN3v+gSmoazGD1M7wB7cPiU
         NDKAx1T/7s5KQkR7GqF4evn2K+evrXc9ADeb7mzTHODwfdXPomSORxg6ZOrgOgwqpbD5
         67lly/Fbld2Q+kw5m5DKDcKbMoRHEyPaaRDjSR07D1aezqVp9EVzZyWN6nE93YAu1IoF
         6lnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDN1v6kVsmNZbe+tLS5CcOcKEePdWn3nad+xIiGQhwrASgnjSpq9LvO0AenPx4eK6QOPw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsUyAdUFUC1baaqnNU6GRbUER4Y7NWS7EmTPXWJq7jKJfrXoq5
	Op8ZfO2xlI/JmPEfN3d/FgIblK4TemhDqvhc22a1DHVHOSdQ71aLvIQGNoqLLqP4tw==
X-Gm-Gg: ASbGncvr8mifY5cD4qwXFNL+WHmEpLzRLkh9VHmUvq732vn8rSMFtqkL0bxSMJDtcqO
	5uN6DmMLf5TQk/gGPiXKZpRjcTVm80zo4o7oYZO5cHTZDTi5Tp2xT3ouOa0ch8GwfiK6LcksZgZ
	veof1CZAZFAe3lLa7yu5WrlTlMA7FFXLUS+AeTjwP2jHemqihVTQ9Lj9sFxjazRYOV7AvLeKEWm
	L0XbHAfznn1BevkmI6e5d9Xym6/OTOfOouomb3zIK6xGoXNi6obWDdd/KeaLyzLlcESFcSsLNBw
	D87F5eqhkYQ2vJVcEAyFozgdi9WM2ExqQIefZ3LSVhYcvhmRyI+yJTXabYesxHuoI5lekxrOot/
	Ve9B6GLJ5JHEALtHnJAHZ674a
X-Google-Smtp-Source: AGHT+IG7hO9GoY+lsjfIcKo8gdqn8/SJyMesPC+8pn55vRpHA2eE9UpdENnEjjBD2oj6HtS8wcJVKw==
X-Received: by 2002:a17:903:22c5:b0:215:ba2b:cd55 with SMTP id d9443c01a7336-2360204d1c3mr66275695ad.2.1749251151608;
        Fri, 06 Jun 2025 16:05:51 -0700 (PDT)
Received: from google.com (111.67.145.34.bc.googleusercontent.com. [34.145.67.111])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236030969ebsm17399595ad.72.2025.06.06.16.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 16:05:50 -0700 (PDT)
Date: Fri, 6 Jun 2025 23:05:46 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Vinod Koul <vkoul@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Adhemerval Zanella <adhemerval.zanella@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	WangYuli <wangyuli@uniontech.com>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Eric Auger <eric.auger@redhat.com>, Josh Hilke <jrhilke@google.com>,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	Kevin Tian <kevin.tian@intel.com>,
	Vipin Sharma <vipinsh@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 07/33] vfio: selftests: Use command line to set
 hugepage size for DMA mapping test
Message-ID: <aEN0Sr96nyJkN3fL@google.com>
References: <20250523233018.1702151-1-dmatlack@google.com>
 <20250523233018.1702151-8-dmatlack@google.com>
 <20250526171501.GE61950@nvidia.com>
 <CALzav=fxvZNY=nBhDKZP=MGEDx5iGqCi-noDRo3q7eENJ5XBWw@mail.gmail.com>
 <20250530172559.GQ233377@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250530172559.GQ233377@nvidia.com>

On 2025-05-30 02:25 PM, Jason Gunthorpe wrote:
> On Fri, May 30, 2025 at 09:50:22AM -0700, David Matlack wrote:
> > I'll explore doing this. For a single dimension this looks possible.
> > But for multiple dimensions (e.g. cross product of iommu_mode and
> > backing_src) I don't see a clear way to do it. But that's just after a
> > cursory look.
> 
> Explicitly list all the combinations with macros?
> 
> Enhance the userspace tests allow code to generate the
> variants? Kernel tests can do this:

I got a chance to play around with generating fixture variants today and
eneded up with this, which I think is pretty clean.

tools/testing/selftests/vfio/lib/include/vfio_util.h:

  #define ALL_IOMMU_MODES_VARIANT_ADD(...) \
  __IOMMU_MODE_VARIANT_ADD(vfio_type1_iommu, ##__VA_ARGS__); \
  __IOMMU_MODE_VARIANT_ADD(vfio_type1v2_iommu, ##__VA_ARGS__); \
  __IOMMU_MODE_VARIANT_ADD(iommufd_compat_type1, ##__VA_ARGS__); \
  __IOMMU_MODE_VARIANT_ADD(iommufd_compat_type1v2, ##__VA_ARGS__); \
  __IOMMU_MODE_VARIANT_ADD(iommufd, ##__VA_ARGS__)

tools/testing/selftests/vfio/vfio_dma_mapping_test.c:

  #define __IOMMU_MODE_VARIANT_ADD(_iommu_mode, _name, _size, _mmap_flags)	\
  FIXTURE_VARIANT_ADD(vfio_dma_mapping_test, _iommu_mode ## _name)		\
  {										\
  	.iommu_mode = #_iommu_mode,						\
  	.size = (_size),							\
  	.mmap_flags = MAP_ANONYMOUS | MAP_PRIVATE | (_mmap_flags),		\
  }

  ALL_IOMMU_MODES_VARIANT_ADD(anonymous, 0, 0);
  ALL_IOMMU_MODES_VARIANT_ADD(anonymous_hugetlb_2mb, SZ_2M, MAP_HUGETLB | MAP_HUGE_2MB);
  ALL_IOMMU_MODES_VARIANT_ADD(anonymous_hugetlb_1gb, SZ_1G, MAP_HUGETLB | MAP_HUGE_1GB);

  #undef __IOMMU_MODE_VARIANT_ADD

Let me know if you think this looks reasonable.

