Return-Path: <kvm+bounces-64796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C70C8C59E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4DAB834F347
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC1A30BBB7;
	Wed, 26 Nov 2025 23:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vly440eT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6797A21B9F5;
	Wed, 26 Nov 2025 23:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764199617; cv=fail; b=OUnDSSY6Cq4/YkeVKdAmHUOeK8/hq0mJBGu/B/iGIkBQqjJAz2HF2MBCwLcs5BGMk4FYBdZ5dHbAoZvhxNoapZM4LekK80SLqsAi9bcywK8jYaGW2O2e4cIF/hPeQ6odoZibtJdgXinskCkkk9ZvgA0YZenF3D7DyOJD4f+DYDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764199617; c=relaxed/simple;
	bh=x56sONsfv/aQcssZTi8X4A7xaQIRcyQKJHg0TVCPB+Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dzt1/Thbs1Q0xRWQ9awUDGTXcsnnOLQAzcqzYQ22TXa8W/sJ6f/QHpif4RnED5ZEgQQ64OnGFILugng/JeeNgONGnuZpFAZbDXIku7QdAkAwS9GM+KYOTPSf9vmY5Mnt3rCtW56hjdFhCHUiEuu74eChkfTsHj6AA8tUxx86bEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vly440eT; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764199617; x=1795735617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x56sONsfv/aQcssZTi8X4A7xaQIRcyQKJHg0TVCPB+Q=;
  b=Vly440eTjWaKOq+7zBFbzc3FPZAivrWlRsgl3mPCzfrcg3uVjX73Pi31
   UOwPTNXYMDwkzreSsgi6yYDhO8wgM+JFI04e5We31q2MPG8tUwP50Qruu
   Aox/k3ZxpzCsaxW+SKe4Hu3vwmkBZm7bBxLPq9SWR0wVEQx1K2Izcl3Rt
   zHeCfuLSv3bw1yCGtJ+MMWroL8jKtFcXxYsRwld8HxyJGhuhBwv0U3HRq
   zjOqjRorWsc+yZWJtguwqxcFhv1Fh3iBS57HIFrFQhI5xsY09FHXNASo8
   8H4zaxtulchgjruEAx9xWcyp70saUFigXcJOt5BNpZOuOiAY5zmQixYR5
   Q==;
X-CSE-ConnectionGUID: Ewv5ptH9QWyO/0DVOmAqXQ==
X-CSE-MsgGUID: jaVCMlclQ2uphpuObmEmGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66138858"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="66138858"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 15:26:56 -0800
X-CSE-ConnectionGUID: Zrv9dcImRtuf05J2eCizFA==
X-CSE-MsgGUID: wtWbKjsDRdSGyANnrrPaRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193175856"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 15:26:55 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 15:26:54 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 15:26:54 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.27) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 15:26:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWA2U5uMzK3vhzOu54z/OsmOw/0SEokG9W3z4OXfzK2Imy6+Y8V9rtUiGmteRuQVkeBReasAFV9efB6Y6+KaKUlJ0JDcMauZaEeul6g/poudOhyNkHsbXoD4+e9c1VwANMxY13w9RswNENL9EJP7vUpLqmZgP4+ehnargNR6CfJgo2nkKOb8rVg46KrZ1lk+5sP8iQN+epwtFAv8UElHvuaiYga8LXisJmndKlE8be9X5ZPO8wcVeEmV9raub844gz7aXFk9LjMhY/suZ3LtZNjkHkBthLmasQBcJkn4+eg1uJAhPvisZTGuNgNW9QCr5QrjGcx4adsTe3uRMB3w2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x56sONsfv/aQcssZTi8X4A7xaQIRcyQKJHg0TVCPB+Q=;
 b=Yb4O7VfRBdQnI/kTcv16Vuz+dOSKEq6vQlUXGxt4dZFr5WvvTdqyij8YzNHcZkL2zJTOOD2KnQcyln6x5nXuIbfJnVUVPPul1oZLwMGgMMeoShc47uo+kVuT90NJue1iuwWn2Od5/P4lo2R48+zNH2c2LdeXATloyeUGQqze7aSYoceZgsZ1vcH5C31pWUR95/MP3Nscx26fQaRd2dyLNYWp60EgYDzFsmugTQKIWKIYO4LSVRYQYoNzxONhYVsiwmEzEg4yX6zu3U/5wVTunpef2f0a9M4/tEFeUHxQ84NXD1sY+eTboCMw2xzZL8GCTj/sCgO52gvOy8FDtRBS1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7271.namprd11.prod.outlook.com (2603:10b6:208:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 23:26:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 23:26:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcWoEHfSzJD2pReUOZz4xpGvN+87UEC26AgAGX0YA=
Date: Wed, 26 Nov 2025 23:26:46 +0000
Message-ID: <47711491d148ef92b582f40c7b5b6d2d5319e542.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-3-rick.p.edgecombe@intel.com>
	 <a2ac55888596ddf081084804c0276e3686515cd4.camel@intel.com>
In-Reply-To: <a2ac55888596ddf081084804c0276e3686515cd4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7271:EE_
x-ms-office365-filtering-correlation-id: aa463ee2-8af6-4bb0-5bb9-08de2d434489
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TWdNaFVhY3JGeVBIS1c5dDQybm01YkxCZHIreDBhMDhmNUlPVGhnS1ZESGlp?=
 =?utf-8?B?andMNGVYeFZQcWd2cTBHSDNrSUtZaTR2ZDB0MGZORXF5TVduUGtaekNrdm5K?=
 =?utf-8?B?ZlR3OUoyM29PS3RodFE4NndySmtBWVpFQWl5RVg3SjJzTWJHVGQzUnExaGNK?=
 =?utf-8?B?Vi9DOGFhNXBCUmpqZmRMNzVzOTNnSHhvWTZaRFJqb2lKaStYN0Uva0tqUXZE?=
 =?utf-8?B?Uzl2NlZHd0ZGMXNpK3RrWmQ2T1BpNnVSMVVpMlNmMDRsQzJPRjdKQUtmQ0NR?=
 =?utf-8?B?clVVY3F0cTZyWThHNENTaXlERFR5c1dRemFjSHY4dEIxMU5JUC9mUStqZlB3?=
 =?utf-8?B?KzFkL1A2QVpiR09mY3FjK1FadVhFOGQ4YUQ5UnlzM09NaFNERUtMcm1KaHVO?=
 =?utf-8?B?dTZleFBLS1FZbXArc0lrYmRJa0tQbS9PaEVTSU5wd0NrYzJoZWo0dEJPT0xr?=
 =?utf-8?B?VURpQ3FPKy9oLzl1MHpQNUJLK0xrYWExMWR2QkJlckY5YzdlUWc1dkZraitD?=
 =?utf-8?B?cmJINEtSTHdTblBWZkE3UVZzZSt5bWtRTkgwZmhJSGhvREpjNmZSeUwybjdF?=
 =?utf-8?B?SlFmQUZZdlNNam9jajBmMjJJRnZjQU9wanliYThwWlk5alpTUlV3enpSVStt?=
 =?utf-8?B?T3RLV2dBeU9RaXJnTWNmRG9PVVNGK3NmRytsVllWMFNSUjVBNWtUNnNTb05q?=
 =?utf-8?B?OGV6MDAzTm4rYmQ5Q2wzN0JtMjFoc2wyYnNSWmRINmNZS2VpbXQ5ZGErcEJG?=
 =?utf-8?B?MlZ6TkdVVGZzNE9oQ3FxSitJVmJSQTk0VUhNK04xMHpWejc0Yk8yd0RXbGV3?=
 =?utf-8?B?U1pDRnBMQmR0TytzRHF5M2RqZy9KTW85Y0NSYnlDSTlXZzVHNm1HSmlhbzY2?=
 =?utf-8?B?bXp5OW9ndE5ZUGdMN2FFMmNlcWVKQ0drTWdsbkVwdEVhUGhpbTdKZEd6M1BD?=
 =?utf-8?B?dEpzQVZ1QWVzSElZbFpGYzlFT2tJSWVFR2lOa2dsYnIzZThDSjlmUzh0eWp2?=
 =?utf-8?B?SnV6czJkOENaSGpuQU0xQ1RJdE43QVMxTjlDZ2EvMUVOQzJocVRCeWpGVVJ1?=
 =?utf-8?B?eUNRc1dRVmV6Y0NvdDhKYmo4eXovZTlFaWtvRjhEYXhJeHFJbGtITnZlRnBR?=
 =?utf-8?B?QThXNWlmWmZyeUx1SEh3aWxDc0hoOTlsQVFXTHpxV2kzMGdXUDBNaHZZVG1k?=
 =?utf-8?B?Y05uVllGNU9BdkY5VS9IQ0R6VktyNVo5ditNcWNqdXdhdWVTL0ZrMG1odEtF?=
 =?utf-8?B?eXBGWGMwVGxzVFU0blFKc0xCOWR0SDRMdWJjTVhIaTBkNkc4Uis5OGZidk4y?=
 =?utf-8?B?aER1eHhQT2FyUGs2eTFDTmxHc2YwcmhDQTVNYlUvQ0NwRU9IMnVCc0lwRDBO?=
 =?utf-8?B?VEdjVkNrQ3BtV0FPallyTG5mUmZOeVhpSDh3YVE0Nm1MQU9RUlhyOUpxQVJJ?=
 =?utf-8?B?OG9QM0oyeTdqSUl4SlZwbDJzdW1jM3JJUUNmQ1F6N0NFWXRrdlhZMVBWalBq?=
 =?utf-8?B?SUtRTE0vaWhWams2YnA3YS9MU2FqT3o5eFR2K1puc1pBek5OOGtTYmpYcjNU?=
 =?utf-8?B?Y1NsMHZuODd2TktPWHhIT2ZoZU5wUGZ4eW9yaFJjRGRienFuZHpkTkYrWG5N?=
 =?utf-8?B?d0Z0NWlVR3gzMGhmWHR1OWRCbkdCQ2lUZG9NYmx1YzJQNDJacGpRZFFWWlp2?=
 =?utf-8?B?bnVzOUh3QmxtbGdXNmFaQWdEZlhJbHJCdVgwS1YvZ3oycDhkWEdoM3haYVJP?=
 =?utf-8?B?Ynk1WjNlWGNZcDVOdDBmdHQzMHRKNzFJNXl6cVZ2QnN6b0FvTVNqQnFxVS91?=
 =?utf-8?B?Ky8waEplVlh4d1h5QnpSVHpZVk9wWGp5empPdHBVRkhNU3BnNmFVWEN5TnB5?=
 =?utf-8?B?V29nejFKZldwUHZqSVZCbnlzbXZFbWRXY09zMGQ4S2hYb0l6dVRTcGQwVUc2?=
 =?utf-8?B?TmJBUVBVYlVqVk9uLytCN24wWWkycytnL0trSElnNy84eEREY21ERjEwNVNK?=
 =?utf-8?B?RTBDVk10TmdjazFLRDhvYi9jSE5Zb3hOUjI5czh4M09HYzY0ZXQzNzhzSk5m?=
 =?utf-8?B?bXFrQ3MwMnFXM2JSeHRzTlIyTlFSNjVPZCsvZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXIrWHM4QXNEZzJFSWVqYjRNTmNlT1RtWlFHL0llOWZPOGZqaHI1ek5iaS9y?=
 =?utf-8?B?Ni9BTStqemdsUVg4dkJQaDhsWW5GVlViSS85eXpURlM1NHNhckpJODczMm43?=
 =?utf-8?B?RUZ5UE5xRXlQRm1paDZ4WTVOeEQzWE5sT1BVVlk4MWRiUk16d3JBVG5NOFZs?=
 =?utf-8?B?MC9kOEVMUFlQazVJbjVqU0NqZThkMldSREVZYmlJcnZGWk5MUVAwb2JFOElT?=
 =?utf-8?B?S0dzUlpFcVA1alR2bVlpdmZlZHBhcnQzL3BpN0MzL2VPWTVzUkNhWlJTNEg5?=
 =?utf-8?B?RG9vSmxaL0hMUzV1ekUvYnF4TU9NaVhuUVJsNWNPa1Z6cno5S0kzbnd6NnNE?=
 =?utf-8?B?WlVWNStWNDRPMlNmM2xNYkRlbDgxNkpRZFkzQ2FQZk1QaUVEdk1saTFwNTU1?=
 =?utf-8?B?ZTBUeVdzaXlIeFRlcXhPSzI5em40dmcvRnI5MklyTFpXNjNIR1kwN3hTak9B?=
 =?utf-8?B?cjVoMUlOZzg0UUk5ZjFUMmtCa092eERBcU4yYjZVcjRHRXYxSFhsL1I1blY3?=
 =?utf-8?B?NmtpUmF1aHBkNUlmUjI0WEowaTR5OWZDNjdUb2o0dVNXSDdnOUhQWnMxQUtD?=
 =?utf-8?B?SFpLZjQ4OTFYdmFlQ2RWVXRMSjF4T0Z1SlpQWE5ZczRtL1doY2cvUStTMStI?=
 =?utf-8?B?QkM4SFFiRnVvQVBMQWd5RVFsK0UvMUgvOUZZMDFFcDc2ZW1ybmw2KzdEd3ZB?=
 =?utf-8?B?UGhJd2NMK1pZZ2hGSVd6OW1JQWttZmtVMmRxbUZuMWJOelBsNjdoVW0vcDJE?=
 =?utf-8?B?MHEraGZkSDh1SERRVG1lbDRFT1JDeUY4T0RhTDR6T2xuQ00yMFFpUHk2eldu?=
 =?utf-8?B?R1d2N2ZRVTRuTEpMUzluY0tSd3MzNHFKcVZSV25uczNNTUJjckxzTW9GNE15?=
 =?utf-8?B?SnVXRTk5Z2lFMDRKbmFwMUM5cUxNcmNKN3BvV3l5cEN2Zk4yRHl3YU1EL3l4?=
 =?utf-8?B?Y3lLNWRHNEpsSXBIclhOeEI3R3VxRWgxRGdUZXNpMVJhM2NFVVFFWUsxK2Z3?=
 =?utf-8?B?a0xhK0MzdEZNSFozaVdBL3FVdU4xS001Z3VsNExlUWtmN3pFdHJIVW9GdmN2?=
 =?utf-8?B?WEp5YllPMXJnaU9BZTJscm1sSG1rVE5TeXVvVFlIUnk1dGpVaHRNWlp1L3JB?=
 =?utf-8?B?Y2hlNXAwVTc2TTBjcWk1QnFNZnZnRWFPaEtudnhDYnpiZzlWenpEaVpRdSs3?=
 =?utf-8?B?UjJ6Q2FpcTJKcityNDhNUDFCVmNBelNXbklhZi9SdDhmSFVGQU9WbUsxVEZl?=
 =?utf-8?B?bGpPV2VoSmpyQkZaYVFZYWgrb3ZMWnpOeUdJMDlvci9zV3NnbDA2ZkRzREp1?=
 =?utf-8?B?TGk1M3VkT1I5VFh6bHd0Z0N6NW9jSURCVzk1R3pVYWVHOVJ0VEx2MkhQZmxP?=
 =?utf-8?B?UDhqTWR4WmhITm9td21qVXoxRlZVOVVkbURwSDV1MUJRMi9SZVRFUHkraUlh?=
 =?utf-8?B?Z0lpdm9LaEdLMGFlUDRmbE1Mb3NkRkNBbytJS3NxZnlSbkNxdmNWK0U1NjV5?=
 =?utf-8?B?eWdXUG9PYzlzM2lkVEFYaXJRSFB2QzJma2pWeURlRmpqblNnT3JkWnloK08r?=
 =?utf-8?B?MU1UczFaaytuYlNHeE1qYXdOcEdVMjhLQ3Zzd0NWSWFFUklDTUQrcnVNKzFM?=
 =?utf-8?B?UkM5amZULzNTOWc4bjhabWVUK0wwRmRQVzlyNkdlTXNVN1JYQUt0b3RUWTc3?=
 =?utf-8?B?anZBZE03THN4Y1lLNHp1QVJxaElnVGlHRnpsUDJpWTFoTk5LQnlsaEdRQVBC?=
 =?utf-8?B?TDNocXRWWmtVTzNaQmdHMHBHdHcvTUlBNC9lYmxHamVVN2NvbXBsQjdyNzR3?=
 =?utf-8?B?aFk1VmJ0SG9ORDJTQmpIbm05YmpLdWFuYkNCeUo4OTlORGdWV01YbnVJcVVm?=
 =?utf-8?B?MzE1c1pyRTF1b1JpWTN1VlJSenJiclNoK3FyOE4vYVhoNlF3dzgyZHVDZFpN?=
 =?utf-8?B?MWpnejRDZExYTVp6aTZKZXl2QWNPWHFPRGtGRTJKWkJyTXQrNXZyYmdsZmtN?=
 =?utf-8?B?U2lhd3NBUnV2OTAvVk5NQWhFZE55dTJPck9QdU9YVk1qRnJEMUNDY2tqYXRZ?=
 =?utf-8?B?ZnVERE5kMjIxN3d0Yis5KzZZUzNHSFFLcjMvbDFJK3RhMy9FQXZ5cWF2Qm5S?=
 =?utf-8?B?clpSZzBZWjdMWVVSYXo1QVR3VjVQL29xQVRFakdEcExvMFJzdFZoQ0RnMjRV?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD03201FB3B48F4FA12668A0719915AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa463ee2-8af6-4bb0-5bb9-08de2d434489
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 23:26:46.8871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nbiEO05Oi19pbBM+8779iHpK3kpG1s0CJ7wMJZkcV8N5aZF8esZ6bfImZDq8b+KiPVMiQ8qzNdRWt9WrcrUo7rRXR96P8m/VHhFW2YPwFH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7271
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDIzOjA3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjUtMTEtMjAgYXQgMTY6NTEgLTA4MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0K
PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4X2Vycm5vLmgg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4X2Vycm5vLmgNCj4gPiBpbmRleCAzYWE3
NGY2YTYxMTkuLmUzMDJhZWQzMWI1MCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9zaGFyZWQvdGR4X2Vycm5vLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9z
aGFyZWQvdGR4X2Vycm5vLmgNCj4gPiBAQCAtNSw3ICs1LDcgQEANCj4gPiDCoCNpbmNsdWRlIDxh
c20vdHJhcG5yLmg+DQo+ID4gwqANCj4gPiDCoC8qIFVwcGVyIDMyIGJpdCBvZiB0aGUgVERYIGVy
cm9yIGNvZGUgZW5jb2RlcyB0aGUgc3RhdHVzICovDQo+ID4gLSNkZWZpbmUgVERYX1NFQU1DQUxM
X1NUQVRVU19NQVNLCQkweEZGRkZGRkZGMDAwMDAwMDBVTEwNCj4gPiArI2RlZmluZSBURFhfU1RB
VFVTX01BU0sJCQkJMHhGRkZGRkZGRjAwMDAwMDAwVUxMDQo+ID4gwqANCj4gPiDCoC8qDQo+ID4g
wqAgKiBURFggU0VBTUNBTEwgU3RhdHVzIENvZGVzDQo+ID4gQEAgLTU0LDQgKzU0LDQ5IEBADQo+
ID4gwqAjZGVmaW5lIFREWF9PUEVSQU5EX0lEX1NFUFQJCQkweDkyDQo+ID4gwqAjZGVmaW5lIFRE
WF9PUEVSQU5EX0lEX1REX0VQT0NICQkJMHhhOQ0KPiA+IMKgDQo+ID4gKyNpZm5kZWYgX19BU1NF
TUJMRVJfXw0KPiA+ICsjaW5jbHVkZSA8bGludXgvYml0cy5oPg0KPiA+ICsjaW5jbHVkZSA8bGlu
dXgvdHlwZXMuaD4NCj4gDQo+IElNSE86DQo+IA0KPiBZb3UgbWlnaHQgd2FudCB0byBtb3ZlICNp
bmNsdWRlIDxsaW51eC9iaXRzLmg+IG91dCBvZiBfX0FTU0VNQkxFUl9fIHRvIHRoZSB0b3ANCj4g
b2YgdGhpcyBmaWxlIHNpbmNlIG1hY3JvcyBsaWtlIEdFTk1BU0tfVUxMKCkgYXJlIHVzZWQgYnkg
U1ctZGVmaW5lZCBlcnJvciBjb2Rlcw0KPiBhbHJlYWR5LsKgIEFuZCB5b3UgbWlnaHQgd2FudCB0
byBtb3ZlIHRoZSBpbmNsdXNpb24gb2YgdGhpcyBoZWFkZXIgdG8gdGhlDQo+IHByZXZpb3VzIHBh
dGNoIHdoZW4gdGhlc2UgZXJyb3IgY29kZXMgd2VyZSBtb3ZlZCB0byA8YXNtL3NoYXJlZC90ZHhf
ZXJybm8uaD4uDQoNClllYSB0aGF0IG1ha2VzIHNlbnNlLg0KDQo+IA0KPiBZb3UgbWF5IGFsc28g
bW92ZSA8bGludXgvdHlwZXMuaD4gb3V0IG9mIF9fQVNTRU1CTEVSX18gc2luY2UgQUZBSUNUIHRo
aXMgZmlsZSBpcw0KPiBhc3NlbWJseSBpbmNsdXNpb24gc2FmZS4NCg0KU3VyZS4NCg==

