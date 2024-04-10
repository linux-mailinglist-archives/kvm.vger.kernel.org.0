Return-Path: <kvm+bounces-14058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9960B89E787
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 03:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C866283ECD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E34010E3;
	Wed, 10 Apr 2024 01:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hWmgbbQo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3952E621;
	Wed, 10 Apr 2024 01:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711126; cv=fail; b=t52RNQHvhgF4TkHGS3TakxLOl/EGLqJJbOIJu0GyL98D7GjfOkg3mh0Q0fKSWgCFi+gl7bfuRO9GUlHsKyl8llt42j7UY35Rxcl8muJGFoCH4XT85jsCKHS4yZ/JgV1htvfPYA3XL5N9fLSilPbZcio55zTAMn3LGCvlxHClDhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711126; c=relaxed/simple;
	bh=a1OjSKAekNqLU2NnIADQxMHnCyZT1ggZVpZRb6fpJO8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mi0dA2pYGvOkzVT9UDDE5Vp90DeNQt717cdUH/lvHaPCFlNkPzri+c52dzi4lICKLG47Y0U6It7eVbUa93hCT07zUHvO2RtKd2JWcnG/lpwtO6435CKGys9QpFyZL3MBqIjQE1gbHczXWKSBPXsmL9avk0mCz9ktb9EcxNZ1/Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hWmgbbQo; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712711124; x=1744247124;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a1OjSKAekNqLU2NnIADQxMHnCyZT1ggZVpZRb6fpJO8=;
  b=hWmgbbQoQwhBZAYykUBmXkR50F5fuyjk8TOooa3vYJnY6Uid1IVjuDPz
   bNjuwuR/QTL619NJpLOJ/6UazVd9qyX1o+C7ef16C78LijgyhbeBvUWih
   io4aQtv0NAnIIx3HgCvAPjJ4S0QmV9+3EM0uqxIt4cy1lkG9wgcoVhnOd
   0uTldD3Fgd4N74b5celKRX4gDOn3ILHcqpr2AosabBpAlt30x2SapNm03
   XPLc5tvDJX709aMQFMRzvoU9S7kVrTS96lIHU0ajXjvltWEO05M+wL1CB
   iZ09i4afsZioPgfw7sicrDc5KKxLFKHCjv7s0xO5Vk1ZYJlGXD/mQVtm8
   w==;
X-CSE-ConnectionGUID: mqhbX/8bSbygkq52d/rIlQ==
X-CSE-MsgGUID: GrXDEnZPRLKrZ2YLqQJlzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="11844218"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="11844218"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 18:05:22 -0700
X-CSE-ConnectionGUID: Nwl62qToRBanWvtwjrlkTA==
X-CSE-MsgGUID: ZllNyA4aTr+Uv+DylqfovA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="20280379"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Apr 2024 18:05:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 18:05:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 18:05:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Apr 2024 18:05:21 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Apr 2024 18:05:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffhwT4w2MAb8stCUnpaLqLztIQFsb2XN3FAEZLRdKe0tpWm6bY7CD/dDIXmouQlK5XMbJ/I6odUvrmFKLbGugY1AV0kHWsprdxXw8UYWGztE6j9NaoTXFIPOCBJQ+aDSI0Kebhci+Gnlaml/aPaRUI9yFeYMd8G4S7aU43OJwlWtzCBbFH9Z60leMsBf/xVOVrMT+v4ClUWJcxZdtq85V8qILb1oqqFAJtVKWNt65ApfQyaBGLcl+6CZUt0rcbgclWtsEEFHI+JUjIixwIMe1vZp/1LgVX6v0rKqYfSWwLdYluSy5ANlzwZWxcuP14pA6cZPFMfSWD8msyrfC4gmEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzehTvPX+XkGWq8heLjUgxIoVQCOjdmMj+0U1Qg7rKk=;
 b=I1DoUIa5MbZ+G9GC2v0bVLIhq0CQMM9IoWfbWTpXcLTOZcET9aaQgyp5n1orQWfWyNYwsofI8DsD/O87hONihO4+ZDJ1+H/VqYaDTgAdg6aDVn0kAM84Qud7gTnhz6O9u4/FWgHJ7EHFYyXzJGmaKj9n+kdZ/5DY3EWLjoBKCHKrmhgwg9DrIqQ1UGETXombwYJQ5KS1eEYOwENebPrD+TT7hhuEBxCaJg4sFsY7BMpVvfCzFJ6dr2lcvHDlMrjSzKeYNfDsg2CFP2hkGSv1f5EoVtf2onXIxOaD7CJFg0rNalALZN89VdPApxpxwp/28QRlXWtJASSCGzt/0cWwVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6469.namprd11.prod.outlook.com (2603:10b6:8:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Wed, 10 Apr
 2024 01:05:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 10 Apr 2024
 01:05:12 +0000
Message-ID: <2d65584b-8811-4760-bd6f-600ed170b418@intel.com>
Date: Wed, 10 Apr 2024 13:05:01 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: Xiaoyao Li <xiaoyao.li@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"srutherford@google.com" <srutherford@google.com>, "pankaj.gupta@amd.com"
	<pankaj.gupta@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Wang, Wei W"
	<wei.w.wang@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com>
 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
 <ZhRxWxRLbnrqwQYw@google.com>
 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com>
 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com>
 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <44af8014-f73c-4ef0-9692-07e8df18fe24@intel.com>
 <99144e08-7852-4aef-addf-2c031b6cc62a@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <99144e08-7852-4aef-addf-2c031b6cc62a@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:303:dc::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB6469:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bptPQ088GqLs6nYaWYQrvEoxeF4nNykcfmrqckOgCFFSZc5mNb79rOSgHUxuG94FrqOdf1JUVdU+JeyZm5G3eTThz7Op1VPu1u61iJxq9jDAqUfddCHwOIDX663kHT36RTeGLw3BpU+JnIng6Y419uWr1CIuoW2VDDSQ9t7X//RP9C+FxZ5veFIZDXSrI/fKdT+o3ITzbMl3GsahbNQK1Vz7dSVkx2yNyRFjqMWOcBBYXvX2Oe7ZNWYQ70yfEPXz0Cd50SgOyolduvq/zsfSgvvb7i9nIBOjgGtGCm8Ar1mUYzcLUYZ6wsxGMOcW84sqS1cLMiYo0LxK5mIOzYJzAtUDDZVvw+SRhmt/Rd9tCZLMB9DrvBpJG5QlGMQ9lich6Y+VsbY6qAYa3qDKJEQYMAgjMbcpJBXVOp5bRLDw/0xqpWJc60a62b5/aLf3R6FOoC8rTeV6bHG8JZAXZI7pOCAViEcenAy3+qYWpwusMYVPczxqMh9SuCjfzBO1iq3Rx5WX72vmsxP1O6DdZ7bhY8SsgWwl80Yjv8epqDuulMXmT7dHfE4gN8qibqAtEQcE+5mEmeoU7vX8K0XwhYXZxxb/stSxzU69ewKD8duCp4ngrvMuC8+RfVrcKPSigjl5BCXFuoZ38jfx82xcd1RSomcJ/TVrK50Qehg8wGPCS3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yy9maFZMRDRxUFE4ODlRdE9GbDZ4N3lha2phWkMwQXI1cGxZbVVjTUJna1Bv?=
 =?utf-8?B?Q1FRWEpQZ2crQUFpNnBvblQ2Q094TC9RVGFKZEJjUmN6R1pxVUErUkhSSjg0?=
 =?utf-8?B?MUF3N2dsMW83MncrcGJGSUhobUFjUCt1UkhJMlNrdEozSHdBUFpNZjMvWmJI?=
 =?utf-8?B?SzJaUmxpRXIxSmRvR1JrR1BLSmdkZi94QWF3U2JRWnEvcUhqRUg1N1d6TjZo?=
 =?utf-8?B?dWp5SzZMdWQ4SG1RSzZuYlpxdTA0V0lXUkRKSUhiTncvdCtDQjMyUGQ4YVZC?=
 =?utf-8?B?Z1pxV3ErZVgwL3pWWEJneEFoTUVtaHdYWHlvZTBIQlhJMURCVENZMS9OS2RK?=
 =?utf-8?B?Y3BidllZRFhuTFFrck1UQXRubzg5Uk1sdXFtS2xHMEcwMTVHK25Ia2t5SllY?=
 =?utf-8?B?ZDZMUWwxaFBoUFBtMy9kMDBhZlNHZjhiTEdkd2s5ZG95cStUN05sOGdyRTly?=
 =?utf-8?B?eUdkeDY2TU9zK3U5UFk3bVd4NC9lRER0Y1dPVDVDNGlabFNqUGdyaUVzY1Nn?=
 =?utf-8?B?OGs0T3FDU2tBcVEyaGo5aEFpVmwwQmx6M1hRdFR6K0x6dHhkZjNGK1FGZXYx?=
 =?utf-8?B?SG1YcXVoUnk0YTN6cnFYdnQrazBsOFVTSWZoK0NHL204eDIxckZjYzlCQnQw?=
 =?utf-8?B?aWRzdWJ4d3c0VU00dzhNYk1LUWM4TDg4bGRVR1hsSWJwTWV4ZExpaDZEVnRB?=
 =?utf-8?B?OXNydUtXVjFUcUY5aDhSVXRMT2ZZVGhkVVVubUpkZzdUOGxNK3hnK3d6Z1J0?=
 =?utf-8?B?c2JUNC9jTGVGaDVRVzBlZ2xFeDM5VHljRVV3dUY3UDFnTlB5OGRtdTRVYXZn?=
 =?utf-8?B?RER4UjJKaDNEZWlVMDlqMDh6SjdRNXJqcmJlQVhBamFwK1VNSW5WaS9VWFdm?=
 =?utf-8?B?djZubTVVcHRmMUt1eWZUS1Z3V0haUXZqanB2U2hkd2JEQUo5YTRmaUQ2dFRM?=
 =?utf-8?B?RVovY25ld2lUcVlWS3V4WGFZSklJcHQxR3lqdVRmU2wvL2lYN2FPMXRJVll1?=
 =?utf-8?B?TWFRTlAxNDVzMmdlbnovQnhTR2VjbVcrajRoaHYvb1RHcVNiOUExS0s3bXFQ?=
 =?utf-8?B?ZE9PVEtPaE42VEEzVEU3RW5aVmVmUnB2SzAwL0htbGZrNHVNT1RFNE9pZURn?=
 =?utf-8?B?Z2NxWVc2N25NTytORkphaUEwUHltZXdLREkyVTJSKzBtcENoaENuSkIvc1Z6?=
 =?utf-8?B?eXNieFJkQzdXTHNSQS81RnpPNUZ6OFNnS1R1RkdUdlJ0Z2FWZDVub21yeFpW?=
 =?utf-8?B?RGNzY3pVWWJBOUtiNjRheWZSQU9pVWIrTExXeXhUSk90MzJzVXc5d3JmOEd0?=
 =?utf-8?B?N3FkQzJ1bHVCczRKa1huWHIxVkdHRlJhcnhOcU1sN3R4aWh2VkNYS05DR1ZN?=
 =?utf-8?B?cnlpZ2dtc1REN0dyamFFbExjK1RicHNnT3pNUmlad1pnWTJtUkhkaHB5QlVx?=
 =?utf-8?B?VHZVYnVtTkZDMmdCYmxZNmFYd0hZN3BjckNPUERFckk1SitNRnNSSlcwTEdZ?=
 =?utf-8?B?MlFnWmJoeFhqV2RWOGtKY2crM3ZMOHJ5a2RJbW5KdStYS1JSNnpVSWRzYitH?=
 =?utf-8?B?Q1lDN2dlL2R6a1l3ZjZ0cS9pcDJacC9DSTNGOFpoWXgrM3JMSVFCM3hKTFFy?=
 =?utf-8?B?blIvc2JpRzZDYndCMVBzVnN1SmJTUnBaMEFWVTROVzdia2V4Mlc5ODJHMkh2?=
 =?utf-8?B?TXVEZ0U1LzY1eHFxb2pmTWo3a3dSZm51VEoyRzdPYXF2c2c4N0pxMHRFOWRh?=
 =?utf-8?B?UnR5L3M3WkllS3NDcE9FSmRlL2ZYR2Z3QUJKb2FQNi9zY0NSZEx6UjZjbDFo?=
 =?utf-8?B?a2hqNmpxelNKWXNyWHBneFRSbFVXRGZETXFuUkxYazlYOVltZWxrc1lBQnlS?=
 =?utf-8?B?cXFOT3kxRVV5WjFYZ3BTZm9WOEt0Qkt5Ri9ZdVh2dFR1MHc4UUtqSUpPbmZT?=
 =?utf-8?B?eW40UnpKK2hLWTU3WVhRTlMrMk9DUFlKL05tNS9DMHZ4VUNxWFIvbWNtNDVP?=
 =?utf-8?B?Q3VJY0xpVUFQMVZpSld4MzBubDQ4VVB3UnFzNFFqUGNDOEwwaU9iNHNiTHhF?=
 =?utf-8?B?Y0hEeFdDQ1NEUFVjOENMTGsvenkwZkxJVmJNV2o0MmFhWExWcXdFaFlHTmVr?=
 =?utf-8?Q?UIWlyNP/PFJPHRgo22IReVY1U?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a047b8-899e-42b8-b27d-08dc58fa464f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 01:05:12.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9daG6cE0Slss856hYc4p+AZl1DZYyCL7y3OQMJtS1S4P0TLAEj8piaqLI6oL7TZ6zNh0AvqkC7xtKgDtwdGvFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6469
X-OriginatorOrg: intel.com



On 10/04/2024 4:18 am, Xiaoyao Li wrote:
> On 4/10/2024 12:13 AM, Xiaoyao Li wrote:
>> On 4/9/2024 11:49 PM, Edgecombe, Rick P wrote:
>>>> I don't want JSON.  I want a data payload that is easily consumable 
>>>> in C code,
>>>> which contains (a) the bits that are fixed and (b) their values.  If 
>>>> a value
>>>> can
>>>> change at runtime, it's not fixed.
>>> Right. The fixed values have to come in a reasonable format from the 
>>> TDX module
>>> at runtime, or require an opt-in for any CPUID bits to change in 
>>> future TDX
>>> modules.
>>
>> I have a thought for current situation that TDX module doesn't report 
>> fixed CPUID bits via SEAMCALL interface but defines them in docs. VMM 
>> (KVM or userspace) can maintain a hardcoded array of fixed CPUID bits 
>> and their values according to TDX docs.  And VMM needs to update the 
>> fixed array by striping out the bits that are reported in 
>> TDSYSINFO.CPUID_CONFIG[], which are configurable.
>>
>> If the newer TDX module changes some fixed bits to configurable bits, 
>> They will show up in TDSYSINFO.CPUID_CONFIG[]. So VMM can update fixed 
>> array correctly.
>>
>> In fact, this is how TDX QEMU series current implements.
>>
>> However, it requires TDX module to follow the rule that if any bit 
>> becomes not fixed, it needs to be reported in TDSYSINFO.CPUID_CONFIG[] 
>> as configurable.
> 
> If TDX module flips the bit between fixed0 and fixed1. It doesn't work 
> neither. :(

Exactly.  I think we need to ask TDX module to report such information 
rather than depending on some JASON file.

