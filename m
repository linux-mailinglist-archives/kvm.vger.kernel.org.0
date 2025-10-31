Return-Path: <kvm+bounces-61687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEB5C255B0
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 14:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 145CA4EBE92
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 13:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67810331A4F;
	Fri, 31 Oct 2025 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nK/cTSEf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A22D223DDA
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918720; cv=none; b=eHOzr+6y9btqpG59yh6KhgamE1S5P062LTkq740DC4muxE2I2kb82/v7R2jemlfz/rv8wdJ973HjmgbkLtd/qSV+dtOXD88P6mcgOFOzSPeU/6Fazpf+PAWZahytsYb5RAhEr/OJdjXYLHSGXEYbDZlJ4gRYeDno816me1WLIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918720; c=relaxed/simple;
	bh=u+AukBoxYg8JPWTyx5oeq6nDXLUMwXM4oa2t6x34USc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KqqwzYYjLtZXrX7TGw2B8woRFB8QRbjDPtKpI1dmDE3xoYrrlV6lgXg250huySxw6VujOAqAeDX0UDDTCr/+y2VQMyxNhmjjcEhoE+5ON/lpCh2aiFrZkCvLZ8pIIV71yYyxYQWLQ1VrDZQ9SV188Cc6xyhgILMER45e9AUzMWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nK/cTSEf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761918719; x=1793454719;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=u+AukBoxYg8JPWTyx5oeq6nDXLUMwXM4oa2t6x34USc=;
  b=nK/cTSEfWPzSEBQsWG3Js6gLTALJ04AP8+z6NDSolreHsS0tEQFdLXLD
   6ROj25EHVAfBJli2+TvYP48XAXgO6vNNPvjlx3Wt6pRZBTrqwHjBBT05n
   LfJcNjV2gBoaZSSXsoergc4gTTcKgICnklwphDhRktZ+RSYBlC5gNL/1r
   Qd71KWcZlyns29eabCYXOfSHexen/6HGTDn7oh+Bkqjrl/dF6gDqEctfH
   zojWBLbY8R5tdQ59aYrBiB97BC97hHovpesbavSCixn26qcZ4CajZp400
   drRL5wKK+tjS//1PYmBxyh/8hXBq5kKM6FLD3eVhGAieAuLFyy6bVQHw8
   Q==;
X-CSE-ConnectionGUID: mCqt1crKRZ+zVMOyuzAHvg==
X-CSE-MsgGUID: Ugw7TJ8ES96r6eW4C9alag==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="75195764"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="75195764"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 06:51:58 -0700
X-CSE-ConnectionGUID: Ddjw+4ofSW69aljn2c0LmQ==
X-CSE-MsgGUID: y2mHe97wTHmEVrk392RiwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="185454978"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 31 Oct 2025 06:51:52 -0700
Date: Fri, 31 Oct 2025 22:14:03 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <aQTEKyQjqIIGtyP0@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20251031113344.7cb11540@imammedo-mac>
 <0942717b-214f-4e08-9e2a-6b87ded991c9@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0942717b-214f-4e08-9e2a-6b87ded991c9@linaro.org>

Hi Igor and Philippe,

> On 31/10/25 11:33, Igor Mammedov wrote:
> > On Thu,  8 May 2025 15:35:23 +0200
> > Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> > 
> > Are you planning to resping it?
> > (if yes, I can provide you with a fixed 2/27 patch that removes all legacy cpu hp leftovers)
> 
> Sorry, no, I already burned all the x86 credits I had for 2025 :S

Don't say that, thanks for your efforts! :-)

> Zhao kindly offered to help with respin :)

I haven't forgotten about this. I also plan to help it move forward
in the coming weeks.

Thanks,
Zhao


