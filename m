Return-Path: <kvm+bounces-31410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FA29C3993
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1262A1F211DF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB95115CD55;
	Mon, 11 Nov 2024 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+aMQD78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3564015746E
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313099; cv=fail; b=BXQZtV4WTKuQI2wzhYplvu2s5FcYrb5yuUs5QzQYxBtBlE3Ied52RVyzp+D7jB6e6CNx2jFpf9iIvO6S2RWHKwqKGBlDaj+5TVHzdQY0P2u6A36EmtnloezQGrysdXxaqFrAmte5SWhSwjZwnma69hR4m3DpkUzpSu1e0QLqXFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313099; c=relaxed/simple;
	bh=w+ReXUEJEsqt8SGiEa5ZJ29L1F/eCK9qX8Rd5kk2rFQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZUWBNOXC1U7ook4sONCEMfES7G91pdLBxbm5ZJqxnfFzXxEVK3PyJRuvUuIaUGwEgEOdOwySPOvjK2+H00ls9ISlwfqWv/TPMZhqQqta262jgxEpeRhrdOqAQdmPpfCK60RvVSM/394UpnsZMpMdgsZDLmlYYd51ba6ZPNwyIrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h+aMQD78; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731313097; x=1762849097;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w+ReXUEJEsqt8SGiEa5ZJ29L1F/eCK9qX8Rd5kk2rFQ=;
  b=h+aMQD78TOfELcarkq9u+tmMMJ1TbMMr1I5UrbhCDBia7isdnjxC/lwS
   4bWJPK6Ch7C2k60nZgbhWQF80wvxwjsMB9dOId8F3sOXUb+mKb5A+QRNn
   Qt+n74tpgQyAvSlWsRY3bc+v+1G1eAvoWBlRaXilS+/PWKO9MSeYvpV4p
   BhoBpKNDmHO/WXewBLeeV99/HOC+y8eSXSasJQz/huRVozKYhTySZk2Yr
   X0gVruFTDRnhP44MBv5lMZfER1zd7Vj9YIPB9iQlHovcU2Y2DTtvtQFhq
   qGjnj6MLEZDP1du65J4JoGLEq6JLd3G28AleOFlCLg8ovsfRlzYKiPn7T
   Q==;
X-CSE-ConnectionGUID: k7iykrBeT+iP6z3sL9963Q==
X-CSE-MsgGUID: 1R9SVzhtROWn7Trn1p2XFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11252"; a="30524277"
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="30524277"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 00:18:17 -0800
X-CSE-ConnectionGUID: ZkkOMVSSRfK67jWFaiuHRQ==
X-CSE-MsgGUID: G4EYWDJWRcGZHtnbCAeQjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="90784627"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 00:18:17 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 00:18:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 00:18:16 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 00:18:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcaXEVOtdp3nkS+CHWEB3KUSewA8thDRPT49aYD5KXFdoI+VWR1m72aYYdyNSwsuOJM8qgNTaE8j5RkjjU8A+7Gt22QWceW+EHUmQmWDGjTRE7qIMObESIu8vGyM+RxyxVnzpeUm/wNx4Lix+jOuNuByZKR5/ucwYS2PqfLCSHqk4iESZfOhXM9i++Ct0RbMtEoFlC3C8hQGEEuqN/zuSslOuS9FG8AA+VoPh/ue028LobgcDDWCWesDyPXs6daehz18Dcoyed6tY3tey4Osr1XPFRF95aKjPbYS28wzQvUo58kf7VRxbZsV5fLRHKfWsp0/xV4TfdcrO4Z0ZZ7qUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvllEkie3Tcx3p7J32mDUyjoqzSZRAU4PhDoGIeZByc=;
 b=eus6cVxchVB3MxLwLAyHBFdLM6teajx/O2xNRKahjePcR0YkxcUqCnBYb+OnsdHz9I6xRQ+q6fAkhMpTRFw+6A+9Vt7+7HOobiJfSFBAxbfzZYB90jgLw0LyrpureVtxtdk/3OzIgs5mhrIrfDdpvUfdPKP7ESVCPM9oBl0hGONodJYdGdzBqMBhepWc9VoPPnpFi0VfqulkjtYE0vZyt2jDDfDEtbCSQh/55tW+fft60sg2uIR9siGk0dTzkEovERoq03gvy1WRkLZb7ez2380DTliiE17vuWRBFGzLSh7iROQHIejp0gN2j0OlOa2+9qkcf94u08HeUpqHbJSFgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Mon, 11 Nov
 2024 08:18:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.022; Mon, 11 Nov 2024
 08:18:07 +0000
Message-ID: <f95158af-9293-4527-bfd0-d8bd64a582ff@intel.com>
Date: Mon, 11 Nov 2024 16:22:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<willy@infradead.org>
References: <20241108120427.13562-1-yi.l.liu@intel.com>
 <20241108120427.13562-2-yi.l.liu@intel.com>
 <facfee81-1b25-4b3e-aecd-38930ee41f7a@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <facfee81-1b25-4b3e-aecd-38930ee41f7a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SN7PR11MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: be68cd66-6f16-42d7-74dd-08dd02295f2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Mkh3WklRMzFGR1REaEthUjg3eU5oaHQ5dUYzQ0p3LzBNenM3OGIyZTRxdUJF?=
 =?utf-8?B?Q0tRZWpkVXVFZTZZTmJlb2dESzBVODkvbU85cUd5enF6WGU1OFZ0RnlUcWJ6?=
 =?utf-8?B?UnRpbUpkSlU3dElIaFlQK0J4blcyc0paMHArZzE3Vld0NlhHM2NPSTB6d1hJ?=
 =?utf-8?B?Tkk0MytOTTM3U3pZWXhmbElDTmVXVWNjK0pOVmlSR1J5azFNWm1DU2tQNWNp?=
 =?utf-8?B?NzNFcHBFL0xKbGFXZEVaS1o3cUZBSnZXZnpWbFVaaHN0K3hsMFphdDVIeE1X?=
 =?utf-8?B?Z0dNMFlncXFpVTBUdXlVR3hYWmpXMHdKYjdUNitFNWZPUFNSSVdsTHpVVmE3?=
 =?utf-8?B?WGlIQjFYVTUxeHdxS0hhajlkaC9kT2xvOHE5RTRsOTc0ampBMEdxbmkvTGVL?=
 =?utf-8?B?b29hQzBsNVVQVm1yOTZIVlJCWXduTU5WdUN1Y0lQRGRPTTcrOWVpK1g5TlNy?=
 =?utf-8?B?V0Q2RWZFR25lMHJ5RzJvWnhDOWs5OFQwT3FlTGxyK0EwM2cxM2dnNStCUTd5?=
 =?utf-8?B?cTBVdDlJbHRZUGZaU1VmRnNmNGJhRVV4L2RZa2R4Z1krTGpyVmhmYjIwR0JL?=
 =?utf-8?B?emFTSTYvVlRSeFFXaVhvZ2tvaUczUUZvWEo5NEcwVmI3UEJYK0lWWVUzNDFj?=
 =?utf-8?B?dXl6TlU4TWNseHdsWFFjUCtONWE1VG9ZQzVUMzhybGczSEhvRldIZ0tiUmRw?=
 =?utf-8?B?ZG96UlJwMS83QkpEODN4S2hkNHY0bitkbUFBRFRGMjEreUwrVUY4UHNSWEo0?=
 =?utf-8?B?NWsrQWZwT0ZCOHZsSzVXYmFKQ1d6TVJONU5tclhuVkhjdXVMWVE2aVlTRGt1?=
 =?utf-8?B?RzhGMytUVTBwSTlPZlAvRU1yUEhUSUkzYzRhU0o4SGNOSXh2MlIrcVJwUkI0?=
 =?utf-8?B?K2FqTFBqQ3RCUTRiMmlhWUR3R1JnMGZhdGlZNnhzemowYU9EdVVhR0pOdHdh?=
 =?utf-8?B?cVNUTWRGK01ibUcyZ1JzeUFPTk56UlA2cHRoNFB3T09Db3NZaXhsM0Yzb2d4?=
 =?utf-8?B?VlptRk8vMjROa1RkcmRTbGVUZnNkRDBIa2VvYVRMS0JrRUl4cmdtVjNpMzlH?=
 =?utf-8?B?SjFzWTVFcEJDSkhxdDFYUmxpek85YVlUL29XdExOTHhHbUUrRHExc2FjbGdt?=
 =?utf-8?B?SGlGdGxXd1hKT3dMeHl2ZDdaZVIxdG9Yd2JocFdBSlRKQ2xyZG9aejQrSk4x?=
 =?utf-8?B?T2FXMFFTR0FQVTJDRXBjZjc4bEdNSFdndzlWaGFvYmpXRjJjdjRQaC9yS1U5?=
 =?utf-8?B?Ly9kYm55V3FIYTZTZW5vOTNhQjFPeDlGRlhBdEU1NFpzSnhpMVpvWkE1V3N4?=
 =?utf-8?B?YTFPYVd4Z3k3Q2FtNGdDM0tBeXNTbExYMzdrU0VRVms3NnpXcTl1OWpPQll4?=
 =?utf-8?B?azlsenFyNVlDYUZ3bzF5Z2g2NEhnZW1xbXFYYlppK00wRDRucnhXTDlDSzNS?=
 =?utf-8?B?YWVlVjFhMW55YXlQamlLbnFGUEZVemVQcUlyazFqVDNoSDJjZFZaMVBQaHJX?=
 =?utf-8?B?YmZ3eEh1RGlQSTNLVG5sSTJXQ1VlWEtjK0dtc2Y5U0s0RU1iMUtsWnZBNVNx?=
 =?utf-8?B?VmR4SEFpZGQwTDcyS2I5c2FPK1pubXR1d1FIbDdSZGhubVRPNlU3eFdLcTZu?=
 =?utf-8?B?eUhRbzhQRE9SdEduTUlMZVF3Q2h3Z0R4YXgvZEd0a2U1aWFqTHc2Y0QyQkpH?=
 =?utf-8?B?QzJjT1BJd1pIUkx2eGcrR3Z2dVRtTTEzR3k1QjVlTmN3L0tWdnJkTG1oWEJQ?=
 =?utf-8?Q?PQhDaybPvxnKN/l+GKP+5iwB7OWaKrsQ9Mg+gna?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckV1Qm5MMTNTRnl1RkR2blRRdnc3Zm92TTZscjUrZ3MwWFBMbjYrd0taOUNa?=
 =?utf-8?B?NGNadjF3ZGZsZk5NWHp0VnFYMnp0SVdiYmhob1RMZXB4eGppUytEYVpVa0hT?=
 =?utf-8?B?QUFZNFBBL2ZuSGYycW9EaFZqRDNxTk9aUE9TWTM2bE5FYWpMNG8vbjFKRTlw?=
 =?utf-8?B?TDRnTE1WWTF6NFpTbC8wOHJPV3NJejhVT0c1UXI1b1NZTXZNaFNxeFlNZWNl?=
 =?utf-8?B?aFJNaUJRSXY4SkQvbmlSUGRjTWw3SmNvWk9SNHV6SFlZWk0vQ2tidjVEOGRN?=
 =?utf-8?B?MjBxTm5lemhYd3lSR05RZys2eVpwZ0k3S2ZsR0g1WlpzQWFsVzVRR1RyVmtj?=
 =?utf-8?B?clRubllZRFk1VDBHRUFORG1DYkR1ZTdPSURWblZxc0ZZMWx6eGNhTFRPbGNp?=
 =?utf-8?B?THkrMWtFSnpvRGV4WVIxYjlLNEZ4cDVBQm5KSDF5MkFuZ2NMcWw0aDQ5ZGwz?=
 =?utf-8?B?NW51UmNLYlZhZHd1RmpRN29oUmdVWnhuOVhhbllVam9pMUlXSktVdktGZm90?=
 =?utf-8?B?VGtpbVJFd3A0RHZsbkJ4STR0U0c2TExjYmpRMWQrajVzRUIvcWg2QVJ2NzAw?=
 =?utf-8?B?TUFwTStrekJKSFFPbEF3VDcvaDF5OWFlL0dhRnh3NjkxdkNQVlo4YndNVVFx?=
 =?utf-8?B?S1loZlpmMHRHWUhpZ2Zoc3o0RUN0Z0pNU0x1STJPOElzQ0dBekFhYmR2U0Qv?=
 =?utf-8?B?UFVsOGlnQ0VRbUIzR1JtVDRrelpNOSt6MHR0VFVaOVZKVFl5blVxdFRsbEJx?=
 =?utf-8?B?R1ZWZ0FtWEluT1VtS09BR3Y5Vkp5UXE3ZUZZakQyakxRZlJ6WXp4aHJYSTBW?=
 =?utf-8?B?OGxLaFRzZVZJbTgzL3RoYWQ5L2JaRnUzaXRxY0FWOUs4VzMrZWp1N0pxSkhX?=
 =?utf-8?B?djJueVJFRTNJc0V0YlVIbVE0aHNlUE5xR2hZODk3WndtY1lGMncwcVVGenVJ?=
 =?utf-8?B?bjNES3Q3SEhGcWNheXBKUkxheG9hUTkrN3pEY2IrYUNvV2tZS1o5bW5YOFRj?=
 =?utf-8?B?Z1YrdVlUNWNJbnJqdXdkSWFsWWJDMTRQSVpScldtT2xqcWVveXRJb0pvU1h4?=
 =?utf-8?B?QzJwbEM1OUQvYlBxSm9Md09zTE1GRTBUKzFrNTJ5eFRjT0dRNTlKWUloc3Fw?=
 =?utf-8?B?NXdhUkJHQ1BXeVFHWExFQ240Y2NJcDlMME1NMnRzUVB4dExvUDlvd29maXZx?=
 =?utf-8?B?NUlpd3RLMDNoS1hWdTJIZDRHVWdoNGczZnBFOWx5Z2dMTXNLMmJReDQ5a3Nt?=
 =?utf-8?B?dURhQUJmNFV5MVpieW5hVGNjWHFxalgzMmUweVk0aTVvTkJmL2hDN2lKOUtS?=
 =?utf-8?B?SCtpY0RIek5OYnhJZlBhNWtZd2VLWm82d2wxSG1xOWhqdytTYlE2S2FPWnFz?=
 =?utf-8?B?UStJY3YwTENWRG5WOUdlMGg2azQyMFNQNkNGRkUwNTFuS1J5T1B0R2RCQ250?=
 =?utf-8?B?UHlEQ3V5UmtOdGk1SzBrYitwZDhzbTBySi91Nm8wWS9mMlBha0QxM0JUWG9J?=
 =?utf-8?B?K0V5SUt5dHZ5V0dNcnF2R1VOSE53YmVwczJDQjhUM1RIeGFSQ0JBNzMwdVBC?=
 =?utf-8?B?UXVLQzBCcXo1emRDb1JBYWp2R2x2TE1HTFVQdUVsR2hOQjFFSDdFMVYrS2pu?=
 =?utf-8?B?YVUwMERGODdWUXZHL2JTY0pualRZWTNpanN1czAxMWNiR1J5bnJIR3FSOElj?=
 =?utf-8?B?bjhzVEUvVXVyZDZ0aGNuekhFSFkwQmRrcHoxU1pHQlc1V2tYbHpjd2JEVmo2?=
 =?utf-8?B?RHZ0NXhHT0MrdExPVk5md1dMdFNTTzV3b1hyeW9HSTduZW9QYnMrd0o2L3Az?=
 =?utf-8?B?Vyt4dHRZbXlxQlhTcy9kRFJVOU8wUktONEQ3VW8zc0RQTDFPTWxBMG1QbXRM?=
 =?utf-8?B?cFU3MGtwY0xoVmVnOHJUeld3QTBJQ203UjlZZG1FTVJDNXYvbEVDNnBtMDd1?=
 =?utf-8?B?V3IwU3prVXJoejV5aXZYMXBYcUk3Q0FmSlp0ZVdGZmlvMUQ3QTdPc0JpZjdJ?=
 =?utf-8?B?SmMyTERzMVNkd3drbWFzSzFoTUJhcDVEMFBaN3pZS284Z3hGdmE0RWtaczVM?=
 =?utf-8?B?eXdZZVpkbEFERTk3VUZCakR5eXFGclp5Ym53QWwvT0VQZU1ZeW9taFpONDJx?=
 =?utf-8?Q?luPQ92zFAM3ni+BLwufwH+cxh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be68cd66-6f16-42d7-74dd-08dd02295f2d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:18:07.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYj3UQBxmkh1wIuA2sBWCC+AeYbg/zxFEBATdzR8uSPGlFoPmpJyDiCcDphz8V0r1GWyoWBl/WC6NsJqZznA+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com

On 2024/11/10 11:59, Baolu Lu wrote:
> On 11/8/24 20:04, Yi Liu wrote:
>> driver should implement both set_dev_pasid and remove_dev_pasid op, 
>> otherwise
>> it is a problem how to detach pasid. In reality, it is impossible that an
>> iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. 
>> However,
>> it is better to check it.
>>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/iommu.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 13fcd9d8f2df..1c689e57928e 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3352,17 +3352,19 @@ int iommu_attach_device_pasid(struct iommu_domain 
>> *domain,
>>                     struct iommu_attach_handle *handle)
>>   {
>>       /* Caller must be a probed driver on dev */
>> +    const struct iommu_ops *ops = dev_iommu_ops(dev);
>>       struct iommu_group *group = dev->iommu_group;
>>       struct group_device *device;
>>       int ret;
>> -    if (!domain->ops->set_dev_pasid)
>> +    if (!domain->ops->set_dev_pasid ||
>> +        !ops->remove_dev_pasid)
>>           return -EOPNOTSUPP;
>>       if (!group)
>>           return -ENODEV;
> 
> If group is NULL, calling dev_iommu_ops() will trigger a kernel NULL
> pointer reference warning, which is unintended. If you need to check
> ops->remove_dev_pasid, it should be done after the group check.
> 

good catch. Let me fix it.

-- 
Regards,
Yi Liu

