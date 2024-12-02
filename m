Return-Path: <kvm+bounces-32849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A1C9E0C02
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB909282CBB
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B531DE4D9;
	Mon,  2 Dec 2024 19:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f3hkyqR5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56752AD22;
	Mon,  2 Dec 2024 19:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733167463; cv=fail; b=Us0qGhNjOm476aNZeh/z1GIe7BYYBEfBvLL/Q1SdAt1zQUe/UCMuzlILBKWRNWYO2FjrDDe1tQWk4ljbMW8IoajXFiY9o5neI3NLj7g0bmqOt5Wk+WzdVHlHbHjFRuj6U1SYrJ++hluusjgH9NIfP1VxQ+0bEExXonKUX1I+nlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733167463; c=relaxed/simple;
	bh=Q+MOrfNJApId2ZZJIycYUN/kndOMegCc9QSAIw0lQNw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ik7JjpERnuu2gWIvZeikUGoMxClCAlZ8PqaOqk3XJOO0HLmKyeEhPxRLxO65jDMLD4orrDQawKhqTl+SAX4jk4WJL4zrmivJ6W7PfakNEG2h5uzAgnmWhTEsP12Yj12DCPoTt5nxVNHB0FdVeuvbLHeMVANAIs4QZuFs3vQGvn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f3hkyqR5; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733167462; x=1764703462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q+MOrfNJApId2ZZJIycYUN/kndOMegCc9QSAIw0lQNw=;
  b=f3hkyqR5v1dW8YWEzig6XdbEH95+I//kIPkthDb7Zovm20Fljr2s1c/u
   dI7sjkAIIE4zUhChZsNNqi9DoH/ejPF05Fd+2luLk9AUlzu7SosHkLP4s
   /sZXERDak5PWkmOZvsA4WPFawqpfF20e+7XbmmsRNjjijpk+pL/mwcoqc
   0AG8HCbuqw0CZPFoMoiFJdclsxtqui1tD+S5ggsyohcSigTlaT8O5MKMh
   SJrgBoGeyxrlLBDpp2tKu8wOPLv7cBqMgYzyBsIC/0NWhmkkZ4VvBlc/J
   uLWVagfqfXBgLewAee53bMkcIfumsnkAAKdqCAROP/XmGxiFV7qJpg6/T
   Q==;
X-CSE-ConnectionGUID: aXOtsfALQKG/CkwUZynw6w==
X-CSE-MsgGUID: RBH0b06LQm6JTDHLc+XLWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="44742455"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="44742455"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 11:24:21 -0800
X-CSE-ConnectionGUID: yjicUARKQwWxkW/OVoiLgA==
X-CSE-MsgGUID: YmnJaH8TTaCyIqqUH2dE6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="98179875"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Dec 2024 11:24:21 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Dec 2024 11:24:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Dec 2024 11:24:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Dec 2024 11:24:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OtIyurcea5QAFFgzZ7h0GZnOIVv4wdftz/za7EHvR1TAKZl8Wr40S2znxWuQ2DRNVZW1k6JQCoI2Sl3Cfh4Wc9iTC8QWJhOwG4cXXn0da7T0U4OjdMrFD9OdaONt3qUk0BmxCb5mLUohTRvgJKE+0DwGthcM751NxO+LzMaxRAzoXZqMDf0Jy7zjj5v/QziEuijcvxumr1acpat1xawnbIqLfl6oBC4cRCVUCvCECETNvXTwQyVmQ8R+uzXd3CoyPlZ4+7svqDkg5lMVoaslNqAL5p651KbLzPEcxCj8oxPE9JOHS4Dslz0dJ1sVlr0fpyf347A6iBezyH8nCK3mCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+MOrfNJApId2ZZJIycYUN/kndOMegCc9QSAIw0lQNw=;
 b=Jf2nV5ty22UfFV8DcTZmOdclohyYlwv0CNlR1zv4elvE39ahFSk5bCt0lEz1lCcg6jo6uGtibS+t66OB8m/EaY8YMf+8wwESUEqIbi5K3m3PyXjpW/m7S6M1zMCeY9K9rSZgajvYHnxA7JMOO9VI/GalcpciBSMJ2LjHoZvC10t/ms275xX59UYgZgq33SF3MOLjkxkVxW3lgZV43cASF39v9XTrp9Uvt/QdfbQ3SWzDJ4BRlOSJKpOCxgbtDjpTxyjPcPmzdDQqhLNeVNgQjneJpdufaCezYxgrXu2uWZt+ckun59/D1ow1XpKAJ6a0Gr+ecroY87xOnqdyhvjNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Mon, 2 Dec
 2024 19:24:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 19:24:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Yang, Weijiang" <weijiang.yang@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Topic: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Index: AQHbPFI1CpXUe0dtwEa1D+tl1lrdQLLCpF0AgAiMhYCAAv0xgIAFNDOAgAAEoYA=
Date: Mon, 2 Dec 2024 19:24:16 +0000
Message-ID: <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
	 <20241121201448.36170-8-adrian.hunter@intel.com>
	 <Zz/6NBmZIcRUFvLQ@intel.com> <Z0cmEd5ehnYT8uc-@google.com>
	 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
	 <Z04Ffd7Lqxr4Wwua@google.com>
In-Reply-To: <Z04Ffd7Lqxr4Wwua@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6690:EE_
x-ms-office365-filtering-correlation-id: 12edeb21-c589-40c0-0543-08dd1306e9af
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VnI0TE5ETVRuQmpQdXZaemJpb0RtWU15bGJVbERHRjUwM1h1S2tlNUJvZG9W?=
 =?utf-8?B?VFFiOU9QazY0YjlheTd3b2swMlVmc0xIMXRCNVMwYWkwQ1pCVEdiYVFpM3Rh?=
 =?utf-8?B?M2hRcm9YNDB1RnZuZXpDTGlnN01sRHJ2aEFxL2xocUZqbXh0SmVjMWUwZXls?=
 =?utf-8?B?YjJ1cExZMk9XS2EyWkpmcE80QXJxNytwQmNUTklXYjNSb2NtVm1ZUDN6V1J5?=
 =?utf-8?B?MHkwSlhpbjA5eGp1bHdNUVMvcHU2eUdOeVBBcDRPQVhMbFBsWGdKc3psU2JG?=
 =?utf-8?B?dnIvZGk4OTFBaThYWjRIUFVDMlY5U2ZVenpiYVVwL0d3RHk3amI5VVR0aFBh?=
 =?utf-8?B?ZW5lbnZ5N01kTkZvbGc1YklFRmdHMTc2MlI5VGoyb2FiTVhBMkZMV284Q2tJ?=
 =?utf-8?B?eHhRTWJ2aVRNSnJ0ckFUYkdnaWRpWjBGSGRmY1BiS3ZwN3RpTGV4eUk0bklK?=
 =?utf-8?B?ODdSQk9HWmFmNEUyNk1EOXVMbm1Fcm81bklsSHRNbWVjZTBRd2ttMHlRU0Vu?=
 =?utf-8?B?RFZDRVV1YWhsTEtQZFpKTUhUTHFvanFZdkN1WUYvdU4zYlM3QTdQK3BrRzln?=
 =?utf-8?B?ODYxUlJjUzFMMnQ4OUFPY2xmQ3BjZEw4a2dBT2M3Um54Wk5iVDF2bnJIZjJR?=
 =?utf-8?B?VXBva0YwWm4yd2RJSXFZeU1Jc3RLR1NXbUtMa0pzK1YxUnlycmNWRE1HZE5y?=
 =?utf-8?B?QmJhbnA2ZVN0Rzk4UCtrM29wRG5vcEtvS0xERGxRNWFwVTFxek5KYi9Zdld6?=
 =?utf-8?B?NHU4eU96ZDdHQTdjL2owWGFNRDZZVEVEamtBcEVFVktOYTJDeXRYNUNSeE8r?=
 =?utf-8?B?NHYzLzhSY0JLcUZzMkRzYmRra29PNXpPQmZzZkdqY2xqaTluR0hweXBYZzgv?=
 =?utf-8?B?eUhKazN2YWYrT2FYK2M5OStmYUxUWW1saXdWRUtVRVNKUjViZGNST0JRa1BV?=
 =?utf-8?B?dm91amVSajh1dGFueDFTdUJzSnk3TUJUaGdVaFM5eWlNaUxRcGU5L2NwUk9p?=
 =?utf-8?B?TzJPM3Y4MHRVcWtzd0NXYnh0S2RZZEV1a1A0eWx5UmxHNjBqR1p0TVFPNlZz?=
 =?utf-8?B?UXp2UXcwN2pRUk1DbW5sT3NvUzFmRjhQaGRFVXJEOWIrM1RVcEE4aW9VS1V4?=
 =?utf-8?B?eDdnSWt2Sk5rckpCcm45SEJleUp6NElIck8rZDgvZzlQTUZhNFFlS3o4cVc4?=
 =?utf-8?B?TzlQVVRObU5mM3Y1ZDFMYTNjajJWa3htRVpHcmVVNENtTnAwYmQ3TEMrOFg2?=
 =?utf-8?B?elF5RmVMdWxmUHhqb3FVZktnNzRtMjEyYnJidmxsa1htT2pUdThLbmpVYVNv?=
 =?utf-8?B?QXZURzBER3ppSURiQmhXdG1ySGZUZGpSR016Rlh6OGI3YVBnUWpMdG44Z05L?=
 =?utf-8?B?djQ2RDRMNVVLQnE3TDd3MkhHTnZOb0tJMFdSMkdDMUUzMUoxQTJRbmppZ1U3?=
 =?utf-8?B?bytyMkZPYXdYNXNOZmxBdmthc1Fxa09lMnhaUVo5Tk91MDlQZ0Urd1NJL1VW?=
 =?utf-8?B?dEJrRytYTHZTYzhaR004VE1Id2paZ0ZXZFMwRElJNnV5Q3duWUM3QlBMZjR5?=
 =?utf-8?B?MmZPOGJGK1AwSDRRNEtjZGc1RklQUnp3YW14d3Q1SU8rajUyU214TFh5M3N5?=
 =?utf-8?B?SkZ0UjRwZTJCRUd2SzlzekFCK3dNUjFlVlEzb2YzTEM1b2t0QW1YUUNSaUxU?=
 =?utf-8?B?bmd3VWhzY1F2VUJUcStmVVI2aUwvdWk5Tm11bjRJUElSNkxuOGoxM2NpZmFM?=
 =?utf-8?B?NTd4TGVUNWI0eSt4bHRHd1NDREVMdCtzRHJYbXZLT1VxVGdaYW9WTGJQMS9C?=
 =?utf-8?B?TVhtRHh2WGNjL0szbk9rdmc2SDZkZDlZQXlWNzZyOGRTM01Mb2hSMHBjQzRh?=
 =?utf-8?B?Y1dGeFlRVHhVQjBSMWVQekw4RmlIQUlpQ0NKY2xrUzJ1MnNLWWJQbS84dWF3?=
 =?utf-8?Q?YC+Uv/MNoPA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFQzQ3cxNWJTNGlwMFgreU5MRkdzWCsxR1NRMFlmRUpBUW9aajNiNWR4NnFo?=
 =?utf-8?B?K29vQ2ZHdWRxVnI5V2d3NWFrQjhyelJYZzVtQVFUemI0RHlWS0lwRG1SdC9F?=
 =?utf-8?B?UWdWOVZ4NWlyQjJRQXlGODd3SGtUTHQxVTdZYUdZaVlDNUJLMVUzUjNhVFYr?=
 =?utf-8?B?d2pORElKWXIzMTJUS3F4azAvUjdlYndFYVNxYUl1VldUN1pzZ0V1VkFmOGVB?=
 =?utf-8?B?a3cyTmNhM0VaT3FsRFdEQ1JyWU4xWGJDSEhQTDJ4azBHbXpOOEFmTk5qRFBq?=
 =?utf-8?B?VXNoZFBmNXJVWmgvVEFjTWNjRFlIYmpmSXNVNGwwYzhldjZ4MXRkQ1R1ekFM?=
 =?utf-8?B?cEhzbFRpbEpNQnJaUG5Xb1JoZjA0azBCUEVBVDVOc01Qdy84emlPTXBQdDFZ?=
 =?utf-8?B?WmxlSHpidTNhL2hPZVViSElIOER6WlVVN0JYT251dWhtbFd2UGJJNGNGSTgz?=
 =?utf-8?B?YUdQcUJCbzJabXNMdERXcmh4Sm9ERU4rOWdrT0YvTlprV1V0dmdYaDl2K3Nu?=
 =?utf-8?B?VVVqZkdKYXoxTHgremY4RkFaa3psRVorak5EZmNHcWJkVC9sdEJxYWFLekJv?=
 =?utf-8?B?aWRmN09FTjMzSC92b21PYUh0b3NRZzJuMk5jQzZlV1JaWmVhVnFmcFNLdGkz?=
 =?utf-8?B?aFMyMHhxSExZeXM4U0JpaXlramQvTUt0YWdpSSsvUlg4QzJPaWNHeWlVQUxS?=
 =?utf-8?B?YWNhVXVORjRxd2x1MVBFdXJkUjNVQnpwY2p0RG12QmM1clRRRnJ1YitEWTZ6?=
 =?utf-8?B?VDdkd21FdUh3NmdJNTc0WVJtWFNTVENPa3N3amtpbzVmY1haMkpBK2k2UU1i?=
 =?utf-8?B?OXlTS1l0Y1MraUJWOHBrNk9SVnEyd1QwZUJEZy9TOExYcCtacWFvRzZZaG1s?=
 =?utf-8?B?eXBITUYvRkd5UWJUTXUyVnFwSXFydHFocFV3b3RQNEgzRUlnVGlxaUYrRUxY?=
 =?utf-8?B?SzY3TjdIMGV2aHl6ck9wNHhmNXlZYVVBazE3bi9DMFN0dVhaSUNSUHYvbW1J?=
 =?utf-8?B?V3VPdzFGN1hpTkUrNmtmOGdxUm5sTXNmRHlZb1RRSnpxK3NVMktFcDhJK2Ix?=
 =?utf-8?B?bGEvaytuUG9LU1FXMEF0VW5pd3owbDZOMFE1R1E3OXU0NGc4R2VmUGlhYnpL?=
 =?utf-8?B?R2wwbGVJeDFHejBkTFdHWGloTC9mcXltTEg0ZU9zcHlZWXRYWnMwZ3ZxZHV2?=
 =?utf-8?B?TFAzQ3p5cVNnR1ZCb3AvRXZYa2RIL0xmNTZjQUVJOGk5bXpuL25uUlFCemtq?=
 =?utf-8?B?NjNrV09TK2JDa0dUdGtGWHRlNzl4VytJTE5hcTI1Q1drSUU1aDlmV2h5S3U4?=
 =?utf-8?B?aFJDb2Y0Zmd6YitHbzFvRjZiMFZNR3RrMWxOVmhPakFvbWhVWlVKR0ZzdFNk?=
 =?utf-8?B?MDRkRFEwOVlMVWhjOEU1US9uc2NHMUtJYWJHTjIwQ0dETHBmZDBWWU5ncktv?=
 =?utf-8?B?bGtWeXQvTGhLb0FMMFlVS1BvV1Fyb1ovUFRmUWY2TzBiYTJqOTdFY0Qwd1VC?=
 =?utf-8?B?aTRBeWtOSVNJKzkxbzNmMFVwVnJjYklBazNUL1RaTy9YVmRCZmdhcmtZRmJH?=
 =?utf-8?B?NVlYa082b3M1RGNQK3JURXZueW0xUE9zSXJkL0M1cXNpYy9oTHdKK0lZZVBK?=
 =?utf-8?B?cUd3Y0lkeVJJSVVkNks3c1hkYldBbXFhSnRxRnhpaVFhL1hsakhFMHVFcVAr?=
 =?utf-8?B?c2ZjUnJHQ2RLZ3hoVk5oYnlxcTBlY1JLaTV0akxhSVV6ODFRanhiVWVZaXFY?=
 =?utf-8?B?MTJLUHRSQ3JSU3B4MEx4dllwaGNRWlJybEJNeUJqQ2dTejNEeGVsTW8zZUZG?=
 =?utf-8?B?UitYTEZXTXY5L2Q0T3RuclJiMGQ5NzBCTHNtcmp2elJ6RjlhYUpDUVgwV1hT?=
 =?utf-8?B?SDRhVUoySUtNVTRZK1BKeXI0NG1OSDNBWU4xYzI3UE9zSHdWWWZKL3dnNkdS?=
 =?utf-8?B?R2xwS1c0d0wwUUE5eDRxLzg4bWNwR1h5VGRuVmdOYVljT245V0ZaRnF6SGFF?=
 =?utf-8?B?N2FIQUM0RjJUYytaY0xVYzgzL2YrWkJKaGZRTS9FWFYrZm1RUFFQMytJSkVL?=
 =?utf-8?B?TlZ5OEJKcEJaQ015QWNTbENVditwN084dmlxNDVFUm1KLzAzS1VQaVlnS1pj?=
 =?utf-8?B?TjYxZ3ZYWUp4ajlneWNBcEFYK1R0M05zRHV0TVdBSmR6V1VEcVpWWE40MjNB?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC2BE2AC26E7EF4C8A9B0FF2C333AD59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12edeb21-c589-40c0-0543-08dd1306e9af
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2024 19:24:16.7646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0V/hg1fyj1vFL/pcYwX+AoYkBBoxkZEe/l6eRbLb38J7YyZ23u2ZfZHjr5kQWfv+5Ob0t5+MCVuFp5ZwCzPkavlli9xMkFE0MPqoLQWVkuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEyLTAyIGF0IDExOjA3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IGd1ZXN0X2Nhbl91c2UoKSBpcyBwZXItdmNwdSB3aGVyZWFzIHdlIGFyZSBjdXJy
ZW50bHkgdXNpbmcgdGhlDQo+ID4gQ1BVSUQgZnJvbSBURF9QQVJBTVMgKGFzIHBlciBzcGVjKSBi
ZWZvcmUgdGhlcmUgYXJlIGFueSBWQ1BVJ3MuDQo+ID4gSXQgaXMgYSBiaXQgb2YgYSBkaXNjb25u
ZWN0IHNvIGxldCdzIGtlZXAgdHN4X3N1cHBvcnRlZCBmb3Igbm93Lg0KPiANCj4gTm8sIGFzIHdh
cyBhZ3JlZWQgdXBvblsqXSwgS1ZNIG5lZWRzIHRvIGVuc3VyZSBjb25zaXN0ZW5jeSBiZXR3ZWVu
IHdoYXQgS1ZNDQo+IHNlZXMNCj4gYXMgZ3Vlc3QgQ1BVSUQgYW5kIHdoYXQgaXMgYWN0dWFsbHkg
ZW5hYmxlZC9leHBvc2VkIHRvIHRoZSBndWVzdC7CoCBJZiB0aGVyZQ0KPiBhcmUNCj4gbm8gdkNQ
VXMsIHRoZW4gdGhlcmUncyB6ZXJvIHJlYXNvbiB0byBzbmFwc2hvdCB0aGUgdmFsdWUgaW4ga3Zt
X3RkeC7CoCBBbmQgaWYNCj4gdGhlcmUNCj4gYXJlIHZDUFVzLCB0aGVuIHRoZWlyIENQVUlEIGlu
Zm8gbmVlZHMgdG8gYmUgY29uc2lzdGVudCB3aXRoIHJlc3BlY3QgdG8NCj4gVERQQVJBTVMuDQoN
ClNtYWxsIHBvaW50IC0gdGhlIGxhc3QgY29udmVyc2F0aW9uWzBdIHdlIGhhZCBvbiB0aGlzIHdh
cyB0byBsZXQgKnVzZXJzcGFjZSoNCmVuc3VyZSBjb25zaXN0ZW5jeSBiZXR3ZWVuIEtWTSdzIENQ
VUlEIChpLmUuIEtWTV9TRVRfQ1BVSUQyKSBhbmQgdGhlIFREWA0KTW9kdWxlJ3Mgdmlldy4gU28g
dGhlIGNvbmZpZ3VyYXRpb24gZ29lczoNCjEuIFVzZXJzcGFjZSBjb25maWd1cmVzIHBlci1WTSBD
UFUgZmVhdHVyZXMNCjIuIFVzZXJzcGFjZSBnZXRzIFREWCBNb2R1bGUncyBmaW5hbCBwZXItdkNQ
VSB2ZXJzaW9uIG9mIENQVUlEIGNvbmZpZ3VyYXRpb24gdmlhDQpLVk0gQVBJDQozLiBVc2Vyc3Bh
Y2UgY2FsbHMgS1ZNX1NFVF9DUFVJRDIgd2l0aCB0aGUgbWVyZ2Ugb2YgVERYIE1vZHVsZSdzIHZl
cnNpb24sIGFuZA0KdXNlcnNwYWNlJ3MgZGVzaXJlZCB2YWx1ZXMgZm9yIEtWTSAib3duZWQiIENQ
VUlEIGxlYWRzIChwdiBmZWF0dXJlcywgZXRjKQ0KDQpCdXQgS1ZNJ3Mga25vd2xlZGdlIG9mIENQ
VUlEIGJpdHMgc3RpbGwgcmVtYWlucyBwZXItdmNwdSBmb3IgVERYIGluIGFueSBjYXNlLg0KDQo+
IA0KPiDCoC0gRG9uJ3QgaGFyZGNvZGUgZml4ZWQvcmVxdWlyZWQgQ1BVSUQgdmFsdWVzIGluIEtW
TSwgdXNlIGF2YWlsYWJsZSBtZXRhZGF0YQ0KPiDCoMKgIGZyb20gVERYIE1vZHVsZSB0byByZWpl
Y3QgImJhZCIgZ3Vlc3QgQ1BVSUQgKG9yIGxldCB0aGUgVERYIG1vZHVsZQ0KPiByZWplY3Q/KS4N
Cj4gwqDCoCBJLmUuIGRvbid0IGxldCBhIGd1ZXN0IHNpbGVudGx5IHJ1biB3aXRoIGEgQ1BVSUQg
dGhhdCBkaXZlcmdlcyBmcm9tIHdoYXQNCj4gwqDCoCB1c2Vyc3BhY2UgcHJvdmlkZWQuDQoNClRo
ZSBsYXRlc3QgUUVNVSBwYXRjaGVzIGhhdmUgdGhpcyBmaXhlZCBiaXQgZGF0YSBoYXJkY29kZWQg
aW4gUUVNVS4gVGhlbiB0aGUNCmxvbmcgdGVybSBzb2x1dGlvbiBpcyB0byBtYWtlIHRoZSBURFgg
bW9kdWxlIHJldHVybiB0aGlzIGRhdGEuIFhpYW95YW8gd2lsbCBwb3N0DQphIHByb3Bvc2FsIG9u
IGhvdyB0aGUgVERYIG1vZHVsZSBzaG91bGQgZXhwb3NlIHRoaXMgc29vbi4NCg0KPiANCj4gWypd
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI0MDQwNTE2NTg0NC4xMDE4ODcyLTEtc2Vh
bmpjQGdvb2dsZS5jb20NCg0KDQpbMF1odHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vQ0FCZ09i
ZmFvYko9RzE4Sk85Sng2LUsybWhaMnNhVnlMWS10SE9nYWIxY0p1cE9lLTBRQG1haWwuZ21haWwu
Y29tLw0KDQo=

