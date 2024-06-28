Return-Path: <kvm+bounces-20667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DA491BCE3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 12:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51DDA1F20593
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DAF155A5C;
	Fri, 28 Jun 2024 10:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NKddnA9v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B782139A8
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 10:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719571977; cv=fail; b=E7c+S0gx8kFm55EcXQLdxr+d+Dje/747Pl1hoZfu0IPtse1vTivD/fPh8DzA4H6VoTxMAYyNA0Ek2o4C1X3LQvRjC+aP2+8gKKTOpG8PwFqYD6QPscmu26C8LgPHJYLSiaPISEyWYLGrIJ/UFZMrlS3kVkFy3rG4UnEPwkpKZKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719571977; c=relaxed/simple;
	bh=mrsRbiZsLOzES7tW94esztLt3oAzhRquq88fJ3VGWzc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LxxyqNFF7kWoQMPiY7kIJFFQmnQkzrT0nqn+9yQOofiQhOH9eQT3ZdrioVj8EVL83CaQhwkjZDFblZuTootYjwwi7w+9vu7fS8sI0EYE0zmzI52luc6/h+AZ+kqvi8S/NGCF8zKEhi3jjTQj5BakTVXYQLhqZQpUK+U4MCa0ySY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NKddnA9v; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719571975; x=1751107975;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mrsRbiZsLOzES7tW94esztLt3oAzhRquq88fJ3VGWzc=;
  b=NKddnA9v1g9nf8R1gDPbbzcI0tJZNQaXixLLfigPZDe6o1TRt7/LKGZj
   lJXgnCAdshE9FzbSXCI8dhOFNVv9U8WtdrhbQo0mPn2nyjB5zM1Ll7drJ
   TX4Z3ETQRnZtDgCdQIW3P+jW160o7WlRruXIjKt8WwX7c771oUGh+u7Dw
   UDX9IQ+kkKlR0nTnHzkC9fW5r0Wv0v4Tw+J+G9jbZVGWvO0zinHYQ1d++
   jtRqS1DRiL7BpkCa4a35Ldva0byURwkSo3KLV0XkY2aCVW5+n3AIiUEs8
   ciOketO3aaQlZ82ugCDHMuuoQvnAFBGoIPhYN+4/deJRfmlP8+KLCznhG
   Q==;
X-CSE-ConnectionGUID: /PxkMechQpKJ9ZIe/Yf6lg==
X-CSE-MsgGUID: 6vhccqehTNyEfb5t2Kl4Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="27434897"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="27434897"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 03:52:55 -0700
X-CSE-ConnectionGUID: ElnX0U5QS5W0R0ZIjw7Vnw==
X-CSE-MsgGUID: nqsbgkQbSYK4XoBmmVt7kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44539929"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 03:52:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 03:52:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 03:52:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 03:52:54 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 03:52:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdZM2RVNtPw/Y28QqNUNCW8HPDJyzdcvwiRwwQ8p9p/R91fb8dt5gzdD8VshJWhqbyQ8PmT6+U3IIVOnpfjXhqiMdLLJFbxsgI6fzXtTpbhWvW2t1aYnwx1VeDgNvvy2OfzNMPaM3ozRMn4DX0lyGShkmqWxF5vOmHyGEHW0fRLcO9sUOgmrQEgitm+6wrmMZjBdcKshtfIluUB+mdJErSfVDjTJhP9m3wKEPhPzXktruZ6sqJPtrvYajATmBuhAXVBPNkWIglHoqoMEYtWT8jNgR6XushirhzbykFk6QCAyzUgXha+AhFHhgNFxHPCJjbkuvFcVR5dVC4V7VBlUww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbuZGirJnjVY/x32GXi5fO42AcyEnTqhoc0OcmMz7XY=;
 b=ExVlBn5JvqahCDruxbTyJbEnEv/bHw5R+saVBwl5pnI3mScWTWHJu/XjgVKZe1JcUlFyNAHHEOQ0TR/QdRTVWalLjlcQd5P1BuMu17LOE0R97EDyhBRNjrtM0gCWcv1xllLBHmH796Uc1CjyFLFDzYkDp9BIJcKrwPdgwT0NNeKbmEQRflbjDjYiJLtx7hZgo+F/Od0Q31F3QuvApXnbe0TorB0P5iK9tb3driC3o5+g2GumV/Gqnmb+dim+wXBOyhuqg5S2rnK675iOVGpJFB1fAqTASclm2JyuKDD91dffjsvHjD5ipi1tNu4PeCuqOHqZdN0vGW+hC2BxVb95cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Fri, 28 Jun
 2024 10:52:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 10:52:50 +0000
Message-ID: <1f45d1d8-5bab-4a53-89c1-d97afb5a7c07@intel.com>
Date: Fri, 28 Jun 2024 18:56:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] iommu/vt-d: Make helpers support modifying present
 pasid entry
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-4-yi.l.liu@intel.com>
 <d4601f60-a2b9-4660-9b10-d05391e87e77@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <d4601f60-a2b9-4660-9b10-d05391e87e77@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::32)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d19740-f51e-4fe8-d307-08dc9760745d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QnVZMGZrd2o3TFNhS2Uwb1VhcEZLOFVISEd2RDhNZEo0eFR1VWllVEhydFNt?=
 =?utf-8?B?K1BUeHJ6ZzdFQk44ZlZ1aGJucWZFMDZQbnI4dHMxT3BzL0ltRjZzWitXaFhE?=
 =?utf-8?B?MjNGTG9kYnRDdUJJdUxnVTc1c3FlOElWeWxLbHJMSVpjZ3M1L0NaeTBLK3Vs?=
 =?utf-8?B?ZHlWblU1MlZQb052KythSVFUVDFxbkRsc0U0N1VUcFV2QXdxdWZPSm9Kcnd3?=
 =?utf-8?B?aXdoMlpJdmpWZDNVdlp2cmRRRVVCbUUwTFB2bGpWb1pNSWZTTFlRNFpOTEto?=
 =?utf-8?B?Nnk2YnZsZ20ydGdqb1pzOGM0NzAzeER1Sm9MalhPYmJDMEd0WDJUOE1IRlhr?=
 =?utf-8?B?WXZpTW02alovWnVncWVJMXR3eDROZUU2emF5eG10Q01ieVNIWVdrWWpwdFhp?=
 =?utf-8?B?Z052bVpzc1czaVNHU2Q3dW5ZUGZVYWRsa3pYaytKbFdScHNkYTNmN3V1M3V1?=
 =?utf-8?B?VTFEcERmQng0K2RCSlNhYmxBRlpSNEsvTFJBYVRZZDRxMVhjRHBQSjl0bVFS?=
 =?utf-8?B?ekU3UWRRU1dzSjZLbnh3KzFreHdDc1NTcGpxRURGaFJKUzJnVkFqYUVHbkx4?=
 =?utf-8?B?dGZVY3FZUU9xU0ZoVnRiOTcyS0I1VU1iN2Y4NDgrMnp1ZjB1Ukx2bzFXUmxG?=
 =?utf-8?B?cno5aUZBQWRyaW1YV2dpcjlhNWpQanB4K3hYVWI2MFQ5WFZEWERnVjVDL3M0?=
 =?utf-8?B?N3h0T3pIallZc3M0NDlLSTcya3BORVlkcExCTzFXNXAyOTRKQ055VnYyRUFK?=
 =?utf-8?B?aGJ5UmZJWE9SeUZEOTloM1VHYkRudDlKbHBqODdOOE5IeW9VRVB2N200OWU1?=
 =?utf-8?B?N0lNeXZNSGJtUjhPTzhWZ0xEYjZncWNWeXFKZmVMMUEya3JLYndrUUlINmhB?=
 =?utf-8?B?dDkxSE5hTjJ2TFg0VXlFL3JyMlpVWXZ6UlhRb1k2WmV4TDNkU0V1MTR4WWdu?=
 =?utf-8?B?MXBJZ0dudytwL1ZreXg3MEN3R2hmVWZJVnppMWJkWFh6VXQzUk82Y0FJbWth?=
 =?utf-8?B?SzBXdnFWK0Y3Q2dTc3F3U0VWeGZWNnBha2lJNHpadVl4UTY1OVRZWnc4cGVK?=
 =?utf-8?B?OHcwUm41SGVqZ1pIM3hhTHd2QWlKR1VXTVJXY0tJUlVDTGZoTkMzaUl2SmUx?=
 =?utf-8?B?NWRxeTdoK2dVdlIwdmdRaHhGbUxVSlBhQjlBUjlwbytMZ0NxOUt5TEJiTE04?=
 =?utf-8?B?VzNmaHVrU3M5K2lOZUFlMEJHQTFLWnFaMHdwYnhXbmdqUXdPcUtIR0xFSFBM?=
 =?utf-8?B?emJtYmh2cmJqK0psWXI5V2w4SWJTbkJyeUZwTW8vUVVYWnlJYkVmdUpmVHZF?=
 =?utf-8?B?YlhrakE4MVlId0Jxd3pXT054YlI5UEZPS2tNbE1uTUY1NHc0MDZ6SmtSUTBE?=
 =?utf-8?B?U25YTkRTSk0zWFd0Wm1LamZnczJpMXBkTGN3TDBBRExoRktaMm9waElpU0tT?=
 =?utf-8?B?VVNZcDRndEFHRytxbXh2QlJMbmthYU5jK3NMOEQxOWY0NW9mVXpkdGdCSjd6?=
 =?utf-8?B?UDdQY2o4UHJnMXpwdVBCQ3BsVDVHMzZ3VlNpNUxReDVVbExxWHU4ZEJGM3Ax?=
 =?utf-8?B?Y25mRWRWLytJR213czgvWFhoNFpYVmJYdjE3VXZNUUNBbnFpUmdQQXZDVjNY?=
 =?utf-8?B?RDRyYUNWcnJGVk9vd2RReUlVc2pLR1pNaHord1VXK0hWcjRDVGtOMGVXSHRm?=
 =?utf-8?B?c0pmRmFXWVZvQVNlS2NVbGZnWmNPMFhhVXhWWWF5UGV5bklNRTBOR3lLQnpz?=
 =?utf-8?B?NEVpQU1TMVBNZ0FCb3Eza1hPUE5rY0orQ2JRc1FaNGQweS9RWkFvSElvU1U0?=
 =?utf-8?B?Q1pJME5OejFzaGZRUlBaUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUNscGVNeEIrOGQrN2pjZUpQRk5IVm8zK3YwYnFFNFROUlgwOUNmSDdkSytT?=
 =?utf-8?B?NXE1T1ZySlJhY2V0eXd5NUVGV2NwT3VhSlJiRkhVQTEwQ2tLQTRmdkdIdnQ2?=
 =?utf-8?B?cFNrZ0JkeFk2cXc2NXNtVjBPaVh3aEJzdGtsSmlQNTB0K2xKWUpza3lpajMx?=
 =?utf-8?B?ZVRuMDkwZGdxN3FWQ25QeCtKWEZTa2d2ZzN3L0FJN2RBcXc1S2UvZEJPa0dJ?=
 =?utf-8?B?QTdqaHZ0UG0zRGluM0owT1gyNWhqWVRCRVExMWNwc2dFQXRxZXRKUnlrTmZm?=
 =?utf-8?B?NzFKbnFNWSs5Y045cmhNSXJzNXFyOCtBWk5HaTMzY1oxazRoSkwzOCtXVGUy?=
 =?utf-8?B?RGx5Uit4UTVZUzF3bEVWNE1UTnNlRUxLclg4Q3pCUEJYNThJVVY2d0hIRjZU?=
 =?utf-8?B?OWZEZ0dVbDRFSk1EbU1zS3VMSjE5VmJNMFhnTVpEaFh6UmR6YXk2Q0EyTTVY?=
 =?utf-8?B?b1VkcjRhYVA4MDdGbjhSUXhpSnVhd3JxYzNReDU1ZStEWlFlV1JtUXRBdXE1?=
 =?utf-8?B?NklieWFTaityNkl5M2NKOGFidk1wV1lJVlRLL0xBQjJNTXNaa0V6RWZuZG53?=
 =?utf-8?B?Z2lvdCtKQlQ2bHFDQlVPWnczRnhRUE93Uk9CN014YndwOGRyQS9RMnFMQ3N4?=
 =?utf-8?B?Rkw5NEFpQlE4SmtiaEQ0NThBN0p1M056T3g3STBaeXZhWWdSaTVlbE5Hb2Js?=
 =?utf-8?B?b1FzVEgzelg4RUIwbUQ1cGt4WUNYb3VIZzFzOEpRNDV1MDhKS2YxMmJjQ1JP?=
 =?utf-8?B?dzhrQjdabDZFK0s0QVdmcENFczVpNSsranVCbGltcEhyVkoxVDZDcitmZ2th?=
 =?utf-8?B?aE1BQXJ6MGtiNk91cE5hbXJuL2J0djE1dFpSSklhSWd1Y3IvQ3Y2andsZzBY?=
 =?utf-8?B?TUtubHNHQnVuRTd0czl5QndWZHJQWUF4cCtCeE42Z2R5eHoybTZYWHJQTjlZ?=
 =?utf-8?B?aFV0SWtBWVQ4MGNzY3hzelZGRjBGeFNoNW5NN2lGeFpXcHVsYjhCbE9kVlhv?=
 =?utf-8?B?bjIreit6Q01TKzZvS2ltS0hqNVE5dzdwc0lhbHhDZFRNbTQ5T1I4RytURUcz?=
 =?utf-8?B?Rzc2WnQwcTl6Q1FjZWVkT0VOU0lFeUxxa3l2UGIrSGNaMjFQV0xsSHdITEtN?=
 =?utf-8?B?N0pZSmdDeUdGbUtEc3UwMVFSUnhoQktDeFZCbUIzUFdSRkpUaEg2bjdmd1ZC?=
 =?utf-8?B?ZDF3UmtBakJVM3pxOFVHcTVpZitkbE5qa0Q4dGVmaVVDY2p5S3NsWnp2MkFB?=
 =?utf-8?B?NDV5VktpM3A3Ky9vQUVqNXMzTUFjUlJ1VXVLSmI4SnFHR1B2M0VRYTNvKzlQ?=
 =?utf-8?B?bDU4TktRRnFHblVBTEp2WkJaQWtSRW9waVRVbDNEL2JSK213MmJRUkhnTllo?=
 =?utf-8?B?M2hhUnpNT3FRTkgzUGpPM2ZhV0FHc2swWkY0ZGNzRm5PcUVmSEloMkRFdWpH?=
 =?utf-8?B?VjZqVE1DWi9Ndzl4K1FRWEErWXRLaEFNQzNEaHhUTmV4YlBhM0xITjlyUEF2?=
 =?utf-8?B?cFdSV01lQ2dNNFVGTGJvTUIyTUhkcGl5NXQrQ0lxQ0NSTTM0Z2d2bUxocjVQ?=
 =?utf-8?B?NngzaWw1S1VBQXZZWEY2MS9oaktuUDQ1Z0NrSmdMaUxKc0tQS0VkZ3ZUU0lP?=
 =?utf-8?B?MGxvSVhFSkhMMFp2KzZaemFYb3RnMVhFSnc1cHpiOUNmMDI2cy9WVDYwR1Jm?=
 =?utf-8?B?SHJuK3FqaXFrMkdFVVRjanBuTFJwSGZXNjVrTXJjcC94MnRXRm9rNmpmU1JF?=
 =?utf-8?B?N2Mvdkx3eTd3cFhzdlAzUWZyMDlwa29meFJkOGlIcU5ZYmxpdGd3SzRJU3B3?=
 =?utf-8?B?Sk1HcHVTR25qdTZ6WHNHN2Q0WGY4Mkh5ajgwa01qWUVsczRhZ1ROMWMvYlA3?=
 =?utf-8?B?SnZ5KzNMMTdNQ0VQU203SUNLU2VBM3E1Nnh0UnlxamlOTGxzZXdnVVF6Z3Ry?=
 =?utf-8?B?NitodXNsc2hjQTNFQllUajRadk1Rck1JYnIzMllLUUl2Q01VTjg4a0lTdzc2?=
 =?utf-8?B?U2RFb3lFZE43T1kzOElWRFo3UUFPL3htU3puM2c5OFpzaHhCTmY5Um9jNUpC?=
 =?utf-8?B?TkhRZ2VCZWF0T2t3d0xDSkM4UTUxNmJQbm9XbmowZHVETkFrQkdtalZYTHlw?=
 =?utf-8?Q?l6cGWZJwUAnrcmjET/S54ZOTL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d19740-f51e-4fe8-d307-08dc9760745d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 10:52:50.7891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDgA2XMBDtIe+SfHUxFNSazJoYuynocI3kms0nV7w9YIestCYPtpzFJWHMxxMpmuToUY9CaLNQrsxKsmEqP6pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5776
X-OriginatorOrg: intel.com

On 2024/6/28 17:52, Baolu Lu wrote:
> On 2024/6/28 16:55, Yi Liu wrote:
>> To handle domain replacement, set_dev_pasid op needs to modify a present
>> pasid entry. One way is sharing the most logics of remove_dev_pasid() in
>> the beginning of set_dev_pasid() to remove the old config. But this means
>> the set_dev_pasid path needs to rollback to the old config if it fails to
>> set up the new pasid entry. This needs to invoke the set_dev_pasid op of
>> the old domain. It breaks the iommu layering a bit. Another way is
>> implementing the set_dev_pasid() without rollback to old hardware config.
>> This can be achieved by implementing it in the order of preparing the
>> dev_pasid info for the new domain, modify the pasid entry, then undo the
>> dev_pasid info of the old domain, and if failed, undo the dev_pasid info
>> of the new domain. This would keep the old domain unchanged.
>>
>> Following the second way, needs to make the pasid entry set up helpers
>> support modifying present pasid entry.
>>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/pasid.c | 37 ++++++++++++-------------------------
>>   1 file changed, 12 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index b18eebb479de..5d3a12b081a2 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -314,6 +314,9 @@ int intel_pasid_setup_first_level(struct intel_iommu 
>> *iommu,
>>           return -EINVAL;
>>       }
>> +    /* Clear the old configuration if it already exists */
>> +    intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
>> +

[1]

>>       spin_lock(&iommu->lock);
>>       pte = intel_pasid_get_entry(dev, pasid);
>>       if (!pte) {
>> @@ -321,13 +324,6 @@ int intel_pasid_setup_first_level(struct intel_iommu 
>> *iommu,
>>           return -ENODEV;
>>       }
>> -    if (pasid_pte_is_present(pte)) {
>> -        spin_unlock(&iommu->lock);
>> -        return -EBUSY;
>> -    }
>> -
>> -    pasid_clear_entry(pte);
>> -
>>       /* Setup the first level page table pointer: */
>>       pasid_set_flptr(pte, (u64)__pa(pgd));
> 
> The above changes the previous assumption that when a new page table is
> about to be set up on a PASID, there should be no existing one still in
> place.

actually, this does not break the assumption. In [1]. it already clears the
pasid entry.

> Is this a requirement for the replace functionality?

Replace would surely need to modify a present pasid entry. But this patch
only moves adds the pasid entry tear down and prq drain into the helpers.

-- 
Regards,
Yi Liu

