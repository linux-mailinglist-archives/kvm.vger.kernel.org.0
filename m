Return-Path: <kvm+bounces-50873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC002AEA5BF
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0853A17EE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7C02EE999;
	Thu, 26 Jun 2025 18:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="elo/ZS90"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8917B13D8A3;
	Thu, 26 Jun 2025 18:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750963778; cv=fail; b=hrGBHVpRxoRHP7mXsu/rDaK70DcDK1ZMEsJKWPQ2xM4bltPIF1RfCGWWls9WQH1aMJUwGWLKzoNaUk2++C8bLZcntD8woorx8o8tdF490XquRzaZXVTNFFFyF9EW+AvPsdREFPCFzq6c/kRuHzHiLzztXaLukP+ltekd/3Zjuwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750963778; c=relaxed/simple;
	bh=+boqu5tdl038xUM8J1AJm2RInr15+H0EghOEzfF9LDQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pub5s9QnfNkFzOy1Og4dWtyAJTr24XBICloNYwfLwUCZOea4UVFyvDC4URJmeiAub7ATFExvMJP6xw83Xk1Vol7tnkv82VtLRodtLdlQvJfKUZ7VfFBdB2twgUelsorsNV1Tua2YAsPMtaHOthW+s4SCbDENwOdniHMxl3pUpS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=elo/ZS90; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750963777; x=1782499777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+boqu5tdl038xUM8J1AJm2RInr15+H0EghOEzfF9LDQ=;
  b=elo/ZS90X2Jt1joODvw4fXBZTzj/gZGdNt+ac0dpELOJaP3LsnBGY+LZ
   664eXNflv0D+Vld3duyrr7tnJjvd1hxptMhwUIl9yM+JpzcCAKmxRSZw5
   5w8Oq1KBXSkhAVGXxRgSx1oeV0cNNEZDmk+P8fJrJGis6emSbizPEMQZc
   b+Lh21I1C0nCa0k8Go+0GS7cY+NKa6DhM0Zp+9TRTVNk6jxMZUpmKEYav
   juZ9pItqRuZ3rfIR8dUFGIaQT1BFOzBzASjd6moP+jDtmGm5WFQGCZn31
   glNfUDMJ1Dw2t6eOxj3qgbuyvAT0Wed7wqnpkiKLO3ZCHxAUrO0jqDaaH
   g==;
X-CSE-ConnectionGUID: lF1adoMRQiSKmzocjbbblA==
X-CSE-MsgGUID: G2+9/JRbRH+mhYKhXBmX5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="70703425"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="70703425"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:49:36 -0700
X-CSE-ConnectionGUID: uZG9dvniRIGVbPH4TgdGqQ==
X-CSE-MsgGUID: c7WGNpl+TzCtB4XyMNCUBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="156623686"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:49:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:49:34 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 11:49:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.88)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:49:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pqcWUnENXnoR4H1QyDqIY84gl07y2TOnE8V/gZvC1ZJtGS1HLhMR+BDgicckkmJQA2zmPE24Veup+qKnHAL4KWnAzdvOdnPydo9jyX35tzL1deRNlGHfSiKOIKnTgNjVsvwnZsf6fTZY+sqouZx77wrrFnM2wtRVA2lUypuJwG6kRX19SvoFgPvZO/Z/SKedJ/Eg2i1Dp5ywFpzGaXTUI9xx1LI9wFlBmqyjwOredUd8+XSmWUQDCJQdwyfBnYVyvayUioy38Ie22Lk1ULw10SE5a9R3t/ZnSgo8pXRJ471dazec+XpYMfkO3Y6iOpKOexvcd/hAcu+Fz6ZMHVPsVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+boqu5tdl038xUM8J1AJm2RInr15+H0EghOEzfF9LDQ=;
 b=Z7BDHiJ2Eo39m7tfl1bEZM+SAABHOMutcgycVOKQ5BShvJGQzeJ1zkDkXjQyfYiMHGvA5U7IBpyvEuIWBV8IrXE24+cptEhcXGzpcMvQ9WDGS4SImf3xkvHc/Z4qMHqj59owbKrXhd/UwY8bU70DG0qzps+1Z4iPFsnp6mt4qxUF8DWulU1/Q2NOXr6N+3WRS+mIdrvIPAGEqLfb+9puU1dgEM+MZ3/M9Xq8hWfsHNBrIOtLm9zluGuEXhN2igHG5NvdOoDcUcUjOAheYaP5rprvJE4X2fOWpS6ISCPiJh8X9bqPlMcxlckpLx09Rs1GQDgMMycA3Q9l8/LQR3aohQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB8937.namprd11.prod.outlook.com (2603:10b6:208:57c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Thu, 26 Jun
 2025 18:49:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 18:49:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Topic: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Index: AQHb5ogJzQk8ztTCzkmIvpX60YI237QVyQQA
Date: Thu, 26 Jun 2025 18:49:27 +0000
Message-ID: <46b79a986eaaac6e413db2d6e7826c769f9dba6c.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
In-Reply-To: <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB8937:EE_
x-ms-office365-filtering-correlation-id: b1d7be93-6875-4830-6e30-08ddb4e22d3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bVFaTk1qWmxNTnJ6NFJNQVFsUVFyTkdFQmExSy9rWlBSS2dEMEErZnFLNU1a?=
 =?utf-8?B?NWV2ejJuUkw3emRVS1JKbHU4dHdDc20wZFNFQkM0a1lOWFgxcVVOS2FOTEJY?=
 =?utf-8?B?WW9EUEI3RDFIWG5iVFZtTUVGTkdzUlMyd294YXQrcVNBNjhsMTBFTzYzRTlD?=
 =?utf-8?B?dFphOW1XZStodXA0cTFBZE5NcGtFUmZwZXpYL3FvU2x3NmNPSXB3Tm5XZlBJ?=
 =?utf-8?B?OGhpYnlVeGZLajZ0Um1jdmhoS3V4NlA3d2dvdFJScityeGVCTVJiTklONTJV?=
 =?utf-8?B?SnRFdlZ1SFp6SmNYVUlEdkxpdU05Yi9rS0JlcTRGczRVdS9ZSjFvRXNCaWZL?=
 =?utf-8?B?eVhuc2VyY0FEeUlJeEtlZG9ZNGdkUVJaQkkwV0ovaWVZZUt6UUVXVjgvKzNx?=
 =?utf-8?B?aGNxVXVvbEYvekptL3pKaGl2cHg3ajBrUW5sM0FNM2RGRXNEZitITWt0U2FL?=
 =?utf-8?B?dFh5LzB1NmxEdVU4QVBtU2lnb2wzcyt6cXpnZUNqK3NlZWRSUGV3SW10WW03?=
 =?utf-8?B?MGxQbnFON1p5OGVBcXRTalRNTENibEswR2hCYW5qK0o0eVlXajBhdFZhcXJP?=
 =?utf-8?B?Y1FwNTg3UldHRmxFanMvT3d6MExLUlB1OHFGUHczUE5xZlptZVgwWGMrRVBv?=
 =?utf-8?B?aFNOdWhQbmlzYXZFejAvMlZyTkpjMlhDT0FSUVFDYU5CRE44dXNkaDRKL3lS?=
 =?utf-8?B?ZjA5Z05ZejhpMkFPcTR3TCs0OCs1dFgraU5ST2tOYVc4Ym5wN3FPOGdBeURT?=
 =?utf-8?B?MHVzSEwxUzNzL1IzOXlTVmMwZkM3T1NTYVQveXlXMlB5SGoreE03SThadkxK?=
 =?utf-8?B?QUlJVXdGUENsWnBLQ096VkFicHo0TjB2OThTUkxGRk85N0FCUXNkM3I4cEpF?=
 =?utf-8?B?eWlZTGhPT2FIVm1YdSt6L2RwWTFpMTYzbEZ0MFY2c2ZrNzZRNlNGb1lmL3Zs?=
 =?utf-8?B?b0I3c25zZitWY05LWXFQWEZyTStTVEhOcWpGYk8xK0dNbXlYV3J1RTVaTStL?=
 =?utf-8?B?MnhRUmZtQk1LWnBIZVFycHoybVZFOXpFMFhEdmhwR3FSSFAzUlhlQlYvV1FV?=
 =?utf-8?B?aW9qQlhGcFIyeFNQTHZ3NDQ5NEh6YXVTVnRuVCtOM2ZGaHEyS2dPTWE2cVdZ?=
 =?utf-8?B?R0c1TVRncGozbGdNNXZGR0JQTCtwUkRJM0o5NEdWMi8rWWdQRkRGUTcrNXF5?=
 =?utf-8?B?RXF4VmpkQ3BBQnNPNnhPaEZDdm9wa2pyM3JrdHorVHR5V2l4WFVxS3NDWldC?=
 =?utf-8?B?TGJZMFZpdVc1bXlCdjJuVjM5TVR1eEJ2ZU1ZYjQ5MThuSGh5SUI2TUVIYXAy?=
 =?utf-8?B?Y1Bkdml4WmNxVmxZNW55YUdEV3ZSQ1c2cXdMTGJHY1JTWEVyK2NuelFuT2hl?=
 =?utf-8?B?T3FrZldvazk1SXlHSzBBREQ1UW9IMUl4UllON0ZkeTNsSlZmSm1hbjFSZmhE?=
 =?utf-8?B?b0xuRm5yR0R3Wkp0T0FQZGlYc0tabFpYUC9FMWNWVGFONDd4RnRUZW5rRi9t?=
 =?utf-8?B?aUJPMnR5WmFFblhYa1dWaXZxeFVXS1ZVaXdHdFlFTHpOWmlRNE5DcjVXdkEz?=
 =?utf-8?B?elhuaGc5cjIzaW1BNjVzVFRxL0Z1SDFIcVpUWmFyRDNHYUY3ektPNnVmZnRI?=
 =?utf-8?B?eEFWYWIzRVlGcDFHOG9aZ0tFMEpQaTRKK0RZYzkyUnRGWXpNR3E1N05rRW4v?=
 =?utf-8?B?bUdVVDNCVlVQQ3UyNzhGemZ1RDYreFJGejdjUHFmc2g1V2p3ZVFvc21SZlZG?=
 =?utf-8?B?UEwzaXByTnZ5RGRhS1hhaU51bHhuQzFnYnNXU1VLSFd4MnVrQldUdnVEQXNC?=
 =?utf-8?B?aFhDdk1xc2lhc1p2NXk5clRjU0loVzh5UkowRkVHSGVvM2p2R2NrMXdaYXVO?=
 =?utf-8?B?V1Y5RkpWY2J4cDBONFhqNnR1WUxGNnArY2tycW51WG9qd0N4RDdBbjB1RHBH?=
 =?utf-8?B?MXkvQzN3RlduZFhoNmdZQ1hiWU1GZHVKU0ZZenRHblZiYmRPNXZINXpBdlgw?=
 =?utf-8?Q?uikrSOGMaYBtmm1rAG7yUqJxDh2ztk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VCtVOGVEZVlDaFFaRmpMWjRkdE9ueTcwRnVWcW8rd3NQR2k2TWZnZE9iemlC?=
 =?utf-8?B?WHlzaFFWSUk5UDVPOGlnblhLN2pJNTVDakdHLzZ3Tm9IUEFkTm9rcUxTN0NC?=
 =?utf-8?B?YnZOblRoc3d3bXVSdi9EeDhEWkhSaUFVNkJIVW9qUEJYNVFFNEZjWDk3bFJn?=
 =?utf-8?B?cnBuS0FRakhSQkxsWnBMMkNIbjZxeTR1VWFacnAvUVkwdHYyTTRVL3paNHV4?=
 =?utf-8?B?eWpEc2tJbzAzMVVYSng1dEZGYzl3eFBXTkF5elpuWkpSa0pRclhsVDdKeDZD?=
 =?utf-8?B?cld4V0NTbUNaWEJUdTltNk5kR2Mwd2JhdHRkejd6NTBtcnA2OWdmVXlZVUxK?=
 =?utf-8?B?dTl0bHJXOGZWd3I0dDlFMnkyRHYwMUx0dmFRMEhCMHVqVms1R0hHMUtLTm9W?=
 =?utf-8?B?WUdHOU4wZTZuc2VUblIrVUxENVhpbncvWEFCbVpyU3I1TnZlVS90aGFpY1RW?=
 =?utf-8?B?TFA2a1piSkxEUGNBcEU2dWlWT2xzdzVOYVpZdWt5dmVIM1hkSjlGbWREc0JY?=
 =?utf-8?B?WWRRT0VaM01iU28zZ2NVQnZUeTRvRGxmSUYwcG5aenpTYVY5T0pPeFdWTjQ3?=
 =?utf-8?B?Tjh2WTVyVXhNdUR2UXJDVWtPZkRRam9nVjhSVnZVZS9qNm0vUmp5WEJHaldG?=
 =?utf-8?B?aEErcWNKTFRvZXYwNUlrVHNKSytyYnBtMFRpQ1poVGo5Z1JGNGx2V1ZZbUps?=
 =?utf-8?B?cEdnSWR4RmllcmNrUi92RGtTK1orNGhJR1g5bCtkZXpHSHlpQjRVSUhwT1o1?=
 =?utf-8?B?Zm9YSnV4VWJ6RmhUY1g1SGJGUVkwbXhMRTFVRjNUQjBMb0tyU2NoVjdMcEpX?=
 =?utf-8?B?RnNYT3N3VXlrbnF4Y2JJK2paZFdxamNkN24vc2tkdmczaGtKMUlMd21JOVIv?=
 =?utf-8?B?SEZvc2ppZFZOekFFRjFzOWhCSWd6VjZwM1lOTXYwbldYUlhxOHpwUjJ1R0dQ?=
 =?utf-8?B?QmhCTFFBc05RZlNZb242Q05pSHBWUWVmbTNHU1c0TVdhMnlSeU9vQUQ1b2Rk?=
 =?utf-8?B?alhrSzFaNHRjem5WWTJsMXhuNnNocS9sWjZpVFhPVXFTMi81c1hiT3VoaXFy?=
 =?utf-8?B?cThwNGlNQUdGUXRISG5JZGN2bXd5bmRnVnRVRjhUemw3cGIxOVd0cFNFb0FS?=
 =?utf-8?B?WDduYzBjMjRyZGZyM0VsbUlHVVdyM2pVMjBiNkRqd2JYVE9hUG9HTFR3UGpu?=
 =?utf-8?B?aXI3Ri8zL0MrWlJpVndxQ0ZKMWtEMkQ0VXFaQUtkalJDeFduNWVFUkFkNHUv?=
 =?utf-8?B?SG80UUhJK0crRU1qeHM4YXNzNnZSUjFLTzY4VGtveEhjaUtEZnhLSGhpZWdX?=
 =?utf-8?B?MnV2Mk1Pb1FIVWlXQ1NTaXhhSGtmSHNJUWJyOVd5T24wMU41WVlldnhCemhY?=
 =?utf-8?B?REdLc21JT0piTEs2R1pBQmhUZThIdkZNc05QVlJ2aXU0dUpXMzRxa2VLbzFZ?=
 =?utf-8?B?L09qa08yUzJpZmFqM1ZxeTlwQUNIV1hrWFRoSzcrVW9hUEdNbnNFOXV6Vnpl?=
 =?utf-8?B?c0xpV1lDeE40M3hBSE45RGRnMlVqSWM2ZnJHRGxYVXJIZ2JDNzdaWlFWU2or?=
 =?utf-8?B?Z0J2ZVJ6c2VDWDA3WmNOZ3k2WXlsVE5LZFFSTlBtUVBEcEZ1YllHd1NLa0Nt?=
 =?utf-8?B?VHQrdUdua1FIU3c1V2RwRUNRUzkwS2RBd3JPNU16YVRBa0VsU1Jsb3dHV1F2?=
 =?utf-8?B?K0lqWjdkMjI0Tk9la0xhU0JtODhiRFJxekt5bXAwTEYrcDUzYWlERlR0djh6?=
 =?utf-8?B?QS9RSFJhT2xod25McXQvaUVXaEVZYU5oNGIzMmVZdnQzbFQ3enYrL3ErMlU1?=
 =?utf-8?B?WVRVNG1aRk9BZDRNZzBVeHRJWkZxUTk0QzNhbUU4M1p6NUw4STlEZlNJUXVm?=
 =?utf-8?B?OEV5a0NETmxoZ2VacDVtWlpZK0EwRDNvZEFwc0dtRWtDd3dNRmwwUXFQR3hv?=
 =?utf-8?B?azNHTVlWeTE0RWhNOWNNdmlYMTBZc2VTbEM2aUdiMDVFT09pbzJkcFRhRnlT?=
 =?utf-8?B?QWlKUVhUQ3lMbmFRSU1HVldoNWFCSUlvajNIVWJGNFFXcnEvd3F2a3NpazJC?=
 =?utf-8?B?dGJhOWpyMWZIR2xKOVBWNE9hdGdTem5ZcDlyYkkyYWpGNUlsU3BvbktJZzhi?=
 =?utf-8?B?Q25kOFFha25mRUVJRy9RakhDeTNzbnVQam1FRjJtWjRNeldHaXFGSjZlWXlr?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <922113DE9CCA284A973D4E9A8F203268@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d7be93-6875-4830-6e30-08ddb4e22d3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 18:49:27.1114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DA7tO8YmZGZfFrRpAp14RSqbtgHwfpc268uN164AE+WmFC6DVV6vZmT64zIuBcfoUKsEb6cx63xfu1o1LHLXcUQk8YqhBZGEFXulYLrzGNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8937
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDIyOjQ4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFNv
bWUgZWFybHkgVERYLWNhcGFibGUgcGxhdGZvcm1zIGhhdmUgYW4gZXJyYXR1bTogQSBrZXJuZWwg
cGFydGlhbA0KPiB3cml0ZSAoYSB3cml0ZSB0cmFuc2FjdGlvbiBvZiBsZXNzIHRoYW4gY2FjaGVs
aW5lIGxhbmRzIGF0IG1lbW9yeQ0KPiBjb250cm9sbGVyKSB0byBURFggcHJpdmF0ZSBtZW1vcnkg
cG9pc29ucyB0aGF0IG1lbW9yeSwgYW5kIGEgc3Vic2VxdWVudA0KPiByZWFkIHRyaWdnZXJzIGEg
bWFjaGluZSBjaGVjay4NCj4gDQo+IE9uIHRob3NlIHBsYXRmb3JtcywgdGhlIG9sZCBrZXJuZWwg
bXVzdCByZXNldCBURFggcHJpdmF0ZSBtZW1vcnkgYmVmb3JlDQo+IGp1bXBpbmcgdG8gdGhlIG5l
dyBrZXJuZWwsIG90aGVyd2lzZSB0aGUgbmV3IGtlcm5lbCBtYXkgc2VlIHVuZXhwZWN0ZWQNCj4g
bWFjaGluZSBjaGVjay7CoCBDdXJyZW50bHkgdGhlIGtlcm5lbCBkb2Vzbid0IHRyYWNrIHdoaWNo
IHBhZ2UgaXMgYSBURFgNCj4gcHJpdmF0ZSBwYWdlLsKgIEZvciBzaW1wbGljaXR5IGp1c3QgZmFp
bCBrZXhlYy9rZHVtcCBmb3IgdGhvc2UgcGxhdGZvcm1zLg0KPiANCj4gTGV2ZXJhZ2UgdGhlIGV4
aXN0aW5nIG1hY2hpbmVfa2V4ZWNfcHJlcGFyZSgpIHRvIGZhaWwga2V4ZWMva2R1bXAgYnkNCj4g
YWRkaW5nIHRoZSBjaGVjayBvZiB0aGUgcHJlc2VuY2Ugb2YgdGhlIFREWCBlcnJhdHVtICh3aGlj
aCBpcyBvbmx5DQo+IGNoZWNrZWQgZm9yIGlmIHRoZSBrZXJuZWwgaXMgYnVpbHQgd2l0aCBURFgg
aG9zdCBzdXBwb3J0KS7CoCBUaGlzIHJlamVjdHMNCj4ga2V4ZWMva2R1bXAgd2hlbiB0aGUga2Vy
bmVsIGlzIGxvYWRpbmcgdGhlIGtleGVjL2tkdW1wIGtlcm5lbCBpbWFnZS4NCj4gDQo+IFRoZSBh
bHRlcm5hdGl2ZSBpcyB0byByZWplY3Qga2V4ZWMva2R1bXAgd2hlbiB0aGUga2VybmVsIGlzIGp1
bXBpbmcgdG8NCj4gdGhlIG5ldyBrZXJuZWwuwqAgQnV0IGZvciBrZXhlYyB0aGlzIHJlcXVpcmVz
IGFkZGluZyBhIG5ldyBjaGVjayAoZS5nLiwNCj4gYXJjaF9rZXhlY19hbGxvd2VkKCkpIGluIHRo
ZSBjb21tb24gY29kZSB0byBmYWlsIGtlcm5lbF9rZXhlYygpIGF0IGVhcmx5DQo+IHN0YWdlLsKg
IEtkdW1wIChjcmFzaF9rZXhlYygpKSBuZWVkcyBzaW1pbGFyIGNoZWNrLCBidXQgaXQncyBoYXJk
IHRvDQo+IGp1c3RpZnkgYmVjYXVzZSBjcmFzaF9rZXhlYygpIGlzIG5vdCBzdXBwb3NlZCB0byBh
Ym9ydC4NCj4gDQo+IEl0J3MgZmVhc2libGUgdG8gZnVydGhlciByZWxheCB0aGlzIGxpbWl0YXRp
b24sIGkuZS4sIG9ubHkgZmFpbCBrZXhlYw0KPiB3aGVuIFREWCBpcyBhY3R1YWxseSBlbmFibGVk
IGJ5IHRoZSBrZXJuZWwuwqAgQnV0IHRoaXMgaXMgc3RpbGwgYSBoYWxmDQo+IG1lYXN1cmUgY29t
cGFyZWQgdG8gcmVzZXR0aW5nIFREWCBwcml2YXRlIG1lbW9yeSBzbyBqdXN0IGRvIHRoZSBzaW1w
bGVzdA0KPiB0aGluZyBmb3Igbm93Lg0KPiANCj4gVGhlIGltcGFjdCB0byB1c2Vyc3BhY2UgaXMg
dGhlIHVzZXJzIHdpbGwgZ2V0IGFuIGVycm9yIHdoZW4gbG9hZGluZyB0aGUNCj4ga2V4ZWMva2R1
bXAga2VybmVsIGltYWdlOg0KPiANCj4gwqAga2V4ZWNfbG9hZCBmYWlsZWQ6IE9wZXJhdGlvbiBu
b3Qgc3VwcG9ydGVkDQo+IA0KPiBUaGlzIG1pZ2h0IGJlIGNvbmZ1c2luZyB0byB0aGUgdXNlcnMs
IHRodXMgYWxzbyBwcmludCB0aGUgcmVhc29uIGluIHRoZQ0KPiBkbWVzZzoNCj4gDQo+IMKgIFsu
Ll0ga2V4ZWM6IG5vdCBhbGxvd2VkIG9uIHBsYXRmb3JtIHdpdGggdGR4X3B3X21jZSBidWcuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFRl
c3RlZC1ieTogRmFycmFoIENoZW4gPGZhcnJhaC5jaGVuQGludGVsLmNvbT4NCj4gDQoNClRoaXMg
ZG9lcyBtZWFuIHRoYXQga2R1bXAgd2lsbCBub3QgYmUgYWxsb3dlZCBvbiB0aGVzZSBwbGF0Zm9y
bXMgaWYgVERYIGlzDQpjb25maWd1cmVkIGluIHRoZSBCSU9TLCBldmVuIGlmIHRoZXkgZG9uJ3Qg
c2V0IHRoZSBrdm0udGR4IG1vZHVsZSBwYXJhbSB0bw0KYWN0dWFsbHkgdXNlIGl0LiBUb2RheSBp
dCBpcyBub3QgZWFzeSB0byBhY2NpZGVudGFsbHkgdHVybiBvbiBURFggaW4gdGhlIEJJT1MsDQpz
byB0aGlzIHdvdWxkIG5vdCB1c3VhbGx5IGhhcHBlbiBieSBhY2NpZGVudC4gU29tZSBmdXR1cmUg
cGxhdGZvcm1zIG1pZ2h0IG1ha2UNCml0IGVhc2llciwgYnV0IHRvZGF5IHdlIGRvbid0IHN1cHBv
cnQgYW55IGtleGVjIGlmIFREWCBpcyBjb25maWd1cmVkIHRvZGF5LiBTbw0KdGhpcyBzdGlsbCBv
cGVucyB1cCBtb3JlIGNhcGFiaWxpdHkgdGhhbiBleGlzdGVkIGJlZm9yZS4gQWxsIGNvbnNpZGVy
ZWQsIEkgdGhpbmsNCml0J3MgYSBnb29kIGRpcmVjdGlvbi4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sg
RWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==

