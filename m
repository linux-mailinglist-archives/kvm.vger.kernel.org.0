Return-Path: <kvm+bounces-26155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D60AE972423
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54E1E1F2456E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC60218B47F;
	Mon,  9 Sep 2024 21:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bvDnPzX+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE016178CC8;
	Mon,  9 Sep 2024 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725915843; cv=fail; b=VSyaAVb4G1ZhZHW/i8J5jNty9wEOcAFvCd3x2HMbAhLNiqJQyYF1MTohe5CVFtfmJECbfpgsBDGSCM1iJarHAOvro7uQT6Iv5QIZVlz6LXfuNXoDYYrGO6brdj7AoxKvxpiAhu6PDnEr7yUnTTwwItqr0UB9Zw9QKpHrFMasXdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725915843; c=relaxed/simple;
	bh=vjOzv1tx2bCx/bSPgahqn4gq3igv1sj2KkwrK6FNleQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dTlT83U7q3ICDHDw0qsdQBTgngyxmx7YUcrfRRRVNhI1imM1UH5agdQXmGzJVmQYdzBnWMnhfAsA+1vyI5Bl8UA6+195ZBiSGKSFFovoxYO/Ll5V6K1mxMbhOr7bByZ0JiPZXfouISED9c960V+gMQIddd7sDNwumVWcAta+33Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bvDnPzX+; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725915841; x=1757451841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vjOzv1tx2bCx/bSPgahqn4gq3igv1sj2KkwrK6FNleQ=;
  b=bvDnPzX+TiwOfNIK8bJRGfGY7OZACPuhZInFIhYoGUmsX6jOpvFxDzA5
   fsHccJ9kDQ3578qN0So6NzdoIsharE+l3CPX/JFvn2xBNZnRRk5DZS3tk
   4+jWHSfj586oDyM7EZFavucl2GHZh75fyMdZxFpJfcXZSveHMO6LrbY81
   y8Bp4tXvORaLkCGURwBSRQMVBrsNHdRXsiNBWpD0sBy5lfaL8sSsZNUTV
   fC7gnubBDNu3g2PCHmDY54+4vXP12EeLueg8C6HZ4OUgJDq9/KzDhhN5r
   nnX9hHVrdeQ+7TX2HK7p301HWviP8ot7RE9xmkwp+ouiizHv+uam9gYtf
   g==;
X-CSE-ConnectionGUID: TYbDX7tmRfyNITMe/QNAdA==
X-CSE-MsgGUID: XHMtpjIgT/64fJ6Ylqu6zQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="35230431"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="35230431"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 14:04:00 -0700
X-CSE-ConnectionGUID: xfZaFJ+sTC6vkTgmm6XLxQ==
X-CSE-MsgGUID: iTb1CtStToqX6r9xWMz4EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="71766829"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 14:04:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 14:03:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 14:03:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 14:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtciElJIQsciKFyduOOurl6MXmhvzpo122F1n8s1KEgkUfD0XKAVw1cKzngH2byYtSqXuMoZTnaaLULAwRNMvDgc1NVGW1IlvZV/NNTsjpUITYURkSq8LNcg2lruaPtypXWCy/39Aq+MP3eMjhI8BbfBTpYmwITS/dJuxyEgDDk3XjbQUC3Q+ve3OkiaY7WzQPrN4C3KvBdJHYmp1FWtoe9qMCjrpmfXkNZlGzb+Vn02i5eH4E2MXP/e6epITnadtsY5RajY14hrJPdv0GIHbFX/I/LczlX6nMrqfoA8hTz/d4SRN1+O6h5jQi3VL0PmGiWjyj7v4M5dAovH5051XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjOzv1tx2bCx/bSPgahqn4gq3igv1sj2KkwrK6FNleQ=;
 b=AqKuIZUO/dQjlW+Xm1buPEWDQO0IN9erqFqdxnkfFyUMABcjL6KXO9ko6a3FJELNPcxbTW5tLnasApfv8/Smw33vufdtKehWwVDCS6BMbyYfvwACZpME5wAZFXrKBe05JlPp9yNCulqKfFPvgZ0wBt8MYH2MtK4zDeWsFVhXPoMKtKaLLaiKWh690Ivwa9zGaB3JruXJUi/ZCwmZwKq1T0BmugVr5Dtc12cJsm3htrWqsfiMVFiRZ+RQTpZEVVmz7uH1cfY8BsIo9BXwHXZc2UzRRpIt6jc56XxhnjNJhI5Vm8bam7ulsnIxbpuI/Wdk3Q9dFL7PJohXR02lTkVkSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6725.namprd11.prod.outlook.com (2603:10b6:806:267::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Mon, 9 Sep
 2024 21:03:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 21:03:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Thread-Topic: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Thread-Index: AQHa/neyIdr6hdDmIkGAByVbUnUe27JKBtWAgAXzzAA=
Date: Mon, 9 Sep 2024 21:03:57 +0000
Message-ID: <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
	 <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
In-Reply-To: <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6725:EE_
x-ms-office365-filtering-correlation-id: e9bd996b-a4ff-4984-f6bf-08dcd112eb88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z1BBRVEvNWZTRm8wSkxmdDl4cW13R3UveXlKay9SRXRYRVFXRXlGS3R3VjZQ?=
 =?utf-8?B?QnJTWEJ5RVUvaEN4aFZOZk15NWF2dmQzbFlXOWtVNXluMFo4WmkvbmRtVVoy?=
 =?utf-8?B?RnV6aWxVaUNBRVYyeHQrSzFObDRmWnR3MzdaekJBK1kxZitYRThMais2bEdX?=
 =?utf-8?B?ZkRnNm9Fa2dLMXdQM2dFbGZTRzFicUNudEVhMTFhUzdrdHVKRWY1WWpEQk41?=
 =?utf-8?B?bWt4T0QycFBENkNqZFVZOHg2LzlxVjdUYW4yaHRSNjIrUlpCeXN0ejRldmQr?=
 =?utf-8?B?elBGU1FYbTVmUVJybUFWWndzNFhrc3owRk1TdVNnNHZCRWt6V21IcTVGeUwy?=
 =?utf-8?B?aVBBelhNenMxY1FYcWJDaUZNdERKbVlzdlg3cFRGREZkai9wWWxGbXAvcVd6?=
 =?utf-8?B?MjhKUjg3a0JrSGQzRXgyc0kyejZKUHhQMGNVdmV4bExCUFVIME5TQjNMeXFR?=
 =?utf-8?B?NU5tK0l2WHdOSk5IbzJ4eUg5NWdzVEg2Yzh6R2JTdmFGaXBoV29RRGYwTVJP?=
 =?utf-8?B?R0ZHak5FallQMitQTElaQXVTN25xOStoRkozWUxjU3RVZmxyS0ZmR0I2dmpj?=
 =?utf-8?B?UlloUmtpNlpOVEcveGhWaC9PYXJtRStaOG8raERoakVBOXdDelFxQ0hReWZx?=
 =?utf-8?B?T2xDbC8xOVdXdEIvUlB4WDZaT0paaWllZXI0bUtJWUFlM3B0UXcyTUQ0dGhp?=
 =?utf-8?B?QmJVS1MxeUlLSm90aUExMVFtY25PQlNvQTJBSTdTaC9tMDlBVVlMN1RzVitz?=
 =?utf-8?B?Z01MS0F0ZGRVL1dmRVZUWVh2WVJMWkk1WlRyRUZtQ0VDY2VaOHVqRVdNWEJY?=
 =?utf-8?B?OVIwRDRsTFcwbmV6UFFiOWpLTVdRbmtCU2FBVVZRYk9iekljWmdzb0ZCOXMw?=
 =?utf-8?B?RzdjVUlOY09oNGUyVEkwVWdNUGI3VTJXT2RsUVhpb1Y2aWJEWHc4Lzh0b0h1?=
 =?utf-8?B?U3VTc0E4S096QWN6MFJPK21IcGE3SmVCMHQybU04bWJvbnNvb05TeEtpYmE0?=
 =?utf-8?B?c3p2R0Y1ai80c1VlbmQySXAzd2RaQ3hFZXdYY3NnOFJXZFNiVU1kTHR2b0Fq?=
 =?utf-8?B?UXl5T1pDQlNoQVdHZGROYTdqU2ZIZnU4SGUzNEx3cVRpV0pRQlY0T1I1ODN1?=
 =?utf-8?B?cVllL3N2d2paT05rR2tXckdMb3JxcjlEWklvQjJtakxza2IvN2JNSTg4aHdK?=
 =?utf-8?B?NnRvS1E3Qlh6ajVmUys4Zm9UUEdKUlNsNEg3dmdwNnk1Y0Zia29WR0dMK2FZ?=
 =?utf-8?B?S04ya0cxRkFjV0hic1M1U1V3c0xPQTlZSFUyT2themlub3FyQWxMeEwydUxa?=
 =?utf-8?B?MkdWUTdKd2VkOFA1QnV4RmxGcXM4SUZmbThvTHdqaUlGMVVZSVhsUDJkMGxP?=
 =?utf-8?B?b2VpMll3NDZMNG5LVXhFU3RDUHdLd0xSN0ZTTkVNdVpwdFZIK0FLaXUwTkpG?=
 =?utf-8?B?THJzOGpMc3VBMkwwM2JsSUttRklTaVd2VjJDTHpFazFhdEd1MVNBanpaSFRR?=
 =?utf-8?B?WjVWQnd0WDFwNlpSNWpycFBiTWhUNDN5czN0OWlRN0x3SUxYWTB4NlFTdWVC?=
 =?utf-8?B?N0wvazFNTTdMeUEzeUJBVDI3R3pKNG5vWWtwSVpOL2hUQVZaQk52c1ZGczNt?=
 =?utf-8?B?WHBJa0xZYVoybzcvVi9HTEZpMkFqZ2JwSU1CcEo0RGUvYUliTkZLTk0vRFlF?=
 =?utf-8?B?eFYwRkcyMU01cXZzYmNkcnpFKzM4UHRRU1VTRWRwYzVaYXFUSXhhaTltRHZQ?=
 =?utf-8?B?SVhRNXJEbG8xZ0xDamVSUkl4MjVsMjU0T0ZLcHVyOEZxZ1owYTUrclBaaGlR?=
 =?utf-8?B?c0Jyd0NxVUJJODZjckFXMklSZlQ5RzFOYjdvc2k0TUhxdkxkd1V1WmRsSHh3?=
 =?utf-8?B?MUtycG9LbDcrZUpHOW42c050R3ZIZGYxK2c2SEJoRlNDOHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFVKYkRIYWNKSm83S011bVpFblNZaGxwVzdaUm1UamkvdlZLWWZYVko2dHBB?=
 =?utf-8?B?a2xaZGJPeC80RzVGY3AzaGVUUTRkRmtXT2VhYWRwU2hIczF4cDVta1Uyd0xl?=
 =?utf-8?B?RFF3ZXhJZ1J0OU5YTms2RHdNSUVJODA1NitiakhhdDA3R0R3QksxdFR6UzBY?=
 =?utf-8?B?NHBiRzdsenBHYWxQb0NEVThON0pUVStiMUx6YWpyVk9lanNUeG5YaE9jRkhU?=
 =?utf-8?B?cml2d2hyamlwYXhhRWIrSFAzTzFtdkhPbGltWjBVY2Qwa1VqR0hTZHpFd1Fi?=
 =?utf-8?B?QXVHSGZ4STY4UVVMVW9VSnVzV2NwcEZ4aUhheHAyUU9ZbmN3UXpPWEZmK3BP?=
 =?utf-8?B?d3pmK2xZQ2ZoQWQzZEpFUlJhMlk1QlV2K2diOUxyN3VCNDVWTXBnS1FBOWda?=
 =?utf-8?B?Rjc2QXZobTRPZktob1kvZGE3ZDM2WnowVmZ0eHhqNGltYVYrTVR3K0lhQkQw?=
 =?utf-8?B?a1FJZUF4WFp6RmMrM0c0am5BUGJWMjNSUkNoTEZrbzlEemhvYyt2RU5KYjRJ?=
 =?utf-8?B?eE5Va0cvaGxEaCt3Qm9zQkNKelpYNGFNSTdDM3d1UEpRdFlpYXBQcDl1WDgv?=
 =?utf-8?B?RFM2dmJRc2RLanFQTjZNVEFDOW5nYTNIT3g1dTBYSUw1QTVyWWt5bUE5R0l4?=
 =?utf-8?B?TStCUFZSTDEzeTVRU3QyOFFUQ0p0SkowYWY2VmEwc2dCQ016NnY0WDYxS1g0?=
 =?utf-8?B?b1BwbjVpcEc0OHpmS1lIbWVjSkhTUmdVS1pXZzVqT1VvYnFraHBLU0VvNHdJ?=
 =?utf-8?B?T3VsYVNyU1EwNjhxUzJic3JVQXVHZGpBSUx3ZEdnbG1SU2VSZWlYVDIwUC90?=
 =?utf-8?B?Mk5xQW8xWXFOeGNrZ043b3pWSEsvUVFEbG8ySmVqVlFQa09sdjdaR0oxRVNm?=
 =?utf-8?B?M1psZGNjNXp5eWJzSGQ2ZC85SFhpQXdLTGdKcmgrc21PTUJpRmQvb0tjajNs?=
 =?utf-8?B?MExOUGVNdHIyc0JURE9Nc2tCd3ZkdVp4aXc2TWR1bW5FeEdUZitGSWF2Snlt?=
 =?utf-8?B?aE9uWkFPMGIxcEgvVGY0WVgrS2ptQVYyRUxKc1lMZDdQbUFxZTRBeldYbGVk?=
 =?utf-8?B?UjRiRDl6cUxNalg2V1RJSHZLY2pMTTh0OTdpTkNsWG5EVWc2Qmo1ZTBCUHlv?=
 =?utf-8?B?Tlc1elQ5ckV3VzZ0WEIycEtkZUhsaGwxYm5QdElKZmVjaVkyOEZ1YWtQekRW?=
 =?utf-8?B?akcxL1BoWGJDeURranZlcG1vcGY4STZ1NlVueGJKNWIvUGwzN2pLalBYWkVo?=
 =?utf-8?B?TWNQTmpGSm8wNVdEa3crVnJ1cTQxdUpZOEEyMkZUL0Uvb2dWTmxteEN5QUp0?=
 =?utf-8?B?cmlreEFoRnVkUStXL1BWdkFzRGh0aE9ibktaRENla09zdllvN0Y3ckdEUDBR?=
 =?utf-8?B?NWRWUDV4MERJRjNKL3Bub1ordnVOOEt1c1F4YzFIc2dBVGtpU0dQNDZMMHpV?=
 =?utf-8?B?YTM1VEdtYnNhU2ZhZWVTcENNalJDQlcweHRBVkRuT0ZZOTF2T2lYVFlSWVYv?=
 =?utf-8?B?RFRUdEd1RTRaeHVRVjlvckpmcExpT2pFaXVxcU9ubFhxWExqU0dKZ0ZuYUgy?=
 =?utf-8?B?TjVjbS96TVNLeHh1VmlZUEoyYXZtbVIrUUZjTWRvbjZvczlrZjVXRkRpbWd3?=
 =?utf-8?B?U2dPdU5aYzArWGtaa0J6YU9BMzNUdHo1SVZhTWcwSUViTXhvYjRtVitjeVVM?=
 =?utf-8?B?clAvY0h6OFJUQ21ha3JCb21tdm1qbGh6K2ZlRjNUQUd3N2N6MURZdDF5Qndn?=
 =?utf-8?B?Q205UFUxNW10S0ZleWt6Q0UvajkxUkVmTmdpbkc2dXZJWXYvbXZaR1NTMWNv?=
 =?utf-8?B?ZG40UWRBVDlZUHU3bHVCRk0xTk00V1M1K0FLMTFwTDlHSWgyM3dHc3ZhSjdI?=
 =?utf-8?B?T0Zwb1JmUE54WUU1Q0Q1eTBtbEUwUjVxQitBWmxLR1VQaHh0a0Q4SHUwUlJq?=
 =?utf-8?B?alpsTWF4RG41VGNRNWxtajlaNldVN0RFdlp2LzRrYlpjOTBPY0NieS82Vk5a?=
 =?utf-8?B?bmRoV2xhaThDZXdVQzh1ZFJ0cHZRZVdPdHVKUjdPdWh5S0FLR25lWWZXZWFS?=
 =?utf-8?B?SHBJMmd3MSt1Q28rZy9FTE5seWF1OVNMdWdmOU5kMUFCY3d6a2h4NHNJMitj?=
 =?utf-8?B?N21ub2JGRVk2ZzYvVG9GWFlJTHpUSEVDRVRGRXNmUGhuRGVJdTMxTURpR1gy?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <541CA252A39FFE46AA26F2AE478288C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bd996b-a4ff-4984-f6bf-08dcd112eb88
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 21:03:57.0847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U61LL+U1qxLVey75svTX0tPUntqXbMOvpvzW/apMK9vJ4crNvFtgJB53b3fFJjJuioyjeZgd4WMzS2jmD5EYAt0UPIKFG51pdlZMUswXK+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6725
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDE0OjEwICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOgo+IAo+
ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9tYWluLmMKPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvbWFpbi5jCj4gPiBAQCAtMzYsOSArMzYsMjEgQEAgc3RhdGljIF9faW5pdCBpbnQgdnRfaGFy
ZHdhcmVfc2V0dXAodm9pZCkKPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBpcyBLVk0gbWF5IGFsbG9j
YXRlIGNvdXBsZSBvZiBtb3JlIGJ5dGVzIHRoYW4gbmVlZGVkIGZvcgo+ID4gwqDCoMKgwqDCoMKg
wqDCoCAqIGVhY2ggVk0uCj4gPiDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiAtwqDCoMKgwqDCoMKg
wqBpZiAoZW5hYmxlX3RkeCkKPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChlbmFibGVfdGR4KSB7Cj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZ0X3g4Nl9vcHMudm1fc2l6ZSA9IG1h
eF90KHVuc2lnbmVkIGludCwgdnRfeDg2X29wcy52bV9zaXplLAo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNpemVvZihz
dHJ1Y3Qga3ZtX3RkeCkpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogTm90ZSwgVERYIG1heSBmYWlsIHRv
IGluaXRpYWxpemUgaW4gYSBsYXRlciB0aW1lIGluCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICogdnRfaW5pdCgpLCBpbiB3aGljaCBjYXNlIGl0IGlzIG5vdCBuZWNlc3Nhcnkg
dG8gc2V0dXAKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB0aG9zZSBjYWxs
YmFja3MuwqAgQnV0IG1ha2luZyB0aGVtIHZhbGlkIGhlcmUgZXZlbgo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIHdoZW4gVERYIGZhaWxzIHRvIGluaXQgbGF0ZXIgaXMgZmlu
ZSBiZWNhdXNlIHRob3NlCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogY2Fs
bGJhY2tzIHdvbid0IGJlIGNhbGxlZCBpZiB0aGUgVk0gaXNuJ3QgVERYIGd1ZXN0Lgo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHZ0X3g4Nl9vcHMubGlua19leHRlcm5hbF9zcHQgPSB0ZHhfc2VwdF9saW5rX3By
aXZhdGVfc3B0Owo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZ0X3g4Nl9vcHMu
c2V0X2V4dGVybmFsX3NwdGUgPSB0ZHhfc2VwdF9zZXRfcHJpdmF0ZV9zcHRlOwo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZ0X3g4Nl9vcHMuZnJlZV9leHRlcm5hbF9zcHQgPSB0
ZHhfc2VwdF9mcmVlX3ByaXZhdGVfc3B0Owo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHZ0X3g4Nl9vcHMucmVtb3ZlX2V4dGVybmFsX3NwdGUgPQo+ID4gdGR4X3NlcHRfcmVtb3Zl
X3ByaXZhdGVfc3B0ZTsKPiAKPiBOaXQ6wqAgVGhlIGNhbGxiYWNrcyBpbiAnc3RydWN0IGt2bV94
ODZfb3BzJyBoYXZlIG5hbWUgImV4dGVybmFsIiwgYnV0IAo+IFREWCBjYWxsYmFja3MgaGF2ZSBu
YW1lICJwcml2YXRlIi7CoCBTaG91bGQgd2UgcmVuYW1lIFREWCBjYWxsYmFja3MgdG8gCj4gbWFr
ZSB0aGVtIGFsaWduZWQ/CgoiZXh0ZXJuYWwiIGlzIHRoZSBjb3JlIE1NVSBuYW1pbmcgYWJzdHJh
Y3Rpb24uIEkgdGhpbmsgeW91IHdlcmUgcGFydCBvZiB0aGUKZGlzY3Vzc2lvbiB0byBwdXJnZSBz
cGVjaWFsIFREWCBwcml2YXRlIG5hbWluZyBmcm9tIHRoZSBjb3JlIE1NVSB0byBhdm9pZApjb25m
dXNpb24gd2l0aCBBTUQgcHJpdmF0ZSBtZW1vcnkgaW4gdGhlIGxhc3QgTU1VIHNlcmllcy4KClNv
IGV4dGVybmFsIHBhZ2UgdGFibGVzIGVuZGVkIHVwIGJlaW5nIGEgZ2VuZXJhbCBjb25jZXB0LCBh
bmQgcHJpdmF0ZSBtZW0gaXMgdGhlClREWCB1c2UuIEluIHByYWN0aWNlIG9mIGNvdXJzZSBpdCB3
aWxsIGxpa2VseSBvbmx5IGJlIHVzZWQgZm9yIFREWC4gU28gSSB0aG91Z2h0CnRoZSBleHRlcm5h
bDwtPnByaXZhdGUgY29ubmVjdGlvbiBoZXJlIHdhcyBuaWNlIHRvIGhhdmUuCgo+IAo+ID4gK8Kg
wqDCoMKgwqDCoMKgfQo+ID4gwqAgCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gPiDC
oCB9Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2
bS92bXgvdGR4LmMKPiA+IGluZGV4IDZmZWIzYWI5NjkyNi4uYjhjZDVhNjI5YTgwIDEwMDY0NAo+
ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYwo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC90ZHguYwo+ID4gQEAgLTQ0Nyw2ICs0NDcsMTc3IEBAIHZvaWQgdGR4X2xvYWRfbW11X3BnZChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGhwYV90Cj4gPiByb290X2hwYSwgaW50IHBnZF9sZXZlbCkK
PiA+IMKgwqDCoMKgwqDCoMKgwqB0ZF92bWNzX3dyaXRlNjQodG9fdGR4KHZjcHUpLCBTSEFSRURf
RVBUX1BPSU5URVIsIHJvb3RfaHBhKTsKPiA+IMKgIH0KPiA+IMKgIAo+ID4gK3N0YXRpYyB2b2lk
IHRkeF91bnBpbihzdHJ1Y3Qga3ZtICprdm0sIGt2bV9wZm5fdCBwZm4pCj4gPiArewo+ID4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IHBhZ2UgKnBhZ2UgPSBwZm5fdG9fcGFnZShwZm4pOwo+ID4gKwo+
ID4gK8KgwqDCoMKgwqDCoMKgcHV0X3BhZ2UocGFnZSk7Cj4gPiArfQo+ID4gKwo+ID4gK3N0YXRp
YyBpbnQgdGR4X21lbV9wYWdlX2F1ZyhzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVudW0g
cGdfbGV2ZWwgbGV2ZWwsIGt2bV9wZm5fdCBwZm4pCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoMKg
aW50IHRkeF9sZXZlbCA9IHBnX2xldmVsX3RvX3RkeF9zZXB0X2xldmVsKGxldmVsKTsKPiA+ICvC
oMKgwqDCoMKgwqDCoHN0cnVjdCBrdm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeChrdm0pOwo+
ID4gK8KgwqDCoMKgwqDCoMKgaHBhX3QgaHBhID0gcGZuX3RvX2hwYShwZm4pOwo+ID4gK8KgwqDC
oMKgwqDCoMKgZ3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4pOwo+ID4gK8KgwqDCoMKgwqDCoMKg
dTY0IGVudHJ5LCBsZXZlbF9zdGF0ZTsKPiA+ICvCoMKgwqDCoMKgwqDCoHU2NCBlcnI7Cj4gPiAr
Cj4gPiArwqDCoMKgwqDCoMKgwqBlcnIgPSB0ZGhfbWVtX3BhZ2VfYXVnKGt2bV90ZHgsIGdwYSwg
aHBhLCAmZW50cnksICZsZXZlbF9zdGF0ZSk7Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAodW5saWtl
bHkoZXJyID09IFREWF9FUlJPUl9TRVBUX0JVU1kpKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgdGR4X3VucGluKGt2bSwgcGZuKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gLUVBR0FJTjsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiAKPiBOaXQ6
IEhlcmUgKGFuZCBvdGhlciBub24tZmF0YWwgZXJyb3IgY2FzZXMpIEkgdGhpbmsgd2Ugc2hvdWxk
IHJldHVybiAKPiAtRUJVU1kgdG8gbWFrZSBpdCBjb25zaXN0ZW50IHdpdGggbm9uLVREWCBjYXNl
P8KgIEUuZy4sIHRoZSBub24tVERYIGNhc2UgaGFzOgo+IAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGlmICghdHJ5X2NtcHhjaGc2NChzcHRlcCwgJml0ZXItPm9sZF9zcHRlLCBu
ZXdfc3B0ZSkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiAtRUJVU1k7Cj4gCj4gQW5kIHRoZSBjb21tZW50IG9mIHRkcF9tbXVfc2V0X3Nw
dGVfYXRvbWljKCkgY3VycmVudGx5IHNheXMgaXQgY2FuIG9ubHkgCj4gcmV0dXJuIDAgb3IgLUVC
VVNZLsKgIEl0IG5lZWRzIHRvIGJlIHBhdGNoZWQgdG8gcmVmbGVjdCBpdCBjYW4gYWxzbyAKPiBy
ZXR1cm4gb3RoZXIgbm9uLTAgZXJyb3JzIGxpa2UgLUVJTyBidXQgdGhvc2UgYXJlIGZhdGFsLsKg
IEluIHRlcm1zIG9mIAo+IG5vbi1mYXRhbCBlcnJvciBJIGRvbid0IHRoaW5rIHdlIG5lZWQgYW5v
dGhlciAtRUFHQUlOLgoKWWVzLCBnb29kIHBvaW50LgoKPiAKPiAvKgo+IMKgICogdGRwX21tdV9z
ZXRfc3B0ZV9hdG9taWMgLSBTZXQgYSBURFAgTU1VIFNQVEUgYXRvbWljYWxseQo+IAo+IFsuLi5d
Cj4gCj4gwqAgKiBSZXR1cm46Cj4gwqAgKiAqIDDCoMKgwqDCoMKgIC0gSWYgdGhlIFNQVEUgd2Fz
IHNldC4KPiDCoCAqICogLUVCVVNZIC0gSWYgdGhlIFNQVEUgY2Fubm90IGJlIHNldC4gSW4gdGhp
cyBjYXNlIHRoaXMgZnVuY3Rpb24gd2lsbAo+IMKgICrCoMKgwqDCoMKgwqDCoMKgwqDCoCBoYXZl
IG5vIHNpZGUtZWZmZWN0cyBvdGhlciB0aGFuIHNldHRpbmcgaXRlci0+b2xkX3NwdGUgdG8KPiDC
oCAqwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0aGUgbGFzdCBrbm93biB2YWx1ZSBvZiB0aGUgc3B0
ZS4KPiDCoCAqLwo+IAo+IFsuLi5dCj4gCj4gPiArCj4gPiArc3RhdGljIGludCB0ZHhfc2VwdF9k
cm9wX3ByaXZhdGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZW51bSBwZ19sZXZlbCBsZXZlbCwga3ZtX3Bmbl90IHBmbikKPiA+ICt7Cj4gPiAK
PiBbLi4uXQo+IAo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgaHBhX3dpdGhfaGtpZCA9IHNldF9o
a2lkX3RvX2hwYShocGEsICh1MTYpa3ZtX3RkeC0+aGtpZCk7Cj4gPiArwqDCoMKgwqDCoMKgwqBk
byB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBURFhfT1BFUkFORF9CVVNZIGNhbiBoYXBwZW4gb24gbG9j
a2luZyBQQU1UIGVudHJ5LsKgCj4gPiBCZWNhdXNlCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICogdGhpcyBwYWdlIHdhcyByZW1vdmVkIGFib3ZlLCBvdGhlciB0aHJlYWQgc2hv
dWxkbid0IGJlCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogcmVwZWF0ZWRs
eSBvcGVyYXRpbmcgb24gdGhpcyBwYWdlLsKgIEp1c3QgcmV0cnkgbG9vcC4KPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBlcnIgPSB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkKGhwYV93aXRoX2hraWQpOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgfSB3aGlsZSAodW5saWtlbHkoZXJyID09IChURFhfT1BFUkFORF9CVVNZIHwg
VERYX09QRVJBTkRfSURfUkNYKSkpOwo+IAo+IEluIHdoYXQgY2FzZShzKSBvdGhlciB0aHJlYWRz
IGNhbiBjb25jdXJyZW50bHkgbG9jayB0aGUgUEFNVCBlbnRyeSwgCj4gbGVhZGluZyB0byB0aGUg
YWJvdmUgQlVTWT8KCkdvb2QgcXVlc3Rpb24sIGxldHMgYWRkIHRoaXMgdG8gdGhlIHNlYW1jYWxs
IHJldHJ5IHJlc2VhcmNoLgoKPiAKPiBbLi4uXQo+IAo+ID4gKwo+ID4gK2ludCB0ZHhfc2VwdF9y
ZW1vdmVfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLAo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGVudW0gcGdfbGV2ZWwgbGV2ZWwsIGt2bV9wZm5fdCBwZm4pCj4gPiArewo+ID4gK8KgwqDCoMKg
wqDCoMKgaW50IHJldDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoC8qCj4gPiArwqDCoMKgwqDC
oMKgwqAgKiBIS0lEIGlzIHJlbGVhc2VkIHdoZW4gdm1fZnJlZSgpIHdoaWNoIGlzIGFmdGVyIGNs
b3NpbmcgZ21lbV9mZAo+IAo+IMKgRnJvbSBsYXRlc3QgZGV2IGJyYW5jaCBIS0lEIGlzIGZyZWVk
IGZyb20gdnRfdm1fZGVzdHJveSgpLCBidXQgbm90IAo+IHZtX2ZyZWUoKSAod2hpY2ggc2hvdWxk
IGJlIHRkeF92bV9mcmVlKCkgYnR3KS4KCk9oLCB5ZXMsIHdlIHNob3VsZCB1cGRhdGUgdGhlIGNv
bW1lbnQuCgo+IAo+IHN0YXRpYyB2b2lkIHZ0X3ZtX2Rlc3Ryb3koc3RydWN0IGt2bSAqa3ZtKQo+
IHsKPiDCoMKgwqDCoMKgwqDCoMKgIGlmIChpc190ZChrdm0pKQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiB0ZHhfbW11X3JlbGVhc2VfaGtpZChrdm0pOwo+IAo+IMKg
wqDCoMKgwqDCoMKgwqAgdm14X3ZtX2Rlc3Ryb3koa3ZtKTsKPiB9Cj4gCj4gQnR3LCB3aHkgbm90
IGhhdmUgYSB0ZHhfdm1fZGVzdHJveSgpIHdyYXBwZXI/wqAgU2VlbXMgYWxsIG90aGVyIHZ0X3h4
KClzIAo+IGhhdmUgYSB0ZHhfeHgoKSBidXQgb25seSB0aGlzIG9uZSBjYWxscyB0ZHhfbW11X3Jl
bGVhc2VfaGtpZCgpIGRpcmVjdGx5LgoKTm8gc3Ryb25nIHJlYXNvbi4gSXQncyBhc3ltbWV0cmlj
IHRvIHRoZSBvdGhlciB0ZHggY2FsbGJhY2tzLCBidXQgS1ZNIGNvZGUgdGVuZHMKdG8gYmUgbGVz
cyB3cmFwcGVkIGFuZCBhIHRkeF92bV9kZXN0b3J5IHdvdWxkIGJlIGEgb25lbGluZSBmdW5jdGlv
bi4gU28gSSB0aGluawppdCBmaXRzIGluIG90aGVyIHdheXMuCgo+IAo+ID4gK8KgwqDCoMKgwqDC
oMKgICogd2hpY2ggY2F1c2VzIGdtZW0gaW52YWxpZGF0aW9uIHRvIHphcCBhbGwgc3B0ZS4KPiA+
ICvCoMKgwqDCoMKgwqDCoCAqIFBvcHVsYXRpb24gaXMgb25seSBhbGxvd2VkIGFmdGVyIEtWTV9U
RFhfSU5JVF9WTS4KPiA+ICvCoMKgwqDCoMKgwqDCoCAqLwo+IAo+IFdoYXQgZG9lcyB0aGUgc2Vj
b25kIHNlbnRlbmNlICgiUG9wdWxhdGlvbiAuLi4iKcKgIG1lYW5pbmc/wqAgV2h5IGlzIGl0IAo+
IHJlbGV2YW50IGhlcmU/Cj4gCkhvdyBhYm91dDoKLyoKICogSEtJRCBpcyByZWxlYXNlZCBhZnRl
ciBhbGwgcHJpdmF0ZSBwYWdlcyBoYXZlIGJlZW4gcmVtb3ZlZCwKICogYW5kIHNldCBiZWZvcmUg
YW55IG1pZ2h0IGJlIHBvcHVsYXRlZC4gV2FybiBpZiB6YXBwaW5nIGlzCiAqIGF0dGVtcHRlZCB3
aGVuIHRoZXJlIGNhbid0IGJlIGFueXRoaW5nIHBvcHVsYXRlZCBpbiB0aGUgcHJpdmF0ZQogKiBF
UFQuCiAqLwoKQnV0IGFjdHVhbGx5LCBJIHdvbmRlciBpZiB3ZSBuZWVkIHRvIHJlbW92ZSB0aGUg
S1ZNX0JVR19PTigpLiBJIHRoaW5rIGlmIHlvdSBkaWQKYSBLVk1fUFJFX0ZBVUxUX01FTU9SWSBh
bmQgdGhlbiBkZWxldGVkIHRoZSBtZW1zbG90IHlvdSBjb3VsZCBoaXQgaXQ/Cg==

