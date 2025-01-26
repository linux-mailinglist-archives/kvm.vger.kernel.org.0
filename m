Return-Path: <kvm+bounces-36601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C85E7A1C63A
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 04:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C5A57A3585
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 03:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC401991B8;
	Sun, 26 Jan 2025 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e/VhD3H6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BFF7494
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 03:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737862495; cv=none; b=PAI7DM46KLfP6WP0ShhnB5HLtdjZOQZVSYjKxClYaV8E4S+hZhvcXXaeTA/NWwbDGfLSq/6cmBjkLhdjoCnPxFTQOckCwFqreBQJHGqFmf4Gxijb+pl2Sc7bgYahjRYkrc+6L1dvJbvMCja+Vir4d3k4YS33ZdNttF2dWHOvviA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737862495; c=relaxed/simple;
	bh=AxH/KOjNZ7bGqZuAZbGbffqbSslE+PDxCx1zDr03ZS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiwhzheVnxcp5NMYhWdp8qxwhOyKLMHGE9b00LrLQyD2J7Znn2aPJu9ZlBTJYa2k91LLR1PJKKkqdf2kGjd/kDAzj3devkTST/RDNVPSRR64e91VvEX50oqfBt3BHD+U5X9qHBRNJqs9jB4yzrM7TGAZfhuH8Q5vXw4924YFFmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e/VhD3H6; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737862494; x=1769398494;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AxH/KOjNZ7bGqZuAZbGbffqbSslE+PDxCx1zDr03ZS4=;
  b=e/VhD3H6vlfBmQbKdyGTfALt23zEY6HA6UVPqvDK6e0X28IiWTHvyOxv
   wMJJMuEUNNGGi/FPpKkazj2EcW2km8wKKBgapa6RlKqTwq2AaMtNClfrG
   ZfhsWNFZIQCqYQrouE/KWPBJS/4bgO/JTnyY/AcQasx/JwLUDYItkHjY/
   v9TmVq3OIoa+PJccPaF2RZXswdSX4eJ4YpcFkMx3gXmsWISDpMG7myi7W
   bTemoN7rmIqgt3FUrXk2K3fufqMsosofD1IPc/UUr781x9gCJhS8a+El5
   XuKOV4YQqpmbOPItmuZEF8N3fr+OJ42qk6AUcljdmNo+Nl7ehSPbXAkOh
   g==;
X-CSE-ConnectionGUID: w0bI4/a/Rya7LyM+9dRgQQ==
X-CSE-MsgGUID: 6sZBx4icT/+mfcmDTtDc7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11326"; a="37611640"
X-IronPort-AV: E=Sophos;i="6.13,235,1732608000"; 
   d="scan'208";a="37611640"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2025 19:34:53 -0800
X-CSE-ConnectionGUID: LP9krpO0Rt6/x9mLgNPCXg==
X-CSE-MsgGUID: Hmg03IfQRwyvDtewIGau1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,235,1732608000"; 
   d="scan'208";a="113126474"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 25 Jan 2025 19:34:50 -0800
Date: Sun, 26 Jan 2025 11:34:29 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Peter Xu <peterx@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z5WtRYSf7cjqITXH@yilunxu-OptiPlex-7050>
References: <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
 <Z5Jylb73kDJ6HTEZ@x1n>
 <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050>
 <Z5O4BSCjlhhu4rrw@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5O4BSCjlhhu4rrw@x1n>

> Definitely not suggesting to install an invalid pointer anywhere.  The
> mapped pointer will still be valid for gmem for example, but the fault
> isn't.  We need to differenciate two things (1) virtual address mapping,
> then (2) permission and accesses on the folios / pages of the mapping.
> Here I think it's okay if the host pointer is correctly mapped.
> 
> For your private MMIO use case, my question is if there's no host pointer
> to be mapped anyway, then what's the benefit to make the MR to be ram=on?
> Can we simply make it a normal IO memory region?  The only benefit of a

The guest access to normal IO memory region would be emulated by QEMU,
while private assigned MMIO requires guest direct access via Secure EPT.

Seems the existing code doesn't support guest direct access if
mr->ram == false:

static void kvm_set_phys_mem(KVMMemoryListener *kml,
                             MemoryRegionSection *section, bool add)
{
    [...]

    if (!memory_region_is_ram(mr)) {
        if (writable || !kvm_readonly_mem_allowed) {
            return;
        } else if (!mr->romd_mode) {
            /* If the memory device is not in romd_mode, then we actually want
             * to remove the kvm memory slot so all accesses will trap. */
            add = false;
        }
    }

    [...]

    /* register the new slot */
    do {

        [...]

        err = kvm_set_user_memory_region(kml, mem, true);
    }
}

> ram=on MR is, IMHO, being able to be accessed as RAM-like.  If there's no
> host pointer at all, I don't yet understand how that helps private MMIO
> from working.

I expect private MMIO not accessible from host, but accessible from
guest so has kvm_userspace_memory_region2 set. That means the resolving
of its PFN during EPT fault cannot depends on host pointer.

https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.com/

Thanks,
Yilun

> 
> Thanks,
> 
> -- 
> Peter Xu
> 

