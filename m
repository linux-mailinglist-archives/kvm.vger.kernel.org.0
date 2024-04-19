Return-Path: <kvm+bounces-15206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC368AA89F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 08:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8A55B23AB5
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 06:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BE43AC10;
	Fri, 19 Apr 2024 06:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U37DA/kB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1AE37165;
	Fri, 19 Apr 2024 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713509245; cv=none; b=MIE47GCAjElGMmhmfEBR+T3SNuSZy8WCVn9xCaLjPJrsHXtiMgSaH2rlaUw8SHxNVdjfbOj0XQ/A6htZMBobG/lPPDv+29jaGY90wu+09noYt9bOcbZbnKvRfaNWaP0VYQ9NnfBXE2EndzkJrPny/kDO/UPbWY+c9mwo5Uk9buM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713509245; c=relaxed/simple;
	bh=qmJspUN5/sFyMT1W/2++coD8shFK3AdJHmIK+WO0s4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rcPLs3HDkT4uvV+XvZnyDJKxQrf1oM6G0XMBeOQ63iG01+9/X/dGGXWPy4VMOZj8Z6TdVX8JPdhaQ4wm5b57Bm8gFeFRNmQRWTuTWqbWnnjDJgG3aqQW15OgfUN1Lc86JqcGa335Ul1oKpH812Ivp8INzhBqO076fQnzDEt6/BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U37DA/kB; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713509243; x=1745045243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qmJspUN5/sFyMT1W/2++coD8shFK3AdJHmIK+WO0s4A=;
  b=U37DA/kBkSpMZEiG4fUigdEB8EAbUCm9SbdN09lidE9tpIHOy/UQhQuL
   wQJ4qZvCEoIFmDiAfVDPVU2jQSS5Sr+V5M2CAiY3unfZhkPYR+aZALBgp
   oJ1oL8HNi/Mrfs3PTDph54Lqqz2B6zyz79Zedsi2lMkd+qgMP+P24XKn7
   PtRR0NWzZN6CIp0M0YpEtN9VDN0zGVQaVlehA11X3pSWiO8gJSTEq5+zA
   ib23n/QJJmH4tiJi5hcORD60M3Tts7VlBPMDgBjiXYqFMh3UDp99JXmHu
   BQmIDULzAt00xZ/0c8nqd4kzQ9e45j/3KpyyMmTirfktRnFGT+vU0c5Bh
   w==;
X-CSE-ConnectionGUID: E7ENx/qrQ8mWGLvqKR4IiQ==
X-CSE-MsgGUID: Qc/0W+CkQpuG3bi9Bs0n+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31579524"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31579524"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 23:47:23 -0700
X-CSE-ConnectionGUID: RWvXiigjQCqQ0R6Kfzu4nw==
X-CSE-MsgGUID: hkiTvbDYRkGBTagcSkQ48Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23223618"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 23:47:19 -0700
Message-ID: <7b23e6f6-23cc-4dff-aea1-cb30e91d046d@intel.com>
Date: Fri, 19 Apr 2024 14:47:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] KVM: x86/mmu: Page fault and MMIO cleanups
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <CABgObfaS7RhUPe_FYS9SCuDzOfFw4X9P8XOhJSspVdzsYeoX2A@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfaS7RhUPe_FYS9SCuDzOfFw4X9P8XOhJSspVdzsYeoX2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/17/2024 8:48 PM, Paolo Bonzini wrote:
> On Wed, Feb 28, 2024 at 3:41 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> This is a combination of prep work for TDX and SNP, and a clean up of the
>> page fault path to (hopefully) make it easier to follow the rules for
>> private memory, noslot faults, writes to read-only slots, etc.
>>
>> Paolo, this is the series I mentioned in your TDX/SNP prep work series.
>> Stating the obvious, these
>>
>>    KVM: x86/mmu: Pass full 64-bit error code when handling page faults
>>    KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
>>
>> are the drop-in replacements.
> 
> Applied to kvm-coco-queue, thanks, and these to kvm/queue as well:
> 
>   KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits emulation
>   KVM: x86: Remove separate "bit" defines for page fault error code masks
>   KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
>   KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
>   KVM: x86/mmu: Pass full 64-bit error code when handling page faults
>   KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are non-zero

Paolo,

It seems you forgot to incorporate the review comment into the patch 
before you queued them to kvm/queue.

e.g., the comment from Dongli to

KVM: x86: Define more SEV+ page fault error bits/flags for #NPF

https://lore.kernel.org/all/12f0b643-e2e8-8a9a-b264-5c7c460f1a24@oracle.com/


