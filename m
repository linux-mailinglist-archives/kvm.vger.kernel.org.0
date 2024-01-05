Return-Path: <kvm+bounces-5707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C69D982508D
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CDEA1F23A89
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEDF22F0C;
	Fri,  5 Jan 2024 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OPHmylR4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDCB225D1;
	Fri,  5 Jan 2024 09:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704445519; x=1735981519;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VtKiolryq0Lrptr3y5K6DrUeCq8eQ0O/34EOG+JQzVE=;
  b=OPHmylR4tgAUbzkTGW1D9W8OpQcBgA/4bCsKOCj9AFG1+22wV7IQVujF
   qclgNMFa1AopGK7777iAoAHxix0z0NMhfXUD2osufqv7K++KdnPmcAD5X
   2BfllBabRQBEO5C6MJqrprnXF26rwkX6hjW/PyUfwg1yQzg0RUScpfOQ1
   DDbSFh1lEI78A+ClWC4leBTqS5w3oKeCfYkQg9UfPnf/ujz2ufeARYZJ8
   UyegyRYiSzRA6LBunFqZm34rqF7tj91fUyZq6+D5MvsjSbeYVhTCW6+1i
   mIi2pFMJiWHYwaO08hMdS7NUeZf5QYdSKp+Nyy/TaZkoiIx6T2Di3Xn/g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="463863057"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="463863057"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:05:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="904100298"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="904100298"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2024 01:05:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 01:05:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 01:05:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Jan 2024 01:05:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Jan 2024 01:05:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CO3ljawGyjlBPoluyoEU9/sMNF2EvKoIfUeiDRAT0JxEZLXDpyKyqg7CJYBbwEMOpjiFGP6YMEcOct4YTP3JDQ6JPZhTUpDY0QWyPo0iAS4HoBmiRP99haduAXP2/07f761BqaLBY/msXnEBgWz/FvMP/FgHLE4gn1IfNSHxL+38fl/pDYBR6vwDc9yKZDUrsyhqDneyZjWpn4vYkIgD8lHNVPaNA7CkJaBTSL8vauT5Yk+WJHTDzlYkOZbjNfAf1TrqDXHqXUgVWwQ7JXLzJWLGNz+UDrVJbf+A2/69OlzEivHMqJEnPMr1jgDkRSXACXI+5eNBmsBnWRbVS0WWvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIJfLWn0IWaZ/XTGP25zwyt4uqfCNGb7aXzpxl+1vr8=;
 b=SFGMMceLK5DkJerFCUQBWNWVRFZMD4q0X3VHlAovKVnktmEt7DS9EzQ9Zijwj86Jc90dadPWQTTXCD/hMNqyCmeYIvn7gtS9FCNQRdTDePuONY3PhGX8f7UvkcKvbQxjCfmxzfag3RQbG/uSMV7RfG2tWbpeYNqSpSseON+c2GdvBvFnksiraXIojxWB3c5noX6EyFG/15K8FOHqa8+GsLL9++na+L7cxN/UbUnz3e7ZsbQkLDNG0Tcdj5U3SyCfKLKGnD1/gnkws9wYtT8XTDZqd0kaTOnuhY7JiNN128VCzsVx6Gt8g2ewBuwkDXGTXlIFZFvnHPKncY9XaaoowQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB6742.namprd11.prod.outlook.com (2603:10b6:a03:47b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.16; Fri, 5 Jan
 2024 09:05:09 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 09:05:09 +0000
Message-ID: <35ab017e-bf9e-479e-8f06-06f12ba85ec8@intel.com>
Date: Fri, 5 Jan 2024 17:04:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:194::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c0a4328-c78f-4352-0997-08dc0dcd6a9c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJCJ+BJ9xQ3HkNW1AGt211CNkqM8TKpOebTLkKIeXl+v5RGQZ8aNRDFW+yQ3p1XkzFyfH7rsQE4ovhkQ3yr1TJzIVYCuJVkahks23hVEtpVEVtyy+3aaPjuEzQHvl1Tk5GA1UTdIKmBN8UC6Tsvh4SdPBmrmTSY/iZCyA3uNEqClG6ZAQT1xeQAm3T/1r1o8D3sunCqHoYQeFdmMcMYV09fuQS4CeBiLu10DOYK78Vr0yYyFyvEEhwqA6Jk/foBnATYTwsz6qoAOJVMPZHJEY1uNUh8QDZJ7t0QAlHOH6M0xl9p61y0ErKP6bCNmrgSoQmtQogW+1cF747+iY6lMp/vRBzXNJgSGlorOY15xPBx1AJFxG7ikonkpqAVlbhTK1efrRx5SM9mgykp30N+D3PlulgqdcYCfundMTS4rQc3NBeTUeOcmBmI87S9mTGmwXEfUy+UHTaauUhmveqFUx9IDHdUF37AvJ+jRp4URlYb6QVm1RtBjNZN5jJ/P1x4XOxsIJWcJjS5rH5qGF4bPh8nvOFeqlye7trykfrFpXKhqd70zeWxSHLTQ9t/lskEa3vom5Za/C4wrI83qIa3K7slAWJSx6PJAcznK5nAK18zprP28aZu/yqyYdcQUGm3tkn3DcZpiF4H13UA9Ltq8lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(376002)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(31686004)(86362001)(478600001)(53546011)(6512007)(41300700001)(82960400001)(6506007)(6666004)(31696002)(2616005)(54906003)(37006003)(5660300002)(2906002)(6486002)(316002)(6636002)(36756003)(66556008)(66476007)(66946007)(8936002)(6862004)(8676002)(4326008)(38100700002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzJzcTBacEF3QkpCVU9rVVZrZXN1NlExeFYzMHpjL2NUa3AzcTZUWjF6TFhr?=
 =?utf-8?B?akRjZFhDZHI3OHRQTHdoRVBnYjRJaFEyZWxCWjJzdkpQcGptK1k2L0FLeFJH?=
 =?utf-8?B?RFdsdU9RRmFtc2kvZ3VlODBDejF2MjFoMmdQS0VaZ1YzMDUzZTBiQitpNnBX?=
 =?utf-8?B?VTRrSVVwd0RrdkdOUlU2VjhMVDVuY2o2azUzbkJ1eS9YMlNIckorWGRiOHdv?=
 =?utf-8?B?cjkvajB5SVBMQk1uOVdETVNRSzFwdDQ2YU5vNzVHbjI0MW1jc1JsTGRTOWx0?=
 =?utf-8?B?Q0dIRkViQlJJVXNwNmN2RWszUjVWU3l2TFJiaUp0c0RhVFlEQ0MzK08xWUtM?=
 =?utf-8?B?eHdYaVNiK1Vxajd4MkE0TElCMXNEMEM0bGVnYjd3aGhpU0VsOEtLVUpqQmZO?=
 =?utf-8?B?ZXdhZjlaREtLMTNqY2dCd0RicGxkWnlpZWhMNUFuazdidUVrd3NBNytSUkhx?=
 =?utf-8?B?d1cyWVpLdG9oMTZpZzJ1NUtzakJUUks4ZWtJM1pwamFqTmlpY1dIMXd5bkZx?=
 =?utf-8?B?c0tUWmM4OEsyRTd3U1RvTnZVQ2ZMemNMZVF0QjBFeEFxVG5hWkhhQVdmMS9l?=
 =?utf-8?B?MjFuaEdxWjI4Vmt2dll6Z1ZOcklaN0RKYS84ZW1aWElxUWtJVUhwWnhoNjNV?=
 =?utf-8?B?MVBQVGxURXVlVGF1bjhZY1hjODM3dWRkYTd6NUF4MlE1NGY0MjJBY1J0ZWhs?=
 =?utf-8?B?MDJzWkZCOERSTVh6ZjVSenZSMkRKMUFJcEJOSlpJdHdzMkE1cXExdHdqMnJK?=
 =?utf-8?B?U1VlOFZ2WDNiRWtmQ21WWnN0cVRBdytaRkpxR2FWMExpUEdaeStuUzgyS2pW?=
 =?utf-8?B?ZGJlVWlNTGJ5SGtGSklORUc0L2tvQkNPbThBRndJS0lyRVlUZ2tGVTlleFQ3?=
 =?utf-8?B?K25ocmY0ZTVHZG02YVlxVDRNeXRtM1pmM1NCWUJHZERmYjhQWEZuTkMvOHFH?=
 =?utf-8?B?VzFUZzNSblVmZWlFMDErb3V2eWVGVlVvcWNIRnhEUmMxdlp0bUlESkZVckFP?=
 =?utf-8?B?ZXMwamI3MStTb0VveWdVNGVyMmtxU0JhOGhNZXkvdXZnQnlNMmpib0xmN1h5?=
 =?utf-8?B?ZzZwOHpla2NnbS93SlFWaXExNW9oanBpaE9GdE1xS1c2MzkyTEdtODBnaHpS?=
 =?utf-8?B?SUJWcnBTakpVUG9hRHBCT3VudzVGdW82cUVNcDNiRjN4dDV1dGVDWlNaZElW?=
 =?utf-8?B?cFJvL3h2TWtqSFFMS0VrclpmYTlMa3d6WVhtVndtVURoTlpyMFRvUTJNcTdx?=
 =?utf-8?B?Sk5DMk5uWThkN1c4SGY5V0tEcDhOSWo4QnI5V25jc2hjbG9SaFR0SEZEcVp1?=
 =?utf-8?B?RWRvWmNuT3Yva3VDQWM3WnE3V2NvNHlub2dHUmpMaytxWGpFak5Yb296SDNF?=
 =?utf-8?B?RlpRd0d6WG83eHRhRVliZkJRVFlwaVNOTHF3aHJQZU9uVDA0dzl1a01GaHEx?=
 =?utf-8?B?bFZ0SDh4TG9UQURUclpkYVhqazZIc0Z0NmkveENDby95OGdFUmZHTVVXenZn?=
 =?utf-8?B?VVVSZUJYc1ZuOXYxOFRZdmVWQWJKS1RxOG1tZzR1N0VHV0trbGVQR29uSkl5?=
 =?utf-8?B?MzluU2hyL1liald2citWTUZjcXc4T1Y5TkdUdkY1b3hzRllHZWh6QXdqcnhJ?=
 =?utf-8?B?QWRlcTMrZmVaM01xL0pLcU4xWTgxdVl5Rm1ESzFTcmg3RVk0Q3dKNllINHlE?=
 =?utf-8?B?K0U3ODg5dUxFWDdCRmNFTjEvQS9JS3FNa2JrWmJxOFIvb0hPbjdwWCttd0Ur?=
 =?utf-8?B?bHdGSTlNZXg3K1NnNVVnZnMvVXR4M3lrYXFhVzhNRlhEbDI4TWFYWVdLR0h4?=
 =?utf-8?B?QnRRWDZFOVlOZjV0aDVQU3B3TjV4MGJJdEduNzZyczFkd1FSZXFNNFU5OWpx?=
 =?utf-8?B?ekhHMTJwRzREZjVUZkVXdU05OVdaS0tkTk0wdGdhZUx6bXJLczFod1JpekVH?=
 =?utf-8?B?RkVLWFA1TjU1ZFFYWlM2U2tZK2ZoK1hLbldDb1pmY0xteUdzb1ZIdjNVSHFE?=
 =?utf-8?B?dmJWanA4OXppQXBIaDdRb3VLK0FoeWF1dHd2NTZ1OFY1a1dDV2hIR0xGbHdG?=
 =?utf-8?B?eHBaZGpmM3lnQVBMMTl5TC9MTER0UGZDZzM3WTZVK08vcFVUNkZwVkdWR3BL?=
 =?utf-8?B?N1ZEeFhRa0R5M2MyeHU0T2J3aisyOTlpYzIvdmV1S1JKZGo3WE5wZUVodkpB?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0a4328-c78f-4352-0997-08dc0dcd6a9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2024 09:05:09.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kO4Axn8cXGhRPDPzeI2amxCnPjQoGIiYSLiLosWxzpIwsyECVcTKQ5keBFwS1lOdCC2duIv89PMn5XSEB8YIlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6742
X-OriginatorOrg: intel.com

On 1/5/2024 5:10 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-01-04 at 15:11 +0800, Yang, Weijiang wrote:
[...]
>>> My understanding is that the KVM emulator kind of does what it has
>>> to
>>> keep things running, and isn't expected to emulate every possible
>>> instruction. With CET though, it is changing the behavior of
>>> existing
>>> supported instructions. I could imagine a guest could skip over CET
>>> enforcement by causing an MMIO exit and racing to overwrite the
>>> exit-
>>> causing instruction from a different vcpu to be an indirect
>>> CALL/RET,
>>> etc.
>> Can you elaborate the case? I cannot figure out how it works.
> The point that it should be possible for KVM to emulate call/ret with
> CET enabled. Not saying the specific case is critical, but the one I
> used as an example was that the KVM emulator can (or at least in the
> not too distant past) be forced to emulate arbitrary instructions if
> the guest overwrites the instruction between the exit and the SW fetch
> from the host.
>
> The steps are:
> vcpu 1                         vcpu 2
> -------------------------------------
> mov to mmio addr
> vm exit ept_misconfig
>                                 overwrite mov instruction to call %rax
> host emulator fetches
> host emulates call instruction
>
> So then the guest call operation will skip the endbranch check. But I'm
> not sure that there are not less exotic cases that would run across it.
> I see a bunch of cases where write protected memory kicks to the
> emulator as well. Not sure the exact scenarios and whether this could
> happen naturally in races during live migration, dirty tracking, etc.
> Again, I'm more just asking the exposure and thinking on it.

Now I get your points, I didn't think of exposure from guest and just thought of the
normal execution flow in guest, so I said let guest handle #CP directly.

Yes, I think we need to take these cases into account, as Sean suggested in following
replies, stopping emulation JMP/CALL/RET etc. instructions when guest CET is enabled
is effective and simple, I'll investigate the emulator code.

Thanks for raising the concerns!


