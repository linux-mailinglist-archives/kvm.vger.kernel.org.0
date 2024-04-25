Return-Path: <kvm+bounces-16000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E03F8B2DA3
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 281F9B226D7
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6778A156962;
	Thu, 25 Apr 2024 23:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxoCJIAR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A731DFF2
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088341; cv=fail; b=JfJ1Y4fqZ8sujwhAxLBAg78GKDXoLwvWPrWOefr8CRiarA6Pem0FKtA5DIr+r7CP1Uv5aMjGmXfsBlyb7ycE78Um9jFHhBU8LU21ZkYBV2QEk4lPzXd9zSqIPGyq37tuJ50dvOW3j+z422eAp4jIj7c5EgUWojvo9ua6UmoNCj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088341; c=relaxed/simple;
	bh=tylhzHb6+JOroIvrMEsNT1ImAjgye3HxGJka1Bq10yo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fb9JAkv+mEtkIUiXrjBOC1m0bNuJFcS4ETm3IlmvtmDCx2TqowhTVbRnhwx5E7nMduUqyoSEFcygMmONS0Cp+ppTlVWWahtHMDxuwkscLWdYz9227wnJTbnJBjLwGqew3L+Oy1MJvnj2RdF2225ox0Fqt2wgIOQGMBlFXY+n1PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxoCJIAR; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714088339; x=1745624339;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tylhzHb6+JOroIvrMEsNT1ImAjgye3HxGJka1Bq10yo=;
  b=OxoCJIAR+WHM+cifzL6zl0xCqO/OQCO4f5GXzUHOrSScaQz7v8TFijIM
   eUuvuuqWF834stXJC4PJuKYoVazDLodjIxLSFCErFRpZMoeCmo9DbhsW+
   izC+rarlTeB45wZPKyO0oxXe82WWTydOOSWK0QCDnXKfu1GvoS7tnfV5m
   8pCmr4kZbpd49RisxzvSGD25g5RHKNln9jykidRxDJViKrwh7hCJM5qqT
   ZZqqXG1GjXpnC90MspCw7PLgTWo+n3NfTZcnOTUHCmpj4N/9Ob0Dm81p4
   0rnef7ZlwHwg/pPnowDix1wJz5DhxAUStv665TIcoL95JK26WGdGRm0F4
   Q==;
X-CSE-ConnectionGUID: cXZygouKQnaFR9w6Ii6iPQ==
X-CSE-MsgGUID: kumpkKegQfuMgpGs6p6Www==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="21231978"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="21231978"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 16:38:59 -0700
X-CSE-ConnectionGUID: MTPqTTMRSHy5auZPOnuM8Q==
X-CSE-MsgGUID: YAWRiGbCRqGLWJVcKNpZHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25252928"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 16:38:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 16:38:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 16:38:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 16:38:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt76v9aOU90IleptIpncLQ0WzI3UbbR0pfMqmBIcZfcmFUXqgN7/tIAyQPqOrBmaFJ+FHPiS3SQyQLyQ0HwdRca2H9x8Kr+94JuMRybje5ymRERaPmHzqtk5RccZwrrH2vp5jqfLzTSe+nTbKPdjo57Ys4GZ0C+Yqt647eZl+iVGLwhoHP/9pFqW6+RpKiAR8LbHHiFx5722PnVaWVV2xvhNkk46ThYuU3u6//hXffmQSfYKDDrqvSgTLJSLZiH+73DRWDoYkyt0NNE6eGo4iSmrLICvBuRiIAASmyOL4L/OMwcQR/xi0yJpwSrmhrLH07FEBtXLUyeqf0xHVvGP0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tylhzHb6+JOroIvrMEsNT1ImAjgye3HxGJka1Bq10yo=;
 b=lXBMDB6AX8/L3aCFATAJrC76bcS2XUB6eIHyrzCzgSXVgWVNgZi2p3FSgdMzqkWJqgpY5/SfnIXd2uqlwtdcdlrO4nBWHRyZ7RmnCYv6pxrkHymMNHc4OaKSSKKx1YLwbNPJNumhOetez/lE90BGL27WL/xXa5lf11bC6qdeBAFA58wqMK+JIP+Fu8j25CFlQAO3kGu38wPkI/pPvdoAVtdAY1kcI1684ifRvMJQx5shbdo+zX6K0FBC4a8R7IX7t1+FezNCdLiVbwziIkZwn9c2fTsN6fZ/sdY+uwsmGwZc1780fbY1xsI3034uVBQGO+NYYj/fsIXM+6KVR7Ihzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8750.namprd11.prod.outlook.com (2603:10b6:610:1c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Thu, 25 Apr
 2024 23:38:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Thu, 25 Apr 2024
 23:38:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoCAAAekAIAAFtYAgAA3YoCAABFSgIAAA1+AgAAETwCAAAWtgIAAAsmA
Date: Thu, 25 Apr 2024 23:38:56 +0000
Message-ID: <3a3d4ef275e0b98149be3831c15b8233bd32c6ea.camel@intel.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
	 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
	 <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
	 <ZiqL4G-d8fk0Rb-c@google.com>
	 <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
	 <ZirNfel6-9RcusQC@google.com>
	 <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
	 <Zire2UuF9lR2cmnQ@google.com>
	 <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
	 <ZirnOf10fJh3vWJ-@google.com>
In-Reply-To: <ZirnOf10fJh3vWJ-@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8750:EE_
x-ms-office365-filtering-correlation-id: 784e9338-2580-4860-3553-08dc6580df99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?NzBLaEFtZDFaSUEraXVPa2FQWnhGc1VzeUh3N2w5Zy96SjVHdHpRajUzbER0?=
 =?utf-8?B?dnMzUWxlMnBFQ0hRd0h2WGJWRnlVQnhGOFMwZ1RtMFNXckFGS3VlZXJpUEg3?=
 =?utf-8?B?MWxTaEEzNEE4cDFuT29xa05zbktPTXcvWXEwVVltTGVnR0cybjdwOUphcEhR?=
 =?utf-8?B?ZjlrMGpSYjFoemVYYVVnZ1VpUXVSMjV4bzJsS3RHTE1LRlVDa2hVWGlaemMx?=
 =?utf-8?B?UkI0YStzdGFUN1IyMWk1UjBxeml2bmpuVVgyc0RCRXhMVmpMSjVLWkg5Y0o0?=
 =?utf-8?B?OE5PK0VXR0RuL1VYT2hlS0RWbWp6U1o4ZXhKRGdzNjdHODloWG5pbXZuSTM2?=
 =?utf-8?B?U0p6VlVRc0RnQVhLTHRpSy9Kd2MxR1dKM01TdVdsYTNWRmVZZjM1U2tkTkx1?=
 =?utf-8?B?eFVYMmtYbjV3UU5mMDhWazJZRlpnWlRTQ3FldDNWSmtxNFFKR21RRWdRN0N4?=
 =?utf-8?B?Wm9xd3ZTaERDUnJqeTFIVWR3RTRaQWo5S0hsNkhSYmxuemZFbmkrTk1iRFg1?=
 =?utf-8?B?N25hUEJRNGpQK3k4S28wa0FZQm44Y1hVQkJGRGV1Q3Bob0M2NWVZbUJlL1JS?=
 =?utf-8?B?Q2dQbytEVnRTUThhY25MOGVQOUpLR0tTMmgwbTNndWFSQWtKU2JWaFl5NHZV?=
 =?utf-8?B?SWZ3VHRhclFPSFlwVGNKTUNyUzR4UHk5SFVCMFhCQWJJZit3Rzg4amdBZ0FQ?=
 =?utf-8?B?cnpkaUZjVXdRbmQ2QkdWaTBEc2ZTQmJXVkxZWExRajliKzJRdVp2Q21QeHFo?=
 =?utf-8?B?Ym5FU1hUTVZtaUZwOTlxcHRJc0EvekVCWVpJcDZtd0huaGxNVDMxTGZIaUVD?=
 =?utf-8?B?K1N3L0xHWEFkMjUyS1ZJSEFFbjEvUzBRQ29OTUlnOXVzdDBkSXBKTW4zU0Rm?=
 =?utf-8?B?MVpzNlJmb1V4UHVWSHZScXdJS3pBSHVoZnpwMktxSEw2bXVzUUx5bWg2MUh4?=
 =?utf-8?B?T1BVMDZwV0xvYWNRa2hneC9zVmVpdVJjNXFOMjBqQTRiQm9YSFZPSWw0Yy80?=
 =?utf-8?B?QUt1aGY1NmE4NzJNTVpUekFIM1FGaVVXNXZ5WGlWTEVOM3pFdkw5S1o5bHlz?=
 =?utf-8?B?MlZNdVdZd3VWY05RNFNvNDJVL0NkaCttcHh0aFdyMFRVcDAzYWI0SEpMMWtJ?=
 =?utf-8?B?SnBRWWtsTkZDbmZTNFZqTExXdDJWWFlheFBmekNrUldJaTdKelhTN2hmOG5u?=
 =?utf-8?B?N3FUTzRQU1VrZDZsSHhHU3U0MGtNZ3A5aG9pdWJOV05TWGpRTmdjdmw5eFFi?=
 =?utf-8?B?cStzM1FpRE9DZUQ0cDN0UDVDVnRocmwyUEgxb2VKR1hzK2FteXN1dzNvVDlB?=
 =?utf-8?B?N2NleFdFbE9YODFyS3Mxa25RaWNIVkE3NFA4bzloam9UUHcwQXZQRzN1QUJj?=
 =?utf-8?B?dGVnSE9TY3ZqSktqVlpnUHFoSmZ5RDFwZTM1ZVR5U2sweDgwK0VnWDVwaXht?=
 =?utf-8?B?WDhyQjVjVW84alU3UmZZTURIdEhUdldQd3pxamYvSTdKajJCSlhIeGJwL0Vs?=
 =?utf-8?B?OGlJVEFlK1BTQk81bGtTdndFWEgwayt4VUpmL0tNVVJMTGFoaW1oVitqMEp0?=
 =?utf-8?B?L0tXL0ViOFY5V3NQM3JWWXJJSG5Za0ZFNHd3dTlHbkRmc3NxS2xoMDdsRjFO?=
 =?utf-8?B?Rmd2NUtCUGdTczlObUFoa2FzRjJaa0VTU2RCdEN1MEZScmErZGxMdHpJZTF3?=
 =?utf-8?B?bStScFQ0V1Axd3c3ZlJMSzBEQkh4MW1MNlAxZzlFODZjZzMxdXR5L1V3T004?=
 =?utf-8?B?ZTR3MGx4aUFpR2FOTkdCdnhEY0lCZ0cvYnV2UE9XdER2WUVUMnlyQUtnQzg5?=
 =?utf-8?B?SUIxczVSVlhGckd6VzNMQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHhmWndxa05mQWtDQlpoaFdxeG8rOG9qVUhCQnNXMllpd3ZOaElHZUpsQmJs?=
 =?utf-8?B?SjZSSTBYU3VWS3hTaDFoUEtXbzJBOHhYTGl3VWk2T2ZOaEE0aDQ2V2F6UWQx?=
 =?utf-8?B?bnNIbUZTTnNrOWxLY1pjdEh4V20wQXB6dDZSZFNBdHlucmVtcUo5TUJzeEdN?=
 =?utf-8?B?REJpaVZoWnVhS0M4R29wTGFReGZPSFF4Z0N4b3FmSUhROUJ0MXR5NFZnTEFi?=
 =?utf-8?B?aHJiNjFOd2h4bGpzVzhBZVRYUTYvcnVtR0NuU0dEaHJCaHpLbDdtOUg4cDJj?=
 =?utf-8?B?dTJsMVRWL0pCckgwZWl6TE1KRDUxeE9zTXJSRUFjb3BlNk1YM21nbkVvR2Na?=
 =?utf-8?B?Tm1OWTBhY1oxRFc5YW44UjhNMUhLQ2IxSVZjeDQycE90elVsMjBDa1dGLzhJ?=
 =?utf-8?B?U0F6anZQNUl3Tkp2YVZyK1hmR0FVUnJLd3I2cmI0MVNoNVVuTm1iWW1FWFo2?=
 =?utf-8?B?RlFVMkV3TmR6M1cyRTBvU2RpSThnUlJNVWlRaHpnUzJEOFJ2UTcrRnI0WUpm?=
 =?utf-8?B?bEd0anh1RzUydGdKTVg4VVpMY0NmMU1xWS9NY3dNWTIwWmhzVVhUOENpYWlq?=
 =?utf-8?B?bk5oUSs1TFBzRHIwWHRta2E2Mk5wMmo1MlJLdnlVaWhBTGFwckNZc29VRWRT?=
 =?utf-8?B?WkF6ZUtQWXBzYTVPc200OWRFQlhJWDFkOTBFcURYV1d2QVpRQXJTZklyNEpn?=
 =?utf-8?B?VmVnb0lhMm85VjRza0dOR3RFTCtvSkVVT2FHSEh6ZnYveTd0dVZBTHMwdFNq?=
 =?utf-8?B?WWQ2akJKN21DMnhDdEMzRHlIaHBrK1JWU3NaUnJZRkcvSEVteHU1TVJ1MVNH?=
 =?utf-8?B?VWs1NzRrSXQxcnFvbzdFZ1h2UjQvNXhTVGd1bWsrNjNlby82M1lnRFN6V2Fm?=
 =?utf-8?B?eHdGcG5BdTNhQUlpak84K0xlZUwyZXZxNjhTejJKZUpxd0JaLy9RazRTUG56?=
 =?utf-8?B?cVIxazhod1RHRGl5U3N4SFQ1TjJYaUJCNnVWaEk1aVE1R1Z6eURsTkVJN2lh?=
 =?utf-8?B?OGp5ajVyZklWYzBQSmFhK0NQUmhSbHQwZEFrSGtCQThSTkxUN3AxSXhXb2dS?=
 =?utf-8?B?QzZyajRLbE1Gd25qOHNHT2EySzBLRkFKSEJVenc4YjRpa2JVZXB2TTU5cjhR?=
 =?utf-8?B?YU1JUmhPMjVMTXdmTjFLTm85dDV2Q3dPWGpmak9HMmVvVWkwbmVnU2lwaVNz?=
 =?utf-8?B?bkw1dEwvdlFUZ1poRWU4QytjQmczcCs0YWhkVFkyT0wvNG1TN21xVHVMN3c4?=
 =?utf-8?B?em84N3p2S0p3Z3h2dGl3bGRkZjM3R1RRWmtzRUsxeUJUNHVxUlkxS1V1cXdK?=
 =?utf-8?B?QXZpK3M4YTFwSWNYUWcydW4zaDEwekxlM05kdjZqcHU3WFFkVTJDemowVzNj?=
 =?utf-8?B?TGNOQ2EySmlSd2VmcFArd1JONzhNUWd2V3k2VW9lRXA4Yk9xTmZSUzBIZFh1?=
 =?utf-8?B?UUVmb0YyR25KNzR5Y0ZwL0xuTDVBTzg4alR1Vzc3UjNvT2N3NWlOZ0IydUpR?=
 =?utf-8?B?ZEMrc3ljbUhKTWZGbGQ3Nlg4ZzQvR0JsN3paOGY1SktnTDRUTWkraVBDOFpF?=
 =?utf-8?B?VEhBQVRpb2FGTnFiQS9MK0p0QVZsbXcyNHd3bTZUTkthYVM2LzFxUlNlNVVj?=
 =?utf-8?B?TnJQeExzUmcyVHV1eXpHb0FUT21Gc3VvTzRmcXRoT1krLy9CZDhWRWQzOWdu?=
 =?utf-8?B?bkcyV1I1bkRFMzJIdW4rR2FkL0ptUEZXMTIxMnE2Y1VwQzkwV2hRaWZjTnMy?=
 =?utf-8?B?NlNIalNlb2JjeEh5SEErL3hhdzcvNlNEM1gxTFRGTjk0dXBYNjBlQ0loSkU4?=
 =?utf-8?B?ZFY5OWt5cVphQ1UzNEU2N3Mwc05pdUtSUUkvaTZ1Lys3ejg4ZWpMRHRPV2Fz?=
 =?utf-8?B?b1liblVrU1c0cFlMQlRpRVd0bUVRc1FDMXZaRlBrRnJoY1RWcGlEeFkrNkJh?=
 =?utf-8?B?cTBxTnlGWVJqeXg5dFBOakt0NlBrUnVBak0rWlpua0ZYRllDbG5rVDgxUDFY?=
 =?utf-8?B?aytYV1pNRjFXR2p1dE9tb01veTRYbUkxU2k1SWw4QkR6aGlLRVdhOHRzMk50?=
 =?utf-8?B?empDK2FwQ2VwSFExRFZLaEFpQVkvbWJZZndtYWtxL2dqK0FCLzNIZEJ3dUoy?=
 =?utf-8?B?UUE0VWJXSDZaMFpKZHJ3MlMrT1NMSWxmc3p1VlRYWW1keGpGUjJnUE5NZkt6?=
 =?utf-8?Q?f2FDTc5X4Ja4oRKEkrg42BI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FE14C6E6809914CAEF3764C029B63E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784e9338-2580-4860-3553-08dc6580df99
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 23:38:56.1225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XeaQ2KB+VcaXWXqIRbt8fvX2DL0M+5OmnRW5f78WhxKwyOs+ExziFRzv1uAzW1/QgrY3nW0P76126iEOL/6cgrLGhvlznmFgEusNKLf/Nvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8750
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE2OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiBJZiB3ZSB0aGluayB0aGUgVERYIG1vZHVsZSBzaG91bGQgZG8gaXQsIHRo
ZW4gbWF5YmUgd2Ugc2hvdWxkIGhhdmUgS1ZNDQo+ID4gPiA+IHNhbml0eSBmaWx0ZXIgdGhlc2Ug
b3V0IHRvZGF5IGluIHByZXBhcmF0aW9uLg0KPiA+ID4gDQo+ID4gPiBOb3BlLsKgIEtWTSBpc24n
dCBpbiB0aGUgZ3Vlc3QncyBUQ0IsIFREWCBpcy7CoCDCoCBLVk0ncyBzdGFuY2UgaXMgdGhhdA0K
PiA+ID4gdXNlcnNwYWNlIGlzIHJlc3BvbnNpYmxlIGZvciBwcm92aWRpbmcgYSBzYW5lIHZDUFUg
bW9kZWwsIGJlY2F1c2UgZGVmaW5pbmcNCj4gPiA+IHdoYXQgaXMgInNhbmUiIGlzIGV4dHJlbWVs
eSBkaWZmaWN1bHQgdW5sZXNzIHRoZSBkZWZpbml0aW9uIGlzIHN1cGVyDQo+ID4gPiBwcmVzY3Jp
cHRpdmUsIGEgbGEgVERYLiANCj4gPiA+IA0KPiA+ID4gRS5nLiBsZXR0aW5nIHRoZSBob3N0IG1h
cCBzb21ldGhpbmcgdGhhdCBURFgncyBzcGVjIHNheXMgd2lsbCBjYXVzZSAjVkUNCj4gPiA+IHdv
dWxkDQo+ID4gPiBjcmVhdGUgYSBub3ZlbCBhdHRhY2sgc3VyZmFjZS4NCj4gPiANCj4gPiBJIHRo
b3VnaHQgdGhhdCB0aGUgc2hhcmVkIGhhbGYgY291bGQgYmUgbWFwcGVkIGluIHRoYXQgcmFuZ2Ug
dW5sZXNzIEtWTSBnZXRzDQo+ID4gaW52b2x2ZWQuIEJ1dCwgbm8sIGFzIGxvbmcgYXMgd2UgdGll
IEdQQVcsIDIzOjE2LCBlcHQtbGV2ZWwgYWxsIHRvZ2V0aGVyLA0KPiA+IHRoZW4NCj4gPiBtYXBw
aW5nIHNvbWV0aGluZyBhYm92ZSBpdCB3b24ndCBldmVuIG1ha2Ugc2Vuc2UuDQo+ID4gDQo+ID4g
SSBkb24ndCBzZWUgYXR0YWNrIHN1cmZhY2UgcmlzayBpbW1lZGlhdGVseS4gSSBleHBlY3QgdGhp
cyB3aWxsIGdldCBtb3JlDQo+ID4gaW50ZXJuYWwgc2NydXRpbnkgaW4gdGhhdCByZWdhcmQgdGhv
dWdoLg0KPiANCj4gT29vaCwgSSB0aG91Z2h0IHlvdSB3ZXJlIHRhbGtpbmcgYWJvdXQgS1ZNIG1h
cHBpbmcgYSBwcml2YXRlIEdQQSBhZGRyZXNzIGluIFMtDQo+IEVQVA0KPiBhYm92ZSB0aGUgcmVw
b3J0ZWQgR1BBVy7CoCBJbiBoaW5kc2lnaHQsIEkgZG9uJ3Qga25vdyBfd2h5XyBJIHRob3VnaHQg
dGhhdC4NCj4gDQo+IFllYWgsIHRyeWluZyB0byBzYW5pdHkgY2hlY2sgdGhlIHNoYXJlZCBFUFQg
aW4gdGhlIFREWCBtb2R1bGUgd291bGQgYmUNCj4gY29taWNhbGx5DQo+IHBvaW50bGVzcy4NCg0K
SSBtaWdodCBoYXZlIGJlZW4gdGhpbmtpbmcgdGhhdCBhcyB3ZWxsPyBXYXNuJ3QgdGhlIGZ1bGxl
c3QgdGhvdWdodC4gU29ycnkgZm9yDQp0aGUgY29uZnVzaW9uLg0KDQpJbiBhbnkgY2FzZSBpdCBz
aG91bGQgYmUgbW9vdCBmb3IgdGhlIHNvbHV0aW9uIHdlIGFyZSBnb2luZyBmb3IgaW4gS1ZNLiBJ
J2xsDQptZW50aW9uIGl0IHRvIHRoZW0gdGhvdWdoLCBiZWNhdXNlIGp1c3QgYmVjYXVzZSBLVk0g
d2lsbCBub3QgZG8gR1BBXzQ4IGFuZCA1LQ0KbGV2ZWwgRVBULCBkb2Vzbid0IG1lYW4gYW5vdGhl
ciBWTU0gd29udC4NCg==

