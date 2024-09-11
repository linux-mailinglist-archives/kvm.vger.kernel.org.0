Return-Path: <kvm+bounces-26465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CCB974A69
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 531AD28236D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E6582876;
	Wed, 11 Sep 2024 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BH4m3kQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A3C182D2;
	Wed, 11 Sep 2024 06:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726036119; cv=none; b=uP8JpMANvVu2+U9JHnvsjCtJc63KO6Tgi1xPrn3sYoOz5ac2U2c0DQXNlTUqQ3wVf++9XrWEYmCICxha7tQ0xlt0rJuQe3bK6YBvFPzWqclFqCcg1O0g6ofoig2cLNZv7pyPLTTW2vclWtY8NpD7jPMn7aqKsKOQWERco/QQySU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726036119; c=relaxed/simple;
	bh=NsQoCjaPJFpWZkhQgbCeOWbAOMlaZWlcHP2l+8reT9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHd1qVWzaO/EPcayEHlatFZKDKVeO4BLS+deJKu12pVdRKXZvDLSO2cdhdpiwwroqp6CXzL3KyaaNuPxkWNyxb3GpC/XDG73dT2EOIhbnN6g7nG51SuHxm+bsS5JwAcl9A8lM3GCEjuFFUSnjO4e2vKjx9Z/K4U3KJmmuPfW8NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BH4m3kQ+; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726036118; x=1757572118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NsQoCjaPJFpWZkhQgbCeOWbAOMlaZWlcHP2l+8reT9w=;
  b=BH4m3kQ+KGw8aPG72ebxEgR4TvMv+AUtbw/KWZPuVyDWocHcxTKhCK36
   ZxZeQ83gzoiQyxod97M1Yv/MtE4xBK5rf34lkcMElwUoYz7cqzulKGyHz
   hZLFcrXbE1R2owCKPq2HQB3v7aX0v4YPpakivv4bt/KJZlDJN3SQ6TQMs
   S5amUnfmQkZk4a0HlWCk6yGNAAcf1q/zChHT0JJ+0ho1e4ZrzSi2jgB2S
   YvVFfkH/tzYaSwXLzwRUUSRK5mgNxGbllLv6LzQyd1+O7x1lonM+e3OQl
   xLrwpe+4wMkxmAmdBCmXxA3iwQylGtSDGpTWUDzGYQCHStucauLymWKVC
   Q==;
X-CSE-ConnectionGUID: yPj78ZWuS36UiBlUCPcVHA==
X-CSE-MsgGUID: kY3pvr/3R82AcYPsBjl4Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24954696"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="24954696"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 23:28:37 -0700
X-CSE-ConnectionGUID: t38wI+GEROCvySXWDSC2sg==
X-CSE-MsgGUID: m4/0mm1UR8+wIBZanDfs8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="71880390"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 10 Sep 2024 23:28:34 -0700
Date: Wed, 11 Sep 2024 14:25:54 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com, nik.borisov@suse.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Message-ID: <ZuE38n/yhI24vS20@yilunxu-OptiPlex-7050>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904030751.117579-14-rick.p.edgecombe@intel.com>

> +static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
> +	 * private EPT will be flushed on the next TD enter.
> +	 * No need to call tdx_track() here again even when this callback is as
> +	 * a result of zapping private EPT.
> +	 * Just invoke invept() directly here to work for both shared EPT and
> +	 * private EPT.

IIUC, private EPT is already flushed in .remove_private_spte(), so in
theory we don't have to invept() for private EPT?

Thanks,
Yilun

> +	 */
> +	if (is_td_vcpu(vcpu)) {
> +		ept_sync_global();
> +		return;
> +	}
> +
> +	vmx_flush_tlb_all(vcpu);
> +}

