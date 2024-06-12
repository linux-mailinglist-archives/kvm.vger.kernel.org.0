Return-Path: <kvm+bounces-19420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF73904E25
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A03BDB24D13
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 08:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB32F16D30F;
	Wed, 12 Jun 2024 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="elcgWg1b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8954D7404F
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718180946; cv=none; b=JbAWTgjeKSHMqMSt4KlP/czm1+mCgGTiSpvO/XhAnw7aNXqPt0zhgmKUN3uiS8+GrWaXXfjux64D7RBW3M6L9+zObSAN3Jp/0LgF9zaX+Ef6QRDRn/hVK41ZGcNgJUZ3HAleT1POcqRs5tuOHkzmNax6qfOIYkaUcLlcNRDxKRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718180946; c=relaxed/simple;
	bh=tnsFj3xarSZjBfOEha/shi7k/q3DMKKZs+BnOozwJmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J5kT3yoSTF1um8sPnnHRLDuMM89atemTeZB4WOcLlYdSh2i2koRqSkmdyGjpARMTzXalfBnCFJdG+/5n0zCG326bI06h3UDmqWVVEGXxdcf46DeqKFUTRkFmzjduZf5MhoC0cbFOMw+CnytMReSiFyHwTwByGjPJew+g1t7MLvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=elcgWg1b; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718180945; x=1749716945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tnsFj3xarSZjBfOEha/shi7k/q3DMKKZs+BnOozwJmE=;
  b=elcgWg1bvhPUF8KLqCgKHGxtfogbGTrdWX4hoF5DQkLaZN8a/1NW2FS/
   j5FWAcps88P/lACBHJgYDIKcB/8IgVWrR6FSJqvik205tz9Ec1h5ejkMo
   C5sFEAUjEohVognSwcTBTdzMl9RHldHOVMPtcZYCTDxeqOtE/BH7FNI/w
   kx8HcIarfpcdn1gg9SH5naN/6eVGZTUwDbLWM8W3cPDJffWw5H1KoNAJP
   rHzXAgqIOrBu8sD1TFWk/blQRRvpS7hFXhkoQJfEMG3ut4DenuROaZWGl
   DoOc1cv1bUFH2hfcguqKkQSGyla4QmCRY33ETECIL4FQDLUCHz2haUxDc
   Q==;
X-CSE-ConnectionGUID: VKOxykXtRXWDo7lwIcLHZA==
X-CSE-MsgGUID: 5tWMAW1OTTuD3+OOZ+WHvg==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="18710855"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="18710855"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 01:29:04 -0700
X-CSE-ConnectionGUID: jlcWsIirR0mR+ipt3FugoA==
X-CSE-MsgGUID: EcTQyWlRTViFDHpV1SIrNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="40183566"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 01:28:57 -0700
Message-ID: <90739246-f008-4cf2-bcf5-8a243e2b13d4@intel.com>
Date: Wed, 12 Jun 2024 16:28:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/65] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
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
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-26-xiaoyao.li@intel.com> <ZmGTXP36B76IRalJ@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZmGTXP36B76IRalJ@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/6/2024 6:45 PM, Daniel P. Berrangé wrote:
> Copying  Zhenzhong Duan as my point relates to the proposed libvirt
> TDX patches.
> 
> On Thu, Feb 29, 2024 at 01:36:46AM -0500, Xiaoyao Li wrote:
>> Bit 28 of TD attribute, named SEPT_VE_DISABLE. When set to 1, it disables
>> EPT violation conversion to #VE on guest TD access of PENDING pages.
>>
>> Some guest OS (e.g., Linux TD guest) may require this bit as 1.
>> Otherwise refuse to boot.
>>
>> Add sept-ve-disable property for tdx-guest object, for user to configure
>> this bit.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> Acked-by: Markus Armbruster <armbru@redhat.com>
>> ---
>> Changes in v4:
>> - collect Acked-by from Markus
>>
>> Changes in v3:
>> - update the comment of property @sept-ve-disable to make it more
>>    descriptive and use new format. (Daniel and Markus)
>> ---
>>   qapi/qom.json         |  7 ++++++-
>>   target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>>   2 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 220cc6c98d4b..89ed89b9b46e 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -900,10 +900,15 @@
>>   #
>>   # Properties for tdx-guest objects.
>>   #
>> +# @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
>> +#     of EPT violation conversion to #VE on guest TD access of PENDING
>> +#     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>> +#     be set, otherwise they refuse to boot.
>> +#
>>   # Since: 9.0
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>> -  'data': { }}
>> +  'data': { '*sept-ve-disable': 'bool' } }
> 
> So this exposes a single boolean property that gets mapped into one
> specific bit in the TD attributes:
> 
>> +
>> +static void tdx_guest_set_sept_ve_disable(Object *obj, bool value, Error **errp)
>> +{
>> +    TdxGuest *tdx = TDX_GUEST(obj);
>> +
>> +    if (value) {
>> +        tdx->attributes |= TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
>> +    } else {
>> +        tdx->attributes &= ~TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
>> +    }
>> +}
> 
> If I look at the documentation for TD attributes
> 
>    https://download.01.org/intel-sgx/latest/dcap-latest/linux/docs/Intel_TDX_DCAP_Quoting_Library_API.pdf
> 
> Section "A.3.4. TD Attributes"
> 
> I see "TD attributes" is a 64-bit int, with 5 bits currently
> defined "DEBUG", "SEPT_VE_DISABLE", "PKS", "PL", "PERFMON",
> and the rest currently reserved for future use. This makes me
> wonder about our modelling approach into the future ?
> 
> For the AMD SEV equivalent we've just directly exposed the whole
> field as an int:
> 
>       'policy' : 'uint32',
> 
> For the proposed SEV-SNP patches, the same has been done again
> 
> https://lists.nongnu.org/archive/html/qemu-devel/2024-06/msg00536.html
> 
>       '*policy': 'uint64',
> 
> 
> The advantage of exposing individual booleans is that it is
> self-documenting at the QAPI level, but the disadvantage is
> that every time we want to expose ability to control a new
> bit in the policy we have to modify QEMU, libvirt, the mgmt
> app above libvirt, and whatever tools the end user has to
> talk to the mgmt app.
> 
> If we expose a policy int, then newly defined bits only require
> a change in QEMU, and everything above QEMU will already be
> capable of setting it.
> 
> In fact if I look at the proposed libvirt patches, they have
> proposed just exposing a policy "int" field in the XML, which
> then has to be unpacked to set the individual QAPI booleans
> 
>    https://lists.libvirt.org/archives/list/devel@lists.libvirt.org/message/WXWXEESYUA77DP7YIBP55T2OPSVKV5QW/
> 
> On balance, I think it would be better if QEMU just exposed
> the raw TD attributes policy as an uint64 at QAPI, instead
> of trying to unpack it to discrete bool fields. This gives
> consistency with SEV and SEV-SNP, and with what's proposed
> at the libvirt level, and minimizes future changes when
> more policy bits are defined.

The reasons why introducing individual bit of sept-ve-disable instead of 
a raw TD attribute as a whole are that

1. other bits like perfmon, PKS, KL are associated with cpu properties, 
e.g.,

	perfmon -> pmu,
	pks -> pks,
	kl -> keylokcer feature that QEMU currently doesn't support

If allowing configuring attribute directly, we need to deal with the 
inconsistence between attribute vs cpu property.

2. people need to know the exact bit position of each attribute. I don't 
think it is a user-friendly interface to require user to be aware of 
such details.

For example, if user wants to create a Debug TD, user just needs to set 
'debug=on' for tdx-guest object. It's much more friendly than that user 
needs to set the bit 0 of the attribute.


>> +
>>   /* tdx guest */
>>   OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
>>                                      tdx_guest,
>> @@ -529,6 +549,10 @@ static void tdx_guest_init(Object *obj)
>>       qemu_mutex_init(&tdx->lock);
>>   
>>       tdx->attributes = 0;
>> +
>> +    object_property_add_bool(obj, "sept-ve-disable",
>> +                             tdx_guest_get_sept_ve_disable,
>> +                             tdx_guest_set_sept_ve_disable);
>>   }
>>   
>>   static void tdx_guest_finalize(Object *obj)
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel


