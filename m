Return-Path: <kvm+bounces-24351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BC895417A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 08:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E607B1C21F26
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 06:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6F08063C;
	Fri, 16 Aug 2024 06:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGdRlE98"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B02837B
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 06:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723788276; cv=fail; b=eCbgMd6zGqqgmd3tMGF786rvJ8qOBL1ZP9+RG31QFVPSx/Q+FiseY2Da8kLdCgNG6Se3emo/KvN6fhPOzp3NjaulddhPldCq/eQf0CwXmy8jd8TTWlY5egkszcePQgLHEr6OL3Y6+3Re4DPDb2ZTOotZG3Car0ZH80dRrORvJBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723788276; c=relaxed/simple;
	bh=9v+td4aMRQHZdUR47ER4pSniQwAWKVrcgVpS/eCGvxI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tTOAx/urbivFJ2e6cWXq16aGalBYw4mkGG5M6PNC+mZzUbTKrzeSqkCPMaa/QLIj78RQLKxp6pN4tjVd/tFmoOqlztiyTiAC1mj9emo8fka7/BMwE+d7RZm1fw7Egs8yKBHbqHmA++OAq6x6Ht3O88RGuP4aPPi48vvA8vBtwVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AGdRlE98; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723788275; x=1755324275;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9v+td4aMRQHZdUR47ER4pSniQwAWKVrcgVpS/eCGvxI=;
  b=AGdRlE98CiSDxdkEDBMTCyItCGwE7p28TReF8StwP/T8wtVhFAyhwdqX
   3BfJqfqR4nLxW1kLmPH08klokqk6hoIQbRIUpbTtkHi3rNOrob5hyjAj4
   OovRG4+zA6LslmcCva+a1DC4Gq6ZpJup+0Jp0e9O+cjW2kv0iZ8uSaycK
   ooyVz314+4QmO/P7DVJxJLihwhSUOwYstjcOFx+8xlXdMLGaM46XMxWvr
   +zF8lO7yYOul8KBTparSWOBrS3s+sEzhCUVFV8LSCpkaAU0WEU9hIld9j
   dMDRQ5av6lY1wmGoGFr/kFc56blL0BB0TpSflCqsPevcvw3n1NJlA2DB8
   A==;
X-CSE-ConnectionGUID: XDoZYHxqRT+HbIydY6L6AQ==
X-CSE-MsgGUID: Q6GEzhC0SAuoKTy3FAanFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="22044225"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="22044225"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 23:04:34 -0700
X-CSE-ConnectionGUID: /Za9X/I5S/+1se6eNW6ADg==
X-CSE-MsgGUID: 9j/HvixESSisyV3pfWNSvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="60144074"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Aug 2024 23:04:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 23:04:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 15 Aug 2024 23:04:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 23:04:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDjLbZag7GEUYKjc6U6sSAiacR+SRpghv+C9mHEqCXcrzitXZ5IMAv9N7TcN6oGJVqLy/17mgaDHwsXY5VFJPMbmDtaMZ4bn2Adi+GulDjH1cWugA+e+Z1g0VXzeTSGc8BLjO02XERMDM3/MnKCgzWHRahEApftt0m+nsADt8VzxYMjbLjqEWtGQM8QjpqMsYVHrIkMrWkVkSZ7wyo9CZfEBuJEDbW/arXgNw/eAQ/2jhAfbo8Dp8kP+1ax3SyidaKudD/89+c4c75VAajQdQPk8tczNuEA72P7X2iNSq2AEuoRJWwI9LQKed6Ep8HMtSplvnngVWQCLX4nJUs1agg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVjAIOV3xKcdmc9vFKK9Wbi7feporHQuMsAPHPPMGVY=;
 b=F49QNcOvFJPIeI2/AlIxUVAqMfMUr8DcE2XLnaKyGe1hVr6IxKn83SMIjH6CPDYiLw01euK8STbg2vssuDGqI84eRgNCA18U16sdyLCdb0U1XiqP013BTuJaSrAQ1b8wKxj3T3VU+aawXba9JlK9cPkwjQ3MT8P5KnaK1Ok2UW1qm9iNHP7J9kqgEeFUHrYikzyKgXrRi7eirmn0UevKnkvC9AmcsWxh4bl/ijrx6TyG6NeC9JX7Xq3BlY7xwXIJSUy/VnNSje3LlRUHHdBh4og9Dfk2uNJ4a69oeQACWqEw1vq9hk5WkztVuIDWGVX+NgpSk1C9t35iWzDfHtXKaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7122.namprd11.prod.outlook.com (2603:10b6:510:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 06:04:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 06:04:30 +0000
Message-ID: <939d526a-7926-414b-86b5-6c53b6b0810b@intel.com>
Date: Fri, 16 Aug 2024 14:08:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Baolu Lu <baolu.lu@linux.intel.com>, Vasant Hegde <vasant.hegde@amd.com>,
	<joro@8bytes.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
 <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
 <33eaf2b1-75be-4167-be05-16414abe8385@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <33eaf2b1-75be-4167-be05-16414abe8385@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6cdb54-6ba5-4576-d8bc-08dcbdb94a8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZEJpMVRSWmdHRG1rYklnaTRydmtUYTJick90QUJtdDJFZElNZkN0cmNyU1ll?=
 =?utf-8?B?UnUwTjZmalZpL3VIYTIzWVduQXFDajg1TzdqVHByUVNMZWJIdFE0dk1WK2F3?=
 =?utf-8?B?ODFhYUdaaWhCT3lZUlpsKzJFQnkyaUdCdUFvVS9tZGNJU3dPWHBpd3pMOVh0?=
 =?utf-8?B?Q1JXa0t6MmY0SFNWUkw1UUVrQVVqWlNJMEU5N3ZpQ0JYZHdqdllZSUx1VzhL?=
 =?utf-8?B?V2ZUNHdCYlhNRnp2a1JKN2RHNDM4MFJNM0xUZlRiTHcxNTRSTFZvZEpvbG1V?=
 =?utf-8?B?SnFyYXVsWmxFa1NxYXg2ajhMTTAwekNNL2taR3VpQWczV21lZitSdy9sTzhP?=
 =?utf-8?B?aFNLOE1hOWYzd2w2SkpoY2wxUi92clVJZFgzNndhWDFjODJKK0dkbDNBa2Qy?=
 =?utf-8?B?SU1qSFNuYjdVdEpPeE51Sm5xUS9FZ0pteHN0cm9GSjdnd2VnT0FpaUdEWjg1?=
 =?utf-8?B?UTdrdkZkZjYxVXQwM1NobFFlMDFDSk1JU1hDbmh6cFdqeDNWemowMGF5OG9O?=
 =?utf-8?B?dE5CSmRKOFBLYkUwSURteWFVU3MyYjJOZlJUQmlCNFJMeVhza2t5OUFYckJN?=
 =?utf-8?B?WFptY0twM254bnkyVHdLVnN3RXNXWnZDWTMyakNWU2ZGOG9KT0RlMmxjd1N5?=
 =?utf-8?B?VDh2TnJvMm8zazNmVUtYeWh4MjNRUjRnV2ZzbjQ3SWo2bUtYM2loYk5qNVNa?=
 =?utf-8?B?elZxbGl3TFQ0RFpZSWFGZStGa0FjOEdJaEpWRFY3UVpTQnNoMS9FM1ZGM0hT?=
 =?utf-8?B?M0ZDUEZSSU9ZS3Z3R3kxRXdOdEJUWWhybGNDeVNjUU1HZ1FGaXdJdEYyK2xO?=
 =?utf-8?B?ZHFJeVFwOWdkY0xwNEJJQVJ2QnRrS09zVHlmVy9rckdwOFpNV2s0WE5aL1JF?=
 =?utf-8?B?Q0FUd2J5UDk4NmRLTzd1ODlxSWlWNVUrdXBNbFZTcDJMdStxd0YxZHg5Z1Fr?=
 =?utf-8?B?UWJ5cWVkSU1IRFBUd25KVVJRVGJqck84Qi9IaXZxVlZIWFdTR2hZOTFRNDho?=
 =?utf-8?B?N0xYVlRUTndsbnE4UVBjd24vTCt5OGNxbVR1YkJzSE1wdU92Rm55NkxFK0c5?=
 =?utf-8?B?YjR5aG9uNzdHMXd3UGVOaHFES0JVa3V2N1h1OHFWYXhjbnI4TVFXdXh2cTVN?=
 =?utf-8?B?TUlDdTJGeHFzU1JjSC9LTWt0anVBMDVaZEtXVzB5V2Q4dmw3c05QTTRRUUJ2?=
 =?utf-8?B?TXg1WHZKR3RPOTZTRjFqMVNMQjZ5cElCTENpSDUzOHMwWmlXVHZPSlhrZnFE?=
 =?utf-8?B?bi8vNEVjelNMcG9GOFN1VHZKNGxlZWlEcGU5eTNDOFFzTkZRcElYajlRNGQr?=
 =?utf-8?B?b09tTEkwbUJNUHI0TVRmQ1Q5K3hJSWFtTnU2YlAxdU9SRWFhNHdMQVdoUTUw?=
 =?utf-8?B?ZG9zeDN0djdLQVNFajBOb2JrUWs2b2M3YWNqZm11dGFRT09jS01LTXVtVWxz?=
 =?utf-8?B?RVJqRVBLUk5sWWU5bWZQN0pqWnkwMjB4enc5VjhEWnNpNCtLcDV6Y3NIUnZY?=
 =?utf-8?B?QjNXQytYY0RXOVhUSDc1QnV5WkhuQnA0a2R5WVVIazJRL2xLcHJqcFc0eElQ?=
 =?utf-8?B?SHVJUVA2anB1eStHZ1JQcjFVM3BQb2VKa1luRDRPQzZ5RHVsVjl4YVdVRFJz?=
 =?utf-8?B?UkpQTWY0cHFQY0ljOC9lYkV2ZjVUSWlkRnc3QjBhU1pEbjk4a1I0TC9KcUI0?=
 =?utf-8?B?cEdpaEdBTHlsaXNDdlBWZWQxdTA0RDdsMFBNdXBwWkkvQk56bWVUdW4rVmQw?=
 =?utf-8?B?L3U1K0M0UFhFRGZjRVc5ZDgyRVBhVkxCWFRkN2hXWWU1RmRRVS94dzNnd2h0?=
 =?utf-8?Q?MYBnOAJhBrhFyAJjA9t15jmFT6rfTHr+Dcg6I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzBzRUpnRDBkTkZYd0dXU1lxOXFWYlhDTTRDa1pGRWt0TTZ2VUl4aHRQa0Jj?=
 =?utf-8?B?aFdWRWxraHluRTI4VUJVa2t4dGpacVZSMTFxREp4U2c5NkJYaUpQYlVNWjR6?=
 =?utf-8?B?eEJESTRnSVN4U2RZQXFGOXpJNy9ySjlDSVFPeWl1czlaZXBvMGxvVFlod280?=
 =?utf-8?B?Nkx4NjRMUDVJL09KcWlCdXZIVlVvZ2liZmhZL0JQS1pmYllGeVEzOFBadTU5?=
 =?utf-8?B?OGYvYU9BMFNtZGh1YjF5MXQvUCtwY0ZCcnlJNzhaUCtlSXNRWG9lS1NSL1pj?=
 =?utf-8?B?S3ZLZ1REckkxelBHZzlpSzhQTGFCMWdmOURSdklSOWhDdGtUbVBSWlNnY1Vh?=
 =?utf-8?B?VGRmVmhycDY4R3lvRWxJRzI1b3lNRENaOE9rWDRJYXhZMklzYXlhQUVjbFdT?=
 =?utf-8?B?YTRwc0FSS0pYYmk2a25jSmJ0KzVaQWlZNDhxa0lhOTNFbUF2T1ZPdkFtTVBO?=
 =?utf-8?B?S2VEZ2QwUDZlcmxqa1lQYjZwei9tV3RUM2RTbzFaTVhDaU9lWm5KWnQrc0hC?=
 =?utf-8?B?ZXZGd0JKVFFlRkU5VURFMVlRZXEyUDZVTnA0K0RiWTNBM2w3ZkZKS2g1Z1ZD?=
 =?utf-8?B?YXF2QVZ3ZWNHMWY0UStaQnE2encrMEhPQ0NiY0x2ZWo0YWs0Y3hGZ2ZpSllW?=
 =?utf-8?B?YStQS0dsNWVwZHF0d3R6RmRXQmRtVm9nNjVHNWh2czBmUldFM2U1Z0xSQWJX?=
 =?utf-8?B?UkVmUjhCNHBTMGhTd09FYmtxZUxzOVcrMjJPZ0l0Y2V2VHAxSlgwMEpQTVQv?=
 =?utf-8?B?OHZBOHhsYTZjb0gzVmFDTnQ5Sm13dGNZY3RaRjQvN1RPcDk2NlhMYS9rS2hm?=
 =?utf-8?B?SWhBaUVObzFsLzQ0S040QlV0ZUk4NDNSSk1FcHRXSFdkaitJUVVFK3BlME9B?=
 =?utf-8?B?bW40aFV2M2lueEp5WmY1SnMwa21Zb3ZMdlg5eFpYQ1luL1I3UkJEUitVYU9S?=
 =?utf-8?B?SGlZY1pOejFQMU9hTCtTcm9IbzJUbWRrZUtMR2w5UkUwaEFmK3pQcXY5RTZU?=
 =?utf-8?B?ajlSV0YvbUh5dS9BK3FyVnUrcEhVN0JtUCt0Z3pKS25YeWlzME5lWWtiUytU?=
 =?utf-8?B?Y0t0R1NtNHAzTUhtdEtHSVBMbHQrTzJBYVArNytVZTRMZ1YwZ1NDTG91NGg1?=
 =?utf-8?B?eUJxRDZsWCszazJZbmhFRS9IeEZmSm5RS3UrTXdiS1Z4NlBRSG15NkE4Zmtk?=
 =?utf-8?B?NTBud2g2VnRraHFVbDMrZ3ptNE8zcGhQdkFPSjBNUnZobHlERy90NU9CcjQz?=
 =?utf-8?B?cUJLdjlsL2w3UE1qNkovSjlPc05aSTFQNjZIT2tubTdSMjhBRGw5OXg2T1Qw?=
 =?utf-8?B?NXlkRTh6YzYrSG5mSlRVcnAvQjFSWFRHd0NxVXlaZ2hGWTVwanJZc1lDQmRF?=
 =?utf-8?B?U2RHeTVQWkorTlJSd0FPd3ZiRXd5SVQ4aUM4T3c0L1VwRy8wSDFaREFIa3dB?=
 =?utf-8?B?MTdmbDBacjl2ZWZLRlBzNGo2UWR0NXpINTE5dFJ5a1I1dERmalJQRjZ0MVE3?=
 =?utf-8?B?dWxDajFHWWsyeng0MUgyWGtQS3F5VWxRZGt4ZmYvRjcyOXIrcFdybEpCQ0FK?=
 =?utf-8?B?c3lqN0NId1F0dlFXQVJGNXcwWEk2UjhlM21OWUxkMHJvQUVHZXJoRHBtTGFF?=
 =?utf-8?B?TVpWckx5YVo1Qmo0VzJHa3dBVTlVTzZuemNSMWNIQ2dDc2VzM0VzdnVMS2t0?=
 =?utf-8?B?c3pTVUN2VnRjdFJjb2pRZE9WVFpVM2NNNlNrR21CUFRsb0JaM2YrTE1FV1BZ?=
 =?utf-8?B?b0RxeStwS1F6MWpGT244V01pZjlzbWZhOEUzbzh5U2VaSk93WUs4QWhMZUV4?=
 =?utf-8?B?Y2NFRVNJY00xZXhCeTNvME1OSUdoeWtGenVDTDFrcTI3T3FPZDNnT0FKa2tt?=
 =?utf-8?B?N00yM3ZVMHYvWnN0WW5hSXBRVDlzTWYzNWVwTE55aWs2L0xOZU1vYVBMY1Na?=
 =?utf-8?B?YzNrQ0haYVJVSmJnMG0xL3NaSXIzOVIrKzIxQWRUUDNxMUkxb1FJdGNRSzZh?=
 =?utf-8?B?c2Rod2FwUWRqNFJ6ckU1RTl5R1pBMlZwblRvN3VjTCtnMzBuczZVVyt3WnhT?=
 =?utf-8?B?aGJZOTYzdnpkbjNtcU9xNGZwamM4Nnl1UTFPUGVxdVZRelJLWERWbnkwcHEw?=
 =?utf-8?Q?7qzv21XqLbVa3pcs6GW3XR6EU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6cdb54-6ba5-4576-d8bc-08dcbdb94a8e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 06:04:30.0154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25UpQNfMHvAoAcdpIv35rjRWTtCLegus2x9PQ1R7CLZVeln8tX4Bfo1aiBkMxcU5qMpnGdk3ruDww0cEN8PNqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7122
X-OriginatorOrg: intel.com

On 2024/8/16 10:52, Baolu Lu wrote:
> On 8/16/24 9:19 AM, Yi Liu wrote:
>>> So the expectation is replace existing PASID from PASID table only if 
>>> old_domain
>>> is passed. Otherwise sev_dev_pasid() should throw an error right?
>>>
>>
>> yes. If no old_domain passed in, then it is just a normal attachment. As
>> you are working on AMD iommu, it would be great if you can have a patch to
>> make the AMD set_dev_pasid() op suit this expectation. Then it can be
>> incorporated in this series. 🙂
> 
> Perhaps this has been discussed before, but I can't recall. Out of
> curiosity, why not introduce a specific replace_dev_pasid callback?

you have a good memory. It was discussed in the below link. I suppose it
reached agreement at that time.

https://lore.kernel.org/linux-iommu/20240416174749.GI3637727@nvidia.com/

-- 
Regards,
Yi Liu

