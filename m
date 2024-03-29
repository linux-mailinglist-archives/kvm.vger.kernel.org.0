Return-Path: <kvm+bounces-13054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C76A891448
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 08:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5D5628387C
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 07:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91C542054;
	Fri, 29 Mar 2024 07:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZInWLE4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF1A4176B;
	Fri, 29 Mar 2024 07:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711697154; cv=none; b=ML2EMNNfPbc89u21nUoL2y2MQxK7LI2YbbEqamDW29uZ9aIl6bODgsRw2sOxVPbiYLeINrP4JsIqEPDvX8G+xPEz+wXFohCaGBXZEzPLqo/dbz134GMAHQlhodhXSqH0gnEZC4eC69o1+DO9/2E7EJ/m3fE6gvqhtPGJ+Wfom6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711697154; c=relaxed/simple;
	bh=q/qIYXt+0gsDpQDFJZuqnL/uaIcsR0UZmn8FB/WzRQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ihz4vb+jH5/qt1AI9qvSVUJBwtjcZ/BkfZ/z9Rc8GD4WbCJGye/CQz6PX3U7Mo86ryOvUBn9UvFdny5h4nW/TO3ogLuKStZvceiBPWapypGSKzxbEFxwIKCb30YoT1POq7udPfcEo+apaWfZzFUmPeK5LdmwDngeVP1AB9/Bdt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZInWLE4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711697153; x=1743233153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q/qIYXt+0gsDpQDFJZuqnL/uaIcsR0UZmn8FB/WzRQY=;
  b=NZInWLE4oFMovUkwjVB3eiV7m3mDOX48Q/luXQWwHeAs69sS1fzhnULx
   PmakBtq6tM5taroawbprq+S5LvByZYxYc/Gu1XCxdKixBqs3P+IK+uw01
   BFelHp9Pk6HJyz34DyTvGviH3elM2Z558vCBQgk/HZ8xFWwus+d75su21
   REKzx2obCN184srcY+9S/PwrnwMyZNC1FX+b5GpifwjgI0XHaVkgLxawn
   8x36GYN0IawpIYi/8tpv9fQ3mWMv7ML7SU5Szl1iUUbvDdy7uAC0K9mgv
   hOyGI+FpoI1zZsIksuqJwUkRIZHSGeyD1qz6pDZ6afLQ5RU82HAnaWr8E
   g==;
X-CSE-ConnectionGUID: up4BqJDSSvWnK9r7qAc69Q==
X-CSE-MsgGUID: 9GqpmMeTTfG7FvTJG66UXw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6996731"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="6996731"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 00:25:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="16942869"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 00:25:49 -0700
Message-ID: <71e6fa91-065c-4b28-ac99-fa71dfd499b9@linux.intel.com>
Date: Fri, 29 Mar 2024 15:25:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
 <20240327225337.GF2444378@ls.amr.corp.intel.com>
 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
 <20240328053432.GO2444378@ls.amr.corp.intel.com>
 <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
 <20240328203902.GP2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240328203902.GP2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/29/2024 4:39 AM, Isaku Yamahata wrote:

[...]
>>>>> How about this?
>>>>>
>>>>> /*
>>>>>    * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(), and
>>>>>    * TDH.MNG.KEY.FREEID() to free the HKID.
>>>>>    * Other threads can remove pages from TD.  When the HKID is assigned, we need
>>>>>    * to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().
>>>>>    * TDH.PHYMEM.PAGE.RECLAIM() is needed when the HKID is free.  Get lock to not
>>>>>    * present transient state of HKID.
>>>>>    */
>>>> Could you elaborate why it is still possible to have other thread removing
>>>> pages from TD?
>>>>
>>>> I am probably missing something, but the thing I don't understand is why
>>>> this function is triggered by MMU release?  All the things done in this
>>>> function don't seem to be related to MMU at all.
>>> The KVM releases EPT pages on MMU notifier release.  kvm_mmu_zap_all() does. If
>>> we follow that way, kvm_mmu_zap_all() zaps all the Secure-EPTs by
>>> TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().  Because
>>> TDH.MEM.{SEPT, PAGE}.REMOVE() is slow, we can free HKID before kvm_mmu_zap_all()
>>> to use TDH.PHYMEM.PAGE.RECLAIM().
>> Can you elaborate why TDH.MEM.{SEPT,PAGE}.REMOVE is slower than
>> TDH.PHYMEM.PAGE.RECLAIM()?
>>
>> And does the difference matter in practice, i.e. did you see using the former
>> having noticeable performance downgrade?
> Yes. With HKID alive, we have to assume that vcpu can run still. It means TLB
> shootdown. The difference is 2 extra SEAMCALL + IPI synchronization for each
> guest private page.  If the guest has hundreds of GB, the difference can be
> tens of minutes.
>
> With HKID alive, we need to assume vcpu is alive.
> - TDH.MEM.PAGE.REMOVE()
> - TDH.PHYMEM.PAGE_WBINVD()
> - TLB shoot down
>    - TDH.MEM.TRACK()
>    - IPI to other vcpus
>    - wait for other vcpu to exit

Do we have a way to batch the TLB shoot down.
IIUC, in current implementation, TLB shoot down needs to be done for 
each page remove, right?


>
> After freeing HKID
> - TDH.PHYMEM.PAGE.RECLAIM()
>    We already flushed TLBs and memory cache.
>
>
>>>> Freeing vcpus is done in
>>>> kvm_arch_destroy_vm(), which is _after_ mmu_notifier->release(), in which
>>>> this tdx_mmu_release_keyid() is called?
>>> guest memfd complicates things.  The race is between guest memfd release and mmu
>>> notifier release.  kvm_arch_destroy_vm() is called after closing all kvm fds
>>> including guest memfd.
>>>
>>> Here is the example.  Let's say, we have fds for vhost, guest_memfd, kvm vcpu,
>>> and kvm vm.  The process is exiting.  Please notice vhost increments the
>>> reference of the mmu to access guest (shared) memory.
>>>
>>> exit_mmap():
>>>    Usually mmu notifier release is fired. But not yet because of vhost.
>>>
>>> exit_files()
>>>    close vhost fd. vhost starts timer to issue mmput().
>> Why does it need to start a timer to issue mmput(), but not call mmput()
>> directly?
> That's how vhost implements it.  It's out of KVM control.  Other component or
> user space as other thread can get reference to mmu or FDs.  They can keep/free
> them as they like.
>
>
>>>    close guest_memfd.  kvm_gmem_release() calls kvm_mmu_unmap_gfn_range().
>>>      kvm_mmu_unmap_gfn_range() eventually this calls TDH.MEM.SEPT.REMOVE()
>>>      and TDH.MEM.PAGE.REMOVE().  This takes time because it processes whole
>>>      guest memory. Call kvm_put_kvm() at last.
>>>
>>>    During unmapping on behalf of guest memfd, the timer of vhost fires to call
>>>    mmput().  It triggers mmu notifier release.
>>>
>>>    Close kvm vcpus/vm. they call kvm_put_kvm().  The last one calls
>>>    kvm_destroy_vm().
>>>
>>> It's ideal to free HKID first for efficiency. But KVM doesn't have control on
>>> the order of fds.
>> Firstly, what kinda performance efficiency gain are we talking about?
> 2 extra SEAMCALL + IPI sync for each guest private page.  If the guest memory
> is hundreds of GB, the difference can be tens of minutes.
>
>
>> We cannot really tell whether it can be justified to use two different methods
>> to tear down SEPT page because of this.
>>
>> Even if it's worth to do, it is an optimization, which can/should be done later
>> after you have put all building blocks together.
>>
>> That being said, you are putting too many logic in this patch, i.e., it just
>> doesn't make sense to release TDX keyID in the MMU code path in _this_ patch.
> I agree that this patch is too huge, and that we should break it into smaller
> patches.
>
>
>>>> But here we are depending vcpus to be freed before tdx_mmu_release_hkid()?
>>> Not necessarily.
>> I am wondering when is TDH.VP.FLUSH done?  Supposedly it should be called when
>> we free vcpus?  But again this means you need to call TDH.MNG.VPFLUSHDONE
>> _after_ freeing vcpus.  And this  looks conflicting if you make
>> tdx_mmu_release_keyid() being called from MMU notifier.
> tdx_mmu_release_keyid() call it explicitly for all vcpus.


