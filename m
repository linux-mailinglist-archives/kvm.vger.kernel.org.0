Return-Path: <kvm+bounces-52844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E007B09A32
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E216D5A33F2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EE01DA617;
	Fri, 18 Jul 2025 03:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfr5iBJh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E451C8632;
	Fri, 18 Jul 2025 03:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752809609; cv=none; b=bSL8Ro37RQFVwX+JE0zLGqaqyKHRLM5ku1YGRlmUh04zRAbkuIvNoTxFp4BjqN28jgLwbX2XS0/x/m/ltSN4X7W+/2TBYVQJoQTwZWQ8HqA1MYNMoFG3C9tEtmyMHESe8m9wqQxkmM5Oqt3eiF26TbiQ13KYF3m7S/APRZZx1ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752809609; c=relaxed/simple;
	bh=D8AGor2dq/npc0EvnMPgCs9khQ5Ob0CiUc1XMT/N94M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBLHq910MsVBfuuAriTLLSExejNpl7mCGXAS6rZD43GJcnRRE9F0f3ufTaXTihoN+xRNy1SXREXT1ok7lNnQnYGIaVntWLCSgFWrGu0U2jl/ehSGReaRL63sunwKigcL1kwCHJYt+ipGxE+99xW1saYAwSRu+fsTeaHiWtTF8pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfr5iBJh; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752809607; x=1784345607;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D8AGor2dq/npc0EvnMPgCs9khQ5Ob0CiUc1XMT/N94M=;
  b=dfr5iBJhzg50WbAELtF3aK7I4sz042NUKaS9mUbBjIDC0xaBHRGafBEE
   L2VDHeJRMU+GbVSb1AocPN9QZLoL7DbwWlGjurVg0B+xX5e8BbtDeTWpf
   w0wHDUjn+hKUAWhiW25VRUAOW8R4g5oV7a9rzKpUZQTmljt6XUYMDEbxq
   Rq67uWCx9UnSjQFJvv16Ee7bri9jNIK0TpuMHe3rTKrZNC6TCf4aPwppn
   RzLyDC4Bz99dcDWtcMa7uCyI/IOsT5fwoxvF3Yg8qwuXO5W1aeTOy0r0X
   jEIxoldQaSRmwJoku6b4sDCeMbm3Q7InetmEgiPENWBmt0H5X9BSu8hkC
   w==;
X-CSE-ConnectionGUID: emUjhN8OSDe5NzWBQWtqEA==
X-CSE-MsgGUID: RU7xFwhwQHOi3xceD6CGTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54313061"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54313061"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 20:33:26 -0700
X-CSE-ConnectionGUID: /scvanS6Sx+UV2IV+v5vuQ==
X-CSE-MsgGUID: JlCfL47DR5aRJITyOXDjvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="162232198"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 20:33:12 -0700
Message-ID: <d8b0fa0f-b9f5-4435-8602-bd6a2d375ca4@intel.com>
Date: Fri, 18 Jul 2025 11:33:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/21] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
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
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-10-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> memslot->flags (which makes it strictly for KVM's internal use). This
> flag tracks when a guest_memfd-backed memory slot supports host
> userspace mmap operations, which implies that all memory, not just
> private memory for CoCo VMs, is consumed through guest_memfd: "gmem
> only".
> 
> This optimization avoids repeatedly checking the underlying guest_memfd
> file for mmap support, which would otherwise require taking and
> releasing a reference on the file for each check. By caching this
> information directly in the memslot, we reduce overhead and simplify the
> logic involved in handling guest_memfd-backed pages for host mappings.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

