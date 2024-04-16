Return-Path: <kvm+bounces-14747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E9E8A66D0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E45541F22B9D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E7084A5F;
	Tue, 16 Apr 2024 09:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ayRft/HR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F343BBEC
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713258906; cv=fail; b=ZJ+aLs/3Vj3PXEv26v1ibjcGMEn92fz2nYCYMOhoWcjJy16zpeapoa1t8PgVoHwSoioB97GvaXpf7mxtegZFhfe7mEyH29RkXmFjM39PIpNZhPm73HiaQSENG3Ml/K3fPjk4JnghojsEDRedHx7DDTCFBcpovrIKwFKRSaPDDck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713258906; c=relaxed/simple;
	bh=63lfSpH3QLeVUGxa+Np2NpAcEmSilStjlmuNzEEjCLE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E7NMnD1CSuGmlPv1x2bR16dNo9q3sc8hHbVE4cJQWnChypk76OmpX3jZCsTSXdF3JaPjzrCoeYJ716Ta3uxVWESMn9DWIYcjxugzQEa3UbsgsxfPIZCLhH0Gz7CLKkSDoNFbnvoiQ17evEGhjjJMPTsPao0/qcjla+WSSICuUlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ayRft/HR; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713258905; x=1744794905;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=63lfSpH3QLeVUGxa+Np2NpAcEmSilStjlmuNzEEjCLE=;
  b=ayRft/HRgazTa1ME9A3enzTWeRPcT3WKRGcn9azCexupAcQrFvNs6h6X
   oHquI/gmjHD59MQmdrj0elsEzu0U+rrY+zTNFl/q8sWMTDRNX78OdN6Yv
   cezAWqEYRye0MoZVKn/Ryg5GiPAnSVEN2c05HfvY+x/18QjqllAQnj2kl
   viATdd3VeupqD0+m8J9I8US5qQ2OrdbCDROTkgrKERwc7yRv5SntGogLI
   OtoW+M8gkvNFjFuOF8SzbAbpmZQG/ZY+Qt3YPd+EbXzJewsuTsvvZ89sM
   kS6xj4MgJaX3mqfqFqXx3ZFGIBhW4gDusLvFsYF7O8Pgz0kGP5P9CRfNY
   w==;
X-CSE-ConnectionGUID: fb+P5kdiTGCPGajmh59opg==
X-CSE-MsgGUID: kCxN1YWpQGmjXtPYdkJEWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8848997"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8848997"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:15:04 -0700
X-CSE-ConnectionGUID: gCZxgRIpTeSPiVmll+P91A==
X-CSE-MsgGUID: gfwQ9fN6RNWJazRzMz05hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26993101"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:15:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:15:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:15:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:15:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iT7+O7x4QJ4LZgu88JTGejUCnGADjKSpQdMnSrJgtNkHT/Uf86hspf5R/JCPkeL3wkJXC/AYakXR7KtsKyoKJ0B/OIrMBKNErD3AYPaKWEBgQv6EDKcPUWLsExSxksFHaIVE+NM56CiwOVvDfs03UkkoEDEl6odE/4DYNxMdzgrTD0rAuYqVABP1dnSPiYXO6PPIxMMccadfSwo/0Ozvt4W8fTZrNvsNibf372NTSKPCn4dFqkNsFIU/qXk6EF518TEgYTQ3WDwyiOis31YzCuSGAf6OHOp0cOUByVkNWLju/y1WZNrXmgxsE/dPB/BVM10DZILcFKzNgRlYY29IdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kr7ObjC/bMCCwotOgUkNwXm3aYCO8OQEVxv4EcEYFV4=;
 b=ceu3rIKIv/F53tfUYItmWA8F+AXaf4gDhs1tPSffbh7nOGw11a8HwyW2Jp00ajQ9j5+wt6uAz01c4f61oY1K0TB8w2x00pIInqZ4U5maJJ3FmIqOVDPafwx2/NuIcnzqfkKJ8cIl1PVOJPx50FemSy7/5dFVDZdE8SExSLy2duSt80PtyLta2h5Fu4ESXE7rPiv2omp+4lY/q1XuC0ESTaX2XlJcpg2ByRN7YwQtZm0jZc/IOY4hfSBOnTwKf7r0VDejYLf6dKgHgRLi6Nn/cMdpJkjgYLmX7xc9jU0au6iTPfJHxe6ktmqWcf7BvgondoTQiiFiABzzpkqX7DYc5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.43; Tue, 16 Apr
 2024 09:15:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Tue, 16 Apr 2024
 09:15:01 +0000
Message-ID: <ef826a64-6157-4dbe-9bb3-019bc1711304@intel.com>
Date: Tue, 16 Apr 2024 17:18:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
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
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
 <SJ0PR11MB6744EE4A01AE1FA71DDDB1C792082@SJ0PR11MB6744.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <SJ0PR11MB6744EE4A01AE1FA71DDDB1C792082@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0044.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL3PR11MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: 05bfd53f-f2ab-4a89-34d1-08dc5df5b197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2aet67wLN6ufG2VTuQJHKVcrXJ6oI3Vx52jRw2xhO3Mtd3dD8jKDDkbgx6/RSIwqA0A01lJp3MwdrK/QK34m24kUT0cFP5qOuJEEjeXhUukYk3rbutwSl8U/JP11zZ0SjCulDhMy6fQWAo6bPyRlBYbRCt0IBAxHKUVNoGQ16N7KQpzoIAsozOpAsZGAEQOXq4rzj22Us/R/OEzlIz2u2qbQEB+Maw3SusrD/RBlqA32BtRjppb3PziLF+iELtR5br82nvT4AucJE9CDiPajQ/fyhy6WYNGSOYXcHaI9YszpCajXCd07EbL9sTy+kul6X03X7WGEdKFbVN0drOqc50lVwoxjSG3fKBo48f8N7MKBlyQuOMRarLbpHvzdvt9TvXK6TlAJsCvFowqNPxby4f76tFV9tdo6vi3KnIUa+bFb+vR3BgV84EpewhcoGdsqD012fMIc6ZQzT6X65uLz1q0+yPP22X2aF+J9NpJkiYQlEwn1twKG0lFkTlQGVZcRrX+j4ue7vmbdADQw/4YMZ3nFoqqObQOTdWYuaW995ZXE5gH0QqcXXHtoDCG6oQnuw6LBy0KCrZauw42MtsizXFKTqEMi58S83xaooJmL/kqDeMhuLwJr1G6hK79iy2d4Hw9DvxfqVgKu34vQXyHLDnGVkeoiEB9yVFXZWefvqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2tmbjcxdkYvRVVhZkYvSkF4cWlRZHVnaEExeG9HRlB0d05pRnFrcjFLaG1i?=
 =?utf-8?B?QlNUOVRUd3ZKREZNc2FVSEZqeVBUN2t5a3kzcktnQmFEWE90b3dLZFRXUUp2?=
 =?utf-8?B?VGY4USt5c2JRdGRHZWFwOEVuUnN4eldDUTJSTFhhWUttN2RQbWpSeWMyY3BT?=
 =?utf-8?B?K3k5QUU5a1BORENTUHJPOFFncWpWOVdveDJZSlZjdk1uLzlLNGQvWmJGVWQr?=
 =?utf-8?B?WFJrNDBpN0tSSTFYUG14Q25VNk9rK3pKdEpYUUcxbTFyeHAvSlNzVnJORHMy?=
 =?utf-8?B?TGFRYlY1dmR5K1dJQmFYdGlOaVRwbDRpTGkwTUR2ZUdoenEwVm1BK04waDBP?=
 =?utf-8?B?R3ZqOGllYnRIL0tXdStTK2ljUjRjakpLd2VURVl6cC9sU1ozbGFzQlIyQUpy?=
 =?utf-8?B?UDRZYVo2dmhsZzZQMEhDZ01ETytUTk1PYUUvdjhWMFBaQWpHYWFGNTY0d2JM?=
 =?utf-8?B?SG5ETFZyd0t2VWpkWDFlS3ZJMXVxSlVTZmpKOFIxZmtkTHE4RnhsbHZBSFFX?=
 =?utf-8?B?NVZyMFA5UUMvcUVsUVFTeFVBM1BZVHlPTnk3bFJLL3J2SjRFSURwWUV6NkpP?=
 =?utf-8?B?TnJKL1dNZjA4a0V4VmVrcWpCR1FITVZEVjBZR29OWC9qNTRZZkNOUklMd0xQ?=
 =?utf-8?B?U1FOb3NwcmNZOHB0Q0g3Mkw4eTBQTkRuWDgxVTNKMUNDK05rV2tlU3VISlB2?=
 =?utf-8?B?dDZDZFpjSDJ6Vk1OdEYyeVZrbWdBaTJCYk4xVHNBTlUrR3dSamJiNS8wc0Iy?=
 =?utf-8?B?TEdLQmNsNkNCLzk4aFlLM2RqTnQwTkhXTFQ1dVQ3RWFyTDZkU1ppVmp0UnE0?=
 =?utf-8?B?UmluOFZGQlMyaVhGYmIzVGVNb3JQVjU2dmNwdEhuOHZXdW8rcEM3VlliRzBN?=
 =?utf-8?B?UmxmSDdRa1Y3RklBbkJ2K0VEeTVDSklqaUk5OEJBbXR5WW4yUTdMT29pLzR2?=
 =?utf-8?B?TVlmSzV5aG9OMkpMZDhrK3lVWFpmek9ZNGIrUGpxV1R6VzdoaFFmcUN3V3RU?=
 =?utf-8?B?S2swZERuS3hDb0pXeHRtQndacUlYc1J5cVhVL1NxN0oxSXRmb0h2dEJoK2FB?=
 =?utf-8?B?a2dSeGt6WTMwajg2VURJRXV2TzVrd1ErZWZ2RlQwYkwydy9iZkZ1bFgzTGFK?=
 =?utf-8?B?Vzc4Qmd1NFBPVEJOMVdVMlA2bUF6THJDNXBOTzBVdVBQQlRYOXpTSEs1M2Mr?=
 =?utf-8?B?QUdKUDk2VHNUeXZoQURLbWpNY1gvb0Voa2dCTnNiQU1yS2R2ZG5aZTZ5SFdU?=
 =?utf-8?B?dWpIdVJEY2NDdC9OUktKUk9WTGx0OERqbUY3MjBES2tadm5IalFVZmdhbmxj?=
 =?utf-8?B?RDdCbzgxTkNkUDJBWkYrQ3lCYlV1YzZKMUNKN0VPVFFVMlM5WXdSKzc3Wm9X?=
 =?utf-8?B?a3pabUw2ajhkcWpWUmVrS0hsRUdxc1ZNTEF1VFFCK0s1ZHVveVo0TDNsVjdD?=
 =?utf-8?B?L3IzajZ2cit0cktyVFdEVE1QbUpUZy9OK1dtbml2MVRNaGVvZ1FpOFNqWi9R?=
 =?utf-8?B?VHpVclVGSVFpVnpWamZUOVBlMzRieGhLNkx0enpVcmp6WFZGM2pFMmZtckQz?=
 =?utf-8?B?aUUzNnBEeGpHTGxCdWZSWGExc3hzWkNtVjVJSERzUEk0VGd1eURxWmVTWStL?=
 =?utf-8?B?SHV5ei9yZm9nVHJZNGR0WElZU3FUa0J1Q2JnK1hSLzdrQmhQelhJTjJFVWZO?=
 =?utf-8?B?aVRUL0JNU3kvRDc5RndTeWxLNmJiNmxTeTN1RVNhRUFFR3lxWHFYWVJtanox?=
 =?utf-8?B?QWdxQ1JEeS9zN0w3TDE1TStKSnVhZE5vSks2RVZBRkExS0trUEs5UU04cVBo?=
 =?utf-8?B?eXNBUENDT0Z6NU5GZlpidTJ1dUFYdlFVRkhucmZ4RXA3a1NFZ1ZqL05MZUMy?=
 =?utf-8?B?cnlsaXVKNHdlQU1vTUhscTRvUnI4WmZXVFg0bSsrR0NlemdQWFZFTHBkQjBx?=
 =?utf-8?B?NTBHL2dXQzJjSi9kMHlEOEMxNktUZzliZjVDRDhFdW9RcjZCRzZrcThDNWRi?=
 =?utf-8?B?T21scWQrZW1DWU00aVI4SzBzNC9Sek5FU2l6VnE4eml2amVNN2crOFZpbTFB?=
 =?utf-8?B?RUpHbVQ4aWtWM1dqTXVJZlpHTllqZ2FRVzM3R2J5U0NUY2dMU3ZqM01WbzJM?=
 =?utf-8?Q?RKdcH0cDg2yMb10gdaKopCji7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bfd53f-f2ab-4a89-34d1-08dc5df5b197
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 09:15:01.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJVbwNC5N1uwikuLcuGu4LklTlkdsjSiCTv8pXGDlCojvF/LS6rEB7Q9HO+AlbPiyl6wNhTK2pYSehUchaVzaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com



On 2024/4/16 11:01, Duan, Zhenzhong wrote:
> 
> 
>> -----Original Message-----
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Subject: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
>>
>> Provide a high-level API to allow replacements of one domain with
>> another for specific pasid of a device. This is similar to
>> iommu_group_replace_domain() and it is expected to be used only by
>> IOMMUFD.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>> drivers/iommu/iommu-priv.h |  3 ++
>> drivers/iommu/iommu.c      | 92
>> +++++++++++++++++++++++++++++++++++---
>> 2 files changed, 89 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
>> index 5f731d994803..0949c02cee93 100644
>> --- a/drivers/iommu/iommu-priv.h
>> +++ b/drivers/iommu/iommu-priv.h
>> @@ -20,6 +20,9 @@ static inline const struct iommu_ops
>> *dev_iommu_ops(struct device *dev)
>> int iommu_group_replace_domain(struct iommu_group *group,
>> 			       struct iommu_domain *new_domain);
>>
>> +int iommu_replace_device_pasid(struct iommu_domain *domain,
>> +			       struct device *dev, ioasid_t pasid);
>> +
>> int iommu_device_register_bus(struct iommu_device *iommu,
>> 			      const struct iommu_ops *ops,
>> 			      const struct bus_type *bus,
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 701b02a118db..343683e646e0 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3315,14 +3315,15 @@ bool
>> iommu_group_dma_owner_claimed(struct iommu_group *group)
>> EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
>>
>> static int __iommu_set_group_pasid(struct iommu_domain *domain,
>> -				   struct iommu_group *group, ioasid_t pasid)
>> +				   struct iommu_group *group, ioasid_t pasid,
>> +				   struct iommu_domain *old)
>> {
>> 	struct group_device *device, *last_gdev;
>> 	int ret;
>>
>> 	for_each_group_device(group, device) {
>> 		ret = domain->ops->set_dev_pasid(domain, device->dev,
>> -						 pasid, NULL);
>> +						 pasid, old);
>> 		if (ret)
>> 			goto err_revert;
>> 	}
>> @@ -3332,11 +3333,34 @@ static int __iommu_set_group_pasid(struct
>> iommu_domain *domain,
>> err_revert:
>> 	last_gdev = device;
>> 	for_each_group_device(group, device) {
>> -		const struct iommu_ops *ops = dev_iommu_ops(device-
>>> dev);
>> +		/*
>> +		 * If no old domain, just undo all the devices/pasid that
>> +		 * have attached to the new domain.
>> +		 */
>> +		if (!old) {
>> +			const struct iommu_ops *ops =
>> +						dev_iommu_ops(device->dev);
>> +
>> +			if (device == last_gdev)
> 
> Maybe this check can be moved to beginning of the for loop,
> 
>> +				break;
>> +			ops = dev_iommu_ops(device->dev);
>> +			ops->remove_dev_pasid(device->dev, pasid, domain);
>> +			continue;
>> +		}
>>
>> -		if (device == last_gdev)
>> +		/*
>> +		 * Rollback the devices/pasid that have attached to the new
>> +		 * domain. And it is a driver bug to fail attaching with a
>> +		 * previously good domain.
>> +		 */
>> +		if (device == last_gdev) {
> 
> then this check can be removed.
> 
>> +			WARN_ON(old->ops->set_dev_pasid(old, device-
>>> dev,
>> +							pasid, NULL));
> 
> Is this call necessary? last_gdev is the first device failed.


It is since we claim replacement failure would leave the pasid to be
attached with the prior attached domain. That's why old is checked
in the above. If no old domain, it would exit the loop if it is the
first failed device. Nothing need to be done for the failed device.

> Thanks
> Zhenzhong
> 
>> 			break;
>> -		ops->remove_dev_pasid(device->dev, pasid, domain);
>> +		}
>> +
>> +		WARN_ON(old->ops->set_dev_pasid(old, device->dev,
>> +						pasid, domain));
>> 	}
>> 	return ret;
>> }
>> @@ -3395,7 +3419,7 @@ int iommu_attach_device_pasid(struct
>> iommu_domain *domain,
>> 		goto out_unlock;
>> 	}
>>
>> -	ret = __iommu_set_group_pasid(domain, group, pasid);
>> +	ret = __iommu_set_group_pasid(domain, group, pasid, NULL);
>> 	if (ret)
>> 		xa_erase(&group->pasid_array, pasid);
>> out_unlock:
>> @@ -3404,6 +3428,62 @@ int iommu_attach_device_pasid(struct
>> iommu_domain *domain,
>> }
>> EXPORT_SYMBOL_GPL(iommu_attach_device_pasid);
>>
>> +/**
>> + * iommu_replace_device_pasid - replace the domain that a pasid is
>> attached to
>> + * @domain: new IOMMU domain to replace with
>> + * @dev: the physical device
>> + * @pasid: pasid that will be attached to the new domain
>> + *
>> + * This API allows the pasid to switch domains. Return 0 on success, or an
>> + * error. The pasid will roll back to use the old domain if failure. The
>> + * caller could call iommu_detach_device_pasid() before free the old
>> domain
>> + * in order to avoid use-after-free case.
>> + */
>> +int iommu_replace_device_pasid(struct iommu_domain *domain,
>> +			       struct device *dev, ioasid_t pasid)
>> +{
>> +	/* Caller must be a probed driver on dev */
>> +	struct iommu_group *group = dev->iommu_group;
>> +	void *curr;
>> +	int ret;
>> +
>> +	if (!domain)
>> +		return -EINVAL;
>> +
>> +	if (!domain->ops->set_dev_pasid)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (!group)
>> +		return -ENODEV;
>> +
>> +	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain-
>>> owner)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&group->mutex);
>> +	curr = xa_store(&group->pasid_array, pasid, domain, GFP_KERNEL);
>> +	if (!curr) {
>> +		xa_erase(&group->pasid_array, pasid);
>> +		ret = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	ret = xa_err(curr);
>> +	if (ret)
>> +		goto out_unlock;
>> +
>> +	if (curr == domain)
>> +		goto out_unlock;
>> +
>> +	ret = __iommu_set_group_pasid(domain, group, pasid, curr);
>> +	if (ret)
>> +		WARN_ON(xa_err(xa_store(&group->pasid_array, pasid,
>> +					curr, GFP_KERNEL)));
>> +out_unlock:
>> +	mutex_unlock(&group->mutex);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_NS_GPL(iommu_replace_device_pasid,
>> IOMMUFD_INTERNAL);
>> +
>> /*
>>   * iommu_detach_device_pasid() - Detach the domain from pasid of device
>>   * @domain: the iommu domain.
>> --
>> 2.34.1
> 

-- 
Regards,
Yi Liu

