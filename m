Return-Path: <kvm+bounces-15924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6DE8B2304
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB162286BC9
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D034149DE8;
	Thu, 25 Apr 2024 13:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0B7K8yx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850F149C4D;
	Thu, 25 Apr 2024 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714052607; cv=none; b=lzwJnALsNZjNaZmFid+N1FTAVlIDGEwWhu4kxyYN1rzs5dhUurRdlj45I/LW9M1yzIj0zeWrgshmyADstz3115kNJun32AGwyGz3YsQRbJBHIpeflMyM76KWkXBw+4G61Him8uKWJbRuejEmth4ee/DLVZEvPVfmwFi1TgXtcbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714052607; c=relaxed/simple;
	bh=NPSlzCKVCsU2wq+izhAa1CU8nylnb03JghGzrs0lLp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4rXTEka3DjwPBhpuB8Ml6VIDG0wHNsqWWOiggNIilXfRwtYX5jccGut4bji+UinQQcK2yzbB0hnmgMkevWk0ydYby1EzgN3js3jbVB8lykznTcyUnlj0oejgiAB3p18kyfrgfr7qXrH7q4BNKDr16VICJWs9goeX5O2k7Yu5kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0B7K8yx; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714052605; x=1745588605;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NPSlzCKVCsU2wq+izhAa1CU8nylnb03JghGzrs0lLp8=;
  b=L0B7K8yxUkCPx3o+0k5xVcK15sWTjxHaBhpu1MYcrXMtDSRmXRcyWPQe
   V2zDgG46Zy+tDu6uZGANJC8vVJJtt4qx3IOebcgc5hHlfmANKJLowgbR/
   HBM/WtXq85EjBnKBs8/1E5hcFCQ29zwfeXxG5OnZ7JyD+Ad/azBoMrnkx
   0SH7c0QXZTTM82vupZcOjJOXCyszo10U6hf7CXZqllsZBvhj68+saJDYp
   lL9coC2WqOzlkSJ8ojEFOmP2goLebck6Su4BDDd5tSSqQL9n6MBJy4gsb
   1mFx/l1DPgp7Y/HuMCI23WHYvixDhekaB4zP4ueAcPW7bGLWDHyHcwVeJ
   w==;
X-CSE-ConnectionGUID: yMdGrwlVSSOWcesWQ+zPBA==
X-CSE-MsgGUID: ILZLXdEzSd+rXYP14MkZnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="20352405"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="20352405"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 06:43:25 -0700
X-CSE-ConnectionGUID: YFV6ZcPxRf6rFe4wTzZqQA==
X-CSE-MsgGUID: 6TzPwLkDQ9aQD+iZ9E0nzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25143068"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 06:43:22 -0700
Message-ID: <4a66f882-12bf-4a07-a80a-a1600e89a103@intel.com>
Date: Thu, 25 Apr 2024 21:43:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240423165328.2853870-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240423165328.2853870-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/2024 12:53 AM, Sean Christopherson wrote:
> Fix a goof where KVM fails to re-initialize the set of supported VM types,
> resulting in KVM overreporting the set of supported types when a vendor
> module is reloaded with incompatible settings.  E.g. unload kvm-intel.ko,
> reload with ept=0, and KVM will incorrectly treat SW_PROTECTED_VM as
> supported.

Hah, this reminds me of the bug of msrs_to_save[] and etc.

    7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")

The series looks good to me.

With v2 to move the reset of kvm_cap and set the
hardcoded caps earlier,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fix a similar long-standing bug with supported_mce_cap that is much less
> benign, and then harden against us making the same mistake in the future.
 >
> Sean Christopherson (3):
>    KVM: x86: Fully re-initialize supported_vm_types on vendor module load
>    KVM: x86: Fully re-initialize supported_mce_cap on vendor module load
>    KVM: x86: Explicitly zero kvm_caps during vendor module load
> 
>   arch/x86/kvm/x86.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> 
> base-commit: a96cb3bf390eebfead5fc7a2092f8452a7997d1b


