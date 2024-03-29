Return-Path: <kvm+bounces-13053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED18F8913B9
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 07:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6141288443
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 06:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD5C3FE4F;
	Fri, 29 Mar 2024 06:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F2lNdD50"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3DB3F9D2;
	Fri, 29 Mar 2024 06:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711693340; cv=none; b=VKb9jZPYFnX7GYTQx6MnR9PhITp0r2RgTMQsnz1mK2LgXqv8rwgk4nhpDYKkRJV0TvCQrSpZ0LvxB/yynlw3Pv9D2YMaiz4T5tO0+7zupd5+erivdQHbKuStMJvJfn7SRgAxhRctM+0TX14450tJKZ451L6MfbXMRTWe8PLiUGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711693340; c=relaxed/simple;
	bh=qqijB1DYYP8h60w+Z5syxz5vz3KMKyQUPWPlyBOGC7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qMM4ksJCE+1xp8AoKp+BZ3ykvbDB7y1YlzsMg//BwRUYSYuO+BLrzrmWd7Oma5YOuJn486HWFH+Ru5c6ryeNNzylIB0KvGsGZxF01SXW4fEtC32XzjVLSWyhOqRApxZwF0MQ3P3Z9U7H4TT6ZgJHmPOTuzTlf8BE3LHV/+0K0nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F2lNdD50; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711693339; x=1743229339;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qqijB1DYYP8h60w+Z5syxz5vz3KMKyQUPWPlyBOGC7M=;
  b=F2lNdD50QwHYi43qCM0C0kbLWJ/13EarTAaouT9qJuHox+Ns+r8y16dR
   YSPBXzgsUxh/Au9s6cAUDjdv9WEKXRpgmXmYVt2KKNtVG75ayrU+YIvv3
   dU3+gncj2iPcmc0XDHrvpdkhGUhqndi9rJWmixQf8WsRCus5wt0jN/mA6
   EYXpTWiSohVOmDMZDqzpfb39o0tAmmTpMNyxxKpBT88GA1IaVoaYSwiJM
   3VqJulB04ZN46igdcecnR6BP8YwPHGzHDMNrpUdXtqJm6D7m1uGYlTj9A
   oxaOlxJMbZLaQyH5Vk+2clAyn8hh7AhoRxtc7HRmJ7q+LnVKsG0t1nqmS
   Q==;
X-CSE-ConnectionGUID: Rv+gWfS3SB2ns6iTu8rQug==
X-CSE-MsgGUID: 3dr3UbaaT5efevOpuARAkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="10663142"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="10663142"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 23:22:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="54345229"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 23:22:15 -0700
Message-ID: <f52734ac-704a-49f7-bbee-de5909d53b14@linux.intel.com>
Date: Fri, 29 Mar 2024 14:22:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240321141709.GK1994522@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/21/2024 10:17 PM, Isaku Yamahata wrote:
> On Wed, Mar 20, 2024 at 01:12:01PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
>
>>> config KVM_SW_PROTECTED_VM
>>> 	bool "Enable support for KVM software-protected VMs"
>>> -	depends on EXPERT

This change is not needed, right?
Since you intended to use KVM_GENERIC_PRIVATE_MEM, not KVM_SW_PROTECTED_VM.

>>> 	depends on KVM && X86_64
>>> 	select KVM_GENERIC_PRIVATE_MEM
>>> 	help
>>> @@ -89,6 +88,8 @@ config KVM_SW_PROTECTED_VM
>>> config KVM_INTEL
>>> 	tristate "KVM for Intel (and compatible) processors support"
>>> 	depends on KVM && IA32_FEAT_CTL
>>> +	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
>> why does INTEL_TDX_HOST select KVM_SW_PROTECTED_VM?
> I wanted KVM_GENERIC_PRIVATE_MEM.  Ah, we should do
>
>          select KKVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
>
>
>>> +	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>>> 	help
>>> 	.vcpu_precreate = vmx_vcpu_precreate,
>>> 	.vcpu_create = vmx_vcpu_create,
>>
[...]

