Return-Path: <kvm+bounces-51156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0151AEEE0E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BCE03E097B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F160F23958C;
	Tue,  1 Jul 2025 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dDRXR9ra"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C256219E8C
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 05:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751349421; cv=fail; b=K8M5A4a8JtuCcTH5g+awSslWjVB2qNT/1cEI9k4iGOEaSpwK7/Ix/VOQuTBj04N91E6Q2+E46Oq1xoYJYMG5pLOrm+xt+BHniEIMPMS3eYvyS2Vr7fPaqPCndsNWCRezgyb/XNU338wCGamzFFZhEag3U+FtFXM7s7mQ6O5YkhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751349421; c=relaxed/simple;
	bh=rQ41jN/RxliW5c/T81tQahcmK1KGeWOQ48z30P+7sx4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ol/kfp7lGfGJXHNVGi02TI5CNcAtQMEHvEyLI2GozCNR9VQg8KX/i4KA1PWO/WvZjgRbKvp2BDf6v7V3QYSV5huVvQ19zmr6wdZA+xaS34dDC2JKETk5RpOQBv2VzJbE4JaNc5qQmKuBwDM21g5DSNIwuPg88bXSKvXc+RE5PGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dDRXR9ra; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751349419; x=1782885419;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rQ41jN/RxliW5c/T81tQahcmK1KGeWOQ48z30P+7sx4=;
  b=dDRXR9ra1yxwwztzDv7LLpo+doEnV0AE1uYrtaF5d+jAFbuYGOQhCVIC
   4cZKY4sibrTzx0AOnHsAyi4wf4m4gl20MqT83AmTUGpr+QprCvO0Glp/y
   uy1iwB/lbYKJFR1QrX3w06u3ENwKVVUbNB36YBjfszYaKCZbwAsVgmnvT
   PHkHpCztR3KHiR3rmu9XZT8c4eKlSA3n1Egulap4omJSeaJ0ASPIBpOEf
   AbgLjBLJevLtmeoZq0cb5Ahk10c12yACJJoBzvvve6ZBGpft4CvJTSMEz
   7y88Em2uothOZBhs+5UmA5LCzlg8dDHeAlCNEwALcYTAfhkdoHe54CTZ6
   w==;
X-CSE-ConnectionGUID: q2yf4lCSSFqvVBbkvf5GXg==
X-CSE-MsgGUID: GXM1tiAXTaqDbDC0JF19Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53532571"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53532571"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:56:57 -0700
X-CSE-ConnectionGUID: 7d1OW0VVSzGz2id8qAvlvA==
X-CSE-MsgGUID: nLhWVOEuQHePo5xHqzbCDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="158208520"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:56:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 22:56:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 22:56:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.43)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 22:56:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FXM1/m4OZ57w79XltxQPKbVg8SVjLjnceSxDl4I6P59qTwS/QqxsZET3ykT98jLO/z/w4V/acHiDOv908w/L0AgVP/k450D2D0YkB774B9W/ojwYIJCXfyBSjmgzR72orNXNRcoTof2L+eg0zSlavZIR/yOYNaXO/PlYVAFYJyBT3mDDgbiOLwX8aUwVtDRdc9rfkNnBRtqGrNf5GeyoNUMEh9HBBgQjlq7Q7lAKqIdLpeUrnBdiflPY/MNILHxyKgjzKtMs5fsfxVFI2iIDm5Q3qxHY9+sxq1LE/dNe+Lk1Hfg0q7eb9EZcFvx/kGV5mO/vt1VlE+DgPXv5dqT6yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQ41jN/RxliW5c/T81tQahcmK1KGeWOQ48z30P+7sx4=;
 b=rxiskfOKn4qdf5sukldDqBVTJlVD9E+DIOWgt6SBGbcRr40Me0sDAoxUKwsrmIKbvisvDdT+co8Yhqtd3Dieu5oPYVJqGeiUv0I/9bteJXKGgrprEXu0uUKo4EurydrN36xaqbTlTHaAbkiP93/v5wamzvYaZeGOi3OwadGcW+nbrPi972BDWSmF8QY4NyqhsJEDtS0qjKzGagUeRwx8WbFiusX9ybti8M2xt5sytvfdCq0hWDVxCOeTdMKszQYHiYRNXZg/P87YKw2PfoCb7CbRlxEobh1bUO2SdCR4roCMoV/QZm3CoB3gI3T382q4neMCDnjnyJTThBmhCInPNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SN7PR11MB7092.namprd11.prod.outlook.com (2603:10b6:806:29b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Tue, 1 Jul
 2025 05:56:50 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Tue, 1 Jul 2025
 05:56:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>
Subject: Re: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb6awSQgGTXSslVUSNVI1aR2O0trQccSiAgABORYCAAAcWgA==
Date: Tue, 1 Jul 2025 05:56:50 +0000
Message-ID: <be5465f9feeb5d04f8c78f4a2ecc91aaa9be7ad3.camel@intel.com>
References: <20250630104426.13812-1-nikunj@amd.com>
	 <20250630104426.13812-3-nikunj@amd.com>
	 <bbee145d51971683255536feabf10e5d2ffefb44.camel@intel.com>
	 <1cbd9a5a-1c15-4d32-87b2-6a82d41ff175@amd.com>
In-Reply-To: <1cbd9a5a-1c15-4d32-87b2-6a82d41ff175@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SN7PR11MB7092:EE_
x-ms-office365-filtering-correlation-id: c6fdb907-642b-47e1-d81c-08ddb864126f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TkNhb09nZkJqeTAwT0Z5UWN1alRyU0NXdExJRXU0Y0ZPelZjdkd4R1JYMXBI?=
 =?utf-8?B?cjUyVVFIc28wTWxBa3VUNzFLamd6OXhLQjZnODI0UWJKcmNiYzBEM1ZWbTRH?=
 =?utf-8?B?WSt1SzcwMkxNL2ZIdWZlby84Y3RIUnZkS3hqcXZkMGQrSWRmK0hOWjFmS3Fj?=
 =?utf-8?B?eFlXVTA0cFgvMng5OWt3aUEvRU16S204dCt2UW5KcFNYL3JBZFJoM0J5MDRq?=
 =?utf-8?B?Rkt4MkE2UWU0cHBMNGFnd21tbWRLMTBVd1pwZEFYRWtmU3Q0WWtjTWptek1z?=
 =?utf-8?B?V1pNRTczeW85RGtEQlpNejA0MXBSSXBxY1JaaHNTeE00U09FUGJmcTE5eFd5?=
 =?utf-8?B?UEVkQ0VnVi84c1dpenNjYTgwWHVGOUN6NThjRFpyMFRJeGoyZ3VCUnhZSVhH?=
 =?utf-8?B?allRR0pRWkdrS0tKY2FhKzBDN2c1dHBWZ2w4bklGMElQaUw2NTBmb3lxb1lx?=
 =?utf-8?B?MkJ3S243M2d0TitONDNXMk1TZlRqTjFIbEVsN1ZKWEszWjdCLzFTMU1DSk9a?=
 =?utf-8?B?d3FmWFoxNEUxVGVxdVpobGtCSWxQVmZiS25JZDN1cm0wVXMzM0g5Ym41eGlj?=
 =?utf-8?B?TjRLODFVOEVjdjRQREtuVGdDdWljY0JaaUY2bUlBQWdwQVhmT3k2dkdrWDJZ?=
 =?utf-8?B?Tmg4SUd1YWpSbGdUQ2JRRlBMd3RFTVNFN3R6UVZId2V5MkRzdFJ2eSs4KzRE?=
 =?utf-8?B?Rkg2alRneDB6TzB4SUljQ2NuT1FpelBtMjlDODhSNERPYi9jL0RaaW1Gd3BS?=
 =?utf-8?B?ZmFmRFJmczc3Z0FRTkZqRkVzdTRGajRUZE9xQ3d4SUt4TEV4K21LQzJ4azI2?=
 =?utf-8?B?MGoxMnpVTUxiR0FLaWFYajZzK0hxSERJanV0V0pJYWQ4K0E2dGRJWFByK1FY?=
 =?utf-8?B?QzR6ckd1bFVIQ2kxalFwUmh2RmJIY2pRZlZkbG85UFZuZmExTml5QmtESDFI?=
 =?utf-8?B?SmlzRk9SNHFtbkRENUdvUTBPdVd3UFliQ0pYSHQrODVIMEV1UjhMdCtSUXlu?=
 =?utf-8?B?cUtjQjNkeklzcVZmR0xqZ1FrNitSdTc0TjhqQTJ0YTh3U08xSm95Sm40bUhH?=
 =?utf-8?B?NkN4Q0hCYzI1bmVFcitkTlJudXdacjNTeWVoamNzWGdETWZZcnFFeXRMMlZ5?=
 =?utf-8?B?RFJ0ZTVMM1IvdFR6R2I2THI3cGJWRzhLa1FPSDBFb2VORzlQN1MwQUdtSjhB?=
 =?utf-8?B?SC9EVFM3M3hYWTBlUGpwellhbFNweXppSmY3QlM0U2grU010cG5icXJ1eGtW?=
 =?utf-8?B?SFkzallHTTdrM210Wm9LMXc0NFdiWDJBMHdtVVhNZlZEa0krbForZHFHNzIx?=
 =?utf-8?B?bVVuQzE0UmJYc3NXVTlqbVVDQ0d6NkpQRENLMS82dG1JZm9HSG1BN282ODZt?=
 =?utf-8?B?VzFiYVdMdjJtU0NDclJvcjI5UzgwR09ZTFMxL2RBMkZ3b3dkdlkvTy9HYnNz?=
 =?utf-8?B?ZU1obFNuUGNHR1hyc1VJYWhFbkxjRXpWaHN3eXkxN0xuVStzM2hmb1FlUGNV?=
 =?utf-8?B?dTFzbDhUTlorWmE5M3Iwa1VvZHRqZUU2V0pMZmhybVZhYnAzRXR6bzR3MU5P?=
 =?utf-8?B?b0ZRZU1BNk1pVGFUZHVZdlZaMmY3bHp4VjVwRElxU2NwVmp2MzNSYTBiUWFZ?=
 =?utf-8?B?b0VXTDRnaS9OcTBsK1BTSk43b3pBVW00cUVSWmZZV0lIQW54ZG5sRVhYd1BV?=
 =?utf-8?B?MWNXeFdTZDBkcXFtdk00OXBCSkV5Y05ISlBxOFJxR2s5bmxvajJoaEQ3cjV1?=
 =?utf-8?B?U0tZV200SkFSeDBtN0wxdTI5dmNVMGliSnVrQ29aSS9kZVY1Mkd4YTdNcjVp?=
 =?utf-8?B?RlIwTVhtaitXVTVFUk0vMWdlenpXbHAzSGZpTnl2T3RQM2c5L0YyUUo1VEEy?=
 =?utf-8?B?TUVKS1REanVIV1RGczNNM3MyVmZpVlhMRFdjbnp2TTQ1OXBvS1RybGE2bjR5?=
 =?utf-8?B?eGJQbTB3N3g1N09zVVpQdlJNdG54U2FjNmlvbWREQkFhaXl1MDUweVdEeXhQ?=
 =?utf-8?Q?RSfe8u7oYjwLa1Om089bjirUTAK+Ss=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjNpdklINmxHWmlLTlN2TVFBbHRrRXFsblMvU3YzbGpaaXBYR1B0c2h2cW42?=
 =?utf-8?B?NmE5THNHckEyOFJESmx5YjVtMU4wZEZtV0IrMXYxVjduWG5EVmZtaXIwSnV2?=
 =?utf-8?B?RDRnTzRxbWdmSmRUUmNVVS8wbDBXUCtFY3BmblFLaXZkaFdDT1BzRC9IT0wr?=
 =?utf-8?B?SzdGOGFiMWE4bVcwQ3ZneGZlTlFFZUNxd1ZWcEpYQ3dRWHA5TWQ2VW0yUVUr?=
 =?utf-8?B?bUlzT0RoSk1jZHkzUDZGaFhxU01YS21EaCtQVERqQ0JOcmZYb29EMXJ3RUxW?=
 =?utf-8?B?anZSdkc5NjR0MENuM0tKTUNBR25aSWNmZWdLUHo1T2VvM2I2WEhmV3JvaFVx?=
 =?utf-8?B?bVlyY0hRSTVhd1JUcWI0N2FEZ2l0SW1tekJWZWZYR1E2VEJZY0N0NDFCOWEz?=
 =?utf-8?B?UG8xVmhYSVM1UmYyaGxVa1VKTnhlemlTR3oyTGg5YzFoU01kL1dSQURZZU9W?=
 =?utf-8?B?eE44TUlLTTUrYkt0S04rZlBZNWhLcjU5cm01U1MvWWgwb0kreTlrak51WU1a?=
 =?utf-8?B?dmczbG5xQmhpM1RvYXJUMU5ZTXp5NHZFSlFOd0VRNlEvQThNcHErTkFmS2pu?=
 =?utf-8?B?S0Y0RmNyMU8yVEdwUXNKdWNCWGxUVEJmMzQ4NjJDYXN2OE1vcmc3TWcwWGNM?=
 =?utf-8?B?OUlaWnhNM1FLTU9Cd25tNmRLdkRuRW1xRlgyb3NoZ2xSZ3ZIKzFxR0NKZDk4?=
 =?utf-8?B?NGtjbUl0a04yVXplQ0RGVEpZczRmQVlIcEdyL3VBblY3T1BtbFc5ZytSRHlO?=
 =?utf-8?B?QzBNODZZdS9DQWN4MVRRNUtjWmJaUmMrZlpSNjBNUDlmb0duSHFWNTljMExV?=
 =?utf-8?B?UGRqTndLMkdmSzRZQW1kd2tPdWNGQTIrSk1ERVNid3VuenFSTmxTci9VdklX?=
 =?utf-8?B?UEZaWGw5UitMRndmNTVKYWpvbjFkTU5STEtFZENKdXRYbk4vTFdDNVVtTFl4?=
 =?utf-8?B?N1hYaWdvMWZYSWxxbkFaL1lqNWlydUswNGtGVXNBWWhzcmx5Z3JvbXNLOU5t?=
 =?utf-8?B?MmdMRlRhNitLb3ZvUEhoR01yS2grY1N2ckpSS3phYXgzd2pLNnIxcXVxb3l1?=
 =?utf-8?B?N0pKTG5pM0tCdm11WDMrRmpZeVZMMDJUa1gzTk5jTTdiNVBHMHBaNmNKV0x5?=
 =?utf-8?B?cklBRklsNkJpVTFBSlBIRlNYZ0VNSkgwNDQ0ZmRqaGZWMk5FWlF6TTIrNUhC?=
 =?utf-8?B?Nk9mQ2V2QVBhamtoQjBpQ3hYdXBTR2JndW1WTWozdUx5NklNOGs1YTNkOU51?=
 =?utf-8?B?TGpyeEZaZEthWEYvci9tdlFSbG5UL3NhMitFeTFobkxxcVIwOVU1S3lFWEJa?=
 =?utf-8?B?dm1NMyt0Mm8ybmNzVWVHQm1NUFhTdm52VUZlQ1FMZklqekdrOStDTXh6Q1ll?=
 =?utf-8?B?S2xhbzV6YWJJM3JyZTNSWXZkQkgxLzNjRENwVEVsSEs1anE5VUdnb1VWdml6?=
 =?utf-8?B?aG9FRy9JWUlMSHV2a09vZmd6T3dXMXlQREk5THNWY096WkpzWjRHQzVTdURF?=
 =?utf-8?B?MEJ1WVlqdnJrZllXbGZpTmJwemxDZmc0anhYZ3dNY2RVbGpPeUpicGQxWlVh?=
 =?utf-8?B?TXRnajIyOXYrQXdPcFQ4TzBpMkI2YlFWMzVZbEdiSVZ2Nk5pakE3Q3pMOTUz?=
 =?utf-8?B?ZXIxWUY1OWlKUVlZYU1zZkU5V3RjYjA1YzBiZVpTL3Y1S1d4dStnNkoySGxN?=
 =?utf-8?B?M0ZZTDZOU3Rab3pxT3l1NUlWT0Jvcm9EUFdaalVGMGM2TjJVbm1NWFpuUExj?=
 =?utf-8?B?ZnUrOWRTVll6R2ZpUDcyaEM4emNSbWxVMFJDbWQ3Z3RSdlpBQzRYUGRqSWRQ?=
 =?utf-8?B?bWp3bVZUY0pObjZQeE5vQ1lyRU1iYThKU2lOQkxiZXpQN0JXcWNzMVFNaW1P?=
 =?utf-8?B?aDNmNUt4MlFWWjlsTVFIYmZDTGFCdzFuWjFibm5OSlc3VWUwTEJmbDVHenh3?=
 =?utf-8?B?SHJOcGNMQlRSSEI4NlNoR3dwZzQ2Nkw4MTVxTU1LUUE2alhoY2E5aDM3S05y?=
 =?utf-8?B?TnpkZmdXbnBWN3o4MTNHSjFqYTFQQlVnVmsyT3FMLzBOR1BaTndHSVJGcURK?=
 =?utf-8?B?OFlLZy9HWVR6am5hdWVNb3BFSys3WHR6em1wQ3pIclBvVWY5ZW12R0M0bVBa?=
 =?utf-8?Q?4tybDcBnMNxYTkBHwqmHlRuM6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC5BAC37EB3A1C42A728BEF7D3D68F5F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fdb907-642b-47e1-d81c-08ddb864126f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 05:56:50.1829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wnsSmgD8JsyfecIGMuZcUFemghqopGPV9OCEej2K7m693tez9JFZfOXnVqooAWJ+O+SJ9syRaaf1LDsOC+C7/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7092
X-OriginatorOrg: intel.com

PiA+IA0KPiA+ID4gdGhlIFZDUFUgaW9jdGwuIFRoZSBkZXNpcmVkX3RzY19raHogZGVmYXVsdHMg
dG8ga3ZtLT5hcmNoLmRlZmF1bHRfdHNjX2toei4NCj4gPiANCj4gPiBJSVJDIHRoZSBLVk1fU0VU
X1RTQ19LSFogaW9jdGwgdXBkYXRlcyB0aGUga3ZtLT5hcmNoLmRlZmF1bHRfdHNjX2toeiwgYW5k
DQo+ID4gdGhlIHNucF9sYXVuY2hfc3RhcnQoKSBhbHdheXMganVzdCB1c2VzIGl0Lg0KPiANCj4g
Q29ycmVjdA0KPiANCj4gPiBUaGUgbGFzdCBzZW50ZW5jZSBpcyBraW5kYSBjb25mdXNpbmcgc2lu
Y2UgaXQgc291bmRzIGxpa2UgdGhhdA0KPiA+IGRlc2lyZWRfdHNjX2toeiBpcyB1c2VkIGJ5IHRo
ZSBTRVYgY29tbWFuZCBhbmQgaXQgY291bGQgaGF2ZSBhIGRpZmZlcmVudA0KPiA+IHZhbHVlIGZy
b20ga3ZtLT5hcmNoLmRlZmF1bHRfdHNjX2toei4NCj4gDQo+IA0KPiBzdGFydC5kZXNpcmVkX3Rz
Y19raHogaXMgaW5kZWVkIHVzZWQgYXMgcGFydCBvZiBTTlBfTEFVTkNIX1NUQVJUIGNvbW1hbmQu
DQo+IA0KPiBIb3cgYWJvdXQgc29tZXRoaW5nIGxpa2UgdGhlIGJlbG93Og0KPiANCj4gIkluIGNh
c2UsIHVzZXIgaGFzIG5vdCBzZXQgdGhlIFRTQyBGcmVxdWVuY3ksIGRlc2lyZWRfdHNjX2toeiB3
aWxsIGRlZmF1bHQgdG8NCj4gdGhlIGhvc3QgdHNjIGZyZXF1ZW5jeSBzYXZlZCBpbiBrdm0tPmFy
Y2guZGVmYXVsdF90c2Nfa2h6Ig0KDQpIbW0uLiBJZiB1c2VyIGhhcyBzZXQgdGhlIFRTQyBmcmVx
dWVuY3ksIGRlc2lyZWRfdHNjX2toeiB3aWxsIHN0aWxsIGJlIHRoZQ0KdmFsdWUgaW4ga3ZtLT5h
cmNoLmRlZmF1bHRfdHNjX2toei4NCg0KTm90IGludGVuZGVkIHRvIG5pdHBpY2tpbmcgaGVyZSwg
YnV0IGhvdyBhYm91dCBzb21ldGhpbmcgbGlrZToNCg0KICBBbHdheXMgdXNlIGt2bS0+YXJjaC5h
cmNoLmRlZmF1bHRfdHNjX2toeiBhcyB0aGUgVFNDIGZyZXF1ZW5jeSB0aGF0IGlzICANCiAgcGFz
c2VkIHRvIFNOUCBndWVzdHMgaW4gdGhlIFNOUF9MQVVOQ0hfU1RBUlQgY29tbWFuZC4gIFRoZSBk
ZWZhdWx0IHZhbHVlDQogIGlzIHRoZSBob3N0IFRTQyBmcmVxdWVuY3kuICBUaGUgdXNlcnNwYWNl
IGNhbiBvcHRpb25hbGx5IGNoYW5nZSBpdCB2aWENCiAgdGhlwqBLVk1fU0VUX1RTQ19LSFogaW9j
dGwgYmVmb3JlIGNhbGxpbmcgdGhlIFNOUF9MQVVOQ0hfU1RBUlQgaW9jdGwuDQoNCj4gDQo+ID4g
DQo+ID4gPiBAQCAtMjE0Niw2ICsyMTU4LDE0IEBAIHN0YXRpYyBpbnQgc25wX2xhdW5jaF9zdGFy
dChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2NtZCAqYXJncCkNCj4gPiA+ICANCj4g
PiA+ICAJc3RhcnQuZ2N0eF9wYWRkciA9IF9fcHNwX3BhKHNldi0+c25wX2NvbnRleHQpOw0KPiA+
ID4gIAlzdGFydC5wb2xpY3kgPSBwYXJhbXMucG9saWN5Ow0KPiA+ID4gKw0KPiA+ID4gKwlpZiAo
c25wX3NlY3VyZV90c2NfZW5hYmxlZChrdm0pKSB7DQo+ID4gPiArCQlpZiAoIWt2bS0+YXJjaC5k
ZWZhdWx0X3RzY19raHopDQo+ID4gPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gPiArDQo+ID4g
PiArCQlzdGFydC5kZXNpcmVkX3RzY19raHogPSBrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6Ow0K
PiA+ID4gKwl9DQo+ID4gDQo+ID4gSSBkaWRuJ3QgZGlnIHRoZSBmdWxsIGhpc3Rvcnkgc28gYXBv
bG9naXplIGlmIEkgbWlzc2VkIGFueXRoaW5nLg0KPiA+IA0KPiA+IElJVUMgdGhpcyBjb2RlIGJh
c2ljYWxseSBvbmx5IHNldHMgc3RhcnQuZGVzaXJlZF90c2Nfa2h6IHRvIGRlZmF1bHRfdHNjX2to
eg0KPiA+IHcvbyByZWFkaW5nIGFueXRoaW5nIGZyb20gcGFyYW1zLmRlc2lyZWRfdHNjX2toei4N
Cj4gPiANCj4gPiBBY3R1YWxseSBJSVJDIHBhcmFtcy5kZXNpcmVkX3RzY19raHogaXNuJ3QgdXNl
ZCBhdCBhbGwgaW4gdGhpcyBwYXRjaCwgZXhjZXB0DQo+ID4gaXQgaXMgZGVmaW5lZCBpbiB0aGUg
dXNlcnNwYWNlIEFCSSBzdHJ1Y3R1cmUuDQo+ID4gDQo+ID4gRG8gd2UgYWN0dWFsbHkgbmVlZCBp
dD8gIFNpbmNlIElJVUMgdGhlIHVzZXJzcGFjZSBpcyBzdXBwb3NlZCB0byB1c2UNCj4gPiBLVk1f
U0VUX1RTQ19LSFogaW9jdGwgdG8gc2V0IHRoZSBrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6IGJl
Zm9yZQ0KPiA+IHNucF9sYXVuY2hfc3RhcnQoKSBzbyBoZXJlIGluIHNucF9sYXVuY2hfc3RhcnQo
KSB3ZSBjYW4ganVzdCBmZWVkIHRoZQ0KPiA+IGRlZmF1bHRfdHNjX2toeiB0byBTRVYgY29tbWFu
ZC4gDQo+ID4gDQo+ID4gQnR3LCBpbiBmYWN0LCBJIHdhcyB3b25kZXJpbmcgd2hldGhlciB0aGlz
IHBhdGNoIGNhbiBldmVuIGNvbXBpbGUgYmVjYXVzZQ0KPiA+IHRoZSAnZGVzaXJlZF90c2Nfa2h6
JyB3YXMgYWRkZWQgdG8gJ3N0cnVjdCBrdm1fc2V2X3NucF9sYXVuY2hfc3RhcnQnIGJ1dCBub3QN
Cj4gPiAnc3RydWN0IHNldl9kYXRhX3NucF9sYXVuY2hfc3RhcnQnLCB3aGlsZSB0aGUgY29kZToN
Cj4gPiANCj4gPiAJc3RhcnQuZGVzaXJlZF90c2Nfa2h6ID0ga3ZtLT5hcmNoLmRlZmF1bHRfdHNj
X2toejsNCj4gPiANCj4gPiBpbmRpY2F0ZXMgaXQgaXMgdGhlIGxhdHRlciB3aGljaCBzaG91bGQg
aGF2ZSB0aGlzIGRlc2lyZWRfdHNjX2toeiBtZW1iZXIuDQo+ID4gDQo+ID4gVGhlbiBJIGZvdW5k
IGl0IGRlcGVuZHMgb25lIGNvbW1pdCB0aGF0IGhhcyBhbHJlYWR5IGJlZW4gbWVyZ2VkIHRvIFNl
YW4ncw0KPiA+IGt2bS14ODYgdHJlZSBidXQgbm90IGluIHVwc3RyZWFtIHlldCAobm9yIFBhb2xv
J3MgdHJlZSk6DQo+ID4gDQo+ID4gICA1MWE0MjczZGNhYjMgKCJLVk06IFNWTTogQWRkIG1pc3Np
bmcgbWVtYmVyIGluIFNOUF9MQVVOQ0hfU1RBUlQgY29tbWFuZA0KPiA+IHN0cnVjdHVyZSINCj4g
PiANCj4gPiBJTUhPIGl0IHdvdWxkIGJlIGhlbHBmdWwgdG8gc29tZWhvdyBjYWxsIHRoaXMgaW4g
dGhlIGNvdmVybGV0dGVyIG90aGVyd2lzZQ0KPiA+IG90aGVyIHBlb3BsZSBtYXkgZ2V0IGNvbmZ1
c2VkLg0KPiANCj4gSSBkaWQgbWVudGlvbiBpbiB0aGUgdjcgY2hhbmdlIGxvZyB0aGF0IHBhdGNo
ZXMgYXJlIHJlYmFzZWQgb24ga3ZtLXg4Ni9uZXh0Lg0KPiBOZXh0IHRpbWUgSSB3aWxsIG1ha2Ug
aXQgbW9yZSBleHBsaWNpdC4NCg0KU28gY291bGQgeW91IGNvbmZpcm0gdGhhdCB3ZSBkb24ndCBu
ZWVkIHRoZSBuZXcgJ2Rlc2lyZWRfdHNjX2toeicgaW4gJ3N0cnVjdA0Ka3ZtX3Nldl9zbnBfbGF1
bmNoX3N0YXJ0JyBhcyBwYXJ0IG9mIHVzZXJzcGFjZSBBQkk/DQoNCkkgdGhpbmsgdGhpcyBpcyB3
aGVyZSBJIGdvdCBjb25mdXNlZCBhdCB0aGUgYmVnaW5uaW5nLg0KDQpGb3IgZXhwbGljaXRseSBj
YWxsaW5nIG91dCB0aGUgNTFhNDI3M2RjYWIzIGFzIGRlcGVuZGVuY3ksIEkgZ3Vlc3MgaXQncw0K
cGVyaGFwcyBqdXN0IG1lLCBzbyBmZWVsIGZyZWUgdG8gaWdub3JlLiAgQWdhaW4sIG5vIGludGVu
dGlvbiBvZiBuaXRwaWNraW5nDQpoZXJlLg0K

