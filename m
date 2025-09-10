Return-Path: <kvm+bounces-57195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A837B515DB
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7CFD1C83FF3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59782DCC1C;
	Wed, 10 Sep 2025 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="an1IlSjJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5493E23A9AE;
	Wed, 10 Sep 2025 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757504148; cv=fail; b=ZP4ahAFZgs5xiSHR8hS0UWPDuzIXGwQ/oz3ZvrHCor/Ix9vNfwuXSpJKsnbEqYjWdn8kIl/n9GKPKGgqiDHaQARPc14PCsqCUswLyR3FZo7EyMVv3kqnd6l3HsPBTcFpjQPGzkroFfJC28qkBBQ+1IVuwmJYT+oSGP1fuAhIA3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757504148; c=relaxed/simple;
	bh=a8yPqFxv101+YCNvWGzKOGUh/c6AJr5BxnPoo9OQJaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UubGvAZmRUyTG3/wv51XRaMctwzgDxIoIoLtTL68cUDk5JUa5xiKr6wC0VqX7FDzZmkM2sZQDuf362dcevC0+tJBW6M8fNkPwIKk494Sp8ltv7hdNtr4V4feX3HyRVXCkVMAKHqJRi++u7rdAQ/zi8+1WIkXgPTMzayy7bAGXO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=an1IlSjJ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757504147; x=1789040147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a8yPqFxv101+YCNvWGzKOGUh/c6AJr5BxnPoo9OQJaY=;
  b=an1IlSjJWk8dAeH3Ilim9clu8HEivfj7tdpSjHi2Ck7F/VlM07MrSqM8
   A2rS4mRFVEXsG3H0jI6PoPxjJ9rhdDkixZHpIFkKLVEwftBK6rE2XiNpT
   J/FtWE42GrH5+K7uJ+Y52mbR43ahB0V328atfnZy8bwoJuNO3hE847jxs
   9imX0qofZ2CV0xZu85phCofei1pRo3dtCmXXSCpCgNLB/CeMPT9KXvgZz
   ahnmBftvytxNS6Q6bSureZ8zF/2pABTk5PKVQ4d+R7vBl9SaPM4qNupvr
   2tLZkaLyhySRvCgAsx1zAaBI35vmca1Ir1Cw9wP6RU0ipdc6eJyG4JSBv
   Q==;
X-CSE-ConnectionGUID: pvc2uQ4+TNqoAyc1+Ul1kQ==
X-CSE-MsgGUID: CIM6ETpET+6s9Zpo8LTv5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59758948"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59758948"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:35:46 -0700
X-CSE-ConnectionGUID: U1Fz1g8fTb+1ilDZNcIp9A==
X-CSE-MsgGUID: I2W8jPQDR46nXTpYxHQf5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173454143"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:35:44 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:35:43 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 04:35:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.40)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:35:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQnMcs9GIPihlYRdsxj48Mxz5CwPEH9DA2RvFxgasFjWM8X3ZU6taHBGUS1pBHUH31uZK6szFh+Syhqw+bMwCMa4AXsS1HjIaPBFIpgjy+5n9xhfktjRqpbSAxo1E2DmjOE3q8piAO6UE5e7sJJbJ4v6YB8c+RMeHCSCWiKmY6Fh1fLfOEf64tm+6oi4OC0XsB8aegg2B3kY8x5p7+SOvDlgRYin9tK+yYtf2k0wbA/g3d+hNgueefi2wMeMTbb0ZCoJfdOKlYdBYuPW8V75PSPicqjNLisXchpNYDAsNpDIOH/UhZvIT3YsQ4uGkRigMeFecfLGh99GEKXpsc+OoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8yPqFxv101+YCNvWGzKOGUh/c6AJr5BxnPoo9OQJaY=;
 b=rmTQ00b+SoTd/xKoGu2tG+Zd+QjZviMfYJ6kPDzz4Dv0MOZg0fMW+Z5HZCOR5lilv2EcKUgPaVDRTuSyVb7GaylU8OhHua3FZO90cJSWaXJZCva+U+fAel0SYwm9zbQDvXgNvxgCkKY4U1J0m1N9GyhiLC7Vr05c1XxXmfbfZqm6vn6P9+IYjbmJBRyAQ58Ma8OCcWTmyy94Y7RoLcQNz+IA4Z30FKReUahY09mfJegbxfENg5bSegKeG66q0bvG6/ZYI1wsYK6MfyTpCgft89pkQMXd1rRVu0+F4DTDwFqeAxJoQReQrPiLE6hpb0sMqfEt9QMBeL4UvPIBCkoSRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6681.namprd11.prod.outlook.com (2603:10b6:510:1c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 11:35:35 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 11:35:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "brgerst@gmail.com"
	<brgerst@gmail.com>, "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"arjan@linux.intel.com" <arjan@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"kprateek.nayak@amd.com" <kprateek.nayak@amd.com>, "pavel@kernel.org"
	<pavel@kernel.org>, "david.kaplan@amd.com" <david.kaplan@amd.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Thread-Topic: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Thread-Index: AQHcIbhd14UC0LurTkGsI74DGd7tB7SMDyGAgAA0mICAAAbbAA==
Date: Wed, 10 Sep 2025 11:35:35 +0000
Message-ID: <16a9cc439f2826ee99ff1cfc42c9006a7a544dd4.camel@intel.com>
References: <20250909182828.1542362-1-xin@zytor.com>
	 <20250909182828.1542362-2-xin@zytor.com>
	 <1301b802284ed5755fe397f54e1de41638aec49c.camel@intel.com>
	 <aMFcwXEWMc2VIzQQ@intel.com>
In-Reply-To: <aMFcwXEWMc2VIzQQ@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6681:EE_
x-ms-office365-filtering-correlation-id: 07817cbc-012a-436b-5685-08ddf05e2865
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YWd1Z3pNTWZnQ2NONmJjbkNmNlR5aHlTQlJXOEJmdUg4SmtQVW9OTGVqdGJJ?=
 =?utf-8?B?S3J4djVNSGpzMjNuNlNoVkJ0am1iMEZaNHRUOHVZaTNsUjg0NEU1VVJ3UUZa?=
 =?utf-8?B?YUxpb2dVbkR4NmhZbDBNcnIyV0JOZFpFTkZUNjVyQjlhUEsyTnArTUt2cjlv?=
 =?utf-8?B?NDVjVi9yaXFqeDJ0WGt5OFBzK2FUbjFCT3dkbFRXUG1RRjZNV3d2TEhQb2wv?=
 =?utf-8?B?bUpva25iZjQ2Rm4vKzhUZTB6cTFmNUVZTWZMelM5UkhuUkQ0QWdwNytjUDhq?=
 =?utf-8?B?aVNvVWN0MkdqK3FjUGVweFUwNHdpRk9GVXQyTEtSRnRtWVJudVNnU2hXSjZv?=
 =?utf-8?B?MkVMUG9FU2Z4V0VVeG8yZDRQbElhUFBpSFZaUTk1elJXTk1HakFHTkMwamZD?=
 =?utf-8?B?L040cHY5ekN2WTlOWDhqdlR3dDM1K3l5ejE4aEhYNmlULzM5eFBRZ3M4VXIx?=
 =?utf-8?B?a3VmMlZPd2lQWFk4L2E5bGN2REpiaGk4M3pDcVREQVppOWtoMjFkdk1YcHo3?=
 =?utf-8?B?WnVpVzNQNngwVldIemsxR3BuNzBlUUxTaVRMNjE0a2w2MGFPU0JlYTVpUUt3?=
 =?utf-8?B?T3NoT21RMG9lelM0bFdaOGVuUmhaRGZTdjVXeUlZSjU0UXR5T1NFZmxDWTNn?=
 =?utf-8?B?Y3RLL3Y0L05BY0NEa2o3WlZBQWVWWHdrelorRk5CSEV6WXpObUdLWlJKNytH?=
 =?utf-8?B?MTY2dGxWS215OXBKc0JTSC90NVcwZ1FVb3U2N21qMklNK0RlbVdNS2RZSm9S?=
 =?utf-8?B?am54aDl4dHNHVWE3bE0xN29KaVR3czF3MG92YWsxRlFENmNvY3I1VGp3eWNm?=
 =?utf-8?B?Tm1BQnJ6bFljN1VTalFzb0k2b2dGR2FuUVFmR3Avcm1QWFlkVmhRVmoweHZF?=
 =?utf-8?B?QVNta3dkbm4waWdRbkNudFpXS2Z2eFpKUmpFWXV1MDA2by9RZ01mZUkwNmND?=
 =?utf-8?B?dHU0K05pQjlwZVkydVVSaXRzdTlMMDJRYVhOVmhLQkVqSDhwa1A3ME1CeldF?=
 =?utf-8?B?NC85ZmtXNzlRaHZSRSs3K1h0QmluRkZYNlFwcXF3OVJJTnk5ZXg5MHlSb2xD?=
 =?utf-8?B?bUo1WDcyNHIvbFZWNXBwMTg1ZjZKc3d0ZTQ3QitGNU10TWhPZTFUQjE3MEEx?=
 =?utf-8?B?NnZMM290RStuc2MxelMwYmtwYnI1UERxMXEwdThrMzB0WC8yTG1FRkpqZTN4?=
 =?utf-8?B?MDBLVmhKdzg0TndrVk1FcGVmdjlxL3dQSFZzOTl1bmlGWG1ISVU1UGFKdHVQ?=
 =?utf-8?B?dnNCZ21kQWQ1UGJ3Q0I0SEhHTlhiSUZnOFd5Ymw2SU9QeTlGeWRXZ3k1a2ln?=
 =?utf-8?B?YWRSN1Y5ZlFNT2d0YWNZSWc2SVBraVIxa3c5alg2SUxFcEZjNWtLRm5IejZC?=
 =?utf-8?B?WnM1YTkrWEh6ZTl5em5wWWYxbkZndi9kTEhtZjAvaHoyLzJFanJhVmNpRWh6?=
 =?utf-8?B?ZTk1SVUzNnV3ejNTRVNWTm04U0c0TFRlcFdTU0taSklSaExka3YvaXBkSHdh?=
 =?utf-8?B?b3F0NWs0bHNLQUR3dUNRaHROUTBoRy9oSWtGdXZ4VThEaFpjMmhOdTM4VzFw?=
 =?utf-8?B?Z3lxT1JKK2lpR1l3c21HZS8wRzF5OW9LOVlBNlk3aFhzWVpiZFZDWkYvNThj?=
 =?utf-8?B?cFdhVnFZZjA2bTlranFoMVZQSVVZRk9ZTEoxclhqMjNaR0c2akNBenFzVTdM?=
 =?utf-8?B?UUh3UzVVWitmZ0Uva2hXV0pDRURiaXQxeG9zRHlJcDlScXQxQ2lBWXpSNk04?=
 =?utf-8?B?enNJa0taeHNiL0IxVE04VWRxdmwyc1NONytONlhyem4yU1A1alVYbTRrREp5?=
 =?utf-8?B?L1JiSktFVmwyMFlaWmEva1VVYktsd3NuNzkzRGkvNDYvTTB5dFNKb2NDajB1?=
 =?utf-8?B?NXlpdFplQldXNTNXK2QxN3pUUVc4dkpMVjJCTWJOajNSZUsxWnNBc2xYdWwx?=
 =?utf-8?B?cE5tSWc3TmFTb3IwSXIwd0hZb04zQm1NRzhxVER1eDA4SytVUDNrcmZjN1FW?=
 =?utf-8?Q?GrUsACXKa+8ZWyLfMpXCocflyuOCeM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm42ZHVyRnQxdjhiOTBnVllOYnRoVnNldDhDdWVJbzFQSHJnQXE1b3RBbjln?=
 =?utf-8?B?cDJGUi9pNitrSWUrSDZyTzRoNHF6K0hvWkZIVTE3YU5ic3d3MHR4U0RzQStm?=
 =?utf-8?B?MjMzNHg5aVNqOUlpQmR0T1grMElGUm5JUDNuWXNsbFNXUzVZenAyL2NPOUpz?=
 =?utf-8?B?V2daNkNmbVh6aUN1SlMySmlzTWNoWjlOWlBZSjgwMkFITFRYQXBDbmZhUW83?=
 =?utf-8?B?UDVHYk5jV2ZOTFNzQVJpaFRsRzk5MEw3bXNmT3BvaXkwenlsN2lETXdHc293?=
 =?utf-8?B?SHVpUm5jeGk4Q1pHQzZGZU4wNFVEOVZGMVJLVzNUUlRkVVByTnM4WmhYWlpr?=
 =?utf-8?B?UVdCbzhIL3lNU0dTbjhTcCtPUWxvWktEcTAySktIbDBaeDdyTzhrMy96d2RP?=
 =?utf-8?B?RW9wL3NwYXhMNnlhZWZ6Y1d3SWY2ZDVHNXk0MkFXQ2lkR2h6YU9IazQ0NGxC?=
 =?utf-8?B?R2FHK1F2SGYrSVhjcFR2NkFJZHY3MUJ0SUM0RHJlZU1XRmFrUEo2UG1QdDkx?=
 =?utf-8?B?WXo3MWVkNHpjZU1hQ1kvakw5WVVGcXlETzVQRXZpM01uWk9RYmYzOE9hZTBz?=
 =?utf-8?B?WUM3MWJPUFU3c1QrU2RQak5hT2hlWFNsZ3pKUDJJVEk2bkduZnlqbmtiQ3lt?=
 =?utf-8?B?ZU9NWWQ2bmE5Rk9GWWpSNjdXc051emdyOFJRaXFlcW1UemUyWjdneDFMZmpK?=
 =?utf-8?B?Umo2TUNJdmRNQVBmOExLZjd0MGNZSXRHTURXcTNqVEpXbUI4S0ZsRFcyQkdw?=
 =?utf-8?B?VGlEaG13YXQ1WDRMWHVOdVFFTXlKdVJ6Y2tObHZlM2JVa1hVTThqeEZHYVQv?=
 =?utf-8?B?Q2Ivd1hkQkdjd213bnRQUkkxWTlrZGo1cEFmeVptNDVtSExRdklYRU9mOG9j?=
 =?utf-8?B?Sm9mZGJLYWlEWTk0Z2E2bGQxZVZ3U1YzcGdOWjF3dks1ZlQ4RG0rYktKTGRI?=
 =?utf-8?B?bytXV2hZcTF0aGRacTJpTUl0UHFkdmxrMWVrT1J2dDZBVDVzZThBV2wyK2Jp?=
 =?utf-8?B?OWtEeWgwVnFYcU5TcnpQclRTbURHdXVlaVg4K1pLYWNHUnNYL3Uyc29KaUlS?=
 =?utf-8?B?Y01ENkNRcUZ6djRTVUFaU0lnQ1lwRzEyNVozUWV0QkpvQkJoaVFjV28xeXpC?=
 =?utf-8?B?b0JOd0Rnd0VaVnc5UDc5TXhLNysvL3FuZ3JzWXVPRklhanN6ZUZYR1JlN055?=
 =?utf-8?B?WlkxcitHanA5Q01aQ2FzQ1dvMUpZS21BN1QweWkvcEVwWGdnWU9kVmJYNElz?=
 =?utf-8?B?Z0tsdlNJc2ZEcDNWNVdkdE01M1Qrak1yR0hEMGZBdWRqc1lLSUNMQ09vby9z?=
 =?utf-8?B?NmRwUUl2c1p3NjdwNmxZYk44U0VMVlFONCs4b3hwbkFCTEhkOS9XQ0NvK3hv?=
 =?utf-8?B?d0JGQTE2bEd2ZDVsciswd2g3TitpNFg4bEk2Nml3NFpNdDdLcHpva2lTc0lU?=
 =?utf-8?B?Z1hHL1p3S0FVZ0txN1JsRVVIUHQrR2JUWWREQ1F6cjRBY1ptQkd0Ly9jU2FK?=
 =?utf-8?B?ZXBEV1hFTTJJZUNGdlZqeWNraEdQUm1oVDZDakp1dWxFamMwSys0NXVlOEoy?=
 =?utf-8?B?N2VRRFM5WUljT2hDU3d0anF0cW5kMkRQcHdEWmlMTlpIbEQ0UEZtL2R0dFc4?=
 =?utf-8?B?S1BWQVNiR3RyQU9sMzZqUHRRQXZTZ09GUExpWkVLU3AzSVNuaGRyaTMzR1h2?=
 =?utf-8?B?NitEN2YxQ3dhT2JxbERiMUNST0htYUhYVlZrUk43ak1yZmc1S3ZtdG1sYkRK?=
 =?utf-8?B?YlpMeTBOa21BNThZTVdwand1djljSEUwTTJqNit2V29qQnZTTE5ESVhWZVha?=
 =?utf-8?B?dENDRllDZ09EVzNYc09helc2Y1g5UkJvd1RaY2ZKemRNQTFDazlFd0dtNFV0?=
 =?utf-8?B?SzE5QnkwNU1DdmQ2eG0zYkNnbUErcElGb0JoSTZlUjI3YlhMZFh3N3J6THM5?=
 =?utf-8?B?cDRZazNuYXhvZEJRNDNiODBuV1hpM0dVdnl2RFBpTmJaRUQvbXoyb001Wkor?=
 =?utf-8?B?VVhYV0lCek96MUdIVUZvOUlWOU1IUlZzSGo3T1Z6ZjdOZUd3OCs3RW5GbFRT?=
 =?utf-8?B?S1BkaGJNQVIwekxSemRzR1k2ZnpzMW45YkV6SkkwblU1VFpJSkdoQVZGRExT?=
 =?utf-8?Q?riYDZ5pXJazKwyQNTWDbjicQV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45CFFD435943F040B9052CCEBCB65117@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07817cbc-012a-436b-5685-08ddf05e2865
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 11:35:35.1342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LMYYWOfbmRr5T/p2AjaPThDK3gjb51mSGPmq0jfNRi8RHVTt/86LfQISMwJa8TMTFa35sKLHAULbqVBgdhI7UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6681
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA5LTEwIGF0IDE5OjEwICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiA+
IEBAIC0yNTUxLDYgKzI2MzYsMTIgQEAgdm9pZCBfX2luaXQgYXJjaF9jcHVfZmluYWxpemVfaW5p
dCh2b2lkKQ0KPiA+ID4gwqAJKmMgPSBib290X2NwdV9kYXRhOw0KPiA+ID4gwqAJYy0+aW5pdGlh
bGl6ZWQgPSB0cnVlOw0KPiA+ID4gwqANCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiANCj4gPiA+ICsJ
LyoNCj4gPiA+ICsJICogRW5hYmxlIEJTUCB2aXJ0dWFsaXphdGlvbiByaWdodCBhZnRlciB0aGUg
QlNQIGNwdWluZm9feDg2IHN0cnVjdHVyZQ0KPiA+ID4gKwkgKiBpcyBpbml0aWFsaXplZCB0byBl
bnN1cmUgdGhpc19jcHVfaGFzKCkgd29ya3MgYXMgZXhwZWN0ZWQuDQo+ID4gPiArCSAqLw0KPiA+
ID4gKwljcHVfZW5hYmxlX3ZpcnR1YWxpemF0aW9uKCk7DQo+ID4gPiArDQo+ID4gPiANCj4gPiAN
Cj4gPiBBbnkgcmVhc29uIHRoYXQgeW91IGNob29zZSB0byBkbyBpdCBpbiBhcmNoX2NwdV9maW5h
bGl6ZV9pbml0KCk/ICBQZXJoYXBzDQo+ID4ganVzdCBhIGFyY2hfaW5pdGNhbGwoKSBvciBzaW1p
bGFyPw0KPiA+IA0KPiA+IEtWTSBoYXMgYSBzcGVjaWZpYyBDUFVIUF9BUF9LVk1fT05MSU5FIHRv
IGhhbmRsZSBWTVhPTi9PRkYgZm9yIENQVQ0KPiA+IG9ubGluZS9vZmZsaW5lLiAgQW5kIGl0J3Mg
bm90IGluIFNUQVJUVVAgc2VjdGlvbiAod2hpY2ggaXMgbm90IGFsbG93ZWQgdG8NCj4gPiBmYWls
KSBzbyBpdCBjYW4gaGFuZGxlIHRoZSBmYWlsdXJlIG9mIFZNWE9OLg0KPiA+IA0KPiA+IEhvdyBh
Ym91dCBhZGRpbmcgYSBWTVggc3BlY2lmaWMgQ1BVSFAgY2FsbGJhY2sgaW5zdGVhZD8NCj4gPiAN
Cj4gPiBJbiB0aGlzIHdheSwgbm90IG9ubHkgd2UgY2FuIHB1dCBhbGwgVk1YIHJlbGF0ZWQgY29k
ZSB0b2dldGhlciAoZS5nLiwNCj4gPiBhcmNoL3g4Ni92aXJ0L3ZteC92bXguYykgd2hpY2ggaXMg
d2F5IGVhc2llciB0byByZXZpZXcvbWFpbnRhaW4sIGJ1dCBhbHNvDQo+ID4gd2UgY2FuIHN0aWxs
IGhhbmRsZSB0aGUgZmFpbHVyZSBvZiBWTVhPTiBqdXN0IGxpa2UgaW4gS1ZNLg0KPiANCj4gS1ZN
J3MgcG9saWN5IGlzIHRoYXQgYSBDUFUgY2FuIGJlIG9ubGluZSBpZiB0aGVyZSBpcyBubyBWTSBy
dW5uaW5nLsKgDQo+IA0KDQpUaGlzIGlzIHdoZW4gJ2VuYWJsZV92aXJ0X2F0X2xvYWQnIGlzIG9m
ZiwgcmlnaHQ/ICBUaGUgZGVmYXVsdCB2YWx1ZSBpcw0KdHJ1ZS4NCg0KPiBJdCBpcyBoYXJkDQo+
IHRvIGltcGxlbWVudC9tb3ZlIHRoZSBzYW1lIGxvZ2ljIGluc2lkZSB0aGUgY29yZSBrZXJuZWwg
YmVjYXVzZSB0aGUgY29yZSBrZXJuZWwNCj4gd291bGQgbmVlZCB0byByZWZjb3VudCB0aGUgcnVu
bmluZyBWTXMuIEFueSBpZGVhL3N1Z2dlc3Rpb24gb24gaG93IHRvIGhhbmRsZQ0KPiBWTVhPTiBm
YWlsdXJlIGluIHRoZSBjb3JlIGtlcm5lbD8NCg0KU2luY2UgSSB0aGluayBkb2luZyBWTVhPTiB3
aGVuIGJyaW5naW5nIHVwIENQVSB1bmNvbmRpdGlvbmFsbHkgaXMgYQ0KZHJhbWF0aWMgbW92ZSBh
dCB0aGlzIHN0YWdlLCBJIHdhcyBhY3R1YWxseSB0aGlua2luZyB3ZSBkb24ndCBkbyBWTVhPTiBp
bg0KQ1BVSFAgY2FsbGJhY2ssIGJ1dCBvbmx5IGRvIHByZXBhcmUgdGhpbmdzIGxpa2Ugc2FuaXR5
IGNoZWNrIGFuZCBWTVhPTg0KcmVnaW9uIHNldHVwIGV0Yy4gIElmIGFueXRoaW5nIGZhaWxzLCB3
ZSByZWZ1c2UgdG8gb25saW5lIENQVSwgb3IgbWFyayBDUFUNCmFzIFZNWCBub3Qgc3VwcG9ydGVk
LCB3aGF0ZXZlci4NCg0KVGhlIGNvcmUga2VybmVsIHRoZW4gcHJvdmlkZXMgdHdvIEFQSXMgdG8g
ZG8gVk1YT04vVk1YT0ZGIHJlc3BlY3RpdmVseSwNCmFuZCBLVk0gY2FuIHVzZSB0aGVtLiAgVGhl
IEFQSXMgbmVlZHMgdG8gaGFuZGxlIGNvbmN1cnJlbnQgcmVxdWVzdHMgZnJvbQ0KbXVsdGlwbGUg
dXNlcnMsIHRob3VnaC4gIFZNQ0xFQVIgY291bGQgc3RpbGwgYmUgaW4gS1ZNIHNpbmNlIHRoaXMg
aXMga2luZGENCktWTSdzIGludGVybmFsIG9uIGhvdyB0byBtYW5hZ2UgdkNQVXMuDQoNCkRvZXMg
dGhpcyBtYWtlIHNlbnNlPyANCg==

