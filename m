Return-Path: <kvm+bounces-34889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA107A06FD6
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EA3F167C9A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4D3214A65;
	Thu,  9 Jan 2025 08:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M1+BTsCk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0941FC11F
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 08:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736410683; cv=fail; b=aq51ZPTWn+Ck3dwtvIv0fyZNemqTnR6XrI+Q99FreyuYKoQdJobs5pSjM/piww6h8Jzge5H5rPjtBVurE8nmp7KSgvNj01eW0r27PPoimf5CyL/S5gkk9YnVLh21KtyXhqPwVWJ17d4zZQSOx7tp3/soIru9fFtdpjSXtR1HDb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736410683; c=relaxed/simple;
	bh=HX+5jdjVUq2m/vJVCJUMJ26O980f8vvOe29rujjdGA4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NkhRX/2CnBebgjfIJl8R7ArTx+G7STMN4QWynxIw0a1tbJZJ8NPzNg8EBz0+wUlAWm8XDEMGZ8dKe7u40Rhnxufc10avytPOUFpBLG0Ob134/Rp2P2TC5vN10fe7Covzyh3Msk5MQnP1chuV/sJLXYPrO6bhpnct3NVcoHOjGjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M1+BTsCk; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736410680; x=1767946680;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HX+5jdjVUq2m/vJVCJUMJ26O980f8vvOe29rujjdGA4=;
  b=M1+BTsCksOl4qDGnWE/n8MpiKWUZFR99psqTStEHmu92ge96ZSjWJIFe
   emWpSC7jUb7kM/wpVJujyLpH2RhFiifI49clLfxz4wglxnjqBjeWkQWWY
   QiWYPx0rmaoy51uFFIgyNY4DA8mfpaPF6wHe160vWM5S0r5janLbTDeMg
   ck4sY1S4+ouFMC10A3C0ggwWffF91jWJM1tBNVzvoBbMsKcVKIT9pDmoV
   UtiEAtmoKWqKFy2/3EQyHdthVji+FIKX7P1GHAUCjaruuk5swEG5B1Ujf
   WgnTxahkYueAceoC0PJKU0JGZIsVloJuMrI0azSyuKOQV67dZYZP7C1kL
   A==;
X-CSE-ConnectionGUID: QnzJtyPVRiCe8W6bayYSxw==
X-CSE-MsgGUID: IR82RA5MRaa+GZN59Fh0sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36821363"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36821363"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 00:17:59 -0800
X-CSE-ConnectionGUID: dv3/r5wVQCSZVg3rkfQb4A==
X-CSE-MsgGUID: HphQpOA/RTq1R3cOpxC0ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103836048"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2025 00:17:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 9 Jan 2025 00:17:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 9 Jan 2025 00:17:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 9 Jan 2025 00:17:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cuCdg1V19Snv9YNoP8aRZIwCQI9s9+e+WfAZx36htfeR+vLlTbmhCBleMFywch+JuxYnrKkWLuxuiXpzAxn8GUNIBKgtazBlN80lH2gXf0OA0joPs/KzNfo30JqR22y44jpOgrHTjysVm7qjZWP+pE5F0rCEnP9/GewmsTGNxWmL5AOMQLs5fmstLEIog8b+Ze3cMuUG6amlLLhgEOb+ECjTEmJczgux2wCrPW6gn8oAhLs27oQWgNIHMf6ep3Buk4yIOBFp/PdFb7gaSQJX7Xeri9Lcf9U6ypXZEHBFOPhbjZE89s2k8c+Z7WHjtCOuj6KLHc6LJe1ziSEACpdj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zpl5+53eNH70hyL51Y1Rdr+kaM4Dmd+k8a2CgxJCXc=;
 b=JlcZtaKXGP2ViNLmUtIS3CesMEF+ak3snDOkc58n2lLz227bgw9ttCxcZaqFNJpGhynmGMUIowjJoW7DlBq/zmaSroKeP8zAi1cvKD0PK44hxydE8xfAyR5TrgaCHrcQRa8nrKHVxV66rCeWoiCYMWGXbjd/II7c4NagR139sIEHS6njSsMkM2xW0+AcnqkkXL8ojZumN/U9TEhoKsP0/CWzuJ+VoSngnxi15VMU22lfBsAyOl5H+Rd28PlpmDbuFzUoDcEkWfqvJLMhjjjEPVrWJtKLRpRqFD4N+6KfEG5Z6HRLWlkLIeUiEk245Xcp+mpWsY+LyBXRSw0StSI4jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by DM4PR11MB6066.namprd11.prod.outlook.com (2603:10b6:8:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 08:17:56 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%7]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 08:17:56 +0000
Message-ID: <99cb8fa0-b26c-4969-a203-466a082464d4@intel.com>
Date: Thu, 9 Jan 2025 16:17:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
To: Zhao Liu <zhao1.liu@intel.com>
CC: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com> <Z3+FWW9v3QqL/gEw@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <Z3+FWW9v3QqL/gEw@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To CYXPR11MB8729.namprd11.prod.outlook.com
 (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|DM4PR11MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: e418642b-e65f-4dfd-442f-08dd30861edf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFVaaC9WZm1jMDZJNnVHL0lKK05nNTFYaFFEMUpQVi9RaUROMzNEZmRrekh0?=
 =?utf-8?B?Q0ZZY0hxTGpXV3A0SlU2NGhCbFJsMERHTHUvTlIvb0s1dEdNK2lWcWhqMU1Z?=
 =?utf-8?B?Q1V2QS9tNEFENVdmeWladHNGSHdraEJWZk56SmI3bjg3MGRsd1FzQUV4Y0Q5?=
 =?utf-8?B?dVBmWTI4SUJGd1VjMkZVQ2crN1dFVGxFNERUU1U0MlJvSHZyMVduSnVGTW9C?=
 =?utf-8?B?MVhkbGlZeWpkTGhRdm1XSFM3cFl3cjIxZlQyaWhNODZoR21jbjU3TlI5b0xa?=
 =?utf-8?B?RCtXYnYycWJROERWQS9LQXdQK1FMTzRJTHh3NzZuSldISGJLWVJ2R2xWYjVk?=
 =?utf-8?B?S0xveFIwelJscU8weXF4dFRmRlpRa2g3RVphYzBUcGFyL0VVeVNBN3M4K0Jr?=
 =?utf-8?B?TXJpbHhyeks0YzFDVmg3ekVoL2R0RXlkM2h0ZHBBVGExVlNMOVlJbHN0eVpI?=
 =?utf-8?B?UllkY0pYK3pPWjdCVTJCSkRCZnRDMlVlbng1R3lyMjhmY0h4bElLZFFYOEpX?=
 =?utf-8?B?MmdkaGttVUZzditCNS9GMWw5blZMRnRxM3dVa1RxQzA4eFdTZEQ3NnczaVZG?=
 =?utf-8?B?MmRoeU41SVU5TVBHQklWS0lkMnpCbis2MFZJdUM5TlU1UEdvWWtrMkt3amxF?=
 =?utf-8?B?WnhOQXlRREc0TzMrYnNrbEZDUWtOMEJhRXZwYkF2bEVMYnhMd0h5Y0JiU3Vq?=
 =?utf-8?B?WWZYeDd3S0xEeUJzbWtjZFd1YUlrekQ1aTZKa1Y1L1VLZ1drc0J6b0NTU0ND?=
 =?utf-8?B?bHYyYk1kR2NxVjBGZ3h0cmtqbnpYdHhDblZSa3FYTWRGSlk2cEp3Uk1zM1VW?=
 =?utf-8?B?WUtERTdacVpUYUdDTE96ek5SZk9xMzFUTXBJd3ZEbnFLZ3FhemNOL3dubG5N?=
 =?utf-8?B?REFqekpuamRoRGY5VmVUcml3K2ltc2RBOVF2WVBPM2JIQ3pyS1FkTjZoU240?=
 =?utf-8?B?enpwaFVHSGYyVC9uaE9Velc4K1p4TksxaGY4RytCV2pnMThWdEhCWGFrVDdh?=
 =?utf-8?B?dXllQUc3Q28wVHRjL01KZktZUjJrcHVKS3o1ei9XWDFaSDcwVkQySk9WSzR4?=
 =?utf-8?B?V3p6UUV4d2JWdWJycU1IRDFDckp1aHMzZGkxOE82VUt3eWZDazNLdUxZalc3?=
 =?utf-8?B?TWh3L2FQOHc0eTQ4RDhRSysrVG1FVmlEWjNKcVlYWFpEdDJ3bUZVakVUT1Nk?=
 =?utf-8?B?dWxaOFVzQWFZUlJLYnp0OWtUbGZWZVhMUFNsQ2JkZDhaWlBhdmlZcjJvd3N3?=
 =?utf-8?B?bXVoSGo0bld0TzI1cC83VzVRejlIMFBoUWJOd2IwRkYxbEl2aFlWdXM5KzM2?=
 =?utf-8?B?d1BxdTVqMlNObEp3MDR3VmtTK1VmTWVnSFJOL2pqQjMwWW9abTFOUDRoY1M4?=
 =?utf-8?B?L0c4WkszVWdrV3MrK0ZvZEVoMGYvdHcycGxrQ1Z6TW1WLzdZeTlhWkRacEZV?=
 =?utf-8?B?alFyVWNBVVBFY3UydTF1TWlUSm8xbkxmZzhRdGpTNHhaWlJCMEpxaDJGNVdn?=
 =?utf-8?B?cTVHc1ZKRmpjWFkwQzRsdjYvYm1nelZOaFhLTks4SUNVdWdGcVNKTkVRUklr?=
 =?utf-8?B?dTl3N3JDZXVFdHV4bGplWERUYkZtTlNic25IQTN1SmR0Y0NjMHZoSkE2TDRh?=
 =?utf-8?B?RTloWVBOSmRjWk1rR1RibE5waTJLYm5mWmswQUVSaExVN0UraXVkS3h5aW53?=
 =?utf-8?B?TmVybmZoVVNRMWNtSGlsVWxCaHRYUGNzbzBNU3Z1L0ZBVURpNjBNNUhhaHNz?=
 =?utf-8?B?N25heFIySCt1T1BQdzZpVDRRUFl6T2o1QlliWHBFbjBFMTJvZ2orRE1CTklx?=
 =?utf-8?B?VkJMeVRNYldmNE13VENqUDRhZmdOSXBmN092VnZhT1hvVy9qNHJZQ2xTVzNE?=
 =?utf-8?Q?kY5N3rXtHnNOw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3dzOHA0VEVrbnV3aTlOMmJyZkE0WW5VWFF1dGQ0b0dSYnlEQlRmNXQzNlV2?=
 =?utf-8?B?OEQ5a2ZCeWZXaDFmUUpacWdST1BrbXVSV3diUlJaV2ZRdGhIbmVKeVNvS1dN?=
 =?utf-8?B?R0V0VWgwLzRYaXhTV3c3dnpyMzU3aVhraVhJbFpwbnFiUlR5UkJabFk0VU1P?=
 =?utf-8?B?SEFsRXNNa1BWa3FNVkNiaHdXYU5paW1QUlpnVjNGd0JlaDF1dmVLdTZZVS90?=
 =?utf-8?B?ajZLYnVpVWEvTXFsRUJDdnZlQk9HT0pzWDlNSVVQc3QvbzNIdkdGMllHcnY5?=
 =?utf-8?B?cUQrSDBKZ1c0RnYweWNSTkg5d1VUcnpZNE1iRzMzOVZpS012WG5XZzF3NHBF?=
 =?utf-8?B?Q1N0WXdDUlYvTFh2UHhZck0xQlJzMkRTUjJjZlVPUWhKeXcyajdEQ3gxOWc0?=
 =?utf-8?B?UENnU1ZUNG5CdGRacHJPZnhLTCtNQ3IvUHVzUC9FN0N2VC8yYUFLWE5FdWIy?=
 =?utf-8?B?NThXb1BtU0dEdi9qa0ZDbUNuMUIxNlZBMDVvMU41NTFjL0x1ZmxhRFdkTlky?=
 =?utf-8?B?cEIwYmJjNDRWcmdNZHVZZEszdDFZZVVBRE1MRVpvbG1XQWYzdjhWeTFsQlVo?=
 =?utf-8?B?YlcvT0l0NXlSdXNXT0R1THJpMGdUQUk3WUxVQ3BLT21Da2s5ZkpEb2xVL2ta?=
 =?utf-8?B?K2FaNk1SdVlGZTBBTDQweml3b2Q4UVMxQlQwZk50QWdLQmZSY09GeW1jMDFF?=
 =?utf-8?B?RmJnNmF5bWlJRWgyQTNPMXBGODlnWXdOcDRqREh3SjJFZ1hyME1iWW5rT0h1?=
 =?utf-8?B?WmNYaGkzaG8yRFg5bkR5TjdDcU9XVG12SkVJWE83ZDVWcGdvdXl6eU03UWp3?=
 =?utf-8?B?cHpGZ1h6Zk53VW82NmdBbWFHNk5LeUxGQ2VPblF4MjVYMWRIdi94L052UHpD?=
 =?utf-8?B?Z2ZoMTgra0Z6NkJDZlQ1TkJPWWVQWnBORk1qSVdzdktDVG9oVnlTNmRDWWpD?=
 =?utf-8?B?dWFpYkNLKzNHMnEzczNSUGxYVEdyUDlMWWxtc1VCaEl4STl6QUVtdVo5a2Zw?=
 =?utf-8?B?NUtYb0RNU09OQ3RRc2ZPaWhTUFhYMG94emE2UUVVTm4rT3NWSnZSRCtaS3do?=
 =?utf-8?B?UUdlNzdyNk9NRnY1K1dnSmVDYVVZN3NQQjBTcW1FckhxODB0R25NSzRpTWQ3?=
 =?utf-8?B?VjhRbi9PZ0ZNL3Bqb28xWlZObUdVQlN0dm9wOXFHZHZSQWlkZmNkWDhXQXdx?=
 =?utf-8?B?ZklEcHZKMGZJb0V6NDFSSThCV0lnYlBKWndYeEUvOTFSUnR6SU45RzdTUEMr?=
 =?utf-8?B?QUswSTJmZm11aThqWHc4K3hSdzNIRXdHNDVJb3dmYUd6Z1RXK3hGUnJzOEZF?=
 =?utf-8?B?ZzhVTm1ISmN5eEgvOTFQVE12QVduQUhFVi93T2lsVkhRT083b2hDNGVBWFcw?=
 =?utf-8?B?UmRqUnhSWXZDS2ltdlBLUzhBMzlWdjFQMFIyTTVSelBVdWU0d0FlajJTOEpE?=
 =?utf-8?B?YUQ2aWdOWDR3Vmh1SHdPK3BFdnVZdkhxU3VBWkw2a1BMVjNYZ2ZtS2VpVTZu?=
 =?utf-8?B?d3REWHBQSnRYbDY1M2pwTzdZaDBjWWljYktnUnJmbkhGZjB4OWk2U0IyZHpB?=
 =?utf-8?B?QzZ3WlJ6c3IzaTA0WW5VUEJWVEpVNEt2S1RXUWk2aVB5QmRuR1dJQWhKZFE4?=
 =?utf-8?B?TXFJMkdQbW9BQ0F6VWxJMUp6Q2dZNVUzTmRaRWQ3SlF0UUpBV2lzM3ZHKyta?=
 =?utf-8?B?MkJEbXYrUHhtQThDQUFWZnRkdXJzZGdOTmovcFd5b0l1bUMra1FPeFhhUXRW?=
 =?utf-8?B?clh0OGlPd0tzaUlpaXZZdFBiYUM1R2RTQS9IQXlWZm83OXNiVHl0Q296SG5B?=
 =?utf-8?B?K0VVYlZJNkVTMUY1NmdxbXlrb1ZDSGQzYWQ5SXhDd0J2eUVOOEs2VTBOYm85?=
 =?utf-8?B?NlNoQkV4cXdmS1BjQVdHUzROUjdpd2E4NXZ5U0l3ejk5ejFtQnpXT3NpNlNJ?=
 =?utf-8?B?TG1DT3BqN1ZKanQwQUtCSFZ1WXFybnZrUllzTlF5Vi9nVitOQjJlQWlnYUxq?=
 =?utf-8?B?WkJjbnJ1QTBFaGVvd3NuWUdMWXBaOEFjMWQvdTZLRmYrRzhDN3pjdmRVWmJr?=
 =?utf-8?B?ZzU3V2t6WWd5QXJCOWVBQ2lYWnlJOFVTUFdHalBYMUN3VFVQS2UxMm51bUc3?=
 =?utf-8?B?YzR5UHNmeDE0a0kvZmhYRnNlc2t1NzRrRjl2Sy9KTS8wa1JkVVpBZDVpajFU?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e418642b-e65f-4dfd-442f-08dd30861edf
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 08:17:56.1015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfaB/Z7/bDPrZDa6redmg5Q1qsO2mVQv+Y24a09L9SLoeiT4Nl0l/utD8Dlj1KdM+8R8UElnzdnW9KcysOexyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6066
X-OriginatorOrg: intel.com

Thanks Zhao for your review!

On 1/9/2025 4:14 PM, Zhao Liu wrote:
>>  #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>>              qemu_mutex_unlock_ramlist();
>>              goto out_free;
>>          }
>> +
>> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block->mr->size);
> 
> realize & unrealize are usually used for QDev. I think it's not good to use
> *realize and *unrealize here.
> 
> Why about "guest_memfd_manager_attach_ram"?
> 
> In addition, it seems the third parameter is unnecessary and we can access
> MemoryRegion.size directly in guest_memfd_manager_realize().

LGTM. Will follow your suggestion if we still wrap the operations in one
function. (We may change to the HostMemoryBackend RDM then unpack the
operations).

> 
>>      }
>>  
>>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
>> @@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
>>  
>>      if (block->guest_memfd >= 0) {
>>          close(block->guest_memfd);
>> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
>> +        guest_memfd_manager_unrealize(gmm);
> 
> Similiarly, what about "guest_memfd_manager_unattach_ram"?

Ditto. thanks.

> 
>> +        object_unref(OBJECT(gmm));
>>          ram_block_discard_require(false);
>>      }
>>  
> 
> Regards,
> Zhao
> 


