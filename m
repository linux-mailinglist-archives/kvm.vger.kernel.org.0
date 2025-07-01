Return-Path: <kvm+bounces-51131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1062AEEB5F
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 02:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D01C17742C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D212D148832;
	Tue,  1 Jul 2025 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOc/0GuH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DF01CAB3
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751331119; cv=fail; b=c28m1l78N3uKlOJQILw5fm1CWo7t27F1COutDfj+PbZsolN490wUrSwNUipgoeqvmzZJtjo0iX2ANwDv4CAGrQpbSUtg3g5776u7/kX6ujmemPUMGu7LSwYpANoVhSPXHyhhjY69T9NxgHrwxt78LvZ2W0rc4YxFx0BQRYQ/wAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751331119; c=relaxed/simple;
	bh=w9xDU9g5jpN3KAE1Axgq23bP1klr6IRDHkUPWQ5T5zk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=puAiHBdQRkArjJVz8FzZdmYTkzT/uMTvPpsDqaODBf/IR/HSh/+ZEKxwmTtbgXPTcGS5u92Rg76SKamt+puVrBOrnW1JXbAbaaPOZtD94Jn7u3aK2K3lzsOgowDQxFPgBmdMoX67K7w4DR1MCqmJWce47D8Y5sEG4wnNKwEBGf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOc/0GuH; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751331117; x=1782867117;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w9xDU9g5jpN3KAE1Axgq23bP1klr6IRDHkUPWQ5T5zk=;
  b=YOc/0GuHPae/EG/WqGJA2cNA2jhFXljd4gTvhV6hPxJvD8tfn+p+x6yo
   ubNZKqZXhrZF8kvLdvAvHpVCmssyukNbqA60YF46QL86jUsklWAkY5p1T
   KdwR50Gt6NSbnrAZTsMP2RQZ3c6gp4ZmS/yH3pV9Wcs4U33mjYrg/5JA5
   SDm4RyVTE/MFjKcmYR6BfMlRko+RpAELJSIdKPbF7PYJLMfePY71/zSJo
   3zgLrMczKnbvflydmVsdORIeBixxQ+5WZb7GwZikicY7C0N0W59s2WjL7
   P6ovkTUg9yOWUUeefUPK5lCAh5Kqd+7Lywvi15eULBlLNq9HeTX7OtaIm
   g==;
X-CSE-ConnectionGUID: Q2OSK0j0QPGWehV5Db6FlQ==
X-CSE-MsgGUID: Iui3BuRkSK2SyOMkXULMMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53296916"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="53296916"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 17:51:50 -0700
X-CSE-ConnectionGUID: SuH3Y9hSQkiSF0Ttjgp9TQ==
X-CSE-MsgGUID: 5t6NiR47TT+JXse+lBf80g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="158149276"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 17:51:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 17:51:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 17:51:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 17:51:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LJWjk+oGqUQrtICKThbk0geVXW00fLj3jamGq90ZFG2oej5BBexTY11aRg5kxdImezlUZ2dgT2I5iLyYK+PSSTwV8QV88x4IM+V8qwsYLMGXRff+wRG7cYqcTqSpsj1K+4Asvetk6FRGVFV6sPS/kMOxg5TY8gubDSLA6Ng706OczR0iJOvD79z0SEsowx1iT3MKwI1KneeK8xweBJjtn57vFSNoAQMQVmaA2xgQb8YuK8go7h+BaHreNdGlZoCHg/RdsD3Ozt8GCLWRapSIkQnKZKf02mkuL3wy9Q9H13wIGzorH8GZTEsQ0GfFQNMc/x5Y30754Qu0CpaZi3PtMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9xDU9g5jpN3KAE1Axgq23bP1klr6IRDHkUPWQ5T5zk=;
 b=YO+DVPqmfiSPotVr3EAbbjx/rdoWt73sJzuHeCtLLE3wh/WVtIYscIfv9ILSYJ1WUzPuBrNUWORy3eCmnyGkqYqXU0ZFW7Ke6r+NILZsIHiHOpwG8dPGUp3zN++MvQZLliGV/7NgCHoSbBMsf5LXH/NGGIMI8ugZ08ikkgIDvAFVq/C1Cy+3wVuA9Cn2lImNlIli9V4uIhQzwtwFR5xBEWxiRLIKcpobZV2WnS55p6lxgJo2eYLlhVc+pVQehSlu7fKa+hoW2oaVDS/kBdPvjfy6zV/0IswxSpS7G1k0W2KAMmpZaljnElVkaP2cdJTFz4kk0TTvfQZzXN2sYUVAAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB7500.namprd11.prod.outlook.com (2603:10b6:510:275::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Tue, 1 Jul
 2025 00:51:20 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Tue, 1 Jul 2025
 00:51:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb6awSQgGTXSslVUSNVI1aR2O0trQccSiA
Date: Tue, 1 Jul 2025 00:51:20 +0000
Message-ID: <bbee145d51971683255536feabf10e5d2ffefb44.camel@intel.com>
References: <20250630104426.13812-1-nikunj@amd.com>
	 <20250630104426.13812-3-nikunj@amd.com>
In-Reply-To: <20250630104426.13812-3-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB7500:EE_
x-ms-office365-filtering-correlation-id: f918dee6-e8b4-4829-3fd5-08ddb83964e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YXR6T1Z4VFZ4TTl0QlpPSGxLMDlzcUh5YXVPT2lUV28rOElKZ2kvSGJIc0tO?=
 =?utf-8?B?T2xmRnJadkpEMVVlcEpaSXMrNlpEZk5aYWFZU29vUk5aMUM3enRzK2ZFZ2Za?=
 =?utf-8?B?NkhRck1peFZMeGoybzA3cUJJaEhiaVZFMVNDN29LdmxZNGhKWmNSOXUxc1JW?=
 =?utf-8?B?SERHOU90cXZ1QjFqNU50K1lHSzY2ai9OUGorTGc0RmZ1Y0ZseUszaVRKZmhU?=
 =?utf-8?B?YXM4aTJjc05JaWxmNGVkVlNPQ0ZkeXBKU1g3NDlIbHFEQVQrZC9ubytjdEZh?=
 =?utf-8?B?Y2sxTndreEJ3Zlh2MWFYbnJKaVFLM0plMTJyVlhSU2phajUyYlhVRzhFc3M5?=
 =?utf-8?B?NThDaS9lNnJES3ZSWDhRSEQ4M0doSWZlMTB3VVB2ZFNsM0lRWFMzRm5FOHlM?=
 =?utf-8?B?cUxiSnlEWld2M2JZSURFUE9vWHpRN3A0K0JUSzhKcGYrcE5pUUtsQ3hsVmVu?=
 =?utf-8?B?VTJDMURVbUNQd2Fpc294UVZ6WnRHTXQvWXdmQzNnRHdFcFJuQWo5TzBnTVJ4?=
 =?utf-8?B?QldjZ0tWUitJSkdmaFdmMGQ1YjR3LzRxOEhaRGJHSStNOUFyK3VGUUV3ekZD?=
 =?utf-8?B?YUpjZ2RuNndHUzUxQ3pjbDh5Rjc3c1Z4SldSSXROWHNNd3RwL0pVdHRMKzF1?=
 =?utf-8?B?bSthYU54UEJvMExpTlRtR3A0QmswWE1Ma21TVk1TTVZxTU5GRytsNnFnK1lu?=
 =?utf-8?B?MXM4U3RWZVlpRE1kMHlmNFdOVVROMjhxYTlXUFB3aHBEbnI0Qm1wWFhZRnZW?=
 =?utf-8?B?U05aR0FGVDVzclVha2RiZjVDWTFhYkFPQmQvNGFuVEZ2MXlKUWVvV2VsS3Bs?=
 =?utf-8?B?NitGSzF2MUlEWCtKRzNMMGQyQkl3VjdTWDJEZnZaOG9pNEl6N244WUFqSGwz?=
 =?utf-8?B?M3RVNWlPZGhiTUlPcHhUWHlIWjloUk5uZGIwK245SWkrdEdWTk1wb01RbVcv?=
 =?utf-8?B?TDBwWklIQ25DODBuYUd5TXJGczNTRGtzMythRXYxZU52SEd0bGVycVJyQlk0?=
 =?utf-8?B?M3FmODZ4dCtxaTNBTUY5M1Z2MG5Pc0t3V2lTVGI0aFV3bURNMU50WXBZaVhJ?=
 =?utf-8?B?S1lXUkxQZysycVd0UDI0V1pkVUhEdHk0akM2S0VhSWQwWi96anFWQnZxSDFJ?=
 =?utf-8?B?cmdSUmJVSmk4ZlNKekFjU0xKSzZMdU90N3AwT1NlQ25weFhjTXdwMXdWZEFP?=
 =?utf-8?B?QmhiS3JnZzM5SU1ycXFDc3d2MFRkeGJmalEvcVJRUldSZ1FQZEIzNzJRS0l1?=
 =?utf-8?B?Tkx5enRlMUh4aXRudDZzTTZoVmxUY080bXYwZEkvQXRnajVqMDNFSTdhYzR6?=
 =?utf-8?B?aDNXQ0dPNTFxbklNVDB3c1hkZkRSWmZ1Ry83WXRPVyt1K3FFUkFnMVV3Q3V0?=
 =?utf-8?B?ZlpuWlRtdExsemtQNmNMTmxXeU5abzJTa3RkMVJwWjdCSDFGU1grSnRTQVAw?=
 =?utf-8?B?bmp1RzhwU090Q2x3aDZ1YVRjcnBKSVo4TENiYzlrUThaWmNrMGF5V1Eza3ZS?=
 =?utf-8?B?ck03Zm1JNEg1QTF5WlhYNmw3ZE1vYU9DZVI0ZGt6Tkl2cExKYWNGN29Xbk9x?=
 =?utf-8?B?TXR6V2VmMThJbk1oYmF0SGRSSUxoSmx1bS9FMzdEWmJwbm9OcHNCMUtaRWVN?=
 =?utf-8?B?Rk9QTWFuUXNkRXVpTmh0WWdGY09LOTI5R0JZT1JGa1QycXRwaU9IaUVBTXRk?=
 =?utf-8?B?WVlJQUJHdDRiRTRmNTR4Q0g3TWhMeE1ETXJyOHVsMFp6dUdSTkc2U0FUb093?=
 =?utf-8?B?Sm1jcjd3SGpaQVY1QUZvc3FsUVp5RkNDcS9Oak1ESVlwV2ZXUjlsbUkvZ015?=
 =?utf-8?B?Yi9XdjhYczRHRnJEZ3FmWjZib2hSdDZ5Wmc3bkhSalRXTmNoQkxrMzdQQTh2?=
 =?utf-8?B?aEtIUWlieWZVUWE5N0lXc2M4aUU0NmZ4aEtyN3Z5bndoTzloS3Q2M1cydDcw?=
 =?utf-8?B?OGJLRjhCaVRZRUd0eitId2FJdjhBeVRHOFRRaEdKelZ0ZXlHS3pxOEc0UTgw?=
 =?utf-8?B?RHBoM090R3hRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjF2RHpVNG1jQ2MyeUhXZnFoMDhUUlBRWmpKT3JrTzdXWmhYaW9UQzA4WjJN?=
 =?utf-8?B?elBFajUxMGNuMHJWd0xiU0M0c2tZeUY4SkkxNGFjMnh2ZWVuZi9tWEpaSTE4?=
 =?utf-8?B?M1pFSVN1RWN6Y0hDMG1ydjFvV3pPelA2RCtYMUZLQ3JwZ21VdUlaVlh6d2xZ?=
 =?utf-8?B?dXZ4WUJlZ0MyRDQ1NWxFazJhMWlnbVpOTndURHJUdUJ0QlVsSm50M0g0ZThE?=
 =?utf-8?B?b2ZvMThBUFhaTHpwVU1lQWVOMWg2T1lHdjJiMXRsbUtJTzJscHQzdWtOUlJL?=
 =?utf-8?B?bjNaeHVpZVVZUkJ5ZWlRTEczbXN2R3RuWE0vT3IySEU2VUxCcDVDK0NjUlAy?=
 =?utf-8?B?NkJjS0FyNHFkZzZvSkQ4cDlkK2FxRFd6QXZ0cTluNElGMi9SWWUveHhycWxi?=
 =?utf-8?B?eGxWUFJCWThoMzQ0Q0ppV2hDYnBOVkJKaXBJQjc5UmFML21PMWtKNm5RVmlX?=
 =?utf-8?B?TFlnK3FrRTRFcVRTT08yaTg2SDFjbWhyWTBVY1FNRVpTdjlub1FqRUtvYjNU?=
 =?utf-8?B?RHdEM1hGUStpaVJ5cjE0Y3FGQmh0U3U0TjdaekRSTzlHTXZUMTQ4NENObHFQ?=
 =?utf-8?B?THJ5WHdwWjR2WUg3WkhXZ2JUdlNJSXMvalN2UzcrQzd5WTdYdVp1UThLTTRs?=
 =?utf-8?B?U1BrQmptSFhUUXR0VkMyODlwK3kxSm9ZZUdGNHZiM0x0V2t4ZldOWFJjL3RG?=
 =?utf-8?B?L2dyRGk3ZGthWVdaei9QdndkZ2lGMVBGc3dGNXA4aFZuck1DRSt4MUtPUTd5?=
 =?utf-8?B?NzAwV0lSN1BvOTJuOXpaN2R4ajBMR21TdjYzR00zL1QraS9kRUJpTFdab1F4?=
 =?utf-8?B?YUt1ZFYvN2JlaEtjcHQxZGNndVlzSVhOSkhHNE8zY24xU1hrMVpYMmJNWGsw?=
 =?utf-8?B?VVJqSUNxVXhjZTV4cW16M1lBdHpmUFltamZJUlNOY1k2VXFUeGFzSEtkV1dN?=
 =?utf-8?B?M3dmVENhWjhTOExjekZ4ZVBmTGZqNytnbG9TdUNqV25jd2MzRFo5aTdhaVRB?=
 =?utf-8?B?cTNSWXYzSEdDanFNOS9yUXhHUzdtcmhmSEVQMFpzMDE5RjBseUdtdUNnN25G?=
 =?utf-8?B?Tm9SbXFXVUVsZjkzem42YkMzZHpiWjFtYTJCUXhhbStqUTRlK3lmVmprZUln?=
 =?utf-8?B?VDlJT0dxWEdqTEljN2tSRHl4bVBpdlhoRmhoL29kdWRDQkNVN1lxM3ZDZy9C?=
 =?utf-8?B?VVZ6Vkp5TGY3V1p4RytlSnNJbkVWNU5kSWZJQTA2L0FkQUNuZTdIa1k4K3hV?=
 =?utf-8?B?TGRUY1h4eDNJVW5HRkRyUklrWmJTSFA0bWNPM3RNUEROY3ZXMGd2TXRWenRW?=
 =?utf-8?B?M2ZSanFQdUFwcjFMT05tUXhYbmQ5dTc4UmxldXF1MFJlbGRiUkorMlptaGFB?=
 =?utf-8?B?WlVXNkU0OEpiSWw5NWtxTE9ZVTkwb1JIci9ibkk0dGFlM2s3Z3VOMTFITkJt?=
 =?utf-8?B?SzRxeHdKZGZyZTZIczR0QytWWEdqaDdNNkRqYnB2WVRVQUF6czFUcWJLNHRl?=
 =?utf-8?B?L0pMakRVejhlL0VVRHcyZ1pZQVBKdFhOV0NYQlJBTXYvcjhCZXpLS2JmcHM1?=
 =?utf-8?B?cGkzQ0h4V2E3Z3lKRnNiZElDdVV1VllncUtNR3FxZkZsVDhGbW5nR2pqbnBt?=
 =?utf-8?B?VW5zSHU4MlVVcFJDZEpHWFNzdHBkTW9XbU9PU3g0aXlSMEhmQThYOUFVdSsz?=
 =?utf-8?B?bXU1QlpmSzJBUzlLUGdDRnM0cnR5cS8ySzJiWFRlTG1QYXB5a0YxWVl4L255?=
 =?utf-8?B?ZU9aSnNzcUd6em8xYnR3dHkvSjAwSEJvTm5yVDJKdFpkRm9nalZheTVZNWRr?=
 =?utf-8?B?SWNoN3htTjBMek1TTzNCbU5xNEJCRFFPNWZ4S0E5WWxTbHNURklTd0pzN3VT?=
 =?utf-8?B?K3lZdWROQkVvWWtlZG9lTEdZdjBFMW9uTDlQMXNKNFhqRS9OQVkzeFZ4bFlz?=
 =?utf-8?B?RldaVjU1R0FKVEE5VHo3QjcvRzZHVmJHMDZ6OWZ4cWVZUXRSR1ozQjNBQkh3?=
 =?utf-8?B?ajArREJ3MEkrN0V0RENTZjFJNkdPWVVKSjd1TXFPT2NSSHRxYmNrRDQwQjVY?=
 =?utf-8?B?TnpNdUFCYlNzdEpvVmg0MDFQRkFaNDdNSG5zelBuajdISVUvcUFkNmZKUkVR?=
 =?utf-8?Q?SDE+groVb39JqO01wonMncrN7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1FC24337EEF234CA16A2B963C12C28D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f918dee6-e8b4-4829-3fd5-08ddb83964e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 00:51:20.1102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NrMdBadQja6U/uVPR8bmvrFEWMKuoBkFXhCAm961yxxjIqVMRPL5LjfT1bU+g9/XKV1ypG1rJDjbzpk0/gUrBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7500
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTMwIGF0IDE2OjE0ICswNTMwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQWRkIHN1cHBvcnQgZm9yIFNlY3VyZSBUU0MsIGFsbG93aW5nIHVzZXJzcGFjZSB0byBj
b25maWd1cmUgdGhlIFNlY3VyZSBUU0MNCj4gZmVhdHVyZSBmb3IgU05QIGd1ZXN0cy4gVXNlIHRo
ZSBTTlAgc3BlY2lmaWNhdGlvbidzIGRlc2lyZWQgVFNDIGZyZXF1ZW5jeQ0KPiBwYXJhbWV0ZXIg
ZHVyaW5nIHRoZSBTTlBfTEFVTkNIX1NUQVJUIGNvbW1hbmQgdG8gc2V0IHRoZSBtZWFuIFRTQw0K
PiBmcmVxdWVuY3kgaW4gS0h6IGZvciBTZWN1cmUgVFNDIGVuYWJsZWQgZ3Vlc3RzLg0KPiANCj4g
QXMgdGhlIGZyZXF1ZW5jeSBuZWVkcyB0byBiZSBzZXQgaW4gdGhlIFNOUF9MQVVOQ0hfU1RBUlQg
Y29tbWFuZCwgdXNlcnNwYWNlDQo+IHNob3VsZCBzZXQgdGhlIGZyZXF1ZW5jeSB1c2luZyB0aGUg
S1ZNX0NBUF9TRVRfVFNDX0tIWiBWTSBpb2N0bCBpbnN0ZWFkIG9mDQoJCQkJICAgICBeDQoNCkkg
YmVsaWV2ZSB5b3UgbWVhbnQgS1ZNX1NFVF9UU0NfS0haIGlvY3RsPyAgU2luY2UgSSBhbSBub3Qg
YWJsZSB0byBmaW5kDQpLVk1fQ0FQX1NFVF9UU0NfS0haLiA6LSkNCg0KPiB0aGUgVkNQVSBpb2N0
bC4gVGhlIGRlc2lyZWRfdHNjX2toeiBkZWZhdWx0cyB0byBrdm0tPmFyY2guZGVmYXVsdF90c2Nf
a2h6Lg0KDQpJSVJDIHRoZSBLVk1fU0VUX1RTQ19LSFogaW9jdGwgdXBkYXRlcyB0aGUga3ZtLT5h
cmNoLmRlZmF1bHRfdHNjX2toeiwgYW5kDQp0aGUgc25wX2xhdW5jaF9zdGFydCgpIGFsd2F5cyBq
dXN0IHVzZXMgaXQuDQoNClRoZSBsYXN0IHNlbnRlbmNlIGlzIGtpbmRhIGNvbmZ1c2luZyBzaW5j
ZSBpdCBzb3VuZHMgbGlrZSB0aGF0DQpkZXNpcmVkX3RzY19raHogaXMgdXNlZCBieSB0aGUgU0VW
IGNvbW1hbmQgYW5kIGl0IGNvdWxkIGhhdmUgYSBkaWZmZXJlbnQNCnZhbHVlIGZyb20ga3ZtLT5h
cmNoLmRlZmF1bHRfdHNjX2toei4NCg0KPiANCj4gSW50cm9kdWNlIHRoZSByZWFkLW9ubHkgTVNS
IEdVRVNUX1RTQ19GUkVRICgweGMwMDEwMTM0KSB0aGF0IHJldHVybnMNCj4gZ3Vlc3QncyBlZmZl
Y3RpdmUgZnJlcXVlbmN5IGluIE1IWiB3aGVuIFNlY3VyZSBUU0MgaXMgZW5hYmxlZCBmb3IgU05Q
DQo+IGd1ZXN0cy4gRGlzYWJsZSBpbnRlcmNlcHRpb24gb2YgdGhpcyBNU1Igd2hlbiBTZWN1cmUg
VFNDIGlzIGVuYWJsZWQuIE5vdGUNCj4gdGhhdCBHVUVTVF9UU0NfRlJFUSBNU1IgaXMgYWNjZXNz
aWJsZSBvbmx5IHRvIHRoZSBndWVzdCBhbmQgbm90IGZyb20gdGhlDQo+IGh5cGVydmlzb3IgY29u
dGV4dC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpAYW1k
LmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBLZXRhbiBDaGF0dXJ2ZWRpIDxLZXRhbi5DaGF0dXJ2
ZWRpQGFtZC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEtldGFuIENoYXR1cnZlZGkgPEtldGFuLkNo
YXR1cnZlZGlAYW1kLmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+IA0KPiBJIGhhdmUgaW5jb3Jwb3JhdGVkIGNo
YW5nZXMgZnJvbSBTZWFuIHRvIHByZXZlbnQgdGhlIHNldHRpbmcgb2YgU2VjdXJlVFNDDQo+IGZv
ciBub24tU05QIGd1ZXN0cy4gSSBoYXZlIGFkZGVkIGhpcyAnQ28tZGV2ZWxvcGVkLWJ5JyBhY2tu
b3dsZWRnbWVudCwgYnV0DQo+IEkgaGF2ZSBub3QgeWV0IGluY2x1ZGVkIGhpcyAnU2lnbmVkLW9m
Zi1ieScuIEkgd2lsbCBsZWF2ZSB0aGF0IGZvciBoaW0gdG8NCj4gYWRkLg0KDQpXZWxsIEkgZ3Vl
c3MgeW91IGF0IGxlYXN0IG5lZWQgdG8gcHV0IHlvdXIgU29CIGF0IHRoZSBlbmQgb2YgdGhlIGNo
YWluLiA6LSkNCg0KWy4uLl0NCg0KPiBAQCAtMjE0Niw2ICsyMTU4LDE0IEBAIHN0YXRpYyBpbnQg
c25wX2xhdW5jaF9zdGFydChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2NtZCAqYXJn
cCkNCj4gIA0KPiAgCXN0YXJ0LmdjdHhfcGFkZHIgPSBfX3BzcF9wYShzZXYtPnNucF9jb250ZXh0
KTsNCj4gIAlzdGFydC5wb2xpY3kgPSBwYXJhbXMucG9saWN5Ow0KPiArDQo+ICsJaWYgKHNucF9z
ZWN1cmVfdHNjX2VuYWJsZWQoa3ZtKSkgew0KPiArCQlpZiAoIWt2bS0+YXJjaC5kZWZhdWx0X3Rz
Y19raHopDQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCQlzdGFydC5kZXNpcmVkX3Rz
Y19raHogPSBrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6Ow0KPiArCX0NCg0KSSBkaWRuJ3QgZGln
IHRoZSBmdWxsIGhpc3Rvcnkgc28gYXBvbG9naXplIGlmIEkgbWlzc2VkIGFueXRoaW5nLg0KDQpJ
SVVDIHRoaXMgY29kZSBiYXNpY2FsbHkgb25seSBzZXRzIHN0YXJ0LmRlc2lyZWRfdHNjX2toeiB0
byBkZWZhdWx0X3RzY19raHoNCncvbyByZWFkaW5nIGFueXRoaW5nIGZyb20gcGFyYW1zLmRlc2ly
ZWRfdHNjX2toei4NCg0KQWN0dWFsbHkgSUlSQyBwYXJhbXMuZGVzaXJlZF90c2Nfa2h6IGlzbid0
IHVzZWQgYXQgYWxsIGluIHRoaXMgcGF0Y2gsIGV4Y2VwdA0KaXQgaXMgZGVmaW5lZCBpbiB0aGUg
dXNlcnNwYWNlIEFCSSBzdHJ1Y3R1cmUuDQoNCkRvIHdlIGFjdHVhbGx5IG5lZWQgaXQ/ICBTaW5j
ZSBJSVVDIHRoZSB1c2Vyc3BhY2UgaXMgc3VwcG9zZWQgdG8gdXNlDQpLVk1fU0VUX1RTQ19LSFog
aW9jdGwgdG8gc2V0IHRoZSBrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6IGJlZm9yZQ0Kc25wX2xh
dW5jaF9zdGFydCgpIHNvIGhlcmUgaW4gc25wX2xhdW5jaF9zdGFydCgpIHdlIGNhbiBqdXN0IGZl
ZWQgdGhlDQpkZWZhdWx0X3RzY19raHogdG8gU0VWIGNvbW1hbmQuIA0KDQpCdHcsIGluIGZhY3Qs
IEkgd2FzIHdvbmRlcmluZyB3aGV0aGVyIHRoaXMgcGF0Y2ggY2FuIGV2ZW4gY29tcGlsZSBiZWNh
dXNlDQp0aGUgJ2Rlc2lyZWRfdHNjX2toeicgd2FzIGFkZGVkIHRvICdzdHJ1Y3Qga3ZtX3Nldl9z
bnBfbGF1bmNoX3N0YXJ0JyBidXQgbm90DQonc3RydWN0IHNldl9kYXRhX3NucF9sYXVuY2hfc3Rh
cnQnLCB3aGlsZSB0aGUgY29kZToNCg0KCXN0YXJ0LmRlc2lyZWRfdHNjX2toeiA9IGt2bS0+YXJj
aC5kZWZhdWx0X3RzY19raHo7DQoNCmluZGljYXRlcyBpdCBpcyB0aGUgbGF0dGVyIHdoaWNoIHNo
b3VsZCBoYXZlIHRoaXMgZGVzaXJlZF90c2Nfa2h6IG1lbWJlci4NCg0KVGhlbiBJIGZvdW5kIGl0
IGRlcGVuZHMgb25lIGNvbW1pdCB0aGF0IGhhcyBhbHJlYWR5IGJlZW4gbWVyZ2VkIHRvIFNlYW4n
cw0Ka3ZtLXg4NiB0cmVlIGJ1dCBub3QgaW4gdXBzdHJlYW0geWV0IChub3IgUGFvbG8ncyB0cmVl
KToNCg0KICA1MWE0MjczZGNhYjMgKCJLVk06IFNWTTogQWRkIG1pc3NpbmcgbWVtYmVyIGluIFNO
UF9MQVVOQ0hfU1RBUlQgY29tbWFuZA0Kc3RydWN0dXJlIg0KDQpJTUhPIGl0IHdvdWxkIGJlIGhl
bHBmdWwgdG8gc29tZWhvdyBjYWxsIHRoaXMgaW4gdGhlIGNvdmVybGV0dGVyIG90aGVyd2lzZQ0K
b3RoZXIgcGVvcGxlIG1heSBnZXQgY29uZnVzZWQuDQo=

