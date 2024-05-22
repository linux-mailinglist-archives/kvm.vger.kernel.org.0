Return-Path: <kvm+bounces-17973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 786B58CC535
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 18:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6DCB1C212CF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 16:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A26781420D2;
	Wed, 22 May 2024 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Hgc0UHia"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53318141987
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716396994; cv=none; b=UxJa8rnKo5iamgXSyTUeH6z0dDypS+gdMRA5sSl43suwl3CrC7BXx/5aK0RgQm4LZW+LptPHE0uT+2RbPp+nvcPNUfEX4H/VZLVDxVxFb5gow71ywnuvaQLnVqw56A/pXyVsOo5CuOrp78tWQBJiUbA05upLR3Fv+JCc5V7Ic5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716396994; c=relaxed/simple;
	bh=K/QFqvmIUmvv+6I66+VxZaEmsXlY7Dd6DLzcMLWByuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwKNv0DENryazsxOWGswqdA40XLvq7feStBsAaAMbHK2GIawOl33kGWEI+G12owfGz8xhvWKLkulSubUrsbXdD4x1EGmnfq7gz/Rk9KWmRnr27v/mfvPWmuo1L2cupQhZRD1VyKEg3CIydU4keKMuDZ/YXl/ak2QucbLtZgccH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Hgc0UHia; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5206a5854adso5978853e87.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 09:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1716396991; x=1717001791; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v4VWbigBV97aeZyxhifeEI6VQ++Df9sfCivB+cI7pOU=;
        b=Hgc0UHia+N1oUrRYGADRbxr1BUmABZenh3NNQl6bfkQbz77HekguN9TBpx6z9FxdnI
         L0Q17QBAtnQd1UQHTM7vaAoLfOEsCBFx5A3mDFJ18EQyrk6YmOomyKYmyGLWdVbWwdmN
         xyUM91E4X4avohwVmMXbLmjCWs14HSGbumACoK4Lvbqdyg3GQcnZFooZcWObqngebbWZ
         zo+VvVJJBqKbGPUWQY5k7hOIDpb3oewk3k+uZ7xrJNZeg7JtOIm+8RRC5f8Aqn3TKoCG
         BwfgDdgJmVxl454mqdJuHJEJQHc9ZQ/q1stDuDyvPW6h2Od5t1rcbvgnHpzDpcWtAmDz
         iCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716396991; x=1717001791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4VWbigBV97aeZyxhifeEI6VQ++Df9sfCivB+cI7pOU=;
        b=alNgrxzbg0yGBjrSkLFRwtWPuF5UVVFqAUmT/P/vNh9+/5NmRkP/yBKdgoXpHRaLST
         0x/12T8Cj9tGJYVALwNI5fkWasOMyfCnE/00gMYGbxW87CpsnYb96bsZbmt4LcXN1niv
         Jt81oQPq0go8t0npUA5oAyRHKmalN1QKgx0MI/rJnWF09h0xO0th29KU2ZjGwkZNkhVV
         GXOrMr7ytzkoiwpkOxMBgUY6qx3xt3oNolDjVZNxw6XgnxXW9etmBnxukpdVqmd2HOYo
         3aUM1VNtyF7kLWGEG4ZrmAEIM2E+WDhYM0HzOFF7tkUNXYk78ayAih84xmfOf7wSm2mr
         3Tgw==
X-Gm-Message-State: AOJu0Yy/Y30WLdNP7C4YCW0mOpcQuMgpPjrohxNsLQvtrpiOFK9dkI3H
	ZOVdT1W2gRBxKUwSrpeI24efRpoEcJ4eoBQlVrFlzG50siZaqWbJlnLORN8xFrU=
X-Google-Smtp-Source: AGHT+IG7la7QdJ5gJEmQp6A/EREQqLjg3RbugtXHkWprUb8DAfwSzJsUVcwBr7yLjzDbpyCqEkbaYw==
X-Received: by 2002:ac2:5442:0:b0:522:2fa0:c3f5 with SMTP id 2adb3069b0e04-526bfc02eb2mr1542529e87.62.1716396991348;
        Wed, 22 May 2024 09:56:31 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17894d40sm1790774566b.75.2024.05.22.09.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 09:56:30 -0700 (PDT)
Date: Wed, 22 May 2024 18:56:29 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com, yishaih@nvidia.com, 
	shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <20240522-b1ef260c9d6944362c14c246@orel>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508125842.28193-1-yan.y.zhao@intel.com>

On Mon, May 08, 2023 at 08:58:42PM GMT, Yan Zhao wrote:
> In VFIO type1, vaddr_get_pfns() will try fault in MMIO PFNs after
> pin_user_pages_remote() returns -EFAULT.
> 
> follow_fault_pfn
>  fixup_user_fault
>   handle_mm_fault
>    handle_mm_fault
>     do_fault
>      do_shared_fault
>       do_fault
>        __do_fault
>         vfio_pci_mmap_fault
>          io_remap_pfn_range
>           remap_pfn_range
>            track_pfn_remap
>             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
>            remap_pfn_range_notrack
>             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
> 
> As io_remap_pfn_range() will call vm_flags_set() to update vm_flags [1],
> holding of mmap write lock is required.
> So, update vfio_pci_mmap_fault() to drop mmap read lock and take mmap
> write lock.
> 
> [1] https://lkml.kernel.org/r/20230126193752.297968-3-surenb@google.com
> commit bc292ab00f6c ("mm: introduce vma->vm_flags wrapper functions")
> commit 1c71222e5f23
> ("mm: replace vma->vm_flags direct modifications with modifier calls")
>

With linux-next I started noticing traces similar to the above without
lockdep, since it has ba168b52bf8e ("mm: use rwsem assertion macros for
mmap_lock"). Were there any follow ups to this? Sorry if my quick
searching missed it.

Thanks,
drew

