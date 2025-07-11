Return-Path: <kvm+bounces-52201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 007A9B025B8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A05C3A650CF
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395431F9A89;
	Fri, 11 Jul 2025 20:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NSF26i8T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB441F3B83;
	Fri, 11 Jul 2025 20:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752265462; cv=fail; b=a50D1WhNR/j5DKvZzc9Oui1uuBVbOOL6pHAit9CAgDI+WEAP+ij5xtGtk/ew4VemR578C7/Y9oO6hZuLkB2PKfhS7JDudjpUBKW4qyk6lB6IJoPc/+kovz3uqU7Bxea/x223K6OOsPtsD9gjC1Fz0IQuP7tVMev6vZxHHwzAuEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752265462; c=relaxed/simple;
	bh=6+PjFmpCXRpZzkDXhoBQJP33OfbpDZEufnqxIs9QJ2E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tu2H8lpeEGtVOYbhHIUbK/Ao9NQTZKjhyl+m4eWdKPRN12kNqzPxxZzVjHDiowJ3Y8gn6eQxSb8a44ve5YqbWheb1LMyVlYs+qkQHhXYvxbhLNrBi63OvJNZnrcTOg6+1LDzD3dxVl1ukn1alx6R8ff4AQL5WdAUidsYm6Dh3tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NSF26i8T; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752265461; x=1783801461;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6+PjFmpCXRpZzkDXhoBQJP33OfbpDZEufnqxIs9QJ2E=;
  b=NSF26i8TT/Uqk2N0lL1m/AZF/Mm7VgDTq9brt0vAcokeyWqWEYwTTsRN
   LN1EzlIHFbAWXSKXzqkfPrrWwaaTlWE5mA5jllBF1AIcx+lJizkZpJhGj
   n0gVKlQyvJJjILB1e0CDSiz8uaVYFa/8vfsJhRx/jHm/QBe+7aQC4MyAF
   qKG5sl6fa+nvG84+Pz9nqw4oOTpscdnhLrW3l/X2zOL/ryfjpfNbcg1GG
   l073rs8bRsngBhtTdLldMbu7QrwGI5uOi8+JJU/sfWmStczpeJGCMvtET
   IwFxqOhFDjKqodBEGBSxSWvAYRsXbOXjViGMxIJwP2SWAs9lKKAXzDU/W
   A==;
X-CSE-ConnectionGUID: kuujPS01TVexR9rDh9OENg==
X-CSE-MsgGUID: vM+i9yzTRYOfJGSjGfHMOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="77109601"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="77109601"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 13:24:20 -0700
X-CSE-ConnectionGUID: cJGjE27mQ9agxqw78VoiqA==
X-CSE-MsgGUID: IlIs4FgRRZWH5l9zI7bizg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="160781652"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 13:24:19 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 13:24:18 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 13:24:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.80)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 13:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAoZEvoANzFkahBM43doX90nzj+hnpyN6LO7b4iHPAXi+mZY1HMM3ajb0YsZ1NqMuOfCIqWSJzRIxxcjJiYN15Nqe6i5GyADG5lCZhkdAOwufTZIVqXYCSPWiahT4cBIzbS6sOfRIwX6MMtDlivAJsurFd8Rtmphjt7pNJ6/XZ0rL8mnG5ve9LVhJsFaYCUB0Su+RlvHY7CXtR8/aGQxOuciyVWn4DcN8iMKgmkKRtEHlPa4O+iPffCR8CsWTpHgT3bmn2QZuUIAjuHgZV+sNrFB1x73Trl7iCckfmlCPT+tJZi6zWwzFjtK6Vv3MzNFlx6tWqJZonsZprnOj2u2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjcJvadbkR+2CXxmnbyuCl5/t3368kCfDY9Ab9ek2Eg=;
 b=SbRTSThTbunQ080j+lQwJ0ylEmJzxRPnQPXS/LNSmL9kYuyblwbkxhETR31me20X+TDI7pgXKfUO8acr7DFpGZ/YjPCzhylOE+yhZztRx67PMWIQaeoHmUZuL6nWgV8skthack+HKINLozc+hyEo/QjmTaJcFI2AzQ2jxAYV+WhZZYDQ/eclYvkT/CLydTH57Dswe9MN0iI2EWcD5YMvUAMm1KmTs7etsrlOAHRPuMGxle0cNfg387Jr+WKaT8NUONCCkovTk7uVCarIwiSb52Naxgtes+8d1N9AdieTyPDDeqdqcWpwvXeDdAmsAUVJTGBmJY5M6Rfuy05EZvB+5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 20:24:15 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Fri, 11 Jul 2025
 20:24:14 +0000
Date: Fri, 11 Jul 2025 15:25:38 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Michael Roth <michael.roth@amd.com>, Sean Christopherson
	<seanjc@google.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250711163440.kwjebnzd7zeb4bxt@amd.com>
X-ClientProxiedBy: MW3PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:303:2a::13) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW4PR11MB6738:EE_
X-MS-Office365-Filtering-Correlation-Id: 931cd11b-4fe2-43f4-d224-08ddc0b8e706
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7fiA+diEHQwOFEP8uEAOiOEWWm0i9xyAlJFDeLdqS/J6lmuK9+aQOq2mIrId?=
 =?us-ascii?Q?OIeVXMUWq7iP/2VtgDdPaH63tmE33eief7fqYj0H5mjp202wNaFcyhjIoEYt?=
 =?us-ascii?Q?gJSvXjqdSs9GvkItBP3g5cCTP+1Jpj/avz3sVzwiDsgKNjGi64fJAJh+tkjU?=
 =?us-ascii?Q?7X5nIEkTxCdvz95xXNnMTyNXGD9CjS59+Je43nTDJMB8txQntY9moG5NM789?=
 =?us-ascii?Q?WMs4m2k1yeqbM3mrEMpgffCZ7KpiVfF5B3qjbvn8WcOjTNns9//8zDllOguE?=
 =?us-ascii?Q?G+V6vn+aIopqLltMwYiqii4Hk0khgr50/YzTGcbgBvRoY0bRbsl2Mw3wiTAr?=
 =?us-ascii?Q?oP5H2nxumP95eU4EqtuPipnVpKuUvdV7//10hSoNT5OJ5H57NAcGFbu8XSM9?=
 =?us-ascii?Q?eyZjN10Zc7RGiHa3jfk7l81xnTvbig6735glfH4kgOTgkoDbO8FvWxgnotqV?=
 =?us-ascii?Q?KidB8weXUAU6xEhSG6vU3c6RB/g9uiVK3nwF7G/7tZoTFvBK6pwzcPixdbR6?=
 =?us-ascii?Q?+zd5u+IoNaU422+cB1TBm2a6KbWe0ErFXw2lc1sm3faDdHIUg94EeYg70SBP?=
 =?us-ascii?Q?BtlAvn6K4XvI5aF7/4lyf/Dx6fn5tIGsKff/95lvkoWlBp1sVanKzt6KTsj7?=
 =?us-ascii?Q?qmAcBKpwIh4oAm+OnrFQUF8JUxMmYyAE6s2ezXmWjQ2NuyZKK5JOc5ZfA0Lu?=
 =?us-ascii?Q?AnakmAM5U9jEiigJ5XMrH77Ft1fSnhcmuvPLg4HtAhMg6rSvwstJkTbRlDQh?=
 =?us-ascii?Q?jbMJIVsNhtUm3QonaqrEbehA3cKP1Lc9XMcNgN3S1XL43SGM8OM8dyK6ymI6?=
 =?us-ascii?Q?JHbPMhLYDOOYtZt4Gw8CGjg6OFetCCVfaIWsUMmKQurVozRBx2wHdn3Y8xt6?=
 =?us-ascii?Q?ylgdrXTNVOU0l0LZJC+X9Te++XWlAdWmwjn4r3v1TCn+SP2ed8Z1ln/te86k?=
 =?us-ascii?Q?F3OArY6zZ7FJ1C9j6voFvEZr4dX9oJ9xw08Y+/RQXD6KSamhN1/TTJbY2qCT?=
 =?us-ascii?Q?FcVXT4+kVbrkjDyWtrAu0zBvJHsFlpYD1RP/8Et2C8tufRuNmZArYG2zchX5?=
 =?us-ascii?Q?gkpwdOwUumxdqGc6QR6DYwce59TrEG8u86sH2y+lPOAfxuvWdpZaf8d3ty3o?=
 =?us-ascii?Q?YTmifAuY6tISSRU2aPzqYl31K3O/YK0jdPE8DC3QYs6OdN/eNO14MjtNcnM8?=
 =?us-ascii?Q?N2QDhIfWbhU5FLnPThsxoEmDwfI+VTT9q609vIQTYzNVp1yFT2uotfP5aFXz?=
 =?us-ascii?Q?oxhgL3uW+yOdtIPtR9DcMOD9AlXfZ0RSPBDx6OLyioUEr70wPjjWrnznREB6?=
 =?us-ascii?Q?kNUy+5YE3tl2T7wG4v7s2GL8oUT8JCh+tCT5h06bm+TE/roy8K/y8ZY7slSJ?=
 =?us-ascii?Q?AUgOLtnuhDh+0JTdrB5rJoNJCEVd+vrxu9Mpj/VSs3+kLCItk3rN6QF9AvoA?=
 =?us-ascii?Q?Xa0zRClj8kM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3flR+fn0Q1Xo4vmiRzCdJDipHTuakqAUAuDDcEmgtWbiqVkPHjUQnhygUoTc?=
 =?us-ascii?Q?RJjGozSA38xumtrg/rWx/hCTNljKRwHlWVVTzNCDlLvhpEUYgAIYTClj4DNm?=
 =?us-ascii?Q?YNSYBGaDj/xkqSxNZiNbi+tBFF26abga3t1vTukYCOF8YbeBkxCZHZJhEWqx?=
 =?us-ascii?Q?hHJbn1Fbi3Wj4/Ul/jv5K68U7MFpi2g9Cyfwu77EXE7EZWJVK83Gey2cG+Hp?=
 =?us-ascii?Q?q6GSrNHWOLOTI6GPCMX/DtzPYcksPwYYXhe12T2QkGyiwmwkiXq7lngY6W04?=
 =?us-ascii?Q?1YYVZN2lnwLb14Bw/pcU6MRlNgcGyRvjuvMKQeqy+SNyT3Zb/dVfOK2IoNIm?=
 =?us-ascii?Q?taaI0X5Y9HW980oTaDYpljr6cjVQjA17MHxMYGig7ylGDJGDSgL1FPScXeTH?=
 =?us-ascii?Q?I3TtNFFUWqxomXDeA0D8eMjDjoT3qkewd7Iw/voqeZyzV8krnV0RjUiclaVU?=
 =?us-ascii?Q?Nz8nBTNYX4e8/MbNJHNFYk+7IEuX6r8HTAXpYvvhLoF9fPmEDmg5LQ9C1AnM?=
 =?us-ascii?Q?NmiN4rh8RgWcJZiofNq4UlYlso6fzIAE6faRm/sAgGrpJtuQ43SJJFe4V0Ie?=
 =?us-ascii?Q?66EqsLT0wBIzvHItAx1/STGlAFzv36XRfxKxNBo7RKXyByT7SpRotUKbmsGD?=
 =?us-ascii?Q?iFURWdQFwozvy7VPiFO611XqMBt45tvePQcxWeh/2jjD0dkceXBeCcYuqZpB?=
 =?us-ascii?Q?shYHL0AlioKdn5TFBjm7S1IgrCNnAHRts3fm3uWwgxWwXXSMuxmjBD7RTm61?=
 =?us-ascii?Q?/6lAUa41l7qWgL6tWGB210zt115vtLXK6tOY4GINZ94y7UtxR775YiKXH8eb?=
 =?us-ascii?Q?20NdhxmivbJ/SgWNAka/L8K8M/wZXUDAu0HYOkfWddAkMy0BUipDMWQFTgER?=
 =?us-ascii?Q?7NR7R0O/hHwXI7EAXFnc/vod19+JiXCZKRM8FT5q6p2dGOyv+qutEkBvIGXO?=
 =?us-ascii?Q?J19VQ3CFWT0iydAy6vYiHD5IncqH4VMZ/KfUwCYSPur30fuGsezNJIyzItmB?=
 =?us-ascii?Q?GgclOJ2MQGUKNy+MslB/ORYi8WIMKHz3kIjOw/Qwq94mMzvD/CE1fe4ZqZZ4?=
 =?us-ascii?Q?P6RcOMhtOAizmBk/5Iq82PnYRpmVKK39uEh2bGJSzGAIzsMbxIhiipFd6O+R?=
 =?us-ascii?Q?wr6rpKzqVD+1o1jjOJcC8ZmaBo2E/bUw94T6JIN4EOXCr6Zrx+K/ej4oVzTW?=
 =?us-ascii?Q?Mwqt/OpH2bkdTjwUUEXrGc+Wg8l1TQi9nZYxdVgK+1/q0HThLwWu5Sf7nZuV?=
 =?us-ascii?Q?ZtmnshYhKKpiUXOEDRti0+QPS0uvC7T3YBvWaRatKWaALsjvHTr3WdKQAB7T?=
 =?us-ascii?Q?bNnBwXwjwm8P/9UR1P6JfLnxAiF3ZMyuwsKoMlUi1duhL07sd7MEfwGfxNNn?=
 =?us-ascii?Q?HpbZlDKMSfk0BW46n9ldFd1iZI7NLmsi5DZ92SWlN1tBA9d9Mcg2RE0omvkG?=
 =?us-ascii?Q?tzb/xCsQpvCPKnEcbWqyy2N5xf4kBzzeRJ4JGj1XSx5cWGOcAulCkPdvEHYj?=
 =?us-ascii?Q?Xu78MqkTMlqnCB2XR/7di+31oXEWEV2EeRwO35QfTZkefeAypw9sCqyZlR2C?=
 =?us-ascii?Q?52kFLrofY2hOcnuCmYtfPz5imqCKDtrlNm8Irz5j6wUPHLna/eBus3TaSzKt?=
 =?us-ascii?Q?xYKAv2sSc/E/ILf2l1yKznJp2YHRDkj1BoUqutz8qLy8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 931cd11b-4fe2-43f4-d224-08ddc0b8e706
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 20:24:14.2936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYdap2Y/SYwcslsGMSSFPIJ3T9uRps2/Sp2cftxc8mUBVeCCGYzia//Uhxi8EK02acQhlIGtNkoR7CJwyNjTMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6738
X-OriginatorOrg: intel.com

Michael Roth wrote:
> On Fri, Jul 11, 2025 at 08:39:59AM -0700, Sean Christopherson wrote:
> > On Fri, Jul 11, 2025, Michael Roth wrote:
> > > On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > > > Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> > > > log:
> > > > 
> > > > Problem
> > > > ===
> > > > ...
> > > > (2)
> > > > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > > > resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> > > > - filemap invalidation lock --> mm->mmap_lock
> > > > 
> > > > However, in future code, the shared filemap invalidation lock will be held
> > > > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > > > - mm->mmap_lock --> filemap invalidation lock
> > > 
> > > I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> > > KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).
> > 
> > Irrespective of shared faults, I think the API could do with a bit of cleanup
> > now that TDX has landed, i.e. now that we can see a bit more of the picture.
> > 
> > As is, I'm pretty sure TDX is broken with respect to hugepage support, because
> > kvm_gmem_populate() marks an entire folio as prepared, but TDX only ever deals
> 
> Yes, for the THP-based hugepage patchset the preparation-tracking was
> modified so that only the range passed to post_populate() callback will
> be marked as prepared, so I think that would have addressed this case
> unless there's something more specific to TDX in that regard (otherwise
> it seems analogous to SNP considerations).
> 
> However, I think the current leaning here is to drop tracking of
> prepared/unprepared entirely for in-place conversion / hugepage case. I
> posted an RFC patch that does this in prep for in-place conversion support:
> 
>   https://lore.kernel.org/kvm/20250613005400.3694904-2-michael.roth@amd.com/
> 
> So in that case kvm_arch_gmem_prepare() would always be called via
> kvm_gmem_get_pfn() and the architecture-specific code will handle
> checking whether additional prep is needed or not. (In that context,
> one might even consider removing kvm_arch_gmem_prepare() entirely from
> gmem in that case and considering it a KVM/hypervisor MMU hook instead
> (which would be more along the lines of TDX, but that's a less-important
> topic)).
> 
> 
> > with one page at a time.  So that needs to be changed.  I assume it's already
> > address in one of the many upcoming series, but it still shows a flaw in the API.
> > 
> > Hoisting the retrieval of the source page outside of filemap_invalidate_lock()
> > seems pretty straightforward, and would provide consistent ABI for all vendor
> > flavors.  E.g. as is, non-struct-page memory will work for SNP, but not TDX.  The
> > obvious downside is that struct-page becomes a requirement for SNP, but that
> > 
> > The below could be tweaked to batch get_user_pages() into an array of pointers,
> > but given that both SNP and TDX can only operate on one 4KiB page at a time, and
> > that hugepage support doesn't yet exist, trying to super optimize the hugepage
> > case straightaway doesn't seem like a pressing concern.
> > 
> > static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> > 				struct file *file, gfn_t gfn, void __user *src,
> > 				kvm_gmem_populate_cb post_populate, void *opaque)
> > {
> > 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > 	struct page *src_page = NULL;
> > 	bool is_prepared = false;
> > 	struct folio *folio;
> > 	int ret, max_order;
> > 	kvm_pfn_t pfn;
> > 
> > 	if (src) {
> > 		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
> > 		if (ret < 0)
> > 			return ret;
> > 		if (ret != 1)
> > 			return -ENOMEM;
> > 	}
> 
> One tricky part here is that the uAPI currently expects the pages to
> have the private attribute set prior to calling kvm_gmem_populate(),
> which gets enforced below.
> 
> For in-place conversion: the idea is that userspace will convert
> private->shared to update in-place, then immediately convert back
> shared->private;

Why convert from private to shared and back to private?  Userspace which
knows about mmap and supports it should create shared pages, mmap, write
data, then convert to private.

Old userspace will create private and pass in a source pointer for the
initial data as it does today.

Internally, the post_populate() callback only needs to know if the data is
in place or coming from somewhere else (ie src != NULL).

> so that approach would remain compatible with above
> behavior. But if we pass a 'src' parameter to kvm_gmem_populate(),
> and do a GUP or copy_from_user() on it at any point, regardless if
> it is is outside of filemap_invalidate_lock(), then
> kvm_gmem_fault_shared() will return -EACCES. The only 2 ways I see
> around that are to either a) stop enforcing that pages that get
> processed by kvm_gmem_populate() are private for in-place conversion
> case, or b) enforce that 'src' is NULL for in-place conversion case.
> 
> I think either would handle the ABBA issue.
> 
> One nice thing about a) is that we wouldn't have to change the API for
> SNP_LAUNCH_UPDATE since 'src' could still get passed to
> kvm_gmem_populate(), but it's kind of silly since we are copying the
> pages into themselves in that case. And we still need uAPI updates
> regardless expected initial shared/private state for pages passed to
> SNP_LAUNCH_UPDATE so to me it seems simpler to just never have to deal
> with 'src' anymore outside of the legacy cases (but maybe your change
> still makes sense to have just in terms of making the sequencing of
> locks/etc clearer for the legacy case).

Agreed.

Ira

> 
> -Mike
> 
> > 
> > 	filemap_invalidate_lock(file->f_mapping);
> > 
> > 	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> > 					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> > 					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> > 		ret = -EINVAL;
> > 		goto out_unlock;
> > 	}
> > 
> > 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > 	if (IS_ERR(folio)) {
> > 		ret = PTR_ERR(folio);
> > 		goto out_unlock;
> > 	}
> > 
> > 	folio_unlock(folio);
> > 
> > 	if (is_prepared) {
> > 		ret = -EEXIST;
> > 		goto out_put_folio;
> > 	}
> > 
> > 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
> > 	if (!ret)
> > 		kvm_gmem_mark_prepared(folio);
> > 
> > out_put_folio:
> > 	folio_put(folio);
> > out_unlock:
> > 	filemap_invalidate_unlock(file->f_mapping);
> > 
> > 	if (src_page)
> > 		put_page(src_page);
> > 	return ret;
> > }
> > 
> > long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> > 		       kvm_gmem_populate_cb post_populate, void *opaque)
> > {
> > 	struct file *file;
> > 	struct kvm_memory_slot *slot;
> > 	void __user *p;
> > 	int ret = 0;
> > 	long i;
> > 
> > 	lockdep_assert_held(&kvm->slots_lock);
> > 	if (npages < 0)
> > 		return -EINVAL;
> > 
> > 	slot = gfn_to_memslot(kvm, start_gfn);
> > 	if (!kvm_slot_can_be_private(slot))
> > 		return -EINVAL;
> > 
> > 	file = kvm_gmem_get_file(slot);
> > 	if (!file)
> > 		return -EFAULT;
> > 
> > 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > 	for (i = 0; i < npages; i ++) {
> > 		if (signal_pending(current)) {
> > 			ret = -EINTR;
> > 			break;
> > 		}
> > 
> > 		p = src ? src + i * PAGE_SIZE : NULL;
> > 
> > 		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, p,
> > 					  post_populate, opaque);
> > 		if (ret)
> > 			break;
> > 	}
> > 
> > 	fput(file);
> > 	return ret && !i ? ret : i;
> > }
> > 



