Return-Path: <kvm+bounces-29916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 127979B409F
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 484A328337F
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 02:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55F91EBA14;
	Tue, 29 Oct 2024 02:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HMdaHz9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3F8192B62
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 02:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730170093; cv=fail; b=bQEnCEKABgCcRo1noQslOmFSa/kFWxmPM+vHHYmMetTlD+Op3KptJQFevIWLHgrSmbU0SjNflDSXnwvArcWTLErBHs8/LtNux0IVQyD59Az0YMdgxVUD7Y1BP8ChMgLuvnGhdUr+FTChH7CVZx+XAmFc9A1wfe0MiEl20BHjdpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730170093; c=relaxed/simple;
	bh=Qo9utYUYavSz6IqAVI1b031tY4itm5QjA9ew7trIF90=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TKw/nT0rDEm1eRksrA/rvjGQ8d1d3Z0gNQ8p6owfvIPsL04KH1LrWDaAd1TJ3e6T9NCFTRY4RtUGKKzSISb5TU5X5o0CerSoQ27vVcpHvqystF7n3t5031ktBGpg6aS4fsYqCG0hVUXuPb/C6ewikfg4JIaN5P/8TMUap9DFxi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HMdaHz9Q; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730170091; x=1761706091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qo9utYUYavSz6IqAVI1b031tY4itm5QjA9ew7trIF90=;
  b=HMdaHz9QB1FCha7qRIbMPsdhh9wYsewEew8wstoCN7gUpPVOzC0at93/
   7xMw1OuVi4v+1+tNbcPbs8YmzQMUNa+jc88qZpwklX5IZfrkxmvYEkeuX
   8gJvjIIXt2hSVFod95AyGx/7D0P/yGjD6TY3msQNwP4i7uHUlg4A290AH
   nh61/Xw+BSu2yVHfy1Rs8tDcSospAqe4xH+OrT7QlPH8ERlEVaM+VG1Sz
   M0KBEWSW5PdWobC2YDyfYIAfrLUpQBVlDsbUFdXJK5pIlPP/u0F9DAZyp
   15B0YYLEkQTQcjnM4eaQpBaZOt2ePz/IPKtf/yx5SXBNjIdMcD0KaPIsT
   Q==;
X-CSE-ConnectionGUID: wK/RwqJhTRidMilXiqgrgw==
X-CSE-MsgGUID: rKn2olEoRXCuPW9Oymd0Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="29223994"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="29223994"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 19:48:09 -0700
X-CSE-ConnectionGUID: sFpzSnJIRd6UH/eIbRp9hA==
X-CSE-MsgGUID: 6+kNzANqRvCbiYCaeb92ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="85767635"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 19:48:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 19:48:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 19:48:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 19:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MEG7KPR9rq6NjvIymbH4oFUIjqTNSgWKR0m0XaZDxjBp6P9eZcs0pqtW47k4I59//5aCgPenqcJHfwBCFjBpftK3cNuwBWM/5/77iRHuHHGUZEx3rWmByWe/XBM7xLBMs2qseGxkZwxQfmIRJKdpRfqjuIPy25geqth6OW66NByqNoul6N+CRfr+y6b+yIHk44B/xtnmth5wxq4wby5P4E+LwlDPvS1f6AbNeJg1i8yx34nUJ4wmOKDk51H0COqOwiRsUX6RXKTjA3V0plmZL/Om+mRoSNSOFFXPzmcLb8ewJiKm+CBvnop5gHGXgNjiCzMjCdvL8Xpi2C5FTahoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bINkb0LOI2334TZwomC5RqsDLKyo4TAy/4FyN9gpnTk=;
 b=nQjvAt34NbPTwA4QbIer5EgQufrEOjeu+6D6OVKDkYgTMffociQHVtQ408Z7E6eLBcMmJ1qDZReYWlP48PSi4p8XYGl5DfXP8m8eC42FW85f/Dot6QUe+2uipgv4hUfNfMhz8sgtJJoxC0yVuLEh21s739xJFcJHqKls3MbT54Ty9n8CdXoD/I57XfLmR1AzQgJetoTpbNCaDdsnuLc5JDyql2Y9C4KpqSvAXICxlSfDJheWKgOw9jUKESFZY0ELGi6zXFlBx8448ykyQFnizJh0xGYE0klFdf9eRrg+9l0vfeIF9MkZ2SVZJZIcG8E0Ff5hnLLfK/dXk2aMTKkyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB7080.namprd11.prod.outlook.com (2603:10b6:303:21a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 02:48:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 02:48:00 +0000
Message-ID: <b7f79653-4bfd-42f6-a641-479d2973190f@intel.com>
Date: Tue, 29 Oct 2024 10:52:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Zhangfei Gao <zhangfei.gao@linaro.org>, Joao Martins
	<joao.m.martins@oracle.com>
CC: <iommu@lists.linux.dev>, Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	Yi Y Sun <yi.y.sun@intel.com>, Nicolin Chen <nicolinc@nvidia.com>, "Joerg
 Roedel" <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HN4VnL04EbadWh9cQf+YpTzvscvXBdHY8nte6CW8RVvg@mail.gmail.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CABQgh9HN4VnL04EbadWh9cQf+YpTzvscvXBdHY8nte6CW8RVvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB7080:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b04021-c459-4f8d-0882-08dcf7c41a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b1VpY2s3NUhseFZ0RW5xSmc3ZmhJRVF5TlZ1RldablVTQmMyTy9QSWhuWWl4?=
 =?utf-8?B?dWpVZXFyQXdFZEQ0cHp4VjBXSHh2Tko4bDU4NG5lZ2poZlFQdENyRW1nSVJr?=
 =?utf-8?B?WnkwM011UGZIR1ppZEtBeE1NSFpOY3daaEFjVDRtWXFKY3lkNXUzU1Q0MThX?=
 =?utf-8?B?M0FlV2o0amI5ZnpDZ3VEVFVSVWJGL1NLT2pJVEViN2MzZHBISTk3aEZrNUFQ?=
 =?utf-8?B?QngyQlNkSEE2T1hBSkM1RWgwL0JOVnpZWkxQWmZDTUdrM3ZlOXFsVTlRcTNr?=
 =?utf-8?B?UlFhQWFtQlltVUlHUDVvbWl4N0ZYeVF4WEF5V0srL01oMHFzT2FpQVhyeXRK?=
 =?utf-8?B?Ui9ET1JlNDRleitGUG0yUGpSdGR0aVYvUDBqWE03VHd0dTZOR2Jxc2U5TE1U?=
 =?utf-8?B?R0xKUWFxMUIxa0hFSUNLNnd6MWEzTzhiQ0xFRzRDY1lxNVBXZ3RvZ1drV2FH?=
 =?utf-8?B?dHcrNHdtQ3o2TENlT0plVXNzRVIvZHFoWVlzNWs1d2NISVl2eFlySXByWCt2?=
 =?utf-8?B?VG1PTWtjN2lOQXdrNDF6Rmh3ZWF0azRxNmJMdE44b01PZVJKNWVHMmRkbkpQ?=
 =?utf-8?B?dGRtVGFLS2o0UnZpaVh2ZU8vQ283ZTUxZFNCZWRjRkxjUEFKY05lallxSkFZ?=
 =?utf-8?B?eFRhbHRMTnJkamwzMXkwN01qK1N2clpOWHBvSXhNeHpkcWxzb0pQeElwWTFL?=
 =?utf-8?B?K201OURuOS9rMnlUS2J0MVZQaHhLa2l6L3VzNUQ3WmxHYjRqbUJ3MkZ3NXFQ?=
 =?utf-8?B?VnlxRC9vTzArTWRDTTZySkpDZCszWTZGN2RpVHZ2TE9jUWUxMnpiYm10TEVp?=
 =?utf-8?B?M0JHYXBMeE5lZjF5WFNjQzFnV1ZZd0JzUUxPQWdmZk9pM3pQWnlQVkhXZ3Q1?=
 =?utf-8?B?TjFpbVRvR2hLWmxMbEJHc2JubXpnUEgxOHFkQXFIWTdJMlBaYUN4eWxrS3hl?=
 =?utf-8?B?WHdwMTQ5emVpbzhmcHIrRWgwS2NsSFhGQzBiWTI0Nmp5aDA2R1NYZnF5bmFD?=
 =?utf-8?B?bWg3WllXSFR5TTNoQS9YUUFDMkRVMG1ObHVmL3d4b0xOZ1BuNS83eng3bGRK?=
 =?utf-8?B?VDY2dm9zNWEvbkNlZ1d0ZCtzVzY3UjJPdFBlNW9kZ2ROclN0Z0htWUdlSU1q?=
 =?utf-8?B?elM3dkVrTFdwZU9HQWhwN2ZUeDFOTjEvUkl1enl1TGZTaVRZOWNsKzJYNUVB?=
 =?utf-8?B?ck5oUUpTeFdISWVRb2xEWWRFSUlXRENiYnA2ZVQvWkNJOFh5R1lLN3QvVUVT?=
 =?utf-8?B?OUFrY1NWZTRjSDEzZVBaanp3dkFvRktidlVySVIvYk9hbFh6T1ZocE03WHFS?=
 =?utf-8?B?eUl0TzJTdC9hSGZTOEh0ejNEd2Iwd2dFSGRJa0VRKzZVb1BZZThSSlFOd21q?=
 =?utf-8?B?NVNMUjRWNjJBazF1a1gyT1F6Z3lRV2RLVm0zZU1nZXVxcjZMOGgzY0xieGpK?=
 =?utf-8?B?eGpnTE5ESkdHMVc5MjBPQXdVQlgwN3p6LzF4ZFpjNGp1UDRZdkVlOFVVaE1D?=
 =?utf-8?B?dFZFcG4rSnVDbE5SSFh5NGlSbTgyNERQbFlQRDVEL3Yzb3c0RzFjbVZDMSth?=
 =?utf-8?B?MFhEVmUrS3NyUWM3U2UwTEpBZXRPSFl5WFE5cUV4bjg3TGltbHNRd0FsT1pD?=
 =?utf-8?B?d3dkcVVDdVJIVjFWT0hKemora1V6ZjA1VExnRldUWmkvZnZsSEVPQ3paL0lR?=
 =?utf-8?B?ZEFYQjVFSEN0aU84RFNaYitETWZHZEF2QWp6ZWxzaTZpRFJ0ek9MTGZPelpC?=
 =?utf-8?Q?95w4XrC5exZoviENZg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkdocWlOMmZ2a3dIRGN3bmI3aENkWDVEcnZvdThtRjNTSVRIcjFJWG5YVWMv?=
 =?utf-8?B?Tk84SU40aHV6U2N2SlJnaWN4ZjhtN0JkSUJSSks5WlBQaFdZWm5XRGZIdVQr?=
 =?utf-8?B?VWhwclFpOUZUSGNTUS9mZVVvdTVHcnQxWFJ3RFlod0RFLzhiM0ViWUkxYk0y?=
 =?utf-8?B?VFVSck1RaXJYa3FQWGlsUlB3YzVvZ1VPU0U2SzFINEJTVEtuOEZxYjc5anc4?=
 =?utf-8?B?RkF2NUcwY1Z0K3BOamxDQVFSb1RjSVlFaVpsTjVxaXZWOFBxTU9RZ2hBOW10?=
 =?utf-8?B?ZW5ndHJnZlRveUxzUmFuZTVrQnZaR3J4NWJsVVkxWGU2c1lVYWxMYXd1bmlH?=
 =?utf-8?B?MDFYZTM4VE8ya3JZOTk4aW9HYTlBT242RVM4TDVERzdkVGRKZG9CQ0FSa0ta?=
 =?utf-8?B?djNyYjFqU29JUklGMWVodWJRV2REbXRBYlVEalZCWnJoQnNLNDlSdHFRWlJq?=
 =?utf-8?B?ZmYrYXgrRk8zZE51NzR1R3lvZ25ETTYrVmhjdEhTSmNQTU1FSXY1VGdQZ3dl?=
 =?utf-8?B?WHNtazFtTXllajhWb2xkNnJ4NC9zWVQ2TUoySGhBVStGVUovbnpjY1NmTGRl?=
 =?utf-8?B?WHhvUFpaa3MvbXJkL1ZVUnB2SUN1OFZZWVVYaGdWOTZjV25RbGhjeGVCak1P?=
 =?utf-8?B?NUxtbFZYQ3ZXb2FCdmFxaHRrU1dsS245NEVaeHc4M1A2a1lrL3B2WW9qbTRG?=
 =?utf-8?B?aHErcGgvV051cUEyejArbXlsUmFxUWtXWitnTTY1QXVpVzIrdE1rd2VvSHBy?=
 =?utf-8?B?eURYdlJ2WnJFSWo3SzlzcEF0RjlvQUdHZ2ZWcktNNGhTaGdqdVNpWjlncmRU?=
 =?utf-8?B?K28yaWN2cjhmZ29ScVArNUYxSWp4Skd6cDlUUkx5Wk1XOFNpS08venZzaGZX?=
 =?utf-8?B?aVFGTXBZcjI0azRWc0Vna1NpUEpiYzVFeDdkUmFrYWY1UFFkY3pLaVRsdUJ3?=
 =?utf-8?B?eURweEJIdXQzY2FKZEJVam5ocDRnMG5DajJMR0M2cC9vTy9HVGphLy9MSEJj?=
 =?utf-8?B?RGZlOHg2b01lbVgxeEwzNFM5dXhSaVNZTmdobzN2TFFwb2MwcEJGVHRtU0U3?=
 =?utf-8?B?UzcycFZ5SWlTS2JKaTd3eW05dG1VMlVtQjRQNktySXMrUlZZZFdsdjdGMHJ1?=
 =?utf-8?B?N2thVmt4SzdRcXpaTi8ycVpaZHVaSDRNbjRJV2RvSldOWE0rb1pZUTJ5aWtO?=
 =?utf-8?B?dFROVHA4T0JwVndnMEVEZ3V2Z051K3ZOSVl0MVcwRlFRTGxLTnpjMk1XWmtL?=
 =?utf-8?B?enV0WExCQkE4Mys2VGNtaFF6Y01wbVVEbjAxYVdNR0paQTR5bmdtdmhLdE93?=
 =?utf-8?B?cWlIQ0Z2RVQ3Y3U1ZGpqK09pdmpEQllVeDlGM09OeGl2bDM0Mkw1aXErb1lh?=
 =?utf-8?B?N09HSXJoS2VmdEpYVnU0Zkd3eFJNSjBFa3JmNXE2VTJxQUxkWlNKZ2FEMHlw?=
 =?utf-8?B?VUU3T3l4cmVJWXROaHBJRnQvTkk0NnlyYnAva3JXYWtoMW43dWdlWDlwWTJ2?=
 =?utf-8?B?RFUzNUd4K1NxNkduM1dnUkpTTW03R0t2ak16c0VDRHJxUkc3K05hMlBzOFFl?=
 =?utf-8?B?d2JQOTFBZjhIdHhCWC9idXV6SnQvbEIvSElaWDVLbFNLdGxDQ2tJaC93cy9Y?=
 =?utf-8?B?VVVnMzloSG42RVRCM211YTNPaHpqdTZIYzYySmY3aDdIRE9uRHZwQkMyY3o3?=
 =?utf-8?B?NXptc1JKNmR1bFA3TGlsNXBLQlNFNU5mV2FHLzhYUEQ2MlB3U1ZDSlNZTXM0?=
 =?utf-8?B?RnlZaHRrb2dxOXhWMHVHbXo4UWFsQ2hhR1EydVBRNWdaTDQyb0hnV20wSm80?=
 =?utf-8?B?OGRiNHQzU0hibmRqTmRWNm5qVWprVTBYeGR1YWVJS2VZMEVuTG9TQ1BjSUNI?=
 =?utf-8?B?R2ZnNkdOT2RLVmpDQi9ZL0hLZHJOYVpYekJMdlhGSlJ2U3JHd1VnNDJJVXZk?=
 =?utf-8?B?UEhIbndPY3FsS2YxMldpSjZFcmE5d3hNbUR5bithRHlUTVlZelgzVkUzWFRm?=
 =?utf-8?B?WHpkVUsxcXpDVkRYS0NNdjh2cmZycUcyL2xaUVd0RGpHb2FiSDlESnNFRFpr?=
 =?utf-8?B?ME51R280UU1BcWphRWFmQnV3Sy9yS2tlT2ZRWnhLU1dRQUhsTHYzTHB2Risx?=
 =?utf-8?Q?DWCuQZGt8sPDYj4DNyPcTUFR4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b04021-c459-4f8d-0882-08dcf7c41a0f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 02:48:00.6535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qkAput/nGmnt+/DfVBJPUwPHdA0e7dE8FgJb9ZUMvWxSo4E0BjNvSvTnSoi3dJFkZT5cKJ9VTGkLs1U/kyyYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7080
X-OriginatorOrg: intel.com

On 2024/10/29 10:35, Zhangfei Gao wrote:
> VFIO migration is not supported in kernel

do you have a vfio-pci-xxx driver that suits your device? Looks
like your case failed when checking the VFIO_DEVICE_FEATURE_GET | 
VFIO_DEVICE_FEATURE_MIGRATION via VFIO_DEVICE_FEATURE.

-- 
Regards,
Yi Liu

