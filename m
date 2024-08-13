Return-Path: <kvm+bounces-24068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F45951060
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 579091F21C2E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE161ABEA5;
	Tue, 13 Aug 2024 23:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5j49WlL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE5153BF6;
	Tue, 13 Aug 2024 23:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723591027; cv=fail; b=TErEy6QZaO1drhxEC08YTFFbQbSySQuzUDw0TdOAXOH0z1d0vNKsVQRV9kOnth58QWHT2NSqvXgQGjqRdzefOHZUNxUeZzWG74WKCBCTI47VtG61rRqkEHzKWYTngsDUY494jjglTrQHcTNJWohd3Iue9bFe+JqNnl/RNdLemh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723591027; c=relaxed/simple;
	bh=eedq3n9tyxL+CuTL4HwOAMAgek+9B/gI2BHPIq98Yvk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oACJJIN9abSq8HmqW8pSabfcChrYuQ4bYCI+YMzhMNLen6b4QNMqXxhQzElwOPymXS4KSyAlmpGM4htvoaGNxFZ3BUkMIY2JOQS/CFY7gvAkxNgV9i1HNyiUfIEnctZenh09Bxwg8NJ7FobD5xyR8IEYwTP0OJflT039bZucdIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5j49WlL; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723591024; x=1755127024;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eedq3n9tyxL+CuTL4HwOAMAgek+9B/gI2BHPIq98Yvk=;
  b=f5j49WlLOJ0UE+mX6SzDqqYjsF8ALpjQ/hKNs7RVc5+5/Z1JbTqutXJN
   cw4u9aDRMEtLdSHdkNZ7f3WEq79pN0JyLOcPvHd3o2r2eRobsCRSM+hjq
   kZJSDYwS14QvDRFALKLZKj9wRCTqj2u1V9LYSMcJ6PZ1+q5IZCqMojabx
   7kGzn/991q20BC2W88clqzWudR6yp78VtryAOVRkYce7gRuqOnC3SBl0+
   tQZYRTbeGtDHPS+goCgscRwI05d+XKJ8u/W83nJzFtahA5TFQVtpLgsVQ
   Cwjjz1EmPz+bXAuOz8GleIaS8I+3GNceCOm4oRPMP0UAGM3dZVslzRIdD
   g==;
X-CSE-ConnectionGUID: dac8C1goSFmvn1CRJDYYFA==
X-CSE-MsgGUID: Kx91V7vETE+OLuE3CNFSTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32928962"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="32928962"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 16:16:58 -0700
X-CSE-ConnectionGUID: o0y5VoEkSDm4USo4L+n+fg==
X-CSE-MsgGUID: O190c83wQVegwM1UukwGKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63669869"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 16:16:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:16:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:16:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 16:16:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 16:16:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKoFZy5UbzT7dG6sCDu9LLI6qaS3ylrEJGfuyji6BhPCOtI/PdJR2ViA38S/aFTXTFvbvV/owMqWo89xwN+DM66Whv+EprMmeqSOi0K8IxLLYRC51hZjFgXWuNZ8Uyh3iI0VhEX7HMws9bF/qkirAiALhF3WgbWaiPimpqtJvx6+6M0aLIZqqd8hipAGlfrrSrI6UkmwDDTjx9X0QjPgCoSh7fbVyryvBc3qTetlY8TWVa88OiL73AW/Pt6MCpO3hMPMdMehUU/HW0pQAlEMvwKyi5OBoFegKDngHr5om5R3R8nDXLrJ3LFHkHz/YtGxDGlkm4qCld647qSZvaxpaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jTPLbprtk3czDjCKYVH5ZNCC2XvVQXA/QQ45xqCPW0=;
 b=KvvkRYuboAdYY5VfTKKFM4i3VC4cUCf7fcPQfxSUz5agza68WCJypqDlEYctB54Eh1pBT2dNpXUUMnm5oF7JiTpi52h8hvjzDAh0eARAyMipLUsXP4dG55Kn3vai5lRSP45h2BLQSGZNp2sogmEdP26a4VDhJRQq851v9h2zI2kPbP1WZtsy4dAWf1dt0nZJU+wJH3Kv3ap0xHxIFEOXU3F3P3831mzNyNejLWE+hkvgq1G0/Q72HbmxekK5EuMGQNhLKO79fKo9UNqEbi6Ls/wSsNWLFyxaqViss1N99ZsUtaGTDz/uCXaIrUoZWB/ZPCbggS7PNNdxzc4GqP9drA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7659.namprd11.prod.outlook.com (2603:10b6:510:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Tue, 13 Aug
 2024 23:16:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 23:16:54 +0000
Message-ID: <d7ae5009-748f-4aa2-937e-d805a3172216@intel.com>
Date: Wed, 14 Aug 2024 11:16:44 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Binbin Wu <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <isaku.yamahata@intel.com>,
	<rick.p.edgecombe@intel.com>, <michael.roth@amd.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240813051256.2246612-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a4cbdf-9805-4726-43bd-08dcbbee050a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXI2bGZVdmRINnlLM2dyR3RQTW9FdUlNeUpVd0RjRmJGWnNCZGZuVTNpMEk0?=
 =?utf-8?B?N0VpY3RpVXVzUENITkNQTWlaVmY4amZ0TmxLMk1uNFREY2N5c2RRTUM5Y3JE?=
 =?utf-8?B?YTlrb1FkamxqYytEN2p2RGRYQ1ZiWE5CSUVvYmNiSGpmZWJFT3J4YmxkVnJT?=
 =?utf-8?B?dFFYKzdhbk9LL1FLQUFEb2lYMDRkdytzQmhKajFNaDM0MEtYRkt3TnhjczhM?=
 =?utf-8?B?dHFBMVNpWXMvMS94OU9KUUg4OGtoMGM3akI4UndneFZNSXZRbDNvTytuOE9V?=
 =?utf-8?B?VTlGY3MyY1llM2NzeXV4djhRcThJYUk5YUJUQTdoYlJOY0dhQ3Q2d0JGcFlL?=
 =?utf-8?B?ckIyZWV0MnZBRzlqUThpUG5kUnkrTVhMczhNNHlsaXdSOENwTWkxR09aam04?=
 =?utf-8?B?OEhYN3ZVeWRMMEhjVjRXUDJTOW1JTEQ1NWxoK0ZYcjFldnp0SnM3SStkYi9z?=
 =?utf-8?B?S0xKemkrK3hheEZjeFhhNU5DZ0hyTTVDWE5kNzNCOGloZzZCSUtTTlJTc3kx?=
 =?utf-8?B?Tmdsazgramt1c1E0Y2hlV0QxdktlRlJKbnZ4NmJvbHhvbnJQWFNWbWIva2ZH?=
 =?utf-8?B?Z2s0YWNkdTh6UTg4TS96YlFuc2lOTlBjbS9Fa1RhdFd1a05tMGFqcVJKWE9C?=
 =?utf-8?B?Nk1UQms3VHZoUHcvN012UC9nTmY2clo0eTBpd2N3a3lZeWViMThjVzgySUxv?=
 =?utf-8?B?Z05sTjg0dXV1YUdReXErbEZVZGRIVzRCMWJ2U2VlOFdLR0lEMmtEQ3I3WmVn?=
 =?utf-8?B?c0ppN0xTSkg2NWcxdVQ0dUpGdVJXL0xhZk9Ta25QcmhKZmJNVUVyeExGdVl4?=
 =?utf-8?B?T0lhMDluRHQvUjlpWkdVejFGMVRRMzlrVTVjdU9ObWRIRW15UHNRczY4YVhT?=
 =?utf-8?B?MERyR1BBTGhsZUNlakJCVXFqVVhWNzhuKzFJcGhwbTZZZ1ZINWN1U0pYREVH?=
 =?utf-8?B?eGMwc2FoOHlvMFRiUkNwSmMwU25MK04xOHZXd0ZGVkhVdkw1MmNZSG93TEo5?=
 =?utf-8?B?ME1CSEcvN1VYRG01SDJqMS9vb3N2T1p4aG1iOUZLZjNsU1U0OTI0dExqWHRY?=
 =?utf-8?B?Rld6UlRMUVBsaEdrQ01LOTJDM3Q3ekdWZWxVekxrUG5XenI4b09hYkpaa1FT?=
 =?utf-8?B?TGNqT0RvL0h1VDZqZjVUbzNYZjNwcjRJZ2tqUmNGNGF5eTVseXVyTDJQRm1E?=
 =?utf-8?B?U29vOFE5c1RZUmJSK1ZwU3JNbEl4VGZhNTlsNVliejNQUUlPbEFXaVMyMEFy?=
 =?utf-8?B?VWJXUE5RWHljcklwTU5NRGNJL242OHlxeUtjdHFTckxuM0ZiNzNNMERqWDVl?=
 =?utf-8?B?TEwxZ0lTNi9GTWRLT0dySk9LM3VjRFhRdTB5WGJIZlRpN2pPaGJ5NW82SUVN?=
 =?utf-8?B?QVdncWxZWkF5ZFBwVmxDT1RIclEwYUFQc1NBZSs2ZmJYKzNZVVFZdFU4ZEdz?=
 =?utf-8?B?cldZdWVycW1EcTVDeHNHTXJxaU5Uc0lXYlZXQ1F4LzAyWUJWVFdnSkNiUFF2?=
 =?utf-8?B?ZE5rQXhzTkI2RWtUYmtIak9UektqMzhLaFlDc0FuUHFtYWM1WnFNTWcxbnlo?=
 =?utf-8?B?RFZrRkpBcWxUN1gvazMwKzVtMmpIQ1pQdkNLeHpLb1R3aGIwU3VBQ0VMQ1hY?=
 =?utf-8?B?ZWpMRTdiKzg3RjVEeENZUjVzR2xNL3ROMGZ3QkVFWWxzbjEvNng4NzJROWkw?=
 =?utf-8?B?enFMbWsxOXh3bVdpTGFZa3VmWlViZkZ1VTFIS1V1NTQ0bDRRaVpEMnFHSitY?=
 =?utf-8?B?ZHhabWp0M09teFI0d1QwdGdLa0tUR3d2emdmN0k2Nldlb2c5TGZhZ0o0d3B5?=
 =?utf-8?B?QUllaFhPZ0ZvUWZmWmtJQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmtFTzlPMFNwOEp2UGdXUTFZK21vbTRoS3ZXcjQ0azdINVlXWXA2cWFXSXY1?=
 =?utf-8?B?Vi9UcmJlalBBQ1d3ajZlbnBBbHEycVpmaXBwTmZPc1l2eW5jSFk3U0tTajEr?=
 =?utf-8?B?OHA1UmdQVGRZYTNVdlRwaEw4RWxiVUh2TzM1UVBzZlNqTUxuaExTdU1pdlNy?=
 =?utf-8?B?MEFBRUdVUnBhZEtZK1ppbjREcG9Zd1A0R1ZXcTB6bVZEQWJseUU4VUM5ZDhj?=
 =?utf-8?B?L0pYTWlVMGxLUWFqeXRsN3F0R1hyUzMweEVyNWsrU1BTcnd0NDlWdm8wNlBq?=
 =?utf-8?B?VnNvMXBoV25CM3BlNGJMOG5zSGg0TXNvTnZFUVRmTGRwbExQQzh2ME1aejBI?=
 =?utf-8?B?amkrZngzM0NIbnM3elJaSlFLbmlVcmFQaFY5RWtyU1FWeWNRbVlNRm9VMVQv?=
 =?utf-8?B?WDdNNHZOOXRXZ24xMjVUY085cSt4ZnFqdk1JdHUxekRudmY2dDFvUWY0RXNH?=
 =?utf-8?B?Wk83SmswTjhxdzNOckhjazRhU0NVdVhrSzhWd0MwdGluS2FiU1RkcUtaNWhL?=
 =?utf-8?B?eHpoQkJDZThDaXRKT1o0OGdqVmhEcjJqc1VMNjQ5Sk55VDU2QllWVXI5ZzdE?=
 =?utf-8?B?Z1BHMjU1VG1USVllOVhUbUprRVQ2WUpwUW11dGE1L2VuU1hTeEVFT2dhTWJS?=
 =?utf-8?B?clJ6NmNMcHFDYUpDbGlKVlhTM2NmdkdON09ycHltdW05SXNjS1J4VmhKT0JI?=
 =?utf-8?B?K3o3UGZYZ1dwUXdCS21RS0xTeDUybGFLTmh0YUhxZ3A5M09raUdlWDlYNVhF?=
 =?utf-8?B?U3BlaDdIbHg4MW5Hdk5TcFJzN0l0TmdLblM0MEhCL2pTT1NxMVd0NVQ4T3pu?=
 =?utf-8?B?RGp2SFJ6T3dvZk9ZOHRnbXdaQ0ovcU1MdlpuOThSaUNORGswT1YwT3VHT0Vp?=
 =?utf-8?B?RHNMZ1FVNnpxL1ovT3lSWjh3Ymw0VGI0eEc5K3p2R1V0ZXVYTHhWOTBGVVBE?=
 =?utf-8?B?TjBUbmtJaTZTa2o3Tk9Mc1ZNMlFzRHRiTTJDb0M4NHhsaVdQUlVwRVpXVE9k?=
 =?utf-8?B?SjlGNEh2YnJ4YVhLaEhRc2ZSMkYzbzBRb3l4dDNWWVJCbGNFd25IRkYzM0Nj?=
 =?utf-8?B?amI0MDI2bFR0QytsaDNLQTlHWUJDemV0ZW5ySXpuUFlWNTNLSDJtZEdReXlx?=
 =?utf-8?B?OFZDUjZzbVg4K0ErZHExbmhhekFrekJsWWNBODRtWU9RWDc4cFBzQjVvVmdj?=
 =?utf-8?B?YUx6b0hOb2d0ak5obWdycTZqVXZHSWJpVDAvVkVnNnpGMmk4dGZuejkzZ3VH?=
 =?utf-8?B?eHN6aTVXMTRvMmRUdHo0OFROaFM4NmhCYTVMRS9mbzFGT01lcVdsaHF3MG5W?=
 =?utf-8?B?cVNWWDRhT0p4Ym9USkZvYlF0K0daV0o2MDhQUys4ZUd4NVgrTDNoMFViazF5?=
 =?utf-8?B?VnJDckdEaWFNbmJ2ZUlZVU5PdW5MQXlvMHZoT29qZXluSTMzNmk2OUZGTjdC?=
 =?utf-8?B?WHlDU1p2YTFmRDkzZitYakNUV084QXVMbE4wWDVtcUhFVkJDZDdTZzlIUUtv?=
 =?utf-8?B?TjdhbnV4eFZvdGwvNkphOWUxNlB1NjVyTGdjRW1uaHdXajI0allWS0s1OW42?=
 =?utf-8?B?VXlqRTRzY2hqTFVES1JjcDlXZ28yRWM4bmNqanFNSVB2Y2Z6OVZGbW0zSFBY?=
 =?utf-8?B?VUExM1o4MFF3VzZSMlIyby91SEFxQ0NRemV5ZFo4c2RFUnhRYWZXTXo0bkds?=
 =?utf-8?B?Z0gySVUrMDYyVmRXcHRNYjJSTk1lbTFvNlJ5Mm5YaVg2VkFhajJWcGRuR0hm?=
 =?utf-8?B?dGJrcEtDalJZSlA3cUpjTnhXUVpDTmJwMVpDQ1NkTTM4YjM4V2lBZ3ZyWVgz?=
 =?utf-8?B?elhUSG5mQTZYNFdHODRjQzJ2K2ZRb2YyWXZDK2dDNmUzVmsvRythMElRRkRt?=
 =?utf-8?B?THlzMkttYWhjVitZTmRZZUY1SytHMVgzQS9HRnJWazUxR2lmOHVrMEExbktu?=
 =?utf-8?B?N2M3T1NPd2MyTmtJb0hmTDRuUmFGY1lBTWs5cDIrQnI3dTR3ajZJdUVoZTJT?=
 =?utf-8?B?TzVQd3hVMzI1RVQ5Qm00SU05KzdmbHhtdHlyZjlvTTRNTmNyUFpOSzJFRnlh?=
 =?utf-8?B?SmNCcmwrTUFvd2hoR2V6ZnZuRzJYZEgwMXNFM0xQSTFKQ0tjUjVzaS9LeVJo?=
 =?utf-8?Q?2GSr/4ZVxb+EAZBLviCNglkr6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a4cbdf-9805-4726-43bd-08dcbbee050a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 23:16:54.2364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCkICX2G3oLS8i1y+kN+aFkHq6x+tRsYPj5xiC87KvDvUO4KieXC13zeQE1iS94im7gHgEYoMTv9xL8nV2UptA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7659
X-OriginatorOrg: intel.com



On 13/08/2024 5:12 pm, Binbin Wu wrote:
> Check whether a KVM hypercall needs to exit to userspace or not based on
> hypercall_exit_enabled field of struct kvm_arch.
> 
> Userspace can request a hypercall to exit to userspace for handling by
> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> hypercall_exit_enabled.  Make the check code generic based on it.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

One nitpicking below:

> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   arch/x86/kvm/x86.h | 7 +++++++
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..6e16c9751af7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>   
>   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> +		/* The hypercall is requested to exit to userspace. */
>   		return 0;

I believe you put "!ret" check first for a reason?  Perhaps you can add 
a comment.


