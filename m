Return-Path: <kvm+bounces-33704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA559F0605
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 811B118898F4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CB219E982;
	Fri, 13 Dec 2024 08:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixTTUg2m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71017199FA2
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734077314; cv=fail; b=LqMvvIwOZyyd/ItEXbUWgnagBkQQ2s3fy5UazwVXl4hFyhmtRAH4lW5ET8pWXRbFN4P0ghIuKMpLEDqweYdHatD7L+Qb4tCYXyS8M57X5tfIAXdwfF1JbmNzmn9PksfOItfCPx/45oFvrHAoFPLSOIHm2sUqom8XDto/w8fnWyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734077314; c=relaxed/simple;
	bh=Er89OYFCAKLo8hp08i1LkyL2juZ918dKJe0W23Y8edY=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LLD78DXGcew1uOXFs/H9BX/QlgTOYx5RJrjpnoQSRh7jpcE9gwZFRmfJ8BF+VeOVVRSmOYXG7OrfWMn9LRaEfY8pKTpY1ExizyibvQ0WtrdUxxrgZk29jkZ9p5T7+qRbRPmYwpHu8MlIn/YWPPGbVcPXlR8/YYbgyU+/m2HstZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixTTUg2m; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734077313; x=1765613313;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Er89OYFCAKLo8hp08i1LkyL2juZ918dKJe0W23Y8edY=;
  b=ixTTUg2mL2Hf7PO6fxSTyU2mES2asnznyl8F4z9Qa5oehgHFUp0FHA7u
   BNEKJzzgueQ+cO+QAn8aRbCuRC/CQ41nZWlB2iAN0UQ9sB0P/z//6bCpH
   hA2icmkg3jLWMnDvt5tag4wUvX0zekgyC8b8RcE1FGSXYNviRS2qs1rD8
   ej8vrCqU/VQXClhXNAXx827xMcMMWeC0Iao0lMFKF7Qk3pvTyCQxtlTql
   KgbsszvxpMRN+Af64AAiWFhtjwQi8Uy+oqKHbKbLLsrvzG6uRgHb0WzCN
   WTEVqGNo1fejormO1jh8mlON/h5WOgO/JLBUy+tF9OiF9FqJpHFlcVqOF
   Q==;
X-CSE-ConnectionGUID: EYxQlWXaS5C9PNUPtHbYaQ==
X-CSE-MsgGUID: vYzJKoF1TCW2UE3eTa41WA==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34396066"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="34396066"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 00:08:32 -0800
X-CSE-ConnectionGUID: HFYdLmLzTDW3SlS9L/Y4Gw==
X-CSE-MsgGUID: yk6tykbYQP67EkvLcMcXKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96543648"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2024 00:08:32 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 13 Dec 2024 00:08:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 13 Dec 2024 00:08:31 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 13 Dec 2024 00:08:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ur0qyS9+FS/xhOoBSjjQdYGqiNWmjpSi9GZFQQedHL7xzBMdbgMRVT1nX7huN1kOq6JokSgOT5pfbeRmXWbNdQM6UVUmbGuWTGtXFWs+TTvy21svxyjsiaxQw9HvSTschh2G2KTgWo19Zi0hYog6A/lESxete8xhpZLpMdT7nRh1pBAUqu/bLvnzDWdhgOGpLZGdtLxDRkws4A9lWEETK/K8zt7J2/rk6qoo0rL8s1q1gBHTFyQzQU5QpY7rAArf+A2ZU5iX3EkvIqgO59/mQec+dSRjW8PqyxMH6ee8vYjVO4vVNKeRds5UYhKMMK2mhefhi1H6lsvzaIUxmoeYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnWfms8BTR6GME/6c7ctzK0qRNzTdghj67LQvT4PTa4=;
 b=l+mcd4UIOmQcVE0cJ/bHvk1jchznKPDnb2IW3hCDcdJJ+H8tccLcTrX0yY4Qr/qkkxdPLYLOjLPtHF31wEt+RG1R+CPsYTIVUm3Rg91VLJPdGtmAvEiQlTNatK5Ft9GKK+LXmsdGRNVj4Ho5gBzwPaJRn/wB6LzjMwWmX+JBWrM7BKHaV2ga8+eSIVw75WhpFMc3MhahPaDA9s2gr6we7GBdntHyFle5id8NgSHxBY40pfYRfdVN/zkpdnWGI2HvLe75WvZsM6k2PcEGLS2HNNllpLf1XdmWCWQ1d3ug2AEjFk/KFq8On2R+bhdt9fFdPYQePEvfmEaeaRoxaqPojg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7386.namprd11.prod.outlook.com (2603:10b6:208:422::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 13 Dec
 2024 08:07:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.008; Fri, 13 Dec 2024
 08:07:42 +0000
Message-ID: <4787c016-646c-49d3-be23-2dc7389bdc5a@intel.com>
Date: Fri, 13 Dec 2024 16:12:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
From: Yi Liu <yi.l.liu@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
 <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d4d959b7-3260-4e03-a0b6-078ae2ea4450@intel.com>
Content-Language: en-US
In-Reply-To: <d4d959b7-3260-4e03-a0b6-078ae2ea4450@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::32)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea04315-c250-49be-287d-08dd1b4d3824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q01CUUplckhwYktiSkFtWXJXSHozVHRNei9ZTVRra28yVE5YM0hLc3dSQk5V?=
 =?utf-8?B?NDZXWG9XTVIydjNvNjJWcXZVZFovYm1UMW01ZkxNT1JCQ2NOdER2KzZVelg5?=
 =?utf-8?B?b1UweHpKUUtjTTdybWIrd0tMSFJXcUR6UXZJS3I5clVhTWxhOVBvT21CU1hQ?=
 =?utf-8?B?a2l0aHdDNmZQd1JraVVpUHpkU0VIekxpdG9PVElQRXR0V3J1Q0JkYWVZa1d4?=
 =?utf-8?B?dEozNXdFNXFYUGlXbElxRlQ2U1BwblpCaS9WMjExTmM4clFrbElMZkh3WHlz?=
 =?utf-8?B?dzJiTDl5a2hQS0d5TmZTa0o4bzA1bkMybmxPYXNEb0dGOHE4N29ISWF1V29h?=
 =?utf-8?B?NlhIbmZpcS9oaUtBQXB4enFCbG9aRWVsTm5ES1dQRkk2WEZjd1c1KzBlS3dL?=
 =?utf-8?B?VmxvOUlJZEJqeEppMEFSaTJhVWZJWkMwTG5idjNNN2lGaXdFTmFCUDJNWDJx?=
 =?utf-8?B?YUVoL25YT05UblQvVjVGSkRCU0NsWGZ0dk92SzRGaUVITVFJdmp5aUd5QXd0?=
 =?utf-8?B?ZTZjcnZtQVVKL01FbGZiY3MydVVHT3ZabFc1NEQrRkI5TjRQcVlsL3BTdTF1?=
 =?utf-8?B?RWNodU9meTZNNXd4VXk0Z3FiQlBBdStHZGU1ait4UFdwSFdJaU50RzEwcXhZ?=
 =?utf-8?B?a0FlZGdYMW5qK2wxaDN4ZHZMTVpjQnlBbklyTEV3a1NTVERpR2xVZnFHUzUr?=
 =?utf-8?B?TVVNaGU3NFVjNmJoS0NvODFGTm9rd3hZYmVKa24wVm5Ga3BUVGRxYUdkUzBs?=
 =?utf-8?B?dFNXOEg1VG5OMStEVHZLUkNOSjU4RzAzV0YwRTlwd0Z1REd3L0pqL2JkblR3?=
 =?utf-8?B?STZ1Slk1T0VjbHp5TnIwTDFLQXAwT0pvcVNDWm12QlNhNy96SlpmU1pmV1JT?=
 =?utf-8?B?QnBFK2F3cnRBWVVpRDdEci9ZaWRhczIxZkdZb3ovdHlUTkxFeExwczBjeDlm?=
 =?utf-8?B?VlRhWUdTWVl6Qlh0bkZhRm1PQWpnZklYenpxc3VVVG5pdkErZzZLeUx2aFZy?=
 =?utf-8?B?WWtzUEl1MXFnYzY0a25qelJmSFhOTk1aeXcrUnVhS3hDakVXQXZlajRLUUJJ?=
 =?utf-8?B?eGVJaDhDbERGOStrSHVwT1o3RXJobDI5bXBZc1RXU2dES29MRmxsTEZOZEt0?=
 =?utf-8?B?ZE5zYUlUaXZub3RUU1ZRamI5Ymgwc1dXemZqOW11b0JSajc1TG1XT1VqYnpV?=
 =?utf-8?B?SGpPVGRBeXhLY29rS1ZsZEIwYmF4RWtBZ0U3ZEJPRW9sTFFwRXdIdU1zVmh0?=
 =?utf-8?B?TkFudDFBNTFGdzhaUjc2bGdvYytTVjEwTVVtZDdqdkI5Kys5NStQTHhtL2sy?=
 =?utf-8?B?L1FaRmxZSHVYM3VJbjlrUU4wU0wyN29wRno1QjNWcWJmbUFKYlhDR0UyNGtB?=
 =?utf-8?B?aVdvVkFtUVB5WkwveENmOG90Z1pZOStURXM5dEJjK2wyRHZCOUR4ZGdHdVBk?=
 =?utf-8?B?YW80eUNER1J2djRGV3hrY3hXMXc3MGd6ZTlvb2JQcGVwZDUxdmFkNnJvSzFU?=
 =?utf-8?B?c2NPNkdLY0xiQS9WQXVBbXVMOStsRm1zVW1SV1hIdUZGblIvOWY2ZTVMWlNw?=
 =?utf-8?B?dEFvYTgvS0Fnd2liK0IvSnROVFk0T2tUN3hVK2J3YTBwKzlaaFVDS0d4NVRX?=
 =?utf-8?B?UnRURDlKam9RNzAvaUV4MDRGdVJuSm9KaEdOUGFBSjg2eTFJMWlNc0pKbmZB?=
 =?utf-8?B?WWd6RHBkZDNuQzdONURGWHhpQmNRc2plSW9iRVJGUWVkKytJclRvbGNwNWRS?=
 =?utf-8?B?VzJyakoxNGM3VUxzTE5ZR1NIZ2JFL0Y4bkt5SjVHQUhnQzdUUy8yb3FFL09l?=
 =?utf-8?Q?B/jjCUc5hPHHiOqd/xIG9ybinOcmEonPKptVo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWhpNmlvSjhkcVVwaW95d0dpb041RWM0eEpGdkMvYzZTL1cvdnIvTVZGalZV?=
 =?utf-8?B?UFMrYzA3VnR2RjZHb2l2cVRSdHJjSnE2aHlKUWMwQUFRMlJjYmhIeWhSUldp?=
 =?utf-8?B?WFpJd1R4R3VRb09vVUFiZmNZNHdNK0Mxakw1QzhLdXFxWm50dUVlUmhQMkEy?=
 =?utf-8?B?T1ljL3czSjh1YW5tUjNKbVpqemdyNkhSUlpjRjdERTZQNkhUTWZEUEkzRitN?=
 =?utf-8?B?RXpMN2dSamJZOU5RVW5mc0h1aGxqWUEvZXh0Qm82eTZqQmNBblUyRTcwL0lG?=
 =?utf-8?B?WjFBdGFpeE43YVZ1cFNoV0lwNkp5Z0hQVTVTajRpVjUzcENIU1dTbVZCTkJl?=
 =?utf-8?B?OFdYNGFmSHNOUmRWUlhkenFCZjVuR1VGbUpCbzhleEZZYWp0YXpPdDl1M2g4?=
 =?utf-8?B?TmtVeU01UThKYmxVK1Y4bHJvR3g5MGFjTDRoTC90UHd6Zk1wT0ZkWk9Ta1p2?=
 =?utf-8?B?YmFMOTRVc1Uzb094bVdKK0hTMUV6ejJFVnB6ZzQ4WlNONzJTazdQcEllcC9r?=
 =?utf-8?B?QWFodUN6WC9rWGx1NDlJcUtrL01YN1luQW1TSVFNNHR0U2srYk1ja3VMQ0lW?=
 =?utf-8?B?aW16QXZVVlJScC9lc2VLQm5SQUFsVW13ZkhZVGpKY1JZbVI0VTl2Q0p6N2NL?=
 =?utf-8?B?Z0I0ZDJkU1R6NEt0aFhYeDllakNTWW1CNTRxNnYzVFZyUS9WYXl2Ri9mRFlu?=
 =?utf-8?B?UG9JaU4wZElHazBnN1Q1Z2tTb04rTndpdmRXYlhRSCtBeHBNV3Z0Z2o3L2RX?=
 =?utf-8?B?K2RzaVhZd1ZVNVhOdWxxTTE5NFV0Y0VhcE1vRVV3bERDOVY1cklVMEEzTWZW?=
 =?utf-8?B?SlM1RUlJYlZCd1NvTlZGczg0ajBXM2IyQUxpWk0wTFljbkZ5NldZd1lNRVBX?=
 =?utf-8?B?ckorbW00a0RURmo3V0dBNzdKUmI3dnZhSGZTdUhoZENzaFE2T21IK3gwSzRa?=
 =?utf-8?B?aEVDemFuUlpyUVltcHlnRlo3U1EwZmN0aE9DdE5qU2ZnNW8zYk9sSklOMGYx?=
 =?utf-8?B?VVliUy9QOVh0NEQyam5iWGI1SXg5WnRtWjZKTHhudmN4U01ZbWdPSHRpTXFz?=
 =?utf-8?B?dkFTZmcyVVdMQUFCazdlc2RjaDNLaWNFTWNEeEZtbFhqTVA3WjZSODVRWTVH?=
 =?utf-8?B?YWIzMW1uRjZOcnVvWlJYcXpSRG1odGJFYloxYlk4bzJjUUt2UlpZOXNWWHRR?=
 =?utf-8?B?d0FBdXQ1K3MrU0M3RmxTdk5vQnA3VENPR0JKVTFHTGwzcDl4dUI1VDJGYnZG?=
 =?utf-8?B?QVU4UVlxTjZmREh5bmdQbklxVjNaajRhWExwc0xrSllibU1pMWVTNk4wOWls?=
 =?utf-8?B?Zm5pMEFrbTg0TlFDM0hHR1hmUGJ3aW41YUxmaHlIbFJZcS9zSWtDVUZ3NXk2?=
 =?utf-8?B?bEplUXZxVXV1dEo2K3l3dE44Qi81ZzFnMGIxWUFPK2JrdE1GdHo2RXRVTENs?=
 =?utf-8?B?TUVJTzAweWN3bVJVN1pEaExjZ0ZOdFpBSW1FRy9kNjdtWDZicXVjSHFSMk5T?=
 =?utf-8?B?MUgzVjVINkU3R09qTEY4TGxhemhUTC8ra3pHZWZKMlM5MjQ1YzBLYkczNkhF?=
 =?utf-8?B?ajJxcFpTQ0w2QUpjV09KRDJrTkcyODl4dG5pSnhaRitZbGhZYWhNY0FjbzRq?=
 =?utf-8?B?K0J2bWJNQ2FYSHJiNy8rOVpkSndhNVQ5dDM5dGcxM01XTnlvVVNDcjZPbFpY?=
 =?utf-8?B?S2IzQVd6a2lmVE5tWGNMMTdpc0xObUx4a2x3RFBsRTJ3aW90T1dWME1UYWdV?=
 =?utf-8?B?dTVDTGdJVnhGQVlLeS9GdXNoWEtwTzd2WS9HQTdQM3VnaWwySFdZQ1EyWmU1?=
 =?utf-8?B?dWZ3Y0Z6UUp2c2lEWDRYcGpFZDhFRTFQS1ZORlBXQ1k1ZllBQzdjTVJwZ2Zr?=
 =?utf-8?B?dkdyVTdQM21KR0pSMHoyNDArM25TMHZDbnFtSWJadzBzTWNZVXZpcysyU0N1?=
 =?utf-8?B?OTJkQTBObjB4YVpZWFlxc2ZIdGdUM3JKTUM3SWJSdmhPd1oyV1Q0NEdWZEFu?=
 =?utf-8?B?M0c4ZXFmVk5EdG9RS2hZbkhHbWk3ekFtYnBzcEt2VmRpdU8rY3grSHl3N0tD?=
 =?utf-8?B?a2tSWmc0aGhKL3Z5Rjg2NGdzVmtmdGJ6aDJZcm5xN3l4bmlOL1ByL0Y3eC9S?=
 =?utf-8?Q?yt8R1ogopSjc/uSH43AGVnHBk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea04315-c250-49be-287d-08dd1b4d3824
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 08:07:42.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IWeEQjxa7R05GpiwdNioSMy/qfBA2C3ZptIjLR96FdLHAWYrixZ9mup/pfM2rwQan8Mf2isf7X7pRUR6EVmjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7386
X-OriginatorOrg: intel.com

On 2024/12/13 16:11, Yi Liu wrote:
> On 2024/12/13 15:52, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Friday, December 13, 2024 3:20 PM
>>>
>>> On 2024/12/13 10:43, Tian, Kevin wrote:
>>>>
>>>> Here is my full picture:
>>>>
>>>> At domain allocation the driver should decide whether the setting of
>>>> ALLOC_PASID is compatible to the given domain type.
>>>>
>>>> If paging and iommu supports pasid then ALLOC_PASID is allowed. This
>>>> applies to all drivers. AMD driver will further select V1 vs. V2 according
>>>> to the flag bit.
>>>>
>>>> If nesting, AMR/ARM drivers will reject the bit as a CD/PASID table
>>>> cannot be attached to a PASID. Intel driver allows it if pasid is 
>>>> supported
>>>> by iommu.
>>>
>>> Following your opinion, I think the enforcement is something like this,
>>> it only checks pasid_compat for the PASID path.
>>>
>>> +    if (idev->dev->iommu->max_pasids && pasid != IOMMU_NO_PASID
>>> &&
>>> !hwpt->pasid_compat)
>>> +        return -EINVAL;
>>
>> shouldn't it be:
>>
>>     if (!idev->dev->iommu->max_pasids ||
>>          pasid == IOMMU_NO_PASID ||
>>          !hwpt->pasid_compat)
>>         return -EINVAL;
>>
>> ?
> 
> no, this check is added in a common place shared by RID and PASID path. If
> it is added in place only for the PASID, it should be something like you
> wrote.
> 
>>>
>>> This means the RID path is not surely be attached to pasid-comapt domain
>>> or not. either iommufd or iommu driver should do across check between the
>>> RID and PASID path. It is failing attaching non-pasid compat domain to RID
>>> if PASID has been attached, and vice versa, attaching PASIDs should be
>>> failed if RID has been attached to non pasid comapt domain. I doubt if this
>>> can be done easily as there is no lock between RID and PASID paths.
>>
>> I'm not sure where that requirement comes from. Does AMD require RID
>> and PASID to use the same format when nesting is disabled? If yes, that's
>> still a driver burden to handle, not iommufd's...
> 
> yes, I've asked this question [1]. AMD requires the RID and PASID use the
> same format. I agree it's a driver's burden but now it's defined in the
> ALLOC_PASID. So, I doubt if it becomes a common requirement to all the
> iommu drivers. Otherwise the ALLOC_PASID definition is broken. e.g. Intel
> may have no need to enforce it, but it would be like Intel is breaking
> it.

aha, forgot the link.

[1] https://lore.kernel.org/linux-iommu/20240822124433.GD3468552@ziepe.ca/

-- 
Regards,
Yi Liu

