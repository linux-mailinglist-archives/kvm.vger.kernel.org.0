Return-Path: <kvm+bounces-11210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D188742FC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B6111C21757
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917D11C2A0;
	Wed,  6 Mar 2024 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgytN9SR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D51B7E4;
	Wed,  6 Mar 2024 22:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709765371; cv=fail; b=g/v6rOvEH96qSM8r1n5dTz42EiysZJO5J4UuFFSlQAuL9yGeMwHIWlCJf4Ah9YwSwSeIdMJFS4GKD5P7mK7znPKeoRXKqhXHUei5v9M8pwH6t2XxdstrRFjjZWiOBSO58FaITfPbC8Q0f6wovnSAQnbaPPmwZmhh886ud092lMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709765371; c=relaxed/simple;
	bh=JxijQbKzitVX0eSw34xzrgkQOkUkWeijLi7tHHm3tRo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ycnm3H7+AcHBWujslJun31WFd+uUQTLYqn82riA1JahMBDoVuA89rhAZQO/HhDsnKO0nQQfbFFzrs+7EEVMapJFelxUvc+pusyAeK7Mi+j7xWHg0g6f2HYhsCu76RWwydCSQFGv6grezuek09jMIh1iWs0NwQpGTh6vJJJpqslo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgytN9SR; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709765370; x=1741301370;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JxijQbKzitVX0eSw34xzrgkQOkUkWeijLi7tHHm3tRo=;
  b=KgytN9SR6cfXPWUfsk5VvjiwARTLLDt4NVXyqnJwW3tVXKTtypuhzHk/
   tgfishkUGJPyNpSquEWg8OEeoilfquK5CdIvPJZRuHbuaiFGA396WtYXH
   a+tGHniKL3KlMwVwfqEWUeBBD661puXaV4TBFr/fSwKcR/rcoeSGw6BKP
   baJmwyn9VFkyM9UkM05HquMzIKzAjEu7z+jPDHbvOOAT6iIgYIhjMHwMJ
   u28ZAy/HRWgyK8VsdqMVt18sB4LZSAj7jkCBNpuraQgV4r6VO5cUMfkv1
   9rvUXkH6pjbFcCokmBtjjX3xZnbfMLAjR8mt1VeNI8gVLTkaG/pkFqeca
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8172344"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="8172344"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:49:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9993494"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 14:49:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 14:49:28 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 14:49:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 14:49:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSvT+F/iqXjGAsFWqdVeoK+ki/JyLx+cRMbn+Z8EtNm/4gL9C3SDBf6rKz8Jr1FoR8C03YcXwSVzyH4dfGDu66LEfdci2jGuPNRvgO9dLxczyW1PTNJHKMq8IGOSAweRyu79ZypChrfRsSv8xRL/hptlC4R2cD9DP9IQ4YRKRF0FeJP/uor7mpBOslYGnOaugXGFZlS0R+8CJw9vpcpOsO24S9kdr0X3OpdbZf1mQNy0L6sa4F0Tt5kKeOy8aHoP/uWvYCqAwcK6YAhM9+xvY/wK7Us5Y8iSVIhC8Mx2qWP0kjyuvV+jvEC+A4ixfsvNSzRqymH+HhlV7XX9QpY65g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rdw5JrLzG6wQ49wz5C9e1xH6BtZ65Ft/h3lFiBRMA8w=;
 b=Euj4YkN+bd+s1awjp5QIJFgLcMyjzVnH5AMMFXiVkY72leJXhI90x6LeqPALr0x8RpDx9OkFLAcuoQ71l2pVZOmfS/AayT9DU+QWB0Lpr7gdYQafwT7Z6a6jp89ky25xp+pWcxr1GH03SFFo09JpB+hEmxGPhvp3Gsdm6mdPGvIc1KoQxEvD5PgzzpxldgENU009eiodgkGsmBP2WeAfC2uaQVay71NK5ZYjji4jRDdhb/6JRZDB3V1QzQw995qUCN65Pqj/V+bYHDufVPcopEn8kokS97nOlnUduYqA6vLX3QGCeO3fSdSJAe4/kp6LZhyyoaAZaRhRnKdr8AibTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5982.namprd11.prod.outlook.com (2603:10b6:510:1e1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 22:49:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 22:49:20 +0000
Message-ID: <5f230626-2738-41cc-875d-ab1a7ef19f64@intel.com>
Date: Thu, 7 Mar 2024 11:49:11 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: x86/mmu: Explicitly disallow private accesses
 to emulated MMIO
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>,
	"Yu Zhang" <yu.c.zhang@linux.intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David Matlack
	<dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-12-seanjc@google.com>
 <0a05d5ec-5352-4bab-96ae-2fa35235477c@intel.com>
 <ZejxqaEBi3q0TU_d@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZejxqaEBi3q0TU_d@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:303:86::15) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB5982:EE_
X-MS-Office365-Filtering-Correlation-Id: e1feed50-49fc-439d-55f4-08dc3e2fa965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MWpVhMo/P2OWsH7u7EKgtqHV0vaiHC5hHI0bFc4Nhe+i7CVZcOz02UEgs0K63jbKc4V6fjZpyDw74VMJ1A3wmnWJjUjf3DNuagT+PwveJHmLzn9A5sphb2mCziLEGwxwC+75b4DatGhHrBsjNL6uWX+0vm14JzXhg31DCTqvz/UnQTR06tIGX6wCHTZCoy8NojVfr3hC+5mCNfJyhzlBs9ff/9NYhfSbIUprzZZdipWgN7TjHmxixfaBYCzcIij7ty83iioeZv2Q/bA5PCQFOWiIQVLzA4Tj9i3IevV0EBpbVDHUBi6/pp6Ol97X7MfO4TYVopDcTvI7sQ+445Sr6KaxzHHv/TwlIo8Er4w19pWyny/YuNVS/VfligGM4Syl5SKwe3e14vEm6aw5XKtyeJu5ogSJlzQVC/ophuebwqJBCi7btw/i/QsgBnvXwRPmX3dzsE32U8a0q3AKm/4H6XEs70mSdyGErZcNiuPvGV/t1e12TqFMagsWZHLqSiSB2Rfvbw9FnrcNHV05s6A6onOUQ4fwJqXF91S9fDvvoRtfIk8xu+awiUQA9ZPh0oqduAQEi89f5DpV2KsoazYUar4xUJG3DUy5PKkmwZOCd5t8lCiJ0chY8bMrxPMwsLZ0kC/qlakaA9anHRz4DWVq7cb21grD/kwUEiWXjbk8ys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alc5ZExTUEhwaG9HR0F2Ykt1SWc4Zmo4TlZQenNYRGJSckVxRjBwR0gvK3lJ?=
 =?utf-8?B?K09lTlhuY1hKd250dDVpVlJwMjB5RmtJa2xaL0VDb2FGMTZLT2llNlh5MWNN?=
 =?utf-8?B?c2s5bGxtTENjK3FHdDN6UEFHUjlmS3RTbUdKSWl2RXQrN0RTVWh1SlNnTFVR?=
 =?utf-8?B?Y3ZvaGpOdEdXTWpVOVNtTmY1TU1wRnJMR1VGZ1FocGx0c0pMOU5ObDNiRk5X?=
 =?utf-8?B?eWlMb2JreDkraGpJZSt4QlVTd0pZajRjU2djVDFzYWpHVTVsN3J6WmM0Ym4r?=
 =?utf-8?B?UVY0d2ZCUHc4c0g2SjFEVEpEdWNvMDVpQVZuaEtpWnBvWjVMODFqcnBPdElL?=
 =?utf-8?B?elFFM0FWMFh6aVhqNkphOXdlRUtUbk4yeU9ZWWUwSndHWXdROEVTbmlocWtR?=
 =?utf-8?B?MDN5OTJ3REZvNUpXbmpYT01XaGo1S0FJRGJSa2RtbktjQk85V3htSHo5cFE1?=
 =?utf-8?B?TjBuM2pIcnlvUW41RjJDdFliRkF0K2lLZXNDMDd1a3FlRC9sWDkwNTc4akxS?=
 =?utf-8?B?T1VqZEdyOHp6Y1Z4NkxaRC9tWk5qMHAzRXZLcnI5Z2tpT0xJb1N4TEpGVzFY?=
 =?utf-8?B?ZFFGU29TZ3lkNG9sNFBZQXVRTDRkSlczRGhBcGxIU24xWUlndktoWHhLMjUy?=
 =?utf-8?B?M2dmOXIyRlR2QmhxT3RyaDVPTnFidDBmOWFQZG1XWllmWHlER2dQWG05akVx?=
 =?utf-8?B?T0tpQUUyWHN6QThpay9qaFZFRmRXdUNiRXN3RHdGaHpScG4xOHA3RXJySEJm?=
 =?utf-8?B?dkhjVnRQQ2MxM2dKbXU0L0JsVTlPOThUSE01UzVTQTQrMEFQM2JweXo5c1Az?=
 =?utf-8?B?c3B6WUZIRnNQUy9JOWt6N3VMY29maGk3QUsxdEJKM2ZJekVCc2xuVDI0WUM2?=
 =?utf-8?B?MXBsY3Vlei9iV3RnVEpsRU5rSUpka215TnVQSTFNWTRPbkQ3aW81L1JKcm1t?=
 =?utf-8?B?dU5xOFdIbmNPQ054RGpPNzByQzZ0VTRXVTMwYldmOEdqb0NtSUdET2VJMnlU?=
 =?utf-8?B?ZlZGSXQzMDFsRkZYdmVBMDlIVWkyTmlHYVdnOE1CdHgwYmc0NkdDbDQzbGtG?=
 =?utf-8?B?emJrWHFiNklvbStYTnJqVkJCN21jdHRUbml5ZitCdFQyL2N0ZE1RbHh3NDJH?=
 =?utf-8?B?SGRXSmRIOTBSR3dFQ0haS3Iwb1hWb3ZObWtBTjFWczBHUWtvOVVNaHBBbk04?=
 =?utf-8?B?dXZhMU8zMmI4QWY1SDhjUXZZRWQzYzc5c2twdGN0S1BxSXVEdzNvTURGZGZH?=
 =?utf-8?B?Rm9nOTUxV3A0WkdGZFk0dTJNdTFhZ0oyYkFLeVhNdHlzTk5ZZG1XcDF4K1l3?=
 =?utf-8?B?TlErR0NUb2FHZkFZc2o0TW5RaXEzZlhVdko1RHc0eFEyZmhiMXo1d1Rhdmlh?=
 =?utf-8?B?cDBBSnVXWCtIYkZkYTM4V0hrNTBXVUFqOFNIUnFDbSsxQm9kRDVBM1J0Z3A5?=
 =?utf-8?B?QURhZzE4MXNsV0FiQVZLa3ZuUndNQ0QvZVlPN0svZFBnWWdtUldhYkYzOVI1?=
 =?utf-8?B?K2VCaGRBbEF4NHZwcUhrT1hoSFl6QTZnS2lWOWNUam55UFVldjJIYWtnVWE5?=
 =?utf-8?B?cnhBc0dZRDBuYTZ0YXhVdkVHblNUNk9ZS2NkbWxDK2ZBNnlQdms4K3lqVVNp?=
 =?utf-8?B?VHRrQ3Y2N011Y21WeFFHWlNweitFbWNUNXkrczF1WXdoemNEbWE2aEFSUlUv?=
 =?utf-8?B?a2Rwalg3aUdSNk9Nc0ZISHhRY3psMDhFSEFpcjdsSmRaVFlQU3dkOCtuL2Mw?=
 =?utf-8?B?aTZRSUtSUGFtSVlBWHR0V2xzNCszWFJvZHVmU1VQTFBlbys1SFhsaExPdTZX?=
 =?utf-8?B?WHpBeGxWc3BVMUJnVE9xcVN4OXE1NmhxcGtOZzRXSWpkK2FLRkNqQndUWEV3?=
 =?utf-8?B?WHR5QWovM0tnZnExMHVOVjkwYldOaWlRMW1rQmJkTjdRMm5pc1BkQjRvWnJm?=
 =?utf-8?B?VzVoajA0TnhxNmM0L0tRaDcyV25Hdnh5cHVGdEJ5Y1dQMEZiajVJd09SNEZh?=
 =?utf-8?B?SEhYclFtVCtQbHNrdHdaU1BibTBZK0ovUjR2RzQ3ZDNLajBDY3RzWDZYeTh3?=
 =?utf-8?B?dktIaXpLaGNkU1FVQVNZeDMwaHY0R09DS0M0cnJvM0tLN0prQU1wMmczMXNW?=
 =?utf-8?Q?c2oMQaGVxtGgEyTrhPC1knl9v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1feed50-49fc-439d-55f4-08dc3e2fa965
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 22:49:20.7706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OjZGyRfDXnI1+oD6PgDQ4Zk7J1HiLA0+gOu1B8fA4xuKUhi0VkN0nqJcaNeLhhV4h17Q2puhPHldGVbr2PGHjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5982
X-OriginatorOrg: intel.com



On 7/03/2024 11:43 am, Sean Christopherson wrote:
> On Thu, Mar 07, 2024, Kai Huang wrote:
>>
>>
>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>> Explicitly detect and disallow private accesses to emulated MMIO in
>>> kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
>>> to perform the check.  This will allow the page fault path to go straight
>>> to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 5c8caab64ba2..ebdb3fcce3dc 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -3314,6 +3314,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>>>    {
>>>    	gva_t gva = fault->is_tdp ? 0 : fault->addr;
>>> +	if (fault->is_private) {
>>> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>>> +		return -EFAULT;
>>> +	}
>>> +
>>
>> As mentioned in another reply in this series, unless I am mistaken, for TDX
>> guest the _first_ MMIO access would still cause EPT violation with MMIO GFN
>> being private.
>>
>> Returning to userspace cannot really help here because the MMIO mapping is
>> inside the guest.
> 
> That's a guest bug.  The guest *knows* it's a TDX VM, it *has* to know.  Accessing
> emulated MMIO and thus taking a #VE before enabling paging is nonsensical.  Either
> enable paging and setup MMIO regions as shared, or go straight to TDCALL.

+Kirill,

I kinda forgot the detail, but what I am afraid is there might be bunch 
of existing TDX guests (since TDX guest code is upstream-ed) using 
unmodified drivers, which doesn't map MMIO regions as shared I suppose.

Kirill,

Could you clarify whether TDX guest code maps MMIO regions as shared 
since beginning?

