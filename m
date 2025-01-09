Return-Path: <kvm+bounces-34856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A70A06B9D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4CE33A145B
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA1913633F;
	Thu,  9 Jan 2025 02:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kTwMotIY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297CFB677;
	Thu,  9 Jan 2025 02:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736390656; cv=none; b=OUPQZdlQdDD9lODZEA/mDeReH9DApEFIAz4E7qUInFQ4KtB3SCOm+rgPQmv2nEmuP1zpu+oSz0eksPVc0ObIwgzJ3HqO7aPyjVajdMo9ChMM6SEDH2bLluDw4hgsXEPEqnJNQFKhm/qLldv9ZzL6yDG7+n35o8IEKUNoZ48QeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736390656; c=relaxed/simple;
	bh=7k+mdF549qSWQusWg4/vdeeGlCUR59Hy/a5tDPYZft4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmCLbukQaX73dKsySbzKbX2nkMWWsQ0gbLZJTtKmFTKpbxhqxRjEAUGXdE36BWxR1yfEbxeLqCLJ0bh8ojsbFs2upswVxEA6FGtQfujdbSMDMAHI6zpswY4iXqmRUfFwBc/2e/G8uWTmN7GCF4dHdb5dIP23KuLNKAlVvqQgIeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kTwMotIY; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736390654; x=1767926654;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7k+mdF549qSWQusWg4/vdeeGlCUR59Hy/a5tDPYZft4=;
  b=kTwMotIYRudj7QCS1JSFYc03lSUwzBc+OnkopvgZ8zQY2jo9c3XwTeMs
   5tsEGmehsRh3v1N8RMEh74m9y7jvv7vVCuXKwsLwgACa1Z69lb0iNLE7g
   eqDJlCb1xW2NPy0Ra6D7HRwTJ7fDFscOWtxzbOAqn8qd+2DECCfZNnwsJ
   /Uxn4g9bLiUjOubmxZgA19VUrQZ2c99+ZCiuwHF734n8L59VzARKkMZr6
   knoFBg311r9MYfiYgWTNYmBEHwvzQibTHdsRapTRUeb9ALgT4ZdJJnpHF
   s6dKDTRBdWM3/9gDTWZsyI75Ca6foeKtDfSyXOSqXb6OLRdgiRmZENZbR
   A==;
X-CSE-ConnectionGUID: cgOBH7v+TnSPoyfyvVE7xA==
X-CSE-MsgGUID: PqamjesCS0yFw9oE5QI2wQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36797247"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36797247"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:44:13 -0800
X-CSE-ConnectionGUID: YKm54DItS4i7FlJLr+eIXg==
X-CSE-MsgGUID: eaDi7FDzSeai3KLt70zOBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103082452"
Received: from unknown (HELO [10.238.12.121]) ([10.238.12.121])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:44:11 -0800
Message-ID: <38116f37-c720-4285-8aaf-1bd64f86c62d@linux.intel.com>
Date: Thu, 9 Jan 2025 10:44:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] KVM: TDX: TDX interrupts
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <af89758d-d029-419e-bcb5-713b2460163d@intel.com>
 <Z3w4Ku4Jq0CrtXne@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z3w4Ku4Jq0CrtXne@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 1/7/2025 4:08 AM, Sean Christopherson wrote:
> On Mon, Jan 06, 2025, Xiaoyao Li wrote:
>> On 12/9/2024 9:07 AM, Binbin Wu wrote:
>>> Hi,
>>>
>>> This patch series introduces the support of interrupt handling for TDX
>>> guests, including virtual interrupt injection and VM-Exits caused by
>>> vectored events.
>>>
>> (I'm not sure if it is the correct place to raise the discussion on
>> KVM_SET_LAPIC and KVM_SET_LAPIC for TDX. But it seems the most related
>> series)
>>
>> Should KVM reject KVM_GET_LAPIC and KVM_SET_LAPIC for TDX?
> Yes, IIRC that was what Paolo suggested in one of the many PUCK calls.  Until
> KVM supports intra-host migration for TDX guests, getting and setting APIC state
> is nonsensical.
>
By rejecting KVM_GET_LAPIC/KVM_SET_LAPIC for TDX guests (i.e.,
guest_apic_protected), I think it should return an error code instead of
returning 0.
Then it requires modifications in QEMU TDX support code to avoid requesting
KVM_GET_LAPIC/KVM_SET_LAPIC.

