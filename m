Return-Path: <kvm+bounces-57680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F105CB58EC5
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D1EC4840EE
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559402E426A;
	Tue, 16 Sep 2025 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="miXOqrnv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2912773E9;
	Tue, 16 Sep 2025 07:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758006451; cv=none; b=qTOuKYlOQIbXJM4vqjXvtBz8ftNOGXHPUJ77r784NC9XWcZKoMA/63lvr7nXnxRA1Vf6TVi5uJW9awlc6X4D2F2anqcyfHJBXgKnFrc24caBChotkbYVYX2W9cX6mvrsY+qxCCOJeRxbnTQ9GOXWYQinLZIqCoPZVx0GsJZPNmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758006451; c=relaxed/simple;
	bh=MEaBnohzWA8YxhLDfM0OxmPLj95mJXNJ+dbbv5pP7jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JVzrMojWC7LR6u24mEJC55LAM/SKW3Lk43KYIVAYdG+Wm2I+M1RR5UxldOQnsquIp1UkNuA4QevbbpMFtDPn5mkNKGjzoRh/LI7j8ieD6PR/w6X9eh3gcJjP6kBcHjk/OxEh8FLicAY0rsNufxCrrkvZEQ3Ge7GdxQelcooYUXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=miXOqrnv; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758006449; x=1789542449;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MEaBnohzWA8YxhLDfM0OxmPLj95mJXNJ+dbbv5pP7jI=;
  b=miXOqrnvhdO0QD94v8pZp4rKZtrSuwGmnXOFzCSP4xAHAHSh4vo3kiqZ
   Cdiq1MyDqQpR3BUuvdGh7f6UhWyyQaNR6J7cOi6U19OofolQssA4nVorf
   Au7g88zjWnUw4Ic02/wfw6/ngQwbrJQPxcjimk93n5EEm43PwCq0O1+JO
   Zs8HRo31Lq8ELXLeaGDFfr9ZK4WRD2+3Z24mjnc2Jb0aZN8KRbwJwrxe9
   ahRxOoYhb3me1vi4f2BX6QhJMgmGffcnOozQk7a65Zb0NIYhvxgDJkS7a
   KZJi1PMylikWq7m/O5vkwydRMeGm65Sx+bEVnNJ9iPTEhenFOofeuGZwe
   w==;
X-CSE-ConnectionGUID: mLxrpapTSseL5lj2F6m3XA==
X-CSE-MsgGUID: JkYce3gjShyQl0E0qGuE4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="77718049"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="77718049"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:07:11 -0700
X-CSE-ConnectionGUID: P4f97KpmQQeTqUgnvYyzdw==
X-CSE-MsgGUID: dVw3sHYrRPeJtMaDclOjfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="205827322"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:07:09 -0700
Message-ID: <5afee11a-c4e9-4f44-85b8-006ab1b1433f@intel.com>
Date: Tue, 16 Sep 2025 15:07:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/41] KVM: VMX: Emulate read and write to CET MSRs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-15-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add emulation interface for CET MSR access. The emulation code is split
> into common part and vendor specific part. The former does common checks
> for MSRs, e.g., accessibility, data validity etc., then passes operation
> to either XSAVE-managed MSRs via the helpers or CET VMCS fields.
> 
> SSP can only be read via RDSSP. Writing even requires destructive and
> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
> for the GUEST_SSP field of the VMCS.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: drop call to kvm_set_xstate_msr() for S_CET, consolidate code]

Is the change/update of "drop call to kvm_set_xstate_msr() for S_CET" 
true for this patch?

> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

