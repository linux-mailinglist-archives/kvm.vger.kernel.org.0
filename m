Return-Path: <kvm+bounces-52686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE08B082B4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 04:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0559163229
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 02:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0015C1DFDA1;
	Thu, 17 Jul 2025 02:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XuwvFRIL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E68C1DE3BB
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752717789; cv=fail; b=W7FR1CzUq/6NrDQAR+VseN1EE/RIWbIpN89WaNbARIHMSBYlRkY+UZ4W7r3X0SPwvtSrJ95InYIiS/2tpeKWXJap72/xwM6+eYzZY1CPMGw2AQXrRq4Vv6dkGIa5M3eTcyTg60KIK8GaqdlmKglb2LMh/fWLHKkH0VYUinuvdlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752717789; c=relaxed/simple;
	bh=Vqgiiyk9ajpgWqXt9fmQGU6pwX4xCNlgso0f02ISOZ8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MQMB0AANP5t7GQBAiQ67zgQYzMh9oPLoacUXXBX9LM2FY4oaQdE4YqNPphFIjp+y81VdBVedpKYsQkvDs/cU/7EtDuX+LCsQdHHN373GATJsujHtyFr4RljI2T1Ip6FJcXHsVnL33Pa1i1BYDdemLOlaeJt9mKuLa7sazgpArLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XuwvFRIL; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752717788; x=1784253788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vqgiiyk9ajpgWqXt9fmQGU6pwX4xCNlgso0f02ISOZ8=;
  b=XuwvFRILESEcDCM1UTNih/KZ/Qv++Sf91gbxi4C26IT+jp2MzbX/8R50
   fQ/nVqIU0Qrg6wD77DF3pLoUrz2O1cCN+4+xEaY7D9DxdXwIbhPGnRWwK
   0s9Zw9k8O0BRFfwZXMiLbiEX/E+MjXrwtq5/knUJgw+FZJB0cYYb54xaq
   syoziG2wmvjcZES9YALyENH6li4WssxD8i9Pbz5LJ2jnb0vWI+d+wh6ph
   PeoTi41jmNxqkAMveQpfUn4RFBUsSTgL2iSUSbiPCoux0MKe6Gutij0u+
   rlHN9Vv3nejZiFbEPyA2LBhizcbo8nTQWooX/JZ8ySrAXZIoHhvUeUgVx
   A==;
X-CSE-ConnectionGUID: ubXpwdGJTKCiQ8Pvuq3N9Q==
X-CSE-MsgGUID: 5wnJetedQfaemMr1eeQuXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65237219"
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="65237219"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 19:03:05 -0700
X-CSE-ConnectionGUID: FFwY8ThkR8S7bcwisGSkgQ==
X-CSE-MsgGUID: TgOgNVx4T8201c9X41XIDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="188653422"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 19:03:03 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 16 Jul 2025 19:03:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 16 Jul 2025 19:03:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.83)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 16 Jul 2025 19:02:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWNAvxrLYBCXIRVo0dycfm6fxbtxQ6/mW9DsL6wde2BfjYr2EXjQI+Psp/HWCmgHxaC9J/sDeEolh/me3g9iOl+AOfMyxy6cEVj8bUrv/QXxsVlYUxtb0diEWHgFymTvgY2FfzKjqwwyEiFqedd2JibKT1h8We8nJgcO8W09jKFgWtmv0W32Lo+q7UplFqYqdP0LZBYFfJffrhNjUpNDsWPQ/rXaL/PZIY1VBa4oNGwHj59IOaXr6uAfukjAHaRkIMcjACnCkN+QBInSF2euxd4jw3xz/ZJvgEEGg/V7jJjZg9NmY4B2bcUYvU6t0fGnXgoKt9POFo8jW4RU5DbN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DfqGgCtwIuFlxgMndsdmitSwVlc+FbuiG2VrHj6RTE=;
 b=GjheEoGonY8clCG9npxJvwbgw9sScDZP8chwLZpQJasl5cj2epLqtK6V4srKCqwnmY4V5JrF60jHmG9jKK51LgRmCIzVrnpnKVEPj/wXfCCDdi4PlPSwTUjqXULs311MA1yOMezSvzNoZpiDTrEBKkL6/mGWUgi+ZSp1AzoAtx/qHbn5bOWrUgAGwn59HJcpNsnsCmiXjlu7bQvQqr5sr+ofmpOtBd1NDGqIil4YwEjudwcmmV6wINa3Nv9rgJry0BrD1MFOUgMW55xJf+megsNYja85W1Nw4lFHKVacgIK4200bUklzX55AOfCxBB6dM0bjBklPTrYTa4SF+VzIlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA0PR11MB4575.namprd11.prod.outlook.com (2603:10b6:806:9b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.39; Thu, 17 Jul 2025 02:02:55 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8901.023; Thu, 17 Jul 2025
 02:02:55 +0000
Message-ID: <18f64464-2ead-42d4-aeaa-f781020dca05@intel.com>
Date: Thu, 17 Jul 2025 10:02:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [POC PATCH 3/5] memory/guest_memfd: Enable in-place conversion
 when available
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, <ackerleytng@google.com>,
	<seanjc@google.com>
CC: Fuad Tabba <tabba@google.com>, Vishal Annapurve <vannapurve@google.com>,
	<rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>,
	<binbin.wu@linux.intel.com>, <yan.y.zhao@intel.com>, <ira.weiny@intel.com>,
	<michael.roth@amd.com>, <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
	"Peter Xu" <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>
References: <cover.1747264138.git.ackerleytng@google.com>
 <20250715033141.517457-1-xiaoyao.li@intel.com>
 <20250715033141.517457-4-xiaoyao.li@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20250715033141.517457-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0128.apcprd02.prod.outlook.com
 (2603:1096:4:188::20) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA0PR11MB4575:EE_
X-MS-Office365-Filtering-Correlation-Id: b63a78b9-1e54-43c0-8c4b-08ddc4d60b6c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXF5V2hHSkVWR01za2o2VWx4SWZXczlwNm1kMkNQaWZjd01wR1AvU1A2VGR5?=
 =?utf-8?B?cG5remRxRDhETHNSWUNqeUtSQ1pOMzM2ZXNwcU5SOFhwYURvZ3VuUVFlZC9o?=
 =?utf-8?B?SktJeWNJMy83aGs0ckRSeENjNWpON0t2SmxNYktBekx2ZHRzR2Nkcms2S2Qy?=
 =?utf-8?B?ZWZLaHQzeXhlVlpSdkdJMTNpd2ZPMW0wZ05wRFBNbGhpdGhZeWVjbEtxbHRk?=
 =?utf-8?B?R3o1TlZQbldzOGUzdy8rQ3ZhU2NnVDJhZWhwb2V4dkNqUFNPdzhieUgyZ1pG?=
 =?utf-8?B?Nm8xeDdTUEZkekFweEp3a2NiUGUzS3JHZzJsdnNWQ0dWZWw2NnFlT05ISDZU?=
 =?utf-8?B?VlVIUVV5TFk1VGJlN3hTcjdueWRBb0Q1a0xFSTRvWVpKWSt5ckhvUWVWU1Iy?=
 =?utf-8?B?V1NDS1J4eUl3NWxoWG9IN0pPOEt0WlpiL1R0SjhIcnlLc2J4ZG0wVlBWNnVW?=
 =?utf-8?B?NVJmNXA3a0h0V3Q4Z0pMNmVLa2M5eFF3M1ZERm93Q29RZXp2NFNmVGtPUUha?=
 =?utf-8?B?S2FMYzJkYWo3bjNmUmYyUEYvMzNoR08zaUgrYVhxaU4zbjBPSmpGaGZSQjJI?=
 =?utf-8?B?cXoyUndiMGpTNHVhRDhWNForbEl4MFJTQ0xwM2pYb2Q0WjZBVjZWTEFITFJF?=
 =?utf-8?B?S01hTjBYcTZ5bXpyTG9qUXZ6dG8yUUFJVzV0RUtXc2NpTnRzek5zSDVaOVVs?=
 =?utf-8?B?M1VYUWZsSlhzSldoSG5SY1BUMHRCT1U2RzRpQ1gvU1FJa2tIUFBqeTF3Q2xl?=
 =?utf-8?B?ZnRuZHduaVBpbVRwVnNycmpkSEFwaENmc3crckZCU1k3VW5HZU85UDZEamJw?=
 =?utf-8?B?ODhRMG1pS21GbFVCZHFNaTJMNGtaMWVWN2lDTDdQUjQxM2xWY0JsQmpqSk5q?=
 =?utf-8?B?T3ByVUVvMkw3ZHova05BZWl5d2RZem1jK3BLY2NxdnYzangwUFduOVo3NVBV?=
 =?utf-8?B?K1JrWXFlOVJmL082cmJPbTY0bE9nRXUzaE4xUGZvd3JQbWNpVCtOSzRqQ3Vw?=
 =?utf-8?B?NTdDa0h1ZEJWdE9qcStPeGh3N1FFWkE2STUxUzdnYXRBZVNNSWpnNzZ2Smp3?=
 =?utf-8?B?emR0cUNWOVpRV0FMdVloSGFOYkZSZzNCSjVBejRibnNhUjJ4Z2d2d0dXRCtC?=
 =?utf-8?B?VGNnTFozakN5bWtiY0ZLLzhYRlRxTFRjb1hkUEpkZVhKKzRqUmNOekNrS2NN?=
 =?utf-8?B?SWNuMmRYK2djb1ArS0lyQmdhUjlOTlpSRFRBM3ZuUWNMNzlwOFVLZTFTbnFL?=
 =?utf-8?B?eDkydjdaMkRZaDR5SGpFR3pBR1RjMnE3TzNzTHhWL3hlSFV2em1LZnVMcEY0?=
 =?utf-8?B?cEdqU3JSMi9IWlBCanJGcVozay9JVHozNmM2d29Fb1B1T1NZV1drN1pQa3N4?=
 =?utf-8?B?Uzk4RXRsNjhDbFBlT2RCSGIxYjRKa2NKMWdId3lyUHg2VmJDd1NGWWg2SUpj?=
 =?utf-8?B?NkM2RTVPN1RvYndNbVo2elpVSVpsZ1NzU2NPNW5qOHlnMGxXc1ZaOEQ0SjB2?=
 =?utf-8?B?bEh6TWtia1dDRVBPOFR2K1RBcEFnL1pXY2JxdTRqOXZvSlphcTBzMWVETW9m?=
 =?utf-8?B?dVNFeTh5UW1qVVpEL3RFckg4U0U3bGgrNWxzRFgvV0g0U1hGSCsxT25pVHhW?=
 =?utf-8?B?dlFpdzBLOFJqRGNsejF5ejR2MmNMYXNXREorNHgzNmZ2c2oyUXRRV1psbXk4?=
 =?utf-8?B?V0xEcUNJcG1GOTF4YW8zbTVaK3pSWmY3eXBlUG9DY1Z4eFdVVUNEUWIyZWND?=
 =?utf-8?B?V0FwQTd1dWtzRXk2dCtaUzRHQnZkWkIwb0VHeEl2MzgwUGhNcFhlOElCUlp0?=
 =?utf-8?B?SFAzMTArOUJzVkpSSjRpT2E1R1VkNUxmdW1WblRlcVd1c2d4NXBsbWd1eTJa?=
 =?utf-8?B?L0FrNzFkQjlZOVkvK1RrZisvUDhLZlZtcFVnU1NWRGcvcHlwbDE2OXJUT0FT?=
 =?utf-8?Q?brpoUnVLEWA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2Z2NVcxM2hKWmFYaE1vUE5RVW9wYTdLU09oRkNFYmRjOVExU3ovYXIxM2xV?=
 =?utf-8?B?SjVKdFpyS0Y0MGlIWFBEd0xXM0VPcHoyMXlYc3RJUk1RMXJIUXIrYzE1VU9B?=
 =?utf-8?B?N3ZJd0RLOWtkMyt0Nk9Ydk1LK3ExVGk4TGlRN3M5cmRhSlg1NHpTdUo2Sm05?=
 =?utf-8?B?NWtyRDB3MVdpVjdXQlU4MEtDbVh6VmFFbjlCU2V1ZUFVWjc1dlRFa1FLaGdw?=
 =?utf-8?B?d2lRNFNrcUJSTkIrWGxLaWNhdHpEZnE5ZDRhVnNOelBIM1FidGozZEExZ3lR?=
 =?utf-8?B?VUo2UUtJazdLMkhLZ0xoTU15bVNNNGpSYVZvYjFKN1pZNExNd3FtZDlmZ0RI?=
 =?utf-8?B?TmI3TmNBZ3dQdWR4OHM0R1BrVDJiVk1oWFc3TGhwckJuUDllSHlaNGF0bVdQ?=
 =?utf-8?B?ZUJKTGJPMFpXT29DcXN6K1VaTDRJcVhGRWhnekZWWDMvTUNCS1VHMTgxV2Nh?=
 =?utf-8?B?ZHhNRmFKZmJDb0VUY3dzM3NiUExIZ3B2TmxWR1FaNUdWVWpHb2p2TnZpTk1M?=
 =?utf-8?B?N2pldklVajFVWWIrS1BqZlB6ZkZqYWZUMjZFdWtoVXlJRUJlNmpPS0pHYWVG?=
 =?utf-8?B?WUJ1djRvR3pPL010cWdzQmxvbkRkTlNRbTVOMER0eXZna21rL1Q2SHJoOVBj?=
 =?utf-8?B?ai9RSWIzcHluNWY0L3pDeS9ROGN4OXNNcS94Tk1sVzY2VVlXVEFpaXg3alpu?=
 =?utf-8?B?UEkvU2NkMHlBUGFSWEZKVGx0OEF6Qk0xZkhFNjdrcVVGNVMxUE83c2Z1U2wy?=
 =?utf-8?B?SXAxclVUZjl1WFdzQkdnSkJjRVNEZm45aHJZTVh0Qnp2ZTl2MkFHWi9kUEw5?=
 =?utf-8?B?dWRJR3FXSkJYUDVaYVRYcnpINHU2UTNac2Rpa0l4K21UaDNKRVZLK0UrSndI?=
 =?utf-8?B?cXFkZThieWRTSE1pZmFrZEJVNENubFM4aXovL2Ixemo1RUE2S2xLMnJRaUhw?=
 =?utf-8?B?cEpnUmNnRVU4MUNwVmp2Lys2WnNXTks1SXlHc1VsWVBaRjR6bnVEdTVFOXY2?=
 =?utf-8?B?NWwySlVUL0dEQ0hrZS9QVi9veWlKY0tGOTdoZDlKaC9TM2lldXo5VDdCWWJR?=
 =?utf-8?B?aXRJaVFYTk04UE1mWHQvaXdUU3NCVnpXZmFTMGU2ampVY2tmN0d1bjZRTEEw?=
 =?utf-8?B?OXpQdHB6Y25MdTRqV0xveHlQakh3VWhCc3hoNDI2Ukh1SStNTnpUNEdDdWt5?=
 =?utf-8?B?TGVZVGxSTVRwVnd2T3RQNlVLSTRrZUc2NEZmSGFHc1NDMWFZc05hRndPaGFv?=
 =?utf-8?B?bVJ0WkRrT3IyZzRJSXAydHJaSkdYVnpjT2dMbE1FaDJwMjJPU3FUWDNCMUtY?=
 =?utf-8?B?UFYrYmZSbEQ1bFRGWVVWbXl5cGo2ZFZCUTBoODZKaW43a0lMU0syNStobjBM?=
 =?utf-8?B?VmZob2Rsd1U1TjFucHBVcm9uTlllRmJCV29ncGFRaVpkYjk0ZGxYcmVyZEpX?=
 =?utf-8?B?UEUxWHpldVg2WWNUQXduNGRiWG1UUE1lY1puM3RtbktieXJCbDAwdzNTMHJt?=
 =?utf-8?B?N3Q0U2ovdEF1aXMwc3d1cnMrRkRRK1FTRkxSWEZnbWJJWUZQV25KNC8rTlZU?=
 =?utf-8?B?alNJS2U1Um1sN3FnaHk0RG5tOW1HTTZFUVdjNmhDMWNnZnZLS0lwZUlNYkJ2?=
 =?utf-8?B?V2Q4WnRNVy81Z2FzSTlNWlIxZ0NoeHdoY1NNZnMrcGdHZ2ZvTzMyZ3poVVV5?=
 =?utf-8?B?QVF6STRrUllzNUt4WS9kcXNENXpzUjkwSkMyNzlrOXpVZkVQMGdLanJicVZN?=
 =?utf-8?B?Yzl4eG1oTHI4MEdSbm00TW9ZYmVLK2RLR1l6bnhoc2grUkdydVFSTUpXTlN3?=
 =?utf-8?B?RUpzVHNwZnp2RFEyNmZsYm1NMXVUYlYxamtmQzRVYk00SFhxRzMwMlE0enow?=
 =?utf-8?B?RU1TdWFzUzRsdDV2QWJseFluc3NJbWxFanR0OGR2U0JvbXpweU5MZGJMRGhP?=
 =?utf-8?B?SEJCYXBsdklIaGZUU2NGSFVFbms0WkN5aDFjOGYrSWNkM0t3TE8xQlJ0QWJ1?=
 =?utf-8?B?c2lmRzlEbWs3QXY2MUV0TWlHWGZDbzM2WXZkSjhUekcrT0pPMmQrc1NjSjZZ?=
 =?utf-8?B?Szl6YnVkei9rcUtrWFJOU1JjSEdORFpYT2hxdmhjbmdMdVRtY2NzQVNJL1BE?=
 =?utf-8?B?NjZqOWFPTTk3T2gyRnlPOWhhSUtkdVRmdDJqL0lrSjJyaVIweWlGTGVUdGNC?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b63a78b9-1e54-43c0-8c4b-08ddc4d60b6c
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 02:02:55.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKZWVh26I4YTegBJ3oYu7xjk9l6/IqO5INgT8gaTkBiC9LaiNFA12Cf6kXRJKDBi8W2xjZM3ktORuNEwOr59Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4575
X-OriginatorOrg: intel.com



On 7/15/2025 11:31 AM, Xiaoyao Li wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> (This is just the POC code to use in-place conversion gmem.)
> 
> Try to use in-place conversion gmem when it is supported.
> 
> When in-place conversion is enabled, there is no need to discard memory
> since it still needs to be used as the memory of opposite attribute
> after conversion.
> 
> For a upstreamable solution, we can introduce memory-backend-guestmemfd
> for in-place conversion. With the non in-place conversion, it needs
> seperate non-gmem memory to back the shared memory and gmem is created
> implicitly and internally based on vm type. While with in-place
> conversion, there is no need for seperate non-gmem memory because gmem
> itself can be served as shared memory. So that we can introduce
> memory-backend-guestmemfd as the specific backend for in-place
> conversion gmem.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c       | 79 ++++++++++++++++++++++++++++-----------
>  accel/stubs/kvm-stub.c    |  1 +
>  include/system/kvm.h      |  1 +
>  include/system/memory.h   |  2 +
>  include/system/ramblock.h |  1 +
>  system/memory.c           |  7 ++++
>  system/physmem.c          | 21 ++++++++++-
>  7 files changed, 90 insertions(+), 22 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index a106d1ba0f0b..609537738d38 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -105,6 +105,7 @@ static int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
>  static uint64_t kvm_supported_memory_attributes;
>  static bool kvm_guest_memfd_supported;
> +bool kvm_guest_memfd_inplace_supported;
>  static hwaddr kvm_max_slot_size = ~0;
>  
>  static const KVMCapabilityInfo kvm_required_capabilites[] = {
> @@ -1487,6 +1488,30 @@ static int kvm_set_memory_attributes(hwaddr start, uint64_t size, uint64_t attr)
>      return r;
>  }
>  
> +static int kvm_set_guest_memfd_shareability(MemoryRegion *mr, ram_addr_t offset,
> +                                            uint64_t size, bool shared)
> +{
> +    int guest_memfd = mr->ram_block->guest_memfd;
> +    struct kvm_gmem_convert param = {
> +                .offset = offset,
> +                .size = size,
> +                .error_offset = 0,
> +    };
> +    unsigned long op;
> +    int r;
> +
> +    op = shared ? KVM_GMEM_CONVERT_SHARED : KVM_GMEM_CONVERT_PRIVATE;
> +
> +    r = ioctl(guest_memfd, op, &param);
> +    if (r) {
> +        error_report("failed to set guest_memfd offset 0x%lx size 0x%lx to %s  "
> +                     "error '%s' error offset 0x%llx",
> +                     offset, size, shared ? "shared" : "private",
> +                     strerror(errno), param.error_offset);
> +    }
> +    return r;
> +}
> +
>  int kvm_set_memory_attributes_private(hwaddr start, uint64_t size)
>  {
>      return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
> @@ -1604,7 +1629,8 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>              abort();
>          }
>  
> -        if (memory_region_has_guest_memfd(mr)) {
> +        if (memory_region_has_guest_memfd(mr) &&
> +            !memory_region_guest_memfd_in_place_conversion(mr)) {
>              err = kvm_set_memory_attributes_private(start_addr, slot_size);
>              if (err) {
>                  error_report("%s: failed to set memory attribute private: %s",
> @@ -2779,6 +2805,9 @@ static int kvm_init(AccelState *as, MachineState *ms)
>          kvm_check_extension(s, KVM_CAP_GUEST_MEMFD) &&
>          kvm_check_extension(s, KVM_CAP_USER_MEMORY2) &&
>          (kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +    kvm_guest_memfd_inplace_supported =
> +        kvm_check_extension(s, KVM_CAP_GMEM_SHARED_MEM) &&
> +        kvm_check_extension(s, KVM_CAP_GMEM_CONVERSION);
>      kvm_pre_fault_memory_supported = kvm_vm_check_extension(s, KVM_CAP_PRE_FAULT_MEMORY);
>  
>      if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
> @@ -3056,6 +3085,7 @@ static void kvm_eat_signals(CPUState *cpu)
>  
>  int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>  {
> +    bool in_place_conversion = false;
>      MemoryRegionSection section;
>      ram_addr_t offset;
>      MemoryRegion *mr;
> @@ -3112,18 +3142,23 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>          goto out_unref;
>      }
>  
> -    if (to_private) {
> -        ret = kvm_set_memory_attributes_private(start, size);
> -    } else {
> -        ret = kvm_set_memory_attributes_shared(start, size);
> -    }
> -    if (ret) {
> -        goto out_unref;
> -    }
> -
>      addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>      rb = qemu_ram_block_from_host(addr, false, &offset);
>  
> +    in_place_conversion = memory_region_guest_memfd_in_place_conversion(mr);
> +    if (in_place_conversion) {
> +        ret = kvm_set_guest_memfd_shareability(mr, offset, size, !to_private);
> +    } else {
> +        if (to_private) {
> +            ret = kvm_set_memory_attributes_private(start, size);
> +        } else {
> +            ret = kvm_set_memory_attributes_shared(start, size);
> +        }
> +    }
> +    if (ret) {
> +        goto out_unref;
> +    }
> +
>      ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
>                                              offset, size, to_private);
>      if (ret) {

There's one thing required for shared device assignment with in-place conversion, we need to follow the
sequence of unmap-before-conversion-to-private and map-after-conversion-to-shared. Maybe change it like:

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a54e68e769..e9e62ae8f2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3146,6 +3146,17 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    if (to_private) {
+        ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
+                                                offset, size, to_private);
+        if (ret) {
+            error_report("Failed to notify the listener the state change of "
+                         "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
+                         start, size, to_private ? "private" : "shared");
+            goto out_unref;
+        }
+    }
+
     in_place_conversion = memory_region_guest_memfd_in_place_conversion(mr);
     if (in_place_conversion) {
         ret = kvm_set_guest_memfd_shareability(mr, offset, size, !to_private);
@@ -3160,13 +3171,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         goto out_unref;
     }
 
-    ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
-                                            offset, size, to_private);
-    if (ret) {
-        error_report("Failed to notify the listener the state change of "
-                     "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
-                     start, size, to_private ? "private" : "shared");
-        goto out_unref;
+    if (!to_private) {
+        ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
+                                                offset, size, to_private);
+        if (ret) {
+            error_report("Failed to notify the listener the state change of "
+                         "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
+                         start, size, to_private ? "private" : "shared");
+            goto out_unref;
+        }
     }




