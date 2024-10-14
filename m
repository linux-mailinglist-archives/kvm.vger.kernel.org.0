Return-Path: <kvm+bounces-28760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7E599C9B5
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:09:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500331C224A4
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 12:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686DE19F42F;
	Mon, 14 Oct 2024 12:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NzBPeKHY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408AB158A19;
	Mon, 14 Oct 2024 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728907779; cv=fail; b=FZigJ22ucgVKxApcruxArpF4CqlIAQ31D2X0n3zHe3EBzo8D77fb8HxLoVWRXsHS57Bpgu3AaUyfJhgpxDNG95iB0ccJWI39FpNJRG0oviHnlt/xIXlcfk7vJq1bvhaR/FVv/ow0fvFPJZdsJ25kB8YizOhZid217bX9Vx84DlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728907779; c=relaxed/simple;
	bh=I6lCZS+V8exAUG10yDBIgA5L1tixYP6oorV6H6dHaHk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AKBqDyvLT1X17h19TRqlG691csDBR+Ks4V5Y3xEBppNtGxW3c+H7XbAWel3eX7BAWvL1uMFf6Yep89IECis5IbPgYao32qqLtL6HiHDJ1Knv5mud8YIYxD8r1kh6C7lFWADXC4zww2Hm6SlnW2HC2KlqKLHW1fDzZEZepkJni58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NzBPeKHY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728907777; x=1760443777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I6lCZS+V8exAUG10yDBIgA5L1tixYP6oorV6H6dHaHk=;
  b=NzBPeKHYH2QRJPDeN1PHxxXIZOVhLTMTx/Jv+uLrLhnGfuxJIFLVN3m0
   JXZP98gyL+TAYgPTV9/GXAkKGMncs4iWrf/xfFoKndp/3mB1rOG9Nhg+f
   fkzo7C9OuZmp0Ht+lztTHUy/y7+PKYgqwsqbydU0ZGe5QENfoknBtMbBY
   rHG2RVgd19+epz0f9Jv10oFylbP6sEs+Mte5xdfVteP4WUIQnxzCosuu9
   zIPRJcoa+JWeoDKtfGz+FGbrlcFGllIyw4H2JenkGD06nJkbV37uT8iWl
   gUCSbl125wtpQ6R1b0/mFrICJiZdw9SXHAX+bFz/+95P/BJRJ0NbdIKEn
   w==;
X-CSE-ConnectionGUID: 6Dk1vez4ScKapd5bo35TBw==
X-CSE-MsgGUID: VWaADu7yQLScDA7eVn1RMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39373958"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39373958"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 05:09:31 -0700
X-CSE-ConnectionGUID: W4iyD6aZQruPZpAlyzKBAw==
X-CSE-MsgGUID: zBO691u9QgOGfgEmwOYZwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="82334659"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 05:09:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 05:09:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 05:09:30 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 05:09:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJneyqEusyBXyKkxNywOl9ZZ8tmaoznJwKY1iVIWYK0eebBuYXFVsEAO/KnCIBqh8B0Dr8SbscPaZ5Z+Fa4Y30cBlOdtec05/qZt16PrZw/1t2b9Ou+Y4ywNeW/6TdvMXdEDAxVx2L6SMQdFFl97eewd8uQ0DDoYk4q6jRqGE/0odZDsuzidud5S/6XzwSmhRdi/UKJefizE+rpEYzvhUx8AtvDaPUoM1f1D8PyVDLF/TgFyw1+pgDYdUc0jt5hxPEwNpCOWqC7I4MigKntJGfo2hyrm+d4W89xM+xecVdLKB6VN4gIfYUCE4g8REkEdRhZcR8SWk8WTiqTHUOrCQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6lCZS+V8exAUG10yDBIgA5L1tixYP6oorV6H6dHaHk=;
 b=F2s0gmtQ7+qPFBYTKCFThMqch5FVYrSnZ5lEAFK7lLUZPbxJtXAjG2TrAnsHToGJ5M9ktD3fflSoPym2j7ZrTBG1wn7rxRKEer9Hq72ZDlSN0JcfSnNO2LyM5Y9EU037ufaW4+bbNAJUnJobIXyYZRqVsdWDFiZEK+JeuOmVPsx1iO+HTG9F0ytitK1vfrb6qjQzwt1XRhpCnvnRH7ZK5GQEfNlTdSIIZiBIFfLGqgxaYZi3dDcgA96RgoJVDKqf8PP69qQdHCuqDxT8mACdcK1KDlE0DwRUjQ4k1YvMCupSNNqQ43Rcwskb3ps8FXGbJv0xB81nixs+HURFKca11g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4604.namprd11.prod.outlook.com (2603:10b6:303:2f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 12:09:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 12:09:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: x86: Move kvm_set_apic_base() implementation to
 lapic.c (from x86.c)
Thread-Topic: [PATCH 5/7] KVM: x86: Move kvm_set_apic_base() implementation to
 lapic.c (from x86.c)
Thread-Index: AQHbGnggowufqA3uMkSgHmzUVPj+r7KGLuGA
Date: Mon, 14 Oct 2024 12:09:28 +0000
Message-ID: <d09669af3cc7758c740f9860f7f1f2ab5998eb3d.camel@intel.com>
References: <20241009181742.1128779-1-seanjc@google.com>
	 <20241009181742.1128779-6-seanjc@google.com>
In-Reply-To: <20241009181742.1128779-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4604:EE_
x-ms-office365-filtering-correlation-id: 1bc89412-980a-4d5a-0cd9-08dcec490d63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RkhNVHZuTVdnUWxrbCtiVUlzdk4vU3ZnOHFnbzdrOFNOOWR6MUNOVXQyOGVh?=
 =?utf-8?B?bVJzeVVYZlpQallUMFV5bG9KNmF4UGpGcXJjVHBuejRXL09wQW13Z09RQkta?=
 =?utf-8?B?czVmVnZhU25UZUR5c3JtWFljQkhZU0M2RWMrTzFZcWdJalVJb1BOSVQ3UjYr?=
 =?utf-8?B?aEVreXhKWjUvSG41WnhMaDhTekJ3aTBvWS9VVlY0OG52dG9CQnlLYUxtZnY1?=
 =?utf-8?B?VThsaGFsWHdjcytPYXFkQ0dRalV4TlI1dUZlTndieWpDUU5HVmVqblFjc09S?=
 =?utf-8?B?VDVRYW5odS8wV0pMai9DUEdXRzIzWTUzenRRMGh3Mlk0clhNbTNkZnpTb2t2?=
 =?utf-8?B?ZlBKTS96eEQ1ejhwWSsyNFE3dlA5MGxIb0VldnBtZ3E1QW9zR0UxNlNsdFll?=
 =?utf-8?B?N1d5Q2RPU1JLaStzRGFLZXBUOXNDVE51dUpLUUtCYlhVZkpPYjI2TCtvM1Ew?=
 =?utf-8?B?cjNLbjN0MDM2d0RDNmhRd3dnYWFTQ0hTTDRiWHoyV2ozQmZQTVdDWnYvWVBD?=
 =?utf-8?B?THdXREFkRjdGY2RJUkxSUUxvaUtlTTJEeDk2SWdIOGxZMUliV2YxRk5NQzFD?=
 =?utf-8?B?UXEvcElrRW5Cb3dBaDJqRkVmekVkMy9IaW1JamFNUGF3RXZiciswYVE4MHBm?=
 =?utf-8?B?c0I4WHBCcFZYaDlOd0dHWTlKMzNnSmZTNEVMVWFCaklGSUpKRXZWQXlYM0Nu?=
 =?utf-8?B?Wk5HOFQvbHMvWTFrbzVnTEpOVFNYcnVURGgvemJlWHNwZXlLVkRkaUZ0TDZX?=
 =?utf-8?B?Ky9mQ016Q0kwZ2NlQ2xGMCtzb0RyTFdHQy9NMFJ0c0JKeXRZRElPeUsyOFla?=
 =?utf-8?B?cTV0elFnVHg1VWRVWDJTNDB0TEtaeng4L0lWS2dsdURDOC9KTEhQb3hzMXk3?=
 =?utf-8?B?ME5aMnREN2JEaEFicFpsL3h1TVR0cUNCN3FBRmxWQjJBZmF1Qnc1WHkyK1Ru?=
 =?utf-8?B?TlRoNE50NzN2TEp0MDlRR3IxVjJuTjI4S28xNTh5cnJUL1ZBQ01MSHo5NGlZ?=
 =?utf-8?B?djY4RGZybDJZcitWRjNUT043UUZPbmRPRVdrblI1cXl3ZnMwSEd0cmdSOGhr?=
 =?utf-8?B?M3JnV1BEVXJlalA4eGhHRGpiY2g4UVRYUkN0eVVmRTNWZVBlNGpXSEFrQ0FV?=
 =?utf-8?B?VW9PZGMvR3pOaUtOUlg2QzYvNCtOdU1KN053WXY0MzNHVWRtSWZMWmJRSDZ6?=
 =?utf-8?B?R01GbENXR0x6TkFWL1o0Ni9XR2oxdmJSdTYwQ0M2M3VDQlRaU3dORy8wNm5s?=
 =?utf-8?B?MCtaVVNISDIxQStCdW40R2puV1dib2RSalVYWTNVMHNzTEFRMzQ0SStxQXF3?=
 =?utf-8?B?d3d4V2lHK1lSZlE0WVRoMWhIQmU0YzJFamdTSk9TUmE0OUZ2NjUyQUljcTh4?=
 =?utf-8?B?WW1Wb3Q5dTRhdm9LbEJrRnJ1amo5RUNqaGFwK25nOFFwOVl5QmVjNjRHODRM?=
 =?utf-8?B?dERla3ZJcmdXeHRaZ1VTVkRuTHJXUTlCdmRjN0xiVkRaSnhIeFR1d0lGdWVL?=
 =?utf-8?B?VnJjRGZrNk9tckUzYytIazVuZm1GNTJ5a3dKL0JTOVRXRTVObWpaQ1pxOC9I?=
 =?utf-8?B?ZTF0d2Q1UXhQYWx2ZzlBYUZxdTRZNytZajZmRUJlZW5wUVk4cElsRnpVdkhk?=
 =?utf-8?B?cTROL1M2eG9mWk5YMUVTZ293L2NJRWZyUi9kdTJncVpkd1MyemlXczVzWEpy?=
 =?utf-8?B?WHQrZDA3cXREWnN5c3U3dWNQTWJtRVpoc0RpbjQrMEJGYlZDL3hDblNyV1Ex?=
 =?utf-8?B?NHg3VE0ycDk1bmhuc1c5QkozZkRVV1k2QnBCb2xFZlE0aFYzSnVqdGdQd2hV?=
 =?utf-8?B?S1AyVGZ6OTVVbDdkZE1Kdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mzh4eWpWT0ZOVnhyRmRTb2R2dkhqcUZZRS8yL2IwM0t3ekp5ZkIrSTJEY3ZW?=
 =?utf-8?B?a04rVk9pNyszTjZHaEhWN0FoemZYWE9xbkVPbWhZL2p5c3E4c3dTcXdaUytt?=
 =?utf-8?B?WjN5YkxGSVRic2tpUldja3c0NDloUHlRMFowM0pqQ1kwSS9La2k2VjlCK21s?=
 =?utf-8?B?ZTIxQjEvcWpBbnJ6NlZ1Y3ZCMG1pZGpkQ1FBVXhlUnUvd1l6aC9Na285a2FE?=
 =?utf-8?B?T0VQM3E3eU5GTVdPN1B3czVZOVFMM1VERHhIeTNJQWxtaGhZcEpVZGwxRnlY?=
 =?utf-8?B?TmVCcDdLaGFZeDRGVXdGQSt0TkVlNk51ejZDeXFnMjFoMlk3K0dNY2dNNTBZ?=
 =?utf-8?B?ODhrdlYrVHl4clJObHlyVHdNVk5ObmQreG14YjJRenZuamlSNnFCWi9ab3Bm?=
 =?utf-8?B?dE9IN1RUQjZGM0IzWW9QZC9RYy9GTjFYZ3lISTZpWkVsNGFZdC96T0FEQ1dI?=
 =?utf-8?B?TlFBRTZkWDB6Ym9zSUkvZ3BhU2RGNXkrV1JEZ2orVDF0OGRYOG5xSWNHSUJ1?=
 =?utf-8?B?eXJDejBKaHRyRHVWaFdzSEVURXlwbnVqYm93RlZWMHFIN3hIZ0RSaWtYd2d5?=
 =?utf-8?B?dWNjSDVsbjFmdWh2TDFBcW5NbWtLM3E3SkM2WXArQ2MvNHkwZXBKQWdHN1Vn?=
 =?utf-8?B?K0RiZ0U2TjBReHg4bFc2WElXcWVXbkQ3NFlzYVpjTWZocEdBeEYxYzhpNGgz?=
 =?utf-8?B?TElYWGVlRFpVWm1Lai9SSE1jZ1prYkZuSG4rTHNWV3I0ZXpmMXlCSFBWd0lt?=
 =?utf-8?B?eHd4cEJhMWJQRitSRVR4bEQwb3hxaURYU0RTUFZoYnVsTUpzKzE4MXpJbndo?=
 =?utf-8?B?bG5OT0Z1UHZIZ2VGRnZ3cnZBUnFPQ29yN0w2OUJOdGNFWXVpOXpJOVNVbStH?=
 =?utf-8?B?a25zdVFvMVlINE5qZU9CVzkrTXhqbjhiSWo4QmJOUjB2ajdER2NTRU8rNVZl?=
 =?utf-8?B?V3lTSjR6VVlSQi9obDZ2YXhESUlRR3VJNlV2bmlGZ3RDZS9nMUZtaCs5TkRa?=
 =?utf-8?B?V1M3MWFDT1ZBaXF3OVhON3BpU2Q2ZDVsVWdOSUQydmF0YUxDTWo3WEhuRUNs?=
 =?utf-8?B?ZzBBU3c0cjU3TSsraTV1UDJ1N3FDOFBiSDFEQlFlL3FFeTFQY1JFdHF4T1RV?=
 =?utf-8?B?WXA1ZTVKTVRHUTFvdFZDanl0UnArU0dSU3hDUXFGdzBETS9WZ3J5WFZYaGZK?=
 =?utf-8?B?bU1TODZnWGVsNk1CVWFuOUJ6Y2Q1STVMNXJGZi9KYXFML3FzK0VxNDhtcW1o?=
 =?utf-8?B?M1hLa29zZjZDZ1hVQnUybFNBVDlWeFl0RlhaQ0NncmpoZmNGRlhlLzV6Mmwy?=
 =?utf-8?B?VXR6SEw0cyt0ZDdwelZwLzgrMHZmVVNWazNZejVHdHJlL3RQU0hiSjhWMGFq?=
 =?utf-8?B?N2IvZnEzdHJLaEFmQS8wZXAvTTBjMGFyS1dlSlAxcGEvTm9HSVFpR0VSczYr?=
 =?utf-8?B?VGhVS0pNcjVMd1doMjRWelhOZ0Vld0Y4VFZwM0krUnJqbHc2bVEydzBkSVdq?=
 =?utf-8?B?a0h6cFlpWXVHdTFTQXVGcEhVZ1BwTWZJWUI5a25xcTA5cExUdHJKZWNOUDhu?=
 =?utf-8?B?V1lVN09GTGpsUEFoZk80YkRFcVpmTFptZUlydlU0VVBnUXNkSGpaa3FkaVVv?=
 =?utf-8?B?VWdhMU9KbDFxMndxSGF4ci9ZYjRxYWtIdll5ZGkyL0dZWGUreFIrOHdIODhM?=
 =?utf-8?B?aUZkaENuM2xXYVRHaFFiS0I5WnRFUmZNK05YZHU3TFBSaEh4MllYMHB2ZVZZ?=
 =?utf-8?B?VU81RXB1TXp2UHBjSzg4eDJ3WXBFZHFEcW53cWh3R1JyUThBTkxaV2VsUEF0?=
 =?utf-8?B?VzkrM1NPeDViWkhKT2J1MTY2VkdLMCtJSU10YU1pSkNkMFpQQzg0bW5ncXQz?=
 =?utf-8?B?ekdpV0tuRGROOWkxbmRUT21tRXA1eDhuZmFuRE5WcU5Ra0tHVDdWeWlqRDls?=
 =?utf-8?B?MndlS3UrRk5ubWJFTytpZENVbW5vSGhGUGRQSi9EUUtqQWRtMFJxVTVoUjNr?=
 =?utf-8?B?M1lVbkovQjg4TkY4ZG84YURuMVJPeFR1blIyWWk2UjVJRmZlbFRlVGdPYXFi?=
 =?utf-8?B?MUlEUzIwZS9zV1owYXdEMlJPQW1XUTkycWFyelBEOXU2Zk1CclNzdUd2RzRJ?=
 =?utf-8?Q?ZL0lrARTn2go39G5D9FUR695l?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3B4C183D65A0E4E83B3CCD10907C5FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc89412-980a-4d5a-0cd9-08dcec490d63
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 12:09:28.0916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWLPphomkfCyp37Otk/lG41jQ/9VNkZIO5eoaH8LB6B0TknPpVrlHiHDYJhPewupYSD4OZr/y6fXWOuA4pMXig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4604
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTA5IGF0IDExOjE3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIGt2bV9zZXRfYXBpY19iYXNlKCkgdG8gbGFwaWMuYyBzbyB0aGF0IHRoZSBi
dWxrIG9mIEtWTSdzIGxvY2FsIEFQSUMNCj4gY29kZSByZXNpZGVzIGluIGxhcGljLmMsIHJlZ2Fy
ZGxlc3Mgb2Ygd2hldGhlciBvciBub3QgS1ZNIGlzIGVtdWxhdGluZyB0aGUNCj4gbG9jYWwgQVBJ
QyBpbi1rZXJuZWwuICBUaGlzIHdpbGwgYWxzbyBhbGxvdyBtYWtpbmcgdmFyaW91cyBoZWxwZXJz
IHZpc2libGUNCj4gb25seSB0byBsYXBpYy5jLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2Ug
aW50ZW5kZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbGFwaWMuYyB8IDIxICsrKysr
KysrKysrKysrKysrKysrKw0KPiAgYXJjaC94ODYva3ZtL3g4Ni5jICAgfCAyMSAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgMjEgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2xhcGljLmMgYi9hcmNo
L3g4Ni9rdm0vbGFwaWMuYw0KPiBpbmRleCBmZTMwZjQ2NTYxMWYuLjYyMzljZmQ4OWFhZCAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL2xhcGljLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2xh
cGljLmMNCj4gQEAgLTI2MjgsNiArMjYyOCwyNyBAQCB2b2lkIGt2bV9sYXBpY19zZXRfYmFzZShz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB2YWx1ZSkNCj4gIAl9DQo+ICB9DQo+ICANCj4gK2lu
dCBrdm1fc2V0X2FwaWNfYmFzZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBtc3JfZGF0
YSAqbXNyX2luZm8pDQo+ICt7DQo+ICsJZW51bSBsYXBpY19tb2RlIG9sZF9tb2RlID0ga3ZtX2dl
dF9hcGljX21vZGUodmNwdSk7DQo+ICsJZW51bSBsYXBpY19tb2RlIG5ld19tb2RlID0ga3ZtX2Fw
aWNfbW9kZShtc3JfaW5mby0+ZGF0YSk7DQo+ICsJdTY0IHJlc2VydmVkX2JpdHMgPSBrdm1fdmNw
dV9yZXNlcnZlZF9ncGFfYml0c19yYXcodmNwdSkgfCAweDJmZiB8DQo+ICsJCShndWVzdF9jcHVp
ZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWDJBUElDKSA/IDAgOiBYMkFQSUNfRU5BQkxFKTsNCj4g
Kw0KPiArCWlmICgobXNyX2luZm8tPmRhdGEgJiByZXNlcnZlZF9iaXRzKSAhPSAwIHx8IG5ld19t
b2RlID09IExBUElDX01PREVfSU5WQUxJRCkNCj4gKwkJcmV0dXJuIDE7DQo+ICsJaWYgKCFtc3Jf
aW5mby0+aG9zdF9pbml0aWF0ZWQpIHsNCj4gKwkJaWYgKG9sZF9tb2RlID09IExBUElDX01PREVf
WDJBUElDICYmIG5ld19tb2RlID09IExBUElDX01PREVfWEFQSUMpDQo+ICsJCQlyZXR1cm4gMTsN
Cj4gKwkJaWYgKG9sZF9tb2RlID09IExBUElDX01PREVfRElTQUJMRUQgJiYgbmV3X21vZGUgPT0g
TEFQSUNfTU9ERV9YMkFQSUMpDQo+ICsJCQlyZXR1cm4gMTsNCj4gKwl9DQo+ICsNCj4gKwlrdm1f
bGFwaWNfc2V0X2Jhc2UodmNwdSwgbXNyX2luZm8tPmRhdGEpOw0KPiArCWt2bV9yZWNhbGN1bGF0
ZV9hcGljX21hcCh2Y3B1LT5rdm0pOw0KPiArCXJldHVybiAwOw0KPiArfQ0KDQpOaXQ6DQoNCkl0
IGlzIGEgbGl0dGxlIGJpdCB3ZWlyZCB0byB1c2UgJ3N0cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8n
IGFzIGZ1bmN0aW9uDQpwYXJhbWV0ZXIgaWYga3ZtX3NldF9hcGljX2Jhc2UoKSBpcyBpbiBsYXBp
Yy5jLiAgTWF5YmUgd2UgY2FuIGNoYW5nZSB0byB0YWtlDQphcGljX2Jhc2UgYW5kIGhvc3RfaW5p
dGlhbGl6ZWQgZGlyZWN0bHkuDQoNCkEgc2lkZSBnYWluIGlzIHdlIGNhbiBnZXQgcmlkIG9mIHVz
aW5nIHRoZSAnc3RydWN0IG1zcl9kYXRhIGFwaWNfYmFzZV9tc3InIGxvY2FsDQp2YXJpYWJsZSBp
biBfX3NldF9zcmVnc19jb21tb24oKSB3aGVuIGNhbGxpbmcga3ZtX2FwaWNfc2V0X2Jhc2UoKToN
Cg0Kc3RhdGljIGludCBfX3NldF9zcmVnc19jb21tb24oLi4uKQ0Kew0KICAgICAgICBzdHJ1Y3Qg
bXNyX2RhdGEgYXBpY19iYXNlX21zcjsNCgkuLi4NCg0KICAgICAgICBhcGljX2Jhc2VfbXNyLmRh
dGEgPSBzcmVncy0+YXBpY19iYXNlOw0KICAgICAgICBhcGljX2Jhc2VfbXNyLmhvc3RfaW5pdGlh
dGVkID0gdHJ1ZTsNCiAgICAgICAgaWYgKGt2bV9zZXRfYXBpY19iYXNlKHZjcHUsICZhcGljX2Jh
c2VfbXNyKSkNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCgkuLi4NCn0NCg0K

