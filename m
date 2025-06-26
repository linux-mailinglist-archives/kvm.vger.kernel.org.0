Return-Path: <kvm+bounces-50784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8957AE93A9
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 03:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B03C66A14A5
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 01:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093951A317D;
	Thu, 26 Jun 2025 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJa+Mn9p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38D613C8FF;
	Thu, 26 Jun 2025 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750900819; cv=fail; b=SmuiISUHsjOLbvCGm46Z2Em0tm0jVFH8vPYXQ1ROLscjFa2Yn7pspzSTzr3V35nESGL05JU7JMcUEF5mYzlMPTYE71416+QbvQJKJo4pXe5XsbKB7sVnreoO6hESUhgEZ/ho3UlQGCyJ/eXsJsmNgwaqdBptFo8/swgej2Qh0vI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750900819; c=relaxed/simple;
	bh=VCB9OgDLevGbSAEOd5ofyy37Sjst0th5P7MiwjAJfkE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tOBx4cjYrXTwP5gxhYhMGBnxZH6AM4LkzSJxi5E/1UoueET4KHYGFTaDMIvAW7K5Ozm8JgeUITXH5KxMVCPQmhScZo2ff+ILPHbBBgo+qIr7o6B+7WGJm1CHYR748kakU8AXf487Y7fVg0uocm4G39OPJoC14rjidtUVWHtywRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZJa+Mn9p; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750900817; x=1782436817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VCB9OgDLevGbSAEOd5ofyy37Sjst0th5P7MiwjAJfkE=;
  b=ZJa+Mn9pzGrGA6Jj6OLSgjzx2vM2pAWG3vneb1hf/2VUR68ibFXLnqvI
   xUb+oA1Gxc9Go2qS62V0q5+hzrIhlWfAHG/db8YUrrgLMXkStcZKmEFg9
   jmx5BuyUtt0FGb8iK+pgTI9KzVzCZe+RK8yJmj8KER4tY+/dI3LemJmea
   V2WtqLhN91Vrj1dNaG6bpi/UNq+8253W/qf/SmvJduLr3g2P5kklTGThU
   4QaM+9BqlPr88Tl1sN3wdPjw97bX4R9Cy/pb1V441ERMDINDffWbXSzGJ
   dEEheK8nu4EpEvsBTZaPf2xUAXt8g96pgVhtKXKKf0J+dQdEq+oaDeO9Y
   g==;
X-CSE-ConnectionGUID: /Z+7soytTP65xXdP68g96w==
X-CSE-MsgGUID: 5jAveJPkSB2lxFYjji9gAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53123881"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="53123881"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 18:20:16 -0700
X-CSE-ConnectionGUID: vY0uyh2eTk+V00THD8CrWw==
X-CSE-MsgGUID: j9hsd6UrTse8tTIO0iPf6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152548492"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 18:20:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 18:20:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 18:20:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 18:20:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bULB0SxF6Ovyvcj9XTvYVUr0O+zh09CrmUlhD+keRHMpP6/1E7OrVoz9rUYNrhcHu+/iz9a1oxuofxV1jOD+Y32cGGk48geNY/yEBNFFrQyr/aETowlP7Ou6FQ4+AeBbMTtgs86jY9IJstHt6L0Gl8MzZLp4MJpsnoct0e0b4ImllVrWBX2hYAQFoK+T5RTnbqoopPwWXgcQimLVoRRhfnhxVG1txr8Bin0/ZFJTUB0cIJSDvYfesMLZuRfjTLuYP0276zbx0JxkYDQ4+d/6MzDrZnL7dnQLlQdzY5GhmoZLJcI4SxjtSqAB/k1ptnAkkhvErcQZYxK1lMZUzxK0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCB9OgDLevGbSAEOd5ofyy37Sjst0th5P7MiwjAJfkE=;
 b=LsynQ0WVKBOjYloM6jOHlrKKFrnTdnIiPj+0VfBEYrWLC58ECUuCHMLQjz+1Of5PP93mVTRvhgiS3LWhGlvgX8S7l4H4vIKqeCek1gmVWWgHO9vj7QGDCnMOgKjl1xpIizrF6Dnffvk0NcA+/egjESMGuqMVJJj4hSTeBPQacXxAavwtvSvd/n4Pq9Uyz3IMNkcU4yPRhap2EXOAO+S+NFXt6M54e9tJue2H8BHGxO5ajtDa+RNJvO7OFKYeCCoFoy+elDXQfxMIqiCQttnKGa/oropkhh0uE3Oa39XpLB0qzCVnwzglMK8PXkbt3taTNawZn3RtAiLdn0BpzV2Gyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB5082.namprd11.prod.outlook.com (2603:10b6:806:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 01:19:54 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 01:19:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnDpX31F9fykECcZZx9vdaxeLQJAkSAgAr5c4CAAB9IgIAAZo+AgAABkICAAC0ggA==
Date: Thu, 26 Jun 2025 01:19:54 +0000
Message-ID: <8c24d9b9c888eed972e8ee75fa9d31cc7fd72a73.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-3-adrian.hunter@intel.com>
	 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
	 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
	 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
	 <c315604761ad760fc29bebdb007fac239a1b45f9.camel@intel.com>
	 <91df7051-2405-4609-9e86-2bbc02829644@intel.com>
In-Reply-To: <91df7051-2405-4609-9e86-2bbc02829644@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB5082:EE_
x-ms-office365-filtering-correlation-id: ff88eec3-8d4d-438e-66d8-08ddb44f8eb0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a01BamIvOTFFZHE1dzJ5OUhyT3RpQjhydm96NSs1SDNEQVpDd2Zrb1ZjbmlC?=
 =?utf-8?B?bUNPVVB6cjJId0ZSWGNNUDAxV0F1N2VxZzhCbjB6Qk5MNkZvVFRqVkkzdkVY?=
 =?utf-8?B?Q1VjSG1pVjJ3VWZmellheFhVUW5ndzV5S0dQSXM4ZHVydHNhcDhCalk1MTJH?=
 =?utf-8?B?aVRKU3JHRWVLU3dJRS9wOVQ0R1A5SGYwOXorWjhUQXhBbWVlZUZQYUtFdmo2?=
 =?utf-8?B?YWFDaENnR0hNaHFjMUNpbW1YOHNYUnN2M3NCWWw4WnhGVWxFZkNPL1JyU0Yv?=
 =?utf-8?B?cmp5ZyszQlpvK21ldGx5eC90WEM4TnZ2VDhrd1diWWxDL1dTN2FxK1pvVVhM?=
 =?utf-8?B?cmF3TEk1RDVoR2djSEVKaHJIRHNDNWFUWmpyeWFiZ2FNVmNjNlhjNmNBd2h1?=
 =?utf-8?B?V2p3K2dCM3JUc1lITkhwVndJUEJjMzRielo1aitWVTY3ZnBsZkpTS0s2aHU2?=
 =?utf-8?B?N3grMzRYdmJuVVVzaFMrYlh6enN3cGRVV3h0dUdGdDU0Qmo1aVZJaThocmp3?=
 =?utf-8?B?ZFNhQ2VDVXVHSUJOa3p5cUlUelRZMVE0L2ZLODlWNjJMYnEvdStZS21YQ0ds?=
 =?utf-8?B?KzhkSmxMemNmUk15UEVHTkVrdWRIVEtxR1ZjS0N2WDhFa3VyeVgrcVNUWE0z?=
 =?utf-8?B?WVlRZ2dFYk9aM3NBeHA3RXhaNWtXVUUvNG5pLzI0enYyV3pReU4rdVV2aEpi?=
 =?utf-8?B?dDVQRWFjWTFhalVBNnRQVFNHUE91MEIyYXUwWGpWMEVwTlpBRkVTR1MrM3RR?=
 =?utf-8?B?djRBMlc3R1FoTWo2TnJabzNrWTVFczl6QVhkN0xBT1FEK1lBZlNxd2p4QTNS?=
 =?utf-8?B?eFpybmVlaXo3L3A1R2lKRldDUEh5aGN4M2sxZkR4Ymg4WDdzVytuSitzeXY5?=
 =?utf-8?B?UDVKbTQrMmRKL1ZJeTFzdjZ5Rm1Sa0ZDVnVLKzYzM2p3VXJhYVRvRDIyVjcz?=
 =?utf-8?B?V0NYcGJZYVZEN3Y5UFJWbkg0Z1RUUk9ja3JhYjJVT1VKQ2hzSmVTUXhBY1VQ?=
 =?utf-8?B?b2ptb0p3QnVqdjQyMm9QcVlXZ04wTlR4TTljVkZFeTR0Zkk4b2pmaExhYWh4?=
 =?utf-8?B?T2FhNVNIQ3QxTHR0UUN6VDY1ZkY4bFZZWGMvQXBsZjFhbDF0MFJOU29QVUJT?=
 =?utf-8?B?QTZHdExpY2JDeU1xYzB0YVZMaFV5cDdoOFdoaCsxYmZ6bzFmZHVTUHc5RXZF?=
 =?utf-8?B?VWp4U2pJdk9EUU4wMFRsV1hkNENZZ0hIbnlCMHFhNnAvbUxZeGZZYmFabURS?=
 =?utf-8?B?WmNqeC94SmMxbDR3VGZheWltWmQxMmM0by8rODREWkJ0bWw1WVlISjM0Uzln?=
 =?utf-8?B?UWU4SmlKamVJSGxjV29LYkg3d3prWlR5RWF6eFBHTkdlNGtiNUtTSlFuYjN5?=
 =?utf-8?B?UkhYbE5tLzdFZThtakVZb1ZUYmFJbzhpem50Skd2VVA5cDRtZnlwN01iTXZs?=
 =?utf-8?B?YmJUN3h6M21ISDZ0Q0dPUlEwMWQ3RGZuRWxyNjY4SHkxdGw3Ni83RlZSUkdF?=
 =?utf-8?B?d0ZpTE9ncVh2a3loNGtWZHhpb1ZFRWxFODl1aXdvdUdsRWpTTitaQ0hrOUNw?=
 =?utf-8?B?UzJrN2puNjF5TGFFVFNQSDVVZkF5K3Z4OENzVHV5RjBLQ1JqbUE1SXV1WCtn?=
 =?utf-8?B?emlqVk1pUXg2RUxPWENkcEdaTkRQUzZiWGFlZkRySVlGVkErTzhJTlRZU0tn?=
 =?utf-8?B?TmhMRWhoa1FGQzVHa0EwQ21yenRyZGhmWTdWQm1VcXViR3FoRlcrYzFqK2ZY?=
 =?utf-8?B?QnR3OGh1UXpjdXpsaWFQVkdsZndmWGN0OWZlQ3EyTCtUeEQrZGVpZ0hCNXNm?=
 =?utf-8?B?K3NPZ2VWazh0V0dZY2R0QXAvQ3ZZQVZqRFJKZ0FaRGx4TDdnMytFQkxTR2dD?=
 =?utf-8?B?ZjhjcVpLMEZxalhqVjFmWEpzQ3NOclFHU0tzSEwreHlzcHFLeVpEZHlMaCsv?=
 =?utf-8?B?d1R3dDZnS0pDYnpFdC92ZWZMRnNxOUJwV0FvcXNBSTZuY1c5QWxCQkVuTERk?=
 =?utf-8?Q?SYpG251oqSMrg8o7aD0kFH4Jfv5LN4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVprKzBrcCt5M283YnRNZnVuK3preWM5TGh0aHowVVNESDRxYmJuc2xBVmJV?=
 =?utf-8?B?RFRqK1pvMFI4ZkprRTl2ZXM3WFpQb3V6TXJlVzlIbnlFajdtOGp5UDdRemhi?=
 =?utf-8?B?c21URE1TTXE1MUVWOUpOd21jcUtCbFh2RmZkUFJJVXc0eGkvSCsxWTM1Y1pq?=
 =?utf-8?B?aFZYNFZRL0VYL1F6YkE1UTZZRkJldGxQaUVxMnlpVDR0dDNTOVZYT0ZIMmFn?=
 =?utf-8?B?N2MxM084UDRqazBqUnVUUFFmeXVHZGJRK0hTTzdwZ2dBUGRLTmlHL3AxVGJ3?=
 =?utf-8?B?UlhqZmVzWjZaYVUyVFJvQkI0VmR1OEtmNnRmYWR1SFdaeW1sbEQwb01yT3U5?=
 =?utf-8?B?NmtKUVNMTnJjUUVSTmg2N0tKTXVQZFFIVCt6N21BSXViTmVnRGsydjFYdjB1?=
 =?utf-8?B?WExRTDRsZEtFR3A4V0xLZ2JlRlM0bEJBZWphRTV5d1NTNCt5UXRkR2QrMWFM?=
 =?utf-8?B?MnpWZHdIcHdsemE2TjVIbitSOGZyZUp6U1B5elNJemd4Tkp0Qzl6YTZuYngw?=
 =?utf-8?B?bWREVGx4L2k1TjFTYi9NSk1CVllCd2t3blhyYURkaEFsb0NxZnNUczZEYkFK?=
 =?utf-8?B?K0FJdk56aGpEZ2YxWVRvY005WmZyYXBHVFdQVDdjMmRmTGpkL0ZwUCtmN1RZ?=
 =?utf-8?B?ckJCK004cHY4VXNtMHhQdVBLbzVoajErbnZqazJGWEpDRXVJcStxbStWYjdG?=
 =?utf-8?B?dlNOWkt4UjBrRWVMMDVSaU9QOGhBeVY3aEI2bEFZWjZuSXZJUGpZSVREK0lT?=
 =?utf-8?B?aytTcDFrcjU2cFFxYmFTOFhjZDdxNEUzaFdMdHVjWXdjS0kwQlhsU05CUjVM?=
 =?utf-8?B?TVB4YnVIOENtTkNYVnVaaW1SVXVGWTNkb2ZEbFE5RmkwSFRkZFI2NG1YTmVJ?=
 =?utf-8?B?UFMzQkpVQW1vM2k5UXU3WVNYQ0ZYdVkzQkR2UFRYcGNqYWtId2dSZ0VaNmJF?=
 =?utf-8?B?MWJ0SEttdjN1ZllnWXFRdXo1RDczWkFsaXVnbDEySHNEeVRNYmc0RVRrSUdX?=
 =?utf-8?B?a0M2Z2oyalBKYnU4bGVKanRNZUpUNnVoSEhXK3dXTXVEbWV4TXhUQjFqQXBJ?=
 =?utf-8?B?SXZVYWVXcXNya09hRDJEV0I3dzMva2h1b1l6TXpjM05SVXpwZ0wrRjdCc3ZH?=
 =?utf-8?B?S3dNdSt5NGFrYVdSbDJlQkgwWi9MaDZVVkJNMUVZYkVvRkxoL2NwYW8yR3BN?=
 =?utf-8?B?c3RKcGIxdWk2ZmJVVkllOGs5cjdDZWcxc2E5a2hCdWsvcitTa3hHb3FobUpv?=
 =?utf-8?B?akp4YldrY3R2SVkxZlZYdzByT2ZCTzNmcSszSjZEZ2FDa3Awck9QUndtTm5k?=
 =?utf-8?B?aFlMRTZMSER5ZTd0d0wxT1pZRkIxWmttbk1yclNUM0RialR0MElrZE5Ickw2?=
 =?utf-8?B?NmFpalA3cWhlQzF0SDJrWnl3YTM3R09FUkliNk5YK0xpYVlCbWlzMmZreW5C?=
 =?utf-8?B?NkVreDhKcTRyOUhUYW5IeEtQbGJ0SXk2d2RPY0tUZld4TVRYUWd3d1RTRTd5?=
 =?utf-8?B?NkRDUlJZVFhwNVRrQnZiVzhiOVoyK0Y3R1QxRXhZOHRtKzgrY0FBeFRhZCsr?=
 =?utf-8?B?UVFybWtJeTBrUVViRzhFbnhZSFVqYnNUYk9WVGpIcTVTS3NuRlhJempKSHJP?=
 =?utf-8?B?cy92VmxpSnkwREpqOXcvM2VuOEFsZkdmMzhkZmJMUS8vRDVoaDRUc0pzOEtB?=
 =?utf-8?B?aHI3SDRGM3ByaG1iMFdtc3dPUWdrVWNwcFk5NFJTRHJCbjFXem1LN2hXeG5r?=
 =?utf-8?B?RVN5aTh1c1Z6NzhkSnZBZFJtZjJIKzEvSWlvUmpHQXl4Q0g5Z203V0p2UTZ1?=
 =?utf-8?B?TzlLVnNFZGQyMTltZUVwRGoyUlZBNHFzVzZsczg5RkI0dGtMNGxBbHFMRkZY?=
 =?utf-8?B?amdnckFlZXN4MW5GV3cxUnVNZGUzMTd0b2ptVEc0Y0tQVlM3dWlheUx6NEoz?=
 =?utf-8?B?amgvY3JGUU1NdUpCekVpOGdLb1pyUUUxZGFuUWlKbnFhd1lRcklHZ3o1V0Fp?=
 =?utf-8?B?OFRqUTRjTmxZK21QUVZZOXNqVFFRZmFYeUtaTEhWMDQ3VmNNZjhpc01NbXVr?=
 =?utf-8?B?WHNzYS94UXFaWkpGd2dpTEZTTWdQNmJpcGRXTzNqOHpMcG02bUcvUjYyUUFC?=
 =?utf-8?Q?ziURQjE5erdd5PjBZ4mPHEyd9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83FA971FC6346E44AD58121E4AF4BAAA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff88eec3-8d4d-438e-66d8-08ddb44f8eb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 01:19:54.5324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L5imQ7Zgp66zYICSOgFUKunnuiBbDwlAJxgpSATX+sq+/TgHqv+BxOTqs97A0RTSERvAflRvTlE8nLkdOQSuJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5082
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDE1OjM4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8yNS8yNSAxNTozMiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IDIuIHBhZ2UgbWF5IGhh
dmUgaGFkIGFuIGludGVncml0eSB2aW9sYXRpb24gb3IgYSBoYXJkd2FyZSBlcnJvcg0KPiA+ID4g
KHdlIGNhbid0IHRlbGwgd2hpY2gpLCBhbmQgUGFnZUhXUG9pc29uKHBhZ2UpIGlzIHRydWUNCj4g
PiBSaWdodC4gIEkgdGhpbmsgdGhlIHBvaW50IG9mIGF2b2lkaW5nIE1PVkRJUjY0QiB0byBzdWNo
IHBhZ2UgaXMgd2UgY2Fubm90DQo+ID4gdGVsbCB3aGV0aGVyIGl0IGlzIGEgaGFyZHdhcmUgZXJy
b3Igb3Igbm90LiAgSWYgaXQgaXMgYSBoYXJkd2FyZSBlcnJvciwNCj4gPiB0b3VjaGluZyBpdCB1
c2luZyBNT1ZESVI2NEIgbWF5IGNhdXNlIGFkZGl0aW9uYWwgI01DIHdoaWNoIHdpbGwgcGFuaWMg
a2VybmVsDQo+ID4gc2luY2Ugbm93IHRoZSAjTUMgaGFwcGVucyBpbiB0aGUga2VybmVsIGNvbnRl
eHQuDQo+IA0KPiBGaXJzdCBhbmQgZm9yZW1vc3QsIGRvZXMgdGhlIGNvZGUgcGF0aCBpbiBxdWVz
dGlvbiBpbiB0aGlzIGNhc2UgdG91Y2gNCj4gdXNlcnNwYWNlIHBhZ2VzPyBPciBwYWdlcyB0aGF0
IGFyZSBvbmx5ICJrZXJuZWwgY29udGV4dCIgaW4gdGhlIGZpcnN0IHBsYWNlLg0KDQpUaGUgI01D
IGhhcHBlbnMgd2hlbiBpbiBTRUFNIG5vbi1yb290IG1vZGUsIGkuZS4sIHdoZW4gVERYIGd1ZXN0
IHRyaWVzIHRvDQpyZWFkIGl0IHVzaW5nIGl0cyBURFggcHJpdmF0ZSBrZXlJRCwgc28gcHJhY3Rp
Y2FsbHkgaXQgaXMgYSB1c2Vyc3BhY2UgcGFnZS4NCg0KQnV0IGZvciBzdWNoICNNQyBpdCBkb2Vz
bid0IG1hdHRlciBiZWNhdXNlIHRoZSBtYWNoaW5lIGNoZWNrIGhhbmRsZXIgaGFuZGxlcw0KI01D
IGZyb20gU0VBTSBub24tcm9vdCBzZXBhcmF0ZWx5Og0KDQpkb19tYWNoaW5lX2NoZWNrKC4uLikN
CnsNCgkuLi4NCg0KICAgICAgICB9IGVsc2UgaWYgKG0tPm1jZ3N0YXR1cyAmIE1DR19TVEFUVVNf
U0VBTV9OUikgew0KICAgICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICogU2F2ZWQg
UklQIG9uIHN0YWNrIG1ha2VzIGl0IGxvb2sgbGlrZSB0aGUgbWFjaGluZSBjaGVjayANCiAgICAg
ICAgICAgICAgICAgKiB3YXMgdGFrZW4gaW4gdGhlIGtlcm5lbCBvbiB0aGUgaW5zdHJ1Y3Rpb24g
Zm9sbG93aW5nICAgIA0KICAgICAgICAgICAgICAgICAqIHRoZSBlbnRyeSB0byBTRUFNIG1vZGUu
IEJ1dCBNQ0dfU1RBVFVTX1NFQU1fTlIgaW5kaWNhdGVzDQogICAgICAgICAgICAgICAgICogdGhh
dCB0aGUgbWFjaGluZSBjaGVjayB3YXMgdGFrZW4gaW5zaWRlIFNFQU0gbm9uLXJvb3QgICANCiAg
ICAgICAgICAgICAgICAgKiBtb2RlLiAgQ1BVIGNvcmUgaGFzIGFscmVhZHkgbWFya2VkIHRoYXQg
Z3Vlc3QgYXMgZGVhZC4gIA0KICAgICAgICAgICAgICAgICAqIEl0IGlzIE9LIGZvciB0aGUga2Vy
bmVsIHRvIHJlc3VtZSBleGVjdXRpb24gYXQgdGhlICAgICAgDQogICAgICAgICAgICAgICAgICog
YXBwYXJlbnQgcG9pbnQgb2YgdGhlIG1hY2hpbmUgY2hlY2sgYXMgdGhlIGZhdWx0IGRpZCAgICAN
CiAgICAgICAgICAgICAgICAgKiBub3Qgb2NjdXIgdGhlcmUuIE1hcmsgdGhlIHBhZ2UgYXMgcG9p
c29uZWQgc28gaXQgd29uJ3QgIA0KICAgICAgICAgICAgICAgICAqIGJlIGFkZGVkIHRvIGZyZWUg
bGlzdCB3aGVuIHRoZSBndWVzdCBpcyB0ZXJtaW5hdGVkLiAgICAgDQogICAgICAgICAgICAgICAg
ICovICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgIGlmIChtY2VfdXNhYmxlX2FkZHJlc3Mo
bSkpIHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAg
ICAgICBzdHJ1Y3QgcGFnZSAqcCA9IHBmbl90b19vbmxpbmVfcGFnZShtLT5hZGRyID4+DQpQQUdF
X1NISUZUKTsgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChwKSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBTZXRQYWdlSFdQb2lzb24ocCk7ICAgICAgICAgICAgICAgICAg
ICAgICAgDQogICAgICAgICAgICAgICAgfQ0KCS4uLg0KfQ0KDQpIb3dldmVyIGlmIHRoZSBrZXJu
ZWwgdG91Y2ggdGhlIHBhZ2UgYWdhaW4gdXNpbmcgTU9WRElSNjRCLCB0aGUgZnVydGhlciAjTUMN
Cndvbid0IGhhdmUgTUNHX1NUQVRVU19TRUFNX05SIGJpdCBzZXQgKGJlY2F1c2UgaXQgZG9lc24n
dCBoYXBwZW4gaW4gU0VBTQ0Kbm9uLXJvb3QpLCB0aGVyZWZvcmUgaXQgd2lsbCBiZSB0cmVhdGVk
IGFzIGEgbm9ybWFsIGtlcm5lbCAjTUMgd2hpY2ggd2lsbA0KcmVzdWx0IGluIGtlcm5lbCBwYW5p
Yy4NCg0KPiANCj4gU2Vjb25kLCBpZiB3ZSBjYW4ndCB0ZWxsIHRoZSBkaWZmZXJlbmNlIGJldHdl
ZW4gaW50ZWdyaXR5IHZpb2xhdGlvbiBvciBhDQo+IGhhcmR3YXJlIGVycm9yIGFuZCB0aGlzIGNv
ZGUgbmVlZHMgdG8gY2xlYXIgImludGVncml0eSB2aW9sYXRpb24iIHBvaXNvbg0KPiB0aGVuIHdv
bid0IHRoaXMgY2hhbmdlIGp1c3QgZnVuZGFtZW50YWxseSBicmVhayB0aGUgZXJyYXR1bSB3b3Jr
YXJvdW5kDQo+IGluIHRoZSBmaXJzdCBwbGFjZT8hPyENCg0KVGhlIGV4aXN0aW5nIHVwc3RyZWFt
IGNvZGUgY2xlYXJzICJpbnRlZ3JpdHkgdmlvbGF0aW9uIiB1bmNvbmRpdGlvbmFsbHksDQp3aGlj
aCBJSVVDIGRvZXNuJ3Qgd29yayBpZiB0aGUgcGFnZSBpcyBwb2lzb25lZCBkdWUgdG8gImhhcmR3
YXJlIGVycm9yIi4gDQpUaGlzIHBhdGNoIGF2b2lkcyBjbGVhcmluZyBpbnRlZ3JpdHkgdmlvbGF0
aW9uIHRvIGF2b2lkIHRoaXMsIG9ubHkgaWYgdGhlDQpwYWdlIGlzIG1hcmtlZCBhcyBwb2lzb25l
ZC4NCg0KVGhlIGVycmF0dW0gd29ya2Fyb3VuZCAodXNpbmcgTU9WRElSNjRCIHRvIGNsZWFyKSB3
b3JrcyBpZiB0aGUgcGFnZSBpcyBub3QNCnBvaXNvbmVkLiAgSSBkb24ndCB0aGluayBpdCB3aWxs
IGJyZWFrIHRoZSBlcnJhdHVtIHdvcmthcm91bmQuDQoNClRoZSB3aG9sZSBhc3N1bXB0aW9uIGlz
IGlmIHRoZSBwYWdlIGlzIG1hcmtlZCBhcyBwb2lzb25lZCwgdGhlIGtlcm5lbCB3aWxsDQpuZXZl
ciB1c2VkIGl0IGFnYWluLg0K

