Return-Path: <kvm+bounces-3656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F0D806555
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 04:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36D8C1F2115D
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 03:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AC1747F;
	Wed,  6 Dec 2023 03:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+WwVMUu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772361A5;
	Tue,  5 Dec 2023 19:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701831642; x=1733367642;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bI+GXWtMiNc1LQ3xNgCsnmGMK73RWZ/dYRTWx3AqK44=;
  b=E+WwVMUuocRa7HLoRU9hMmkItfx9LXO0607b/1cToFPK/8ZtxvEalEu5
   jWzk3GIt6WTvf6ul5sRi/MnCIouVI19pn9Cyjmx0US1ef9ld7JUP5Ybr3
   mElLZ0BE4l/YyK+74CYfLzFAOkQB56ndCKHfToSdJY227Xjqg5CiQ4k1r
   oOOalJV+P0HqxyMAI3TEXGpfSqzfL8tEhE015CI8fp3eRfFEDnzWq+TGe
   RtbrMdyiUrfnIH6XgwTdZEAuN0ap2VxaIKG4yuAAcLjOfOIQ6lMjldtY7
   /rYYRO/f6LEeMn676uQAHFn2XHjj43/3xClIJCjyu8gb25fxmCXcd+QKx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="458319412"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="458319412"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 19:00:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="774843408"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="774843408"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 19:00:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 19:00:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 19:00:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 19:00:40 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Dec 2023 19:00:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIbdqac1R0T1NKo6nA33Es0UDrq/cAmKXtmlPdKgFiqFDdzkEmNR1ZfPJW+lzW/4kkJlJnTQeUZjpSVkSKAJUkgR+LB6jarMV2jmJxC6HybZFokLErF/flCkhp1Dk2UusAmJJSqvpM2HPIZPt6dhLMjC/HRzfW8FMQFG8pl0+LB05SPB6AtPw+gAXdDZLJ8e3CLZj9YLGkO2RuzjYNatXThr76Ewp4rv4EEwqBT3Iz7B5H+QMNZrwy4z3TuJ57s/Mw5CzaR7xbeyYMqbVTiegY0Ag9yaa2L2yhSI4d/XhUu2Flt3Pg1Nvvk8OxcDVHZyUGmLGQ1uvUhrmAI4VlsBmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7mcpmvCU2fyK3zjauf0hSfwRqa6uSSTKg9ugVTtGZM=;
 b=nb4JFjbZCjWV1GAxtCGXH/UE7alfNwikciT8U/JUak1xIg2V7AaI9YWCzpzQ3l6MyNrRW4U+aYibAr0X5G0cXCT3QJ+I1mBpGctlM9UA1c9+xldAgLU6FLyNldSuDz+3P2D7d2/ZRbeVwG2e8MsFF4x4zFKsRN83KyLGQWLt5M/mfZjaUSWvwI7GoRLCzNMcYGcQCR9vFZb+KDCKO8oEynSW5wyoexcvWTNA2hEPe1smlsLwMUku7Xqg7MVh30uBP6PRt6tTvJoEzc+Bh9u2fcFz3CsU7ONPb4uREG2eE9SK8ET/7Zotw1WlHZZ1ksthG118F//WyiqrRTUtwH2d7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA2PR11MB5131.namprd11.prod.outlook.com (2603:10b6:806:116::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 03:00:32 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.033; Wed, 6 Dec 2023
 03:00:32 +0000
Message-ID: <888fc0db-a8de-4d42-bcd5-84479c3a8f5e@intel.com>
Date: Wed, 6 Dec 2023 11:00:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-5-weijiang.yang@intel.com>
 <3c16bb90532fbd2ec95b5a3d42a93bbbf77c4d37.camel@redhat.com>
 <9a7052ca-9c67-45b5-ba23-dbd23e69722c@intel.com>
 <5a8c870875acc5c7e72eb3e885c12d6362f45243.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <5a8c870875acc5c7e72eb3e885c12d6362f45243.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0075.apcprd02.prod.outlook.com
 (2603:1096:4:90::15) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA2PR11MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 893af4b8-2879-4637-8e94-08dbf607820a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIdzsWZEWRDo8koubvmD9zJqoyOSVoTToo5VmcSdB9qA5M444JZbuco92mF4E15n1H2JUKyzf4v0mV9ngEaa+hU18mSaRUvf3/o9UsW95BXlZfhW2pAwUMBOZCLFeXw7PcKAr64d1eJexSNwpO2hMqqQr0ZMVVyY0X4FZjaeMTVtRIhM7EC5pmRVVCtiuskGE18tf6Q7XqbPqKAw5V2UB5T0eulMZCgVS3IkB8S3tssMLL12eEGnpaqICh3v4Ij8d0dxf2OxDk5ew2lXhidm1Mwg6fHgZWFxNAiCLpBtoFHTeOCvW3rIC7eS71JcwXjor6JW1onY8cBRC+P9LacU+uae760FjCnYkRgKbZPpn3tPY/xQ0Yg4nnQRIjptsc9laplO1/k7ULBc4kPtk5vhAVT1LE/0mTOr6otiDBPMXbJH19vYLfjZSlx1DASPRur8qY0Wpu9ZqZR8djHTChreIryOFM2vCJe67FsED8RQWJ6Ju8h16uqujNCSIDL5bLHJ2XJuM+wApH5c7WaBZ2IDume+PJg0iY2YvIyHokQgt9lW4rXq8S12L2qDpHEiuekQc9RQbTpSIJleuhHM9IXmOMzQL1qrBpRn5qJ07I8zkhA5HO0nn4ZbgI5hMQbzNhfRpJeGJOQJNC+pcUsDKcczBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(41300700001)(5660300002)(4001150100001)(2906002)(31696002)(8676002)(8936002)(66556008)(66946007)(66476007)(6916009)(316002)(86362001)(4326008)(36756003)(2616005)(478600001)(6486002)(53546011)(6506007)(6512007)(82960400001)(26005)(6666004)(83380400001)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTRxdm9jbTlqSGZrdk9pTTVCUkdUUVRNenMrcW10d3ppTzRySDJIQk9Ja2Vr?=
 =?utf-8?B?eUxJY0psSkRGbzUxaXZvUjFRTk42S0JYeDlRWmhscXFLMzBqMGFzNkZFYlpY?=
 =?utf-8?B?UnhxZ29GWUtuanRRNFRKZjN1RDFZQXRrMDAzUmU3S29PNjA1cHZWYWVMVXhv?=
 =?utf-8?B?Rk1zQUhlQ2JCdFYwdHIzSHg5TW5RL2ExMDNEY1VOWEtUWGtlN1BvM213L1I4?=
 =?utf-8?B?eHJkK0tmOU9SdWJIaWFQREFGRC96bkFWeHVCbUt2OSt4ckJCOG44UlFSWTJJ?=
 =?utf-8?B?bGpvYmVXcGtHeWtHUHJGR29DVnNrUWtVeE1aemJzeVZrQkpCbFdCQnZPV3JP?=
 =?utf-8?B?UmtlbStpT2FGVVh1WHRXb2ZZQkw5NXUvV2Vhb0tCZHcxYTVTM1RPdkFqYnhp?=
 =?utf-8?B?OVRQWmV6ak1LRjJBRUtmejNYR3ExZjNzcXdPaS9NT0tiMFhuU0xPUUlZb21n?=
 =?utf-8?B?clNwUU9kVWJtK2ZoT2R6MGZUWW5NMkhxNHU5TjY5Z2pjdWZ1UHhmSkNJc3hO?=
 =?utf-8?B?WmxhNWxNY1krM0hDVm9OUG1jVFJ5S1R2L1g2VnpLbXRiQVNUZi95cmUzamJw?=
 =?utf-8?B?TG16aHNib3lJUlNxUEhoVThVbk5EUkVQU0lWZ1Jud3NsekVuTGxSNFlZVi9Q?=
 =?utf-8?B?SmhJQm90TzRXZ0ViZFB1MXpjMHV6YzRjSEFNR09zWXUrNnlud0lnbmlrYjJ3?=
 =?utf-8?B?ZTVDYWlRYmtNbXRPcGJpMEtzbGpuSEFyK1gwejU3T2U4RHFoRnZxL21UUUg5?=
 =?utf-8?B?MHNFbzMzSytsODZ4NXFzdmpVWDY3WUtrNWpESEpobUR0bDVQOEU2dDhaUm9N?=
 =?utf-8?B?TElrVDkyZS8yMDB2WmgrQTUwck12Qm10cS9yM0pqWU04SVJWcUtnZ0hiSjVV?=
 =?utf-8?B?SUwxTm96bC9WejRtcThmWldxeXkvUVB0enZLaEUvL0QvdHpqTXQvNDRvOVlx?=
 =?utf-8?B?UnMzMFFLWFk0T1VMbUtxMUJreXdGaWJlVnRhaUhRbWs5ZDVGZ0N4TXlvRHRZ?=
 =?utf-8?B?bXNYL09WcHhzdUNFZURZWHBxeEtxc1FRSnR3eEdyUnpiOWp0VW9CZE5FaEFp?=
 =?utf-8?B?cWlVclFTQVJHSWozSm1XQ01uMCtUanpQMDhhWDBJRGNwMmlQMWs2RWhkOGx6?=
 =?utf-8?B?WnB6UXk3TldxMmpiUElEeWVURitYUTBNeGFtYllLWS9PUkIxQzJ4YW1hZDBQ?=
 =?utf-8?B?Q3RqNmtsYjRKZDJNdU1JdXkvUnZMVjZLZE5weElvRjV2b2NyZGd3NnFyNTlL?=
 =?utf-8?B?UzY2dU9mTXFSTUFZSk9zWUowdHY3M0JlZkdYY2VuTSszTUNEM1hBOFpWZ1or?=
 =?utf-8?B?LzRFbVNYb3pwYVl2eFhUVDFWSVdGbGlTT0NqZXJzWk83SkRldkJrdlFVQVZj?=
 =?utf-8?B?WDhwWmlnMUNVM3MyUTM3MmFUZ2VRN3oxZGUxY2dFYVlvQWRhR2dWcFpZK2xR?=
 =?utf-8?B?bFNIR2FSUXJMbmtkSHd2LzFSN0ZSNmlpWjNCZFIrM2ZjODRvSGRDaEhGd2Nl?=
 =?utf-8?B?SFRYYW5EYnVEMGl2YjNFdmVoSzh3VUtIcXZGZEpia0pnbG4xS2JLVU1Ca3Mx?=
 =?utf-8?B?WmpxU0Y3bmJQdXZGSk81V3JIYmJuL1pqcHl3RWY1Tnh3THYzbFlpc0NSU3Q2?=
 =?utf-8?B?L28wcWhRdFJrVWJ4ZlJJdjhpeE5QUVVsRlhoZGlsU3Bnbjd6TmVuSW5icHFY?=
 =?utf-8?B?T2NKRzV4cXF1RTZyTWtoWktKOFJYYVRBNGtmQkJLYm5NRVNWN3AzK1RJQWNG?=
 =?utf-8?B?Q3l6M0YwMm1oYzJPZUZZNTJ4RnF0NTdkL0lPOGx0WjFHdHFLVjJ5Q3JXcERu?=
 =?utf-8?B?TDMzK3ArcnY3Z0tUQk4vanVFSG1TNy9SRWhIUG5aTkdzRHBrZGZFdWt0blVN?=
 =?utf-8?B?ZWZkbGx3cTRXa3REeE9yMDVlS2xzRmZ4Lzl1cjlKb2ZpdlBNU2VESUx6QVVD?=
 =?utf-8?B?WkIrQ21SRjhtelF1V1hqYU9zTmtTZTJYL1hOOFpPQjk1UG5oZWM1eFQ2cU1q?=
 =?utf-8?B?aXJwRXBOeFVjdFRKMFIzTy9sTW5COUZrNlI5NHh0M29sOXVEeGE2ZkZpWloy?=
 =?utf-8?B?Z0JHelc4VTB2Y3RXMjVMUUo5QUdSVG4veVdMZDFMUmNYNjA1R2FMSDZSd3V6?=
 =?utf-8?B?eGM2UlMrNzlLeG1ZYUo0MHZQem0zTzNQK04rcmltYU1XbnFWaUZuRm9NSkw3?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 893af4b8-2879-4637-8e94-08dbf607820a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 03:00:31.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aNyCfNxUdm58Ngn5dU46iEE/46JPVKW++OSGjqZO0XOyZVVCp/TGoMgAja5o3Hi21K4mA8HI2454n7VA+u3juA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5131
X-OriginatorOrg: intel.com

On 12/5/2023 5:55 PM, Maxim Levitsky wrote:
> On Fri, 2023-12-01 at 15:49 +0800, Yang, Weijiang wrote:
>> On 12/1/2023 1:33 AM, Maxim Levitsky wrote:
>>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>>> Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features can be
>>> I am not sure though that this name is correct, but I don't know if I can
>>> suggest a better name.
>> It's a symmetry of XFEATURE_MASK_USER_DYNAMIC ;-)
>>>> optionally enabled by kernel components, i.e., the features are required by
>>>> specific kernel components. Currently it's used by KVM to configure guest
>>>> dedicated fpstate for calculating the xfeature and fpstate storage size etc.
>>>>
>>>> The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which is
>>>> supported by host as they're enabled in xsaves/xrstors operating xfeature set
>>>> (XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow stack, is
>>>> not enabled in host kernel so it can be omitted for normal fpstate by default.
>>>>
>>>> Remove the kernel dynamic feature from fpu_kernel_cfg.default_features so that
>>>> the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be
>>>> optimized by HW for normal fpstate.
>>>>
>>>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>> ---
>>>>    arch/x86/include/asm/fpu/xstate.h | 5 ++++-
>>>>    arch/x86/kernel/fpu/xstate.c      | 1 +
>>>>    2 files changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
>>>> index 3b4a038d3c57..a212d3851429 100644
>>>> --- a/arch/x86/include/asm/fpu/xstate.h
>>>> +++ b/arch/x86/include/asm/fpu/xstate.h
>>>> @@ -46,9 +46,12 @@
>>>>    #define XFEATURE_MASK_USER_RESTORE	\
>>>>    	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
>>>>    
>>>> -/* Features which are dynamically enabled for a process on request */
>>>> +/* Features which are dynamically enabled per userspace request */
>>>>    #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
>>>>    
>>>> +/* Features which are dynamically enabled per kernel side request */
>>> I suggest to explain this a bit better. How about something like that:
>>>
>>> "Kernel features that are not enabled by default for all processes, but can
>>> be still used by some processes, for example to support guest virtualization"
>> It looks good to me, will apply it in next version, thanks!
>>
>>> But feel free to keep it as is or propose something else. IMHO this will
>>> be confusing this way or another.
>>>
>>>
>>> Another question: kernel already has a notion of 'independent features'
>>> which are currently kernel features that are enabled in IA32_XSS but not present in 'fpu_kernel_cfg.max_features'
>>>
>>> Currently only 'XFEATURE_LBR' is in this set. These features are saved/restored manually
>>> from independent buffer (in case of LBRs, perf code cares for this).
>>>
>>> Does it make sense to add CET_S to there as well instead of having XFEATURE_MASK_KERNEL_DYNAMIC,
>> CET_S here refers to PL{0,1,2}_SSP, right?
>>
>> IMHO, perf relies on dedicated code to switch LBR MSRs for various reason, e.g., overhead, the feature
>> owns dozens of MSRs, remove xfeature bit will offload the burden of common FPU/xsave framework.
> This is true, but the question that begs to be asked, is what is the true purpose of the 'independent features' is
> from the POV of the kernel FPU framework. IMHO these are features that the framework is not aware of, except
> that it enables it in IA32_XSS (and in XCR0 in the future).

This is the origin intention for introducing independent features(firstly called dynamic feature, renamed later), from the
changelog the major concern is overhead:

commit f0dccc9da4c0fda049e99326f85db8c242fd781f
Author: Kan Liang <kan.liang@linux.intel.com>
Date:   Fri Jul 3 05:49:26 2020 -0700

     x86/fpu/xstate: Support dynamic supervisor feature for LBR

"However, the kernel should not save/restore the LBR state component at
each context switch, like other state components, because of the
following unique features of LBR:
- The LBR state component only contains valuable information when LBR
   is enabled in the perf subsystem, but for most of the time, LBR is
   disabled.
- The size of the LBR state component is huge. For the current
   platform, it's 808 bytes.
If the kernel saves/restores the LBR state at each context switch, for
most of the time, it is just a waste of space and cycles."

>
> For the guest only features, like CET_S, it is also kind of the same thing (xsave but to guest state area only).
> I don't insist that we add CET_S to independent features, but I just gave an idea that maybe that is better
> from complexity point of view to add CET there. It's up to you to decide.
>
> Sean what do you think?
>
> Best regards,
> 	Maxim Levitsky
>
>
>> But CET only has 3 supervisor MSRs and they need to be managed together with user mode MSRs.
>> Enabling it in common FPU framework would make the switch/swap much easier without additional
>> support code.
>>
>>>    and maybe rename the
>>> 'XFEATURE_MASK_INDEPENDENT' to something like 'XFEATURES_THE_KERNEL_DOESNT_CARE_ABOUT'
>>> (terrible name, but you might think of a better name)
>>>
>>>
>>>> +#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
>>>> +
>>>>    /* All currently supported supervisor features */
>>>>    #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
>>>>    					    XFEATURE_MASK_CET_USER | \
>>>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>>>> index b57d909facca..ba4172172afd 100644
>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>> @@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>>>    	/* Clean out dynamic features from default */
>>>>    	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>>>>    	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>>> +	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
>>>>    
>>>>    	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>>>>    	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>> Best regards,
>>> 	Maxim Levitsky
>>>
>>>
>>>
>>>
>
>
>


