Return-Path: <kvm+bounces-21455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE7A92F254
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 865E128379F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A41C1A0719;
	Thu, 11 Jul 2024 22:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Do2ZNGCa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A1719FA96;
	Thu, 11 Jul 2024 22:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720738524; cv=fail; b=nhTRgAhaWfgeVhM2Q/ZBPD9lXXvHHissKjkTr5gmcSnRydrTmiliXq9SqauemJUvVl/9wodfGN9i4jiITV8xHxr36SpnLZd0FhBvjem7XtPfe9ondHIw1SdKeR7+RgMfNBzseMrSuwgiVdec7yAMi6+13sAFCls87us5lQ89XIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720738524; c=relaxed/simple;
	bh=6PsZwGW60vbdhdPhKCweWR/AS35TUhHDQk0pYBE/CHg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N1juw47AQ5bF2OS6U2cFbqld7btx4G4AdTvV9UAwz8mtd5q1nHC5kmLpeu+/oO7iD8xzUJrjvlbNmau8EFYTiSFCGmZOtKrCANfWNIlQPkPO+lynpQK+9nEY3HHN/dBDL0oQLx6jHIdDqDR/6zrLOwuvUBEQTyCX4Kb2KVZ4na4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Do2ZNGCa; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720738523; x=1752274523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6PsZwGW60vbdhdPhKCweWR/AS35TUhHDQk0pYBE/CHg=;
  b=Do2ZNGCa+bNl7g1luVTIsyal6veyQm/XuxNQIIH1JTu40P8zWv9TFVbB
   GNOfHOOQZxH/Plvkc9k4m64SbHJD1xB8TOUzm9krM2TKIO+zPyf8E5or/
   KtbHcq68W2NPwjGAXzNeZ5VaI1fFFJXKsW3wVyCySJHCcfBc0xPRbCy3I
   9v2PNJmFsCN+pXimgG7qXTZPvWWKAFykEylu58bllPSL+yp3Y2duXnM9j
   jww1MRiKbpijadW+vP6+vSghdMoEDGbUGVXNeT+h3MyQsbpptCMqYx6Ey
   piLocgxLlZH6hM1v2XaSyi8LYHVo7UsHDgrziEfOdk5s0WFumbUxJ0NeQ
   w==;
X-CSE-ConnectionGUID: IjSH36WERjqJw/DLldRTIA==
X-CSE-MsgGUID: EA/2W4skSwqbs8sUxwsRaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="12511473"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="12511473"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 15:55:22 -0700
X-CSE-ConnectionGUID: RiGDLDrYQJek2Ut2xY6Q3Q==
X-CSE-MsgGUID: pUh4ql4gQQ+9tFmutJ6KJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="48618375"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 15:55:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 15:55:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 15:55:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 15:55:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 15:55:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bw3Cmhohc9pDj7USh6B8H6AW8WSP8W6w1LyDAzfJDLdLL/1aMYkq04Fr0UqOqMfgl8Ep3YQtidq/d5iJaHM8Vo7CDJvrqPW6Mo6m6v2Y4MdhvLvuVTO2m/4X5SDr9OwtRRJzEzll9WpvOx15VCtzAm5rkCRQvQdHOzMEyR/oAhnRI5TQ1Mik1j/xMPLeSfgoOMjdUo7iI16srZxx+rZiRYhWJNBO+1WsaeLwStiwD0VdcD6Nlg9e5T3jnPDBIvnWlGWF/qgBXS9H1rRWdOs6nTpUQLkBL1oJGEaeSXwBLjWnG/+QwhUyeNCcqt2dRwLvxx4gEn2B5LBLhdLTaNy4Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PsZwGW60vbdhdPhKCweWR/AS35TUhHDQk0pYBE/CHg=;
 b=NLOxEfe/Jn5ebjh/HI4h8Q876wq26X0kU247psTSnEypFP5Ss73UJq3wQ++KzkT5H4ZVc+mFlLIx3CYeBQlOstWb8nXro4iBlubta2rPgRIViNLKm9QJ+sZloY9U9ioDdFUAQZEuKE8tEI3qQiLcxMn5TSfQfz+utxQQPLa8KLXp22JPBHlciuagrln96tDvVcPGVnIngcHvKhNDjMm5J46P0ini0Mz12zxOxfgoctSRa0zThWLaeyCndsu/3mRuyj7leDDhirynaTikoBiC0zvyuluHMin1TP+ECRS8WvdgY7RJgZNOkOkdw+bDwsAmK6mq6wxz9ttcvufVVP6zbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4679.namprd11.prod.outlook.com (2603:10b6:208:26b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Thu, 11 Jul
 2024 22:55:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 22:55:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "Gao, Chao" <chao.gao@intel.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 0/6] Introduce CET supervisor state support
Thread-Topic: [PATCH 0/6] Introduce CET supervisor state support
Thread-Index: AQHaszmBJohBiOz+pE69mz1umIxaubHt9r2AgARM+gCAABRjAIAABVeAgAAG5gA=
Date: Thu, 11 Jul 2024 22:55:17 +0000
Message-ID: <90a70461d15b9053e0507beda20b448194ba5eb4.camel@intel.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
	 <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
	 <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
	 <7df3637c85517f5bc4e3583249f919c1b809f370.camel@intel.com>
	 <4bba0c20-0cd0-4c1a-abf0-511ba6940a57@intel.com>
In-Reply-To: <4bba0c20-0cd0-4c1a-abf0-511ba6940a57@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4679:EE_
x-ms-office365-filtering-correlation-id: 4b862024-4a88-4ffe-368f-08dca1fc888a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dlVCVTNuSStXWlJ2NlovWjR4WXhxaG00Y1lvZXFOUFkyQkpOUkNCZ0M0c2l3?=
 =?utf-8?B?dUdhVXJHZGYwbDd5bHF0SEU2RTZBTzRCdjZaRnMxZEpvMFF6czFzV01PZ0Y1?=
 =?utf-8?B?MDJ2Y294Q1NUS2h2V3hkY2M1VVJ1c2dGQyt3cTZVS2QxWGh5TVhldGVMNlRl?=
 =?utf-8?B?cHZWSnZWUVFIZ1VqUTNNZHV4ZHZLRHFwQmpQWjlaM1Z0NkY2WlNBbmFYdWlC?=
 =?utf-8?B?UTNqYlJCSzEybjAvOVBoUUVaSnhRUUI2bHl3ZFR2ZHNNd00zcGZlUkErQWpY?=
 =?utf-8?B?UWxxa1F5WTBzUGxlTHQ4RkQ2S3F0L0FaeFJ4RHE0eFV3SWhKN2pHS2FVd2xG?=
 =?utf-8?B?Zk85M3VCbVJwVHMyaUNOZjRhTXoyaGNFazQ3ZGlLRWQxbS82amFXOXkzUXps?=
 =?utf-8?B?d0QzUFdUbUcrK1p4MlpScHkvMUNsZVdEWm44RDh5dE42OXd0ZzN3Umg5aDcv?=
 =?utf-8?B?bzBLNGpCSEg0OXova1IxMFc4OG4rZEJndzdBZGhCcytpQ0p0TURIM2xXVHRU?=
 =?utf-8?B?Z1Y0RkRxVXZtY3J5NFlXMzgyRDgrZ1lscFVYVHE1eUpLSzF5NUhNVDg5WFdP?=
 =?utf-8?B?dU51S2tIeTVhdHUzWDdiRzl3WVdSZ3VjUDhNNDhEV1puUStXb1NwWElheVg5?=
 =?utf-8?B?eTI3akFRTEpiOUxKL0dYSkNkUEl2UTUwbi9JaVhDdmN6U2pqd2pJUmQ1NTQx?=
 =?utf-8?B?Yy9UMEhJYVg3NTIzYzQvSklXcERLbEJJb3JTdFpuN296VDUyTk5aVVgzYk9o?=
 =?utf-8?B?YmYxUmp5SWF0U2ZMWjNXQ0gyc1BmNlRHSlRwTjdBbmNGekNSc0F5ZytyNnl0?=
 =?utf-8?B?MVFvSEZzUElMb0VEQjJIWXJ0eUN4N3NqUmFVYmRHYVZWWVFuWFQzaTlHNmk1?=
 =?utf-8?B?NDNPUDNRc1B0ZzFJamVkMzZNVkhVMFhQLzNrbFFPUTdWTlNjcndnZk5wQVor?=
 =?utf-8?B?LzU3bzJMdFlSNkpNbEFmY1V5aEYweXlCU3Z3QmJObXNjeURHWmVtbUJhd2pI?=
 =?utf-8?B?bnVKQm43d2hINitQY2EwVzRlNzFyYXFXaSsvMCtGWjg5NVJQMFFhMStleDVw?=
 =?utf-8?B?bkRoTTNKWTV2R2pNay9EMnNJVmtSbWRkNTcxeldpeDNGQ0hrKy9HWjZPNmNU?=
 =?utf-8?B?NllTR040c0JMN3BnckRMaUtLYTlFWFFRdzRVNTl1MlplWUFEeUVyaUxHR3VJ?=
 =?utf-8?B?NUVxNHlyYm1kaVJBdnNRd3JJUnJtTmdGVTh4L0Y0alRvTkMwMGNYdVN4aS9Z?=
 =?utf-8?B?Z2F1dVVjTmlhbFZXUG5CMWxwWjFNd3NuWm5IRmFKWWdJUkFkZi9pT0phQmJH?=
 =?utf-8?B?c2k4aEVGcDFVTkliR3pnVjhiQkdRTE10aDNHWDlhTDNLbk9kWXc5TnFVdi8x?=
 =?utf-8?B?Q3l5MmFTbDdJMTFOQTlPQU12eXk1NU9ON0NqRk1NOWkrWUJ3M09vNWF1Wmp5?=
 =?utf-8?B?MVRPNzkyVG8rRFlWMEs1Mm9yeDdKdldUK3lBSTdWNXBrQXNaTXEreWwxQ3hw?=
 =?utf-8?B?dDl1RXdZb0IzZ3d2YTZBOUs3RDREdFNTNGFSelY3THM3ZERnQ1hpSUlMY1RY?=
 =?utf-8?B?dUhzdVZvRDVwSWdtcnhNZm9wOTJHb0s1RjNQRzhlVzNmeEtWY25VMUl3N1dp?=
 =?utf-8?B?bkl5UHh0MmNHcitBUW1BS3V5WVVRc0FtZXR1TnpuTy81R1g1Q3dHa2NPYTJK?=
 =?utf-8?B?K01HSGFOY2Zoei9icTRGTFU0SHVrMHErL0ptVWNOVlFmUjdsVVZNZ3ZNSity?=
 =?utf-8?B?NjJpQmRsVVpYb3FDZlhOUXBicHowUjEvc0gxdlRWYTZKdytSZFozTXkxeFo2?=
 =?utf-8?B?bFdHK1RyTjBabmNSRFlVZWZaTjdiUzFkclVSVi8zUFRvSmc4dzFGdTFnRmlR?=
 =?utf-8?B?bU1lTDlzd1Z5K0lUMURYMWZqaFRFRE1HZnV3SFFWZkpjNmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0xKam5aVE1mVy9iU0VLNGNOK2FMeVd6a0lpREFWVnphUzduRDFYTDh2dVhn?=
 =?utf-8?B?MjBRWmhsUkZ4WXhaWlcvenFuMHdSRTBJVDVxTFF2R0ptYmxxNzc4Nnh5Nytl?=
 =?utf-8?B?UkRpNEE2V2t3QlR5Tk51RHV3Wm9IN2lITVR2bVdxaHdMaCsrRFA2c3NRZldC?=
 =?utf-8?B?eHBJY3pCbnRDMWZJazM4Z2o4c3dnSWlqMGY0WDRPZ3N0QnZzc2h5T1l3QVEx?=
 =?utf-8?B?clN3a1NNckhqY1hGSEZqd2pydmRWbHlZYTVxcFNzMGxpelhtcmZHWVUwcG5z?=
 =?utf-8?B?VUkwS3JaMWZ2MTRqMVcxK0dLTFBaVFF4MWVyMkNKZ09XaTcyMHN1WkxaUlJi?=
 =?utf-8?B?UWUyWVVmZU5DVGZVNlpwZkVYMHowNDIxamVBSVhuRWhqZ2pTSjVXM2NPYzg0?=
 =?utf-8?B?aXJIWnZVMzFFRWFGOFdoOVNTSko5YytxQXhpNEFXVTFmbnBSK25HR1NhcGpj?=
 =?utf-8?B?NmVNOXRxdUgrUmJUZkphQ0Q1eXVYQU1LYVBmd3ZBRnBsUUNtdWJMQUMwbjQ5?=
 =?utf-8?B?ZXNtMnoyZXJ4L2xJaWdIdjFhWEUrYVp5SHdwNHhmdXR5QlVLSitpUGtkT3ov?=
 =?utf-8?B?SC9ZUHpweU5tOW5RQlo1SzE2OFJNeWpjWEV1OHNkc3ZaeXVhOXBBU2JtdW9o?=
 =?utf-8?B?bjdhTEthckpDNWpYOWY5bm45MTNvUU9mc1JoZytZdm9ZZ2NVeTl5Ri9ZZEhZ?=
 =?utf-8?B?aXhFbkZRUk5WbzBvS2JGZmxUbVNyc1ZuV1U0ZFVwSzJkODJqV1RySkJoSnMx?=
 =?utf-8?B?cXJSYzhuUEVhV28wNGJhUUcwSDJwb1BwRUxNeGE4VzhHaHVSYW03S0c2SlB0?=
 =?utf-8?B?VGdBcFZrdXYvK045NTJoTzZTQkZEVHY2T210dGk4MmRQdDF0ZWl6REpyOU40?=
 =?utf-8?B?YTRUNjRlMDQ5ZnFEV2hsNUNSMnNPQ3RJcUdNVlNkY09FS2RaYmRTMEJtNm10?=
 =?utf-8?B?YkxZZnBWTk4yOHREUGE1RW81RFIwSmlLNGFxYmFnTnBQZjJxOW1CVHNmbXor?=
 =?utf-8?B?NnVQUGZ3anZtdnBVclJPckFZRmMxWitEWVJDRWZrbHM1YmZ4OWlUQnFhZm9X?=
 =?utf-8?B?MjNhWWlUVTNzVDJLdFV5RTErN2w0ZXFGc1JWNS90NC9PdzZUN1RCUU5wOEVC?=
 =?utf-8?B?R2ltQjBwclVJdWVaM2w4Tk1kYm5kYXNHd2lSZHJnRG11b0V6MURWYnRjVmg5?=
 =?utf-8?B?b283bGpsb1BDZUczSUExWU9SQzh5VkZDdklqb0R4L21tcXdiM2NHT0VaWisw?=
 =?utf-8?B?RXRCWkhCSFJ6L2g5OHZZSjJFK3AxeGZSSm1pblQ0ODQvdTlDZFhTSlc4Uytu?=
 =?utf-8?B?WUlFYlNaMWpEa1I3SEpSTW81aTNPVllTSklRdEF2cHNLUVFiNkZPZ1VBbjFW?=
 =?utf-8?B?cFdkVVN6TWZEZUgrSDdGS094a0xvcUMxZXR1VjByd1U4VENlZUU3R0NmSTdZ?=
 =?utf-8?B?OGNDOG1xY0x3Q2RCa1k1K1FVZVEyT3lNYmhPVEFlMlpxT1NuZ2pCMlRYaWx6?=
 =?utf-8?B?d3BlWE1KdjIza2h3ckhzQzZOUWUzRHk3aHRJdXRQMitEaHZVZTRjVzUvUFhH?=
 =?utf-8?B?aHJXNFY4SHp0RHZPbTczNTBkZ3ZOWFFveVV5ZzNRSUlxbXcrUkx3SXJnVVM0?=
 =?utf-8?B?VG0vYzhkbkZQZ25aODJvUjA5dUV0RGt6aXdhM296MDhVSytXZmtZTUJiN1FU?=
 =?utf-8?B?cERiRTJXUFRoUUQrSlNjNFArRndUUDZLYnp1YnlPMU1IaFd5bmpSa215VHpn?=
 =?utf-8?B?dVJ3RTZIOFBGeXdNOWljM01mM0pRMWFNUW56WmF6bWlESjFHdDF5MGI0eU5h?=
 =?utf-8?B?cGxmb05ReUt3b293WnAzMHg5WFdCZ2U0bFZKT3NsM0tXZndIQk1valViOC9v?=
 =?utf-8?B?bTZwSDh0anZpZVVYYktUQU1JbW9lK0MwaW9zTCs0V3pQSDlUMnBiRnd3d0xI?=
 =?utf-8?B?UlkraHd1MVZFeERFR3NDTFIvWGprZnkxM1lkNE8rcVQzZlhaZXFjaUR6cVVK?=
 =?utf-8?B?MUFZNVRaaTJEMW9GYUYwTnNoUE9MdGVZSWtrY3AyZkRKc3NWOEJhMUlPU3hZ?=
 =?utf-8?B?eGVLZUo2UzVaMXFjTjkwNzUyM1JPSTd3WmM5dEdjQ1dMdDlocm9GaGw3dHI4?=
 =?utf-8?B?QkczNmF0d25lZG5rZktET0grWjl3bU1Hek9kZmNKNW5aQ1BSU01GSkEwZ0tW?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80AA9ECB615CC048818435D19882B668@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b862024-4a88-4ffe-368f-08dca1fc888a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 22:55:17.3979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e4ftGe2FQJwjJ5uM+BU2h5JWkSjxdbN4AmKolCD2Pa4tbN3dECE/KqB11jtOnQ1v3oLL5hYivaDCRBJteSHnF37/tYXBGXnh4hJjPIc7D6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4679
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA3LTExIGF0IDE1OjMwIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiA+ICRCWVRFUyBpcyAyNCwgcmlnaHQ/wqAgRGlkIEkgZ2V0IGFueXRoaW5nIHdyb25nPw0KPiA+
IA0KPiA+IERvIHdlIGtub3cgd2hhdCB0aGUgYWN0dWFsIG1lbW9yeSB1c2UgaXM/IEl0IHdvdWxk
IGluY3JlYXNlcyB0aGUgc2l6ZSBhc2tlZA0KPiA+IG9mDQo+ID4gb2YgdGhlIGFsbG9jYXRvciBi
eSAyNCBieXRlcywgYnV0IHdoYXQgYW1vdW50IG9mIG1lbW9yeSBhY3R1YWxseSBnZXRzDQo+ID4g
cmVzZXJ2ZWQ/DQo+ID4gDQo+ID4gSXQgaXMgc29tZXRpbWVzIGEgc2xhYiBhbGxvY2F0ZWQgYnVm
ZmVyLCBhbmQgc29tZXRpbWVzIGEgdm1hbGxvYywgcmlnaHQ/IEknbQ0KPiA+IG5vdA0KPiA+IHN1
cmUgYWJvdXQgc2xhYiBzaXplcywgYnV0IGZvciB2bWFsbG9jIGlmIHRoZSBpbmNyZWFzZSBkb2Vz
bid0IGNyb3NzIGEgcGFnZQ0KPiA+IHNpemUsIGl0IHdpbGwgYmUgdGhlIHNhbWUgc2l6ZSBhbGxv
Y2F0aW9uIGluIHJlYWxpdHkuIE9yIGlmIGl0IGlzIGNsb3NlIHRvIGENCj4gPiBwYWdlIHNpemUg
YWxyZWFkeSwgaXQgbWlnaHQgdXNlIGEgd2hvbGUgZXh0cmEgNDA5NiBieXRlcy4NCj4gDQo+IE1h
biwgSSBob3BlIEkgZG9uJ3QgaGF2ZSB0aGlzIGFsbCBtaXhlZCB1cCBpbiBteSBoZWFkLsKgIFdv
dWxkbid0IGJlIHRoZQ0KPiBmaXJzdCB0aW1lLsKgIEkgX3RoaW5rXyB5b3UgbWlnaHQgYmUgY29u
ZnVzaW5nIHRocmVhZF9pbmZvIGFuZA0KPiB0aHJlYWRfc3RydWN0LCB0aG91Z2guwqAgSSBrbm93
IEkndmUgZ290dGVuIHRoZW0gY29uZnVzZWQgYmVmb3JlLg0KPiANCj4gQnV0IHdlIGdldCB0byB0
aGUgJ3N0cnVjdCBmcHUnIHZpYToNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqBjdXJyZW50LT50aHJl
YWQuZnB1DQo+IA0KPiBXaGVyZSBjdXJyZW50IGlzIGEgJ3Rhc2tfc3RydWN0JyB3aGljaCBpcyBp
biAvcHJvYy9zbGFiaW5mbyBhbmQgJ3N0cnVjdA0KPiB0aHJlYWRfc3RydWN0IHRocmVhZCcgYW5k
ICdzdHJ1Y3QgZnB1JyBhcmUgZW1iZWRkZWQgaW4gJ3Rhc2tfc3RydWN0JywNCj4gbm90IGFsbG9j
YXRlZCBvbiB0aGVpciBvd246DQoNCkkgdGhpbmsgdGhyZWFkX3N0cnVjdCBpcyBhbHdheXMgYSBz
bGFiLCBidXQgdGhlIGN1cnJlbnQtPnRocmVhZC5mcHUuZnBzdGF0ZQ0KcG9pbnRlciBjYW4gYmUg
cmVhbGxvY2F0ZWQgdG8gcG9pbnQgdG8gYSB2bWFsbG9jIGluIGZwc3RhdGVfcmVhbGxvYygpLCBp
biB0aGUNCmNhc2Ugb2YgWEZEIGZlYXR1cmVzLg0KDQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgdGFz
a19zdHJ1Y3TCoMKgwqDCoMKgwqDCoMKgIDI5NTjCoMKgIDMwMTjCoCAxMDA0OMKgIDMgOCAuLi4N
Cj4gDQo+IFNvIG15IGN1cnJlbnQgdGFza19zdHJ1Y3QgaXMgMTAwNDggYnl0ZXMgYW5kIDMgb2Yg
dGhlbSBmaXQgaW4gZWFjaA0KPiA4LXBhZ2Ugc2xhYiwgbGVhdmluZyAyNjI0IGJ5dGVzIHRvIHNw
YXJlLg0KPiANCj4gSSBkb24ndCB0aGluayB3ZSdyZSB0b28gZGFpbnR5IGFib3V0IGFkZGluZyB0
aGluZyB0byB0YXNrX3N0cnVjdC7CoCBBcmUgd2U/DQoNClNvIGZvciB5b3UgdGhlcmUgd291bGQg
YWN0dWFsbHkgbm90IGJlIGFueSBleHRyYSBtZW1vcnkgdXNhZ2UgdG8gdW5jb25kaXRpb25hbGx5
DQphZGQgMjQgYnl0ZXMgdG8gdGhlIHhzdGF0ZS4gQnV0LCB5ZXMsIGl0IGFsbCBjb3VsZCBjaGFu
Z2UgZm9yIGEgbnVtYmVyIG9mDQpyZWFzb25zLg0KDQo+IA0KPiA+IFNvIHdlIG1pZ2h0IGJlIGxv
b2tpbmcgYXQgYSBzaXR1YXRpb24gd2hlcmUgc29tZSB0YXNrcyBnZXQgYW4gZW50aXJlIGV4dHJh
DQo+ID4gcGFnZQ0KPiA+IGFsbG9jYXRlZCBwZXIgdGFzaywgYW5kIHNvbWUgZ2V0IG5vIGRpZmZl
cmVuY2UuIEFuZCBvbmx5IHRoZSBhdmVyYWdlIGlzIDI0DQo+ID4gYnl0ZXMNCj4gPiBpbmNyZWFz
ZS4NCj4gDQo+IEkgdGhpbmsgeW91J3JlIHJpZ2h0IGhlcmUsIGF0IGxlYXN0IHdoZW4gaXQgY29t
ZXMgdG8gbGFyZ2Ugd2VpcmRseS1zaXplZA0KPiBzbGFicy7CoCBCdXQgX3NvXyBtYW55IHRoaW5n
cyBhZmZlY3QgdGFza19zdHJ1Y3QgdGhhdCBJJ3ZlIG5ldmVyIHNlZW4NCj4gYW55b25lIHN3ZWF0
IGl0IHRvbyBtdWNoLg0KDQpNYWtlcyBzZW5zZS4gVGhlbiBJIGNhbid0IHRoaW5rIG9mIGFueSBh
cmd1bWVudCB0byBtb3ZlIGZyb20gY2FzZSAyLg0K

