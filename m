Return-Path: <kvm+bounces-11219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B19CA8743C9
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2960BB220D2
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14201CA88;
	Wed,  6 Mar 2024 23:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jlZToukk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAC61B80B;
	Wed,  6 Mar 2024 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709767228; cv=fail; b=ln923eUyNADjFJNEEAHpzTSMlq9YXUStusUMIe/j+Eab3oKgTVAPw3Yfrh51FyliNGQuXwuSszuY5bDaHcXYCWEtW1tmpDfv/dz6vI6EobIawUotRvS0+VliJ1kYWHHYze87+1gOdgGGWnBg11L5E9r0YoRf+YbzWSw86+whPTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709767228; c=relaxed/simple;
	bh=fDBrtKxI6bCBKxPh00MUheh9uoOe9Dtj1hHiFscqDTg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FIQ3QWtHZs/bl2l0VK/OWEjBjzpZEAwSUtJvrCmv29WhJ26kvQZnfAmUPVLHQ3yIIwT0JRZblmbqelbQjzSJ/+mqGiG4z7IfQ9uQKb73xXNgF6o2N8lCeHNyPLCFYjZAHQKUcqayICiFoH8w1Ps2V6veVU3RyvttPhfHK/gH4XA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jlZToukk; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709767227; x=1741303227;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fDBrtKxI6bCBKxPh00MUheh9uoOe9Dtj1hHiFscqDTg=;
  b=jlZToukkRTnOmNAmSp/oHPNwWoTwD1qPhjKwj8CJJb+vlQf1StPkGW+N
   XICDiBgNVpdvW92EjOOyWMGDSdb2mPDe8ungcV18cUadJfFiBmcImkqZh
   epica4a4qulV+5Tne45yT2AwtyJd8d9C1BOttv05JbYfSrFbke3OVpPGE
   4eFccmKsZwJDwTPkWQZjphDoc+m93Atf2UT/rmvWFUslVpFjygQZOObw7
   eDaDPuyJ0vpkpfFrFVE4AZzEhCMMZlCMfaL8Y3VwaLuKE8TPY+9x5Ww/U
   XemMmDqV+oHxizmv9e09Wx/HixsjM5PC1QTcDnsXa1sKv4Z5HtgcsYRD8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="21864842"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="21864842"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 15:20:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="10457747"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 15:20:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:20:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 15:20:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 15:20:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNVLIqSkotHA+BTVKFUHmm2ufhQpWWNicpWJX+7MTuum60rlXHbHMlt0wIFDPImepPGm+k0hvQEeTi1Q1oHzFnu5GWFp9kl0D6IOBNQNQAWcc14svm04PXbSTshOME2Cqx0TTbumUf2JOiCW1J6UbTGdxl34vJHWJo6L0J8xLeO/2FBBDysS2KrnqGWrAgdoe4O/XWbk2HKT0gg9fwlazrCMlIX0F6QLpBX5djyg5PDUxGOjh1NqcEZoeCk5LPKAOrrvaOeaeHh2ANFWHl0vXUBZEOfREKxJoxfas2s/vLQOPPl90U43++fp1KWDeXsoaab22GVcsvXKQluTOJ5U6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NlKfQUzM1fMgrCvmNmgFHiBHwuYp5VrniP3P4/qT2nk=;
 b=SpjHnzx3+EQkfp9lTTO85GtTZ0GLnAtwiQU0zOmLm6tq+4xCeb1LKKwptnBNTelsOpJnH8ggJ4Ai6d8g0vagkEQNsbSWA1HAopkagXjeLsF2J7DnTRnewWEhRnA12YRO9SFD9f1Xks/OR/uBwRwQPWCyEr1atuM/osBBD7lfhWSbkwyq6i5GcazHRPKpAWq7Hb5FKjdY8xKJfrS+xkfm3F8eKjUl5cxI+1j5o/JF5ltOZ8S3Di4/4H0TbhWfCcrHMozgD7NBz5729dfSnEWIjsLqQ9BYda3fs0j/PM63Jf6WI5gk953SNReXuNX+zGpjG5a9qjOZDms3SQIoOsIDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV3PR11MB8728.namprd11.prod.outlook.com (2603:10b6:408:218::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.6; Wed, 6 Mar
 2024 23:20:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 23:20:19 +0000
Message-ID: <db22392e-fb88-44f6-8592-7429c606cf10@intel.com>
Date: Thu, 7 Mar 2024 12:20:10 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: x86/mmu: Explicitly disallow private accesses
 to emulated MMIO
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
	"David Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-12-seanjc@google.com>
 <0a05d5ec-5352-4bab-96ae-2fa35235477c@intel.com>
 <ZejxqaEBi3q0TU_d@google.com>
 <5f230626-2738-41cc-875d-ab1a7ef19f64@intel.com>
 <Zej1sBTPLXIhfemS@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zej1sBTPLXIhfemS@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0336.namprd04.prod.outlook.com
 (2603:10b6:303:8a::11) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|LV3PR11MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a55696f-0774-4820-0683-08dc3e33fd49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +y587IqreTQflhDrrB9dg4SMCRMnfzYm3n4NXSqir+T001o4zMyGzIJg+m+ouj6BLoGeKF2CV6zS9aoEv3wSCUHFg91HGk+6qlIyu8C41T+kE9nfMANR0UC4qHaUK5Cw3zg1nOxQ1wBltKyNWuhKSImKd2ehgOTHvgqltdxcf/sy3131lUJyjotUda+7SgcwiQbCW9Oq0Co+J1rOram6tgbqb+ZrSSDpJcnaMG32RZ/3eWuRCMnSk3q2Dz6FUJJEzo6rHjkptrzdsngBuLBXiZXA4Fd0VRaMEZPzp0CDEtK3K5QdFGuy+TdUG0P40FbB9KBiyysiqNknr+uNJO8KbCnPOTZsE6ergt+f/fY3efeWZvFaW+RGlzkDOV44LZi1OGybWIsVla1tBWCacx49FQIIn14omoLmb+aJnBD3o+n0vZzLXdh4PvyHEBuJ8yAqSPH1vFIQTS3h3hNgEPoZK+qZgjy3rgF25GcnlUMupivbw1TrvWVd6JBOXwrxy0rBJTulvzjF65VCbkQ+yCC0QRei3EJ2ooEaL3zPjAbqPdCLtq8SObM1Tf8jOCFQEnvU4yl8eWqoj8GOZIAB6jkZHhTiwNXBj1U2wcLvRi8AHuncukG+g1i/dh9gwPvG/FHcVvWnTrs1Mxih1yyDcj1q2LU5NNJfEXl3nbU6K2+lh/g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3FDejNkUWZibnJ4eWsvZGcxd1ZtK0tVUU0rNlBRellyTkREMWd4eXVOOTJ2?=
 =?utf-8?B?ajhzY0p0NVZvSGt6UjJLL09BQkdacitxK3NxdHhuclVWQzRsbWFYMFBWMXVE?=
 =?utf-8?B?V0Iyd2wxTnZZUWtEQ0lQZjBnbTNia1R2aFB3WXVlQVh6aFY0YmFacHZmb2p4?=
 =?utf-8?B?c0k4TUpNbHNYRUhnSCs5VW5GdWdqNHgwS05PRTlLKzFpNEhVeUdPTzZkL2tq?=
 =?utf-8?B?VUlFdFZWYW9kTkxTNXZGRUdTZmV3TW5Rem1xYk1YMGVaekl5Mk9PR0lUWm8v?=
 =?utf-8?B?R0cvNGNuNDdpWnptNDBQaHlpZldDcDlyaVVJQ29LRkdjNk9jUHZnNzg4Tnhh?=
 =?utf-8?B?ckJKVmtmbU5rSCt0Sm9HVjI0QVdWNjNxMWViaUJPcllRbmlMTjJYWjI0ODNj?=
 =?utf-8?B?QlJoSjBvU3k5ZVpaS25OOExQZHhRV05xZXp0SlVSSGpQSzBJdkZqeFRIZWpX?=
 =?utf-8?B?Nit5QXpnYW1Gdy9kWXN5WnJzR2E5N1hlRmhwNGUyQWFPbDdMOFQvUlUrL3Vs?=
 =?utf-8?B?N1dxZDBXRE5KdnZ2MHMxNnk3WE9NQ1hHQnpHOXdNNEU0ZHZ6N21RejZiZDBa?=
 =?utf-8?B?L2xBK0JaZUZuV0krUHFUemtjNmx3cCt0RXZzaGpiVWVTYmVzYy9LYUxRQVBs?=
 =?utf-8?B?NEw2eTNpQmEzRktyQnVIUXZjb1NTRkFzUi9HWElkYzkzV1ladjRUNncrWkY0?=
 =?utf-8?B?V1kvZHFIL1hISWxIT2dWbW5qaHR6OFI1eDY0Si9KK2pza2hWSFFLVUpvaFo1?=
 =?utf-8?B?ajNHUElNOGZGWUpjaHlUVVJsODZJbzFwWW83bVZnaVFhNFJyOU1xZkdSTmxL?=
 =?utf-8?B?TFpQV2dnVGo2a3JPVG5PcEI3YmJNZWFHaSthQ2p1V3p4d0F5Mzhjcis0Q0pr?=
 =?utf-8?B?NXl3S3IwY3plK1VQc0plc1M4dUk1b0tTWnhQdWFtQktmVTN6a2JRMVo0SjNr?=
 =?utf-8?B?VExwZmcxWmM0eHFvU3BlVGl5bWdDamJERzJVSGJ0TGJYTEFYb2szcHltZ2pV?=
 =?utf-8?B?NEpLWTlXMEE2cnoxVnVoZ1dCeHBpQXRPeURvc1NlSnhPNW5yd1JqUzJSa1Bp?=
 =?utf-8?B?eWpQNlE5dlV5dGdiaUc3RjIrbFcwZTFCZTdocjZHRmxSK1FNZXhrN1BuWVU2?=
 =?utf-8?B?RDdteGhZM1JsZWlGVWNhaS9CODdjMGVab0hRc0lLaUpUSXY0Y1hlSTlZK28x?=
 =?utf-8?B?b2xCQ0J3T1I2NjBFT0ZJSHQ2MlFjb2hBeDM2MG5FcVdBM1YrNmt0a1hPbTgv?=
 =?utf-8?B?dlZNZmFsYkVGUFFIZjhtWnZzMXFPMWd6ZTZwQUlXSUJ3MEQ4aTNWUTRFQUZC?=
 =?utf-8?B?d3BTL2NSUC93c1BJbkdhZ2NjcCtrMzduMnIxVFlHbE5QK1BYUk5iVkh0TDBQ?=
 =?utf-8?B?TmxwQmxCUG96YVFFOTdXRExXUUJKQ1Y4cWZLanAwSi9sUnNLZGliR2c1Z3Br?=
 =?utf-8?B?bWMxc2RWTmlDMHhNUUNDRlUreFFYVFU0cThpNk9HcU1yNmdHdnI4MjBrNVJY?=
 =?utf-8?B?eXpDMUYrS0drZ3FFOEtKNWMzdXluOHp4OHczVU9iOHk2SjdRb0Z3cFJWVzNH?=
 =?utf-8?B?Ykd6U3kzUDhJL3dob0NWZjZnR25zeERlRWZPa3BCVmZlZkNOTGtjVnR6M1J1?=
 =?utf-8?B?ajZwaklMNjBuVlhKWmZDM0lkaUN5OEREdERqZVh4RGRTd01ZUVlxd2dJOHE0?=
 =?utf-8?B?Z2tzMmxJNjhDdldMeXBzV3pqQzJsQzNLODhmNng0ZXh0b0R3VTh2ZS95Zm43?=
 =?utf-8?B?alBITzhHVXdNeGYyNWZFdVh3ZC9wK1JCS2ppQm1JMjl5MXQyNFl2MDA3Z1R4?=
 =?utf-8?B?SVpmbTB2d2ZiWE1EM1p1TEVwYUxIWXlsRUNNVGFNT0FXWkEyNmVLTjBGcDZQ?=
 =?utf-8?B?TENSREJVLzhvMGRRb0pkQk1qOHZydlF3YUZ3R2Y3NjlXYWprbWVMU1lvWS92?=
 =?utf-8?B?SXZDbkJFd0FRTDE4MFR4cjFTYllqMzN2Y3RVY1pzaW5zQ2JEOFYxdlhGYW01?=
 =?utf-8?B?MG5lRm5YdEJ3QS9vZTNtSDJmbEpaS3JIemZoK09tSHpNZzR3YURmSnFiZXJR?=
 =?utf-8?B?akEwa0VNVytHdlJtM1puOTQ3MzJpYjhCU1RCWnF5MU5CbGRnd2ZRUGVJaEhn?=
 =?utf-8?Q?Zmm6lFAYKs0sBx9qlMsy9vpci?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a55696f-0774-4820-0683-08dc3e33fd49
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 23:20:19.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXEAS1Tx3X9DVRdncaWunTGrFLjLjHn4dUe6YFU/dIE8r30pl99LOpBwBpDSQMy6iUTaj1Dr+UDbkXUEunoB5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8728
X-OriginatorOrg: intel.com



On 7/03/2024 12:01 pm, Sean Christopherson wrote:
> On Thu, Mar 07, 2024, Kai Huang wrote:
>>
>>
>> On 7/03/2024 11:43 am, Sean Christopherson wrote:
>>> On Thu, Mar 07, 2024, Kai Huang wrote:
>>>>
>>>>
>>>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>>>> Explicitly detect and disallow private accesses to emulated MMIO in
>>>>> kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
>>>>> to perform the check.  This will allow the page fault path to go straight
>>>>> to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().
>>>>>
>>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>>> ---
>>>>>     arch/x86/kvm/mmu/mmu.c | 5 +++++
>>>>>     1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>>> index 5c8caab64ba2..ebdb3fcce3dc 100644
>>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>>> @@ -3314,6 +3314,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>>>>>     {
>>>>>     	gva_t gva = fault->is_tdp ? 0 : fault->addr;
>>>>> +	if (fault->is_private) {
>>>>> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>>>>> +		return -EFAULT;
>>>>> +	}
>>>>> +
>>>>
>>>> As mentioned in another reply in this series, unless I am mistaken, for TDX
>>>> guest the _first_ MMIO access would still cause EPT violation with MMIO GFN
>>>> being private.
>>>>
>>>> Returning to userspace cannot really help here because the MMIO mapping is
>>>> inside the guest.
>>>
>>> That's a guest bug.  The guest *knows* it's a TDX VM, it *has* to know.  Accessing
>>> emulated MMIO and thus taking a #VE before enabling paging is nonsensical.  Either
>>> enable paging and setup MMIO regions as shared, or go straight to TDCALL.
>>
>> +Kirill,
>>
>> I kinda forgot the detail, but what I am afraid is there might be bunch of
>> existing TDX guests (since TDX guest code is upstream-ed) using unmodified
>> drivers, which doesn't map MMIO regions as shared I suppose.
>>
>> Kirill,
>>
>> Could you clarify whether TDX guest code maps MMIO regions as shared since
>> beginning?
> 
> Y'all get the same answer we gave the SNP folks: KVM does not yet support TDX,
> so as far is KVM is concerned, there is no existing functionality to support.
> 
> s/firmware/Linux if this is a Linux kernel problem.
> 
>    On Thu, Feb 08, 2024, Paolo Bonzini wrote:
>    > On Thu, Feb 8, 2024 at 6:27 PM Sean Christopherson <seanjc@google.com> wrote:
>    > > No.  KVM does not yet support SNP, so as far as KVM's ABI goes, there are no
>    > > existing guests.  Yes, I realize that I am burying my head in the sand to some
>    > > extent, but it is simply not sustainable for KVM to keep trying to pick up the
>    > > pieces of poorly defined hardware specs and broken guest firmware.
>    >
>    > 101% agreed. There are cases in which we have to and should bend
>    > together backwards for guests (e.g. older Linux kernels), but not for
>    > code that---according to current practices---is chosen by the host
>    > admin.
>    >
>    > (I am of the opinion that "bring your own firmware" is the only sane
>    > way to handle attestation/measurement, but that's not how things are
>    > done currently).

Fair enough, and good to know. :-)

(Still better to hear from Kirill, though.)

