Return-Path: <kvm+bounces-42879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03EF8A7F282
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 04:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70E343AD106
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 02:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6CC78F5E;
	Tue,  8 Apr 2025 02:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YR5yWsvi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C00679C4
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 02:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744077640; cv=none; b=cGi0z3p8mNgo/KCqrWBu5KIyeQgUpi5OokdkyIDVQjlSnUWIXDMp0A9jXZL/drpRFb5A+RY6lHY62vLHxNr/oHHe2806bSPI4A4STBhhmXz1cQPe6HW3IjmkqaWF3iKU656ZJNNmGWY5irI2vP2VdYCvgKiZEoXm2BEZOJEIi6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744077640; c=relaxed/simple;
	bh=OCilHNMl6KOjdWUU2fEWt3Z/3p/1AspDT7e6OPB1xro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bx90Q4aWPnbENP8tyIM2uOM5GguydPpn927hPUkiOeFNIILGGr7J4PvmteJyMZp5Ru7Y6GzThPLbhBmjPf8uRGYdPtSNNAkgtamtlilQOdhuTtKFMr9Wem0OJ+qRwi5XrN6SNRJIMAgvewFn8whkrwRKqHzr3YonlMDCVIQVF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YR5yWsvi; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744077638; x=1775613638;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OCilHNMl6KOjdWUU2fEWt3Z/3p/1AspDT7e6OPB1xro=;
  b=YR5yWsviDCxtpY8zcoYLvHkFUC1GtmZdfwxwPKGQv1rKJor4i+fD/csl
   62//gJTcADvq1afjS+JykaYoiNGTUsdzXcgNe8x+iyhsbbeFVfTQcO8xe
   eabplTrqr5Qqn/03EMVugS5jO+fwmxp6PMTX5OMBZO6SuxEQLNlXGx7rA
   Lade8Jd7MYQPvEWiqVEbVBDXftwhLTdRObbyR6lc9lwV1IDXcwL3jJ/rQ
   lsuB1XE8ARVVtPKgXqaUlJlSzs522fAL5LeFdLrJvuSCgAOfFiQ16c5iP
   Dto474LmxRlRKS2h9hxAXQmRc+9X4gCz6eYPEhQEg1UK0gGwWgi+3ihof
   Q==;
X-CSE-ConnectionGUID: wcXEgFXYRbuYc1HYN1MOZA==
X-CSE-MsgGUID: lzB9BwxVQMe1gP/AZ7pW/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45390912"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="45390912"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 19:00:38 -0700
X-CSE-ConnectionGUID: W5SHVA7bTiCl3k268kurqw==
X-CSE-MsgGUID: Bv9tb3WlSt2LIuUOAZ6+9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="128455440"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 19:00:31 -0700
Message-ID: <f1b0c905-3804-4c34-bc17-e437a8ae86d6@intel.com>
Date: Tue, 8 Apr 2025 10:00:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com> <Zv7dtghi20DZ9ozz@redhat.com>
 <0e15f14b-cd63-4ec4-8232-a5c0a96ba31d@intel.com>
 <Z-1cm6cEwNGs9NEu@redhat.com>
 <a3a8ed8d-9994-42c9-ba3b-ef59d6977ce6@intel.com>
 <Z-5Ces2kGrB67aPw@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z-5Ces2kGrB67aPw@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/3/2025 4:10 PM, Daniel P. Berrangé wrote:
> On Thu, Apr 03, 2025 at 03:28:43PM +0800, Xiaoyao Li wrote:
>> On 4/2/2025 11:49 PM, Daniel P. Berrangé wrote:
>>> On Wed, Apr 02, 2025 at 11:26:11PM +0800, Xiaoyao Li wrote:
>>>>
>>>> I guess the raw mode was introduced due to the design was changed to let
>>>> guest kernel to forward to TD report to host QGS via TDVMCALL instead of
>>>> guest application communicates with host QGS via vsock, and Linux TD guest
>>>> driver doesn't integrate any QGS protocol but just forward the raw TD report
>>>> data to KVM.
>>>>
>>>>> IMHO, QEMU should be made to pack & unpack the TDX report from
>>>>> the guest into the GET_QUOTE_REQ / GET_QUOTE_RESP messages, and
>>>>> this "raw" mode should be removed to QGS as it is inherantly
>>>>> dangerous to have this magic protocol overloading.
>>>>
>>>> There is no enforcement that the input data of TDVMCALL.GetQuote is the raw
>>>> data of TD report. It is just the current Linux tdx-guest driver of tsm
>>>> implementation send the raw data. For other TDX OS, or third-party driver,
>>>> they might encapsulate the raw TD report data with QGS message header. For
>>>> such cases, if QEMU adds another layer of package, it leads to the wrong
>>>> result.
>>>
>>> If I look at the GHCI spec
>>>
>>>     https://cdrdv2-public.intel.com/726790/TDX%20Guest-Hypervisor%20Communication%20Interface_1.0_344426_006%20-%2020230311.pdf
>>>
>>> In "3.3 TDG.VP.VMCALL<GetQuote>", it indicates the parameter is a
>>> "TDREPORT_STRUCT". IOW, it doesn't look valid to allow the guest to
>>> send arbitrary other data as QGS protocol messages.
>>
>> In table 3-7, the description of R12 is
>>
>>    Shared GPA as input - the memory contains a TDREPORT_STRUCT.
>>    The same buffer is used as output - the memory contains a TD Quote.
>>
>> table 3-10, describes the detailed format of the shared GPA:
>>
>> starting from offset 24 bytes, it is the "Data"
>>
>>    On input, the data filled by TD with input length. The data should
>>    include TDREPORT_STRUCT. TD should zeroize the remaining buffer to
>>    avoid information leak if size of shared GPA (R13) > Input Length.
>>
>> It uses the word "contains" and "include", but without "only". So it is not
>> clear to me.
>>
>> I will work with internal attestation folks to make it clearer that who (TD
>> guest or host VMM) is responsible to encapsulate the raw TDERPORT_STRCUT
>> with QGS MSG protocol, and update the spec accordingly.
> 
> To be clear, my strong preference is that the spec be updated to only
> permit the raw TDREPORT_STRUCT.
> 
> IMHO allowing arbitrary QGS MSGs would be a significant host security
> weakness, as it exposes a huge amount of the QGS codebase to direct
> attack from the guest.

If I remember correctly, the QGS instance keeps the vsock interface so 
that TD guest can communicate with QGS directly without going through 
host VMM. (I'm not sure if latest QGS implementation still keeps it.)
So QGS should know how to protect itself.

Regarding QEMU avoids from being exploited to forward arbitrary data 
from malicious TDX guest to QGS, QEMU can check the beginning of the 
data to be a valid QGS MSG header before handing it over to QGS socket.

> QEMU needs to be able to block that attack
> vector. Without that, the benefit/value of shuffling of TDREPORTs via
> the GetQuote hypercall is largely eliminated, and might as well have
> just exposed QGS over VSOCK.

If I remember correctly, one of the reason we changed from TD guest 
communicates with QGS directly with vsock to current TDVMCALL(GETQUOTE), 
is some of the TD guest environment might not have network stack for 
vsock to work.

Anyway, I don't have preference. Either is OK to me. Let's see what 
decision the attestation folks will make.

> With regards,
> Daniel


