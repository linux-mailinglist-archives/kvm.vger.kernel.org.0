Return-Path: <kvm+bounces-70526-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJ9nF0eAhmmVOAQAu9opvQ
	(envelope-from <kvm+bounces-70526-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:59:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C520910437B
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E18883038515
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 23:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C149314B8C;
	Fri,  6 Feb 2026 23:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2TTdg0y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B75330E0F2;
	Fri,  6 Feb 2026 23:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770422324; cv=fail; b=nm8SdW4v63PIaHHlqT4YNMGhQF3dQZ0LbHDV3nZ6TnerYqolgv4QLqupe4CVxWasVSSy26+Yb/zlKl7+KQTYvAIybWP+O560foGq9MtaelcoaQQ9YpqUgXmWC7UKElpJYa7vRQRx+t/Nf9dB+eaaYPIrEdp5LG2Uf16x17Zk8mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770422324; c=relaxed/simple;
	bh=bzemOa3jwZvLhy8N500HSI/Z1T73g6v4XZtc0MrBp5E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lDbwGkmG3Oe+2zxbZSIpFbU0rmxhEy2XmlabfSnnNrBDAKcZEmy9uY77ditd0o8CIszO+mgAHcos1es8DXK25XrkFJLG/rDzfxTYHCM1Qw7wqT7QELu2mmqEKInIAR5mFTnlVP5zf436b9WXOnYfMBo9Ytyw2p/ztQXn8XFXIpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2TTdg0y; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770422325; x=1801958325;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bzemOa3jwZvLhy8N500HSI/Z1T73g6v4XZtc0MrBp5E=;
  b=A2TTdg0yq5eqhP9II5hPtyIYfI49gLflC2hX1KGjmZXbwu31qvOiwC5V
   aJmThzhu/Wvol/+AJ8HBGAjBBJMoIroaFvmoh6lmBJlS13/tCxX99SCUj
   LWNofJyFc1grTK/e/vYVEsyPnVwQAIPgkncoabhmMY1HnGgjhI6xaKaZJ
   4Xyy7nn41s5+FZzBNYMPAi5jRUUxlRVYIxgN1RqdWEvdAvuQ+ohwocz6l
   fF+ggUGM5k2xUFp3V1ObfjIt0acwHH1bHU+NaDhvGxJ6jKu22qYPXL2+N
   fN9ZeBtTzqedt95MdoiRdMJVe9Ly88d87bG4A0HjAvM0b4IAibHy4G+hv
   Q==;
X-CSE-ConnectionGUID: PVI6HFsBQBiwDVKLC7tRAg==
X-CSE-MsgGUID: lAu/XuKIRWK790M5V/59xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="71535965"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="71535965"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 15:58:43 -0800
X-CSE-ConnectionGUID: Tnr3uE51RM6oLC60rC+3+Q==
X-CSE-MsgGUID: J4vzZbJnRQ+5RL507z0e4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="210301133"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 15:58:42 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 15:58:42 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 15:58:42 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.52) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 15:58:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RetB/jMJNljujjtjWNZS4aVYtKAKpxpzXIUgh8ADKDIShfGS8e0epwT6VDjr/CihLbLsm5Nabn2m4niuAFnMbLv87OIhiA9NfNTKp/u+sqJt6ifQpAvI3nhgsiR54chU+70SB6eBFhy6gCxkp9t4jUwc0CL8GaaNJEMU7n47agr5f7Ig3G3pRuPh7dxy1zKM2Ni0r5cVShsvLd5LMubflTcG5NT3P0gHqKXDU/HcGGxDQAwuOuWCVT29xaDfRz7roMfCbK51TfaXqtIMVEFTh0/Vv6oBglIFUfzp9Kz6eECD2hmdGaLCFJeLN1+betsfWhL7JiHawG0sG7Du/w45Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ycf8vkhLwEqw1Yzbw+LjkrdUZGAQLKPtMWwZYcBghpo=;
 b=WnkMbfsZtE6Ot5ifjfxN9HvF2afGgma3MMOFZz1cM3AsMK8PsyMh9YDKHKEYmrQLCQz/rQCPmFyNkytyVuBOn000Fv9F1YRz12GYIu+WVa8dGvs6i+f9WzB5k6+QRppYIouF4dbJeRKMrzR72E3ORy3b9UJQ765FwAuO4wU1bEeJC/HcUab4GlroeyCSjsly45+xMGAw70oLeZavcd3+V9DLAjLh1erfqAxENs5qaAA6A6+UYBCiDDqUNIVFE4SLm6iqrUQm99yadJjScODCdWb52eU0Qvz3wdxGaifVOVYVf8fUcn/KW75gw0PgRYZZdTBdfPWJDWqSAZ7hfO4qzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6736.namprd11.prod.outlook.com (2603:10b6:806:25f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Fri, 6 Feb
 2026 23:58:39 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%3]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 23:58:39 +0000
Message-ID: <b7f04a29-0693-4df9-b0dd-c7c047c1f9fe@intel.com>
Date: Fri, 6 Feb 2026 15:58:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/19] fs/resctrl: Add new interface max_bandwidth
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <a4ca7d43100132b79adba85a4674c7b46b05bb8c.1769029977.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a4ca7d43100132b79adba85a4674c7b46b05bb8c.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:303:b8::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ebaf955-48ce-4983-5f91-08de65dba623
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WFhiU3JLbnhZT2hWYzU3OHRGdGlYdzFXZFRaSzUySVFUOHdWem1JRCt0TFJz?=
 =?utf-8?B?Q3ZJL0lrQkhVZWFlK1F4cUphb2ZMNkxESCtMeGhBYkJrNEl2cmlEUStOeW9a?=
 =?utf-8?B?bmhSVkNXaFZXYWliR1A0TUxSUkdZcHJaT0YzM1BCLzhjb3dUOXdJbWZac2FT?=
 =?utf-8?B?ZDBJbThheE5BN1lvalo5c3ZkTWJYWjl2V2Izbjh0ZUdLakxYaWlGSGVKdk1V?=
 =?utf-8?B?RXY4NURKS1hDUi9DR3BKUExPVHR1UVVaVEY0bHFLVUVjeU9aWmcyVUU4MVp4?=
 =?utf-8?B?eXF1ZWhYWWlCd21KNlZzK1ZKcXZwdkg5Mk9TWE1Obll2d0oyTVJPMGhqMGdY?=
 =?utf-8?B?Z0FkWWdvcnp4WUNqYk56NkZtbktIWE10UHRBQlV0K3JOZmREeGhYMWh4Skxt?=
 =?utf-8?B?L1FURXh3SXZ0dVozLzFJR0MyYTRyWGFveFVqVC9FL2NzTDluR3VvRFE4OXBT?=
 =?utf-8?B?L0dvZG5yZW5xeDVPdVVYRHJ2VU5xQ0hMcEFGRnd6bElBcDk3Tmh3UFlNS2dV?=
 =?utf-8?B?STd4R3lQZit4UjBLTFlrSFpLZW8yZTI0d0NMRWlmZUhLSVRLTVhrc25zRjlL?=
 =?utf-8?B?QUZGZGx4M0wxWmNBc1lEMmR3bVJRdTJZM3RSdjVDRjZsNjRyMlNBbTZDT2l3?=
 =?utf-8?B?dkdxazZYTU5xV1UxeEw4dVNmY1pXUHR3T2drSzhOa2ZDby9YVmpKc290WXI1?=
 =?utf-8?B?MkN2K1hzUzV5d3BkakNjQ21weVUxMGN4VzNjckpUQmUxVFNhcmRucFNMdVk3?=
 =?utf-8?B?R0FROTI4REJKMmJETk5BSUFCL0JBNURqZ245dDROMHZBSi9paVZlZzkwVHNo?=
 =?utf-8?B?ajBtT283SzJ4Mk9KWkxYOU94bjJIamZoTE4wL0tNOGVQQUNTVzZwYmlNV2tV?=
 =?utf-8?B?TFdyVFpGNjYvaGhUQVNXUUszVWVSTysyb244T0JWSW5mb1g0c29CejZ2WTdw?=
 =?utf-8?B?MVRieFcwemI0UTNSYldyVjBUNlVGZDI4Q2J1dXRTcmJIeWRuMktncFBGQXV0?=
 =?utf-8?B?WEJEQVlsTldHN3hXZktuaEJST21JZzNMQzZDTGJGM0UveVJLZGxUMGFvTU9C?=
 =?utf-8?B?anF3Qm9rS3J2TFE4Z3ZveUQ3MEF4UmYwWGo0ZDhQazJJV1o3TFJ4ejhWZEpP?=
 =?utf-8?B?THo4MkNaZlZtVkxiNnp4K0VpS3FRQzJPUmdjUnFKZkpqNmQ3NkwxeFd4Wk9K?=
 =?utf-8?B?UjFEaVlGd0hSVGZscHl3UnNSUGkwMFU5bzgrRUpCMkd5dll3aG05WFlaVGdp?=
 =?utf-8?B?R2hHTlBEUmFueTRwVnUzbHJ6TUp5YVJicXk4ZUpxWVpzKzdwUGtZc0o0QTNQ?=
 =?utf-8?B?dVdKMVRQQTU5aWxraXc0SGZlWHRCd2xpYzdmaHlmM2VuOGdBT3h3RlN3UXZj?=
 =?utf-8?B?NTNOaFhjdmN3QjB6eWJuRXEzWVhpNnNyU243VW9JbDlodUFvNEFSUmNLRHZo?=
 =?utf-8?B?SVpXMjJGTmluOVowOUhyZHdBeUhFZUl6M0xRVXNJb0pnWW5ZRTQ4UzNLYld6?=
 =?utf-8?B?ZE9jZU1iU014MW5WZktxdWRLRlF3dE84b1VkN2NSa0UwSHJ1Tk5HWlBGcDdv?=
 =?utf-8?B?Sk5UMmsvTTcwU1V4dERrVnN2UWlkS2J0VG1yejlpWWxTRzVHRXZjMW1hdXI3?=
 =?utf-8?B?bHhydWRTYWJ0eW9mWFNGNE5xbTVNdTk3eGtOd2ZPRGV5MnZEUGJvVDR3a29H?=
 =?utf-8?B?dnc3N25NdXBNZVRnYU15OVFRdFczbXZ2Vnhta2lnM3lBRm9jV25uR05uakFU?=
 =?utf-8?B?S3FpeG9OYWlVS3dualcwNUovbmtyRm1keTYreUh6enVsS2lURDEwMGJBa1hB?=
 =?utf-8?B?dGVNQi9xZnI1MHJpV0NzYkJkSVE1MTExbEUvK0dhbHJnNFpqbnNQY08ybGNG?=
 =?utf-8?B?bFJsWkQ0UDBVU2dObUZUbFFGTUVyVlZUSmVPcmNUU0U4cXRUVTA5WU5OT2lS?=
 =?utf-8?B?bXdvVWpZZDdpY0Q4SVNTUnF2V3VqS2hFemhXUERaeThobG5BVnNucDFIeEFl?=
 =?utf-8?B?VDFyYXc4cUxReEVmMExPNGlyZzJnRXl4YzlweDBINkpPNm9ueE1NNzRtQVZo?=
 =?utf-8?B?cHc5cUxNSnJnVEV6V1pUY2s4ZUU1enpPSnpKQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0xDV1pmYmp6RU42emdJSkdFRERUUDNWdDVRYzI4WlFLTDg3c0ZNMXB0VEVi?=
 =?utf-8?B?b3AwUGU5MEFsd3FvdUlMKzZucWszRU4xNzEzTUxkbHVCNXR1VHFTRnNyTEhG?=
 =?utf-8?B?b0l5bHlUZmNjK3hSUFlIOXEvNFRrV3Z1SDQwWGFTbEczNXB6WlFxWGtGYlM0?=
 =?utf-8?B?OTM1U2p0S0JYNDRMUy9ONHZoZVYyTW5pcHBWU25KQjdEOElQaWhGTDNNenZW?=
 =?utf-8?B?NEhQY0pmcGRYQUR2Y0o3YWRLV3VzeDVPNVUzNTVDZlZZcXJ1Z3hTbnV1TUhR?=
 =?utf-8?B?dUJjOFVhQ0RUK2JkbE5ITy9GZm8yaWRpelJXRE44RGxsbVdzeUFXdWdyZkRZ?=
 =?utf-8?B?Q0h1QzBDZitmdDZMVmpCWDhNWWwrdFQ2Q09qbWlTUnh2R2pzWTVadlgyNk9x?=
 =?utf-8?B?WFVhbW1sTkRkMDFxQ0UvRVJWRHpNVTFnWVJjVk9NUk5JelAzaFViVFh4aUND?=
 =?utf-8?B?ZDFCT0QzYUd3UGxEZnlwQ0pPaFNUSENCa1owRkhwZWxnK1ZJZXhJZ3cyRzhZ?=
 =?utf-8?B?NDEwbFY5eGFRc2NDREFQSGNWS0hlN25JbGdUTlhuZ3RVMnZMRUJJeWJvZnpk?=
 =?utf-8?B?cXlGRzdXRE5Dd2FVVFhSS3VkV3VEYVRxTXk3Qm1FRzBsdmRZTFVxdzY0TzZB?=
 =?utf-8?B?dlIyL0M2Q0ZWTFViWmhQY2xHM2dDaUNWa0ozamhjZnJjaFlXLyt5UitTU2s1?=
 =?utf-8?B?VDRnckxnY01NNUlIL04zZEdTSFJKOUJ2Y0JwWDlydmNQeHVrV1hZcm44WHd6?=
 =?utf-8?B?R1NFUzM2Y2tJcmV5VzZ6cFU4eFZyRVQ0SFVHdnBheDV5dVJIQ0p3Z0cwYmoy?=
 =?utf-8?B?bis5d2VERXRJcUZWT3B1OTcrbW4zUkIzK0NFdUNVdElNeDgwNFdrdkxDTzgy?=
 =?utf-8?B?KzNZSDVVa3pMREtxTDI0L2tqOXYrbS9iUFJWbnRHUlBWWWtRSmtxNjBYUEFM?=
 =?utf-8?B?aU42RmpGaXBNSDQvY1ZrdEZHN0RaZVUrTGgzdFd6QUNBd1BJb1pxeVZ2SENh?=
 =?utf-8?B?enR3cnBkTGc3dkFXUk9VMk5raVF5RUVsMmpIQy80bmp5MlVKS0xFV05yamwy?=
 =?utf-8?B?c3JPZk0xcDNlaXprc0Q3dmhyVXBPaXlFK2ZmMkZQVmdQVnVNQ3dmeXZJcXJI?=
 =?utf-8?B?SlFMbmVSMW4wWGZ3TG13TXFJcmdJS08yNHExbHVOSkJ4dU4yZ2pObXc1WEJy?=
 =?utf-8?B?ZkxVTmpQSFNVTm1ZcVllZVdHRlZ0OUV5cTJrNjNTYk1idmIwQmVHSUpXMHlE?=
 =?utf-8?B?Z1VHWFdxTGxldUQxUW5rNytzajJSWFRYUTIybURWQktKTTVXZUxidmRHWG0w?=
 =?utf-8?B?UDYxZTdvWkFZTmZac290UkZwQTlmdTI3N1preC85N3BaOTEvc08vSUNDWGVS?=
 =?utf-8?B?amhxam5QOVNKTHNPdEsyVVJ4V0FHb1JuOWxPS29DRFVvOFVoVzBUK3lTOThr?=
 =?utf-8?B?R2JQNTNyaFY2ZGl0UkNWRXREOWdqcTFkeGJ2NXNqcnBjdDkzaHN2NDVpZTBp?=
 =?utf-8?B?dHJyQ1p3eExpNytuWFVVb1V0NlJ5Zk1hMm1xS0l0SHJ5MzFSbGIwM25pRW03?=
 =?utf-8?B?L2FJSkxkRDR3Vzdtdm1xdkk4WVBjSWZjTFhGNzFEdmtHL0h6S3Q0OTFDZ2M2?=
 =?utf-8?B?L3hKRDlPUDVZNm1aV2pFd3gybzM4bzJiTVlDaVN3ak9jZUlHaHRQdGVNbnZZ?=
 =?utf-8?B?YWY3VnEwZDFvMUZJWHI4WGdONU5JSzB1Y3ByazNwd3JERkMwUXBGekJQM1Zk?=
 =?utf-8?B?M1dKQzNtN1N4K1R0cXZpeExqMCtxZ0o0dG50dlhjaURLU0grNXVHRzJpd3ZW?=
 =?utf-8?B?SEZMTkNiMGxiaTBZMnJFUVAzV0dNTHlUT2dFaUpCc2dkcEVsVmFoaUYzQ0tt?=
 =?utf-8?B?WHZxWHVDQnRMQW5hcFFON0lWaHRWVklNTGxRMjhHYlF6S0VDVlc0QXBtdzRa?=
 =?utf-8?B?YnNYVVlVeGNGSFUzVVM5SUY5dE0wUUhJK05HNEYxUGxUakhwaEJSMWNFWXhn?=
 =?utf-8?B?eGVLNWt2OHdMOGV4YTAvd3BBeWNmV2JKWWpkZ0RlalhwSUk2WHdjQlJhM3c1?=
 =?utf-8?B?bmk0OVJSeW5pK1ZTUWVINjdUMnNZUWhlbURlTjdNN0xGVElkdTNTUUtCT1A0?=
 =?utf-8?B?WUw3RythZC8zVHpQLzdvKytMZXV4OG1sWXN1enRvYVo1UnNla1JMK0dRT3lt?=
 =?utf-8?B?NE80Z2pnYzJLT3dDS1dXc1hWUkdSZ2c3UHJ3bzhFTzFsUlFWTnRrY3hZdjFX?=
 =?utf-8?B?M0NHMlhjVUE2aE9QRFU2RnlvMHVXQTl1OThaczB0b2I3STR3TXJHWjNYNXRt?=
 =?utf-8?B?R1BsdjJDYTlvYmN1VWtwNERiajZaODBwbEJwRWRlcjdsOW5NRHUxd3FRTU5a?=
 =?utf-8?Q?DSSWAtZfFeuF0bXg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebaf955-48ce-4983-5f91-08de65dba623
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 23:58:39.3774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBffJArT62NMTEqjkkmajQ7JFP7N939Wo/zsXk3TjQGTixv6CHhSwIMIRFgqXC53g7ScvETvmcg9xXGye17WwBTYMHQ/PyAHasO1CU3bCFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6736
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[43];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70526-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: C520910437B
X-Rspamd-Action: no action

Hi Babu,

On 1/21/26 1:12 PM, Babu Moger wrote:
> While min_bandwidth is exposed for each resource under
> /sys/fs/resctrl, the maximum supported bandwidth is not currently shown.
> 
> Add max_bandwidth to report the maximum bandwidth permitted for a resource.
> This helps users understand the limits of the associated resource control
> group.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

With resctrl fs being used by several architectures we should take care that
interface changes take all planned usages into account. 

As shared at LPC [1] and email [2] we are already trying to create an interface
that works for everybody and it already contains a way to expose the maximum
bandwidth to user space. You attended that LPC session and [2] directed to you
received no response. This submission with a different interface is unexpected.

Reinette

[1] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
[2] https://lore.kernel.org/lkml/fb1e2686-237b-4536-acd6-15159abafcba@intel.com/

