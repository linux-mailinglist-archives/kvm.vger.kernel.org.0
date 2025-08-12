Return-Path: <kvm+bounces-54469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8813B21A7D
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A63157A1AE1
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C91476C61;
	Tue, 12 Aug 2025 02:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1RiyEMx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A82A95C;
	Tue, 12 Aug 2025 02:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754964203; cv=fail; b=sM/0/yNVGbHvJhW4MdHKfH3PamYFVAHtJ3Bh5DLJmOP7UX9sV201KwOcNFCMdbx3WPKQQtzx30eXOqI/kxKWHZrziL/qPTNIiuwcgQ9or/XB/JjiE+lIcIb8p9bTKnf1+h65BZNYYMTajqdSud1ibYfop9+W4OSSNkO/WHh1WR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754964203; c=relaxed/simple;
	bh=xHrzRna2yroJ5RjD3Gq14OXRecpjKITMYzq1bgdGaJQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=teJtKxoYkUCnVtqzctKUTlYh60UYcEKErGEJZK7nkMijb06KITOWNTTBicV3LRXjXw1lUvGGsF4ZWEHwI6x010gTi0lbDIlITBuD0ZwMbSLtS2cnU43XOse2L8gdyI3VjgE0vIF09IpZ/n3nMciXesPsVhfGo/tbyLsHI26bCTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1RiyEMx; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754964202; x=1786500202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xHrzRna2yroJ5RjD3Gq14OXRecpjKITMYzq1bgdGaJQ=;
  b=b1RiyEMxanYFshrhy5bJVusiH+y6cUl5MN3lTYGGn+92F9+uD8aooL2P
   TzSzuw9BP7TohlKVcFvf8rckFVj+OULadF5/Z6AFeq/gOw7VvbBGGsOj4
   QvsZRO3eHy5gz8VG7ONdP6S7ZKbps/FaKeNzuDd7ofLT1I6zWqqjNhD7M
   MDRNKs5njFvugBRy7NEU3BiTrquDEyRrfW4Aa66AZY9XLuvirQcRS4w07
   rQi+nqiQpoWESrAJmK6AtIFgbPakqHeZ22U/b/MRfZaYQw5mDdGY5H7rR
   6phxfutxE/8h25je14CTwV7kGMz5mwxDGzP7XuaSJiU07HFkwPEux9Zg/
   Q==;
X-CSE-ConnectionGUID: BI6ilK1QSZaqSVwWf/wuyw==
X-CSE-MsgGUID: t/FKF3ACT3CYSWq4bGY9uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="82667215"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="82667215"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:03:21 -0700
X-CSE-ConnectionGUID: pVVX3v/ETjG9oLO823+x7w==
X-CSE-MsgGUID: 87xlPkcATfaint+/BkAnFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165302109"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:03:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 19:03:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 19:03:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.62)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 19:03:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZ3OvKYSQr7oe9gehr0iXQS3YOfkEc9RtCGgegzJcWjGcX9YVNcPQ3V+f+OJeeZVWki4Q7G7atlgL4KfUjP4TYTHhzof6ExZl74JsVJ2w8uReOX/wEK0vfANemVEjkfyV4tDeo1E2zubueMjN9f1jIDlR52mdcq2Bx16fpvlItsMApz7bnaC1B6A73jm7RvPDT9WQwNdiCedI0+m8AjP3UmTd166dfQTehpgjeDW/bprCF/j9MfFaGuA10cQmlUiYFKgDa4aI8unD77xsBDjQ52KtJdtpDK6/2kllWycj/L629dM6eP/Tk3ga2MvG+sFkCaSBxFO9NIuYAlgqEtHrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHrzRna2yroJ5RjD3Gq14OXRecpjKITMYzq1bgdGaJQ=;
 b=w1+Kr+UQlA8tGrqxihc5OoGoL5oUPY3P0/YA1IIaRkRiQXfqIQkG8j/wsmypjyZw2dzDmIOXXk6dQeJKc+5nHxVuTjUgJvob9u3FgDQuKNjIzGahWHYx7eLZwiZnNAPkHvBkVuZY8b1cCv700VZRVKy1zHGOPGXtJSXXYTod5KMEngrMzqh+nR1ALWMJaUMhUrF+DenU8pO2j11AijuK9UHqs60GNZQM30TXVjbZoz0u8vuwu1ooMNQk3WKACIVc2vB/ql9kDI25NXpRP0fB5pMcOZC84vWl2js5BvPMXdsDX9txPsobvJCJuJK9Pm/4MTxTNr7WvtZiQHAy7aNY+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 02:03:18 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9009.017; Tue, 12 Aug 2025
 02:03:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb/7MLtHK6BqodHUKBqQjOH+Kz87ReRx4AgAALXICAAACkgIAACAOA
Date: Tue, 12 Aug 2025 02:03:18 +0000
Message-ID: <46bd50822596f6bf0795e96daeaef01415746e08.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
		 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
		 <3bd5e7ff5756b80766553b5dfc28476aff1d0583.camel@intel.com>
		 <05ed4105f5cf11a9dd0fa09f7f1ff647cc513bd5.camel@intel.com>
	 <e11de78443cea475030635b4d440803db3e0cf8c.camel@intel.com>
In-Reply-To: <e11de78443cea475030635b4d440803db3e0cf8c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|MN6PR11MB8102:EE_
x-ms-office365-filtering-correlation-id: 0604c647-d63e-4219-3c0f-08ddd94467f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RGhDM3hGVDFVSWJVUU5mTFh6akFuWDJ2UE9uclhsNzJyaVRwT3dOVDhWRVk0?=
 =?utf-8?B?NEhGR3piT2dxd1U5NmlwMk9vWHBXaDNOaDRrNFRsUGgxZ2ZTaE1pRURrTng3?=
 =?utf-8?B?dTBBRUpPaFcrand0aU9PZEF0YW90dDVSUnk2ZksvcjZxOE5TN2I5djFaOWxN?=
 =?utf-8?B?cXhkeHF3RTNWSm03Y2xQb3diYVg2bWVDNWZOeGVvU25ibTBHL04yN1BmZElm?=
 =?utf-8?B?SVQrZDhMajBoRlZFbUhLV1IwYUgyUlN4R2tiZEFuUzFjUW9mRG1vODRZNS90?=
 =?utf-8?B?bG1PK0VWYkhYM3RVTWMzbmZ2ZHpNVGwzWit0V0QyVmoyY0lpNndlSER5d0o3?=
 =?utf-8?B?UjNwLzdjRHBtbk56UzBKL1l1N3lFd2s3Q3JGZWNsNVQ3Q0I3RTM1MHdKcVB2?=
 =?utf-8?B?c3pRQm5XblVQY1J5QW1sam1uUVZxbGViK3lMaW00YzNoMFFmb2huS2RwRFlW?=
 =?utf-8?B?VkJCVW9sTVhhZFlDWHpvekVEQ1RXZlFyN3lXUUJGZEN3NGhyQUM4aUJqbHpt?=
 =?utf-8?B?YXZOaU1EUFdRWVlZUzlmaW1sRE40Nnh1SXB6OU5sRk5tSmN4aFM5SkZpTC84?=
 =?utf-8?B?b3RpNHRVNFVOT2JDNmtVZzJWM2l5bXN2RkM3a2FWTkt6SlpBZnJSQlh5K0lY?=
 =?utf-8?B?Q0lnTVpUTG9zaDhWdHRmQThuZXdKeWllVkE4SGUvK0x1NHp6U3VPb29oWE5v?=
 =?utf-8?B?L3BteFlKVUpxelZHUXkvM1pTSFlRT3lpSGVjQTlVMGhRYjgxM242dHhFL2Zk?=
 =?utf-8?B?emhkdENLRy81RjFTZHVkMkhmY2lYVzJkbHBMWTRFUEN1clZEcU5KK3pkcHcv?=
 =?utf-8?B?LzJKVEhZTlpHN2d1MTJHV1BWeUZhYjFnMy84bnZ4dUUzYTZ4eFRETWl0ellZ?=
 =?utf-8?B?RjdCc0RRUGtkSlhkSWo4OUtsYXhkaHdxTTdDd3BlNEZ3NVBBcDJ2Z2xuN1RE?=
 =?utf-8?B?MmMwTGl6dHFHQjJBK0phblpOdDlNSFpCOVhtdVZSQUhUVk8rZkZEOWNiWkJC?=
 =?utf-8?B?WitlajdlY3ZrTElYZ2pUb0ZZQ1U4U3k3WDVqSU4zdXJObnQrUzJYV0tkcVp2?=
 =?utf-8?B?TS9pYXV1Vk1SbXlBVUh5QXc4NVd2a0ludFJvVWhrTzE2cU1pL1hUVytGcXNC?=
 =?utf-8?B?SWF1Y0lTdy9wVDk5eXlZTWRoTWp5SWNBV2VQanhDRjFrYkdlRERLdlRabkZV?=
 =?utf-8?B?VlBndkV4Qm1CQWNaRE10RFVkZytXeS9wRmd5Y0Z3ZG1YdzVMMFU0UTFDYlZC?=
 =?utf-8?B?RFQ0bkRZVlZCbVkwN3pmcGdLUUtOVWFoY0ZGeWlSRmxrYzVUT25CT1kwYnky?=
 =?utf-8?B?cjZ4SVV6OUVOMFdZUjJ5UFRRSXErVkxuR3QvWmtYYjFhTkdXdUJYY21PTFlK?=
 =?utf-8?B?L1B6em5UUytEQWE5azBpaEFHenozMmt4aFBQYVdRZm51T2h4Z2Q1bTBXVVEr?=
 =?utf-8?B?KzEwT1RKc0VRNFdFZ0VqL1h6S0t2V3JhNVRRMnBWOTZaME84V0gwN213TTJV?=
 =?utf-8?B?MkhvWWo2L3l5SEpwQXppaWxQa1hDMWcxR09wSnJLUmVHbWtyekdaZ0ZFUUhB?=
 =?utf-8?B?ODVPdDFxemRmOXRISFphblFIMmRDemdEUDNDRWhYQVZoRGY4dXloeE44QkVl?=
 =?utf-8?B?OXNHOTRTQ1J5SFBkRCs2ZVpFSllMTW9SQTlrSGxydVlwTys1M2tlcmowa1NF?=
 =?utf-8?B?VW5NQzluOXhBOVk0VFptZnBUSnI2QVk4UlI3a2dTY21OMVV4aG5ZaFJlUTI2?=
 =?utf-8?B?bE9tNjNVZWFMdWhPVHFIVm1wMUlZM3IwR1pjakt0RGhQYVU4YzNPblRJRXlV?=
 =?utf-8?B?QklESTFjNklhTFVNd0R3M2ZPSUdiaDhQdnlpbXR5OWFsSnp6RUlxcFNGSzll?=
 =?utf-8?B?dXU3RXEweUUzY2hicDU3WHVDWmxUaE1wQ3VvdkhYMTByaUdaQ1l1UnNOM295?=
 =?utf-8?B?RVFQN0tQVUtSTFdoTCsyditBWkE1b21qZmsrK0k1MVZBNnZjUkxRTGszSGxn?=
 =?utf-8?Q?6LxV2O9gmvA+Xgee777scLf4uLtLv4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEpLdVNOMWx6NlErSTkxdkVPNm5SV0NDeWtQNjd5YlZTMURqSnVtM1VacEhZ?=
 =?utf-8?B?am5USVpaN0g5UkNNRGUwd0dPTU0vNmh3TlhwNVl0U3k4dGxhM05NL2Fqemth?=
 =?utf-8?B?alBoRFBnaHpiZEtWeDYwWHBMRUFZRkVNNC8xbGRBNTIydzJoUE1adU4veTFM?=
 =?utf-8?B?YnhlSkVQakt3UUt2bEdnSlVlQlJLeXVtOEw2VDI2UGJ0ZVhZdGliKzhOaVkz?=
 =?utf-8?B?cDBFaHlCOVNZbXNqQW1kT1NOVEFLOFRYcitZRGZPbXZiTGpqQnZXcjR0STc5?=
 =?utf-8?B?TnFEVG5kdzN3VXZUN04xN2gvalhhOXNYajIxUTYycHlwSndTVVRpVU54OExH?=
 =?utf-8?B?YUJRQkt2RmFrcHErUUxnUE5IcFY1cmxyeUhQR0hJODRIUWczVnN2ODZFWCt4?=
 =?utf-8?B?TjZKdnhIcmVSNStBMFZidXVHaUt3VkxDbFd5RnlIZGNoTEQ5Q0ZEK2Z0UTJo?=
 =?utf-8?B?dlhQeWtHNWRheFNEODNWdnNNbTVhajJ2QWFpRm1Pd25jTWY0c1JmaE5VZGVN?=
 =?utf-8?B?Y05CYllWaHhzMTVWc0NiaTJ4K0hsNmNmZkdETVZYcnhFR1l5eldEZ3BnenBa?=
 =?utf-8?B?UkRIc2hFR1ZGWlM4ZHRkYzdrMEFlTmJ0dERmN0MxVFNZWkJibFlnNVQ2ZEZB?=
 =?utf-8?B?MmpXcGVpajh1L1U2aWE1L2dYMkQyMEw2TTZMTGZWRmVrMHA2UGRRZElCZUps?=
 =?utf-8?B?ODJyUDM2SERwaW8xRDdOTWxoZHdkOFpDQlRFbGRGK1N5aEhlZkgwR3hYT3NS?=
 =?utf-8?B?STJmMHJsVllrSFg1cjBDWXpCNWdmMVllVDJNZGhPcXFtL3A3YTBpL0M5b2Jl?=
 =?utf-8?B?RGptMmJGWE82QWZ4eThjUGI2M3JMallnYkxmRnU1TXJWSHZHUWQ3TVhHMTNq?=
 =?utf-8?B?VmtaR1NTK0F6bW8yRTkxQXA2enlDQXBMemIybUtNSjVpeUwvRUdYNDE5M3R4?=
 =?utf-8?B?UmpoREhWYkNDZkZhRFoyR3hmVmY1RTRobHVnOHhxYjFPQ2pHbi96VEtDVlBj?=
 =?utf-8?B?dkl3YnZHbGRpaGo2UndmaDRqNUhNMjlCV3hIR25GS1RiVTFBVUhlRUlOejVU?=
 =?utf-8?B?WVRqc29MWUUwWUVRNTlONE9oUlJ0R09WM05tbnA1eC9vYkdVUE1ZQXF5TXdL?=
 =?utf-8?B?WHJpWGREaEZvQlZFNjFVd1dlV29CeFZSVEVHNVhuQ1M1WVFuT3o5TGVuZjlP?=
 =?utf-8?B?TXdkbUY0djlNVnI5SWFqZUljbUo2OWUxOThLVVdpektwWkF6RDRFQjV1Yndy?=
 =?utf-8?B?VjU3eWY5Z3ZwTUswNUZIRTRLcWF4Nzk1aW5ZcHdrSG9xUU5BTHllbVlyeUZB?=
 =?utf-8?B?V3p3dEVIYStMaUxvSzBHOGpvK1ZMVjVjalhvamdqYkRDTmpwL1ZMdnBIMyt0?=
 =?utf-8?B?M0EzMzFqSFZSdkMwRE00cGVWWEZOZGJZN2FMYWpCTmVmM2FjMkpkZm1qSHFz?=
 =?utf-8?B?QVdLVkRFa1hXci9vaUVJT0FRYmNmc2hSN2NodTNQS21ZUHdzSlJRTHRhZktM?=
 =?utf-8?B?dFZYTWgrNS9HUE1yekU1aXdSQ2p2M1lCWE5adVovOS9ETXNLcm9qeit3UjBx?=
 =?utf-8?B?b0RWR0txc3B2dW55SVFIYmFNUXpUZzNZdkppOXRCZGlOZjBWS1FCU0FEZlI2?=
 =?utf-8?B?RU5ORVlvVG9ZbXVIRHlYTXZqV25EZkxKNEQ2dFFpalFQZ1ZNM2hZemhLbzVz?=
 =?utf-8?B?cEZ1ZjVsYWw5ZkNGSUlXbEt2S08xK0tjd2NHTkZDUHk5M1lEZTRuM3BrNEZv?=
 =?utf-8?B?bm4xR2lQMHN4MW5PVEdlZ05rWWNJYmMrVXY5UUNZVDdsK2s0UENYckhYYzRp?=
 =?utf-8?B?TGtacXpsMzB4OXJFNG40eEFvMmtTNVVObjNWelAySHBBRlZoSEZjVzRBdDBy?=
 =?utf-8?B?cHNtdUg4bXBHc2p4QXc3SHZ6OXVTeHhRUjVIUWFUVDQvdmVNcEFvR2gxNmpo?=
 =?utf-8?B?OXBLLy80cGZSejZtdXhndTVuRllpdFovU0JnblJockN6VmxEREZTbVpIQUdS?=
 =?utf-8?B?VU0rWDBHQ3h1UkFzTy91eWw4RDJDRnVoM3B3L1cvRFhSMUIyZmp4VjZxS01N?=
 =?utf-8?B?YjdZMFRXSEpVUW5IL29udElSeU45Q1QyazVCMVl0V0RHaWZGdUFhZmhwMFZu?=
 =?utf-8?Q?lz0q1RMuflDJNfe7HMY96BsP6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C4A877006592D41A32EF97ACC755FFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0604c647-d63e-4219-3c0f-08ddd94467f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 02:03:18.1531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RV169IHS/FhQBO3MOrLez3q0wAgSQxadL0ICkNVAf+6Jt/IGm0xUCLuDGkLbHbQ9q8kJDyDz8g946PSM98VPuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8102
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDAxOjM0ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVHVlLCAyMDI1LTA4LTEyIGF0IDAxOjMyICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+ID4gc2NfcmV0cnkoKSBpcyB0aGUgb25seSBvbmUgd2l0aCBhIGhpbnQgb2Ygd2hhdCBp
cyBkaWZmZXJlbnQgYWJvdXQgaXQsIGJ1dCBpdA0KPiA+ID4gcmFuZG9tbHkgdXNlcyBzYyBhYmJy
ZXZpYXRpb24gaW5zdGVhZCBvZiBzZWFtY2FsbC4gVGhhdCBpcyBhbiBleGlzdGluZw0KPiA+ID4g
dGhpbmcuDQo+ID4gPiBCdXQgdGhlIGFkZGl0aW9uYWwgb25lIHNob3VsZCBiZSBuYW1lZCB3aXRo
IHNvbWV0aGluZyBhYm91dCB0aGUgY2FjaGUgcGFydA0KPiA+ID4gdGhhdA0KPiA+ID4gaXQgZG9l
cywgbGlrZSBzZWFtY2FsbF9kaXJ0eV9jYWNoZSgpIG9yIHNvbWV0aGluZy4gImRvX3NlYW1jYWxs
KCkiIHRlbGxzIHRoZQ0KPiA+ID4gcmVhZGVyIG5vdGhpbmcuDQo+ID4gDQo+ID4gT0suIEknbGwg
Y2hhbmdlIGRvX3NlYW1jYWxsKCkgdG8gc2VhbWNhbGxfZGlydHlfY2FjaGUoKS4NCj4gPiANCj4g
PiBJcyB0aGVyZSBhbnl0aGluZyBlbHNlIEkgY2FuIGltcHJvdmU/wqAgT3RoZXJ3aXNlIEkgcGxh
biB0byBzZW5kIG91dCB2Ng0KPiA+IHNvb24uDQo+IA0KPiBJIGRvIHRoaW5rIHdlIHNob3VsZCBs
b29rIGF0IGltcHJvdmluZyB0aGUgc3RhY2sgb2Ygc2VhbWNhbGwgaGVscGVycy7CoA0KPiANCg0K
QWdyZWVkLg0KDQo+IEJ1dA0KPiBvdGhlcndpc2UsIHBsZWFzZSBhZGQ6DQo+IA0KPiBSZXZpZXdl
ZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3aXRoIHRo
ZSBuYW1lIGNoYW5nZS4NCg0KVGhhbmtzLg0K

