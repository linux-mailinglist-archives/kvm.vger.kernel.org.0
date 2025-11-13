Return-Path: <kvm+bounces-63100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B02AC5A9FC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC9904ECF22
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3552432E12F;
	Thu, 13 Nov 2025 23:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="my+S80Wy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64AF32D7FA;
	Thu, 13 Nov 2025 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076647; cv=fail; b=mpZu9v8T8JwWJHBi9M1EiWPwLuA7JFkdEIBU+zz7Us53JXFKZrZl49VlzaD6E3OQXx4rRAgCGERVF3bx5Mr9ABnUiZ0erBAB/AwGusNnHPntzsqdI4vxvGIjSZ6SzrmAWMML1lCgpinfnW33NOFN9z2Y5gQ5uWQfrBmR43uDlQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076647; c=relaxed/simple;
	bh=m2FPFKPLszjGEpQ9mHqOvsqpOizlEhZwggZVibuMT28=;
	h=Content-Type:Message-ID:Date:Subject:To:CC:References:From:
	 In-Reply-To:MIME-Version; b=sok8n4dTrsT3buBilUzWXafcXrq+xCQZ9P79wVHEBfcmNQZKLMLwodfP3rGRzAp/LYEiy5VUflnqF4r7nYfWJ7XBJ+Ivs1QGDyfL0sbKLVWAa4lsL+dLnlsWCDmsYgQVQy/Jer53p/pNFbfZ3hYtNe0ezVyOs8+a6CE6f3rqTuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=my+S80Wy; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076645; x=1794612645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=m2FPFKPLszjGEpQ9mHqOvsqpOizlEhZwggZVibuMT28=;
  b=my+S80Wyfk4FjxtzuP/NG0nIpS5IkpGYZsSAjuCSfPCa3oTGQccML/Mt
   78fc6gd4Gtj9btCZ82SUgnhK2vXZSUCAzqMY8lQfI+Q07wxtu2MJFIDAg
   Ux5gcc562HxyDdy85SXk5O3akGTj8wghrgWPNsCFV1leX3yOTDxVKfzIm
   WnwH+9BcPQWQR2ipLj4+x97sVIJzurIKulXLKj7JRqUk9Wdmvdn9GJCcr
   0BSmwVAckfGsi/cWe0oXiwUQY2B7l3SO65RIPIYyZzPeyP/53+uLHjcOI
   hIQCwzfEUZyvlSX2T6gzPND5X1oAvLqGt6WKJ97xubLAht5w43nJ1Rc/W
   w==;
X-CSE-ConnectionGUID: 0crvi4cySaeAZpdx3uScEw==
X-CSE-MsgGUID: yuuC8EZuTn+vmnzxwOGzEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="69035986"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="diff'?scan'208";a="69035986"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:30:44 -0800
X-CSE-ConnectionGUID: HkdY+7rbReG0zR5DCH+MWA==
X-CSE-MsgGUID: hoQ0fzO5Q02Ir8mhgLMRCQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:30:44 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:30:43 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:30:43 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.20) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:30:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCRsdFB77g0Hu0UIYS2RDP1YS3FALM21nTZg2KXU9DHvHnQ3bWBzicTbEwV5UjOipomZfjTMLOQCs1m4OushI0LXZMwIvVXmVyK5I+NVp4gy+ovAPoyz6ZNegvxjmax/ddNvC+hEbUWo1KJ3UCFOJ1zKbFxiQbtxRZHcBpZ7/0JQDNbU3DyqjhPx2MHZOiJIrNOvpudJOLQs2wgiiOiBKlI35msMeQnunQzM5Lz7P16E5qYVn0NXyqRyaHWhe3FpMmYUE2kroQVQKv6XwMOkReh3HnC6uyjKCo80CcKcW/WvUNk2BcnWSI3aUkNwQnCWASHsHytX265yJRWgQuKoEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASwysHlrfFj8hHyvRvNvNpnqz5f7XEkHvl+LgJmAsJE=;
 b=p+bWqTDGiuVsrH/t+BDPKglSBIG0dUM3hftDNGhdyy/qbPBlyi5lPz2aWhuTZ6GhzkRdoreN4tES2Y/aDrjv5G0t3QrG3iq9HRLe+R5mmE/HPloX2jK97jGeLIAQXiKP4vORsQuk5ftYR1u/E9ngczPavgEvWNMyP+rRodP3MUncFZhPTakZXYZc876y4niht+cRMP3HCFQPEcS+K83fPNrFJs2Z3ftlk+NN/2H5NdytjkRShD75ZAnPbLaeEm5FFB96QM0fQINPzIhXAAyyrTRx1RuLfaIrAwtBgU7HuweREqjrrdyFDlR6G+G5pmtTzGsinr8BOly0BbliyMCqqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB8050.namprd11.prod.outlook.com (2603:10b6:8:117::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.16; Thu, 13 Nov 2025 23:30:40 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:30:39 +0000
Content-Type: multipart/mixed;
	boundary="------------lfkbs1FEXCpgYoZkzywO151Y"
Message-ID: <25c8c533-73a3-4cc1-9fbf-4301b2155f11@intel.com>
Date: Thu, 13 Nov 2025 15:30:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 16/20] KVM: x86: Decode REX2 prefix in the emulator
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-17-chang.seok.bae@intel.com>
 <6a093929-5e35-485a-934c-e0913d14ac14@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <6a093929-5e35-485a-934c-e0913d14ac14@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::24) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB8050:EE_
X-MS-Office365-Filtering-Correlation-Id: ed71a564-818a-4f0b-c684-08de230ca78e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|4053099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WU9WZWUraTFTcm5iODJwZElTazJQVjJkS3k5WldnWUF5SlMwei9raGVwSVB6?=
 =?utf-8?B?ZHFnM2lqSi9PVE02VXgvMkZxY2dqM09TOHJYMmIzNy96Mk1ZangwQ2xtQlFW?=
 =?utf-8?B?V1hQd0xoa2F6TmExcDZWSnhja1lIZVhCRW55TWpCZUc4ME5xRG84ZWovRHZ2?=
 =?utf-8?B?NGt6a1ZqSmNTOGxCbVM5ZlNML1JmZXNBS0VpejkyVFRsTC92VWpwY09rb0pG?=
 =?utf-8?B?aFprZnk1WjZGaVpPNjY3Y045NU82bE9LQ0pKM3FacHMya3diZStXc1pXZEU0?=
 =?utf-8?B?amdIQTc5YTJGK0w4NHJyUWZkL3lyV2YvL3NLREIwQTFOVWNPMGppWlNDc1pr?=
 =?utf-8?B?bzc2N010dHJLd0NpSWVCREZRdDNrWVN3aWpSbTg0bkIyRDg1NytpV2NLZ004?=
 =?utf-8?B?T1JGWCtsbXRkVGJ5UzVIOUJrNnNiLzcyWEl5a2JEWkNqNlJYb0w2amRnYTZq?=
 =?utf-8?B?NThpbzF4Q0drdnRoTGM3QWxBOG0wNGt2ZlozLzluWW1PUCs0YXV1YUgvRHhv?=
 =?utf-8?B?UjVsa2RpUGMvbExFcGxZL0RXNjYzcjBiYWNOMlh5Q3c5NS9KWjlQUnZpUVZ5?=
 =?utf-8?B?alVyRVFnU2dlMkNDcXAyVWdUQ0VNa2FkMmVIaDFaMlVMbGU0aWFORXY1bWZU?=
 =?utf-8?B?STcydHlVRFhrbkRVV1o5SnpVZnMvYk1hZGNLUkIzOUU2VDlwVE5VbktSRWFI?=
 =?utf-8?B?VVJZdkxlVEFBdEw2QmRYekxBNGNGL0tvMURXcVBvK0dUM1VseXM5Yk5xeE5t?=
 =?utf-8?B?UkVRSmhmSHk3VDFlWUtQQ1lHa3JVOEJCVnp4RVFtRnVsRUlyRklwQWNMQnBr?=
 =?utf-8?B?SU9QclBodS9HTitnMGRQWnluZlVYMEhVQkZySnlSREQ2ZVlBRm55QmUvSTA1?=
 =?utf-8?B?OFIrelVNUU9LWVVUQlljMDJjbzkvYzY0MmtCKzFKNVFsRWFiWTFhSk5JMDcr?=
 =?utf-8?B?MVoxRTVJU3NKQ2NQdG5HMHZZODEyR0ZEdElTQW44SGRBNGhhdVF4UEV2RDBN?=
 =?utf-8?B?Mk1pZzRBWGZrRlpRU1cxeUlRYjF3ZWtjZGxBUS9OQUVLWnpZM1BwRUdGZTBB?=
 =?utf-8?B?VHQwYW1KTmx5aFNWVVczejZCR2VhanRKdkdEU3RqZm04dG1vNnVEaEJIbWJk?=
 =?utf-8?B?cUtXamFRdGxGRzY3dm4wdUVmN2pzNGRlOFRPdkVWajFUajg4WU1TTnl3YXBa?=
 =?utf-8?B?NW9uRU9kMHhyTm5VQVdXY2VadXVsY1BHSmVXYmZMY1QwS3RDZW41T2VJdzN3?=
 =?utf-8?B?QUh6VHc0V3dHUXBsdldjYWxLRnRJNXAraFhzZzBUTXBST3BTeTVlc1lqOEtC?=
 =?utf-8?B?MGh1MXUvUC9QT20rZElDT1FOa3RZYUlKY2ZRbjFkSXl3endDL3BOV05yb1A5?=
 =?utf-8?B?WkZwczN1YUh2dThldG9QOHdiUm1PMFdGdUg0eXVaMk14amFETXBueWQ4ZWJ3?=
 =?utf-8?B?YkZBTWdsSTB1dUg4M2FGY3RLTTJCSEZzQS9hYWJ6bThKemtNZGMxdk15M1pu?=
 =?utf-8?B?Nm1rNGtWamoza2xMZEwySmFzcXhMczEvMnNKM09kUmxRRUM5YkRJVU1vS2FG?=
 =?utf-8?B?Y1lURHM2eGJwVlpNazk2WlBWa2ZxaGU1MlRjSWFITUdRenVXOGo5SmlFM1Rx?=
 =?utf-8?B?bTRTa2JUenE2S0t5dnZVNVJyMHlaQURtUmE1bEtlQmFYTGY2YVpxeURtYnFp?=
 =?utf-8?B?SjNnTnZ0ZkYvOGRZbkZFdFZFbjh5YWtRY3VHWFlrcjhaWk15elR0bUVlc0dE?=
 =?utf-8?B?R1lzL2tkZzZxc0JzT21wQU1jemFYRXhzakZmdm9qYU9XM3hKSm14amV3MktD?=
 =?utf-8?B?M2FoM0JkKzF0R0hOVW5qcEZGK2pJTFZmVDN1YUlybUxjOS8rVkRuSnUvL1Vq?=
 =?utf-8?B?ZDZJNDI3VE42UHVHZzd6ZXpOcFJiR1hVN0JaT3FOY2xBZE9oUG9aQW5GVkor?=
 =?utf-8?Q?/ZADsNbUnP6q9C8aGnOPZ1ornqLqe7aH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nzg5VWUyUUR3dDlldHdHenA5aDhYYTBueHVMR2tlb283VVh4Q0w5dGRWWHo3?=
 =?utf-8?B?MEpZZ2ZScGNPZTZwQytZUE1QQ1NQWEU5M3U4a0RWWnpYM1lZWVc1UkMxRjNk?=
 =?utf-8?B?RFJOT0lXM3kxb1FtdVB5Zi9PbWdkYXMwVnZ2QkxQbTRUVjlBWk1EYnRsS0Qz?=
 =?utf-8?B?MStyT2M5OEJLaWFkNVVFVkQ1dGMweTJSNFVCSHAvYnM4eHhMTEp3RXVxZVF1?=
 =?utf-8?B?SEp2QVhrcDRTamZuZ3hPQmZ3QjIvY1FhMm9hQ1ZuUG9wMW5xdWVMM0ZsVHc4?=
 =?utf-8?B?dVlJdXU4cVo4YXVtNnc1LzVzdGUxQXV4a1FpQ2ZqOUZiOVNnVnlHeWgzVVJm?=
 =?utf-8?B?OXJIaWo5MkZCUjZ3QWxVWTNYMThvOGpRSFB0Z3F5bFA0QktwZ2grTXNrV2pY?=
 =?utf-8?B?TFdjTlJSL0oxWlN5TXJ2RDhPbmZadDc2b3Y5ak9EUTBnSFVtamczd2JGdDlM?=
 =?utf-8?B?MXZlczRvQlA5YXEzUDRqd050Q2dSK21RZ3RYelZMeityTjhTTlM5UlZUNm9s?=
 =?utf-8?B?bXdRaEt6bGE2aklQaVV4U3ljenlvSWZNejVqWG84Y1RITWVsT2xjb3lCblo4?=
 =?utf-8?B?YkJ3bFM3eUxlQ2Z0RXVUa0JxWlZSQ2NpVm0yYzR3elprMjBsR1d3WjA4dnhC?=
 =?utf-8?B?SUllWjVWUTQ3T0NpZDRISjFBVDVrdDhVamZweDYyR3k1WmVjZDVvYy9FZHIw?=
 =?utf-8?B?YWdFdzVOY1poUTZCd0xId2VmeWZQMUZqWXVsQUY0cW83cTcrVzlNMjVLdCtr?=
 =?utf-8?B?NW5OWjExNXh6UEJuMXpIbG5SSDRjTGZCTUEyZ0VUeWVIbGdBcXNrdklHRVNr?=
 =?utf-8?B?YTZSclJwQkJ2bGhWRGFhMlI3MzhLT3o0eUZrQzFCdy8vWitsVGlFUjBXMCtM?=
 =?utf-8?B?bmRheUxDWmdLeTIrSTVVR2hoRUtLNnhyQmk5cTJBMjdBdlVqRDg0UFExWFJ0?=
 =?utf-8?B?WEhKaS9XSWgrVysrOG1ubG5xSVpkc0dpY1VhRk03NHZFT0REbFNRL0lyejJy?=
 =?utf-8?B?UUlBUmwrWjVnclZZbjF4WmMxbnZSRUZUeWVPUzB0aG9WRUZJZlBDZU44c25x?=
 =?utf-8?B?UE1VTVNyK3l3RVJ1YlBvOE41N0I3ZGFKUDhEaUhVREZFNHJocll5NEUvckRZ?=
 =?utf-8?B?aEs1RVowOWp4TkZRd1Z1NjN3cDgvSnZMUUprcDZHek91N2NWRzJKYzJuUXVU?=
 =?utf-8?B?ZWpEK0xhWGpzNXRzcHVSME0zVzlOMDEyNnBrdEVsUkFsRWFOY0VpdGR4SXRG?=
 =?utf-8?B?SkNmWmM1WmcyZk1hdlNsMnYrVVA0T2ZjRnIrVjRlbThsbzMwN2RMMU4vb1M0?=
 =?utf-8?B?NjhFdVVzTXVoUS9sUzdDc1FGTUdISzd1NXRzamQxdTUxL0Q2UXpsRHAyRjV2?=
 =?utf-8?B?WkFBQWhzZkl0QS9NeXFHOWZIR1VHcEVnRUd3a29yb0NCVEUzTHNOR1huR1ha?=
 =?utf-8?B?OWpXYlNPeFVRNFZBOFBoR0ZOZnVxZW1talE0Q2tya2U4RW1mOUpRZ1NtRkt0?=
 =?utf-8?B?UGpPdU0vWFVJU1orODhsTTMyZ1N5L1ZNRHk2L2k0SFp1SXpqZ3BaMlJLWHNm?=
 =?utf-8?B?ZWVDNGVXQVZBWDhwNktLcWxYeitqR1dpbnJtT3dHK0d5Q295U2RMZ0N0Z2hK?=
 =?utf-8?B?UE5qZTd4K0YvTzk2aUROOUtiTEM1WlVJT0RaRlZVNzR4M1gxUzZuK0Rvbkhq?=
 =?utf-8?B?UWQ5U20wYnNYM2JQKzVxeWMyZGcwTENJMTdmREM4T2NabGxMWXMxVTJpTHdL?=
 =?utf-8?B?ZUNYc3VSNlFsWFUvSHJ5ai83UXNTa2JQbnAvMGh2R1dsZEFSR2FqQ3dlOStQ?=
 =?utf-8?B?NE5Ja00zVWhJTTR1YjlLSzNWM296Mm5XQTdaUWE4QjRlOWhVWm5YN3FEK3hi?=
 =?utf-8?B?dVBXc0x1a3lPN0E5aysvRTVUZ0FnaWRtcXJ5RjJHUEc1MGI2c1U5OERhZnUv?=
 =?utf-8?B?Z29pUUh0MTFsb1R2ZzBOOTJVKzRQdjI5ODhUcFRqakFCTklqV0NQSTVpMU9w?=
 =?utf-8?B?aHZkS3doNmVzMkF5cjNXTHI5SCsxWlE2akIwQVY0L0ZXR0QyNnJUT2d2Umg2?=
 =?utf-8?B?bFN1ZTgxTUpleDNxRlpvc3B6WExnZUE0OGRxWXF1UmdmWWNjcXREeWc3KzJ2?=
 =?utf-8?B?Z1lzV24vMHRtUWxVUnFOQmxZQkdqaXFJVXExMmJ2akp0bXMyZXBiNitKOERY?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed71a564-818a-4f0b-c684-08de230ca78e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:30:39.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRUMQpVO8qNjgwYBvMpfD10etI5Q3BkfeZE6wzFvkqfLTJquUwEOZuKh5sefKEF9Djh3XWFx0ctCVp7gE2sAq5ceaJ6tz2cxhLqJsfLrdag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8050
X-OriginatorOrg: intel.com

--------------lfkbs1FEXCpgYoZkzywO151Y
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 11/11/2025 9:55 AM, Paolo Bonzini wrote:
> On 11/10/25 19:01, Chang S. Bae wrote:
>>
>>           case 0x40 ... 0x4f: /* REX */
>>               if (mode != X86EMUL_MODE_PROT64)
>>                   goto done_prefixes;
>> +            if (ctxt->rex_prefix == REX2_PREFIX)
>> +                break;
>>               ctxt->rex_prefix = REX_PREFIX;
>>               ctxt->rex.raw    = 0x0f & ctxt->b;
>>               continue;
>> +        case 0xd5: /* REX2 */
>> +            if (mode != X86EMUL_MODE_PROT64)
>> +                goto done_prefixes;
> Here you should also check
> 
>      if (ctxt->rex_prefix == REX_PREFIX) {
>          ctxt->rex_prefix = REX2_INVALID;
>          goto done_prefixes;
>      }

You're right. Section 3.1.2.1 states:
| A REX prefix (0x4*) immediately preceding the REX2 prefix is not
| allowed and triggers #UD.

Now I think REX2_INVALID would just add another condition to handle
later. Instead, for such invalid case, it might be simpler to mark the
opcode as undefined and jump all the way after the lookup. See the diff
-- please let me know if you dislike it.

>> +            if (ctxt->rex_prefix == REX2_PREFIX &&
>> +                ctxt->rex.bits.m0 == 0)
>> +                break;
>> +            ctxt->rex_prefix = REX2_PREFIX;
>> +            ctxt->rex.raw    = insn_fetch(u8, ctxt);
>> +            continue;
> After REX2 always comes the main opcode byte, so you can "goto 
> done_prefixes" here.  Or even jump here already; in pseudocode:
> 
>      ctxt->b = insn_fetch(u8, ctxt);
>      if (rex2 & REX_M)
>          goto decode_twobyte;
>      else
>          goto decode_onebyte;

Yes, agreed. I think this makes the control flow more explicit.

>> +        if (ctxt->rex_prefix == REX2_PREFIX) {
>> +            /*
>> +             * A legacy or REX prefix following a REX2 prefix
>> +             * forms an invalid byte sequences. Likewise,
>> +             * a second REX2 prefix following a REX2 prefix
>> +             * with M0=0 is invalid.
>> +             */
>> +            ctxt->rex_prefix = REX2_INVALID;
>> +            goto done_prefixes;
>> +        }
> 
> ... and this is not needed.

I really like that this can go away.
--------------lfkbs1FEXCpgYoZkzywO151Y
Content-Type: text/plain; charset="UTF-8"; name="PATCH16.diff"
Content-Disposition: attachment; filename="PATCH16.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMgYi9hcmNoL3g4Ni9rdm0vZW11bGF0
ZS5jCmluZGV4IGI4YTk0NmNiZDU4Ny4uYzYyZDIxZGUxNGNiIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vZW11bGF0ZS5jCisrKyBiL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMKQEAgLTQ0NzksNiAr
NDQ3OSw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb3Bjb2RlIG9wY29kZV9tYXBfMGZfMzhbMjU2
XSA9IHsKIAlOLCBOLCBYNChOKSwgWDgoTikKIH07CiAKK3N0YXRpYyBjb25zdCBzdHJ1Y3Qgb3Bj
b2RlIHVuZGVmaW5lZCA9IEQoVW5kZWZpbmVkKTsKKwogI3VuZGVmIEQKICN1bmRlZiBOCiAjdW5k
ZWYgRwpAQCAtNDc2NSw2ICs0NzY3LDExIEBAIHN0YXRpYyBpbnQgZGVjb2RlX29wZXJhbmQoc3Ry
dWN0IHg4Nl9lbXVsYXRlX2N0eHQgKmN0eHQsIHN0cnVjdCBvcGVyYW5kICpvcCwKIAlyZXR1cm4g
cmM7CiB9CiAKK3N0YXRpYyBpbmxpbmUgYm9vbCBlbXVsX2VncHJfZW5hYmxlZChzdHJ1Y3QgeDg2
X2VtdWxhdGVfY3R4dCAqY3R4dCBfX21heWJlX3VudXNlZCkKK3sKKwlyZXR1cm4gZmFsc2U7Cit9
CisKIGludCB4ODZfZGVjb2RlX2luc24oc3RydWN0IHg4Nl9lbXVsYXRlX2N0eHQgKmN0eHQsIHZv
aWQgKmluc24sIGludCBpbnNuX2xlbiwgaW50IGVtdWxhdGlvbl90eXBlKQogewogCWludCByYyA9
IFg4NkVNVUxfQ09OVElOVUU7CkBAIC00ODE3LDcgKzQ4MjQsNyBAQCBpbnQgeDg2X2RlY29kZV9p
bnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0LCB2b2lkICppbnNuLCBpbnQgaW5zbl9s
ZW4sIGludAogCWN0eHQtPm9wX2J5dGVzID0gZGVmX29wX2J5dGVzOwogCWN0eHQtPmFkX2J5dGVz
ID0gZGVmX2FkX2J5dGVzOwogCi0JLyogTGVnYWN5IHByZWZpeGVzLiAqLworCS8qIExlZ2FjeSBh
bmQgUkVYL1JFWDIgcHJlZml4ZXMuICovCiAJZm9yICg7OykgewogCQlzd2l0Y2ggKGN0eHQtPmIg
PSBpbnNuX2ZldGNoKHU4LCBjdHh0KSkgewogCQljYXNlIDB4NjY6CS8qIG9wZXJhbmQtc2l6ZSBv
dmVycmlkZSAqLwpAQCAtNDg2MCw5ICs0ODY3LDI5IEBAIGludCB4ODZfZGVjb2RlX2luc24oc3Ry
dWN0IHg4Nl9lbXVsYXRlX2N0eHQgKmN0eHQsIHZvaWQgKmluc24sIGludCBpbnNuX2xlbiwgaW50
CiAJCWNhc2UgMHg0MCAuLi4gMHg0ZjogLyogUkVYICovCiAJCQlpZiAobW9kZSAhPSBYODZFTVVM
X01PREVfUFJPVDY0KQogCQkJCWdvdG8gZG9uZV9wcmVmaXhlczsKKwkJCWlmIChjdHh0LT5yZXhf
cHJlZml4ID09IFJFWDJfUFJFRklYKSB7CisJCQkJb3Bjb2RlID0gdW5kZWZpbmVkOworCQkJCWdv
dG8gZGVjb2RlX2RvbmU7CisJCQl9CiAJCQljdHh0LT5yZXhfcHJlZml4ID0gUkVYX1BSRUZJWDsK
IAkJCWN0eHQtPnJleCAgICAgICAgPSAweDBmICYgY3R4dC0+YjsKIAkJCWNvbnRpbnVlOworCQlj
YXNlIDB4ZDU6IC8qIFJFWDIgKi8KKwkJCWlmIChtb2RlICE9IFg4NkVNVUxfTU9ERV9QUk9UNjQp
CisJCQkJZ290byBkb25lX3ByZWZpeGVzOworCQkJaWYgKChjdHh0LT5yZXhfcHJlZml4ID09IFJF
WDJfUFJFRklYICYmIChjdHh0LT5yZXggJiBSRVhfTSkgPT0gMCkgfHwKKwkJCSAgICAoY3R4dC0+
cmV4X3ByZWZpeCA9PSBSRVhfUFJFRklYKSB8fAorCQkJICAgICghZW11bF9lZ3ByX2VuYWJsZWQo
Y3R4dCkpKSB7CisJCQkJb3Bjb2RlID0gdW5kZWZpbmVkOworCQkJCWdvdG8gZGVjb2RlX2RvbmU7
CisJCQl9CisJCQljdHh0LT5yZXhfcHJlZml4ID0gUkVYMl9QUkVGSVg7CisJCQljdHh0LT5yZXgg
PSBpbnNuX2ZldGNoKHU4LCBjdHh0KTsKKwkJCWN0eHQtPmIgICA9IGluc25fZmV0Y2godTgsIGN0
eHQpOworCQkJaWYgKGN0eHQtPnJleCAmIFJFWF9NKQorCQkJCWdvdG8gZGVjb2RlX3R3b2J5dGVz
OworCQkJZWxzZQorCQkJCWdvdG8gZGVjb2RlX29uZWJ5dGU7CiAJCWNhc2UgMHhmMDoJLyogTE9D
SyAqLwogCQkJY3R4dC0+bG9ja19wcmVmaXggPSAxOwogCQkJYnJlYWs7CkBAIC00ODg5LDYgKzQ5
MTYsNyBAQCBpbnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0
LCB2b2lkICppbnNuLCBpbnQgaW5zbl9sZW4sIGludAogCWlmIChjdHh0LT5iID09IDB4MGYpIHsK
IAkJLyogRXNjYXBlIGJ5dGU6IHN0YXJ0IHR3by1ieXRlIG9wY29kZSBzZXF1ZW5jZSAqLwogCQlj
dHh0LT5iID0gaW5zbl9mZXRjaCh1OCwgY3R4dCk7CitkZWNvZGVfdHdvYnl0ZXM6CiAJCWlmIChj
dHh0LT5iID09IDB4MzggJiYgY3R4dC0+cmV4X3ByZWZpeCAhPSBSRVgyX1BSRUZJWCkgewogCQkJ
LyogVGhyZWUtYnl0ZSBvcGNvZGUgKi8KIAkJCWN0eHQtPm9wY29kZV9sZW4gPSAzOwpAQCAtNDkw
MCwxMCArNDkyOCwxMiBAQCBpbnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9j
dHh0ICpjdHh0LCB2b2lkICppbnNuLCBpbnQgaW5zbl9sZW4sIGludAogCQkJb3Bjb2RlID0gdHdv
Ynl0ZV90YWJsZVtjdHh0LT5iXTsKIAkJfQogCX0gZWxzZSB7CitkZWNvZGVfb25lYnl0ZToKIAkJ
LyogU2luZ2xlLWJ5dGUgb3Bjb2RlICovCiAJCWN0eHQtPm9wY29kZV9sZW4gPSAxOwogCQlvcGNv
ZGUgPSBvcGNvZGVfdGFibGVbY3R4dC0+Yl07CiAJfQorZGVjb2RlX2RvbmU6CiAJY3R4dC0+ZCA9
IG9wY29kZS5mbGFnczsKIAogCWlmIChjdHh0LT5kICYgTm9SZXgyICYmIGN0eHQtPnJleF9wcmVm
aXggPT0gUkVYMl9QUkVGSVgpCgo=

--------------lfkbs1FEXCpgYoZkzywO151Y--

