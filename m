Return-Path: <kvm+bounces-12567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B1788A2C4
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A1231F3B5CD
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1315E154C16;
	Mon, 25 Mar 2024 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aignWX6w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD5715666C;
	Mon, 25 Mar 2024 08:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711356165; cv=none; b=WgCFrv3PHSOpWizSeO3JVVD7bIi1Yvlz66bpa3rLfRlUZj/FqfDj4Y1cPRiHkzd1jNve97ON2qepUk9m7mWdDZCA/iBJedzv0wjayWvsOX2BNAFIg5j6PXepyQJ9i0vxY2GRIvW9Z45PF2s9KRjExYt6lWkt2Miciku8kEe6QY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711356165; c=relaxed/simple;
	bh=yMcZMtk73vcphNvp8+N87iwyUs5Wm8UEBtf+e10b8Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e56q29yM9ywQxUOZwWnG0oWCsdZIOL+yDii9ksO9XkJz36PepzML6Az8WdgFJh41VGw+zE3s7d9Fi89i54R1mXmr9QGs0fQiaV/xK1oR+CYHR2dLy3qZ1XUSKpd73A8O8tv2PV+N2KI8i9mLEwM0kdRclomzmtr9uKA4xfG3M/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aignWX6w; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711356163; x=1742892163;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yMcZMtk73vcphNvp8+N87iwyUs5Wm8UEBtf+e10b8Sc=;
  b=aignWX6wKpBDJIH2szw0PWXSnwwv4p43J/nj7GbqYFFVCmmHfcbS+7Nr
   s4/+EuK4yTk/Pt/MaoUsGrKxG0skF5gzqJV+dl440ZUPjD1ppyrhJzimP
   pgo7nEfOo5zhj7kgSrVqhQ2OUlKwfNozwAd1+P0aHAJGBJ6lf3oxEVSN3
   laY4LHsz/7phMnpOHxpmNeO6eEWMkFhR2Q1z5Px00+lJo5rYm1Da3eSkD
   3XflR526fsTl9JKa+agd1BuLgErKizlCLJyd8zqAUBEy2SBZ3XW/+Mzvi
   E7TkGKY+2UNEPi4qgSCGrabq9pkbziZDwLi9SYgoykyR/96L3VqKnnF47
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6460000"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="6460000"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 01:42:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="15572634"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.234]) ([10.238.0.234])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 01:42:39 -0700
Message-ID: <fde1729f-aca7-4cf8-a2cb-a7fde5b4f936@linux.intel.com>
Date: Mon, 25 Mar 2024 16:42:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: Isaku Yamahata <isaku.yamahata@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
 <20240323011335.GC2357401@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240323011335.GC2357401@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/23/2024 9:13 AM, Isaku Yamahata wrote:
> On Fri, Mar 22, 2024 at 12:36:40PM +1300,
> "Huang, Kai" <kai.huang@intel.com> wrote:
>
>> So how about:
> Thanks for it. I'll update the commit message with some minor fixes.
>
>> "
>> TDX has its own mechanism to control the maximum number of VCPUs that the
>> TDX guest can use.  When creating a TDX guest, the maximum number of vcpus
>> needs to be passed to the TDX module as part of the measurement of the
>> guest.
>>
>> Because the value is part of the measurement, thus part of attestation, it
>                                                                             ^'s
>> better to allow the userspace to be able to configure it.  E.g. the users
>                    the userspace to configure it                 ^,
>> may want to precisely control the maximum number of vcpus their precious VMs
>> can use.
>>
>> The actual control itself must be done via the TDH.MNG.INIT SEAMCALL itself,
>> where the number of maximum cpus is an input to the TDX module, but KVM
>> needs to support the "per-VM number of maximum vcpus" and reflect that in
>                          per-VM maximum number of vcpus
>> the KVM_CAP_MAX_VCPUS.
>>
>> Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but doesn't
>> allow to enable KVM_CAP_MAX_VCPUS to configure the number of maximum vcpus
>                                                       maximum number of vcpus
>> on VM-basis.
>>
>> Add "per-VM maximum vcpus" to KVM x86/TDX to accommodate TDX's needs.
>>
>> The userspace-configured value then can be verified when KVM is actually
>                                               used

Here, "verified", I think Kai wanted to emphasize that the value of 
max_vcpus passed in via
KVM_TDX_INIT_VM should be checked against the value configured via
KVM_CAP_MAX_VCPUS?

Maybe "verified and used" ?

>> creating the TDX guest.
>> "
>


