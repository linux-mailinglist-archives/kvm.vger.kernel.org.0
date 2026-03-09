Return-Path: <kvm+bounces-73250-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EOOLA0TrmlY/QEAu9opvQ
	(envelope-from <kvm+bounces-73250-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 01:23:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 163A4232DBC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 01:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 325B8300DD48
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 00:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3051D217659;
	Mon,  9 Mar 2026 00:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ka7VnXQd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD501D88AC;
	Mon,  9 Mar 2026 00:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773015816; cv=fail; b=fwR+9p9dK/Z7EKae6xTKTKWNH3vqj9TXF209kKmWUYlR045qEH76SKhzkO/kgcmwTA5DYwBUO9D41JhGjFBdCLZBe/9IP7ecZ+IvTblnsGAqhe4pQQrePXz1xrafkc9ATS25Eu88IhMwJJz9wMu6Fdgef3VDheYObFE1aXB/u7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773015816; c=relaxed/simple;
	bh=t+UPRxWhhUC9bmkDJ5cDda9MhdRzuW9Vbj+u1D+IEkw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bK0a2hkCqNe523xF8ItbuxaOhkWbXqDqlahXCPTk61nMIgiIhAh3PDwW2+dUwqVea7vr21BMFpLznWy6kGNMxrOFtbk4zK8Q2dbnOGre77ad9v/D2XYKLyTLYRd85drm6rECx8smkpMJ7Jxmly3waDC5LZ1uOmOGEJokLT5rWvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ka7VnXQd; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773015815; x=1804551815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t+UPRxWhhUC9bmkDJ5cDda9MhdRzuW9Vbj+u1D+IEkw=;
  b=Ka7VnXQdH3GTmMVpdCF6TaVycrtKGYKVTTNyy9y9Qhp1V0nE6yAhSyw7
   KEI4WDkJJjg+UmyboB9YBrsv7ZDZ2Mx3/Xy9UqWtEG9VVU004yOk4w2Sc
   e459VLM10sPb00Z1r+u255+heuL6f1NwvSHvaIQOS8zxsB41UzaTms4pT
   febu4CaJCqp5zgC1PiqOD5QHRSdKUXQZ3hFP5AmpGecFlnuAN7p1eZsZF
   W3dUq5jcpgSQ7E3DDtOPG689Wt9BrEqrZx0y9LfWTFUtSl03fFo38XU93
   sbyDFSJtAsRNs9ejMYMAkUurikL3VyWx85xXELkjFx+Qojf9+ulzjmnM0
   A==;
X-CSE-ConnectionGUID: ao4+fbByQ86rehFIsleYYQ==
X-CSE-MsgGUID: dn38enqoSei9FlPiCA2mxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="84671365"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="84671365"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 17:23:34 -0700
X-CSE-ConnectionGUID: /LlAeOPlSsuUJK2AnNv2DQ==
X-CSE-MsgGUID: 3wceBjNJRHCTCvuXjhUTww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="216155462"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 17:23:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 17:23:33 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 8 Mar 2026 17:23:33 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.54) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 17:23:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RtzIw+tlGPt21HC5rUspXey3JPcbHBiZEiDCmt++y5wrqdG0RsO8pQ/eNABtdR8MsbhBYT29JS/zFO2nK8GmQWNlQCkn/HWFp+gHfMI+ft3UQVkCEqqJaOowTcTxUyxt2HmpRbknBVujV/E6zDepvAtUbM+xVzUmF496yrj5nYZX9+L55SCm2KZsRH5/CRnN4cIrq6jhljPObw8NdAehBo27QWKf+szl3XT7XhCREd2Bihzctj59BpWJlYVCEnsvMKR30hublNiDWT+30rGNN1ogsPr/K7D3ySPCgn28TaabsqDpuvI3RngmqRcIqdKgkatFN6nXiMfx8juKOv1l0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+UPRxWhhUC9bmkDJ5cDda9MhdRzuW9Vbj+u1D+IEkw=;
 b=POYiAAos7jDimOCaRS/DHH6HxnmbEC/O/jcS7eV0fbUdCih5ZDilpq35HPpJTlUClQXfZmxL9LG+k+F1mCV0ucI0pTtKrkG9Zz2imzdbqQZsywdmpkTVW37ExZ+wQ8+TsobFjV8+93M+AS19xe/5Xu71D6ps9Ygvpc8Cz4NrzcI7wPIlCQHxtXN9afNa14ihb3efXYtgC7ofsxnicJrpBZnbX1juoIi3PmTzrfICxBVOvdHCCQI6pu9a+ZTy1XX5T1lFoL+eQPHpM5xyvw9rZepOgeGJSj95+dxtK0uf6SjkjZKowH1t3ZlMHmnLN+EDVtX0ngKkwiFWF4kpyeFaxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 BN9PR11MB5225.namprd11.prod.outlook.com (2603:10b6:408:132::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 00:23:25 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9700.003; Mon, 9 Mar 2026
 00:23:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@kernel.org" <tglx@kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/4] x86/virt/tdx: Pull kexec cache flush logic into
 arch/x86
Thread-Topic: [PATCH 2/4] x86/virt/tdx: Pull kexec cache flush logic into
 arch/x86
Thread-Index: AQHcrc5Th7BKK91ay0qPJwjq4dKmxbWlWkMA
Date: Mon, 9 Mar 2026 00:23:25 +0000
Message-ID: <d16e808b16d9c23f7db34e576c4dd82eb9772831.camel@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
	 <20260307010358.819645-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20260307010358.819645-3-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|BN9PR11MB5225:EE_
x-ms-office365-filtering-correlation-id: 73df7775-a134-4167-8b11-08de7d721430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|921020;
x-microsoft-antispam-message-info: axTB0fPR6ExqJWLdver6U1YNMTjziJdM1zXJGTHTNNItReN9ZiHatB17I8PgsPP6wWVTsPyzGF/iJflyu2RoPHjNb9BaCQrbw+eMUaaDYCn4xZq6VyCWjiywKH7YmN8HH53rbFrOqS88pPKZfaRbQwxCvJgD8CjzuOXLYPax5grX30aMT0SZjDK1Xtpq5b5hPZToUsaJTXOwK1XNSFvCapimqCwETB8/zISQMgVoD8BR31fI+rTj+UJ0nm/BSJQJlFIJS02P/1GLlpwEml/ZLurxbHYPbeVY6C89ORWUeSaXWS/du+xcuryDpp0+h/UMaBI2vV/GcPYieQBlac8HwLfpB8v7JKCphBAUQvxFgjsrbaWoOrsTnQxe75Q7z10svA0MndbotNF1rtfY9g2IDx292kr1kE1RVdcMmvn97Jpdrl0lGXefd4dPmF1Dgy5N6TTkBwtGi0BcZM6Y0NuXGxzQA0gbNm5tv36MgKuNAjDz4NOMDpPfTMuG1F4u1vZuq7e+Y+BD2nbx5jsVE+0UZC12GvuX7I1fA+f+OKkJQ4n6dtj0TInmikf8yCVlTB+ZTbVcDVcBkhNtz05PEH4Qmgq+OSfqCi6ENYuj/yoTmJyhhCmtsR1dx8mzthhRGnyW51OtSVhWYe0q1cT57FV01nxM65BcgOCAXi5ICnd5EderDt3RRz5aPzEWbyUDtnI58WFkitINA0MfvGjUxpgcdtq0FnMpLLtEg04MFCtpS+HPucaHrjbakDWs81nT2+KDsyWywGG557111Mo5nIhPyVz2ZFK5STbikaHu9BSgiLMqGP0xsKCJKn6HzNDQyX54
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmVhaDhzNTg2Y2l4S1pBS29JampLbk1yaFRSRWtPYmNtWmw5T21rZ21tRVdy?=
 =?utf-8?B?VVM0U3QwdURKY3E1d1JWa2NpRnFsZzM0a3FGZTdNcWM2ajdSMDlwU2Erdlpx?=
 =?utf-8?B?cCt0anlTMGkwYU9qaGo3VWNlM0hxNEp0TCtWT3VsamRqT1ljaXY2Tk9admJY?=
 =?utf-8?B?N0dtSHZ4dVFxMHZrY1dTWmlWQ3h4TkZtTURab1hvRkRsQzBGSFVmNHhjMG5L?=
 =?utf-8?B?Q1B5SHFxZVJ5ZUx0T0dHYzlNekZLaUlwUkRSRlNPb0JJTzNEa0RCNjA5RUZn?=
 =?utf-8?B?aWM0Q2NJRTR1RHAzNUxHUmlja3VPZW5PMklQZ0lwR0ttbnI5Y2RyN0srU0hx?=
 =?utf-8?B?N1ZMY2xNREZYZTZKVHl5Z3JhVGRSVlNteTFjcStTbTVHaXpIZ3FYNlI0bGt1?=
 =?utf-8?B?N2VCckp1dnBTSnp5bVM4OG1rNVFmakw4L0NyR0xBVHBscjJKS3BhbGZEeFRo?=
 =?utf-8?B?R2dnSjEvMzZTc01zMGc1bUsrM080VmU4WEJZWU5sSFVkM1lzNHFvdndyMzlz?=
 =?utf-8?B?VklWeGdmU1RNcVVFTGJyT1R4dGJhWE42MWRlMDdVWjZBaWR3bGRpdnljaFc2?=
 =?utf-8?B?VFI0NWpNUmlvRnpoQ25NeHZicitSbG1rTE80OStjTTdyeFd1anoxTE13T3h2?=
 =?utf-8?B?NjJoWHEzN0M2WFIrV1dxdHRLRSs3cEk2Q3YvdkxxR0FKZjhta2FTTG1Vd1Bh?=
 =?utf-8?B?U29oTjVsNy8veFpFdHExM2pnVE4wQzE2bGk0eVFtVGtSOU1JRDAxS2FxU1E3?=
 =?utf-8?B?cnNwYVhUQ2loODNvRnN4WmxxSDZ0TTNlTjdCWUdBRi9xcGN1WGRxZDlud1p3?=
 =?utf-8?B?Nk9KUWpLSWtsc09CUHFpQUJ2MWZYZitkNUMrSU82YmVmK2JZL3VDc2lLSnJa?=
 =?utf-8?B?WnQ0eEI4WDFsNTgrU1d3bUE2S0VsQjBzdGRxSzUyWHVjV3NWbDY2TGV5bTZS?=
 =?utf-8?B?b3ZRT0prb3Fia1pQWnF4TExXYlgwSTBYV2J0T1BpTnN6bEJYcFd0R0hGNnRq?=
 =?utf-8?B?QzRBZCt4c1JtakdrckkvWE9aL2J4SGVBbXZLd3V5RDFDbTlWZEJxZHBpb3dY?=
 =?utf-8?B?MUxtRDhzQXpUOGY5SCtDeFNSWHNjMEJwU3Z2bDdTaFNQNURsWjN5T1Y1NnI5?=
 =?utf-8?B?U3orNGJGR1Q5SUFLS25aZTI3dU5CQ2VsSUZSRG5zaTliTVQ0MkdPOWthMy9R?=
 =?utf-8?B?WEg1Y1FXNlpBUWx2bm1OTjgybmF0OWd5dGZRUU9nYTZlWHRnTmVEb1Nmczho?=
 =?utf-8?B?b0xGOTBnVk9NOGZyRmZTaFA3Tm5OazM0dmhsU2xhOWJVeG9kcnhPNUFwRGxT?=
 =?utf-8?B?UHI1T1Y5K0JwbStzQ0V6bzJ4Yys5VFNKTzBJa2dWK0IvRTZzd3hDR1pPanJC?=
 =?utf-8?B?WTE4K0V5K1VYSWVKdDhyMnoyU2xZdzhZcXJrbkZ5dGRKQkQ1cllGVDk0UXNz?=
 =?utf-8?B?OU1qcVRBOENKUEVZaWcwSG5OVlp4VjNGRWE4dFpaY0o2cXZvdzVJaTZ6U2VY?=
 =?utf-8?B?OGh0RU5MeEN3WGR2aEUrR2d6WEgzTjlLSDdpMDdpQlhqM3NKaFlhLzUvSGlx?=
 =?utf-8?B?UWxNVFRaU3ZGYkd3M3o2Zk9jM2dycmJRZ1pCcjhLZ05IdGF3a3lPQitscThD?=
 =?utf-8?B?ZjF3NWJDcEZxTm5xcERIQVNvWStLSXQwTkt1YlF2a0FpQmlDRW9CeDhPTUFz?=
 =?utf-8?B?S1RxV3g1bjdVM1dLMEhuWUg0UUsvckh2dFhuUkRIbjhOSkJHU05tYTh2ckpU?=
 =?utf-8?B?ZEo1cFIycWNhMXIreDZZZTJ6RTJXUGhCWWJwYjNVczRyUy9IbDVJNmx6Uitt?=
 =?utf-8?B?QVphY0RyanlnVW5VUXlzcGlSVlh6Z2FIWUd2Uzg1NnhQVjNnMVFBWktFYVhv?=
 =?utf-8?B?VC9oSVJvY1dYRStuR3NJZTlKbHQ4bmI0eHdrd2EzcjY0dHdUU3h4aE5teXV0?=
 =?utf-8?B?SVhoMVNhU2Nob0xWQ3JrTUxzcHA0dThBUC9BRmlUMG84VERlS1dvRUIyUTJ0?=
 =?utf-8?B?RFFValZhMFkzR0JrMk5xdTJ3d3FSV1grUFFXaXowU01nWkVEM2VrYUwwVUNq?=
 =?utf-8?B?OTF2MzZKSDNwY2Vja1FiUzJCL2czdGk5dTFzOUtpYTdaUCtLWTRpRTZiRDdV?=
 =?utf-8?B?MWdCM0hpY1hxZFdUY3FXQWYvWStpT096aVdxUzVYNVVZMDdFeTEvZjR4OE1s?=
 =?utf-8?B?Tnp4WnZVZVZzMkpLVTcxOWlSME9tRXNqKzRyS2QzY29zUWoxNTZMTTRjT0h2?=
 =?utf-8?B?ZVNoNk9TOVFkaFdRbUhOVEM4MHEzMW1jWkFua0NxY05qY0xEUmRwS3k2dnJ3?=
 =?utf-8?B?MUhzMElERlFiK3QrRFQxL2MrVWxrTVFFa2kxQmRHVDlPYnpTMjYrZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <571F7FB0A90BC74BBAFDA198DF3D0BDE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VPqXJaNUSZfamoNilkf0+7lvK/iKUn6KX7AMZjG3nDlWbjzLE1B7Ge6BWnHYqoLW2JBsh8VhRyWMEy3rAtKZ2KnNAKQijb0pB8yhSdBqhWz4rktkBTwTMdc3U2N0nofj3WpBClJWCS/m7ohUjtouVx/O9T5asL+aIUIsiLx709kNQ40qgSG/YDx7obd6bzb2gjusnq+C3tVdw9MZcxVNRls2vh7ahRofckAeL1uGgMP0o5QBj9riluHsWKHMHOyzkIRP7kKNaUXa1n0Hk/uIjIg2PiDbewd8OdNr5ZodHhSLKxVoDAE7CZ9Ukza8HstVx7sUE9JI7HxnmC+IEggi/g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73df7775-a134-4167-8b11-08de7d721430
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2026 00:23:25.1503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 19NSltS5Ol4NxvJQoGAyxVpH6TvBIvetLZ0yjnGmDpCGUmyPBwnKsa6TiqMP6XrGFoRxbwx6trlJZIz53qjR7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5225
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 163A4232DBC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73250-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAzLTA2IGF0IDE3OjAzIC0wODAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gS1ZNIHRyaWVzIHRvIHRha2UgY2FyZSBvZiBzb21lIHJlcXVpcmVkIGNhY2hlIGZsdXNoaW5n
IGVhcmxpZXIgaW4gdGhlDQo+IGtleGVjIHBhdGggaW4gb3JkZXIgdG8gYmUga2luZCB0byBzb21l
IGxvbmcgc3RhbmRpbmcgcmFjZXMgdGhhdCBjYW4gb2NjdXINCj4gbGF0ZXIgaW4gdGhlIG9wZXJh
dGlvbi4gVW50aWwgcmVjZW50bHksIFZNWE9GRiB3YXMgaGFuZGxlZCB3aXRoaW4gS1ZNLg0KPiBT
aW5jZSBWTVggYmVpbmcgZW5hYmxlZCBpcyByZXF1aXJlZCB0byBtYWtlIGEgU0VBTUNBTEwsIGl0
IGhhZCB0aGUgYmVzdA0KPiBwZXItY3B1IHNjb3BlZCBvcGVyYXRpb24gdG8gcGx1ZyB0aGUgZmx1
c2hpbmcgaW50by4NCj4gDQo+IFRoaXMgZWFybHkga2V4ZWMgY2FjaGUgZmx1c2hpbmcgaW4gS1ZN
IGhhcHBlbnMgdmlhIGEgc3lzY29yZSBzaHV0ZG93biANCj4gY2FsbGJhY2suIE5vdyB0aGF0IFZN
WCBlbmFibGVtZW50IGNvbnRyb2wgaGFzIG1vdmVkIHRvIGFyY2gveDg2LCB3aGljaCBoYXMgDQo+
IGdyb3duIGl0cyBvd24gc3lzY29yZSBzaHV0ZG93biBjYWxsYmFjaywgaXQgbm8gbG9uZ2VyIG1h
a2Ugc2Vuc2UgZm9yIGl0IHRvIA0KPiBsaXZlIGluIEtWTS4gSXQgZml0cyBiZXR0ZXIgd2l0aCB0
aGUgVERYIGVuYWJsZW1lbnQgbWFuYWdpbmcgY29kZS4NCg0KWy4uLl0NCg0KPiANCj4gSW4gYWRk
aXRpb24sIGZ1dHVyZSBjaGFuZ2VzIHdpbGwgYWRkIGEgU0VBTUNBTEwgdGhhdCBoYXBwZW5zIGlt
bWVkaWF0ZWx5DQo+IGJlZm9yZSBWTVhPRkYsIHdoaWNoIG1lYW5zIHRoZSBjYWNoZSBmbHVzaCBp
biBLVk0gd2lsbCBiZSB0b28gbGF0ZSB0byBiZQ0KPiBoZWxwZnVsLiBTbyBtb3ZlIGl0IHRvIHRo
ZSBuZXdseSBhZGRlZCBURFggYXJjaC94ODYgc3lzY29yZSBzaHV0ZG93bg0KPiBoYW5kbGVyLg0K
DQpOaXQ6IEkgYW0gbm90IHN1cmUgaG93IHRvIGludGVycHJldCAidG9vIGxhdGUgdG8gYmUgaGVs
cGZ1bCIuICBJIHRoaW5rIHdlDQpjYW4ganVzdCBnZXQgcmlkIG9mIHRoaXMgcGFyYWdyYXBoLg0K
DQo+IA0KPiBTaW5jZSB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpIGlzIG5vIGxvbmdl
ciBuZWVkZWQgYnkgS1ZNLCBtYWtlIGl0IA0KPiBzdGF0aWMgYW5kIHJlbW92ZSB0aGUgZXhwb3J0
LiBTaW5jZSBpdCBpcyBhbHNvIG5vdCBwYXJ0IG9mIGFuIG9wZXJhdGlvbiANCj4gc3ByZWFkIGFj
cm9zcyBkaXNwYXJhdGUgY29tcG9uZW50cywgcmVtb3ZlIHRoZSByZWR1bmRhbnQgY29tbWVudHMg
YW5kIA0KPiB2ZXJib3NlIG5hbWluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNv
bWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg0KRmVlbCBmcmVlIHRvIGFkZDoNCg0K
QWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KQnR3LCB0aGVyZSdz
IGEgZnVuY3Rpb25hbCBjaGFuZ2UgaGVyZSwgYW5kIHBlcmhhcHMgd2Ugc2hvdWxkIGNhbGwgb3V0
IGluDQpjaGFuZ2Vsb2c6DQoNCi0gQ3VycmVudGx5IHRkeF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tl
eGVjKCkgaXMgZG9uZSBpbg0Ka3ZtX2Rpc2FibGVfdmlydHVhbGl6YXRpb25fY3B1KCksIHdoaWNo
IGlzIGFsc28gY2FsbGVkIGJ5IEtWTSdzIENQVUhQDQpvZmZsaW5lKCkgY2FsbGJhY2suICBTbyB0
ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpIGlzIGV4cGxpY2l0bHkgZG9uZQ0KaW4gVERY
IGNvZGUgaW4gQ1BVIG9mZmxpbmUuDQoNCi0gV2l0aCB0aGlzIGNoYW5nZSwgdGR4X2NwdV9mbHVz
aF9jYWNoZV9mb3Jfa2V4ZWMoKSBpcyBub3QgZXhwbGljaXRseSBkb25lDQppbiBURFggY29kZSBp
biBDUFUgb2ZmbGluZS4NCg0KQnV0IEFGQUlDVCB0aGlzIGlzIGZpbmUsIHNpbmNlIElJVUMgdGhl
IFdCSU5WRCBpcyBhbHdheXMgZG9uZSB3aGVuIGtlcm5lbA0Kb2ZmbGluZXMgb25lIENQVSAoc2Vl
IFsqXSksIGkuZS4sIHRoZSBjdXJyZW50DQp0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygp
IGRvbmUgaW4gS1ZNJ3MgQ1BVSFAgaXMgYWN0dWFsbHkgc3VwZXJmbHVvdXMuDQoNClsqXSBTZWU6
DQoNCgluYXRpdmVfcGxheV9kZWFkKCkgLT4NCgkJY3B1aWRsZV9wbGF5X2RlYWQoKTsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAJ
aGx0X3BsYXlfZGVhZCgpOw0KDQpjcHVpZGxlX3BsYXlfZGVhZCgpIGNhbiBpbnZva2UgZGlmZmVy
ZW50IGVudGVyX2RlYWQoKSBjYWxsYmFja3MgZGVwZW5kaW5nIG9uDQp3aGF0IGlkbGUgZHJpdmVy
IGlzIGJlaW5nIHVzZWQsIGJ1dCBBRkFJQ1QgZXZlbnR1YWxseSBpdCBlbmRzIHVwIGNhbGxpbmcN
CmVpdGhlciBhY3BpX2lkbGVfcGxheV9kZWFkKCkgb3IgbXdhaXRfcGxheV9kZWFkKCksIGJvdGgg
b2Ygd2hpY2ggZG9lcyBXQklOVkQNCmJlZm9yZSBnb2luZyB0byBpZGxlLg0KDQpJZiBjcHVpZGxl
X3BsYXlfZGVhZCgpIGRvZXNuJ3QgaWRsZSBzdWNjZXNzZnVsbHksIHRoZSBobHRfcGxheV9kZWFk
KCkgd2lsbA0KdGhlbiBXQklOVkQgYW5kIGhsdC4NCg0KQWN0dWFsbHksIGFmdGVyIGxvb2tpbmcg
YXQgbXVsdGlwbGUgY29tbWl0cyBhcm91bmQgaGVyZSwgZS5nLiwNCg0KICBlYTUzMDY5MjMxZjkz
ICgieDg2LCBob3RwbHVnOiBVc2UgbXdhaXQgdG8gb2ZmbGluZSBhIHByb2Nlc3NvciwgZml4IHRo
ZQ0KbGVnYWN5IGNhc2UiKQ0KICBkZmJiYTI1MThhYWM0ICgiUmV2ZXJ0ICJBQ1BJOiBwcm9jZXNz
b3I6IGlkbGU6IE9ubHkgZmx1c2ggY2FjaGUgb24NCmVudGVyaW5nIEMzIikNCg0KLi4uIEkgYmVs
aWV2ZSBpdCdzIGEga2VybmVsIHBvbGljeSB0byBtYWtlIHN1cmUgY2FjaGUgaXMgZmx1c2hlZCB3
aGVuIGl0DQpvZmZsaW5lcyBhIENQVSAod2hpY2ggbWFrZXMgc2Vuc2UgYW55d2F5IG9mIGNvdXJz
ZSksIEkganVzdCBjb3VsZG4ndCBmaW5kDQp0aGUgZXhhY3QgY29tbWl0IHNheWluZyB0aGlzIChv
ciBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUncyBzdWNoIGNvbW1pdCkuDQoNCg0KQnR3Miwg
a2luZGEgcmVsYXRlZCB0byB0aGlzLCBjb3VsZCB5b3UgaGVscCByZXZpZXc6DQoNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyNjAzMDIxMDIyMjYuNzQ1OS0xLWthaS5odWFuZ0BpbnRl
bC5jb20vDQo=

