Return-Path: <kvm+bounces-12966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3B9688F7D7
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47C76298D5A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566EE4EB56;
	Thu, 28 Mar 2024 06:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GAUf/u7K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9F1E49E
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 06:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607114; cv=fail; b=jcdMlwYE+6PkyKV0hDwi+a+TiM9UZ/UabDKt62hdNEHYbUexTKMoI9qfXRAj3GX5L0d41+xFw2+4Oi89anqLSUbefWjVvOwZ4JkWvAD441Pl3KsY2e9zHv70SmEVayzl8G2/lg3uJHKIl0jZfVDXPFSLNyTBcblE4IzGfD5pFo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607114; c=relaxed/simple;
	bh=RNcU0mjySRsLphTv8iR/bnQ9RB5N9qM2lVYah8KOWew=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HYN7L63IrpQtkUHhsrGdso7OmtdPQd0t1AZKSQYrfwzigRKFp8wdvgJNm4IRd8WWg3Ki28dmtVgzEfSlYD6lEod262j7MVXVz8Onl2Hv+rgzxHuslhnlaI+MJYps4o9m95V4xhFGDW5Nr7h1Mo4p+kxvc6tJMbBQDNG9S0vYuzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GAUf/u7K; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711607113; x=1743143113;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RNcU0mjySRsLphTv8iR/bnQ9RB5N9qM2lVYah8KOWew=;
  b=GAUf/u7KjCpugtqiforM61iFOGc2I+ym/eLTN0TIdtosl+m8QBn+w+z0
   p5r8pp9x0NoovdNPxh1Yoq9/COjzxScWtEjOnquHVONC6JM8jl3+YmT+8
   y7XCzSxG/FsvH2xa21Qg29BMT3OqFHNpMJKUM2hIVCBl3d8cV26wKF7Ic
   /RM8J5xssBcuzXeqzGBNd9ZjPer18bBKnX8muMtVAxuc9q/inuzU6n8rR
   OuKZHXRYMkE4J35yJxqQAB8FXhUpMJORTG6J04ENogN57bc6fS8PXM4Lu
   EinU7soeUrdrZwSY+vmJSXn7QiT3AgRugDOdyLE4vQyjIIux4iSa1hmDd
   Q==;
X-CSE-ConnectionGUID: ZWypgAGOSraxI6eZ98gGIQ==
X-CSE-MsgGUID: 7rJZTfW9QpaUMl+bxUQEKQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17471154"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17471154"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 23:25:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16563238"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 23:25:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 23:25:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 23:25:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 23:25:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYFh89Ha5kciRrlvKyOGdGVs4Z3IZINiPb7wrhUgilN/c2PzA+oDJP88Z1kP9GOG+aRi4uE5GlKe62QzXEmSDuezJ0BEUCL5LFR1L4RdEPNfz2EtCqNkZzg5CnE2EYyxKFZMQ7f37ygl6ZCei9lAV/+Xxgpf5hm0zLwRmRQ0Buzn+uxHwDXe4W5vJXKmAPMj/cQkWHFq/MjzYs5S0dyN90ePon4+sMl0Ckj27Qg29WygpY6jJgAzyl9wCg3UWm6nfi6390gUWaeu+lQzwnCqaTLtNYrnXzxf3tPZ4Fkt4tS+p5HcM1VoXoGHf6j9z0aLSRW4Lkka3vrcO4p3z5Cnvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7n83kXtwhENJW0TN5xCW6za9u2vE6kN81JzgAlCbrGw=;
 b=B/jxqFuLuABLgxljUQwsN+LTMDp4T15B5TXBaz9TQXY7LxrIHqZLBORMvxjLV4hPyCJ79KAX8EzWQeDmIwvV/sZ2WdRjQHmEKiswK24Ja2nlI30a+4vZkvCVW2dn80lAEJ90fX6QjjnTOSxyjJV0IrAOViWgQP5w6FuMtvFaVRx/in5/g0bNLJ4urfuU42Bf5NemxkZ0OwwglbxADYYNSreh9///GClBue+gus3VOS7GmqV1itULz0ooWwSC2MO+LA0CmfenkucZ9Zy6a/iW6MpfcUxRbOWHf70NnK0Qp3Yo+yAXC5PUdthVstgan4zgqKTF1P0wiClc/npQYTTVwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV3PR11MB8577.namprd11.prod.outlook.com (2603:10b6:408:1b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 06:25:05 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 06:25:05 +0000
Message-ID: <f76f09a6-5538-4e9f-9070-c09e307a5ea8@intel.com>
Date: Thu, 28 Mar 2024 14:28:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommu: Pass domain to remove_dev_pasid() op
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-2-yi.l.liu@intel.com>
 <BN9PR11MB527651B93FE5D2EA426678888C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527651B93FE5D2EA426678888C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0131.apcprd03.prod.outlook.com
 (2603:1096:4:91::35) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV3PR11MB8577:EE_
X-MS-Office365-Filtering-Correlation-Id: 395cf463-1527-4a85-beb7-08dc4eefcee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEL7UHbcfU/41kMpNdjSX1iuKVl4FwtLgu5yoPHKi8di9RvuDlTAbeigd08eq6FONE/wLBUqSMYrdrbolGz1cA0TqBKrOquweOEmBVV8ncmyhI/GKE1wtpx92t94QminKuKyZc9snzouEgg/fLBeYqpqAd/2daASM4OvVGDYTF1UymRPf2r4cRnDqzyT8o7KBFnj/AWrDn5TCoEL+Y8NwMtgcyzAYPUsRvP92ADf+eiKQoQ3g0KEVkddBOn9s5d1tY24YMNpVb///jhqcLGKm7Wi/ZTTSJyEDydkAu3EJM44G8Fs18tv6cURAYy2HKPAjRi3Q1DJcckDpFZDJOTaMEGuNgJ6H/VZ3qec/0EjrICS/ECTx5s1MIJrhiM7q3NQvG6pk3G4yksV57wHOl4yFQzkef/UwEToDqegVwV7NbjUPmw6lr290uxufiMO01BJdvA4NS/eSzSiVsop3qAjfi9nPs5f3JoWGtzdbgv2aaJIcwZXN8VyGvAmExKiz+lKLIRCpZ4PIzn3ud0rzCllhr8W8g9dVIMUhce6A3yul1AhFne1Ad4mqwwSLbAnGGhq89yt7QtyOK1reA6T2tDuIyEeVBxZ4LJA95BoFtOhYqsvMq5/Foup1n29vVxXHCWzzxvWMLt+4D+zDzsaX7ZOoCfczgFZOBtZhiOTWBX41Y0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3g1ZERaM0kva1VXQzlvdjVxWG9kaTdPM0hob2I1QTNYV0dPYVB0YlNVdzN5?=
 =?utf-8?B?cUEzVXhIdjRXK1hvYjRadW9nWVphRXREbnhIR0hBNUpvdEphbkcvWlZiSjFZ?=
 =?utf-8?B?TjBoc0VwTTh0VFUzaDVLNmZBK3ZyRWpjbUVZd1ZuYXplVU5sSGZBb3E3T2lJ?=
 =?utf-8?B?YmdzMVFxc1VNYlVKanZxakhhUlV0Unl0Z0RXV1pKamQvSGo4ck5Ua0tvc29v?=
 =?utf-8?B?Vy9CdzlRYUpYY3dxRFJtaFJnWXhnNzc3RVA0WXZpL3RHMjc0U3RaanExK2NR?=
 =?utf-8?B?YUlkUXhwTm9rMElTbXRSNlh1S1Q0NlRydGcvUzFIalVwdWVFMXBtT3ZNOEh5?=
 =?utf-8?B?N0hlSFdnbjdxVVZlcjJyL2dVYndzaHBEMDdWYXBqUURRazdZSU54NWRtU0ZX?=
 =?utf-8?B?eWU4OUJqckxidkxMYWVQQ1FoOHRnNHg0SEdXNTNCdTBNTjhqc1JKazhLV3Fp?=
 =?utf-8?B?d3VXYnJGR1QweEs4SDRwYnpIY0lyOUZyb29qRW5FSHlZVFRyVXJPRk5yWGdF?=
 =?utf-8?B?V0JQMXlYNkVqajVKcU1mbkx1UkJSZjNjQ2xwcWVqRzNFMHRoSG5hZFoybWdN?=
 =?utf-8?B?TTlGVjNEdm9YNXN0aC9IdWJtM2JVNFBYWVp5azJBeUEwWDJBYzQrK0N4K2R3?=
 =?utf-8?B?UU5wUjBtS0ZrVGVlOWU5REJoTGtBVi82akwwMGVEdnRQc3NHbmowZ3oxaFJ2?=
 =?utf-8?B?WXB5VG5xUTBkbVpkRDFCTms2enUyMnNoN3djVHBKRWtPS3kyR2p6SnpxWGIx?=
 =?utf-8?B?NEloeXM1V09JYXA2NjdEaXlOOW5rRlNERUJqbm1YY2xLWllDRlExbm4xeWE0?=
 =?utf-8?B?eFo5d0swVzBVcTJsdWlIaXJPVTdyUzRjNjJXczVmMjJIK3hXblZvbWFSN0Zy?=
 =?utf-8?B?TDhjRXkzYkk3YzVoaGRyc3R4UVdlNDZoS3lCUFZ0NjlEc3BEcnQzSzdIWEhh?=
 =?utf-8?B?ZWYwa2FLa0dtZ2RMZzhoZ3pMdklWME1sKzVwN0pXbTAzdXNMbUIvN3gvejN0?=
 =?utf-8?B?QkpYcCt6SlN6TkRWS3NvcGFpaGZxQU0wT2svd3J5cXNacFRXbUkwSURNZ1pt?=
 =?utf-8?B?djF0VFlZSnR6RHAvUmx1TTZ6MDlmQW5rbGJRUzRLSHh3aXZUQU95eWNRVnF2?=
 =?utf-8?B?aVF0TmJ2MndiRG1ySXpZeUEvalllSVFTbmgweWJUa05PdzgyeElFVlBIdE0r?=
 =?utf-8?B?RGhJd3hPRWU3c0VQaytSTEVTUkZIc0g4engwcjdpN0xwT3Q0L3VlalVUL3dK?=
 =?utf-8?B?eWh2K1pwdE1aSlVXQjU1T1A5MHRISXd3T04vZC9wcUMyVVRjNTlSaTNDQXNa?=
 =?utf-8?B?NEVLUy9kblBRbjh4QXFIbjlNYjlZRTc0czhYTDZJWEdmZzgrQXNtWCtkMVB4?=
 =?utf-8?B?OXhjUW92VVZhcytuQ1FtOVozajBCYmZJRGZ3Z3J2cng1TUlmdWR2dklKNFc4?=
 =?utf-8?B?YVJIK3RaR2RiNDZjY1pVaTZobmxTR1VYdnpOUzZwUC9taXAxYkEvMGhlUWlX?=
 =?utf-8?B?clRWUW9tOFRtUDlBSytOZkJ1WmpaUEtnajU5L0diWTY1S2VXcVVpemc2K2Rs?=
 =?utf-8?B?UnZDVEVuNFQ4REUwakdERlJzSzVVMDc4RVdZY09XS1ZDYjRUYzBuVFppVnpt?=
 =?utf-8?B?MFZKV0FpbmdEVWliOXF4TTNHczI2dzVqWStmanlrMkpieVRJWk80ZEpYcUFB?=
 =?utf-8?B?NE9XTkdFNUlJempoSkpuaEx2bGF2VTd1NmNVUHVMMXdCQy9TZk1HNmo2eHFX?=
 =?utf-8?B?bGNyU3hSR1RoSWxiN3V2aVMxVW9ON2FqQTZHNmsxZnZqTDRGVy9ocC9sS3Nn?=
 =?utf-8?B?U2wyeWRRQTJmOTNoSlc5UGxpbnJHOVZOWGFIZ2JQeG1SUmFVckNRRjlGS0hF?=
 =?utf-8?B?UkZaK1NJdExnRTBEaFpQaWxFTHdTeXZ5Y3N0WXE5cmFMcDVsRmlGc2NhSlJy?=
 =?utf-8?B?Q3Y4Snp3N2xpQXduNmFFUk40V3lLcE5rcUhRazVlZmRocTlXR1prOGFOdXN1?=
 =?utf-8?B?dTlrU1JEOU1KdXdoSGtCQWlPVHJtS2pzQWY2YnB6WDJJSjBoNWxXZUhPWjhD?=
 =?utf-8?B?ektzLzZsaWxNaGExMksrUDVoUU43cTJUSEw5NVF2N2Q5Nm4yNHdpRE9QM0s4?=
 =?utf-8?Q?aTgu6n4OuU7LeRYY22DgBY3OI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 395cf463-1527-4a85-beb7-08dc4eefcee1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 06:25:05.7952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: op6de/QOGgoWK46EamqEd/e2bPfakINbg+d1ZP2tG46KC/Ow4dh0+dmOIC9P5c+ziY9AxaZ54E2vOaLTPlA3KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8577
X-OriginatorOrg: intel.com

On 2024/3/28 11:12, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, March 27, 2024 8:55 PM
>>
>> @@ -3375,7 +3376,7 @@ int iommu_attach_device_pasid(struct
>> iommu_domain *domain,
>>
>>   	ret = __iommu_set_group_pasid(domain, group, pasid);
>>   	if (ret) {
>> -		__iommu_remove_group_pasid(group, pasid);
>> +		__iommu_remove_group_pasid(group, pasid, domain);
>>   		xa_erase(&group->pasid_array, pasid);
> 
> I didn't get why this patch alone fixes anything. You are passing the
> new domain which is same as original code which gets it from
> xarray.

you are right. This is to avoid getting domain from xarray in
remove_dev_pasid(). But this part is still the same with the
original code.

> so it is at most a non-functional refactoring with the next patch
> doing real fix?

yes. let me make it clearer.

-- 
Regards,
Yi Liu

