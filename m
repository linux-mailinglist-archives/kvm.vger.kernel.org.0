Return-Path: <kvm+bounces-24069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D024951063
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 900531F21F7C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88823153BF6;
	Tue, 13 Aug 2024 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ETgQ9uER"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E991A707C;
	Tue, 13 Aug 2024 23:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723591047; cv=fail; b=XKC7lqSD8Nk6QbXeW8Wz0eQuSrgXqnQkU+8I0lAGq3v5swOdQnADw7cSy+iq/lMsLnGqzkKoBTqasIZAebHCndxPOW8wX9al+5eLnhLUpSLY9GEfgOcCb88/rqR5xW7awSRZlYaFGzobAys0OfKsvcnnfkq9lctaTw5ug11Uqnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723591047; c=relaxed/simple;
	bh=dCo9BPRZjSnu1wfsKlkuxeorCC5gR+nXyucffOwZRC0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mEIg1NHI1Yy7b3ZqblMI+a/gnRki3RA2Ex0K6b88wt5yIkPcr9u0EsHljQRmdVH6ORNzHbid0dJCgwwev5LtXS8N3HITpSBScJkhNrk9f8e/b/SU5kucVv95xiP4lp7xnKQMyFqg4tQ3g7TAdgD9qrtSqwmUTiqVFAN3ekgWL/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ETgQ9uER; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723591047; x=1755127047;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dCo9BPRZjSnu1wfsKlkuxeorCC5gR+nXyucffOwZRC0=;
  b=ETgQ9uERFj6EesvdNUPUh5wNC8jryt6Lx4zRM49NFHGV4/Jw4wRCYXw/
   Y+Z2F+bjplyVF7tsRRg/epR/TlEqSdnh0NoyuEarNVWSZ6wcafQjZFF9e
   xAr2QiJkoVSG/W5m7HQ6cpIa6hBmhvuvexRR4zgNuotS8/BJxYSQj2510
   p6bTWh2oiKL+CfFc6W95+JVSNWcz5Ym509LzEtA4ZbIKytqs2Bo3wZ+Cc
   rqcTSHcICm8Gf3CiRMZaWaI4U04t8Lxyu91EHvImAXHt1f83nbrSl/fkK
   I3zHIGqG4UwdqBc9/lwAGKdTcGKFGnxaLmgQqnMXlcYSJn5b0OtH6xllP
   Q==;
X-CSE-ConnectionGUID: y8/cxQ8LQqyI/bWq41Rr1w==
X-CSE-MsgGUID: tDa1IEb0T0ubyQCZ+zJhpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21600326"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21600326"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 16:17:26 -0700
X-CSE-ConnectionGUID: LJbtz16LSDKlRd1WAb/x1Q==
X-CSE-MsgGUID: LFiW2P05TbKUZXrm4iYbpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="89503822"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 16:17:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:17:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 16:17:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 16:17:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mdcV6FzOaFSf13uakpqszMqwZcVt66r1dnEcUcpokdmVDAjWUXbQlNVntAG9k2mGjvAfKHGAb7UktfOKBstvRX4QlYcGmxIDLkHOwZ/NY5WCvn1fKBVeBM5k/WlqyiT2Cr9v+t8ajbqloEmykhb2pkqeKTA9B3m+QnRTZ5by1uMFHpfQq32iFuy2qR08m/pHnRjTCE3AJyPjiB4sFc7BhwfRudS/C6tr6H9C0aPJmUNyUnlj/tvERJBYWrYy9l1OZcVCn8cT8H3HHdT2SoN32PlCVb+hoa+25HoBDPbdxuzqSl0gPQnoc+sJcncEm3Demsyui7ndkvHLrWZIb7ZysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qr9jTD/6jtv9zNFmN1GZbmY0ynLrq4sctbFrwGxV4UM=;
 b=Su+s1Py7BSPaa4AEn/EA37Wr9ERccmMQiyb3LfkLqM2/m6GaPd5Hf2yoD7FTGR+ChUSpHxlBiLaQxy6HcxIO+x1CuCKishGtpv/Os0BlTrsDLAc7wxTfQ/8u12jxjLpvpFlWbwJf2TqYc6rI5TlF+kU1pbEVyb/ftiVF6LnhNeOR8ZFR6IvH8HaS6PSu/hOhw7PwH4fLsJ6Cdbyz6rK76sgeOB4DBSyTyp1Rg9NFkE1f+MSKP7KhFISL1TQtQk+sOrU/JeWAXzQceCD2L2IFK3kYYMF7uDu2BGy58aCy+moGoSgQLo40JrwMGJXMgozwjn+A1sgzs+Fd9sgfu1OxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8518.namprd11.prod.outlook.com (2603:10b6:610:1b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Tue, 13 Aug
 2024 23:17:23 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 23:17:22 +0000
Message-ID: <4bb6fcee-e16a-4a31-a69a-655bedd952b4@intel.com>
Date: Wed, 14 Aug 2024 07:21:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>,
	<patches@lists.linux.dev>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <a4760303-02cd-4c4b-bd23-eba4379b2947@intel.com>
 <20240813123041.GU8378@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240813123041.GU8378@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8518:EE_
X-MS-Office365-Filtering-Correlation-Id: 723c05c7-d394-41ad-75dc-08dcbbee1603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aldTTEIwTmt1ZFdtM1ZxVlBtTitVaDJFWTFUZ0JYSUJ6TGNzMi9wNW80VzFk?=
 =?utf-8?B?VVZvWUMrSFQ4cHRpa0VkRE1ISnk3VG9vTnBqQmZDNzBZNmNsLzdyRTRibDZV?=
 =?utf-8?B?OS81aWVid1Mvd0dVV3pWNnR2amY5UDdNb1E1R3IzaHZrVUlDWnhvVDZLbUVE?=
 =?utf-8?B?clJLcjZ4OWI1UG1Db1gxQld6Myt0YUp6SlRuYk41MWhNRU9SUnVwVkViS1RX?=
 =?utf-8?B?b05oOU5ZejV6VWdGN2RYMUNmMlg0SUFIY1VLQWNlZDAxZ0xRUytKNTZ4TzNj?=
 =?utf-8?B?Q0JZVitLMmE3KzF6a28zS0ttbmlZSHNhVUJhVmN2RmlGMUJwNmg5OW5IVU1n?=
 =?utf-8?B?Y2dMa1JRWE44QlBCcnhQMUl1YzFoRVdvRWlpcUNueHJxV3BBR2pmZ1pBOHJT?=
 =?utf-8?B?T2FvQW53MlZlL1d5WEpENTNLOEhhYTl0MXJ3TGE0Rlk1SjdKMXhaUUhXR3ZH?=
 =?utf-8?B?SnEyWE16eDRkdEhiU001Q2lYMUZ4ajVkSFU5UFUrU255QVZwYm9oVVBWRG82?=
 =?utf-8?B?a29yRjY0WndxdVNLSE5HK2tZbUJLSWRIWGVlSlZQZmFlY3VBVHVwYUQ5aVgw?=
 =?utf-8?B?RTJuWDNxYld3dzJYbWY4UlF5SmxoQUdQb1ZNaU1TMGFSTjQyYmJzRDMwTVgy?=
 =?utf-8?B?N3gvZVlzU1FXaHdnUERJZGltVUxTaGNHQnZMaTV2UEd4VXRqU3BEd01mc3dL?=
 =?utf-8?B?RGdGZ1JPVmIxaUozR3VXN1pmeGNLVFhBZmZQQnF4eHNHZmkvbWZybW96aEFy?=
 =?utf-8?B?OWY1Wm1tamhyaitabTgwbXNjL0dsWjA4d3FoclMzOURhVjZyb013TDZYYjh5?=
 =?utf-8?B?bXliOWlpYTRQTExOR01Xb3Nmc0xlcTN3bWlEaFFIWDI3b0xTT3hDeC9IeVcv?=
 =?utf-8?B?THJGd2MvTFM3UlVhZG9LQ01WMGNvc2xBc25lc1ZJcVJ1VEtaTGFQeTYzdkZS?=
 =?utf-8?B?cS92OGZzL2JFS1Zpc2lwbGY2Qk5OZ2gwZm9TeWliWWxtb1RUL3FtN0R5NGtS?=
 =?utf-8?B?Z2sxWlRDRWxVYlVVRjdEUUpUOUMwejJ0NDdNYUhIU0dwR2F0d04rRW9PQXla?=
 =?utf-8?B?Z1lYT3JOR3VIbEY0cy8waTFCVXNraDZlT1pwUVBZdHRXaDJ5cldHTkM1akoy?=
 =?utf-8?B?c1dZcUlhcjNjcXp2c09GdlpJbXlFZTQvZDVpQ3o1a1lHK3Zzblgwek15ZVEy?=
 =?utf-8?B?YWtDNnV5V2YvUVVNaSt2cFVRQ0RWek8vbXJqenNVc205QUxydWNTUTJrSHJ5?=
 =?utf-8?B?ZVkvM3YrdUo0aTFqV0tURThEL0x0TFZuSm1XUm1rbk5ZbG5RRFhNcU1xOWxW?=
 =?utf-8?B?YkJHV2xCVFJHMEQyei9aVldqaGtmaFVXR1NrSzFBd0hTdnZ2VC9HTmJsb01m?=
 =?utf-8?B?elFsUUo0aXBmMzVCa3hxdlVzL3Q3aGVXMnB5NjFFU3NtZWljQkxvRmwwYitB?=
 =?utf-8?B?WWUvTGhoSGlSY2tIM3QybHJlNXlaK0U4Y1ZxODB2UEVsWTM0KzUyVWIrK0ZQ?=
 =?utf-8?B?Zk1hZ3c5cjJBUHNMdEVBSjUxbUNKVEJaOHA4T3EvRDVCdHdPWmZPcThyZlVa?=
 =?utf-8?B?VElVVXRQd1NtZnZmYWhQZWIwcXg2dStqb1U4S1NrOXYvRkxWWEJQSXprNlk2?=
 =?utf-8?B?eXRiZ3pIdjNNQ2RGVFhRb2IwTUxObVlNRmpKaTdFclNjNVpZN2tUV0tHbEJo?=
 =?utf-8?B?a00wcGJ1MXNiNW5DdXBjTEhzeFNzRS9HMHpGY214WVlNRnBSWXhDZ3pqT1Zj?=
 =?utf-8?B?aGJ5Qy93SW5kcGtpSzV0N3hmT0JTSDRIR0VkelF1KzJScVBTSmt6aGd6ZXdV?=
 =?utf-8?B?Y1VqT0tiSTgxR0cvTjZEdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmRyYVpIdlZuYnBkSlgveTNYMHlMVlJRVWVCYUdtdTFWTk9lZ3J5YS8rZEdN?=
 =?utf-8?B?TElCMy81ZXl4WUcxMFNybjEzcUlmRVltUFc2OTJhOGkvRXBHeGpjUGw1WUdn?=
 =?utf-8?B?RnRWWFAySFdjd0JEdkgvRGRhNnpLdlI4NGd6MzZJYUhqSGxFYnFGLzc0T3VV?=
 =?utf-8?B?WEc5ZG1STGpMSFV1OEo3dkoxREhBWDZOUFFJSjVlcGpKY2dCd2I5YjZnbEll?=
 =?utf-8?B?NTFPQ3ppT2srdkEvTUZ4L1lDNGVDWXBDYUF0MkZhU09icmt1NzRIMG1aOXVL?=
 =?utf-8?B?Nk1NWDErd05wd1llekR1YXdIWW85V0c4SlpkMERMZmY3M3Y2OXI5TjRlM1BD?=
 =?utf-8?B?QTFmZFdpWjNKcjJGOXh6K1Z6d29MWFcwbWV6Tk0wNFNxa3diQ01HYVlCWUh4?=
 =?utf-8?B?L3B6VUxqK2ZoOU03RHU3L2ZoM2NnWWJJemkzMFIyZkxiV2NXRlpvUmcxL29L?=
 =?utf-8?B?VXRnSkIvaXRoOTNJam4rMnVDSGRlQklraEcxcEc0MDZXRmF6RWVjdUppMXdD?=
 =?utf-8?B?Qy93MldiTFhkM29UNUk0VmY2dEFIT2pWdkRhZnRSNCtVSzVPMmszRytKOXRv?=
 =?utf-8?B?dnd1WXI3dEJ3MG5TL251SmdUMHhKRDlidzcrdmxKRGtET2ozcGtmakJWZ1lw?=
 =?utf-8?B?c2hvbjk0RG9OdXpaY0lZREF1dFZvV1hWVXVzZWg0WmJpL2hsM1lvOWtlT0hu?=
 =?utf-8?B?MnJobFB4OU9pbmJBbkJCNjA2S2tNaVdhVTQxdmRCeHpOR0xwNStEWG12Zy9C?=
 =?utf-8?B?ay9mQzIvMG0zTGdYRHc2ZkxMUlR1bE5RZEhrMzYrekhRazhmakc5UXh3ejY3?=
 =?utf-8?B?N0x6SUl6YzZHRkxTczBrcjJpWEpQTjkwOTVGMG02d0h6Si9QLzM2dTBwaFEz?=
 =?utf-8?B?NWVGdEowS0swRURCcUJIU1VrVHJXRnhzL2pjTTBZcTFqYXVsS000THUwSkN3?=
 =?utf-8?B?N0tVdHUvcXhGMndDdTZ1YXM1Zlh0MG5wdnl1UnJxZjR5cE1UMEswNzh6Ty91?=
 =?utf-8?B?SnZySElubXNwMTNOSFd0UkF2Tnh4TXJwbUhiOHVHd3J6Z0lvL0t5ZzlteldK?=
 =?utf-8?B?dmk1YXZ2VSt3SVFrc05ZWXpRT2w5NHVhMGNXNXZpbXNOV3lnOStyL1ZVWWVT?=
 =?utf-8?B?Sm05M2hjVzl3bTVzT04wdXExTmxTZEIyWkt2VmFQOWxPanlBVThDSndXZldn?=
 =?utf-8?B?SW9WMk11K2dLQTZLRnUyaVVGc3p4cXVuNTBvdmZGSGFDVlExeHl3TmhnZFNM?=
 =?utf-8?B?a21CWWVwcXdmZ3MvZ3ZQMTc2UWphTXIvYjlXWVJIWXlXZVFGRDVJYU85MHkv?=
 =?utf-8?B?Y2ZLN1BaWFJxVndsMitNOVkzWTlsNnFtcm5hWURFRGc4eks2b2hZQjlOWE54?=
 =?utf-8?B?dFduVUZTSmtQaGVURGNRZXVrVWhtQlkzNFFVMXdJOU9XMWN0U0NFMzVnRDgx?=
 =?utf-8?B?eXRWTnBGU0U4SEs1aGVhS3cwOWJwaFRMaVJJL3V4OFNHK01oQmJMT2N4L0xq?=
 =?utf-8?B?VkdhOGFxTnlnbGZHMit1d25vZGF5bDVFc2N3dXEwdzViVnpPTWE0QytDYk9P?=
 =?utf-8?B?Tm1uM2Y3ZUF2T2lsMmZZUFJrMnZmclB1RTNQWVhFYys1L3pIZy9ZVHlSRHpQ?=
 =?utf-8?B?SkVGSGprUnArRDdpcGdoM0xUQlBYMDZKOHdGZk5uUWdIYkp6c2NzSlQ1dVJm?=
 =?utf-8?B?SlFYd0cyTnpkOGhod0J1R2hLRFV6L3NlK3VTdnluV2daRko3OSs2ZVFOSktq?=
 =?utf-8?B?YzBrQWRlSkxmVk1STkJKNHZuSU56T1N1SXVTMjZMWlNHRTdJYkMzcG1FVlRX?=
 =?utf-8?B?S0Rnckh5R3Ryb0JvM2I4NFd0SnJEU2xVbmhudDVUamFGUE91R1JWRkY4SEho?=
 =?utf-8?B?ZFowWWUyWjRwQVNwZWtZSCszSUhGemp5UUkwdjRYekVSY2pBYnRINW9HTkJU?=
 =?utf-8?B?MFRMVjFmNDdlRHJ0RGdYeUpPT2dkOWJRTGJpM3dxMXRvQXVYbFJNV21mZUtT?=
 =?utf-8?B?ZGdqUG1aQW44WHVFaHJCeWxNSVZrYldjK1FTQkxEcCtUTUVSdHhjVnlxQWU4?=
 =?utf-8?B?bm04eHZadGdPSVhxNnBnUTA5T3FlWEFiMVM2Vjg0RGNjaW4rSEFjR1M4Ri8z?=
 =?utf-8?Q?y7iRZs2hYjtuZuH4ZAILY46kk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 723c05c7-d394-41ad-75dc-08dcbbee1603
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 23:17:22.9063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASOm/R4zkC0FwDRr5U6pLuABJWtpBPv7Oq+7W3o2u0OZGzqeyGr3iC8R4T92ZyX1R4p7RsgoTAVwsrWy39+0TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8518
X-OriginatorOrg: intel.com

On 2024/8/13 20:30, Jason Gunthorpe wrote:
> On Tue, Aug 13, 2024 at 11:11:01AM +0800, Yi Liu wrote:
> 
>>> The simplest solution is to have the iommu driver set the ATS STU when it
>>> probes the device. This way the ATS STU is loaded immediately at boot time
>>> to all PFs and there is no issue when a VF comes to use it.
>>
>> This only sets STU without setting the ATS_CTRL.E bit. Is it possible that
>> VF considers the PF's STU field as valid only if PF's ATS_CTRL.E bit is
>> set?
> 
> That doesn't seem to be the case. Do you see something in the spec
> that says so?

no, I didn't find any word that describe it. So it is highly possible this
is not defined and up to vendors. This means there is possibility for what
I typed in the above :( I'm not a hw guy, but it seems reasonable to treat
something valid only when the cap is enabled?

>>> @@ -4091,6 +4091,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
>>>    	dev_iommu_priv_set(dev, info);
>>>    	if (pdev && pci_ats_supported(pdev)) {
>>> +		pci_prepare_ats(pdev, VTD_PAGE_SHIFT);
>>
>> perhaps just do it for PFs? :)
> 
> That check is inside pci_perpare_ats(), no reason to duplicate it in
> all the callers.

got it.

>>> +int pci_prepare_ats(struct pci_dev *dev, int ps)
>>> +{
>>> +	u16 ctrl;
>>> +
>>> +	if (!pci_ats_supported(dev))
>>> +		return -EINVAL;
>>> +
>>> +	if (WARN_ON(dev->ats_enabled))
>>> +		return -EBUSY;
>>> +
>>> +	if (ps < PCI_ATS_MIN_STU)
>>> +		return -EINVAL;
>>> +
>>> +	if (dev->is_virtfn)
>>> +		return 0;
>>> +
>>> +	dev->ats_stu = ps;
>>> +	ctrl = PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
>>> +	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);
>>
>> Is it valuable to have a flag to mark if STU is set or not? Such way can
>> avoid setting STU multiple times.
> 
> We don't because we only do it for the PF due to the is_virtfn check

ok. Doing it only for PF is enough.

-- 
Regards,
Yi Liu

