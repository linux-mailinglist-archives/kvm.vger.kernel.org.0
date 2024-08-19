Return-Path: <kvm+bounces-24487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8B395656E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 10:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0724D282E55
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 08:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAC715B0EC;
	Mon, 19 Aug 2024 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LTfskToL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D1615ADBB
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724055689; cv=fail; b=bKRjL3Rc/Gm2A8xMpYezcSCtF2kdTAqD3o9JCf3+VrsMkNJFP7KXuPgzFStt1yTpGdJk3QNKsWMzD0HA8v4fAPe/qQvONQQCsf0NluQG6bQF4JnCnqCXj4ubcIlij3XmcPCS9BCIrLKy1flvYJSUFJIx/fLyxg60Zu6sgy8so/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724055689; c=relaxed/simple;
	bh=k1g8J5zBoFxLIhX9H5OuTshMpFZP6qY/HlJTYCFsOr0=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KX26lwSmHxAn/PPpadWkNeUzH3JIqLPGYgOhuYtDU61mB1Jgtk8d0MsPXTWLbEV7nbopZ52ZbTZA6u7hH60Jm8L5GpzlyXOB0AjiHpcbfnlcIOlD6SNpa85K4Y+S9w9cj6gvYS+8v0KWszwnwHpeWfxFX+EFZyHVMMADSMPs3Ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LTfskToL; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHccremjzJv3NYARyRn6KohdCTXeUlXAfRlsC2FLbtrse4D4LPE0Y5sCER1/GdbQQHb7NmmzosLbNARlLTmSk5EnI6hdBe0DB2hhQvmh+puYRS+BJubj1agDCTtl1hQLdu5XGTDvVwiJ1corkosneHlDqxXCOLMODCz0vJgW64YaPhAF4iZHQnLpp3cxGaMX/1k+m88yMoDA8SL5eHLexijFQzf6IrZNaNQReKSeMJDyqv0Gjxm7wwMkaS+Ac0lFcfBjQJlAe+hWkI281NtWdpUkeCJH7S7kO05GnqBzYo6yGdOSWI6yZf4uaaVbO+uQxMiEu0SIDaO25TMy5YElPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Q4Uxbo4rY3XYMrFlO8Lmz5q6a7efQyicsOvkjI2zEw=;
 b=DNE+uHj/uyySWzSWuuACW9mEEVvfHzc7z8W/W38gkoKAMtK6MJwIXSE+R6cdykoCvty60nwYuk8gIPqLmseFCtSxNvAkDJuPTsVvvyP5O3EUduq3tq+2KerW5JytX8WegMai07qoGGGi6Z7g5MbI5YFSXI0DtenGDZuKmDJTjShw42WaHqH+nI+qP5+GlbCNErDP8JSXEFPFor8LsFRrYAp0NMUp8jGdKB1XEt69cvlNlapsgUvVgGFnmNM1/g6pIMuhwDo2jZZ6U3ekPu9S4pDfRUrpG3I+xsOQXxtyLA0BTqKHvcrCp0wDfTA21OaHQLMEH2qv/8N9MXR67SxbqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Q4Uxbo4rY3XYMrFlO8Lmz5q6a7efQyicsOvkjI2zEw=;
 b=LTfskToLX8Eys8n0gR0CB3hhsmKJFRHGG1aa+NyDKEeSNOqtPnw2FtCBH7nC36Y7FHGKLA7WMAkoGPPJuowLE2utWrqEv0tI3lqCIX+BH5B23bmSjyIexLIoXDOpYT+mjTmG97KrQFszlkSj+kA7QNDB8x8g/cpy/3Cqsmb21U0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 08:21:23 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 08:21:23 +0000
Message-ID: <594cc037-8c49-4be9-a9ce-4d846975dca2@amd.com>
Date: Mon, 19 Aug 2024 13:51:08 +0530
User-Agent: Mozilla Thunderbird
From: Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
 "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
 <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
 <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
 <8a73ef9c-bd37-403f-abdf-b00e8eb45236@intel.com>
 <f6c4e06e-e946-489f-8856-f18e1c1cc0aa@amd.com>
 <20240816125252.GA2032816@nvidia.com>
Content-Language: en-US
In-Reply-To: <20240816125252.GA2032816@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0149.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::22) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|MW4PR12MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: a8f74c83-3413-440f-a0ae-08dcc027e92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWJRRTZSbFdaWXpTdnpMREx3QXlEdHhJeXQ4eHBnaW55RE0yUUNucmg1ZEQy?=
 =?utf-8?B?QnBadzRCUWdESERzZStlVUlHVDNXenNrdWcwYjM3QzRpYnNpUldGSEpmbGZS?=
 =?utf-8?B?dFEzR3UvbW9Pa2lKU1FnZ2pCTzFIdXpFZ1VFSmZKOVlUT2NoSXkycHJhMTdM?=
 =?utf-8?B?WDlQRVF4YVdYMExjS0JlNTNGL3IxQXBEcFRTUGFObS9Tc3h5aWloZExYQ2s3?=
 =?utf-8?B?R3htTVdRVG9Pajh2QkhtU08wbEE0cWZNNzBZOUtMVnFQNW1GTHZUb2tnWUNF?=
 =?utf-8?B?TmdocWVqNjd1SFVMTlUrUlZBdzc1Y1I5Q0w3VXpkV21sdzFtRTdYcEJFOVpQ?=
 =?utf-8?B?MG9OTURoNmVSTlJndUV0blVCbXFuR043SndPczhDOFhKTlhlNjBzaTlIZ1I1?=
 =?utf-8?B?ZnZWaGNncUx4eVJQWUhBVmJxdDdsMDE5UXdEYUk1MGF4SEFYa0dQNWJNSDZx?=
 =?utf-8?B?dUtoVE4yT3l1ZUlhOWpWRTR4c3NuNkh2OThEWGpBZTM1Qy9UOHd4WlE5cHU5?=
 =?utf-8?B?VWdyc3dEblNoaVN3Sit6Z3cxZWlWQTlnNk81OXJrWXdwQ1B0NzVqSldtbDgy?=
 =?utf-8?B?a043bEZ2R25HZ2tTbi85L1Z1UUNYT0tyTFV1SGdFWW9LYisyRTMrYVNFcUlW?=
 =?utf-8?B?N3lSaTRIMnJ5c2lXZERxaEx6QVhvZFpXWFlaaXlXZi9VRHdZYWNnK2NiWWkz?=
 =?utf-8?B?MmRWaUk2a0pQVkljQmpvcVVZZU56WWxOdE5UZ1QrQnhwR1Q5OGZuRW9US1E4?=
 =?utf-8?B?dG42ZU9DMkhXY2l4V1k0amlGdXlKUU9QcExjcUtvYzZReDl3TWUydjNIY2oz?=
 =?utf-8?B?OGV2ckFVM0xOL3gwbG1NQjd0RWR0RzRzaEk0N3JsUGxUTGpET09QejNQdUZ2?=
 =?utf-8?B?ZmZKN1Q4S3lqN2hvOE0vWS9kTzdDdHUyR0I2c1U2Q3hHaGMxeXpwUmhpdURh?=
 =?utf-8?B?cXUzdDIxVlRnTGJrdFNjc0taWERyaFN1UHZMSURiQ25rU3NuanBsQStWY1RY?=
 =?utf-8?B?OVZWd0tQRlFQY295UGkvRDNQNmJGbHNCSjhkN1JGMFdSaTBqclhndlVETzdB?=
 =?utf-8?B?TTR3WXlpTlJkSkROc1VNZm1RRStJa2JUNGVyTzdRNlJPM2t5Yk1wVmkyVEQw?=
 =?utf-8?B?dG44T0JZZ1ZLSzdIV2F0bys5VUZTUEVPSU82bFlBd1E1UEo1dWp4d2dRK0ZL?=
 =?utf-8?B?czBKQ2piMUlCOWZRUDNocGpucnZSNkV5Qmk0WHBYNWFJYjdHK0Z4b0JDamMz?=
 =?utf-8?B?eWhTVitxOXBCdTBUcmhIWEZOazVHWkZqcHFhdW9oeXR5elhNd295b3h2LzFQ?=
 =?utf-8?B?UHpheXY5enc4cmJLL0s2Nm5OUlJwL0E0MThHbm82cmdMNmpBY21IQ2tRaGl3?=
 =?utf-8?B?SHdOMWJKaUM1aHNPZ3VjUmZYcDdpY2V4Ym5JblNrb0ZXQkN1NDBGQ2FUdFJL?=
 =?utf-8?B?L2tUN0czbXV3ZE12RDNNVElhejhLZTVrd3ZuMk5icERZVis5TitYMnFjcDI0?=
 =?utf-8?B?dWowdEFzSFpCRWY2ZWgvUElHdjdHNnd2VzBkSFJBRHpuRitQSFZwQ2l6QWtT?=
 =?utf-8?B?d082VXcwSFIwUy9FK1VySzhiY21RdHdyN0YrZ0VSUjI0R0VnODdKeWpLQkIy?=
 =?utf-8?B?bXZKM1orWmFwSVEzSmU3Ym1OdTZBQ3pWaUpzZ1RPdzAwU2NnVU5ISklFVmlR?=
 =?utf-8?B?N29FQ2l3d1dxeElGQS9aS2NmN1FhQi90Wll4UWdRUTl3VXhLZUF3QU5QR0k5?=
 =?utf-8?B?T21mYnJDa2wwVzZKYUU5UmxxUkE2R1l3MXZERWthaEJ3QnNlVGsyYjhMdXFT?=
 =?utf-8?B?cnN0cEI0UTBMc2tNdXYvQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXlrRnczaGhadzF1R1NJMWtudVZldlFubVFZZXNxOEZiK0FTMVRKSFRnYjUy?=
 =?utf-8?B?d3pwSHE3cE9wY2plV0ViNzdzd3dTK1ZUbnJucVllQVJIUGdpSFU0M21PNG5o?=
 =?utf-8?B?MzBtNnpYdUpXRHZrelFqZGtLR0xkOUUxVnUvMFNrdzFibERjMmJVWGVtZVZZ?=
 =?utf-8?B?ektNMi9ka2pBZ1dPZjQzKzJtZjNGWkM5Tzd3MlNJZkdkRVJseUV6ODhzMXVE?=
 =?utf-8?B?WUtPWTdKZldRQ0puYStIUXVDeWd3bXdqYzF4N2NpOXdUL0dKZEtKYmpKeFFu?=
 =?utf-8?B?M0dqSTZqMVIxZ1Z0elk0NHEzUXRjSUdpMngzUzVKT3EvNFFpNXc4QzFpTEdu?=
 =?utf-8?B?a0NramJaaG4wdjhPTFJnSCtZQ0RxWGZFb1hWQlh4akh6aUFFM1plOUJnSll4?=
 =?utf-8?B?bjlKem8zK3BaQ1NzZTdZRlRTQnQ3dWhvS3FCazNjKzlxVmVtWTJlZlN6N2d1?=
 =?utf-8?B?dTdzSktpZ2dNUHFXTFFTbENwczZxUjVsNklrcGYySlQydE11SnBOeng4Tjh4?=
 =?utf-8?B?RWFQTkdsanZRU2hKMzZ3bDFZSEtRNXJmZ1Z2SDdPdnFJUjdyYUF5NDFLUEV5?=
 =?utf-8?B?NHcrMGcxcHJRcmNBWE5oM3czV2l3QXZQODZVK2RUWkN2dHNoYTRnU0dMTm9Q?=
 =?utf-8?B?eXJqQW9TVjM4NmtMZmV6cHJOVnBjYnozUWtZdDl3dHJSZzlJbWNQdlJ2NXlJ?=
 =?utf-8?B?RmtlVTYxaGp3aFhraXV6MS8rMUd0MGNhcDh6TXlyeWZPMUJuL3lTYnprVHM1?=
 =?utf-8?B?clJBWFVGWVZRTmlreFl6OUZ5anlISU9ZekVHQWFLSjR5d3NMayswWlpwcnpJ?=
 =?utf-8?B?WFNTODg0NmptYVUySml1enp6YUJJS3h1Nnl6QThlOHNhb2RoV0JrNnh0cXJB?=
 =?utf-8?B?Wjd6UEFGMXRONC9iQVpiOVIrSSthTWQ3Q2gyZHdUbnlyUVJjY25wUXl2NFRm?=
 =?utf-8?B?YUlTYzN5SDRYTnJmVlNuTEtsOWtFTUsxdTd0MjdwNEcrSFF6aUsxK0pLc1RK?=
 =?utf-8?B?bVMwQlhCazFLaXFFYmFTYkJUTjI5RGdybDZYQ3BReGNwOUNVSVowMSt1WERN?=
 =?utf-8?B?QndNWkVHdlN2Y3J4NXlac0VIcS9MTE5oTWZ6VkM5TFV5a2xwb1FyaTRPM010?=
 =?utf-8?B?Q1RIVU80c3RFS2VBdjFvVUVBR1lVbnNSK1U4ak9wZVBHSnRRUGl3MHRXN1JT?=
 =?utf-8?B?NU9Gc1FXblRreFl3S0RsRENsWUJVc1FtRTN4YlFZdUNNMnVvTDJ6bTloYVVQ?=
 =?utf-8?B?YmtJMmRQZUUyeUdadHZYd0tzZlJwOHM0NTVvMU50bzFZbDJBcUhZcnJiOFZE?=
 =?utf-8?B?dGlHWjdOTHFob1FFZ01aR2ZLMXFhTUl3R3JCL3UvY1VKTXpGZmJlN0FkK3Bj?=
 =?utf-8?B?T240cEJuZk5QYVZ5TWNOd1puNSsyWHAxN2tWczdOT1R5clhxTGJjU1BZa0V4?=
 =?utf-8?B?M3ZMTnpOUHJlcUpYdEtLbkVhMHRCbS9vcWp2aHRLeG9lTndRVzlzUjlkdGF3?=
 =?utf-8?B?dGhOVVh4UG1XM3ZVb1ZzeERndG9TNUFmWktwcjk3UFMyY0ZkMWRJNzM1T2FZ?=
 =?utf-8?B?YTRiK2pqUEt4cmo4R0ZWMEJEbGhMUCttcjF1TW51VVdpVVBROW5iQ1RxcEI3?=
 =?utf-8?B?eklNN1V0aVVaamZIRXFWZCtzdFNWYlVVQVEzZ1BZL2RzSXpNVmVFYWFqTkVo?=
 =?utf-8?B?d2NXSndsS2Iwb28yWGNlOVZHNDhrK01XdUNmVWRoQUNDRzg1a2haZUVzUHVB?=
 =?utf-8?B?b2NHUGtRQTNiY3Z3eW9xUXJyWkV5YWg3S1RaSVEySXFnOXJQUlVWOUNIRkRl?=
 =?utf-8?B?VTJpYVQxYmZvRTFLcmJ0ZlZFYlB6aXVnWk1meEMrby9DYkRaRUZ0K0hLeWU0?=
 =?utf-8?B?MmpjYkNTSWZMSGVZazRJWkZsc2J6WE10QVU4STBJVDE4NnB0OXFEN1RhY1Fz?=
 =?utf-8?B?em5WbGJ6dEtTYk1tMWdpWkt0N3FFdlB5YUpERVo2Z09qVGFSeE56RVdGVlY4?=
 =?utf-8?B?UU8rWFVxOXlFNVpaa09LMHF6MTZJQ3ZlOVZUWUNSZEVjc0hrdU5XSG1NeFdo?=
 =?utf-8?B?QmN1L08zSjVwTENGTUFxL3hMbS91R3Z5ZDVERmxqSHFTNjAycTVmMkhNdjB6?=
 =?utf-8?Q?TwT7k7gb0XmyFm4T6zVc59jop?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f74c83-3413-440f-a0ae-08dcc027e92d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 08:21:23.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: du4j+HKGOO5KshdJJ//Tt9awTfJKJazcol/MWxUETBZcZa90bqlJOP+aFns9s008IcIkPMM0Oo9SOZ4j8ZN97Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262

Hi Jason, Yi,


On 8/16/2024 6:22 PM, Jason Gunthorpe wrote:
> On Fri, Aug 16, 2024 at 05:31:31PM +0530, Vasant Hegde wrote:
>>> I see. So AMD side also has a gap. Is it easy to make it suit Jason's
>>> suggestion in the above?
>>
>> We can do that. We can enable ATS, PRI and PASID capability during probe time
>> and keep it enabled always.
> 
> I don't see a downside to enabling PASID at probe time, it exists to
> handshake with the device if the root complex is able to understand
> PASID TLPs.

Ack. I will put it on my list. Will make change to AMD driver soon.

-Vasant

