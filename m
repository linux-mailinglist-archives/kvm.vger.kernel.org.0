Return-Path: <kvm+bounces-52565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04575B06D17
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 138173B5688
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6208277CBD;
	Wed, 16 Jul 2025 05:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KLoN1qFq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F6C17CA1B;
	Wed, 16 Jul 2025 05:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752643153; cv=none; b=bLX2P2p/qNJ7mu3fnFdKp6NuxDsalPgSS5jSbT8QvxaCYekufGtetcS9D8q5M3ZJ42BHLy02sJxgxlRZxIslYQEQwcYfPyNYRrEO3GyR4nlWEKxkWdQH572frL/hwJHghcY2WiWKMNF6qrzAFbf9N7Nv1AsBYwmf0ygFvUJquVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752643153; c=relaxed/simple;
	bh=ACeJsjJgiO+CHQEq/zTw4r/Vew4KL7aqSzVje7WzBRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=praflHQUumCKEPmFkQtW0PxeOgyvYNBT2gSCD8WgSZz0agXUSJbZsL7YmEjEIE5iLW3/xEuQGnW34YqtLvGkRpxf7IvpqaTEoCf5r/eT9a3CKy0bidZgT55Hsu6HlwShWzAVT6/PXTnmB+mXBjB27F/iTJEuq2FjcZH0XxR9TUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KLoN1qFq; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752643152; x=1784179152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ACeJsjJgiO+CHQEq/zTw4r/Vew4KL7aqSzVje7WzBRk=;
  b=KLoN1qFqf3+2E+JvP/pf1U3lnjcF6pp0ZtKOE8p9ADJaolGg4hirFYnG
   cgq052mFmkXxGMsVCcw3GTVBX8oDgCrrCkPXZqsCXkY+NgPOAP9N1vwH9
   lyE/DesgD7QByKH+oJo24HBHj3DULTcHcclNsDYeK1hsrTwRQcyGBy/du
   kg/Kh1bfOK9XWTbmcQe7eQJoTldCoAw1CqSVEY5NmwaG5SiLbwowP/CFb
   A5+nC3uSk3bRfowmfQKmzwCjyRxJ2FxfGm0970i4M7ENSlE0Lr8lco0dU
   hO4IVR++NlKZxTx7EUW9gBspa+g9wi9Pun/5yTaUirYWhX55DwtK8tRE/
   w==;
X-CSE-ConnectionGUID: GOApeWm/SHuZucTMAGPbRA==
X-CSE-MsgGUID: JwW9OLVkRNKv8jS3X29pyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72450036"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="72450036"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:19:11 -0700
X-CSE-ConnectionGUID: j7EXiFajTcaQq4oFn8LIVg==
X-CSE-MsgGUID: 2VAAn0VzTD6hSHKhcdVWfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="156804591"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:18:55 -0700
Message-ID: <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com>
Date: Wed, 16 Jul 2025 13:18:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
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
 <20250715093350.2584932-5-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> Introduce a new boolean member, supports_gmem, to kvm->arch.
> 
> Previously, the has_private_mem boolean within kvm->arch was implicitly
> used to indicate whether guest_memfd was supported for a KVM instance.
> However, with the broader support for guest_memfd, it's not exclusively
> for private or confidential memory. Therefore, it's necessary to
> distinguish between a VM's general guest_memfd capabilities and its
> support for private memory.
> 
> This new supports_gmem member will now explicitly indicate guest_memfd
> support for a given VM, allowing has_private_mem to represent only
> support for private memory.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Btw, it seems that supports_gmem can be enabled for all the types of VM?

Even without mmap support, allow all the types of VM to create 
guest_memfd seems not something wrong. It's just that the guest_memfd 
allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.

