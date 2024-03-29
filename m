Return-Path: <kvm+bounces-13048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C2C89120E
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 04:34:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C51F128BB03
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6B639855;
	Fri, 29 Mar 2024 03:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNIlSk2d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D18347B6
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711683285; cv=fail; b=eIskf9eWUFDiRQlf2OZAQBbg2JqKcenolG+ukfDPs6rR/NsUrGAOMWrGjn1cVOX7ZnvMw+oXRaPmEGrHxSmhrK55Pl/LsDI/vgdSGiWpy+Jxw2IO5msjG/akqbHvp6uff7g9mjQRrwC/4tSIrjV765zlvZHBm5MooLMoB7RE7NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711683285; c=relaxed/simple;
	bh=PIs3nzD6J2py0hd2P9BbxErFFVXXZQtgU5/5UTaiU2g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gIp5inZLDwr5SNOqOf7q+KEGB5+esIfToMoSXuNv6+z+r8PJHUqaAeapBc/TVfXQ6Db0b6mA0WmBZkv3B2PXH2f858ZqyTGhUp+nU74LcgdCUGDSpg13mjZE6FmBdY1/IPsGB4Nv070EMFj0Whj2NShgXTDbIXJca4gT9Q4JXKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNIlSk2d; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711683284; x=1743219284;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PIs3nzD6J2py0hd2P9BbxErFFVXXZQtgU5/5UTaiU2g=;
  b=MNIlSk2dmHMy3ypIN/kvZTyvJLAfY7Ks5U9YtqgPJ78GEbkUx40a7Epa
   NDPVMM4Ty9CGbPqLqnUmp3nP+FPzELHRMAxYDTFypcPui0AiQCfR8eqt9
   Y1WYAGnlc9ff4AJMdR8+JgYx33qKzz1Z/iapnVRmA2c+uzQIqDRIS5m04
   PtAkx5VKwDHFpZu4O1TaLGnvFJ8BBsgAoi9f/mWpSAStuaqzeMQsCVZgF
   PxYfJz0czo8k/winzm7ReFXqPEmN2K09VTMsO3alWLIT5ITl/44FKWP7m
   Jq8xtoRdvCcYzpRXdfzG7RFmz8YR7TpJzZAhQ2tZlkRz0r327kf6Iu8uD
   g==;
X-CSE-ConnectionGUID: naiabGVIQ6GFVgico4ykqA==
X-CSE-MsgGUID: utH2rW1HQNq/dQo6MLGAow==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6996233"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6996233"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 20:34:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="54320368"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 20:34:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 20:34:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 20:34:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 20:34:42 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 20:34:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJlja15KotlMOY1zZ7mZuVX4Bu1jp4iyKsERY4Ikjb5n4RbrQykWfL0MxyIMLqmqs5+hibyxZJonrtiryjyD98OmnCN4epA2oFY1Pi/9KEPmoTgAKc37TsusA9JDs9qpFyXh9WLjhsvuGiFHsOd1QoQhcapTbRuxHBkLnW+D0CfWguGZS34584WlizRSixQ30BfzRup0WqG+vh0WW1AwxRUThTtUqnzsJ2VBwHgBTCgnsnPeFXdaOA0rZ/mJuvc4MfH1Dlk6NzUqP9ICZdEiztn/IscR3Buj7BoX+9nMbMN7eJXBhKWVXMcBa21SEDnZi5VlY/CPZ782nnYpTnwrdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fouCpvQlpB9A/LJPW9y2RY39I+uIjA5FfSS7/tBcgn4=;
 b=I8xwRgYUUc/f5yIiQUhnVpSTCmxxYSAabhE5WpkcKdLEpWbp+xksJvlctDkJy+lz8IsXIzP77Arz+I2T0MUBOz10PlyT5aBiy1GkmpNZbMPrcjdrYYacvrFLGXJHRM0ysqlwGBpY57WUeDja9bqYzRfqn6KZ09C6nbCyHTPz7muQ1HUVxBxN+97wenQxy8boQpvVzkMKXKW+ITLdgNslssKF6vzvbsMeSEZVxU5AOD6Bj/Xmi8cjRVI3GFn6bGVsaLxieEufKs3iwHbGsa8GnVuDKdWfePTOt5bkU/pZ0zW9n1HbARJ8Wxng/gdJ5+aCAMk5BNIeeDbQldCbhosquQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Fri, 29 Mar
 2024 03:34:40 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Fri, 29 Mar 2024
 03:34:40 +0000
Message-ID: <902e9ca4-51d4-4705-9d60-e03f8d914ef9@intel.com>
Date: Fri, 29 Mar 2024 11:38:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Content-Language: en-US
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5181:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ol812uDmWaXo8GoB0tRDUzyymhEMwLNUqCVEkU6BOWZUi5udCMj28/8z9G4EYRGNrKi9Exlu266nSWxgZH6go5y24OklzhlQQZUqyKUf0Y5f55iG+Pt1Sox5VKjJ4RF1nB9/9nMTdNXREhEB9SvrTqVSdfN0VLgwiKVkt2LxETxAOeVnGzHw5ykx4R2X1GAOUmIlEDp+PmUW58kq/d2arUoPPANGPARyV3xRltFmuvDh8530VTPplutMBXZWVMg5WVGeJFI4uFBS+zhaPOH0h7LVZZSsnjO9elwP6tdXgCS0oZcNHpzkKYNxQO/Ub17MdCc4Ft6WfFrqe9dPSfq7aDmcxcmwE8friBYBUKWapjhcWvkstsRR6aoIkn3aRszj11/4CTLcIgFbWYoDeNpOnjEyLwKMqNC6PG/UmI8pPixTpqudNcTUWyBWG7mT4IcHvTDf+3J1lljYiX3bLHO8RjC5SSnN/gSMCqZraaBw3AXvf7/2x42HIkLr6/Kka7x9hZnRK6Ji7saDbjNavJnKhSUJwYUPB3o9/XYADAribIwh6+PckBjmdQVHgu0lO0vfRnOLIeRi1oWi6P2tf5dh8T1t8MjUlPMceN8PE4T8o9irlDBwKeV0BoJwYvagvfij
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cElUOXJwQ0l6SzVMaC83ZW5IY2o1R1B1VFRZK3lneHlscUFlT2pmZDhLMmNv?=
 =?utf-8?B?MnhYUWpZdzdwZGNQblZFNW8vTjJydzdmVWlpVElwRlFObHdUSzl0YWlFcG9x?=
 =?utf-8?B?bHkwWVg5RzVzSWFickovRkpBRFRKQ0hnSFJkL1RWTEE5ODNmSk9xNUZqVS9s?=
 =?utf-8?B?T2g5bmx2d0Ztb2tmc3dwd3ZsQ1JqL0ozZ29WcWl6VjllUmNaTXZlcEJIVzRH?=
 =?utf-8?B?TXg5eHdKYWp6cWUxQ1ltajRxM09JREdQYU1QZHFETVpCN3llU1hZcDhNZEpj?=
 =?utf-8?B?T0RnM0kzUlFQaGFFNFNOMFFHNWovVEVnT1Jxbk5BcHltL2ZQU3R6SjVTbEpu?=
 =?utf-8?B?SmhOM0ppY05oVEROMlBJRnpoRDdIaHE1K3VLTytSaW13Uyt2elNvKzdIaDVh?=
 =?utf-8?B?R3NrWm1xaVA3Wlo1QXhKYTFEejFsTjNLS3lxMkYvUnVGMGdVanBWT1A0Um82?=
 =?utf-8?B?Y1pTcWp6d2xGTUtkb0pJanRDS09aeEpPTkRnckVOQ3FiUkxZNTVOSVh0WXdG?=
 =?utf-8?B?cmNuVkQ3YmlZN1JyTDdxVkRUMDBmbDBBcGRTbDhrTTdIcE5zMDIza01jVTg3?=
 =?utf-8?B?QmZvNzBBNEZ6cnMrdUxNVjJKWlRHT2xra0xXT3hJeXcrOUxQWG1OVEhWem9a?=
 =?utf-8?B?TUExWE8rTXBmMytNblNKS3ROWUdHdzhMKzdzVlV5bmM2Z2tQaytCeVN6VWx2?=
 =?utf-8?B?eU1mNTY1cTl1MDJDNEo0ZHJFbU0rVlNXOGx2MER4eFNOWWJvS2FhOTk1SmlU?=
 =?utf-8?B?QUJUWlAzcGFzNzJ5L0xuY2FobkMwbk0zQmp6TGVBaVgvcW1hTVYzd0xZRnEr?=
 =?utf-8?B?RkZSWUhhTjJYTGx6UkVkcHM4NlNWOGwvTkNoSU1CUXVOMkRuL0dNL0txWW1K?=
 =?utf-8?B?OUZKTmU0WHUyMGVFMnNJZW9FR1NZQVpuK0N5dllDNVdncUdHOE9YSW41MFky?=
 =?utf-8?B?SDRWUFRpeU5OWHZ3Qm1qTE1UVEltWE9MTTRnc25nZFY5dFVGL1ZIR0JERkw3?=
 =?utf-8?B?QkZ5dUV0N1JPZnM5WkZ0akcvd0tPRUhkQ285b1JJRjh1Mi9renppYTFtOUJ0?=
 =?utf-8?B?eFVGSEJlUUo4TXpTa3hUdUF0d3VTeDFueUZ6RkVIek81c2l0dXJZb3NyS25Q?=
 =?utf-8?B?VXkwcHdEQUlGT3YreVlHZVhaZFNFV3c1SllVdHM4ZW9YSEJKby9JZkVPcmxv?=
 =?utf-8?B?RFMzVTRmd3orK0ZYQnp4clh1QnBaTThEblN0TTM1U3gyRXRLVU1rZ01sbk90?=
 =?utf-8?B?MXJPRHVmY2xSMnhtTWNyelQ0WHNmaTVLMnlxVmkwQWZka080cXFyMFNDU0Jw?=
 =?utf-8?B?cHEycmR4OXBQT2FyZWEzOEZXSmloRW5UeFdraDRZZitoRFEyczJGcExhS2c1?=
 =?utf-8?B?bFRVdEpqYi9nQWc0MjM5UXh2ZnVKaHFnTjVqY0wrcEkxbVQ5QjdiaFdNbnE4?=
 =?utf-8?B?dG0ydTRUVnpyMkMzdkVmVk1wMytGcXB1ZHB6bDN0TlQzd3J2N1VBdUw2d0xp?=
 =?utf-8?B?UlQ0R0VjTTdVemZzdXlsOHhOcm9KeFQ4c1B0UzZIaVZxZU0yUFc3ZzVKQ1Iv?=
 =?utf-8?B?ckpwcE1rMmpKejdKbkpaQStGdFlRK2g1REhXSnJEUWt5RXE0dXVVamNFVWNm?=
 =?utf-8?B?OVpQK3l6R3dkK2dDUXZBbk5mOFJzZ0lCZ28wYkNGUXBMemtDTXhQM05acUNU?=
 =?utf-8?B?cnpoYmVpTW80VnA4a1IvUGYxREZwVDJDbW5IUWZjR0gyVkNvMDhpTUhGeUZt?=
 =?utf-8?B?VGRWWXRBaDBiOGNnaXNzT3RiNm9JMTFpWVU5YXlwM1FlbVcweWVPOUdUNUVV?=
 =?utf-8?B?NkdkMzNlZ1V2T1d5M0NST0JyMXRQbWR4TjdCR01LMGQvNlRRK2tSUXFmUnph?=
 =?utf-8?B?dGN3N01Qb0VxaGxUTWw0VTlLOTR5NVNocnNlOWtIZlpnSUxMeU1za0FzUEp2?=
 =?utf-8?B?a3dPVzVVdzZVVnM0V0t3czFhWmpTTVp4REFQQUttNS80dkZEVk96bUdzQTh5?=
 =?utf-8?B?Ym5oSTBHRjQ4dWkrdllEOEpTMmxLTUQ2UVJEWVo2Zm9ERnRLYnh4eVVXcnYx?=
 =?utf-8?B?OW5nem0waGdIVFhSVDh4OEQycXdBbnhDU0VNalVxMmc0Qis0alJiRExiR0Jk?=
 =?utf-8?Q?i0S7AlInBqs+2niIayd/m5onx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ee846b-9efc-49f9-39dd-08dc4fa12a5a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 03:34:39.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIqu09yOf5Syp/G3VXALV1hBW6fNvW7t06Tq6rtG7LX6MzxSDANHz2N28MnPKWyd4B9i7ZFgwqQDeVLTtMSgIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5181
X-OriginatorOrg: intel.com

On 2024/3/29 10:12, Duan, Zhenzhong wrote:
> 
> 
>> -----Original Message-----
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Subject: [PATCH v2 0/2] Two enhancements to
>> iommu_at[de]tach_device_pasid()
>>
>> There are minor mistakes in the iommu set_dev_pasid() and
>> remove_dev_pasid()
>> paths. The set_dev_pasid() path updates the group->pasid_array first, and
>> then call into remove_dev_pasid() in error handling when there are devices
>> within the group that failed to set_dev_pasid.
> 
> Not related to this patch, just curious in which cases some of the devices
> In same group failed to set_dev_pasid while others succeed?
There are multiple failure reasons. Given to the fact of some devices have 
already succeeded, the most typical error may be no memory. Not sure about
other reasons.

Regards,
Yi Liu

> Thanks
> Zhenzhong
> 
>> The remove_dev_pasid()
>> callbacks of the underlying iommu drivers get the domain for pasid from the
>> group->pasid_array. So the remove_dev_pasid() callback may get a wrong
>> domain
>> in the set_dev_pasid() path. [1] Even if the group is singleton, the existing
>> code logic would have unnecessary warnings in the error handling of the
>> set_dev_pasid() path. e.g. intel iommu driver.
>>
>> The above issue can be fixed by improving the error handling in the
>> set_dev_pasid() path. Also, this reminds that it is not reliable for the
>> underlying iommu driver callback to get the domain from group-
>>> pasid_array.
>> So, the second patch of this series passes the domain to remove_dev_pasid
>> op.
>>
>> [1] https://lore.kernel.org/linux-
>> iommu/20240320123803.GD159172@nvidia.com/
>>
>> Change log:
>>
>> v2:
>> - Make clear that the patch 1/2 of v1 does not fix the problem (Kevin)
>> - Swap the order of patch 1/2 and 2/2 of v1. In this new series, patch 1/2
>>    fixes the real issue, patch 2/2 is to avoid potential issue in the future.
>>
>> v1: https://lore.kernel.org/linux-iommu/20240327125433.248946-1-
>> yi.l.liu@intel.com/
>>
>> Regards,
>> 	Yi Liu
>>
>> Yi Liu (2):
>>   iommu: Undo pasid attachment only for the devices that have succeeded
>>   iommu: Pass domain to remove_dev_pasid() op
>>
>> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++-----
>> drivers/iommu/intel/iommu.c                 | 11 +++-----
>> drivers/iommu/iommu.c                       | 28 ++++++++++++++-------
>> include/linux/iommu.h                       |  3 ++-
>> 4 files changed, 26 insertions(+), 25 deletions(-)
>>
>> --
>> 2.34.1
> 

-- 
Regards,
Yi Liu

