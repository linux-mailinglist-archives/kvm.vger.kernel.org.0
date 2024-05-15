Return-Path: <kvm+bounces-17474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3F88C6EFF
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EB031C2144A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1620C4F5F9;
	Wed, 15 May 2024 23:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6KGvYDq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7142E101C8;
	Wed, 15 May 2024 23:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715814910; cv=fail; b=kdgQ05N5VH1orgbmYd4/3hFfoA4LFYr4on++oS32Km5p4Me28KhZT1LEW0OfV+QaAYGkP7s3Q22Z+SwDbRctf+fyq4/rcvlwuhKDlGXwdSoGsIjoEOletVEcOACuT3AOKMbEVnWYLEtWjFT7BOzCjDsmxBpbBWtiqQJulVl8+Bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715814910; c=relaxed/simple;
	bh=xjbCH5GsnNd35AvYanlrtikHiiHhDvJkDUGV7C6mR54=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AexV+zAIVMMHASE19DoLRY2qM6tgUY6kN5PUGWNn1t/eygHFv/EH7YH5PLeSkt3UsSVluyytawELXcNHnXUTp8AE8RUFkA5rrSkUP6faCIfAACxsJO+UoSnNEOvTXfmL4yqkKALzLRnP0jDl5rn4AIXXdufNnjNaZnX9fwoqozs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6KGvYDq; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715814909; x=1747350909;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xjbCH5GsnNd35AvYanlrtikHiiHhDvJkDUGV7C6mR54=;
  b=C6KGvYDqEwFpOGVipgEiPgEgZj4CubvoA4zKmhULwIT3nOzgRygpWXSO
   jgtmz/dBYuC5ZiDIAudX92PXzudZ40je8bpmgyrpx4i0UO6f2jqpVGw+v
   i2OX0/YKcvY5jq0lILgzDeToLKj7/vQSKzWEMtZOM8OFsRk4lALk6VyTo
   4XJe3zxOMbKIK/w9DUzmgUnUcQN8yEfE0Dh4NIX9SN7qKM0fQQDF83Ngs
   zX6Qo4hPXJND4snS0ItmHcRuBXzp2GOSvAefg+5Spj3nQjJ5Ug6mRp2Xf
   vkJSpSn+41ygXwiWK1Esmrmm705tOel0I0LdA1qhR4srKcUhI8VJbOno1
   g==;
X-CSE-ConnectionGUID: 9VbP27VlRQ6zsMKnhnriqw==
X-CSE-MsgGUID: 3z1ELb1MRPulE27B4hyPfA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29418249"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="29418249"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:15:08 -0700
X-CSE-ConnectionGUID: MP8nona/RbCQm78if8/61g==
X-CSE-MsgGUID: rMXrVP4/TqCqvUfjCy5iXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="62060119"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:15:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:15:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:15:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:15:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:15:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaSkDXjMtYXozqlCYbFjDyDS0JnaYmngUMdGDzgyftTmnmzbiLEW51a2iyV1lcZxTHFQKlc1OLo9aMMTQa622yASAPyv8mxDhaTQYcDUW+TvoQBJ3VCTuLRa/QnkRjy+FjYnuBcDFS80lwAv5x5E49GapI/E9bQdYQlYYInJRa9UcvmnDkRgm0No0g/LCxn760dEgJWsNrtrFMTe/+5NRrP7c0cvcveB740+npFRclSjQCemsHQcnBBhlFFAPchctlk2bMj5BlOXqcvbeGXkEEdAokPBMP/o5sx1pL2PE32KOOyjpGkJPlr6Fvf+EtYJ6GG2UqI9UXhobiUrnJbOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FANOY3NcAaUm5l8STRrXxbFdR+q2K3/4E0WmbuPTcnE=;
 b=iyf2r30mgt8rFke/eLNv2+7bcspiKoRlJivTsVFmq+K3aCcV9uiX+dRJQ15iNF8s3FvkNekxQJMi1l19e3kD0Ndw/NTzdDdwqPRXcJmsq+Qa89eAchTKQ4aSjXy4ovpNO4t9eKU47BhZIupcOgoAexk3gMVHwS2VioexagxH5u9X70XIP5rHu1qWEP3K+4WcVx7LSytHtYvKRF/hLT2FG0xKA6U5fzJ/9qEP+Gb4lb2zMj0Jxz3JJ7fP4g9g8TDsfFCcN7m+kW8AXSIvtE7HrSSa1WbrglR0c59GQLY1sHGq/kgqkiYzSNXhOBhm17G+8hwANANKGOVBwFkbD4A0sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4595.namprd11.prod.outlook.com (2603:10b6:5:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 23:15:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 23:15:03 +0000
Message-ID: <bea44699-f0c0-4904-bbed-a987b1b97cf0@intel.com>
Date: Thu, 16 May 2024 11:14:54 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <621f313d3ab43e3d5988a7192a047de588e4c1f5.camel@intel.com>
 <d0c16dc46ca0b21bffb2abeb3227d4d7f63ebaac.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <d0c16dc46ca0b21bffb2abeb3227d4d7f63ebaac.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:303:85::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM6PR11MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fad2481-2222-43dc-9a36-08dc7534da04
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aFBrcXB4MWZxUEp6NGUxbVc3Y1R3dzZLcm5qSGhpUVV4Z2dSOEVxZ0tIcldZ?=
 =?utf-8?B?T2U5UUdram96TG9sSkIzSVVMSHZqVjZjM3F4VFdZLzZPR2lxSGMvaElWc2x6?=
 =?utf-8?B?Y29wOWNDdzFNOTNlQmJYa3V5Y0tnT3hYVW4rQ3VqTE9WY3FQQS9WaTRwTVJH?=
 =?utf-8?B?RTNHN1FkSTBUVExaVXRiYTRHY1FZbU94amlnWDlXVTEvWnZqNERxc203RCtH?=
 =?utf-8?B?L1JaNTdnVjkrNFd4Qlp4ZmEwRm1MZFBwd3ZERkxVWDhtVTdqVVh2VkVyaUNw?=
 =?utf-8?B?S0xPUE1SOTF0SFFVbFVLTHJWSWxHeVY2aGNmNnMwamdIaHpJUzlMS202WHVy?=
 =?utf-8?B?OUY2clRkWk40ZUlibERsTkxMRVVZbGROenVZQU1vK1pXK0ZhSktQc2ZOa3JO?=
 =?utf-8?B?dUpNei82MmV4c25sdkdlZ292QTFTMjFqNGplZTJpRDRzeEJMTkF1WlQ1Y3Vy?=
 =?utf-8?B?akZUQk15bDd1UTdCekF1OUU3RnRic2pEZFRJZmx1U29hdUFKaHpIbE9UMGJK?=
 =?utf-8?B?VE5MNXZxMEg3Wm05SG5XVFFJTUQxRHFLTXY5b2hVYVZEMkhNblY0N0RmZXlK?=
 =?utf-8?B?TjRNSDZ6Qy83NGtUS05SSDUxWVBmZnFWY2lYWjNmWGpoeTBhUzF5a3I0RnlN?=
 =?utf-8?B?Z1NuOVdmMExLMjM3dDl1ZytSTkw0d0lrNXJLaW5uaFppTTg3eDJJYlRpYk5Q?=
 =?utf-8?B?TTlxT2JScnNmMmxXUElJaE9yVmFOSFRhUHFUeDk4eE5vcHlSb3IrcFROSmEy?=
 =?utf-8?B?ZGhzSDh2SzZYY0ZyRDlMSTBTTFpIbkIxZlU1c3VNUld5dnFjUjdOdFdJVE5i?=
 =?utf-8?B?VDNkNFRzbHlPRlVsVUZEcWpUaU1maHBmREJETGR1a2wzNHVwZjM5TC9WTHAx?=
 =?utf-8?B?L2JGbUdXQ0VQRmVFMHdmS2w3dVdueEhwVTBaMWphcWkvU2E1aGNBWmxlaXpy?=
 =?utf-8?B?SkI2Z0pGa2pURG9ZczZKYTRSSEIwaUJLZVY4em90emlvMHl6V0I0S2poMUFp?=
 =?utf-8?B?cHRnQjJVTzFONlBnOXFZejM0cUt3aU9kemw1Rk9FV0E4S2xGZ1Rzak9GWi9u?=
 =?utf-8?B?emlkWXE2K29pUjU2RGRyTzA1b2Y1MFgxZ29EQ1ZiR2FHQjNkVmM3S1M4WmM2?=
 =?utf-8?B?MmhGWk1jR0puKzdCSzlYcWV0ODBiZWVYcFNBUnBWMEU4WWF4MGsxL1RHTkRE?=
 =?utf-8?B?M0JJWWFGdVNzUkVDcndJMUlQNzdHNzJpWHN2OVJtUkFvQ0RTYkRHVFgwWmxH?=
 =?utf-8?B?L1BYSi9XQWRHMEZ6WURrYXIrNTkxR1YrMGpvZnpYQmtGSUh0cUw5d3hCVElR?=
 =?utf-8?B?ZEhvaWMwenZBOWNkbng3WXFVV2RiUVE0RldpVXdFVU0xLy82WEN5dkN4MFEv?=
 =?utf-8?B?R1VzYkhYbVpwRGthbEdRa1pSV0grQk1zZnFwUEN5ZVJMQWQySVF0RDZTYXEr?=
 =?utf-8?B?MHBHczZOYkNlNEU3V0prNVJzS0pMa3RVdk9Dcm1NaVp5aVBzdGovbG9vQTZQ?=
 =?utf-8?B?a05yUGFXVjVpVnllN3pBMi9SbEo5bk1xNXJ3d0pWcC9tYjNrQzkvZHFkYWRV?=
 =?utf-8?B?RlRSTzJxQ0YxWVhSNTNjQnNiY2xYU21HSmVOendSbVNMQXJCb1BQK2pQbXV3?=
 =?utf-8?B?alJOcmNMdC8vRzI5NTJCRFBRSExiRE5EZjNweWVSY3gyb2RReS9qbkNTWDRm?=
 =?utf-8?B?cy9aTjRKQ2FQTlZJWlFNVGo0aTB5WnhLMTlEY2NxYmJVSXRQdEpnd213PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WThoQjBNNWNUMGNmRndSNEs2RCthNmgrV1BDWWRtcU9RT0g1VEdNODcrTmM0?=
 =?utf-8?B?VUdpb3M3SGViTEUzVFZyTWJrbi90OEQwbllqcEpZajdLemwvNCtTUVYzS0Zv?=
 =?utf-8?B?NXVXemRpZFZnQktGZDUxSXJJTEw1SjZpOTNDcy9velhuNFVEY2UxZzZuQWo3?=
 =?utf-8?B?U0NMODBLeTRmbDhoUGxlRlBYZ2cyVkJjM2RkVXRwTkRLTVI1Z3FqL2FWem9N?=
 =?utf-8?B?d1dDYmlOMjhhRGFac0crVHFidk0xWk1sRzBURDVUTTNKampVZE8raEl5Y242?=
 =?utf-8?B?dVZmK1FNTDloeUZ4SmQ0bGJZWkZJMVk1WjRqOUtsMzE2ZkNPTzk4OVNjNitC?=
 =?utf-8?B?S1FZOWx6R21NZXZ6QlBYVHJEcDhqL0F5eEMzU29jdUdpckxqMjhxYlRNaE1V?=
 =?utf-8?B?UFZGQkl2RkNGUkRtTFpZdVhyTkIzLzRPRnp1bFpwZTU5UlRxL1cwWUJpUWVJ?=
 =?utf-8?B?ZVNxeG9BZk1jM1VwTTA5bUFDSGlKbUt1c1A4KzNkL0tvSXRTRVZGNzFkWXRx?=
 =?utf-8?B?NlBLTW5XV1lBNUpaT1gzWVFLVDJLQTd1UU5HV0VONEVyNVBXa3lMUWQwSlA5?=
 =?utf-8?B?RjlySEJvNnVoUlVWUFBlM3ZibC9QWE1GdWVVcDRtTzJrcG9mOURRczBxTlhN?=
 =?utf-8?B?L1VQcWtoaVMxYkpGOHBsYWEvb0VWZ1RkejBBWGFzLzcvREZxeXdndmU4T1hl?=
 =?utf-8?B?Y3Nod0pwcEhzZ2JtRUo1ODZxWlEreTlaQ2F2UHFnbzMwOXdHRTk4TExqZnlk?=
 =?utf-8?B?ME5qUlh4VkJ6Q3BkbEtMYjJER1FsTzdOdjQ4ci93VDdPZ0k0Vm5wLzVXNlcv?=
 =?utf-8?B?bTNQWHJqdDNDMDhCR1N1NDhlejVqOG5vMnkySnpqZkxZTGRKcml5L3hYdW9h?=
 =?utf-8?B?SDVQNmpPcWl3RE8vaVE5Y3ltSjhkSDBIblhrZHVZSmVCYVJjWi84djg2YWg3?=
 =?utf-8?B?NEd2VG5wcmNpeCtKRXJvVUY1a3JCVjk3ZmFIT3pZK0pieU54aDJYeUlEYjU4?=
 =?utf-8?B?aThNY2pRYnd1dEZ6UnVPaVd1d0NoM1NHVHhjWW5JeTQzUDlQTkpBNHVFYWtv?=
 =?utf-8?B?Z0puaW5qWUJHOEFFc1hIT2lJSDZFc08zODRFeEMwRGlrNXZaRUtJZGRHL2tl?=
 =?utf-8?B?Q1ErMEhGeEt4dHJ2OG1aQ0pqS1VocjdFV212VW4wcmRxOVpoVG5VVkRHTHl5?=
 =?utf-8?B?MkxCQ0pURWhtR1JvMnoxc3hNUkZocWp6N2ttdXNNczBzblRaUDMzVDNpNzhv?=
 =?utf-8?B?K0E4TlNDL2xxY0VIdnlya0tzNFJrRjdPWmd3NnZKdEtzUGxyMGVEVmFyWk5q?=
 =?utf-8?B?Vk1XMFJrbzlHdGczYSt6VzNMckt3MDJ1bXdXUVJWZ29iWWZGVFNrNXZJOG9r?=
 =?utf-8?B?WVMydk5tZUlWa0xkRGhHbmgwUHN1WDVNYUVIVzh2NkMzRzJyNFkwYkdZVXV0?=
 =?utf-8?B?ZGpUQ2ZJcjI5ZFJRZkYwTUQzSUEydzRyZkx2OTNWMkFTVTdJUmRXdW96bjhR?=
 =?utf-8?B?LzJHek91ajIrMENEeE5odDdWbGdTNHpQK1NUZEVzL3pxWkZsN0ZjcUp6UFNF?=
 =?utf-8?B?RWdra1ZncXQzM1NodjlzNGxNc0lYaEk2UExWM0VRNkllZ05NVldubjFOM0wy?=
 =?utf-8?B?RWh6alBnbGxZbXBQYVdPQ05CN1V3MEdvV3VxUFF2NGliQmVLeTErQy8xdmdn?=
 =?utf-8?B?M3c5amJwMXVmMzlaUlpUS3F3NWVIMXl3OVYxemR0QTUyakVOWGQ4cmthNDlx?=
 =?utf-8?B?d2FQV3hJcVpDL3RFQzZDM0hkSlFGYSt2MlgwMHVFME03SzZHdHZ1MzFPVkpr?=
 =?utf-8?B?UkF3TGZZT0YwWjhqUXdGZmsyUElJdE01M1BVdDdpZG12SHlQcWRXUC85M0o4?=
 =?utf-8?B?Zm11YXpjcHZxUlFmVjA5VzBWanRocDBza3ZsYmNPQ2JUKzFtb3ZPRElWWk1P?=
 =?utf-8?B?NGwyRUl2ZjVETHNncHpwWDVVL29QbXpOR2VCQklWTEpFTFpsRUk4QjVaT2w1?=
 =?utf-8?B?OTRvMk5yMllrcVJ6VjViSVl1K3JScDJEVTNCTWpCdE1yZlA3T1R4cXJ5dTFV?=
 =?utf-8?B?TFJpdGNNTjR2dnNZdk1ZRDMvVTRtWVNhSlN1V0RRbXhqTnovVnY5dTJ5SG9P?=
 =?utf-8?Q?Pi86XPUQHGRxmgtTUNXRMQceX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fad2481-2222-43dc-9a36-08dc7534da04
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 23:15:03.8112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMQIdeSDA3cyrUYLbQgeVePVg+Cg61Gng3O7r7drgDJh+iAWpZuFjQn2iula/BMLUQDNN1weOQbUMxf6B8McTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4595
X-OriginatorOrg: intel.com



On 16/05/2024 3:22 am, Edgecombe, Rick P wrote:
> On Wed, 2024-05-15 at 13:27 +0000, Huang, Kai wrote:
>>
>> kvm_zap_gfn_range() looks a generic function.  I think it makes more sense
>> to let the callers to explicitly check whether VM is TDX guest and do the
>> KVM_BUG_ON()?
> 
> Other TDX changes will prevent this function getting called. So basically like
> you are suggesting. This change is to catch any new cases that pop up, which we
> can't do at the caller.

But I think we need to see whether calling kvm_zap_gfn_range() is legal 
or not for TDX guest case by case, but not having a universal rule that 
this cannot be called for TDX guest, right?

