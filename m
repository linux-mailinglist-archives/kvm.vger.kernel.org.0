Return-Path: <kvm+bounces-20498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9774291728F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 22:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6112B227B7
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 20:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E9117D88C;
	Tue, 25 Jun 2024 20:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FXEB7pdc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFC14C6E;
	Tue, 25 Jun 2024 20:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719347608; cv=fail; b=TnaxY2YngIFae2L+m/nPPdEc6qaaiJGUx+zFEQd87asMIl3QZvZzwr8k6EdYUDrifFaOks35ypWOmtEz2PVTTf1300OydNS1pgTmmWWMUfQmq3FpAT5TzdBkqocE3psRspDwR31wFD5ppEGoCl9565hPvjZ8TPl9BHms5OCpssw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719347608; c=relaxed/simple;
	bh=ZwptwwQiQQCabvZ4mz91UhD1rxKMocmeWBSppsS0KBw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SRI28ASSyOAajq1kX9kdJrjSZuO1wsU7C/O5wDtVKS+aD8eB1i8gf/w2DiHLRr/j8N9ciXAt732PcLOUeUDn3wPU/2+7dC9I5IUAQKqYbukBQw+qpFbGW2HQG6yXX2/QVDh2wtrjebYzWib6vrBNO8KawCFdBcoJzaX7ED0zV8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FXEB7pdc; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719347607; x=1750883607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZwptwwQiQQCabvZ4mz91UhD1rxKMocmeWBSppsS0KBw=;
  b=FXEB7pdcGH8aY43il8mW33UkJKZ2A7tazqtCHdBdHpzPwwqWsusotA1i
   +vVXekuKtNmqIKSe7dle0pFLEDPR2WHZOih9O0SH4Ti0kdjoqKKWPEKxR
   wRv0t2xp4U2ti7ZI+p380XowLosV4WU6Ec2uM5crEELgqHAGOQuq6J9ld
   t3J19p6CKI7B9/NZyusSa4JWrac5kSVYhsFESUaou8FtPmhMHKrliXVy7
   ShklnO4ZONwq7VH5bDHkkebnXGyTTYi5ZhwfdbpcxqziL1WSgw7cgxt3B
   RE7b9RNdKYv4zU626CXDKR4Iihte4coZI0naL57Jwuy1cl7DP3Ujr0++B
   w==;
X-CSE-ConnectionGUID: 30SPb+JLSJauAD42/sqC3w==
X-CSE-MsgGUID: Kd1BhTJmQbqJtaRoFLkK9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="33924273"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="33924273"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 13:33:26 -0700
X-CSE-ConnectionGUID: fNwyod7UQaKUgC36u8itFA==
X-CSE-MsgGUID: 4EQxj0OHTFyOFWvRqNaxtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43859077"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 13:33:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 13:33:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 13:33:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 13:33:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 13:33:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAEkNsYFU+tR0Gd8+byf6vQrDPPj2XKqT8NgBABDK1ybljU/ti9Y5UxIW+ur1pJRtGtnkb1nue/8xiVOdD+ngvEtumIvV9Vf6aJ9eI9+f8rI06r8yHPD/vxjh69+bKvhts9cKcrJA6soy8H66PL2FaT080RaKFaAdAvcKaad1yS/ragWzynSnVk8uMzdmy8uPVSV1wgG9xW5wXlo6hjC4KYMqbOI60L6yTtl7IPlBfVhFWWCIaD/WPEm4E6fAPd0k+Pa3vd+YBAgKnZLlJuaPVikZrB9RRgMFzFLqGp8WNmxHoE1wqcSwLnKGT0cRNMMQ3qvoFpkews2eonzHBGd2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwptwwQiQQCabvZ4mz91UhD1rxKMocmeWBSppsS0KBw=;
 b=bnQBbACqaqlJEM5cIDEni9gRYFgr9QWjoVBl93udu1hrnFk1d6R4r6zB36G7Zt96lfAhpfQ6ESI/8Tlat9Q3lZas8c2SC+wDT1gjwFUTLAWBseEWnWH+MRP/z90ZOof32qFKqRwOSgeujgAVxM8RdngdRl8mvBpTEGQrfsW3kzpLCvfKcGwOekjb2SjT4E3M/nXgLGBXLOLAM1aUHWtmPTSGHtQTDyHsn8UA4+900QEklL5Me7DNvCoBm4yS+2iz5xR/JLfXybGiDpey70gUeoFtVqxDp8EydxB0ryYZJlrjWp2p7dfPrPJiFal8y9DyLIyU1noMY4nVP9+xoHl4Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB4960.namprd11.prod.outlook.com (2603:10b6:a03:2ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Tue, 25 Jun
 2024 20:33:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 20:33:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHawpkqUontib46sU2zk5qqIlBj6LHWnFqAgAESGACAAFF6gIAA+LWA
Date: Tue, 25 Jun 2024 20:33:20 +0000
Message-ID: <70dab5f4fb69c072493efe4b3198305ae262b545.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
	 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
	 <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
	 <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB4960:EE_
x-ms-office365-filtering-correlation-id: 97234d1a-3f1d-4262-868c-08dc95560d72
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|366014|376012|1800799022|38070700016;
x-microsoft-antispam-message-info: =?utf-8?B?eW9jUHBVcWZueFh5WUlzQ0RvUXJyTDB0MVlacVJaeE5iRHh0b2U0ZnFndTI5?=
 =?utf-8?B?UWl3MDUxdEpJSXpNZEN5N0xxc05WdXMvV0JVdHN2Mk55bHp5K0R3b2dOeERh?=
 =?utf-8?B?Q0JsTzBlSzZ0U09WL0wrbzBDS1IvanJzWXhqRWx6YWk4QmxEZ2RYeDB2RXU5?=
 =?utf-8?B?TDhJUi9EOXJLTVl4WXQxN3kvRzJyaExGVDExamhzTWpZbUh0TFliRUlRdFZo?=
 =?utf-8?B?MzZtcGFxeS9uMXNxR2JPMExndys5VzlTWTg5UytxUkZLa2c5aDdsWnJIQ3U3?=
 =?utf-8?B?LzNQR3E5eW9lTG9veGQ0ZXJ6aEZkQ2wxaVVKRW90QjRrOFg2RlJQaFVsd1FV?=
 =?utf-8?B?WndOZ09TdUNNeTA3aE5mZmpWQngrVFZtUjZWVDN3VC9iUkprbjh4eGhEenBX?=
 =?utf-8?B?MXN0anhTVmVBdWVDR05UZ2F4Vk1tMVErRkNtamZFZ2tvWU5HSlFZc2xnNUkw?=
 =?utf-8?B?U3FuQ1d5bGNCbHBNWjRMZnN6aGM2dmJCK3o4SWIxU1gzcnY2dis1RnJoVFBC?=
 =?utf-8?B?aDhGRFJ2RnhlMTV4QU42RDAxc3NJbzlzS3pEZjRSRCtKMS93NXpDdVEwUTJw?=
 =?utf-8?B?T1pLTm1zVFU4WllCRmNyU3VVQUx2Y0lWRk0xdnNIQjZNRjFESjZCYk5JUk1v?=
 =?utf-8?B?cVI5ZXU3MzF1YVNTWmIwbGZiOU52NTZWbWNoUy9aT1k1SFRXNk15c09odmhV?=
 =?utf-8?B?SkhjbDRHQjNTUE12ckVXQUJSeGhrL092aWJ3TmpkZDMwUkhGcmRQaWQxNWs1?=
 =?utf-8?B?TjZaZXVVdjBGMUtraTBCNnBMU2dlSE1RbnZma3dCS3lqNmlIaDVtOElzZjRO?=
 =?utf-8?B?djJRa3Y5dFNwT3p1UFZVK2ZVdjBBNDVGdk10RUNVc0RZdkZLNDhQUmMyOVZP?=
 =?utf-8?B?RFdzUmJOTk5rUDZNbVpRZDRsQ1ZFcENicmlWVVQzK0ZXZFlCaXNPQ0xlY29T?=
 =?utf-8?B?UWwyZUhuT0UwcEN0SlRQczA0a1hsM0lUTWVNNW9CUEVYNmhTN2lldjFLa3Vk?=
 =?utf-8?B?bXg0SVdrUm02b25qSkZmWVlTMno5cmtIQzB1dnBwV2JJMm55ZDhHdVRNbnpx?=
 =?utf-8?B?Rk9ZYklVS25MOTJrWVR1QlRUU3ZQd0xoWVRLWDZqWGFod1NxTTJBTVVXKzVl?=
 =?utf-8?B?WHptN0JOWW84eW1YanNIR0JJZzkybzlBdmpPNGVKaUZTTXREd1hWNGJUT0dU?=
 =?utf-8?B?UGoyNWt5RHJKUGZaLzU4S2QwNDR1WXpBQjd1QlcxSGxFZUNuSlhVRkJ5Zk81?=
 =?utf-8?B?STdZck1uc3lyRTJEUEUxaUh0ZXBIaWdCT2tPdEhLcFBGRXlHOVJCQ1NHSUg2?=
 =?utf-8?B?WUczd0l5WGphTHJ1enVNaER1S1pyeE9tSUx5YWptWkVXVEZjSWRNcnlqZ2sy?=
 =?utf-8?B?T0tiSXEzajJKYUUwTUs1bkllclBFYVIzWUhWN1J4ZG85UzQ1UmRhK1ljRFJU?=
 =?utf-8?B?RFlWVFhQYkVhR1FjYzh5N2lBemF3WENYQUZ0RGVwSzVSYmlUUVNTTCtQcytG?=
 =?utf-8?B?MkxsbWF5Rm9OMUM2SE4rOGpCNGlQRG5hMGRsMDVSbWhFUlRTNnh6M0ZhNm94?=
 =?utf-8?B?b0QyVnFjQjQ4Z3ZIeVdseTVLM3k5SENYQVh5QVBNSGZYR0VIZ0FzVUdsYXZs?=
 =?utf-8?B?NkE4OXRBWlFRWGFpbmFQVW5FWGMvWW5NaFcyR0lvWWdEK3NNc3doVHcxMGhh?=
 =?utf-8?B?WitjTGRvcUtaUFc4UnJkdmp2RHcwYW1hWXArN0JJK2tRWXBBZFZpWEFKSHRJ?=
 =?utf-8?B?cXNDUVVBcThVdXo4anhJcmUvQk40WWpTWHZqUTBxeTByeUxOYzFHL0FNNU1Z?=
 =?utf-8?Q?LyLmyii0l40w8vHbDuX+AaRCEqOBuX9J7bUag=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elhYTzMvMGI0SnM0YTlSbE1UMExTY2lDYnRZcGpzNTdLWXBRSm9BU2lhNWlt?=
 =?utf-8?B?a3hnQ2g1YU1tRUNCZDNEOFQ3eHVRQ3ZkbDZaS3pnTUsydmlYK3JuZXhLdDNu?=
 =?utf-8?B?bGJ6QlhucUxZZmZ0dFcwdlJCWHFvZ2s2YldpcDJxbnhwdmRhZm16RUVoaksy?=
 =?utf-8?B?R3VkQTJFTS90OWlPZXhVQVp5L0xFYk1JV2J3Z29xRFdKNTBaRXp5THFGNU5k?=
 =?utf-8?B?bUUzcXJveU4zUEJ6eGxrTDZHb2VGejRZNkowS0NTT1A0Z0laeW9Pek5ZRk05?=
 =?utf-8?B?MmRUOEFraDFOejNsd0dtZm5RckxKSTNSMjRDeE4wdjBOaHV2WTJlQy9GZ051?=
 =?utf-8?B?YWlyVmFXQ3AwR2d4MENJWnpWcHRmSWtrQVg1cjZKeG9za0RHRkhLWWxlOGRJ?=
 =?utf-8?B?ck41Q1B2NEdZK0htZzk4UXI1SU5TRWxqR1Q0VFBNSXZVUG9ORlBzVTFWSExm?=
 =?utf-8?B?T05QejdYK3kwaWhkVVpYeDY3ak51TWZsY0I1VU5EbUVOTmcvL1hIcW5FSy9L?=
 =?utf-8?B?Z0tZOTlWMEhKK3dkSFZEaGd2TXFnMGJ3eDZoM2o3Z3FjV2lmSHhtdGF3MHFS?=
 =?utf-8?B?eURFV2lPRm1aM1hTZEoxUFMwY1lkVDMrYVRqMzV1L1MxQS9NcTNGNW1pcXgr?=
 =?utf-8?B?TVRFb1ZFRjFVeHl1NWw3RHZKanlzbVJMSkN4VXpTT1hGTXZycFZ3aUMvUFY1?=
 =?utf-8?B?cDhxQmpZc0lJUnVpbU1tZjlDRHdOYmtocGRlaUNWdVRYTm5lOUtCaUZJamU4?=
 =?utf-8?B?dnEzaXdOZ3RORHZSZk93Z1BpMVVFdms2M2tqS2M0OVZ4UVZiNGoxOEhTaW5Z?=
 =?utf-8?B?MkpvVWZOajJ1OUY5dnN2SGFRNEsycXNFY0FXTmx0Z3VuTFJuazZvMTBITlBG?=
 =?utf-8?B?NUI0bmVWRzh4MWZ4UEh0NzZBQWRzNkdOQm9VWW02OXBobnNoY1M1ejdQMHBK?=
 =?utf-8?B?U2VoVlMzcGpxeWpMWlJRQ3p6QUFSU3QwQkNtUjJDR09zSkNZNng0QTI5QVBB?=
 =?utf-8?B?WjkxazU5MGFLZXYrSmU5eElLR2NzQTFscXBuTkVaNzlqWjlmTHh1ZHUydmU1?=
 =?utf-8?B?TWJOdXk3Rkk3cWR5S0tFMWphcTROc0hQa0EyS3c2NEszQTV3NkhVV0lQbXVN?=
 =?utf-8?B?blZkUThBNjcxbXcwUjQ5YzRRWUsrdzkySnU2Y29EeEhEaWZjVFcxSzZXcm9r?=
 =?utf-8?B?MkRZbHQ2R1JKR3cyeTRjQVArZ0FlS05EKzlTUzBCYkpMeVlTZkY3eUJFZnFv?=
 =?utf-8?B?NEY4TUlxcmhzYlIvVWE5V2xRMlpBNEU0elVyZTByZXQ5Z01DZVJnLzJ1aVc4?=
 =?utf-8?B?aGZldy9KQTR4dlFlTmkrWm42cmpnTVpWQjhNdi9ZQWN4cmtFdDFMOEZTUVlt?=
 =?utf-8?B?dFA3VmpJNWJrSVNvQkVIMVFqSWc5UVEwR2tIQ1NXeG4yaVR3dy9MdS8yTTBo?=
 =?utf-8?B?dGh3UjB2cU44Q2d5dWhYbEdqcDNZUU8xaVNVVXIwcm4vTmZSVTAzTDU4Y21B?=
 =?utf-8?B?dTMyOHNGTitTMkx3cDJOWld4Y21TUzBoVmV6TmFQOUNnQWI1bGFvK0grNEZs?=
 =?utf-8?B?S1ZvS0dvRnVqWm9FWk8vMmRFajVhYzZqemNGS1FFY3M5QU9GN1V0RTBUSUYv?=
 =?utf-8?B?QytGM1M5cFNGcGN2MExvK25VaHhUZlhTRXFvTmFQSzBDVEhYby85bUc5eS9Q?=
 =?utf-8?B?eUJQUU0yc2EyT3M2akZiamZETUplUnM2U0lLQzhlMCtyM2dXamorbERDQnBM?=
 =?utf-8?B?emdvT0JsUTlrY0xkTXBEeVRLYW5SUWxXQkR4RitHK2dSUUtDT1V4R01ZVUZQ?=
 =?utf-8?B?RUVWUCtZS1BjQi9YaEY4L2h1ZVc5d1JtL0xmNjNjanZaMkt6NUxHT2N2aHVy?=
 =?utf-8?B?ZGZqdlFNMG10akdDNE1xOHEwM1lxbnRXTzJaM1dYWC9xN3ZzS2U3MUtmcmtN?=
 =?utf-8?B?RHJTekVnbFlmcFhGc1UySnFxbHpUeGdYZUFXWjZHVTRpTE9Fb1I4d2pjK1pO?=
 =?utf-8?B?QWRqM0REQXhpWEF6MldTT0svRGNndXRBSENsYXhNVHhxSS9Uc0tUcjJvR3VX?=
 =?utf-8?B?TVFwNzNPNnM2Y0F0a1lDcm5SVmw3QnlabWJSM0VVRWVkbjJjNUlVL3pmR21V?=
 =?utf-8?B?aFh0NmpYUk1iZXNMdndoRHNsSEhjODQrbDhyQVphRHZLOU1rc3FaY1JMS2d5?=
 =?utf-8?Q?+orX+LWzelS32Q762At0ScI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C12D294BDC0B06499CAADF215AB0FB4C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97234d1a-3f1d-4262-868c-08dc95560d72
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 20:33:20.4959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: My6Qbslb6r0AqKNyRed9MkwKrVXHcIlHD6ILX3eIk0Bk1FGxXII/nYsxyiU7XPaXAZ1AmBubF0kk0u8wjv2Z+NPozpLsZ0pyK+gGjTuhBm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4960
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTI1IGF0IDEzOjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiA+
ID4gSSB3YXMgb3JpZ2luYWxseSBzdXNwaWNpb3VzIG9mIHRoZSBhc3ltbWV0cnkgb2YgdGhlIHRl
YXIgZG93biBvZiBtaXJyb3INCj4gPiA+ID4gYW5kDQo+ID4gPiA+IGRpcmVjdCByb290cyB2cyB0
aGUgYWxsb2NhdGlvbi4gRG8geW91IHNlZSBhIGNvbmNyZXRlIHByb2JsZW0sIG9yIGp1c3QNCj4g
PiA+ID4gYWR2b2NhdGluZyBmb3Igc2FmZXR5Pw0KPiA+IElNTyBpdCdzIGEgY29uY3JldGUgcHJv
YmxlbSwgdGhvdWdoIHJhcmUgdXAgdG8gbm93LiBlLmcuDQo+ID4gDQo+ID4gQWZ0ZXIgcmVwZWF0
ZWRseSBob3QtcGx1Z3BpbmcgYW5kIGhvdC11bnBsdWdwaW5nIG1lbW9yeSwgd2hpY2ggaW5jcmVh
c2VzDQo+ID4gbWVtc2xvdHMgZ2VuZXJhdGlvbiwga3ZtX21tdV96YXBfYWxsX2Zhc3QoKSB3aWxs
IGJlIGNhbGxlZCB0byBpbnZhbGlkYXRlID4NCj4gPiBkaXJlY3QNCj4gPiByb290cyB3aGVuIHRo
ZSBtZW1zbG90cyBnZW5lcmF0aW9uIHdyYXBzIGFyb3VuZC4NCg0KSG1tLCB5ZXMuIEknbSBub3Qg
c3VyZSBhYm91dCBwdXR0aW5nIHRoZSBjaGVjayB0aGVyZSB0aG91Z2guIEl0IGFkZHMgZXZlbiBt
b3JlDQpjb25mdXNpb24gdG8gdGhlIGxpZmVjeWNsZS4NCiAtIG1pcnJvcl9yb290X2hwYSAhPSBJ
TlZBTElEX1BBR0UgY2hlY2sgaW4gYSBkaWZmZXJlbnQgcGxhY2VkIHRoYW4NCiAgIHJvb3QuaHBh
ICE9wqBJTlZBTElEX1BBR0UgY2hlY2suDQogLSB0aGV5IGdldCBhbGxvY2F0ZWQgaW4gdGhlIHNh
bWUgcGxhY2UNCiAtIHRoZXkgYXJlIHRvcm4gZG93biBpbiB0aGUgZGlmZmVyZW50IHBsYWNlcy4N
Cg0KQ2FuIHlvdSB0aGluayBvZiBjbGVhcmVyIGZpeCBmb3IgaXQuIE1heWJlIHdlIGNhbiBqdXN0
IG1vdmUgdGhlIG1pcnJvciByb290DQphbGxvY2F0aW9uIHN1Y2ggdGhhdCBpdCdzIG5vdCBzdWJq
ZWN0ZWQgdG8gdGhlIHJlbG9hZCBwYXRoPyBMaWtlIHNvbWV0aGluZyB0aGF0DQptYXRjaGVzIHRo
ZSB0ZWFyIGRvd24gaW4ga3ZtX21tdV9kZXN0cm95KCk/DQo=

