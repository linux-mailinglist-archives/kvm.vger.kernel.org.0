Return-Path: <kvm+bounces-15042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 778A38A9011
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CDDC28211A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5702F3A1BE;
	Thu, 18 Apr 2024 00:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="etAGmblC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20384374C3;
	Thu, 18 Apr 2024 00:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713400417; cv=fail; b=Y3tBUuuGTGFDgR5p6DDZSmO4dR1s/jrVrWhwYYs6mj2PM3FHEUjQvGp7mHToCCIXEKDGS+vs7m2YjYEkhCTdyCf4h6A69P0JYVFRguAu5z2G5Ou95LQ3eo09JOvhAln4PyPKIMMMnNF4CE+Xxl2EmF8fC34BpWcEP8KosefsPko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713400417; c=relaxed/simple;
	bh=EGJpPfj2H4ZfjNskCbozpzFbJemi2Goe7y+Y+QLflM4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tUecJ77OhngS9VpR6pKADKbxdIhYvVfC3zBYnfhYhLQCZpChNWLV7WH78in6m4OwpuCU65VTlxu9U+B4/2zE+9pPe9wh9SG+5ATM/bzYozfqvfLKVM3S32xHNwt3m0uZ1OeuKjirajR8EJkEI+yi5O1vSn7AE2OzfWffTuIrZOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=etAGmblC; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713400416; x=1744936416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EGJpPfj2H4ZfjNskCbozpzFbJemi2Goe7y+Y+QLflM4=;
  b=etAGmblCbspI3yxT/cxCx8BpdsVFRT21aCnbMFrC1kAO3M+P24gm7HE2
   YwUtBYRZo523JH36HXtW03pdcRApet0KAlKIJaZDuzeDrNwbo+4yk0yvj
   MGDLgvd1t/pSbYcGqoJhhgJe6+3TsVvorK3l0BYPRMW5WuyQs9heTUBUC
   ypqSGbiX/F29ttunWUEq8Cd0ck4NcShsb9AVgHn32oOH7DjzUwt99Spji
   6fMr3gAGmvQs2DOKO39TZALbZ7dMfvu+x2Kg0W49/lcJwDQvZqJX3v6BH
   R10m1oOy6EbynzL4lPjeMm7sJYwfIdMiEgNmBpex9SdkA0EcFP03BwHRU
   g==;
X-CSE-ConnectionGUID: dkQB8pNhSiqZLp5QI8fCZg==
X-CSE-MsgGUID: cb6OO4tVRo6jd5xNzBDLmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8782597"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="8782597"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:33:35 -0700
X-CSE-ConnectionGUID: x/NtC9mBQau7mwsbvHStgA==
X-CSE-MsgGUID: PF44rmG3QnSUPcfk+Gh+xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="54004611"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:33:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:33:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:33:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:33:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:33:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPa7fcjjMKeDLoYBCJlb2gxZJz5xr4cQYzrZyv7v4d3nZ40cORsc3jufuGfm1ZCXDMerstFGrCGuZ+d/fUa4BziG0U4Ff024xrvVpHGPjvtX+6s/hHbLqxlmqz5G1FuCLFcmV/SKWN/CC3bGDARS9k4Dv8x0GxgAs5i2jpsZYmBj5XOIJKSlqlzICJhsxhd13Yb8xF71REfKkEJRQEB7cv/atZcF0TABRoBmktv0gE+V85HHKt/zjn+nIGshs4//LtXVKFBmftlVGnn7eGF0STX6j57QTnKO+8pYCXTnK/WvFy86Ya1nOA8MfT4tK2HLv4LpBxk7s+7tlEu1Bxs6aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGJpPfj2H4ZfjNskCbozpzFbJemi2Goe7y+Y+QLflM4=;
 b=W/FAQrJlenkN2Z/7b3Ql4z3EvyNzs/E5/O9qW3frwYXSGpU10kXcDFBvm0kXeWP4fG/+TrLxXvt+7jdEEphpv5cZ+tdwBcI1jF7qQbbweLDb3qw/k/sT1sR4BrOzoxtH3znKdUsgmspU/yQ9sOt4ThNNJEZzcOnjYqhqc+dAXkcgpAebNYaq/ajm1rJw8QJoWHx98BY7Z6iSkipm7ub3GDyMCdwoJMjzuBromPjnNWqWdqf/sFIvtwGj/6QBzbnSK/e6/PZyTn8f1p9MZoLxKXidR6+cDtVYkEcjjIfawiwO5X+z7piy789SlFPNs7j005c3/vTG4w1TV+Q1I9D5zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7921.namprd11.prod.outlook.com (2603:10b6:930:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7430.46; Thu, 18 Apr
 2024 00:33:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Thu, 18 Apr 2024
 00:33:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 0/7] KVM: Guest Memory Pre-Population API
Thread-Topic: [PATCH v3 0/7] KVM: Guest Memory Pre-Population API
Thread-Index: AQHakNzaTxX4DImU70ihdbj0RK/TqrFtJUCAgAAIqwCAAABugA==
Date: Thu, 18 Apr 2024 00:33:32 +0000
Message-ID: <e374e93586ff7aa4caecf856031309f5beb63b00.camel@intel.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
	 <65cdc0edae65ae78856fbeef90e77f21e729cf06.camel@intel.com>
	 <8245609C-0086-4DF6-8D17-509165F4D87A@redhat.com>
In-Reply-To: <8245609C-0086-4DF6-8D17-509165F4D87A@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7921:EE_
x-ms-office365-filtering-correlation-id: ca6a6e12-5d7b-4052-e130-08dc5f3f2d08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C5F/1OQQxwiLGCYeXnQFulADNScqDkNDJBjC7nyTSrGDXBlXuf6g714JiL+B5DIFqiYa4sl0AmjOASvCrxTdr87LQHGGQZQkCbQ4b/KyIGYBcu5s0ycVVFpH/Ut735fd4Kl1BGm4XDikNfQIwG2QnRqA99NSfJzE66kLgLgbmxCmhhcRVOERiOaC/AvhfAmcV2MqIPkZuLPP4dgas+U6l1djyIGy0alXwJ6/VV/bhkUME2JrgG/uzYcDyXnqPki7SsyOTUYv/2Mlv1KQuEtlcpL0DK3TXUDLkZogczj7e/TFOp1CTPBgdPFqO745DLyJQ+TrS6BM35oQG9LW+gAFGB5yI3DsEp9ULTGG6gf0LBV18HhYY1pwSFePj37zsiAqHO8X4xCBi5CLSIFFv4DiwFpmC/JGmEpWIaX8qH7ScBYT1Ra5uVwzbYOSAPuIs0fjKuXvX7EahdXpBdsnF673kVXUbXP+O02lCw20FJNVCBxB/gztIR7dh6iTI6EUFrzWJtXIp3qd4VXbQg706RTS5ynS1LeddNuPAPkoVybs8jsgpG5lGKcIsYaA2pOuCu7KzEyRh0CiHUQvzs0HWLFArmVXQWpxsD02VInqPmjNGPV0YjOSpu6bAdtr/XsCFpN6s0AlMPX5CEQ839VLLwBrhY/WyMe3iKqZHJA1ujHlFyNnwVZg5yVMIpaG1ZP76ItmA2LNOa+/jRq6uQR7TH0Nag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHJoejlQczRtR3hCaEdqOE9JOWRqR2kva2loRDVJYzlob0FvL3pjWHVnVVVR?=
 =?utf-8?B?UE0veUR1aDdxajhqNzZTOHNKMER6OVRObER5bjNDZlVsWHcvR3FXeG1XSVV5?=
 =?utf-8?B?OUFITUxhSUpvTDJpcXZHQ3dDRnJINzVOMFpjdngva1NNK0s1eUhFT1FyNDJm?=
 =?utf-8?B?RnEydjRCaUxXZTJBRmZ4TXJRdTZHQ01tM2N1K1V0NmZVNmU0aTRaSUNPM0lO?=
 =?utf-8?B?Uy8wUWlPSmVnZytMWkJTYmRxM1E1ZXFsOE91d2xtM1JnN0ZGdW9kSUg1aDE3?=
 =?utf-8?B?TjZHYzFxZ09wSGpmUGlzdEZPNjRJaHo2cy9ydnVzL3cxMVBpQllhWlEvQTlt?=
 =?utf-8?B?WHo5QnVwdXBGM0pjeEpTVzl3TXFSRExvSzlOQWpWOE1sWkdFZFlYTDZmRXJ6?=
 =?utf-8?B?K2FKb0FlMHVkcC9oZFBlV3ExbHdOR3g1dmN0VElsa21XUkhPcHBORTZqQTE2?=
 =?utf-8?B?d1lFdVZCL1ZLNUNtODlQQ1FsNFdILzdQbGFGdTdPeUNCVUdwb2tNei90Qzc2?=
 =?utf-8?B?bXhTL0xmVGVlRjdUMytHQldhbWFNMGJCU2FQZHVEK2hiZzViUTFhSi8vbmlW?=
 =?utf-8?B?WVFwOUF2c2pwN3pVdDUrb21NbFNrYmJtMWdPd2ptblh6Y1ZhM0dzVEFTRmpN?=
 =?utf-8?B?dFA0VGoyeU9PMy85RGtsNFh3WjNrMWFhUGdlcWI4MWhyVWUzRlhUYkFTM2x6?=
 =?utf-8?B?aS9oeEFFeGxJTzhoSlM1NGZDSXBaUlE5RUVrTFdzZDhzKzFreHIzQTQxTytE?=
 =?utf-8?B?UGJ3ckczQ2s4OFA1REFEOFdLMVFSbERabitOeDh6emNsUHFkcjA4Ukl5U0xU?=
 =?utf-8?B?bGM4M2gxRUNINmplVTYxdm1iVHpKdTFoa0w1NEFhUEt6bE9XTUo1ZXR0REdO?=
 =?utf-8?B?cW1OenpZemMvTTQ2RWtCSnlzNWZ2M2NjNjdxMVFnM05Sd2NKd2orZzZOaUtD?=
 =?utf-8?B?ckxWWWRVbU4yNmdvSDhxU3lsajhPSHZ0cGtob0lIdnRrdWROcFFkVTdXQmNP?=
 =?utf-8?B?SW5DN2ZYUDI3SncyT1F3NU5Kcmx1WDMxS1U4Zk9icGJ4R0owTEp0c0grUGds?=
 =?utf-8?B?Q0RhWkhkQjlkVlRjMGliNk5NQ1VVQmMreTNGYzh2a0gvamt2NDBHa2dGS3dp?=
 =?utf-8?B?ZE0rVS9ERnR5em9oemE1L2VqQjBMMW1keE9aOEVsSGRwUXE5UVIzc2Q2YVkw?=
 =?utf-8?B?aGNBcDlEaXc1RjVvbzdJdkRnL1B4MjRCU0w0M1lMZTNvN3B3dEF4bmRJUTEw?=
 =?utf-8?B?UCtKR0g1dFJ1Y0hYcG9abExuTnRqK2xYZGZ3TmEyWHI3R0tXRmtaeHM1TStH?=
 =?utf-8?B?eEZkaDExaVNrV3I3d21UWnh5MS9ZN0cwYy94QmRvQ1VFZlh0K2hoc09MWUR4?=
 =?utf-8?B?Sm9xMVpEdTBrNjRIS296TnZRRW9BZGM0ZHB2bkhpanprMytJZGEvS0JMcmJh?=
 =?utf-8?B?MHB1ZnBWckRndUNGVVpzWTFXc1JiZGR0TU83b2FVLzYxOEc3MmY1YUR3dnhk?=
 =?utf-8?B?dTBZOTJBMzBZOEZoSEl3dlBnRTVYUmFMb2s2Um44cHBSaStrK1JIcmZYUC9H?=
 =?utf-8?B?ZkFNejBOOFBnQS9jUHc4UUJtRXo0N216YThyMVZTWG1UTXNJSnVqejFsSFRN?=
 =?utf-8?B?RXpRUi81OENqZG16cEIvYVp2V29OTk5hK1VFUFZWb2lndnZzRk9ITFNYbFJw?=
 =?utf-8?B?cWRMMmp3blZFdzlDL01samJ5am9DMUF3VmljWTlMWkM2MGw4OGk5c3dRWG5a?=
 =?utf-8?B?dW5zc1BDT1VwTjFOcGRSeVJRaVIwVWpHYVg0L2d6U01sUnBQcWRTaGE2S3Vu?=
 =?utf-8?B?b1ViNk01UmRBQ0tJZ3h2YjhpOVNZVkxtSlcyWGZQelBmemNXVGc0ZllnV1du?=
 =?utf-8?B?UEFGRVppMURCUXUvVGtoaG9xM1dMV3ZlQVZ6dDZ1S0h6WXB0bEZxa05OcDZ4?=
 =?utf-8?B?MDZqSFhySW1VeWZqQ3pzZVU4d2VRMUF1NVV1SXBrL2lORHpuaGpHWEhEUmlL?=
 =?utf-8?B?YkZHWmNjNTdobjIvYzR0Z3dBQ2NheDh1WlYxaVZrTDFpaEFtUUVVNEorUDky?=
 =?utf-8?B?RVlETlhNUmhOWC80RUJFZUMwdkU0VmFYbWljekVkU3dEWFVxR05MdlNTTUNi?=
 =?utf-8?B?Y1lteWdtaG5FOXYyQnZCSWZMT0xaT0lCemM4V3FLS1VPVUtJSlljcWxCM0pE?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85E6E319966576428554476D4D0C63C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6a6e12-5d7b-4052-e130-08dc5f3f2d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 00:33:32.2821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kOKzpTOVHBrkPAdPdKhWIeUr8kd4BjZyTfrb5i80yVk61GhdS/4u+P93ctv2N+XuOd8OfNDie6ezeDzuokw3X5k0yDj+Aak3V21t+l2D4+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7921
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTE4IGF0IDAyOjMxICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
ID4gVGhlIFREWCBwYXRjaGVzIGJ1aWxkIG9uIHRoaXMsIHdpdGggdGhlIHZlbmRvciBjYWxsYmFj
ayBsb29raW5nIGxpa2U6Cj4gPiAKPiA+ICIKPiA+IGludCB0ZHhfcHJlX21tdV9tYXBfcGFnZShz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGt2bV9tYXBfbWVtb3J5ICptYXBwaW5nLAo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHU2NCAqZXJyb3Jf
Y29kZSkKPiA+IHsKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCA9
IHRvX2t2bV90ZHgodmNwdS0+a3ZtKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qga3ZtICpr
dm0gPSB2Y3B1LT5rdm07Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIXRvX3RkeCh2Y3B1
KS0+aW5pdGlhbGl6ZWQpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biAtRUlOVkFMOwo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyogU2hhcmVkLUVQVCBjYXNlICov
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCEoa3ZtX2lzX3ByaXZhdGVfZ3BhKGt2bSwgbWFwcGlu
Zy0+YmFzZV9hZGRyZXNzKSkpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAwOwo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyogT25jZSBURCBpcyBmaW5hbGl6ZWQs
IHRoZSBpbml0aWFsIGd1ZXN0IG1lbW9yeSBpcyBmaXhlZC4gKi8KPiA+IMKgwqDCoMKgwqDCoMKg
wqBpZiAoaXNfdGRfZmluYWxpemVkKGt2bV90ZHgpKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiAKPiBUaGlzIGlzIHdyb25nLCBLVk1fTUFQX01F
TU9SWSBzaG91bGQgYmUgaWRlbXBvdGVudC4gQnV0IGFueXdheSwgeW91IGNhbiBwb3N0Cj4gd2hh
dCB5b3UgaGF2ZSBvbiB0byBvZiBrdm0tY29jby1xdWV1ZSAoaS5lLiwgYWRkaW5nIHRoZSBob29r
IGluIHlvdXIgcGF0Y2hlcykKPiBhbmQgd2Ugd2lsbCBzb3J0IGl0IG91dCBhIHBpZWNlIGF0IGEg
dGltZS4KCkhtbSwgSSBzZWUgeW91ciBwb2ludC4K

