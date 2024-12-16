Return-Path: <kvm+bounces-33858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABF39F308A
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 13:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A687018851BC
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 12:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D674B204C11;
	Mon, 16 Dec 2024 12:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEn4sMeY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C124204588;
	Mon, 16 Dec 2024 12:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734352281; cv=fail; b=Jd8kDZ82QhKbgkt1mIMBw3hbIlXVbpMEgGsxvhkyC27Y/BasxtJsn3e3lJdQv6iHPuWlv53vTCZzkcTo8UYkyF3PvPTGivMPbYEkqSwnnmKpCoaeE8qIse0XOq7DryF1uxU9MUfYxdLeQyRTpqdY1kofKrdSiCTLwXJ5Y//17d4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734352281; c=relaxed/simple;
	bh=xJsZ+2AIC6/NSNEBVVxiYmoHxR5sht/VsQkaI6ScLPY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d4bpeXSZwBDo688M9StNe2xYjSLrRSeUIRQpFFDJMJqifeRG8uJ0u7Pq4JzYsO/cE6VDtkP8be9fUKYSaOxFUbYUF5vzz6TF/GzaFp3bcGO09qcVE4/yJRQYMLC30T3HYkQi8jo/AyxoTVdcOXcYehTLbfd6skniRXaKFEWWxFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEn4sMeY; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734352279; x=1765888279;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xJsZ+2AIC6/NSNEBVVxiYmoHxR5sht/VsQkaI6ScLPY=;
  b=dEn4sMeY7+lk1VqeEYAiLWVVdmk6uAj102cvqv+o2XEOQ9V8/2tltbdG
   C/cnK1PW5kBF10ig9hWwB17zBIKV1cHkUpcqv8dxIeDEEtnK468+omEcp
   1KOo/JEb4MHpxqPTzgEAg+VrnCm6uIRngI2Ve9ZM0hYdAu3dfTonSyYS4
   zKWnIhKcjEadVDPgqLl1cH36cKVvh5Alj/rG5a+su0PJMghfQZXDNyUm/
   tNoWKYqMWxqOjsNuVxyL4H80Le39wLjq0jpuTJlp5Adxm6PJyPd5DFlxm
   UIx00oy0DjToY4fwncZ2hHH5+9JuNLPFGchx2N/7OtkjbJ/qTQRMttM6C
   w==;
X-CSE-ConnectionGUID: Snb2cWo1R7+jB1eEIPbLJA==
X-CSE-MsgGUID: nBr4MyFeRXuCSYGqnzW/Lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="37581722"
X-IronPort-AV: E=Sophos;i="6.12,238,1728975600"; 
   d="scan'208";a="37581722"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 04:31:18 -0800
X-CSE-ConnectionGUID: t/CjukOQQ5eSfiibGeXRDg==
X-CSE-MsgGUID: P3p36UipTZ2gDGxCngpaJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101763566"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Dec 2024 04:31:18 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 16 Dec 2024 04:31:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 16 Dec 2024 04:31:17 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 16 Dec 2024 04:31:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+74kXAJqmyVQzWFRl4b7cyPgAXUevbkP+SPOeyuEq9nUFYgI+q1A0F6CZM4j8z/k4+Bz/qI2382VYL0lJu9zAJJWE9d1gLsZQNkQlwaCibzUPOyHsUWDsoyHv7a13AK8mbHfb7kUbzmR5Ny+c41IL5D3BY49/3iLJAv57T6jfoPEHZhJxafx2qjbYsilvTxvtzR23hkhg4wFyScITUGOzdQJlmlWfPJAH4+1fkqrF76NXFFmj88bRIfwxdupMmRzMexvMEom1nk8x1pAa0a/YS5C+AkOmeGZlFvT0QC3gTu5gjzU7iXFZQ2PvwkDWsuKfHTRIuzInrDcZHhZPpbLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6mOO86q+Tw3dEda73r8sRMGIN2jdF9oMjo7T9bHQVo=;
 b=Uw7nvBLBN3uSB+NeDczjqQHKSvykTzdDhvt3SznmhJN5Ey0rYmWn1O85eHDUTn3jaS2z4vQa4cvBTCuZWvAQ2jdW67osNOSU1SomMUyjycgEKqyBBfoZ0Or1G9cD16XBKvZiXgURju8XCB8ajMVwuE2zEMkjounSXxBQQ9hehVr6ePqDh6esBmcFxpkYGE632zE00HfM/9TSRAfVNMPD+P4TiJusChS0gMEfjAbA3OYU3yRNL9CdmD2BHh+kiN5iOMxrKo3gcPrRnf4eFg2CN8LUypWH8VvyrOOmAKMPP7JAfb4a9Gx8ieEeAZnY9n6YTw02CO5GV+HSHUoRNZKytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4913.namprd11.prod.outlook.com (2603:10b6:303:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Mon, 16 Dec
 2024 12:31:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 12:31:14 +0000
Message-ID: <e4873b83-f4e9-4673-af37-261e7a250e1c@intel.com>
Date: Mon, 16 Dec 2024 20:31:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/18] KVM: x86/mmu: Add an external pointer to struct
 kvm_mmu_page
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <yan.y.zhao@intel.com>, <isaku.yamahata@intel.com>,
	<binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
 <20241213195711.316050-5-pbonzini@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20241213195711.316050-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0050.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CO1PR11MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4da785-ac8f-420a-68aa-08dd1dcd882a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bmtIN2NVUWZqZTFEQXpnWTEwTU9NbnJzcUJoaDc0cGlqRWcyeG9zeDVHdTR4?=
 =?utf-8?B?VEIvdEJBaVQ2NngzQVlUeWJTQnUrS00zRjd4aGhLNkpERDYrbzM0T0k0MWl1?=
 =?utf-8?B?eXlQZlNTcXVVM3E4Z2ZZTThjM3V0cXRsaW5PNkx2eExnZ3kxZzBVNDZQTXly?=
 =?utf-8?B?eFgwWFFITXNhbllRVmtONEMwUjRyK3Vhb1lZY01vVy9nYk9wajJVQTZ3eHRM?=
 =?utf-8?B?Vmw3RytaNjVHU0FDZmlHV1A0d25WTlJCeHRnTXVzVjluOENBZ09uV1RwTk9N?=
 =?utf-8?B?MytYZGYrTkwwN0Z4T0xnbzhvYXJyVmFDeDIvblUzNklYK2VoNmgzM2hOaCtR?=
 =?utf-8?B?TEFiM3hncVFGTGVwbGkwbi8rbFNKZ2cwcGVuYVF1bDVtLytnWEN0OU9hcENF?=
 =?utf-8?B?cGhETVB4ZFdFaVVwZE5UV004eUZEanR4dUIvU3cvUmdhWWcxZkY5SEhPZEdK?=
 =?utf-8?B?UWh1eE00V1BYZE1tTWd6TnM5andaSFY2QkZQTGtOZHRtaXVLT2djMUIyd0xn?=
 =?utf-8?B?clp5VXZQSkRLaEkvTWtHQ2pFeGVzVE1RcGpqN1hPWTJzeE1rVENCMVlhbUdj?=
 =?utf-8?B?NXJ5alI1dGtzMU9aQ3dtR1VwazlaY0NTUU14eEc2RXNTUU9VbE5DVnNBbXgx?=
 =?utf-8?B?ZXFKZFIvandKV2Rxd2RaZ3pIS3hBOUpMS3Z3R2NIWElHTTBYRkx1cTJ2NlEr?=
 =?utf-8?B?YUkvQy9LeU1JdUozczBYN0x5SmxnbFYxdXRUcG9GdEwyaTR6cmpINlR1M09Z?=
 =?utf-8?B?elp5aHhVS1lWK2tMaFMrYlhCMlY3OUFZYm90a0xzSUIydEFpUDNabVZTWm9S?=
 =?utf-8?B?cXhwTlZtd1YvTktsRW9ydUdBMy82WnN5cXNnbnE2R2U1Y2xaQTVkQzRmNW1C?=
 =?utf-8?B?WDkyaGc4bXpCTHYyVzVwRlQwL3IvczBjZUEzd1A0bWpvRm11anNVSW4xY1BO?=
 =?utf-8?B?UWViQlhIaGQwWXNQL2xiWncrc2dWTHhUQmR1SkUxY3YvRXF4V3RNMzV6Z3c0?=
 =?utf-8?B?MnlvWTF3MzZ4RURaRUVJcFhUSElMZEpnL0M4STl1Y001eC95cmJUajl3SVZM?=
 =?utf-8?B?T0xCSzd1M0FKYlA4Qi9tZklQT3NHS0c4TjRHSzJJUWZKdWRmcFFrVXJsQ0hp?=
 =?utf-8?B?b3o2ckR0YklROUpUVnN3YTJ4UHUyL1V6NkpwcWIvZUY0N3hramNUS05HNkpw?=
 =?utf-8?B?ZjJaWjRaVjdJNEFmN1kvdnhvRDhpaEg2N3Y2T25uOGxTTUpmcFdPSFZSc2FZ?=
 =?utf-8?B?d2V6VWg5MGpLamJZNEdtNTNobUQ0bkRxTWJnMlU0U1pneVIvRjJpc285K1NT?=
 =?utf-8?B?VDA1bnJaNC94SFVJMFZQU2F3RWdmRlEwTEZ2Wmo3RWpYV3hJWUVqeUVQMkg0?=
 =?utf-8?B?MUhpblpieFlqNUxJWjZsRkRRaHhIZ01RbWUrZythYS81TkdXTzMydHQ1MVhs?=
 =?utf-8?B?ODdXMWQ2cmk2UWhnVjZidzJDWWlRdnlhQm9aVml0NXFvSm91RlFhM2locWYr?=
 =?utf-8?B?RUtCY3RVQzgwWGMvQXcreTNReHU4azlKYUJ6TVhmdUIzSzFOOTc0NmFuNUxw?=
 =?utf-8?B?Y2N0cnRVbU9CZGtlTk9DUDFldXJ4M0lqU1JkbTNyeWVMZGdsbitYcFM1bVFs?=
 =?utf-8?B?QmNvRW1PZUhCNS9OYXcwV2l4cTVZRFlHUDBJK09nM2cwZ1BGRnE5VVJVMkh4?=
 =?utf-8?B?V1ExUTRCQ2ZZaXdxTmp4T2JObjdxNGlwMTZxeFRucVd6ZWJBZ2hvb0Q0UFZW?=
 =?utf-8?B?MU8vNVdoNXY2T2NpcVlZKzdzbUthNHpzeThVcTFkaHgxWmduQW10YTBQMG8v?=
 =?utf-8?B?QUFQVHM2KzA2UWVOenRBbkFoRCthQnNnNlR0dkM0ZmhpOHMxTjlhR25JWjVv?=
 =?utf-8?Q?Zo92cBxvxqMXm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym0vdksvUC8xbU9UM2s1eE50MG15WFhzVFAyVTR1aWppZ1BRRnRiZnZrOW9L?=
 =?utf-8?B?LzJSaUhwZldobkczWE5RVkF6M05ORDZBK2dYTERKanpwaVlkaGgrd2xGV0ZK?=
 =?utf-8?B?QU1vQktzVDZvUDNpYjl3Y25wbllWYUxhbFZiOFF5UndGMUhQaGZzK2R2REVL?=
 =?utf-8?B?bzFsWHpCelFwaWpvZWFyUkQyRDZBYlp3aWlHdnJQV21zdkJKK09SWnRyMWo5?=
 =?utf-8?B?d05JMndOeWNKS05wMnBTRmRoYmVpQ1liSVpHUDlnbElobllyRHd0bktUQnBO?=
 =?utf-8?B?K0FaRVlCbDhCOG9kMmlQS2d3ZFdGMHl6T0IyOFJqQkdFWUh1WDh4eENCYjlx?=
 =?utf-8?B?QklKOW4vZndEWGJEZCtsdC9UNEFZOEZTRzNWZ2VHUExNTGwwM3lFclBFd3ZQ?=
 =?utf-8?B?eEhVM0VFMW9wNGlsYnlVV0tjY2IzSCtPU1YrOS9aeDhRNjRtUmJ6bXVDd2VF?=
 =?utf-8?B?NzlDNVkzSytGb1FFZ0l6ZHhCN3paMVlVb01FR3kxbXdmUFVKYnVWN0JQSDF3?=
 =?utf-8?B?Q0Q1QXI3dTl2TDlDdnc3UmFOOVNocmtrbDArSE9ReWZaVkVobW1qOVRoK2tt?=
 =?utf-8?B?cGxpMVNydUxJRmVxdkM3cUN3SHFRZVpxemJabEswVGI2L0hDSS8yS2xiQUwx?=
 =?utf-8?B?ck1HaHVoU25TcXZXUDBrelN1MWhMZ3dVZWtkSFAxY054Ky80K012OE9rVFZQ?=
 =?utf-8?B?Nitnb0dxNXVob0VGNnVwZVRsR1h2TE5meFJiUU9sNkxqa1pRY0doVTVpK1Ry?=
 =?utf-8?B?UXpCREh6VnhDOXArOVNPV1FMSmc0azFSeFhPRUJBcEQwT1JOeFNnVUNPWTBV?=
 =?utf-8?B?aDNtT3M0MVNlaW0yclJDeE0rY2RSVVArdjhZRUlsdjFqV3NUSGJiaFpOQ0Ev?=
 =?utf-8?B?d0JvSksraHBIUmZkTWJTNUtTa3J0a0dEejh6b2Y2VkQ3S2c5a2Z0L1M4UUpn?=
 =?utf-8?B?SHVBTVFwK1dpbVRFZVRETlQ4UjRBQkY5MHY4Rm5CL1Z1bGhLSVdXTFEyY1o3?=
 =?utf-8?B?bUQrZXNnUlhjcE5HM29QZkdVZDhacWxQbzRjeFQ4SjNFUVF1MTdhMkhkOVJ5?=
 =?utf-8?B?SkJBR1UvdkFvQ2ZxSHh1Q0hremI0eitUbFQ5dGRhZG14WmRCdlFvNHhHMkJ4?=
 =?utf-8?B?N0J2TGZPWXRCUmFqWmpJWmxtaU1WUnpHS05EazI3OU4zODYvYXd0L2JNREp1?=
 =?utf-8?B?N3hVZEt5amV1ZkFvTVpzTGFPKzFUUnI1K2FaUXdzU0p2RFhscTRjRUtjOEFS?=
 =?utf-8?B?aVFwQ3FOOTNyZEYzVzNnUExxN0tLN0N1NWJMT3VzbGFrVHdXVEZKaWd0WHJ4?=
 =?utf-8?B?SkJWZHZUcFphc0JybVgrZ2R3VnhlZ2p6N1o2ZDl4WEUyL0pOczVVN0drVldU?=
 =?utf-8?B?M1UvUWpDNFZ3c0lMN0gvLzVHN0x0clVGMFFXNmlFT3FTNkwxSXh6VUg5NHdl?=
 =?utf-8?B?a2JTZWRWcnRjZitQNVo0SFhUenJHVEtpTEY3UWVnV2czZnRVakxndnJDVSsz?=
 =?utf-8?B?MjdpSjJSTHU1QmVWdW1tZGxUQVczYlg2VlZ2UkRxQjFXSkRxREgrTWZSa2dr?=
 =?utf-8?B?MzgzY0t4b2NyYk1BU29HcE1xUnE1aDB5b3ZXNjBLWGJucEVsZ2hQOEppanpq?=
 =?utf-8?B?d0xpaVZkaXlCRHlIQmpySy9oTUpKdm9kejZPVmZBRy9zUmpsRGN2bHFYR2l4?=
 =?utf-8?B?Si9Xa0F2R2JIejRucDRMZzR0Vjh5clpDeGZ0RnpTY2RZSHZPcWREQmsrVUxG?=
 =?utf-8?B?QjBUSmRKM0ZiZ2NPRk1tcVAvNUlOU0NQNGJweUxmcnJ2ckFybUFFSFZLZlBN?=
 =?utf-8?B?bkUyeE95UXk4VTZSTDdLMThRNDVrR0hNYldKL1lYdG8vS0JmdkxORXJaNmx0?=
 =?utf-8?B?aEZCc0cwNzRsWnZJZ0FCRnl6a3VneW43V1ZJaTRiK1ZicnZkV1dyVWxYOERj?=
 =?utf-8?B?RFYzd3FpOFliQ21sNnIvTktnUzFoUUowZUtHbG1WYU5ka3F2QnNMdERxT1o3?=
 =?utf-8?B?UWdjaFd2OXkxcVYyajlHVFBvN0ZTTjNBYy9WbUxwd3l3RE1SWFM4WUxoZ3pI?=
 =?utf-8?B?dXN4YlB5aHJpMzlWenhnM0FXa2ZoeDNxMUZNQXBydngrdVVSRWFlQ0NGdDlU?=
 =?utf-8?Q?aJFqb+yNadXo+u27XE8o90GI1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4da785-ac8f-420a-68aa-08dd1dcd882a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 12:31:14.9000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VZwXypAc79AqkCSFFWH8at8WpieE5ZGlW7VSMSEIszRyalqJDcyvLwFI+yNEmHxNavGnGnTJrA+K+NzXBP92w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4913
X-OriginatorOrg: intel.com



On 14/12/2024 3:56 am, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a external pointer to struct kvm_mmu_page for TDX's private page table
       ^
       an

