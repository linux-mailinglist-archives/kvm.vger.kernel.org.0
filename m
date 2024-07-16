Return-Path: <kvm+bounces-21680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48BAE931EA6
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 04:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBC271F21D8E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6DF6AD7;
	Tue, 16 Jul 2024 02:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nl+p98I/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1C76FC1
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 02:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721095412; cv=fail; b=Xab5S7vYrb+F8HeZpImJai5ud0ZauZBip6G7HLh4sHb6dVrc2JBPW64GeS5IA9NdkLPsZp34Ir/MGjNg8cyvRCeHP2NMKsXxNnJYswHWa7qwy1SjfnAk69+1FNJMul9cdZ44j0YLcnrbDzkrOY2t9+wljkqgcIb4vUgbU0zwAWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721095412; c=relaxed/simple;
	bh=oFeC7SSVlC/STRezheH9zt0talG3xIN0rbID7Vv1bhA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q2q8c6leM9Gsi81T+moP42kOINTpO9Ad/VsZOXCgR8cNLeXWiV8K1jU6FXqpNshGCXgWyKktJf1x1LQ9Qe8f/NttDHzOJXnv/ViWACObHGVWVllF5xohwBdlxtKJibOJ5ObfepOHdmouaEU8u0prKnhlBqIPuIvfMWOG8x5lLc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nl+p98I/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721095411; x=1752631411;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oFeC7SSVlC/STRezheH9zt0talG3xIN0rbID7Vv1bhA=;
  b=nl+p98I/ZpqA6wtwwen1uFnv4hZTJvyc4NxJvKA5RQYwHjir/5quQdnS
   kXp+vqiGKJi5MflKnqp0pVI9YEAbXfS3y9Y+9JK5LMQqS6L0QxY/eo0y8
   p4yTxdnZsMTxh6mw6tIDYNjApOC+1ZO4IGfQy7gFcb+LisCFe7B7NNk5h
   QZ+6Qz0+n9imviUtsp1EYuls3KWzEe8mJFjWsM6fC9cSIPnOT3bPMBrZU
   3Hv7cJq0/aTTA+pFq6iO3uWmNE7j/HjxeFqkzWdWS5v9gDtcMc6FPpC8j
   iNpozqSA5rq5e+WJYV+PK9QFJOYGJJC+hBlaf6gOy7loJUraUfyhIPbDr
   A==;
X-CSE-ConnectionGUID: MtzQIZsFRW+H4P2Dx6p21Q==
X-CSE-MsgGUID: rYKB54JfS2mLKQlFI/oHQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="35942151"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="35942151"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 19:03:31 -0700
X-CSE-ConnectionGUID: rzjCXUctTDip60Dq4ml9DA==
X-CSE-MsgGUID: xnaB1GN4TO2G98NaTlsLTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="49769809"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 19:03:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 19:03:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 19:03:29 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 19:03:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FgYLCrlQlkttusCDb2iH6gosrdpE3lNmK7zjBz2ViDttaM2FFNcT/XdKgd106TcY4hgKnXWIPHXTIUcXgD/dBn+QgmtDjidfM8mdUyzZ37CqqFPunlBKwUtYMjvN288vx2FHiakE9UH1LyHuZ+UkQIq7r6/9gzQ+9+BUkmDZ2ck5Yn/tMTQFglP/oUEqsQbMbsW+hQFtYowtdly7NuCzjfTxz/WLkNpFP+hmBqaFKVy3HhUJeNXGvUPIhJrNZqp5661Qar/O4nvU5tGHf3L1gRHHY7zPqmL4rD79g6n/VBfNdrC56DO1KhVC1rf8vG0kM1RamWfUE0Z7I6lQ5dFIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kddNt/Q5wq/38E8OYWyAwrKuWh1AHlj3Ot1eSF7K/Io=;
 b=Z2pd7VXekzVw2AUzK2Vot8ixmpIJynIFW02p3J7co2fHkmEZfTTrEG2hGagtzChulDcag20vJn0Q2TN0OYS+HRwFoB8NXWgHKaRZ9jWN9NrGFE3RaxjheXgYfxI9TVCrWGKoO8p+w5a342PSrewg/yxXcfd897KIbcdW4nIT9J6Ek8yyEp5ksnYTHCI+zw1pZKBAWXtMQYS4e1By3L39Ov9mvwwuw3xiG3SpqjaWreS63JzNXL1P8BV8FpLZe7uZRN1Sfi2yb0XIXekerUQDD9GGm/v3BJAAUGhZx5X2OdtvIeeE/shq9jwpYYTXPdur4At3yFE9cmsY0CRVOibeNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV8PR11MB8560.namprd11.prod.outlook.com (2603:10b6:408:1e7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 02:03:27 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:03:27 +0000
Message-ID: <b81ade0e-fb1d-435c-9372-25032bb7b59b@intel.com>
Date: Tue, 16 Jul 2024 10:07:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240711184119.GL1482543@nvidia.com>
 <a3848458-b41c-4ef1-ae0e-28bf5f3ad43c@intel.com>
 <20240715121946.GT1482543@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240715121946.GT1482543@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV8PR11MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 30435daf-56d9-4476-f9b4-08dca53b7b59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NGNVSE5KWXBpOVVaQk1LRWJmVEx6OW9zRHpDTzF1QjhwM0Q2aVZ3YU40ekt5?=
 =?utf-8?B?YzlUekRnTDFlUThramZXUGpjVC80eEVpd2xBUmVnajNweEg2SStUaE5TRHFB?=
 =?utf-8?B?dG8zUC8wazRrbXl6UE1QRTNUenNLSU83VWdYWEoyV1FlRmw0c1F1eDc2MGtq?=
 =?utf-8?B?N1BLZjRJTG8zdzV3cjJQWEVpRm8yeXN4YUlFSW5peDI4K3FFUzF2WE1JdFUr?=
 =?utf-8?B?cVI1Z3FsT0tTV1AzbEo0R3ltb2NzaTVnbG5UWmpLaXMzaUZWTm5EdkJoRjB1?=
 =?utf-8?B?aEJqbHRYeVh5bXVsV1RBUUZYUDJHcTN4cTBlczRscTZ1VmtadUQ4eGUrYkpm?=
 =?utf-8?B?eEN1K2xZS1VOeXlmRThVTUYwalpVZzY0ZmcrbkphbkZsVk1NWkNNYzYrdUUw?=
 =?utf-8?B?RzJqcTNHcXVSZFNGejc2TnJxWnJEa1ViamUwVU8rcHZtWmdqYThYU2tCUTE5?=
 =?utf-8?B?OFUyTXFITFBGVThucWZQK2tLRVNlRy9VSFNzUUtJbkZIMnRSOTQ0U2c5VmNp?=
 =?utf-8?B?NG9kMVMwTGRqQ0s2QW9IaVlybU9GblUwZ2pkYU1RaStDc1lZN0RlZmdGcHJ1?=
 =?utf-8?B?WTZvbDZWL1lwb3IyK2d3Y2dQbitBcWxXNEY0NzBhMXFQWXAwb0Vsb2ZoTnNj?=
 =?utf-8?B?bmJ6QkkyVHZiMGZIM1BpQUx1M0ZHT2Y1eWlIRHRVd2h6MXdpTUlVZkNTTU85?=
 =?utf-8?B?YTNua0taNDhGK3R4VEEwaml1N25Ob3NUZDdaL2RnWlZtekpGL1VHZW1yUzFy?=
 =?utf-8?B?SjVDdDlCcmpNeUNkc0tZOG5LdjB1ZHZQem5EZ3JkbnRpNjl3TEtaMC8rWENW?=
 =?utf-8?B?MHh4U3hKNXViVGdNZjMxMUYxYjU0SHBvQTVGeW5jZWpTdWZUd3ljazZvbXF1?=
 =?utf-8?B?SUplOVlKbHQ0MHVRK283WGg5RWxFeDRzTFpzTWJ1RWJlSUJzVDlHek43Si9t?=
 =?utf-8?B?ZEhicjJScWVFUEF0dkhCcjlVZm4ydFNZZG1tQktiN29WM2ZzMUtpZnFwaHlu?=
 =?utf-8?B?c0lCbWlCWUNBWkZ0TXhicEtyNjVrN1Fhc0F3UHREd1FwZXF3dkNOVDNHa3JK?=
 =?utf-8?B?WlNnSk9jNnh3Q3hvYks3UHMvV2hBcHl0YnF5OWlDOWR3N01yYmdkaUVVc3E0?=
 =?utf-8?B?WkYzZ1loOHBZT1JsaThTQlZzbWtRZ0I5Q0NQMGpWSlcwLzd1N053eld5N0w3?=
 =?utf-8?B?eXRRbTNjMW1aNnRUSUFMNExkS3gxSmFTbmtxWVd4UDduQy94N3JkaC9HWDVw?=
 =?utf-8?B?d2VaNngxK0RWdm5hMHBlNFoxbVZzaHhpRnNDMU5QdlppMjVVZjdJR20xcllv?=
 =?utf-8?B?bzIxU1dzYlRYaVF1blI5ZEZRRTV4YUUwK0VDZ1R4d2JiazJxUjlyQnBSZStJ?=
 =?utf-8?B?UEhlWEhieGV5T2wwNEF2eVJrYm53UzRuUDF5WUlMaloyOGdlRVhjNnB1VW5P?=
 =?utf-8?B?anovVDZjVzA2WFROcEtDaXFHYUpZbFpaN2tnYWJWbnM0aFpZZ051RjRSb2x1?=
 =?utf-8?B?NjNQY1B5a0tBeHQzMXBYSjUxSHc0RVhJLzA0YXFRcTdpcURDL0gxelhCbEtr?=
 =?utf-8?B?SUVwOU9lWG1NNnhRQXBkb01yY2ZZNFd2QUZHWmNKTE94RUFvdjNuZzF4QWJO?=
 =?utf-8?B?emRycm1KM2F5MlRkUTRpaGI2Mm5kT1NSUURtVS9Ub0JYNjNxUUpSSFpmOStM?=
 =?utf-8?B?V1RNSXEvc2ZrYkRJQnJLRE5wN2Y0aXN6UDMvS2hIUjBKSzlVRjA1NVYvRG9q?=
 =?utf-8?B?eVVQN3N2SlAvWkFyazF6SWVvMWVzcEhRc1dyY1FaSGhGZlZ2R1FoOEZVU2Vy?=
 =?utf-8?B?alBuazZIelBBVDB1RjJWQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG9scVpMNXoxYUFId0pYaDVVT1lKMkpHaHZmOCtoME9UTnFxeEdpbnVRc2hG?=
 =?utf-8?B?R21YMVQyV2IyOTZZTWRCeVZOUEJkSTNCVzVKcFpWOU90VkdMYzRycVlLOWU4?=
 =?utf-8?B?Um04dW96NzBjRFZkZmVBdVFKQ3ZxWjMwWS9LL1RQSDZSZ0JsMDRMVHRIY2hQ?=
 =?utf-8?B?dlQvNE5heGt4Wks2R1UyanRUUWxBZC9zcDNLZUdLOStsTFVudFhNNnBrNjFh?=
 =?utf-8?B?dThCcURjTWhVYk8wby9sM0RyKy80c2RCWUZhM0FqL3RUaE5VOC9DNWlWcUs1?=
 =?utf-8?B?VXl0eUdMZDYxNGFrU2M5eFlPaDBxTVRqclFMazFFUGhBdGRzeTZQKzJTSTFP?=
 =?utf-8?B?TTIzYnlUZGdydXNwUTBLOERLSUZVbVVCZE5WUTAxRjdnUTRQRys1bjBCdEln?=
 =?utf-8?B?RldKc2Fxa2NpazNaeWsySENnS1VScHFrNzdBUkNuUzJQZ3dVTXlkeEsxd0Zu?=
 =?utf-8?B?NjluOGcwOEJBVDF2TW56eUZRTzhtak5rWW9KNXhhRllwT241aDlQZFpwWHQr?=
 =?utf-8?B?V2tMbFlCNkZ4RnhiMnhMcTZJbjluWmRUR0NpQ0tZK3dhckFRLzhRdnlCVFNZ?=
 =?utf-8?B?d2NXSXJBVHhDRExQR0pRYlQ0Y25iZXNPVjMwTVRQRk0zRlgyZldYVDJZYWZn?=
 =?utf-8?B?RjIwL0ZCTFI5OTI2NFlGUXVQbnVwLzZWR2tQblFucFA5Vi9YZWtaTnZSNEE0?=
 =?utf-8?B?TnM3bFBpaXpzcUUyTzdocWtkcmV3UnhGcmZUdlRHQ292UTZhK1VNT0djR043?=
 =?utf-8?B?NE1NWjRka1A2b2J0dmI0YXdxazZ1R3pPLzJrTlFMd2VndnB2U1NVUXhQZHR4?=
 =?utf-8?B?Zk5qeURLMFZuZHFzVjNORTJDakp4eEY0YWhzODI0QkNSSUh4ZFpIMkhYYU1Q?=
 =?utf-8?B?dnYvbFhOQ2c5M1N2Y01ZT3dFY0xoYmh4V3FrUno0R2k3UFJVaUZBNUc2aURz?=
 =?utf-8?B?RzZyTDJ6VGxob2JDNFhHZVVKSE9wbE84cVFnTVVWUzFTN3dEMWdYOEJJSW5E?=
 =?utf-8?B?bmFRR09VS1VxcWhta3RPMGFOWDQvUnZjWHhSamNucHRTWjNLcXNueS9CcnNZ?=
 =?utf-8?B?M3NIUS9wNUdreFpNNkFBM0VmbVV6aXRqaWlGM29SMGhVVEp2YUh2citnRjc2?=
 =?utf-8?B?UkN1UXFvNFFwZXhSUkR3eFlvakduZlhRbzMxS05YQ0tlOUhsUVlxbm5nWEhD?=
 =?utf-8?B?ODEzcEdjaVV3OVhHejhzdmxnUk5aWHNpQ0J5NjFoTXF1SU1QV0pMbmxiM3dw?=
 =?utf-8?B?ZG5wU0ZqKzg5dFJ1SWJWb2N6KzcreW5Od29rSWRMZkx4VU5DdjB6WFRGU1g2?=
 =?utf-8?B?d0lkYS9aYnVIaUpZbCtKYmtxZjlVbjQ3dmRkZnU0SllyMEVVWFI5N3VkODZn?=
 =?utf-8?B?ekJlbGNRS0IrU2g1QlVORk9jdU1ZazVlbDlIYVlXZ3h5a2c4MUt4eGJTaUNk?=
 =?utf-8?B?dWtSVXdTWTBidEdjY09CNVhjcWlEZjVJRjFwNzlodzFJSUQ3NjJRWDRXWlVG?=
 =?utf-8?B?VlRvUVIrZERIQ1hQb3MxT1UyWGxnUUR4bXZFTSt2T1FDUmFkZHl2ZlZJWGVO?=
 =?utf-8?B?K0pKTGNrNVdlcTd5c3BsejVwSnFaaFBJQVBUNExGL1RRQjh6bEw3MU9FUXVw?=
 =?utf-8?B?K1hUS0Y1c1NGdmFXVWYwSDBBWFo1blg2RHVBaU5HQVpwS2MxaEpydUhGckhU?=
 =?utf-8?B?UG5HWUZSYWNmb3N3UWpiWmQvZGI1ZFJJZkhHNWhISmhoTWNtc3dmeUxQZjEy?=
 =?utf-8?B?TWhXVGVGWlhoY0pVQ0dENkg0QS9UZmFVb1JleGFWaW84SE1yakhCbFZnb1Fv?=
 =?utf-8?B?cnVYNDVla3lkd0s3cXdKazNOOW9ScHJibmRmWjRocHQzSEFIbkJSeXZUTUpa?=
 =?utf-8?B?MXE4ZHlJbFNjblhRRzV6OWxpQ1ZoVlR3MGVJalQ1QU82VHBMYS9qNVMzaXc3?=
 =?utf-8?B?Zm45Rmh4TDltd1g5KzN4ZHd0aHMzWXlGWFBMa2M3bVFsMFM3R3ZwVTZDcGJv?=
 =?utf-8?B?SE16dG1kMTNSbFdHaXFMM2Y3N0FqKzlieU5jVkZLUm5mUnFnTnl6NWdGZFhZ?=
 =?utf-8?B?RVZrSEh5Y0RRRmVqM1VablVWaG11NTVNM0VqU05aYkVTOE1hdHU2Z0h2Z3Nq?=
 =?utf-8?Q?0VwrYjDxv2FdmVnL3mz52+6a7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30435daf-56d9-4476-f9b4-08dca53b7b59
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 02:03:27.4568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jpIcPWT9ZyP2QmG5RyjRqVSXbZ7H8+onqfx9RD5mKAtScPjuzV/XmcQIYYJRpZbKq1zmKHNTPFHOLaWkbni3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8560
X-OriginatorOrg: intel.com

On 2024/7/15 20:19, Jason Gunthorpe wrote:
> On Mon, Jul 15, 2024 at 04:23:07PM +0800, Yi Liu wrote:
>>> Then the description is sort of like
>>>
>>> Replace is useful for iommufd/VFIO to provide perfect HW emulation in
>>> case the VM is expecting to be able to change a PASID on the fly. As
>>> AMD will only support PASID in VM's using nested translation where we
>>> don't use the set_dev_pasid API leave it disabled for now.
>>
>> Does it apply to SMMUv3 as well? IIRC. ARM SMMUv3 also has the CD table
>> (a.k.a PASID table) within the guest. And I think this is the major reason
>> for your above statement. right?
> 
> It does, but it also supports replace so no need to explain why we
> don't enable it :)

got it. :)

-- 
Regards,
Yi Liu

