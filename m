Return-Path: <kvm+bounces-1861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4B77ED9BC
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9EBE1F236AA
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C4A63B5;
	Thu, 16 Nov 2023 02:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JxpXSeem"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F14119E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 18:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700102865; x=1731638865;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=raAjj+ppcl8HOoyTjPoDhf0qhLozPZCCDn35FT/+JrU=;
  b=JxpXSeemD1EM2MKtot1KC91pOBuvPWEwfV+ASvn0ept/+Xt73unyqlla
   fWSj372NHR+mrk/0ajc2liJbHGzNL48UT/wINZxgl4hfLA+89olrQyp7Y
   WD8ANR9L9t+HC+87YyU3Ubhf470nzgp3M9+QjVbCZwIr0ZQYIqMyKtaFe
   tOo3UoQ//miaUVnf4WAXk6Qs5LAJwbRsE37+1elf6Ki4H4RYHhmsHMKRY
   PgK2rw9hQLXzJea/fo32TGwUDlvUW66BE2IleBCTpxDQX1YKbNxfJ8zKt
   aCnj5TwR0ON7E6tW+r0z4WoUFTtjBjVxtnclDbJpq0TwLdoSN1lptzk62
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="388165701"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="388165701"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="715062974"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="715062974"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:47:38 -0800
Message-ID: <05f0e440-36a2-4d3a-8caa-842b34e50dce@intel.com>
Date: Thu, 16 Nov 2023 10:47:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
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
 <20231115071519.2864957-4-xiaoyao.li@intel.com>
 <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/16/2023 2:10 AM, David Hildenbrand wrote:
> On 15.11.23 08:14, Xiaoyao Li wrote:
>> KVM allows KVM_GUEST_MEMFD_ALLOW_HUGEPAGE for guest memfd. When the
>> flag is set, KVM tries to allocate memory with transparent hugeapge at
>> first and falls back to non-hugepage on failure.
>>
>> However, KVM defines one restriction that size must be hugepage size
>> aligned when KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is set.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> v3:
>>   - New one in v3.
>> ---
>>   system/physmem.c | 38 ++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 0af2213cbd9c..c56b17e44df6 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1803,6 +1803,40 @@ static void dirty_memory_extend(ram_addr_t 
>> old_ram_size,
>>       }
>>   }
>> +#ifdef CONFIG_KVM
>> +#define HPAGE_PMD_SIZE_PATH 
>> "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
>> +#define DEFAULT_PMD_SIZE (1ul << 21)
>> +
>> +static uint32_t get_thp_size(void)
>> +{
>> +    gchar *content = NULL;
>> +    const char *endptr;
>> +    static uint64_t thp_size = 0;
>> +    uint64_t tmp;
>> +
>> +    if (thp_size != 0) {
>> +        return thp_size;
>> +    }
>> +
>> +    if (g_file_get_contents(HPAGE_PMD_SIZE_PATH, &content, NULL, 
>> NULL) &&
>> +        !qemu_strtou64(content, &endptr, 0, &tmp) &&
>> +        (!endptr || *endptr == '\n')) {
>> +        /* Sanity-check the value and fallback to something 
>> reasonable. */
>> +        if (!tmp || !is_power_of_2(tmp)) {
>> +            warn_report("Read unsupported THP size: %" PRIx64, tmp);
>> +        } else {
>> +            thp_size = tmp;
>> +        }
>> +    }
>> +
>> +    if (!thp_size) {
>> +        thp_size = DEFAULT_PMD_SIZE;
>> +    }
> 
> ... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)

Get caught.

> This should be factored out into a common helper.

Sure, will do it in next version.


