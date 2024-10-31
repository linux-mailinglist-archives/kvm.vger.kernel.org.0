Return-Path: <kvm+bounces-30162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A85A9B77B4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDFD31C21CB3
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DC8196C7B;
	Thu, 31 Oct 2024 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cy0BrY2P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAC91946CF;
	Thu, 31 Oct 2024 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730367487; cv=none; b=TJnvZhVbhmOE7Fie6NoQTBAobA/4Iz7MKLt+tfXsGyCEHi5Bqg4v8EPeAp/xax+BM2JIaBT2WrrE6j+AVwl2UTlBBHRPGjjXBiR3F4PCUCmSnyBQ7ycKmeKrmuNuyLaqyNhQvI0WMDMmBzRY5UkeUNrZkF6zmmGn+4FhtufQc08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730367487; c=relaxed/simple;
	bh=hGJmDyB3p1Y6/eVa1XcO7bP2MXZb9GFzininqLTSFxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plcs28mvScUxE3PYhGbqJ1m8x27zhLXnDSA9wj21R5pXEog5fo4du7QK9H6KRxetVBr6yJOe+GyYjS4Ab9ZX/1mC4xpCus2GRT2emWSc6n4sHO9e0oRHWRmNuBnfsLNm4ikpa4pGyVqX+629TG7uieWg1WPZS7bd9dhh7k23u7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cy0BrY2P; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730367485; x=1761903485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hGJmDyB3p1Y6/eVa1XcO7bP2MXZb9GFzininqLTSFxw=;
  b=Cy0BrY2PMFUD4QKJr+Ei/51zOqKNjA9dNMYjDkd37h1fNF6vfF6BporH
   nNsmFvHuHHNIxZlnfkfVUbubZqTYp9Xr5BLxEj2MZx4hd89EwmGNdoXjY
   cA/YgEc10tR40jelJC6zs7n19Vtc7AcyavLsaE5jEn54u5mjZSxjaa87Y
   C8oeKLJeWwrL+hLJbZmjBXck/gi3DYB+DoU36oFWlgUrvEu/jzLhKMNrl
   O0DAinhgsrOPsaiknLuDhN/dHrQhAp90DUabCp5871u+zRKGwR9yWbrSO
   5WBMzVHhqXHM4DE0XlQeazH/lgPMcsXeUbl83msM71K3R/NUKxXaktGml
   g==;
X-CSE-ConnectionGUID: wU/SsoaESlyM+RXp2r0/zA==
X-CSE-MsgGUID: Jiim5T2PSNChpVhOHdx5OA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="34027227"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="34027227"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:38:04 -0700
X-CSE-ConnectionGUID: fXyzVN9ZT7uVl5DrNiSfaA==
X-CSE-MsgGUID: 1uqweDCwRXmsrNNn/tUcLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82232403"
Received: from slindbla-desk.ger.corp.intel.com (HELO localhost) ([10.245.246.164])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:37:59 -0700
Date: Thu, 31 Oct 2024 11:37:55 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Message-ID: <ZyNP82ApuQQeNGJ3@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
 <bb60b05d-5ccc-49ab-9a0c-a7f87b0c827c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb60b05d-5ccc-49ab-9a0c-a7f87b0c827c@intel.com>

On Thu, Oct 31, 2024 at 05:23:57PM +0800, Xiaoyao Li wrote:
> here it is to initialize the configurable CPUID bits that get reported to
> userspace. Though TDX module doesn't allow them to be set in TD_PARAM for
> KVM_TDX_INIT_VM, they get set to 0xff because KVM reuse these bits
> EBX[23:16] as the interface for userspace to configure GPAW of TD guest
> (implemented in setup_tdparams_eptp_controls() in patch 19). That's why they
> need to be set as all-1 to allow userspace to configure.
> 
> And the comment above it is wrong and vague. we need to change it to
> something like
> 
> 	/*
>          * Though TDX module doesn't allow the configuration of guest
>          * phys addr bits (EBX[23:16]), KVM uses it as the interface for
>          * userspace to configure the GPAW. So need to report these bits
>          * as configurable to userspace.
>          */

That sounds good to me.

Hmm so care to check if we can also just leave out another "old module"
comment in tdx_read_cpuid()?

Regards,

Tony

