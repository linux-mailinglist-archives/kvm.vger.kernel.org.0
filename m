Return-Path: <kvm+bounces-10560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8AC86D6ED
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 663B11F2287E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4EB38DD7;
	Thu, 29 Feb 2024 22:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hpvKm4CU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB771D522;
	Thu, 29 Feb 2024 22:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709246393; cv=fail; b=mnvvg0kvHaBaq47Vy2jIy0bFyC0KgFRLc5+hwpKgZB9EEoOk89wKm4QtYE3JF7zwoBn60UxFXlGBRL0khpm5B3ekEfGSZrx04uqfNZLPduLkpFP8QtTzNYgs5isPfyyMXdF4rG9x7eVU88GTluDqusWYZlJfmDKHLcWPMj3PEH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709246393; c=relaxed/simple;
	bh=Ia/Z9wiEYzsaN2Sf68c7C8C5ML+d6ky11uAnnT/qT2o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NlosWcl4bz1FlnklyIWBO0q24IgTFc2t1hBJJDURuV9NaLAKO9c4zSaWK+vtxMDQ0+FNjNJ/MC6qD+0OYL+s1lrH4o+OUpyCVdfopEkVsaOvApMxSAmIb8iFgm8P8V/Pcl24t0Xox87YcaBIES26KJt0k0AoncrH+Zm0tzgtTrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hpvKm4CU; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709246392; x=1740782392;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ia/Z9wiEYzsaN2Sf68c7C8C5ML+d6ky11uAnnT/qT2o=;
  b=hpvKm4CU/z8ugBDAl6ojWpKlsjfrfPGT96JkRLIxqXEPKizReKcTiwEN
   YR0GbptURmym0QdgHA3NW0YzXpCSDSwCXZeXF/XTpeSM6KKzy2NcTJy6v
   7XmB7mbfka+xZE5BKaNacrKUeULup52/GYD4vBXMEzdA7XboejZsDUwAx
   60I2OoZKapjIjrJfQGY8774Pd02gFxWodyLncC1DG8s04P/93E3/ulYei
   fhHeiEU2ByfU4yvqFTPtd/XcbWAUrn8Oatc07XW36uKLd5MkLujWdRCqs
   Yn8v0fGFRZ2n08j2EOGSg+p+nXVDB2BHJ32ZJaYvEmvOPm1OdCI8thKVB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="7577815"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7577815"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:39:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="8373492"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 14:39:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 14:39:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 14:39:50 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 14:39:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmLqgo6M1brQFR8F1/ecXJc34eRCXA22TOvAeO4pTmoiu/Ub8y32V6Ny9/YWPKxyt6gyEddOZrgTU1BgN8t0XXL4SBsusY5v6y6SRRhf6W0kTYwM5NfyoTH/l9oFCkvtzhDebsj8CdXbO/lyJcMbQckqUDUj9LhOz1D+YA1nxtH3wyNG1Q5GWTC9gQnBZOSd0xNJ7xz8BS1sd8k5LufmrKOE072Or492j51Fbbx8hFcv/Tjiiowwvs5eQ0WLoy6qEApbGag7LEehjt6eFHhUrBoMUxyR0P/QDGfwUdcC+t/pxxgeU+NvN585wp6SR92mjCI6OhsMrKbJgles0qXT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDfpfipceMK/kZ7Hew7Cd6RyplSqYNkOfRs+2jIU7pQ=;
 b=O5MtdWuaFzVhhIWLPClxKxoEiTTLr39m7+cNazGExs/TYaYgxrBQq+AWvxJ2gyNqyCzQtTnDPHgfsXBCtY7+vN/ju8HuL3/dh/azbP8f4h2PFUUHjS7So1AzNBCmPxYxd37DlGyuwuUDsZzUjfjm5XySG2RTxPa8RTKk1OtGjiZPV8FMxwfVkT3Kx5lixOkFMmL/b2XO4I93jumiqNdihCp+Aspjf1rqIFtreOHLIeA/O7sZ/b8j52Jxc/XyJrS+l1DoyOtWwtDzOEJCEEVk9bwhDSZAK6bO85kDugxarAvCtwz1tGt/bF3pH0S2Hc0CLQTQOE9kKQ5EZTRxwyaYww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7929.namprd11.prod.outlook.com (2603:10b6:8:e5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.23; Thu, 29 Feb 2024 22:39:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 22:39:48 +0000
Message-ID: <6d17801e-33be-4f6e-a61b-8d8f43238261@intel.com>
Date: Fri, 1 Mar 2024 11:39:41 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: use KVM_HVA_ERR_BAD to check bad hva
Content-Language: en-US
To: Dongli Zhang <dongli.zhang@oracle.com>, <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>
References: <20240229212522.34515-1-dongli.zhang@oracle.com>
 <04398f4e-6098-4559-9604-b9810753801e@intel.com>
 <7fcfc226-0263-0364-bed7-fc95e6c945cb@oracle.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <7fcfc226-0263-0364-bed7-fc95e6c945cb@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:303:b6::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS7PR11MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 2daff21c-686b-497e-2716-08dc397755d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OP2O7sufgy/etPoI3ONvurQjuqCoeVVranC7QYpUp27J0jWwkX0bd5Qd/HHVaTtxl0tRckm2B1RCtX9hDViUkSmon6tSjgGhS2Iv+yeF4u71OIJTqUAkcbzs3jpmZxg60FdbN0s/5T0U6n37+mOKYWl91VundkPNHqLiRnkfawQWJ0LuRcKVOz1qHPoSt0ShyenNTyI0+kuGORDRGzEXnTd5MGs43dD66jUPu9h7OKToIzv8qzGyRHrvCl3XJFMZSDjNrCKKooET6in3WtVD6BQup+Hojy22j8afyxqPYl8tnH2beYIIXXKzz3BI6Sa29OlP6pfANcKVtUd3nQA5mJ1Uc+CwjDaxCzSN40crgtaExZgurb3jG/IFn4rYvFS4dX/P8zmG7cLQ47ODMVNZ0qY/URYck3zfCXFnKP3hOJPpWgrMk478ICdVRC1+c21SyEm+wjwsCszyaADqBxWcHKSncLLlR/wbgqrKGlYEWpj1puMdMWCm6lQxWGGvxJYFnpHqQa87PI8qzvWPdBpzb/+A8M8mDKuU4T/e3XzeSypPiIJqzft/FP8L6fuRAWwGBTYsr/inn/AdZUJwSEasmNk0KkYahx/v7wAparBPX4JaHfcvdfQAJ9CoVEgDN7K5MtS4ujs8OmHJxQs8NMVz/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTVtdEpPM1hCSG1rZVpIUm1vaVd6aWlkYVRRY2pFS2xaNHlNUjN0aEt1cmpK?=
 =?utf-8?B?YkJZZnE1M3hXa1JXK3dmS1JGdzhnaFhsYkt1Y1E0RWZxcVdCclFSVlB0eFp6?=
 =?utf-8?B?NHptNnJpNDluajBiSytLaHNabFBPL1d3STZBd09TT1lIY0ZFcVVHQnR1cVdz?=
 =?utf-8?B?cnJHc0NJc1E3WE5PY2FnTHB5QTBHZ2dxUEJ6bW8zcjEwSERJb2JSdVZqZWV2?=
 =?utf-8?B?YTdTcVlhWTV2UUpHWlA4RkxMbFdnUDBmVFFhbEFQQjdFWkJuM3c4VmNVZHRX?=
 =?utf-8?B?TkN0Sis0VFBRQkEwbXQvTnhpV2xNWWRycTBERmtuSUo3QlhiY2FMakJmdzIy?=
 =?utf-8?B?aDZ1S0pSVXN1bW1BRnR1WkZTN2xVblBiZk15dUtZVGk3VE1zTG4xck05MHZB?=
 =?utf-8?B?Mm9rck5rbnVlZ2NIZUY2R242QnUyNEdUejlWdGZPZFVZNHY0cndEUjlYY3Zj?=
 =?utf-8?B?Q3VpajdUcTlBWUlQOUdQM2dXMEYyRU1OaTBUcmY0UE45Y3NBdFhUbEdwUUJF?=
 =?utf-8?B?ck51UXB0K2s3Y2o5OUdqNzZaVE52dk92MHkvRDREdDY2Q21adzdMRnZleEVw?=
 =?utf-8?B?YTdvTEtha1BjeHY4U3JLNEZZd2g3RytXdjl4SkIxZ2VMQ3hmRXA0RmpsMWZK?=
 =?utf-8?B?S2g1Y3dMRkdTZjc2VFNja2xvdW42NGVYWkM5eVliYWZpc1VvbWtnZHpHVk1D?=
 =?utf-8?B?U1ZVdVprYlNBS3d3aFp0dzNLUkNmZHVONDVUQWU2aHBocUo1aEJkQk9pa0xE?=
 =?utf-8?B?MTU0cVFDQUhxb0o2MStZZThlY2xGd25yVzNyNnF5aStaWE0rVk5EUk5MN2dC?=
 =?utf-8?B?Q1l3bjZOYUxqanV2WVhlWDBKOUlxSjRlT3ZCN05keEpBR1NtbWRjWktTNXpK?=
 =?utf-8?B?NWV0bTZiNmFvQnozSmJCWGh1OGFYNjExWGdNY1BweDFsZzhxOWtnckU0OFdi?=
 =?utf-8?B?TjhDbzlDNWJlS00zSSs1UWNyS0VIVmprbllWSkorTWdwQXFURDFoYllJR3NO?=
 =?utf-8?B?RXZpMWxaeFRVRXh4a1FmY2JHeTZ2eWhQYmNIY2dQSUIzaU5jRXNVWE1VWDRI?=
 =?utf-8?B?Tndwa0tOeFBqZTVxd0dYeWZrTTh1NUtuYkdaZ0hDRHl3MTRyMmVOcDJLUUJ5?=
 =?utf-8?B?YWVLRnhrZUM2WWZBN2tQSnpWcHRVbFdPWmljbU5hSUpZbFI0eFJZVjhqYlB5?=
 =?utf-8?B?bmEyNlFEYWpMcGZBaFB1VTRubnd3cXFZTm8wajdWR1haK3BHMEdzckRtQ0xw?=
 =?utf-8?B?Y1dwY1BnYyttdlJLcVB6ZEZDS0FkSXNzczdIRk9IVTJHSm9IMkdGQlVBZWFa?=
 =?utf-8?B?RkI2NXJ3WXNvb0pnM0s0Snc4N3ZtM0pxbGF1RnlaMS9WOUFYTFlQUmFxanMy?=
 =?utf-8?B?T2tzYVRXYUhBU1F6b2xRbzNXcHdnUDZHNnNZa1FpcjdLMTBKTHYwUjBFQkNF?=
 =?utf-8?B?SWppdnlweVM1N2VwTlhVQTBNQ3NQY0laMTFncTR1WFlqQUFOWndLWlZaS2VX?=
 =?utf-8?B?KzVza2RrbVI0aklFL0puTGt4dHNrbmNicFo4UWhSa0NCVGFDWE80d3daTnk1?=
 =?utf-8?B?OHhaY0xYMnp4ZFJDRmdDZkkzVjhZTy9qQzB6MnNjTmJsVlg0aGxlL2pxazBS?=
 =?utf-8?B?WlhBbThQcHFCM1BMVmcwV3RUNHAvSGJoam42QkZkb29QV3gvUDVrZ2Eraldo?=
 =?utf-8?B?MHlSeTV6Y3NXSElML1Y3TndZWC9KbGc5QmNKbnp2NGtLZUtVTklQdlBuZHVX?=
 =?utf-8?B?NFJwU2lRbXNlbDlzdGc5ZWl6MkN0Qk5OcU8va0QvVnRiZHR4MUdKdUI3WnM4?=
 =?utf-8?B?MkltcENvbVlmYjdncXNPNDAyWkdYVllVcTVMOEJLQUw1NEdXaXR5L3cyeXBo?=
 =?utf-8?B?NGJ6amZKNGFFZHJOQ29rUFI4UUg3TTZnSk9oWTdKczB5VmJkc2NxRUx1VUVK?=
 =?utf-8?B?YzFldE80eWN2MUNrVUpiK2o3SCtyaWdNQ2xhYkl4akYyOFBlRW96Z1V3VklU?=
 =?utf-8?B?NndwSjBvWTNnZUpxUTdIcnNrWStiRk9MYThPNXVRdFV3Zlh5bE5ZV1BReHpi?=
 =?utf-8?B?WUc3QU03YnZsUVVJMksrTVlrLzdSbVVnN2N0VVQwV01vWDBycUtsM3R2bjk5?=
 =?utf-8?Q?2zQ6Z9NBr+7VZ+1z1u+uGjoWw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2daff21c-686b-497e-2716-08dc397755d4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 22:39:48.5061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0cOf5maxj9q1NjUrLfLcW+KMpvXxddEKb1eN+V/FRKo5Allxj7PP6ECE9brQYENTgJgPHJNgFUkiN/dqM2s7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7929
X-OriginatorOrg: intel.com



On 1/03/2024 11:13 am, Dongli Zhang wrote:
> 
> 
> On 2/29/24 13:53, Huang, Kai wrote:
>>
>>
>> On 1/03/2024 10:25 am, Dongli Zhang wrote:
>>> Replace PAGE_OFFSET with KVM_HVA_ERR_BAD, to facilitate the cscope when
>>> looking for where KVM_HVA_ERR_BAD is used.
>>>
>>> Every time I use cscope to query the functions that are impacted by the
>>> return value (KVM_HVA_ERR_BAD) of __gfn_to_hva_many(), I may miss
>>> kvm_is_error_hva().
>>
>> I am not sure "to facilitate cscope" could be a justification to do some code
>> change in the kernel.
>>
>>>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>>    include/linux/kvm_host.h | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 7e7fd25b09b3..4dc0300e7766 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -143,7 +143,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
>>>      static inline bool kvm_is_error_hva(unsigned long addr)
>>>    {
>>> -    return addr >= PAGE_OFFSET;
>>> +    return addr >= KVM_HVA_ERR_BAD;
>>>    }
>>>      #endif
>>
>>
>> Also, IIUC the KVM_HVA_ERR_BAD _theoretically_ can be any random value that can
>> make kvm_is_error_hva() return false, while kvm_is_error_hva() must catch all
>> error HVAs.
>>
>> E.g., if we ever change KVM_HVA_ERR_BAD to use any other value (although I don't
>> see why this could ever happen), then using KVM_HVA_ERR_BAD in
>> kvm_is_error_hva() would be broken.
>>
>> In other words, it seems to me we should just use PAGE_OFFSET in
>> kvm_is_error_hva().
>>
> 
> 
> At least so far PAGE_OFFSET is the same value as KVM_HVA_ERR_BAD (except
> mips/s390), as line 141. Therefore, this is "No functional change".
> 
> It indicates the userspace VMM can never have hva in the range of kernel space.
> 
>   139 #ifndef KVM_HVA_ERR_BAD
>   140
>   141 #define KVM_HVA_ERR_BAD         (PAGE_OFFSET)
>   142 #define KVM_HVA_ERR_RO_BAD      (PAGE_OFFSET + PAGE_SIZE)
>   143
>   144 static inline bool kvm_is_error_hva(unsigned long addr)
>   145 {
>   146         return addr >= PAGE_OFFSET;
>   147 }
>   148
>   149 #endif
> 
> 
> Regarding to "facilitate cscope", this happened since long time ago when I read
> about ept_violation/mmio path.
> 
> 1. The __gfn_to_hva_many() may return KVM_HVA_ERR_BAD for mmio.
> 2. Then I used cscope to find the location of KVM_HVA_ERR_BAD.
> 3. The kvm_is_error_hva() is not in the results.
> 4. It took me a while to figure out that the 'KVM_HVA_ERR_BAD' is indirectly
> used by kvm_is_error_hva().
> 
> This is just based on my own experience when reading mmio code path. Thank you
> very much!

Neither of these can justify this patch.

As I replied earlier, _logically_, IIUC kvm_is_error_hva() shouldn't use 
KVM_HVA_ERR_BAD, because the former needs to catch *ALL* bad HVA but the 
latter could be some *RANDOM* bad HVA.


