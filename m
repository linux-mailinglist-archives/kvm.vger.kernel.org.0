Return-Path: <kvm+bounces-15752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC388B00A6
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 06:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8EACB227E5
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 04:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B84152E0B;
	Wed, 24 Apr 2024 04:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJZ2Jgaa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37EA85C59
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 04:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713933897; cv=fail; b=bggcqdA9U2ybYVIdearRKCqujCNZt6j+1mw65Rx4YoaA1KsQ6BuJktPl3GsfOKLLmMLo+TC5iMv7ZHgP7yvDGwEcnj5wY60TLLc5HCX6QYiUG1/7H8X9IEYBqfd1jK8JBWv8nSThpBlWqTPOjYHEYpWnniOoRgg5I4WcPVDnc+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713933897; c=relaxed/simple;
	bh=Xlvka3CIAj69eqSD9iNgWib9/hHO6+AZ+c77nevfXqQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZvBBXU3ha9RQ5XMFDCR62js7nzchOR0uLWVu8uzw7MZXb9O+TF0zj1pI2TQseHVDjAoIMgmYdSFatT9bGbB2uRs0UdB8cthKmvuO1YuO6vFZLqNtfpCmd2CxRn0CEy3ydoDElnHTcyrhNShoWPVAh9hBfYDGwIXwmcadBY3ihm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RJZ2Jgaa; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713933896; x=1745469896;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xlvka3CIAj69eqSD9iNgWib9/hHO6+AZ+c77nevfXqQ=;
  b=RJZ2JgaacjgpagSp7FG9qb5XGgEnBmXDg+T8zo/YB+N71oNmlUWMQV7m
   L+/JIbxIpwfKtTFuvf1c3fVy6w733vbazb6axAIfPafNGm3JPFcmSaJS2
   CRL8HmhYb1oVQ2bdyCMBLrwTxFEamUKjEYP/C9/XmaZNvdDCV1EvQ2RpU
   /QtY2iai1XWwuXELIiGnzZBW7LZH2ImdCDYyfEGrwUGxGCqXb2fi9FBPv
   00xWte9g1uZdSiJpDgcJsTpGDVyKJlqNWPPMqRlDIoY9p/cfmos5s/8XE
   ziZ0xZIwsLvRICOmpP/mBCnFZvv8OVTYRcg0hX6xQBU68kbPkngajBA4Z
   Q==;
X-CSE-ConnectionGUID: tL1Wp38BTQCCpV3he18wcw==
X-CSE-MsgGUID: zReHakMORb+XHTsc0INC0w==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="20160017"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="20160017"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 21:44:55 -0700
X-CSE-ConnectionGUID: wXsBU2T5QkCAPQBR8dq26Q==
X-CSE-MsgGUID: 9JkXf+oZRHWKfAIMQCojKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="24553385"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 21:44:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 21:44:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 21:44:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 21:44:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 21:44:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/Ipf0JGbjsi1qpVyqqqSmh9bXtYM5PjM622SB4ugfqnyCWcel+LXXRGCU/6oarTFe4MriH+zUr35/82WsfQqTORm/k91y/14hYx+cGzQDUVzwjxgDoLiv+y+u1hZ5vCOzal8EIYTlzl12eG8KEhlrW3f3evixaiaj4YZM65144HdOpYGMf8kh6RyHR/C0TmC8Zzus7WElzaFWc5l6ISTt93rsLroKf6UkHnvozSfI2agSoSR+Gs3GsWqinpXn7F4iHdw594Vn7fuMS6yClSrNmXNM6Yg6IOULBzJxJPdydG1WwtKGKu1mIWvx2OvQX4Xif/tzewcuav3ZFEyD0mYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9CAOyxSo8iwbALIYHB4NMZmaPt17zVjPnytm3EP+C8=;
 b=KVFiTN0Cx2ZWbcVenQIIYKgb14XcPTwpGuN/DC/LLlQBwUaMrCcSnzBoeJ/pJW4q8Bqd1frWlyTGBG87MtXDofVnbnLus88bsSY0ILjeucD2RqzXKWDUNcMUHb5OUbHvznZrLWgZQGP1zyqWwGQgFBqh93OnTOAEPyDijNjVcCFledmg1TSFy4gjme4Ix5drk9EPHkH08bG5LoEKLaIAONS3ut2aSvFrKPskc1Q1TktlWJ94oda7on1ovy6yOesOvwELvqttt5IQuq9P4nC6/ISKgQ3ZQt3Z9EVLSCt83mao8tNBH49Qni1KHUaCxS+VbKgennkgOmkfMF1aGOu21Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6977.namprd11.prod.outlook.com (2603:10b6:510:205::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 04:44:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 04:44:52 +0000
Message-ID: <1581932d-a1b0-4704-b5b7-d505bda53257@intel.com>
Date: Wed, 24 Apr 2024 12:48:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
	<robin.murphy@arm.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <baolu.lu@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-3-yi.l.liu@intel.com>
 <20240423124346.GB772409@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240423124346.GB772409@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYBP286CA0010.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::22) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e31b0a-0504-40df-e97b-08dc641947a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZUlhTU1XTWRtN2xYNU9qdDUycHlXZlp1UkhzUitWZG9WZzI0NWZzSm03V2Vl?=
 =?utf-8?B?S0IxV1FBSmVYTzhPRnRlTTNiODNZR3dNVWRlUGRYNEhDcUMxTGNNS3RZYWNm?=
 =?utf-8?B?blJOSXhUTXFNUVMvN0JYMVlVdXRQN3NIM2RGUlI5ZEdnL1NBL1hGNTQycVZZ?=
 =?utf-8?B?ZDdtclhCVFRjQWNhZ3lYejdDd3BrcGRYRitCc0Z0Nkdla1FINDhPd3B1V3p5?=
 =?utf-8?B?VVJWT3RxczBCeE5XamJRRmluUVMxZUdMR1cyeGw1RFBaMEp5TWVCN2diUGt1?=
 =?utf-8?B?QXlZZ3lWTFJXVkZXd0hiWUM5Q1hIZEw3am83UXU4cW5Qa2hnMlBVWjd3WTc2?=
 =?utf-8?B?QXd0TVNVcnB1Q0xiRGw3N3VSNDRkWFhUOEVEWnQ5b3NPVk5zQldkMWR2Y1Bw?=
 =?utf-8?B?d2s5ZkRzWEhtT002UCttRVZ2SnR1cGJvVVh5eWN0dGNBRHJpTDZGa1VEdjV4?=
 =?utf-8?B?aGNzZjluQVpJUU5Wd1d6cFhXZVVaZ2kvWTZ4WUIyVG1ieC9NRzQ0MjRMcEty?=
 =?utf-8?B?K3J0Yk15NUdiV2x1OEFrTFQxcE9oZWlTdytBaG5mTHA2bG1CWFZiRmU2emZn?=
 =?utf-8?B?NHpoZitnbE9lMFZhNmxHNlZVRno4TXN0N3B2bUVCNG1QZDIrWUVFV3VBSmRQ?=
 =?utf-8?B?QXhWRytpeWVCbHNBQkNkNENHSHlSbUZCYWIwVTFVZ1pubE9xUjJuR3NtY0ZR?=
 =?utf-8?B?b2p2TWpxSGdGd09kZllYK2lGNzF6QkdEUG1YaXZtSDJtSm1WTFRrWks5RlVh?=
 =?utf-8?B?Um9EWks1b1JJclEwM1g5UHpFY0MrTzFLbkgwZk5hS3pnWFFRRXRYVjhrNkJv?=
 =?utf-8?B?WGdadXNIcktrVnlVeXk1RTBYKzUvMitZREE3d0x6QXhvMlAvNzJJa3V0bTgz?=
 =?utf-8?B?emxQOGVud0kwUzJxRkdNSVJVYmFvcjQ5K0x1WHdmNWtnSnpnZU8vMEpYTERI?=
 =?utf-8?B?UmkvZWlEbVdmNEFjSGpoOEpldlpPM2kxRkhubHVQZGZjL1BYaXVmSnJaL21x?=
 =?utf-8?B?UDByRDdCOHMwN0lnQkcxcUdRVENlU2Y2YXdocGh3OTgwcmFaS0ZKYW01c2RK?=
 =?utf-8?B?V0t3L1FDSzZVcEUwYWlaT242cGtmSTk1SG1Cc1V2QVNlWldVRWRudlJIUHBO?=
 =?utf-8?B?VU4xbjNuek93Vyt0N2RiYWNwcWZFbCtHSnhtbVVjdUl1c3d4dmRJVGFnK1pU?=
 =?utf-8?B?b3FVUjNrQnR3K2lhTXcweEU5ZDRRczhTa3ZiaW5UKzZJK2VBMk5Yd0pXTmZi?=
 =?utf-8?B?Q1lBUm5QajcvUkMrWFhWOWpldmxwZjVybGtIMVkwTXBlcXM3czIyQVhIS3U0?=
 =?utf-8?B?bGtXbWpQM1VtUEJmVUdEVXJZektFRUtaUXNjOUh3UXc1NXptL1ZMZUJ6N09L?=
 =?utf-8?B?Nnp4N094aXgwYlo1RjRRcENncXh6d251YllMOXhDYTUzYkVZSHlUWXBKVm03?=
 =?utf-8?B?eHNtQnB0MzluRnNCaFpzVnVzS0dXczVqdGdvWlhlVnMrUzdBK0JkM3Vac0lQ?=
 =?utf-8?B?TUZtbG9CT3R2RUpRMnNNMXlMSUluTXRoelZkV1o5VTVsQ0hyQmJJRXd2M3E4?=
 =?utf-8?B?OHVud0krMlpXNkRHQnEyK3dkbFhiUG9GS013OUUxbEd0MHoyVkdBVVJuT2dh?=
 =?utf-8?B?RnZRVmpnNC9wZVBGSUsvNjlId2pYWEZZV3Nvb0hhSytpTnJjdkYwcjZZYVFW?=
 =?utf-8?B?c0lLSjkxSS9XV2hSMGFRaVhVb056amxYeUozZ3hHZThFNXNzK1JHSkRnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0pCbkpTRTN5NU43NHdualM4aGpidGU1TVNsV3JJcnBKaGJQZWFGU2lIdVVr?=
 =?utf-8?B?Um1BYmhxakd0NHE4a0hpT2dXWWlMRGhkQzNoTlZ2dU4rcUFqR0tMUDB6QW9t?=
 =?utf-8?B?SklBOUJENHREUkE0UC9VOGxSN0hPU2xvSzY4OXUrc2RUc20weklGMURQWHB1?=
 =?utf-8?B?dlJRVmxXMlU0cmtOTHp4eGQzcXpGVDZzNTRQVGJmcDVYTDRkemF5MGRBYnVi?=
 =?utf-8?B?YXRqMjJlUlM1Y0lwTytIYUxwYksvbWxFNE5NRi9odGhDZERadXVTaUdjcUpS?=
 =?utf-8?B?NWxiYllPSUp0S1FBMDhydHBteWppRTBmSGpqOTBWQ3Z2ZWlBaDRULzFId3gx?=
 =?utf-8?B?WXR2aVN6SmtabXhqaWZiYzhDUkRFNzBCNW9TcmRqdTJSQ2ptYW1CRTNFckUw?=
 =?utf-8?B?UE5jZ0lGOVExZVpNUmZ2YVZoN1N5MUt2N280SmFlVnFoRG9PeU02bjU3WlBU?=
 =?utf-8?B?L3d6djNNY2pNSXlqd0VMN29iSDFjM3ZKR1pFT1dPVC9TaHFpS25pUHpMbHlr?=
 =?utf-8?B?a0RpV3hSVGkzcWFkVkJLQWVNMm0va1d3aklxenVycEZYWWsxOEMrWEdQN0pF?=
 =?utf-8?B?cFVjSU9QNFkwMXBlTFg0ZWV1ditSQzN3ZmlwS1NsL0llNkRPdjcvZ2p3bzBD?=
 =?utf-8?B?b1Y0cFZyaW8wQStVSTVZNk9nV3Z2bit3YlQrUXRDRWVCMFRUUGF4aVBuTHQy?=
 =?utf-8?B?ZkZVbzVQOHRDR01uOTJYSkswVXVDSVFYOTlPTWFzY29QSndaeU12SkhlUUFC?=
 =?utf-8?B?aHNuWVFlcjViQWNRZk12dThyVThNdHRhWFkrdlZYdVIrZ2hGbE5BNlJLVlZy?=
 =?utf-8?B?SUN4TUhwZEdOZUNyY3pFZXJuZ1U2Nzk1ZTNsa2xsbis1eVk5SEcrTEdwKzhV?=
 =?utf-8?B?RHZOeE5QOTgya3hVdFp4VDBvdkFrVW4zNVhFYjRScjV3MzQ1amlHekRVeFZv?=
 =?utf-8?B?MmZ6bnFVa1RVVmRZV3hnYi91NTF3d0lOM0s4b3ovSlk1bzdLLzdnbGZseTNr?=
 =?utf-8?B?T1NmTHZkdTBKQWRmbEt1NkcrazZMNTU3N3kzWW5NZElveEV4ZTJueWlpUnhO?=
 =?utf-8?B?OGRubXpiNzJ3czZpdjV0L1l4VnluOVFYVXpodlNMUUNxSVExS1liQVRnSzdp?=
 =?utf-8?B?bHE3VFR0T1dFS3lqTkk5TVNKWDl4Q1htK1BGckwzbVBlQzdGYkJ3U0hlM0p0?=
 =?utf-8?B?QWpQU3ozbmNYeHZUU2V3UjZqRTdNT3dQTHVFMDQzd0NMa0xGbi9hYUw3QXdl?=
 =?utf-8?B?R0x0RGtRdWY2RTBTMW1adlc2UEtVdGV3OFcxYzFlTDN2Vm1sdUJQczZWVnRx?=
 =?utf-8?B?QXJ1ZkV4ZG91OXRVRjN2TEhYNFBnd0Noa3NjTUk2S2lBSXFiY3BBNkVPYkIr?=
 =?utf-8?B?THNzUTRqUVBrWXZoeE80bHZ2Uk1Yb2FnZDFpcXBHekMvVVZFOHp1ZDVtYWpJ?=
 =?utf-8?B?VlowZVdrQitVQmFWWmlUS1RFQ1RKcm5XWW1IS2VFYnd2dW5mUm12V05FMGN0?=
 =?utf-8?B?Z1ZweDlzVlV5c0tCZ20zT2J2MVpmcTdodXhZclVEZFRXaExIS3pMK0JxUTN0?=
 =?utf-8?B?b0dOeE03cUJwVWtPR1VhT0RQV1FlYkJqOGhSUjVQbWRFYU5TcVJkUjcyWmRO?=
 =?utf-8?B?dDIyOU43RVErRlBsOVRMZURkdTNkdmpDcHZsR1ZsU2FkVXM3L2NLcHRkOEtH?=
 =?utf-8?B?eWdJVUNCNFVHKzdQQzAwWEtGeTBnenY5LzNKYmtTWXcvRndaVXhyRVltR3Zo?=
 =?utf-8?B?UWYxQlZyai9rU2w1c1NXWXUvdm14VzlDbGdybVhEVExyem8wOGlidUorWGRr?=
 =?utf-8?B?aWNoTFVTSlMvU1BDMlhtdUNLZ1VVRzhNQmdoZ2RlOWRCUDBLUUNDZ2Z5K2s0?=
 =?utf-8?B?OTZiMnQwK2ZpdVNQS29hQkZ5U2Q4OWxzZWZkdEVTWTZTZ1ZHNnByczNwV1Ir?=
 =?utf-8?B?OGFvMjZYRVRmU001SWlNaUl0N1hPNnFLcFBMaFZLZ25FNFQwSXNwUkM4Mk9i?=
 =?utf-8?B?ZDdkbUFtUytsdk1CdTVWOTYraTROSEwxNkJDNHk4UWhiSndaWS9LbGhIV3I4?=
 =?utf-8?B?ZkR2OUx1NHpnVUdNcy9FN3dzOEZGU3dkWFIwYmw0OVhpTkdZbjc2R25peWZO?=
 =?utf-8?Q?jGBrPCM543BpDsoX2XiFlNp3r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e31b0a-0504-40df-e97b-08dc641947a9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 04:44:52.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3HscAn3Y/1kDw+Waj0MSVGNisRSDjKZDwjl8W4Q4IO9AI8vCUK2Zu4oU0DI0LKwQlp/btmaAesEcNEH0dopeDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6977
X-OriginatorOrg: intel.com



On 2024/4/23 20:43, Jason Gunthorpe wrote:
> On Fri, Apr 12, 2024 at 01:21:19AM -0700, Yi Liu wrote:
>> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
>> +					    u32 pasid, u32 *pt_id)
>> +{
>> +	int rc;
>> +
>> +	lockdep_assert_held(&vdev->dev_set->lock);
>> +
>> +	if (WARN_ON(!vdev->iommufd_device))
>> +		return -EINVAL;
>> +
>> +	rc = ida_get_lowest(&vdev->pasids, pasid, pasid);
> 
> A helper inline
> 
>      bool ida_is_allocate(&ida, id)
> 
> Would be nicer for that

ok.

>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index cb5b7f865d58..e0198851ffd2 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -142,6 +142,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
>>   	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>>   	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
>>   	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>> +	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
>> +	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
>>   };
> 
> This should be copied into mlx5 and nvgrace-gpu at least as well

looks like Kevin has a different idea on it.


-- 
Regards,
Yi Liu

