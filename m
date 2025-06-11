Return-Path: <kvm+bounces-49092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F412AD5CB4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2FBA3A5D12
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14AF20C494;
	Wed, 11 Jun 2025 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDw73BMW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA0C2E610F;
	Wed, 11 Jun 2025 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749660813; cv=fail; b=UblMEg/BoICPA9yGPEnit2JnhX/grUBNz9tZ70JTj5+XaD2hmqhH115xjIH9Hz/kgHXstDnGkOrQ3iXRnYOZFdTgbV0YK4ah3XDX2Hbq5hje0ZSQxPTJQ2clXBAm3LyAJYCN+HYWgbQyQL2O6ubT6q+fj+kaoDxgcLrdjeA0rzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749660813; c=relaxed/simple;
	bh=iqABcx6c/3Jl8kQyGVgArehTH2Jxzn97iZg/4p+TOtI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KYiCvlyxqaBBlV59X6pvbbR8U9cWQUbVyA6F0uCfLX1elw2D2HOEcjEo9imiKzoawlhlxurRi1MnMs6N9BImXmGmloWHY33yLaS4Svcunx8fL/Gu0FAaCU7eMH/QLnIbIe7QmGADh4SNTNaoCO3PmeFI9j0bxtWO4hSmhqNpN5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FDw73BMW; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749660811; x=1781196811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iqABcx6c/3Jl8kQyGVgArehTH2Jxzn97iZg/4p+TOtI=;
  b=FDw73BMWl6QetQymu7mdt/gSbqmFxOhW/1Begsc+/8NCo+EMXYSSJJlx
   VhVAJpxb0/atrVtcv3by7BRYc6va85tH1RHvi1MGBot46tY7fVbgaInl4
   3h2SQVBAf2hXE75VBvZ59UDy1HIF5n9UCNtkthmHEdDVRUOYzAeCdd/QF
   GjR0pQ4JgbniwUWwQeT6CGwthoYCTJBD7v3GABRRLcvfoTVbwiH9/0qVj
   +6BNA7C9BV+sF6AFBVVBk0Q8K7HDUhsW5YGcIF2FdfFr1WRcogbenC/OC
   XDwDtNXtbY/F0C3iRgnAiDWFsx3FeGWQSF2OrLFGdhutILaL6R4hp5/BM
   Q==;
X-CSE-ConnectionGUID: jfjyjUgpR2+ts6h7NcnydA==
X-CSE-MsgGUID: xTr+urInRlq6eBa1J5e1Aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51528780"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="51528780"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 09:53:24 -0700
X-CSE-ConnectionGUID: 8u5ym+wxRz6T7EFHJsu7EQ==
X-CSE-MsgGUID: W1vIXvoqQWGvPZ4st4zsZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="147105260"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 09:53:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 09:53:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 09:53:22 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.76) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 09:53:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SU/EDGOFG8wUVknzF+tws1srtfh9bXrSKA+ebterFmEL9t/sOw/gBK+AqFC3SelauV1WeRIOgsc2vYG4L+DbMehX3bOKtSkJvL7x5+wo3Zu2E3oasMFYQWtO30XbPuyCMK2ijbu+Y+FH1o4U5yEPcfTRSzIZp9nk0pKBuJVqJhCpkevwCTgyFv9SgImswdP894+ET4tt2vSY8xTHa2JJSNZPJHp5tucyMQfVnPV7nwgmMdD8Rhwb5rhrI/hn0lHlmhlMqWWjkb47wGddViUD678O1l9O3XoBKs28Kru04/S8FsImg3jrsrHMFTK3+5VVWvTXFkZieSbQKB445CdxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqABcx6c/3Jl8kQyGVgArehTH2Jxzn97iZg/4p+TOtI=;
 b=uonthBzjkOmokw7eRJHXVIsHPdzjMClCiZwdU6OJdKraH6tasHoaV/7CmNm6jDcU3wz5Ro1RgFhls5wCLr8hW3I3iDp752Du9fYDMJlqi6v4S7nRFEqIVy6aehq8aIf15flgZdE2TQ3BxWjIwQAOy7tkobahfIn4hN7KKj9GOyQgEg0jxQkOP2ZqR1WMoNrXmPglmMhQKect5kd34XKZ2jlssmUPamKeeTVtvvKW8aDiwp8z2ZNDF3pwobYQYXtgmhC0pkS4rk3xCoqCHS2csRrb3wji4H5/2nnlkU0NKUNiD3FlD8Ft8Fe+NEepMMEGP1WY+waAqMj2OLXkW/uguQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5125.namprd11.prod.outlook.com (2603:10b6:510:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Wed, 11 Jun
 2025 16:53:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 16:53:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAESDYCAAAs3gIAA02cAgAABHgCAABiEAIAAB40A
Date: Wed, 11 Jun 2025 16:53:19 +0000
Message-ID: <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
	 <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
	 <aEmYqH_2MLSwloBX@google.com>
	 <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
	 <aEmuKII8FGU4eQZz@google.com>
In-Reply-To: <aEmuKII8FGU4eQZz@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5125:EE_
x-ms-office365-filtering-correlation-id: 0e9a6d72-1c00-42e8-f438-08dda9087832
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UWd6UDZwQU1ZVTBBRDNYbW5waHRiQ0tqWFJuSUtXeFp2aWhOTGMrWVpxN0Ni?=
 =?utf-8?B?eDAyeXZjTjBFQUl4VXRJdU1PdnNrbFR4MEhJVjh1RWtJb2FXUjdTTlYyM3cv?=
 =?utf-8?B?TkJJeDUvT2JHallyMVVkME5SWlRCQyt3bXh1cXNPUG1jaXFPeFAxR1JuTU5q?=
 =?utf-8?B?djVVWTIwd1lGdk5NcWNXSWlHWGY2SERIQzVPOU9JVmN4SGkxWmZtYkluRWxs?=
 =?utf-8?B?Y3lLQXJRVE4xYS9vMW81eDE1cHdSVUd0Ry84eVJtSUp1OVRmbkx0L1laVitI?=
 =?utf-8?B?WGJCYm80aHoxOFo3dmQ5T21lMHY3bXJ0TkYraE51Sk10WEJLTXlNWTN0ZEx1?=
 =?utf-8?B?R2MwQitLbUlXT1g2d3dSbXpoZktyS2oyc2I3UXBkVnF1RWJLS0RSUUR4ckdW?=
 =?utf-8?B?SitReFBJTHdrMjcyWlhpR3BkblFJYlJkcjdUdm1EamlibUJ1LzZFQmluZTlX?=
 =?utf-8?B?NzI4NDR4SDVyZXhWMzFnUEZaK1BsUDBLWmVjNE1Xc0lvQ3kwaTM2UnlOZXBQ?=
 =?utf-8?B?a2JvVDdMQUFqaW9JR29XNnU5MFh5RzkvMnExcUd4b0pwRXdYc3BaQVpPcWFW?=
 =?utf-8?B?T3lBQ1FkamorWlVQSXdlS0pqRDVIaDZTTlNkWkxXc3RYUjVBV1NHTzVUV0Zj?=
 =?utf-8?B?OEZvZXp4T29vRXhzaWJ2QkJGRlpQVUZKOVc1R1pKRkZNeXQ0TWNQOXR5NXAy?=
 =?utf-8?B?Qzg2QThNZm9DdU11dGdTbXBhVXhiTHh0ZUZTb2JvbjdiSEJlVTVmKy9ZZ21B?=
 =?utf-8?B?OG5nZWtjcldKUHhTL1ZoeFkva0VHTGRWV1Jua1lMU1Rwbld1VEJ4WGoyVHRs?=
 =?utf-8?B?djJQWW01UmlyalVXVm8vaCtSZE9MdTRWUTVNYnVXdjVYVWdScWI0VGVKNHBu?=
 =?utf-8?B?c1ZXZHhlZU9FT1BnR1VBdXd2OFFEeVQ0bkl2ZGNZVUJKNW50cHpDcUVZM2pZ?=
 =?utf-8?B?ald5ODc0emQ1NnZhSEF2TTgwMWsyMDFJQVg2dzN6Ry85b2trYTQ0L2ZtVHJo?=
 =?utf-8?B?Z3VzVzBma3MvbDRPd05jaGVzTlBXZ0ZzNHNLMFlOcUllbCt0MVhsMTlwdFdx?=
 =?utf-8?B?c1YwVlpUc0VyckJVZ3V1MHY2d0E1OXp1aXJ1WkVNMTJlT01sNmk0b2xUcUhZ?=
 =?utf-8?B?NWhsNlFCczFWR2poRWQvZm5yL1lacTFTVDZUWU9LaHFiaGhNVFY4bHBLY1Na?=
 =?utf-8?B?dStNR0RoM2hxNXpXRTN3TUluSkFZQ29FZVIwZ24zUFU3N2tUNGMrWmZmdGtW?=
 =?utf-8?B?MU03bkRVOUgvM0ZtZUdwWWQwS0FMWSt4QXFwN3hDRWZYclZRYndhTlczMTAz?=
 =?utf-8?B?Vk9xSmVGY1BWT2V3VG14cFRMY0ljcGVSbjFYMkhwY3ZzeGJHUHJyVHhHT1FZ?=
 =?utf-8?B?Zzl2WFlzcWdoNVUyMXhzNXN0WU9FWHdzUjluRFozcVJ3bjJKNTNKZ2RCWGYx?=
 =?utf-8?B?ZU9GOXdzTStqcVQ4YzNJOWlpai90T0tLNDRZRnA2Y3ZEaUVzNDAvRVFmZVNI?=
 =?utf-8?B?c2owZUVrTmFiYTVMclpXRE9tQ1I5RUVIYUtXNU5BNzgyamdnclZkT2hkZEYx?=
 =?utf-8?B?SngrbmlJWWVYZDdCMitNVDhGT09xbUl6MitSK2kyRURCbkdpSjFjb1gzc3ZQ?=
 =?utf-8?B?OUhXdUNveU5vdUNGbXNrZk9OWlVnNUN1aC8zZkw4WVJBMm5pektsT3k5VGR3?=
 =?utf-8?B?Q2R1WXY3YUQrVmt5VjZyZ2Z5dVoxNzVFRVpSL0wvZVdobkJqTFJBY1o3QTJW?=
 =?utf-8?B?UDB5OFFxOG1pSGhHK0xqSWZPSXVkTlJUbThGYmN6b2RNQ3QvNkJNYXVSanFC?=
 =?utf-8?B?V2VvbUZIV3d5TW5CY3VFaDdoRzNITWphdXp5bTRVc0o5eXFhTnFJQ0VWZHNt?=
 =?utf-8?B?M0NjcWsvMUY3d2RsUUl4RXJJT3k0WnBMcjNObWx4TUNWMW5mRGhDN0dMZzAz?=
 =?utf-8?B?UFlIU0ljS2c3V1d0RGg2d0pocnZSUzV5Z01KYjF1RHFGZzY3Y0dtSGZjeVdD?=
 =?utf-8?Q?tN0V4vri8xQWoZoIXGtSiwhBIvkC/c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnNIUUJMeGFmMDBsN1pVWDAvWEJMUEdmMU9TKzlJbGZNejU0S1Fvd3lkdnE1?=
 =?utf-8?B?R2ZEYUZGMTZMMSt4SnpSOXcrS0JPM0lENjlWUWI2aTdLa1NGVnk1a3Fud2xs?=
 =?utf-8?B?OThCT2xpeno2ZW5iYkl3dFJ5b1doMDdudUwwTWVrQUxWbDFSazBVbTlaVS84?=
 =?utf-8?B?REx0WVBkdDlpVlBUWENoRVEwaE9SWTM4N2RZam5wN0pWbVg4Q0JjamQ4OVpF?=
 =?utf-8?B?R2dSbjdha3VyeTBmOHV4ZzA4cCsrMzE1aSthOWVlUm9vOVp0OVFsbVVEcTB6?=
 =?utf-8?B?YTZYWlcyWVR2MHJIZVlTVjdNY3hXakJXKzFWdE02UU5nVmpwUnRxTlMvdEJO?=
 =?utf-8?B?cjZkcGlQUll5STZLc3lGdHh1UVZNMHB6NStIdTNNTm5kZWhhSTZCWmpPT1I1?=
 =?utf-8?B?VHF3MVBZSkhqK3hiVDZMYXlUb3lRRFh4M21GQ29VQ0ZGcFI1Zkd2V2V0Vk82?=
 =?utf-8?B?MHUyckswQ1I3VVFVSzZkOUtOeHNYS2c4QnR5SCszb2pqTDZzK3ZCWHNGT29h?=
 =?utf-8?B?VlpsQlpjbXJraktHODZnb0lzWnVGd212aFNXTDZPY2prVUhFcHRvcDZ5endC?=
 =?utf-8?B?WCs5a2w0OFcrUHlLSUxyNTNlK1hUL1IxOHpPSEo5K2tpRzJoMlBLandENFdH?=
 =?utf-8?B?eC95TDhnNnIxV2JGYU95QncxUnFIbEdXNWVaclFwbXJGWWtrR0ZOOU5mbTJw?=
 =?utf-8?B?ZDVNemszakZDbkFqbEU2TkhIRVovK3p1cXVOdktDMmM1Z1lxcmpld1hxaWFJ?=
 =?utf-8?B?cGR2VlE2Qkpqd0VHeFBHVzIySHNyZTcreXlqR0o0Smszd2NPS0pXZG1Kdkdr?=
 =?utf-8?B?QlJnb2xmUjU0bUpjRHB6ZW9jM3BoSVZaUXRKR29ZajdWV1k4bEtYd0s3eGpn?=
 =?utf-8?B?Q2RLTEdlQUZiNTM2WHJLaVgrZFBPdkRQd1pIR2svQ1RrSGNDQ2FYZng4Snkw?=
 =?utf-8?B?bUpLYk8wNlhvdG9mTmR5MVdEQWErMFBrV1lIM2Irdk9mWkdwUHN4aU55WFFp?=
 =?utf-8?B?KzUyU0ppKzFoTDVGNUlmK0tCS05BazZqWmtWZUxDN1ZWMWhpek92Yk5KR3Aw?=
 =?utf-8?B?S1BSNzgyRnFKL1FLRXdxMEZ6L3hPVFJaVHJwaWZKaVk1V3RlUThQcjhEZC85?=
 =?utf-8?B?RXZrUGR6UW1qaFFwZVpsRk9aREcyOEhsQ29ESk5mcEVxL2owYU85THYvWEdI?=
 =?utf-8?B?VmRLMDlHMXJXd01EcE9pRlRIeUtaRXZBdFFUK1l2eVprSll2VEppSUIvOE9s?=
 =?utf-8?B?d0haZk5SdHJjQXVYZVQ3UTlZT0tVUzNRcWlBTzNSNEYySnQ5aXFzV0JNNjhM?=
 =?utf-8?B?eUlwV2VYeUhqT1FnZlNHNEtTMkxrSzV3OFN4UjJ6eEk3SmswMitpNnh4R2h1?=
 =?utf-8?B?R2gzN0RleGhyelBoZmsyMWtLeGtBaDQ3YjNBSm5BQlFmTU1DTjF1cVlGcHda?=
 =?utf-8?B?Lys3bGw1WEErN1huL1NOS2hFUmtVa25tWDFLenpEODh0V0tkeURJci9kUDJl?=
 =?utf-8?B?VGlKTWwwMEZtT1dmZVdGRGpJMGIvWjI4em0rUnpqaG1oVUpiK2hiYWZud1lT?=
 =?utf-8?B?MFMwdkNEV3JSV3J4NFpRekxZOEpzRGFSVkVlSTBPUWJ5ZXRzSDRMVDhXWGJk?=
 =?utf-8?B?bzd6YTk5a3EyZm5GejFmTENHYXA2eHFrRklINEYvOHppRElTVXAra0FkZEVV?=
 =?utf-8?B?ZGRBTDVrN2NBQ2cxVktXczIxbXJBMFU4WkxqNVphdGVldVk1NmIveDRVVFVM?=
 =?utf-8?B?RnF0eWhZWEhMSWxCRzFVU1BJVzZuYlJlclgxZWpYcXBVbGl5dVRRVWhuTTBO?=
 =?utf-8?B?cnlTenZUbEQxdlpMQlhld09IYmIxb0RSRmVXcVdxTjMyaFlDbEl6S05NNkhN?=
 =?utf-8?B?aDE3VkV2NFkyZDJDUEU4RUpzcTBRQWpBN2hybmR0L2J2SU5NR00vUW1OaGFI?=
 =?utf-8?B?VkUrdzRkSEtjMy9BWkMrL2lvblZzdWxEMTdwWHEzU3dMR2lOMEZUOWJQSFpy?=
 =?utf-8?B?RHQxUG54NDEzcFp4bnF2TGErZGxoWlN4L1R3b1JqdEZ6UEQreWVkWlNnRVJt?=
 =?utf-8?B?ZVozZVFZWU02aUM1eGE3ZThQTlcwa2lCZWtvNGdZUHI2RXl2OS83M1lHR29m?=
 =?utf-8?B?blpMS0VpQmovWGFYQXJubTB5NWFKLzNIVk5vM0JMZ2hac29zZm5iTlFpMUxi?=
 =?utf-8?Q?Id7D2iHRwWzpHzYuza/Fxk8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99B6BB8E37571346956AB63ACDC9739D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9a6d72-1c00-42e8-f438-08dda9087832
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 16:53:19.7651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rX4ubIqCKc//0mtRqv06SQCiDcrtUwVRLdiLbx/o85gqToLxN9LysuPyjJGZfNXm8WM1bGg9aBdHJJQZIGtmq9CLgTM9j2sONvBWjo2xZK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5125
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDA5OjI2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEdldFF1b3RlIGlzIG5vdCBwYXJ0IG9mIHRoZSAiQmFzZSIgVERWTUNBTExzIGFu
ZCBzbyBoYXMgYSBiaXQgaW4NCj4gPiBHZXRUZFZtQ2FsbEluZm8uIFdlIGNvdWxkIG1vdmUgaXQg
dG8gYmFzZT8NCj4gDQo+IElzIEdldFF1b3RlIGFjdHVhbGx5IG9wdGlvbmFsP8KgIFREWCB3aXRo
b3V0IGF0dGVzdGF0aW9uIHNlZW1zIHJhdGhlcg0KPiBwb2ludGxlc3MuDQoNCkkgZG9uJ3Qga25v
dyBpZiB0aGF0IHdhcyBhIGNvbnNpZGVyYXRpb24gZm9yIHdoeSBpdCBnb3QgYWRkZWQgdG8gdGhl
IG9wdGlvbmFsDQpjYXRlZ29yeS4gVGhlIGlucHV0cyB3ZXJlIGdhdGhlcmVkIGZyb20gbW9yZSB0
aGFuIGp1c3QgTGludXguDQoNCj4gDQo+ID4gUGFvbG8gc2VlbWVkIGtlZW4gb24gR2V0VGRWbUNh
bGxJbmZvIGV4aXRpbmcgdG8gdXNlcnNwYWNlLCBidXQgdGhpcyB3YXMNCj4gPiBiZWZvcmUNCj4g
PiB0aGUgc3BlYyBvdmVyaGF1bC4NCj4gDQo+IElmIEdldFF1b3RlIGlzIHRydWx5IG9wdGlvbmFs
LCB0aGVuIGV4aXRpbmcgdG8gdXNlcnNwYWNlIG1ha2VzIHNlbnNlLsKgIEJ1dCBhcw0KPiBhYm92
ZSwgdGhhdCBzZWVtcyBvZGQgdG8gbWUuDQoNCkxldCB1cyBjaGVjayBvbiBhZGRpbmcgaXQgdG8g
dGhlICJiYXNlIiBURFZNQ0FMTHMuIElmIHRoZXJlIGlzIHNvbWUgZ29vZCByZWFzb24sDQp3ZSBj
YW4gcG9zdCB2MiB3aXRoIEdldFRkVm1DYWxsSW5mbyBleGl0aW5nLiBUaGlzIHdpbGwgcHJvYmFi
bHkgYmUgRnJpZGF5IGR1ZSB0bw0KdGhlIHJlcXVpcmVkIHBlb3BsZSBiZWluZyBvdXQuIERvZXMg
aXQgd29yayBmb3IgdGhlIHRpbWVsaW5lcz8NCg0KVW5kZXIgdGhlIGNoYW5nZSB0byBhZGQgR2V0
UXVvdGUgdG8gdGhlIGJhc2UgVERWTUNBTExzLCBwYXRjaCAxIGFuZCAyIHdvdWxkIGJlDQp0aGUg
b25seSBjaGFuZ2VzIGFueXdheS7CoEl0IHN0YXJ0cyB0b8KgZmVlbCBhIGxpdHRsZSBmYXN0IGFu
ZCBsb29zZSwgYnV0IGFub3RoZXINCm9wdGlvbiBpcyBqdXN0IHRvIHRha2UgcGF0Y2hlcyAxIGFu
ZCAyLCBhbmQgd2UgY2FuIGZpbmFsaXplIEdldFRkVm1DYWxsSW5mbyBhdA0Kd2hhdGV2ZXIgcGFj
ZSBpcyBiZXN0LiANCg0KWGlhb3lhbywgQmluYmluIGRvIHlvdSBzZWUgYW55IHBpdGZhbGxzIHRv
IHRoYXQ/IElmIHdlIGFkZCBHZXRUZFZtQ2FsbEluZm8gYXMgYQ0KbmV3IGV4aXQsIGFuZCB3ZSBj
b3VsZCBhZGQgdGhlIHN1cHBvcnRlZCBURFZNQ0FMTHMgdG8gc3RydWN0DQprdm1fdGR4X2NhcGFi
aWxpdGllcyBhdCB0aGF0IHBvaW50LiBJZiBpdCBkb2Vzbid0IG1ha2UgaXQgZm9yIDYuMTYsIGl0
IGdldHMgYW4NCm9wdC1pbi4NCg==

