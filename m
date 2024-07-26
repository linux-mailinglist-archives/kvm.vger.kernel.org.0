Return-Path: <kvm+bounces-22298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D07F193CEAD
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 007801C20942
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F9F176AD1;
	Fri, 26 Jul 2024 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z17srSh+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7373176AA6;
	Fri, 26 Jul 2024 07:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978111; cv=none; b=iHky6kFKGvCxc+TzkIDGM/faKho8sBEaBXZgQ2s02l8qgpnerUvfJZ16hXdAcTIV8IHiVxxK/8mtrlQRn7CCYOpFewGbqNdSXxHAZSm5ihx6eSqbsDPsFc0yEf4VAVUuQfqojawurZF9IPWsAnKtHQw6y5RJz0ppgl2/xs4bovk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978111; c=relaxed/simple;
	bh=RJP92SF2WFoPIDG2hG1+hg5Un5h0Inykr9KdpLr/vGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9fo88zcnzQ2SijOJbGYnfdf7SSmWCMbKhh035nXL/fueHzAr5w32RCgeNaS7V8Jd2eWqeaZnkfuMalRMPQkqjSrOqSg8FBWjhYatxCqBSegJPtwJvvegws+ZzU9L1KvTcS5N+sTaHT9bVU+c3Xo+CKnn9rANSueVEBcU33qQsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z17srSh+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721978109; x=1753514109;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RJP92SF2WFoPIDG2hG1+hg5Un5h0Inykr9KdpLr/vGA=;
  b=Z17srSh+It12XGrUvaok7S660SgPjKIw4VGS5CeT5KAjA55EtUpUpLDs
   kg5jxwL3c5N17fOQ7rY3midZvhLcwMBHnAXI9FKq7mVL8BiEYL+mwuBQC
   FqdK6jSu0/rHhjAFGmi3WRxwCrsYZfm/LOMPPBY4KaHbh8WVtnb2w6hNq
   lXh3m/5g0NM/HvlovveixU9TdsutmAZwb88T2erJjcviR4hGSvfoKygpd
   z7h0fu6AVF9r/kdQ6naGOCowfke3lO2d6NrUNw733L2jENWQ8bquuuM+S
   G/urpR8YSs8CoQbpFhNs9BX52hJZqdrt4dMgIFNTU6CJJP74KgmTNpSgh
   g==;
X-CSE-ConnectionGUID: 2/M9qSj+Sq2+7GrRwjcUgQ==
X-CSE-MsgGUID: e4f2+vqST+m6echhxdDeSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="45175954"
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="45175954"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2024 00:15:08 -0700
X-CSE-ConnectionGUID: VA/vNtmiRl+7516OPD9unw==
X-CSE-MsgGUID: PVTpmcntRtu0h49j3OarXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="53196595"
Received: from taofen1x-mobl1.ccr.corp.intel.com (HELO [10.238.11.85]) ([10.238.11.85])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2024 00:15:04 -0700
Message-ID: <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
Date: Fri, 26 Jul 2024 15:15:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
To: Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
 jroedel@suse.de, thomas.lendacky@amd.com, pgonda@google.com,
 ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Peng, Chao P" <chao.p.peng@intel.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com> <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com>
 <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/29/2024 8:36 AM, Michael Roth wrote:
> On Fri, Jun 28, 2024 at 01:08:19PM -0700, Sean Christopherson wrote:
>> On Wed, Jun 26, 2024, Michael Roth wrote:
>>> On Wed, Jun 26, 2024 at 07:22:43AM -0700, Sean Christopherson wrote:
>>>> On Fri, Jun 21, 2024, Michael Roth wrote:
>>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>>> index ecfa25b505e7..2eea9828d9aa 100644
>>>>> --- a/Documentation/virt/kvm/api.rst
>>>>> +++ b/Documentation/virt/kvm/api.rst
>>>>> @@ -7122,6 +7122,97 @@ Please note that the kernel is allowed to use the kvm_run structure as the
>>>>>   primary storage for certain register types. Therefore, the kernel may use the
>>>>>   values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>>>>>   
>>>>> +::
>>>>> +
>>>>> +		/* KVM_EXIT_COCO */
>>>>> +		struct kvm_exit_coco {
>>>>> +		#define KVM_EXIT_COCO_REQ_CERTS			0
>>>>> +		#define KVM_EXIT_COCO_MAX			1
>>>>> +			__u8 nr;
>>>>> +			__u8 pad0[7];
>>>>> +			union {
>>>>> +				struct {
>>>>> +					__u64 gfn;
>>>>> +					__u32 npages;
>>>>> +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN		1
>>>>> +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC		(1 << 31)
>>>> Unless I'm mistaken, these error codes are defined by the GHCB, which means the
>>>> values matter, i.e. aren't arbitrary KVM-defined values.
>>> They do happen to coincide with the GHCB-defined values:
>>>
>>>    /*
>>>     * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
>>>     * a GENERIC error code such that it won't ever conflict with GHCB-defined
>>>     * errors if any get added in the future.
>>>     */
>>>    #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
>>>    #define SNP_GUEST_VMM_ERR_BUSY          2
>>>    #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)
>>>
>>> and not totally by accident. But the KVM_EXIT_COCO_REQ_CERTS_ERR_* are
>>> defined/documented without any reliance on the GHCB spec and are purely
>>> KVM-defined. I just didn't really see any reason to pick different
>>> numerical values since it seems like purposely obfuscating things for
>> For SNP.  For other vendors, the numbers look bizarre, e.g. why bit 31?  And the
>> fact that it appears to be a mask is even more odd.
> That's fair. Values 1 and 2 made sense so just re-use, but that results
> in a awkward value for _GENERIC that's not really necessary for the KVM
> side.
>
>>> no real reason. But the code itself doesn't rely on them being the same
>>> as the spec defines, so we are free to define these however we'd like as
>>> far as the KVM API goes.
>>>> I forget exactly what we discussed in PUCK, but for the error codes, I think KVM
>>>> should either define it's own values that are completely disconnected from any
>>>> "harware" spec, or KVM should very explicitly #define all hardware values and have
>>> I'd gotten the impression that option 1) is what we were sort of leaning
>>> toward, and that's the approach taken here.
>>> And if we expose things selectively to keep the ABI small, it's a bit
>>> awkward too. For instance, KVM_EXIT_COCO_REQ_CERTS_ERR_* basically needs
>>> a way to indicate success/fail/ENOMEM. Which we have with
>>> (assuming 0==success):
>>>
>>>    #define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN         1
>>>    #define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC             (1 << 31)
>>>
>>> But the GHCB also defines other values like:
>>>
>>>    #define SNP_GUEST_VMM_ERR_BUSY          2
>>>
>>> which don't make much sense to handle on the userspace side and doesn't
>> Why not?  If userspace is waiting on a cert update for whatever reason, why can't
>> it signal "busy" to the guest?
> My thinking was that userspace is free to take it's time and doesn't need
> to report delays back to KVM. But it would reduce the potential for
> soft-lockups in the guest, so it might make sense to work that into the
> API.
>
> But more to original point, there could be something added in the future
> that really has nothing to do with anything involving KVM<->userspace
> interaction and so would make no sense to expose to userspace.
> Unfortunately I picked a bad example. :)
>
>>> really have anything to do with the KVM_EXIT_COCO_REQ_CERTS KVM event,
>>> which is a separate/self-contained thing from the general guest request
>>> protocol. So would we expose that as ABI or not? If not then we end up
>>> with this weird splitting of code. And if yes, then we have to sort of
>>> give userspace a way to discover whenever new error codes are added to
>>> the GHCB spec, because KVM needs to understand these value too and
>> Not necessarily.  So long as KVM doesn't need to manipulate guest state, e.g. to
>> set RBX (or whatever reg it is) for ERR_INVALID_LEN, then KVM doesn't need to
>> care/know about the error codes.  E.g. userspace could signal VMM_BUSY and KVM
>> would happily pass that to the guest.
> But given we already have an exception to that where KVM does need to
> intervene for certain errors codes like ERR_INVALID_LEN that require
> modifying guest state, it doesn't seem like a good starting position
> to have to hope that it doesn't happen again.
>
> It just doesn't seem necessary to put ourselves in a situation where
> we'd need to be concerned by that at all. If the KVM API is a separate
> and fairly self-contained thing then these decisions are set in stone
> until we want to change it and not dictated/modified by changes to
> anything external without our explicit consideration.
>
> I know the certs things is GHCB-specific atm, but when the certs used
> to live inside the kernel the KVM_EXIT_* wasn't needed at all, so
> that's why I see this as more of a KVM interface thing rather than
> a GHCB one. And maybe eventually some other CoCo implementation also
> needs some interface for fetching certificates/blobs from userspace
> and is able to re-use it still because it's not too SNP-specific
> and the behavior isn't dictated by the GHCB spec (e.g.
> ERR_INVALID_LEN might result in some other state needing to be
> modified in their case rather than what the GHCB dictates.)

TDX GHCI does have a similar PV interface for TDX guest to get quota, i.e.,
TDG.VP.VMCALL<GetQuote>.  This GetQuote PV interface is designed to invoke
a request to generate a TD-Quote signing by a service hosting TD-Quoting
Enclave operating in the host environment for a TD Report passed as a
parameter by the TD.
And the request will be forwarded to userspace for handling.

So like GHCB, TDX needs to pass a shared buffer to userspace, which is
specified by GPA and size (4K aligned) and get the error code from
userspace and forward the error code to guest.

But there are some differences from GHCB interface.
1. TDG.VP.VMCALL<GetQuote> is a a doorbell-like interface used to queue a
    request. I.e., it is an asynchronous request.  The error code represents
    the status of request queuing, *not* the status of TD Quote generation..
2. Besides the error code returned by userspace for GetQuote interface, the
    GHCI spec defines a "Status Code" field in the header of the shared 
buffer.
    The "Status Code" field is also updated by VMM during the real 
handling of
    getting quote (after TDG.VP.VMCALL<GetQuote> returned to guest).
    After the TDG.VP.VMCALL<GetQuote> returned and back to TD guest, the TD
    guest can poll the "Status Code" field to check if the processing is
    in-flight, succeeded or failed.
    Since the real handling of getting quota is happening in userspace, and
    it will interact directly with guest, for TDX, it has to expose TDX
    specific error code to userspace to update the result of quote 
generation.

Currently, TDX is about to add a new TDX specific KVM exit reason, i.e.,
KVM_EXIT_TDX_GET_QUOTE and its related data structure based on a previous
discussion. https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
For the error code returned by userspace, KVM simply forward the error code
to guest without further translation or handling.

I am neutral to have a common KVM exit reason to handle both GHCB for
REQ_CERTS and GHCI for GET_QUOTE.  But for the error code, can we uses 
vendor
specific error codes if KVM cares about the error code returned by userspace
in vendor specific complete_userspace_io callback?

BTW, here is the plan of 4 hypercalls needing to exit to userspace for
TDX basic support series:
TDG.VP.VMCALL<SetupEventNotifyInterrupt>
- Add a new KVM exit reason KVM_EXIT_TDX_SETUP_EVENT_NOTIFY
TDG.VP.VMCALL<GetQuote>
- Add a new KVM exit reason KVM_EXIT_TDX_GET_QUOTE
TDG.VP.VMCALL<MapGPA>
- Reuse KVM_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
TDG.VP.VMCALL<ReportFatalError>
- Reuse KVM_EXIT_SYSTEM_EVENT but add a new type
   KVM_SYSTEM_EVENT_TDX_FATAL_ERROR



