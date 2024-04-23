Return-Path: <kvm+bounces-15663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F03C8AE7DD
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEFBF28DDFF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6FD135A4A;
	Tue, 23 Apr 2024 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kIl1Rd2w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBAE745E2;
	Tue, 23 Apr 2024 13:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878410; cv=none; b=j4vKS+PzhxPhx6JwKB898hXPRWu4pyCJDOx4pMhY3h7z5ouCQjwDL0xinN+Bg66fU3YErVOGbX16cEX9jAiNTV3B7yhY66T3uH0hcpvmMz0E5+yBXQvvYWIMiobLQEzKOZ4Yeu819joyqWt+rSv4/D5Bb9p1Sva4FISQArmWkIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878410; c=relaxed/simple;
	bh=TFx9xfvwbclzPPajH46kI/lyaHseaDkHlbeFy9Vg4RM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hnux5cArT6/HORT/+txUlWlCPelZh3JWz0T2bBZiU5C3Ana+n1oZR6QNkiJFzCfkfTYowGiqpBJkYVjWPRBJF498j3+4JHhyFOOrpcJAmw2N2TfNfApoHuGXvy8HRCl2thrf6vQUT92KGIBXnTZtdiYEnL6JgWhjgqYE+wCd6kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kIl1Rd2w; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713878410; x=1745414410;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TFx9xfvwbclzPPajH46kI/lyaHseaDkHlbeFy9Vg4RM=;
  b=kIl1Rd2wVyI1G0VgV1nQ9WxvT3S/VVROX2t7e0BIXwjplv+9yuXY5mm1
   ZEBK3EkH7X+9EryRZyy4TS8TeCy5MJBBB9tPljknZgkI24Tg64BgrPbSq
   9xEXgbP7FaQBs7ZFfIOVCb/TIxhQidIZagJ9ipWnWU9Z49YVVfo6dO1eu
   KOfhxeXEx9w4wuXA0yTdX2EOaVU7ezSiaYfFyE4iYueexLCYnsuJUjOK3
   JNqJErCojqDjDxAd5AkVFXAICeVlC+pEWgIcCF6Fq8x+vsW7YQNEvVI5b
   QVdULJ/hbH2uqDWwEpKRbavRXwECiVb4AXT8oDgOnUMvgpxAvs1jXcQFz
   A==;
X-CSE-ConnectionGUID: tt8teK9dTemw9GwhYJwodA==
X-CSE-MsgGUID: 6fsiG6ArSsimauSw/wIvcA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="31953602"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="31953602"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 06:15:40 -0700
X-CSE-ConnectionGUID: M86h0au6SiOVuxovR2hrAQ==
X-CSE-MsgGUID: fwqwAFHYRrOEtC6/GVhW/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="28864245"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.225.183]) ([10.124.225.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 06:15:36 -0700
Message-ID: <fe9cec78-36ee-4a20-81df-ec837a45f69f@linux.intel.com>
Date: Tue, 23 Apr 2024 21:15:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
 <7d19f693-d8e9-4a9d-8cfa-3ec9c388622f@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7d19f693-d8e9-4a9d-8cfa-3ec9c388622f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/17/2024 2:23 AM, Reinette Chatre wrote:
> Hi Isaku,
>
> (In shortlog "tdexit" can be "TD exit" to be consistent with
> documentation.)
>
> On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>> virtualize vAPIC, KVM only needs to care NMI injection.
> This seems to be the first appearance of NMI and the changelog
> is very brief. How about expending it with:
>
> "This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>   virtualize vAPIC, KVM only needs to care about NMI injection.
   ^
   virtualizes

Also, does it need to mention that non-NMI interrupts are handled by 
posted-interrupt mechanism?

For example:

"This corresponds to VMX __vmx_complete_interrupts().  Because TDX
  virtualizes vAPIC, and non-NMI interrupts are delivered using 
posted-interrupt
  mechanism, KVM only needs to care about NMI injection.
...
"

>
>   KVM can request TDX to inject an NMI into a guest TD vCPU when the
>   vCPU is not active. TDX will attempt to inject an NMI as soon as
>   possible on TD entry. NMI injection is managed by writing to (to
>   inject NMI) and reading from (to get status of NMI injection)
>   the PEND_NMI field within the TDX vCPU scope metadata (Trust
>   Domain Virtual Processor State (TDVPS)).
>
>   Update KVM's NMI status on TD exit by checking whether a requested
>   NMI has been injected into the TD. Reading the metadata via SEAMCALL
>   is expensive so only perform the check if an NMI was injected.
>
>   This is the first need to access vCPU scope metadata in the
>   "management" class. Ensure that needed accessor is available.
> "
>

