Return-Path: <kvm+bounces-50814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A45FAE990C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0DE45A33DE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A4D29617A;
	Thu, 26 Jun 2025 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FXYpPg1/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390902957AD;
	Thu, 26 Jun 2025 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750928017; cv=none; b=kRkfonT56/Cl5terZPhhZ+tHPkajajxw7vUl4kBXIdAmmvjpb7pH0vdCWkQd/Pjdz+LqWaoZgWOJZcVDU6XAnA+Ynl3iqsXfFOLB4ztGaiRGRHN5F4E0BrFCDaWIXSN9Ul+zaDQRaDGjcASIcJJLwF+IU1a8gdtSZN7Bn2VDgyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750928017; c=relaxed/simple;
	bh=qjCW5fANYpBxZMos/0B9Lmzp0fOKP2cSn0Aj7JueaHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RACe5dYR/wJRZDiMA2E61BPitoBAgc/VFvRhDfairzO3p/n9Gdzk8ixHeKlcHtZjZDjlMm7hLnt3b1HY+Jz8Ly4QbE2CAnOmd0BRHbHuiBRjPmb3M/JqLEIQYuvvb+0tUwhB/KxK8XUh1pk5///lQxU7GSdqLi/fLY5wVZWFQVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FXYpPg1/; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750928017; x=1782464017;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qjCW5fANYpBxZMos/0B9Lmzp0fOKP2cSn0Aj7JueaHQ=;
  b=FXYpPg1/PSsqmk0t1D/Mf3cvkSEpESTu+RD8JpnFIgPMbLrxA4eHJNc7
   mOtrhTF5gf4zC3s/8mMGPk7FlCbgCZW6YSp9pzWSyqjrtEkwLNqpM4kDJ
   vUDSiIkmFWtJAJ1CY1UfN6F8e9jc0xUnpqenb8V8iOTVaYkCadLau6NGu
   beXOqcRsUzr7l2SJd4umKDF86+QeYJxF7tzkbCfrFrEIwrcuBX8MJbOsX
   5D/Q/pjjfs0h5wfQmhfThKAI4dLAAoVQZp6AIwBz5MwJ+ultxgj90+GlM
   s/9f/WhKdgADOpaLwnsx3oCJEf524pqWpyR3Y+Xl+BFIVQd3+f0WjJPKr
   Q==;
X-CSE-ConnectionGUID: ORqFRwSGTTiqXZEmKGgQRw==
X-CSE-MsgGUID: gTcqmOXgR0mXFHK+505ulw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64649479"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="64649479"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:53:36 -0700
X-CSE-ConnectionGUID: MYHDrDs1T4GgRk7RUyBgsQ==
X-CSE-MsgGUID: BuxoA7uNSmmxTflue01UJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="151975111"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:53:33 -0700
Message-ID: <b8b3f43d-5e02-4072-8954-1f0c6f80eaae@intel.com>
Date: Thu, 26 Jun 2025 16:53:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] KVM: x86: Replace growing set of *_in_guest bools
 with a u64
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>
References: <20250626001225.744268-1-seanjc@google.com>
 <20250626001225.744268-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250626001225.744268-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 8:12 AM, Sean Christopherson wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> Store each "disabled exit" boolean in a single bit rather than a byte.
> 
> No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


