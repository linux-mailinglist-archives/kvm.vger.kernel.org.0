Return-Path: <kvm+bounces-4978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9B881AEA8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 07:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 691362858FB
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 06:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34232C12B;
	Thu, 21 Dec 2023 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8dw3F0D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC87EBE4D
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 06:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703139080; x=1734675080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2hA/xn0NG+gy8teTCJK54dPh/Y6wZ10nR1+JUI9HKeE=;
  b=n8dw3F0DkZDDBIQB5bZhQTUnVL9C9deztL+o/wwq+HDEGJr2XugHb94e
   LtahrcRHusS43WCr/0X2IBmzU0lXUyWUeL7mXvJrXiQMYWRCQVGtXe8XD
   y5ws2DMoywZ070BpXULEmAntdpvv0+JNtlK2Pslt3ANUIlLMGmm5J/WkY
   j85Wlzr/Bs9ER1T2G00tk4CmHFPEzcUaVKZtU0sIngsKDUbkGxtJWTEsH
   DRev9SoSZ55zF1rwaI9B0ZDqU0VLNzr6gt+6Emmr0Sg+EoAgb5dcAGffc
   FoP2AELP+iUCnta45UHIDxdDFZ6lgGlN9dNMqat3dnKxQ7jM5lfUewc7M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="399756792"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="399756792"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 22:11:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="1023747379"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="1023747379"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 22:11:12 -0800
Message-ID: <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
Date: Thu, 21 Dec 2023 14:11:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Content-Language: en-US
To: "Wang, Wei W" <wei.w.wang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, "Qiang, Chenyi" <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
 <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/2023 9:56 PM, Wang, Wei W wrote:
> On Wednesday, November 15, 2023 3:14 PM, Xiaoyao Li wrote:
>> Introduce the helper functions to set the attributes of a range of memory to
>> private or shared.
>>
>> This is necessary to notify KVM the private/shared attribute of each gpa range.
>> KVM needs the information to decide the GPA needs to be mapped at hva-
>> based shared memory or guest_memfd based private memory.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   include/sysemu/kvm.h |  3 +++
>>   2 files changed, 45 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
>> 69afeb47c9c0..76e2404d54d2 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -102,6 +102,7 @@ bool kvm_has_guest_debug;  static int kvm_sstep_flags;
>> static bool kvm_immediate_exit;  static bool kvm_guest_memfd_supported;
>> +static uint64_t kvm_supported_memory_attributes;
>>   static hwaddr kvm_max_slot_size = ~0;
>>
>>   static const KVMCapabilityInfo kvm_required_capabilites[] = { @@ -1305,6
>> +1306,44 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
>>       kvm_max_slot_size = max_slot_size;
>>   }
>>
>> +static int kvm_set_memory_attributes(hwaddr start, hwaddr size,
>> +uint64_t attr) {
>> +    struct kvm_memory_attributes attrs;
>> +    int r;
>> +
>> +    attrs.attributes = attr;
>> +    attrs.address = start;
>> +    attrs.size = size;
>> +    attrs.flags = 0;
>> +
>> +    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
>> +    if (r) {
>> +        warn_report("%s: failed to set memory (0x%lx+%#zx) with attr 0x%lx
>> error '%s'",
>> +                     __func__, start, size, attr, strerror(errno));
>> +    }
>> +    return r;
>> +}
>> +
>> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size) {
>> +    if (!(kvm_supported_memory_attributes &
>> KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>> +        error_report("KVM doesn't support PRIVATE memory attribute\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    return kvm_set_memory_attributes(start, size,
>> +KVM_MEMORY_ATTRIBUTE_PRIVATE); }
>> +
>> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size) {
>> +    if (!(kvm_supported_memory_attributes &
>> KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>> +        error_report("KVM doesn't support PRIVATE memory attribute\n");
>> +        return -EINVAL;
>> +    }
> 
> Duplicate code in kvm_set_memory_attributes_shared/private.
> Why not move the check into kvm_set_memory_attributes?

Because it's not easy to put the check into there.

Both setting and clearing one bit require the capability check. If 
moving the check into kvm_set_memory_attributes(), the check of 
KVM_MEMORY_ATTRIBUTE_PRIVATE will have to become unconditionally, which 
is not aligned to the function name because the name is not restricted 
to shared/private attribute only.

