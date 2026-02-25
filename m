Return-Path: <kvm+bounces-71889-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gDl+O+Jin2lRagQAu9opvQ
	(envelope-from <kvm+bounces-71889-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:00:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9A219D867
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BFD93036740
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D070F2DC332;
	Wed, 25 Feb 2026 20:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ops7mPbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7083F27B35F;
	Wed, 25 Feb 2026 20:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772053030; cv=fail; b=R1u+KXqnYPEopjY7gyLD+vFyKTskjrHDS/9xbt7Df2026ZMPoEpDHYPVW8uhG8QNKCjqLhkK/o0E/G181oHcIhsQUvbKQ1pr2L1mrluQLMLLV3NEDx5adwsOccxuXr1GyubV6sFvnmWRocR1gxbIJgst5HvPLb6+bOph6vNDaTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772053030; c=relaxed/simple;
	bh=LSVmocKFL353oNAW+41hCZ5y6zhLQoKRh1JTXq7KSdM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=rM+5RiR8KDBGdSTCh8xYgCkMKCKKqKuJ4vXwDrtlCGH3b+tDZhkgpcNXHmv5DIVpkzY3NHKuvDYFH9k+P/Po4+Mkau6m6+EyO+FKT7GLTJpHhmQ9UQWh0FUOf1bUaXp7cM2W+GccI63z5yfFyHZSouXFutf9PU2Bcio0Yl5QiFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ops7mPbZ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772053028; x=1803589028;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=LSVmocKFL353oNAW+41hCZ5y6zhLQoKRh1JTXq7KSdM=;
  b=Ops7mPbZNoCYtx0sd2vwRB9xYfc8/MMnS/ZgfHxu5RwbJHsPQy1TRzDE
   wNgMmooUNZptmDwqhWSeNE82SfU2ic0GWKbgz1JBDK26lpfJ1U1VFuEf9
   M3wV1FKkEZiR2fDqXhm8Y68dzY1DJJB1nSP6JyQ3tCxadoEt/rnLeJkqX
   KRy3C0lCdoQ+v4j5BTyCQO06QehMAbCfg5K1JYL1RTF8IubSqtK2qz062
   nm5v958uzW2ZI/Sj2lTTrQIlicXw3CCxUvNofjA1n0yxhycq1p+0j6ECY
   WUOfnjeOeb29T+1yxqJfVTM/yYPVfwRst5NR9CTn0BsYgW7JA6JLSmtnC
   w==;
X-CSE-ConnectionGUID: Dud0vZGpTQqB7OjEY0rE2A==
X-CSE-MsgGUID: COGeZs+iS5GPkAmfjCwyrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="90517690"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="90517690"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 12:57:07 -0800
X-CSE-ConnectionGUID: 7X+YD273TmGUoUSMttdf3Q==
X-CSE-MsgGUID: tPQfCLSuQfaFVHYBP7RQug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="220850099"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 12:57:07 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 12:57:06 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 12:57:06 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 12:57:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJ0rgXmo0TonESCke2TJzCHug1zkttkVqDrMs9mIEyntHg7Ep7EJNSSMTf53N1obWaLVeaZyr8oVfdPyKnGE0I8FAHxulIoEntoiv3p1rrlIBv/vekZCZQHvNWC8AolWMokGLmIHkV8DMXIC5buSslwmaJhLt57WOFxuObcgcHeBSFfGcfhwF/vagIENy/FbzzbgZcq00UTvRuiuD0NkTIa4yTiagbyKcUjNSEzstDkE5/CIbGZYEAB3M456bGadpEXgRyU3tGwwax2/722PNyJfIcKgnlq7BUteadgUlez7fQbXFd6UG3HDbKTrcLsD4rUZfViYsldyaCE/jwfPXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miCKiydYpeTsgR0QsoTfZZWy9kavSKOd5Z2cVO8mY28=;
 b=P2ahoHr9vJyFlptiV3AhUr9Au3IS8a6/3KgWxzgXaKRsET3CztOm3YFMpLew9Eu+NKH8lBbeUeSyHb3zwT5I60QOIPgILULiTGEIII20PhKkpkjhmnWEWnIa0yHJFtxFA/kSRu/erSAUvKEw+n/so0tpwY9mmr1a9CrvmqMUjDBXmSqiBUFpX/TtG9N+D4uSZztW1al5Gf6iujB+8vtVZjM2iJ+qxxk7zNcRJ9VBew2DppYtaU58DhkgRvufhp8T8eW4OnwdcJjt6bmSiltQ5VrGAFyD9mRnS3qs2uqdDBK7KenFYbaVqcnJY0NWwk+S+ao1QH+sunrPD1MOm3YnIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 20:57:03 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 20:57:03 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 12:57:01 -0800
To: Robin Murphy <robin.murphy@arm.com>, <dan.j.williams@intel.com>, "Alexey
 Kardashevskiy" <aik@amd.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>, Neeraj
 Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
	"Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>, Andi Kleen
	<ak@linux.intel.com>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Message-ID: <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
In-Reply-To: <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:217::29) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA0PR11MB4542:EE_
X-MS-Office365-Filtering-Correlation-Id: 50bd206a-939f-4384-d519-08de74b06d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: OeIVsMd0wDe6hWCO1NP86uQf/k55GN1NkxKouHxtw+7EfUl6OV58veHjvnmYuTAPHDVhaKe/6I7PotmFf5wfOwnfRkAaqzoaOAP4Hnm8AGLnrkhCEiGwt0haV+HtQUyHilV7yTZGvYygSGYb9bAnYb2Hoe8BaK5ARbCjT7CpL/jsvVNBKit/ziyOkWnPuSuQTnxQyBJv8Md83PYkSVACXcfdPVx/PMd0HsRNwtiS+gr7qZ6oTtx7NavkBe0EL767yXkdVAV3M6TGOng/xCGUY6E9Tc4xXqzoqpTDhKuAGkCxnmzp6i8c3EMXqmqpXJySPsnH/2Mja8Tm4LbPAT6FFYN744KKgw/0eDxDB1c4fTVmBlYCPpLjfCJN6mmR5ch/GT/0qN7DbBXFzUA1aTPknEh+ln9AjEpyAWFsF8dYEmM4Dkd8R2mBGVpkkwr9j8V7vNCETAl8mnbteHFmS14a4rRcsCoG09XCGqJarBGBVAWBYFfpC/2dhs/XT3lQ/F7Lh+dfgzvf2yTS9r8xkRJYNSuzRhYkw/+TWGF4UI2sUsQQDoViQuIGwdU8QF0fiPoDerPO5Scwsaki+kuslQtfv/32S8xeBFFRliwO72elZDlDHrjxBb/PfxyCfwgOEh5bj4pG61OsGmFY6sQFqQP15OIwm8eJI7yMJFKMRRNl/bLiY0pKAsr1uNR5oyI+WfzB3W7imWSIBslWNlEaXKnGMg/2FaR56C9OXKFKSwB9OMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MThFY0FYM2p2SG5zaUJoTmVWeXd1SHg3NmdiUXlUOUZDc2ZXRHlWQVQ3TUR6?=
 =?utf-8?B?VDY5YTQxeStxeXpuanBBSjRUK2xJbGpLc2Jsd3Fhc1NNSkZoTWJXZEdkL1Ft?=
 =?utf-8?B?Ni9CTGU2TUFObXJiOFVBZVgyMFRialhrZWxlRjl0aWs5aTM5Y21SOFJLK3dB?=
 =?utf-8?B?Wm9icUNZMmlmaG1jOEhVZFNMVS9lRC95bHpiY0ROZm0vUlFNQ0hPRmhwWThR?=
 =?utf-8?B?LzlIb0J2WVU0MW5MUk5SM2dNcFJvMkJxZGp3UGRXR09SYVZvUENTSWUxSk9m?=
 =?utf-8?B?TkNaU00wbU55NzN4Nk5Ja0RqeS9HMkdtNmFzK0xKOHRzUTladzdkV2t2VXFr?=
 =?utf-8?B?Z05JcnJ2UVVuckhsS3UzSXdDRWtDUzhQRVJ2Z0p4UklLbFVMNVdvc3BuaEtt?=
 =?utf-8?B?WTUwdjVHQThBQ1FYMVF6RzBob3N3REdHMmM1RXhZd0hOMXdlbWRNdzBjRm85?=
 =?utf-8?B?RVFMOGVzNXpWTjl4Uk1vQ3VKeTM3Zy9oeUF4dGI0bFVmZlJPRWpyZ1FObE44?=
 =?utf-8?B?eDk2MUxUNjRENG00NGVzUW9rN3RkSU14RmtnSmxaYjl2UUVIa3Rxb3F6WFhv?=
 =?utf-8?B?dHZZMFRTSktBY3k2eVVQVU5jTEczWERqZ3JZWGxvR0ZMOGRjWXJkYWhTMlNa?=
 =?utf-8?B?NnloUGhkYVlKV3lmaHRQeHNUa1VkeEhVN0dVQ1Jqd0VON3hYQkw1dTh2Unc0?=
 =?utf-8?B?ajl4ZFdCaEtJSjdmUHVINXkwN0tYbXltU05TTS8zeXJYdlRnQlhxbStnZjBu?=
 =?utf-8?B?Z2pETWhmR3RsVWZnb3ZBNDFwcWs2dmh4ZWdIcy8vdDVoZEpiOUUyRWRFa0xI?=
 =?utf-8?B?clllS2JRbDRsZHNQRnBRUlcvOWQwZU1tZGVaTE4vZkxBNFlDb1piVzVXR0ZW?=
 =?utf-8?B?eGx2Um85NnFTdnhBVElLTzRLSm5NbUF2WTMzeW43QXFsYXhRU2FFVlhJUG04?=
 =?utf-8?B?b2Q5WXIydUlNejVkSDNVdTNhdzZ0QksrMHJYaVcxUWJONTRCRVNKbEdpdG9S?=
 =?utf-8?B?NElmY3Y1YS9xWEFoZ2dIMVlrZFMzK1E3eDZUd0ZheU93cjBKR29iVlB1ckwx?=
 =?utf-8?B?dFVQTjVvd3g5NGJRSUhtZTNIZ0hIeFE1bjRpR0xvN0lZcElpbS9WdFdSN3R1?=
 =?utf-8?B?T2c0Y2lFbUVhQ2RpSUkzeVk1NmFVZVlLNkVHdlhrd1R2Rm5Ub0JqTC82clNU?=
 =?utf-8?B?U3ZvU0pleEVxcVAzYzBlT3pWZVpKYlRBaW1qalhOY3pPNllPekxlYkMrWDBu?=
 =?utf-8?B?R2Q3UkVtMHo0RktMUmwrai8yYUcraTdLYTdEc3pQZkFVaEdNUzRvS01Od2dI?=
 =?utf-8?B?cGRIZWlEWHM4MWFESGpPUUJGaXZrVmpUYkZvL05SQmFvRjNKOU92K1RKRkRw?=
 =?utf-8?B?OVRsZWpId3JWNzBBK2pINkh4cEFrMVhqOUdITWJjdkxGUmF2bk5jR01BSVFq?=
 =?utf-8?B?dG1jWUI3aWU2N2ZFVU5pNHBOdml1cGtDN01pTFFRcWs1eTR1L3FoY00wUUN0?=
 =?utf-8?B?VnNvbUQ0amluUzJJTGsyZUZnZTdOWjhpUWIzK0IwTm5tcHpBc2wrU3kvWUpw?=
 =?utf-8?B?RDVSK3o4cjdEc1d3QVlzQzJyZU13aGhwYUM3MmIxSXpFRWEwdEE0eE9ySjBx?=
 =?utf-8?B?cEJ0VGI0SENEVW5ndTdvTkpMVm9Gd1lsM1l2amZKbTFWK1N0eWJiUlo4ZXVC?=
 =?utf-8?B?dDhBbVArMmIzWlVzaW13WGpRRWxyRzZqZkRlbXQ5cHlqY01wS3lRaGxZSzlV?=
 =?utf-8?B?bVJEN1NQbkNrQmdJYmpWYWdkYTc0dE4yQ0dUekxiQ0Q2UXAyM3EwUkRnZTla?=
 =?utf-8?B?ckd2SUcyQ0VnSGR1Y1Nnb2UxN0NvU21TWGxXdXowdUJxSmVwWUYyQU14NzVm?=
 =?utf-8?B?aTB5a1lSMS9IYnBlQ0NwbzkzZnU2OTJkQVVSZ2tmaFUrVnZjR05odzVtdHN4?=
 =?utf-8?B?UFlVdElLdE02NGVNQXRrU3FOdXZvNUdOWTB2RVVCMmU3S3dpQmM1V2Rsd3pY?=
 =?utf-8?B?Y3VOZVdEQkRLN0EyMjZWRkpkS203Q3dySTBCRW8yVkpGd1hWZllkTXlubjhW?=
 =?utf-8?B?TUw3UUtCR1B4SXRTazBpci9jdTdTaUJZVjVNWUg1U0xtV2l4cUZXSFk5S0wz?=
 =?utf-8?B?aGZaSHpyVkh3ZTIvY3N6ei80TFZYb281RlNUZ20xRUo3a20xSHYrd25zdmx3?=
 =?utf-8?B?bTBBYlFsRy9qa2NHUEsyZkgwVVRqT3lQeGd1bG96b1FTQmIrZ21EM2lsQnBt?=
 =?utf-8?B?SVV2TjYwQkhvMGtrUkNZY1pLRnRNc3hQL2VVclU1cG9Fc0MvdjJkQk1WMVkx?=
 =?utf-8?B?MHBSYjVST0lTT2k1S3llOW5XMG1ORnVIYXJwc3FuUDVGME9KSzBqQXU3SUQx?=
 =?utf-8?Q?EDyuipEEYqtN4iMw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50bd206a-939f-4384-d519-08de74b06d67
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 20:57:03.3679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLheXHL90z7rOJlVBlQ7lToy4XYPwJyDWt2yDYT8iEmrU3XdGut+8rIyMnKCVUO+h2JHgDS7o4+TPAWEZ0PYz8p+t6rTEeslsp2mLFobddE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4542
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71889-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	BLOCKLISTDE_FAIL(0.00)[2603:10b6:510:256::6:query timed out,100.90.174.1:query timed out,10.1.192.143:query timed out,172.234.253.10:query timed out,52.101.46.65:query timed out,10.64.159.144:query timed out,10.18.126.90:query timed out,10.18.126.92:query timed out,198.175.65.10:query timed out];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 8F9A219D867
X-Rspamd-Action: no action

Robin Murphy wrote:
> On 2026-02-25 4:30 pm, dan.j.williams@intel.com wrote:
> > Alexey Kardashevskiy wrote:
> >> SWIOTLB is enforced when encrypted guest memory is detected
> >> in pci_swiotlb_detect() which is required for legacy devices.
> >>
> >> Skip SWIOTLB for TDISP devices.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> >> ---
> >>   include/linux/swiotlb.h | 9 +++++++++
> >>   1 file changed, 9 insertions(+)
> >>
> >> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> >> index 3dae0f592063..119c25d639a7 100644
> >> --- a/include/linux/swiotlb.h
> >> +++ b/include/linux/swiotlb.h
> >> @@ -173,6 +173,15 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
> >>   {
> >>   	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
> >>   
> >> +	/*
> >> +	 * CC_ATTR_GUEST_MEM_ENCRYPT enforces SWIOTLB_FORCE in
> >> +	 * swiotlb_init_remap() to allow legacy devices access arbitrary
> >> +	 * VM encrypted memory.
> >> +	 * Skip it for TDISP devices capable of DMA-ing the encrypted memory.
> >> +	 */
> >> +	if (device_cc_accepted(dev))
> >> +		return false;
> > 
> > I worry this further muddies the meaning of the swiotlb force option.
> > What if you want to force swiotlb operation on accepted devices?
> 
> For that we'd need a whole other private SWIOTLB plus the logic to 
> decide which one to use in the first place.

In this case I was still considering that swiotlb is still implicitly
only shared address bouncining. Indeed, a whole other "private_swiotlb"
mechanism would be needed for private bouncing. Not clear there is a
need for that at present.

Even for this swiotlb=force for "accepted" devices I only see a
potential kernel development use case, not a deployment use case.

> option to forcibly expose all DMA through shared memory regardless of 
> TDISP and friends, that would logically want to be a higher-level CoCo 
> option rather than belonging to SWIOTLB itself ;)

As I have it below, yes, CoCo opts into this bounce_unaccepted mechanism.

As to your other question:

> (since a device that's trusted to access private memory
> isn't necessarily prohibited from still also accessing shared memory as
> well), hmmm...

The specification allows it, but Linux DMA mapping core is not yet ready
for it. So the expectation to start is that the device loses access to
its original shared IOMMU mappings when converted to private operation.

So on ARM where shared addresses are high, it is future work to figure
out how an accepted device might also access shared mappings outside the
device's dma_mask.

> > For example:
> > 
> > @@ -173,7 +176,13 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
> >   {
> >          struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
> >   
> > -       return mem && mem->force_bounce;
> > +       if (!mem)
> > +               return false;
> > +       if (mem->force_bounce)
> > +               return true;
> > +       if (mem->bounce_unaccepted && !device_cc_accepted(dev))
> > +               return true;
> > +       return false;
> >   }
> >   
> >   void swiotlb_init(bool addressing_limited, unsigned int flags);

