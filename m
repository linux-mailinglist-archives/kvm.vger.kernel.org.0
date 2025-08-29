Return-Path: <kvm+bounces-56373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B85FB3C4B2
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4865916DA65
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE8C27978D;
	Fri, 29 Aug 2025 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ABBDd2c3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971E11D61BB;
	Fri, 29 Aug 2025 22:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756505864; cv=fail; b=uIlYrnaLuz5u7SXEXV/CNGF2/de54VYq1iys/IhMBgKdRksRO7ygKND9SIyG1LNC9aqCzQ0lWEGWkykUhTxQpJn+U2/fWKHRkOm4rshHGufwviOtbcH90l9Td/zncAr5+4A0hUtbQXhmNtWIfu8IOPRr+fPcj9YoPlkLweCDHaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756505864; c=relaxed/simple;
	bh=XxJuBwZrvAypneYRjxiyM0To2wpwuh5vbvbGYT4WlWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XbZMazOiELhyM60RfGEq+LA9EjdrpHiOlwXXPei2rXWFbmHFaK30gdWdo1LQCGgYZAmSviAsO45P2bHBId2nWrDMApxpZ6yBfn0GK2BeMPtGcYL5TpxisVAIVQVOp4lkyIJE5jzJQ8L6w3Dfy3WnC5w8OW8EH2HoShQKoJzrCu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ABBDd2c3; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756505863; x=1788041863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XxJuBwZrvAypneYRjxiyM0To2wpwuh5vbvbGYT4WlWs=;
  b=ABBDd2c3xmDT1OMb0Qy6qkf77rbT5kmLVokrJWPo+RchSHqWEJn39Fq1
   5KxfMOQJaBuPN+O20l+Slk6FUQAwpfhGcji1/XF1m8e6MiibtsMhhrdnB
   h3AtWDJXIColQhxMG998qQhaKUvPeHrzo9g+GfwD7q1oM1xj+HXCbbEyw
   ugQCdnTS8RstOPBgg43O+gbwLDLxpCu9Ow0C0pLcfQuhnqOUP8fTOQlwC
   R0SX+Gy4Pb1C6oAlnFm2jFZ/9a2I1llMxBFkHgzvg7wohBCi0UWzWEtvd
   nlYzKnKp6kxCB47V9zo9FPUdcYvRAeEehnWjlx68MfgsdSlm/NeqNhdFH
   A==;
X-CSE-ConnectionGUID: IVyihbw/QISDK+KIo5eWEg==
X-CSE-MsgGUID: B9MLKWrMTXGOvQ6FrRcBCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="62617603"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="62617603"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 15:17:42 -0700
X-CSE-ConnectionGUID: NHgPHrJESi+IsPtpEGdTgg==
X-CSE-MsgGUID: g5mrRT56Sb2XUuQJug+M6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169735530"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 15:17:41 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 15:17:40 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 15:17:40 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.62)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 15:17:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qEFaMgRPsQlU+ajPDkpk7c95bzbb3A1dBezaaAjdmyV1+1ERigEiaQ/d0WzcGHzkzGkBB4TWDaQ4O6F3kslETHs0D03tjYEL5KCQwTdX2tqStuxUQuANnZVSiOf4Rfplwv/0QC0T5+2X2zLkgtdktw4y7yt9Da9DAr6lS00DjHX1Sb/ZKUYStFesYvbSps9QltVILnDufkfydfvAvbRmaiEn0ALEbj7O04kHGpLvvjcglX1MGz0mta0RfwYy+TEaN84UjwYV3imsBFYdS/wT/6e7/JaLwu0jgcqwOgYwVgruazwQVMvFBVTDy4eLy9/LkqFDS9wg0HvtEQIqMK0bCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxJuBwZrvAypneYRjxiyM0To2wpwuh5vbvbGYT4WlWs=;
 b=jMK0NaNmwLnmxgtQi5PxkKqPPsGEVZpA/TIItqjo2IdrFJCeoCG1zeTyG8BOnLypjNOOAvSVkJZtWcMUfL5wHl8+NAs7O99v2kgguYDq8421GRVDedejsPFiA+jDuJnHutUscUy0hmlAtH9i6f38sxr1PBUxesQoxEIKhBSHHPktE8os7+63GOSySHKPuEm6huwuqQZAM88q9xbjY533SEj3s43xTDt9he9hFeBVXwF3VrRyAf9uNGtU4CZgz4gyq9z2qohoyJEYYe+7NHz8f6sHLlX7Lsb61arXlosTaSbCY0b50/FnBiDOKELwoTjeQGf+WWQ0lONQbweiiQFgQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 22:17:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 22:17:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcGHjL8dqNtw+1DUm4eDEQMXeVS7R6DDCAgAAHQwCAABp0gIAAAmYAgAAELgA=
Date: Fri, 29 Aug 2025 22:17:33 +0000
Message-ID: <26a0929e0c2ac697ad37d24ad6ef252cfc140289.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-6-seanjc@google.com>
	 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
	 <aLILRk6252a3-iKJ@google.com>
	 <e3b1daca29f5a50bd1d01df1aa1a0403f36d596b.camel@intel.com>
	 <aLIjelexDYa5dtkn@google.com>
In-Reply-To: <aLIjelexDYa5dtkn@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4525:EE_
x-ms-office365-filtering-correlation-id: d1646b37-8c2a-48ee-3a46-08dde749da08
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Yk50NGFrTXNHY2lXc2RpbDRMMWhzVFFMcDE2S2tmSlVjelRJWDg0eVBWcjhF?=
 =?utf-8?B?elBkRjJNSjRyeUh6akpMcVk3MHVSNmY4aTJGMjNaQklHT3cyOEZGNUhWQ011?=
 =?utf-8?B?cTdnNUhjVVZHOVFhS1JweC9xNFAxK2ZHTEJ4R3hQQ2VSQ2EzeHlHSUFsQ3Ur?=
 =?utf-8?B?a2tvNFJXQ2NUZFFqeDd2L1lFN0ozWUc3eGk5ZC9UUmduN1hKWEcvcWp0YTgy?=
 =?utf-8?B?MnBHRUU1dkdWSHBDOWlvQ0hqeHNPczBSa2VJanh6bTNnVzNDUGNPcWUvNDdq?=
 =?utf-8?B?K0pVOFpYelRlUFdKVk4yZzFGSCt1S3ZQTzloM1htei9JMTd6M00xRnh5NTZ5?=
 =?utf-8?B?SGRrVk5Dd1kwamYrdEZHNi9wQTlVRkh1Z0l6bHpoTEdnbGpTcGVreXZtOXlI?=
 =?utf-8?B?L3lEQVo3cWV1d0pHTXZOcjVMVUlmTE1hNmJ5Y2swVVE2aStPUmx2QThOWC96?=
 =?utf-8?B?YkJWN0g3ejVyL3A5aG9zN1pzdzlwLzV4NGVZb0IvMjZScEJQK3grUDhOS2VL?=
 =?utf-8?B?TVN5SzUvRVZUZmVkQ3pwU2lMc0Y3NzZGbktKSmZaN1BqT29EeVVDNU5DbzhV?=
 =?utf-8?B?UVdCNmd4VWtQQk05dDAxZEpSM3BwRERleE1Wa1JlN3FXSVpnV2dEa0QyUHFW?=
 =?utf-8?B?cDhkNU1IRlNGZnZlUVI2UG1KOVZ2cTFWMkhrWHVUcDk5OFpRVjBEUU80MjBJ?=
 =?utf-8?B?UTNoMUxUd29mL1RWWkFwbTc0a0NPWEJSRGttV2thYStJVUZha05RazYrcGp1?=
 =?utf-8?B?TkhHWDVvM0Z3TjRLRXB1cEdXZHVYQmIzbHBBamNOMHNTSi9yWFhuMGRFdTdW?=
 =?utf-8?B?VHFyRWdtTHc1ODZjTWZwWUN1ZUMrUkxSN0ZYRXpXRHh1RkNrNjB6WFVVUnli?=
 =?utf-8?B?Q0FSNUJmMVlrWVY4Y2w1MVRGcE0ra0tPaWZ1TzdMSmQ3bnBUZUFQVWlLU0RY?=
 =?utf-8?B?bGtqZzcrRW1pRGtuRUpUY1M5K1psd2tVR0ZGcFcxNGxCMS9Kbmo1Tmd2OWx2?=
 =?utf-8?B?Z0Jsejc2eFFDRWxXaXN2Rkk3d3p3RFJTVXdsWnk1TmthUmhLM3d0akF5T1Nz?=
 =?utf-8?B?bENyYlFKRVZvMjFHS2RDdXBUai95ZG5hb3VoQU9vQlFZMkV4SXhyTzdkOTBU?=
 =?utf-8?B?b2RMMmVZSnlzSVRuc01jMHQ5d3M3QzlIYjFXcVcvWG9keWJrMGltWFJ2N0RE?=
 =?utf-8?B?ZU9TVWJ6bk1jRWs0VmEwWG9WQmY0cjBTcmJZYVVSVG4rZUNJaFhzVnlOZ0ZF?=
 =?utf-8?B?elFCZGU4RFNFZUc1QTMrTHFhTVBPcHBrRk9CM1RxbTJaaGhLZUhSWXY5a01p?=
 =?utf-8?B?NGc4VHNuanJsdWYyVXFZUDRsZklMSGxrYXZFQzY3cUFpSTFTN0VjSmpWM1B1?=
 =?utf-8?B?OXJ3V3Nxc1BvcGxqajNzZ0VxbTFlRi9wNThDS1JwTkFyTWZhenFsaUZNZVc4?=
 =?utf-8?B?cmdYYmtRbjdVVTVUcG52d0NvWkc5K3R5M0hjb1d3ejE2VEFMbk9WV054YVp3?=
 =?utf-8?B?SnRreU0zUlZ0emJZOEltL3ZDdEw1T3hWQ3N2bzNvMkx5V1VzNE1zblQ0WnNn?=
 =?utf-8?B?YWExQk1LRFZLemgycUpjMTBadmRGUkdXd2dtSUZwQ0Jhd2hEdmRKYytZTHRn?=
 =?utf-8?B?bU5CN2Jsa3J1REdVV2pBNFQvTE50ZjA1dHhtRHpxckZlajJ2KzJmd1luZGNE?=
 =?utf-8?B?WW1kZlFXaHBkalJ3K1JRdFJSOXNYR01DL3NqOXN2dXpYQmlVZVZyRFlaR3oz?=
 =?utf-8?B?RzZPOWM2aDNrR0krWEhLYjlYaXVRZldTWm9kOEdkUXo0RUc4ZnhTZzNmUUNP?=
 =?utf-8?B?ck5xTHVnVms5d2diUlhINFdlWm1FY0h1L25pVlpVZlJRU1NsczRuSS9yRStP?=
 =?utf-8?B?L0pFbGlnS21hcjRqdlFMOWpFcGl0d3BRRktvOHg4VUcxTGIwUmRmWTVCckFy?=
 =?utf-8?B?QUxYK3BEdnJkYmRsUHNCdTRWekYydjFlNkdnWC8yY3JLWDRyWjdBdmttdTds?=
 =?utf-8?B?aDdWM20wMkhBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXFLUzlndGdVNEhuNVFNSitPOGFWN2NFTmFIS3QvRSthbzJtc3FqNnlmd2VZ?=
 =?utf-8?B?WDU0cFF6Z3JBYlRoZE95TTN6ekl2VFlYWHVSMjlFSytuTytXTThIWTBDd2Jv?=
 =?utf-8?B?THB0akFSMFluY1RGNWlNNy9HM3J2aGpxb0FmVGJmYUtSdEoraU9iUnBkLzRi?=
 =?utf-8?B?RnFBTjRaN3VFYWliTFU5SmJVK1p6amdTbVFHNU1uNmxleGlpRTZRajRRckp6?=
 =?utf-8?B?TjZTNzVVUWpRYWlpd1d6dU5NQ1dGVHRyaEFXYXJtb1VqU1A0ZFRVckN2angy?=
 =?utf-8?B?STY0Nzlad1BvemVCU0hLbEFiRkFudzVISlJhbjFrMDZWTHIyUk0wY0JReXhj?=
 =?utf-8?B?Q0V1eU9TbXQxdlhINmtVNXgwSWZ1aENwMG1pTHovMWpZQkE0RHlNblV5WTIy?=
 =?utf-8?B?M05GRFRPUHUwUzFpWm4xRmlVVFYrc1VHU0tSa3I4NGtxZUhieHgxNDFRd3JO?=
 =?utf-8?B?NkNkcnkxZGZDSjR4aTRSdTRHVzlnL3duOVBlcU9iTTRkSWJaL0VmTTlZemNW?=
 =?utf-8?B?ZitaaWRSd0FGQnVhenptbTdwWDRNZ2tFK0s2bWhLNzlPVndkVWtrcnRsVThm?=
 =?utf-8?B?OFlKNnhOVEM0Ylk3TXdIVVQ5dU1MMTBhcFYyek0xaEFSWkFvcytaVU1VYnVu?=
 =?utf-8?B?QjdUbitkVzFXUGZXNjZKZnFjdThTUEc4TVMwQjNMd1ZWdklNZnJFblhwZ2d3?=
 =?utf-8?B?cjh4Z1V1Y3V4dzVSZEFqNTcrTjgwVWhoMUVHN0pMOHNnOHJkT29ZTWxrRG5G?=
 =?utf-8?B?d0grRm1meHFuMDRzLzJ2aVJLZ0tNYUt3TUhyUDFiTFcxdUcyQU5JYVc5b3RQ?=
 =?utf-8?B?bUhORTVWZjZ6SjJiVnFDZGhhWllPakh4Rk92ZVVzelVCeWdxaC9hd2t4Q3cx?=
 =?utf-8?B?M3d5Yi9waEhnUUd1OURJM3lQVDdlV1ZxVGJLMzlGaUZMeEk4WmZRWjRIZUNN?=
 =?utf-8?B?K2JMVlJ4VFVSVW9vdjVlZGRaZFdreHFPeExpUy8xU00xaGRCaEJDRWF1bSty?=
 =?utf-8?B?cEtnVG5mM2lKV2l5cTdMVHJkVDRibm5sRzM2MFNJZEMzdVQ5dVU2WGQxWjVO?=
 =?utf-8?B?T2dWZmd2WndYZ1psWWh4VFNmS1duNjlVT3hoV09jKzZhckc4Rm1aK0JadGNU?=
 =?utf-8?B?UmhCazFubHZWSWVCdjF2RGh0bC9LOTB5ZlJHSTNSSU1XeU5OOUVIQkJpNUI0?=
 =?utf-8?B?VEUzcFhZV0R5dUd4YnFWUXhsY1Y4Wm92eTBTeHVQd2dZODE4MWJ2eElOeVR4?=
 =?utf-8?B?eFhURXlvcFRqMU04b0JQbG1lemMwK1VzWTdKNVAyeWd6ZXlua25SanlRTTAz?=
 =?utf-8?B?cHA1Qkd1aUZSMG5hQUJRcGQ2QVdoY0JFRFZTU2IyeXdXU09hcEFyZmJqbmty?=
 =?utf-8?B?RmpncGttSnJwSm1MMmhsWHRCTVpzanViMnVPY0d1M21QUS9ZRHFtdkVwa2Rp?=
 =?utf-8?B?VmgxUHI1NWxNcXZlYklLSERhTzJrVGNZN2Z2eGRLNSsvNHZBSk03MjJ3KzdG?=
 =?utf-8?B?Uk5xbXpRR3l6ZHdSMEltQXVqNXJFelQ2R1NPS3JlR0VaZnY0OGY3L2JUOEo0?=
 =?utf-8?B?cURaQ3d4dVFxejFYWmk1bndMb3dSZWxEam82dy91TDNZS0owNFhLYzY1NDdv?=
 =?utf-8?B?Wk1nTW1YcGE1NWpnTUtlN3V1Y2xCZW5HK2s0bFJIb1R1dk05YjIwY3VzQ0tW?=
 =?utf-8?B?bjdETTlMVkpNNVFVb3pKNENtMW9Ia0hwZ3ZReVJLUmxMVDdjVGJMbFlRWi9z?=
 =?utf-8?B?OTdVSGtvWVN2S2k1ekljcDNPWHV1ZEhIbE5weWpIenR5bVk1cThXQThoUmpx?=
 =?utf-8?B?RFJFajJ0TThkZlVwa3h5R0MzUzk1SktGL05oM21NRzROMmNJM3hoYWdYVGdT?=
 =?utf-8?B?Qm9vZk8yZTNZVWVpR1FlUkFML0NJaEp1Q2NSeDZYVFZqZ0tjUjZ4UTRnc1dL?=
 =?utf-8?B?VDlCQzlYZHlnNWtWOTZzRXppbE9DRFVhMUgrNDNCcmlrMkFvM2IvSFM1MVNC?=
 =?utf-8?B?UUpsSEk0bzl5TXI5TEhCZFJDc0lnVG5zZ3BFZTZkaTc3UHVCT0h1UDlzejQy?=
 =?utf-8?B?VVlNc2RwZEt0UGloS0lNdEhzTU1MU2taYzhGaUg3SmpiU3hWdHVLNFo3L2k2?=
 =?utf-8?B?c3d3T2xlZEg3RGVGMDlyaFhwQ3ErT2wvSC8wcVUrbTZRZGVETWMvcU1xUHY2?=
 =?utf-8?Q?2AJUa83CzcxeMdgbnISbAzg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B16BED6D103EE47B6B5A3A4B2612951@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1646b37-8c2a-48ee-3a46-08dde749da08
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 22:17:33.2460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8To/e/jism55EZ/Zw3tnMW0fZgGiFn8CGfQ3dbkP35AxKqojAyqGE+kH23AVYoF3f/zwbNkbtPO9g0uBiC5AaCkhfmJEgx1olhr4JOLpXCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTI5IGF0IDE1OjAyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEF1ZyAyOSwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBGcmksIDIwMjUtMDgtMjkgYXQgMTM6MTkgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiBJJ20gaGFwcHkgdG8gaW5jbHVkZSBtb3JlIGNvbnRleHQgaW4gdGhlIGNo
YW5nZWxvZywgYnV0IEkgcmVhbGx5IGRvbid0IHdhbnQNCj4gPiA+IGFueW9uZSB0byB3YWxrIGF3
YXkgZnJvbSB0aGlzIHRoaW5raW5nIHRoYXQgcGlubmluZyBwYWdlcyBpbiByYW5kb20gS1ZNIGNv
ZGUNCj4gPiA+IGlzIGF0IGFsbCBlbmNvdXJhZ2VkLg0KPiA+IA0KPiA+IFNvcnJ5IGZvciBnb2lu
ZyBvbiBhIHRhbmdlbnQuIERlZmVuc2l2ZSBwcm9ncmFtbWluZyBpbnNpZGUgdGhlIGtlcm5lbCBp
cyBhDQo+ID4gbGl0dGxlIG1vcmUgc2V0dGxlZC4gQnV0IGZvciBkZWZlbnNpdmUgcHJvZ3JhbW1p
bmcgYWdhaW5zdCB0aGUgVERYIG1vZHVsZSwgdGhlcmUNCj4gPiBhcmUgdmFyaW91cyBzY2hvb2xz
IG9mIHRob3VnaHQgaW50ZXJuYWxseS4gQ3VycmVudGx5IHdlIHJlbHkgb24gc29tZQ0KPiA+IHVu
ZG9jdW1lbnRlZCBiZWhhdmlvciBvZiB0aGUgVERYIG1vZHVsZSAoYXMgaW4gbm90IGluIHRoZSBz
cGVjKSBmb3IgY29ycmVjdG5lc3MuDQo+IA0KPiBFeGFtcGxlcz8NCg0KSSB3YXMgdGhpbmtpbmcg
YWJvdXQgdGhlIEJVU1kgZXJyb3IgY29kZSBhdm9pZGFuY2UgbG9naWMgdGhhdCBpcyBub3cgY2Fs
bGVkDQp0ZGhfZG9fbm9fdmNwdXMoKS4gV2UgYXNzdW1lIG5vIG5ldyBjb25kaXRpb25zIHdpbGwg
YXBwZWFyIHRoYXQgY2F1c2UgYQ0KVERYX09QRVJBTkRfQlVTWS4gTGlrZSBhIGd1ZXN0IG9wdC1p
biBvciBzb21ldGhpbmcuDQoNCkl0J3Mgb24gb3VyIHRvZG8gbGlzdCB0byB0cmFuc2l0aW9uIHRo
b3NlIGFzc3VtcHRpb25zIHRvIHByb21pc2VzLiBXZSBqdXN0IG5lZWQNCnRvIGZvcm1hbGl6ZSB0
aGVtLg0KDQo+IA0KPiA+IEJ1dCBJIGRvbid0IHRoaW5rIHdlIGRvIGZvciBzZWN1cml0eS4NCg0K
QnV0LCBhY3R1YWxseSB0aGV5IGFyZSBzb21lIG9mIHRoZSBzYW1lIHBhdGhzLiBTbyBzYW1lIHBh
dHRlcm4uDQoNCj4gPiANCj4gPiBTcGVha2luZyBmb3IgWWFuIGhlcmUsIEkgdGhpbmsgc2hlIHdh
cyBhIGxpdHRsZSBtb3JlIHdvcnJpZWQgYWJvdXQgdGhpcyBzY2VuYXJpbw0KPiA+IHRoZW4gbWUs
IHNvIEkgcmVhZCB0aGlzIHZlcmJpYWdlIGFuZCB0aG91Z2h0IHRvIHRyeSB0byBjbG9zZSBpdCBv
dXQuDQoNCg==

