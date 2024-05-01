Return-Path: <kvm+bounces-16385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A34C8B9249
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD11C1F21D49
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCE7168B0A;
	Wed,  1 May 2024 23:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1diy1Lt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F194165FD0;
	Wed,  1 May 2024 23:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714605902; cv=fail; b=RRzchp5DMDmDb48UtOYZ4SeGhx+HUUtbbonsCIkegw8UgWQlqdY5L3DRRU/zwDqMuUMg6JT9HVvveuhrlK2U64m/9Hv8nFblJUjaHShwqzvzqB4BN6rxH24p9C6txYQHHcOby/TEOHpC3/+sz8RROuiHagClECGFgb7bAdMqA2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714605902; c=relaxed/simple;
	bh=JpIRitR+CfUcfJWssCrzRAYsgnkn5TMST0AVV9SIQzs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i58b1ero3eYUJ1EJi5jf43/R7oD8N4R+8sdNoMdKjqK/XobJ/5fmaWP21Ag3ngZpYh+yuB09if1/XNfGVAsakmMqn5mEFAzS927Jx0L0rr8yMx93DNFDOIWbw23A1JWvhtUWI6N87Gr8htKB9pRZ2MuGeH6/ETY/WrjMB8CCOww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1diy1Lt; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714605902; x=1746141902;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JpIRitR+CfUcfJWssCrzRAYsgnkn5TMST0AVV9SIQzs=;
  b=L1diy1Lt2fgtOeqN1SbUw13hsROHJJeguHMX9glE5Tzu6lMeURqBp6Yf
   Hj4F3Xj53L/XPE6lurMgBC9UCh3uikf5FrG/02scDsS4GCbMMCsol2gYd
   Ikj7avdSSo2SImr/gV+naxPU3MjUBjbI3oCCgmBWWNZab5wIvxgG5Nr74
   BtCpfMX6O6N6DqTWSstTZaqrdyOM/Z2T7VAWkoxUcgxyUhiiBoV69vgRL
   eAJ7TMjftePpWpGgnEtvz499FZZeG3lpYsDftIkk2fy/38k5LElc0zS4k
   L/ouf9JZwf99hqhkJEmghE+xCVmgIhqUqy9aKx5X9wlHXUVr4tI1/lfak
   Q==;
X-CSE-ConnectionGUID: ZRegMcNLRxeYwCxc1fUf8Q==
X-CSE-MsgGUID: 94ZmBUL6QSaSD4dCNujC+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="32875510"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="32875510"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 16:25:01 -0700
X-CSE-ConnectionGUID: SSwIcYWcTk6B+xmgtVfLGg==
X-CSE-MsgGUID: hrgZ23ufTESTkom0K4TjFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="27014191"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 May 2024 16:25:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 16:25:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 16:24:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 1 May 2024 16:24:59 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 1 May 2024 16:24:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaUsGkzj9NMKLZFrH5eFz2oBAt2xRUbO3LEmYdqoOEQ9n3hu1pnr8HBxQGsUP+/QtNCknRUe32w0TyjebIDfTJL7yg2j/iafwvRsAS8lR+xAOUAti6S4+0FZNmQtmWDGhVisnrq7lwIC45QUZcGk6zPLWe950w+4RqXh0IQj4Kw2qKRRgxm/T4j9ikKVHKDCCNPWzrHHDXocn/jX5iD7/0H+qVN5iFcNV3aky+PgQlkJUllDyIX2NLN3nYqV3h05VG3R4Va4emvKa+Oru3EMNj74Uih0IfIWJV5VexoqfLcaGQr3hfSNnn+EaKaUWDJyUH7mRuMfKwEi8QX+hx+D4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpIRitR+CfUcfJWssCrzRAYsgnkn5TMST0AVV9SIQzs=;
 b=l4CwlTisJiQtlemejFGHV/J1VkmYyqxGrSAk9BH1PilIkZX25JMN4XqjCMuFAvQ2fzVGj06Z3Sb2DE7Tu5Iw+LVsZI8QUbtiXpjaToxF/Pl35/Yj09VchWX1x4ceD43B7p2x9Lz+ErewdavCZ+3qD42uLb5nuXNYEny3L0JpGnS1gIrg/7rWe7JpgivQZGkMQTfyNcoY/0hSsYYRy5gadUAkom3WKCAmvKVrBVN9VyNujUzD4azBRpbaQh+4LVUavtXfNQlzlSUhST4FyIq/Wgg8TdSYHgrsq5Y8E2CveUsxJJVjxo9iWaNHDYOmFXoDPZqONDMoeaLZmPd893vKoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7061.namprd11.prod.outlook.com (2603:10b6:806:2ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 23:24:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Wed, 1 May 2024
 23:24:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Thread-Topic: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Thread-Index: AQHaYwfynhk8CrwGC0ayixDi2U+bW7GDdNgAgAACpQA=
Date: Wed, 1 May 2024 23:24:57 +0000
Message-ID: <d86b65c0686e6477cebb9be4d8765d4349b1f48b.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <20240219074733.122080-25-weijiang.yang@intel.com>
	 <ZjLNEPwXwPFJ5HJ3@google.com>
In-Reply-To: <ZjLNEPwXwPFJ5HJ3@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7061:EE_
x-ms-office365-filtering-correlation-id: 6106c6fc-e199-4e65-c999-08dc6a35ea5f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eDgybTE0V2JHaXVlb1BUS2ZBb0ZtSllwYlBud3NkMEFJYkRFMTBmWkE4RVAr?=
 =?utf-8?B?TUVsNmxDdHQxTnlhTElkK0g1TndQWHZIb3RWbWpGaGI4QmxtdGRvejZ6UjdN?=
 =?utf-8?B?czl2UHh4Z2pUdnAzT3BKODNicEpDcU9hU3lVQ0tPRllNQ09VT2NXbXRFMlBP?=
 =?utf-8?B?cHVYUFVNWWlpb0dhS1ZIOVdmQXRFSVJOaDB4MUk1TmRCTlc5MWlhYXdUby9k?=
 =?utf-8?B?aEJwSDNxNFp4ZWUrcXFncVZyS25hTzI1RmdWS05tRUpTRStsdUNuWVh4dE4y?=
 =?utf-8?B?MHdWbXBUb2hyaFJFTXdXWEZkZU9QU1pLVnUwVnhqd3BncFRiWHB3QnMrMlZz?=
 =?utf-8?B?Vkk1WG0wbjYyaEJmSnVTN2EzN2c0ckJBN21XVlBOTmR0djQwRnFmUHBVbXk2?=
 =?utf-8?B?WnVvb2xsVGc0RzJRLzBsSXdjSkVGSVloUmVTeTFsbW1nZmZOcCtaUm9pcnVt?=
 =?utf-8?B?ZlZFT2U0UUZ6bDBzZ3cyaklGSGN4dkFSeE80SStzVmdqbDZVQlMyL09NQzlj?=
 =?utf-8?B?UU9Tc2FadGxxN083U3BYUDVzYWtKY1RhMGJSOERSTnRiQkRmRDI4RUs3TVZj?=
 =?utf-8?B?cEg5U0dRc3NtR1IvU3RrN2IzbElkQUdldzhCckVYTllDT2ZTdFJJVnRkLzZF?=
 =?utf-8?B?c29KWnhXVG03amFQQm13dUdBeTVsU0VDZG52WjJyMlpZNm4rZGEzcExxUkIw?=
 =?utf-8?B?WkJybkxXem1TRlI2VjdqMG0wZmE5b3NqbU1VRGxZcldzR0hiRFVjN3BIQXhr?=
 =?utf-8?B?RWxscW4vTjduLzdNNUY3b29adVR0RlBJOHE0NU1GSUdqeUx2dlNyTWh0dHdJ?=
 =?utf-8?B?ZmJuM3NJaTNHaHRZU0ErV3BWUHJ3ODQydWllS1JIRVJNL3VvMXVxOHZCM0E3?=
 =?utf-8?B?N0hrc0U3cTZQWHZ1Y3o3eS9jNFBIR1VjNUg0QTdWWlJWdlRRSUl5M3gxMm9w?=
 =?utf-8?B?dGpvaSs4b2gxeHZGSlJBcUxzV2ZlbHFoeUhJYXVadlNMMnRrYUgxZ0xqa2lS?=
 =?utf-8?B?L0E1NUhVSEFxSEZXN1p0VXIxWW43bGZ6cGs0YmltTkRja1B6TXFXeUlSSmFw?=
 =?utf-8?B?Y2xER0U0alV2NE9NSHhHRFl2M0lMNFBaMjJVc1FGK0xPdTlQMUt3Q3k3VE5q?=
 =?utf-8?B?MHZnZnNMb0ZPaXFLb2lzRzZvQnFEblZEbFFLUjBnTjVmZDkyeWE4Qm4vcmZR?=
 =?utf-8?B?SWd4bW5ldFN6TVl3MnJueDJFREpkd2RKYTVGc053cldyK0VOWDExTTVHd3RE?=
 =?utf-8?B?N09wTkFqQ2tFK0RpcVFpNEMrb2ZXWlFJZ2VIU2VPNjJsM2NjQTBmRHk3TUJt?=
 =?utf-8?B?aVBWbTJLOVhaR2hqS01PZ0VLSFhaZ0hHOXkwL0JpblBtMHhpcWZXNGJvc0xY?=
 =?utf-8?B?eFB5bDVzV0x3T3BrNSs0b1VmT2xDRnBkTGRJSkpnS1o3eEFKdlBoR0QrZmhO?=
 =?utf-8?B?TFptRURaTVVVaTk2V2hWeDFPUGJ1RHRJRDREbUxiTm55cHhsc3RkZC9CeXph?=
 =?utf-8?B?REFQa1FEci9veXMvQ2h0N0dEQU5uWDkyTFYreDhMYnQzdWpVS0s5Nkk0NlFB?=
 =?utf-8?B?N25RdkJCWEZBMUxZZnZDMjRCemk4SGx4RTc3b3I2L0I1YlFqcHJGcE1VYmxT?=
 =?utf-8?B?K3Qzc2huelZ5d0F6ZVFENFVtK1IxSEhJVmZVMHRsSDlCZ3JiRHFsU3hCcnlW?=
 =?utf-8?B?ck5JL3pFTUl1U1hMd3owRkJ4M2EyWWlTVHBDbzRBd0NadWV3Z1FCTkFOdSt1?=
 =?utf-8?B?TjU0WXptdnRDR3FGM0dDUGZ6TGFqck9LUmh0KzVBaVN3VFlMeEc3dmY4clIr?=
 =?utf-8?B?KzNtQys1S2txUDR1N3ZXZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnV3UThoME5NeHMrNnU2b1VUSWNKcElHTHYzdm1wQ2sxWng5WEIzcGF0R1Zv?=
 =?utf-8?B?a09KdEg1ajd6cUVUUG1wQ1Q3eEZnZnhjb2ZCcFZIOWlwNnRDOUZVa2VRMlpK?=
 =?utf-8?B?QnJrM3hBczByMkNhTmZXZDVySmsyMStUZmJ4bUpSWVNXRFo2U0JMUjlqcmVp?=
 =?utf-8?B?ek91Z1FicjFZZXpPWFNnZ1YxekgvYXF6ekNiTXVYa083cFRKUnVMSk5rK0tu?=
 =?utf-8?B?SHdudlBGZjBwWTJ6ZVRvZnVBOG9wRC9aWFNvNGZwSlFIckVNZ2NCR2ZJMUtW?=
 =?utf-8?B?KzlCUUpwZlVJSy9hVTEvK3pmcHNsWmtkSUU3L1dpbzlUeUVUM0J4bk8wZTFF?=
 =?utf-8?B?cVdyN09IR2xIUHd1R3hSeHJ1MzRzeElJaVBQRmV2M3JhaU5YVi92cE1ja3FB?=
 =?utf-8?B?MGVVUnIxSTh0QWxIelEzaGRQUkQ5VWlselQ2RUNqSmNVR2hRd0dxenl5SVhM?=
 =?utf-8?B?SFRGSnRsOXdTTGE0UG5RdHJkK0oyYmRHblNhVkVqM0FtbXUzMHZhMmtkczcw?=
 =?utf-8?B?dlMwSWpuSWg5MnFCWVh5S3pUOGR3SUxKaEdYdEROWHdGWDZ5aTdZQVFJbkZR?=
 =?utf-8?B?VXlva3l2aVBCc3N0SFBrcERBcTkzQVIrWGJFaWd4bmZLOEluYkxjdG91cVdn?=
 =?utf-8?B?dDR0SlZIRktwN3dnR3BtNnNBUnFMaGI3b3BmZWJnTUM4NkFwZ0s1ZjNEMjN6?=
 =?utf-8?B?K3ZveWF5QWV6cFAzTE14KzF5UVQ3bS9MM1BTVE9yUGpHU29IZ2tIa2p3ZDZl?=
 =?utf-8?B?ZGV3MzRhSXpzelNveEUrQ0pQUzhPTFNRQVh5WmN0OEZsbjdnNkcyNXMwOG1U?=
 =?utf-8?B?clM2aWdiODV5c2Y3L0lDVy92VVo1QmtORWJRU2ZneTBVYWlZRGErK1dvQ2ZM?=
 =?utf-8?B?MW0za0I3VnhMU25TNGNHOXlZbHE1U0pZeUtWZjg4bHdVN1RoNkxxWkRRRkh0?=
 =?utf-8?B?R3lTM0JOblI0STJrZ3R5SUNuWGJlck9mSHVJdEhlYXVLU0FobWFCZFhTcmIw?=
 =?utf-8?B?OGRVSTBTeEw4bktjMEJWYTVjNkxudHo1eTVYbXdZVWdWV3kyWW1xSHBWMTNN?=
 =?utf-8?B?T3d3NWNLb1FGZnp3VEwwdm82ZFI3SWs2Zm5BQVQ3YnFXYzFZWWlJTVFFcDRP?=
 =?utf-8?B?QU5IMXNPc1JldXVnTnpVQUFTNlEwSlFtdmE2Q21sK21oOHl0TDVjUm9tL29C?=
 =?utf-8?B?ZHZyd004ODdWbkNmdGkvOHBHbzdPMitIcVhxS0M1YUdHUzJ6b0tzS0g1amdx?=
 =?utf-8?B?K1BWYXp1Z3hmMEpTdFVjcGlsa21qN3NKVCtPdjRSdnNDWFM0R20vdFNwNmxF?=
 =?utf-8?B?RzN5ZjBzZkcwYk14Q0VSelFxL2YyTjRHaDVrS2ZFSnQ5eDVPWW91UjFxU3lC?=
 =?utf-8?B?UTVybEo1bUFFd1VlbVhrK2IyaVQvRm9TaTh4ZXhrSElVN3d5Um9HRVFYaDVn?=
 =?utf-8?B?MUU3R21Mekl2ZkN1YTBESmorZWRSczlOVmJmd2pFYWJSeVVEMzZNZUhwUUNx?=
 =?utf-8?B?ZDVxcm15VitVdjNCeDlGZjFZb0E4MmhieCtWN2xQWXFabDhKNHpuWVA2ekxW?=
 =?utf-8?B?YWpjd2dmaVMvclEwRFFDelFyK3dhRVV0REZSRUc4V3FrNWM5NU9RUjg3SC9F?=
 =?utf-8?B?VlFiT0hmMGJGYTlFTnNBd3lkRjZ3OWtKL0NpQmpobjV4USt1K3VaRDFkQlpL?=
 =?utf-8?B?M3RwUDdOWllUNkpMQ2UwMFVCRU40MmtlV0dkeHd6UDRVVmUvYms3dm5EMkNP?=
 =?utf-8?B?U2VuMytlUFZDdll6dC8vTnNQcnh2cUZESHdPak45YjhYVDZManBFNDBoVTMv?=
 =?utf-8?B?ZVgvWFZaSHFKOFdwQVJvOTlEeUQ5azVGOUhRQklybC91MHZWWWFad3V5TnY1?=
 =?utf-8?B?VFh1SlIrZ21tWE5ETEFyaXpyWlFkMkpWcjBKTGVFTHJudEd2Q3g5Sm1YZy9y?=
 =?utf-8?B?ekt1dHVRdWNEVm54VU91VTdGT2swdXhLK1JueG8zM3ZwQnplWXZteDB3V3NC?=
 =?utf-8?B?Wmh5ZDhUTWhSb1BMK3o3bXhvRUhDRE9JWUJnQnJpRGZSZmY0azJma24xWFE2?=
 =?utf-8?B?WkJNWGFoZ0lnbGhCc0M2bU5Jb21hVWpDVWIxTFQxWm11YmdmUGwzUkd1bDdB?=
 =?utf-8?B?dDZMbXpqQmYyTEhUTmFlUDV4bDEwanNSb3F5Vko1ak82YzlGOXJkTDQ3Z1Bv?=
 =?utf-8?Q?OG3EbBxFqNk1u4n3271v/l0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9116EAE7D4399243B1D5D7C5F374ABF7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6106c6fc-e199-4e65-c999-08dc6a35ea5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2024 23:24:57.7223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sPQAgIeWq1CKcnJmOBOwv4yDZ3HHhATvohvwdAtkaksamUsIDCZe/h+ES3e9Oajb3eUQgCemq8KfZNCyLZbbtjCSujKMdR/7AIbDZoljh/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7061
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTAxIGF0IDE2OjE1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBTdW4sIEZlYiAxOCwgMjAyNCwgWWFuZyBXZWlqaWFuZyB3cm90ZToNCj4gPiBA
QCAtNjk2LDYgKzY5NywyMCBAQCB2b2lkIGt2bV9zZXRfY3B1X2NhcHModm9pZCkNCj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9jcHVfY2FwX3NldChYODZfRkVBVFVSRV9J
TlRFTF9TVElCUCk7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChib290X2NwdV9oYXMoWDg2X0ZF
QVRVUkVfQU1EX1NTQkQpKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga3Zt
X2NwdV9jYXBfc2V0KFg4Nl9GRUFUVVJFX1NQRUNfQ1RSTF9TU0JEKTsNCj4gPiArwqDCoMKgwqDC
oMKgwqAvKg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIERvbid0IHVzZSBib290X2NwdV9oYXMoKSB0
byBjaGVjayBhdmFpbGFiaWxpdHkgb2YgSUJUIGJlY2F1c2UgdGhlDQo+ID4gK8KgwqDCoMKgwqDC
oMKgICogZmVhdHVyZSBiaXQgaXMgY2xlYXJlZCBpbiBib290X2NwdV9kYXRhIHdoZW4gaWJ0PW9m
ZiBpcyBhcHBsaWVkDQo+ID4gK8KgwqDCoMKgwqDCoMKgICogaW4gaG9zdCBjbWRsaW5lLg0KPiAN
Cj4gSSdtIG5vdCBjb252aW5jZWQgdGhpcyBpcyBhIGdvb2QgcmVhc29uIHRvIGRpdmVyZ2UgZnJv
bSB0aGUgaG9zdCBrZXJuZWwuwqAgRS5nLg0KPiBQQ0lEIGFuZCBtYW55IG90aGVyIGZlYXR1cmVz
IGhvbm9yIHRoZSBob3N0IHNldHVwLCBJIGRvbid0IHNlZSB3aGF0IG1ha2VzIElCVA0KPiBzcGVj
aWFsLg0KPiANCj4gTEE1NyBpcyBzcGVjaWFsIGJlY2F1c2UgaXQncyBlbnRpcmVseSByZWFzb25h
YmxlLCBsaWtlbHkgZXZlbiwgZm9yIGEgaG9zdCB0bw0KPiBvbmx5IHdhbnQgdG8gdXNlIDQ4LWJp
dCB2aXJ0dWFsIGFkZHJlc3NlcywgYnV0IHN0aWxsIHdhbnQgdG8gbGV0IHRoZSBndWVzdA0KPiBl
bmFibGUNCj4gTEE1Ny4NCg0KRGVmaW5pdGVseS4gSSBzd2VhciB3ZSAoV2VpamlhbmcgYW5kIEkp
IGhhZCBhIGJhY2sgYW5kIGZvcnRoIGF0IHNvbWUgcG9pbnQgd2hlcmUNCndlIGFncmVlZCB0byBt
YXRjaCB0aGUgaG9zdCBzdXBwb3J0LiBQbHVzIEkgdGhpbmsgdGhlIENFVCBGUFUgc3R1ZmYgdHJp
Z2dlcnMgb2ZmDQpvZiBob3N0IHN1cHBvcnQgZm9yIENFVC4gU28gaWYgdGhlIGhvc3QgZG9lc24n
dCBoYXZlIFg4Nl9GRUFUVVJFX1NIU1RLIG9yDQpYODZfRkVBVFVSRV9JQlQgdGhlbi4uLiBob3Bl
ZnVsbHkgaXQncyBjYXVnaHQgbGF0ZXIuIEJ1dCB0aGVuIGRvbid0IHJlcG9ydCBpdCdzDQpzdXBw
b3J0ZWQuDQo=

