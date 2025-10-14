Return-Path: <kvm+bounces-60037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EB81BBDB6CD
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CCEE54F7F12
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06C0296BC1;
	Tue, 14 Oct 2025 21:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hS2Xkx+S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C211FC3
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760477831; cv=fail; b=fFn/FhF9HLFk2CSowL1Sk8gpdXXxP/uR/G/Q3gsFAd/CtzSFZq9D391HIBik7/xPoSd4NB8jrredj3qIDQDaZ4tKLvpB1Ziqov+vCrN2nbe4CZY2G0gqG9kKyIU27sMTexGgNmSmDfYkqFwfutTqRW9aEbYpt1dT/+ynkGN0bGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760477831; c=relaxed/simple;
	bh=VrmltnU+hZMYMG2/X8S7KZjwwp3YGYV4NqygZBL8gmQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YJCBFc/6XuYhNes3fXCWLER/9SrVgaZIqtAdafIMnSPFsH5aJxPKbFwYISJnOSimJejq9gDy8gVBy9MZysIKDaYrl6y50kB/3R/Z+UbK4fLOY7feRKgyMFGfklghG8Zm7G4gmDZx//8K4C8kK72qQCcHPqtCqc+PNUW13nfCtGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hS2Xkx+S; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760477829; x=1792013829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VrmltnU+hZMYMG2/X8S7KZjwwp3YGYV4NqygZBL8gmQ=;
  b=hS2Xkx+SOcvWxp5fcrvmP0KuibIrfRNzdLGxECkxd3ilvGsC23UqkAGA
   H7wiJGrmR1ci9oS29VIlf3WqeyzEMKc/anGANgFQyXQsNcnXwoardh95L
   iA14PIRYxiMP/8CWQW1I8u52YswTkDtOHRGDPkJgD6o6+g/reVjmmhg+c
   FdVlapABpr/Rs1TE7H1yHBuhPG86itqb7LrwKa4dvEkPTNwd3wDQODKan
   YrMRj8OvXEIHoVHYV3P62ntX0PT2VqOk3p5qfa0HLcCzGJ7txpJyok+xX
   CbFtwPVlY9A+oAaux5L/ZCjbBp8yq5TFTj0dgDh8fyAOqNEPZjQs87s8y
   w==;
X-CSE-ConnectionGUID: 1nMoJ156SxGrvx1Js6RAdg==
X-CSE-MsgGUID: KeU0DScdQsi09Wmq6sJK/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="73989390"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="73989390"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 14:37:08 -0700
X-CSE-ConnectionGUID: 3nj0j16FSF2VtaUqZkmFhg==
X-CSE-MsgGUID: YI42lGEiRROjNyBhEQR6uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="182469875"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 14:37:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 14:37:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 14:37:07 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.18) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 14:37:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RLrJWNDLU4BQLlo+1+UE447wgMX702F1hcsQrDrP8u+Gjeky8Fi6CvyHlDfM+lKKsTn5du+G+MoY1JmY7OaZGPUSlYSw7c+G/0MzEPjkzllVoTMNG4soEXFD3nbPVovc1ak4MAjkUYEPIGP6vZOsun19vjYUh/WRLhTnZLW4++gNm72S90//uDC+kZtTl9Bkq7OLuR0FBDQWZL2wE3ilNpdEI5Yg+ioQ/DoIlfvmyrSCBLbsRgXSJ2Ku7yH0PkA4AFBKRTV7LKSkmpRUKgqq+TD5wFfiLsr2TloAFeDCUwIalQcyjlF2D1aDEigNmKL6OPlf/w/bK7PT3IIerTHQqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrmltnU+hZMYMG2/X8S7KZjwwp3YGYV4NqygZBL8gmQ=;
 b=fkO/J0mtoDf0DTgwwHZCVaQN0I/KLeRaW8EDg73kPVkNMpFedQ4PnhO5VmmwUe38yomlv9wjevd9nSaMUMW6AENPkywiP35yq/jFsRhtNwl0wnSRnDfOAbaknqs1P9qBaoBfXR8FbYqc73d9KhuyJgwFaxPJS7rG7aW8CNUy6dzc28KdXuhobSX/fIPa6auXItvrNe+mqUU0pqqTtizOrm4eRcFWMg6EJWsjFulkoVbjwgotbw8iBHsol+BIl082/DpbcA0fK6ZbWuLvUcK5v0Rq9Wn7Wq46V3Dyw4lStGCxg/FezjE4q/2DDFeM1ft2mdth7+jVumsInGy/wDgiwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPFD6B8A798D.namprd11.prod.outlook.com (2603:10b6:518:1::d51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 21:37:05 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 21:37:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "nikunj@amd.com" <nikunj@amd.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Topic: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Index: AQHcPApHQq5GYUzMbUWZEhHpuKXxubTBhNuAgACYtoCAAAw0AIAAA4EA
Date: Tue, 14 Oct 2025 21:37:05 +0000
Message-ID: <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-5-nikunj@amd.com>
	 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
	 <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
	 <aO6_juzVYMdRaR5r@google.com>
In-Reply-To: <aO6_juzVYMdRaR5r@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPFD6B8A798D:EE_
x-ms-office365-filtering-correlation-id: f76ab18f-f5c3-4c0f-1983-08de0b69d1c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cnpMaklRM2NHMm1KeWphelFHeHlnTDJCem8wS1pIeStwZzVwSEFvSHZ4V1Zl?=
 =?utf-8?B?TDNxaW9JcXBRODZTZkRtYUtDY1d0RUUxWWk4RUszd05ybnBVWVMvTTMyQ3d2?=
 =?utf-8?B?NWJTMDZZZWI5c2tVWUQxVjByYXpMakNaR0NGbkkvZDF2UkQ0Z0VaczJjUEYw?=
 =?utf-8?B?ZjRpNDVOYUxwTXBiS2RUZXl4YUxQZDNBVzh0U1pTcTVhWlZpZmxiM2k1VEUv?=
 =?utf-8?B?RkFrRXQ4MEpQOU9mOWVsdGtRcmVRL2xONE9HUlkySmFDNEJLeWNndSt0UURr?=
 =?utf-8?B?eTBaeE1INkFyWmM5SnVVVEJQZ1BnMnRnZDBXMkdoWFdIRnNhMEEzcW9WNzJC?=
 =?utf-8?B?eDdkbExUNnpPTVZvSmZVV0IrWGZpY0haQ1FaUjcxTVJaZmxJeTRTZWVtWVlI?=
 =?utf-8?B?am9TWDFNU2c4NkdZY044KzloMlpBbm1CTUg3ZHZoa09UOUxZUTI5ZWlUUFZx?=
 =?utf-8?B?SjJyVmhGaDFNOVFXQi9wL1R1Y0E4WnBTSWxvWEFLODJFUWN0T29pelBsT2Za?=
 =?utf-8?B?a1VCMEZLSmQ2R1pRa0xBc2tvM2xSRUErSkFTdlhPSEVrMHphUTBaNS81elhs?=
 =?utf-8?B?R2xmNisxeEFmUjdGS2NQb01VOFI0TS9wMllIOWtaNlR5T0xZMWp6bGF6cVNi?=
 =?utf-8?B?RUpxeU1ITWRpbHgxb3Uzd2s5azlWN2lZK240Q1F2TUpyRHhlNmkwanU5aDBv?=
 =?utf-8?B?QXNWQ004OCtkamNHWWcyWUJuS0F6OXRFa25aV1Q5enZCdTFJdDVpMDIvVkFG?=
 =?utf-8?B?R3JuemFVcmlxZ0VadG5IaU0yaWU2REw4ZjhlUGtzZlQvUjZjOGNWUW1tNGMr?=
 =?utf-8?B?Q290RktoZlY3QTVTRy9mbXpYYk05bE5vcHcwaEdoZ1lnN2I2dkh4Q0ljNnI2?=
 =?utf-8?B?TVFzZUpZRWJDTWJ3Sko5V1RVWWNDL2ZndW01aDBUOC9UN0pxOGZiSlJoUzJp?=
 =?utf-8?B?S2FNakhHcTFkQnhkZ3VlVDBaQmt3alprQ3dWSGFJSDBocmRUVTh6cTNXY0Q1?=
 =?utf-8?B?ME44U283TU9RN3FoVmZLK0xaSVZQSEFlanJTdlVnT1BRczE2dXdkMmpQN09x?=
 =?utf-8?B?TUx5b2xralRuaWZFY3VJUFA0MjZ2RjJ5SmloVTlJcGZIVXJQUmx6cWlqNTFa?=
 =?utf-8?B?OWVEUHovaGdpSjZLQXY2cjgwNDYyeTBHWitHZWhlNXpQYVp3Um9SVFB5Rnlj?=
 =?utf-8?B?bFZpM3lQclEyRUFGSTJNK2FoNkJka0lWVkxHb212YnNGUXp5ZGMxWnA2R1lL?=
 =?utf-8?B?bE1EWDZ6N3FWSUw0OUtFUVg4Zm16NVBpK3M2eVVpREE1V21aWDJRdmd0c2dW?=
 =?utf-8?B?N3Z1OTFQWjFrWmZEa0VUeTVuV2NmMHBjcis0c3Q2OE5Rb0x3R2prK0RNUmFx?=
 =?utf-8?B?VTNESVVjaVY5dWxMdmMreVpXSkdmZ0xqdWJhRjY4RlVSVFkrbmNqYkRpTXVi?=
 =?utf-8?B?S25uVWZVNHJKVVhLaGpBVFQ2dkJkdFluUXdZL3JlV2Y2WFRwVmllU2NVNEVN?=
 =?utf-8?B?SDYza3oxcFB0dWJVM0thQmZRNWxwZkxDSFFMRGJMaGZRYm9ydjhuSzBuR1dX?=
 =?utf-8?B?N25JbGo2MkwweFpVZE95OVhGR1N2TkpHVEdnRHRPRnJ0N2VyNm1aK0ZLZS9R?=
 =?utf-8?B?NUEwd280OHNjUmFwemFiS3hrajRtMTFHVWpJTXVyeXVSYXVLeVhqTkg1OXJT?=
 =?utf-8?B?SndldjgwQkhscnhhdGcvcmZaVW5SelRQTUdQUkJZeElKWE45dldkUCtvaS9J?=
 =?utf-8?B?QlZPck1INXVzTmxlUGkzeEVHZ29Na0VOejh4SGFla255MWJ2RFJ3MkpBaFMz?=
 =?utf-8?B?YWJOUUVBWFVBTVZWZmhubUNDdEhMc3hoZ25FbkJCaXhmSVNFd1lheWY0K1RZ?=
 =?utf-8?B?bktRQ1pRcTdsSXpndnJNU05kcUV5SkVOU3lFb3FFL2pHMFFxdEV5Y24vWmhC?=
 =?utf-8?B?TEF6dG9VZERNSHRpZStKWEdVenhGbWRhYWdtSUZhejR1b0hIMDZmaEVGaWJU?=
 =?utf-8?B?NHBlL0JIbEJJRWd4YklIbFpVb3dQdGJvdWdvR2NDM1NLaEJPaEJMbllDL0Nq?=
 =?utf-8?Q?B0+oq6?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGp1VXpQQVlDQlZwemtXc0QrVHpLTGJMV1VvWHFleWZZUVB2ckdjcWwwdkkv?=
 =?utf-8?B?cjVJRThISzFVZ2d0MmNmdmF3ZDhSMU1wd2tlK05uaEN0M2FpOHc5dG1tc2Fr?=
 =?utf-8?B?bVBUQVhmMU03Qjl6bFJZQTBNTWtUdkhLQjl2RWdxR3NHL2JqUVBmU0QzQmVW?=
 =?utf-8?B?UksxVWZ6S1I5MTYrbThXRXZHb2ZscG0xTEZjWC9BUjdSd0RsQ0hRWFMzcEc2?=
 =?utf-8?B?eDlOY3VEYUovV1ArNjcydnNKNWYxVlBTd05QRktPdUd2dE0yZG5EL0NlWFhr?=
 =?utf-8?B?ZXJyM2FZU0FBcFhHOG1uRElHcXgyQ05YMWo2Vm1BZ2E0MDJVTTk3L2hLQTJL?=
 =?utf-8?B?d295RVlSZFJNN0JkSkRaVjYxNjNTZEpQSU5tbklrVDJ5S3oxMndITkg2ZkVF?=
 =?utf-8?B?ZHZENzhFcDllYVk1Z202M3hkZjJxTHpuK3MvaEZ3YjAvNG9mUlNKWG5VQmIw?=
 =?utf-8?B?K3VnZ0tMeW1oaUkyUGJuWDhSVEtkZFJGa1hHZGc4Y3BOSzlhQThpdmRaaUhI?=
 =?utf-8?B?Mk5PdFlXUFc1ZCtpSVkxdnZORGZGVWhZaHpVNnFBS2Jzd3AwVGVTY2dSYmFa?=
 =?utf-8?B?bURmQ3hOb0R2VHZoUExRNERWVFJlbGt5THdXY0l1RmtBdjJlVHFwN0dPT3Ju?=
 =?utf-8?B?clBvVDMwYzU5RFM3ZElSVzhJaXVsR3p1SFhKQTBCNVpKZmttYmMvdVpQdlJn?=
 =?utf-8?B?eDFaUGxOY2g1YndTYkF2emhQMEwwN015cWxVREpDcU1lOFFnTVJ5MG9HVFZN?=
 =?utf-8?B?a3VUaUk3OEZDSmpsMFpoNndmQ0cvdXJWRk1RTFpHd0FCcFpmTW1rc0YzaWRo?=
 =?utf-8?B?NFRxVWpzVmNQZHExT0VhQjNNNnNZN3pSYjhtOVVidjJzcFhrTHFXM29rWU4y?=
 =?utf-8?B?SG1PczJYZ2NyMDZFNHNsNXNWZ0JHUXIva3J0WHhTOEhxbzZVb1BmU2xmbnlM?=
 =?utf-8?B?OTFZY2ZJeHRPOEMzV0VMbVhLbFNiREwxdHdmaVE0b0JVUGE5bkxnWjNZMlZG?=
 =?utf-8?B?WG1vOGU1UDFBR0E2Yk9SWHhKTDlmRnhPUWpBVGRJamV3ZldLek0wL0ltSDVo?=
 =?utf-8?B?RkQzdkF0Yms2THdDVjl3K1duUHRKU2ZtUzVoeVBxdnFRUWoyWk9NQTRINTJm?=
 =?utf-8?B?UGJuQmRMNlZwVlFsVVRWaVF0RGRlaTI5K3ZUaVZKeEFteEhldGJVSmJlUnVS?=
 =?utf-8?B?eXdJcGxHcjl2YTlUdzdEQXltcm5xWXhKYWtvNVV6eUNyQVJpVEZXYXVsM3pO?=
 =?utf-8?B?akJnVDRKRmp0cHVWZFAvUUtpMjh3NjJ1MU8xTWdGWW1iMXdLd0RJLzFKaUcx?=
 =?utf-8?B?bzRrOG5RMjhrT0lSZnBwalpMaUNxZDNxd0pNZk05b3Z3dFgxVzZMTFhLK0tm?=
 =?utf-8?B?TWpnekRkd1lkdDMvajFHbzJ3UTlZdmxVcXloaTQ4djlQQzlhanBza2QvOHVq?=
 =?utf-8?B?emVxcGZKUTlVRnRGdVJVbVo4aTkvOHZ0ZStiVWNMQ2M3bzVBa1VMOVcrZDJS?=
 =?utf-8?B?TlNsRElTQ1V6T05IRnZrTEpjMDgwcUt2SU1LYXNaVnZKcERPV3o3OTg1YWd5?=
 =?utf-8?B?SFZUVVlqcW5jUXk3Vm9zQ0VFUDREWDdEbks2all5eXovbm9vVEJyRjJnQ3dV?=
 =?utf-8?B?eWkrRGR1S2JzU0dQNDZhSnovVGlXODRnYm15ZXJ6YXBuUllGK1BYdjdFS1Vk?=
 =?utf-8?B?RDYwL0ZtdmYyRFJ3Yk5odXRrN042TCsxd1F0Rk9rdnhvaE5id3VxMHRrUmZV?=
 =?utf-8?B?VldETHo0LzhLQUU1cWJyQzFYSkhnTE5qNWpkU3lUNnc4ZGVFZlJpengrWHBq?=
 =?utf-8?B?cXV6aDFWcGNSMmRINjAremQvaUVTeFRzVG4xK00zR0hIWXBUWm0vdlNESHRz?=
 =?utf-8?B?NHpwVkF5c09GanNVaDlBSjNtZnJYbEZkVUNmRVc5ZUd6M0IyTGZkc2JkSytw?=
 =?utf-8?B?eXIyMzdyamE4RG9RVzZ2cTBQYWR3M1ZjclNmS042ZFNRTXVSS3FwSFRCY3BV?=
 =?utf-8?B?WkJONUpPeEQwWkFKa2dGUG5rZzJ0amxmSHhzRmljS3JVamZuOVlXdEtLT0xk?=
 =?utf-8?B?TVhkRE1YbkZ2dk51R2xOQ1hrMGpQR0kzR0xqZmFTaUJ0a0JtbUhiTWFQL2p4?=
 =?utf-8?Q?SPNd3nWkz+vlu4yxRmsxgDnrb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <471C426DBF07744ABD74A15C0DC5D412@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76ab18f-f5c3-4c0f-1983-08de0b69d1c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 21:37:05.1447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+xTfXcYvCGuTXS47wLZIoPLtAKbkYI/mv9AIo0wnW/GWWs9HzHwRmMSDhyJkdS5pijSBuhlP/l77V7iKLEpYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD6B8A798D
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDE0OjI0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE9jdCAxNCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNS0xMC0xNCBhdCAxMTozNCArMDAwMCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
wqAgDQo+ID4gPiA+ICtzdGF0aWMgdm9pZCBrdm1fdmNwdV91cGRhdGVfY3B1X2RpcnR5X2xvZ2dp
bmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gPiArew0KPiA+ID4gPiArCWlmIChXQVJO
X09OX09OQ0UoIWVuYWJsZV9wbWwpKQ0KPiA+ID4gPiArCQlyZXR1cm47DQo+ID4gPiANCj4gPiA+
IE5pdDrCoCANCj4gPiA+IA0KPiA+ID4gU2luY2Uga3ZtX21tdV91cGRhdGVfY3B1X2RpcnR5X2xv
Z2dpbmcoKSBjaGVja3Mga3ZtLQ0KPiA+ID4gPiBhcmNoLmNwdV9kaXJ0eV9sb2dfc2l6ZSB0byBk
ZXRlcm1pbmUgd2hldGhlciBQTUwgaXMgZW5hYmxlZCwgbWF5YmUgaXQncw0KPiA+ID4gYmV0dGVy
IHRvIGNoZWNrIHZjcHUtPmt2bS5hcmNoLmNwdV9kaXJ0eV9sb2dfc2l6ZSBoZXJlIHRvbyB0byBt
YWtlIHRoZW0NCj4gPiA+IGNvbnNpc3RlbnQuDQo+ID4gDQo+ID4gQWZ0ZXIgc2Vjb25kIHRob3Vn
aHQsIEkgdGhpbmsgd2Ugc2hvdWxkIGp1c3QgY2hhbmdlIHRvIGNoZWNraW5nIHRoZSB2Y3B1LQ0K
PiA+ID4ga3ZtLmFyY2guY3B1X2RpcnR5X2xvZ19zaXplLg0KPiANCj4gKzENCj4gDQo+ID4gPiBB
bnl3YXksIHRoZSBpbnRlbnRpb24gb2YgdGhpcyBwYXRjaCBpcyBtb3ZpbmcgY29kZSBvdXQgb2Yg
Vk1YIHRvIHg4Niwgc28NCj4gPiA+IGlmIG5lZWRlZCwgcGVyaGFwcyB3ZSBjYW4gZG8gdGhlIGNo
YW5nZSBpbiBhbm90aGVyIHBhdGNoLg0KPiA+ID4gDQo+ID4gPiBCdHcsIG5vdyB3aXRoICdlbmFi
bGVfcG1sJyBhbHNvIGJlaW5nIG1vdmVkIHRvIHg4NiBjb21tb24sIGJvdGgNCj4gPiA+ICdlbmFi
bGVfcG1sJyBhbmQgJ2t2bS0+YXJjaC5jcHVfZGlydHlfbG9nX3NpemUnIGNhbiBiZSB1c2VkIHRv
IGRldGVybWluZQ0KPiA+ID4gd2hldGhlciBLVk0gaGFzIGVuYWJsZWQgUE1MLsKgIEl0J3Mga2lu
ZGEgcmVkdW5kYW50LCBidXQgSSBndWVzcyBpdCdzIGZpbmUuDQo+ID4gDQo+ID4gSWYgd2UgY2hh
bmdlIHRvIGNoZWNrIGNwdV9kaXJ0eV9sb2dfc2l6ZSBoZXJlLCB0aGUgeDg2IGNvbW1vbiBjb2Rl
IHdvbid0DQo+ID4gdXNlICdlbmFibGVfcG1sJyBhbnltb3JlIGFuZCBJIHRoaW5rIHdlIGNhbiBq
dXN0IGdldCByaWQgb2YgdGhhdCBwYXRjaC4NCj4gPiANCj4gPiBTZWFuLCBkbyB5b3UgaGF2ZSBh
bnkgcHJlZmVyZW5jZT8NCj4gDQo+IERlZmluaXRlbHkgY2hlY2sgY3B1X2RpcnR5X2xvZ19zaXpl
LiAgSXQncyBtb3JlIHByZWNpc2UgKFREWCBkb2Vzbid0ICh5ZXQpIHN1cHBvcnQNCj4gUE1MKSwg
YXZvaWRzIHRoZSBleHBvcnQsIGFuZCBob3BlZnVsbHkgd2lsbCB5aWVsZCBtb3JlIGNvbnNpc3Rl
bnQgY29kZS4NCg0KWWVhaCBjb21wbGV0ZWx5IGFncmVlLiAgVGhhbmtzIGZvciB0aGUgZmVlZGJh
Y2suDQo=

