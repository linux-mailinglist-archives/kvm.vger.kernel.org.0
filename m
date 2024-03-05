Return-Path: <kvm+bounces-11072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7ED87297A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 22:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81D0F1F22539
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B572E12D744;
	Tue,  5 Mar 2024 21:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LS1DIpAn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CA712D1FF;
	Tue,  5 Mar 2024 21:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709674358; cv=fail; b=Z7V3FQFjGEiXbYICC1e9mT0NRFKKiENTG5vC5YJLdhMuSPvvy9o3JgMiZR7UMKTHbqwZdCAcC6BThRDQxJQVjZ7xfr07uDPBgA7TfXFOrz8I2HOMXUqSY1cgTXVIQ/zLsaDazXmUB44Mh68rbUVDpjuCBdU5imkScwIzYs3F9Bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709674358; c=relaxed/simple;
	bh=RuGex9Vx99tMfbCA5R7TysPi85AmWI4S7BVWGF4+81M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k5fJ/L2T0112i/cmQo65P3uNR/xRFMjKyMv2+IzhwSUy31yhYQfDdYBZw1JisnlpS5GS39t1OGzzBRk1SUhgc/YPMwIFcv0hiKRIHsmgZfGA58RTc/6pwxBoppKrMHJR+9FXnqhlz4Sbpbefxsi953KBM2/eYnc5156rZE2h3e8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LS1DIpAn; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709674355; x=1741210355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RuGex9Vx99tMfbCA5R7TysPi85AmWI4S7BVWGF4+81M=;
  b=LS1DIpAnWEwiC89r5jF23xRqVydS9lj6yH6IOn7dFrsug5sLesAFI/Sy
   rhmAHoYQOAwXxw0EGyG35GvEZfqFfU/VaxhgIDBkApsqpwq3L840m6m7x
   XL37hSEjQBI/WxntHPxccdIklTYeTGVw00MY2lrFRiZjt+1XFcHtBvH4Q
   EdJ+DzijHz/NXtjMy9yfDcG9/lxOzIYtz+x55Ug/ygRy5o2RCBHKXWxt1
   TucH+VMBuFKZHWd2y9rXIfkMRu1ufx85bwmyWhXW+ig/PGbPuDoTI9DQ7
   ZK1UYFv/AvbJR6AobFSY2a3NkZALGx7AcfaZ+V06LvvXRzKTbbgYkL9pO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4181117"
X-IronPort-AV: E=Sophos;i="6.06,206,1705392000"; 
   d="scan'208";a="4181117"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 13:32:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,206,1705392000"; 
   d="scan'208";a="9616116"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2024 13:32:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 13:32:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Mar 2024 13:32:33 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Mar 2024 13:32:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpOQb3tT6uFhbU9my9HAGC2E8fnOG+UKn3iHE6kQOSoMl6Ot5+lMv3uMdqxxMBiaStC8g/XGgJXHPBAs9sH1b5Nv8edSyk+v3Z5By/U3K5WXZAYtOiEdZzbiJ+pwwSbS7KMz0hu/ZGpWOqnoKTsDOkLQiwCHyVSfD02EHLslHKa5iZ8oLxXb5XD2Ya4skzMZUBLOqXZUYeClbvFo2QbRAnayAMO21DZ0aies6tQNaXGL/ko4IxkoHsidtrNTWGvP4X0VMbCavbNBJSqdpHtxCOY18VxKtK0066dhfUgKSbyupBNNiraBz2GeXSJAcfa0V8ENi9j/+sF1D+GLMJm49Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gj5GHuVxWwhhUMy7TyyKympYM+g+AtuSHk+8rkQek/M=;
 b=UuZSjK4wvrgbnlICMN9455aLoXQzQnf+BKcwYybBSvr1aqF75S7chDGSXpWS61RcppZ8eOR2oV5As5glT5Gf0lWLzoE3459G+htTq7Thuu8sKBpGA87kZmSsXE+gA2JjXDTQFI8E0E+DwhTW1vxlppL2cmwslR8ZgUGURmE2NGBDtjjO7if1cfHZkHyh0dTZW19PDwIuuaiPyq016aaY0VZzLYNDRlzfZzI6AoUMQukjKFm5Bv3SNcugtpUI9Y8nRz0xRJHFJV3LRrbb1nBxFG1nU3Twho2DvHLrABJApFAv5tdD66LLVPhcJAqo/CaN1uSZTXuFykLxc0UPgu/FTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8049.namprd11.prod.outlook.com (2603:10b6:8:116::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Tue, 5 Mar
 2024 21:32:25 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Tue, 5 Mar 2024
 21:32:25 +0000
Message-ID: <420cf8e8-88de-40b1-91a3-6660f7568494@intel.com>
Date: Wed, 6 Mar 2024 10:32:16 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>,
	"Yu Zhang" <yu.c.zhang@linux.intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David Matlack
	<dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-9-seanjc@google.com>
 <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com>
 <ZeEOC0mo8C4GL708@google.com>
 <05449435-008c-4d51-b21f-03df1fa58e77@intel.com>
 <ZeXt6A_w4etYCYP7@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZeXt6A_w4etYCYP7@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0100.namprd03.prod.outlook.com
 (2603:10b6:303:b7::15) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d44199-6677-4372-2bab-08dc3d5bbfe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WNK893Msp9x1vSfKIAz5i0ncnSBHLuJ4i1HqdyewKt5/e8JOUX1rtyGs1b0yQjSXR88aJmbHty5w2HF37xp8LveWKCXYMP9tukHwfeXPXS9kKuA3dD5q5HhKmNCSMN8q5/wQJaiDjcTQJ5Uhi8PCvijd5tRLaLonUb9EeDBkKp+OUyXKEqlYdoIZy/ydbmMUX6HTmTu5emh/2WqaK2H3A5Z3jRddT+I0bY5HdJ7FsKVG5FyuYmPWKKHk4By52KH07o+nzN3Sioz92PcGF0X9SMGAaA0CP1ZOZfGaVlnSgbRjSRH3JwjXdgH1bs/HzmCJHMs8mI5mxcUyaaR8fxDaaseqhcBLSLIa2ehCNs9fmlLvF3GjXGXtKqN3crd2aoRatHYMRrwDp3TZ5KlTXL4/BWotGxBje1eJagRBhokUdnvOMaaon6Bz7g1P3hNeMZnWe3V/lHhIBT1L8yJxW7Q+q2Bh2fko/9GJFhYfN8r/umYjZpLRRujQnRWfZ4rk2WS1Mp0YdM+l4mXEVN/Nj9K6BKw2QRkvsZ0CHN3x3VxRLp6X74ReJQ4aTsxt9EW7Ng4iLMmc2QJEIuylRveDlpSBzzZf3CxP4ly8zUkkB1T4EkhbXJTz7NYwLVHtvUG9pB7Rp/1/qiIoIxR9ivjKijAq2+j1rDS4ZTkL1nm6iFzOkEg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVdYRGpkMlVvdk9tVDZqR0ZBMDRxb2p4VHJ4Sm1Ua0svbXlhREM0ME5rdm1J?=
 =?utf-8?B?ZjJzQkZ2czJLVFFxTzRLa05lVkdKMEh6NWYvMlBqdFVKVnZtTDB2Y1cyUjVk?=
 =?utf-8?B?eU9GMFB3SEhUdDdXVzBjSnpmNExSMVNsWm1TcUovT3Q2VUxTZzBOLzcveFhP?=
 =?utf-8?B?T3RjV0tSM2NLdjVmV2gybU5nMGplUWI2KzlkbUduaVR6aDNjSm9XMzk5WFBR?=
 =?utf-8?B?UXE4L1RBRzZzQTQwVFF3QkpoR1QwYUg5V0lSbW1McWl0WmRmMXNyVWNCVzNu?=
 =?utf-8?B?ZUVwSjl1d0V1WUI3ZDlLNkNGTW50Y1RTdEt0ZXRXc0dpbnB6ZCszL0NMR3lV?=
 =?utf-8?B?WDFKbzV2MDFJNm9sMXl4VnFjUVJLSzQ0T1k4R0RBZm1LcWNDQlg5cDN0dTdj?=
 =?utf-8?B?Yy85T1FTMTRjOWVZYXcwSFoyWXNJeW1MU2tyd3FnMWFLN3lFZzFrQVdHOEEz?=
 =?utf-8?B?anhLeUdYUi9uVlkwNWMxdHdPMHFxdHE5d2VqRWNsU0xvZ1hYa04xbVd6Q0ho?=
 =?utf-8?B?Vm1qR1RWek9pOHBWVnVScEJ6QnB3a1d3eHJRTnM5aEVPN1JnbUxTaHIwQ2ps?=
 =?utf-8?B?UStlUHVsVEpNckhVRTBkNjJqU3IwRzErOWhiY05EM2p6Z2J1M3ZIeDIvOSt6?=
 =?utf-8?B?Tk02ekE0N2llMVBPWktSR2FBWE9FeHQxb3hyYWFYSzBqNENmbk9tSFZMSDB0?=
 =?utf-8?B?WExWNzhVdkZJYnhVUnd6a2I3bzJGVGpnTGJCaFg4T3hMTmsxKzdESGNaVDZ1?=
 =?utf-8?B?U0JaSXg2UHF5NW9TaGN6S2J2bVo2c2RsTDBTWlBjTmtFTVVwMlI3WG9sbklY?=
 =?utf-8?B?dThYeng3N2RYYmI3U1h0MGNmUHJjM3NRSlhabzd5enFkbkV6a042NEk4ZnRr?=
 =?utf-8?B?WlpLdHBWSmdFU0lhckFlK3pTZkR5WFdhd1NNc1N1ZlVJUEI3RjA1TlRlVVdR?=
 =?utf-8?B?STVoN25iWDhsT0U0OG1hQ0VBcXNYY1ViT0lyM0Y5My9vYUNuMEEzWTgwcEVY?=
 =?utf-8?B?amZYd3l2WkhaYWVqYXVaRjlJTzIvSTdvTS83WmxYSTF6bXg3QzRXMGxtcVZI?=
 =?utf-8?B?ZDhZZzlwRkdZU0lwS2lKckdHeHNSeUpieVNIcTFwRUtEZ213dmY3RmI0cFp2?=
 =?utf-8?B?a3hOV0RkamcwYW9HbFgwa0JZVFlzQU9odktLSTZ5dVNQWW0zMUI4STBCTFBw?=
 =?utf-8?B?NG5OS1J4T2Z2bWtqYS9xVW1BNmFNaTlpeXZWakFtOGZPZ29LazZZVUxabnZs?=
 =?utf-8?B?WEpOZlVMdHVSZklEcTYvaE5FSFFSNXIzUVBhcnNKSkg1NGg1Tkp0NGxrem5F?=
 =?utf-8?B?bklDSmIvSEh3WmRQNWg1N01VU0pRc29hSmZLamZaemJicDUrVEZYNDBWY3Vr?=
 =?utf-8?B?OFMwV0pwSDlGRjN2byt2VmkzQzFFUW9HZExBY0RPZTlMektIMHhDbXJqNVJP?=
 =?utf-8?B?VlZ2SHE1RnVHWHBaVVEwZUZVRzZnY3liaUQ2VTYvZjUzNjdFREZ3VHovblZ0?=
 =?utf-8?B?YXZBMExSclZ2QXpnakIra3JWRXZTcXFiWUdNM25tZjFIalI2ZVo5OFVMTCtJ?=
 =?utf-8?B?OVp4ZTR4QUd6U0VianhSdldtRlZXMjcyc0VYWDNvbDhKTkVvek5tTDVCQmZL?=
 =?utf-8?B?T3d1V2hBTGV0U2ZQUkJVWTMxUThRU3UzRStDQ0E1VWV5cms5RnY5cmY5NkY0?=
 =?utf-8?B?cGJhc2U2eFAwMU5VSWZicHlPQ3BQL25ZRzlGVWR1bndsdzZGcTdpUW5Vc0pD?=
 =?utf-8?B?UEVYRjk3WEdZVE9hOUZDQi9hL05xSGlnbFhZbnJtYWh3c0hIYS8yNTE0Z3V3?=
 =?utf-8?B?UlBsKzNYN3BPbGZkWTlwdHJBT0l0bHVFYU83UXNzK0cxb3NwUXpYVndzMU92?=
 =?utf-8?B?dkpCNGcwdnZpOWlxeHVhZ0N0eXdtL1JrUHErWVVPTXNuZVFEWnF2U3ZZNGFS?=
 =?utf-8?B?VDExVTNDbFdlUm5maWNtTHowL1BSa0lxWWJWc2VpMjc5Q2RDTWpHakZLWUNQ?=
 =?utf-8?B?b3BVM28yeFJZWHA5RGRJVENtRXBQNkVYMS9PdW9oQnJBSlF0Q3BkaENXQm9T?=
 =?utf-8?B?WlRTRmk0aWpCTVJvTFNCaWdaaitxbWlJVEYyZ2l3RnluRkVIWFQ4V2hqd0Iv?=
 =?utf-8?Q?cBGCr/edQ6JOFmpl8MHDABigQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d44199-6677-4372-2bab-08dc3d5bbfe9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 21:32:25.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QIwFKPWyGWEiSxSZJAUtwyYdE6qA0ojMoh3ERX8JPeE7BwYk4f5QnyVPmW3+Pc8oZIduoX7Y8pCrY7mmWjsDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8049
X-OriginatorOrg: intel.com



On 5/03/2024 4:51 am, Sean Christopherson wrote:
> On Fri, Mar 01, 2024, Kai Huang wrote:
>> On 1/03/2024 12:06 pm, Sean Christopherson wrote:
>>> E.g. in this case, KVM will just skip various fast paths because of the RSVD flag,
>>> and treat the fault like a PRIVATE fault.  Hmm, but page_fault_handle_page_track()
>>> would skip write tracking, which could theoretically cause data corruption, so I
>>> guess arguably it would be safer to bail?
>>>
>>> Anyone else have an opinion?  This type of bug should never escape development,
>>> so I'm a-ok effectively killing the VM.  Unless someone has a good argument for
>>> continuing on, I'll go with Kai's suggestion and squash this:
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index cedacb1b89c5..d796a162b2da 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -5892,8 +5892,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>>>                   error_code |= PFERR_PRIVATE_ACCESS;
>>>           r = RET_PF_INVALID;
>>> -       if (unlikely((error_code & PFERR_RSVD_MASK) &&
>>> -                    !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
>>> +       if (unlikely(error_code & PFERR_RSVD_MASK)) {
>>> +               if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
>>> +                       return -EFAULT;
>>
>> -EFAULT is part of guest_memfd() memory fault ABI.  I didn't think over this
>> thoroughly but do you want to return -EFAULT here?
> 
> Yes, I/we do.  There are many existing paths that can return -EFAULT from KVM_RUN
> without setting run->exit_reason to KVM_EXIT_MEMORY_FAULT.  Userspace is responsible
> for checking run->exit_reason on -EFAULT (and -EHWPOISON), i.e. must be prepared
> to handle a "bare" -EFAULT, where for all intents and purposes "handle" means
> "terminate the guest".

Right.

> 
> That's actually one of the reasons why KVM_EXIT_MEMORY_FAULT exists, it'd require
> an absurd amount of work and churn in KVM to *safely* return useful information
> on *all* -EFAULTs.  FWIW, I had hopes and dreams of actually doing exactly this,
> but have long since abandoned those dreams.

I am not sure whether we need to do that.  Perhaps it made you feel so 
after we changed to use -EFAULT to carry KVM_EXIT_MEMORY_FAULT. :-)

> 
> In other words, KVM_EXIT_MEMORY_FAULT essentially communicates to userspace that
> (a) userspace can likely fix whatever badness triggered the -EFAULT, and (b) that
> KVM is in a state where fixing the underlying problem and resuming the guest is
> safe, e.g. won't corrupt the guest (because KVM is in a half-baked state).
> 

Sure.  One small issue might be that, in a later code check, we actually 
return KVM_EXIT_MEMORY_FAULT when private fault hits RET_PF_EMULATION -- 
see your patch:

[PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if private 
fault hits emulation

So here if we just return -EFAULT w/o reporting KVM_EXIT_MEMORY_FAULT 
when private+reserved is hit, it seems there's a little bit 
inconsistency here.

But you may have concern of corrupting guest here as you mentioned above.

