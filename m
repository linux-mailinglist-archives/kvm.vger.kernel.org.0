Return-Path: <kvm+bounces-22226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8043493C108
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 13:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BBED283040
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 11:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02511199389;
	Thu, 25 Jul 2024 11:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBI0276g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984A2199256
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721907750; cv=none; b=mC7q7ijBA7OyZ5s1R4w8Th5hlwBobKVlfM4idyZoDaTJbpJyK9DWGuibeQKZvw9kfbyh96rzEsoQJwACH0MM6ttWYECcEdAQ7Ahr5iy3yNMZZTEWc8HE/IflvO9sO9Riufb9J2bdXD42Xe01+Rr8k/BIw4fxeHLULkUbfLmlXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721907750; c=relaxed/simple;
	bh=KygXsTO1/7PsKHbHPRlx3mwu6GzCfvzBN5TuN2US15g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sivyTGEvsE0IN/BA/ekQWsfR8DAdJ8cUP484gnqSOaXCJiCZ1PFWHLG07Own9n2laM9ld4yPderFrTNg3DrmK8gCN0r3iXFXGAEMHdFsZFU7CWDIEcnsoSvAMZm7v1fV9q8BpUPxloI6S9cx7ou4UH97QT9cvpj34p35H8UWnpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBI0276g; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721907749; x=1753443749;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KygXsTO1/7PsKHbHPRlx3mwu6GzCfvzBN5TuN2US15g=;
  b=IBI0276g2hzqDbdv5fCTRbkR7AppghbncIwjnTssmcTrxsB1NgG04w14
   +6ZQIy9NKj3sk4dwCx8CpkcSO7BfW/aCP9tKvG55VH5puO0Xt/6ybFCDK
   VNLV+1HO+fVci6jIxZYD4dQaLVvhyjvEd9kdc/Mkdc31g0sFRnNNrmPUq
   B69Qp48q7MogDF+fZxxGMi+6C8wsQVMT7SVjByQ+Fa8M+qa4PdlauyKBv
   8Au0W3opQ3Kt9lpDb502frzdFV2OgtZhzDpNOx6Gn2LqJwSBlFaV1HtpH
   uQtvt84tx/EAL6fBKEdDP3lMsWu9s2yT9H+B3z2tOeVY8UBvZH8krqmiN
   w==;
X-CSE-ConnectionGUID: UZy/g9j8RoKW5UxiGhpkhA==
X-CSE-MsgGUID: 5H11vfBEQxqEfAsOIjViiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19818824"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="19818824"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 04:42:28 -0700
X-CSE-ConnectionGUID: 2Wsp4k4PRGSWlLWNJZuuKw==
X-CSE-MsgGUID: utSt5rtmS7CpNGoEk5uI9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="83895660"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 25 Jul 2024 04:42:23 -0700
Date: Thu, 25 Jul 2024 19:58:08 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Markus Armbruster <armbru@redhat.com>, berrange@redhat.com,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin " <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <ZqI90B1jkfO4N5a5@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
 <87wmld361y.fsf@pond.sub.org>
 <Zp5tBHBoeXZy44ys@intel.com>
 <87h6cfowei.fsf@pond.sub.org>
 <ZqEV8uErCn+QkOw8@intel.com>
 <871q3hua56.fsf@pond.sub.org>
 <20240725115059.000016c5@Huawei.com>
 <20240725115902.000037e4@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725115902.000037e4@Huawei.com>

Thanks Jonathon!

On Thu, Jul 25, 2024 at 11:59:02AM +0100, Jonathan Cameron wrote:

[snip]

> > > I think I understand why you want to configure caches.  My question was
> > > about the connection to SMP.
> > > 
> > > Say we run a guest with a single core, no SMP.  Could configuring caches
> > > still be useful then?  
> > 
> > Probably not useful to configure topology (sizes are a separate question)
> > - any sensible default should be fine.
> >

Yes, I agree.

Regards,
Zhao


