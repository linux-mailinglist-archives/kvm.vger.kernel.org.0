Return-Path: <kvm+bounces-48966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD4AAD4AC8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 08:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCB57189BD1A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 06:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D2B227EAF;
	Wed, 11 Jun 2025 06:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTDY9byW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C981A28D;
	Wed, 11 Jun 2025 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749622165; cv=none; b=kDnG4v4MnlpcCRpLwF2cNuuAam0twjX3e/C2e08uoYRG9Izh2HHmPhwuLUAYjqzV5DQBShH9eQX9GSFGZSMzZZE+0mF832GsaLbsIuY2LRC0qNOo6jmghs2uXhW/PrAoaU93CUumxk3z4iv89E6Wk/JzM0W2fneCuTur+Rp7yJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749622165; c=relaxed/simple;
	bh=n0ZxMwmhwsKHF2cIHL9Z+6l4Zol/h2uEpfxP0yi4JK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mhYIYmY3mmnHgwSrVg08p++n2av553MZ4qA5ElF4sEaQKQKb0Kgc64U2cT7RdHvIfSDYcMiMs+v3LjOlnR3iJdwSj9FdQjL6uCb5ZcH/c4GGWoyiqOnW9LBDLARolYIsrME74sgWjM02QlypiyubFlqySV14TiBG/xQ3vp/1g5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XTDY9byW; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749622164; x=1781158164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n0ZxMwmhwsKHF2cIHL9Z+6l4Zol/h2uEpfxP0yi4JK4=;
  b=XTDY9byW0r0/tK1SRr243oedykBe2SSfbU4ughkjbBzprY0arZNtVCt2
   rnYWWAOn5KNs6V8zlOa7tN9vqXydLUgoxm8QDBIjLtvz+1mU6wRYfzQV+
   mwY6xK6vuUNdkn8UF4glip2HaxTQ00ySTHwdsWJrP9c3jRXKwg4YImnUF
   sq1q2jZvTUFWduyOVqYHrCMZQvQwUP3mbitY5EJOKQgSEXLhd8AATT91o
   F7aka8TcOzr02oelZ20tibWe6sHh1LVlccleuxe1VOxJf4mNfqjermPa1
   CnLmkYFCs4NWPDyHYTNHlpLPcK46sh9otkQQP2PBlHmw/kyVMrCjSgA3o
   g==;
X-CSE-ConnectionGUID: E+ySlteGQf+N7OyuBp+R1g==
X-CSE-MsgGUID: 79mC6T95R/S2sCdG0H05CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="55556047"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="55556047"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 23:09:24 -0700
X-CSE-ConnectionGUID: FX+BVXrxSM6gCI4xQQaIMw==
X-CSE-MsgGUID: ilIp4+hMRb6kV8GEKbZbdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="147037961"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 23:09:21 -0700
Message-ID: <5a80916b-1572-479b-a502-8b2d79c1dec3@linux.intel.com>
Date: Wed, 11 Jun 2025 14:09:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/32] KVM: SVM: Clean up macros related to
 architectural MSRPM definitions
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-10-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250610225737.156318-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Move SVM's MSR Permissions Map macros to svm.h in antipication of adding

antipication -> anticipation?


> helpers that are available to SVM code, and opportunistically replace a
> variety of open-coded literals with (hopefully) informative macros.
>
> Opportunistically open code ARRAY_SIZE(msrpm_ranges) instead of wrapping
> it as NUM_MSR_MAPS, which is an ambiguous name even if it were qualified
> with "SVM_MSRPM".
>
> Deliberately leave the ranges as open coded literals, as using macros to
> define the ranges actually introduces more potential failure points, since
> both the definitions and the usage have to be careful to use the correct
> index.  The lack of clear intent behind the ranges will be addressed in
> future patches.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
[...]

