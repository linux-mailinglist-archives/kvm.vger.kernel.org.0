Return-Path: <kvm+bounces-15420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F08E28ABCD9
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 21:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7CE62817EB
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 19:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8E53D96A;
	Sat, 20 Apr 2024 19:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZEgQRfe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218A52E3E8;
	Sat, 20 Apr 2024 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713639927; cv=fail; b=XT9bWPK7pIe9WtqnTwuNmrey8tytOr98yLhQYfmcI4A2bGLnUKs2tKR/fMFFtUkhp5LUJsefOCChSdJ8XU6rix9nKbnpW5hi+FN6ZxGvX1SHhQIWF2U2YywH2lMoz2GaaBNRmXFuUzSCCfKsj3qlFTMb8Nh48aBvhp7y7D0q9QI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713639927; c=relaxed/simple;
	bh=ZEvIiM13lRo5+QGZHR2HyPDML+tJHYO8BOjUZ8Ogc90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RI8ZgtDS7OyRufSVHTZ6A3KzyVOLZl0sBIHO3KzhOfQ7QLr23jQ2hiZmqFUib+ygjUKMTFujTIW4pCQ5ti7JWXkoJYSfMJLeiyHleVRcRtU4wa6hlInf5StR1GQpKc9YgwQRw3hPEcWjpV4/D4ajndpFEt7sb5LtXVtuy/lYSPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZEgQRfe; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713639925; x=1745175925;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZEvIiM13lRo5+QGZHR2HyPDML+tJHYO8BOjUZ8Ogc90=;
  b=kZEgQRfe5izhIF8KKmsE3IFRihL0X7h8ceDE3BS0k4jyPlm4ivjE2q/o
   U/c+bjOR0Ua4gTl5Y1EdyuJWEvT/EBtoD5aEuF7AOJ+vwglzSCgjwtUgK
   ymd5nraUo3Ew9WUt1pCMup5LGSmdTQ1Rp/QHw1p/LvGw6ZUTJC6ORaQ0P
   Gmw9iwU6DpfxM1F9qPXA5dH5XtOyHLuu89gQo0di3bNA7N/lEZQxooqem
   oTqaj1Rb5PLHZJFUuIQ1OBuaGjhAH2xIYcYGuXRxZtGRMR9V0xNpnmlCn
   D49BZSKFCU7puacZbJK8P0qqcOfGBani02dUs/qhGqMeOhgpYtLrnQnLF
   g==;
X-CSE-ConnectionGUID: zYxd/PijQ3C7/vAA6DfVBQ==
X-CSE-MsgGUID: YdvM/bdYTlWc/3MIVt6suA==
X-IronPort-AV: E=McAfee;i="6600,9927,11050"; a="13013532"
X-IronPort-AV: E=Sophos;i="6.07,217,1708416000"; 
   d="scan'208";a="13013532"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2024 12:05:24 -0700
X-CSE-ConnectionGUID: 4N2rU2R2RtyARZavbxphhQ==
X-CSE-MsgGUID: pM9RgNWhSWKfbwKU8m9D0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,217,1708416000"; 
   d="scan'208";a="28144454"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Apr 2024 12:05:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 20 Apr 2024 12:05:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 20 Apr 2024 12:05:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 20 Apr 2024 12:05:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 20 Apr 2024 12:05:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h67djTksYk18ny1DNHSGVN2ZRxofDOqlwAmiACcHh61Wm8YUiFV6CUh68rhEBeuWfFp/OgbQu0zheoTPg3VtOa0sBNh02vmz2rYRVDFYWR4Mk6OouJywASeaE9Iu+epjGu13apX1JPsit/Z8Y4exvuAES7p5bSUSSXIJMEwR58t8GdAmvrfEvXOLRqmbBt8Z+zwyjslMxd0pxVKaG1Wa4TxfwxvACJeDqAhZd71TR+gdrbf4A79iAJz1+okY4JbqYV5l+S77/y0fxZlMwcHN11HGl4l6JwufGIEOkh8GbLqdOJOHYudf/qYJ/MF89KjQsJ/MIFi3Ppc63lj/eUkP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEvIiM13lRo5+QGZHR2HyPDML+tJHYO8BOjUZ8Ogc90=;
 b=SanUrEMIulO7c/QKEfMNVjg1wCTekBwP3Jkih8vFhQKhsoGdaWR6X1hnpifY4VZOJkuhQ6oKqm19ti7Lh30NQn4HZbeKCS16dyUVBgWA1Vn6dsvXkbSlMDSS/Y+iAfHTO0q/yLb3GRuW0zg/B4/YyFD8dwnNoQE3nHOFqMmJHbnMaAVcAhJvPtYqRk4w75a4RwXgp6mFTYVLlwM2u2rE7kCbVW7OxPCM2w5/A6Ug0sPq4mrBAVhkYjzJ5zLKA1DdamD6f8ITgDuXy+XI8Q7Tk3rLFyU02yyjP8EGs6wISXkF343+3NPidWDTS/w1oukm7/AJm88dOiucA5MBsl+YbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6217.namprd11.prod.outlook.com (2603:10b6:208:3eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Sat, 20 Apr
 2024 19:05:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.015; Sat, 20 Apr 2024
 19:05:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Thread-Topic: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Thread-Index: AQHadnqoikf1/sFCe0+iZ0Ofp2o8ULFBW5gAgDBi0AA=
Date: Sat, 20 Apr 2024 19:05:19 +0000
Message-ID: <d394ad9e23cffcf1b06302b3f2d49410c326a4d4.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5d2307efb227b927cc9fa3e18787fde8e1cb13e2.1708933498.git.isaku.yamahata@intel.com>
	 <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>
In-Reply-To: <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6217:EE_
x-ms-office365-filtering-correlation-id: 9ae25d11-8e0b-488b-5f9d-08dc616cd280
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?VkNOYmpVODlIbE5BVzNqTUtDdnBEZm1jVEpGSXI0S2hYN2ZvdXJZL1dIYW1u?=
 =?utf-8?B?MDJDd0d5aU91bksvK01kcXVmTWYydGU2cVBDUlJVZkxTVnFzQVRBb2k1c0pt?=
 =?utf-8?B?Nkt0bUNsTzN1czcxbXFKTmFna1pKQlBZY0lFOGtVL1FkdTZvS0FCYjhiYTV6?=
 =?utf-8?B?VUsxVTZGODJXek14V3Y3d2FYQjVyQ21lYitHY0xCVHZmdXhPcXdPMG5vTWpu?=
 =?utf-8?B?bGpTalVvdzRWK2M0ZFNzdTdxamJjcjBiTmVVdjlSOUJJTkFzZFNMMEM3UTds?=
 =?utf-8?B?RjZ4K0t0clF2cHNrTlBacmxxZjk5a3Vmd05ueWN4bmI5L1dyNkdKYnFrY0Nr?=
 =?utf-8?B?SmRRUCsvK2ppOWllbnYydkFjdXlIV08xa3NYRm9nNjQ1TVRIenV3Y2RzZzlR?=
 =?utf-8?B?Q0Fva3AxazRiMDkvdzNaOFNJeko4NlcybW5aVURET3JsbkpEZDdjN2pLSnBQ?=
 =?utf-8?B?dnhWcDNTU21ETnRwSWVtd0YwMG16a3IrUGFjTjA4elpmWklkTGxrYTdLSU1m?=
 =?utf-8?B?WkpuajFCdmVkT0lJVlpvN2VleUNiRnE3NkZUTlZrbWRQdnRDQVpXUFk4Qkx1?=
 =?utf-8?B?bWVYdUZTV3J0QTNTRGhNRFB0MDNxS2NRaGRHNFhLVGtvQjVBR3Vydk9QUGFG?=
 =?utf-8?B?YTJMRzBLMFg2bmkxa3QyU3EvZDY2V0wrWW1ObGQrall4dWVSVE1yQWJkaldn?=
 =?utf-8?B?bXhvS016QnovdldHOEV6QVhDVEp6cFdyNTRTNG1YZ29Xanp3R3JoYjU5T0Z5?=
 =?utf-8?B?RVVkdEdjVEZvSHFMMnNGTFRrL3dJZzVXdktsVzJ5RUQxdzEwWHlpZTBuN2pj?=
 =?utf-8?B?UmN6R1B4NVc3eVBBL3JaWUUxR1NPa2NTMyt6bU9QOGRRSjNRZmxQV05aamtP?=
 =?utf-8?B?Q1FKWGpvOFA1Um9lL1B1dVV1QjlBZzM5eVQ0cFNSeGd1Z2JQL3VsbkZvMmFs?=
 =?utf-8?B?NVNYRlMxaWhnSGY4ZnEzRHRqNks2aW1DemJyVCtsZjkzbmZlWEN1OVRUbXkx?=
 =?utf-8?B?MmlNYk5kR2graGUvSnlLVDJKcEY1WmFUR3dueDBYaXpnTlpTc2lLbG9RVHpX?=
 =?utf-8?B?cmo0K2EwSStGa2FRTUtiYXdSMGhXVWNQYWVCa3lyWi9wRWpUckxsY1M0Z3kx?=
 =?utf-8?B?SnRWQ0p1emFReXY5dTBUNng4aEU0SGt0cVJPVEF1Q0NabHdtSldaZkZkU3hM?=
 =?utf-8?B?MzRNZTBKZjlhK3UrbG1ZSURaMFJIUWt4R09aaE52VWR3cWhWenJsVmlnb3ZS?=
 =?utf-8?B?YUZzbGlWWTViTUt6R3lqWnlYM1FabVp5QUhoVFIxS2xNaXFzeXpGMk1BNWJw?=
 =?utf-8?B?KzFNQ0RSMXFPTUZ0ak0xRXRaVUJ6aU15MEhONnU4Q0pLZ1FyZVRTaUt6eTQ5?=
 =?utf-8?B?a0dyY0dsUjZUUDZLWmlkL3RNeE11NjgranI3cUprM242QWx5VVpJZGc5Q3lr?=
 =?utf-8?B?Qzhxa0UvZGM1SWFRVUI0ZE1Zb2Y0SDFTcmVWOGlHcjh5ZHM1V2VuclVSdHBM?=
 =?utf-8?B?cWxyMElnQVhVdis1eGFraWtGbkszYXpLNi9Va25rOEpjRnZnWjRxMEExM2xs?=
 =?utf-8?B?VDhIQVRONWxnRFljVWNtYXdxSFhzWnI3ZDFtQXJNUHI3ZHEyY21Ed2wxTnJY?=
 =?utf-8?B?VlhhSFVrN0pwdXJ2elA5TXpvYWlIU1NhWDJEem42dWc0SG5pYll1cDhjRERw?=
 =?utf-8?B?cEUrUFZFYWtCZ3l4MFQvek9jWHpseC9ydDI4amtMNlp4em1vWVRaalNNN3Iv?=
 =?utf-8?B?Q2p5V0hQZHRQWjBhcitiVFE3cDFHcVRQYmlON3FpR1FEUmdndDVYVHJ4SHZJ?=
 =?utf-8?B?aExUNWsrSEhITUlPSk9ndz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGRDaGtrbGNtRXlEajdaRTlXQTA2R0FqVW9xZU5kVWp0VWJIQ3kvVzEwYVMv?=
 =?utf-8?B?dDlJenBJdDlKemhNM1ZFVlppTS8weUlGWXltNWFqbDVEK2RnUDdLa2tXYTd4?=
 =?utf-8?B?MDJYVU9qb2QyMit6QjJuSE1ZRlRKOS9WQk9TMEpxeFJZbURxeHowQ2tZelF4?=
 =?utf-8?B?empDSTZLVk5ETEJWYW9SSzFvYTF5bHVLVEQ0alkwMVNLekp4cGNPRERpRFhO?=
 =?utf-8?B?eW5MOFJpQllVdEZXcXJsanBIYmhRcS9vWCtZOGRtSG5hbVNBNmdSWG0wbG5a?=
 =?utf-8?B?Mnkwc3Zyd1FGWFdSakxUVUIyZi9yM0pLTmlBVGxXeTlnaFdNYTgrOVdET0l4?=
 =?utf-8?B?V0E2N3ZsNkdpMXpCb1pDS3NvajVMWnBGMFJQbjlOMDNiMHdWOUdvRmxPVkx5?=
 =?utf-8?B?TExEL2FsaTNhTUdJelFLcC9JVURyZWczNUJlbHZJZC9hZmtKdFhVRE9YaE0r?=
 =?utf-8?B?YVlDNW5rRGtFVjM2UGlhcTgzTDZvSzcvZWkzbzVsRlhBZjZQMVZ1WGhnTmtr?=
 =?utf-8?B?ZG85NjZ2dTQrMHRweHc4cy92dFNLeGttdmcrZk5zVHh0VHdGZWZpUEpiTjRC?=
 =?utf-8?B?bE01YWJoUEczVDBzNWI1cFN6bERzUE5LL2ExYmtHaTB3cU5PZXFjMDEya0dC?=
 =?utf-8?B?NDlvT1F1Q3RDRW5xYVl2V1pNY0tzQ3JNek1wdFBQQ1RPNitnTy9aaU9qTUhy?=
 =?utf-8?B?VXQ4dTYvS2NPVmtnM094WmNqQmFmMndaVUtvaCtSMXBiYWEydXpXNjY0cEdv?=
 =?utf-8?B?TVBKcXB1Q2Z3TzJYTU01cHFKSW5KT25xU1FPTUtxdUhua0xwTUVRRFpQOG10?=
 =?utf-8?B?eWpNTk5HVUlYR09aZmZDVnBwUGZTeFFjdTJ4YW1aSnNBcUpZN0pKNEp6RkpK?=
 =?utf-8?B?QUo0MVE4bHFCT3ZhdUdmYm84TjI5VmR3ZGJCcnR4Sk5FTnBSZ0RsM2tsVysr?=
 =?utf-8?B?SkFrV2pwaHppYU5CQ2NiZUdrNmNXU2VVcHVxUWdjeWxKZVZycDc0ZUVDbG9U?=
 =?utf-8?B?MnBhdzZVbnpVeUh3MXlOTm11TTZKeE9RSW9qejViY0FXUk9idlZLelF0czZw?=
 =?utf-8?B?TENDT3BqWTlQR3lMK0NNT0NsdXpXbGNRR296Yy9LUTJTZHFiclpQejZGOUVh?=
 =?utf-8?B?YU0xRFdnSzVyN1NyZXhlZEVhRkN3TzN3bFVGWmRPVk0wYVVuQ1B0RWI1eHUv?=
 =?utf-8?B?MXh2YkFudGJSYjRVSlZPNDF4Zlh5ZHJLbHlhaTBPNmowUWt1amh3YlYvWkNY?=
 =?utf-8?B?QjhzVE94UWZNM3BTTGNZRUtZbzFlTnhpUEhOTHpaUmxRYlViZU90VE4rT3di?=
 =?utf-8?B?SnZ1Z0NKcmFnOEt6WFJyWFZieVZJMjE1NVRLVEdSeGNvQks5OTNQY0pxV081?=
 =?utf-8?B?VndGaUltU0QrL3YwaElyb1lwejk4NnhtUHBqZHhEcDh2VTczYVduK0lrR1JH?=
 =?utf-8?B?a1EzMVN1dGhMYm5OZGJsSzk2QlNFb2tPek44amhFMzBmWGFCc3lnV0F3a1Mv?=
 =?utf-8?B?L1VpVHR0SGpQN1M3clM5Sjh3QUs5RUlWeXd6Vzh6ZWI3WHRWd1hXQ2ZJVURL?=
 =?utf-8?B?N0liNFczMHdoK0JQM2JZT2c3YkIxbm1tUXlkZjl6UGlGMjJQZHE5dlBtSlVR?=
 =?utf-8?B?NXVnWFJ5UXMzVHprL0JGV0lBaDFpU1RSMFNPR09FQzh3dEV3RlhBTTlJMTFx?=
 =?utf-8?B?ZFVtdDdPUDJkdXhXZGtnQllRTFJBYy80U3NTYnNhREg3VDMweVNiQU8zVUZL?=
 =?utf-8?B?TitSMXQ5SlViMW4yQzFzU0FIeTVhcVMrUzFta0pxaXF0RE52NU1ueGtmaHFu?=
 =?utf-8?B?V253S2RjR08vdzBFOExZUG5va2wwcWJ1OVpDYmpxV0tYclpwUUN5ZStlYXNB?=
 =?utf-8?B?ZmJNSVpGWFhvZ1diNG9iL3ZUeUpCdERTY2s4d0VvWjc0cVVuOUI0Ym5tRFJP?=
 =?utf-8?B?cUwvOFkyWmNNOUpEY0IrWWZFWUlLemNvVU02R3docTdyTlNoTUdXczJhSkNk?=
 =?utf-8?B?WkNjcVdFbUxnK2Q0UGFzanE2M0ZrNG1ORDN5Y1B3YTRhUUtBY1lBVGxrdGp1?=
 =?utf-8?B?MHAzQ0R6NmdnbUR3UlBuLzhqdHBUcXYzZGVsaTJhdG41VFhCVTk1VUpvVGN1?=
 =?utf-8?B?RUlmU2lEc2RIbTlKTGdwQ0FzSGl0azI1dVRESFc2OGsrYkF2b0owMkpHdU5u?=
 =?utf-8?Q?js15oCemoTGTb671oHKnvJo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24E6914553805F4DA8E8FC86319969ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae25d11-8e0b-488b-5f9d-08dc616cd280
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2024 19:05:19.5607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8CIwN0SSfErrQAkUo8F3PrT7TO+cgdY11D0Sagn7Ozt7Sb81Qg5I4ISxzaWLXLWehUpfzA+Nm97JGN2NPZf00x/ubSCj82T/DxYpoFqZdLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6217
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTIwIGF0IDE3OjExIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gQEAgLTEzNzgsNiArMTM3NSw4IEBAIGludCBrdm1fdGRwX21tdV9tYXAoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCBzdHJ1Y3QNCj4ga3ZtX3BhZ2VfZmF1bHQgKmZhdWx0KQ0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIG5lZWRzIHRvIGJlIHNwbGl0Lg0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc3AgPSB0ZHBfbW11X2FsbG9jX3NwKHZjcHUpOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoIShyYXdfZ2ZuICYga3ZtX2dmbl9zaGFyZWRfbWFzayhrdm0pKSkNCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9tbXVfYWxsb2Nf
cHJpdmF0ZV9zcHQodmNwdSwgc3ApOw0KDQpUaGlzIHdpbGwgdHJ5IHRvIGFsbG9jYXRlIHRoZSBw
cml2YXRlIFNQIGZvciBub3JtYWwgVk1zICh3aGljaCBoYXZlIGEgemVybw0Kc2hhcmVkIG1hc2sp
LCBpdCBzaG91bGQgYmU6DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUu
YyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQppbmRleCBlZmVkNzA1ODA5MjIuLjU4NWM4
MGZiNjJjNSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQorKysgYi9h
cmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KQEAgLTEzNTAsNyArMTM1MCw3IEBAIGludCBrdm1f
dGRwX21tdV9tYXAoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QNCmt2bV9wYWdlX2ZhdWx0
ICpmYXVsdCkNCiAgICAgICAgICAgICAgICAgKiBuZWVkcyB0byBiZSBzcGxpdC4NCiAgICAgICAg
ICAgICAgICAgKi8NCiAgICAgICAgICAgICAgICBzcCA9IHRkcF9tbXVfYWxsb2Nfc3AodmNwdSk7
DQotICAgICAgICAgICAgICAgaWYgKCEocmF3X2dmbiAmIGt2bV9nZm5fc2hhcmVkX21hc2soa3Zt
KSkpDQorICAgICAgICAgICAgICAgaWYgKGt2bV9pc19wcml2YXRlX2dwYShrdm0sIHJhd19nZm4g
PDwgUEFHRV9TSElGVCkpDQogICAgICAgICAgICAgICAgICAgICAgICBrdm1fbW11X2FsbG9jX3By
aXZhdGVfc3B0KHZjcHUsIHNwKTsNCiAgICAgICAgICAgICAgICB0ZHBfbW11X2luaXRfY2hpbGRf
c3Aoc3AsICZpdGVyKTsNCg0K

