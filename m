Return-Path: <kvm+bounces-20194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C89A19117BB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 060C51C22002
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 00:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF251CFB5;
	Fri, 21 Jun 2024 00:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mw4U1Gij"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B551B171C4;
	Fri, 21 Jun 2024 00:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718929740; cv=none; b=PeQdsT4ez6BlNRYjtgD7Y3SC+EW2vL7VGqNy/huvD8FaYOJGeoxTxms/saAG81pWtemmGCGOA/xhJRZ38gA8MIR5fpVjwdQ15bkhRDLWM3uyKWKjSEaozVhmcZo8RFxKfIcPv+L/8djoYpGee3+WpjYz6qdONsI+M4plhsCYXdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718929740; c=relaxed/simple;
	bh=2OzZJtp11WcvelIn751HNZFt93OPOf6PFcCvCKO+Mow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kYv6krMpra0jfR3pyl4CpO0p2/DkTpe4wgNIbErX3rRgUPHi6wdE28Ywq7TiddFruMWqOvn18h1TiBeZqRQISowB4vw1wlhPlvUu1mcCWjF6M4u+yEgwbWchNDam/iT8sA609/6s7QNGRKeKZwFk86Oemg9TUKGJViHH42DstLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mw4U1Gij; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718929739; x=1750465739;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2OzZJtp11WcvelIn751HNZFt93OPOf6PFcCvCKO+Mow=;
  b=Mw4U1GijRFBxooMRaHfIgKYP5eKU+d3rot3X+pmCmv96ohaYcdgu5HyN
   pES0pDxKOiiFugkAxC/UxAOAHO+nUyYVcCrB7CpgnUohikzGf9gt+JMJS
   s0QuKSEd0YzOvutzbwbTUgCELL3RbOmTNqxj4zO+0M0sQ5FJxThC6QMGi
   pN6McrelaMmq5QfftxLP2SzHOISO50IC2MVRit9aJhnzN+0gvnaL48TF9
   N0WLc2H5kUh4ZzoGaN6rtO8zLCxy3UrFndz61UdDVWxligj4agwnQ6Pks
   xifADifvwhWQWdXEQnOyNuw7O+N9qFdTwJAkGzfPNwqE6skml2wfReDbt
   Q==;
X-CSE-ConnectionGUID: NvPxHu99SIagZMdu/Eh4oQ==
X-CSE-MsgGUID: 8coaAcTSRGmecHmwLngkrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="19721838"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="19721838"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 17:28:58 -0700
X-CSE-ConnectionGUID: r/opdNpOTiSK60gG/Gj+Aw==
X-CSE-MsgGUID: gKdmQlTrTWaaKJtwI7ak1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="46766256"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 17:28:55 -0700
Message-ID: <43586442-6ad2-4f97-b48b-8c7c3c9acfa8@linux.intel.com>
Date: Fri, 21 Jun 2024 08:28:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM vPMU code refine
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
 <ZnRTv-dswVUr0hzZ@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZnRTv-dswVUr0hzZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/21/2024 12:07 AM, Sean Christopherson wrote:
> On Thu, Jun 20, 2024, Dapeng Mi wrote:
>> This small patchset refines KVM vPMU code and relevant selftests.
>> Patch 1/2 defines new macro KVM_PMC_MAX_GENERIC to avoid the Intel
>> specific macro KVM_INTEL_PMC_MAX_GENERIC to be used in vPMU x86 common
>> code. Patch 2/2 reduces the verbosity of "Random seed" messages to avoid
>> the hugh number of messages to flood the regular output of selftests.
> In the future, please post these as separate patches, they are completely unrelated.

Sure. Thanks.


