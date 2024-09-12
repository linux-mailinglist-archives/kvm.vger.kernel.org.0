Return-Path: <kvm+bounces-26725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC30976C59
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20F002859EF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199251B5EC6;
	Thu, 12 Sep 2024 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ecPJXKQz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D31AB6D5;
	Thu, 12 Sep 2024 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152192; cv=fail; b=oL0wMzr54QnFlIHhWA4RteueDlhQByeJLC5+18fuEAqa+DkfrW5lmVCEJKLklua/nem7RY1cm5splfMM7VgjSD2iX/fJsLbdzZYVR6mPQjaAYqlrAAruhDSpD/+BuXvvQToQnajAMBagC4ORWWP3LsJVHlaUGWqgp++iY/6ENHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152192; c=relaxed/simple;
	bh=sfiAUVvfqg4kISk9QqT0I0YLrTgspkaHUjz0Vcd553k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=buK90JEoUeFl+Y8F09bvZSGD2wEmHfjZOfoh6Uyuo6eHQcYJKMWetR2KKEZqmt6bHnRGKSiKucKfnbmmr2DKtfe6qSfgxXX21R3id9U5Id4OZsbyAQCnMTsft7kjkh+Z8z6TtkELlvVF8YlA8D9WBHqlom2XjhjHlQq8l9FdLkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ecPJXKQz; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726152190; x=1757688190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sfiAUVvfqg4kISk9QqT0I0YLrTgspkaHUjz0Vcd553k=;
  b=ecPJXKQz+6r8VxKrDzG9vstksAYaxW1sfPlgAB9yginUyNRDFf1xufz5
   1PKODDfDXB/yoAa5mnPjUz8HyR3nE2DxPWI4C83vRCYq4DUZ3mahA6KJC
   5QHlbxaZ0Dztkb3EPUSukftSD3XmQ0a8r7WgC+nVgmchjrS78d7tgHOFy
   lTnjPsfRaydss9J2ehJ4ZeWgvbU6b4+5c7MhA/AkADJlHDpkzGwGFYWXf
   KCYEx2M5EKyX3dCHb2MjGCEd5xB7+4S0sYdH39pT+FrnsEjW3/MTRsVaq
   hgEvlRySDVQSx271XVWkds2RY7aVa/wAHoAj1SZ/TtG5ZhKGTXADwAJev
   w==;
X-CSE-ConnectionGUID: 7aPJwmdWTDKvLo+YN+E9JQ==
X-CSE-MsgGUID: h8iIhrQmT/Om1DTsxDpTfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="13496741"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="13496741"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 07:43:09 -0700
X-CSE-ConnectionGUID: f0KhcxXIQWGjlzlI8ICCbQ==
X-CSE-MsgGUID: eVUqU2gsSNmP/Mdvhfj26A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="67982822"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 07:43:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 07:43:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 07:43:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 07:43:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 07:43:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cN/Y2ydLK/da/zlUvv1RBAnMjTzEKTV6uGhh/D//W9uYwr+ifw3DxEAgrOC1pJ47sS3zP5tdVJ0k/z2nF0BSvGUfaJIQUNAqCwP6s7syAbGsRKI0p3feRcHc5Mvg/gTFnll0cRveqROz/x+Ra585+UWUdFUrMs3P2o2wGV2dzFAYVQSjBY46n7R6wIkj/3FJsZTCTONCTI1WRsQeLWLpr/Lvs9ylahHgmUokzcP/Rvx6trp/6Ss0AiiPhlgY3hwIpZB32CWhpNa887TNvyq/Npe8oOh1o0tH9VSD+djoBO+MmusrrOVAtdVmFp7KP9YFRCHRWHvgG99bUilYtzCxew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfiAUVvfqg4kISk9QqT0I0YLrTgspkaHUjz0Vcd553k=;
 b=uKdzdxLsrYUvjcbvCikOb1lFKmodCdMbDH5MvfgcfPLD60eFIdGADvfmh/4fY0qYMp5rhjg2UNoXd3vHply60xD9hZ7Hc+vu9TIdnJP39ctnnmhJM/sC/5X6zNHa1Vsvf9J1SY6iUMT8RUdGSXdDvK7Vc3x2jD5/97/xj89cI3LuqHSgzlkyWU7x7tArMM2I14g5UQw/coiAZK2SMqm/OLOGO7d7nwqbOvclFPpaTUiRBLT42Pqfe8/wkWV7p9ETMFEF75+ZRHHa9JU932Sen3C1DRrGZNrCzmdmA/7toLUTDBweCIsihHejFXvuh+GPyk5NHOXq60xaioHQU2rzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4573.namprd11.prod.outlook.com (2603:10b6:806:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 14:43:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 14:43:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
Thread-Topic: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
Thread-Index: AQHa/ne3O2iijDNUfE6b9PGncB+dfLJTW4wAgADfSoCAAAxegA==
Date: Thu, 12 Sep 2024 14:43:03 +0000
Message-ID: <d5c49c918a86d37995ed6388c1e77cd41fc51c19.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-6-rick.p.edgecombe@intel.com>
	 <8761e1b8-4c65-4837-b152-98be86cf220d@intel.com>
	 <ZuLzl6reeDH_1fFh@google.com>
In-Reply-To: <ZuLzl6reeDH_1fFh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4573:EE_
x-ms-office365-filtering-correlation-id: 743fed19-e68d-4315-946d-08dcd3393549
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ejBRWlk1Z25ieU91a2ZqQTFnY1k5Mi9aZFJjdVY2RG9KRGlqcVhqaG5MRVNF?=
 =?utf-8?B?YmNSWjFTb0NaNk8vdU9pTkVEdmVSS1oxU2t4N0VtYjZyYlhrTExUS0RtejNp?=
 =?utf-8?B?czBFdUY5Z2dvT3g3MVl6cURNdDdpR1hPM1g3dVk3Y1ZlSWdTZ1NBVkhoaGxt?=
 =?utf-8?B?ODZBMFEzcjJBTDhEYjFUS2RselRSNjRkWXpoQitwWU55bElycTBZR2xIRHNk?=
 =?utf-8?B?RTl1cEo4c251MHZ5Y1lnUUFzdUN6eHFKRHc3TExkZm5qSEtlRlRKVjhZVWgz?=
 =?utf-8?B?aXBTdkF6dkxFaERVUVNCWXpZbGZFZjRqeXl4bHNKMjBSM0lXbWRReEJ0TGdS?=
 =?utf-8?B?alhOTERVTW0raVI3dENRKytzbDlsZjIvbWZHNU9sN01nY0pSYVh2T254cEpR?=
 =?utf-8?B?bE5XUGlpVXRsTjRpQTM0M3g0T0JlZ2Z2bWszWk5KV0hFelFIclNVdGRONHF6?=
 =?utf-8?B?dnZmYkwvRW13Ym1vdXc4RWptOGNncDBTTWpyOTVCMHBiV1JUY3BPT1BpTXJi?=
 =?utf-8?B?cUlpVXdQWmI0WmN5MHExY0wvQjZjbExmOUFFRzBwQ0NJQ0FjdjBTVWRhbHZQ?=
 =?utf-8?B?VWNOeEZSZDFwUm1DRGU0cm1zamNkYlBJV3g1WWR2ZXF1TFpKL1RPcFdZdFJa?=
 =?utf-8?B?SE1mN0s0b1Y0REUrRlpGN2ZxR0pCU204eEZhRTJpdzBYRytFVWJubFRzRnRG?=
 =?utf-8?B?NFVGL2U0MnF6UlcxUHlnb2tySGdWMHZHMmZJZ0IwYkpQZFFRaWk1eWNxbzhO?=
 =?utf-8?B?ZUR4UGNpVEc2QVZYRkZ1Q04wSGFzWmV2THhWY0dHK0RnK082eXBPN1d3SEtK?=
 =?utf-8?B?K3ZwWC9pYjQ1WkpVMDVOZFV1d3NOdkhBMkVjdVVlK1ZtNU1XQVRJbks0SUJo?=
 =?utf-8?B?VW5XV045R1VCd2l4UUlSellCNmRKdEFVcGJVSXQ5MVVoUXExd0N1bmVOMDl4?=
 =?utf-8?B?dDhVVmYxNnZDTVB2WTRZNDkzN2UyeW55bjN5ZFk3b25LUFF1MjNPdDF4WmZW?=
 =?utf-8?B?a0hLUXdkMUZ3SmJ3YUJLNUNyN2NwSFZ3c21OMjZJUzdSQU5pZ2VUVGpnQkpq?=
 =?utf-8?B?RTlzOWNjR2ZPSWhDQ3NmZlZOMTM1SHpXSjRVWXVxSFVrWmZwY3paaWNjYVA5?=
 =?utf-8?B?aXNVanRFVGNKclZPS3I0WXVFeENlOCtvWG5La1hoSzQyZlFYOUFVTHpWSTdW?=
 =?utf-8?B?OTNlRmZSYTNhZDlENUI5NDZnLzZsY3c4cC9JajI0YzJPekI3RFhuV2dmTlVw?=
 =?utf-8?B?czZUcDJ5OGl4OGVWOVlXeTJpeSt4VkprSWRTb3dqNjlFbW5QMlFnM0hpOGI0?=
 =?utf-8?B?b3J2RTkwcnJwam84eVlCZzI3OTJSc1B3MW9qbSs1Y3NMb2loNDBwRkRkTEJt?=
 =?utf-8?B?NytBelRWTnRHNGtTMVkvdWZQRks4TzJNRlZpQ0Z5eFlneXJOMExxZW5ic0tF?=
 =?utf-8?B?WEVMbzlTbXpzSnpKRVZLMTNWVmFSTjJvMDkxSUZDb2dpZk1kQXJQVlZxYURw?=
 =?utf-8?B?RHdHWTFNMDZpeE9PUy93NlM0MGxZSHRtQUo4dHNBVi9Wc0JVWVE0TVNydkQr?=
 =?utf-8?B?clppV1RwVHZpclRSdmYxVDg4NUVYRllWczNKL3RTMk1BNUNQc2Y0TzJPZVdv?=
 =?utf-8?B?ZU1WQVYwcXJSVGVkdXcyTGpITTJzNXVlVFNZVFBDbXFaU3NpSzYwSWpwcHFN?=
 =?utf-8?B?YXVpTUp2YVI2dHhaRW9iekp2YUhRamxvSGhIckJNZmtpemxUZmZ3Z2ppUEFF?=
 =?utf-8?B?djZkQ2UvbE1nVGF5d3N4TE02Q0hieHoySlliM29yM05sL1Npc0JvbkpheXJU?=
 =?utf-8?B?WE9XRFEvd2htYWhyeHlmUzNQcjNtYzd0MkxnZ2tpZ0FFWGtvRDQ2Z0ZEMno3?=
 =?utf-8?B?STcwYzVzRCtsekpaOFhqODZLUE9KMm50M0tkMnUrTjJhMEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVMya2FyNzBhN0syQVR3NzVnREJQSXdmNUFSUHlVWS9Xbkh5S0lQRDErSXRW?=
 =?utf-8?B?MU1Vdk1CYjNKaFE5WTNxSlV3bHdIUmk3RG1Db3VOQ0hSZExUVXZoZzBZU09M?=
 =?utf-8?B?Q011SjJSMHBQZHlSeTRXd2tBOFYweGpxLzRyODEzd2ZvOGlrZ2dhcGluU0dX?=
 =?utf-8?B?UmNDWWlDVTN1ODBzMzZNWGpHTjhRQkJkaVJkYW5Ma3JOY1BYWlRQbUxDWWRR?=
 =?utf-8?B?WGZBUmVhQ25MbnJhNlJIdWFCWnhKb3BjRzRXNXozS0JVYjJOcFRLT2dJUzZN?=
 =?utf-8?B?WGlIb1BlOFkreUJTODZGZlpVUzV6NitxNEV3MjhHUFJQcThXL0tkaGg1SUZX?=
 =?utf-8?B?REpCcHMxbzNsUCsrUGFzVDI1TzBWNVdHYTR5NE5DaENhU1o4enBKcDBTcHB5?=
 =?utf-8?B?eDRUZmt3SnJaWjAvRzJ2aU1yVzFydUpPODJIQUFWTHM0TXZUM2Nxei9hNFM2?=
 =?utf-8?B?Mjk4c0xnZVFkbUU2NWpPUzFVWUFGZnU2Wkx5b3piMHJDNllvQld4a3FOajcx?=
 =?utf-8?B?L280T2hEWXVXR3BKYzN0ZVdac3I0dEN1VU9SMC96bVlKOUtnMlhwWTdDTnJx?=
 =?utf-8?B?ZnBNS0ZlNWZRZEIyeTBwalBEU1JaU2lxdDF5UW1GeU93bUxXaGV6K0dJQVRG?=
 =?utf-8?B?U0FaV1VmTVEzS0FnODZjY0U3cTR5OW1rbnJ1cmU0dDlCN09TbjZWVVZBQkJR?=
 =?utf-8?B?bUI1dG5QSFpLTkVwMDl5S2xuWDcwN0RWUW5JWmxhUUQ1MGt2WWxaYXV1cDRQ?=
 =?utf-8?B?M3FPVjR0eElEckp6UU5hQkdzbTBYUEFBU0Fub3Eyck8wVmVBSE42V0haNEN1?=
 =?utf-8?B?VC9IamVPU01FVUliTkx0RG5DM2tsTTZJREU2VlNCWVk3RlNsRWVvaTNLWFZY?=
 =?utf-8?B?K2l0dnh0R04vV1NFUWpCZVFKNk9Da3dkRFVrTmhsUTNJQzZMeXdwMnVFY1lJ?=
 =?utf-8?B?RXJ3dEJsMktuZ1RCcVVmQkxhY0NDMzBIOTIzV0xUSHRtcy9WQlQ2TDI4aVkv?=
 =?utf-8?B?eVplMkJBMVVtWlZXZG1mYkwxK2xZOUlFZFgvNHhWV0xaMDkxZHFBZGx5Z0Fp?=
 =?utf-8?B?b1hic0F1cE9nSWZ2ZUovclFPRjdVRTE5d1ZyMkxVNzBnd0Jpd0FSd2lRQUVo?=
 =?utf-8?B?ZCtYcFFTeFV5aUYySlM2MTFVUFRZVVhhaU5TQXhQaVpjTU1MQnBoUzVCdVZR?=
 =?utf-8?B?L0JxK0diS2xmQVJsUGpiMUFFTnhZUFpKa3dFeEc3ZS82amZFVkFmYlFSV0hz?=
 =?utf-8?B?RkF5dENrZStIR3l1UGtqWnZoYlhQNmFNZ0V5OUx1QkcvM1dHMFZxQTJiVGpz?=
 =?utf-8?B?eVdYNEQvdHY5SHJrNHhJSGlLT1NDVXdibVBUcFJHREkxcSs4a0d1S09Xc1hS?=
 =?utf-8?B?QUgybXNSdGhhVXhBbEFPYlVwcUtuZTJDUXhnc2JES0pHYlp5cW9UZFRsVHk4?=
 =?utf-8?B?bkZVRnNHcFZBOGFNSk9IMU5zY1g0MVQvMWxmdFh0Q2JhMmpVWVBZTmxRVTM3?=
 =?utf-8?B?TEdxTFY5eW9mTjBDT0g3cDl6d0lESmwzUEFEaWJNY3E5REw0V2xwcHFxck92?=
 =?utf-8?B?ZHQ2WHVwR1JyZzFxcDZyNlJaa1hjbUliYU5Kdms1UmlTcHptVm1PQ1UrYlBw?=
 =?utf-8?B?U01JeGRPZmtWZkdqTTJDOGNWT0dEWU1JZlJCaDJjeVpwb0x5bFF3dGdZelk3?=
 =?utf-8?B?ck9nT3BJNWFNZGZrRlhzbUJocHhHOUZXSnhTNHluSFg3SndMTjRTMUFWaE5X?=
 =?utf-8?B?Zm9leTBJVDRrNndMc2pLUFZKSnpJWk1zMWZRQlVRYlhoZ09nV3hlSk5LNWVU?=
 =?utf-8?B?czNzNjNOY0E4OVFPajc0a1VjclBscFFvVHh1a01uN2RZd25FUVg1dmZYOXl6?=
 =?utf-8?B?a003bzk5NUwzQkNoSEoxWGVlRUdtR3FYVWxrcTMyd0twMUlYaElzbjhGNFov?=
 =?utf-8?B?YVVvTjl5bGo5L2k1endBaUlYTzJmeXhsbVlrVUQ3Q3BCMjdBdloyNUI0bGlV?=
 =?utf-8?B?Qjl6cUcxQUtMeHZ5aXozc0FjVHYvWkw3T3V3emg1M1UwdU92MkNSYXJ2M3Vj?=
 =?utf-8?B?NXNsa0VXc2ZuZ2xmbHV0MW1WQjJYYUlBTTExUDRmQU5YNDJOZWVQbmpWL3lS?=
 =?utf-8?B?d2hjRmxrZ3EwUUxJTlArZ3ZWcEhxZlNuQ05zZWwyNGFZQzBtTEIyUml4eDEr?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34C1047619EBC04EB1F7128660A20454@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743fed19-e68d-4315-946d-08dcd3393549
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 14:43:03.9963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shYcgHgmWabewiIV+TnRIIVbWDzzBz0dzIjCrb54l2av0HpE50RMyS484F6os9o3XcTylBWu2toG+w8OuIRsu0PpR7Ere4nRditSvY7Acu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4573
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDA2OjU4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFdoaWNoIGNsZWFybHkgc2F5cyBpdCBpcyBjaGVja2luZyB0aGUgKmZhdWx0aW5n
KiBHUEEuDQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoYXQgbmVjZXNzYXJpbHkgc29sdmVzIHRoZSBw
cm9ibGVtIGVpdGhlciwgYmVjYXVzZSB0aGUgcmVhZGVyDQo+IGhhcw0KPiB0byBrbm93IHRoYXQg
dGhlIEtWTSBsb29rcyBhdCB0aGUgc2hhcmVkIGJpdC4NCj4gDQo+IElmIG9wZW4gY29kaW5nIGlz
IHVuZGVzaXJhYmxlDQoNClllYSwgSSB0aGluayBpdCdzIHVzZWQgaW4gZW5vdWdoIHBsYWNlcyB0
aGF0IGEgaGVscGVyIGlzIHdvcnRoIGl0Lg0KDQo+ICwgbWF5YmUgYSB2ZXJ5IGxpdGVyYWwgbmFt
ZSwgZS5nLiB2bXhfaXNfc2hhcmVkX2JpdF9zZXQoKT8NCg0KU3VyZSwgdGhhbmtzLg0K

