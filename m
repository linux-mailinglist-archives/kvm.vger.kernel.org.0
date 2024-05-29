Return-Path: <kvm+bounces-18257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2718D2ACF
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 04:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CF1CB238F6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E6BF15B0EA;
	Wed, 29 May 2024 02:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2WwDYrW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1182AEFD;
	Wed, 29 May 2024 02:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716949772; cv=fail; b=CzTn31k4nJcggk5ezsXxZW5IYjapra6T36Tfz3ScoYoSfm1Hv1eqLiJG25Z3sdGokFTlP7rx3JwHSl2Rd0uCXOOzu0MDfr1eTNNYzMZD+hV6jNmcX94pbkyBmhbexkhfbgCUTy/2R1CcmT6c3nuIcOgmQw8bsoa620gysQkRrNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716949772; c=relaxed/simple;
	bh=miW0a7i+4i3RAEbIlvdU0x+emThg1W1rmypw7U8BNfo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OHQ4+bR0IMyarzhrd69JZhEl0WOgdWjRAkm0c3xmBz9lZmxpR4F26Ja46rHBbtZONYc1V2CG9oPIunGz9vVvU3dTGvJBUDZHE1AR0AQyOltIgLkXNY3GagC3jYFrI7mTVRQEIzpa+FDF/qbGKQVJ+ff+yqyBPbCgYCMJ5ovSpnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2WwDYrW; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716949771; x=1748485771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=miW0a7i+4i3RAEbIlvdU0x+emThg1W1rmypw7U8BNfo=;
  b=C2WwDYrWrkobzBBymbWp1MJgtBACcmeK2D16OUohOJor2QZ+DuntDA0R
   PfCnWPZHdloe/8DnhxL5gnUEej4hmwtljLNj5MTYz1LIDDHZ6EUBkqgiE
   nNNjb37W8YPOdP4y3xXimTKfcnnJ8zmf3E0nkLTwQzi/V6C5a38VBcLPv
   mNRaRS7nhLtaEdztPNaHczK+aINajIgy2s1KFdJtl0vqbxgc3b6xcTd5k
   xcDvYKcepPDZsXm5xvU+q2+/DONG+hqGmtG8sQuVbYdXJTA37N12XGsZD
   xEe5F6R2Z5UJ6Sf1ICeHjLVfEwUkxGdSfoa4iO1Qfn6wE4YelkNQlNndF
   w==;
X-CSE-ConnectionGUID: XFnbF6aISLCcsTXUqOI7cw==
X-CSE-MsgGUID: gESaHjPmTdKeTFUNKw4LQQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24460568"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="24460568"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:29:31 -0700
X-CSE-ConnectionGUID: BgAjiGM6RciCw1r6CgIuGQ==
X-CSE-MsgGUID: 1JIZpokhRDGZL9Gmd1S5XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="58450958"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:29:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:29:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:29:30 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEJYWT2QldBVByMxNItSCsatqo4GPnEeSqRnRSaFcJ78q1aQSsnUzsLKY09O7R8OSjF+Qe79HeVs6EdZ3MUF66w2bW+wdAP+K/oZnHruJ6+dYwLvhEmSxyZ9IZM7bj89uYGWqvbLD5fTgkjUcpjeXPd+ZzTazvaBkFy5PSdbRNMlYX04GWbmuv85wfVvXRc5mwakvRmMg0BW//rXSexqhWBdEP4OyEOnAVeroxLs3M4THo0HDpzxILSULGfQUqeetawJJuG+ggL3wZkbhINInDXYAMaA9BjuAzKFdAmvpiXz9x1iR3qoemAhUsXqC8CBtRrlcFM41sDV2NAssR4bpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miW0a7i+4i3RAEbIlvdU0x+emThg1W1rmypw7U8BNfo=;
 b=E121cTY0C9NWZO7+dL0hhWh7NC6oc4QZ8iLyPRGovwdr7HwK7tP6L9Y2wSIusooaxFsWoPKMVNJYyrS6KqTwri99gM3ynJJY292hiAKdh+gUPFTUlla1JHHyPiTB2ReWJ4yb8U7dEftNiYtOUWTAhyQQFjxQ14ZABKyHVRIzd2qpKktt7CvWZW+6iNh2e3ju1t4Z77XcFignl0aaaDrOQ9pEALhSAIJGUN6tCwGpyrsOmNOUIGJeh5CzBHqZoowyI2D88ehAtQTAEUlHFr5dH/ofb4ZxHbuHS76FkVdPGuUMXEpumKXs8JY59u69JHavjgB7MbRYOS5m+8nrGvnyfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7058.namprd11.prod.outlook.com (2603:10b6:930:52::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 02:29:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 02:29:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com"
	<seanjc@google.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GlgQuAgACYjACABytBAIAAOfSAgAAJegCAAAhggIAAAp8A
Date: Wed, 29 May 2024 02:29:26 +0000
Message-ID: <5a5e77006e170e8cb1c77c66eb742d34f9c99324.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
	 <20240524082006.GG212599@ls.amr.corp.intel.com>
	 <c8cb0829c74596ff660532f9662941dea9aa35f4.camel@intel.com>
	 <20240529011609.GD386318@ls.amr.corp.intel.com>
	 <2b3fec05250a4ec993b17ab8c90403428ca5c957.camel@intel.com>
	 <20240529022003.GG386318@ls.amr.corp.intel.com>
In-Reply-To: <20240529022003.GG386318@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7058:EE_
x-ms-office365-filtering-correlation-id: 3b1005d5-6c74-41c9-79ab-08dc7f87294c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?QWRFM3NKN0JYZlVpK0IwSkQyalNIZ1NOSzRoVUZtSmhDZ2hPR056MGw2enMw?=
 =?utf-8?B?TUZPeTdRZ2VCbmtlMGt6L3RKMEE4ZTVDR1Q5aFd0ZnVmcjk5R1k1OEJ4NDhu?=
 =?utf-8?B?VVFaSmdGdXVaV3lYQVJ6aStVa2pXTFVxTTQydjJMbnFDOWVDdUtWR0hkNE1R?=
 =?utf-8?B?SDNIdG16aTR5dXQ3Tm8zd000QS9YUEpWS2NhWlVaQUxRM05HYmdQcTlGVnBN?=
 =?utf-8?B?bVhYdW14Nk9kSVFIa1pSWjRkdkFiMkZXOHJvSSt1bmdmTEpIc2RPZkhRcWk2?=
 =?utf-8?B?WUZGMitpRjlPanZEcEpTZ3QyUjJXaXZCN1BIYnhBSFNkaFBWcWQwbWtMZFBs?=
 =?utf-8?B?Q2ZTVEdFdHVVd3B3bTlaUlNTcEluSUI3YUtRSVljbW8rVnkra0V3S3JZbktx?=
 =?utf-8?B?Q29rSEFlYm55TmFvWkNCa1BGZng2S24wWDIzZjRxeVRWM3ZnMEJncG1kVVd4?=
 =?utf-8?B?aXRCb0ZjcENBdXdERk5aM3d4TE9GL3lYVHN2SmljOGE4ek96Ylh0TzBmdVVL?=
 =?utf-8?B?Tnh3TmNhK2Rzd0QrSTI3ZmwzTmExRERmUnFtMGZUcS9oakVPMHU5S2s0dldt?=
 =?utf-8?B?dWxDZDZqaGNUWmNqSVN6d1lFRTNGT2Z6VjkyRXk1RC9icFYvbXJZdnkrWGVr?=
 =?utf-8?B?V2h6Rm9OS054Zzl4ZXdzZUd1dXhpRjRETlZ3aVZoYlg2TUJZMjQrcm1sSUpI?=
 =?utf-8?B?SmFsQVMzT0VuQXU3ZXZxeWNiQjlEaW5uMVJDMWRKMDhMS0N5ZUhBakNCUXJR?=
 =?utf-8?B?Q0h1NkVZcGlINXRUZHZJaW9ReitCM0p5ZjRqT0txKzFDemNCSzNmZS9acGdt?=
 =?utf-8?B?NG9ocjlXKzlFeGoyYzNtOXRjMFVvNjlvandwUlBUTHprMkFyRmFpZXFmUzRT?=
 =?utf-8?B?S1BibFZnZnZPVS9SN3JWTEVvUlBIZjczbUZiZDg5QTBOaGxiRENYeHhFTGZu?=
 =?utf-8?B?Vm1YemU2TkloNzlQeUovK3p2cW1LZkZiNzdRSUFXOFVkSlBlVWlIMXdsYk14?=
 =?utf-8?B?SjNnYTB6U0F4MHhtTWYvMnNZdjM3NVk2SndCYkNhR1RVUTd0cFloS3U4Z3Zp?=
 =?utf-8?B?K1MvL3d2L2JmakZnN3NGbExPc3luWWRYZkRkWE9IUGVhRzNDV2drUkR4WS9x?=
 =?utf-8?B?MGVVbTJuSlhBMXNWOGFDVTAwelNsQkR6SXZlc1BpVzdSVldjdGxvcmFYUnU4?=
 =?utf-8?B?aDJzZXJ1b2lySlJpVzBFMU41aWQ3OVBJYjhDVEs1b2tpS21haEZ0RXYzK2wv?=
 =?utf-8?B?K3FZRjEvU2orOWZ5QmtwQWEzek5DODVJRnpSWHQzWFFoTHVhbEE1M01SL05S?=
 =?utf-8?B?SUlzZXJIUERuMGZvWUtJSWZFV3pTTmpWV2U2TXRtOWdyS29kUXFkQzN2dzc4?=
 =?utf-8?B?OEpHaWk3UlozSkdkSUhJdUFXMkRuTEpQR2ppN0MyYkxyNXdGUUJCeEdsTXdH?=
 =?utf-8?B?TlE3bEVzNjdvQUIwOEpzcXB3Q1FGV2hOWmJEMFBuQWx0M3V2bWR1V2R6VzN4?=
 =?utf-8?B?ZWpqSzR2ZkJ3V3BFZ0ZuZDJocEdQUndqMGw5RnZZN0xITHZ0QVFmNzgvcVda?=
 =?utf-8?B?YmxUVFVQdjlBWmk4Rzc5blhRbmRIRVo3Zk5wYThCZTY1dFRhREd4S0Rha1Jj?=
 =?utf-8?B?Y0hUVmdqV3kzdWI1UGVhay82OUhWZkhrOWFHcno3TUUxellwSDduWUVVOHFT?=
 =?utf-8?B?Ri9UcmV3T2ZTY0NqY1VFcGZQT3pHMUhtQUpQNEthTEZITFl3L1ErODBoQ1Qv?=
 =?utf-8?B?QmlYOFc2RHZqeEhaMlQ0cXl0ODQzTkFSNitYWG9yNmNIZUttTG11TUdEUWZS?=
 =?utf-8?B?SDlJc2JPNEcwNFhqd1VqZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3JEVUZadkZxSFVWMlBLVFVUaHgyUVU4WWdSWEdtb2RCMEtSb0htUmdZc3Y1?=
 =?utf-8?B?eHNRNzBFK29qMmlsTGNYa2tsa1lrdUNUcFh4UGJDbG9YREFKaVZqOENxVXRC?=
 =?utf-8?B?ajlHUW5RZXo2cXF4SmxjblhGcEtaZnQzWnVrMGFpNWVac1l1Sjg4aWxkOEpy?=
 =?utf-8?B?UjFDVnBjSmN5Sld4bkhxV0E5SndWYWNmMmZYQStJNFFtVGM0VlMySzIzQ2xB?=
 =?utf-8?B?R0JubVd2VStQZ2lzUldjOTZ3OXV4MUtEZElDZjJKNHBsWEJYTGtYYUpQT09H?=
 =?utf-8?B?MGFET2dRQWZObEpEVEswRXRxcy9TYlNaTmhBOWRRRjYvK0hvK2tVUFFScUFs?=
 =?utf-8?B?L1puNkVlN1ZTSUlseTVCZVJHQ1IraXoxblo2SzF2MmQ2Y2NYeG05RFVVZVl6?=
 =?utf-8?B?T2lMUGNNQk9pUkUzb1M2MERmN3h4MUlxRHliY0s1OGIrMEJOZXpqSm8wSnNh?=
 =?utf-8?B?VDJEUWFvY1JIeVpYcC84cVc5NlBsQUo3ZUVPT3U3V3c3L3dMdGN4TkpiKzRn?=
 =?utf-8?B?WUkvVmloakxkK0V2TlVROGYyWU9PRk85TW9sYnorbk9mSU5qK20xTkJDbXpa?=
 =?utf-8?B?aFVPNTlTdWF1a3BFa3VFNjdvU0VWWlRGK1NuUmVUNDFZR1dPeHREVEs2Mngz?=
 =?utf-8?B?MEdEWGlRZDNFMXpIdnE0YUF0MkxUQ2cxOHlxNGMxZHdkSHpleVlOYjRRK01Y?=
 =?utf-8?B?ZFl2ZFF3eHROdCt1ZG9DeEVuSFFXVk8ybXhCc0FTRmZZUFZQakJDa0pvVmpY?=
 =?utf-8?B?cDNVeUVmdlZObFI3aDhSU2tzM2Q0ejRIMHhoaEovaHNhU29pRzNKQmdWWElx?=
 =?utf-8?B?ZEY5NE1PWmlYcmJtRXZ4ZXBQNEtPaFoyUDROVDFaVVNhTTZTdG5CWXA2UHl2?=
 =?utf-8?B?RTM4YWQwT1UvRDF0UkdaemplTTA3Z1ZaQ21EODlxcmdqT0ZUc0JyLzlWRC9T?=
 =?utf-8?B?MzE0Z3FZMlJsZkJRODFUdXIwb0REZEFGR0c1ZkFjR3hLOUVvNjByZFpPOENG?=
 =?utf-8?B?a0tjTjBrKzZFSVVrbk9HazRxWHkvQkhTeVJYaU1RdHNrd2p1TlF1anJJQkV2?=
 =?utf-8?B?WUNhN1VxNlMvZVUvVkUyWVZyZEd2OW5jN2RqL3FVbkhmV0xIL2l1QzdmbWtJ?=
 =?utf-8?B?eDJ0aXJMTUNNaFVhOVpXRk4wbG9Od013ZzNKS3VtbiszWGlMZkowY1VBTCs3?=
 =?utf-8?B?MTRVcklKeFNaQ3NOSkNYQ2ZoREJBVnRRTCszVnVxUFNOVFBxVDVBbGxHbGhT?=
 =?utf-8?B?UWdYUlVYRGhKUmpTUGhraExuYUVweU5PcGNxSlhmTEZHZnBPbldxYVgvd3Rj?=
 =?utf-8?B?UGdXTnUxTEdEWWZIdndnbUpBdDlNNStWR1V1UzJ5WVBGbW1MSFdLMnVMYWtL?=
 =?utf-8?B?VlRkRFA2Vnp6aWU1V2tJZjErMXdRNlRWMFM5MnMxRzJGZ1JCSndMa0xNTSta?=
 =?utf-8?B?MWhaVktRZFRxN1kyRmpuVHZTWVZtVTUzNWQvYUVzTFNaeTh5MkxWZjF6ajB3?=
 =?utf-8?B?U0JvMXRlUnZJZWI4RmZ3cnQ0RGtXcHdyNW1COE5FUkFoQjJCUkptemdSblFZ?=
 =?utf-8?B?TjR5bDgwQ1VIeTB2WURkQUU4VTBXUllPd0YzMzhmbjhzMXRqbjlpTmt1MDVq?=
 =?utf-8?B?N0VnUytmc0VCMTB2a01YNk5sVUFIa08zc3ZBOVl2VGY5RW4rSU1MYlk4bHNB?=
 =?utf-8?B?QjlHR1BnNVlESThaVWp4a1pyZ3lteDZnTlRNQ1NRUk9ldUpTeE9VRTBkc3RX?=
 =?utf-8?B?TjU1Nmp1d1VZN3BUenlGaHRCU2MrRzEyRk5WaUE1MGdqUHU4a0NBR0FUUzF0?=
 =?utf-8?B?YUJnV3U5RXhrYlQ5VXA3SnlnTUlEZFl6dnJQaTh1Uk5qOHQ3QzZUSXZVOXdq?=
 =?utf-8?B?OU90b1hDdXVlYkEyT3RITitybmR2Y2ZhaWtWM1NJRmpwQWpmeEhNYXp6ek1a?=
 =?utf-8?B?UjdjbDlaa2RpYnduelVlQlRYTWxVb0txL2hoREgwZ3R4SDBUQnMyQ3FVUVJ3?=
 =?utf-8?B?NEVpeVNTcjBzL0d5R3d1NUFzWHRETzd4QWhOa0lOZU1tZ1lwQncvaDYwQ1lK?=
 =?utf-8?B?QmtFQUJLMERpRUwvQXU1dHNHbytjeDNZdUx1R2ZGckRjYzhBb1dwMVpRSis0?=
 =?utf-8?B?SEdBdis1YlJYUmd6U1dxSVpUeDBBTXZiL0gyOXJ5OWVDUHI1TW9UUkF1M2ZX?=
 =?utf-8?Q?6wZ1A8ggj9fKp5XPu0kh1XU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15A36F1C499FA84E9F9B1FA9143AF24B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1005d5-6c74-41c9-79ab-08dc7f87294c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 02:29:26.9833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZGEbyw6JXTMkTcWWrm8xIdowsK6PhmjGwMAGNr6K96CZ7LuSN4f31brpbiFSx13wex9vmHra4Q6sxdmk+MCMFdh4Ur4khC7nOdQgnuJr3Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7058
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTI4IGF0IDE5OjIwIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gUmlnaHQuIFREWCBtb2R1bGUgZG9lc24ndCBlbmZvcmNlIGl0LsKgIElmIHdlIHdhbnQgdG8g
YmF0Y2ggemFwcGluZywgaXQNCj4gcmVxdWlyZXMNCj4gdG8gdHJhY2sgdGhlIFNQVEUgc3RhdGUs
IHphcHBlZCwgbm90IFRMQiBzaG9vdCBkb3duIHlldCwgYW5kIG5vdCByZW1vdmVkIHlldC4NCj4g
SXQncyBzaW1wbGVyIHRvIGlzc3VlIFRMQiBzaG9vdCBwZXIgcGFnZSBmb3Igbm93LiBJdCB3b3Vs
ZCBiZSBmdXR1cmUNCj4gb3B0aW1pemF0aW9uLg0KDQpUb3RhbGx5IGFncmVlIHdlIHNob3VsZCBu
b3QgY2hhbmdlIGl0IG5vdy4gSXQncyBqdXN0IGluIHRoZSBsaXN0IG9mIG5vdA0Kb3B0aW1pemVk
IHRoaW5ncy4NCg0KPiANCj4gQXQgcnVudGltZSwgdGhlIHphcHBpbmcgaGFwcGVucyB3aGVuIG1l
bW9yeSBjb252ZXJzaW9uKHByaXZhdGUgLT4gc2hhcmVkKSBvcg0KPiBtZW1zbG90IGRlbGV0aW9u
LsKgIEJlY2F1c2UgaXQncyBub3Qgb2Z0ZW4sIHdlIGRvbid0IGhhdmUgdG8gY2FyZS4NCg0KTm90
IHN1cmUgSSBhZ3JlZSBvbiB0aGlzIHBhcnQuIEJ1dCBpbiBhbnkgY2FzZSB3ZSBjYW4gZGlzY3Vz
cyBpdCB3aGVuIHdlIGFyZSBpbg0KdGhlIGhhcHB5IHNpdHVhdGlvbiBvZiB1cHN0cmVhbSBURFgg
dXNlcnMgZXhpc3RpbmcgYW5kIGNvbXBsYWluaW5nIGFib3V0IHRoaW5ncy4NCg0KQSBncmVhdCB0
aGluZyBhYm91dCBpdCB0aG91Z2ggLSBpdCdzIG9idmlvdXNseSBjb3JyZWN0Lg0KDQo+IEZvciB2
bSBkZXN0cnVjdGlvbiwgaXQncyBzaW1wbGVyIHRvIHNraXAgdGxiIHNob290IGRvd24gYnkgZGVs
ZXRpbmcgSEtJRCBmaXJzdA0KPiB0aGFuIHRvIHRyYWNrIFNQVEUgc3RhdGUgZm9yIGJhdGNoaW5n
IFRMQiBzaG9vdCBkb3duLg0KDQo=

