Return-Path: <kvm+bounces-20666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D0591BCD2
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 12:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F173281504
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A41155744;
	Fri, 28 Jun 2024 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fqJGQvcg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126C153BC1
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719571689; cv=fail; b=rSL/zyOiVZhA5UYumsQ4F5JYqeJDOtrRuQRlOQmfvJSQh1TUxAznqhtfcnX895jL/v1su7fHQUConaG05xyQgFo5Eiq4nd2BU4d38zE1TdgvwVG2/9Pd0dMhXcAaYpvxD6T85F1pMythSr2geZ1iEbQUl7BmUpBx7Et9tGOz5zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719571689; c=relaxed/simple;
	bh=91TfcyKWSTob9kxYm0ebvKaXgXLDnVACJN/7GZpxRJ4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nppybh9ED5w8eJOnL3u6i2d1yRphAdRc6CuIMk+JfdhngCI4EUhTRr5aZPhRNwLNMBRYAGV1UoRDIBvnNsfAC5k3oiosWyubTTYckIiYCBcr/en8e8v2EqVvFFJb1l+fx6uOm1wS+0Fb53eXjvWl4pHYqQmZVaoX1RmNDKLrx6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fqJGQvcg; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719571688; x=1751107688;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=91TfcyKWSTob9kxYm0ebvKaXgXLDnVACJN/7GZpxRJ4=;
  b=fqJGQvcgoBe6auLBAz4nFC9iivLEoPOjIE4K3uHvuDKEZS1FnkQpQgsK
   1Ziz9XoeiDXm9ffaGAd/Z8CEbkbaPygQLmOwV1zR1jIfGGPd+QLyXdnFN
   xfu0cjyZAtegushahgd/yrN4u1tsejriQpRjgdtuLf8kl7ZMBe6F+WXP/
   2+z31EqR5IrCnTkzczxu/q7mR4ejpnPGGAoAlu+gOb6jldIf/hZMiuGvy
   0g++gONS1tb0Nzzxh0/XdfAB+h4Jldk52Z2dJ9Dn/iR6sMF86VzL1t1gs
   kiApMP4gAmquctLqQaBvDoGjUlukIlBc//BEwyDdH1LFU/n7kQxNWRdQq
   w==;
X-CSE-ConnectionGUID: nPoK9JoEQEC1/llutvjD5g==
X-CSE-MsgGUID: tQYziHqdRgqMfNJZZiU1Ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16568075"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="16568075"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 03:48:07 -0700
X-CSE-ConnectionGUID: JjbCXKryRDaPNu8y1GnPRA==
X-CSE-MsgGUID: UnWyV6c5TguzGnG1RCqWBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="49181089"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 03:48:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 03:48:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 03:48:06 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 03:48:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYEd4H+cH2Kz8IjXeI3+44XP+aEHsolHwXb11KrhkWds4670wUPFTpfMnChbI1P6kPWpc0XIHhH/zb0OJBzvyWds+DtLLd2+NumJrm3Ec9G1KRirPQ1wolg8LwXPUyh4fnD2/tUnYIjZ/od1tmKsJijd27Fz5u7ESv8JETskPFdH5N80uDJIVE9t+P07lTx6MKOzjEu/eqT9cYGDth556M50Z0sISIulHIQ7Y3VMW7bGi3Oc7I+cmapG2FJavnLGobvFSllgBOLizwjTT9j/hqWDjLK/2ZtZorS+FR5/uxBImAbythJ3xa6CJmUCPYgYD5NvnCketnwx21tRSjyqzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBuxzWHrQTjcIQOakpeT9DCqt10FTr4hi0afyWyS5xM=;
 b=PcUQUws1CIVa9A/0zz37IUKJb5BRXc/68QJuQLsdz8vmcS6/cUJexOuMCd+T08tmNeCR8zRMIncgYhXoCgBvgIV9CUBnP/iV4m1yfe5LqbDH3aa8kqYkn4HNWENZiwLuzUn3dpwIBAkqpM2dd08p7+/VkCu1PQjM+3EBFTfeTyepU4DIAZdNExzCTWFbRGal0fMZN3dOpcXrp48TAPCJbSgPBCyMuDKTeWXDUdI/eTMgOn4YzeviaPzr1six0qJL2aCIPkf/itND8SEL7xj7uBdf3uJAcvhuIB+glzLKsxc8R5dEiGRK5GcX1D8ZgyZ6n+re7zVoIjMauvjXu+eojg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV3PR11MB8727.namprd11.prod.outlook.com (2603:10b6:408:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Fri, 28 Jun
 2024 10:47:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 10:47:58 +0000
Message-ID: <7785947b-3ff4-4c5d-93cc-cb54dcc0a5cd@intel.com>
Date: Fri, 28 Jun 2024 18:51:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] iommu/vt-d: Move intel_drain_pasid_prq() into
 intel_pasid_tear_down_entry()
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-3-yi.l.liu@intel.com>
 <8e2bbc1a-f014-4fd9-bbb9-c6e5e47595f3@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <8e2bbc1a-f014-4fd9-bbb9-c6e5e47595f3@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV3PR11MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa7b3b8-09c9-4499-c413-08dc975fc666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cmJEa2JUQk1VbS9rbUhrR2ZTK29NczE0UjFOWmcvV3hxU2RXaTVnLzh4VHVV?=
 =?utf-8?B?eVhDeDN6Z3lUc3FqWjFweW1vcnBvSGtUTGZzNE5IK2RUZHBrWDQ3c2tTWTlN?=
 =?utf-8?B?M0tyVFFFbG1ESHZmMmxJc2w0NnA5d0tPdFJMaTBtKzRKRWZuVTdIS2srd0Y3?=
 =?utf-8?B?T2dIVnJ5c2w4ZlBta05wMU1aOXFzeTBMMHhKbTQ4eXhFMmE4Q0tyU2IyU2pi?=
 =?utf-8?B?MktVWm1HcUdKMHpLdUNEaGFYSkhZSXNLSS9rK08yckNRc0pqaDhGV2xGRmp4?=
 =?utf-8?B?MmZBSDFkbnJnYWVuMmIvSmhVWHVZS2EvMkRDT3hEd3J2YjdaemJBNzdybWxE?=
 =?utf-8?B?SlVjdnBrWG5PaXBUbTNzUjMrdVNGVWxFZHAzaXA0NHdQOWpGc3FrOERqbjBp?=
 =?utf-8?B?V29DSy9ESUZxemxmN3U4dWJKWkR4NVozYnl4a1ltTGtDOXFVNzUzSHpETWV6?=
 =?utf-8?B?Tmk5bGJSVWo1a0lKaktMMkVsRGhkOXVLRGY5SWJRZnA0ZUFpSGdBeTBjRXow?=
 =?utf-8?B?RkZ1VXlNbnRmMHo4d1EzWXZaOE04bVd1b3hiV05jdlVIelM1b3BnbWZvNUU3?=
 =?utf-8?B?d1NVdVlzdmk4ZkN5QUtVa2xZa09VcVBQb2xtdnZjakx1QVlpS3lDTnRvVVZk?=
 =?utf-8?B?WVg1cmlVb3pkSUF1U0k0cWtNcXBVdHg2b0YyMGhaMUk1ZGxHeVJ6TERFdm9C?=
 =?utf-8?B?MDZXVEZxVWwzMHNkVjlvYU50VlltM0hQcmEwTFhreW40dkQzYzJEc2FRSEt4?=
 =?utf-8?B?a0ptUU83RTcxWlozY0NlNm5GNkwwQko2YmZ1b3lncVljVWtzdEkzenE3cXdU?=
 =?utf-8?B?c3RkK1FYd0RINkY4Q3lWNGxhSW5MajdMZGphYXUxY1VjMW9tbGdobTVGckZh?=
 =?utf-8?B?dmdoT216b3MzdE9lbGJWUHQyRmRaeloya0x1Z1pOblRMZi9pa0xPclNzd3hu?=
 =?utf-8?B?UENreGhnRWlhU1JRSHBTUEZ4VlJBUlA5NC9wRTg3NHgxMkRWb2VTL05BV09M?=
 =?utf-8?B?LzhOK2RPM3R1cXRyK3YwWDZFYms4aGx4OG14N0tWZ21WYkdCMG5BUkpnaFgx?=
 =?utf-8?B?RGJYZUo5ZjQ4ZWFubFFaU0FOQ0tmV1VCU3BKNlNhbVN5aW9nWGFZc1V5bEUx?=
 =?utf-8?B?QW9HR2plYlZBQ1RDRlRtaURiSUEyK1B4T0w4bFFhNTBNVHIyZXZYRGV2UzhJ?=
 =?utf-8?B?bkM1UXI0a0FmUkFSNXR1SnJzZE5NM3hsQ1JTVWlRaEl1NWFJVWkxc095ZmtH?=
 =?utf-8?B?Z01Wd0FBcGMwTzhlWHh3UHc1UmdhSDhWVFpKNURsWmlSQm85cGhqY3ZRcWtM?=
 =?utf-8?B?dFJ3OEIrQXF3ajhlazA5aTlqUlBUdEVBTGlZNjdhK1JOdHZpcEZyRExlZnhP?=
 =?utf-8?B?T2VWYUw4Mmw1ZVZ5WXdIdlNHRWtVTDc1Q09FdEFkM0RDejh3cWNtVzlBMmpG?=
 =?utf-8?B?MjVRV0kzTlNCSFNkcU5QeHZnZk12aGgyN284VGh2dER0WTFtaGxUNGRZYyt6?=
 =?utf-8?B?RWdpUkx2dForb2F4YVl4OXNpSWJpTXZUczhQNHFNSStWTE9jb2pLT1FYbnAz?=
 =?utf-8?B?Ny9tSURmaW9iUWovVG9taFJPTnNieXIrVU9wVXBUSnVWeVMzTFZpdHVobkNV?=
 =?utf-8?B?S3p1bEkxZVhOTCtaQXBDRkUySllUTWRBRnBQR3NPZ0Z4S05pU1VLSk5INmdy?=
 =?utf-8?B?YXFGWEhOemt2WXV4bGN4Q1BESHA4NnExcTdWaVdwUXJhQWVUbE1pMkdmUDBn?=
 =?utf-8?B?cFE3OW1jb0dsVXcxR0ttMnlkZzY1d3BBMFpSck1XT0IzV2haK25vcEhybUNS?=
 =?utf-8?B?YXhGUjBNamRHN1BuaHJYQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmFRL3JOSEtTcG1mSjVKLzVGVC84NS8zWTdpZXVUR1lkZFhNdXZzZHM0andh?=
 =?utf-8?B?YkxRVmMxZlUzdnpzNE5ma3lVTU43eCtadCtVSzE3Qk52SDZVZEttU1lGNnc1?=
 =?utf-8?B?Ryt6a3ZPa3lhc3BMUFgzenNhNGhqR2d2K00yYmlKeGtUL2NJM0s2N1E3RGww?=
 =?utf-8?B?U2NIcVBaOFV5NlZWY0VjVVpsSzRXc1UvZC9WNS8rYkZHMTJoUVVXV05kQ3l3?=
 =?utf-8?B?YjhQWGw2YUdMUHlPeW9NaGlwelBpUkVvbHR1MzkwWUZuTWcvSDVxMi9YSEFB?=
 =?utf-8?B?WFM5Rmw1Nm5WV2NUNEdWMmxzdHgxdzJaREIxV2RVZm5CSXNDb0dnV1k5RFcr?=
 =?utf-8?B?SXgyWDI1R2NrOXlyR25WTG9qKzBQNkZvN2pLakhpRG9xNXFSTFBiYlhkc20x?=
 =?utf-8?B?RFh6L2NHRHFhYUJaQ29JQzR1eklhRTBYSHVsWUFsbzErTkl2bTIxcDlINXpo?=
 =?utf-8?B?c3Y4NWhtRHVyeGExYnBSSXpSYU5Xei9GOGw5NHJpWEhlaVBqemllVE1kMzln?=
 =?utf-8?B?a2piWlVXa2dUbjBrZGFHK3BHbCtOS1hlNmhhRWIyMWRnRThZbHdPU1dNeGNQ?=
 =?utf-8?B?L1dsMEllakxwVnovS1p6OWJvMm5PQkhERTdZWldXbDRrWE5qcnpYRHRVSUVN?=
 =?utf-8?B?aHhHR1ZHbVVoamdQNzRjb2xpN1V3ckU3VXlzaHZiRFpEaGgxRC9ESFpBcFBu?=
 =?utf-8?B?eEJ1N0xUZXFEUWwvTE4vdHFlZGZqZDZKRUxxSFNMYzZVeUx2UVdKazgzSjZQ?=
 =?utf-8?B?bzFBUHFYVm5HTnNYbGFocmt1MlZuR2NPV0JvY1hTK0hGS0p3c2M2TXFabjRF?=
 =?utf-8?B?RnVyMUd5M2d0dXUwWGo1YmtpTXc5QlFiNkN1Nm1STk1lYk9ZQXhzOGFqTEpr?=
 =?utf-8?B?WVJKeDNMc09vWVZuMG51M0M1ZGM1cDU2VEtNNS8wa1JqYkNOekY5TjB4U2tz?=
 =?utf-8?B?OXdnUS9oU1NNYlRZMlFleE5tR29Id1pDd0F4OHppMkk4aTE4UndVMjk5Z0N0?=
 =?utf-8?B?RDlqWlJBMVZjb2pqKzVFK3g4TWRiNnNQM0ZLd2ptZ29NNGtXeDFYR3RWcUJC?=
 =?utf-8?B?SkZyTTZJcUJiVnpGTURDSlVLM0svUlV4ODYraGFBL3V0M3N3R3FvbWpFLzRY?=
 =?utf-8?B?d1JSTXlTZm41ckVKVk4vV3YycTBpOVAxQzdyZDBCK2hIUmNFbnZIbHRodGZY?=
 =?utf-8?B?QTBuUlZjOUlNeXhXUXVlYmdCU1RvcDh1S2FxMkZqRE94SXJ1UUNvOFowK3JX?=
 =?utf-8?B?anRjRHNNeHYzUmZ2QVBUYkpsSy9FcXI2ZUNjV1piaFF6WEdEcDhzNnpHbVB3?=
 =?utf-8?B?czBtbXBaWnBkcUlKQ3dUZW1vbU5XN2JJL0xzZU1NV1pnTU9xMFFkWkwvdXll?=
 =?utf-8?B?LzRVcU9CY1VwaWpJVHEvVmRneWdSL29wQmVyZEtRYVM0N1JGNlVDZ1pMS1N0?=
 =?utf-8?B?NzRaWTgxckxoWHZkaDlCQWFLTS9uZ1Y5RzRlQlZHSVMyZHdiSkNITENKRElr?=
 =?utf-8?B?QmpjRlJXSDdQdndDb0h5ZmhLQVQybzZQVDVpbFdTeXhDdnlISXB4cEF0WUNF?=
 =?utf-8?B?dEduQnZLaTdURE9FcHlmaE9Pdkpid1pMOGw0UmtoY1REeTlVUWxaU1F5OU5u?=
 =?utf-8?B?Vk9lc2F5MkNUUGYrNkI4QU5SZFRiQW05MitVL0Z5YnFCQUs3Ukpzc3FUV0g3?=
 =?utf-8?B?Z2QrcGhYa3ZYM3YwOEYyNWwwc2dNczIvZWFVOHQzOUdLZUJQbUJFTENEU1lE?=
 =?utf-8?B?VDAyd3o1amlaRWh1cGNGa2JFeUdOdnhrOXZheHVUekJESXFTZjZCM2xmTkI3?=
 =?utf-8?B?c1lUWjg3TFJRMXlMTEJSSCt3enh5UkxBbkR2Rm9pV0tBNlF4MnAyK2hQTU9n?=
 =?utf-8?B?dnBiZDVJWmM1ZlVWYytUUjc0eVRNMTJVUGNZVC9BRDlDVVBqclNXL2tvY1dx?=
 =?utf-8?B?MnhtUTU0OHVnWU8zWEJoVXF6em9wY1dyendGZmFYQVhYVTJ3cHRFb1Uvam9a?=
 =?utf-8?B?Y05nWUxWRVZBT2x4bGhseCtXcHU5cUg3aVA0aklwQkg1eExMWXBpSjRqV3g3?=
 =?utf-8?B?dFhqTXVXa3FteFp1MHhHYjk3UzdTKzlXcHBCdTV5Q2xkS0s4T21TYUNwQ0lt?=
 =?utf-8?Q?3h4UU3pmV8VKPhEfgZ4eh0ykS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa7b3b8-09c9-4499-c413-08dc975fc666
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 10:47:58.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDvrdw0cr7+u1VrYpABAEgXXPgMaJJhh1yJr6xH8T0kCn3MfTCZk0ObVhLd5IZaV9VS0D/gpGI49ZWzUmm7Xvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8727
X-OriginatorOrg: intel.com

On 2024/6/28 17:42, Baolu Lu wrote:
> On 2024/6/28 16:55, Yi Liu wrote:
>> Draining PRQ is needed before repurposing a PASID. It makes sense to invoke
>> it in the intel_pasid_tear_down_entry().
> 
> Can you please elaborate on the value of this merge?
> 

The major reason is that the next patch would have multiple places that
need to destroy pasid entry and do prq drain. Wrap them would make life
easier I suppose.

> Draining the PRQ is necessary when PRI is enabled on the device, and a
> page table is about to be removed from the PASID. This might occur in
> conjunction with tearing down a PASID entry, but it seems they are two
> distinct actions.

Seems like mostly they have conjunction, while there is indeed one
exception in the intel_mm_release(). Given the above reason, do you have
any suggestion for it?

-- 
Regards,
Yi Liu

