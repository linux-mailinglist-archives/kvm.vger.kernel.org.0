Return-Path: <kvm+bounces-2852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BA67FE9D4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9912282095
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 07:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872C120DC1;
	Thu, 30 Nov 2023 07:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfAKjOlK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE80196
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 23:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701329925; x=1732865925;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=30O8Y+FFJR4EB1sJ9gV1RfLIWaUgdgccOeSvL7lYnNI=;
  b=VfAKjOlKzSXdEKIm6N4Lp5LYJHDPOgboQ1aVMoyVWxQaDZgqjrYIkzRd
   XC8/E/5sFGGiDkx3+TXjuzhQefiiD35L1DjsqOa9EvxMWS/sWzX3kYhyL
   Gib3E0xYFyseVBmImX4ydNvBsR4he20MsypMlRspDMqgDn4Z4ebtSxHec
   gS7ei27fwS7u8oXQ9stdfw1hzUkjWDaq2OfYhLdwMg46Q8faJULEQWSAa
   NhOO5oOY3ad0bRBx9cVtGZRvuLIqUXJMB9xs0iP9cvIpXhN5WtixC416n
   OfVA93/CqCOYTAZvzSruaollbA8Q07yoxAuyKkBIWDOI4pXPEeGd0YoKp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="424432650"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="424432650"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:38:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="798195968"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="798195968"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:38:38 -0800
Message-ID: <c2b09acf-9f7f-44be-837c-cb9c57368f1b@intel.com>
Date: Thu, 30 Nov 2023 15:38:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/70] HostMem: Add mechanism to opt in kvm guest memfd
 via MachineState
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-5-xiaoyao.li@intel.com>
 <af2a5b80-f259-45b1-9d92-812e3c4bc06c@redhat.com>
 <6674dc2c-f1ed-496e-bc17-256869bdeae9@intel.com>
 <0ca6a665-ce88-4c81-927d-6e94a249949d@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <0ca6a665-ce88-4c81-927d-6e94a249949d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/2023 5:30 PM, David Hildenbrand wrote:
> On 16.11.23 03:53, Xiaoyao Li wrote:
>> On 11/16/2023 2:14 AM, David Hildenbrand wrote:
>>> On 15.11.23 08:14, Xiaoyao Li wrote:
>>>> Add a new member "require_guest_memfd" to memory backends. When it's 
>>>> set
>>>> to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
>>>> guest_memfd will be allocated during RAMBlock allocation.
>>>>
>>>> Memory backend's @require_guest_memfd is wired with 
>>>> @require_guest_memfd
>>>> field of MachineState. MachineState::require_guest_memfd is supposed to
>>>> be set by any VMs that requires KVM guest memfd as private memory, 
>>>> e.g.,
>>>> TDX VM.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> I'm confused, why do we need this if it's going to be the same for all
>>> memory backends right now?
>>>
>>
>> I want to provide a elegant (in my sense) way to configure "the need of
>> guest memfd" instead of checking x86machinestate->vm_type in physmem.c
>>
> 
> It's suboptimal right now, but I guess you want to avoid looking up the 
> machine e.g., in ram_backend_memory_alloc().
> 
> I'd suggest s/require_guest_memfd/guest_memfd/gc in "struct 
> HostMemoryBackend".

sure!

> Apart from that LGTM.
> 


