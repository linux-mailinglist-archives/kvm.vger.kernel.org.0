Return-Path: <kvm+bounces-12441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3CE886310
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C64E284A31
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C71613667F;
	Thu, 21 Mar 2024 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K4hTiiQn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6031985265;
	Thu, 21 Mar 2024 22:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711059066; cv=fail; b=cE2VHcAhO/JpRRz83skCL/gbeZi6eMPz0pC43DrRvG0pwnoxA1T+q8oaz8l5SpxFNyI/jXzMw9bSHBuTKiSs5OEHM/V44BtgxbEh5AS+RjnDu4Uweou12Y8RqLZ6A43cu4mIuHXtsdvjJo86jj2+PVe6QG8gwOVrbJcRZvjl1Ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711059066; c=relaxed/simple;
	bh=hJwGElNJ+2S4e+rOLM7hk5OV6/M/IP8jS9jeLM8yGsc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oqhTJoiOlvVre0KPWPU4KZbMTJ8brUr5sqSEeXZCDWsn5Lygk9BXHLne5VXVVqwqoP0vokNWqkFrtU+uoNQVrgAPd/kC9IEV4bSRXYGcoVJs9HiiTMc4cPhOzjjcb66/Rcw83eaNoC5Xgi/Z7EOO4ro1WxlE1JPbQNwNESOr0rk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K4hTiiQn; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711059064; x=1742595064;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJwGElNJ+2S4e+rOLM7hk5OV6/M/IP8jS9jeLM8yGsc=;
  b=K4hTiiQnAX4j/UL5BT+UBzAwWT1pBm8yDqzEkrK4a8rp9jZXUThKzuVR
   2Cqg2M29vuBiCk6iGcSql9U6v5HQATbren4wQMJtoMEaeUxpoIpnkNiIX
   4PHPp9q0+V/45U3aGoMnKs6OPy/7b3aGArym5nWXGZzREWzSwcyzXtbbu
   RxSZIviSp6iKJaMFF3K/5Ekpf0PFYXLudtOMVWVC0ryd8gK6zWCT9iJF3
   JJeQ5qd430JmbmD1FPNZP2bN2ipJhuqzaxE7qOLSlClKBtQVVIBPV9w2u
   pJfiDqszVNYe4FJzHSiAtI53EvOMAmUqbQWxI/DSJ26++6/F+tYmH0mxv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9892061"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="9892061"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 15:11:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="14665942"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 15:11:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 15:11:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 15:11:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 15:11:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 15:11:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFspkeh2G+mHbvpZiuqKw+qm5U/1BCSbe4OefxalKwkkkpZJWhMMJCFhhsNR8WXuKQq65IdvtgMLhALKnuC8qchtc7pH820xhQwGEsH4BSanPn9WuuMrPZ626yrZp1qc0hGgbYA+eA/6jk82wyNbWZK5kj7D+NEIDvI/10PdF83aPGKTyrVQczkp/iqvY0M9oSqs2o80pSdeC4+m9/Ha2ceN/NkrVllUP9G71CkytDWIbvg5JoytkKDsqiEWhksOlFGnd/J+Y3W3vr31mSrjiUDCpznVf4KvoQCvIxYWqYkBU7yEA8KO8zz2GaBwPaShocUBrL5YvCF/Z+X5aYrzsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbrfA5RkAd714ac8d7Y5tUe8lnbSyeKRo3L5ebl6kbg=;
 b=gkvpjh+BxY6cprNR6kqZYyXNI+ol6wPOphoxLtlodVb+jSDgJeVpuWcm160xuFCE7WYj/HGfKktbELVs0gsdFNtgSqoFmGs3VPid77tmuY10pDcxq4Axz4S8wd6SvGgsrt++t8RhaskT7g/gnBSWFl2pYhXcHsyHBU4aYJexRChJV5XhQwvUmgDCE9DuPI4SX0uM0pWW5b7YR5T/tdTTZDzM4z83/4+kPASbrozYSOeti4Klzq6X0m/AS4BeRhK8keHZVQmXtDIwEcbvtdZ3FIhWzwHdYw++LnV4j8cw/w67nlZ+IdqBSgS6GIjWLhCru9PLWDAXAHb8Grr6uDXVHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8498.namprd11.prod.outlook.com (2603:10b6:a03:56f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Thu, 21 Mar
 2024 22:10:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 22:10:58 +0000
Message-ID: <9c35ecd7-e737-441a-99ff-27bda2a9b25d@intel.com>
Date: Fri, 22 Mar 2024 11:10:48 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <079540d563ab0f5d8991ad4d3b1546c05dc2fb01.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <079540d563ab0f5d8991ad4d3b1546c05dc2fb01.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:303:16d::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: 6190a21c-ef39-4ffe-936d-08dc49f3c984
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsYu7ic2YExzccKmn46TR8iCo1DsCg086v3wMm1aA+foSMJ78yLiCStNYqEvuWEJ9WJKloyBvZRbnjHKfFuVD39J8lIUUUP3qCcidvfN1DM6ikbDvHNplaxYHCZXVTQTxnJXFXZ2e8362CjQeoULC1NcpSUYKA4DKRSFUlSVqodZmPNsYuw03/juKEalvYqNnGtiXIzHXBKcrJOGIfKEnlFfRNNTmxH2g6c3WDHw3yJjS2xr0ZoIOsT8mps+oW7XpVguR39Xvxv4CtKJyGGTe/1SgELm7AxV9jz4kHqbGwwm31QlePBmtHNNpTNIMk1Ga1e3GAihfbItVRpW2yQHW+zUZIzhOs6U7eMtn5Wl8fp10BSgO+upp80jBR4uTuFNdksBweV8Q0lWw8f91LS81fXf+bfNPaFpHHLsmSAWDJXkNuBp/9Wrs4HWtZDnQsDBROmG/STW39O4NYkko9RkpY0Uw9GT4qB3ZlJnyQyk4TZ6bWYwpmqN7MdMaIHqGAXBOTkO5xHpqX9Rjy85Lw2SbV3Bi4i+0gU9U+HYA6KEkI8MF/vx/raguSvX94fGFZX6l0inG+VzgXcWEs49/SDbUSlkjHfKoQuk26G2cA1yQ1pASSB/4Ax+vitCaYmv5mgGYJjyesOsFFDJo/YLxws1TbkjI/zMPsWsT6xlYQDK+yE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czZ4dW9EbHJXaWFzQzgyanRDMWJpRXp3U3pUWjhnRUdXeWVrVjNWdnVNemZH?=
 =?utf-8?B?OUZXMUY3U1dOQ3hlTGZsdUVlekFka1UyTDF2RE5iMzBKL1dxY09vV1lFRVBB?=
 =?utf-8?B?UlFEeUVZQjBENkNJK1lFa3VTZnZZcUpVRjBZUnNVNGkxK1N6d3pxNndlaXA0?=
 =?utf-8?B?d0ZybEV4K1FSZjliQUFZTDlHRHlBM2YvMkZ0b3pXUUZET0k5OFBFbndPMzBH?=
 =?utf-8?B?dTRtc1hWRnhSQTluRDRmM1lVWTRlOEJ4OFFEUWwwbjlnY3gyT0JHTXpKdVow?=
 =?utf-8?B?VWxmR25xYmFQYWp2S1h1NjNqUHBtZlBRK1ZNQ3VOV0poeXVLNTJuZEpkaHhF?=
 =?utf-8?B?K0hYQ2VHSlZBSi9zOXdEc3NzekZjS2NRdVllOUNJL3M4NTI3UHg0WjJ6RURr?=
 =?utf-8?B?WHNGTFROckJ5eWRiOW9pMFdyL1RQYUZVbTdmWm43anZmZ1g0eWJSUmlOSmN3?=
 =?utf-8?B?QnlrRENISDlESnNkM0xodkdzRm5YdWJ4b05jYXlEbmFtNzMxdkRKeURYYm02?=
 =?utf-8?B?aVhrWVY0a0VaOHk1UUVTMVdSOWJXQk0wMzRwc2RuUGFveWd5ZDFPL0hsNTZQ?=
 =?utf-8?B?VjFWN1kwWkU0akRMK3JHZ1VFNjJReHZsc2I3aHpzUlV0aW4xNE45ZFA3aDZT?=
 =?utf-8?B?WDNQb1VEOGdYQ0RnL0NHMzhvUjFCSHovRzlnZmJGOG1UNUhWRlVrK3ZXSm5T?=
 =?utf-8?B?Q1NjaXEzUDllT2hhTlk2VktXMjdZc0VEcXBoOGFIL1E4MnBYWGt3U1cySC81?=
 =?utf-8?B?RjlqN2tFNHdla3AwcHdxQkpYNFZHMW1pTkZDaGRCQ2VMSkNwb3UxNThBNjBQ?=
 =?utf-8?B?d2VHSVFOaStSK2IwRHR6NkJzNGtZcVFqQ3VHRmo1Y3ZNRmVlVlA2TTYyWWt5?=
 =?utf-8?B?VGhHbHVmbjQ1N0NTNE1zNE5JQ2xxQm1Ud3BYTExpZzVXdjdCaUh2QzZmZmMr?=
 =?utf-8?B?b1JWNUxvYlhWWVd0Zmp6T0l3M1UrZ1I5em9pWnlacldudnc4SHpCVHl3WHJB?=
 =?utf-8?B?Z0Q5bjBLR2NzbGNYNHpEbkhFRDQzcG9heGIzNWxPcHJOdUcxTEM3UE1TSHRG?=
 =?utf-8?B?WjJVWE82aGZKckdyZHBqMjA1YzU2MkFYb2hRWm1pNy9ZOVUrcVdoOGtVZDli?=
 =?utf-8?B?MlVUdFprci9XQ1lWSDVLME9LTVV0eno4R3Q4c0Nkcnd0YXltTzl1Mlk4bERp?=
 =?utf-8?B?MnNIU09vQndhRlpIWlp1amlHVDBNYk15VUt1TE5LZVhwbExldWN0WU5hb3F5?=
 =?utf-8?B?WkdmRTFUL3pXNUNWbDJjckdDa3M2NlhoTkVKdFNRVW5VMFZURHpTbTFvU0hz?=
 =?utf-8?B?S3FMbHhrUTg4bklIWE9DZ2hiQnBwWVJjR0MxTzdXeGdRcVRidC8wK1pKT2JM?=
 =?utf-8?B?RTlCUzlOM0pwekRUc2pXL3V6aHZqbWpaMk1XNnMrNTczbW1xNlorMENSVXlF?=
 =?utf-8?B?VCs5N1RPRHhoOVZvNXhmRlY4RCsxNHAxbzU2elRYNVd0OSs5VXZDR3MwQ3RO?=
 =?utf-8?B?VlBHbVpscDNmK3EwaXBCK3NNQXlkZ2NUTHgxaW41SVZ6SXE0M0JJNjE1M3dO?=
 =?utf-8?B?Y2pSRnpYMUtocDd5OEJOVlRCeHZUQ1RQV0YraWNHYWdhZW1vZlN2UC92QVh3?=
 =?utf-8?B?ZkFrZWNmWFJ3cFBjNms4QUZsTnBqZXdNSFFqRURkZkNwdWVMTE9BUHVYdHpn?=
 =?utf-8?B?SDA0VXRCUGw3enlKSi8rQ0FHWHp4MjZzT3E2eVYyZjllQWgra0lKQUhtV2dN?=
 =?utf-8?B?Q21nVU9NVmtIS1h0dUFWdUkxbVZsY1ZQcVo1MHpwMm5QT3NWaG1wR25xUU1r?=
 =?utf-8?B?UDVmNzlubG5BdWZsVkRFaVduZjRKV2tXTHZ2YUI1ZDVnUjhBbzhvMjNtUHYz?=
 =?utf-8?B?bTZEQXhkd3ZweWU0Z0dSWW4xSkcyelhGczR6RGhWajlLMGdhNlB1WXlFS2ow?=
 =?utf-8?B?dnE0S0dkZlRiSzA5bFlvTFB4Sm5wMzRSY1AxUnVkbm1BRm1LTlFyRzQ2VndE?=
 =?utf-8?B?bzFxRHRLc0JWQkpBa2pKWWp6QWdwQ3B5ZXFsTWtSejJxNjdMY1hHM3ltZE52?=
 =?utf-8?B?c3k2NzhCU08vSGt4eVNFSnRWZHI0OXE1NzVRSXI2MUJDckRzM2k3eXVBZGRy?=
 =?utf-8?Q?BUlmXyezr0HZeUefiIJx5Of3k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6190a21c-ef39-4ffe-936d-08dc49f3c984
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 22:10:58.7832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQy4tix+Dj1Qpema3/CSMf0gTZ1OvegAwnJXcM74CNHlD+icFSdBXIaucdQF65TErnN7Ow5cUIqfQv2c6wbb0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8498
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, Yamahata, Isaku wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> guest state-protected VM.  It defined subcommands for technology-specific
> operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> are not limited to memory encryption, but various technology-specific
> operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> for TDX specific operations and define subcommands.
> 
> TDX requires VM-scoped TDX-specific operations for device model, for
> example, qemu.  Getting system-wide parameters, TDX-specific VM
> initialization.

-EPARSE for the second sentence (or it is not a valid sentence at all).

> 
> Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> TDX specific sub-commands will be added to retrieve/pass TDX specific
> parameters.  Make mem_enc_ioctl non-optional as it's always filled.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v15:
> - change struct kvm_tdx_cmd to drop unused member.
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>   arch/x86/include/uapi/asm/kvm.h    | 26 ++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/main.c            | 10 ++++++++++
>   arch/x86/kvm/vmx/tdx.c             | 26 ++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h         |  4 ++++
>   arch/x86/kvm/x86.c                 |  4 ----
>   6 files changed, 67 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8be71a5c5c87..00b371d9a1ca 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -123,7 +123,7 @@ KVM_X86_OP(enter_smm)
>   KVM_X86_OP(leave_smm)
>   KVM_X86_OP(enable_smi_window)
>   #endif
> -KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> +KVM_X86_OP(mem_enc_ioctl)
>   KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>   KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>   KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 45b2c2304491..9ea46d143bef 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -567,6 +567,32 @@ struct kvm_pmu_event_filter {
>   #define KVM_X86_TDX_VM		2
>   #define KVM_X86_SNP_VM		3
>   
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	/* enum kvm_tdx_cmd_id */
> +	__u32 id;
> +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +	__u32 flags;
> +	/*
> +	 * data for each sub-command. An immediate or a pointer to the actual
> +	 * data in process virtual address.  If sub-command doesn't use it,
> +	 * set zero.
> +	 */
> +	__u64 data;
> +	/*
> +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +	 * status code in addition to -Exxx.
> +	 * Defined for consistency with struct kvm_sev_cmd.
> +	 */
> +	__u64 error;

If the 'error' is for SEAMCALL error, should we rename it to 'hw_error' 
or 'fw_error' or something similar? I think 'error' is too generic.

> +};
> +
>   #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>   
>   struct kvm_tdx_cpuid_config {
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a948a6959ac7..082e82ce6580 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -47,6 +47,14 @@ static int vt_vm_init(struct kvm *kvm)
>   	return vmx_vm_init(kvm);
>   }
>   
> +static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	if (!is_td(kvm))
> +		return -ENOTTY;
> +
> +	return tdx_vm_ioctl(kvm, argp);
> +}
> +
>   #define VMX_REQUIRED_APICV_INHIBITS				\
>   	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
>   	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> @@ -200,6 +208,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>   
>   	.get_untagged_addr = vmx_get_untagged_addr,
> +
> +	.mem_enc_ioctl = vt_mem_enc_ioctl,
>   };
>   
>   struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5edfb99abb89..07a3f0f75f87 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -55,6 +55,32 @@ struct tdx_info {
>   /* Info about the TDX module. */
>   static struct tdx_info *tdx_info;
>   
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_tdx_cmd tdx_cmd;
> +	int r;
> +
> +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> +		return -EFAULT;

Add an empty line.

> +	if (tdx_cmd.error)
> +		return -EINVAL;

Add a comment?

	/*
	 * Userspace should never set @error, which is used to fill
	 * hardware-defined error by the kernel.
	 */

> +
> +	mutex_lock(&kvm->lock);
> +
> +	switch (tdx_cmd.id) {
> +	default:
> +		r = -EINVAL;

I am not sure whether you should return -ENOTTY to be consistent with 
the previous vt_mem_enc_ioctl() where a TDX-specific IOCTL is issued for 
non-TDX guest.

Here I think the invalid @id means the sub-command isn't valid.

> +		goto out;
> +	}
> +
> +	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
> +		r = -EFAULT;
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return r;
> +}
> +

