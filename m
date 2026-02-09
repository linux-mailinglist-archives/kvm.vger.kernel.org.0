Return-Path: <kvm+bounces-70619-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AI3RN7sUimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70619-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:09:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A106C112E15
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0D9A33003998
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13041385EC3;
	Mon,  9 Feb 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iCbQ6psS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE753859EA;
	Mon,  9 Feb 2026 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770656953; cv=fail; b=H/3/GqXcG60NT+Q5m7iej3NGL7wcJGOJTMnXveBWYSXYJ5LF1h4AgM9dUHE25GtzcTwblxINkR2woYb/gzX07kZ0I1bSBmhSxT1OkvtCjB39lTzEnDfCSX2fSnKqhSKznjd+LjjKPKoPNsmWdPgJTM7z4oakuGhrQBU7n8Ye/qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770656953; c=relaxed/simple;
	bh=X1VKfVPIdjkBZiZ3FCh7ru/t3yGlPmzSLHbU6ZsYOT0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=foeN9mxoAZBZyW/cbSw0i9eYcR2/MwoVAMk+LDIkFqG+WUxRxA/gRkZ06OUWEWUmvyt3noam94Vq/lDja2reKsX8sEdCmdd529QznfOKybiT92XbhkJCubI384RPV9bWxhWGt4djsKkGy0MVRzzczmDjBp4FJTsynrkIbZGKSjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iCbQ6psS; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770656954; x=1802192954;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X1VKfVPIdjkBZiZ3FCh7ru/t3yGlPmzSLHbU6ZsYOT0=;
  b=iCbQ6psSt0GQPUBZDgvmtojMOLItUUmNB9f+3C1j53s2Hg7JJMcENEMP
   BlYl6N1FtRhQgV5dQMIDpWLIyNmPXvtrSgRMCoJsKEj23zdxY7kh4JHTb
   76DwK2OHJS2aQCyjoMENzqfJT/DTKfYyZrDd7aVwYkZ6ppF9aw7ZdK5V5
   Ryhj6yiFqdTtZ/VT3VMJ3CsRobPprOd9UNIH4409gs0Ww+yN2LAPsfdgi
   Z0WnwpfjDLfgu4oc2uJ1IWGnXVvBlVeM1UbRd6tTIUTW2XtdMmRp4+MxN
   y4zZJcCB4zEB6w7n2pbreobyIrMvFNpp1G3340Zf1qOcm+2C6CGwzb74D
   g==;
X-CSE-ConnectionGUID: jjLtvZ3EQvm6NdyyYx+L9Q==
X-CSE-MsgGUID: eyw3TxjTQ3SfM2k6vvZzKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71670355"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="71670355"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 09:08:55 -0800
X-CSE-ConnectionGUID: +BgfDyboSbiAGQRZOM8FKA==
X-CSE-MsgGUID: lvszl4kFTR2+EH4Ethotuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="216032969"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 09:08:53 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 09:08:52 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 09:08:52 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.38) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 09:08:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lh/MsTcFajTZTsbtZNYpVZBjen+VAwiIlwuukfHMyev21SteOKdwvf/LX7x/uaeAWzmkDWOAC79LKVTq+EcTabdsdTWlc+Xf8zU7iPRO1LtsXkHheRkmzZQFlUJK0u4W3WkgAHIb5I8oGj5MuXu4xPvZXerHbht11n1NizZcOOA3Keo3IY/gtwtC/ZXNuFUDagrz07cQroeT1hdDvXD96YvHygiensW1nKHIRb8Y2dhrFdGTNCwHfeZAh8VGKrGVi//CGHFU6NvQjA3aMThQARjKybu1jHuwDuiUXs7j6sq9+V5KFgnBQ80XaffhgnoK6F7/sbqbuEvj3xbwEReqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1VKfVPIdjkBZiZ3FCh7ru/t3yGlPmzSLHbU6ZsYOT0=;
 b=EUxeX5UDSAZXgN9E/2WtdhTca9WNXTQOPHmxVgiboHCIg0uWxUA3deGOYACLSX1KjLgxY1AwRuYNRx5JWIchIN/KyZU8Iw7GFmKfPJJnVebSPkxznxTdeh0aT+TMly8CuQfElZBy7Gh5ktF3Lfi8X9F7bIDzodHY1TuOSpYRugRQBLb3vMsPi8yEC1wq3S276HbX8bzXcPkLrl1xV0G9c9ka2whuzTtrsXT8m/82Z9L52rfPkHr7DLeWkTNMOgC0Ao9v37wOpGU6Xz/Fo/EW3cP4x/hU0YKCd7WNsX/F8dcfgoom4CdvY7xQsIn+kn8Z2eu7o+EL0ihY2LzkLmLxFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8393.namprd11.prod.outlook.com (2603:10b6:806:373::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 17:08:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9587.013; Mon, 9 Feb 2026
 17:08:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Topic: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Index: AQHckLzwCgvmuzjovk6gFrXf+s6dG7V1gv0AgABf7oCAADjnAIAAQGCAgAPhToCAAG7igA==
Date: Mon, 9 Feb 2026 17:08:47 +0000
Message-ID: <ddf6c17664044bf66e7a9a0a58f2b6c1104dfbc4.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-23-seanjc@google.com>
	 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com> <aYYQ7Vx95ZrsqwCv@google.com>
	 <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
	 <aYZ2qft-akOYwkOk@google.com>
	 <94f041b3aa32169fa2e1125edab7bd8fed3a6e59.camel@intel.com>
In-Reply-To: <94f041b3aa32169fa2e1125edab7bd8fed3a6e59.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8393:EE_
x-ms-office365-filtering-correlation-id: afaead26-5b10-45dd-5fa6-08de67fde399
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VURBUHk3UHV1b0I2TTdoZGRaRUxZeG5VbWZiS1VWNi80NXYydmRwb2RBY3NW?=
 =?utf-8?B?c2pNWGRMQk9UWlVjVEs0N3hQSTVPN1U0cHhaTGFCNmZJYVVWYXhZTWk2dVB1?=
 =?utf-8?B?SjQ1d2MyVVk2T1NuOTdCdnU3R1RKWnI2TFlFUUhrbUtQYzhKbXBOQ0QrRkND?=
 =?utf-8?B?TUtHdEJRNDlNaFE2aCt2em9TOGtlcHNZZHRFRXZJSnpJS3c0NExmVGdlZ0FW?=
 =?utf-8?B?Mzl2Y1hXT0lseDIrMDdSbVVuS29CSUJvdFpySGFVSStNdXl6cTdNWGxGQ3k0?=
 =?utf-8?B?RC8yL1VSeTIzTUE3end5MmgvTlRqMWJvQmlabUx3QlpHWG4wTCtDMWJRNWE2?=
 =?utf-8?B?M1kzMHprN2E2M1d4WHNoRlpMdDh0bTRWZHJsR1VSMW0yNFZyRUV4dkRhWHBP?=
 =?utf-8?B?QmdGb2ZLUUhvL0xkQzhMS3V2NjlTSUtKT3diSEhYYm5aY1NGTzdOeUYyQml6?=
 =?utf-8?B?OVI2OTA5OW9XYUlWb0FWRXlSNFJMenlzNGZxbGJmaTVQbGszMERNQkY2bGc0?=
 =?utf-8?B?bFBiR3hXMXdpakFZdmdGUThUMzVseUtlRjhvOXROYkREc0lvanNZM2N1S2I3?=
 =?utf-8?B?S1E4aTBnOVN0NTdqMWpKNzB4NVk1dWlrSUFTcmIvUktJRWRZK0g3Q1RGdWhh?=
 =?utf-8?B?NUd2RlpDZnNpbkFXbWJ0Rm4yVVArL25yYUR3N2FqN25qMFZST2taZGMvbHJX?=
 =?utf-8?B?bkxGWXJua2Z4ZHpCaXAzNzBRNG5DMWNyWnRIQ2pjbzBnUmo4MWM0QkhjVnpY?=
 =?utf-8?B?ZWtYUFM4OUhuQ3Ntc0s5ajEvckM1SlA1ZDk0VktyNHZpaTRTYUxURTc5bUk3?=
 =?utf-8?B?TzhuWWxKOVFqYWZrMTMzL2V0Q0U1VGJsd1NQUEoxM2hjS0JMakhKc290VHIy?=
 =?utf-8?B?Ymt3Q3lNa0p5NE1sVjFFMHZOaURtTHJNMTJ6eHlEenU0TFNHL2VDRStIWDlN?=
 =?utf-8?B?RmJuWUZZN3lJRGEycXFnRDhtUVlPZEpsUXI5cmJmZ1lSMkp0emd2SHVuU0dm?=
 =?utf-8?B?ODJmSHJFZ0tXNWpsUnR5cm1qS3ZtTGRiNWthN2dPVGYvTVFKcXZIN3pyQlhZ?=
 =?utf-8?B?ZUpndzhmMS9aWVpsMDh5UWlnTjRxZmVYdDZ1UG9pQjdFMUIyVXNuK3dOSkdy?=
 =?utf-8?B?MXRKR0tWeDVSNjU1aFlpOTh1UFd6RDZNQ1VEL3doSlcrOE9vS21PamNEWkk2?=
 =?utf-8?B?VWFmNnF3MDNoTWx4dFlHSVhJUXJqSzI5WUVXUzU0T0V5SG5mWkpPV0tYZUs2?=
 =?utf-8?B?MThnZnUxQ1JJLzZSVnd6OVJiZmlrdFc3UWxEYWlJS282QUJzMEFQYlhDZ2N5?=
 =?utf-8?B?WG5lSmhPTHJVM01sYkNGVExjM29GdWJodjIzTkdkVDBLWG8rcm1FVHFuOS9m?=
 =?utf-8?B?Ym1aaHhTTWhsS205REdFeFA4b0Q2ZE40ZDUyOE9yQzFTNzFNeDdrUlRkZm14?=
 =?utf-8?B?RlhnbHo1cUdaS0gwQzRjcy9uOGtrdkw0cGxRMHI3eHhkWVFGY3lsT21RMmhq?=
 =?utf-8?B?bjVWajdwcDJQK1I5K25ZS1A3dWUyeDROVkZxMExBVldhWEpmbEJ4ZUFLS1Fz?=
 =?utf-8?B?aENWZEplLzdNcTZBN1dTRi83eEhSYmJUSW5hdllTNDIyVzVWRTZXWGxNZG05?=
 =?utf-8?B?SU5VUnFla0ZTbGFVSGZjb21JcXB1NFc3M0Q1bmdIekF2OThuSENqRTJpSWcw?=
 =?utf-8?B?alBWRGxLVUZCUGw2MU9SUmx0WTVJTTZZdEZoWURxbURLdGh2aEVZUE1IeGVm?=
 =?utf-8?B?UlRRMjAxN2FCK1l6bUd5THB6cXZlQTQwb1hLaVZvQ2phcUVJM2IzVy96eTcx?=
 =?utf-8?B?NlFLSjE3Y24ybVZxVUFvdWZzRjloMS9QUC9tODhNN0lJNERpY3k5ZmRTcyth?=
 =?utf-8?B?YlBpdUlDNHhEdG1CZkUyMUl2MjRuRStaazh1dkRBeit2NzJzUGJNOTU5dDZH?=
 =?utf-8?B?TzZVQWZTSjl1aWhUMnhxZ2hKVlQ0T0JwUWJGemJENlNuTUlUQmRLcWx6Q0VH?=
 =?utf-8?B?RDc4cEgrdjhFUERidEpFQlBzNVM2eCs3Vk5qWXB1djFkNjdBazNxR2d1WWd0?=
 =?utf-8?B?ejd2U1A0SFRad09FL3ZIbDIyT1ZuaHJTdnVuaGFkenUvcERUMHc5QmlmdzA3?=
 =?utf-8?B?YWlCN3BaTGpvYnVNT3FQMlRLMSsyL1lwbXFFUXlWaWM0Lzc3d2FUQm5UQjF5?=
 =?utf-8?Q?ca9G8tIJO5SXRgWiaTXw8tE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnQ4T3ZYWjJDbU1xekZJVk5RcEFuVTdPQXlZUDI2RjZwWHd4UlpWN2RvYVhG?=
 =?utf-8?B?OG5hK3hKWjA0UlRGMkpZc0lxL3BGb1NrK1dEcmhhSThJZmhTVm9CejRDc0ND?=
 =?utf-8?B?cUFtYVdjczg1RTlWZXNWTFJBd0FueEpYaGtIWlN1d2VBK3lVcHE3Tnc1czJW?=
 =?utf-8?B?NzR2dnhyVGNLVDJpTHV3aHEyanZpRmt5WXJpWkRJMlMxRGMvalJYWTJMN0I2?=
 =?utf-8?B?djNxOE5wMVM1Qk1hMmVLMWJXZVB2bzd1OHJCMGUwckx2UCtFK3hTRUh3b3o5?=
 =?utf-8?B?UDlJdHZTVUlsMHJxdlFoay9uS0lSd3d4ZGhEenZQYzVUdktUdVlOa3dTR2RJ?=
 =?utf-8?B?Q3N1Y1NYbHNJVVhEMiswK29YUU1wZ0lFb25zZzdnUDFqcVZjWVppVzcrdzRE?=
 =?utf-8?B?SHJ4ZlV4TFl6Z3dvREx1VHJLTDRCV1lQeitEdFlNR1NzMUxwc2k0ODE3Ry9X?=
 =?utf-8?B?WjgxSDRUaTZGVkNPSC9DMGViekp5YVBjSlFLNklFeXdXU09rRWdYTnFrQkZB?=
 =?utf-8?B?YnQ2TE04TEJaNEcxd1graU5SUkk2NG1lakVRNGNsSGJOSWlkZnB5anNJdUxB?=
 =?utf-8?B?djhKS3ZXMjdxUjNBa3M1V0QyR3pjRkl3bEI3NGl4RERxcSs2VXlXOEROaWVE?=
 =?utf-8?B?MlAxajlKY21Rak5TRnNSczZqQk1yQVduL3ZMd3NINGJTa3VxaUFNUmpFejB5?=
 =?utf-8?B?SjR2MWY2OXk1Y0pXV1Vud0tCdW5QZ3dydjFMcG1qQ1BOVXJKZ2hQdkYrdFRU?=
 =?utf-8?B?UnJqZEVGRkFkdW1CR1dKNndTKzUzVEFFUXNreDYvemF0TFBjVnpIN1VsQ3gr?=
 =?utf-8?B?bFZXMnEvTVU4ZGpQdHhxYWtJSEZnTnhrYUJGSXBnZDNhSnp4TkVZR0VJTWNY?=
 =?utf-8?B?OGViRFI5VWF3RWlySUg5UzBQMGliaDVFeGtPTkVjZTZlNXhhZTlWRWFUMkhM?=
 =?utf-8?B?d1VGWDlhZldaUFhNYTNpNE4vUkV1cnNhRnFsY2s4alN3VlBCemFCaGgyR0hG?=
 =?utf-8?B?OXY0S2gydlRnYlArNDkxbW9CSlUrNzUxbWpOMmhHS01FR0lnL0MzSkd4S1Mx?=
 =?utf-8?B?cEdrRUFhQnltalVtMkY3ZnhELzJ4SHFRcU5pMFBOYTRyVHRielltVXo1K2pi?=
 =?utf-8?B?YXJkdDdIYWxHWk1tMDZENjBpMVQ5MUVCNGxqS1Q0OHd1K3dxNkF4a0Q4WE1J?=
 =?utf-8?B?S20xSFVkY1d2cnVNRkpZbmFTQXFicS9OaWYrdjZISWlIQUJPSldpL09HMWhY?=
 =?utf-8?B?QURydGcvbnd6dkJFV0tDd3pOY3NWVHlYVis0VXlqZzNzaWgyVDZEQXdnZmZ6?=
 =?utf-8?B?Q1Z4bFFYOFZqdzREYit2TlhDSDhvcXhyRkppU1VnYXExNmsrWTF6cC93a0Fh?=
 =?utf-8?B?OFQxK285cDRINmF3bFQyazFvVWxqZTd4ZVFWckt0bWtiaVNHWXg0OWJCanJh?=
 =?utf-8?B?Yk9jL0NFN29Ec3EycEVBb29ncEFiSU5jcmczRWFaK3lERkhYbS9rL0dkY0Nh?=
 =?utf-8?B?bzJpQmJ2d2VzZjNpbGJUMWg0eEg5a1RSc2xYcXcvZVV3TER6dzY3L3lTUDJH?=
 =?utf-8?B?dE9qSXltS1lHenQrWGpIU0hiRE9uZzVTK3hRU0hRYjdiVDQ2c1JrZkVSMmtG?=
 =?utf-8?B?UkdGbUptZ0ZpRFVlOXpKbjB4RFVlKzNkcVJMaURDTXh2VUZpWUdwbzl0NnB6?=
 =?utf-8?B?Y0h3SDduV1ZBMWJ5eXJEbDFzWnRaUnVhT1Bkd3hVL0c5c2hmOGg1LzRmeDhx?=
 =?utf-8?B?NzVrZy95dzhBVjI1M1dJUldTRDJDSm05a0pod0dPRHI3KzFvcS8rMmxGc1Y0?=
 =?utf-8?B?ZlNhYzNtOHI0MTQ1ang5bVZvUS9GMkxMa2pEUnhObVdnVlMwVWwzVGJoOFdV?=
 =?utf-8?B?OWxwSThvd2piK2c2RGFUSUNtRG8yV2dOYkV4WHRIZ0UveldhZ3dtV2xhRU5Q?=
 =?utf-8?B?WGRsQUNPUDI0eVRBV3g3dW03cG9wT1Zlb1hrcjJXOUtPVklNNXZ0bEpWaWcy?=
 =?utf-8?B?OFBEQXZ3eGpJU3d5dXBndm1WUTdJUXNBd3pBVlFvUXB1VDBPczh5dHo5S3pu?=
 =?utf-8?B?R3BReCtSU1kzN0ZjRFVkd3puKytNV1pFNUVaMVJXUHljRjk1azRjUGxqMVo3?=
 =?utf-8?B?SXhCNEVJMzRiQkU2d3NjWFdRZGx2SHhFNzJhTnV0YzN1MzM1MkdVV3k0N3Bj?=
 =?utf-8?B?QUVkd2dxZWY1MXVPeXo3TlhPTUFGZzk2RlZ3emU1TTMyUWl6UloxcUN5cklj?=
 =?utf-8?B?VVNIQjFjVVFZQXd4RVQ2YkpWa056ME1VY3E0aWo5Mml5T043a09IcVRHUGNL?=
 =?utf-8?B?bkt1R3VnNk5TZWZ2SzJ1Vkk2dmwxbHBzb2dHR0JSSmVybVNOOWJYMXBHNnFk?=
 =?utf-8?Q?7y2K+gHo/vcFG5AM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA4F17E65C1A3148AB87B3307B4227D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afaead26-5b10-45dd-5fa6-08de67fde399
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 17:08:47.5648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RhW0Cl/1O5ZFyPcAVxO7OBf8XOFF2Q0JDQZcdnptdblYMigLBmMTLFZND1nThFMPm+WZv5pPJxS/i4jaaFf62+E1qjT+cOX3cZwT9fFN96U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8393
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-70619-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: A106C112E15
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAyLTA5IGF0IDEwOjMzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBJ
biB0aGUgZmF1bHQgcGF0aCwgd2UgYWxyZWFkeSBrbm93IHRoZSBQRk4gYWZ0ZXINCj4ga3ZtX21t
dV9mYXVsdGluX3BmbigpLCB3aGljaCBpcyBvdXRzaWRlIG9mIE1NVSBsb2NrLg0KPiANCj4gV2hh
dCB3ZSBzdGlsbCBkb24ndCBrbm93IGlzIHRoZSBhY3R1YWwgbWFwcGluZyBsZXZlbCwgd2hpY2gg
aXMNCj4gY3VycmVudGx5IGRvbmUgaW4ga3ZtX3RkcF9tbXVfbWFwKCkgdmlhIGt2bV9tbXVfaHVn
ZXBhZ2VfYWRqdXN0KCkuDQo+IA0KPiBIb3dldmVyIEkgZG9uJ3Qgc2VlIHdoeSB3ZSBjYW5ub3Qg
bW92ZSBrdm1fbW11X2h1Z2VwYWdlX2FkanVzdCgpIG91dA0KPiBvZiBpdCB0bywgZS5nLiwgcmln
aHQgYWZ0ZXIga3ZtX21tdV9mYXVsdGluX3BmbigpPw0KPiANCj4gSWYgd2UgY2FuIGRvIHRoaXMs
IHRoZW4gQUZBSUNUIHdlIGNhbiBqdXN0IGRvOg0KPiANCj4gwqAgciA9IGt2bV94ODZfY2FsbChw
cmVwYXJlX3BmbikodmNwdSwgZmF1bHQsIHBmbik7DQoNCldoYXQgYWJvdXQgdGhlIGFkanVzdG1l
bnRzIGluIGRpc2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0KCk/DQo=

