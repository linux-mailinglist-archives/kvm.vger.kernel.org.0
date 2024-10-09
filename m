Return-Path: <kvm+bounces-28169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C99C995FDD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2518E285CBB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE3315FD01;
	Wed,  9 Oct 2024 06:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ckztxtdx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA531DA5F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455711; cv=none; b=GfD8Nhob2+qzIrtNo6KIoTUmLNRgI89Zm5O/xGwzIuP+oVA2LSu9boXTOfc5Szm+zPS9IFubj3x6aJkrPFVW5w6iGvYx2uuMh02cJhUntwhW34mUjnDKFKOGAGHRF1WSc2bWeImnwrs74Ge7vVCluuqruaXZYSJWUFKVu2roCuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455711; c=relaxed/simple;
	bh=oQRmH+fcm9FTEP+iuu4nyOE/JFb61Get/pyjqeqHQAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fxyd/BjqI0xry/UAHk7lnn0WaU9PM2tZIyfcNxBbKwhoCFLtxkmP30U5lsZgZOjYCnCes345scHFBm8hzVQTH+jQFAWi1s9EO7KCwNgJqKPQZiil3N8AEqbeWbrwVKI64WZS8/g60D15IkDgF4zhis9Dtx243mkNvWVENQ9u3TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ckztxtdx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728455711; x=1759991711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=oQRmH+fcm9FTEP+iuu4nyOE/JFb61Get/pyjqeqHQAM=;
  b=CkztxtdxadHra1u8Oxo5VQUjf3kgK5/QDncuLP4+XQ273ixqPBBmaEWI
   yn5TVUHQc4umms9CQhyr9jNtfsuMOfR/HBirMK4BQqVk5Ieqr0r2j46kn
   UOnXzb6hesp9zBSCIiRTEvbVhaVcdDU8GQkBne5J4dcLDzqYqTQE+m5ky
   c896UhQoVpDql01XYhTQ2zdc/OgGqYfSoEMo5D9s9j4xHABUXr7hr2QDd
   3QO8dS9zHKgRyLwFTK9pX4OkoiYtNWWleJWPRGgWx636aWJcD/nvRqSum
   mTbSNJiDQ7TDpaRFXsUJUvgUEI843gpB8QZOYNKqL+aDAh56+p8aaGofr
   A==;
X-CSE-ConnectionGUID: QSZAWQ8/ROKJF2il/Q4GIA==
X-CSE-MsgGUID: 4QlZk4hwQ4ufjIvPrlM7WQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="39127638"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="39127638"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:35:10 -0700
X-CSE-ConnectionGUID: J/jUx0I6T+GzB++A/NzQIA==
X-CSE-MsgGUID: 8hMyCA4ZRMmAb30/h4sbSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76152091"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 08 Oct 2024 23:35:04 -0700
Date: Wed, 9 Oct 2024 14:51:16 +0800
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
Subject: Re: [RFC v2 00/12] Introduce Hybrid CPU Topology via Custom Topology
 Tree
Message-ID: <ZwYn5ETRdd6dxfXU@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
 <20241008113038.00007ee4@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241008113038.00007ee4@Huawei.com>

Hi Jonathan,

On Tue, Oct 08, 2024 at 11:30:38AM +0100, Jonathan Cameron wrote:
> Date: Tue, 8 Oct 2024 11:30:38 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC v2 00/12] Introduce Hybrid CPU Topology via Custom
>  Topology Tree
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Thu, 19 Sep 2024 14:11:16 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> 
> > -smp maxsockets=1,maxdies=1,maxmodules=2,maxcores=2,maxthreads=2
> > -machine pc,custom-topo=on \
> > -device cpu-socket,id=sock0 \
> > -device cpu-die,id=die0,bus=sock0 \
> > -device cpu-module,id=mod0,bus=die0 \
> > -device cpu-module,id=mod1,bus=die0 \
> > -device x86-intel-core,id=core0,bus=mod0 \
> > -device x86-intel-atom,id=core1,bus=mod1 \
> > -device x86-intel-atom,id=core2,bus=mod1 \
> > -device host-x86_64-cpu,id=cpu0,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=0 \
> > -device host-x86_64-cpu,id=cpu1,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=1 \
> > -device host-x86_64-cpu,id=cpu2,socket-id=0,die-id=0,module-id=1,core-id=0,thread-id=0 \
> > -device host-x86_64-cpu,id=cpu3,socket-id=0,die-id=0,module-id=1,core-id=1,thread-id=0
> 
> I quite like this as a way of doing the configuration but that needs
> some review from others.
> 
> Peter, Alex, do you think this scheme is flexible enough to ultimately
> allow us to support this for arm? 

BTW, this series requires a preliminary RFC [*] to first convert all the
topology layers into devices.

If you¡¯re interested as well, welcome your comments. :)

[*]: [RFC v2 00/15] qom-topo: Abstract CPU Topology Level to Topology Device
     https://lore.kernel.org/qemu-devel/20240919015533.766754-1-zhao1.liu@intel.com/

Regards,
Zhao


