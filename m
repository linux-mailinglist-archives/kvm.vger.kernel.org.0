Return-Path: <kvm+bounces-53458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC18B120AE
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 17:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1879C7B500E
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 15:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791462EE603;
	Fri, 25 Jul 2025 15:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KAIGvhBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0936F2BDC19;
	Fri, 25 Jul 2025 15:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753456414; cv=none; b=S3QkA6tOBrSNGTw8+bU7Uk6fXi31I7x5q7Q3JMz0xA3jE1AMWXyY6zmij4CzD2VfJ/3XzfyKU+d77ydQCfLuGx6RSnHl72fEBVmQ4X/adAHg3JoDK0YS3YzQt3tzGoL+M9fedqpeMX3CaUk126lgOQdsqlz6epTxl5krBCkfpwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753456414; c=relaxed/simple;
	bh=G0r5tZJJ2DdnPw+tHoSqb+0jE/QYBRuw9Ad6PZ6f45o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGV62gcSN4ySriYA7kz/og1QBW4yj+3QntoJbFzEac1VLo1xzhvi43zIDtEmZO0YBQORE/4Tg2wKjM13S4mb1tkjpm0O+Z4PFCj5JXhgx57KiV2JvtZ6BI9/Vak3AYetD/RYi4LhqDtM7XalOh4HRWQdzHyNLiztxizrkZ+gKq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KAIGvhBQ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753456413; x=1784992413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G0r5tZJJ2DdnPw+tHoSqb+0jE/QYBRuw9Ad6PZ6f45o=;
  b=KAIGvhBQfpecl3lf5malPn946Kpz3G+O2RlE3xCWOmESC8D2/WmsFwYQ
   4PilPmglhFZNDoAEmZSXpCAbdAZE7wyO0agpiwM2nWYTCeuiqRC8I8QR6
   BiZwOO6VWxMVKsYnEc2Z7nebXfWa6Bz7dPy4+IrW13GjjeLi5FICPDckQ
   2ApnvjNhpUGIY6l62+MgTMCj3O5kh4Vjc2e/nMRxhoFAIPwmqxB45Yea/
   h1pE/eZleNdF6QhPG7+Df6JbsEThWnlzPX476YudURA+iZnw0CXvUkl80
   KSG2cZHnIKnFC4mLXtIBBq90YhvPemFwFu7KdPPBKaSwQDavfV3qD7ivs
   g==;
X-CSE-ConnectionGUID: LVadVNMsTYy9KHFw+IGKHA==
X-CSE-MsgGUID: I0Ifh21ETn6p6hHScQ1iOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55005383"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55005383"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 08:13:31 -0700
X-CSE-ConnectionGUID: hPjDrZYZQOK8o9DuLcPc8A==
X-CSE-MsgGUID: hhduVdRDT8KCUOMdux2CBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160695227"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 08:13:17 -0700
Message-ID: <da2237a8-c271-47b7-b658-fe0746f4100e@intel.com>
Date: Fri, 25 Jul 2025 23:13:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-6-tabba@google.com>
 <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
 <aIK2p9TgiNeQOI4s@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aIK2p9TgiNeQOI4s@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/2025 6:41 AM, Sean Christopherson wrote:
> On Wed, Jul 23, 2025, Xiaoyao Li wrote:
>> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
>>> The original name was vague regarding its functionality. This Kconfig
>>> option specifically enables and gates the kvm_gmem_populate() function,
>>> which is responsible for populating a GPA range with guest data.
>>>
>>> The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
>>> option: to enable arch-specific guest_memfd population mechanisms. It
>>> also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
>>> options.
>>>
>>> This improves clarity for developers and ensures the name accurately
>>> reflects the functionality it controls, especially as guest_memfd
>>> support expands beyond purely "private" memory scenarios.
>>>
>>> Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
>>> function. Therefore, ensure that the correct configuration is selected
>>> when KVM_SW_PROTECTED_VM is enabled.
>>
>> the changelog needs to be enhanced. At least it doesn't talk about
>> KVM_X86_PRIVATE_MEM at all.
>>
>> If Sean is going to queue this version, I think he can help refine it when
>> queuing.
> 
> My bad, I simply forgot.  How's this?

looks good to me.

> --
> 
> The original name was vague regarding its functionality. This Kconfig
> option specifically enables and gates the kvm_gmem_populate() function,
> which is responsible for populating a GPA range with guest data.
> 
> The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> option: to enable arch-specific guest_memfd population mechanisms. It
> also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> options.
> 
> This improves clarity for developers and ensures the name accurately
> reflects the functionality it controls, especially as guest_memfd
> support expands beyond purely "private" memory scenarios.
> 
> Temporarily keep KVM_GENERIC_PRIVATE_MEM as an x86-only config so as to
> minimize the churn, and to hopefully make it easier to see what features
> require HAVE_KVM_ARCH_GMEM_POPULATE.  On that note, omit GMEM_POPULATE
> for KVM_X86_SW_PROTECTED_VM, as regular ol' memset() suffices for
> software-protected VMs.
> 
> As for KVM_GENERIC_PRIVATE_MEM, a future change will select KVM_GUEST_MEMFD
> for all 64-bit KVM builds, at which point the intermedidate config will
> become obsolete and can/will be dropped.
> 


