Return-Path: <kvm+bounces-21250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8B792C7BB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B94972831FD
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDCF4A04;
	Wed, 10 Jul 2024 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OpXoNTY2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D928494
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720573057; cv=fail; b=hGfjTlVgKVoVEp2kWW1MfmNObhQEonQUWNen4ektrOpdQ/Ks6U8uXLk9MzSft+xBLuWBHNP3THE8uWgJfBwldtxTa/0svc59sE+ZVz89Rd9dx2AQs+itTwqgb/SfpvComiquuqD+lDBv7AERc6JTtu+a5Nrzs+dwFqeJDjaOK2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720573057; c=relaxed/simple;
	bh=KlGNvaJQhT9UTVpnNobhBiBPc0dyMwSd8CSMTL7vPF8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YpZm/T7Dm0H6WAVIusbB7pA08GRJT2jC4+s0Z09N6hd8gLFv8tuM1DtqeVS9XR3akCow6d/Oh95Ty73g9CHBs3yMsxpEaOG+/KiVDd4xQ6Miaac8Og98zVUcMBFHMYhQU3LeiVLj9VM4BbPSw7xExH2KpPhqNr7wMaILMkOFLOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OpXoNTY2; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720573056; x=1752109056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KlGNvaJQhT9UTVpnNobhBiBPc0dyMwSd8CSMTL7vPF8=;
  b=OpXoNTY2SohKpTO2wja3klwABPi2ovmLQIIe/mXhGNTDPsU0GtU4RW2s
   IUFcNLp8o3agp/46CQx7WFDa8rlMruVVW25uNC/NdDblIvottgRPMYX1J
   gH6SseWEtaxzrHoMQTgle+Li6KkHDt8AZSMQaVB7T06DhfrppMl/GxrRD
   VWhMToToh4C+cxr8zBms8urEfJmK+kCWIl360zMED+BWJY6qRSeSIIqz2
   r+CQGQiyXnSgmCz1M3bqFaawtII37M3AuTTqIb8WdZKgC4ZCR5hbkp2LL
   kqS9GbGOldoSXFzDV62sbCMNJ3/q0/L1KU1aHXfC8g1k3rCii2bZKV8NL
   Q==;
X-CSE-ConnectionGUID: 2I9GnKk6Q5CvM6SeuhBFIw==
X-CSE-MsgGUID: 0gPmnObBQOCoRGSHO3Da1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="20773685"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="20773685"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 17:57:35 -0700
X-CSE-ConnectionGUID: dwxOa7beTqeMUYhLbsP/qg==
X-CSE-MsgGUID: qmue8THaSk+mS0/m++upow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="85557893"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 17:57:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 17:57:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 17:57:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 17:57:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBpDbE1BcFIY7NnONS5zmSqkyhYCr6Y76nz7I58Fd03DB53JUz5R0Qf6NMkFzkX6qPXUduGunzYfPNzjgTTI+wCtlqxy5ZRPPpH58JEbjja8BhCmDZHbhANWiVsLLpZjbv5IAyCDzfTofM3/kzOfwEI6R9V9Edezn4S9e75NlAxguQXfx7fExPX2PKNu+mOJR3wPtctMT+rKFw1DtunOMJmGF6cihDXJ/q6cK5hzunjPgePH4Difgz8d0ZyD3y6H/+MjTjvGOY1LeCNDTiR8bvrERnGQ0N8tU+Z+urZKZDFdiH17tBse2hj8fOimXgH7RnR7IQAiRofF2fsXggKTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlGNvaJQhT9UTVpnNobhBiBPc0dyMwSd8CSMTL7vPF8=;
 b=RhMdFt0pxXa6Tvw5LkjiQa8U/bNUnMXmP0Q7NEXtuCKZB32wEnUimfelvVEAoCrgt81H8pQV82O8hbblDLPCWN7y9H7xmQ7aPPpPVZKfsu2DWUjx0uYu2XjLEhCrYd/vf1jn9gJUc7KzdVaqy5z7DXEmz5cMNu0/FtfIbjYEMt3jHckTsr/FCLSBU8eRT7h5c/EMAl+xYi6MK8D9Q0XSOFbjCzZQITmMVXVOWtngc5pEr3kvEbke13juoURbq4OYTSgmKb4jmzs/97L2n7IakGkBvBtzyACttrMhkv7ziNevaK2Mp/iX5ArrSe7bZfA6RuzsCbUU9B1ipnzB7InWMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4567.namprd11.prod.outlook.com (2603:10b6:208:26d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 00:57:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.016; Wed, 10 Jul 2024
 00:57:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Liu, Yi L"
	<yi.l.liu@intel.com>, =?utf-8?B?xb1pbHZpbmFzIMW9YWx0aWVuYQ==?=
	<zaltys@natrix.lt>, Beld Zhang <beldzhang@gmail.com>
Subject: RE: [PATCH] vfio/pci: Init the count variable in collecting hot-reset
 devices
Thread-Topic: [PATCH] vfio/pci: Init the count variable in collecting
 hot-reset devices
Thread-Index: AQHa0mH/X8J3k4xPoUioAlI/j+fOMbHvI2rA
Date: Wed, 10 Jul 2024 00:57:28 +0000
Message-ID: <BN9PR11MB5276D401CEC538074305CD2B8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240710004150.319105-1-yi.l.liu@intel.com>
In-Reply-To: <20240710004150.319105-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4567:EE_
x-ms-office365-filtering-correlation-id: 200088eb-de85-4c7d-9361-08dca07b4589
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UENFUFBKK1ZTbGVnY3NLQ1EwWThjQS9DMWhsWDUxdVlwUGxrNkY2VlRkUzk5?=
 =?utf-8?B?czVkalc4Y0FJbVIvZENFelorUXhyQTVEU2Y0cEJsck5wcXl4djk2NTlFNjZB?=
 =?utf-8?B?bVpKN3NVNklDTWpVUEFWVTYrRHJQczdOUExpZC9JK0ZPOU12VVNXalBkREQz?=
 =?utf-8?B?a08xang3eHNtQW9MSDl4QmlLbUcxYjRxMks1UFNmOEpubUZHajJOQmxWVU1M?=
 =?utf-8?B?YjlBdUxVbzEyaGkra3BGZDZ2YlRQR28rZ3g3ZzFGMURuZVgzV2ZUYjlZTzRZ?=
 =?utf-8?B?bUJweVZ6SXZNdXBGOWJLVEhjZUdXTHgzVnBhSDVtTHNPNGk3VExSUno4L3Ny?=
 =?utf-8?B?TVp2a0lsWEgzbkVZbEZzd3Nlb1BrNFRocURXai83Rms2Q1JtSUZrL1FqaWhU?=
 =?utf-8?B?dSt2cnVicVFENk1hVFdhNk1TbnNXeFNFb0N2bzVKNjQwZHFMMTRIQTV0N0ZV?=
 =?utf-8?B?cE5qZ08vQms2aEw1QUpFRmdMVzNoWkdlWTBUYWI2cGNablpYcC9yZThwMXZj?=
 =?utf-8?B?T0N1MVJTYk1jaVVCRUdwUHBwT3ovTGpVRTFoRXRWNndwV01uRWhOUWJFRmJl?=
 =?utf-8?B?cllMRHgzT2VCbXlFRHd1TDRXSk0remM0Z3lZMHVwQlhha2RTU1ZXWU9RNWNt?=
 =?utf-8?B?MnEzaUx1Wkgrbm1vNWRoY2pScC9obW8ranJNRDJQLzk3SlRsZjdNZDJMOEJU?=
 =?utf-8?B?aUJxOHBBMVQrQWVLVWdtRW5LVFJOVEJsR2R4eWhsalNhNHk3ejY3aG92SVZK?=
 =?utf-8?B?SFRZS2Raa1ZCUi9JS0M2b1F6VlpWTVRGOWNNTUVOQWlLdmxmZjNhWitSWVQr?=
 =?utf-8?B?ZWQ3bUZvS0JPczB0YlVwVWFGdFBaOWFVeklOZDhWSjBBYWFlZmlZbnJERXZP?=
 =?utf-8?B?SEZDZVM0dVVHWkpMdW54U3RaMW5Ga1g0YlhTM2VsRzcxTTBQdW5zOFdtYTZt?=
 =?utf-8?B?WnlsVTRJaGR2MU9SbDBCYThsZkk0VzY2WnlxNnNwenFiLzRBOVJHcDdJZVJk?=
 =?utf-8?B?QTJ2SVBjcVFHRU9pWS9VbCtzZEhrOEdTV2ErdExOVzJxRGp5Ni9qckd3clVs?=
 =?utf-8?B?bDB3MWZabFA3THY0dXhCenlwL01WUXJ4Mk5WclRZMG1jY1B4MlowZGJmRGVx?=
 =?utf-8?B?dUtqM1VtUVBBY09Iam9wNDFIck4yYXNIN1RxRmJtQSsyU2hoN0lMcFV2L3ZW?=
 =?utf-8?B?emk3cEVqSUVqQ09GWW05V1hqVzRpYWdLNTFDbjZ4aE4yTmRHZFdpUExZbUxp?=
 =?utf-8?B?VW40bkcrTVVKWWd5OXZ0RHl1eHA2bHNJSkRWZjI2UnF3RXZDbm1oM2Q4bUY1?=
 =?utf-8?B?WHVVMWlDeFdXQS9jM0ROdFN4RU1NS1h0TUhDZk1kd1k3V2tzc1R6M2dBTFVQ?=
 =?utf-8?B?S3duQXhmNCt6Z3h3aGhZclZjTSt1M3Q1NkszUkF4RmVFSmtOZHpxU1VzYm1I?=
 =?utf-8?B?UERVSEh4Q2pXNXNnWmpYYjdnaVdKdnJwT2duNis0VitNTm1qaXdzVEFHTXJ3?=
 =?utf-8?B?cUlJZEJXWTBjS1VWdWF6RVR2ZHZOZENuVG1zN3czYWE4ekhic1l4bnpNMENw?=
 =?utf-8?B?MG9PM0xXN1lTVVNCWERER1dhdFdUdFh1NUNtc3lKZVBHSGZTcGl3Z29rd211?=
 =?utf-8?B?dXlZNDUzbExBWG9kTHpDa2o4UTBTakZnSU02K0QzN1lnN1M5TjhxQUs5MmJL?=
 =?utf-8?B?Ti9lZFlWcloxUkY4RTNLUG5PcXVEMXZpUUFPQ3o2SXNHejJoc01haHZZNkxp?=
 =?utf-8?B?UnhxeEFMTXB5cFM5ZENoaGpDWDdlbGxseW5zK3VNaSthWHcwak1vN3VhUUVF?=
 =?utf-8?Q?uxFf9o18mOidLXkpkPWgeNoLsyb/1m2fIet1Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2hRS09IcytHblpqaDZiREtOQ3VmSk12WTh6K0M4NHJsNmtwVVRTN1pCVDBn?=
 =?utf-8?B?MFNXb1RKODhvN0k2SmxtNUdOWUxPSlh0VTcwY3ltTHhtK0N2K1ZWNnNodENR?=
 =?utf-8?B?VVhUR3c5NUtGRGs2TjI0aHhoRHJkbFJjWEpJalhJd05CR09KdFd4VUJaYTJJ?=
 =?utf-8?B?NTNubHdVeWJvanJmSy9TdGhkNkI0TkgxekhMTGZ1SVV0ZU95VTBLNkM2QlBn?=
 =?utf-8?B?M0FDb2Z2OTBGNkRHalQzMjNkNUZRMmVtWUlna3h3N3RERjAraFRHUit2dlVv?=
 =?utf-8?B?UXVYYjhIRG5vdjF6N3VFOThFWUd2LzhtT0tlVnE5dklxL3FnUFRoY3hycU5s?=
 =?utf-8?B?OTU3NjM3M1NGbFNWTTFkMDNvc3BMbFZZNG9UaEVuWGt3UGx3UTd4WVZFNEI2?=
 =?utf-8?B?VStWamtmWnNwcU85YWRjYVNTNktVWEUrNkt0cmZVK0tSRTJNRmxHcjg0K2dv?=
 =?utf-8?B?N0E0SXVXWWR6T2FyeXVJRE5QTnhBV2xPcWtrM1M2c3QxNi9nRGZ6WnhpTXBX?=
 =?utf-8?B?dnNvYm96Y2pObWNRK0cyN1RBNE15Qi9qNXdzdjJkdVFyR25XUDRHRzF4MGlw?=
 =?utf-8?B?bWhmVE9jZFlkeXRReCtGZGVXQ3JEU0w0cUs1OGRQL2hZaGlseUFQRy9sQVp5?=
 =?utf-8?B?R1FpYjhFVkZTQmFZNEFrbnRoQ2c3M1ViZmVFQ093RTdtd3EvYlhiSTk2aEZ0?=
 =?utf-8?B?K1NsalhIRDI3R21LVjZuUkhLaVp0VzMwZU1Kb2VTVFBmQVVyQ1hMcUdudjEv?=
 =?utf-8?B?elBWbDlubVpCQmc5OUR3RndtSll3Sit0TDBreXhhN0Ezdk85QUJrTU8wQVJR?=
 =?utf-8?B?MHpQdDExekV4Wmd2QWxSMGZON3RGdUxMREFVK1NOTkUzUU4rN1Rnb2Z6VDI3?=
 =?utf-8?B?amVzaWE3Wmc2VWY5MEsvRTVkR1Nqc2REb1JZSXNVOHY0dWZCbjRyTmxsWmJj?=
 =?utf-8?B?aVVkMnM2cWVvQkZBSVUzODRaanZVY3dEUzRBTEVJcC9uYldQTkVxbUp6N2pp?=
 =?utf-8?B?MEI4eDVqM1JhTU1DTGdZSzROWFdMTVpBS1ppOWhrYWx3V1M5Vy80M29JcHJW?=
 =?utf-8?B?REFKRHVwY0g5UzdCVUxKNU5nRmFsSGc0VEV1TUMrVkJVSDY2SGFBQVVmdytF?=
 =?utf-8?B?RWFJWHNqRDF3R1Z0bGhWa3RYS1E1d1I4ck0yZWFnTHlPeFdmVlpyQVpaN2lN?=
 =?utf-8?B?S3BlelhZaCthSUNGSmV4NEFpMWFsbjB4eU9SVWhBRFI3TFFLSUJLYVhDckJL?=
 =?utf-8?B?MElUWUxGRGFTNEVqM3ZuOHhrNzlBcHVFWURMRmxOQ2VkdkdodUo1SU81QTcr?=
 =?utf-8?B?ZHlTenFjY0VlbXRPQ3E4dEZlNVh3RWU1TThUTXVlZTVvaytZb2hxQTZORU9S?=
 =?utf-8?B?NGt3Rm9MZlVTQktMVlgzZlpCWHlvNzU0T0toeUlzUmxDUklGVzRLUmZoMEFM?=
 =?utf-8?B?V2NTdlVmUVpqRXJrUFlsVFN3a0dxWWxURVZaOW9Kd2J2dWhPOTRxMml4bm4w?=
 =?utf-8?B?SlViN2xyd0pCNS9BYTQwYUZiSUlsSGVPS1d6VEtSOHhFaHJFamszUmF1eHk2?=
 =?utf-8?B?VmhuekNwYVNBZ1VLazk4MWRqeFFhYldHbTlpZ1FHOC8xWmVteHpFUDlMUVVH?=
 =?utf-8?B?aUxwRWFJbXg5dWRKK0pTMmN1TVF4L2hua2l3RVdsYXZ6bytSdmFhanVndG5Y?=
 =?utf-8?B?TENzWHo3emQ5ZEltUnVReHlkQmdpczR6UVkwZWFSem9ubFc0bm93eXRvM2RT?=
 =?utf-8?B?UUo5VkhnOGlDTEVwYWQrMGVRbU8wQ2VJSFc3MGNhMmhGL1hycE9xTDN3ekds?=
 =?utf-8?B?aXcrdUxSY3BBUFBEdVVMOWlkbXhVOEovZE1ocFJySkRBTFB1MFlaVzBETnlI?=
 =?utf-8?B?OEpUbGlCRWZLMy82dWkxRlpmN1JYNmJiWk02TjFxQ0NuMSthNnl2cFRTbjlB?=
 =?utf-8?B?VFFFSlF6Z092THZLUnI4cHhJVnN1U0NTQWRVZTFET0VFekIyMUlUbjFvYnN2?=
 =?utf-8?B?V2t3SWtpTXdsdjBVcjVqTnNwQnhJWCt4d2FLczZNZHRpdkdvQ2owSnBDUDVK?=
 =?utf-8?B?bkowN2t6YUhLK0JFUkZWSnlIakhvZklUdWFmbWZxMjFVaFRIbjFlNWpoTVFh?=
 =?utf-8?Q?JzyGxHK/tVhcSR1ev2Xn+txM8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200088eb-de85-4c7d-9361-08dca07b4589
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2024 00:57:28.7048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tdVKPRzJYwbBUJTNqbZTlnkixvWHahsSqvdiXPSzoveG2QtCs9yOBryE0LK3DK4Xg/aeVMYhJl/eQPW5IkuEeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4567
X-OriginatorOrg: intel.com

PiBGcm9tOiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBK
dWx5IDEwLCAyMDI0IDg6NDIgQU0NCj4gDQo+IFRoZSBjb3VudCB2YXJpYWJsZSBpcyB1c2VkIHdp
dGhvdXQgaW5pdGlhbGl6YXRpb24sIGl0IHJlc3VsdHMgaW4gbWlzdGFrZXMNCj4gaW4gdGhlIGRl
dmljZSBjb3VudGluZyBhbmQgY3Jhc2hlcyB0aGUgdXNlcnNwYWNlIGlmIHRoZSBnZXQgaG90IHJl
c2V0IGluZm8NCj4gcGF0aCBpcyB0cmlnZ2VyZWQuDQo+IA0KPiBGaXhlczogZjY5NDRkNGEwYjg3
ICgidmZpby9wY2k6IENvbGxlY3QgaG90LXJlc2V0IGRldmljZXMgdG8gbG9jYWwgYnVmZmVyIikN
Cj4gTGluazogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTkw
MTANCj4gUmVwb3J0ZWQtYnk6IMW9aWx2aW5hcyDFvWFsdGllbmEgPHphbHR5c0BuYXRyaXgubHQ+
DQo+IENjOiBCZWxkIFpoYW5nIDxiZWxkemhhbmdAZ21haWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4g
PGtldmluLnRpYW5AaW50ZWwuY29tPg0K

