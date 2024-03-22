Return-Path: <kvm+bounces-12532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA8B887599
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B77381C22E71
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703358289B;
	Fri, 22 Mar 2024 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vh2fvYAO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4877FBB1;
	Fri, 22 Mar 2024 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711148748; cv=fail; b=MmrOSv2qvGE0MjzrPIzNRq6fDIhu1d07gmgMvIve9vOLwniyXB7UTDOCwB3auMEF1nU9LVRUes/Lt5sa6rAEa1imXz1nhidq+ylX6o/wiEOaS4M9keKHa0lnZth/M3A3suO+47DOgfqLXfJa18djG1hV1h24AyYeaS0DcX+wYAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711148748; c=relaxed/simple;
	bh=iLxSc+HvO4QxUynmQMDstp1NqnvnbRLcuZIz2BXfcuk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HtsoXaNZ202v9gONVdvOvYQvdq1YNNoDdKnNAaM6IsjGmscpHhtNcyRV8T+/9vzpsWifPdatKCcZlDE1zI8nqZrTQ8cRvDTR4o2W9zKr/aV+hRxHZ+IpxbOMWczjTTS7V9KVQkhgtVmH/KMwr350TB/9JfbdPBFrTz8QwbG7gLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vh2fvYAO; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711148747; x=1742684747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iLxSc+HvO4QxUynmQMDstp1NqnvnbRLcuZIz2BXfcuk=;
  b=Vh2fvYAOdSPsQ9ounq7iTwlz1Y+kEl0avWoTgYSzmH0YizCQyowz8IPp
   xaSVNyl0194H/PHguhIlOQ/rEFnmebX4bL22ybrceGQLenyBPrOQjE3jC
   Dpu4UrKihAHRhbjHHHd5WyW7AETyWPA3RwSe9j6Ynqne2PwfRJdtk43g2
   JmsZhvfl79h8CAJx+DRAj6NkwjQRcG0GKD7RHYQrUVZmr4AOrM+JVPtVk
   TM1eNWtXMRcG/edE0HC9wWxVN1xYFhhFQxteMAi0HzjM1v2b148JairrG
   fZ5J1EnZXzMbx1YG+pc+1bWJU88X17SVtjdQ38hiPjnl5T2CCyLnMby1P
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="9989052"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="9989052"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:05:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="52495513"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 16:05:45 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 16:05:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 16:05:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 16:05:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4I3qO8nje6aFga/PkSZdWVWSvJpZ1UYnpjEo5G9ZvFF5A5bv7sAx2prfyntd4yztA8TDf6Rw7Ikuj7hs9xAihzUjFMCBI9vF/zELB0BVJG1MUwabjC7UMHGuwlSJSOa5YfEEMadpGwynEaE1bwQEu7OUH8Td37Ih2wGs9DszlpjTDEYx/QKD9/leewnkTosfEieThm+jIrc06yS0dr29mcSiIhmv3VVF1+Q1bN1hIFUMA8ECl8J63/tzo4YFOv86P4YS9JjGaeDOKQtGmeaUWHAlC/+1sP7niRjgXUSFukWvgAOWf4XOKP3qwl0P73KBz5IViZdmZQKtTOm5JJ4TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLxSc+HvO4QxUynmQMDstp1NqnvnbRLcuZIz2BXfcuk=;
 b=GHzHA9hv85FTPVi7TnjK/DTjCuS0D+KGyijJPBdPK978ckz4oiBDzjTnui42rz/9GLxFMOVPrWzNZFkDQmpqCOSnLkV2pe4As35a4ffi/Q4lUarEJN9bcvYOr7OQn1n0vmi7xbCborLa3EM8pZq/OH0EcsRTzOAh385rqF19K9Fx/iMAeub/YcNF3Gju/VPetY2UO3wddtQoTTN9VTISMZyNHFYmMM3VpJPUYnPAe7/cnnhLjwkXSBRZhOjV2Rx+ELR2EcD0TXEkZ/V3jwiRIZ2V0UjXSeOAEbWj+kRn8YQTzm2ktl91KADOXn6SJEl3qU0RG1F6vVMsZwCpkrXe+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8584.namprd11.prod.outlook.com (2603:10b6:408:1f0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Fri, 22 Mar
 2024 23:05:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.023; Fri, 22 Mar 2024
 23:05:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Topic: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Index: AQHadmyiHbz3BdiqjUa/DQsd0Q/1DbE4BTCAgADQlACABOw/AIAACLoAgABdJgCABkPtAIAAAkEA
Date: Fri, 22 Mar 2024 23:05:41 +0000
Message-ID: <ea2cb7478b7263b1ee71be148b9e7fc865107086.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
	 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
	 <20240315013511.GF1258280@ls.amr.corp.intel.com>
	 <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>
	 <20240318171218.GA1645738@ls.amr.corp.intel.com>
	 <6986b1ddf25f064d3609793979ca315567d7e875.camel@intel.com>
	 <20240318231656.GC1645738@ls.amr.corp.intel.com>
	 <20240322225736.GC1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240322225736.GC1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV8PR11MB8584:EE_
x-ms-office365-filtering-correlation-id: c9ec882c-49f3-4177-e879-08dc4ac49884
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zLPLDX6n98FTXZXv4NHl5zVrnY2Im7NfaGRC+42ct31Yw9ImsrZinYdMaEsld3eBxqR1HmEQ+gEcHM7WKYHiA/TAdf4JfOc5pukOsEY/AjxUQyg6KxbuhDJmkOlvntpFxZNkdYzrczfh67qtuqJY22jvMzmxkX7XGsx7jIhMQL1cZDvQ5P5AHiCe8/ZAjIOJ9DCkriOS40G9SVOGvdP3LXSindNgKzD6yUoNkpT362MwkOXG8EmwJUGtLDLYtLShtjplTbFoPQQ2GUtbXgfp7qJDp/X5HX+62kDNc0///ceNiFX4vrudfkoyQPRpWiC2pj3QH0WR1esLP0vfNMWldnP/TpSfJRvACnWbwfx+u3FcktQshO2F3s484eSCCxbiV7QRLz0atr2BfCV+9tp92nE0inEZGzXLw0kuEZf5EZuO99UEYGaEKAQPrqIzOpMUmACuWrdn0WE1QBprgYSKL0fTze6WaFhqHl3ER0UAvWOg427vGrsnbjhCwySmZWNS82A45uvaeQF51pMoCBHEbL28HSM++37P2OBUIoaG4GajxBjLXd645JU867uNc9DTvmtlR3lpBlm/oRUSxKXRlZ328HYYPt2r1kBvLGuiivDZal8eHGkqDGGzv+EQGNXFqnY3ojWDvvBVGvY+oO4tmbzufqMMpYuPR1r0xzx9VZ1g0zMvxnlII/YGa9pnuFoSCCTwJNZkYXFQrnbLOUDE7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGErWHFGZlhSNFBTTXIzYklDdFB2a3hJeUxmZVRVRXJMSzRCK1NvTFBsaXlX?=
 =?utf-8?B?YVMramJpNVR1T05CbXl3ZWR2V3VnelpxSnh6aktvQmJRSTlEUjNXOXNkMXp6?=
 =?utf-8?B?aitody9ORm1WaThxNFRwWHpXelZsZXNkQXJUY2IvemVreWsyT2JNUitPNmxO?=
 =?utf-8?B?dXJoeUFjWmdPaHJZbTZHNU1RS1E4c3EyeTVHMEl0azVlWGZEUWNBenlLZ0Rm?=
 =?utf-8?B?L3JmTnNaS3FsQTFtbkQrU0EzK0RsN1hOQlM1MnFNemRYSExtNVhEZGw2MFJn?=
 =?utf-8?B?bFJxNm9qMWNZMU5saFBVbjUzMkdYcFpBNEpKVmxNSGVYbXdYQTRvN0xuRFRE?=
 =?utf-8?B?VnJPaUpjSDJKakV3SnJRcUxvQzF2U1orRWNPQ1MybVRReFdCZHkweXV1NGhY?=
 =?utf-8?B?N0x5YWJib0VPZms1Nlc0SGhRU0tUMFFwRWNqWjhpek9sTUY0Nm12bUFlSDlR?=
 =?utf-8?B?M2tEeFRBK213bzA4dzllRjFiME05NCtKeUZ2bTRKaVdKenkyYlhxTVpSR2NQ?=
 =?utf-8?B?T0pudHp3b2tkZDI5SDZxZEhEWGpIam5SNHhMMHNPK3p5TElOK1F1WEVJWnFp?=
 =?utf-8?B?UEM4YTQrcHRlODBYNVA4SERjYkdXakF0cEJBVVFUSDdHY0M0YUhZY1BPNE4v?=
 =?utf-8?B?Y0EwNHhEcEtOOUFMelZnc2RUZ3Q1TWkyczNxVUFxb3NCV2pTc2FkM3REMmVk?=
 =?utf-8?B?WVBRVXdmUEpCSHZZeUg0bzl4OU9FUThtZTNkeWQyV0dsNVJzUHJqUitHb2gy?=
 =?utf-8?B?VWVmOEZtSWQrWk5Ba1RMNHY3MjBvSC9zeVJMY1lKb2pNOEUycTFxMEE0MG9l?=
 =?utf-8?B?OElzR3BRV1kyWUhKT2JJSVcyVUEzOXI5eVAzT2piaE9tTFJnbXlkRTBTNWNB?=
 =?utf-8?B?MmIxcmcrdGRUSzNtWGx1eG50YzRiTWFqbnVnMmt5eDBtZUthUTB6UXkvRFJi?=
 =?utf-8?B?TEJ3bHJUTGN0VmtHSEc0OTM4TVdRWTMrZnp0SkVWd2dFTXJ0MVM0T1JBK2RU?=
 =?utf-8?B?QWZTN0hBaWhLQzduWGRESmZsRkY4S2kvSUFkNExGTXd3K2w5b0FlenJHaWpF?=
 =?utf-8?B?aE16Ly9LVHRyWWYzYjJNMWpIREhTWlZndWtHZDF4bGt4bHlacGtHUEMzZUhj?=
 =?utf-8?B?R0c2VXZwZGRpaXI4UjhCaFIvOEo2Rk1pbzVJRWFkOXR6cW14bmU1N1VzUVRS?=
 =?utf-8?B?aTJGM0U0RjU0VEhweFlWSllXWGNzUnRjRnowYUtWb1hKbVBCZ2taOE1HeHlS?=
 =?utf-8?B?TFhROEovSVRDV1BTcHZReERlU0tIYmxnaUxZQzlGZmlkeVRXdURwYmQ4M0Q2?=
 =?utf-8?B?NGs2cUZqSVB4VUdPUi9ZUXVxUzJiYUlWaFB4SGw2SitqT1U0RHhmV3Q2bWg4?=
 =?utf-8?B?Z0RTOWlic0RaejVJVG83K0xacHM0VGRqYzlJbGlRcldkUG5PZW0wOTNnZy9D?=
 =?utf-8?B?ay9CNUFsMytzNkJXSDBZZERYNXNYTWtsN045dkVjbmVCckg1enBYbHNZVmNu?=
 =?utf-8?B?bTlnKy9JRkEyeXAyK2tqZHdHZG0xZURkQ2Q2SU9HM05LcGF5ZlE1VUpnaW0x?=
 =?utf-8?B?OVJzV2RKT1BzNHp4Tyt6UDBuMkd1N0UxM3h1OEppV3h4eS8zUHY5Ly83Nk4w?=
 =?utf-8?B?Ri9TTDNaaTFsdnpPYzFWVDlkeVpNTnNlK0h1RG9ONzNpa1laRkpSeWhZK3N0?=
 =?utf-8?B?algyc0xqSnJ0b1BjREJIWHpmaFVmN1lYMUJtNWNQZGRRb1AvVUN1N0I5aHB4?=
 =?utf-8?B?NHY0WXUvK25KcUdqb1BweHB1SkVJblhGWGh6MDA1NklMTy9EYTZwdHNjd3dE?=
 =?utf-8?B?TTZvbmJrVkJiblh1TU9IdDYzQm11OHNDWm10ejJIcXJka0xmOTB1S1VrV1lD?=
 =?utf-8?B?RDFPS1RtdVJqRW4vSkRoNlJMUGxRbC9TNTA1WHcyNE5mYjRub0xwc3ArREcz?=
 =?utf-8?B?NkRiV2ZkQ05WR3dNUGV0RzQzMDI5R0FqQ0hxTFZwYVI2clMxbk1SUE1JTlB4?=
 =?utf-8?B?VWQrQU1udmo3ZGYwckY5QlJFZmQwYjNydW1Uc2ZBWGdTNURHdGNrZW5oWkx6?=
 =?utf-8?B?YnhWMUp2TnBsTktJUEVXSXVzZ1lNK0kwMXp3Q0p6NkJsOGxqQjI5SENTd2Rz?=
 =?utf-8?B?VmVLZW9TVHZUOFRzOVV5R05SOVg2ZUE0TEFlaUtEUHJVajZtVkNmRlRhek94?=
 =?utf-8?Q?yv74aNcKfFJcvdDH1VDYxlk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81737660FD196D48BC53BD6BE825069A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ec882c-49f3-4177-e879-08dc4ac49884
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 23:05:41.2260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r12NcX0D6FWzSUzj8dKJU8uz/M5EQ+jQUOyDoFR2V14HeXkawMeIXPuDwNwpBYC0yQ/OwvMbKIncj5JvfjOLC8JTdYyyfDPIeMnw18ACxsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8584
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDE1OjU3IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBLVk0gZmF1bHQgaGFuZGxlciwga3ZtX21tdV9wYWdlX2ZhdWx0KCksIGlzIHRoZSBjYWxs
ZXIgaW50byB0aGUNCj4gPiBlbXVsYXRpb24sDQo+ID4gSXQgc2hvdWxkIHNraXAgdGhlIGVtdWxh
dGlvbi4NCj4gPiANCj4gPiBBcyB0aGUgc2Vjb25kIGd1YXJkLCB4ODZfZW11bGF0ZV9pbnN0cnVj
dGlvbigpLCBjYWxscw0KPiA+IGNoZWNrX2VtdWxhdGVfaW5zdHJ1Y3Rpb24oKSBjYWxsYmFjayB0
byBjaGVjayBpZiB0aGUgZW11bGF0aW9uDQo+ID4gY2FuL3Nob3VsZCBiZQ0KPiA+IGRvbmUuwqAg
VERYIGNhbGxiYWNrIGNhbiByZXR1cm4gaXQgYXMgWDg2RU1VTF9VTkhBTkRMRUFCTEUuwqAgVGhl
biwNCj4gPiB0aGUgZmxvdyBnb2VzDQo+ID4gdG8gdXNlciBzcGFjZSBhcyBlcnJvci7CoCBJJ2xs
IHVwZGF0ZSB0aGUNCj4gPiB2dF9jaGVja19lbXVsYXRlX2luc3RydWN0aW9uKCkuDQo+IA0KPiBP
b3BzLiBJdCB3YXMgd3JvbmcuIEl0IHNob3VsZCBiZSBYODZFTVVMX1JFVFJZX0lOU1RSLsKgIFJF
VFJZX0lOU1RSDQo+IG1lYW5zLCBsZXQNCj4gdmNwdSBleGVjdXRlIHRoZSBpbnRydXNpb24gYWdh
aW4sIFVOSEFORExFQUJMRSBtZWFucywgZW11bGF0b3IgY2FuJ3QNCj4gZW11bGF0ZSwNCj4gaW5q
ZWN0IGV4Y2VwdGlvbiBvciBnaXZlIHVwIHdpdGggS1ZNX0VYSVRfSU5URVJOQUxfRVJST1IuDQo+
IA0KPiBGb3IgVERYLCB3ZSdkIGxpa2UgdG8gaW5qZWN0ICNWRSB0byB0aGUgZ3Vlc3Qgc28gdGhh
dCB0aGUgZ3Vlc3QgI1ZFDQo+IGhhbmRsZXINCj4gY2FuIGlzc3VlIFRERy5WUC5WTUNBTEw8TU1J
Tz4uwqAgVGhlIGRlZmF1bHQgbm9uLXByZXNlbnQgc2VwdCB2YWx1ZQ0KPiBoYXMNCj4gI1ZFIHN1
cHByZXNzIGJpdCBzZXQuwqAgQXMgZmlyc3Qgc3RlcCwgRVBUIHZpb2xhdGlvbiBvY2N1cnMuIHRo
ZW4gS1ZNDQo+IHNldHMNCj4gdXAgbW1pb19zcHRlIHdpdGggI1ZFIHN1cHByZXNzIGJpdCBjbGVh
cmVkLiBUaGVuIFg4NkVNVUxfUkVUUllfSU5TVFINCj4gdGVsbHMNCj4ga3ZtIHRvIHJlc3VtZSB2
Y3B1IHRvIGluamVjdCAjVkUuDQoNCkFoLCBzbyBpbiBhIG5vcm1hbCBWTSBpdCB3b3VsZDoNCiAt
IGdldCBlcHQgdmlvbGF0aW9uIGZvciBubyBtZW1zbG90DQogLSBzZXR1cCBNTUlPIFBURSBmb3Ig
bGF0ZXINCiAtIGdvIGFoZWFkIGFuZCBoZWFkIHRvIHRoZSBlbXVsYXRvciBhbnl3YXkgaW5zdGVh
ZCBvZiB3YWl0aW5nIHRvDQpyZWZhdWx0DQoNCkluIFREWCwgaXQgY291bGQgc2tpcCB0aGUgbGFz
dCBzdGVwIGFuZCBoZWFkIHJpZ2h0IHRvIHRoZSBndWVzdCwgYnV0DQppbnN0ZWFkIGlmIGhlYWRz
IHRvIHRoZSBlbXVsYXRvciBhbmQgZ2V0cyB0b2xkIHRvIHJldHJ5IHRoZXJlLiBJdCdzIGENCmdv
b2Qgc29sdXRpb24gaW4gdGhhdCB0aGVyZSBpcyBhbHJlYWR5IGFuIHdheSB0byBjbGVhbmx5IGlu
c2VydCBsb2dpYw0KYXQgY2hlY2tfZW11bGF0ZV9pbnN0cnVjdGlvbigpLiBPdGhlcndpc2Ugd2Ug
d291bGQgbmVlZCB0byBhZGQgYW5vdGhlcg0KY2hlY2sgc29tZXdoZXJlIHRvIGtub3cgaW4gVERY
IHRvIGNvbnNpZGVyIHRoZSBmYXVsdCByZXNvbHZlZC7CoA0KDQpJIHdhcyBpbml0aWFsbHkgdGhp
bmtpbmcgaWYgaXQgZ2V0cyBhbnl3aGVyZSBuZWFyIHRoZSBlbXVsYXRvciB0aGluZ3MNCmhhdmUg
Z29uZSB3cm9uZyBhbmQgd2UgYXJlIG1pc3Npbmcgc29tZXRoaW5nLiBUaGUgZG93bnNpZGUgaXMg
dGhhdCB3ZQ0KY2FuJ3QgZmluZCB0aG9zZSBpc3N1ZXMuIElmIHNvbWV0aGluZyB0cmllcyB0byB1
c2UgdGhlIGVtdWxhdG9yIGl0IHdpbGwNCmp1c3QgZmF1bHQgaW4gYSBsb29wIGluc3RlYWQgb2Yg
ZXhpdGluZyB0byB1c2Vyc3BhY2Ugb3IgYnVnZ2luZyB0aGUgVk0uDQpIbW0uDQo=

