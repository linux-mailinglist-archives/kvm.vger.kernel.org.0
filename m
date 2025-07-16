Return-Path: <kvm+bounces-52566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D42F0B06D19
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E766D3B531A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B793B277CA0;
	Wed, 16 Jul 2025 05:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mt1XOtJm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FDE2E36F7;
	Wed, 16 Jul 2025 05:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752643204; cv=none; b=g9//+coVs98J45+NYq854yjp2J6bbLh+KgKB8rJkhYlk1jdoS8s9tOjadlJim93zwemk92lF/cAZP3F+j/oMR5ToBnX+oON/vuUQax0hr1l4K1CTX/pB6mYcy9VcMksatAO+7bB2lZHAIijxIivY4iY4Q3r7gGJXdGgwE7wJiso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752643204; c=relaxed/simple;
	bh=W2eSQz3/U70QncMcreVKrezT3oPQBWS/gjJVMRVfvv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMTF6WcirbXKhoy4Oh01dsz7GrH9NTGLNMHiVIjwl3xM7Jf7Cn8SPQxKAgh1MA/5JbpKEjnN6j5WpqblUlh563sU/xHmv21WSUQtB+fdsg1RtHPNu+USLnOOR9G5POZt8e1D3ut6z2kO/jv8G1mshgJEbPR2aR4MlgdDjQQKpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mt1XOtJm; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752643202; x=1784179202;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W2eSQz3/U70QncMcreVKrezT3oPQBWS/gjJVMRVfvv0=;
  b=Mt1XOtJm1105XNzT1vkaRpReqGtGPSla5C9w2+VETLROsuRMeSLzmx7v
   7OtBIZnuwk8zRhBgMhRKp4sHm4po2srhJ8oo7R140BN8HJdL0+zN+2JGs
   4kY/e0fdscKzYXQEdi0CQHNMEE8ASNVSH5YMnfAcoAQZpRVBAP7OD6m0G
   7gsCBM7UTGlI+R6bX6QcoNFH6i2f1ixvGyDLvhpT0l7hZ5XkxI9s2TIR1
   ReySRiZFNab3gSVrCmQgqkL47tGQUiAYVURr0mKHQOvGm2iLdkX5U3T6b
   s9E6wR9h0p6VdPHA9avolvvKIxDcEUHu/F5nMdV4ULiApUTJiOL5EhNWf
   g==;
X-CSE-ConnectionGUID: EHRKXgmLQ3C/1bDAz5nOvg==
X-CSE-MsgGUID: S4HP7VwERTiQKFcUy11VTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72450098"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="72450098"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:20:01 -0700
X-CSE-ConnectionGUID: m+SBZprZQ0mmFQ4+BMJn9A==
X-CSE-MsgGUID: 5+2SXlobSu6omTtrpsqscQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="156804739"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:19:45 -0700
Message-ID: <a59d0d9b-0850-4969-8e87-89440fcb6d30@intel.com>
Date: Wed, 16 Jul 2025 13:19:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/21] KVM: Rename kvm_slot_can_be_private() to
 kvm_slot_has_gmem()
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
 <20250715093350.2584932-6-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-6-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> Rename kvm_slot_can_be_private() to kvm_slot_has_gmem() to improve
> clarity and accurately reflect its purpose.
> 
> The function kvm_slot_can_be_private() was previously used to check if a
> given kvm_memory_slot is backed by guest_memfd. However, its name
> implied that the memory in such a slot was exclusively "private".
> 
> As guest_memfd support expands to include non-private memory (e.g.,
> shared host mappings), it's important to remove this association. The
> new name, kvm_slot_has_gmem(), states that the slot is backed by
> guest_memfd without making assumptions about the memory's privacy
> attributes.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

