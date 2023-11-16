Return-Path: <kvm+bounces-1864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E8C7ED9CD
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 388F0281037
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAE779F2;
	Thu, 16 Nov 2023 02:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJnikotC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443B398
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 18:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700103411; x=1731639411;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zahvDV8ljj6cLCtFfmlAWUV43SQBtyl+ufuho/AJOds=;
  b=RJnikotC86bJs5leaUXKRcNiYsyZ5MwKCGcuy8tvFDX/4rK3esmySC+p
   wM1vJ1wbS5nFpDAPXxDow5LX4ZK1S/yPPKLsIIdP5lnc+lXByctLClgUh
   bLZmb8K90dMeD3Gkrve1Wbb3ivfCW2LtI0s7tvJ0k3v+cX1Pk+dH5vpXo
   LTWkNhXpRdUxhYzjUwz08Qzqp2qu6v/O5ICxB/fh5niU7gaEdiTEILeC2
   qBUBPOzZZYACEAfcYQRWDTqtWtVG21kxJm4SIHc2XM/0UjZX6I8Ot3G0o
   h0cuB8Icc2n/A7bdDD/YSNo0ZbyK//qf7BOpS0HtJ5wBqAZYEtP3ehQu3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="457496195"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="457496195"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:56:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="888770880"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="888770880"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:56:45 -0800
Message-ID: <00b533ee-fbb1-4e78-bc8b-b6d87761bb92@intel.com>
Date: Thu, 16 Nov 2023 10:56:42 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <a61206eb-03c4-41e3-a876-bb67577e5204@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/16/2023 2:20 AM, David Hildenbrand wrote:
> On 15.11.23 08:14, Xiaoyao Li wrote:
>> Commit d3a5038c461 ("exec: ram_block_discard_range") introduced
>> ram_block_discard_range() which grabs some code from
>> ram_discard_range(). However, during code movement, it changed alignment
>> check of host_startaddr from qemu_host_page_size to rb->page_size.
>>
>> When ramblock is back'ed by hugepage, it requires the startaddr to be
>> huge page size aligned, which is a overkill. e.g., TDX's private-shared
>> page conversion is done at 4KB granularity. Shared page is discarded
>> when it gets converts to private and when shared page back'ed by
>> hugepage it is going to fail on this check.
>>
>> So change to alignment check back to qemu_host_page_size.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v3:
>>   - Newly added in v3;
>> ---
>>   system/physmem.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index c56b17e44df6..8a4e42c7cf60 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -3532,7 +3532,7 @@ int ram_block_discard_range(RAMBlock *rb, 
>> uint64_t start, size_t length)
>>       uint8_t *host_startaddr = rb->host + start;
>> -    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
>> +    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, qemu_host_page_size)) {
> 
> For your use cases, rb->page_size should always match qemu_host_page_size.
> 
> IIRC, we only set rb->page_size to different values for hugetlb. And 
> guest_memfd does not support hugetlb.
> 
> Even if QEMU is using THP, rb->page_size should 4k.
> 
> Please elaborate how you can actually trigger that. From what I recall, 
> guest_memfd is not compatible with hugetlb.

It's the shared memory that can be back'ed by hugetlb.

Later patch 9 introduces ram_block_convert_page(), which will discard 
shared memory when it gets converted to private. TD guest can request 
convert a 4K to private while the page is previously back'ed by hugetlb 
as 2M shared page.

> And the check here makes perfect sense for existing callers of 
> ram_block_discard_range(): you cannot partially zap a hugetlb page.
> 


