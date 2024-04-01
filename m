Return-Path: <kvm+bounces-13267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29ACA89389F
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 09:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B4681C20FE6
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 07:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD07B67D;
	Mon,  1 Apr 2024 07:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hERuwyHl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0978480;
	Mon,  1 Apr 2024 07:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711956195; cv=none; b=kajg+lpeNMDT/bR1VfLViQYEmM07Y+9XPB874t4g5cKVT8GyefJHu30ig0BtRRerBNGdFqR/oOvqE7Nd8RJt21PcMMzyCkE2gK+T4duQv8pzTKspN5+lYKRQou+m4FUogcPCBxpI/ox1iSlpoqXUQONIr2FTFFkbe9oXJb8CCuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711956195; c=relaxed/simple;
	bh=Ezycmnn7/V5CGwXkSuVumI+IORwY0gBsF2k0Yk2ici0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/T6eNXbZjIrdbE8rYgWV9/3/COyKDz36y+CBQyLf37L86dtVE8fTa0OvJ3eNa9mMQWfG/LYZbW/mb3pqDdEzB+uoSz2EQXgijIyrr7fsm2mYPXwA1YcnbcDzyDZMudLm7hIa1uCTJbzJppeSUu5Kaogqvr9qGx0RgnugetSgmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hERuwyHl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711956193; x=1743492193;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ezycmnn7/V5CGwXkSuVumI+IORwY0gBsF2k0Yk2ici0=;
  b=hERuwyHlbl8YgNurhEYhTgadKCMbAX9bSAENJadvyrtWtQm9X7BwGBJ5
   /SnCZ4SgTdv5eysmZgYQ44Ih3RP2gLRAbPQHLxFsuHuVa7GouOGi2svMH
   V87dbU7hwYdow6SvXMn1dxYVxoY94xUVb+fdGH9cDecdlHRZ/WT9zgOOP
   BYfvG7f+8X/B4kJwv4ax3fVF2MDLXwlM/d0Uht4H1D/NeSmy/It/8Cnae
   y8QVbJ+Nv/7Xh53Nfxsi9g6PeY0BBBbSOw/H101yZ4yqM9BFVgr2REB6K
   FxiGL2Up6T/fXzZEIVcFx/FlDZ4sew7VG2fbkE5PX24/I6dTtn8NKSzv2
   Q==;
X-CSE-ConnectionGUID: ZstI885XShasXDYY/w3wgg==
X-CSE-MsgGUID: b+dqwTaSSaGF7HTvp7TJNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="32480977"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="32480977"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="22376374"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:23:07 -0700
Message-ID: <e908635d-acd2-405d-ae41-d6ecdea7385b@intel.com>
Date: Mon, 1 Apr 2024 15:23:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yuan, Hang"
 <hang.yuan@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <Zfp+YWzHV0DxVf1+@chao-email>
 <20240321155513.GL1994522@ls.amr.corp.intel.com>
 <5470570d804b52dcf24b454d5fdfc2320f735e80.camel@intel.com>
 <b065cf99-74bc-42d1-95a3-8a0b018218ee@intel.com>
 <482bd937c52cf79c49f1c666cbc8d28c11af7c4a.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <482bd937c52cf79c49f1c666cbc8d28c11af7c4a.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/29/2024 2:26 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-03-28 at 09:36 +0800, Xiaoyao Li wrote:
>>>>> Any reason to mask off non-configurable bits rather than return an error? this
>>>>> is misleading to userspace because guest sees the values emulated by TDX module
>>>>> instead of the values passed from userspace (i.e., the request from userspace
>>>>> isn't done but there is no indication of that to userspace).
>>>>
>>>> Ok, I'll eliminate them.  If user space passes wrong cpuids, TDX module will
>>>> return error. I'll leave the error check to the TDX module.
>>>
>>> I was just looking at this. Agreed. It breaks the selftests though.
>>
>> If all you prefer to go this direction, then please update the error
>> handling of this specific SEAMCALL.
> 
> What do you mean by SEAMCALL, TDH_MNG_INIT? Can you be more specific?

Sorry. I missed the fact that current patch already has the specific 
handling for TDX_OPERAND_INVALID for TDH.MNG.INIT.

I need to update QEMU to match the new behavior.

