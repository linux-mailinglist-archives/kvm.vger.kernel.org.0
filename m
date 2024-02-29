Return-Path: <kvm+bounces-10479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8533886C77B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 259BA1F26B01
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075797AE53;
	Thu, 29 Feb 2024 10:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSKDD/6e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBE87C091
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709204100; cv=none; b=DNmyjxxs5YKTd136N0hi99OkOSFcN/pYCr6SqSLV0y9XFwRi7cj8vXH75nEMv5DWK4A+cd5mvHOHwea0wX6rQ83cyqBljRcds3YGWADurEpsE7CCf0UO7sncZwDV+iyLdLmO0SQThU8BwH5PP+JfZYgAYmZ4y4gZaLQrJFwj3g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709204100; c=relaxed/simple;
	bh=PTV5Pm71RQDWkK6oBnOwKmcEOCjvKcxi5M6jFBDZ3xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itkOGew7yMltE1UIGh/aXpAsAJI2vIfxZWUgr4zhDJ3NMc9L9thKMnA223nqovpMufyF0PAsBOzk6YykzfPrjRaUfGKpGjVsQ5M8jEhHWSZ3JYCM1YbAXTKixP8eeFQb0ScxrRMub+GZBMhkBpOIyR4KJPwjCzJUM1FelsKRXQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSKDD/6e; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709204099; x=1740740099;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PTV5Pm71RQDWkK6oBnOwKmcEOCjvKcxi5M6jFBDZ3xA=;
  b=hSKDD/6ebI0bXZ5vrohjyy7REsndc+BkqdXIjt7MLdFprQcuMwGtkdpo
   BvrwMaTPsl/oUvTlNeFPx9ur9XQ0+kcU8rbUGXArpLJB5ZeFdJsCAYJvV
   AZAzaEhDNxarF6/lxPwe/GXW+hJ+YIzTyj2XDW1qB2bVpYrOmcmnGsrIM
   i7PofSJDHDAa4yixxAF2fDZBATuX5Zr9sZUuAOfs0E7mQtlRVJL9Ha1Zk
   JhInb5fA5zcsKUBxsfuvzT7pGtH0UgJo/vbHjR+CiORpHDZ9/YbIzmnLv
   gm1VjJeDB3KvJs23hKru1SjNIKANOFPZAsuVNkJE3/hwlNRjbB8FPKgmX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="15080098"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="15080098"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 02:54:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="38622139"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 02:54:51 -0800
Message-ID: <8a2c760d-6310-42eb-b632-5f67b12e2149@intel.com>
Date: Thu, 29 Feb 2024 18:54:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
 Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com> <87a5nj1x4l.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87a5nj1x4l.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/2024 4:40 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add property "quote-generation-socket" to tdx-guest, which is a property
>> of type SocketAddress to specify Quote Generation Service(QGS).
>>
>> On request of GetQuote, it connects to the QGS socket, read request
>> data from shared guest memory, send the request data to the QGS,
>> and store the response into shared guest memory, at last notify
>> TD guest by interrupt.
>>
>> command line example:
>>    qemu-system-x86_64 \
>>      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>>      -machine confidential-guest-support=tdx0
>>
>> Note, above example uses vsock type socket because the QGS we used
>> implements the vsock socket. It can be other types, like UNIX socket,
>> which depends on the implementation of QGS.
>>
>> To avoid no response from QGS server, setup a timer for the transaction.
>> If timeout, make it an error and interrupt guest. Define the threshold of
>> time to 30s at present, maybe change to other value if not appropriate.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> [...]
> 
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index cac875349a3a..7b26b0a0d3aa 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -917,13 +917,19 @@
>>   #     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
>>   #     used when absent).
>>   #
>> +# @quote-generation-socket: socket address for Quote Generation
>> +#     Service (QGS).  QGS is a daemon running on the host.  User in
>> +#     TD guest cannot get TD quoting for attestation if QGS is not
>> +#     provided.  So admin should always provide it.
> 
> This makes me wonder why it's optional.  Can you describe a use case for
> *not* specifying @quote-generation-socket?

Maybe at last when all the TDX support lands on all the components, 
attestation will become a must for a TD guest to be usable.

However, at least for today, booting and running a TD guest don't 
require attestation. So not provide it, doesn't affect anything 
excepting cannot get a Quote.

>> +#
>>   # Since: 9.0
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>>     'data': { '*sept-ve-disable': 'bool',
>>               '*mrconfigid': 'str',
>>               '*mrowner': 'str',
>> -            '*mrownerconfig': 'str' } }
>> +            '*mrownerconfig': 'str',
>> +            '*quote-generation-socket': 'SocketAddress' } }
>>   
>>   ##
>>   # @ThreadContextProperties:
> 
> [...]
> 


