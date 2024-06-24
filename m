Return-Path: <kvm+bounces-20435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B543915AC3
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C991280EA5
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8051C1A2C22;
	Mon, 24 Jun 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GuKe/z5c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E238F9A;
	Mon, 24 Jun 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719273311; cv=fail; b=cTqrRzqsGd2FtySGYq+YtOqDokdpsINWtwXwLtumsMwgcgjeIl0F+XHsJHJi8HthCOsFCrxUdUkbBxSrUfj8yquDAYAeevu2bkXlzVDHs8KDpVP/ofKi4khFYfT6Ug3PRYZY3jM+ioaexFe9qBH/gYIYjA0rTlN2CSO63IlZMNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719273311; c=relaxed/simple;
	bh=nV865yBAtttW5O+CknblFyC/HPeG7+8ouEQv0MeHX4U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tZ4iDL1MOGCzG4CFZNIVabyYWDa1m6MteUEqepPE/SwzXWXN5Ni/Rvp1YYJ4ZMIPOSXqBLQd4vGBJSDkeQmue58fCTjx1Y60/Piv8XCGrTD14MrXHfQvcKcT8gNu6KwnGh8/XtbAGhjbPgGV9KEWSpaokcBiruJ3bnNFoRc7qaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GuKe/z5c; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719273310; x=1750809310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nV865yBAtttW5O+CknblFyC/HPeG7+8ouEQv0MeHX4U=;
  b=GuKe/z5cZ6Bzth3cNtgu+vSTp0dCPACAQCYGB98+iXW7oiwXHEq/ZJnP
   Be2fUQwIMJH9qBf+oW3eh1Rsp2OJiteC/EWIQDhck4Sq3yvUZIDa8l9zL
   o2/D0PtEBrtsdaQ2gTh4FIBzq99WPa98w9Lurhx4d/+RaFRw8+JUMUb5p
   CULdn0iSNr4AMrZyz+E5WxaHNQZyDu6jZQvnH3siX4nX8D9n2EWNVhGbJ
   cBE7yM6ShwzJq2NiRArTCpwP/PWfOdwo4L96kex8xhsN5SPxsBTNz4c0h
   GtEPJJNteFZaotUzbptt/g30RQ0gii393rm4ak9hI13M8+NRDsrbkuHUZ
   g==;
X-CSE-ConnectionGUID: VKOqGOLESEWj0SudKZsc8Q==
X-CSE-MsgGUID: GSBWzvlSQQieaBJKrft8oQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="27677388"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="27677388"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 16:55:09 -0700
X-CSE-ConnectionGUID: VnVHSEnPQ1iQCni4ncayEw==
X-CSE-MsgGUID: s1Xl+PueQCmkzeGBhJs3Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="43559386"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 16:55:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 16:55:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 16:55:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 16:55:08 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 16:55:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9kiLN8ebyLkzL/HFlzDKNkDAsNVtiDMD0KX5oWGNs1VT0Hiw3nIi/Hhlbi5/85++XOQLcM3tTeVd4DnY/br2BObEIB5BMrOSsXz4llzRPIlHNycwPHO9hp8iEGNaAq8nMG+J4dVhaxHW/vEvFf30+idfO0HxgGXdWR+EcthwJdPeta/yc0U5AJDZB/JBfmMFWdUgm94kPEBrFVstIht8wFBxidhkQEMS7I3kt5w+w6/V80swLjCeqF7kuPrcnv2Rs4PqNqRFyKa900wkrf/y6N0aoZfPvIuxFV/cGOZXC79NHlFcclgBUIv3I+VQ9EiYZz4OWOTFflLPM9+LVV5pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nV865yBAtttW5O+CknblFyC/HPeG7+8ouEQv0MeHX4U=;
 b=KQ0lRuouwwSwgco7JFBdndQzzoaLehRHra2VHJVteNH/BoSWdRmqL3iSLNFvJCOafQsDBaNYvDWug/s8f9lKqFhEbU1/GUsT4cz8rskRS3O0QdVptBJ+bhGdT6OQXLYWhBYbaWM6kZqFRqolrUR6/mAKYa99XpomMqtkBV1ENKIAjmn5OK9PKaPgeHIBaTr8/5+/TVNtppS38OveZAtppHYvgYynicayRfS1nhIgffHpdl8EervomlB85IRJbSSf3W1WJuPgqNBu/1Tqw6ECG7x0OACGJDPqFrAPaq7py2FrHadsvwG6Y+AZKw0VreK8ZMeNeYeOMAxZax8yc3rbLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8500.namprd11.prod.outlook.com (2603:10b6:a03:574::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Mon, 24 Jun
 2024 23:55:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 23:55:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v3 16/17] KVM: x86/tdp_mmu: Propagate tearing down mirror
 page tables
Thread-Topic: [PATCH v3 16/17] KVM: x86/tdp_mmu: Propagate tearing down mirror
 page tables
Thread-Index: AQHawpko+8JWPzoQz0K7Nk54c0pMwLHQVuoAgAdHu4A=
Date: Mon, 24 Jun 2024 23:55:00 +0000
Message-ID: <842375b84b1649dd2fe43155ee51b7d596e7a0c4.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-17-rick.p.edgecombe@intel.com>
	 <e693adab-9fa3-47fd-b62f-c3f2589ffe7f@linux.intel.com>
In-Reply-To: <e693adab-9fa3-47fd-b62f-c3f2589ffe7f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8500:EE_
x-ms-office365-filtering-correlation-id: bce23299-c50b-4414-8f82-08dc94a90f5f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|376011|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?R2RUV0MxY2RJcXJwb09kTkorNjNTWXdrOVFVMEViVzNGVlk4UTJDQmRKbE82?=
 =?utf-8?B?UHZzMDdPUzVmQnRYbEZyNEt4NEVlTlhUSUcxcU9hQ0c1Z1hjb2dpbzVCRFp3?=
 =?utf-8?B?ekM1NERQcWMxY01nQ3pKZEl5UlpkZ2M2c0htYmZGUHBDenhtcWQvNzN2RW1N?=
 =?utf-8?B?L0VWVGJUUzBrYXpHZElWNklPSVBwZmozSjMzemgveS9tMW1Wd2JVOS9GNFpJ?=
 =?utf-8?B?aVFKRFpLOEgrc3JJWE9IQ2hxSk1neWpscnVYN04yTktYeUdHUDNLQjQ4Mmwr?=
 =?utf-8?B?MnFkSTVTbTNRdldCS0ZQcitYWGRzMU9vbG0xWTZMcnAxdmFVM2F4SDcvUEJi?=
 =?utf-8?B?NFB5bEhPWkd0bVozdHZqZ09ib3IxYjRXUEdKeTNGelM2N2p3VmpzSWRJT3ov?=
 =?utf-8?B?RGFsSEVYS2x5OWRqc2YwK2J5V210NUxOVHo5ZFVEOCt1S2kyUHFWa01PaUdV?=
 =?utf-8?B?UFN2QXRoUVc0UWJvV2VhUmZQcXRRUWhDbVdzcmtBaVFkeEJhdFhGbENFZkoy?=
 =?utf-8?B?VWdlVFFnSWJocUxMTnE1dHY1MXpabkYwQU5JdTlNY2dCTVY5VDFkTzJyVGVv?=
 =?utf-8?B?UWlyZFlZdjlEQzA3WHpzVzk1S0FvZWFtZGdnaC96dlh1cUpwTlVTbHRsTHFr?=
 =?utf-8?B?ZDN6YXVhMzBZYk4rK1N2c25UY2Jjb2tMVE1KZDArYVFHVDBiOXUwWGF4cmR5?=
 =?utf-8?B?UmtsT2tXcS9aNWFJcVdHQWhIcXkzRzJXTkVFOXpJQ09rQUR2UEk2U0NHTEk4?=
 =?utf-8?B?aXF0U0d6RlEyWXk1L1BSREt2dEhWalhsMmZ6Q05qcm9UTllXS01IYUl1TWIx?=
 =?utf-8?B?RDlHL1hXaUlmUVRVY1UvWHVTMHFSNi9IdHJseW83SmJEN045TXc2Q3RsL0U1?=
 =?utf-8?B?VHR3ZGJIQXliSFkxOVUwamEweWR6SUtaUmpUSXNQcGlkYStQVU5EeUFIL2Nl?=
 =?utf-8?B?Vmx0a3NETmZ6bmJXWnVuakhnTjBHeTB6bFRYR1A3TEV4eXhZWHlzOVhkMFBa?=
 =?utf-8?B?OTZtY2NhZUUyS1ZiUEEvb0kvZWY5YTBzTE9xSXBXMC9hckV0dmNtZEFYK1Nj?=
 =?utf-8?B?OXlLSW0yaDh4QWxQWTVxaE5JREZ4VHB6QkpER2ZSMXQxWkZjSFlqN2d4SjdX?=
 =?utf-8?B?Ym1iRCs1emFtY2ZYL3ZZWGlVMXViVHE3V1RZM2gzSTdsSDRBdjZvVjlzV0p0?=
 =?utf-8?B?WUR0WW9ZcVhjaWZhWllqWEk3TFZTTnRIa0p5TDhaQUUyQ0tlVVc2a3plbVhK?=
 =?utf-8?B?alFqNmVjcTR5UmVKZUVQdUFsNExSajAzY1A5ZjNEL2FlUUEyd3piM0p5SHJz?=
 =?utf-8?B?V3F0ZUNlRWRVRkZtaG1pMmhIdW43K1pnWmhRVG8wVlRPTDRvelNJZCtyYUxM?=
 =?utf-8?B?K2tzMmJSbEtQcWF4NG1mbUUvUWJzRUljbDRGZTZHOUVxcVZWOU0wTjdtbzcz?=
 =?utf-8?B?SVh0TWxHWHVJVzFPRElTNG1UaTQxY1lpc0ZxMzE3MTQwS2F1S0RkYWY5dC82?=
 =?utf-8?B?YXUva3RiM2RBK3ZCdUJyTXZxdE1VMXNzc1hMd3FKMEFYbVZ2aThrc2F6Mmg1?=
 =?utf-8?B?NFo0OHVvMGRiQlZiNmVhTEt4dkdjMjVIR29Bck9JT0FnNmJqR0tzZFF5Mzcx?=
 =?utf-8?B?eisxaTU1NEhWeU5lRmxMcmhRcmxDbndlSEo4KzZzODlDVXBMVnJaKytoR3o2?=
 =?utf-8?B?NFYrZkk2eFl0alpiV2lLVHNPOHp0dW9mb2FidnExQXNTUmF2c3ExSjY2UEpR?=
 =?utf-8?B?dk1mNGhLWDVTdWZ2N2JuV3pZRUhFQVR0S0pkM25aQnJiS1Q5NjBpN1lWYm4v?=
 =?utf-8?Q?rh234Ytyj6e2lP4H2YA7HAlg7JE2F+dGwpqW4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlFNcVkxdFBtT3hzUit6UVkyZExkK0luRkNjVFQ4YTdSbkI4V1ViS2p1TE5l?=
 =?utf-8?B?UTFIT1FpYnlKa00wYjBzWEY1Z1M0YTNRUDF6MmxVVXZib25UNWNCNURveUhW?=
 =?utf-8?B?T0lDQW8wcVE2UW04Vm4zU2orMkpiU2JKNzdXeTZVcG9tOGxpaXBBcjMwcm10?=
 =?utf-8?B?Y1g5SHpSYmh1dmlSRFZQQVdTejdaVGVtakdzYmVRNEpOaWNGMG91bVdjMFhV?=
 =?utf-8?B?Y3A2MFFYS2k4VXR6TTRHZ3RESk9GU0cwcXgrb0hDVTB5aTYyTTBHRjloRjA4?=
 =?utf-8?B?em85VUhUYXZ3cVQzazFDWXhJNVl6emRTcm1ybjBnQlNXYkVJbDVMbXlZVU4z?=
 =?utf-8?B?dGg1SGpSQk4xVmk0VStkK3JZY1R2N2FQRk5lMXJDaDZpSU1CUzdXYUpDYWJ1?=
 =?utf-8?B?S0RHd1hXT1BhR3d6U1VxQjV2ZVRLN3ZuajJZbmlUc2FlNVIwTlBZU1Voby92?=
 =?utf-8?B?MnVxTmVNNGV0RzlxOFJXR3lVQnJ5OE15RFpQQUx1SVdxaXpHNENPTEVXVVlv?=
 =?utf-8?B?K0JuN0xxNUJrbHRSMTZrTWVIRWlxS1ppVEZNcDRqTnBkNVZaNlVHY2daWEZt?=
 =?utf-8?B?Z2NEM0V3dVFIYnVzV3dHNnRVTDQwcnJaUHIvV3haRE9WcEd2R0xycmxPbEZr?=
 =?utf-8?B?aER5RVkxT2N0Wk03TnpVdTNZNjkzNVBicE9TOC9oNU1ZVS9tR2tTdFR1dzRW?=
 =?utf-8?B?T2E1WCtFaFZwVlo5OGVaZ2V4QVN0Zjh5cEJJR1E1eG0wSEwxM0czYlhKVzlV?=
 =?utf-8?B?cFJ4aHRoclNXMk9Id3Q4bENLOHIyZGwzemN4YnF6YlR2clc5anJqWG96YXFF?=
 =?utf-8?B?a2M2OHRRanJLZWJoT3dVMS9vWUV0MlhvbTh6UE1JSUdsTWYzTGhIc0s5YXVs?=
 =?utf-8?B?VmI1L2ZLWUo3WEN6d1dwRnA0VmxYRldnL2N6V2VVMm12Y0V5K0R6Y3pQSGQw?=
 =?utf-8?B?ZTdKUEpnOWhwVUg3UlRycjV0a0YreFNBNXl0dEdQNTIrSFlmNEFMTVk5dVBO?=
 =?utf-8?B?cVhpelVRYlJwaFRJdEg0REVOTDlPdUlVcE5TOXBDYjgyUmNFUHVqU1Mrbkpp?=
 =?utf-8?B?V09PWDRxQVEzMmdYL2huTFBkVmZQUmdQTzRQaUt1N2l2R0c1WkZkd0FMR29h?=
 =?utf-8?B?djNza204M2c2VUFKaU9Mc2t4TjJFQkhnRVJza0cxNW9NUW4wWjZEaUtLZGVu?=
 =?utf-8?B?LzRCMXVmMmZWVzNPKzBYeE15QzYzYnlxUWJEOVlTTWVsZm1kZGRJY3E5ZmIx?=
 =?utf-8?B?Y3A5Mk1HdUluNjJ6cFBmOUZDbzZjZ3ZDa2tDZlc5YXFEa3VtV1Z3blQzUkxY?=
 =?utf-8?B?aWwzT0w5NzFCcGNoVUQxQVcrakhoRW0xWVVxbjhWZ1JqaUZyRExVNjA3YlIy?=
 =?utf-8?B?UHZhN3krRGNjWExvaVMzL1lXcVB1VDVtWGNMN2REYVIzeU8xaC9tMWh6MVZH?=
 =?utf-8?B?U3NPMC9uaTUxNFNvdEVwUDBQRkp0SmxRdmZuL0d5UDJENGlibWt4WmtFdHFK?=
 =?utf-8?B?OU9lVG1RY29zV2l5ZTV4SmFha3pBNjZEY0tGWEsxbWN1aWIrTC9LNFhLSGRu?=
 =?utf-8?B?dFdFenl3alhqK0V2Tk1FMlR0MHFzWW9MY2w5dkVoZVBFN0lVQUJOZWNOSmNI?=
 =?utf-8?B?R3lMeklid3FtSEdzYlBjbUdFZHhuYS9IbGtaZ3ZsclM4TlQxdWR2N0NFOWNo?=
 =?utf-8?B?L1ZCa3kwVXA1eTE2VDREQTJzbUgrQit4WkJkUTdTS1k5cWxqSkhEbjJjcFhr?=
 =?utf-8?B?Mm1oTzRkWlRyaU0xUXpaSW9YS0xxMURGeGhKbzFMSUgrYnFzSHNlTWpwd3lu?=
 =?utf-8?B?VElrMHpOYTd0Q3ZPNlFhVUdxeXZDZy8wTTZBdzRqa013NkZTT2p1VkV3dUk2?=
 =?utf-8?B?VWxseVBWL2Fnems1ZmszSzZFaVM5M2hQMS9IK2tkaFAvRzJlUVZDNTdsUUFO?=
 =?utf-8?B?dVJxeEtiL3FmVlJKaW5pcTNmbm44UzIrVTkvVWw4TDcyZ1JjQk9BQ1VJODc2?=
 =?utf-8?B?Z0dWS2ZmQVRxa3RDaXNCL2E0cElCdC9PcFk3L2RPa2xjVVJGMC9FZHJTMU1z?=
 =?utf-8?B?TmFraHZMRXcvUlVTM1RvUjBneWtNNm9aS0dNQ2JyYlM4Rm9FeG9rT2VyTzFI?=
 =?utf-8?B?TVY2WUh6SStNVW9rbE50Y29LN3NxbXNiZUFVUmJibXV3cFRPWjg1S2VDTUI0?=
 =?utf-8?Q?N1IKVHlFQfZ2EC6rBm4PwcU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69177345989E5246B25ACD61549DD661@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce23299-c50b-4414-8f82-08dc94a90f5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 23:55:00.7996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zp6jI5lkavjnFsscyJE1jPWA5/fuIDQC4D88a3xsAgLBsC0oF+GALYv/AYUcthh4L8pH7B2HW6WiRDsKnHaM4SJa+gNtOJK3CmCoa048rxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8500
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTIwIGF0IDE2OjQ0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
VERYIE1NVSBzdXBwb3J0IHdpbGwgZXhjbHVkZSBjZXJ0YWluIE1NVSBvcGVyYXRpb25zLCBzbyBv
bmx5IHBsdWcgaW4gdGhlDQo+ID4gbWlycm9yaW5nIHg4NiBvcHMgd2hlcmUgdGhleSB3aWxsIGJl
IG5lZWRlZC4gRm9yIHphcHBpbmcvZnJlZWluZywgb25seQ0KPiA+IGhvb2sgdGRwX21tdV9pdGVy
X3NldF9zcHRlKCkgd2hpY2ggaXMgdXNlIHVzZWQgZm9yIG1hcHBpbmcgYW5kIGxpbmtpbmcNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXg0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBleHRy
YSAidXNlIg0KPiANCj4gQWxzbywgdGhpcyBzZW50ZW5jZSBpcyBhIGJpdCBjb25mdXNpbmcgYWJv
dXQgInVzZWQgZm9yIG1hcHBpbmcgYW5kIGxpbmtpbmciLg0KDQpZZXMuIElzIHRoaXMgbW9yZSBj
bGVhcj8gIi4uLnRkcF9tbXVfaXRlcl9zZXRfc3B0ZSgpLCB3aGljaCBpcyB1c2UgdXNlZCBmb3IN
CnNldHRpbmcgbGVhZiBQVEVzIGFuZCBsaW5raW5nIG5vbi1sZWFmIFBURXMuIg0KDQo+IA0KPiA+
IFBUcy4gRG9uJ3QgYm90aGVyIGhvb2tpbmcgdGRwX21tdV9zZXRfc3B0ZV9hdG9taWMoKSBhcyBp
dCBpcyBvbmx5IHVzZWQgZm9yDQo+ID4gemFwcGluZyBQVEVzIGluIG9wZXJhdGlvbnMgdW5zdXBw
b3J0ZWQgYnkgVERYOiB6YXBwaW5nIGNvbGxhcHNpYmxlIFBURXMgYW5kDQo+ID4ga3ZtX21tdV96
YXBfYWxsX2Zhc3QoKS4NCj4gPiANCj4gPiBJbiBwcmV2aW91cyBjaGFuZ2VzIHRvIGFkZHJlc3Mg
cmFjZXMgYXJvdW5kIGNvbmN1cnJlbnQgcG9wdWxhdGluZyB1c2luZw0KPiA+IHRkcF9tbXVfc2V0
X3NwdGVfYXRvbWljKCksIGEgc29sdXRpb24gd2FzIGludHJvZHVjZWQgdG8gdGVtcG9yYXJpbHkg
c2V0DQo+ID4gUkVNT1ZFRF9TUFRFIGluIHRoZSBtaXJyb3JlZCBwYWdlIHRhYmxlcyB3aGlsZSBw
ZXJmb3JtaW5nIHRoZSBleHRlcm5hbA0KPiDCoMKgIF4NCj4gwqDCoEZST1pFTl9TUFRFDQoNCk9v
cHMuIEFuZCBhZ3JlZWQgb24gdGhlIG90aGVyIG5pdHMuIFRoYW5rcy4NCg==

