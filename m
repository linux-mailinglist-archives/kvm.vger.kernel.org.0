Return-Path: <kvm+bounces-28167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A680995F8D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A3801C213F1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CBC1684A5;
	Wed,  9 Oct 2024 06:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luApfRkk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BF513AA27
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454527; cv=none; b=mE4cbO/7yxXD9HHkLMK1OM5XrH9/P7cG6CqVOzYE5jEVDisqrq9ChU1TOvZD3iBMaliAsYV+qVoL2ZyrJrH74ZjTnD6i/hflzC+NM0ysjx+GaBhspVybt6/MKWsyfnVaJHKspXWMcHvisksD/iOwdOlh3hN+JzTBv1w2EVNvw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454527; c=relaxed/simple;
	bh=Lt669vuESF+NLlyNvW3nMfB5lZgQCn13KNvjj5g2nMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L27qmSBOrKLG+AW7cuo7weDs30zJEUB9nL8ClRZ1hItFSCBD5m+nGvDkJXGwyLZ0wnX9VMSunU5eTsUEuu60z0/XnePB/ai/M5Puei8kGyKQILUQfrl/9ohu11WM2ywCMIQGGUYBOHkKnBk3cEEWyv6zp92I5lZYZxEqaznQBww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=luApfRkk; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728454525; x=1759990525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lt669vuESF+NLlyNvW3nMfB5lZgQCn13KNvjj5g2nMs=;
  b=luApfRkkLw/mojvj9f5a3zVwpg5QZS0i6s6zT6UBDyqwT2CMp5DJVrXr
   hjoIMDLTbT9e254Xfed2/qlIClhsCKGAYEMKUd1vPuzHnsIrwkCsCazGv
   N5jvGKwjHOtTMqJF1N6fUXe2/4FjlR/PyFr5cAsAEVLG6AoyDgt31468d
   xZqR4yihBQVr7WBqk5unlR8RK1VZRmCWHOBec2k5+Z1R/ve+NGqbs90km
   lawQoYYLy6OrBEqdkmzbWOBwBRV3SHlHrzNDQnUBh/rJMdo6TlTnzJDi7
   31G2LXA5cQjT28C1/x4+xkwLheuRiKQZAz/Hl5Nl5+ejD6VxSTJOdkSPP
   g==;
X-CSE-ConnectionGUID: A4a7QkKlTDKHvVe6Z9SPkQ==
X-CSE-MsgGUID: dz/olXsUQiiisKggyZHP7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="31513100"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="31513100"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:15:25 -0700
X-CSE-ConnectionGUID: UnMqb4StSIaCs9/73yv3Vw==
X-CSE-MsgGUID: kiLaGcXURCyU7A1OBQ9Q7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="106901495"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 08 Oct 2024 23:15:20 -0700
Date: Wed, 9 Oct 2024 14:31:31 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC v2 03/12] system/vl: Create CPU topology devices from CLI
 early
Message-ID: <ZwYjQ2mEa2OP5r//@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
 <20240919061128.769139-4-zhao1.liu@intel.com>
 <20241008105053.000059ee@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008105053.000059ee@Huawei.com>

On Tue, Oct 08, 2024 at 10:50:53AM +0100, Jonathan Cameron wrote:
> Date: Tue, 8 Oct 2024 10:50:53 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC v2 03/12] system/vl: Create CPU topology devices from CLI
>  early
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Thu, 19 Sep 2024 14:11:19 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Custom topology will allow user to build CPU topology from CLI totally,
> > and this replaces machine's default CPU creation process (*_init_cpus()
> > in MachineClass.init()).
> > 
> > For the machine's initialization, there may be CPU dependencies in the
> > remaining initialization after the CPU creation.
> > 
> > To address such dependencies, create the CPU topology device (including
> > CPU devices) from the CLI earlier, so that the latter part of machine
> > initialization can be separated after qemu_add_cli_devices_early().
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Other than question of type of category from previous patch this looks
> fine to me.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> However, needs review from others more familiar with this code!

Thanks!

-Zhao


