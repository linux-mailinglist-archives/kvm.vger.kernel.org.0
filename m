Return-Path: <kvm+bounces-16226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE3E8B6DFE
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 11:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 920812844E7
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 09:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A10F128362;
	Tue, 30 Apr 2024 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGhIRGHB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA97D127B68
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 09:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714468572; cv=fail; b=k40/fBXiUqnu3lvGlNpiFNaprhlVA2jesSagPOFDwWn/pN9vkKOxmlp6xni6BxEd6ELKDRySxQig1utbNgn4nCZOVBQrPObN1x3F5WpyWUAwritLn++iOD66w4GT/lRafqXW9QpsQTX2AvF7eijNzXciCZMFaoakS9vXhFYGSUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714468572; c=relaxed/simple;
	bh=PrTEIqms+yG524cCw6CvM6Hdm1QLBrlGqNO0AcKagdk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s+6qSnOUBIpg4Sr1L/TMV/P2eeFjko7jn8NLmt0jrSUE4INF3H3ECoywOdTY2G/0K/YTaWwA6zVzYqL7QgbU2MVLnZGs4Gg+f2HOW0NvN715i1IAHhwT/PlWRQ1ROpF7w8Zq4Ra4b1fNFpReCwnbjzguRL65sRCgC9QhXhbmUoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGhIRGHB; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714468571; x=1746004571;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PrTEIqms+yG524cCw6CvM6Hdm1QLBrlGqNO0AcKagdk=;
  b=fGhIRGHB93L6I/xfa1ViW/4h18/Zjrt5myrU0ZuSmD5WuFmVCNpGeyoz
   vEAgYu8UmUer1c9Wy30gOjHveKG8Qt4Bs7UmG8NUon3oNbKEas5qjyOHX
   cwxCmiyk9ikWZbrcOt5LONH/e70FgotvNkSUVUwrKbrmGbWeE7qVy4R/9
   qql4uJb9qXMQlFjmcpCtZfmRastjMNTAf/E6Mj3pyKh2CWgrTqqBuuIXI
   YkLj3l4luvbwj0WcQFWPOc0aRHbWCrZgW3xl32E/QUFuEgHTnQQJZhz0K
   E0LeLKfhMksq1ByiHQLm9/u6bUla9b8EB7guiARsLAcvekLjmDwGjcmuw
   w==;
X-CSE-ConnectionGUID: gDDwkzH8Tz2KnoRPQJc3lg==
X-CSE-MsgGUID: Qhx5Bj7NT56LdY+mvgAV9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10702897"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="10702897"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 02:16:10 -0700
X-CSE-ConnectionGUID: foCpNHyGTAaDTF+jQTC1Iw==
X-CSE-MsgGUID: yaXPmyjwSKGxzPXBH7qmXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="26503556"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Apr 2024 02:16:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Apr 2024 02:16:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Apr 2024 02:16:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Apr 2024 02:16:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hh2rPvgsR85fC/otVhAoyLiZ6kxpEmQI1StKAzUMp5HG+VJKv5ztFbmKJCkUMSDlIXQsbcBEV6ZX8MkpesIosVYS4TfgbZ6CKE+EKiLvY9I7rcGP3d/wIl3RIViuDC2+qGyaWk4k/2PTJUibJsDKtYjYCwW+xt75mA5ZFn2Cj9ykG++9+bxXYWSGkPbmIQdHVfH6Gl+LqIUF8YPWEJHJTE3W+GqJMcLF+KEer4SeKtlpc56+MP5oX8uUDDFYjYW1wsWbkr90jMo6rRYb85pUYfemrepdC7u91DaTPkGbwSAFN6St6S71si030gnDeSoo6iJ5YUaiumYNO7y8Qq8NxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdsogOOjTLiVEuP+2DwUIDNJbx0a6zA9U72qOgk6Hco=;
 b=RTRyaEnIQuybRLu1/b8VHNWnJ/kVmlK5lhDWeiJq4qXVzKDTqI+VfWmz/Q5PzLjbUv/VsFMSaXn5rTNaLKzFm5QuwVTKBji/kGaERFjZI0vSFvkV2NZUwPvplTAAhGVaeiDGiTDlefeE7nBqQnK52NpVwGNA7/klMpIYda6prkcMEC2MRWldmUvBxj2AXI2iJfXu8CCgLBw9PwABy9/AtFBnLkFXqtNb965u9gBMCvOMFIGGkYbxPq87iT6EpZW+Px1+KIdPGrZi1FJWCwWaDR0ujoyN7dyG2Ttfm5Sl0LVECFeRXMZEyJZAyeditYI8wUb8uBGuHYshFflKizta2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 09:16:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 09:16:07 +0000
Message-ID: <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
Date: Tue, 30 Apr 2024 17:19:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
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
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:54::24) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN6PR11MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e59dff-bbc7-4d9a-af69-08dc68f62abb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d1RMa1hXTVdJaGdwem9YbmhnRS9ENm9HQSs3dzc4aUlRMXpZaVorZ0k3VHdw?=
 =?utf-8?B?bk91R1RYLyt0aWltUGwrT0RvR3Vpam9BbUswOStCbjI1ZmVTNmRUbGFxN1ln?=
 =?utf-8?B?QXFTL0U0NTlGZ25KMU5XNlFpL0xFalNPZWpmbjErWm4yNUphL3JpYitnNVNw?=
 =?utf-8?B?NEI1WFJ1VWpCN3g0TWMxRTZNTjlNaHFhb0RtYWpzTjlmRFd5ZDlRRmhGckUw?=
 =?utf-8?B?MHhsSkZoWW1Hczl0WHNXSXJZVnFXR243MlpubjJlWGU3NWlrZ3lUS2ZyYTdR?=
 =?utf-8?B?NkFYcmVGTWJ6UDhVamNvOFZUUFZITjdxb3JLRVhZcG9SZjltT3dXcTh0K0U5?=
 =?utf-8?B?bEFMYnd6bHVmdGExdVZkMkgxZFRNMTV5eGJpYUJFOEhnTUtUMFZlTnFubUdr?=
 =?utf-8?B?QnRaT3h2Z09laFNPekd3TVpKRWNqaHZ1QVFTenhIdjYzZEFvQzB6QkEycC80?=
 =?utf-8?B?c2tsbkx1MXdZa0NrZ2YxZ1RlMiswNmlRSlVOUXpveTJIQThlVHdhbzU3TEx2?=
 =?utf-8?B?R21aSnlDVTA5ak1YckRpdW1jNXp2YjlCcFJRYUhsUDdRU1lTc0Q1aVRMZGhT?=
 =?utf-8?B?MUpPUmF1NGljbWtCeDc1K2JiZG5KZUsxZkIzUHJ3NUlMbUZtZUJGVlZFcTJD?=
 =?utf-8?B?Y3dTakkwNDltTlZ4bUxWam0vc0tKME5mcVU5SkI5NHVLY0VjTXloRzZFblNM?=
 =?utf-8?B?R0QrSElCa3VzWGgzNzdxdm9yQzQxc2l4WDBoVkkwN3ZPbXk0aEhzWHVZZ28r?=
 =?utf-8?B?aEdhRGNTWlUrUEpzenhFcTNvdWpoaDhuWlRSMzgzVVVyajRQaEZ4K3RzaStK?=
 =?utf-8?B?V1FzTWxiTjFFaWpycGM3YmxuVGNyK3F4d2FrQnAwOENtZDh6L0lYa0pRSEg2?=
 =?utf-8?B?MnhsWUpXOERpazZQdEpoL0NkU0RjM3pONDRBTmUvOWV0Z2NkUUQ3MlBFYVox?=
 =?utf-8?B?dUdBbXFCanZ3WGVLQ2RzNjlTMzFBUUlxaVRZb3JBTDdpVmZHZ2dXbW5oYXA3?=
 =?utf-8?B?blI5N2laek1qL3dIa2tnUnMzcjI2S1RMamlsem1BSzdIVWpsc2Y1bWdZZTJn?=
 =?utf-8?B?WURyb0ZmRjlqaldBVXFzcUpVMERRSzFwVXpaQlMxRTVmcENhR1VvUHU5a2JI?=
 =?utf-8?B?S2ZIT2tldXZlQXIwQUU2QXFLRjl4cEdBMkZPaDBZTHFOQ1JZNGdqVFpUc0I4?=
 =?utf-8?B?QkFJZndJNlI2akF4ZjA2YWp6MWxtNUZGZ2hhM1RQRUU3ZFlUZE92N2M4T1FN?=
 =?utf-8?B?NzVMV2lXczA4cXI1djFnMUo3eGVuS3RQOWpocXkvRzc4SzladlFhUkxPY0xH?=
 =?utf-8?B?bDdWWC84bG10cHN5TEUwSUNvbDdkUWxwK2dvVU9vNkFGREkvNnhRQkN6aFBr?=
 =?utf-8?B?clZBb0xBd3dvWG5kL1MrQ0NmNTNBZjNSbUNuR2hTbGJsWGxzMWNGeUpwZ0Iz?=
 =?utf-8?B?eTM5cEZnWU1lL05JMU5NY21iTUJFVzRTTE5uR0pLZDVtT1JtSWpab0taY0Rv?=
 =?utf-8?B?VC82c1F2ZDFJbzFjaXl2UzhjQVZRWkluNVdwRWxjTjlyNTMxQTh0aUtNeXg0?=
 =?utf-8?B?Z2FLYVk1UmFrakE1TXdTdThNc2VXaFUrTHZET0k4ZHFoaVpsRFllUDhyUDVV?=
 =?utf-8?B?NlB1SGRBcGpHMUpEMUNva1ZWeU53QjhYcU11RGttVS9oNmJaTkNRS0R0dWFR?=
 =?utf-8?B?Qm5hcHNRQXcyTTlLZWowSzhWKzVtWEJmZlVTbXMzMGJqb2ROVXVLdHNBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHFMazlQUS8vQzNmMG5FbXQ1dHdObkJSKzZzNFV4R1k1VDMrWWxYV1RwWlF3?=
 =?utf-8?B?MlJEaWF4RUdLazRadzBUSkE5aFYvdUJ1VVFmanNUaFRPTVB1aEw3amZqSURk?=
 =?utf-8?B?bVV4MzlYNC9kTkxrSGtwb2d1NDhocWJ4UzA3SGNLRFNvWElORzVxYko0Z2ww?=
 =?utf-8?B?RFhQQjF2SHRPSDdRL3VIdHBwMlZmRXNlYWY3cmpuQXU4Y3hUaXFNY094bGVt?=
 =?utf-8?B?YzFONzExUEpUdFE1QTdSTng5YXkzYzE3MDBDSHk0blF5WjRrK2ZlSElQRDYv?=
 =?utf-8?B?Yk14MEwxZmJ0ang4Vyt6YlZPT0taRHZKdkcxK0VTS0RxbnBsMTNKY2VtQUlP?=
 =?utf-8?B?MXhuYitTdzJhM0MvM0swY0FsUTFoOGxZQ1cwdWNveEVjczZzT3I4OEtMQjNT?=
 =?utf-8?B?d093NVpJWHU1LzVOSFJPMml3RFlRblFvbXRlWURzbXZBOS92STVUOFVUZVlr?=
 =?utf-8?B?eEw0dVUwVjhqR0NyaTNZaTgxVk9yQitLMHJJeWRBYXhDNjQ5bVFLSHVjTStG?=
 =?utf-8?B?ZkNqdGcvWlN4VEFDLzlNQ0p6c0pzSFkrVi9oZGVRTzlkZXdPcEdTN20wOEpu?=
 =?utf-8?B?dlJZWmdDQmNWQ2drV1JiV1c0QlBJWU1Fd01CYSs2blI4bzRpUjVkUDlGOE9t?=
 =?utf-8?B?bjYxMUpmd1krN2ZGWTNKbkNIU1RVOU1YR0FlSDBIOWN5dHRuU29ST0svOWtX?=
 =?utf-8?B?MFFFWW5JdVlYT1ZVS2hQeUw2ZUNBUjZHdldVbFNkbUJlZUJTaDNhbHlnaU5U?=
 =?utf-8?B?Z2NzU25MaVhUMkdFQU5KWDRiOWtXV1hnVUs1MUZBc2RxKy9sRUs5dTg2bTNI?=
 =?utf-8?B?WmpFck9zVGpCYTZHRjhacWQ0UXU3RjhPRGZ5WFpheUlwZDFGK29ZOFBkZk81?=
 =?utf-8?B?dVl2TnJxYTJaQVRzYzBWQzlhN3JHM2VYMThSTVhRYmhnZjh4WW83WHhFckpH?=
 =?utf-8?B?MHVQVVJNV0VnODA1WkNDNDVDS0Z1dXhuSXdRbWFrWTJVWHpLQjhOM2U2OS9B?=
 =?utf-8?B?bkdYN2xGdHdGNDc5MG9HRHFlZEVHUjNZRTdJKzYzNGFkZ294dnFHZFhBcHAy?=
 =?utf-8?B?ZTdNNDZOSkFlakNsRjJTenVMU0dyMHdhdEt3K1lGejJjMzNEWEhDTHk5dndL?=
 =?utf-8?B?a3haRkJRQkhid08zZmI2aGlGN1hPU0hVUHZPQzJTV3dob3Mzd0N1Q2JqdG00?=
 =?utf-8?B?VlViQVo4cHBlVjdUajFOeDFWa01zS0MvVmtWS3V2cnV1Ym1EdlliVXZGQVc2?=
 =?utf-8?B?TXFMZ2JVRlg4alhXVzVVYlNXUkRic2ZUWkltMmtMTGtJeDNNWUliSStxRlhJ?=
 =?utf-8?B?L3R1WmNzOU1PMXlZNElzMUlxR3gvSldjSG9abktZcSt0ZlRrNEdNQnBycWVX?=
 =?utf-8?B?c20yNXM0b005VEJzMTJOaitFdFQwRUJTam5FeDVKMWZoUFlEcDdhRjJmM1Rv?=
 =?utf-8?B?TWNkNnRTaEtvOGlvc3BNajlJZUlaVW5OM1RGem1KQmJPVGNKYnpzM0QyLzhT?=
 =?utf-8?B?TjV1Mjd1QmVsMkpJZVlKU2ZDbWR2T0l6U0JqL0hINEs5dHVFWXlQUW9qc2hu?=
 =?utf-8?B?QStDUFRLOFp4RTlSL0p6TityMWo5VDduOTlUMHVFcytnQWVKRVAyanYvUlFw?=
 =?utf-8?B?bVdaTEI5NEhXYkpwZ3dIODhDOUQ0Nk9IMHRDN0pvRFFOSFlLTU0waVNHY2pB?=
 =?utf-8?B?ZDRzYThGWnVrU1ZvQVFkandlSkdkQkxHM3RjYVZSakRWeHY5T0Vremh1aTEx?=
 =?utf-8?B?UUlLeWEybnFlbWtKWmhXNWd4b2JsZ3ZXeVp3TkRTMUppd0YzZThKWjBydWlJ?=
 =?utf-8?B?Y3M5NHh2cEFtNC9YTk4wazM5SGtRcHk2Tm80bEkyV3hIMGFuRHVPd0ExQzRz?=
 =?utf-8?B?c0tVWUt3YkV1clpUdkg1R2trOFM2eHB6VGN2VU9NalgyZHFhSUhNQW1tYlV3?=
 =?utf-8?B?L0QrNkVrMFRXTmtzYTBmVHJhQ0hObVdGUmxuQWZjRUFWTkNYK2pJejlUNHI3?=
 =?utf-8?B?RmZlcGVzU0VmR1B4UWsyVzBpMTkvMFdWMUR6Z3g4alpBNjhmaW44ZDVsa3NP?=
 =?utf-8?B?NCsyMmZZVXZUc2tvbkhVUW81UHRqRExpeU5Rd2J3SnhCdWpTS1FxNVhnYWwx?=
 =?utf-8?Q?RG/Izj3Qx4NAMYIedlj+e3cYy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e59dff-bbc7-4d9a-af69-08dc68f62abb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 09:16:07.1321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9UJjDa8+mnmivZnZ0pAosiDR9s244UnJNeOtePyLDG//4ObBbZRm2QY0lZxa9wXJ7/iHI2L1IBJ/w6UQSvIYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com

On 2024/4/17 17:25, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, April 12, 2024 4:15 PM
>>
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> This allows the upper layers to set a nested type domain to a PASID of a
>> device if the PASID feature is supported by the IOMMU hardware.
>>
>> The set_dev_pasid callback for non-nested domain has already be there, so
>> this only needs to add it for nested domains. Note that the S2 domain with
>> dirty tracking capability is not supported yet as no user for now.
> 
> S2 domain does support dirty tracking. Do you mean the specific
> check in intel_iommu_set_dev_pasid() i.e. pasid-granular dirty
> tracking is not supported yet?

yes. We may remove this check when real usage comes. e.g. SIOV.

>> +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
>> +				      struct device *dev, ioasid_t pasid,
>> +				      struct iommu_domain *old)
>> +{
>> +	struct device_domain_info *info = dev_iommu_priv_get(dev);
>> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +	struct intel_iommu *iommu = info->iommu;
>> +
>> +	if (iommu->agaw < dmar_domain->s2_domain->agaw)
>> +		return -EINVAL;
>> +
> 
> this check is covered by prepare_domain_attach_device() already.

This was added to avoid modifying the s2_domain's agaw. I'm fine to remove
it personally as the existing attach path also needs to update domain's
agaw per device attachment. @Baolu, how about your opinion?

-- 
Regards,
Yi Liu

