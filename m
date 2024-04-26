Return-Path: <kvm+bounces-16064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 287308B3D7F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90D771F25329
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72E315A4BE;
	Fri, 26 Apr 2024 17:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aF116dyS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCDE2F874;
	Fri, 26 Apr 2024 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714150917; cv=fail; b=YvukaQq1FLHGGpJMvEpsY2Tt21YwALe3jAs5PVTYi7TeM7ixdTMs3UfPbiAdEnoXTiSc0j6tygq6trvs+O2AeJ+mMt0/p/9vNJCaVGuf8C9nc6o1u4SO3XwMMhGArgbEE2X0uyaJazNF95LYBZVh6iWDHNUQhU3p4VkJZwTr/n0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714150917; c=relaxed/simple;
	bh=erxXJ2Q3dAp11WTu7dWaQyJOTe9Pxtf3Z3zum4Dt7Ag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gFHmvC5fQpuRsn82h3qoR6ggkLzDl/IPE7eWihiz43E4oQEZdVVkwyyEjf9ojRVgtN5A8ZLSHkYckgWHZY7TgdVvHmSYCduJbEQzCvOWWt6VluVPwlwSCYlts87AvJAGsQUPV/eE48+jZr9Mcia2B70NhJT7TTHPHR2QjwmRK7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aF116dyS; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714150915; x=1745686915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=erxXJ2Q3dAp11WTu7dWaQyJOTe9Pxtf3Z3zum4Dt7Ag=;
  b=aF116dySVKQ9cko2DnTdEn7QMJ9pPX83VRR/67pqpArRlsQYVcclpy87
   4hfkEBWHJjoRQgxq1udMd2aIqf1tZKeACABlBlg0Z9XG53XUrhuzdkIKz
   cJpzZyqpIF5ED5T8RwGxr7GAVLHzdBHlkf0CsmJxpRjfwSBQKkg9O8MHW
   zC/ssvqewGhQTL0QVlLoxxpM6VWfmxiLXYx2ap04+6xEhGlSXM+zvvX/K
   p63skqWrWInXOt+plJXXQ6KacZiICnyNt5uEaLPpc3wJrHT1BUzXNuX7s
   vxCbJiHmmFFmf59CZW17MBSLjyp89HtFMYvG+2Z+FobkBLK+M5MGC40AD
   Q==;
X-CSE-ConnectionGUID: 8RcrFtWLS+mpV5XNgVGsBw==
X-CSE-MsgGUID: jb9iqkwqTr+42ixMX5xqkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="20448263"
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="20448263"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 10:01:55 -0700
X-CSE-ConnectionGUID: eIG/59adSOWwVZpbM8LMig==
X-CSE-MsgGUID: icoaxijMQheMQBvK9iLD3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="25447823"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 10:01:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 10:01:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 10:01:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 10:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zw5ffuXFyki6BJ0ghDRYiPZB587xJkZUbFm97gAnnG6VFdeYZTgisji3IZvZ6xDziW5vGV3mRua/YiD1E629tjLEix5Crnz53x0ZUeoeVxrcTEltsiPs6N94Mo3YPT5EL8uW0tVQKzOAgjJIG/obrfXRfaOqFPTX8bn5cQUfdMV6ZgAfpGK7itosXlpp2KcODUqeEdmSH1wAgdNCrtRrKEHKsL/73WJizYydzJSPM4ZyQpKY1juBM0LhH7O4M9RXe3gc7PPHpcyxZrSGgvI+qTU/bbpwazoQ5kWV2VA1t5AGCenG3PQ7GroMB5dZlRQtqT93GOQqDSPJnbcecRU6+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erxXJ2Q3dAp11WTu7dWaQyJOTe9Pxtf3Z3zum4Dt7Ag=;
 b=Ri13WQejY3DyF4gNAnBMHEb1V6XqhPEjyCUpEfCMcvn4P20XV8NJSNN/7pVCXS8K6X5H0JibuppLHFTdL9An2NhjbQSwGpS0yQG4b5NqMmNWAlgnE8CqQEB5dS4l6RKQcxKeNcggF+WNKKfa7Q0WTfb/lpdKqbs/SD7R1sxCMvxvGx2y5NSFcoOCY88QCta0FirExAQWmTYCQGczlu3K+6NO72rELSqgAKA+glsYZRalto3fIAz6x2Ew4GDpKnpEzK7qwVcRVCfmGGVYNJKuh/NOIVhKBYRIHa6wD2XplrfD1R0SUL2CN2BdzfdySU2As2q2v3jfikif04Vuo+wxOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8573.namprd11.prod.outlook.com (2603:10b6:806:3ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Fri, 26 Apr
 2024 17:01:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Fri, 26 Apr 2024
 17:01:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "tabba@google.com" <tabba@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Topic: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Index: AQHadnqYyiwEEDddI0GwsG68yoNoPLE/K9oAgAB2CoCAOsrgAIAAZ8AAgAAbRoCAAAhBgIAADoWAgAADSwA=
Date: Fri, 26 Apr 2024 17:01:41 +0000
Message-ID: <dc90c8efaa4d4dd36dc945d40cd118afcc3a9105.camel@intel.com>
References: <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
	 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
	 <20240313171428.GK935089@ls.amr.corp.intel.com>
	 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
	 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
	 <20240319215015.GA1994522@ls.amr.corp.intel.com>
	 <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
	 <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
	 <ZivIF9vjKcuGie3s@google.com>
	 <21d284d23a7565beb9a0d032c97cc2a2d4e3988a.camel@intel.com>
	 <ZivazWQw1oCU8VBC@google.com>
In-Reply-To: <ZivazWQw1oCU8VBC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8573:EE_
x-ms-office365-filtering-correlation-id: ff5215d5-ee5e-4420-59ff-08dc66128b35
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?anVNVzE0eHJOZE96ejRLUmZwa0NJWnk5REljY0ZCOXc5VHVIdStaUUpYNHhi?=
 =?utf-8?B?Y0FFaU9IZmF4eHh1M0R6amg2ajNBNHk3cndwZnBCUS82blpyMnVZbTg1aXQ5?=
 =?utf-8?B?Q0psb0lHKzRvYjVxanRndkE2bUtUV0lpTHkwNDBqeEZHaDN0eDdaWkVQMUcw?=
 =?utf-8?B?K01GbkNGU1FrSjFYVStXR2ZVS1RCS3ZSWGxxUVZPZmJSVms1UjNVTENmamFM?=
 =?utf-8?B?ZG10b3BNMWREakU1ZndrdVhCMWpXRjZEdzNyMzZwcGU0OTdMcU5iUmk5dzcx?=
 =?utf-8?B?U1ZWcHVhMkx4Zms4N2dxQUcyNFBLQ1JPT0IrMW0xNkt3RTA3MWFTbExldUc3?=
 =?utf-8?B?SmhrYlZ0SExkT2RFVVBnN0NLZkNyTW1CS3FmdndEZ1dibW43b1kvWWRvUjRa?=
 =?utf-8?B?OE56RFpMbnZqY1ZBOUplN1Zidmp1VkRPMkpVTWNqb0srQzIzb2VjODh4eDJR?=
 =?utf-8?B?WVVmbzAyNHpSYlhjNVZTeVV5STB4MFcwNTNuU0MvOFAyTC9iL1pyWitScUh1?=
 =?utf-8?B?QjVlemcyd3ZDbDJBWVFWOU11MmNndW1vcG1nY211UVVGUjBFOG15dTMva1FW?=
 =?utf-8?B?SktvbkZ5SUZEalgvTU8vZDFMUktvUzkzSjdEZlJCSVZtSTVyR3NQMWx1ZzlE?=
 =?utf-8?B?RzZZMFhFcTlvYTlHcUJObzgvNXg1b3ZBazFCSkJxclAvTWJlNGVXTmtFTmxp?=
 =?utf-8?B?aXRSVVNycUZWU1JpMUhINzF5eGtoSDRHN25seVpxUytLQlZZc1hORjdmUVJW?=
 =?utf-8?B?N29EajU3eERsOHorUGNtWDdxbmRJelJENEtxa1FITnRhYk11WDRrbEVISHRv?=
 =?utf-8?B?ZldIRGFaQVJFS04xZWF3dDN1SjFYWG9yWGdEZjE5T2k4d1N2c01lQ3ZhZGFj?=
 =?utf-8?B?UDN0ZzN3MVlveVdWWW9xeTVoQ3VxNzR1SUFXT1ZMQ2pGaHFRL2VvTW1rUjdY?=
 =?utf-8?B?Zlo0WE9UeWI2NjNGdlR3aWlHSWMwSVpuNXpmVDVuTEdoMWh4dHk5MktaeFgr?=
 =?utf-8?B?NmlhNlViMTZ5alFTVEZjSzJFajA1OUY1T2hEeVBhMUtNVlBoeTZ1Q0lialZE?=
 =?utf-8?B?WHJ3eHA3UWF0VlcxTEZYWDJpQzdGUHB0UEFmMDVmSmVSL2IwQ2VXUGlMSE1Y?=
 =?utf-8?B?RkgrWnNLNXhtcUp3aVhla0NPV1NsbDJ3S05aak1FcXZvN0c2aTl5Yk4wSWI4?=
 =?utf-8?B?MG96aVBJZ1F1QnFsdWVneHFyZ05ncGtGZVdyZ0gwSmI3clFJcUVlaVdZdGlU?=
 =?utf-8?B?eTROSmVZa3RsdEJHN3Eybm5MWXM0TE5RaDR3QUVGVEZPZmxCSnZLaVUxL2J2?=
 =?utf-8?B?UFVwY1JVNXdZald1eGIvWFdaV2RKRTV2aHlXSTFTKzYzREVXdUFST2JBK0Yr?=
 =?utf-8?B?N2Z3OUMybWhTYjdLTGhzZUY5NVNPcGR6OUdVUWtUSXA1YUt4bTYzV3ZKeGNT?=
 =?utf-8?B?djFwd0JvQ3o3ZFUxQlg1cG5sNUhhc0s0czZNZ3EwVVlNOXpCUHVjMmRFRjNH?=
 =?utf-8?B?MUFXeENIVnlGejVRR3JFUWMra1BsSVpHUUF4bTI4NitXRFdJTlcxdktKL3NR?=
 =?utf-8?B?RnI4TUVRa01HQUw2NmZPZTlyRSszT25Rb3pSWld5SmNxSjNpWW9XZ0JqdXFQ?=
 =?utf-8?B?bjZoZms5T2s3UENCNXE3MjFhTGVYblZYR1VSek5idzg4ck1DOWd4MUhaVUp6?=
 =?utf-8?B?LzlHem1rUktjYUJOdVZRUDMxdzZKQUZVUktDQlUwT1dreGNSdjJEUTNlSjBH?=
 =?utf-8?B?ajQrS0pwVEsvOWp5eWRYcFcxMFFTdFZJeVF1UWpIbFJwMUM5UUhIQ1pOSUo1?=
 =?utf-8?B?bGtucU4yb2MyelNGdno4QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzYvMjc2L1dneEMwWGFnNk1URFFxNktmSHZpdVp3S3hsNkFTaG1CUDQxZk1N?=
 =?utf-8?B?Q0xRVXFxVmxvbnBLaFQrSk0wcmJPVjFZOWtLQnJpcTFIU09wVEhndTc3YmVT?=
 =?utf-8?B?Z0xEa2VjOVB2di83UDlnU0grUFFpS0tRUmtzT2N3Wk9iMVlhdzVoenpzc3R4?=
 =?utf-8?B?cStVejZKRXdhandZTWxZM1pzZGQzNlRxSk94d2diZk5ZMHRkaUxrTENoK0Zi?=
 =?utf-8?B?eXk0RXlKdUlMdisyUmtXbmJVTjhYQ3dnSm00aHJmZUpNYW1rUmNHaC9hVE1i?=
 =?utf-8?B?TjFqcEo0M1UyVTgzdmIrRmFBc3VaZ2Z6Tk5jbGdSUkUzb3JWVm9EQ0sxM0pJ?=
 =?utf-8?B?ZHVDZkZjdU9SRm1rVjMxRzVJdWZjc1hIQTdZLzRyM1I1V0I3NWkrOGlZU3pM?=
 =?utf-8?B?Z1oyNC94NXdqT25GRkwveGM1OVBqcE5nMDNSVVQrQUh6Tk8xNUZidzNzODdK?=
 =?utf-8?B?amtIc2pyQXR2MURPNWN5c3NSY2RrNWU5S2dIekNjandUbkE4V0doeUhURFFj?=
 =?utf-8?B?aCtiM1krWFhLWHVsSjFRZVBMVXZ4NjMvSlhXSzN2TDZsbmEwTDk3SVlPSzN6?=
 =?utf-8?B?RzI5bHRNbGhuQ2NvNlZ3c2V5d3dPcHlkZExuMEU1YzdIcG4rN3hjdkdJZUJs?=
 =?utf-8?B?UUJXNThZeDJHdGIyUnJrOTV0TWFENmpiamMrQWxOVjNka2x0UnY5VmdIeTVH?=
 =?utf-8?B?djFBZ0NrY0NWSlo2R2F0OUptaVRsSmV4OG1oU2Y1K3N4STFMamg1TktyOFR1?=
 =?utf-8?B?L0Ivcm1CQlpVRzZ6Mk5QKy8xNFl4eVlLaDFHWG1SMmVKNEZ2dlFuVzY0N25W?=
 =?utf-8?B?aTlmOXpGYUczRzRMVnhOd29FV3dhR2dRZWZYblVXdWphSHZ0Q2ZLak5iajlN?=
 =?utf-8?B?bXAvWnNjQm83UTMwY1BRUUJERkNxa0MxY0Eva1NyYUhSOTZrRlhadWZzMktq?=
 =?utf-8?B?dXRFUnZjUU5HUE5jQVNVNmpETWk2Q3p3MnFTcVF4N3hNWlZHMWxsSjNlMit0?=
 =?utf-8?B?K3JGa0w3ditFelVFeXFtMlhTTHpTMjZQOExoeG9zRVBvMU56UkJJdlBrWDRj?=
 =?utf-8?B?V3o3bG4ra2lJS2h2aWtqQXhYTG9pRzZERGw3bGxxOXBCQXVzcjF5QU5WWTNK?=
 =?utf-8?B?d0lValdrQ1BzRXVrb1lia29vNXZzQ1AyYUNtbkxrYktjMHlIWEprd2Q1a2tN?=
 =?utf-8?B?UzFjTng2NEdielg0b1V1b29IQ082Ykh0Z1NEZ3FLQlM1emluOXUzcXRSWVZi?=
 =?utf-8?B?WjFQZTlQKzZoQWJVRkJtVWxQd3dkbHZOcHVQNXlvb05WQWVvd0ZMakVEdThm?=
 =?utf-8?B?eHM0WGRHaTZ5R09OZ0pabFdHVGZKK0NKRHNyVkJDZTExQ2orTVhsNHZXUjZB?=
 =?utf-8?B?a1VkNXpMM3ExZG9abHZpenkremVZR0ZiM2lDRFVuRm1YeGFkbDhXemRnSVJJ?=
 =?utf-8?B?c0RjZWhEblREZjg1WEYzekhIRVNxZzFPUWhLTXlqY01DN1A0dzQrd2pkUk1x?=
 =?utf-8?B?bjByTUsyTmlQOG9Mb1VybzVyd2RLZG9vbTVlKy9oeGU0NkNRSFpiVzRmMWt2?=
 =?utf-8?B?TFozWFREbEtTOFBacDFCaGNiOVhLYjNjVWxaZ3RQMjB3K2l5WGIvZ3NyQzJG?=
 =?utf-8?B?SEtUUHd5dHFjWFlGeFI0eEMvbEhaOU5aaWtZdDcrRzEyRG9MMmtRVm8yYkZB?=
 =?utf-8?B?NVYvM0dRelpJRVdITVF5ZmhJa2lpTFlHUXdYd0VFTnZVSFVFTWo0b2s5UmFK?=
 =?utf-8?B?VVI3NHJ6bzl4S09Xb3dRVGM0YlRUUkx6Q2VHUVAwVjFKWmJ4VVlITWdrd1Jx?=
 =?utf-8?B?Sjd5SnQzRUFuVFVNcWtzeFdSR0drUHdaRm1pSElLVDRxNS8xNHFEb0VpVmha?=
 =?utf-8?B?QnRDZTBxSXQ1d0FTem5NTEJhUVRuSW5XVTlKaXdmVTY5OVRmQmpCSThDV3o1?=
 =?utf-8?B?aU56RnNlOEE5aGI0MXhEajFDK1JtVzM0b2doNXFIRU5hNWh4cnp6blZqUU50?=
 =?utf-8?B?TExGRUlDcitGWTVjTGxkWnFrZjA1ckJiZlE1UHNpNC9ITGsxN29lWTdWZWQ1?=
 =?utf-8?B?cXp1VXRJVVYyUFdiaG0zdUFmUjIzbno3eTFEZG5HWUhyMmZ6Mzg5SFQ0MnNi?=
 =?utf-8?B?VVVlZjk2Q2lmamFwOE9keGFCNlVMMFFYb1FxWWNjcGtaQkx4ZjA2OTZmZmk3?=
 =?utf-8?Q?hR0G6n6PqPozXXE/OikZ3xA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4FCABD920AD434DB851C7A1DEFD2B56@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5215d5-ee5e-4420-59ff-08dc66128b35
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 17:01:41.0192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3ZPiCpQ5qra+6Ty3UsWN+1FGk3c4CEdxfSwTXl8mLfJk7/v+B5Bb5qak84VOkGfB2E/QjcfUQ23tPZJAEz5/l/+8aH6quJLIR9bxmokOW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8573
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTI2IGF0IDA5OjQ5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOgo+IAo+IEhlaCwgd2hlcmUncyB5b3VyIGJpdG1hc2sgYWJ1c2Ugc3Bpcml0P8KgIEl0J3Mg
YSBsaXR0bGUgZXZpbCAoYW5kIGJ5ICJldmlsIiBJCj4gbWVhbgo+IGF3ZXNvbWUpLCBidXQgdGhl
IG5lZWQgdG8gcHJvY2VzcyBkaWZmZXJlbnQgcm9vdHMgaXMgYW5vdGhlciBnb29kIGFyZ3VtZW50
IGZvcgo+IGFuCj4gZW51bStiaXRtYXNrLgoKSGFoYS4gVGhlcmUgc2VlbXMgdG8gYmUgc29tZSBz
cGVjaWFsIGxvdmUgZm9yIGJpdCBtYXRoIGluIEtWTS4gSSB3YXMganVzdApyZWxheWluZyBteSBz
dHJ1Z2dsZSB0byB1bmRlcnN0YW5kIHBlcm1pc3Npb25fZmF1bHQoKSB0aGUgb3RoZXIgZGF5LgoK
PiAKPiBlbnVtIHRkcF9tbXVfcm9vdF90eXBlcyB7Cj4gwqDCoMKgwqDCoMKgwqDCoEtWTV9TSEFS
RURfUk9PVFMgPSBLVk1fUFJPQ0VTU19TSEFSRUQsCj4gwqDCoMKgwqDCoMKgwqDCoEtWTV9QUklW
QVRFX1JPT1RTID0gS1ZNX1BST0NFU1NfUFJJVkFURSwKPiDCoMKgwqDCoMKgwqDCoMKgS1ZNX1ZB
TElEX1JPT1RTID0gQklUKDIpLAo+IMKgwqDCoMKgwqDCoMKgwqBLVk1fQU5ZX1ZBTElEX1JPT1Qg
PSBLVk1fU0hBUkVEX1JPT1QgfCBLVk1fUFJJVkFURV9ST09UIHwKPiBLVk1fVkFMSURfUk9PVCwK
PiDCoMKgwqDCoMKgwqDCoMKgS1ZNX0FOWV9ST09UID0gS1ZNX1NIQVJFRF9ST09UIHwgS1ZNX1BS
SVZBVEVfUk9PVCwKPiB9Cj4gc3RhdGljX2Fzc2VydCghKEtWTV9TSEFSRURfUk9PVFMgJiBLVk1f
VkFMSURfUk9PVFMpKTsKPiBzdGF0aWNfYXNzZXJ0KCEoS1ZNX1BSSVZBVEVfUk9PVFMgJiBLVk1f
VkFMSURfUk9PVFMpKTsKPiBzdGF0aWNfYXNzZXJ0KEtWTV9QUklWQVRFX1JPT1RTID09IChLVk1f
U0hBUkVEX1JPT1RTIDw8IDEpKTsKPiAKPiAvKgo+IMKgKiBSZXR1cm5zIHRoZSBuZXh0IHJvb3Qg
YWZ0ZXIgQHByZXZfcm9vdCAob3IgdGhlIGZpcnN0IHJvb3QgaWYgQHByZXZfcm9vdCBpcwo+IMKg
KiBOVUxMKS7CoCBBIHJlZmVyZW5jZSB0byB0aGUgcmV0dXJuZWQgcm9vdCBpcyBhY3F1aXJlZCwg
YW5kIHRoZSByZWZlcmVuY2UgdG8KPiDCoCogQHByZXZfcm9vdCBpcyByZWxlYXNlZCAodGhlIGNh
bGxlciBvYnZpb3VzbHkgbXVzdCBob2xkIGEgcmVmZXJlbmNlIHRvCj4gwqAqIEBwcmV2X3Jvb3Qg
aWYgaXQncyBub24tTlVMTCkuCj4gwqAqCj4gwqAqIFJldHVybnMgTlVMTCBpZiB0aGUgZW5kIG9m
IHRkcF9tbXVfcm9vdHMgd2FzIHJlYWNoZWQuCj4gwqAqLwo+IHN0YXRpYyBzdHJ1Y3Qga3ZtX21t
dV9wYWdlICp0ZHBfbW11X25leHRfcm9vdChzdHJ1Y3Qga3ZtICprdm0sCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnByZXZfcm9vdCwKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW51bSB0ZHBfbW11X3Jvb3RfdHlwZXMg
dHlwZXMpCj4gewo+IMKgwqDCoMKgwqDCoMKgwqBib29sIG9ubHlfdmFsaWQgPSB0eXBlcyAmIEtW
TV9WQUxJRF9ST09UUzsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGt2bV9tbXVfcGFnZSAqbmV4
dF9yb290Owo+IAo+IMKgwqDCoMKgwqDCoMKgwqAvKgo+IMKgwqDCoMKgwqDCoMKgwqAgKiBXaGls
ZSB0aGUgcm9vdHMgdGhlbXNlbHZlcyBhcmUgUkNVLXByb3RlY3RlZCwgZmllbGRzIHN1Y2ggYXMK
PiDCoMKgwqDCoMKgwqDCoMKgICogcm9sZS5pbnZhbGlkIGFyZSBwcm90ZWN0ZWQgYnkgbW11X2xv
Y2suCj4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+IMKgwqDCoMKgwqDCoMKgwqBsb2NrZGVwX2Fzc2Vy
dF9oZWxkKCZrdm0tPm1tdV9sb2NrKTsKPiAKPiDCoMKgwqDCoMKgwqDCoMKgcmN1X3JlYWRfbG9j
aygpOwo+IAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocHJldl9yb290KQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgbmV4dF9yb290ID0gbGlzdF9uZXh0X29yX251bGxfcmN1KCZrdm0t
PmFyY2gudGRwX21tdV9yb290cywKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAmcHJldl9yb290LT5saW5rLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHR5cGVvZigqcHJldl9yb290KSwgbGluayk7Cj4gwqDCoMKgwqDCoMKgwqDC
oGVsc2UKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5leHRfcm9vdCA9IGxpc3Rf
Zmlyc3Rfb3JfbnVsbF9yY3UoJmt2bS0+YXJjaC50ZHBfbW11X3Jvb3RzLAo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHlwZW9mKCpuZXh0X3Jvb3QpLCBsaW5r
KTsKPiAKPiDCoMKgwqDCoMKgwqDCoMKgd2hpbGUgKG5leHRfcm9vdCkgewo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCghb25seV92YWxpZCB8fCAhbmV4dF9yb290LT5yb2xl
LmludmFsaWQpICYmCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKHR5
cGVzICYgKEtWTV9TSEFSRURfUk9PVFMgPDwgaXNfcHJpdmF0ZV9zcChyb290KSkpICYmCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3RkcF9tbXVfZ2V0X3Jvb3Qo
bmV4dF9yb290KSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBicmVhazsKPiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5leHRfcm9v
dCA9IGxpc3RfbmV4dF9vcl9udWxsX3JjdSgma3ZtLT5hcmNoLnRkcF9tbXVfcm9vdHMsCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCZuZXh0X3Jvb3QtPmxpbmssIHR5cGVvZigqbmV4dF9yb290KSwgbGluayk7Cj4gwqDCoMKg
wqDCoMKgwqDCoH0KPiAKPiDCoMKgwqDCoMKgwqDCoMKgcmN1X3JlYWRfdW5sb2NrKCk7Cj4gCj4g
wqDCoMKgwqDCoMKgwqDCoGlmIChwcmV2X3Jvb3QpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBrdm1fdGRwX21tdV9wdXRfcm9vdChrdm0sIHByZXZfcm9vdCk7Cj4gCj4gwqDCoMKg
wqDCoMKgwqDCoHJldHVybiBuZXh0X3Jvb3Q7Cj4gfQo+IAo+ICNkZWZpbmUgX19mb3JfZWFjaF90
ZHBfbW11X3Jvb3RfeWllbGRfc2FmZShfa3ZtLCBfcm9vdCwgX2FzX2lkLAo+IF90eXBlcynCoMKg
wqDCoMKgwqDCoMKgwqBcCj4gwqDCoMKgwqDCoMKgwqDCoGZvciAoX3Jvb3QgPSB0ZHBfbW11X25l
eHRfcm9vdChfa3ZtLCBOVUxMLAo+IF90eXBlcyk7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgXAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoeyBsb2NrZGVwX2Fz
c2VydF9oZWxkKCYoX2t2bSktPm1tdV9sb2NrKTsgfSksCj4gX3Jvb3Q7wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoFwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX3Jvb3QgPSB0ZHBfbW11
X25leHRfcm9vdChfa3ZtLCBfcm9vdCwKPiBfdHlwZXMpKcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBcCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAo
X2FzX2lkID49IDAgJiYga3ZtX21tdV9wYWdlX2FzX2lkKF9yb290KSAhPSBfYXNfaWQpCj4ge8Kg
wqDCoMKgwqDCoMKgXAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlCj4g
Cj4gI2RlZmluZSBmb3JfZWFjaF92YWxpZF90ZHBfbW11X3Jvb3RfeWllbGRfc2FmZShfa3ZtLCBf
cm9vdCwKPiBfYXNfaWQpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gwqDCoMKgwqDCoMKg
wqDCoF9fZm9yX2VhY2hfdGRwX21tdV9yb290X3lpZWxkX3NhZmUoX2t2bSwgX3Jvb3QsIF9hc19p
ZCwKPiBLVk1fQU5ZX1ZBTElEX1JPT1QpCj4gCj4gI2RlZmluZSBmb3JfZWFjaF90ZHBfbW11X3Jv
b3RfeWllbGRfc2FmZShfa3ZtLAo+IF9yb290KcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiDCoMKgwqDCoMKgwqDCoMKgZm9yIChfcm9vdCA9
IHRkcF9tbXVfbmV4dF9yb290KF9rdm0sIE5VTEwsCj4gS1ZNX0FOWV9ST09UKTvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICh7IGxvY2tk
ZXBfYXNzZXJ0X2hlbGQoJihfa3ZtKS0+bW11X2xvY2spOyB9KSwKPiBfcm9vdDvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgXAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfcm9vdCA9IHRk
cF9tbXVfbmV4dF9yb290KF9rdm0sIF9yb290LCBLVk1fQU5ZX1JPT1QpKQoKT2hoLCB5ZXMgbW92
ZSBpdCBpbnRvIHRoZSBpdGVyYXRvcnMuIEkgbGlrZSBpdCBhIGxvdC4K

