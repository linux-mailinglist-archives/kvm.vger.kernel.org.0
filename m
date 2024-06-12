Return-Path: <kvm+bounces-19427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 848A9904F28
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3154C286C2C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDD616D9DA;
	Wed, 12 Jun 2024 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LwAbxx58"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F306CA34
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718184259; cv=none; b=JQwT4w8ac2bjWMTKNxF6CzhXFgup2bZudCnY3u/QV98DWGh7cMSXZUihgOpyRkq3Zx9OG1SWZM/NzsX8cUIXVueLPn7haCeGVTbApAtXMVmDRlDI+Bqupzp5P3XNYqo/eL2ZFVhckS04g2ZEA+Bj2toJ466zLxezLViFjz9UeEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718184259; c=relaxed/simple;
	bh=ytPB7o3sNt3WkmYesD0N7871LrdUiavykFcGUZgCd3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cVz6vT4hOjzMdG6hBqkI/eCsVFXl1GHvfc4GIxkhoWjCY99y52WOgxt4gBLOxedUIPoTpFiE1CtSyFSwl3FGi0tvtBdz7kMs6x2JlHOMuqxx0pj0lnacXeaHExx8FYSaSi3eXUar5EUYwplAkIm+tpWocTJtWtEumUmzDXb1r5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LwAbxx58; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718184258; x=1749720258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ytPB7o3sNt3WkmYesD0N7871LrdUiavykFcGUZgCd3s=;
  b=LwAbxx58BVRv149Y/7ebD1qaO9eLGAzu5cmRKCK90tKsMad2U+sdYT4z
   W0cm+NqpkIq88D1yRGhF7R0f6Vez1IDtqWXH9FY4hY8M1NwFe1ZfYKkom
   8DBI3nqwTExARrcRzD+xeSqaxecIjAlenEsVTfSfw5S1+83XZnY7bQb2v
   63gHG+NE9MTWuZZFwV1+Lj8kjQnWXSHyFA20Tq/sEGi533eZSK/Cr/yFO
   +u3cxJMW2NnaxlyLb76doOkqaOsVpYycRZV4X9xU96oAMI34uBBUWc5EX
   P7P7QUbNLd0HTqP90jJ89sRuQx7JdvuVHxkEVb6Ugr/545xF1NhZRDimE
   A==;
X-CSE-ConnectionGUID: 6dy+f7ocRyiuyK844BH4xg==
X-CSE-MsgGUID: GKtiV2EaRX2n9gLRz4GSKw==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14732142"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="14732142"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 02:24:17 -0700
X-CSE-ConnectionGUID: SWx+sngdQ7iyekGkwC68SA==
X-CSE-MsgGUID: bBfcdBtsTui+Tf8O3iArZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="39839863"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 02:24:11 -0700
Message-ID: <3315d483-cdc0-44cd-af56-9fee612de054@intel.com>
Date: Wed, 12 Jun 2024 17:24:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/65] i386/tdx: Make Intel-PT unsupported for TD guest
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-19-xiaoyao.li@intel.com>
 <59fec569-95e1-9024-77fb-b6d2f89b3951@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <59fec569-95e1-9024-77fb-b6d2f89b3951@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/31/2024 5:27 PM, Duan, Zhenzhong wrote:
> 
> On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
>> Due to the fact that Intel-PT virtualization support has been broken in
>> QEMU since Sapphire Rapids generation[1], below warning is triggered when
>> luanching TD guest:
>>
>>    warning: host doesn't support requested feature: 
>> CPUID.07H:EBX.intel-pt [bit 25]
>>
>> Before Intel-pt is fixed in QEMU, just make Intel-PT unsupported for TD
>> guest, to avoid the confusing warning.
> 
> I guess normal guest has same issue.

yeah, just the bug referenced by [1]

> Thanks
> 
> Zhenzhong
> 
>>
>> [1] 
>> https://lore.kernel.org/qemu-devel/20230531084311.3807277-1-xiaoyao.li@intel.com/
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v4:
>>   - newly added patch;
>> ---
>>   target/i386/kvm/tdx.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 85d96140b450..239170142e4f 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -292,6 +292,11 @@ void tdx_get_supported_cpuid(uint32_t function, 
>> uint32_t index, int reg,
>>       if (function == 1 && reg == R_ECX && !enable_cpu_pm) {
>>           *ret &= ~CPUID_EXT_MONITOR;
>>       }
>> +
>> +    /* QEMU Intel-pt support is broken, don't advertise Intel-PT */
>> +    if (function == 7 && reg == R_EBX) {
>> +        *ret &= ~CPUID_7_0_EBX_INTEL_PT;
>> +    }
>>   }
>>   enum tdx_ioctl_level{


