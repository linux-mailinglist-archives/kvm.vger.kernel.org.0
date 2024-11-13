Return-Path: <kvm+bounces-31785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5209C7969
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06FD51F266B3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9971FAC4F;
	Wed, 13 Nov 2024 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwKjcdcF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924471DFE06
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517032; cv=none; b=e04dJIzUu6ImopPL6cw4PQ0PiwDw3fg404PdYoWfrOwgjIwNhBCmktYC+IsA1p7wTtLcVsZ97usyneNBMrXLLE5r2C8j0QhUDzyq8xhokEraQFl70gtLRbhCB6kY9m2T6MEha3FFWtOvnunl1ckSDNpYCti/PglV9p3KW6daFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517032; c=relaxed/simple;
	bh=iRTp/lPSHCLfmoyHvRh98VAdS2hyyRbRRx8oSbHwnpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfJdgDUsY0aW7Gyutx7tY86fFNlfMB3iKCwWfBrmfJCD2o7qL5ErO22gqEzksjuwQ1FW8jDt9PwZX8zs8SCY5dsuCi5B4oXlUX4gWGn0+viRgDIFX2EhGzSZtcoqKgGjUQSq9eWCFbvOJxH8FSb/dGD1bY3qVuPEyceN3gKYxBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwKjcdcF; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731517031; x=1763053031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iRTp/lPSHCLfmoyHvRh98VAdS2hyyRbRRx8oSbHwnpU=;
  b=SwKjcdcFQ61Gv1od8U3Fv9NNfjCvHfwYsBB4Drk7TIVfmXbmknvQ16Yf
   UNxMNZGQ2UKFs8GWLKW3f6kIYfd2dR3gtKfuw+t8Nw20nVano7WlZXbS7
   pcNLaDv3FZYah1vDl1nsu7BGouHyk6VyMLHnHHZWyIpsbivcz63qS08pB
   LmkFGnPmyauEL1yWcuCfrqhe6MNAwPXMdfG1cEZUIH1QjulzNpxX98R+J
   XEICaldtGPpu6toToFJ2JRU88RZjoFEadY6YkO2yO+h5wWp/mzMYvlnAy
   0gixWjNMHAb4JkOCBLYJbKYYDWJCLknyyhDZdpjNAQIhqiJIysLubfKEL
   Q==;
X-CSE-ConnectionGUID: cSqnavSyS5ua1ZHigB03Iw==
X-CSE-MsgGUID: vrNiR+ysT9mQVZnAUtyf9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31187224"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31187224"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 08:57:10 -0800
X-CSE-ConnectionGUID: 04/TR45hTWmiV+HKmFEs7g==
X-CSE-MsgGUID: rr/gpLk1QsyTNIvP79nLAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="118742745"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 13 Nov 2024 08:57:06 -0800
Date: Thu, 14 Nov 2024 01:15:09 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru,
	dapeng1.mi@linux.intel.com, zide.chen@intel.com
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
Message-ID: <ZzTenX8KOOGxZCou@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com>
 <ZyxxygVaufOntpZJ@intel.com>
 <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>

> > Further, considering that this is currently the only case that needs to
> > to set the VM level's capability in the CPU context, there is no need to
> > introduce a new kvm interface (in your previous patch), which can instead
> > be set in kvm_cpu_realizefn(), like:
> >

Now your case is not the only user of kvm_arch_pre_create_vcpu(), and
TDX also needs this [*]. So, this is the support for bringing back your
previous solution (preferably with comments, as I suggested earlier,
explaining why it's necessary to handle VM-level cap in the CPU
context). :-)

[*]: https://lore.kernel.org/qemu-devel/20241105062408.3533704-8-xiaoyao.li@intel.com/


