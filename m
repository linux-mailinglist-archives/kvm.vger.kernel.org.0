Return-Path: <kvm+bounces-3291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB9A802C22
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07C7F1C2033E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 07:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BB6C15D;
	Mon,  4 Dec 2023 07:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bFxw9oGH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63424127
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 23:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701675331; x=1733211331;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cqnx3GOOOeEnGFwr2YUHohM2BY2Tg7uefwELeHw0OWY=;
  b=bFxw9oGHgmC/JWZ1AGvFx0rF9EEbAeeb1vjQeImv43nsfi10f6ngcMCM
   vbD6cMHQJXgMjPRYzBm+7P/TEEySuIDf3DW/Zxbpa1raYoDFBPn+RCIwg
   T46HrYWkQN7Q5J9V8fVgfXE/e0tPk0NiynUK+RN/HUVTOf8MFpDdfUHcH
   TOFlpUmrhCSLMZJPRad/zNtMMOLScf6UPKe1XhHddOjja/6RwrBgVAG/K
   S9QgSi6PhSs2N79m0siNVPMbisI71GPX3fEcfjrWv9edqlRpbpMOXdEUy
   yZEYbYXR9P1+8g5mrB9bMkUJdBtpwn+GE2sj8Aswo6AZmyBupbAEoacXr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="424860784"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="424860784"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 23:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="893916998"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="893916998"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 23:35:24 -0800
Message-ID: <4fe173c9-6be2-4850-a5a4-d2b9299278f9@intel.com>
Date: Mon, 4 Dec 2023 15:35:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/70] physmem: Relax the alignment check of
 host_startaddr in ram_block_discard_range()
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
 <20231115071519.2864957-8-xiaoyao.li@intel.com>
 <a61206eb-03c4-41e3-a876-bb67577e5204@redhat.com>
 <00b533ee-fbb1-4e78-bc8b-b6d87761bb92@intel.com>
 <419ffc61-fcd7-4940-a550-9ce6c6a14e1b@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <419ffc61-fcd7-4940-a550-9ce6c6a14e1b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/20/2023 5:56 PM, David Hildenbrand wrote:
> On 16.11.23 03:56, Xiaoyao Li wrote:
>> On 11/16/2023 2:20 AM, David Hildenbrand wrote:
>>> On 15.11.23 08:14, Xiaoyao Li wrote:
>>>> Commit d3a5038c461 ("exec: ram_block_discard_range") introduced
>>>> ram_block_discard_range() which grabs some code from
>>>> ram_discard_range(). However, during code movement, it changed 
>>>> alignment
>>>> check of host_startaddr from qemu_host_page_size to rb->page_size.
>>>>
>>>> When ramblock is back'ed by hugepage, it requires the startaddr to be
>>>> huge page size aligned, which is a overkill. e.g., TDX's private-shared
>>>> page conversion is done at 4KB granularity. Shared page is discarded
>>>> when it gets converts to private and when shared page back'ed by
>>>> hugepage it is going to fail on this check.
>>>>
>>>> So change to alignment check back to qemu_host_page_size.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>> Changes in v3:
>>>>    - Newly added in v3;
>>>> ---
>>>>    system/physmem.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index c56b17e44df6..8a4e42c7cf60 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -3532,7 +3532,7 @@ int ram_block_discard_range(RAMBlock *rb,
>>>> uint64_t start, size_t length)
>>>>        uint8_t *host_startaddr = rb->host + start;
>>>> -    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
>>>> +    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, qemu_host_page_size)) {
>>>
>>> For your use cases, rb->page_size should always match 
>>> qemu_host_page_size.
>>>
>>> IIRC, we only set rb->page_size to different values for hugetlb. And
>>> guest_memfd does not support hugetlb.
>>>
>>> Even if QEMU is using THP, rb->page_size should 4k.
>>>
>>> Please elaborate how you can actually trigger that. From what I recall,
>>> guest_memfd is not compatible with hugetlb.
>>
>> It's the shared memory that can be back'ed by hugetlb.
> 
> Serious question: does that configuration make any sense to support at 
> this point? I claim: no.
> 
>>
>> Later patch 9 introduces ram_block_convert_page(), which will discard
>> shared memory when it gets converted to private. TD guest can request
>> convert a 4K to private while the page is previously back'ed by hugetlb
>> as 2M shared page.
> 
> So you can call ram_block_discard_guest_memfd_range() on subpage basis, 
> but not ram_block_discard_range().
> 
> ram_block_convert_range() would have to thought that that (questionable) 
> combination of hugetlb for shmem and ordinary pages for guest_memfd 
> cannot discard shared memory.
> 
> And it probably shouldn't either way. There are other problems when not 
> using hugetlb along with preallocation.

If I understand correctly, preallocation needs to be enabled for 
hugetlb. And in preallocation case, it doesn't need to discard memory. 
Is it correct?

> The check in ram_block_discard_range() is correct, whoever ends up 
> calling it has to stop calling it.
> 

So, I need add logic to ram_block_discard_page() that if the size of 
shared memory indicates hugepage, skip the discarding?


