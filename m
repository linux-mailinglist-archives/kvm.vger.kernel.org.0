Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57C176486E
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjG0HXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjG0HVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:21:04 -0400
Received: from mgamail.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB97C49DE;
        Thu, 27 Jul 2023 00:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690442055; x=1721978055;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YclKqGnfq8l8TOrbd3Su2cvWlErnvTNoEnRn/stgbmE=;
  b=VQQgne9C1x8/s6Bx2KlMhR9+kjmNck8FMIFRf/61bw7IzdUtpImj529M
   7XlHdYXbwi0A/eoPxe6AX/LcaTitWAitoxf5CayRCqdJW1vS9xEZddRfi
   iDUiHgdwXnxf0AJBUFGU7cjES21anXixnJRgfUm7KrWJ9w1t6+umdcxbW
   1Zb+MpHif4NNelxhHNDHwf+p0/zf1ZyB69os2BYV8DSAdIdTLgDNj8ekg
   53uVO0Jd2Uz6+9Ix+QPEdtV+uRIqXLL1VdvMrSrUTU+dNY+BQ/ETVJY6Q
   xNFLb6svJOQ2AmiMdXpvmTqj1E6WfhMchJoNCjkWPR+yVs+NX/JEi7Bvi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="367101372"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="367101372"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 00:10:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="720785295"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="720785295"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 27 Jul 2023 00:10:58 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:10:58 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:10:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 00:10:57 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 00:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1lpGhq+JNwCL/i+dTuMQY2nllVzwMnx3ByJvzUWz5DBDsf80VO/N5jJOgbNQjNHGxBChg6bPTP0DlWFrf64WnUb247dSTtsurzZPqmhs8Lbn4i6fI+dtm9IbQ6z0wEC4QgnayDwavetT6BGSflHUizQEzQK+awwCKJOpgiyF5TQ42h6DItjCR1tTNP5M32nDjMNZ/f1tJUpMJPKhW+IT73DimoJMkBSvcePAvEme7HEUqJH9v75guEL5x4K+DlaV+njlcP6xkC9UK86JrSbG+2G/OzVOQOsZtkqnTZ6CXhwyffL/6aUTLL9qKTlKgOw8iU+zHCYRKf9VySbO7upRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5lAc4liUsJjCT4C3MdQxGftWb1RJhpbl0KYYUZdq2Y=;
 b=XMzVi0MVYBO2Z/c8TnaCwwt3d4XHzF/Ry/whfrUVOYKezlNRse+RHBfuq2TKP6038W0GhlKTmn1/CW3NrU0nkKJ8EBNkhDLGChcJkSE91E4UYP9YbI5suniOZ58EhwRHCcFRrVKY0tQ69rPBkzqwgcT8+fEomohSgTxuYlsYsXJJ5RhU8PIkqgk19avY2EwwECRF24W2QFIaYi7TDDhMGHkgmjoaXpBFq8wNvio8VqngLE17JqNRi10Do0mYjBob9g+uLeJtPfksIB2xAFWeIxqqN/RrK976/ReuSJmbUTlvTSQLVZ2fcJ2torq8C64Rv30N+qi6X47zQHBi0sGP1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7066.namprd11.prod.outlook.com (2603:10b6:806:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 07:10:47 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 07:10:47 +0000
Message-ID: <2801b9d6-4f32-c4b2-ae93-c56ffc2b4621@intel.com>
Date:   Thu, 27 Jul 2023 15:10:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-14-weijiang.yang@intel.com>
 <ZMDT/r4sEfMj5Bmu@chao-email>
 <3d5fdd07-563c-6841-a867-88369c4dbb36@intel.com>
 <ZMH9tIXfPk0dl7ye@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMH9tIXfPk0dl7ye@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: f8ef92a7-199d-4627-f42e-08db8e709a02
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvAaAFJhApO6JYtUMDt1GxocT5W+3cplHB4c1IJ/UTKFMHNEh6Mx2OPnTKnrFwGrEEH6AX768I2T91ImPulUEtWwOF4IxXjFCFnERQVYhvuxNOpmrRMkdwFGpFcdvF3pje82wdNqbOAESWCFE6z/XVrp58t9H6HAQDd/JYrY0kyz0sTmy4vrW9Mxl5OeTApwIhOEmk2+pbW6vNKzOPhfmVZACTkhLsq8EopzFsHBmJ7iKX3KhUZ3Xs5pj3TfQBeMtvdAWxpOuzqRZpdicOnK5UpL6qKpjrNDWDuGoUCxQuiEl0/rL/qedCvRwFXsPXje32fyEbGZP4Rtw8rEhOfmM4Zekg1Nx/42akimoDjIsdu/Kzx6xi2DOCvctGtvclrbqh6SPK9NR3w2Vg+Kcy/y21W8mGq/2Q/ljFNPoxKO1D4nEhIUCcOHHjMjQ7lmY9+/kUCVKkZJQP+Daq+li0H/ALYDMetzwl9yLFkM7PCkSBbkLERET+1t4h/S7IQz1d0o4E7wjNVEw43f0bDEeKLN8WQsaAeLeE64UjQvSfeQjsp17oLmmZ9c1Kza/Wl8ZR3jxEMWLBFgfSOPifhcrsMNlW3GmVSqTh95IB6FMDQGPYWy+Fd7kCBkOWBrqAGf0gqlXAxnRdgZHK3QgGNdJtnI+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(31686004)(6486002)(478600001)(6666004)(6512007)(37006003)(31696002)(36756003)(86362001)(6862004)(66556008)(66476007)(2906002)(2616005)(186003)(6506007)(26005)(53546011)(4326008)(82960400001)(38100700002)(66946007)(316002)(6636002)(5660300002)(41300700001)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXUzdkd0OTZ2RVRWQjVPMnhKRWVIbTk1OEgrSWwzUzM3bWRUMTMwbXR0OWk3?=
 =?utf-8?B?SEZsTytsMmh5amtsVm93c3FJenZROGIrZzcvZmVNRzNEOFZtdkRkVDFGTU9r?=
 =?utf-8?B?aGJMNTRJSEw0OXhGTHh6OWdHR1RlekEyelVXdWI5Z2RWaFUrcEtWVERqQUFG?=
 =?utf-8?B?WFUrYmt2VmJGS0RNT1pVa1djSHNKb1V4M2VYV2I1L1NsSkVpSmhyOFdYYWtD?=
 =?utf-8?B?bFcxeklFbHJmci84RkFRbnhWUFhVNzdPVjRTc3JOTWFhdmdKaWpUNkxUeVY4?=
 =?utf-8?B?cXlyT3Q2YU9ScnZLcjB3TVNhZmJzK3oyOHZ2UTBFckZUK2dhOGMxNWNhVHV4?=
 =?utf-8?B?OVZJdTJlbXJjT3JKRG9tYlh3ZVdqN2NNTWhUbWNYR2VsUDZFOERUU0xZYUh5?=
 =?utf-8?B?L2svTXpRMDFwQzBnakxDeTVLU2J4SHRKQ1dtNGk2S2NLOWVTdXNXck1tcTJv?=
 =?utf-8?B?VHNnbHFlYUtMUWhtK3o2aVpiZVNtb1NhdURaVTFncE5ic0k2bmltRksyWU5Q?=
 =?utf-8?B?a0VsRE53NHR5ejA3VkJKTzRFT0NpOFA5ekZJNUk3b292RWtuRzBKby84aSs1?=
 =?utf-8?B?NDJNZlhobkIxV3pka0o2TUtOa2xqeDVmL2hvU0I0UGoxRFArNVliY1NFSXpy?=
 =?utf-8?B?QnRodk04clN3Qi9TSllEc1pMZmxTRmZ4eDR2SHpxaEcrcXQ0N1IxL3Z0MWRv?=
 =?utf-8?B?OUdTYUNJdmlmVElSbDI3Q3lWN0JaQkNWdWJSUHMwVU9sd0V0US9PVzF6ZEh2?=
 =?utf-8?B?a0RaL0FGYTBTaTkyNUlFUHZNUDVWRzQ5MUlCdU5BOW5rZzdDNnZBSjkxTncv?=
 =?utf-8?B?Wm52dHpKVXNzVGE2azNXZEVESGNxcHRJd0RUbnZXU2c3VmJUUEUrcll4VjFD?=
 =?utf-8?B?NE1FNXdMbURMdmE0aHFuSU1lN0dYeXZZekN5cUtzNXVGM2VZdlZjTWVFbERY?=
 =?utf-8?B?cFRGRDZHS01XVWNMK0hMNGRwdm1mSmRieDNKb1VSdERZYitEMDRWeHdhOUQz?=
 =?utf-8?B?ZXJpSFVsWm1zY3NXZVR6SWtpYUFtVFlacUMrSnRGSElqQlhEOFNmamoxVGVL?=
 =?utf-8?B?d252RkJYMERXZVNGWDFaQm03Zk5MMnlhTzJjRXd1WVIxb3VlTWtwM2t1VitU?=
 =?utf-8?B?RDRJL2loeXBnVWJROUF4eFJXcXJKLzUwOTh3VEZjRGxuUlhyK1FkNmk0OTBo?=
 =?utf-8?B?eTA3ZzZHUlJkUWtWbXdhaHdUSGhRNWE4alJVamZiK3pKYjYwdDZ0QnZBdVQ5?=
 =?utf-8?B?cWhpRzJsQWgvOEx3eU10S0xGNXY5TkhNTW9DNmJ2VzBVUmo4RkV1UGtocStJ?=
 =?utf-8?B?dk1rYklNL09tSUtLQzN4czJRd1U1S3N6WGVsTkdUZGh6Vzl5cTdZUEZQeHAr?=
 =?utf-8?B?OEZWNUkxbngyRTFOdmhOZ3dXWnFGeUlxNzBxNE9UNkprL04rdndYc21KOEtC?=
 =?utf-8?B?OG5ET0w4b0U3NXN1Tm5XMVZQRzBzQVA4UU1lRDRWWVRHUkVLYU9qejhJYklC?=
 =?utf-8?B?dkZlVHFpVHRqQ2t2SEcxeURQMXRjb0dnZ1B0N1pmZTBQWW1leXJlbVN0U3Zv?=
 =?utf-8?B?RWplZzhES1dTVTgwMjBSZTNoYzM2MjhrN09JSjdVVHlFVXIvTVRBdVllc0tE?=
 =?utf-8?B?ekoraXJtajc3clNNa3Z0cFhCeWJLM3lyTTBtelZ0a1N4aTNVeU10SmRYTGN4?=
 =?utf-8?B?UWpYcmJOcWlLRjl2TTdUNW9xUXMxWjlMSG9rNkxHUFFDOS80TUw3TXdxcU1Y?=
 =?utf-8?B?R1FZc0xPdHRBNWRCak9LNW9LNjNtRjJIdFRGZUpDVlNMQWpKZkdLQ0s1NE5U?=
 =?utf-8?B?TVRlR055dG52UStTdWdYcU96M3NLQ3FQczM4d2pVTUtZVHRTNmM1aWRaZlMr?=
 =?utf-8?B?NjZHOHZUYk9lb3ZDRDVhT21tOXdmNGFGck5kdzdzNzBaNW1xZnNTbGNDcGZ4?=
 =?utf-8?B?WTNDSXd3bE5FQmlmQmU2U2RkTVU5VTNCUkREdkcrVVAyRzRlZHJvRW91MlZm?=
 =?utf-8?B?QVBHK255VHdOS1B1cjZXZGFUZDhyVUZlRzdpQVNFMm1NSTlvYkEycUJwK1Vw?=
 =?utf-8?B?N1VUK3E3N1RzVnhBN1NOb0c3NS9IcytGK1pnd29wSG1FNXdzUGc5NDlxSnhn?=
 =?utf-8?B?VUJwSlNEcFhhbGxBM2hqcktCSWZCYUJRUmJBd3ZzZWprN002bDczamFSbWY5?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8ef92a7-199d-4627-f42e-08db8e709a02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:10:47.7299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqIhwaqxc4iO8wz0rK1ONDsaz5A9etP3/FStFy0KmysKqf9rB2vgtOq/A5sw2dJcfsQJC5G8fOkPhiq3OFQHBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7066
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/2023 1:16 PM, Chao Gao wrote:
>>>> +	case MSR_IA32_S_CET:
>>>> +	case MSR_KVM_GUEST_SSP:
>>>> +	case MSR_IA32_INT_SSP_TAB:
>>>> +		if (kvm_get_msr_common(vcpu, msr_info))
>>>> +			return 1;
>>>> +		if (msr_info->index == MSR_KVM_GUEST_SSP)
>>>> +			msr_info->data = vmcs_readl(GUEST_SSP);
>>>> +		else if (msr_info->index == MSR_IA32_S_CET)
>>>> +			msr_info->data = vmcs_readl(GUEST_S_CET);
>>>> +		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
>>>> +			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>>>> +		break;
>>>> 	case MSR_IA32_DEBUGCTLMSR:
>>>> 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>>> 		break;
>>>> @@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>> 		else
>>>> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
>>>> 		break;
>>>> +#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))
>>> bits9-6 are reserved for both intel and amd. Shouldn't this check be
>>> done in the common code?
>> My thinking is, on AMD platform, bit 63:2 is anyway reserved since it doesn't
>> support IBT,
> You can only say
>
> 	bits 5:2 and bits 63:10 are reserved since AMD doens't support IBT.
>
> bits 9:6 are reserved regardless of the support of IBT.
>
>> so the checks in common code for AMD is enough, when the execution flow comes
>> here,
>>
>> it should be vmx, and need this additional check.
> The checks against reserved bits are common for AMD and Intel:
>
> 1. if SHSTK is supported, bit1:0 are not reserved.
> 2. if IBT is supported, bit5:2 and bit63:10 are not reserved
> 3. bit9:6 are always reserved.
>
> There is nothing specific to Intel.

So you want the code to be:

+#define CET_IBT_MASK_BITS          (GENMASK_ULL(5, 2) | GENMASK_ULL(63, 
10))

+#define CET_CTRL_RESERVED_BITS GENMASK(9, 6)

+#define CET_SHSTK_MASK_BITSGENMASK(1, 0)

+if ((!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&

+(data & CET_SHSTK_MASK_BITS)) ||

+(!guest_can_use(vcpu, X86_FEATURE_IBT) &&

+(data & CET_IBT_MASK_BITS)) ||

                             (data & CET_CTRL_RESERVED_BITS) )

^^^^^^^^^^^^^^^^^^^^^^^^^

+return 1;

>
>>>> +#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>>>> +#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
>>>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>>>> +		return kvm_set_msr_common(vcpu, msr_info);
>>> this hunk can be dropped as well.
>> In patch 16, these lines still need to be added back for PL{0,1,2}_SSP, so
>> would like keep it
> If that's the case, better to move it to patch 16, where the change
> can be justified. And PL3_SSP should be removed anyway. and then
> "msr_index != MSR_IA32_PL3_SSP" check in the below code snippet in
> patch 16 can go away.

Sure, will do it.

>
> +		/*
> +		 * Write to the base SSP MSRs should happen ahead of toggling
> +		 * of IA32_S_CET.SH_STK_EN bit.
> +		 */
> +		if (msr_index != MSR_IA32_PL3_SSP && data) {
> +			vmx_disable_write_intercept_sss_msr(vcpu);
> +			wrmsrl(msr_index, data);
> +		}
>
>
>> here.
>>
>>>> +		break;
>>>> +	case MSR_IA32_U_CET:
>>>> +	case MSR_IA32_S_CET:
>>>> +	case MSR_KVM_GUEST_SSP:
>>>> +	case MSR_IA32_INT_SSP_TAB:
>>>> +		if ((msr_index == MSR_IA32_U_CET ||
>>>> +		     msr_index == MSR_IA32_S_CET) &&
>>>> +		    ((data & ~VMX_CET_CONTROL_MASK) ||
>>>> +		     !IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
>>>> +		     (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS))
>>>> +			return 1;
>>> how about
>>>
>>> 	case MSR_IA32_U_CET:
>>> 	case MSR_IA32_S_CET:
>>> 		if ((data & ~VMX_CET_CONTROL_MASK) || ...
>>> 			...
>>>
>>> 	case MSR_KVM_GUEST_SSP:
>>> 	case MSR_IA32_INT_SSP_TAB:
>> Do you mean to use "fallthrough"?
> Yes.

OK, will change it, thanks!


