Return-Path: <kvm+bounces-51759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3D4AFC8D3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 12:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E15A1BC2907
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C3E2C374B;
	Tue,  8 Jul 2025 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cyi6nPIO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C16527054B
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 10:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751971704; cv=fail; b=Xu/C7TTmVfrnkXqeX7sMAWHIhMLl+JGbtpIbVAASwLqKbM3BNsY3ceCoPIV5OP2nnZTe4ts8mrGFjX40+IQwyR8XXNTQKjgMYSRcim07sATRX4fkMQaB9pQqjiizayRlPi52tBUa0VovkbXY1hROArFNq7lHqCWP2gvyu9bNXks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751971704; c=relaxed/simple;
	bh=Jhp0Ukooigzl8AWuKMFiS9mXAfqbmKoyhb+ws2lwuVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jy+hhV7WEsdxsY+5JpCiluIxRW6mrSVCwSa/4d5wg8I0G6gN1xV4KTas7TpujDPY2r7SCsPWIydkB2sjTnVrog+Yp0GKTT0jEwuup0anY2Iclf40LQNCh4yw1DOtA8mR+NWkq5UxQ9nuH7mLqQ4KHKrodSC9R6gSzisB2Vi9daw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cyi6nPIO; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751971703; x=1783507703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jhp0Ukooigzl8AWuKMFiS9mXAfqbmKoyhb+ws2lwuVY=;
  b=cyi6nPIOLX+TB6lx10fb+GnSUPjTjfbSE4id2W0g8rZGkkvJN1m5RPwf
   ukmLG5KjYBjVSQS/OZyMPoipBZkbB7O1mwgE+Vm1A5G4aXmDXNxCpqq2T
   AN7Y633AmYzwKFcKilDgOppeWAZZEeHqUjiPDMHL3/+tJeNWq6BrUiNqB
   F+yu+/w9Ee4FTYZrwuzNig4hMnepF7h6YAtNjIlU1SL3ty4gJEoMCBmgE
   x9a/MPB/qycs3Ai8vADcQwzlZjR6TDftH93nOdjFIaHp5lIyTq+Ts3uM0
   mvbzbw2RqRngF2UvuwsDBxevlRbhhlQf8hWVnhlkFDs8kKGGamuJ2mMaR
   w==;
X-CSE-ConnectionGUID: O7qmTPbUSWewIYftnBmkuQ==
X-CSE-MsgGUID: mX08/pgDTRKMa/P39o9Tiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71787592"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="71787592"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:48:20 -0700
X-CSE-ConnectionGUID: wlhsQ1CURQqoAcraaX0NQw==
X-CSE-MsgGUID: NnYZQZBLSI2u+Gu5YEJAog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="186421163"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:48:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 03:48:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 03:48:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.85) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 03:48:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qS4dApBVCI3nV/SuK+uihMSNYReW6cYfZ3VmTWImrWXACM2yedqmEy6w8XV7zRcTZ6J7/LmRLZtYBREMlJi7IGH9W2H3BoK18V6AV4DIbCzU8eU77Xk/iXqZYUQ+eyd4d4BNyqB6ZiCmGRAHqfXFk+OR9OIJ6A0Iq618XSZtPmUC0RGTJNwMlvLRO/xDffGIW5fWcDVzvfg+dzCny5c/TlvHnHRstlI4FUVCUVQ1mT1XTYM04VbOMolWaBiq22DVSRwtMwH4JBQqk5JOg0qLudGAEuvxwzLxZffB5N699Zw4pSo1scWyIxLdRR0xPvKAFX8hJ8msSCRx/2ITcvs8Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jhp0Ukooigzl8AWuKMFiS9mXAfqbmKoyhb+ws2lwuVY=;
 b=fphQ4uNlo9vzLsT7YawFrMcxOsxUpB9eAMwbjjOw3+Zf6DfIaXK8wpa3S4qFVOwojlbR2grb3iIaUNBz5AcMskTzkaFkiXqNc8hJc9qqwk4NlOB6Rug/R+nm/9xxaY19SnNMoXT/83KUVR6CRVjOQxIDV11zhO8QdILwPoEypeWkPxnSpHVs+kseWS8opELj0/rDESwNMPpjNEg4J7iYofj23JuS4+zxyUUaYvbRYaOGLHuoapec1589/2MxFs0Pqmd7nZ2nfmG/cghlGANmANUNtwMhfYFodm3p2dhcdvG3QD73IzeC6s5kaK/3YRXXOOHi8iV0RF3ut6XPo7qT/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6858.namprd11.prod.outlook.com (2603:10b6:510:1ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Tue, 8 Jul
 2025 10:48:00 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 10:48:00 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb7yd7VfkdP/oV20S9Gj+gph7qB7Qnf8YAgABJtoCAAEO8gA==
Date: Tue, 8 Jul 2025 10:48:00 +0000
Message-ID: <fec4e8dd2d015ec6a37a852f6d7bcf815d538fdc.camel@intel.com>
References: <20250707101029.927906-1-nikunj@amd.com>
	 <20250707101029.927906-3-nikunj@amd.com>
	 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
	 <57a2933e-34c3-4313-b75a-68659d117b14@amd.com>
In-Reply-To: <57a2933e-34c3-4313-b75a-68659d117b14@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6858:EE_
x-ms-office365-filtering-correlation-id: cc68f225-9e1c-4d92-4aeb-08ddbe0ce893
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MWQrVkVtZHlKaE4xNzZhbkhrT09QZGlNdHp2WjIwVUxEMXRYaUNocVEyWVQ1?=
 =?utf-8?B?eE9YRU1jK3hTYWpXSUhTd2NWZlRLTnIzZXdDQlFoQ2JoZ0kvWVFQeGJsR0l6?=
 =?utf-8?B?cW5VVUxYaFIvRDQ1MlpwKzNBK1lqMXBTTGVZWjV1UEhaOEhtd2ttQ3lzUWQv?=
 =?utf-8?B?Uk8zMTBuQ3NCZEltTXE3dkdRVlYvUnordWxUZW5LRGVQOTlMVU1LV2w5cEEz?=
 =?utf-8?B?V21tN3RpVzR5dnJiZkdPUTQ2OEtPV1hvb1VYM3RiUUQyVkZBVEpFVkZkM2hM?=
 =?utf-8?B?MVBDSWo0OUtGdithUjhQRlhOdm9vN1E0c21aZXdraEw0bDYzY1JXSGxXWnNU?=
 =?utf-8?B?VWdHS0p5VE1jekR1OWFseExCVmlnT1M5NWdaV1RHVDd0YmUrQ0dRQUdUcko1?=
 =?utf-8?B?eEN5YWxnekl6ekhFckY3NUhNL28rdCtaM0s0SzVzN05ZNmxoYkRTTHZlWGpu?=
 =?utf-8?B?KytZdnk1bW5JS09YaUpjWXNBaU5zS1JmdEV5VENEWTVTSjBPaWsvdGRvREhN?=
 =?utf-8?B?b0QwS2UwVTFiOVNqRjJ0VWFFTXY5TWgvbTBrb1NEeUhqME9nWTU3WkVGU0Vm?=
 =?utf-8?B?UmxYODhFcXdaTmgrRWtVQjBrUGFyVkp0ZVUrVGNRN1BzaHBZV1BkMGVybmhk?=
 =?utf-8?B?eWsvOXRwZnpWZFZyUnNtcElFV2l0NUVzOVlNajlzOGp2U0k5K1JjbURVQklP?=
 =?utf-8?B?SWlSMWY3VkxGV1JOZC9RdWV5SXNGS25jN3lvN1lKdHEvd1lFbUlYTy8ybDlS?=
 =?utf-8?B?MlNDcE5iSmhXNlZLdThkOXZtbGxLOVA0Z2JwaktTRUtYVWpWajhNQmFDcVJB?=
 =?utf-8?B?NmZTR1dkVEJPNjl2VEVQbnhOTmZ6eElHZEhuU204THZDZmFjMnY3aUZqa1Nm?=
 =?utf-8?B?T0V2ZWxNeEk5cFFzOWd0ZHB0SGRHRTNHQk5nallBekpjVWVITytQUS9ndVl3?=
 =?utf-8?B?Tnl3TnNvU2xUeTUwM2l2SVFIcVZlbmlhcFFDQzdVWWl0ZmU4RVF4MFBrQXBT?=
 =?utf-8?B?bkVvTDlBOFVjMkJUVDYvU05GekV0aEt2ZDRUQTM5cVVzTFBzZVpzMjBYeDFz?=
 =?utf-8?B?b09oYVBMd0NkZnU5ei9BNzhlNnkzdGNGb1BMc09qd1BFWGhSR3V2eEF0ZktX?=
 =?utf-8?B?RWlKcENNdCsyWjZYbUZkbU9vVzdnc3VJSktoVDY2NWN0eFRjNW1BTEw4WmlQ?=
 =?utf-8?B?MzUyUjQ5aExETEViREhSalpsaUVOOEJlSHQwR3QrejVUWSs1eU42YW9kcXNl?=
 =?utf-8?B?T0FhMnFYVEc4STlmL2E2bys5am8wL0dtMjFwTWdxSFErWE5mWDRmR1pPRTRL?=
 =?utf-8?B?R1I1ODg3dzExSmtET3d5Tk9GY1d0c1R0QlArajN2TzRza1NjL1NaOUN5Wjlr?=
 =?utf-8?B?MkxzTE9uMm0zWk8xTlBHenFqOXVzeFlHMHJYajdXZnBoL0QwdEhMeW1uTHky?=
 =?utf-8?B?Q0t4VXFoYzVXY1pDbGVHSHBqUDJHNWdlUVRvbXFVZjF5RUx0cnZCZ0J1RVRX?=
 =?utf-8?B?TGpCTUdXRS9xeFBVR0x4T2hRYjBLS2xaS1dFTm5BYWMrcHNVZTlWY3RZcStp?=
 =?utf-8?B?QWNNTnVBQWVucHF2RmVEeVZFdTl3cjdTQUgybmxtNFQ0d29jeVQ3TTFLcWVL?=
 =?utf-8?B?QnE4L2pjTTFoWFd5TzBmWDJWemNsUkZFTUJnMkgwTWZKVDh1RERwVFZTL0xV?=
 =?utf-8?B?VkM5RWhKU0tjNmFUUnFzZnFjVmJ0ZDVpZTV5aXUzdXdBY0l1ZVVTWEVPYXZD?=
 =?utf-8?B?a3RheTcwSlRwZHk2cWliSkxGYjZKdFYrMHBLdnZjdnl1M2lPUmVmK2wzNFJn?=
 =?utf-8?B?ZGtyWlc2aG5uVmNNMFJjcENrR01ObkVaZldHcHB0ZjZUazFTTm9paUdpbkRt?=
 =?utf-8?B?SWFGeHdlUzV3TWNqaEp4TkQxMGFpb3RuYXB6VkJmT21YY0tKWmZocW9OZ0JJ?=
 =?utf-8?B?M0d6NFJjTjRkWjRTNExWWUthL3dPNHBiS012NE5TcktRV0RzS2Z3NTB0UjN1?=
 =?utf-8?B?TGNSdkRqZDhnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzdVK0duSXpjdVJnNHZrd2E4emtiS2t0c3J6dTJKRXVDcGY0V1FrSDFJdXMr?=
 =?utf-8?B?cDVqMS9KZXE3eHIwaERrZCsvNzlYeE1QNmN6Q0tNcy8zUUlBVC9JOEYxZ2xo?=
 =?utf-8?B?R0h3Q0ZpbHlNWlNjZm1XbWd6WUhEajlTY0pxeWVzcXgzWnJjREZSQjN5ak82?=
 =?utf-8?B?QXVITllJYWFBQWhmekJ5N3l0cnNxa3BRTWZ4MFBaeDRkdVpZMnZPYzRCa3N4?=
 =?utf-8?B?a3ZMa3kwL3J6bVhISFpEUEY3SlgvYUtoeENBV0MwaENSempmVGdqRG1hclly?=
 =?utf-8?B?cUcwYkxWTkVYQ3Y4MkpDVkdvZmd3Ny93SXZXNkdZNHRmOTY2aFRIbGpkcjNw?=
 =?utf-8?B?bWNsZEcwdmhVRVJZNEV5K1hJVHVqZ1oxSlVPYVViS2RCZ1d4U04yMlJ3aW5S?=
 =?utf-8?B?Mk11QWlkQ0Zid1NtVzhEUDJBeXc1Umw1aFpWbzZKQkJkeDloKy9CWjcrNkJQ?=
 =?utf-8?B?amwvOTRtZ2xqMGgvVzlqbXdWb3ZsMUZ4K0xtd0Rla0RPTEY2Nkd3Y3dQSDNx?=
 =?utf-8?B?L3NHSTQ1TDZtTytQNGxCZXY3VDk3ZW83dkhOOVI4WW1adXVURTNRemN1U0lN?=
 =?utf-8?B?NkJ1VHROVWRkZCtNNEFmQzRJUXllc0htbEZGcUdlaVI1WHdzeW1iOUhFamU4?=
 =?utf-8?B?UjdZUGhqdEVneWpnRjlHMzF3S3c0Rk1SVHZVOEtHcktpbzNZdEp6eHEyTWlm?=
 =?utf-8?B?emdrRVBoNTZlS25Nalp5UEJ6L045eHdncHVyYXFlS2lmbEZvQXRXaWVGMGUr?=
 =?utf-8?B?Qjh1R00zSklrOUJLV1VNdHhOakJtbmVubjMyc1hNeXc2alZBWmNsWXNybmcv?=
 =?utf-8?B?cWhXV2V0VGpuL2s3eTYyRXQ5M1c5Nkt3WW0zc0lpeVQxYTlmOWF2UlVNVlYx?=
 =?utf-8?B?NzRBb3diSlZ3aS9RWG1JcWh0VTl0YUlLVFVGMmdObGdvN2tMS0dQclpYWnNI?=
 =?utf-8?B?N1VTZndnMGVYT0Y5c0x4YW0ydVE4VWhtbFl3TCswejliTnBaMCtvVUMwVHpH?=
 =?utf-8?B?SWRxcFdIenQvSmZEUVpGOHFLTThZNjI0NGpIeFpsYm9BdFVnTDJDcjVkMEdP?=
 =?utf-8?B?UmIvSlJWZVlYVzMyYWRoYnJaSnBDMVRNR0c2OVdCMmFVdDdvTTdqeWYvdFIz?=
 =?utf-8?B?TzZ6dVBRbG41ZVBIWXgwT1NNakhMeXZlWjhRd3dMZkFqTzZzcVd2UnZmbmk5?=
 =?utf-8?B?TUZQb2NuVmVRNWNsRkM1UzFadC9VdmJyTml0cDBzTThNTmJiUlZuVCtkeGJQ?=
 =?utf-8?B?dzVnTWRhOFVwS3BUUWtrb0tMcjZTRHZyVG5Qak9GUXR6d2JnTWxHbmxTdWNR?=
 =?utf-8?B?MGFMMytwOTNYZVZKUW5UTnBJSEZhdTFtOEZpVEx0amtGRGFyQzdpTTBLTmhk?=
 =?utf-8?B?NmNxLzUrOENsYXI3ZFlSK0VHUWZuM2QvbzEvNzZWRUxla3VPODQrY04va3hU?=
 =?utf-8?B?YWVHRDRoYzNJSjdZcjFkYjlZeCtlKzdhVy9nOWhvVVR1ZGp6V1NKUFU1WFFp?=
 =?utf-8?B?djVUcEN2NUdNVkJRdjQxazJ4eVhMV1g0djl0cHZnUU9XaFJwWXdadnhUNkE3?=
 =?utf-8?B?U285TUdIcnV0cWg0STJuYXhQZ2dBbVBGK0R5bU0vTTIvd0Z1cTY3WnVBNE5K?=
 =?utf-8?B?NWNvWk1mTmJiNXNndXkwRWpXbkRwdHZheWJEZmR3Z3YrWTdYeVpJWTBPYTV5?=
 =?utf-8?B?Q1Y2UHpETVBIS3Y0WVhJNURoanZxQ2V2SDJsOFV4blZDbjJ1eExWdTU3dHFu?=
 =?utf-8?B?VnRtbXZ1ZGxLRXdnNCsrUUJQcnB3VXdKY2l0akJ1RHZUMUdoVnZxT3ZFZzkx?=
 =?utf-8?B?cU1UbnJxK05xdHBXYllzL1NqcnEzUHhHNWdSODBOUlF4SmFJZnhTQ0JkRG1L?=
 =?utf-8?B?WVh3RHAyY3dwMUJ3bEt0WXdqWjdsMFYyTFlDWEJ3SGxEam11TmdrdGtZRTI4?=
 =?utf-8?B?Q1AyWGRmNnFRbloxcm5PMHkxSXZrWkdsQS9sTmpPdzNMU25nWlZQc29HZGJO?=
 =?utf-8?B?bStsVHRSTU1KS041TWRYTnBwNWpwVVJvSUphYWh4eGlRaVBwVzY2dmVJdnpG?=
 =?utf-8?B?TWhlVk0ydEx4c1ZDY3RnaUFlOVJzS1hNWDQ4T3FiT3RoZEJLeFg3aFlzMk9U?=
 =?utf-8?Q?ZliCs9jSBX/WQaEnvrdxWhTUr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A16F2932E25364CB04F2156A6244F1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc68f225-9e1c-4d92-4aeb-08ddbe0ce893
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 10:48:00.7207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wf987wnB+g+5cAI/vdv24A53nPfj9Wm0P3HOjwqxQXC0CkrEwNV68ssitiYo9efm0P5iDNnJpYZ1vJy3zTgw3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6858
X-OriginatorOrg: intel.com

DQo+ID4gDQo+ID4gPiBAQCAtMjE0Niw2ICsyMTU4LDE0IEBAIHN0YXRpYyBpbnQgc25wX2xhdW5j
aF9zdGFydChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2NtZCAqYXJncCkNCj4gPiA+
ICANCj4gPiA+ICAJc3RhcnQuZ2N0eF9wYWRkciA9IF9fcHNwX3BhKHNldi0+c25wX2NvbnRleHQp
Ow0KPiA+ID4gIAlzdGFydC5wb2xpY3kgPSBwYXJhbXMucG9saWN5Ow0KPiA+ID4gKw0KPiA+ID4g
KwlpZiAoc25wX3NlY3VyZV90c2NfZW5hYmxlZChrdm0pKSB7DQo+ID4gPiArCQlpZiAoIWt2bS0+
YXJjaC5kZWZhdWx0X3RzY19raHopDQo+ID4gPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gDQo+
ID4gSGVyZSBzbnBfY29udGV4dF9jcmVhdGUoKSBoYXMgYmVlbiBjYWxsZWQgc3VjY2Vzc2Z1bGx5
IHRoZXJlZm9yZSBJSVVDIHlvdQ0KPiA+IG5lZWQgdG8gdXNlDQo+ID4gDQo+ID4gCQlnb3RvIGVf
ZnJlZV9jb250ZXh0Ow0KPiANCj4gQWNrLg0KPiANCj4gPiANCj4gPiBpbnN0ZWFkLg0KPiA+IA0K
PiA+IEJ0dywgSUlVQyBpdCBzaG91bGRuJ3QgYmUgcG9zc2libGUgZm9yIHRoZSBrdm0tPmFyY2gu
ZGVmYXVsdF90c2Nfa2h6IHRvIGJlDQo+ID4gMC4gIFBlcmhhcHMgd2UgY2FuIGp1c3QgcmVtb3Zl
IHRoZSBjaGVjay4NCj4gDQo+IEkgd2lsbCBrZWVwIHRoaXMgY2hlY2sgYW5kIGNvcnJlY3QgdGhl
IGdvdG8uDQo+IA0KPiA+IA0KPiA+IEV2ZW4gc29tZSBidWcgcmVzdWx0cyBpbiB0aGUgZGVmYXVs
dF90c2Nfa2h6IGJlaW5nIDAsIHdpbGwgdGhlDQo+ID4gU05QX0xBVU5DSF9TVEFSVCBjb21tYW5k
IGNhdGNoIHRoaXMgYW5kIHJldHVybiBlcnJvcj8NCj4gDQo+IE5vLCB0aGF0IGlzIGFuIGludmFs
aWQgY29uZmlndXJhdGlvbiwgZGVzaXJlZF90c2Nfa2h6IGlzIHNldCB0byAwIHdoZW4NCj4gU2Vj
dXJlVFNDIGlzIGRpc2FibGVkLiBJZiBTZWN1cmVUU0MgaXMgZW5hYmxlZCwgZGVzaXJlZF90c2Nf
a2h6IHNob3VsZA0KPiBoYXZlIGNvcnJlY3QgdmFsdWUuDQoNClNvIGl0J3MgYW4gaW52YWxpZCBj
b25maWd1cmF0aW9uIHRoYXQgd2hlbiBTZWN1cmUgVFNDIGlzIGVuYWJsZWQgYW5kDQpkZXNpcmVk
X3RzY19raHogaXMgMC4gIEFzc3VtaW5nIHRoZSBTTlBfTEFVTkNIX1NUQVJUIHdpbGwgcmV0dXJu
IGFuIGVycm9yDQppZiBzdWNoIGNvbmZpZ3VyYXRpb24gaXMgdXNlZCwgd291bGRuJ3QgaXQgYmUg
c2ltcGxlciBpZiB5b3UgcmVtb3ZlIHRoZQ0KYWJvdmUgY2hlY2sgYW5kIGRlcGVuZCBvbiB0aGUg
U05QX0xBVU5DSF9TVEFSVCBjb21tYW5kIHRvIGNhdGNoIHRoZQ0KaW52YWxpZCBjb25maWd1cmF0
aW9uPw0KDQpBbnl3YXksIG5vIHByb2JsZW0gdG8gbWUgaWYgeW91IGhhdmUgdGhlIGNoZWNrLiAg
SSBqdXN0IHRob3VnaHQgdy9vIGNoZWNrDQp0aGUgY29kZSB3aWxsIGJlIHNpbXBsZXIgYW5kIHlv
dSBjYW4gc3RpbGwgZ2V0IHdoYXQgeW91IHdhbnQgKHN1cHBvc2VkbHkpLg0KDQo+IA0KPiA+IA0K
PiA+ID4gKw0KPiA+ID4gKwkJc3RhcnQuZGVzaXJlZF90c2Nfa2h6ID0ga3ZtLT5hcmNoLmRlZmF1
bHRfdHNjX2toejsNCj4gPiA+ICsJfQ0KPiA+ID4gKw0KPiA+ID4gIAltZW1jcHkoc3RhcnQuZ29z
dncsIHBhcmFtcy5nb3N2dywgc2l6ZW9mKHBhcmFtcy5nb3N2dykpOw0KPiA+ID4gIAlyYyA9IF9f
c2V2X2lzc3VlX2NtZChhcmdwLT5zZXZfZmQsIFNFVl9DTURfU05QX0xBVU5DSF9TVEFSVCwgJnN0
YXJ0LCAmYXJncC0+ZXJyb3IpOw0KPiA+ID4gIAlpZiAocmMpIHsNCj4gPiA+IEBAIC0yMzg2LDcg
KzI0MDYsOSBAQCBzdGF0aWMgaW50IHNucF9sYXVuY2hfdXBkYXRlX3Ztc2Eoc3RydWN0IGt2bSAq
a3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQo+ID4gPiAgCQkJcmV0dXJuIHJldDsNCj4g
PiA+ICAJCX0NCj4gPiA+ICANCj4gPiA+IC0JCXN2bS0+dmNwdS5hcmNoLmd1ZXN0X3N0YXRlX3By
b3RlY3RlZCA9IHRydWU7DQo+ID4gPiArCQl2Y3B1LT5hcmNoLmd1ZXN0X3N0YXRlX3Byb3RlY3Rl
ZCA9IHRydWU7DQo+ID4gPiArCQl2Y3B1LT5hcmNoLmd1ZXN0X3RzY19wcm90ZWN0ZWQgPSBzbnBf
c2VjdXJlX3RzY19lbmFibGVkKGt2bSk7DQo+ID4gPiArDQo+ID4gDQo+ID4gKyBYaWFveWFvLg0K
PiA+IA0KPiA+IFRoZSBLVk1fU0VUX1RTQ19LSFogY2FuIGFsc28gYmUgYSB2Q1BVIGlvY3RsIChp
biBmYWN0LCB0aGUgc3VwcG9ydCBvZiBWTQ0KPiA+IGlvY3RsIG9mIGl0IHdhcyBhZGRlZCBsYXRl
cikuICBJIGFtIHdvbmRlcmluZyB3aGV0aGVyIHdlIHNob3VsZCByZWplY3QNCj4gPiB0aGlzIHZD
UFUgaW9jdGwgZm9yIFRTQyBwcm90ZWN0ZWQgZ3Vlc3RzLCBsaWtlOg0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBpbmRl
eCAyODA2ZjcxMDQyOTUuLjY5OWNhNWU3NGJiYSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9r
dm0veDg2LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBAQCAtNjE4Niw2ICs2
MTg2LDEwIEBAIGxvbmcga3ZtX2FyY2hfdmNwdV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwNCj4g
PiAgICAgICAgICAgICAgICAgdTMyIHVzZXJfdHNjX2toejsNCj4gPiAgDQo+ID4gICAgICAgICAg
ICAgICAgIHIgPSAtRUlOVkFMOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHZjcHUt
PmFyY2guZ3Vlc3RfdHNjX3Byb3RlY3RlZCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBn
b3RvIG91dDsNCj4gPiArDQo+ID4gICAgICAgICAgICAgICAgIHVzZXJfdHNjX2toeiA9ICh1MzIp
YXJnOw0KPiA+ICANCj4gPiAgICAgICAgICAgICAgICAgaWYgKGt2bV9jYXBzLmhhc190c2NfY29u
dHJvbCAmJg0KPiANCj4gQWNrLCBtb3JlIGJlbG93Lg0KPiANCj4gPiANCj4gPiBURFggZG9lc24n
dCBkbyB0aGlzIGVpdGhlciwgYnV0IFREWCBoYXMgaXRzIG93biB2ZXJzaW9uIGZvciBUU0MgcmVs
YXRlZA0KPiA+IGt2bV94ODZfb3BzIGNhbGxiYWNrczoNCj4gPiANCj4gPiAgICAgICAgIC5nZXRf
bDJfdHNjX29mZnNldCA9IHZ0X29wKGdldF9sMl90c2Nfb2Zmc2V0KSwgICAgICAgICAgICAgICAg
ICAgDQo+ID4gICAgICAgICAuZ2V0X2wyX3RzY19tdWx0aXBsaWVyID0gdnRfb3AoZ2V0X2wyX3Rz
Y19tdWx0aXBsaWVyKSwgICAgICAgICAgIA0KPiA+ICAgICAgICAgLndyaXRlX3RzY19vZmZzZXQg
PSB2dF9vcCh3cml0ZV90c2Nfb2Zmc2V0KSwgICAgICAgICAgICAgICAgICAgICANCj4gPiAgICAg
ICAgIC53cml0ZV90c2NfbXVsdGlwbGllciA9IHZ0X29wKHdyaXRlX3RzY19tdWx0aXBsaWVyKSwN
Cj4gPiANCj4gPiB3aGljaCBiYXNpY2FsbHkgaWdub3JlIHRoZSBvcGVyYXRpb25zIGZvciBURFgg
Z3Vlc3RzLCBzbyBubyBoYXJtIGV2ZW4NCj4gPiBLVk1fU0VUX1RTQ19LSFogaW9jdGwgaXMgY2Fs
bGVkIGZvciB2Q1BVIEkgc3VwcG9zZS4NCj4gPiANCj4gPiBCdXQgSUlSQywgZm9yIEFNRCBzaWRl
IHRoZXkganVzdCB1c2UgZGVmYXVsdCB2ZXJzaW9uIG9mIFNWTSBndWVzdHMgdGh1cw0KPiA+IFNF
Vi9TTlAgZ3Vlc3RzIGFyZSBub3QgaWdub3JlZDoNCj4gPiANCj4gPiAgICAgICAgIC5nZXRfbDJf
dHNjX29mZnNldCA9IHN2bV9nZXRfbDJfdHNjX29mZnNldCwNCj4gPiAgICAgICAgIC5nZXRfbDJf
dHNjX211bHRpcGxpZXIgPSBzdm1fZ2V0X2wyX3RzY19tdWx0aXBsaWVyLA0KPiA+ICAgICAgICAg
LndyaXRlX3RzY19vZmZzZXQgPSBzdm1fd3JpdGVfdHNjX29mZnNldCwNCj4gPiAgICAgICAgIC53
cml0ZV90c2NfbXVsdGlwbGllciA9IHN2bV93cml0ZV90c2NfbXVsdGlwbGllciwNCj4gPiANCj4g
PiBTbyBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgd2lsbCBiZSBwcm9ibGVtIGhlcmUuDQo+
IA0KPiBGb3IgdGhlIGd1ZXN0LCBjaGFuZ2luZyBUU0MgZnJlcXVlbmN5IGFmdGVyIFNOUF9MQVVO
Q0hfU1RBUlQgd2lsbCBub3QNCj4gbWF0dGVyLiBBcyB0aGUgZ3Vlc3QgVFNDIGZyZXF1ZW5jeSBj
YW5ub3QgYmUgY2hhbmdlZCBhZnRlciB0aGF0Lg0KDQpCdXQgd2lsbCB0aGVyZSBhbnkgc2lkZSBl
ZmZlY3QgaWYgZG9pbmcgc28/ICBFLmcuLCB3aGF0IGlmDQpzdm1fd3JpdGVfdHNjX29mZnNldCgp
L3N2bV93cml0ZV90c2NfbXVsdGlwbGllcigpIGFyZSBjYWxsZWQgZm9yIHZDUFUgZm9yDQpTTlAg
Z3Vlc3Q/DQoNCj4gDQo+ID4gQW55d2F5LCBjb25jZXB0dWFsbHksIEkgdGhpbmsgd2Ugc2hvdWxk
IGp1c3QgcmVqZWN0IHRoZSBLVk1fU0VUX1RTQ19LSFoNCj4gPiB2Q1BVIGlvY3RsIGZvciBUU0Mg
cHJvdGVjdGVkIGd1ZXN0cy4NCj4gPiANCj4gPiBIb3dldmVyLCBpdCBzZWVtcyBmb3IgU0VWL1NO
UCB0aGUgc2V0dGluZyBvZiBndWVzdF9zdGF0ZV9wcm90ZWN0ZWQgYW5kDQo+ID4gZ3Vlc3RfdHNj
X3Byb3RlY3RlZCBpcyBkb25lIGF0IGEgcmF0aGVyIGxhdGUgdGltZSBpbg0KPiA+IHNucF9sYXVu
Y2hfdXBkYXRlX3Ztc2EoKSBhcyBzaG93biBpbiB0aGlzIHBhdGNoLiAgVGhpcyBtZWFucyBjaGVj
a2luZyBvZg0KPiA+IGd1ZXN0X3RzY19wcm90ZWN0ZWQgd29uJ3Qgd29yayBpZiBLVk1fU0VUX1RT
Q19LSFogaXMgY2FsbGVkIGF0IGVhcmxpZXINCj4gPiB0aW1lLg0KPiA+ID4gVERYIHNldHMgdGhv
c2UgdHdvIGF0IGVhcmx5IHRpbWUgd2hlbiBpbml0aWFsaXppbmcgdGhlIFZNLiAgSSB0aGluayB0
aGUNCj4gPiBTRVYvU05QIGd1ZXN0cyBzaG91bGQgZG8gdGhlIHNhbWUuDQo+IA0KPiBTZXR0aW5n
IG9mIGd1ZXN0X3N0YXRlX3Byb3RlY3RlZCBpcyBjb3JyZWN0IGFzIGl0IGlzIHBhcnQgb2YNCj4g
TEFVTkNIX1VQREFURV9WTVNBLCBmcm9tIHRoaXMgcG9pbnQgb253YXJkIHRoZSBndWVzdCBzdGF0
ZSBpcyBwcm90ZWN0ZWQuDQoNCk9oIEkgbWFkZSBhIG1pc3Rha2UgdGhhdCBURFggc2V0cyB0aGVt
IHdoZW4gaW5pdGlhbGl6aW5nIHRoZSBWTS4gIFRoZXkgYXJlDQphY3R1YWxseSBzZXQgd2hlbiB2
Q1BVIGlzIGNyZWF0ZWQgYXQgd2hpY2ggcG9pbnQgeW91IGFscmVhZHkga25vdyB0aGUgVk0NCnR5
cGUgdGh1cyBhbHJlYWR5IGtub3cgdGhlIHZDUFUgaXMgZm9yIFREWCBndWVzdC4NCg0KSSB0aG91
Z2h0IHRoZSBzYW1lIGxvZ2ljIGNvdWxkIGJlIGFwcGxpZWQgdG8gdkNQVSBvZiBTTlAgZ3Vlc3Q/
DQoNCj4gDQo+IEZvciBndWVzdF90c2NfcHJvdGVjdGVkLCB2Q1BVcyBhcmUgY3JlYXRlZCBhZnRl
ciBTTlBfTEFVTkNIX1NUQVJULCBzbyBzZXR0aW5nDQo+IHZjcHUtPmFyY2guZ3Vlc3RfdHNjX3By
b3RlY3RlZCB0aGVyZSBpcyBub3QgcG9zc2libGUuIFdlIG1pZ2h0IG5lZWQgdG8gaGF2ZSBhDQo+
IGt2bS0+YXJjaC5ndWVzdF90c2NfcHJvdGVjdGVkIHdoaWNoIGNhbiBiZSBzZXQgYW5kIHRoZW4g
cGVyY29sYXRlIGl0IHRvDQo+IHZjcHUtPmFyY2guZ3Vlc3RfdHNjX3Byb3RlY3RlZCB3aGVuIHZD
UFVzIGFyZSBjcmVhdGVkLCBjb21tZW50cz8NCg0KU2VlIGFib3ZlLiAgSSB0aGluayB3ZSBjYW4g
c2V0IHZjcHUtPmFyY2guZ3Vlc3RfdHNjX3Byb3RlY3RlZCB3aGVuDQpjcmVhdGluZyB0aGUgdkNQ
VSwgYXQgd2hpY2ggcG9pbnQgeW91IGFscmVhZHkga25vdyB0aGUgVk0gdHlwZS4NCg==

