Return-Path: <kvm+bounces-49585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF27ADAA73
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AAE83AFCD4
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 08:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11DE25BEEE;
	Mon, 16 Jun 2025 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ae9nqzGF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392572586C8;
	Mon, 16 Jun 2025 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750061733; cv=none; b=ZEmGcylgqbvyqd02SBhrH3x3dwVIvzUBY3lEIXDjkwWERRisdfNgjwOk1UnyWl4g5KE5R7heFghZZ9c4ZqjcqBtMb7rHwjzMSfXPzob3oen+XhDFKXZKpxwUJyIgkTpQ02PjNh83nKMNDGw728eTKBKlJ9E8bFjXW1B1vxY0mM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750061733; c=relaxed/simple;
	bh=gX4mtfYkVeZn70fgnwhPFgC8gGBCBTbaxJCCUWsb65A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2OBjXCIoWdlDxyqCSpMYVuvTknobimMRpOHrwzxG6q4YUU4I/8IDjjXZHhX+rdgkpX3lplmvHi+/cpqy5jBKNGxlSrOFjL1RKmu6HaZSVKDkEBdj0frdFSNkADXEAg5VlBnoWXDIHDGhhowqGGfxam6VQDHA6KpTICTb910EWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ae9nqzGF; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750061732; x=1781597732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gX4mtfYkVeZn70fgnwhPFgC8gGBCBTbaxJCCUWsb65A=;
  b=Ae9nqzGFWXDF7WIhnvagv0cdhoFuKSyizZ7TvDMvwI80GObb/kc+MUBX
   4ANmq2NY8fTzagxoy9dyJZM4QdITEKKZcPGjfQDic955vjX6C+eIhuATC
   yuV/CZumZqiQiSk8oJjVeFLHkLX8GiKzeuFsAGraZWhwzKZoSpsdDRNPY
   EA0AS7IJCwEU/VoJQuhodvsPZjWf2LElVsmt2zN/HLA9BjCDk7AaXYZgV
   o4ne10CRSMNLasg6/542wcleNgL8j/bGj+Qr5/3v4DUD991MDbDjy94XW
   e8/sxajmc+nM7QqRU0QcNLL0kLJERaBEVzmr+qWY3TYUFSAOG/ZHSqrsN
   g==;
X-CSE-ConnectionGUID: Rw9KSAh7S9GGnWW6P08NJw==
X-CSE-MsgGUID: Pa1jtODaRKmYvUNAd6PNog==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="39804451"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="39804451"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 01:15:31 -0700
X-CSE-ConnectionGUID: qYt+wqnPQXOlyeWZqYGb2Q==
X-CSE-MsgGUID: SW+8wFk/QEWzloyU1gsEag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148951762"
Received: from zhaohaif-mobl1.ccr.corp.intel.com (HELO [10.124.224.2]) ([10.124.224.2])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 01:15:27 -0700
Message-ID: <a9628441-a242-4ef6-8d52-c3c3aba781b9@linux.intel.com>
Date: Mon, 16 Jun 2025 16:15:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] x86/traps: Fix DR6/DR7 inintialization
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
 Sohil Mehta <sohil.mehta@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, peterz@infradead.org, brgerst@gmail.com,
 tony.luck@intel.com, fenghuay@nvidia.com
References: <20250613070118.3694407-1-xin@zytor.com>
 <ac28b350-91a4-4e6d-bca6-4e0c80f4f503@intel.com>
 <c93b8a59-9466-4d2f-8141-81142f5ead8c@zytor.com>
 <9D33DFBA-FE08-47B3-9663-7252B943F595@zytor.com>
From: Ethan Zhao <haifeng.zhao@linux.intel.com>
Autocrypt: addr=haifeng.zhao@linux.intel.com; keydata=
 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
 8TCx1OJHpvWFmL4Deq8=
In-Reply-To: <9D33DFBA-FE08-47B3-9663-7252B943F595@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/6/14 11:38, H. Peter Anvin 写道:
> On June 13, 2025 4:22:57 PM PDT, Xin Li <xin@zytor.com> wrote:
>> On 6/13/2025 3:43 PM, Sohil Mehta wrote:
>>> On 6/13/2025 12:01 AM, Xin Li (Intel) wrote:
>>>
>>>> Xin Li (Intel) (3):
>>>>     x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg.h>
>>>>     x86/traps: Initialize DR7 by writing its architectural reset value
>>>>     x86/traps: Initialize DR6 by writing its architectural reset value
>>>>
>>> The patches fix the false bus_lock warning that I was observing with the
>>> infinite sigtrap selftest.
>>>
>>> Tested-by: Sohil Mehta <sohil.mehta@intel.com>
>>>
>>> I'll try it out again once you send the updated version.
>> Thank you very much!
>>
>>> In future, should we incorporate a #DB (or bus_lock) specific selftest
>>> to detect such DR6/7 initialization issues?
>>
>> I cant think of how to tests it.  Any suggestion about a new test?
>>
> You would have to map some memory uncached.

To trigger a real bus_lock event in user space ?


Thanks,

Ethan

>
-- 
"firm, enduring, strong, and long-lived"


