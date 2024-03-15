Return-Path: <kvm+bounces-11897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0C187CA19
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F6ED283BF4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 08:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D8117579;
	Fri, 15 Mar 2024 08:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVve5qvg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92BE14008
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710492118; cv=none; b=TMKFkg/6CpiCBjft8xMHuh4FWh55XYIHfaLvt9dOuqq57C29RMmzG5lSx5i03P0CiVBA8xgMaKSTi+y7ytxRTW+5SbnuB32cX8gylAIG9TnjCSVXnh+bWZctizRVIkhlhArbeLVom0RoceDbIEZL2/rPfPLM+T7D6BpBuZHQObs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710492118; c=relaxed/simple;
	bh=BYZszatMuj1dV4ezUXHmmsX3KR1L4424PjD+Q8n/3kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r+cSSUTpg+wJGRUlPdarp6dr6JyZa3xSLFmMC1B9cL4zLlj5nrzOnrQq1wsutiiZ/NSAV471XIVVkRVVHSd6CwGLJCBOSqY1Q5Ta6l9tlweuqIkRMtKIP7mPZa0rYU4zVmVGhH4PmzfyAM0xBZThybbEfiTW+gyvw+qiTNFfJ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVve5qvg; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710492116; x=1742028116;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BYZszatMuj1dV4ezUXHmmsX3KR1L4424PjD+Q8n/3kc=;
  b=QVve5qvg51mHscICqaH/srmUmX6UQ6ShQK7CKRbjBuUb7/LL7V9Acv0o
   F2fefN0JnfHnAGch6MvFZ4taYvxP05vw8hG4405LzTKgrGZc1p5alOuBh
   kzfJEF9cNtBABpWeGh3i3H6x6r8jDP9uVkG8Lka/NOJuuxxOfQ4RclTzR
   cD0Jr/JBlxiSr2swxOhHLirr6Ye1Htw/8NBENuG51kdtngOVx3v45hLlm
   p4o0U+A6cgLGCPb3/QJQC/ULsZ/dcJgyd8kIkf2gcGAdedNqPS7B4dO3k
   D1/CY8Mi2RDQsxudL0epgGJbcM/nhqWQj0ZxtvIgWKm8pSRhmH4onACQn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="15900035"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="15900035"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 01:41:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="13005450"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 01:41:50 -0700
Message-ID: <b23d6983-27f2-4e1d-b13e-1bdfda97cc56@intel.com>
Date: Fri, 15 Mar 2024 16:41:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Content-Language: en-US
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
 <20240229063726.610065-50-xiaoyao.li@intel.com> <Ze7Ojzty99AbShE3@redhat.com>
 <0f5e1559-bd65-4f3b-bd7a-b166f53dce38@intel.com>
 <ZfHG2DHqf_cnq5tk@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZfHG2DHqf_cnq5tk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/13/2024 11:31 PM, Daniel P. Berrangé wrote:
> On Tue, Mar 12, 2024 at 03:44:32PM +0800, Xiaoyao Li wrote:
>> On 3/11/2024 5:27 PM, Daniel P. Berrangé wrote:
>>> On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Add property "quote-generation-socket" to tdx-guest, which is a property
>>>> of type SocketAddress to specify Quote Generation Service(QGS).
>>>>
>>>> On request of GetQuote, it connects to the QGS socket, read request
>>>> data from shared guest memory, send the request data to the QGS,
>>>> and store the response into shared guest memory, at last notify
>>>> TD guest by interrupt.
>>>>
>>>> command line example:
>>>>     qemu-system-x86_64 \
>>>>       -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>>
>>> Can you illustrate this with 'unix' sockets, not 'vsock'.
>>
>> Are you suggesting only updating the commit message to an example of unix
>> socket? Or you want the code to test with some unix socket QGS?
>>
>> (It seems the QGS I got for testing, only supports vsock socket. Because at
>> the time when it got developed, it was supposed to communicate with drivers
>> inside TD guest directly not via VMM (KVM+QEMU). Anyway, I will talk to
>> internal folks to see if any plan to support unix socket.)
> 
> The QGS provided as part of DCAP supports running with both
> UNIX sockets and VSOCK, and I would expect QEMU to be made
> to work with this, since its is Intel's OSS reference impl.

After synced with internal folks, yes, the QGS I used does support unix 
socket. I tested it and it worked.

-object 
'{"qom-type":"tdx-guest","id":"tdx","quote-generation-socket":{"type":"unix", 
"path":"/var/run/tdx-qgs/qgs.socket"}}'

> Exposing QGS to the guest when we only intend for it to be
> used by the host QEMU is needlessly expanding the attack
> surface.
> 
> With regards,
> Daniel


