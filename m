Return-Path: <kvm+bounces-32491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1E29D9159
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 06:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80680289F5B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 05:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C2D15575F;
	Tue, 26 Nov 2024 05:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZvxRgFVS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6D1653;
	Tue, 26 Nov 2024 05:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732598971; cv=none; b=gzI+qfHn9p/HkMIp1e9NCJ4HmDCLyJoF9NTR5gWV7a5Nn70HH0oOqkjG019ypYoNdXev9sUHhAB0+binBGhYrMBI1NyMp8YrTyzJlCokX3TqaKC8vyEWaErAhiMvipUBxfAsX4EBqFI12f5Zaecqwl1iFq3MIBkQDsi5Q7hjyos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732598971; c=relaxed/simple;
	bh=GGRmZfmUiMkylgoPiUFuoPW0BxU2dT8ye4teaNAz33Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KIG79UIFy+nWTYlSgsVUevGeLBvG+s/j98sN11NfZAiEMVhLO+ta2QWb6TBxdZfezGQ+EpH13dutl06Er+2CQSvij9iKHKNVwwkNjOJT6BnL5KuOrdEv+NrDLcJo44EroK9+F4Slth3R9uA4mJTJMXs76glYJGY51lTy0rD6RNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZvxRgFVS; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732598970; x=1764134970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GGRmZfmUiMkylgoPiUFuoPW0BxU2dT8ye4teaNAz33Q=;
  b=ZvxRgFVSN7u30H9knY73vmuusRDuG3/pclcFY+SYBa4W1shjIc3IUluX
   LrQvxAT2Seqiw0XiXlqH1w7hqEMAr7zHVf4BLZdAH6uY8kBddspK1D612
   bQUE9lbZe9iEss/BjfVCHBz2E1SFnjHFgRkAtSYcvDbXmdN52G0uxtKSW
   z2yrhCCJenlZurip8LCoMXzChrK1iquVNFrVtsb9casf+9uvDAOrXqc+0
   vIUunGH9vbAeDNtc89BkhJkDmwxYK0gcI8TYejEmsKOuVvgPzvwnH3iWp
   PVlpa1L2vRgwFz7tliUEn1hhxvqB91/2WqhmowA/pprpCEscK+8jEcORD
   w==;
X-CSE-ConnectionGUID: 4xa9O8T6RRaBEnqp6I4kzw==
X-CSE-MsgGUID: 6y+yHtruT1yL2qK6kBjOIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43400177"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="43400177"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 21:29:29 -0800
X-CSE-ConnectionGUID: bWgzsmXGRgqan4VnhP0Yjw==
X-CSE-MsgGUID: CC7XiTTHSM+tuPLSxZ5Bvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="95921008"
Received: from unknown (HELO [10.238.10.67]) ([10.238.10.67])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 21:29:25 -0800
Message-ID: <8db4d414-b8f0-4ea2-a850-0f168967fb94@linux.intel.com>
Date: Tue, 26 Nov 2024 13:29:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Gao, Chao" <chao.gao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "Li, Xin3" <xin3.li@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
 <Z0SVf8bqGej_-7Sj@google.com>
 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
 <Z0T_iPdmtpjrc14q@google.com>
 <57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com>
 <d27b4e076c3ad2f5d7d71135f112e6a45e067ae7.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d27b4e076c3ad2f5d7d71135f112e6a45e067ae7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/26/2024 11:52 AM, Huang, Kai wrote:
> On Tue, 2024-11-26 at 09:44 +0800, Binbin Wu wrote:
>>
>> On 11/26/2024 6:51 AM, Sean Christopherson wrote:
>>
>> [...]
>>> When an NMI happens in non-root, the NMI is acknowledged by the CPU prior to
>>> performing VM-Exit.  In regular VMX, NMIs are blocked after such VM-Exits.  With
>>> TDX, that blocking happens for SEAM root, but the SEAMRET back to VMX root will
>>> load interruptibility from the SEAMCALL VMCS, and I don't see any code in the
>>> TDX-Module that propagates that blocking to SEAMCALL VMCS.
>> I see, thanks for the explanation!
>>
>>> Hmm, actually, this means that TDX has a causality inversion, which may become
>>> visible with FRED's NMI source reporting.  E.g. NMI X arrives in SEAM non-root
>>> and triggers a VM-Exit.  NMI X+1 becomes pending while SEAM root is active.
>>> TDX-Module SEAMRETs to VMX root, NMIs are unblocked, and so NMI X+1 is delivered
>>> and handled before NMI X.
>> This example can also cause an issue without FRED.
>> 1. NMI X arrives in SEAM non-root and triggers a VM-Exit.
>> 2. NMI X+1 becomes pending while SEAM root is active.
>> 3. TDX-Module SEAMRETs to VMX root, NMIs are unblocked.
>> 4. NMI X+1 is delivered and handled before NMI X.
>>      (NMI handler could handle all NMI source events, including the source
>>       triggered NMI X)
>> 5. KVM calls exc_nmi() to handle the VM Exit caused by NMI X
>> In step 5, because the source event caused NMI X has been handled, and NMI X
>> will not be detected as a second half of back-to-back NMIs, according to
>> Linux NMI handler, it will be considered as an unknown NMI.
> I don't think KVM should call exc_nmi() anymore if NMI is unblocked upon
> SEAMRET.

IIUC, KVM has to, because the NMI triggered the VM-Exit can't trigger the
NMI handler to be invoked automatically even if NMI is unblocked upon SEAMRET.

>
>> Actually, the issue could happen if NMI X+1 occurs after exiting to SEAM root
>> mode and before KVM handling the VM-Exit caused by NMI X.
>>
> If we can make sure NMI is still blocked upon SEAMRET then everything follows
> the current VMX flow IIUC.  We should make that happen IMHO.
>
>
Agree.

