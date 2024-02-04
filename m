Return-Path: <kvm+bounces-7938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 961948489E6
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 02:05:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15F921F244B0
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 01:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C6E10EB;
	Sun,  4 Feb 2024 01:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UZYEvq0R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777837E1
	for <kvm@vger.kernel.org>; Sun,  4 Feb 2024 01:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707008733; cv=none; b=M3A2cYv2gef5vSXylx/DKNcP/fBgsap3kng3oO4Vu/vYa5w0dYHvOhByyhMMTUHaO+sVVawl44BIsKsQt+pLElOnJD011QjE6zKprskMQuT3xIqGYSGih8hdwWwKdoaMF08D9gB+niw7OgEiFEiDioHpkCcZBAQT4fRUz0GhooU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707008733; c=relaxed/simple;
	bh=jkI+gXGXlF1aDHvx1Gs2m7DJ0vTEaZ8Z+t2q32cetks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TeR4Mg0WUd4aHOqghEHe4dteJNsCmTy4bPBEOTmjn4p30QDUmRwoj/VGDNvU11SVqj5S4VOAQAeTkxfQFnJb0znzeNHSoYQVKuSwnQMDQaANFBypX0NgBkhOtm73L1up9y0J2iW52EuslC/g4vDUG2N/wMc0mvSDBFKe70i6gqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UZYEvq0R; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707008732; x=1738544732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jkI+gXGXlF1aDHvx1Gs2m7DJ0vTEaZ8Z+t2q32cetks=;
  b=UZYEvq0Re2/t3Ih66By+oF7o0/Du9ZTah8JEgyAijMUSbfIWVlc5Nqx3
   ACp0Up9ANPLNpz8KetE1m3NulqBTq/9N1EY3JOjlaEW0L5ySV7wv+XBJw
   LwRtyXBR7a6SBKzjf7+qiTnRW98Lh03ikjICX4ps3nJXh7ZswtOxSBC42
   25DUCuEIepFNbO2QXyqu6IWnELl2lBnm7KUzWzD/CIQpKED8f0VgP7QNt
   ezJrJ83et8xj2fd3jDQiloRdu3PSGqK4i+vUxv9xKdWUvN0f6Q8ZOrfIX
   CJ80IXxY9oSqvJmaIXIJWPrKoV31aGWahJ/qyslHKY8sAhGqBNtSdMqRp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="10999094"
X-IronPort-AV: E=Sophos;i="6.05,241,1701158400"; 
   d="scan'208";a="10999094"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 17:05:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,241,1701158400"; 
   d="scan'208";a="31498150"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 17:05:29 -0800
Message-ID: <4480d8e2-e0ca-4b9a-a2d1-fa42873ab0be@intel.com>
Date: Sun, 4 Feb 2024 09:05:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
To: Mathias Krause <minipli@grsecurity.net>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-3-minipli@grsecurity.net>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240203124522.592778-3-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/2024 8:45 PM, Mathias Krause wrote:
> Take 'dr6' from the arch part directly as already done for 'dr7'.
> There's no need to take the clunky route via kvm_get_dr().
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 13ec948f3241..0f958dcf8458 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5504,12 +5504,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>   static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>   					     struct kvm_debugregs *dbgregs)
>   {
> -	unsigned long val;
> -
>   	memset(dbgregs, 0, sizeof(*dbgregs));
>   	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
> -	kvm_get_dr(vcpu, 6, &val);
> -	dbgregs->dr6 = val;
> +	dbgregs->dr6 = vcpu->arch.dr6;
>   	dbgregs->dr7 = vcpu->arch.dr7;
>   }
>   


