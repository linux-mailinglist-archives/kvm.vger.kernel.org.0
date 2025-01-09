Return-Path: <kvm+bounces-35021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E20DA08D12
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB0D3AB521
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBC2209F53;
	Fri, 10 Jan 2025 09:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJcpAN39"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE46A207A2A
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736502702; cv=none; b=UZ9ZXKvmFZxO1qT3UxT4sbEF7hoonNDyifr3YFR0/NDHkUN8ymcw8pqRARwsJvyXfoShlhDG67MfRN/xbaUXHAOD1FYECHVBol8FhwN4MOLaCLmwAh3ea3aQIgqyCRXXYN+/xmY2hu11VqzdL5kpatTnNEPR/CVBekdXHow7PDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736502702; c=relaxed/simple;
	bh=dlRCjbceXiOhOjqzagMQ1Mu3ZftwOVkJg5fOlUkDJqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hohcSpHHR9LP3LuLLeCWbiHRBv+f3mIn7DbF19fxpmJAcZ27O+/Bt1y+j6kc+Mc0miDpn25JitrSXDmj0il/nCQSbdp4x6GsCk56OVQSeqlpLt5PRwOFDzH/DNnGIC2q823vAzCVV6dN+H2B6XmCVCvgTQu9Mz5zawiLkzkOc1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJcpAN39; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736502700; x=1768038700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dlRCjbceXiOhOjqzagMQ1Mu3ZftwOVkJg5fOlUkDJqE=;
  b=oJcpAN39FuwmdXrDdjq8D1ikwXe4SJTX0oYvzy8gVQcd8vhQ7zl813cg
   4y6XZq8C23BxNbGbBbjI5wC8hoqoH5tkEdvp98ttMbc4il6lLUGVE7PM1
   l3bOJYlz8LMAOFS8fFqID8exocs+xJ3BwvfQLceyDhhwxL+gGtzvdj9S1
   vHvOU9miqRferjoTSyL3ocLRXfAUVRiRYzrVqXrDLiaD6bFVl+xHBSO6l
   IXVLE11FRwlE8skxOA86M2ToIyCQRTj0N9xRweSmBeuYu223zqRsH3ETL
   3wlAV35+IUY326dfRF0yR0iT6ld0NqWNRAUmbV0+QkBd/hrHvf4YbzOCZ
   Q==;
X-CSE-ConnectionGUID: KZcl0M9bS1a1aBbmPOV/QQ==
X-CSE-MsgGUID: sXU+OZ7QRNeJscX8KP8pAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="47458149"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="47458149"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 01:51:40 -0800
X-CSE-ConnectionGUID: sfEaav1hRwedm1aEQy2Pzg==
X-CSE-MsgGUID: +GZZj3wXT8K8qCwrRmn3Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="104245902"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 10 Jan 2025 01:51:37 -0800
Date: Fri, 10 Jan 2025 05:50:34 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z4BEqnzkfN2yQg63@yilunxu-OptiPlex-7050>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <Z4A45glfrJtq2zS2@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4A45glfrJtq2zS2@yilunxu-OptiPlex-7050>

On Fri, Jan 10, 2025 at 05:00:22AM +0800, Xu Yilun wrote:
> > > 
> > > https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
> > > 
> > > but I am not sure if this ever saw the light of the day, did not it?
> > > (ironically I am using it as a base for encrypted DMA :) )
> > 
> > Yeah, we are doing the same work. I saw a solution from Michael long
> > time ago (when there was still
> > a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
> > (https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)
> > 
> > For your patch, it only implement the interface for
> > HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
> > the parent object HostMemoryBackend, because besides the
> > MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
> > MEMORY_BACKEND_FILE can also be guest_memfd-backed.
> > 
> > Think more about where to implement this interface. It is still
> > uncertain to me. As I mentioned in another mail, maybe ram device memory
> > region would be backed by guest_memfd if we support TEE IO iommufd MMIO
> 
> It is unlikely an assigned MMIO region would be backed by guest_memfd or be
> implemented as part of HostMemoryBackend. Nowadays assigned MMIO resource is
> owned by VFIO types, and I assume it is still true for private MMIO.
> 
> But I think with TIO, MMIO regions also need conversion. So I support an
> object, but maybe not guest_memfd_manager.

Sorry, I mean the name only covers private memory, but not private MMIO.

> 
> Thanks,
> Yilun
> 
> > in future. Then a specific object is more appropriate. What's your opinion?
> > 
> 

