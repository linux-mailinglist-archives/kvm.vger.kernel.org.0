Return-Path: <kvm+bounces-51354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B29AAF6675
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 01:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC9A9488292
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3D625DD12;
	Wed,  2 Jul 2025 23:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YRWyPT6d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ADB1386B4;
	Wed,  2 Jul 2025 23:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751500676; cv=fail; b=XvlaCnp1zi8Vv44YwvW24NfU+Ob8yHHe2yeVyGRDQkHWsmxyYvfkAQo5T6mDhnPK99rvXz3dx0TRHp26RscqsAsXvmSqOUTxP2T6ywScmqfmv6jaGi+Fvrc9xNcYK8u0G4cuFqR+Klnqo2wCOJluG8sUL/mtE4PdsEaQUTGjbBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751500676; c=relaxed/simple;
	bh=qPgKvCNwct8/CbnQKEFhdaebv2UMCSDWwkOXxytTUjU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n2GtlBrJaIta6O9fjUyUVDbsdagTgMhs4cgtgbl6Ut+u8t5q20JpQorAqI/Rth/F6cushfsTSQY6a49Xq05/hnwf0W+nV1CcO31ZyDuUY3N+r4weWY5txyZpM/YJewNWHVbge5wkZxWr5qlWCbB2IIlpr8+Rc/ZFNldreTaLpOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YRWyPT6d; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751500676; x=1783036676;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qPgKvCNwct8/CbnQKEFhdaebv2UMCSDWwkOXxytTUjU=;
  b=YRWyPT6duiRVdo0Ft/ESCQ5iEu3WakdEFFj0ajN+aBKFDuVNjYXpp2kT
   Slg4n3X+UvGhc2a3dRKXCPvht+p8b+UWhUePV5H2+cZTQ7Q9+AXnuiYw7
   GHKMtpMQH4Qlt6Qx0YMBQhYt2xaqHio4dAmF8rStGxpq16RI7qHoXK43g
   HMC6CHARytrqqVybeffPQfvkxjk7RTg0kWhEBo50upkwkLAi6hkzDFbiC
   lqzsOa5vuPiMF9CGJrPkYg7gH+9XvgfkYLJMj7hiy6Os9Cs7UDuD92zs3
   Suq49vR/Y9iVKy6gWpz76/CdrZ5510CVkCB2sl5COXJpdjeGwtKrfJayu
   w==;
X-CSE-ConnectionGUID: bMqhQET2QH6BQqLPMh38Jw==
X-CSE-MsgGUID: pqjqHXrRQEKAd+aZwLQrKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="71245798"
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="71245798"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 16:57:53 -0700
X-CSE-ConnectionGUID: fgxrZBCjSF2pSaVmU0BPBw==
X-CSE-MsgGUID: lQQ+EmHaSUO6u+ZakHz+qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="153852372"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 16:57:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 16:57:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 16:57:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.83) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 16:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iiTFRxUyHcystSHBSk/vqoNbzCi0FBBbznwDKTzThY7EKKpKWoGmnHA531W4A+wWax6nBPlxwyK3ay/NCWSzs6HpssBu75k2OezGAM2WWAO3zkeyK/gRs39ntwYcGqcrJHnMeVkZV8u2qesQKi7DujR7HdrURRGggvo/QbhgFRr+x21iuhMNFODFtCCbQU5WpZ42FEHO5CYzXunuXxlcUEMMy8a2nFcKehxvftsftEIu5zlUl/HLWSIrtKoRNF9kknAKhykN3hUm2voqr5HiTN4EOE6AD2CHL089gFxbmDp6DrZgVgxNQifezChwuRIMy5q42MshRcRmIeSy0gdiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPgKvCNwct8/CbnQKEFhdaebv2UMCSDWwkOXxytTUjU=;
 b=Vn6lryJAiIef7J68WJBtCgV1oBMfFb1GxhC9tTQ5aqwNN/XNpxaPokxu6zuwOlSDkraJUiFEDLWbKIEXvdeOBwYjylMVo6Fqlmf38sLPQtQ77WoEJ1NqvZCyUKowWjyht+lcIF8MohY9AebRyjOOdhx1kfDI6Da8u7OfyKVK8lahYXQBFSCFzO2ghcP0imlXTMjgC2Zll8Y/rlrKV19v8ySNnlwUgAoT603oB4euRifsLNvjGDsgQlZziv2p7di+5EAYRNeX6qFgA/ZIx7Oqaxiq26BNGb3yA8mepVU17MhpjBncdvDsG3ipdRh5heGdMESxn5NwF2vHqow5pdiPPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV3PR11MB8529.namprd11.prod.outlook.com (2603:10b6:408:1b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Wed, 2 Jul
 2025 23:57:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 23:57:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Topic: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Index: AQHb5ogJzQk8ztTCzkmIvpX60YI237QeiMAAgAAFFYCAAOL6AIAAHFmA
Date: Wed, 2 Jul 2025 23:57:48 +0000
Message-ID: <f8dcbe257b3931aec9e199132b678bd7681b7efa.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
	 <aGTtCml5ycfoMUJc@intel.com>
	 <01d96257ed48bba14d9d0f786ea90f11eb9e7c7a.camel@intel.com>
	 <CAGtprH-q91ajkgzN3Mki9nRt1cJu2fK7XMiZUeJaAfwZOjLduw@mail.gmail.com>
In-Reply-To: <CAGtprH-q91ajkgzN3Mki9nRt1cJu2fK7XMiZUeJaAfwZOjLduw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV3PR11MB8529:EE_
x-ms-office365-filtering-correlation-id: 6f20d8d3-2f5b-40ce-7282-08ddb9c43f82
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bmRLc1VEd3dxSExYOFJXZUxmUkFCYnQwbU0xeGFKanpJT0RnZlpGeDhURjJX?=
 =?utf-8?B?L2ZJUGlmKysxbGlZUmluV0hrVzdtdnZocmxhOVNvSjNBbFdpTVcwR0gyQTZw?=
 =?utf-8?B?N0xMeHJxMDdrWWhiUGxGV2pjZTdYSDlTT3d5cnVXVXdYOXlrYU15eFlNY2hN?=
 =?utf-8?B?eDNIM3FvUTdmRGQ4dlozcS9LUmZRYkhEdXBNUS9tWkovc1FsZmsxMlFVMTJP?=
 =?utf-8?B?NGM1YUg4VGNKVTRXVk9keGJPblIwMWl4VzZraWJwa3MzTWNxTS83QzVkL1RD?=
 =?utf-8?B?blQ4Sm9MSjBLWVVqTUZmTWJmS3hUUGRHVXRPOWRhMVpCMjdoVGxOSzM1RnhN?=
 =?utf-8?B?R2JNTW5jOGhVTUNHbm9FcERvTkp6V2ZwNU9ZTzgvUDRJMHJtTkwvRitkcVFG?=
 =?utf-8?B?Mzgrc1lvZVV5SDFnLzNjeDlSRkY2N0dicWpQZXQ5SUlaWE5nT2UrSTZON0dP?=
 =?utf-8?B?NzFERmxoMGZPZ1JiN2RadldpWk9TYTc5eThMdXorUXBTT2tRM0YzWW5EWFRI?=
 =?utf-8?B?Y2tIbGVnOURUU1M4R09uWWp0TCtMTlFSMHFBdzNEYlNTeHd4MU5aeG1iV2lj?=
 =?utf-8?B?dTEvaENzRW5xUHU5WTQyYUJGUXdGNzBKS0NWZENJUkwrZFF6bGlpZW9zVyt5?=
 =?utf-8?B?d2hDZ01OOGNKamlxTmpuaWh1bG5nSEpaOU1VS056d0VmaVRCdzlkMGoybFlJ?=
 =?utf-8?B?dnRQNGxybU5vVFhTc1QrQXhJVmplQzZLcWRCQUc3WjFBVUxjTS91WUFjdlhQ?=
 =?utf-8?B?ZE03RUpmZWVrdjRSYnRBVGsreHMzRlZXTWZBdzhxckJZRkt5d0tSaFh1Q3dC?=
 =?utf-8?B?V0pQOGpETHVxejFEbEZmWHBTOGhoeFlXbGNyd3RERDRoZnVkQk5sRGw4Mnp0?=
 =?utf-8?B?S0xwWXBYZ0lwNG9laEF5R0lDU0wrZjhCempaN0trcUE4WEgzOW1VYlNqWjJZ?=
 =?utf-8?B?SHZWS1pPNnkxTjdyMkZqQnFQdExaVm5wNmp2aVJDSTVTQUhhMjIxcnBDdnJJ?=
 =?utf-8?B?UXRpVmVDbnN6emVaQUxnMzljZWpaVnV1Wk8vTXZPMDkzQWpOYmZrUU1FakFB?=
 =?utf-8?B?Mmw2YzF5a1UyMFo2aHdGcmRKRk4wRWUyMHdrb2h6SUhIQjZWYzVhK1c4bnlK?=
 =?utf-8?B?R3dtSm1laW14T0tpMnNHZ2UzMDdjS1VtL1ZmcDZBMVVlYk54Z0VKUU13T3lh?=
 =?utf-8?B?MkQ5WTlMNjE5MzdnZUxLNG5xNmdPTzE2QitSTVpkMU1pR25jTkQ4MUNjcjNJ?=
 =?utf-8?B?eDAzRWRzK0pGdzJIUGtqcm51ZnhjeUJJUndQRzJqYnhtVGZiNWNlMStwL0Zt?=
 =?utf-8?B?NTZSaVpqWFJhVzNBSGFwNnlTS3VvbXFOTmVDYmV5T2hqaFNqanBBeXlVeGJq?=
 =?utf-8?B?R2haNC9hRklXd0xDdkxad3RtYlAySWwxV2FuRzBXQjBFeEovUGpuaFBTY2lt?=
 =?utf-8?B?bXVIMzlMNjdjam9WdFFxS3J6YTFBcnordWNSZnhJVmQvM08xTjh4VERQbWhX?=
 =?utf-8?B?Um53QkNYZEJ5SHRLdit0TUJPb05LWHNMa0x6L096eGt2dmw5RStvRk0wUTlO?=
 =?utf-8?B?bmprN2xVRmJWejBTVzVzaGN1TnBWOFdOeGVQTktBMEpRRCtwRzZkS0VzVFF4?=
 =?utf-8?B?WU8xcmNiTFpxUnhsVGpFM1FSeFJ5TkNVNmhqQmxNRFlaSTgxTmNJRkZnWmpB?=
 =?utf-8?B?YkduenErUUhhUEpqU1BTRUdHM1B1UEk3Vk5uN3ZIY1dtUEFKTkRhSTFkN0kw?=
 =?utf-8?B?amdDa2VCclZBOWpheHE0cSsxd1VjY29kZkpJR1A1NTBUQkk2U25MMUlmZlI4?=
 =?utf-8?B?MTVodXUwV21SblRrMEhIakxJQmZvS3YxVTdLNzZWeHB5TDAvNkVtUHQ4MW82?=
 =?utf-8?B?eW9LTFdBd0FRa3Q5blJXUk9sWEhRV1FpcGR0eWlWSlFlMis2THdhR1NMSTNQ?=
 =?utf-8?B?L0g3ZlV0TmRJV0hwWHlkUHNPcGt6ZFNLOVc1Ky9OQ2twbXpKUXB0Uzh2Slg4?=
 =?utf-8?Q?0/uVHza+dLidQu21YiUWjyi3z7aDsU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTZUMlhSYUd0anJBWFprZ1ZzYUhneWwycnRnR2MyT0tMYWtPUVE0TzBXOGhq?=
 =?utf-8?B?NDBITlVVZ0dGSkxwMGhQSE9qWjFDdWQ2Y3V2cDdQdC9mMUZDU0dNNjlUTWd0?=
 =?utf-8?B?Z1lFNFh5SHcyOWc4MjAvMHlFa1UvNEh5RjJ0Y0MvbVZWTHpwSWtMZFZSN2h2?=
 =?utf-8?B?YjBhYUFsa3k3enFDRnZCZzY3Z1hoOUZJa0taWmZoc3FhZFI4eUNtN0l1NGJw?=
 =?utf-8?B?dkpQOVU4MjVnUzIxK01jSkZySFZkR292NjNoT3hzQ00yN1RBcndRUGVxRUw4?=
 =?utf-8?B?NWxDWkJPdXYvQ3JBTVdPYnNNVVhIYVROeEhBS2srQUZUdVI2S0dBQ2drRUhY?=
 =?utf-8?B?REt5c1FuNi9yN3pETTl2NDMwbVFXemkzOVdTZ0VNVU9COGVMeUZwM2kvT2hS?=
 =?utf-8?B?dHpsR3FWMmtSQnpncFFZWnduWGkzWkhOKzA3eHFrR256NE40Y3dLWmRIdUhQ?=
 =?utf-8?B?clBpRWMvVUxqc0h3S0trUDB4NzNSMDlIS1pYbnVsMnZjdjVQWFBNbXQvZVJL?=
 =?utf-8?B?Yk5Cc3k5WE1VS0w5dEN0VmFvdXFsOEdJOVAwMFBJSitzY2NhbGQrelJaRldP?=
 =?utf-8?B?MmJjZTFqK25oMFhLRzc4c3FUOG1oVlFUSi9Md2pOU3FtNVViTWRyZGdkM29T?=
 =?utf-8?B?MXNIMnJ4bEFadFNoejI3QmxqWjAvcXZKc1JXd0NKTWkwUWsxaytnSW1yWktV?=
 =?utf-8?B?Z0dPWUQyQVJDRHE5L0taQmhhU211d1BDcTJxbXdnMmY4bXJsVFh3cWFSZjJV?=
 =?utf-8?B?Y2JBRTBJZStJd3Bxd0syNy9oSWhsekhwb1k2Z3ArVjljZTE2enJhZHNWYnhj?=
 =?utf-8?B?TmszVm9LeDRYS1VZT0pRWGkvUUpmcXpiSXpkdXRTSnhxTFRXTWYvQUxjTDR5?=
 =?utf-8?B?SXFiVHJCMDQwNlZ6c0N1dWdCRDlNUTRkc09iaHc5MjhSV1VnWUdXSjdZK2Q5?=
 =?utf-8?B?NUhad3ZyamoxUXEyWXFzb0R6bU1UR1pydkNsL2I3UlJDMy9Ddlc4Q3Yzb2Nx?=
 =?utf-8?B?V1pZMjBHRzhheGlhVjJKL2hqck1MV056akVBSlJYNEVPYmhxN2lpYzdNa3lj?=
 =?utf-8?B?UWJ0cWlKYUxxZGJCS1VSM25NVmlQdkxyZ1QxMWJDR1JtZS83emdwZzhJSUt1?=
 =?utf-8?B?UXZOdTdZTk9hQmwwK2txSU9yQmJXUk12TDVXTzMvR2M0N1RrTmV6RVF4cWts?=
 =?utf-8?B?VC9BMTh3b1crWmdzcWpjREp2cGwvdXh2RTYyN291bDlQZlF6K2tWTWZDM0wr?=
 =?utf-8?B?SXNPYk15WEVrOFo4Vjl1bnBJcUowUE9YMUxpMTJkRUFyak1WK3Q3WldLTGJy?=
 =?utf-8?B?NmVlc1p1dFFpb3Z4RTgxYVV5YXBkenpsUFFWSnVkYnIyKzNVcnJ0UkZ5c3pM?=
 =?utf-8?B?U2tpMVJ1MHhTampxSDRjZkFINTZNT2pnSHJCTFU4NldlSXh6ajFrdXZnRW1x?=
 =?utf-8?B?S2xVaTlqeWhKQ0QzV3NyNGp1OVo2aEMxZFFBVGVFZ2EzMkROL0JIUEFLbWxo?=
 =?utf-8?B?UDJMTXplekp6QXBPalRlVUNOakhhenpIYUJHUVpYYmx2STNYYzJ5RlZkSzll?=
 =?utf-8?B?bys3cFBYK3BKaWhQcTBGYndWbXI5ZTUrcEFicXdtK0hOWGpxRUt2RDN0SFpK?=
 =?utf-8?B?SXpxRkczbnd6UmkrVi96UkZINWhTbkdmdzIvVHNVTDk4VTJMSnQ4WXE3c2tD?=
 =?utf-8?B?bFV2N2VqK2ZSaFkwRUxPOEYyNlArRHNsd0Q1NGx3RkIvRUU2WnFEMk4wc3hw?=
 =?utf-8?B?MXpUOHpheGkva0c1SXYzWXBZNnVQWGo3VGcwNEc2RVFIVmVIQTRGT1dvOGdm?=
 =?utf-8?B?Znd1Q1ZsNSs1VHpLVHhvaFg1NHpXSkp4R1lwNHBaSlE3bUR2ZHdqZDU1MkJo?=
 =?utf-8?B?eURsUFdnUFE2WFdiM2hNQXVXeUdtSjNNSGdCVk9qcVRSZ0U1NDVhajNaNTFC?=
 =?utf-8?B?eEcwMmRkK1Fxa2g1UGF1UG80ZTErUmMxTnNSdHk4V1pZMDBrM0hKa1AyOFIw?=
 =?utf-8?B?dHBYcGk0YXRoc3pVbWlXdmV3RXVWS2FGZ2QzeUVPRkltZDIvbmsxUFRTb0hm?=
 =?utf-8?B?R1NUWVZGdTJHNytlZ3lGdjZUU3lKQlBCMk9zNkJtWi9TTHdTeERkYk5KZkVS?=
 =?utf-8?B?WWd5UHFXRVh5VHNUeCt4Wkx1T0NabDM1cjZsTC9zYVczY3gvZ2ZHNTFyclgx?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBB458611E0EAF4D90795C0CCB63272C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f20d8d3-2f5b-40ce-7282-08ddb9c43f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 23:57:48.6444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8taA/bPchiUbhsilRMtwxSITQtpsixBxxCjrjy/CFn5w0GlYvWsIEycjAT1JlihN6VqE/oi44nK8Vyq8tlmIdalaXpqbFtnoJ49MwJYKI+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8529
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDE1OjE2IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IEFzIHlvdSBzYWlkIGl0ICpzaG91bGQqIGJlIHNhZmUuwqAgVGhlIGtkdW1wIGtlcm5l
bCBzaG91bGQgb25seSByZWFkIFREWA0KPiA+IHByaXZhdGUgbWVtb3J5IGJ1dCBub3Qgd3JpdGUu
wqAgQnV0IEkgY2Fubm90IHNheSBJIGFtIDEwMCUgc3VyZSAodGhlcmUgYXJlDQo+ID4gbWFueSB0
aGluZ3MgaW52b2x2ZWQgd2hlbiBnZW5lcmF0aW5nIHRoZSBrZHVtcCBmaWxlIHN1Y2ggYXMgbWVt
b3J5DQo+ID4gY29tcHJlc3Npb24pIHNvIGluIGludGVybmFsIGRpc2N1c3Npb24gd2UgdGhvdWdo
dCB3ZSBzaG91bGQganVzdCBkaXNhYmxlIGl0Lg0KPiANCj4gU28gd2hhdCdzIHRoZSBzaWRlLWVm
ZmVjdCBvZiBlbmFibGluZyBrZHVtcCwgaW4gdGhlIHdvcnN0IGNhc2Uga2R1bXANCj4ga2VybmVs
IGNyYXNoZXMgYW5kIGluIHRoZSBtb3N0IGxpa2VseSBzY2VuYXJpbyBrZHVtcCB3aWxsIGdlbmVy
YXRlIGENCj4gbG90IG9mIGltcG9ydGFudCBkYXRhIHRvIGFuYWx5emUgZnJvbSB0aGUgaG9zdCBm
YWlsdXJlLg0KPiANCj4gQWxsb3dpbmcga2R1bXAgc2VlbXMgdG8gYmUgYSBuZXQgcG9zaXRpdmUg
b3V0Y29tZSB0byBtZS4gQW0gSSBtaXNzaW5nDQo+IHNvbWV0aGluZz8gSWYgbm90LCBteSB2b3Rl
IHdvdWxkIGJlIHRvIGVuYWJsZS9hbGxvdyBrZHVtcCBmb3Igc3VjaA0KPiBwbGF0Zm9ybXMgaW4g
dGhpcyBzZXJpZXMgaXRzZWxmLg0KDQpUaGlzIHJlYXNvbmluZyBtYWtlcyBzZW5zZS4gQnV0IHRv
ZGF5IHRoZXJlIGlzIG5vIHdheSB0byBldmVuIGNvbmZpZ3VyZSBrZXhlYw0Kd2hlbiBURFggaXMg
Y29uZmlndXJlZC4gSXQgYmxvY2tzIFREWCBmb3IgZGlzdHJvIGJhc2VkIGhvc3RzLiBLZHVtcCBj
YW4gYWx3YXlzDQpiZSBleHBhbmRlZCBpbiBhIGZvbGxvdyB1cC4gVGhlIHNlcmllcyBoYXMgYmVl
biB0cmlja3kgYW5kIHNvIGl0J3MgbmljZSB0byBub3QNCmhhdmUgdG8gdGFja2xlIGFsbCB0aGUg
YW5nbGVzIGJlZm9yZSBnZXR0aW5nIGF0IGxlYXN0IHNvbWUgc3VwcG9ydCBiYWNrLg0K

