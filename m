Return-Path: <kvm+bounces-53321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD03B0FD29
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 01:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E3E23A624F
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 23:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A66E24C07F;
	Wed, 23 Jul 2025 23:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N16JhYyE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19980136349;
	Wed, 23 Jul 2025 23:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753311677; cv=fail; b=TLRNMI4eJHQ/avIPMMO/16WKsV4arFZHjBoNWry+djPyzRZy+ta2k2HQ5XO4DS+HH6kF2qX1Gma6SvEnj6kKNFA9lVsUF5OFcvNo/oNerrvlDjW17mtIj7yy1Xq//UdQLc/2KbbPnlG3K2XZ6PBgKL40eGkdWe72AIgaufY+e4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753311677; c=relaxed/simple;
	bh=MOZT4K5OkASGXamWlTYEIePA/1c/8ndSOPdSyJn9iq8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kr6cRB7Os3/hxXvxcIEFyiWjpDTxznKvt3ucwgAu082zhbvr+IEq+OpvpREW7bOtoLOOANPGJ9YYJYXWZmkCd+gEPxR9DAID8OMAJEpzshJb9hWS9qQib4YyJ2Wy2qmKf5uZUiAqr3F29dkdkjd/5HjMGqcKuTJbG1k2xK+eeOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N16JhYyE; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753311676; x=1784847676;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MOZT4K5OkASGXamWlTYEIePA/1c/8ndSOPdSyJn9iq8=;
  b=N16JhYyEsIonSqptZubzUzOM1BhlFclyTAqbkeJdi+7K4CVQXjpbqTMQ
   Q8z+koe9fCC+J+ulJwpoWQry4TzlgCf4ISV5aXwLHdjMy3lo3SJDTWVVu
   YGtIMTOuLvRPV9IyqLNk576dsLI/hVh4M1sggTgcT/yD94pESucBZdydv
   qqvkhQRfnE60HHMIIYCJSWvbnwi9kgoXYASsMEKlN4aDgUbUr4DTw01dQ
   R58dn4tenUs8j78G0+Rqt/2aW3XYeHuceeRoJR/AbNYmWXkSE0vrh/ZuD
   WmHY3vTfcH7KpybsHgM666ig3y96FHHMVRmWaZPN0KHWyiEVJDxd6FY4E
   w==;
X-CSE-ConnectionGUID: 4bLvYuLZSjqcH4TJ4su4Uw==
X-CSE-MsgGUID: a8VuV8OZQc+zrnZ64FKzBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="73188687"
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="73188687"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 16:01:15 -0700
X-CSE-ConnectionGUID: pIC98GCuSzmcKaJje+92wg==
X-CSE-MsgGUID: e2TeSXejRFWAIJ2NhcmouQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="164078916"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 16:01:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 16:01:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 16:01:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.52) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 16:01:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKImaX1f3Y4GSS3qOI27Sosuardz3wBColdg12iqFnXoCc83Y6aXu9gib2fvadUg2H0zpe2ZoHozXNaQvUla4P5Tn99Dv4fY4B8Q8YZiA6q8Ut23BGN/HbF+q+N7QOcjVcYCjPQbIneHtAf1GXV4VZXjNa22dqUFtTBZsU15d61LhBrej637RTW0IE6ErEQdlxFizMPFZsAuGR7Dhs+f7s6Tx1kgRCWuFghtrYw16tYWZTeVgIlWjp2lEcP5RD9UOac8JYzAbrHhcEvWjkY4cxHsp7NdmLkq19GbmSo7jeZBZE30XN9uv27zpXxb9yZyzhgVlHgls/V/bzpQjARZCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOZT4K5OkASGXamWlTYEIePA/1c/8ndSOPdSyJn9iq8=;
 b=HOoFYO7Uzq7pQX9eWIAgupDcFzmi2JlpB9ahcugxhTCqocBA92AMuE/Glu3Khq81qnzTyaNbH1IsqldL2151lyrBBhq3rQVmKzgiHRa8Uji2H6W3gxa6/0hxTmgX+6PKf+dOt7J4NKdg0WZI9dPcnAUf3h/3Qfk/f87X+LUAEAsTMWhnJiUp/EjVd6d810TPn3vRitUqNBJAO24HimT2cmOfVs3nasEznAEQFsDLx2LuAo3LB1WTSHbfh2AJ3vEV/Xa2praWsLm5RiZg9k8y0jU7mfATg14NNRGtdRcIJqcKqzjb0y8nDXdoYTrN6Zq0m7wExUJ8vMcxv0HQcXBSgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV3PR11MB8693.namprd11.prod.outlook.com (2603:10b6:408:215::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 23:01:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 23:01:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovevc+bw9PokmM8lb9WadM7LQ/vkEAgAAI0YCAAAHUAIAADQaAgAB91gA=
Date: Wed, 23 Jul 2025 23:01:09 +0000
Message-ID: <10af9524189d42d633b260547857516b49f9dc8e.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
	 <20250723120539.122752-2-adrian.hunter@intel.com>
	 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
	 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
	 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
	 <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
In-Reply-To: <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV3PR11MB8693:EE_
x-ms-office365-filtering-correlation-id: af14d462-c0cf-428f-a721-08ddca3cd044
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S3BESjZNNW1pNEpLMnU3T2tVQ3hFWGZGWEd6LzF5dy9PSUx2RGRPVkFsVnE5?=
 =?utf-8?B?TGNReE9VYUhyV1U1UFh4NmlDQmlkSTJuSmVUeGFvZ3VUcEM5ZHI0TElkRUN2?=
 =?utf-8?B?ejJBOEQ3QXhHSE5DelRxd2pjMmkyQ0hWbTNqYWdiQWxQWWZ1d0tuTndKbzV3?=
 =?utf-8?B?WDM2Ulh3YUowamJvbndreHZza0JZamQ3Mnc3ODA5MzNNcGFIUkxVdWUwME9B?=
 =?utf-8?B?K0VzdVhUd1dKOUx6YVI4UmM0WmpPcUpZNWJIWnZPcEtkN2dmZHd5SXpRWUEz?=
 =?utf-8?B?SmJCR2t1Y0lCSGZoKy82aTFxOWZ6amJiYXFlcHV3OW82SmUyN3NCaFZpMEsx?=
 =?utf-8?B?RnRGQndVUitKZEdzd0g1YUZlb0ZqZjF3Um52SGNDNVVWOWJBRDh1ZU5JMHpn?=
 =?utf-8?B?R2dQSWJpUVpHUlJKSmw0RnJiZ2IxY1hzd2JYZGN4TmFmeGpBQmtwRnc2M0ov?=
 =?utf-8?B?d3piRzlJNWRHOTVxSE1RaEJBUzBWWmZ5SUE4bW53U2E4UjVGdTBnaUJrbkdl?=
 =?utf-8?B?bGE2VnB4QUJTaE9XQUN5K3lmMkdzTVZ1OFkxdGFPQU1Oelg1VldvY2pIZnla?=
 =?utf-8?B?STNwL2dvQU9HSFNDYWVMVS9mVE0yTUc2bWx1NXNQamxoTTJmM2FDcy9TRUVO?=
 =?utf-8?B?d1d2cDV1eTAxNUZaSjhTSWpQMS8rYjlvT3gwemlybGV4UEtKeXFCWWR5UXcv?=
 =?utf-8?B?OTI5QTZqWFBFRDNNNUQ0NnJheDQzdUI4c1FmUjhkRVRnTTR3M2FubDVhQ1l2?=
 =?utf-8?B?OWkrS2VyODJkL3RLNlpZZ0pBdE5Pdm56dUJyZlErSEZWN052a2VtVXJ5NGpC?=
 =?utf-8?B?amEyQ3lFd1F5WndWYStCZE0xcUZIOER6U0w1Z1o4REZiNGhYNWFrQk91dE9m?=
 =?utf-8?B?OUw1SjAzYTRQUnltd21qbVVmQWJERjN5WkZRT1V0R0htMU45MStvNWxvMjdI?=
 =?utf-8?B?SnVoU1VHTEg0a2REUVMxZ3JJdkJkUTdGWlBZSmhuejJiSk41S09GZDdiazYx?=
 =?utf-8?B?ZUlycUpOOG01SUtjMTRuRTI4Nng4MTBacUNrbm5vSDhFRnJINXI5VDhybHdC?=
 =?utf-8?B?d252V2VwK0M4ZWVaZ0tla2ZRWTdEOFRxM0tldTNXdnY0MnJ4L00yQy84L2JJ?=
 =?utf-8?B?VVFqNHpEVUJEOWpFMHF5YlBVYXhqV051cE1pSE53UTdYcEg0Q3A5QVpLanQ1?=
 =?utf-8?B?ejN1SGJpMkJXRk5Ub0d0SjZoSC9hcS94eUFYM0VDVkI4Z0hpeCs2WWZtKzdi?=
 =?utf-8?B?bXFPMEZLU05UbjFnREFsZ01QbUMwWm42ZCtWVDA1UFZ1UzllNXpWREhxUloz?=
 =?utf-8?B?aTVZUEFBUWtuWG1jcThOQjJPd2NSK2M1c09WOHVHK0dqQVpLWVE0NWRtalVP?=
 =?utf-8?B?ekhzdXBnTXdUcy9uU2xLYVg2M0FqTzBWQkVyQm5SOXVIbS9sMkl6S280K0FP?=
 =?utf-8?B?S1l5UzlOOVdxU0ptUERpMUVCSG1OTWNBd1BkNmRUTkd5bnpxYWl2SXc1T2or?=
 =?utf-8?B?azlhRm1WSWVMYzAwYi9SQzlySWwydDQxVDR0WmpHUWFjbWpNN1hlSEVUYW5j?=
 =?utf-8?B?NGZuZi9VanRTeGxMZ2hOR2dNZjN0OHNOK0JLNmdROWkxQklFVmdWT0dYTWg3?=
 =?utf-8?B?elRwdTVuZm5jMms2OUhDUkZ6alhobHpQTi9HZitMR2t5N1JjV0tIaXlLcnJV?=
 =?utf-8?B?SW1PWEhHdUlQWnZxems4Ym1BZ3d2N0MrTjJkVG96ZzZXcEZoOFhqMnoyVlBG?=
 =?utf-8?B?UFA3eCs1ajA2WUZORnJML1ZGeTlVMWI3bTBRb01uNXdMMXU0VzkwSGJvUlZI?=
 =?utf-8?B?RVNIUDV6TVlPS2N1NlhUdExwdndUalh2T2p3MFRlSUpvZ0dob29oVVZCc2o4?=
 =?utf-8?B?cFA2a2hLRGF6MFBCRnkzN2piRkNtQkVyTjRGVlRCYXlHb3Nxb1gxUW5odTlh?=
 =?utf-8?B?Z2RWYzFYWWhHNnN3R0RkdGhMMThCSmw1VVZKRkc5czBGeFJvUE5CR0l2QmNx?=
 =?utf-8?B?V3cwRGZFblZBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3YxL2t0czdnWm1FN25lbjlFN21HN0tPNnlUUXQzRzUxY3E0ZzltUWcvUHhl?=
 =?utf-8?B?NzR5Vi9qTDNMMEdpa1lZVmt4SEVqWjdmd3FOYWhrWDlPcFlHc2xwbHg5UGJJ?=
 =?utf-8?B?ZVJIQUYzR1dhRER4Qy9sQWpOcGY1NVk5UmxjTDRzUVQ0Tk9odmQzUVRiRVg1?=
 =?utf-8?B?U3B5MkVsUVdXMXRNL2VGVUtSU0c0QnVWdjZPK3lBQ0k1UHFzV25zSG1CT3JG?=
 =?utf-8?B?N1ZjcXRkYXgzeklFRkVIa0EvejZwK01TS0pQOHRkVFRQN1RGVlNMZ0ZCdkVB?=
 =?utf-8?B?N25tbUtQODIrRnZxdkVjSlJUcjI5dTI5QXNqN3Zwc0VCYXJkYzJtMUt5aFor?=
 =?utf-8?B?SVpPSEVLU0wvVURXNzRWcy9YZHc0MGo4VnVxTWpwbEh1WG4zTW04MXJTWXA1?=
 =?utf-8?B?SHRXbUNIakxIVnBIYlc5S2Y5b1NZeGVWVlVROHdEbnNxeUN1OVQwYXk0ZVZ2?=
 =?utf-8?B?cFc2Mm1HTm1Db29EbWtxM0dRelJrWGZJN0dHMmhodDF1N2hQUHkvbnc1N2x0?=
 =?utf-8?B?TkpHbE54NmVWajhYNWordEJaRjhqREVZNmdTM3BiWWNiYzcveFdDOTNaeFFB?=
 =?utf-8?B?TnVydlMweHpUb3ZleWdKUTE0UmNDdmFBWjkyUXhZZEVMVnNSWlRrdThmVnY4?=
 =?utf-8?B?UG5oL1B3VE5wSUV5SG1yaDRLcVFXSXZmSmoyajJxZVhobGZaWWt1SzBNMWlv?=
 =?utf-8?B?NjFUSDZydUpaR0J1RFNaRytLZlpHL3NYYW91Nk9lMDUxNWlMSzIxY2RDUGxh?=
 =?utf-8?B?VWhUdTU5dks3TEZDZVJuUEZkMUZFTjFQTS85d2lNRnFqZDl4NFRKbXFEK1Jo?=
 =?utf-8?B?MGwyc2JGRFdsS2FUaFR6ZXl2L3U2eXdOZTdqUUV1ODgvSFBrcFkvZDV2S1Yv?=
 =?utf-8?B?M3ltbjBURlc0dmpnNzVpN0FwWVdIQ093eFppOTFnRCtlVW03MjFCNnpqZGxE?=
 =?utf-8?B?OUhHdGdVQlNHKzB4Q0dYREdIVlhSZ2lsY1owc285cTFSYkdWWUZXd081Y2hZ?=
 =?utf-8?B?em5sdUtVRUZVOUp1Sm4yemwvY3cxcGs1QWJBL29aV3VJN2trWDJVVEtYT3cw?=
 =?utf-8?B?NExpZWhpcE1PdCtpbHN2eXM1bnQySkQ4TzNWOGlqRnZudVVtRk5FQ3BZRDVh?=
 =?utf-8?B?UTVQc2lqRmxkckpib2RiUm5QMm5yUVJyRWZUN0htRUpRRW1IRUg0TFVoMUZy?=
 =?utf-8?B?MHp0anF4YVBmWVYxUkpoR2hQNjI3OGZxRjFWTlJaMUNYdk51eTlmUlNDOEZs?=
 =?utf-8?B?eFAzYUJyc0dlbXpjVUhvTDhrcDhUTFN3MTQ5cDRTTWhwWTlrM3FqNVRQdVJl?=
 =?utf-8?B?VkxyZ25IUlBxRmpteWtQUFJvb3UzK2FLSFNTRnJiMHpndjBPQzhpcjAyUmtS?=
 =?utf-8?B?WHJMYnA0MWMxOGpRemJ6Vkoyem44OUFFOHB2ZWFIa2ZuWTBBMnErQW94ai9Q?=
 =?utf-8?B?Wk5mUkk3eEI0UEFhTVVtY1QzUzBGdjJzWFVVZCt2eVBreC82SVVENG5wb2dj?=
 =?utf-8?B?TFZWSVNBMHJ6SDRiWlhzQWZtYkRuaDJ3T1dEQThITVgxbXNXWU5rMVUrTmFl?=
 =?utf-8?B?NitJRkVVbk1YcWRXNDg3QjZmVHZxRW5KdWNKNkFaNXpvc3ZudFI5eG14S2Ri?=
 =?utf-8?B?bWlwcHQxZ2Y5WnhMbzBPTGMvK3FDM2lJb1Y3QlFqNjZvYkFmSE4rLzBDcUtI?=
 =?utf-8?B?eTNNU1JvU0pBUmt1bDZWN0ZONTJxSUgvSnZBbHplMHAzS0FYVnVBcE8xd1JR?=
 =?utf-8?B?eXAramR3Q0tEN01YSFN2TEdRODhuYmZjc0hVbkJTSzRQc2VrN211Sis0amYr?=
 =?utf-8?B?dFBaVGJyUVVaRDF2ZDdWUC82TERlNlM2WVNta09NNkM5cEk0RFMzYU9BRU1C?=
 =?utf-8?B?QTgwL3Y2WVRVcnJzeGlSam4xRGE4S1FpZmNxYndhUFdPUDhyMFlEY2gxYWxY?=
 =?utf-8?B?NTl4UDBlaGdVSFo3am5PMDh5aU5BckhadG5qRlo4RzlaS05QSTRycjFOV09z?=
 =?utf-8?B?MWgrVW0zcTEyQkxybGhtMFdoMy9CaXp3Z3dMOEs4eEFSdHZ3OXdLZUhlQmZJ?=
 =?utf-8?B?ZWdoM3d6Qk14b1JzOW9WanRrNzRlWlRPL3djUTJUSGw3TUZ2Y1lEUlNFLzlP?=
 =?utf-8?Q?s4vAaYx7yLcW07X49hgcLxlv6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0780AC2087F4B34A980D4C1D3FD912C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af14d462-c0cf-428f-a721-08ddca3cd044
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 23:01:09.7359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qxj/ff0RePRn5p7EjdALBMi+6r11/TRPf0wSnoSOcEe+oIzArc/E5mfEybNWAkdXRLvlR9X22c+tkaaPYmqmpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8693
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDE4OjMwICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gT24gMjMvMDcvMjAyNSAxNzo0NCwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gT24g
V2VkLCAyMDI1LTA3LTIzIGF0IDE3OjM3ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0KPiA+
ID4gPiBUaGUgbGF0dGVyIHNlZW1zIGJldHRlciB0byBtZSBmb3IgdGhlIHNha2Ugb2YgbGVzcyBj
aHVybi4NCj4gPiA+IA0KPiA+ID4gV2h5IG1ha2UgdGR4X3F1aXJrX3Jlc2V0X3BhZ2UoKSBhbmQg
dGR4X3F1aXJrX3Jlc2V0X3BhZGRyKCkgZm9sbG93DQo+ID4gPiBkaWZmZXJlbnQgcnVsZXMuDQo+
ID4gPiANCj4gPiA+IEhvdyBhYm91dCB0aGlzOg0KPiA+ID4gDQo+ID4gPiBGcm9tOiBBZHJpYW4g
SHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFtQQVRDSF0g
eDg2L3RkeDogVGlkeSByZXNldF9wYW10IGZ1bmN0aW9ucw0KPiA+ID4gDQo+ID4gPiBSZW5hbWUg
cmVzZXRfcGFtdCBmdW5jdGlvbnMgdG8gY29udGFpbiAicXVpcmsiIHRvIHJlZmxlY3QgdGhlIG5l
dw0KPiA+ID4gZnVuY3Rpb25hbGl0eSwgYW5kIHJlbW92ZSB0aGUgbm93IG1pc2xlYWRpbmcgY29t
bWVudC4NCj4gPiANCj4gPiBUaGlzIGxvb2tzIGxpa2UgdGhlICJmb3JtZXIiIG9wdGlvbi4gQ2h1
cm4gaXMgbm90IHRvbyBiYWQsIGFuZCBpdCBoYXMgdGhlDQo+ID4gYmVuZWZpdCBvZiBjbGVhciBj
b2RlIHZzIGxvbmcgY29tbWVudC4gSSdtIG9rIGVpdGhlciB3YXkuIEJ1dCBpdCBuZWVkcyB0byBn
bw0KPiA+IGNsZWFudXAgZmlyc3QgaW4gdGhlIHBhdGNoIG9yZGVyLg0KPiA+IA0KPiA+IFRoZSBs
b2cgc2hvdWxkIGV4cGxhaW4gd2h5IGl0J3Mgb2sgdG8gY2hhbmdlIG5vdywgd2l0aCByZXNwZWN0
IHRvIHRoZSByZWFzb25pbmcNCj4gPiBpbiB0aGUgY29tbWVudCB0aGF0IGlzIGJlaW5nIHJlbW92
ZWQuDQo+IA0KPiBJdCBtYWtlcyBtb3JlIHNlbnNlIGFmdGVyd2FyZHMgYmVjYXVzZSB0aGVuIGl0
IGNhbiByZWZlciB0byB0aGUNCj4gZnVuY3Rpb25hbCBjaGFuZ2U6DQo+IA0KPiBGcm9tOiBBZHJp
YW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIXSB4
ODYvdGR4OiBUaWR5IHJlc2V0X3BhbXQgZnVuY3Rpb25zDQo+IA0KPiB0ZHhfcXVpcmtfcmVzZXRf
cGFkZHIoKSBoYXMgYmVlbiBtYWRlIHRvIHJlZmxlY3QgdGhhdCwgaW4gZmFjdCwgdGhlDQo+IGNs
ZWFyaW5nIGlzIG5lY2Vzc2FyeSBvbmx5IGZvciBoYXJkd2FyZSB3aXRoIGEgY2VydGFpbiBxdWly
ay4gIFJlZmVyDQo+IHBhdGNoICJ4ODYvdGR4OiBTa2lwIGNsZWFyaW5nIHJlY2xhaW1lZCBwYWdl
cyB1bmxlc3MgWDg2X0JVR19URFhfUFdfTUNFDQo+IGlzIHByZXNlbnQiIGZvciBkZXRhaWxzLg0K
PiANCj4gUmVuYW1lIHJlc2V0X3BhbXQgZnVuY3Rpb25zIHRvIGNvbnRhaW4gInF1aXJrIiB0byBy
ZWZsZWN0IHRoZSBuZXcNCj4gZnVuY3Rpb25hbGl0eSwgYW5kIHJlbW92ZSB0aGUgbm93IG1pc2xl
YWRpbmcgY29tbWVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFkcmlhbiBIdW50ZXIgPGFkcmlh
bi5odW50ZXJAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
YyB8IDE2ICsrKystLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBpbmRleCBlZjIyZmMy
YjlhZjAuLjgyMzg1MDM5OWJiNyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAtNjY0LDE3
ICs2NjQsMTcgQEAgdm9pZCB0ZHhfcXVpcmtfcmVzZXRfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkN
Cj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKHRkeF9xdWlya19yZXNldF9wYWdlKTsNCj4gIA0K
PiAtc3RhdGljIHZvaWQgdGRtcl9yZXNldF9wYW10KHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIpDQo+
ICtzdGF0aWMgdm9pZCB0ZG1yX3F1aXJrX3Jlc2V0X3BhbXQoc3RydWN0IHRkbXJfaW5mbyAqdGRt
cikNCj4gIHsNCj4gIAl0ZG1yX2RvX3BhbXRfZnVuYyh0ZG1yLCB0ZHhfcXVpcmtfcmVzZXRfcGFk
ZHIpOw0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgdm9pZCB0ZG1yc19yZXNldF9wYW10X2FsbChzdHJ1
Y3QgdGRtcl9pbmZvX2xpc3QgKnRkbXJfbGlzdCkNCj4gK3N0YXRpYyB2b2lkIHRkbXJzX3F1aXJr
X3Jlc2V0X3BhbXRfYWxsKHN0cnVjdCB0ZG1yX2luZm9fbGlzdCAqdGRtcl9saXN0KQ0KPiAgew0K
PiAgCWludCBpOw0KPiAgDQo+ICAJZm9yIChpID0gMDsgaSA8IHRkbXJfbGlzdC0+bnJfY29uc3Vt
ZWRfdGRtcnM7IGkrKykNCj4gLQkJdGRtcl9yZXNldF9wYW10KHRkbXJfZW50cnkodGRtcl9saXN0
LCBpKSk7DQo+ICsJCXRkbXJfcXVpcmtfcmVzZXRfcGFtdCh0ZG1yX2VudHJ5KHRkbXJfbGlzdCwg
aSkpOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdW5zaWduZWQgbG9uZyB0ZG1yc19jb3VudF9wYW10
X2tiKHN0cnVjdCB0ZG1yX2luZm9fbGlzdCAqdGRtcl9saXN0KQ0KPiBAQCAtMTE0NiwxNSArMTE0
Niw3IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ICAJICogdG8gdGhlIGtl
cm5lbC4NCj4gIAkgKi8NCj4gIAl3YmludmRfb25fYWxsX2NwdXMoKTsNCj4gLQkvKg0KPiAtCSAq
IEFjY29yZGluZyB0byB0aGUgVERYIGhhcmR3YXJlIHNwZWMsIGlmIHRoZSBwbGF0Zm9ybQ0KPiAt
CSAqIGRvZXNuJ3QgaGF2ZSB0aGUgInBhcnRpYWwgd3JpdGUgbWFjaGluZSBjaGVjayINCj4gLQkg
KiBlcnJhdHVtLCBhbnkga2VybmVsIHJlYWQvd3JpdGUgd2lsbCBuZXZlciBjYXVzZSAjTUMNCj4g
LQkgKiBpbiBrZXJuZWwgc3BhY2UsIHRodXMgaXQncyBPSyB0byBub3QgY29udmVydCBQQU1Ucw0K
PiAtCSAqIGJhY2sgdG8gbm9ybWFsLiAgQnV0IGRvIHRoZSBjb252ZXJzaW9uIGFueXdheSBoZXJl
DQo+IC0JICogYXMgc3VnZ2VzdGVkIGJ5IHRoZSBURFggc3BlYy4NCj4gLQkgKi8NCj4gLQl0ZG1y
c19yZXNldF9wYW10X2FsbCgmdGR4X3RkbXJfbGlzdCk7DQo+ICsJdGRtcnNfcXVpcmtfcmVzZXRf
cGFtdF9hbGwoJnRkeF90ZG1yX2xpc3QpOw0KPiAgZXJyX2ZyZWVfcGFtdHM6DQo+ICAJdGRtcnNf
ZnJlZV9wYW10X2FsbCgmdGR4X3RkbXJfbGlzdCk7DQo+ICBlcnJfZnJlZV90ZG1yczoNCj4gLS0g
DQo+IDIuNDguMQ0KDQoNClN1Y2ggcmVuYW1pbmcgZ29lcyBhIGxpdHRsZSBiaXQgZmFyIElNSE8u
ICBJIHJlc3BlY3QgdGhlIHZhbHVlIG9mIGhhdmluZw0KInF1aXJrIiBpbiB0aGUgbmFtZSwgYnV0
IGl0IGFsc28gc2VlbXMgcXVpdGUgcmVhc29uYWJsZSB0byBtZSB0byBoaWRlIHN1Y2gNCiJxdWly
ayIgYXQgdGhlIGxhc3QgbGV2ZWwgYnV0IGp1c3QgaGF2aW5nICJyZXNldCBURFggcGFnZXMiIGNv
bmNlcHQgaW4gdGhlDQpoaWdoZXIgbGV2ZWxzLg0KDQpFLmcuLDoNCg0Kc3RhdGljIHZvaWQgdGR4
X3F1aXJrX3Jlc2V0X3BhZGRyKHVuc2lnbmVkIGxvbmcgYmFzZSwgdW5zaWduZWQgbG9uZyBzaXpl
KQ0Kew0KCS8qIGRvaW5nIE1PVkRJUjY0QiAuLi4gKi8NCn0NCg0Kc3RhdGljIHZvaWQgdGR4X3Jl
c2V0X3BhZGRyKHVuc2lnbmVkIGxvbmcgYmFzZSwgdW5zaWduZWQgbG9uZyBzaXplKQ0Kew0KCWlm
ICghYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX1REWF9QV19NQ0UpKQ0KCQlyZXR1cm47DQoNCgl0
ZHhfcXVpcmtfcmVzZXRfcGFkZHIoYmFzZSwgc2l6ZSk7DQp9DQoNCnZvaWQgdGR4X3Jlc2V0X3Bh
Z2Uoc3RydWN0IHBhZ2UgKnBhZ2UpDQp7DQoJdGR4X3Jlc2V0X3BhZGRyKHBhZ2VfdG9fcGh5cyhw
YWdlKSwgUEFHRV9TSVpFKTsNCn0NCkVYUE9SVF9TWU1CT0xfR1BMKHRkeF9yZXNldF9wYWdlKTsN
Cg==

