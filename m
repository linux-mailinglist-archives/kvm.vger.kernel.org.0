Return-Path: <kvm+bounces-71714-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENn6Atk/nmlXUQQAu9opvQ
	(envelope-from <kvm+bounces-71714-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:18:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C082118E5A6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7BBC630AB0E8
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 00:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B1921CC5B;
	Wed, 25 Feb 2026 00:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O8FDCuhz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC4D1F09B3;
	Wed, 25 Feb 2026 00:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771978691; cv=none; b=K+9Qr3+k1a9m5qlf0EdwvPIZHErQNGBa4m+cHYI7f+FrpOV26QqtYRav6MI5T2iskVzRuwYlNDMJTaE761zOf+l3Y93creCgVVhu7KL/TooP2MO/w4OsxiHUGC1PiV/T3PxmyZcIV1U6wVBAAgBHN8JLwJYar/c7PkBaYCWUNGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771978691; c=relaxed/simple;
	bh=bYVVLZqdIImz6W8bPziDXDDa2N8sm/FTjvgZPVHPdbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F6BYdODVQP/p7W41qwHHDZ/U2VpJzbOgYx7FFHsGK6vRWDMkNodoWZbBsfpnhND4E9v0g1v9y8uZsIBiLGWXXEGuduKXDOvngYH24lxPHuEzBS8YXuUJdN21uSNLPpIh01HXdrgiDPlhU6VWNhfzxfumDJeap3JBXkux8XKBEfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O8FDCuhz; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771978690; x=1803514690;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bYVVLZqdIImz6W8bPziDXDDa2N8sm/FTjvgZPVHPdbs=;
  b=O8FDCuhzX56zLlrha6qgAZn8PBGB7xiVFbAN0m0m8FcBUxYxi9cc706L
   xVdpjHZdi7hy49BEbHaIiiNSgv30hlJakDgu6rtRDZ5Rv2nMJaJBa0pvl
   rgHw7Bwp+I3rBlOvclwSvFxdHnB/QHBN+ncQn7PTqColSl38F6X7cJLib
   rL0gqRlvtyw9zghUmb1P34WqHifDt47pt5itAs/azviUEv51oUg08NJ24
   y1WnAXI9/SWXUg/pT1FclNoRI9Ngh0YO3b/d5A5GGSn9fPTtYb1Bua6NP
   o/jlvJEgIr0AjZFiuTZg20dpnv41OFe3rpKiWQfJMY1QM9u9weF4jCbv2
   Q==;
X-CSE-ConnectionGUID: jG8PDBt4SrOjOERlHyjstQ==
X-CSE-MsgGUID: 28hz8W3VTMupyYAlXvVWqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="76844697"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="76844697"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 16:18:10 -0800
X-CSE-ConnectionGUID: Vs0tWiL+TOaZPAyEHQ+eUQ==
X-CSE-MsgGUID: w38Ep/VeTBuLbg/Sq5cOtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="216075387"
Received: from louislu-mobl2.ccr.corp.intel.com (HELO [10.124.240.233]) ([10.124.240.233])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 16:18:07 -0800
Message-ID: <f4b9ef8c-4cb8-4af6-93ff-49a206ae564a@linux.intel.com>
Date: Wed, 25 Feb 2026 08:18:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 "changyuanl@google.com" <changyuanl@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, Binbin Wu
 <binbin.wu@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "tglx@kernel.org" <tglx@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
References: <20260223214336.722463-1-changyuanl@google.com>
 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
 <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
 <aZ3LxD5XMepnU8jh@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aZ3LxD5XMepnU8jh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_FROM(0.00)[bounces-71714-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: C082118E5A6
X-Rspamd-Action: no action



On 2/25/2026 12:03 AM, Sean Christopherson wrote:
> 
>>>> +	} else {
>>>> +		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>>>> +	}
>>>>  
>>>> +	WARN_ON_ONCE(cpuid_function_is_indexed(entry->function) !=
>>>> +		     !!(entry->flags &
>>>> KVM_CPUID_FLAG_SIGNIFCANT_INDEX));
>>>
>>> It warns on leaf 0x23 for me. Is it intentional?
>>
>> I guess because the list in cpuid_function_is_indexed() is hard-coded
>> and 0x23 is not added into the list yet.
> 
> Yeah, I was anticipating that we'd run afoul of leaves that aren't known to
> the kernel.  FWIW, it looks like 0x24 is also indexed.

0x24 is there already.



