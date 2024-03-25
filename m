Return-Path: <kvm+bounces-12556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF6F8896E4
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 10:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89E451F356CF
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 09:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AEF6F07B;
	Mon, 25 Mar 2024 04:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8t0sFqV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B946F076;
	Mon, 25 Mar 2024 00:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711326320; cv=fail; b=sUx19wtOzKYXIv0jN6O8FR0ABtHCaBHpuI7TEm6h3Xx/6X6bivzooul23kO7G8OafGi+F6GfLz7KHtR3doS4MpPpWd73/yur5sAQMAOOswXaX1Hl/fHG9g22wtUnTd5fZtbLLi7BqS4sdx3LQP/QYdGRU+oUo9dSYCM0F+f3SkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711326320; c=relaxed/simple;
	bh=+5S01g9AnXXNBXtOxPBH9Vqfd5svTlFvQh9Mk2dNiWQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D8lyyoquyeDCICZ+dx9htZxFvx05taWavaimEPEyrYYSwJR1gysZgxjLscbDAsltyI5RuH9ZoHziBr9djmOItQOQg1IMNnVPdFVDOtwQ+yzF6uBe8eHwaSJjzmf6um6bw0sRgPQteAs/pv5AO4Yg6DALQl8lzyqnO+PD0fgMVFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y8t0sFqV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711326319; x=1742862319;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+5S01g9AnXXNBXtOxPBH9Vqfd5svTlFvQh9Mk2dNiWQ=;
  b=Y8t0sFqVDyWYt1m3oo299JfRyoa5nky3jV/LlQZzn33Z9GFSsZp2Zn2x
   SYEXeROaY6ZZcf6PeB7NcbYFxFYjR6jO1NTxhn8Pu6Lf/7vcUWAtDxaQk
   hz8dZ4CT2d8/ax3rfqnhU2bf9VVduiFgVbsKbGbK5ooK0y648S/Kr8heP
   FU2zlkOEiY6vnlgT1HvFFuvYqbk2mcq6sNhNWq6yiI9vKpDEEMHsnGXzJ
   x27n8HXJkEJoAFE+GBH2XYLU76u3Pa0Ps+IZ/4966ifj23Zj5h/hseSOa
   sMPwLtJgX3VW0P7IU4/+Q1/xhsTGrIpH3PNAADR1y9FiZxydvleZav8PP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6167317"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="6167317"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2024 17:25:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="46440496"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Mar 2024 17:25:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 24 Mar 2024 17:25:17 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 24 Mar 2024 17:25:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 24 Mar 2024 17:25:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 24 Mar 2024 17:25:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLOtuWXY5J+vNDjUUiWVBDR6TBtvK8aGjMAQYn45k/whVEnjo15JVNuSbOeBipyo4mRLMCN2Irglu8fOLcCODr5ntLdJ8tu65skbr8qSwTgWhhkFBHGqb2ZhOcPuttdYbzz824jL6LTFdYDeOUKdcQGD7+5dZgzBSDMELK690v2rWEbMClf2XaBVrguT143vtD3oZ1pR+elSUh7PBOGszPx5f94xDGsT0R+wXucs+A8aHMeXW3g67NEKTAfWbpEG2R960rIST8a6FO1QWn2vc89ygc0lqyxUSXGE3CBbXyxGdpvj1adIohMGwzCZGUiuxKNq+UTLgRttoVAZl3BI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xg2g1P+vNRTUF98h4MNdEAYbD+MmZ6hX5il5pGJuiLQ=;
 b=awGL/J81phZdyqUbWWetsBmWNo6lni1edsjl4rLo3Z5uBc3RE178nPo9mE3wwXdjaeUI+3sjKo0eNx5eSLvitAPjx7ZchAoGEKAA908RqOO1xV/xZZlSu7Xr2qh5IvS0msmOg38iWnM6s3E8g3QH1LYVeXpB/+WgBv9MTD6rdIcGZBlRisnodKVqSyhTcAd5gjcXmw3tieRE+WrbwN1t+INTvmxI/DOvSeNz5f9AfTKARMkAaZ1FobhTV3TdGWZWkiUeNYWHbdKnnJf+HLu/owmamwHEpd4gIvDvg6LBImdLYkzHdMYr2e8fe/6hj3mezv1R1GVikBhdN0v8QRaSVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB8067.namprd11.prod.outlook.com (2603:10b6:806:2e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 00:25:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 00:25:14 +0000
Message-ID: <dd464059-1127-4526-86ce-b35f71e71983@intel.com>
Date: Mon, 25 Mar 2024 13:25:03 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 036/130] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
 <838fe705-4ebe-43f1-9193-4696baa05aad@intel.com>
 <20240323002847.GB2357401@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240323002847.GB2357401@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0133.namprd04.prod.outlook.com
 (2603:10b6:303:84::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB8067:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c73b071-5bfe-4713-5fc4-08dc4c620a19
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46hdAu3Qy6lDSDveUS4nmwu39dHx7l7qc6MkktN8wvJAJPVfH78sQM7QB4lZDAv5Qz20D37++MIJbcRb71PnDsHdRtGx/9XbSy4TwHyU/j4QeXFmiP+lrKXWF8+QIj8jTLB4ByUPZBxTRPHZjygtlwod2aLDYpaOnos0cET8fPmCsaluEwnT/xa+aq2AFCA4gThB2hEnVwfFzP1mKi0JWROgOL0zmv//Tow6OO5kgksPCiNeRIiHt49tCz4iYeVoRqV1tJz5mYgF3HCqg+9+PMWhfujnoeBKJiEmAWS/O4muiDBKPIzqo64q/YILNLjbkqmd3z5CmpCve1Lp/kcNYwxv0qWMZB0QdNVAAnZKVdwGT8FUpzIrkdbvSBmBW/fVu5ufyKnp7zI8kB5aJ1Z4MYDDMWahrRVMUyOoOt5h7pLoJruOgyDKFB6OzsYRSVM3T1My6mnybRNiMs3BUtMM/9W4qVg/DqPm7HFpjCX1C0sLsChTUw/qI7y++M/7w+0419pqFatK3qWxygmN0qKMzf1J1ML1N+KhADwbqvr6auKWQp7MAj3KIw9KaA+45DIhUhnTaGIpgYS2TgivYZDPmJQZ5q4mXXWydfWrqJ+Ad6mdstyz82xjFbNB0spFHtW7/OhDzDhv0/9arDZZsZa6mmuCu0WngUr+dBF4oZCJCSc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDN0cjBBU3l6UkhEa2V5Sy9GMjg1ODFLMmJOM2tna0JEMzNFVC9SNWkzTlND?=
 =?utf-8?B?ZFMzK0labzc4M0RZRmEzZWU1SG9zT29iWkw5MUJub1YrY3JQZXBTaVNFZXRu?=
 =?utf-8?B?aUNZNXNmMi93SVBWQUs5cXBubU1iRHRPM0wxbXVWM3Y1YXZsTU5EdFdRRVRi?=
 =?utf-8?B?ak5MckczSVhoV05SSXVGb3A3RnJsbkJVWGZmRkVtdDN2SUcyVk9Bc29NdVQ0?=
 =?utf-8?B?M3FXZVZFRm1Qbm05d2xlWnRFQjRrbm14bCtaMFB1OXQyM0paQzhlMWVPL0ty?=
 =?utf-8?B?OXdpUmlWdm0zWEV2ZXhuRjZ1Um1oejNuZUlnZHlVWW5IUXdoUEVRWlVJUTNW?=
 =?utf-8?B?Q3RYY01zazk5K3BjY2xLOWlla1NuV2FZR0g4NjBFTHBYWDlENEQ5Qjg0ek5L?=
 =?utf-8?B?K3pZdG5jSFhKODI5aEdsZ0VNTUhtOFhLa0ZQQlppYXdJdnRJczllSFhhdldt?=
 =?utf-8?B?VHZyZ1RTTUpSZmx0VGRPMlpFUEpaTlpiQ3d1TW9CTzlXeUFOczVXanlWd25x?=
 =?utf-8?B?RnlURUp2cVBCN21uZ2FzVkw0WngrcHc0U3FtZks4S21SZjluUTYwL1FhRzFG?=
 =?utf-8?B?Zy9aQ01vS3dCZXBDbVRtUnc1MmdwMmthaS9HTXNER1dlMlQ0b0MwTnRHeTRP?=
 =?utf-8?B?WnZsRGlQY3lRWEp3SVA2SzYyWXdBQkNvN2MrQ0EyNHAvb1VIRXU0UHprY0la?=
 =?utf-8?B?aEFVZ1RiTzAzZ0kxNHh3MG9OdUxMQVdCalpyQUR6a2VMaWNORnpkenBxRUpo?=
 =?utf-8?B?WHFjT0NjTU9NdmpIUlVIMFRzMlAwY3Jxa0hIWXBsWVoyNHVRT0haUk9QcVZD?=
 =?utf-8?B?RWZQUTdFMWVsdGtCS0F2YmMrNHA0cEdRalZQVkRVZFpmRUN5QmNnL1lySTNH?=
 =?utf-8?B?bVR4VUFLbytmd3A1ZWtiSFRUL0JISmRyN2JKVUd2RnlZdnpWQitYdnRicE41?=
 =?utf-8?B?blQzU1lqRVZ4QWFZK2dhaWY1RUZSTitIVXRZTSthVEJ6MXBMbFRMdkdTREIy?=
 =?utf-8?B?YlRXc2dMcndRSXg0WFFpbVlqUTVlVDYrazNiMW1OdjZQYTNwVVhEY1A5S0NZ?=
 =?utf-8?B?K3Qyd1dJVWpaa2VIcnBQOXdjR2NudC9yclo4UWZUdExXMjlIN0x2QUZNUnRY?=
 =?utf-8?B?cFhLeGdoR2h4dXF5RE5oeHBhQTVCU1N5TWhISVFneFg4UzFBR1puY1d3L3Zu?=
 =?utf-8?B?MXJJd0NnWTl0RFNVTFhaOVVsaTk3a3lRN3NhSVBiZEMzajJveTVPbmRVRmhC?=
 =?utf-8?B?ZjkxZmNKZmhpK21CR1J2c1BjYlJkNTkrU3JqaFh0N0xleldDWXVPL2pKYmY4?=
 =?utf-8?B?UG1mV1czUTM0c2FxN3hYRlVZLzU3clUxU29kQVFmbW50bGR1UVVtdDhFNzNK?=
 =?utf-8?B?cy9YdGZPcnZ4TnA5cWk3Lyt5UUROaDRjMjhOeGV3cHBnemNVN2dQeEo5RUpp?=
 =?utf-8?B?dy94cnhuYjI1TGVlTjQ0ZUlSY3RVbWlSWFk3TnAydyt6c0plbWE1VXpjci9u?=
 =?utf-8?B?NDVjdHhMSmtjSXI5Z1Qxd0tmOE5neE5DcXNJNVJBbmZVQmx0anN2Yk1Jdng1?=
 =?utf-8?B?TSttdm1hdUdoTjlsZzdrM3FIeFBiOTUyVjQ4SWJIMmU5ODgvdDRtMkdRU3RK?=
 =?utf-8?B?VzJmYzlER0lxZ2dLUHZBRitDN3dUNkg2dWJ2cW1MR3Q1RmpXeUsxd2dwK3gz?=
 =?utf-8?B?dEREeExOdm93cEtUOW5YbFJRNTBLYVRiZUlPR2FBbXlnUVUwWEdMLzg5MVpD?=
 =?utf-8?B?cjd1V2tnamkyYy94bW5CV0NvbTRoQzNjd1NQcWV2ejZMeW41cWFFWlpDdFZ2?=
 =?utf-8?B?U3MzdlFrL0Rod2ErVS9TeStZZ0FNSFlvRm5jNys3NG1aUFhoY09PYlVCUWNv?=
 =?utf-8?B?UGdaek5lZlhuQTRXdGJPaFhSZmdBTXZQS09mQm1ZaEJUZFgralpHalNpVUdW?=
 =?utf-8?B?dHp3dm1iK0Y2MTZCYTlDQWl1NE9GNi9lTGdBNW14ZUEzUEZKQVJ4K0FQQmJT?=
 =?utf-8?B?TEwzamdON2FMYVl2b1hIL252ZWY2NUdxZ2hBaEI2d2FSY3JKb3NwaCsxckFN?=
 =?utf-8?B?V1hiSHMrSDR6NW13UTQ3a2tlN29IWU0ybldXT1dHT2pLZ2FuSnU5R3pKMnZk?=
 =?utf-8?Q?pf3kmivvCkBOUqgR7/jcSiU5j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c73b071-5bfe-4713-5fc4-08dc4c620a19
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 00:25:14.1592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHB8iGamAZ+i86a+g6V39Z/c8sS53a6d+6BVbH+bLi4HMoK6XDq0JDg7IvgydkL2TQpLmus9DB+Web1KYXjGHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8067
X-OriginatorOrg: intel.com



On 23/03/2024 1:28 pm, Yamahata, Isaku wrote:
>>> +	if (copy_to_user(user_caps->cpuid_configs, &tdx_info->cpuid_configs,
>>> +			 tdx_info->num_cpuid_config *
>>> +			 sizeof(tdx_info->cpuid_configs[0]))) {
>>> +		ret = -EFAULT;
>>> +	}
>> I think the '{ }' is needed here.
> Unnecessary? Will remove braces.

Right.  Sorry I didn't finish the 'isn't'.

