Return-Path: <kvm+bounces-17825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D068CA66F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 04:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71D521C212C0
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178A517548;
	Tue, 21 May 2024 02:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iLcrIQCD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62B2CA40;
	Tue, 21 May 2024 02:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716260241; cv=fail; b=eQxe6q7LVZLG38Bp5VuEbiv5Pg7ZwtZ2wiKiDbBjNn9aFoWol7cH5JDaNMgGsiPzT4pCX47th3WyNsxIu2wP2G7zIjCR8kbeuw43DES1YLc/o6rofPBeEdEUB0C4YLk/d5sV8D14HI8+qYePXiaQqvhbBEhu/TqoQGVq1ntZNOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716260241; c=relaxed/simple;
	bh=TwEsWGvyrQ9cqXDJ2dAsMxB1lstVrqRLb2qhlAbbSB4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=COJLUDywWmWs1VYORv8ghUDlpwno4olIWxsVCIEVGtMyoFasyYn2y51wSO43AeQEItffWz4pLGZYSZ0NmkK/I4mCrDtbU9JEGlWwueZZXcd7qr1BK9yO6ZwB4eRWXeqjdTbfdljJRaozLrCBNBylYo+WljKBK4sW+nU4tjurWRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iLcrIQCD; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716260240; x=1747796240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TwEsWGvyrQ9cqXDJ2dAsMxB1lstVrqRLb2qhlAbbSB4=;
  b=iLcrIQCD8oVP+HJPHZAmiEhFhjnWipTAkvco2/G1bWJlRBkwvH8EhW+Y
   XROLgLoth8PgBKrVxRlFL2Z+UzXU1SB0j3KyGJ2Ah2s/biHeLO3MqyrBM
   b7yMfQTq51bneqU6Jj1RKQBN2U4NgF+hZ+mIPksrM+QfReIaJd/zoOhqQ
   cpOhVhHIDE/4lzb3SPAPZRmdMfOFFMMue4gPXj2yXvDaJ7QONAu8yVaVI
   nIhyagbfpaHOs06xCEMI5ELUwB+L8FutkQmBDJqjYSMc4JxPnQm7Lqrvd
   rhii/U3XsVeNMD7cLiUEyB9pEDTa+cDyiSTjKDFOmpFwhRUi3zfekM0dz
   A==;
X-CSE-ConnectionGUID: 5vUzofs3R9O0oIEl6yj3Ag==
X-CSE-MsgGUID: Ds/3B2eOTLO71Ke383223Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12542579"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12542579"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 19:57:19 -0700
X-CSE-ConnectionGUID: 7t71rG0hRqaCttVlLw+kiA==
X-CSE-MsgGUID: FC1thGHuSwut79CudgFIFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32621359"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 19:57:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 19:57:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 19:57:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 19:57:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 19:57:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZICFj+/GRd/RXafh02XovIlLdgc01o9K8iu6zhMcKVOchMHQ1H5grePM7Xj0dcweDGZYqWs2TyW28I08ktZ9vLR8qHwNuQJQTW2NQpWVMmtAjUN/doEwmnXzlafiyRl1su7wedlEZxxUt5CVaKRmfNfSxWS7S2UpCfkfWXW0v9EQFpT8pTD1le7cObaMv8SJEWnOOW+/BiI4BPC+zNUdkJlhvxdktshLAuCO/UiNx0sx/U31+5rL+FqLk/vkjHL3LD17Yq6OBxWDCTFnuWGJlDDsamqBLHcUMLM8ID/uOFYNK2Dx+InrDFIkapsXyPsuTVUcsz7FkAv/C5eQ5JhJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwEsWGvyrQ9cqXDJ2dAsMxB1lstVrqRLb2qhlAbbSB4=;
 b=OTjPWoWiJu3KWmgwslH2v7R81XlfCRLJ0oQKfeZsJmdf5Y+VW2jHZxhep4+iLR0VeBHCa9zWV+UhHZpBQZQSBwJNqNLy857ZLN2Lpu8id4yhx8Vf1LaeYApqvmtC4eOHth110p3AORESHhzE3ryM0xjhl0z9/KMQ/S2KlNqUodMiafYJrg80puUgFtOTgjOl1dZF8rTOTszuu9n98i8+9zS01MOvif8m+B2BqQe53Lpa1cuoovJqSvALSojN1i3G3oT/A+Q7ntksLSkzpe9ZYq43+is8TfC3P/64yrNRJzc6FM6sejYFTaF+YvNtEcb2R7n9AZOA2Q70GuKIcpMEbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7031.namprd11.prod.outlook.com (2603:10b6:303:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 02:57:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.030; Tue, 21 May 2024
 02:57:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABz1ICAAF5sAIABZ7wAgACnZ4CAAtAtAIAAi4KAgAABJACAAE1QgIAALmKAgAAI/IA=
Date: Tue, 21 May 2024 02:57:15 +0000
Message-ID: <c155b1ee39618c0da5fee3efd05b417e690776f3.camel@intel.com>
References: <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
	 <20240517081440.GM168153@ls.amr.corp.intel.com>
	 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
	 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
	 <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
	 <20240520185817.GA22775@ls.amr.corp.intel.com>
	 <91444be8576ac220fb66cd8546697912988c4a87.camel@intel.com>
	 <2ee12c152c8db9f5e4acd131b95411bac0abb22c.camel@intel.com>
	 <20240521022505.GB29916@ls.amr.corp.intel.com>
In-Reply-To: <20240521022505.GB29916@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7031:EE_
x-ms-office365-filtering-correlation-id: 8f42d592-2485-4814-5188-08dc7941b8b8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Q0Exc2ZLTHBXT21Ma0t3bVZsbmtodTNDWS9FMVNma0FkaHMvcHZxcnJPR1Rn?=
 =?utf-8?B?dkVFNW1aeE9uK01UQzFLSnA3N1V1eDF0S3duMGJuMTkxM3JtbGZhY1QzTENJ?=
 =?utf-8?B?SU9SSVpSbDJDL29VbmpGMlJDVU9ubTFscERqclpDZkdYVU1wOGlKT0I1WDVM?=
 =?utf-8?B?MjNMdjFyNGZjYnM2aldVK3BsTGF6eHltNUlLUUtTaC8ya2dLL05NaC9QSWRV?=
 =?utf-8?B?aFV4a1JzOFNRZ2ZudXU1eGlpbm9IR1lCLzYzcUp1cmNoZTNiN1h3KzZ4V1JD?=
 =?utf-8?B?YjlPNUZaZVlGamkvdkNZanhWWlJnV1kzVVgzVUYwcmROWHBLSGVUL3ZER1VY?=
 =?utf-8?B?TTN4VDdmVGNXQlQraGdPZ2dWK0JBUWpxWlZycyt6U2doTGQwUnJvbC93K05r?=
 =?utf-8?B?M1UyVHE4TTBwNDIrc3ByUzFISlVtemptSlNOUWdHanVtU1BkcHBJd2hDRFlX?=
 =?utf-8?B?K28zRzJBU2pUZnFSVlJxVWVCbVRielB1dUZwVTR4bUR1YXJwekVPSG4rMUxi?=
 =?utf-8?B?NkdKY3RnQkdHVXZMU1ZMMW80OHQzelY4cTA4OUt3cm5zYzVEM1pZbThlMjN1?=
 =?utf-8?B?ZFNwSUNVQTdZNU9PK1dIK3JydGlYT2l2NE5UTXVIdDdBcjRna1pLeXpJdEdm?=
 =?utf-8?B?YTlDS09XdTBDSnNjZjR0bWo4eVVPaHcrN2tpUXdmYW94K2RaMkUxc2pPNG9p?=
 =?utf-8?B?Z0l0emo3M1BoVzZmZnJQTUVLNTRTdTEvVFQ2YWdQNTh4UmVBL0dTNHY2eFp0?=
 =?utf-8?B?SVhtMXNIblQ4bng1YXRaNm0reEkwN1k0a1kxMDBhQUlhQ0lIOG1sbkg1OGIw?=
 =?utf-8?B?TW9mQnpZRGtxaldsUnVPOVFNc3RZL3d3RHdwTmpvWVZFWmFYYTlHM3VaTGtO?=
 =?utf-8?B?TVB5RjVSakJ6bS9kdWtlck1Pbm9uUjZPS2Rxc291ZStkNWZuYVZjWEVJM1hj?=
 =?utf-8?B?Z0tRN0VSb2MxcnkrVGhZWStEOTFLOHhHVDRoa25sV0JOaEIybmFPRGllek9v?=
 =?utf-8?B?NUJUWnB3NEZVbUFLRlhtd1d0eTF2WjlZWFBUamFxcFBlclg1eEhZblZZTmo1?=
 =?utf-8?B?WHNzQW1XN0d5aS9RdnZpczlGZk4xZml6OUZzVG40VHRIY3hWOWtRM001NUxS?=
 =?utf-8?B?dGJ5aDNjV1Q3dlhncmtXU0FJNmYvbUtrTkxxTzdGN29RcHhQdjhqSlZQYXc4?=
 =?utf-8?B?ckFGVFd1dmxxdHdwSjZpN2t3TDhvUWJPZE5mb2xwTGJ4SmQ5cmt3c01OdnBM?=
 =?utf-8?B?VWErTjZvelYwSys4Q0FGSVdhaXpTRnVRK1dVNkFOamF2V0hzNTRmczJiazdj?=
 =?utf-8?B?eVlZck9jd0VKb0ZrY2pwL1Jlcjk2aEprU3JFL24zTTR2Y2FsZUR4cHI2cm9S?=
 =?utf-8?B?NWhQR2l2dkhxR2UvNWg5Q1o0eDh0aEoxeUE4c1I2NVFialdJbHZzOFVaU0RZ?=
 =?utf-8?B?ajBaN2FjblhrT2hiZlAzbXVDNng5aTdMYlo5UTNkaHVHdEdJR1JJd2JwWnNU?=
 =?utf-8?B?UngvbnN2Qjh2Ny9TS3hMa3ZVL0Fpbnd5ZWU0LzBsaThsSVB1MDdqVjFsV044?=
 =?utf-8?B?VFZTVzdON1RQcGE3WUNaOGV6aFhLaDlWOTYvNUFNcER0WTJxdkcxc094NGJp?=
 =?utf-8?B?bm5lTkJDZHNrY3hsSTJTSzRRRE1QWDFna3JRUnBlaXJHQ2VhZFdmbVZOOGQ4?=
 =?utf-8?B?U1RjYTRTM2JPd21Ib2hhZ0VIZ05ieFhRYlZFMjM3NDRPRG1TUjE1RFQ3NmpG?=
 =?utf-8?B?Nnh5WE9aM3F0SWFYYktSbTB4M0h3WE5jb3dIb0o0K25OOHhmSTcyMnRQRDRz?=
 =?utf-8?B?MktxbTJwUzk0R1V2aEFvQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzlMcDdiNW4zR2lVS21XdHJBdWVudWtJeDFsZ0FPSXh4VVdWd1R4dDBNanNi?=
 =?utf-8?B?SVpHM1o5M2xTa2ZmQ0JnR2szVjViRlhYSXA4VFJudTRYd1BZeThzYlR6Rk5p?=
 =?utf-8?B?Tk9qOHRQOWNydzJFTnB0ZEpieW9MNU9nQ01JcjlRK3NQRjZiVlcvWE9lQ0FJ?=
 =?utf-8?B?TUdPL0dJRVFZRnlYYzJZUXczNFFMbTJSczRBdzRIc0pzSzFuQUJUd0NoVzdB?=
 =?utf-8?B?c0lsQTZGeEtqWWNzL05VdXJkcEpLN2VJUkdYdGhIWUQ4TUhENTYvV0NmQnlu?=
 =?utf-8?B?MjZaQXlpekoxTDVmZ2Z1NGk1VllhamFhZmZyVWJHVjlxZDlTVmdESi9DS3M3?=
 =?utf-8?B?VlROV0hUQUJneFpkUFlXL3hqdW1EZG85cWxCZ3N3aUZzeHVtbDROdm12U3l1?=
 =?utf-8?B?bFJ6Wm5nWFpGUWZqS2hWOEJTemVFQlRmSmd5eUd1NGRDdVNySEs5R1JRajA3?=
 =?utf-8?B?NjNGcE9kWldaZ0RkN1VRNTFyYVBYSTl3MHNrL1JwQmJlbGRvR21LUjlhNGVk?=
 =?utf-8?B?YldJYitMZmtjRnFyeFpDdDl4Nkp3MkREUzZJVTcrY09kYVJ3VjJsTEdBV0Zv?=
 =?utf-8?B?Z0ZNSXROOThIZE9QU2FyWXNrdkIwZlVPVUhpcDk3eTUwUWcxVmNIczNKVSsz?=
 =?utf-8?B?L1d6UTkxbVhoc2tVR1BJMUt6ODZWRi9kU1hYNnBwNlRFK2F2enY2YWdOOTh1?=
 =?utf-8?B?cHQyVnNSK1oyTUpCZEJ2OFdEKzBBS0p5VFcrMkp3QmtoMWxNd21tb3VQdWoz?=
 =?utf-8?B?VCtvQ0NKNmxzaU5LQ1d2L3ZTdm1PMWhRTmNVam9zUXpUTXQ5dkFCK20xV1Ix?=
 =?utf-8?B?bElibS9wL0xSZjhkRjBoOE41dWJHWlRaaitLREtYYVFOcERqTHZnaHZyQ0Rk?=
 =?utf-8?B?ZXl0V0t3bmgyaWJNUzRoN00vcE5ZU2p2SjlKejI5NXhSa2ZWcE5qNVUzTGkr?=
 =?utf-8?B?RkhGeHpySjFpRWdjOGFEYnM5VE5Tb2VNWFp3TXFoeFpxMXNjOUtpaDZYcWNW?=
 =?utf-8?B?eTFxam5DTGtKMmhnZXZwb0c1YXpYbXM2cjJwSWVVVnVjSmhXWnNPUEZRYkpM?=
 =?utf-8?B?dHhNbHBLQ3RKK1pLb2dOcnh2amdwQ0Q1VWcxS2NMY0RHUFN4QzdCb0NjSXpP?=
 =?utf-8?B?MVpOOW8xN0VKeHF2eGNFcktkZlB5LzRlbkxRbU44QlU5TWpBaXRzMTRiZ3JC?=
 =?utf-8?B?YUdrWUY1K0NsdjkxMlArSHkzbWVDWGVWT3FXdlhScVV5cmdJenhXOU0rV1FP?=
 =?utf-8?B?aUl0cTNLMko1enJTTnRSWkwxRkt0aUhvellUVUVqaWZFdENuY0NMUllTYXpH?=
 =?utf-8?B?QWpZSGxGUlliSE9Cek95ekhnM2FUMVJra1JTZEROSmpQcExGaEVkYjRKeDFs?=
 =?utf-8?B?bnJ1c21HcE91RU90YUxLL2dKT0pkemJtVmdmelpTMzNJL3E5V1djM1lPYStF?=
 =?utf-8?B?Z21oSWdrRkVBMkxXUXlJK3JhM3Y4dWptY3g1Tlk2R1JldHpsM3pOSmJWSlVL?=
 =?utf-8?B?bS9mb0FwUHZHdDFES3Z4U0V3Z3EzdncyOUNtbmo4ZkFESDV4Qk9vQS9xSitH?=
 =?utf-8?B?MXRIazNvZWZaTUMxazV0MFMxZTdvaWZ4bytCY3J5TEthSW03bWVlc2pGSEw3?=
 =?utf-8?B?RFg1aVBFWS9zK0RwcXU1d0JNYzdIZXJjaHBJbE5UQlpqZVhBa2U0K3Ivd0Q0?=
 =?utf-8?B?U01kRWx1enhrSi8zS1BGZjVTNXgwdHdYTjRaMm9qY09QTjJjdmVwdy9kRzFU?=
 =?utf-8?B?WjlKTExFNlFEUDBHaHJaeTVlcTBtM0NzZ0hYK3I3YVlvMXU5Z01GZDNSTVN0?=
 =?utf-8?B?TlZIYVNIRHdZalNmVHBiS0xmaGF6ZUdkSXZoeXg2U1VQNjVBZEJUSDBXK1Vj?=
 =?utf-8?B?N1c5UFhWOE1XU3AyN1ZMcnhRZzFNS2p1eDk0dGphVldSRVFxQ0YvdFVQV09O?=
 =?utf-8?B?dGd5Ylo5cHZnVWRhd1V2bHVRUHJGcWpkTlJhRUJxaWlES1FqTkZnVFR0WkFF?=
 =?utf-8?B?dkpxMU0vemhTUE81MzZwVzF1dWpkRC9yK2FoSHdneGNUcHQ3eFh2SzQ5Vk5E?=
 =?utf-8?B?ZUoyL1Jxd3NpQkU3amg3bENxTnNwZjZ2RjJZMi9JTTFWejhqUlF4WWFoOVdl?=
 =?utf-8?B?alR6eG5kekJTNlZFQkhyalRDMEk4eG80RzlNR1l3NThyM3RmQkhtMjI0MlVm?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2281309858C2BC4EBE6EC809295BFBFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f42d592-2485-4814-5188-08dc7941b8b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2024 02:57:15.8570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wj8DcCoptXz/1h0quMNSGp7eIKnUphhRdGSzeXfqff7RyQ7+M8DuDFCULN+Rzuw7Vg6eRbazmK/BisU8ZzR6nKIRGoX1eaC+CxExtjugQys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7031
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTIwIGF0IDE5OjI1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBNYXkgMjAsIDIwMjQgYXQgMTE6Mzk6MDZQTSArMDAwMCwNCj4gIkVkZ2Vjb21i
ZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBP
biBNb24sIDIwMjQtMDUtMjAgYXQgMTI6MDIgLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0K
PiA+IEluIHRoaXMgc29sdXRpb24sIHRoZSB0ZHBfbW11LmMgZG9lc24ndCBoYXZlIGEgY29uY2Vw
dCBvZiBwcml2YXRlIHZzIHNoYXJlZA0KPiA+IEVQVA0KPiA+IG9yIEdQQSBhbGlhc2VzLiBJdCBq
dXN0IGtub3dzIEtWTV9QUk9DRVNTX1BSSVZBVEUvU0hBUkVELCBhbmQgZmF1bHQtDQo+ID4gPmlz
X3ByaXZhdGUuDQo+ID4gDQo+ID4gQmFzZWQgb24gdGhlIFBST0NFU1MgZW51bXMgb3IgZmF1bHQt
PmlzX3ByaXZhdGUsIGhlbHBlcnMgaW4gbW11LmgNCj4gPiBlbmNhcHN1bGF0ZQ0KPiA+IHdoZXRo
ZXIgdG8gb3BlcmF0ZSBvbiB0aGUgbm9ybWFsICJkaXJlY3QiIHJvb3RzIG9yIHRoZSBtaXJyb3Jl
ZCByb290cy4gV2hlbg0KPiA+ICFURFgsIGl0IGFsd2F5cyBvcGVyYXRlcyBvbiBkaXJlY3QuDQo+
ID4gDQo+ID4gVGhlIGNvZGUgdGhhdCBkb2VzIFBURSBzZXR0aW5nL3phcHBpbmcgZXRjLCBjYWxs
cyBvdXQgdGhlIG1pcnJvcmVkICJyZWZsZWN0Ig0KPiA+IGhlbHBlciBhbmQgZG9lcyB0aGUgZXh0
cmEgYXRvbWljaXR5IHN0dWZmIHdoZW4gaXQgc2VlcyB0aGUgbWlycm9yZWQgcm9sZQ0KPiA+IGJp
dC4NCj4gPiANCj4gPiBJbiBJc2FrdSdzIGNvZGUgdG8gbWFrZSBnZm4ncyBuZXZlciBoYXZlIHNo
YXJlZCBiaXRzLCB0aGVyZSB3YXMgc3RpbGwgdGhlDQo+ID4gY29uY2VwdCBvZiAic2hhcmVkIiBp
biB0aGUgVERQIE1NVS4gQnV0IG5vdyBzaW5jZSB0aGUgVERQIE1NVSBmb2N1c2VzIG9uDQo+ID4g
bWlycm9yZWQgdnMgZGlyZWN0IGluc3RlYWQsIGFuIGFic3RyYWN0aW9uIGlzIGludHJvZHVjZWQg
dG8ganVzdCBhc2sgZm9yIHRoZQ0KPiA+IG1hc2sgZm9yIHRoZSByb290LiBGb3IgVERYIHRoZSBk
aXJlY3Qgcm9vdCBpcyBmb3Igc2hhcmVkIG1lbW9yeSwgc28gaW5zdGVhZA0KPiA+IHRoZQ0KPiA+
IGt2bV9nZm5fZGlyZWN0X21hc2soKSBnZXRzIGFwcGxpZWQgd2hlbiBvcGVyYXRpbmcgb24gdGhl
IGRpcmVjdCByb290Lg0KPiANCj4gImRpcmVjdCIgaXMgYmV0dGVyIHRoYW4gInNoYXJlZCIuwqAg
SXQgbWlnaHQgYmUgY29uZnVzaW5nIHdpdGggdGhlIGV4aXN0aW5nDQo+IHJvbGUuZGlyZWN0LCBi
dXQgSSBkb24ndCB0aGluayBvZiBiZXR0ZXIgb3RoZXIgbmFtZS4NCg0KWWVhLCBkaXJlY3QgaXMg
a2luZCBvZiBvdmVybG9hZGVkLiBCdXQgaXQgYWN0dWFsbHkgaXMgImRpcmVjdCIgaW4gdGhlDQpy
b2xlLmRpcmVjdCBzZW5zZSBhdCBsZWFzdC4NCg0KPiANCj4gSSByZXNvcnRlZCB0byBwYXNzIGFy
b3VuZCBrdm0gZm9yIGdmbl9kaXJlY3RfbWFzayB0byB0aGUgaXRlcmF0b3IuwqANCj4gQWx0ZXJu
YXRpdmUNCj4gd2F5IGlzIHRvIHN0YXNoIGl0IGluIHN0cnVjdCBrdm1fbW11X3BhZ2Ugb2Ygcm9v
dCBzb21laG93LsKgIFRoZW4sIHdlIGNhbiBzdHJpcA0KPiBrdm0gZnJvbSB0aGUgaXRlcmF0b3Ig
YW5kIHRoZSByZWxhdGVkIG1hY3Jvcy4NCg0KSXQgc2VlbXMgbGlrZSBpdCB3b3VsZCB1c2UgdG9v
IG11Y2ggbWVtb3J5LiBMb29raW5nIHVwIHRoZSBtYXNrIG9uY2UgcGVyDQppdGVyYXRpb24gZG9l
c24ndCBzZWVtIHRvbyB0ZXJyaWJsZSB0byBtZS4NCg0KPiANCj4gDQo+ID4gSSB0aGluayB0aGVy
ZSBhcmUgc3RpbGwgc29tZSB0aGluZ3MgdG8gYmUgcG9saXNoZWQgaW4gdGhlIGJyYW5jaCwgYnV0
DQo+ID4gb3ZlcmFsbCBpdA0KPiA+IGRvZXMgYSBnb29kIGpvYiBvZiBjbGVhbmluZyB1cCB0aGUg
Y29uZnVzaW9uIGFib3V0IHRoZSBjb25uZWN0aW9uIGJldHdlZW4NCj4gPiBwcml2YXRlIGFuZCBt
aXJyb3JlZC4gQW5kIGFsc28gYmV0d2VlbiB0aGlzIGFuZCB0aGUgcHJldmlvdXMgY2hhbmdlcywN
Cj4gPiBpbXByb3Zlcw0KPiA+IGxpdHRlcmluZyB0aGUgZ2VuZXJpYyBNTVUgY29kZSB3aXRoIHBy
aXZhdGUvc2hhcmVkIGFsaWFzIGNvbmNlcHRzLg0KPiA+IA0KPiA+IEF0IHRoZSBzYW1lIHRpbWUs
IEkgdGhpbmsgdGhlIGFic3RyYWN0aW9ucyBoYXZlIGEgc21hbGwgY29zdCBpbiBjbGFyaXR5IGlm
DQo+ID4geW91DQo+ID4gYXJlIGxvb2tpbmcgYXQgdGhlIGNvZGUgZnJvbSBURFgncyBwZXJzcGVj
dGl2ZS4gSXQgcHJvYmFibHkgd29udCByYWlzZSBhbnkNCj4gPiBleWVicm93cyBmb3IgcGVvcGxl
IHVzZWQgdG8gdHJhY2luZyBuZXN0ZWQgRVBUIHZpb2xhdGlvbnMgdGhyb3VnaA0KPiA+IHBhZ2lu
Z190bXBsLmguDQo+ID4gQnV0IGNvbXBhcmVkIHRvIG5hbWluZyBldmVyeXRoaW5nIG1pcnJvcmVk
X3ByaXZhdGUsIHRoZXJlIGlzIG1vcmUNCj4gPiBvYmZ1c2NhdGlvbiBvZg0KPiA+IHRoZSBiaXRz
IHR3aWRkbGVkLg0KPiANCj4gVGhlIHJlbmFtZSBtYWtlcyB0aGUgY29kZSBtdWNoIGxlc3MgY29u
ZnVzaW5nLsKgIEkgbm90aWNlZCB0aGF0IG1pcnJvciBhbmQNCj4gbWlycm9yZWQgYXJlIG1peGVk
LiBJJ20gbm90IHN1cmUgd2hldGhlciBpdCdzIGludGVudGlvbmFsIG9yIGFjY2lkZW50YWwuDQoN
CldlIG5lZWQgYSBiZXR0ZXIgbmFtZSBmb3Igc3AtPm1pcnJvcmVkX3NwdCBhbmQgcmVsYXRlZCBm
dW5jdGlvbnMuIEl0IGlzIG5vdCB0aGUNCm1pcnJvciBwYWdlIHRhYmxlLCBpdCdzIHRoZSBhY3R1
YWwgcGFnZSB0YWJsZSB0aGF0IGlzIGdldHRpbmcgbWlycm9yZWQNCg0KSXQgd291bGQgYmUgbmlj
ZSB0byBoYXZlIGEgZ29vZCBnZW5lcmljIG5hbWUgKG5vdCBwcml2YXRlKSBmb3Igd2hhdCB0aGUg
bWlycm9yZWQNCnBhZ2UgdGFibGVzIGFyZSBtaXJyb3JpbmcuIE1pcnJvciB2cyBtaXJyb3JlZCBp
cyB0b28gY2xvc2UsIGJ1dCBJIGNvdWxkbid0IHRoaW5rDQpvZiBhbnl0aGluZy4gUmVmbGVjdCBv
bmx5IHNlZW1zIHRvIGZpdCBhcyBhIHZlcmIuDQoNCg0KQW5vdGhlciBuaWNlIHRoaW5nIGFib3V0
IHRoaXMgc2VwYXJhdGlvbiwgSSB0aGluayB3ZSBjYW4gYnJlYWsgdGhlIGJpZyBwYXRjaA0KYXBh
cnQgYSBiaXQuIEkgdGhpbmsgbWF5YmUgSSdsbCBzdGFydCByZS1hcnJhbmdpbmcgdGhpbmdzIGlu
dG8gcGF0Y2hlcy4gVW5sZXNzDQp0aGVyZSBpcyBhbnkgb2JqZWN0aW9uIHRvIHRoZSB3aG9sZSBk
aXJlY3Rpb24uIEthaT8NCg==

