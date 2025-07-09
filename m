Return-Path: <kvm+bounces-51876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1A46AFDFB4
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BD2B1C24AA3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C99C26A1D9;
	Wed,  9 Jul 2025 05:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8IjYE8D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB371EEA40
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 05:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752040466; cv=fail; b=iSEUFVBog3SPF3XORNqWu0Y0cldQ+FdhPgU5KSNTCXQldS7gYw8YZapMATfOEi+vQnMcK/W/jncrgBzDopWv8DB8DGFUxpVekhIXftdrb29W6NhnP+MpEefsi/gri71ofVe2MPmFVFjBh6uBUSxDbASoy0BJ/Io1BOQmjNriMvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752040466; c=relaxed/simple;
	bh=JNIJz2RMtNlAae98flzualrULG3XFnGsOqM+p2SjkEU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VC9SI2cWnlrHxoXERfG05DCyJBBC1vbzkNI1eqqMDzh/xxrWxHDL75oTBUFvW18V2ugpU/D1+jRIr5usu+rjdUWImqNYfWNZT3ZkLPob/JjFZDxQm7ANmq7wG2Bqnil+gUegK7nlIe3yD67qkIn37rCQoY48ESUmsbpWBgZ0+Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8IjYE8D; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752040465; x=1783576465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JNIJz2RMtNlAae98flzualrULG3XFnGsOqM+p2SjkEU=;
  b=L8IjYE8DT0JCdlihXamlH79+ACkRlzqR9U/axJr5QPdkERNlUW4XVSR0
   M6xiUuU6RHlvIvDBMN1tevOkLCv+RqXzhkDsLhOBkrfgZghHggJykbVAX
   55BMFuhuMvyLx6Y+EioIopuzZerhoyd26uFyMCS+QM2O6c6jm295nkTnE
   qUMRgPDJSb3sQpji4JUrDCUgqqv7jeusVwCskLDdWHqgZzkpeKWvfNmDF
   /HXs3kjQu4VrzTgvqZ1PYEPKa1wQTRoICLrenThNg0vFxuM4HnA/bsd8b
   QuofUPSvZ8CbT5mbAJ9S4Ky9UzmVnyXS3o2UZIrSmjd85Zv+M7RTER8LQ
   g==;
X-CSE-ConnectionGUID: 63iBe7BDRcegHRaHzaxTxw==
X-CSE-MsgGUID: N3PEedliRTataMzfi6qJ4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54421513"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54421513"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:54:23 -0700
X-CSE-ConnectionGUID: LYAYzMmAQGmJBag2ub57rg==
X-CSE-MsgGUID: GrShIBlaSlSIhLoYn7QY1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155100616"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:54:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 22:54:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 22:54:22 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 22:54:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YL6sjugLflIZxaaGDQWqES0/e3YP8x9ffmFPbX0pOtUDQsVsKnxE3QVU9HwEIe+As+VsGCRRQY9Lx76QGwdDLrjsETx0rRyT/umTA22xhKORCuCjRDEjlcYry0CJq7bBIrfXncjxEtxe5WD/LYeghE+FPvpLPyRxgnZ51uLdfBPl2/JmhobIHQJIZSQBANz4VUqT/qy4FKQvwuN0wVHIyRied0lIO5bVJ61Xsa41hUw2sHw3E3RFcs7QHqKIUM/JN80wY8q4P9gZXDCBtnCqMkJG7YCeHzHw/UfmjtQ1G7H/+k3zYTfxO+8xpE7NZxDCTMYV5C1V4KYwSSyd4CEBYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNIJz2RMtNlAae98flzualrULG3XFnGsOqM+p2SjkEU=;
 b=Fn26UMKLd1CRmUjDFNrZZBVEwC/E5nxYSv270iwMM3lq629MvxXBECy3WHPPC7AFAqeC8lXCpZwaYlLeYTJ8WW2bsYcCZanIaq8+0celjZKYMJfYoUmw4v7g89djHw3OAm2jfurPs/3PRUTuM6FwvM86KFIb+c40YJ1NkP9KzgXsF85Qt60AuhLXSGorm5uvfe/w6wVeokD6Hmdr0Q5WQpvDceTtGNq4ROnFSTtoBnCt79OiJPzIpiopG/AvWgxDj2NbgNrhEiedYvChehJ0Pm/ra5GS56mTO3b4dTulJwrWltfoyClnVnSmoInHeGyifCpAW8H+johA3xti3FHbrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB4970.namprd11.prod.outlook.com (2603:10b6:806:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 9 Jul
 2025 05:54:20 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Wed, 9 Jul 2025
 05:54:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "bp@alien8.de" <bp@alien8.de>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"nikunj@amd.com" <nikunj@amd.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb7yd7VfkdP/oV20S9Gj+gph7qB7Qnf8YAgABSdACAADxpgIAAQBiAgACJ7wCAAANcAIAAcXkA
Date: Wed, 9 Jul 2025 05:54:20 +0000
Message-ID: <fb943583cc1f3e27471dee227443935343076255.camel@intel.com>
References: <20250707101029.927906-1-nikunj@amd.com>
	 <20250707101029.927906-3-nikunj@amd.com>
	 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
	 <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com>
	 <d8a30e490c50956a358887a3d018a9b86df91fd0.camel@intel.com>
	 <aG0uUdY6QPnit6my@google.com>
	 <13feda96f84da526b14c4ff48d41626b827140fb.camel@intel.com>
	 <aG2k2BFBJHL-szZc@google.com>
In-Reply-To: <aG2k2BFBJHL-szZc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB4970:EE_
x-ms-office365-filtering-correlation-id: 8c81455f-19ab-481d-b214-08ddbead0c72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U08yend6T0lxaWFpa0xtMi96NkJXMUUrZGZ0UXl2c2JVMWh5QWE0S2VzcUxZ?=
 =?utf-8?B?K0lkZ21QYUZnb0xRb29VTWdaVzBKNHh6U0RkVUR0a3IxQTU1Q2lyUFVjY0J0?=
 =?utf-8?B?cEw3M0FGM2xudlYxajh1dUoxMklHTzZTVTE2aUE5cHpUWTV4ZThNajhXQUtv?=
 =?utf-8?B?MHkvcFJ6Zm95c2Zxd1BqWHU3bGh4bjFiaEhUYWFHUnZReWdvSE9KL0gyMWRE?=
 =?utf-8?B?dG00Q0x6cTZRVlBzNWZGcTdtaWR4Sjg4UW5iVzFSMDlnMENnOVZyUW1YWjNM?=
 =?utf-8?B?ZEhST1gyV3d2NzZjK2pzVUdBdDdpaisvakhhSjdtTVdjdWYwNXJOTGpJblRY?=
 =?utf-8?B?bTBSYThXNW42TmhpazlmTVRqTHlaSW1wTTFGWTVBVXhOMDdKTjJqYVIzNUE1?=
 =?utf-8?B?SlFvQnBVRjQ0MmxOVlZtUVlhdkNlanZXcEFkNmpqVjNmS2ZwMkZaTTZrSUlL?=
 =?utf-8?B?aWRpSDBaVUdSYzhJSnZabkl4ay84WGpHNUZuUGNOOTFFUjlLdkw3V2pwU24y?=
 =?utf-8?B?N3FzbmhMRnNwdzNGcHI4S3BTWllhVTVOeHFyTEhDRUl4WXUvTm1iT2E2YUZI?=
 =?utf-8?B?LzI2dXpCaFRhczVDNUJxTEZhZmU0T3NwN1JVL1UyRmpZT2tPbWpOdFUrMjR2?=
 =?utf-8?B?RzZvV2VYcm1ONnRFcGdPRS8rajBKWVJ0NTlBOUxVQkt0dkFJL3dpTS9HZE1P?=
 =?utf-8?B?VTFUaDhub2c1cDZKLzhHaWJsMFIrTUJ5WkRpOFJkUzVQSGpCSGovS3o3RWl3?=
 =?utf-8?B?amI5dlFXOE1vMjdxWVZ4ZmJjSDZMeStUdTB4azlxUndkeisxbFo3NlFuVUtK?=
 =?utf-8?B?NmoyV01MTjNZemlyTU1RUGJkMVpaalpUUFZDcmV5WTM2dEFrVjVRdXRaam5O?=
 =?utf-8?B?aEttNmFmQVAraCtwZXE0bXJ2Y00zYmEwV2psaTduRy9YZXZNL3JRMXhNa3Fu?=
 =?utf-8?B?OGFUaUtUZ0hEbWVpakZ4UHorVXh2Y3h2di81ZGRzalRhMHlRT2JXdFZIOWRR?=
 =?utf-8?B?NWdUTmJ4L2VqSXI0UjB6bVFFcVAyRktzVG1VcXpZR1lkQnFIN1NEUFk1VjhR?=
 =?utf-8?B?SFkvRURjdUhGT1JNUzRTTjR0cThnclhBeHFWWFUyZDN3ckwxRVk5Mk85dVZY?=
 =?utf-8?B?TW5pb3dGNDc1ZzdOcjRtK0oyQm82dDNZVDNzTFM5aGZ5aThXVkJpUUZxc1k0?=
 =?utf-8?B?RmladCs2bDhSYUNRaVo4WXVUT1h4Zkx0NjFMU0RUbmtkKzJ6eitxNnpTQzFr?=
 =?utf-8?B?VUFwWng1RnFmeEVTV2Y4TGJTQkdrZVpBSnY1N2k0R2NISnVhOENFTk1IRlcw?=
 =?utf-8?B?eGZ5MHczYysvZkxEd3dCdENBU2ZwVWxZWldtcitxQUFyK0tUYUNzUVpzWi8x?=
 =?utf-8?B?Q2lmSkg2eTNEL3QzelNSVzI2MWoveUFNZmxyWFZwdWcwOWlhbDlGZUYxOUVW?=
 =?utf-8?B?cTBGR1l4SE9jT2JmYjJrSHZWRUsyUURGbTluZTQyZXVsOG9Dd3ZxRjZBSHJI?=
 =?utf-8?B?SVRDNnNWQTZXUzJRRVNwZkgxbjE0cFc2M3JXckRGZmZ6S25vcUVWZU1MNElS?=
 =?utf-8?B?Mlg2T25ma1VhZU1NN29vNzBtMlhyTm90Q2N6cnBueEtSdEZpSkluSmtPWmgy?=
 =?utf-8?B?OFAxV1JsTXhBYzZjdENRdEpYR1hxSXhGbHFyZmVUUVZHZFlHdythYkxhUlhP?=
 =?utf-8?B?OVFsM0xmQ2xxVldWVXNLZW9paEcxWXFnSFRFVW1VVTJmWjFjc0N4TTJKVy9t?=
 =?utf-8?B?ak9sQlVhSzlFZG9YWXQzemtGTEphWHppVzBjUHVBMHVKZHd5OEwvT1NCODVC?=
 =?utf-8?B?c2lXRWRDdmJ4cDBJZW4xc25oS2E4Qjd6V25XbHdMdk8vNWpJelF2b1NCc3p4?=
 =?utf-8?B?VWdNTkdxaHhQalEwQVJScUtWYXJUZldxR3E0OHJTOWk2VG9RYTJ1UlBqWm5k?=
 =?utf-8?B?Q21OZmViRlphcU9kbk5lNHl0QjRGeGpjK2FpQ25uSC9LWkNrL3RYSHloZktJ?=
 =?utf-8?B?SzVmaWNNREtBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enlwb3h2cHlYejBOUEQ2aHdNNWtwcHo1dk1lWnQ4NnNMODhGRXdqOFlib3Rh?=
 =?utf-8?B?bzR2Ny8zcEZWakVqZzZ0SC91NHE3bEFXUjZCanVqYW1OeGpRRFVnOFJ2TjZz?=
 =?utf-8?B?anJBMm1JbHlFODdyYllpTU5rSXRFbWtRR1FuVlhGUURLR2hwYkhLYjJiWGph?=
 =?utf-8?B?Qm81WXNUc29uMDdTNDA5S2hUMzNvdnJ3NlRQZFFQTVBFUkRiT1pDYjRSV1Ba?=
 =?utf-8?B?VHczc1BJVGFHM2tEZEJFL0E5U1BUWGxFdWUrZTZZOVlmOWh5WHhveDNoWEhl?=
 =?utf-8?B?RGc0em1wMWY4RHU4cU1MUlIyM2pRR01XU04yZFRlaTFtemk4MHlZVzlCWE53?=
 =?utf-8?B?ZzE2eFJjNXA2d2tFdDZ4RUtmN0tTRVhYZTNHV3l1T0xhOVpUa3gwYkRJSml0?=
 =?utf-8?B?RS93dXVMK2NwNGVWcTVFOFc3TnRyRTRvMHdmR3Jwd1AyZFpTRkcwSWsyellx?=
 =?utf-8?B?WkNkUEVtRldhRFpEQ09FZzQvWWttazNiaFpOR0o5SXRFazhlYno1YTNHVEFp?=
 =?utf-8?B?MDUraGpFY2lSSVQ4MDJJdkFqUEVZSmk4Zlp1L21ONUEyVWZqQ2lzVGFFMG0y?=
 =?utf-8?B?MjkwQUxWSjJjSWlYdGhXUXNxWVdpR2FDQmpUcGk0dWhzN1ZiRWNlNEUxZGdv?=
 =?utf-8?B?SnpTajlEN2o1QWdCQ0x3ZGduMkJGdVhGWmI4OW5wSjhOL1RqVXVOU3RhUFpq?=
 =?utf-8?B?aWJ4U05sWGZrcEg1ejhpSkNFSXFHdjVIVmwwU05iRlRsNzFmRGNrRlExVW9v?=
 =?utf-8?B?TERsTnNSdE5MVG1HTTdWMjdHQUQxM2o1TGhvQ1BhVUVMU2dqOHJmeDIvSXJC?=
 =?utf-8?B?bVpiMTEzNEk5Z1l6V2xtb1poY3czTXRLS1lsdnlCL3hiM0hsN1p6NWlXeW9u?=
 =?utf-8?B?b1dGK0FPSTNSWlNXMSt4T1ljR0h0K3VSb0FUSWJCVHpmZXJjTzJkNCttOGdM?=
 =?utf-8?B?RVdkaTZFZnoxK3doZk5PNkVRd0pnaC9rRFV6QnptYlUxTmF0VytTYzc1S0cz?=
 =?utf-8?B?eHVLZlhMbUkzbUljOWdWYnFnZmU2NGlhcVBqc0tDOUJ0bjFraFZRdWd5eGx3?=
 =?utf-8?B?Y2hzcW1IRjFGTHYyUEpiNktNZWl6Z2ZNc3NiT3hTcTBpdzd0MVphZHBCWHBI?=
 =?utf-8?B?NkdLSDd5NzNWY3d1cm5WeU45R0U3S0pMdnpOODlXMVYzTmljN1ZleGtXVC9Q?=
 =?utf-8?B?eDU1c3k4Vk5DT0FKWWxIUWN4am8weE1lOTlTRSt3NlN0dStVVEVaL2E5cklm?=
 =?utf-8?B?Zk9QOVlwdG4ycksvYnZhUnhmelI5Qzh3YUd2REVOWWZBdkJYTE9lV0tUQjhj?=
 =?utf-8?B?cGlyd05hR2Y0cE12aWdiSlpMa2JBaEIxZjhyVEdNeFN3U1JncDdmSFg3eVh3?=
 =?utf-8?B?Z1J6aDgwaVl3ZDFHU25MbGd5aDdONjd0NlBDcHl6YWN1WTYxcnhIVzNQVXA5?=
 =?utf-8?B?bGIrNFdlUHJmMzAxNmdwUGYrYXpKbVp0RkhaT09LM3RkMi9sdDRKV21KNThM?=
 =?utf-8?B?VEtDS3JXU3c3bHRBT1J4RDRzWnp6NUJKM0ROS0FhOERXaGxubStjbE9xVEpy?=
 =?utf-8?B?UTNpQlFZZ05qRVVSVkVMazFHTkJpVWdweEtXYWRpODJIb0lBd3JPNWxlazda?=
 =?utf-8?B?d1JLTURFdnhkVC9ORFRCSzdvdFhxQmVmUFYwcmJUbGU4WDVHS0V6VG1XWVRV?=
 =?utf-8?B?bGZhNjN2WFNEMWsraEZMdjE4N2djSk4vNGkwKzN3TEtGRVI3bXpCODRUTWk4?=
 =?utf-8?B?KzVwWkZBVUVKcDFPWE44RnhzcjVYWmlUV3B3dVlFVWtRSDRTdHVoY2lJbVZE?=
 =?utf-8?B?RmhFMElzdUd2b0l1ZlU5cTgzekhtTnRhSFlIZm9sMCt5ZkNkTUpGblF1S0Nr?=
 =?utf-8?B?ZkgzZ1JiWGFHb0xPL2hnQU4zUUxSdmVhSkg4eHYyOTBzaW1WT1F6OENDSEd3?=
 =?utf-8?B?NUlQVEh5dmNWbzBHaXcxb0gwa2VORGpFWTU3K3BQWW1LNktaMGM5d3QraU5K?=
 =?utf-8?B?MURuSTNKcmpuajhMY0YvaGFUK3d6dW5uWUhsb1pqdG1CSEUxT1RsaGpqcTZa?=
 =?utf-8?B?Q2dXZHh5RjM2ek91SjVCcDZJVFJ6a3FRL05NTGNlWG9lTmQ5MzJJOWUwUDlX?=
 =?utf-8?Q?OH/TkJyRX5QrWO00dWzjpPYUj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <344F40DB218CCA4390E1A584A9D6896E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c81455f-19ab-481d-b214-08ddbead0c72
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2025 05:54:20.3708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yrF34Ql3G0Yg0uDPhifOu+yIy8rP1mr7Jy4OzqPbfRNYShEg0IAHDaNsegHiEdVBxwKQiS95TZgMR1e1t0B1Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4970
X-OriginatorOrg: intel.com

PiANCj4gWWEsIHByb2JhYmx5IHR3byBzZXBhcmF0ZSBwYXRjaGVzIGdpdmVuIHRoYXQgdGhlIFZN
LXNjb3BlZCBjaGFuZ2UgY291bGQgYnJlYWsNCj4gdXNlcnNwYWNlLg0KDQpJIGp1c3Qgc2VudCBv
dXQgYSBzbWFsbCBzZXJpZXMgdG8gZG8gdGhpcywgYW5kIGFkZGVkIHlvdXIgU3VnZ2VzdGVkLWJ5
IGluDQp0aGUgcGF0Y2hlcy4gOi0pDQoNCkJ0dyBJIG5lZWQgdG8gdGFrZSByZXN0IG9mIHRoaXMg
d2VlayBvZmYgZm9yIHNvbWUgc3R1ZmYgYnV0IEkgbWF5IGJlIGFibGUNCnRvIGNoZWNrIGVtYWls
cyB0byBmb2xsb3cgdXAuDQo=

