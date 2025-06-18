Return-Path: <kvm+bounces-49783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73694ADE007
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 02:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E57BE7AC843
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 00:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6734F13C918;
	Wed, 18 Jun 2025 00:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a6jOLLxD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C775A932;
	Wed, 18 Jun 2025 00:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206873; cv=fail; b=eugO+sbm0+CdpcjTdN6fYgVKXuBibkJsGTGvyOlC5Wk4rilDVULFPfHvnnMNqUqsx5sc0ZNUjCKRl/gX9A33B6cLtu2U5jlSwYHvYdT1/F4Ju0LfsVUaHJ3NMcVEqoCZ9+jqAcSzwM0ys8+GPKt28cONEKoFjNry6t/FP6CvuKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206873; c=relaxed/simple;
	bh=cGL9o7oXks0yXVe+tiel51yIrvFW/VmCbVbLh/joGuA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OoBbnPqCAEndiBiCJAk3oUH810BdvAr+VJMV6Gb2zjIMKiAPfWU3gclqAq8DJ046ipWNss9QDKiRY2atfwcBo7IZywKW2Xzodkorb9TFwxkHJoofX1rfIGA2EN327WvHneGzgBbWHfOYyc54Wlj/pUvMwgIWkxMRkfxHygeFkes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a6jOLLxD; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750206872; x=1781742872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cGL9o7oXks0yXVe+tiel51yIrvFW/VmCbVbLh/joGuA=;
  b=a6jOLLxDnrSyES8ICKgl/CH/CHTUaoB6kvDynspJHab3J6AuEqPirCxx
   HDL56yVuGMjvkCN7OEftZVYoVQdmivQLr3SDXUQ717V/ZO8m9ih/EgTb4
   IQ1FGgSPS0mRzOc546xFYcg7/YFHXlo5UWaKYg+NmQohErTTAWC9hs3r1
   G33Cp3UopPGjS3klT1A5ErS0R+Kg5EuzBNCjhjVDIt9XA6g8Xq+pt5faK
   m2R0RR8CvRhmpzLIUdv8JDqwZWKXaKHHmMebTlyLIDfrr1eJd6ZUqu1Ba
   cm0qMp9sr4t+6d75dQVrZN0GNClPi5L71fVwfw5GNxJWhUEuL+8KU5arc
   Q==;
X-CSE-ConnectionGUID: mnf4v8VfR3+WmQIGZz/ATA==
X-CSE-MsgGUID: dqOJOpNxTk2RrkclIgubvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="62683887"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="62683887"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:34:31 -0700
X-CSE-ConnectionGUID: sunHvRWqQFu5YUhcsbw0Pw==
X-CSE-MsgGUID: fzzgTtXIRvK8Cqu6+Ou9zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="148885839"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:34:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:34:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 17:34:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.68)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:34:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QSIYAgm/L3GgmTph3tY/02oKbzXGQGwd/fgldTzJcW/tw4fPKyeiDxxWXVCjIZjPrMfX8jsDDrTb2kcuNoKnFucnygPKteWk3HSuRehJgVliO/XamSDgOYQSxlg7HClJhYzvGE1NA9qlYXGK0tV4IFVsjhw9OwXgQDu8aFsH3yU5xKJvz6CDpEq0AT66mBh6EKgK3S9FFgrcQduVgfCBS+PbFgBAA2GR0Hw9Oh8GXnCV9dJTNVA3sH1V3wrV4+5U9ZzPYQnvNY6cLr6jus4k4h4nMfhZNq1yvQDs9YISPDyrU01BvQqs68ZHLGovlefWkOLoR0uWZLgNGVaN8T1xow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGL9o7oXks0yXVe+tiel51yIrvFW/VmCbVbLh/joGuA=;
 b=ZFNmwSbddL3ioi0m70LANQOawwKoOi95Hhmi9QsWjRjSaPkDoe3olFdUMKxtMvXv2oQ7IElnSM4Y2oDpEZZubDP2B66OzzP59Aw3Bn+S8sknJSn5F1jeGsCzDL0r3lM0S182MOGJKj5oWNsGnax8tBLLWWHQkqvdoCQehFQ62l28U82Ou0M1jMbqyq2ERaYeRWTv+QO/G5nVwCZPsk06wPOEp+vlXiWSBCZTM/13KpFuBjCXfCYR2PQMtZcSaczJYAyl1KyCdQ1Ge4kjHlKZVkGvh9Fa5m2C0WrGLuoBP8M9izqb7yyFOVSC3RnyFCJ2Wy50Ln+ZxghqoZjTNe3s+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL4PR11MB8800.namprd11.prod.outlook.com (2603:10b6:208:5a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 00:34:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Wed, 18 Jun 2025
 00:34:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIABK6CAgAAyp4CAABVEgIABE0sA
Date: Wed, 18 Jun 2025 00:34:24 +0000
Message-ID: <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
	 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
	 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
In-Reply-To: <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL4PR11MB8800:EE_
x-ms-office365-filtering-correlation-id: 760c100f-d7f8-41f9-1a51-08ddadffe063
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SUJ6c2dIL0Q3NzZJdGVlQ2c2VmV0Z2tEK0F4bDl5RDY2cTRxbHJiOWlYRUFp?=
 =?utf-8?B?RHdwcDBjdWpzK2VETnRxNEExWDV1WkMzUjlsRlJyazlwWlRaMGs3cnJicjd0?=
 =?utf-8?B?TzdqRzRPaFMzc0svcTNCQXo3WEZ5Ti9BZDBhdkNWQUYrOXNDaXcxS3VpaThR?=
 =?utf-8?B?VEJOOGtGNmNycFZyYzdLNXlMS2dlcGZBUVU4NXE3dnRUR2MzWjNnYWMzVisx?=
 =?utf-8?B?ZmhHTUVQMGNvMmUxY21UR25KV3MzYjdhOTdYdkU2R0FPbFV0Z1NQYTkwbXJj?=
 =?utf-8?B?cURobDd4T0NyWlBrU1BUb1BqMDAvVmg3eCtETWNMYTJJVW50V3BXUW4zWG5a?=
 =?utf-8?B?TGRWY01NL2ZHOTFuK0FycnRIR01zUnFWNFBqWFlJUGZEWmw5bkVsTjdVVC9l?=
 =?utf-8?B?bTlldVhJOGVacnl2dXlFMHUxNzhncVpHTGJ1cThkTk9vQWJxemlDZnc1M0FJ?=
 =?utf-8?B?cFlwWkI3REw3T1ZYUjNCLzFWOG5Pa3JSV2hsU1ZjOEtlQ3VTakhQVDd5ckJS?=
 =?utf-8?B?elkxcnVaaXBzY3g5S2M0aXpKUklIaTVnN2xVOWRXU2ZNU280MnRTaXNiZWhN?=
 =?utf-8?B?cWpwZ0tXS0RlMEExVTcvNllSOVpDVjAyZHlDUmg5Vmt0Q1RlWUdER25ydHU4?=
 =?utf-8?B?RzNDVjlqKzJYV3cvTlpYdXlHc1kydkpqbzUrTFEvOUo2MG9tcjRMOWMvM29X?=
 =?utf-8?B?aklrSmtIVnQ5dkR4NDBXYlVyTFBlV0d2U3dIZU9ZeksxZUp3K3cvRmo5TFBG?=
 =?utf-8?B?R0QzN01POGZhVWMzVkl2aEkwc3A0MGh2d2NINHVNbk1MOC9KemI2SXBUZ1Ft?=
 =?utf-8?B?ZmNLdjZSdkJ3L2tFanhNbElmMzg0cm4yTFBMRTdtbkdBdVkzZ05CRFB2RCtS?=
 =?utf-8?B?QVpTbldJbHZob2FpZHZLWlNmRkVUa3ZBeEh5RXBKc3lNbDk0V1hUdStCR3FF?=
 =?utf-8?B?eFpkR0QwSkFqMkNRcm0zUlVTVjBoMjVrU3RKaHJBK2ZFbldNazFsbEl0R1Yw?=
 =?utf-8?B?YzBsNHpqRHRTR2tyOWpxZWJPem5GMTRTTjhwRzJoVGU3dVBabkVMaWE0eitD?=
 =?utf-8?B?bUIycG52bmVFVVlNaCtFSE85V3RzNmJYeGRoTjlVd0dRNDFOWDVXRlZLdUdJ?=
 =?utf-8?B?ZmUvWGErdTRsWXZtaUJ0elFPMlFZaUJudlNxUXFwNUJlOGZIRnNUeVJkdFpN?=
 =?utf-8?B?UFdxenRtSVFtM1VlQk1xS2Y2TDQxVnU1OGdGODZ6SzRFQjRXbjVwMnEybHhY?=
 =?utf-8?B?NzY3U0NCd2l3M3dMdXFRWCtZOXMrY2lOU1Nydm9mTTdoNzF2R2dndU9HTnZh?=
 =?utf-8?B?OVQ3b0REUGhJbTdSdDd0YzlLL21UZ09xUWlMcXdOK2lvMjloQ016RUw3enVz?=
 =?utf-8?B?aytkUU00SkhjR3plcHNwVHE4eVU4amttTkF2ZkQxNXUyODFhV2orTC80aldH?=
 =?utf-8?B?aFkyV01vN01XTmp5akpIVFVaTHhLanQxZWkyMm4vajNKellqOXc1RFRucThx?=
 =?utf-8?B?dkx1Y3NRSWd3R2ZYOGU3NE1sMExEMFdPQjFjalB3MytCTWNnRnR2d3phS2d4?=
 =?utf-8?B?TWx3THVVZXBBK3NYVmJKOWFxMFJTUktHbHMrN3h0TjZTTCtiWit0Zjg5MzNJ?=
 =?utf-8?B?eERWVFFlOEtSZUdoc1Y1MEVWT2UzdnNPSVVTbjhjT0h2a1RTZmErKzNZWTAy?=
 =?utf-8?B?c29wUU5kcHptOERkRzloUlMveDY3bWt6UmViWlljNXV3dTZBSm15dkJtMnpj?=
 =?utf-8?B?NDBBYUJ0TzJDUzBndytrU1V5NVl2dFk2bUhqWEdnMXpCa2N4Mzg4cVVFVUJR?=
 =?utf-8?B?K3NnVGgyM2VQNGY3ME9iZ25LS2IvaDJvRW9oTmxrQUpGc2JwditOdklkSjRW?=
 =?utf-8?B?cXFlNys0WXJTUzdsRlRSMDJxK2lqb2JLYjJ2U2YvekFQV1A1Sm5HK21GNC9u?=
 =?utf-8?B?aXNyaER5NnoxaXNZanlVRDNoNXpnbkh6UmlVTFJld3l3ZGRLelhqenpHcFYy?=
 =?utf-8?Q?6rAAiAP1mkpguc3iveMKBwoBu+1Auc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rmw5VndFbFp6d1hHQzJMQkRlaWJ1VEMyTFJKTmpST1l6dDkxYnBYL2FjNHR3?=
 =?utf-8?B?TUZDSlFOalpqdWtnSjdvOVB4UVcyT0lKeU5qZlkrVDlxTDYxckdMQkRqNXhI?=
 =?utf-8?B?NzVaaGhZaHg1M1FPZkUvbFY4dTlsRmlUNVZqWGdvcVJObDRQRWpqeTlhd1FL?=
 =?utf-8?B?RTFLVVlvV0J1ZFlpQnQ5ZW05MER5d0RJOTZwUWp3L1Zlcng5SERSK0VVWVI3?=
 =?utf-8?B?ZG5mTDdHQ2MreFlMN0ovbFpFSTBXbFIybENnNTl0R0s2WHlhdkVjWnV4aTd0?=
 =?utf-8?B?WWw1WFVsZFd5L01uNWs4LzJvc09FZ2RaMjl5di9sZ1QzZjAwYVdRYXA3c0gx?=
 =?utf-8?B?VDlvUG53dERwc3Nxay81WThlTnpHQzYvVm5nNzRJSXJaakhoTS9uUEdYeEs3?=
 =?utf-8?B?djRVN0hXNmVkSzFZK1pZR1hidGZIWnVpWlRXOWtDUmJkZ2dMejNJaDM4aEVr?=
 =?utf-8?B?akJsSDg0bG03NjVROHBwOWJnN2M5UDk1bmh4UG8yWFkwSXJrMitrSkFOMXhz?=
 =?utf-8?B?UEF4YUZSM3FzV2pFS09VdDI3V09pNms5L3gxbEdKWURDcmV5aVB0M1FXbVJw?=
 =?utf-8?B?WGh6eDlaZkdjUEJzeHAzWnp0by9IYW5WL0RTM2c2WktxdVpYdnU3K0JJVUFi?=
 =?utf-8?B?VWdITHlORUdEUXNITVo5aldWUCtCaHhYVDV3TXNvcnJidG9NdlQrNVFHRkRV?=
 =?utf-8?B?bXFPazQzZ2k1c0xEUG5VMkZqWHdZelJnRXkzRGQvY1Q5eVZDclVYNjBRNlo1?=
 =?utf-8?B?SngzL2phcTlYUDJtdmFWVWxySGRpdWx3bEg5dXJBdTYvRnB4OGRnc1V1RGhQ?=
 =?utf-8?B?bEs1WWsvVHVGTnFCdGxJOERENTlITG9jdE1yODlEM0xLazRiT3oyU0xQVkFx?=
 =?utf-8?B?U04wcXJZbzI0ejVUbndWQmU1Tit4L2RkaFpjaDFUZ0NZb1BUa0FJSGhzbGFC?=
 =?utf-8?B?SGV1QXdONVhqaTFRNU9JdktmT2pEclVaUXl5aWFRKzd3d3BmbWl3azBKUXZu?=
 =?utf-8?B?enArYkJHQmJwQkRTUDRaeWozSUpRV2w4YzlFS0FpcTlnY1lxZjY4RGlTb212?=
 =?utf-8?B?VVdjQzRzSVkzWWhBRjZwc09iTHhKcFAwVkpZbVUySCtaSkxuQTN6amc2T3F1?=
 =?utf-8?B?Z0xxeksybTRHQ1NCbWNCVThKaGtuK2lYWFMrdStaOUgzSFJIR3QvT2RoYmhy?=
 =?utf-8?B?TEE5bWduVXRPUWdOMzc1cE9KbFdkMlhPUTBLMDFoVkFaeVBRVVB1OFJvbU1H?=
 =?utf-8?B?Vml4bmNyVEVQRGFNQm1TZlJoZEtrMy8raUxZdjdaZmNrMXdUekNVcFZ5dldM?=
 =?utf-8?B?Mk1wa3hFZC90blFFNXFMNXJad1JQRytLb041ZjQ2VmsyRG50dFQ2RWVJcnVa?=
 =?utf-8?B?VC9pNWFrRzZsZWJLYldsK01jMWpHMlBBYjVqSG5xdkY1NzJZdmx1STB4WG8r?=
 =?utf-8?B?R0pFVGY0YW9RRFdzSmoxUWlkT0ptcFdNTG1SV2g1S2ZxK2hjdFB0elRKTEpL?=
 =?utf-8?B?cXo5dlpRREdSTk0zSEkyY0tDQzJhNG1Ma21vRk1wMlV5c3gyN2o2dnl3Ui91?=
 =?utf-8?B?T29pR3N0UmEzNFRnV3M0Z0lKQ25FeXcvM0xBVWNZTVZRK2dPU2pvT1dsWi9E?=
 =?utf-8?B?ekJ6enlYMS9ZZXBKbVNkN0VuNlFROHF2c0pndGtzL080SFh1UmFFV05TT0pF?=
 =?utf-8?B?SFdIcVQxWkJoUkIrNE5VelBIZkZwQ2M5WVk0Mlh2Z0RQcGhMNzFYMWN4dkpH?=
 =?utf-8?B?eERVWktCclNxR20zMjAzeFpKZUNuOWNoYitsNDNUc3dJdHRvTmJpNldiMW9l?=
 =?utf-8?B?VkRHYWd3dVZIRnZnNWlZeFF4OSs0Rm9vYXNUZkM1V214RVhxY0ZVZjVhejJE?=
 =?utf-8?B?YVBpTjJXb0VjQ3RlRnhWclpvVmNndER2UFhwY3ROMTViS0d4OVJmQlkwa1ZN?=
 =?utf-8?B?dElhUWlvQmdVcTkvMER6VDFBbFo2eTBsdmtsUVUyZ3FmY29lZy9yak9OdmZq?=
 =?utf-8?B?UUk2cHlsU0p6NEFIeWx5aTl1eXBOenE5bHJYcnUyam81aHNLaXpPRlZQZXlY?=
 =?utf-8?B?Y3lrZmVWV0dJVmRRaWlvNENpdFNwSTFWWE5mM0RZaFR0NWVpb3hnRWtwZC9U?=
 =?utf-8?B?SzcybGQwVk5IWVN5Mi9QY2F5TllxS09wTXNaQ1BydWVrMXhpdnQ0d2xLakwr?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED48E9EFD9E37D49934A461F31E4B25C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760c100f-d7f8-41f9-1a51-08ddadffe063
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 00:34:24.9033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mg2eylrkxgnNWwJ0/Op2Iopc/1mEAFXqcLaXv0Zy5Xgl3kj5g8P0pIgxZvnM5DVgVUrlRnr9yrEbs9VELKr2kXgvgg818RDm8wizDx+vrN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8800
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDAxOjA5IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBTb3JyeSBJIHF1b3RlZCBBY2tlcmxleSdzIHJlc3BvbnNlIHdyb25nbHkuIEhlcmUgaXMg
dGhlIGNvcnJlY3QgcmVmZXJlbmNlIFsxXS4NCg0KSSdtIGNvbmZ1c2VkLi4uDQoNCj4gDQo+IFNw
ZWN1bGF0aXZlL3RyYW5zaWVudCByZWZjb3VudHMgY2FtZSB1cCBhIGZldyB0aW1lcyBJbiB0aGUg
Y29udGV4dCBvZg0KPiBndWVzdF9tZW1mZCBkaXNjdXNzaW9ucywgc29tZSBleGFtcGxlcyBpbmNs
dWRlOiBwYWdldGFibGUgd2Fsa2VycywNCj4gcGFnZSBtaWdyYXRpb24sIHNwZWN1bGF0aXZlIHBh
Z2VjYWNoZSBsb29rdXBzLCBHVVAtZmFzdCBldGMuIERhdmlkIEgNCj4gY2FuIHByb3ZpZGUgbW9y
ZSBjb250ZXh0IGhlcmUgYXMgbmVlZGVkLg0KPiANCj4gRWZmZWN0aXZlbHkgc29tZSBjb3JlLW1t
IGZlYXR1cmVzIHRoYXQgYXJlIHByZXNlbnQgdG9kYXkgb3IgbWlnaHQgbGFuZA0KPiBpbiB0aGUg
ZnV0dXJlIGNhbiBjYXVzZSBmb2xpbyByZWZjb3VudHMgdG8gYmUgZ3JhYmJlZCBmb3Igc2hvcnQN
Cj4gZHVyYXRpb25zIHdpdGhvdXQgYWN0dWFsIGFjY2VzcyB0byB1bmRlcmx5aW5nIHBoeXNpY2Fs
IG1lbW9yeS4gVGhlc2UNCj4gc2NlbmFyaW9zIGFyZSB1bmxpa2VseSB0byBoYXBwZW4gZm9yIHBy
aXZhdGUgbWVtb3J5IGJ1dCBjYW4ndCBiZQ0KPiBkaXNjb3VudGVkIGNvbXBsZXRlbHkuDQoNClRo
aXMgbWVhbnMgdGhlIHJlZmNvdW50IGNvdWxkIGJlIGluY3JlYXNlZCBmb3Igb3RoZXIgcmVhc29u
cywgYW5kIHNvIGd1ZXN0bWVtZmQNCnNob3VsZG4ndCByZWx5IG9uIHJlZmNvdW50cyBmb3IgaXQn
cyBwdXJwb3Nlcz8gU28sIGl0IGlzIG5vdCBhIHByb2JsZW0gZm9yIG90aGVyDQpjb21wb25lbnRz
IGhhbmRsaW5nIHRoZSBwYWdlIGVsZXZhdGUgdGhlIHJlZmNvdW50Pw0KDQo+IA0KPiBBbm90aGVy
IHJlYXNvbiB0byBhdm9pZCByZWx5aW5nIG9uIHJlZmNvdW50cyBpcyB0byBub3QgYmxvY2sgdXNh
Z2Ugb2YNCj4gcmF3IHBoeXNpY2FsIG1lbW9yeSB1bm1hbmFnZWQgYnkga2VybmVsICh3aXRob3V0
IHBhZ2Ugc3RydWN0cykgdG8gYmFjaw0KPiBndWVzdCBwcml2YXRlIG1lbW9yeSBhcyB3ZSBoYWQg
ZGlzY3Vzc2VkIHByZXZpb3VzbHkuIFRoaXMgd2lsbCBoZWxwDQo+IHNpbXBsaWZ5IG1lcmdlL3Nw
bGl0IG9wZXJhdGlvbnMgZHVyaW5nIGNvbnZlcnNpb25zIGFuZCBoZWxwIHVzZWNhc2VzDQo+IGxp
a2UgZ3Vlc3QgbWVtb3J5IHBlcnNpc3RlbmNlIFsyXSBhbmQgbm9uLWNvbmZpZGVudGlhbCBWTXMu
DQoNCklmIHRoaXMgYmVjb21lcyBhIHRoaW5nIGZvciBwcml2YXRlIG1lbW9yeSAod2hpY2ggaXQg
aXNuJ3QgeWV0KSwgdGhlbiBjb3VsZG4ndA0Kd2UganVzdCBjaGFuZ2UgdGhpbmdzIGF0IHRoYXQg
cG9pbnQ/DQoNCklzIHRoZSBvbmx5IGlzc3VlIHdpdGggVERYIHRha2luZyByZWZjb3VudHMgdGhh
dCBpdCB3b24ndCB3b3JrIHdpdGggZnV0dXJlIGNvZGUNCmNoYW5nZXM/DQoNCj4gDQo+IFsxXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2RpcXo3YzJscjZ3Zy5mc2ZAYWNrZXJsZXl0bmct
Y3RvcC5jLmdvb2dsZXJzLmNvbS8NCj4gWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwv
MjAyNDA4MDUwOTMyNDUuODg5MzU3LTEtamdvd2Fuc0BhbWF6b24uY29tLw0KDQo=

