Return-Path: <kvm+bounces-14707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 766748A5F16
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 02:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E620BB2221F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E75A29;
	Tue, 16 Apr 2024 00:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TUi5QBPG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351CB17E;
	Tue, 16 Apr 2024 00:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225947; cv=fail; b=I2F0z6MgJo1UKgs/XoDwP+FzIZIFrDhsFx7ND5L9psG9VxCCe9/uz/vBB3E9YW6mxXYdyR4zSBDPc+HPkgH+9SeHl+OKY0HTlykZ9jckFuDQVnMjsMSY0QUpYJVQicfPQ+jjf8mv9AFOcKBBvaOfz1J8V91mbawwBr8IB6dYtCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225947; c=relaxed/simple;
	bh=QGnpmyK3IufYQ6duuhD7oavHSxei1jHbDgInI3chzGc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p/rwWSNXSdaVXyMBCD1l1zygyFz9wWaJg419P0bxcWTSnmjbaNLbvcb+PFoVDg6Te+uBB/0+Es1Mezr1rUBD0KdpYA6GaSFef6og1gUMV7jW4PPsx+BsOXLGeA9uuFOcCu2Wj04XKPB7PgjxDQxKWPx0A31Rvb9iu8jTGmPNFBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TUi5QBPG; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713225946; x=1744761946;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QGnpmyK3IufYQ6duuhD7oavHSxei1jHbDgInI3chzGc=;
  b=TUi5QBPGg6MMdDBCUz/K/eIOLjV3RSN5k+tMxffw2ys5QbswEVOwRoB4
   1xFDFJrUeS0M2d4gxmCctpNMzqjPs5uZdlNQQPu/Cphf1GE9kzNU4Scze
   ZXF7pj93Y1Emcrvcuxn8QQZvgp5y+/zgNlskzichrkHGhTKwvNbAiJLzH
   6g2zeZyh9EU6/RRZjJYmGapXdKdhoaGn2yo2JRy1rl84BNylPZeHeDSd0
   c48g8ZLfxbS+TbIwl+6f0FsOpUxID22wLX+iwXzOv7F92H8BUi6jBpSHF
   k5A7EMeC/TbPFX7B0Npe2fXI+MdAEbVQsXO6k0dKwq1cEmAw2R0YMxdVm
   g==;
X-CSE-ConnectionGUID: d1yy3JxARjyI3jWez/uO1g==
X-CSE-MsgGUID: UJr1NUtGRWOnxiA8Qa3bWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="20033696"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="20033696"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 17:05:45 -0700
X-CSE-ConnectionGUID: OoZrpXTLQOG1V9ahfDle3w==
X-CSE-MsgGUID: cb2rG3ONS/qaDV6dFk46Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="26743496"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 17:05:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 17:05:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 17:05:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 17:05:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 17:05:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAoVS5Ayisb2mmvpQ39oQBCkNxhfpaOLSYZdxELE/RZBs94XcervzkIaBIK7VpYzcZ7UlEkGmHloaHKQzf0sHvuTMSB4Fb5VVqiemkJDeErZii3r4p9R8619suyH9sHF/O+sTnW+dKhYa6pRnIV47sgbMVfHHDtCnewhVIDZOA4Ex69aic9VASz+YDGorIrCT8Bg7kWUSS7b4R+3J+MbpOSqzVzQKr0ZP+8G3++oOsfkerIQ4Q53FiA/JDqw2zN3uxySz84ZkrCIm7otivAdvmEvfhGELG9HXFscnvV7LL26CcG+DD5+4sPMf8Ru01Bkaj0kPehiO34PwmIcP5/xnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IToKEipuIP7Zs5vJY7ycN4qJeEMXVFgHJ40s/KoSFiE=;
 b=LRCxYkDUkiH0E2ldXPgrnAZ7tMoT6D6g6c6BIIHf/uIifWM6QRfjloTFtSbbZBv0Rc3gBq4cNQIYmEcZZSB/JP6nqVJUaI6VCa8ygQcAx8hcQNOxB0iCN3SAo6kxH0JKJIM4xn7Fc8ngPVEs2qiTl8HoMF7w61zPe42Y7vPZLtV3aN6OXm/oDFdBkNwniPNTDHoSmjtnRxsvuQ+7VAViGz3GFrQm9YQQg7ZHo2FfNt11Kl7sVtDFCJzhTh7XFlyp14f13+ncN0R5INz6sRl+gfWglP24DSxGJcXVlHXagStbyV8zQJS/09ZbAmrPeNmkIatkeA6Yv0Stf1+YWeambA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by MW3PR11MB4699.namprd11.prod.outlook.com (2603:10b6:303:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 00:05:41 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::dd06:e9e7:d35a:77b0]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::dd06:e9e7:d35a:77b0%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 00:05:41 +0000
Message-ID: <a552a48d-81b6-441a-88cf-63301f6968a2@intel.com>
Date: Tue, 16 Apr 2024 12:05:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
 <20240412214201.GO3039520@ls.amr.corp.intel.com>
 <Zhm5rYA8eSWIUi36@google.com>
 <20240413004031.GQ3039520@ls.amr.corp.intel.com>
 <Zh0wGQ_FfPRENgb0@google.com>
 <20240415224828.GS3039520@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240415224828.GS3039520@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:303:2b::15) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|MW3PR11MB4699:EE_
X-MS-Office365-Filtering-Correlation-Id: 86b4fde2-e062-4954-1be1-08dc5da8f45b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SSzDz6d2hclq+CkJT0MfUaudg5bn7NS+57jlItvTLLTsT7oTIpznrxLAdqz3cj9337OlihHDvOqvjLHzRXa422FWCyDAsr/wm2RpO+grzJQ0dpK4ny1a98g0yCRmSImzj3m33t4E2QrPjCDS1uLNlASnZzlEiGMqn+i0mJXqeCiKV0NxjdxICLQIuWdyCFQjiNE8IttjAinBQmBiJv5OLUWz6mpdxrrxN2mFZlAxXaIh1oTkAFBkGdesxit2fmwRNVq/u+mH0eFXwrLTTxBNdqmMPLePWGScvD1L4kPXz5jCKznhJcflnso5tjLd1AgM7+rUibQKoVgve7UG+SRUKT7nfvYRhkdJmahr1xRKXegE6qLbTrs3tZB8l3fw+P4kKU0taVU7uWmJQjMnZ90dNH7nICgovn/vylkvOj0WAKSyWyzd5M9fumRCFJUdBSpWfsZxhkN525UTmdiKRkGu0bp1uwVxJUiaqITcgHyIfM1zy0xWRwXQj6/JrTj7SZc6Z/BK93i7p6UYL3RY0e5vI+pvEeYzlgyBtselkL6CB4lySO6QpuPLcJVAFqT70cyzClj5wSedTk0AB3s/ZNxyuhBFIjkj0NSzwwd9E6MjAucMfgFGLJS8CJyc5TawpsK/ZeCvmySVXejYaBHglDq/zPHV8CwX97fcqSpCqB3UGlQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWJZS1U4SGk4Zm11cGc0T3UzQnhJTDg1SW5tWjZ5czk5Mzh3OXF1bmVGMk91?=
 =?utf-8?B?eVJuUGFkVGt4QnNaSE84RHZUeDFaVnBoMFZrU1RNNHd0S09zaXo4amRobkI2?=
 =?utf-8?B?enpveFphb3ZoSEZiNFhmZ3ZJVWFIdXZnZlhBNm9ZY01sTXZERklTRDRUTG1Y?=
 =?utf-8?B?K2IrdnRzenpwVytwazJzV1ZURjNWU01zTjFuV0xua1lub0Zkb2lWR1RhbjFj?=
 =?utf-8?B?MnVnSUp5RkxyR1Y2R2tKZXl1R1l2Y2JyTUx1M3IrZlN4ZS9xWTJyVjVMYk1C?=
 =?utf-8?B?RGYwcG42cFZYWS9obm5mR0dpUGswbTdQUk9QdnJyaWtkY1pLTzh0OHBlR3dj?=
 =?utf-8?B?V2pGL2ZaOTBIWWsyMG9ZbThNZnJvcEdnWUx6dWNSMU4rWW5kN1J1UE0yMTM0?=
 =?utf-8?B?Q1VReHNMUm01YjhuMitIQ29xWWNHNFp2anhBS3FoTEcvbEZNK1NUSG1FWCt6?=
 =?utf-8?B?S0Yvc2VvQkN6TEJNVUR1TFIwU080Z0loU2xOaWVEWXRXVEFQK2lpVE1sWTU3?=
 =?utf-8?B?Tm4xeHhZbW1FRFhsZ25VWDcrNVE3T1JCSElVWk9JVW80V25TaGpsZm85K1hI?=
 =?utf-8?B?YmlKcHRLQ3BqOEQzYXhBYjZrWXd3TWFyYms5eWd3UzY4U3VJalFqdlFkcXhl?=
 =?utf-8?B?TFVZU1Q1Y25kYTJMWVRtdklpZWRiRkZMYk9xcktRMmhCK2hPUktZcENFVTl3?=
 =?utf-8?B?TUlRaXU2eDBIdkY5ZDcyS1Brbi9iVUhiT3ZnWXhsRnJsNXZGYllVcXpod0Fj?=
 =?utf-8?B?UklqY2xqNmlEVzc1QU1JUk51ZDhONWkvR2dBcVcyVmhTNHRqeDUzS0tFeUVD?=
 =?utf-8?B?YWx6MTY4SnlJRndrNEFuY211YWQyUFg2dHVaWFprUU0yU01TM2o5Y3l0WEd0?=
 =?utf-8?B?ZHNXZXgxYnZJY1FseTlrQklyWEUrOGR5UWNmWEt5QTRXOEJybGovTGpuNEYz?=
 =?utf-8?B?WnVIUjhhK1VvSzczMmVVRTZnV0lHMkRiZGN4bnhCRXEzcURXbW9jSG5HYUpU?=
 =?utf-8?B?VjVMTW01SkRMd3ZiUmsrNnRJRkZtbFVvdmtEN0FLbTg2TGU1ZTdDS1BXZkZB?=
 =?utf-8?B?NWxYUllNLy8wTW0vVC9jYmIwNWdmWVRjR0x6d3c3OHY2VVEzUlU5Ync4cXl5?=
 =?utf-8?B?RjVTYktCUzJlVXZEamtXUzJLdlg3U3NCTXhnS211SmI1cGdMajBNQ0ZnaUJT?=
 =?utf-8?B?VkVPSWRQKzd3SGN1MUwvNXErd2Vzc0xzcWliS3hzYjNqeGl1ZUNuSjRKaVAz?=
 =?utf-8?B?MlZyZDF6Q3BDbGIxMm45cFFZcU5ESm9vc2FPMmdjOWJBMmdCQmFBbHZEWDcy?=
 =?utf-8?B?RWlpOXNXK3hnSXBkVVFHMkVwaXlCTlY1UjVBeGNwWHVGbEh0UGN5VTdUbkFa?=
 =?utf-8?B?QXI2b3BkdndPSWlzbzJWdDVuRFNncFQ0QXFxd0hsMHc4SDBxVDBUMlBNcXdV?=
 =?utf-8?B?TnlhTGFxV0loSU81OU4wSnlYenhSM1ZyMGh4LzF3VTcwYVhYUWp1RjdaUmls?=
 =?utf-8?B?UDRGeVJuK2QxZUlVZng1U0VKTWduU1dXSTJoY1dHbElZRE9yeVMvQVVYZyt6?=
 =?utf-8?B?YU11THdrbmc5eGJGNDR4cnBvSExqRVpOKzBzbFhDRmlYSmpZQk5abWQrdUQ3?=
 =?utf-8?B?ek1SZzlxYTloWjF5dGc0VFpyYkdneGZJc013S2tLQ0g2YWs5ZS9JQjc0cXU5?=
 =?utf-8?B?UWE3L0dNaFRkTWFTdTRnanBtdTF6akE2RlNkQkNIYnZnMldmekNxYWVJUDBt?=
 =?utf-8?B?b0hJM2IvdWhuVk1FQldKM21tcVQzbzdQK2dSM2p0Nkdha0ZiOFI0WE43bStp?=
 =?utf-8?B?OWJYckJHeGdKZ3RMNmtmTWJ1MmFUUjJMa1VGQTMwdHVoRlJkS3djMWZQRDVo?=
 =?utf-8?B?aDBiSm55bXc3aCtHZC9YSDFUdGVKVmFXQ1cvT0UvdXRSblQyL2ExY00rSVpS?=
 =?utf-8?B?OWEzTm5HcGsyb2xZZHJtZ2Q3RjZjaVFhTjNTbUt2NTJzRWJxOFA5UlVSR2E2?=
 =?utf-8?B?cEdYWmZaSTFVd3R1S1VJWUJUamRhUVRYcUROcTJqUFRhNXB3QjRLWUlpZUM3?=
 =?utf-8?B?Vm5oY3cxdXFacm0zcmRyMGZWSXU3cG9IZmk0VGtDTGQzOFE4dlIxdnZ2ZVBu?=
 =?utf-8?Q?yxLJvquTdaMKtrP3F4y/6y1kO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b4fde2-e062-4954-1be1-08dc5da8f45b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 00:05:41.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgbFQ2LPSP+N6wFi6bM47a02DUHqhD6MXdawn/j1HGcCnTo26rK/JQwmlRsu+KL4QOhAEO+IDlLsT3SOUU5OpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4699
X-OriginatorOrg: intel.com



On 16/04/2024 10:48 am, Yamahata, Isaku wrote:
> On Mon, Apr 15, 2024 at 06:49:35AM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
> 
>> On Fri, Apr 12, 2024, Isaku Yamahata wrote:
>>> On Fri, Apr 12, 2024 at 03:46:05PM -0700,
>>> Sean Christopherson <seanjc@google.com> wrote:
>>>
>>>> On Fri, Apr 12, 2024, Isaku Yamahata wrote:
>>>>> On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>>>>> +void tdx_mmu_release_hkid(struct kvm *kvm)
>>>>>>> +{
>>>>>>> +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
>>>>>>> +		;
>>>>>>>   }
>>>>>>
>>>>>> As I understand, __tdx_mmu_release_hkid() returns -EBUSY
>>>>>> after TDH.VP.FLUSH has been sent for every vCPU followed by
>>>>>> TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
>>>>>>
>>>>>> Considering earlier comment that a retry of TDH.VP.FLUSH is not
>>>>>> needed, why is this while() loop here that sends the
>>>>>> TDH.VP.FLUSH again to all vCPUs instead of just a loop within
>>>>>> __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
>>>>>>
>>>>>> Could it be possible for a vCPU to appear during this time, thus
>>>>>> be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
>>>>>> TDH.VP.FLUSH?
>>>>>
>>>>> Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
>>>>> When KVM vCPU fd is closed, vCPU context can be loaded again.
>>>>
>>>> But why is _loading_ a vCPU context problematic?
>>>
>>> It's nothing problematic.  It becomes a bit harder to understand why
>>> tdx_mmu_release_hkid() issues IPI on each loop.  I think it's reasonable
>>> to make the normal path easy and to complicate/penalize the destruction path.
>>> Probably I should've added comment on the function.
>>
>> By "problematic", I meant, why can that result in a "missed in one TDH.VP.FLUSH
>> cycle"?  AFAICT, loading a vCPU shouldn't cause that vCPU to be associated from
>> the TDX module's perspective, and thus shouldn't trigger TDX_FLUSHVP_NOT_DONE.
>>
>> I.e. looping should be unnecessary, no?
> 
> The loop is unnecessary with the current code.
> 
> The possible future optimization is to reduce destruction time of Secure-EPT
> somehow.  One possible option is to release HKID while vCPUs are still alive and
> destruct Secure-EPT with multiple vCPU context.  Because that's future
> optimization, we can ignore it at this phase.

I kinda lost here.

I thought in the current v19 code, you have already implemented this 
optimization?

Or is this optimization totally different from what we discussed in an 
earlier patch?

https://lore.kernel.org/lkml/8feaba8f8ef249950b629f3a8300ddfb4fbcf11c.camel@intel.com/



