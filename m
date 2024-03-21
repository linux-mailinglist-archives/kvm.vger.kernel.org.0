Return-Path: <kvm+bounces-12444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27106886347
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8419A286DD5
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2589136982;
	Thu, 21 Mar 2024 22:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EN+em/gV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB8913442C;
	Thu, 21 Mar 2024 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060022; cv=fail; b=tE9ptzurX59MUHo14KqykwZDH8q4z1tftzdu6cz5j1gpqbWT5SO9J6DsEIA9DMwnnx935byxON64941ExrGZQeXH6Tq4VoL0e3Velio1HHd4YtoAC+1u7GCP8wUMKhJitVOW/yGEgOEjvzUw5ClS3rDqTeLXbnzhLntx0uSQ9Qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060022; c=relaxed/simple;
	bh=9QeRefiS9IKijABmYpGa6GUPZIkQQlsTB9CmbXtzW5s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AsNIVsEv9VOeBGg8BZR7fehMWowIxrFlX6nEsQ4WN3FnArvtY3kZIWajE70yk8xQWf0vFLDgvuACOYu5ElNBpx4CXo3/TqPKFezx8QV7PHxmzep0iV+bpVcjR5hDRS1+pE3g22TW9VyQkDlgBY2+6alChpacYGbim9k1nyg3ZKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EN+em/gV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711060020; x=1742596020;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9QeRefiS9IKijABmYpGa6GUPZIkQQlsTB9CmbXtzW5s=;
  b=EN+em/gVKtc3qC0qz5DiU7obbbnJkiTMJm27wHcQ5++lvvK5FaCzJqPT
   C8o/djBgTRRdLXHHJKauuvLOlkA4ulXWm32435j7YPDpB8mgc8EESkeMi
   K+Gb7v3pk0t0rA0SRan+SiqMPc+ui+NSDAwUeEpcy4CqzBBd/BsQqzGxJ
   Tbl9MDphIdaEwsSHFTcvuRthJdDritmNXQhdZWPDllZvMGxTQAiXWBTOO
   PZVZuuB9ugftCBeq/5KhuO/0S6uELp1d1hRePUZZwFojuqhkjxSvS4SZu
   3MdDloWckqtyzGBJMgUN/FC8qwqDMKgcurnyyzqMfrJ7vgdTJ/CrWJnZ4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5952869"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5952869"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 15:26:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="45663314"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 15:26:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 15:26:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 15:26:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 15:26:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEWD4r8Qsz6yx0JFcAsQCdTOUVsrzu67PPZX+6+qqabja1DzITk6Y3HxNNhgsOmVXcV3a0kNmbqtwvUOzA22SnliRaDz26xVVmG1d5ORFKX5jtpr1ZltrdoBN8gc3+xBZRIQq0Pvf7BuT8olXi6sZ1sCQ+N3GgQRcSN77ImUxrH7+SL7Y0A20w2mrKWPYn5VOHE3YTq9f31/NnYzcRPuoAvU39wKiFZwE28y3V/+I5SGc6B/oKMH7C5xy3WU945+ylJpEwJe0OSfgjpWPm0BGbcW3m0zW9lQp9mduIU7kCJPcW+he9r0ug69Um3bN/Vmug/oufyciT43LZXx6zjRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiUZL7EcXHuUslJBNtAdOq7wRhU/9mkJPpCIFQnJeWI=;
 b=WfC/5wIFZbRp4Psl6R44B3JA5fA3sciJl1NdHWmUehWnfQWcBWnysaVRwc4Zwk6HfSAuZkSSG8NIdIBGMWsRQAs+7oXi4gtTIAiVhgvH05CPqVtBhuBjFivdXMy7bMyuofE3R1oBH0DpCEr26Gj3WH5ennwgw8O/fMJJne5m9gxSOYiHHonkenETP/qc1HjgJ5MxvwccLYwYMjPyKOmkjpKWSjDWu8UxzObxITSKyHLrz4CqqJ+55lQtvSp85FYNL/o2yDW3AVwYF1BbkGpl5QJnB99ZApcecq4IT35OKOyXtSYLBU9u9c3g78g4E60GgFwLT7tIkbXJY7G6s5ylyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7351.namprd11.prod.outlook.com (2603:10b6:8:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 21 Mar
 2024 22:26:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 22:26:27 +0000
Message-ID: <838fe705-4ebe-43f1-9193-4696baa05aad@intel.com>
Date: Fri, 22 Mar 2024 11:26:17 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 036/130] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:303:8e::28) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e3e8da3-41df-4cef-1f56-08dc49f5f308
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48SGHz/CZ8l+iD4ljPSbGD09dXjCp0eZ/Uv4hOg9KLPPBkikStJsHqUZirOFa5yCtO/NTiLvKjhBRCAooz7NlBCn710jIQGaCcmVkFqaRjRDvMDKKClcDETMtYMXRcDUWn3p08OmI9RDlZSnwpVAiwa91S7sz39hx3xVDyAykerXOFWBMtOLNhf+e8I/YK5RGl5XblVRr9mvP2JNq4GRuAemjhoONzmhQT35fQ0KwUQrDFMDlt5neQpyoTan+8vUi5gOMQKxi2OqjBy7TtSgTvEJkdrX8R15Rqc9j4KyYba55b6o1hFCI2Nwv029lzlHSVNQ32YAu79ZOkVG9W4Gi2HoNg5s1VgNyJXP3OXKOTcCnQ+MU5cVz7DrgIt/xfrUYkWMIYJ3qY7c2qcTv/J5kKaeZ05AR0k7Hsl2vVbk7Fkvr0sdrGv1GFdHh3oQVmLWe2z4pncEFY5QO1QKNtB+aAaa8RZ6GJNweMNaS8i7hpL/f7ukikmnQQq2A3yRQR/TXLlwKhPGMMugoQ5YnSnqAg4T+vufijcYod8yW7ktlIzCBr+rQlPK+FhmjWekFOwin1nqpOiKsDVovazjOuG+qejWINT0diaTUgTL0eXIYmIL49hci1spZ2ubZrmwxy69ZEQF8Oj6vA+nZKJnjX0a+sJ27LEVjkDZrlLjBuwK01c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEUyb0htTDFlRzY1ZFBnQUplaFpjZXppVkJrKzFkN3lVdHB5RlZmUDZtSXJC?=
 =?utf-8?B?MmwrYmI1VWlDSWFNSjBPdzVmdk8vN1A0TmxZMlowWmFldE92SHZrOVgvOVg3?=
 =?utf-8?B?aWl1K081TDB2TTJoblFkd2QwREFHT0hoSjhlV3ZjOW9pcUh5ZzJXaXZvcEgw?=
 =?utf-8?B?d2srNFhjMWYxdFBlYXpYeDdvUStOUXh3a3ZrRjBQc2htS1FUMStSSk1GV1Ns?=
 =?utf-8?B?OGVaYTl0MGtoQ1ZCcGNvZ3kxaGZnbnJVcmRNNWtUa3N1SVFzRCt0R3lDQ3Zu?=
 =?utf-8?B?YmRHT0hyUmhva1RqKzhUcmJhT0JEWHJhUFZVUlVUZ0dLOHo3bVZKL2tiRlNv?=
 =?utf-8?B?aVZPN0F0WWV1Vk5JVnJ3UzMvU0o1U1RaQ1Z0RHljV1IyTjR3dFZPUzBRVDdl?=
 =?utf-8?B?cnZ0bXZ2eGVQN09CcFF2T2pKMzkxbTM3N0QycHRqbVJreitpaUl2UkVPdnB5?=
 =?utf-8?B?S09wSVNreTRzTmhPRVpaSmV1WGRyb0pQQjJKdGVwcXcyZHI4OUFQcmdzQ3Ew?=
 =?utf-8?B?d0d0Sk5XY28rK0VoR0FueVB3enFEeW43b2VtT0cwZlRrVEF5enBGWWRBVnFu?=
 =?utf-8?B?OU1Gb2NPb2g5VDRyd1hESFJLN3hGTTJVNWFaOXdKQnZEY3BxV0s2eWNRZkhk?=
 =?utf-8?B?NjczVFI0U29DOW5wbE94YlBQZklDWHVjV0hzSEpEUGNFS2piRDArVTRmRWZC?=
 =?utf-8?B?RTdkdDhyOGZxVXRzYmhtaXFKVlVMZis5T3pEa1NmSytON2x0VlhsRzZaUzFl?=
 =?utf-8?B?N1kyaHFUSWVaYXlkZGlVTVdHazhiRDhQRm9hcGFRRkVPM0E3WkZXZUdVQngy?=
 =?utf-8?B?T2taRjNVTTZ2ZDZYdklyemY5MUlpLytvS011N3VaVDVCbklLS2FYNktQSVVp?=
 =?utf-8?B?RDU0cWVJSVdBcEoyNU9jN25UM1FpdE5YTDR2b3h3SWd4eW9obGRnV2FBZTJk?=
 =?utf-8?B?R1dydndsU3g1M2IzTy82b1ZmRlRLNjlUa2t0b3NmWSt3aFo3RDhjaHdHdDhO?=
 =?utf-8?B?NFlwSGt5UklFVU0wblhnSFRDM1NCbzA0OFhtK2NGNTBDbnRhbVUrSmNNYVNq?=
 =?utf-8?B?Mm0zSDdGSlY1Um5PRFZTR3E3b1lVaTduUTlSMmpOeW1rd050SWR2bmZ1QURF?=
 =?utf-8?B?S1J1MWY2a001eVFxT01JN2N5aG5sY2E0Wjg3M2FWclNXT1BSalNZYUpqR1I4?=
 =?utf-8?B?RHNvYk5GeFB0LzV5YnR2S0ZNWmt3MGpLRWRQZWdxS3ZYNmIvMEZpdDlpQlNJ?=
 =?utf-8?B?QzZma1Z1dkxmMGF1ZWU1OHhLWThMOFZoRzBrTFhKYTEzWkI5aFppblBqSldx?=
 =?utf-8?B?ZjhrV1hPaWtzYWUvV2cweEkwQVcvc2JSbFRxaDFvaXoxQ1NXcGxlUEhlS00z?=
 =?utf-8?B?aGN2Uk02Qy9QRXFMb0dhRG12WTlYQ3dQdThlZ1l4eDdLWXJxaGdOTHlxdDE5?=
 =?utf-8?B?Ukp0ZlplWDJPZ05hU3NNbmpJd0t3d3YyNGhmWGVkNmovTzA5U29GOG56aXZS?=
 =?utf-8?B?N2cxN1VuZWYxZ2g5TnZsVVIvQkRUYzFTNXRwcjRpRGlXVVQ2STZXYmUzZitE?=
 =?utf-8?B?cDc2dFpmNUFDVm0wRGlPLzQyZjYxeWh1Z3NTWm4zY0NrT09iZ0I5Wk1jdXJP?=
 =?utf-8?B?QTBlc2dCc3VzZHZ1eW9Lc3Q0TDR2WW9uM0cwT0VWdUdIaGNPNWxqbFBVYlNa?=
 =?utf-8?B?SWNYLzV2anN5aDhyRWZCdXZLa0tReEFZTmdER1kxU2NDUCtyR1dkZkNBZldI?=
 =?utf-8?B?Ym8xSW1xMG45Z3VVZ2FjZzVHWktGOE41dGJkdDg3R3FBd2lFMDlTdktGRlNI?=
 =?utf-8?B?MklJN0JoSzNrYThYWkUxbEFvdFZleXl2cWZCZkFnVWZVRFg5cU5na2Y2SURv?=
 =?utf-8?B?VjlvSWIzSmNGUHNJZVZHZHlITEhVQ2lXVHFrd1dhSllvSVZ0OVNOd0JZRGlP?=
 =?utf-8?B?UUdiWk1uUExONUY4VUhuNThGQWJVRDVsVVorL1d2M1ZyOXEvQjVGcmRmbkcx?=
 =?utf-8?B?SWpYOStZOTJIRzUwa2NIZHhVSkJIamtwaG9xNWJXUHU5V3Y2bnBPd3N3Ykp0?=
 =?utf-8?B?V2ovVEVPQzJTMlk4aXhvZEp5STNSU0NyQklJSHRKNk9MT3dxZ0dqN1dPNERu?=
 =?utf-8?Q?bLuJP2Z/2fK59XFYa5Irw0AyR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3e8da3-41df-4cef-1f56-08dc49f5f308
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 22:26:27.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4VVNJlCd0qN13eIZD00P9FdMjCfy+JSSubNHS65vP1xykHwm8ZLOBNcEnBf5mvJzhc4CmEDmYZ+65dOSiJTJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7351
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, Yamahata, Isaku wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Implement an ioctl to get system-wide parameters for TDX.  Although the
> function is systemwide, vm scoped mem_enc ioctl works for userspace VMM
> like qemu and device scoped version is not define, re-use vm scoped
> mem_enc.

-EPARSE for the part starting from "and device scoped ...".

Grammar check please.

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - drop the use of tdhsysinfo_struct and TDH.SYS.INFO, use TDH.SYS.RD().
>    For that, dynamically allocate/free tdx_info.
> - drop the change of tools/arch/x86/include/uapi/asm/kvm.h.
> 
> v14 -> v15:
> - ABI change: added supported_gpaw and reserved area.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h | 17 ++++++++++
>   arch/x86/kvm/vmx/tdx.c          | 56 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h          |  3 ++
>   3 files changed, 76 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9ea46d143bef..e28189c81691 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -604,4 +604,21 @@ struct kvm_tdx_cpuid_config {
>   	__u32 edx;
>   };
>   
> +/* supported_gpaw */
> +#define TDX_CAP_GPAW_48	(1 << 0)
> +#define TDX_CAP_GPAW_52	(1 << 1)
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +	__u32 supported_gpaw;
> +	__u32 padding;
> +	__u64 reserved[251];
> +
> +	__u32 nr_cpuid_configs;
> +	struct kvm_tdx_cpuid_config cpuid_configs[];
> +};
> +

I think you should use __DECLARE_FLEX_ARRAY().

It's already used in existing KVM UAPI header:

struct kvm_nested_state {
	...
         union {
                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data,
					 vmx);
                 __DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data,
					 svm);
         } data;
}

>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 07a3f0f75f87..816ccdb4bc41 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>   #include "capabilities.h"
>   #include "x86_ops.h"
>   #include "x86.h"
> +#include "mmu.h"
>   #include "tdx_arch.h"
>   #include "tdx.h"
>   
> @@ -55,6 +56,58 @@ struct tdx_info {
>   /* Info about the TDX module. */
>   static struct tdx_info *tdx_info;
>   
> +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	struct kvm_tdx_capabilities *caps = NULL;
> +	int ret = 0;
> +
> +	if (cmd->flags)
> +		return -EINVAL;

Add a comment?

	/* flags is reserved for future use */

> +
> +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> +	if (!caps)
> +		return -ENOMEM;
> +
> +	user_caps = (void __user *)cmd->data;
> +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (caps->nr_cpuid_configs < tdx_info->num_cpuid_config) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	*caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = tdx_info->attributes_fixed0,
> +		.attrs_fixed1 = tdx_info->attributes_fixed1,
> +		.xfam_fixed0 = tdx_info->xfam_fixed0,
> +		.xfam_fixed1 = tdx_info->xfam_fixed1,
> +		.supported_gpaw = TDX_CAP_GPAW_48 |
> +		((kvm_get_shadow_phys_bits() >= 52 &&
> +		  cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0),
> +		.nr_cpuid_configs = tdx_info->num_cpuid_config,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}

Add an empty line.

> +	if (copy_to_user(user_caps->cpuid_configs, &tdx_info->cpuid_configs,
> +			 tdx_info->num_cpuid_config *
> +			 sizeof(tdx_info->cpuid_configs[0]))) {
> +		ret = -EFAULT;
> +	}

I think the '{ }' is needed here.

> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(caps);
> +	return ret;
> +}
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_tdx_cmd tdx_cmd;
> @@ -68,6 +121,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	mutex_lock(&kvm->lock);
>   
>   	switch (tdx_cmd.id) {
> +	case KVM_TDX_CAPABILITIES:
> +		r = tdx_get_capabilities(&tdx_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 473013265bd8..22c0b57f69ca 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,6 +3,9 @@
>   #define __KVM_X86_TDX_H
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include "tdx_ops.h"
> +

It appears "tdx_ops.h" is used for making SEAMCALLs.

I don't see this patch uses any SEAMCALL so I am wondering whether this 
chunk is needed here?

>   struct kvm_tdx {
>   	struct kvm kvm;
>   	/* TDX specific members follow. */

