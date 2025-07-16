Return-Path: <kvm+bounces-52615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E20FB07439
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3179F7AEB89
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBDD2F3622;
	Wed, 16 Jul 2025 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M3D6hxtS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868F27602B;
	Wed, 16 Jul 2025 11:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752663765; cv=none; b=UYybAa44ho25mW/34e8veUXGVATK8y6BsPXGbXV8qRoBxjvRvzIxOI/rdn8XIZzKBVjDpv93QFHK6502QmrQSEBgYI9Qlxkocipza91rvjPBcylXIiLoD38ZP6A5NAjjDKl86Uc/oOP7QkSHRd8xEsJzfP0HgYtDmHaVWht5USI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752663765; c=relaxed/simple;
	bh=lER+t0W/+OnaqRUfd8abPlZ0d7DVYXV25GgqbWYg6VI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ld42ltl5J02H/RQSclujIcgUrLH6xYwQmYnzzFntFKISdr9s8lDzOGVxAlqqHWykgFFXo16sHLGi2sWqadEs83ndKQiA/NT2Dug1mGWOvD4WifPE16X3fMOWYJWPoyq3edRucEvkPQHvQOqeS+CB3LJxYddrFPoTfchL4w29Il0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M3D6hxtS; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752663764; x=1784199764;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lER+t0W/+OnaqRUfd8abPlZ0d7DVYXV25GgqbWYg6VI=;
  b=M3D6hxtSAZX70yG6I3MeR++UqI7bM8LMoCTTUwoiW9kPt3Yyc9HS9X6f
   mJvGgNX95wCjcA/THS3ejh9euPaGYfcuUy6trCViARBlRTWyueFSsarPy
   Zc9SMIRuBjuMpzBEkPJ5Q0CtfbJk3++j3mFG6ky8qVJTFk3ilY/xGS5+1
   6r8csIr1GWXhKKedqTSt9I8h9OsswSPokgZoJZnG26/XrKd4SOB5Fb4mG
   1jWh2/eajtYKgLh7aGi3M5evVq+juDLV/DrLJYbaORVMJDVZkIqSS8EMO
   EyRW7aFxBDlK2NcS6ghXSvMBp6ctI5AhscY88r2cm6d5g2re1EvGkERca
   Q==;
X-CSE-ConnectionGUID: 2muc5AUQSHm0n6M5IFSTiA==
X-CSE-MsgGUID: 5STmfW9+Sq+FC0fGExdraA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="66260396"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="66260396"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 04:02:43 -0700
X-CSE-ConnectionGUID: OH68QhdZSpC5tEXA5T8uig==
X-CSE-MsgGUID: CfH8gGxYRD27Pg1cRecICg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157281588"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 04:02:27 -0700
Message-ID: <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com>
Date: Wed, 16 Jul 2025 19:02:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com>
 <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com>
 <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2025 6:25 PM, David Hildenbrand wrote:
> On 16.07.25 10:31, Xiaoyao Li wrote:
>> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
>>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>>>> The original name was vague regarding its functionality. This Kconfig
>>>>> option specifically enables and gates the kvm_gmem_populate() 
>>>>> function,
>>>>> which is responsible for populating a GPA range with guest data.
>>>> Well, I disagree.
>>>>
>>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit 
>>>> 89ea60c2c7b5
>>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
>>>> memory"), which is a convenient config for vm types that requires
>>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
>>>>
>>>> It was commit e4ee54479273 ("KVM: guest_memfd: let kvm_gmem_populate()
>>>> operate only on private gfns") that started to use
>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate() function. But
>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
>>>>
>>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate kvm_gmem_populate() is
>>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE to gate
>>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
>>>>
>>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
>>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
>>> I'll quote David's reply to an earlier version of this patch [*]:
>>
>> It's not related to my concern.
>>
>> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
>> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
>> not correct.
> 
> It protects a function that is called kvm_gmem_populate().
> 
> Can we stop the nitpicking?

I don't think it's nitpicking.

Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the 
first place, and why it was picked to protect kvm_gmem_populate()?


