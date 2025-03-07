Return-Path: <kvm+bounces-40310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCC1A561D7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 261231893F4B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 07:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A431A5BAA;
	Fri,  7 Mar 2025 07:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXqwYR8o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418819D8A4
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 07:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741332733; cv=none; b=F8GHjSMEBTxqRPz9SRsx8uZhtSQrEh1ln78rl+t5QSOX3leMDg6DB9miIt1iDVtk67m5vUEDemLeFoczPh1PmdQyYU6koumHsvGVxM6buDIHdgsJKD7UHTjgay6pZ9UP1HVKPTjRY2NZUQdK4bnspOstghA5Wq21nUwmfIs0t3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741332733; c=relaxed/simple;
	bh=0n9mnucRi4sYNV486/6Gw1e7LpF2GnO1kkWy7c3sKFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBRJD5W6WmrSxi/ZmClJLPxLqyYb/J9RTTElmGe5uhAeD0e6rzGzGYRdkVrjvCIqox+UGbxiOGJdCOrsclzlmqBAjFtIySLUwApsViy4PA3Jwgf/tecINWg9j8MWasmzC5pQOXLCt6ePEDBQ9zOtLpu8YlvoyUHdRzjciSxsKvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXqwYR8o; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741332732; x=1772868732;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0n9mnucRi4sYNV486/6Gw1e7LpF2GnO1kkWy7c3sKFk=;
  b=TXqwYR8oAB0QIDLwXMeqbcPSCWg9PWkkps/iNCFTWy7ZRghc+H4f0sUg
   UYPdEv+mPeGj8ljVaNZhGJtXAQT+YrF0a6AYVHY9p/WtbISaSYsJLZrKo
   cO3rL04jS+CjIcoctHbrxECf0wmBcAX8/pnSZuaBBQ4P38TCozVaNuuuv
   CV0PqgsvgM3/F4kH/1YhgAYiVh5j/+vpvgMZmDYyvQ8FGzzK64EBskgeR
   ECsFETVZHDh3GxbpNbSiOg+moNFzPtqkvh1WkEeUVpVPejsgce/Wiem4b
   RSC/PTYvLiFvprULO5vYls10SlL4JcMaN0T4o+jr3Q/uR6qfpbkCloH4G
   g==;
X-CSE-ConnectionGUID: Bb6EFEkwRJSExE+H6wh7Pw==
X-CSE-MsgGUID: SeJ104yMRMCZ5Cf5ZwXAbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="59931185"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="59931185"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 23:32:09 -0800
X-CSE-ConnectionGUID: Z1+BL8nvTUqYhVfuIt1Egg==
X-CSE-MsgGUID: eTZR0ffEQceqcW7KL2AxEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="142483946"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 06 Mar 2025 23:32:05 -0800
Date: Fri, 7 Mar 2025 15:52:14 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 03/10] [DO NOT MERGE] kvm: Introduce
 kvm_arch_pre_create_vcpu()
Message-ID: <Z8qlrjciHEbdnqaA@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-4-dongli.zhang@oracle.com>
 <Z8hjy/8OBTXEA1kp@intel.com>
 <acef41fc-9eb1-4df7-b7b6-61995a76fcc4@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acef41fc-9eb1-4df7-b7b6-61995a76fcc4@oracle.com>

> I didn't know if I would need to wait until this patch is merged into
> mainline QEMU. That's why I didn't add my signed-off.

No problem if Xiaoyao is okay with it (copyright of patches need to
honor the original author & signed-off). IMO, if your series is accepted
first, it also helps to reduce the size of the TDX series, and it helps
the subsequent PMU development (like mediated PMU). Conversely, it's
also not a big deal; you can simply rebase and remove this patch at that
time.

Even I'm thinking that my KVM PMU filter should perhaps base on your work.

> I will add in v3 and remove "DO NOT MERGE" if the patch isn't in QEMU when
> I am sending out v3.

Okay.

Thanks,
Zhao


