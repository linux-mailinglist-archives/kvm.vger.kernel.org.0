Return-Path: <kvm+bounces-35011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A5CA08AD8
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E1F47A31DB
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DAC2207DFB;
	Fri, 10 Jan 2025 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+uMJY+O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5D19AD8D
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499690; cv=none; b=CdJ8OUgGVpB+0u/dyOJ5tjB5/7d4cvfJ7TrAfu0lUzanb1wLBCqn27seNE8Yg7I4PiYNYwGphMdcb1hH3pgCJU1jI5hRU0Pt3gxRFkJvS8GflJeRXEnKbYylcUszokSuk4AqtX5gdCtarcRKZ0jv39CUJNfW4orkLJxLMk4SK+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499690; c=relaxed/simple;
	bh=1us4fXVzOkfuT8fX3fvia/Fj4+R3C6A1nDoeCiptz7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzfKnYq+D5WX5yjeLF3uOrxmQoUkUapFTKYoFyHITDHp+5O1a88Rnf2Zid/xtBsw8G8YGqDLyyzdyfYacPZ31r+7KTAsyqcS57YYp+2IJ+7LUHmkC+ZM6PG5yhIPGU6sBNlygFpGpyOhv+qPTeCLA1xO3bfYvLFWmRtzDCJTbnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+uMJY+O; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736499689; x=1768035689;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1us4fXVzOkfuT8fX3fvia/Fj4+R3C6A1nDoeCiptz7k=;
  b=d+uMJY+O9EUjMLvE09nGvBHJtWUi1X2K2vF7kizbQD9d1RWaOOsDdkz4
   qPsY7sdTlSS6osQbAOlN6OEo7IYnE4I7nHhVBI4S1WNEOlNR5F0Fp0MwL
   QwMvDTIY1r9Z/nR6CLCACAhf5a6FaDCWSKACGd8e6L2x228RTIRbWW3Q5
   EmARRbm3vDKN1UOLobfemTG2xAZOdvKZtBc/lKiIxM4jx5bxKWKqN/fxV
   X3fDXvIE7FIjSKQpYZMpdduFIUueGRBztTEtvWtMjdqdDTnOc88LGEjHG
   OmHXwpZcdC2llZ+Y1T8I5gP9wDuk3zvR9vI8fzH9+kmllU6f/ji2FPDRJ
   Q==;
X-CSE-ConnectionGUID: AC9HiRD7SDe0bw9vS8C8Mg==
X-CSE-MsgGUID: By+0vUkKQeKIVHStYf7ILQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="36003709"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36003709"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 01:01:28 -0800
X-CSE-ConnectionGUID: 2pjZm/zQT9ypQ4cjDZMQJg==
X-CSE-MsgGUID: ob4Ci4fNReCrV/2Uae5ZFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="134514576"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 10 Jan 2025 01:01:26 -0800
Date: Fri, 10 Jan 2025 05:00:22 +0800
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
Message-ID: <Z4A45glfrJtq2zS2@yilunxu-OptiPlex-7050>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>

> > 
> > https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
> > 
> > but I am not sure if this ever saw the light of the day, did not it?
> > (ironically I am using it as a base for encrypted DMA :) )
> 
> Yeah, we are doing the same work. I saw a solution from Michael long
> time ago (when there was still
> a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
> (https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)
> 
> For your patch, it only implement the interface for
> HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
> the parent object HostMemoryBackend, because besides the
> MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
> MEMORY_BACKEND_FILE can also be guest_memfd-backed.
> 
> Think more about where to implement this interface. It is still
> uncertain to me. As I mentioned in another mail, maybe ram device memory
> region would be backed by guest_memfd if we support TEE IO iommufd MMIO

It is unlikely an assigned MMIO region would be backed by guest_memfd or be
implemented as part of HostMemoryBackend. Nowadays assigned MMIO resource is
owned by VFIO types, and I assume it is still true for private MMIO.

But I think with TIO, MMIO regions also need conversion. So I support an
object, but maybe not guest_memfd_manager.

Thanks,
Yilun

> in future. Then a specific object is more appropriate. What's your opinion?
> 

