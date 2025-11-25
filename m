Return-Path: <kvm+bounces-64449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B22C83010
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 02:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8161B4E2713
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 01:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D304274B28;
	Tue, 25 Nov 2025 01:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMQRp4cN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC421DB54C;
	Tue, 25 Nov 2025 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764034061; cv=none; b=Q29eJ/AjRakZWR9GGJxGvkmbfWOma5n78yd7rJuCNfMRDr8K396CMAlYSb3oLaZETtZSOdHjt9LBf9C5s4N1fwev3XwRg9kM/8cNAvGBdOXUN+BkNQkBB5weL6jM26N9vs0rcd0BaAHgc8pgZvQVtYqPTNf3lXLIwGxxa7Y1mu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764034061; c=relaxed/simple;
	bh=7D3YTZVaAhtS21oXZxgvYUu671mV7+8gqJLNhLRMrls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpXOyAJBOO9HaffyrtQuLY3qC5jzzS+pXVx5HjcKPRQk6pnJ8cFZCuf+1I8Mudi+mxAkHyuNGggP8JDlwS4Fdfxo3vG4zQ0gOO+xxARkA0DnPf11iNPLWbI8qUdXv66AR7IX9Z4iWYmOuoeRqv3DdVEuYcRWxgbp1htkAoYL5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMQRp4cN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764034058; x=1795570058;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7D3YTZVaAhtS21oXZxgvYUu671mV7+8gqJLNhLRMrls=;
  b=NMQRp4cNOJ1mO615yRZ1W9/DuODsR5V0AYIp+XTin2LixWD/2MKBh9kU
   FfKAT4pj618OQq0rZk5Iclh0PI0JpjJytozztaqeFV5XaCc1sCidxQosq
   lkIhcRmQJ4rlb5SUZWVq+pqADmA0APMzSCvjDokeU4UNnc+7Ge38uu+5w
   G5fEtp+r/sWIc+/xwGKrGKe2PbKIJDZdlSdJzUaEqkLNh3S7sm9neg7J2
   INzWQ9PCX+MJ/ar7IsH9o6YKmSwn/mPeVjXQImKPCn9gJ8Cl0G3Ncwo9D
   Wp9UV+/oIEEW+Xm4vVzKbcKvc6J2yRIxkU5SwWILAYXjXQo7l3SWQB6pT
   A==;
X-CSE-ConnectionGUID: vWTAZuxNQ9G/aNvaO+PvLA==
X-CSE-MsgGUID: wBrLoi8BS9mdJY7eCFDnjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77521084"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="77521084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 17:27:37 -0800
X-CSE-ConnectionGUID: kHWrSVefRD6JpvW8KQRNmw==
X-CSE-MsgGUID: V6z1ht6FTnqmSv4H6SxBDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="196958254"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 17:27:33 -0800
Message-ID: <23965509-7b15-4dc1-b734-6e66575581a8@linux.intel.com>
Date: Tue, 25 Nov 2025 09:27:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
 <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-4-rick.p.edgecombe@intel.com>
 <8eba534b-7fcf-43b2-a304-091993faef1c@linux.intel.com>
 <f495fed769914a476bace0fd7eb58bebd933f6af.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f495fed769914a476bace0fd7eb58bebd933f6af.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/25/2025 3:47 AM, Edgecombe, Rick P wrote:
> On Mon, 2025-11-24 at 17:26 +0800, Binbin Wu wrote:
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Thanks.
>
>> One nit below.
>>
>> [...]
>>> @@ -535,26 +518,18 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
>>>     	 * in overlapped TDMRs.
>>>     	 */
>>>     	pamt = alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
>>> -			nid, &node_online_map);
>>> -	if (!pamt)
>>> +				  nid, &node_online_map);
>>> +	if (!pamt) {
>>> +		/*
>>> +		 * tdmr->pamt_4k_base is zero so the
>>> +		 * error path will skip freeing.
>>> +		 */
>>>     		return -ENOMEM;
>> Nit:
>> Do you think it's OK to move the comment up so to avoid multiple lines of
>> comments as well as the curly braces?
> Yea, I think that is a good point. But I'm also thinking that this comment is
> not clear enough. There is no error path to speak of in this function, so maybe:
>
> 	/*
> 	 * tdmr->pamt_4k_base is still zero so the error
> 	 * path of the caller will skip freeing the pamt.
> 	 */
>
> If you agree I will keep your RB.
Yes, please.

>>           /* tdmr->pamt_4k_base is zero so the error path will skip freeing. */
>>           if (!pamt)
>>               return -ENOMEM;


