Return-Path: <kvm+bounces-61123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0055C0B5AD
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 23:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C847218989FD
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 22:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F6A2D9492;
	Sun, 26 Oct 2025 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W1LL4DTe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA26238D22;
	Sun, 26 Oct 2025 22:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761517507; cv=fail; b=fnvdocp9GNPvENtpyqj9IDRmW1w9vUymGCQV+kKxFMKPD7wJMkV8Xc5kp/DykKYySadMH6li2sJ63TBuXyXc07lUS25fnzNEFifVJEZENUw5daCQsvrpdfwWO8TBR78Mk8vzvuL4m9E0lMfoNHBniOIEyC7/CV3d/RObtBYXJTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761517507; c=relaxed/simple;
	bh=VRkoVLsV0VQiwMkSn+baflUUIqXgBScQRAyGM5VU9jI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VlguaI6nPCr9PNsCrsJQTP+CgEC+dmaaLpmxAyir/1FJbEQincKgfWMnEaBYXGp6HfB/P2z5Ky/CzC0cNhjjRVH0+i2w1FOwv2s+uNMtYd2oj8w863hq9gJrbpPyWXriOVi9LLqUxSkhkbAdvM4PXBTYECVrRQfpKI/f2DbNsw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W1LL4DTe; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761517506; x=1793053506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VRkoVLsV0VQiwMkSn+baflUUIqXgBScQRAyGM5VU9jI=;
  b=W1LL4DTevC4uaWGQ9u/AwbuWPkdbiuy+pbQXR5PMU76yxohyJsAnJoGt
   NmwEhtyCnAEyuj9svY3LiJTZ1r7d2t+bxBfCSHFp2P9fYLGBBhv/WCrTR
   F3V9VSjDrSBghTy6vCI9MtOBwA9QO0nt1kJYDF+SgsQwAZYy8IGU/aB5Q
   25iot45QdQnx53zZIK7x2AFvQP3dLU9Je/Ut1cMn6dtCwr1NPeVarffXI
   +FHYSiOE8MxHKSBTmbN6ARO0/0dO1tSbdMEhty6civIi6eBInx6OpDcKp
   f/OQ8NJOkj2nbMnARZmqYJ9dW1MJYqqnpn0YFWcg9WFhKS/Ciot08MobT
   A==;
X-CSE-ConnectionGUID: xnBbwnMkTgy4SfkP6n5hAg==
X-CSE-MsgGUID: DBn/7zFTSx+NdnkPE6k06g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74203602"
X-IronPort-AV: E=Sophos;i="6.19,257,1754982000"; 
   d="scan'208";a="74203602"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 15:25:05 -0700
X-CSE-ConnectionGUID: SH2cWPR/RuCyPOdJ0wkiTg==
X-CSE-MsgGUID: MX7EfdDHS3uEc5gKeFxFRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,257,1754982000"; 
   d="scan'208";a="188942132"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 15:25:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 26 Oct 2025 15:25:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 26 Oct 2025 15:25:04 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.23) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 26 Oct 2025 15:25:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYXF0e/akTINF+3NXwnSGlVwuB01M4W9Wjsd3WjEiZGyqpij7bueH4iD7zcqtL/igasdVExhJ4MzlRTtuMK0pHiMP3x9GT+Ou54ed6+F2DRHsbrFedqqp/ddIxyaOIY9w6PIr4PBbNg9pN57tq62Pdu6lW06v7GSBXVHniRyklf8jMNA56fK7TkJziIonHHdcuBycRZQncZlJmbJwJIB2+umwY37hdglWu8Onis6exP4UA8CgASh4s/daDvYdTiCVLmSOca6wDZnWpJqICy4HIb2HNbN5DefTIjZUBRLKrq3KE4+M/5QK/UUTrANVUmrK2noukyEkPcz9vu2P9/l4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRkoVLsV0VQiwMkSn+baflUUIqXgBScQRAyGM5VU9jI=;
 b=AjBtD2wRh8vLGwtD/VTRwpjPNWyVNKlJC7FVCgzYULZtqlHISfiC0NRdtz03GnGlrMvQU1Nj751Ec5w4hTruz8UkUXOpVVm0iyHOu7sLgpSu5eGiywxhEB05wmCBE6EqRdAeyQ3FSUDLgkOY/MaeBOC2Kjp7II0hTpgPgtHATgsGCdpbUKUjXwp0Zx3ohKLV6gmCdbMuzKseYqeZzmGnzhjlGpWW/bWQ/vi2IBhp7y7uMdWD12CQXArKKDJGizkb91GLBrU3EDtsyvtxx9kNdFf1WUU2ioOTquyHMmfuYAiJfAABbphof69T178D3Kd23GSqjNt/BS2942qyiNChhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7778.namprd11.prod.outlook.com (2603:10b6:930:76::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Sun, 26 Oct
 2025 22:25:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.017; Sun, 26 Oct 2025
 22:25:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "sashal@kernel.org" <sashal@kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"thuth@redhat.com" <thuth@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "alexandre.f.demers@gmail.com"
	<alexandre.f.demers@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.17] x86/virt/tdx: Mark memory cache state
 incoherent when making SEAMCALL
Thread-Topic: [PATCH AUTOSEL 6.17] x86/virt/tdx: Mark memory cache state
 incoherent when making SEAMCALL
Thread-Index: AQHcRcvNcgV/f9zlb02RqjCklGKfdrTVAyKA
Date: Sun, 26 Oct 2025 22:25:02 +0000
Message-ID: <5f7a42b60c5cf1dba8f59c30d5d8f20a95545cf0.camel@intel.com>
References: <20251025160905.3857885-1-sashal@kernel.org>
	 <20251025160905.3857885-328-sashal@kernel.org>
In-Reply-To: <20251025160905.3857885-328-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7778:EE_
x-ms-office365-filtering-correlation-id: 9263b929-3105-43b1-c798-08de14de8187
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YzdMbmt2Q2RBTDhlaWtYRkdienVQTHlVdUJqem5Id3MzYkU1WUtWTGpOaTU1?=
 =?utf-8?B?cy9qVmcxS1ZqL1luRGxNVDNqdXB1MTNQZlVWRTFRYmJVakl4SnczOE5hODln?=
 =?utf-8?B?cXJKV0dQL1hMeEkvNHJDZ1ZyTEpmcnNoL2xXU0hPNTllMG9BZW95Vnc5ZjVo?=
 =?utf-8?B?SFhNa1lvY3Fqdys4c1lmaThzN3pIYW1aOXBmaDFQZ1g1aW5aVlA5ejJ3SUtt?=
 =?utf-8?B?Wkd4bkZkMkxmYUF0RUJaYjlkc0E2V0ozUXpnWC9zYjd2K29zN1FTSzlNeTBG?=
 =?utf-8?B?OUgweEZUdVo0Wjk3eTlTNmZZR0NHZnRFR3dSSXJ4VWpyTThGV1FMWE03ZE9N?=
 =?utf-8?B?V3Q1TEJPWXRWZG1Xc01EK1JqazZOamdRTkpwYkN2c2R6UTgwSDluNmVBY085?=
 =?utf-8?B?UVhQb3hBczJicUtzeVAzVFJmQUFRUFpUdkdDZjVRUWFHWWkxT1NoTHR3aWhF?=
 =?utf-8?B?L0pCU08zMW93ZzViSzFhT2NCdHdmS3JUT0wrc2s1Q3cwVDlac1h3cWdhTWJ0?=
 =?utf-8?B?YnVnczRBOWt1UDFBRXMwd2hpZUhTb3ZXd2g5SUlzK21TK3FvQ1NzTGg5Wk82?=
 =?utf-8?B?NitiWnQvaUMrcHo3cDhObzdIaDlIc2s0Zm54OU90MitySUZDT1NuL2cvZFF3?=
 =?utf-8?B?RnpZMEhLT3l3QjhQMTRXL0oxaTZIV0psODZON0FyOWZNdXRObklRYnNzSS9F?=
 =?utf-8?B?TmlIR3VIczRtSHRxMUplcEFMaXN0L1k5M1FpcTN1VFNOdDJmSEVSNzBkV3NP?=
 =?utf-8?B?WGRKQjkzQXQwU0txWjR0MHMzKzRPeGx4bEd2QVhocVpIWjJzVzdmdWkxVzVW?=
 =?utf-8?B?cG1CQjdIRXZFMnNqb3AvTkZtVi8wMk5wQURYQVJYVVRpNUw5dW9lWkFwLzRZ?=
 =?utf-8?B?ZlhZTThodTZNRGNSRlE0MnNIMkVzMnpNSlpUY0tEUFE1Z1llRGN0U2k1OWJm?=
 =?utf-8?B?SnJlcThkUng1NHJEQTVSTU9OamFEb1lCODRxbVZUZTFpcVN2ajQ4bWNkRjE5?=
 =?utf-8?B?TXRjRWdzVzNqR2Zid1dZMGZCdklyQ3M3d3BCK3Z1dVVNN3lSLzlmVEs4QTZs?=
 =?utf-8?B?WUlKNTZLaU9TNDlGdU5BaHlseU04Q3RoR2tqd2hEbFRHRzZVMmJPWTJ3ZXV3?=
 =?utf-8?B?NFZkVlhOK0JTVnhodXM4WktXU2t4Wm5aL28rU0xoSWZidTEzNXdxL2FXaHBG?=
 =?utf-8?B?a1VtcFl2OUlEeFhYam5tdnBWVXBMcGF0R2dkMU5TMU94QmRtTDVRaHdDcFVB?=
 =?utf-8?B?VS8yY3lQSWlsTGMvOGJ4RFdTNklFWGQwaUY2eXllQ2hqRTR3aVFtL244dmZQ?=
 =?utf-8?B?c3ZOMVh5LzJkSi9KWGsrMzQ4S256RDhIbHZ6eUV5bEtCRlFxN1ZUR0NoNUNH?=
 =?utf-8?B?M0F2QnRZNnFXWUVsaVdhZXY3UFJZR05GZnpDTUx6UCtLb29GZmphSUIwRER3?=
 =?utf-8?B?V1JTdGhvV2Faa251eG56UnZTeUluR3Z5WUR4akVSMVRnZEFmMWdjdUtxaEJa?=
 =?utf-8?B?WVR5SjhRR3lISDBnSkhHRk9Jb3loeWhNYy96eTJnRU54L3VlNzk4cmZqNk9o?=
 =?utf-8?B?T0RwdGVqYSt0YXZvNFl1K01ZbEZUVTlERzJneDBPOGNRdEJwT1ZRNzVvSlNw?=
 =?utf-8?B?Wnp4dUI2UUcvck5QVHlHdDlySk9Pa2MwRkxhWCtxOXozTnJoaTRaQWk4eHdZ?=
 =?utf-8?B?aXBxMVNaMVpzUHNPUVEvOTJZZWVTZjRsTEtBSkthZ3lQam91dFFDaFF5d1h1?=
 =?utf-8?B?S2hnWG5Hb1oxL0lPUDU5a1ExcFFrM2lSYmRzSmhnazIyVExoMHdiV2NzMDFC?=
 =?utf-8?B?T2Q0U0Jkc20xTkJySThkSFRPekFVM1luWER5Sk9QbmNkMldENG5UQTBOMDBZ?=
 =?utf-8?B?UURtMFhqWE41UjJ5Z0pYdldtZUV4N2FLQnBoOUZtRmhnZFN6RUhFLzY3Ymdu?=
 =?utf-8?B?bHBlemt2OU1vVHFLQm5iRVgvbFdwdm5Ia2NHTjF3d25va0JxcmVaOHhKMTJS?=
 =?utf-8?B?RWM3TVY2ZklrT1dWZzIvOEJDMXJxZEFlN29ob2NWWXBmaE9tV0N1NFNESnRK?=
 =?utf-8?Q?uyVhHW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVJ6M3FFdTBqSEk5S3AwWDFDMzh5RkhKR21NS1RDVTh5Rk1BdTVUWVlaT1Zh?=
 =?utf-8?B?NStic2tkaGJtdC9COTNqdFByOGg4dHlJeFNHYkFvUTRZc2Fnb0RSaFRqTFlT?=
 =?utf-8?B?TTVkTS93a0ZwaHY1cTNSV3hEOWkyWEF6aHNYbFJMdGZFTndQZXNDaSt3RFRQ?=
 =?utf-8?B?REhTMC9OeW13dmNTN2sxYmp0RDFjNzBkalFKcWQ2dWRvZUtHa2dmWjZrWHkz?=
 =?utf-8?B?L2VCY3lqQ1RaMTlCaThHQmlNZlQ0eWtzT3dVYnN4ZEJrQUVrNmFobkdoMlJ4?=
 =?utf-8?B?U296ak9ZQUJMOXhkN2ZTQm81cG1oeVo5a1lTMlFmdUZIT0kyYlA5UEVNWWZU?=
 =?utf-8?B?WmZrMzJZT2FLWUllL2UwaWJsUEdCZkNpZ0pFOE5VditMT3FOMC9sY2xtN3FC?=
 =?utf-8?B?TStXUmJkR2lCVUFkUEJVWFEvZ2pPMFVHTC9sc0dIYzY1UlF0Uy9xWFVIU2pv?=
 =?utf-8?B?ZmFXTTVxdDZEZm5YbjFNc2lYMjFoNEwrSkVMbFJEcitOY1ovS0gwbHdrTmZL?=
 =?utf-8?B?dWZEemZybzIvUWk0eUdnRit0dXhIZTBLOVNkYVN2cEpUZlpNTTJMTlp1TXNZ?=
 =?utf-8?B?TXRnVytyYU55dHVsK2tsVDVoVW5yRDFqd1pzalZXb3dWVU4rMG4rSU0zdTdz?=
 =?utf-8?B?dXpubDE4V0h1blFpRmZ4R0U3V3lDc3laTS8rbEdtMW9uTktxNXJ1THRrV09p?=
 =?utf-8?B?Qk1GemQ5NlAvcmxwNTFsbUVwTE90YmUwWm4zRzE4bFlNSXc1MmIraitENnNt?=
 =?utf-8?B?OE42RnVjb29VZEhKYlFSazQrcmJqODZNL1lVdzZHZFJVbUU4dkN5ZGVVZmRP?=
 =?utf-8?B?cWlIUlE3ejdEZ2MzYWpwZHpvUzYraDE1ZjQrTWROOVhadGNBSng1QnNmYlhX?=
 =?utf-8?B?Z3p5NmhycFNTZDlEMFlrRGFJbHBxMW4vSGRzQ1FTQ1BEVzNlaFYrWGdNSTVq?=
 =?utf-8?B?d0ozWVo4VkVqYVVVV0h2dlFvb21uK0FXZGZiMVNRcDhJc1g0ZW5TeE9Ra0Fz?=
 =?utf-8?B?c0M3SGozc1lqRGk4dU5vS2ErMFVyZVVqUnlKYWpWTi90R2M0MENJRkpnRjVh?=
 =?utf-8?B?TW9SNzNPcldncms2UWJwNEhBbVUwWHA1aktPQ2hZTGhSY1BrTHFSSEcrS0RG?=
 =?utf-8?B?Um82UVZvSnd3OTc0eHJ1ZGVpRm5xVGo5Z2kzb0FtK3phemVsRDB1bURaczYx?=
 =?utf-8?B?Z1p6NklwRzJSalFXZ2xINmF0OWYrYlFSbFZnZkVzYS90NnV4MXlqR3daRkF5?=
 =?utf-8?B?UE1zYWFxQnNpUnBKbWhtNlZBR2lacXBURTNDWXd1ek9zeWV1K2lkOHZDdmk4?=
 =?utf-8?B?N2JZVERHaXpIR2FxSTJ5cnlkY0hRSVRzL2NZSHJvK0lJeFlBQml5b0xUVlgz?=
 =?utf-8?B?NGRxTEtXYkxkQ1ZzY3pDcTVhV3VScE1tSmxwdW5WbDU1OER0bDBsN0duVkMz?=
 =?utf-8?B?NVpLSEtBK2NOMkFXUXlWeHVoWENuR0YyVDN6aXVkZ1JjdFZ4T1hDMmMrSlgv?=
 =?utf-8?B?eVhqOHFLMElFTXEyc3gvQUVxNlA0M0hMT1VYU210R1RGMWNDLzZzamdoYXdy?=
 =?utf-8?B?Y2puOW1ucjQ3UVFtZ3M2OEprZXZSTjJHT05YL1FKcWQwcjdwaFNNb2FVNDJV?=
 =?utf-8?B?N0hKQjlOcTc5djc5N0lGYWs2amd2REYrMURmRHR1VUorbXVONk9Wck9Wb2xG?=
 =?utf-8?B?N2laajYzQTBFeEkycVd4WWxwR3pydjQreldzaHJlSWVqTWVuVEF5MTVPeFlx?=
 =?utf-8?B?RUYvVEJ4bTFLRDFNcG5JVklZamlLa0k3dU9NS1ZVbEFHTmRhSlNJeVFpNUJD?=
 =?utf-8?B?cGJ6d293Qk1adm9RdGNjWjhzY1ViQVJMZ08wUDdtSzZzUmxQRktnWjZnQ3h2?=
 =?utf-8?B?bXNLWnM1dnVkWHdCTG8xZ0lnZkdNRzRaelI1Nkt2bUpJdUhBOGVzMDBseDAw?=
 =?utf-8?B?YjZvOUFsQmcxRGFkQVByZzlyNTFkT3psOEdMRlZkaTUvUWEvbWVscDZ2Vkw3?=
 =?utf-8?B?VTFidzA5RlZiNXRucU96Qms5cUxuRnFWZG1JTlBpQmZudFFEUGFYYkt6elNS?=
 =?utf-8?B?VDE4eUsrVVEyUkV4RjcvQndwcExqaFdEeUswOGJ2WGphY0hRbytsVTBkQzBD?=
 =?utf-8?Q?/OxxHIDFdgL4zytGK1RdY4qKI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A98406A792BD6A4CA01B7F046AC2EFB3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9263b929-3105-43b1-c798-08de14de8187
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2025 22:25:02.1256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PvdQ81jnb3oS/wK8rK1NRgk/2pAR+qLreHIqdfbrE5pMga0U0QkP+SFNaZi3PwVn5CVr4gZj6y+uRdW7rUKWmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7778
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTEwLTI1IGF0IDExOjU5IC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
RnJvbTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4gWyBVcHN0cmVhbSBj
b21taXQgMTBkZjg2MDdiZjFhMjIyNDlkMjE4NTlmNTZlZWI2MWU5YTAzMzMxMyBdDQo+IA0KPiAN
ClsuLi5dDQoNCj4gLS0tDQo+IA0KPiBMTE0gR2VuZXJhdGVkIGV4cGxhbmF0aW9ucywgbWF5IGJl
IGNvbXBsZXRlbHkgYm9ndXM6DQo+IA0KPiBZRVMNCj4gDQo+IFdoeSB0aGlzIGZpeGVzIGEgcmVh
bCBidWcNCj4gLSBURFggY2FuIGxlYXZlIGRpcnR5IGNhY2hlbGluZXMgZm9yIHByaXZhdGUgbWVt
b3J5IHdpdGggZGlmZmVyZW50DQo+ICAgZW5jcnlwdGlvbiBhdHRyaWJ1dGVzIChDLWJpdCBhbGlh
c2VzKS4gSWYga2V4ZWMgaW50ZXJydXB0cyBhIENQVQ0KPiAgIGR1cmluZyBhIFNFQU1DQUxMLCBp
dHMgZGlydHkgcHJpdmF0ZSBjYWNoZWxpbmVzIGNhbiBsYXRlciBiZSBmbHVzaGVkDQo+ICAgaW4g
dGhlIHdyb25nIG9yZGVyIGFuZCBzaWxlbnRseSBjb3JydXB0IHRoZSBuZXcga2VybmVs4oCZcyBt
ZW1vcnkuDQo+ICAgTWFya2luZyB0aGUgQ1BV4oCZcyBjYWNoZSBzdGF0ZSBhcyDigJxpbmNvaGVy
ZW504oCdIGJlZm9yZSBleGVjdXRpbmcNCj4gICBTRUFNQ0FMTCBlbnN1cmVzIGtleGVjIHdpbGwg
V0JJTlZEIG9uIHRoYXQgQ1BVIGFuZCBhdm9pZCBjb3JydXB0aW9uLg0KDQoNCkhpLA0KDQpJIGRv
bid0IHRoaW5rIHdlIHNob3VsZCBiYWNrcG9ydCB0aGlzIGZvciA2LjE3IHN0YWJsZS4gIEtleGVj
L2tkdW1wIGFuZA0KVERYIGFyZSBtdXR1YWxseSBleGNsdXNpdmUgaW4gS2NvbmZpZyBpbiA2LjE3
LCB0aGVyZWZvcmUgaXQncyBub3QgcG9zc2libGUNCmZvciBURFggdG8gaW1wYWN0IGtleGVjL2tk
dW1wLg0KDQpUaGlzIHBhdGNoIGlzIHBhcnQgb2YgdGhlIHNlcmllcyB3aGljaCBlbmFibGVzIGtl
eGVjL2tkdW1wIHRvZ2V0aGVyIHdpdGgNClREWCBpbiBLY29uZmlnICh3aGljaCBsYW5kZWQgaW4g
Ni4xOCkgYW5kIHNob3VsZCBub3QgYmUgYmFja3BvcnRlZCBhbG9uZS4NCg==

