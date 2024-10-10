Return-Path: <kvm+bounces-28418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A227299844D
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 13:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 591B1282B6F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B721C2452;
	Thu, 10 Oct 2024 11:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IjCnDAJn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324E1898ED;
	Thu, 10 Oct 2024 11:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728558031; cv=fail; b=BNG7jrSy29SjBc/EWkI/vTqi/a+8RRGKhw2XiL+yxVuqd26fb7QaKFHFHA2kqwG3S9veVr5GncFjZRpAbX7xy50XlX49XINDJB9sHeWyhMhQPdnDBtE7D9IWuPo9kk8sgnrr+EsaCtP0UG5H0DKWYNkMRFcn3a+sqmCuVOSb3rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728558031; c=relaxed/simple;
	bh=DRWBSwaxnwTwPuoDBax3cofiscKMsiS2zSpmwQTkMvI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WeakYFRjtJ+FJmiai2Q27vxnIs2i0xCDHvR18yd7cxu3y5lZDgqkstOdmlVeOUOUkVcdth4XbgpFXG+24o5Rj7gwNjtbzRiJFBFjZn8WFOsvBor+MjDzaR6V/dH/LPRQAIbzOoKad9kuuzEIBtt/AiwUbZdXNxaAHi9UO+0K70o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IjCnDAJn; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728558029; x=1760094029;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=DRWBSwaxnwTwPuoDBax3cofiscKMsiS2zSpmwQTkMvI=;
  b=IjCnDAJnqjJO8OAeTl2+6AdBHDOT/u1Y+/n4fTTUUhE+FxZbaeBvFlqE
   lYau+tGRZOoTFzLq/ABxdKtVr+yOOOGjGjaGy7P0r6y36cSUk7f+W203/
   Y6uXFkwUvt3UUM5gpVbYeKzpJNg6zzLH6dCEkv822eMagFuFs23w+dbnb
   PHhReOdTPKSIPHvDMSayAqK2OLXLTG6olomYEwXapGrXRXarh3FhxHSWG
   XXT2ZK590UU6CnNJixaPhiUJUHesAK/uvBPrZSupSvBn9pn/+HSUW2VNQ
   okA/gGcpi2gpkGXqelI8x/TBDAjFSTfYPymCCIRC8GoI1HqAd0vZrkvvb
   A==;
X-CSE-ConnectionGUID: Vbnf0bm8QL6HLulmrja45Q==
X-CSE-MsgGUID: CkXG/ovWQ4GFBHTg2natZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="31697242"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="31697242"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 04:00:29 -0700
X-CSE-ConnectionGUID: q+Tun4dVToCjmHJfuqPtDQ==
X-CSE-MsgGUID: ShTyLJUlRbCTdazu+YWrkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="76757741"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 04:00:29 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 04:00:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 04:00:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 04:00:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/uK2WNJbv/ckEOSF5pc68g3Y6+BOPnyKk2qnsjjXaqdC9sPshro0HSAduTzVjEGHIJVdU4nZsp7LdUK1DWIg+Y2//etMz6Oc+oeE8pcxaV/JogRdlpyxvIr8W0TzAjEVOpeGDWKND1nYztzpOQt2yX+S34JF2JhsdPEJyBbaad8vvLYhqmr0/GsibyC4NfSjBaWTPUzTCURpzdVar85RszmoUDSed8sDs7TxKDHQTXXMFlr/NjSwiIG2148Wwyl3wxqV+kDAeFQ4bKAgX/Hthfnu/LFPP4kv1LED1O2ID0Kfc54bQOXtaUMGgtxfJVU8Ml4GURWdF1dG6jUmzTo2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpoK7SCIH1pFJlHkYP+uj5yvAZdA7dHb5TChznppVfw=;
 b=nAFdl45XzGK5eQPOKmCLbASO1cBTtuHW0ZiN/zX0Kf3GjDkARX0v3xcfkry0ZUdX2YHMNJoj9GxmUC6Qw0fYjD13n4+PFepRgKvssGkHxYdhowMEGavcKFTN5JPNminzTo0DEitC/8rw5yowwc4FCC7UH+O6LLyR5VJXkZZIVkUnxNEmOgZ0LJzyio3EOjzbfNgQHsuWzzfF6A83VZaDipyYyPLJlYjYl1kAR01VPeBQeaJfCKN8SYmQ7t1ebiE76byj5aqSovQnxiV9+8e+iFCrJ4VAFP2BTdvY1fRydP+7S47nggQ/Dv9OH2uAoSNRnm+Y1mldqV4bzYVjjTfeDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA0PR11MB4654.namprd11.prod.outlook.com (2603:10b6:806:98::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 11:00:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 11:00:24 +0000
Date: Thu, 10 Oct 2024 19:00:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Markku =?iso-8859-1?Q?Ahvenj=E4rvi?= <mankku@gmail.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <janne.karhunen@gmail.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <x86@kernel.org>
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Message-ID: <ZwezvcaZJOg7A9el@intel.com>
References: <Zu0vvRyCyUaQ2S2a@google.com>
 <20241002124324.14360-1-mankku@gmail.com>
 <Zv1gbzT1KTYpNgY1@google.com>
 <Zv15trTQIBxxiSFy@google.com>
 <Zv2Ay9Y3TswTwW_B@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zv2Ay9Y3TswTwW_B@google.com>
X-ClientProxiedBy: SG2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:4:54::31) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA0PR11MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 34657902-cb96-4749-8ba7-08dce91abda4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFZqczdBSE9INjdNS0Q5OElSUlNNSHI2ak4yQTVQUmJjaloxekN5TjFHY0hq?=
 =?utf-8?B?SHpCTmY5aHNSeU10RXg4REx0MzJPeUsxaWxHcUFBNFEyeHB3LzlneEZ4VXQ5?=
 =?utf-8?B?MjJJYUJaeU5XcW5XVzlMT2JyY2NmMk02WFZ5eXM4ZFd6ZS9lSzVDREFzWXJp?=
 =?utf-8?B?SUFtSHZqMlRmLzVzUHREdEM5L1hNTUV6OVRFaTh3R3h2VHMwcWVQWEV2SndZ?=
 =?utf-8?B?SGFlWHF3ZnV4TURIamFNenpDNmhUQkwzM2lXWk1CNjNhdE5nYy9zL1UrS3JK?=
 =?utf-8?B?eFlPYTRXU2xWdDgyTVo4VFFkUGRWbjJMbTVOS2NML3FLclI1L1hMR1lFYTJ4?=
 =?utf-8?B?SlVlYkVROWV2cS9aWmtXWnk2bHRKWkhYRFFSWldGN3J4SjlTem1uVHZ1RlJX?=
 =?utf-8?B?cGVJNFBnSTBtVlNPWU10QTE5eGJnajhLY1BLaExKL3dqVHd2RWhLRWxWVXZi?=
 =?utf-8?B?d3FTaDEzTlRYcjNXYlpnWSsxbHd5WmVtb3gxOWRjWlptZ1Z4Z1hPSVZKTnJM?=
 =?utf-8?B?VHFCc056STU5YXBERHFVUGpFQnFSd25ZL3FuMlRDTDZiZFkraGVxcUdxODJE?=
 =?utf-8?B?L0VxVS9uZVZVQjdWc29pMzJRYXBFdDFsbjhid21kWnpyZUQwYkNYaG5SV2hG?=
 =?utf-8?B?UmxrQ3dQMU5EeEtNRGhUZkZiZnlFYzFGMmE1MnZnT0hERUxqbVdZMjZheUtl?=
 =?utf-8?B?bHNvM3dhZ2NFWWUwUEVEVkhsM3cyZytNbWRyemNnNkR2U1lmYlFuMVVFSjdW?=
 =?utf-8?B?ZGZvVWdKUFJRWFV1Z1NGUFR0SnFIakw1ZjA1aitDVEdZb25idjhBeURYaUpM?=
 =?utf-8?B?N1BlM1BOUHM3Q1NvaWVsTGl0UG9HQnd2WFRWemRvQ0JUMlk4UVVhY0hyVHJV?=
 =?utf-8?B?dGNVcWhvTTRoUHBJenpPTExKS1p6aU5JbnIxeFh5V2lLMlV0b0hGc0JiK2Rp?=
 =?utf-8?B?dUJYNVp6eWw2alRGQUUxNGlBRFU5VUpYY0FHbUxKR1JDa3dneXROOWZtbHpI?=
 =?utf-8?B?elNvY1BvL3dqZC82NEFlZ0xaM1lSd2cyMnUxcWRPRjdwTHcrSnRsQVhaK1R5?=
 =?utf-8?B?TGdnZnJGalBGNkZpUXV4cG5uQ2FVQk9RUUNtaXRvMUhhZkJkbFgyaUhtcE1L?=
 =?utf-8?B?ckFHVkVaRUx3d1Y5eEhFTUVVY3JETm5FWThqbWRSUDg1M0h4eWxPeU1hVC9M?=
 =?utf-8?B?Q2xvQXErTW1GTzJ5SW83bkJ6NWVRTGxmL2NBTVpvQ3Z3MGxQeUEvR2VDbXU5?=
 =?utf-8?B?cURBaUpUd0hEWWl2RkxXRm9pKysvY2R5cFRsSEI2eWVaN0tFUkhua0pHT1l5?=
 =?utf-8?B?NzRDdWxvSDNPbGxmRUpmL0xTQ1RibHdMZDVOb1hXQjQ1NXpFWkR1TUliMnlL?=
 =?utf-8?B?NnBnTzZ4WDJabWh1dGFtNGt2S05PR1BRZ0JMeDk5ZWhzUzlHc3JXUUFTaHVU?=
 =?utf-8?B?amdncUxpRVhxUlRhVGpZYm5GWjg5Q3Myci80N1ZrUGVlaTVUelhuNFdrdUt0?=
 =?utf-8?B?bTVSNjdqWk1yNFFGRDdsMDVwTXByekxnYVhpbUI0QWJNdkNja1Y1clVSWm9i?=
 =?utf-8?B?M0gwVmxrNzEvV1NOSFZla245Y2RmdUk4NkJqYzNFYjF1OURnWUNxRUZKMndO?=
 =?utf-8?B?Qk1Qb0phYk9RdVNuYVN0SitObkpscG16YWNNeVQ4L010djdGVTJrN0R3WnIr?=
 =?utf-8?B?UTQ3QzYrRW8vSHpMYjhvVnBJMWkvaDhvVmNhOEZQS2pNNmxuMmdtK0NiZzdJ?=
 =?utf-8?Q?7OAx7EWdzXmdVHv3Ug=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elRjQ0UwU2laU2k5VXVhRlBJMFhIS3UxR0RZSDh6VjhUUmdPMHNnWm1UVFZh?=
 =?utf-8?B?bUY3bDlYZVgxK3llZDZ3ZjdiOXI2amxTa29qd1JXMG96N1J6SzlvdHFnRGJ4?=
 =?utf-8?B?cFpZa3E3bFZPMm9IUmQ2di8wb25JQ3lWM09LdGxJM2h1bmxVOEpvTjl0TXoz?=
 =?utf-8?B?cENHcmpqeHFkWjl3VVl3bFFKVzFGR05yeDdMdVdoR2YxdlZFS2haVXp6Wm1S?=
 =?utf-8?B?dzM1WktaYm5rak0rMCtMKy9JU1NTdnN1WVZCREJqVGFaNEFvNUdCczd0UTNt?=
 =?utf-8?B?RCt1U1lRenVCb25XQXdDK2R4MWFXUFYxK1ZLK3cwZFVRUnRHUzJRbU9LZDU3?=
 =?utf-8?B?dmQwZ0l6MlVRSlFKY2dxZERqNGdaTGtwSGtPV1ZiRDl3U3laTUdZbldUS0Q3?=
 =?utf-8?B?YU4rTXVGM1dyUDJJT2dKbFNXTEZLdmFVQmZENHVqaVNaWlJBK0tLOW93YTd6?=
 =?utf-8?B?QktLOWQrc3BYcVNIYXE1WUpKK3ZERHNmYjc1dFR0UENFMjZqcWpaWEdKR2hQ?=
 =?utf-8?B?Sm90SGdaV0RqQndwMWpIblMrSWR1TUpEQVRxMWNTb1MrekN3T29nQ0Y4SzBJ?=
 =?utf-8?B?eUwvYnQ5M3E3V3VuODRKUW01VkYraTBkZU9YN3ZpcnVpcHBPbEhlQ3NJeHY5?=
 =?utf-8?B?UVdrdUpkdlZNSVhwbkkwQ3VtMERDSU5uMXRFdnJyeUNPeWNzd2xDN0l6VDMz?=
 =?utf-8?B?QnFYQXJFaHEzMUVBWC8xU3BvWGZVSFg2dnBDc0srSG41N01hNGJycWJ0TkVt?=
 =?utf-8?B?MzFCVW1oK2pqdlZra29IU0F4c0VnY2M2d0J2aDlLSGdnMkRXYmlEQjU0dXg3?=
 =?utf-8?B?RWpSTVQ4OFlmTmovU05tVDZSemdhOWRHVkxyd2VLSldST240R25IbW5jcWZX?=
 =?utf-8?B?VUR6UDc2ZEhsVEN1bW9oWDRTQzNDeXliNVljek9FdmJpTUdxanFkRDVxY1A1?=
 =?utf-8?B?OWtFQVVMSHVrRVB4eUoycDlqNTg1UlNxYS9CdjlVTTFwWFNvc29zWExHWDE3?=
 =?utf-8?B?NkE0Snp5eTlETStqd2hVazBNWWNTbzkrdFdtS0owQ0JJRWhYdDhOMlNweDFl?=
 =?utf-8?B?UVNkNWMwWjRyNS82eVg3eVpvdjQ4czF5OGJWS3A5SlFRcWpKakcxdkZidzEv?=
 =?utf-8?B?dHZ4NkgycDJlNWxLbE15QjhPK3NsNWFXam5EV2M5VkoveHNFTXZxRG80R1Jw?=
 =?utf-8?B?STBMQWFSU1Z4cjhUeWdLRUYrVlNUUXJqd0JOaUl6ZXRWL1VBSVM5alRYZWFO?=
 =?utf-8?B?ZDRzTjZDN2lEL2Yza0orVGlhVFhMQ2VjcG1ZNlBzL1g4Yk53QnBKZnNoUGFS?=
 =?utf-8?B?cWp2N29vSHRpeGNrc2FSdjZlQXpKU05OeExEYUV3MmIzMDV6djdwdkpCRWp6?=
 =?utf-8?B?NTdIaFFsVms0MC9neVV5NmIxcWdIUkIxMm1SYWpIT3ZEbGRuVDJiRklOOERC?=
 =?utf-8?B?T2ZidzhqWGdLWUpWYUgyMW5RRlM5N3JldElXdzJPcmdXbmR1UWEydXBuU0RD?=
 =?utf-8?B?NDJGOGl1TFJxam9iKytDVC84TWp5R2hoMVdRUjlmQjlkZXB4YkIzYjV2MjV2?=
 =?utf-8?B?cno2TmVWWVMyRm90amxtSEtjY1d6K2FULy9jQ3dwdm5yaHVyZDFKcnJESnhO?=
 =?utf-8?B?YVRWT2k2VWRUcnNHWGxxQXV3VTVRSWtGSmpvTWdrczlVSXp5eUZiTjNVVXpR?=
 =?utf-8?B?SW5UdExBeGRxQm1yQ2NvVnRQMUVvM0NCeGhFWHp2Z1ZtSENjelRFK3k1c0pK?=
 =?utf-8?B?OXZ1Q3RMaWtqUTlVNmNta2hjakpDTldxRE1SeE5QVXNnTHEwR05aOUhVOE5t?=
 =?utf-8?B?Qi9jdHhuZTRCZUw3T0dEQ1BTN1F3OVhuZktkUVZ3bEhhcmZmbFVMMlQ5OHFZ?=
 =?utf-8?B?aytESEhOSmY2bndDOUNnN013LzA2cTdyWDBYWnptQ0p3Zm9NQWRWaUtKQjRU?=
 =?utf-8?B?SndhVVA3KzlFNkN0dlAxN1oyZUVaUTZ0Q2lQNGh3RytXMkR0YTZkWHZEKzdI?=
 =?utf-8?B?eS8yUitYYWwzRXhGanZTa0dPNW9kd1NzNXpmS2Ixd3l1ZlEvSTlNSmhkVkVM?=
 =?utf-8?B?TnN2dnJueGhzRXR3L2FrbCtsVFFKQlhQOEYwOExhVGprZGkvdG1WcUNJQ2hN?=
 =?utf-8?Q?cIdf6BL/B/fGZ6sA1IypXJkWR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34657902-cb96-4749-8ba7-08dce91abda4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 11:00:24.5040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0q/AjMVTiUv+aVEPZhfhzK2BrgejF4atOcGdwBleJiXuApFKV57S+zV7+5wNhprWSJVowEHQKoKaI9F9YuntNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4654
X-OriginatorOrg: intel.com

On Wed, Oct 02, 2024 at 10:20:11AM -0700, Sean Christopherson wrote:
>On Wed, Oct 02, 2024, Sean Christopherson wrote:
>> On Wed, Oct 02, 2024, Sean Christopherson wrote:
>> > On Wed, Oct 02, 2024, Markku Ahvenjärvi wrote:
>> > > Hi Sean,
>> > > 
>> > > > On Fri, Sep 20, 2024, Markku Ahvenjärvi wrote:
>> > > > > Running certain hypervisors under KVM on VMX suffered L1 hangs after
>> > > > > launching a nested guest. The external interrupts were not processed on
>> > > > > vmlaunch/vmresume due to stale VPPR, and L2 guest would resume without
>> > > > > allowing L1 hypervisor to process the events.
>> > > > > 
>> > > > > The patch ensures VPPR to be updated when checking for pending
>> > > > > interrupts.
>> > > >
>> > > > This is architecturally incorrect, PPR isn't refreshed at VM-Enter.
>> > > 
>> > > I looked into this and found the following from Intel manual:
>> > > 
>> > > "30.1.3 PPR Virtualization
>> > > 
>> > > The processor performs PPR virtualization in response to the following
>> > > operations: (1) VM entry; (2) TPR virtualization; and (3) EOI virtualization.
>> > > 
>> > > ..."
>> > > 
>> > > The section "27.3.2.5 Updating Non-Register State" further explains the VM
>> > > enter:
>> > > 
>> > > "If the “virtual-interrupt delivery” VM-execution control is 1, VM entry loads
>> > > the values of RVI and SVI from the guest interrupt-status field in the VMCS
>> > > (see Section 25.4.2). After doing so, the logical processor first causes PPR
>> > > virtualization (Section 30.1.3) and then evaluates pending virtual interrupts
>> > > (Section 30.2.1). If a virtual interrupt is recognized, it may be delivered in
>> > > VMX non-root operation immediately after VM entry (including any specified
>> > > event injection) completes; ..."
>> > > 
>> > > According to that, PPR is supposed to be refreshed at VM-Enter, or am I
>> > > missing something here?
>> > 
>> > Huh, I missed that.  It makes sense I guess; VM-Enter processes pending virtual
>> > interrupts, so it stands that VM-Enter would refresh PPR as well.
>> > 
>> > Ugh, and looking again, KVM refreshes PPR every time it checks for a pending
>> > interrupt, including the VM-Enter case (via kvm_apic_has_interrupt()) when nested
>> > posted interrupts are in use:
>> > 
>> > 	/* Emulate processing of posted interrupts on VM-Enter. */
>> > 	if (nested_cpu_has_posted_intr(vmcs12) &&
>> > 	    kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
>> > 		vmx->nested.pi_pending = true;
>> > 		kvm_make_request(KVM_REQ_EVENT, vcpu);
>> > 		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
>> > 	}
>> > 
>> > I'm still curious as to what's different about your setup, but certainly not
>> > curious enough to hold up a fix.
>> 
>> Actually, none of the above is even relevant.  PPR virtualization in the nested
>> VM-Enter case would be for _L2's_ vPRR, not L1's.  And that virtualization is
>> performed by hardware (vmcs02 has the correct RVI, SVI, and vAPIC information
>> for L2).
>> 
>> Which means my initial instinct that KVM is missing a PPR update somewhere is
>> likely correct.
>
>Talking to myself :-)
>
>Assuming it actually fixes your issue, this is what I'm planning on posting.  I
>suspect KVM botches something when the deprivileged host is active, but given
>that the below will allow for additional cleanups, and practically speaking doesn't
>have any downsides, I don't see any reason to withhold the hack-a-fix.  Though
>hopefully we'll someday figure out exactly what's broken.

The issue is that KVM does not properly update vmcs01's SVI. In this case, L1
does not intercept EOI MSR writes from the deprivileged host (L2), so KVM
emulates EOI writes by clearing the highest bit in vISR and updating vPPR.
However, SVI in vmcs01 is not updated, causing it to retain the interrupt vector
that was just EOI'd. On the next VM-entry to L1, the CPU performs PPR
virtualization, setting vPPR to SVI & 0xf0, which results in an incorrect vPPR

Can you try this fix?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a93ac1b9be9..3d24194a648d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -122,6 +122,8 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_UPDATE_HWAPIC_ISR \
+	KVM_ARCH_REQ_FLAGS(35, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -764,6 +766,7 @@ struct kvm_vcpu_arch {
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	bool load_eoi_exitmap_pending;
+	bool update_hwapic_isr;
 	DECLARE_BITMAP(ioapic_handled_vectors, 256);
 	unsigned long apic_attention;
 	int32_t apic_arb_prio;
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b1eb46e26b2e..a8dad16161e4 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -220,6 +220,11 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
 
+	if (vcpu->arch.update_hwapic_isr) {
+		vcpu->arch.update_hwapic_isr = false;
+		kvm_make_request(KVM_REQ_UPDATE_HWAPIC_ISR, vcpu);
+	}
+
 	vcpu->stat.guest_mode = 0;
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5bb481aefcbc..d6a03c30f085 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -800,6 +800,9 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
 		return;
 
+	if (is_guest_mode(apic->vcpu))
+		apic->vcpu->arch.update_hwapic_isr = true;
+
 	/*
 	 * We do get here for APIC virtualization enabled if the guest
 	 * uses the Hyper-V APIC enlightenment.  In this case we may need
@@ -3068,6 +3071,14 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	return 0;
 }
 
+void kvm_vcpu_update_hwapic_isr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (apic->apicv_active)
+		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+}
+
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ef8ae73e82d..ffa0c0e8bda9 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -266,6 +266,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu);
+void kvm_vcpu_update_hwapic_isr(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34b52b49f5e6..d90add3fbe99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10968,6 +10968,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 #endif
 		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
 			kvm_vcpu_update_apicv(vcpu);
+		if (kvm_check_request(KVM_REQ_UPDATE_HWAPIC_ISR, vcpu))
+			kvm_vcpu_update_hwapic_isr(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))

>
>---
>From: Sean Christopherson <seanjc@google.com>
>Date: Wed, 2 Oct 2024 08:53:23 -0700
>Subject: [PATCH] KVM: nVMX: Explicitly update vPPR on successful nested
> VM-Enter
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>Request pending event evaluation after successful nested VM-Enter if L1
>has a pending IRQ, which in turn refreshes vPPR based on vTPR and vISR.
>This fixes an issue where KVM will fail to deliver a pending IRQ to L1
>when running an atypical hypervisor in L1, e.g. the pKVM port to VMX.
>
>Odds are very good that refreshing L1's vPPR is papering over a missed
>PPR update somewhere, e.g. the underlying bug likely related to the fact
>that pKVM passes through its APIC to the depriveleged host (which is an
>L2 guest from KVM's perspective).
>
>However, KVM updates PPR _constantly_, even when PPR technically shouldn't
>be refreshed, e.g. kvm_vcpu_has_events() re-evaluates PPR if IRQs are
>unblocked, by way of the same kvm_apic_has_interrupt() check.  Ditto for
>nested VM-Enter itself, when nested posted interrupts are enabled.  Thus,
>trying to avoid a PPR update on VM-Enter just to be pedantically accurate
>is ridiculous, given the behavior elsewhere in KVM.
>
>Unconditionally checking for interrupts will also allow for additional
>cleanups, e.g. the manual RVI check earlier in VM-Enter emulation by
>by vmx_has_apicv_interrupt() can be dropped, and the aforementioned nested
>posted interrupt logic can be massaged to better honor priority between
>concurrent events.
>
>Link: https://lore.kernel.org/kvm/20230312180048.1778187-1-jason.cj.chen@intel.com
>Reported-by: Markku Ahvenjärvi <mankku@gmail.com>
>Closes: https://lore.kernel.org/all/20240920080012.74405-1-mankku@gmail.com
>Suggested-by: Markku Ahvenjärvi <mankku@gmail.com>
>Cc: Janne Karhunen <janne.karhunen@gmail.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/vmx/nested.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index a8e7bc04d9bf..784b61c9810b 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -3593,7 +3593,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> 	 * effectively unblock various events, e.g. INIT/SIPI cause VM-Exit
> 	 * unconditionally.
> 	 */
>-	if (unlikely(evaluate_pending_interrupts))
>+	if (unlikely(evaluate_pending_interrupts) ||
>+	    kvm_apic_has_interrupt(vcpu))
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 
> 	/*
>
>base-commit: e32cde8d2bd7d251a8f9b434143977ddf13dcec6
>-- 
>

