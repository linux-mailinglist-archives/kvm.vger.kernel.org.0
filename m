Return-Path: <kvm+bounces-51771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A5CAFCD96
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EE93189BEEB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028E02DFF3F;
	Tue,  8 Jul 2025 14:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cR9Z9Q1x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18EB2DECD4;
	Tue,  8 Jul 2025 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751984908; cv=none; b=tg4MOfJL10nuwXVA4MvmqwiEfgRxaw5LvzAxpLv2/dfmPdDqafJqkXu6VJcYPz0CDhxtBmXf6w4Dk6k5wNf8AfPWIZmznLZCd2YDQ4FtfTNHABK+Jp2jZ7sRCcurKV99JXsxK5tcJVYV5H2AaU2IuxMCVY4H5YY0EWXctIiAURg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751984908; c=relaxed/simple;
	bh=lHfzSzn+bU6I/A1HdVnuVoESXlkHGxxPECAQjmtMIxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+DM3hpofJU4Q/7csrFbiqaW8JRLU/FXaYkSezpz00scccvmYtmLMvibGGKxg8MpnNsM2/raFu2K/uapMuPlQgAugCRZjv8BzD6mIVXqxQ0CDQOG1KSYtWC6cEwkVRDJhmd3QiwK/pZ1U0JDuM2tW0UbiVR0AUL4/QYyEfj789o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cR9Z9Q1x; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751984906; x=1783520906;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lHfzSzn+bU6I/A1HdVnuVoESXlkHGxxPECAQjmtMIxY=;
  b=cR9Z9Q1xRY7iekloAKIk7bmSDnJ+hsRsR9Yz+ZMN0ySJCO4NcOOsaSD/
   UaanDCjjGraBKUo1GFb4v8b8XcPJmv8+evyqIjghpwL+5cSEcobnBgXaL
   8pCYeSa8qPFuAikHr1GiRMCci4ETbT0y/pViIxiefhW+0h32jig+CKoC7
   asDsF/rrq4zHK0LOXc3neBh2H50S9YV/yaoQJcNnneQM9LVzfooX6rSFL
   9Leuya09/X8lmKXgKJRMo4S+H8IhRdft652eYIHMjcxVoEva4GXjxQoQg
   GtGCpExjM8PzmoTWlSr4ndv2q3irPTJc4Nh/IALPvY06K80iv7pHDSykf
   g==;
X-CSE-ConnectionGUID: WTgipdvWReS9PkvLED07WA==
X-CSE-MsgGUID: DFt04z/NSayxXrl7PKZ3JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64812339"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="64812339"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 07:28:26 -0700
X-CSE-ConnectionGUID: lqElzF1iRuid/K+14vUuLQ==
X-CSE-MsgGUID: xwl2AcUsSKqIJbDiAdm1kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="159782303"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 07:28:21 -0700
Message-ID: <e80c6b47-c4ce-4465-82f3-8e82160fa2b3@intel.com>
Date: Tue, 8 Jul 2025 22:28:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
To: Sean Christopherson <seanjc@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, rick.p.edgecombe@intel.com,
 Kai Huang <kai.huang@intel.com>, binbin.wu@linux.intel.com,
 yan.y.zhao@intel.com, reinette.chatre@intel.com, isaku.yamahata@intel.com,
 adrian.hunter@intel.com, tony.lindgren@intel.com
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
 <20250708080314.43081-3-xiaoyao.li@intel.com> <aG0lK5MiufiTCi9x@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aG0lK5MiufiTCi9x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/2025 10:03 PM, Sean Christopherson wrote:
> On Tue, Jul 08, 2025, Xiaoyao Li wrote:
>> There are definitions of TD attributes bits inside asm/shared/tdx.h as
>> TDX_ATTR_*.
>>
>> Remove KVM's definitions and use the ones in asm/shared/tdx.h
>>
>> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/tdx.c      | 4 ++--
>>   arch/x86/kvm/vmx/tdx_arch.h | 6 ------
>>   2 files changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index c539c2e6109f..efb7d589b672 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
>>   	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
>>   }
>>   
>> -#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
> 
> Would it make sense to rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_ATTRS?
> The names from common code lack the TD qualifier, and I think it'd be helpful for
> readers to have have TDX in the name (even though I agree "TD" is more precise).

Personally, I prefer adding _TD_ to the common header, i.e., rename 
TDX_ATTR_SEPT_VE_DISABLE to TDX_TD_ATTR_SEPT_VE_DISABLE, or just 
TD_ATTR_SEPT_VE_DISABLE if dropping TDX prefix is acceptable.

Because TDX_ATTR OR TDX_ATTRIBUTES is ambiguous to me. There are other 
attributes defined in TDX spec, e.g., TDSYSINFO_STRUCT.ATTRIBUTES, GPA 
attributes.

