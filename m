Return-Path: <kvm+bounces-51245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E6CAF08FB
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 192361C06EAF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B290C145FE8;
	Wed,  2 Jul 2025 03:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dGG818ZN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33C1BEF8C;
	Wed,  2 Jul 2025 03:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751425622; cv=fail; b=ZlRpNJy49SNzAnCY95nDhMj/GeP018s+ekkWLDplzvb/6Bv7BFDO8PNgxqJr5lmiZyPbOG3TLde/NETfwSkxAHyBYWgWHaP0ABY4EGRJg6rITNpzDhKTHKFRthn9noAh3mNXHbUKMfXHewp1B/vzUpmTPcck2iPSiJ3umr3bmYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751425622; c=relaxed/simple;
	bh=gG2dC9GZgMCCWdRgu21FxLVZapC7gtyvWKQ4SUihAlk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iJiuJMkXTDLwWMxsail2d1BCcTjg1ExBhsfbKyHcUATi+E5Dm6eNMjcXBtdyzGzv7ldeIO0HEBKtnWy/0uYD8GIqXdVskYh1JCy8LmbTjKsgxk1mMrTdLnBm0T4TK+czAuVLGG+Df9DyAryENQEypuCqiaP0B/fd01oniDSXTTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dGG818ZN; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751425621; x=1782961621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gG2dC9GZgMCCWdRgu21FxLVZapC7gtyvWKQ4SUihAlk=;
  b=dGG818ZN6P3Kk48UzdyBu3cB2AQLc0iGVsMJ4sWlWmVGiqt/cAQWONKI
   hjlkvNKG0BPChEMw1+9HJACY1YY20tRxvplDvrlbHDQsiMO+C23kITeZr
   jblSrDtGDj01AZVwT0ZpPmuYVmMZZtdEH0P258NUVfFedbBe9urZ6RIfa
   AxMtyA1njD3WZKKnHz5OOwYmY8/M+egFD6SeahuEuS55AIbsBpEH+xeoJ
   QL0POr26bDGahRoueMSlJsMssjDYQcv1tjUwbIc+hhQS2GKTEZe3zjoWQ
   xsOyX3WkfryuxnhD8iXH+FNcTUKCE8Tt6X1A9tYC+Fv4InLEq528Suu27
   A==;
X-CSE-ConnectionGUID: k/oZAm1fR5KIbH4FILYjlw==
X-CSE-MsgGUID: w7XDFX3FTYGSMOTDaq7W4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="71133043"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="71133043"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:07:00 -0700
X-CSE-ConnectionGUID: n8jK9R8SQkmp6mBlYTqh6A==
X-CSE-MsgGUID: ki9BXWAaQCO89LcpXBYORw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="153408174"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:07:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:06:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 20:06:59 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fi333d3ZNIV0i98GlvYK+v8nByyPSgnEw/IO1TIc4Hok4Y5JYgdCESYnVrhPvtn9twoFOFBTZ8yjQZTRBZPd6TX4zzIviGj2m/mFQX2fdNjIVUEE6jkFi2SphTR2x+/e8DwUTxkdQoe8BRo9KkBztyb/qnx4AY8p2fUaC0EZ1LRWQ2Mth7mc0CPfGQRgiTqrUIWCPjJR6NS7HJ+VLuEG+x58jk4VIlN5nXgOhgI5yypMjMsiqoZK+KDMSAb/a+H/C8C4x28soNrV97LrTFJZSvG4J3ieKAS/PFqBbNend38zp5q6UisJGLphDi9WZ2dZFvcj/CU1pQ63JA8f6Eq3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gG2dC9GZgMCCWdRgu21FxLVZapC7gtyvWKQ4SUihAlk=;
 b=Bm3i2TyRXBlzXneYLXd0abFvjZxUieO+aRFltlACpz3MS59mH8jU1zTa0h+z1P2R7JzpzlYsUBgokNfjwFwJx+GVcQ7bVZCCHXO0xROBmOgB/2fH9IbgEDUTNXRm4BMa3/p4PauvlV7CCRf5tJsZTdDS0aB+WmNHfD76SL1H+GnOh2OX+CMZsUdOIITfytgFYXyQiEACUH44fmTpOGs/oPIGUvH0IiM7JzIGWlqmacJYMOXe2tkrDf1iEgZhFyoOBnLeUcOFqDdZMcYPwyrLUaUkVdA6P0wZNlgCzEArF0buB0lAMx1ZVlIyKk8yQn9l9qQDlpV45C7r85NPnv5v6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW3PR11MB4716.namprd11.prod.outlook.com (2603:10b6:303:53::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Wed, 2 Jul
 2025 03:06:43 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 03:06:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQYiUSAgAMPkYCAAZzkAIAA+eGA
Date: Wed, 2 Jul 2025 03:06:43 +0000
Message-ID: <89d3000e7a4bd4947080607038a89a4e5c38234b.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
	 <e7d539757247e603e0e5511d1e26bfcd58d308d1.camel@intel.com>
	 <20250701121218.GBaGPQold6Kw2M-nuc@fat_crate.local>
In-Reply-To: <20250701121218.GBaGPQold6Kw2M-nuc@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW3PR11MB4716:EE_
x-ms-office365-filtering-correlation-id: 20a7647e-db74-416b-e100-08ddb915790e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NjJBSG1KU21GMEtybUN0RXN1b2RKWmZ4cnJRbDJ5RUNRYW40RndhciszelJO?=
 =?utf-8?B?c0JnTXE5aUtwMW1vN011cHVHTFFOZmN3cG93Sk1EYXYrY1gxbys2NGRkNk9J?=
 =?utf-8?B?Z0pZSzNVS0tncFlHMkEvR2FCOWlXSGZJWStJY0VjKzZqQmthSk5ZSjU4LzU2?=
 =?utf-8?B?QlBGOW05YURUSzBEK3FoWHc3NXdJbDFSREE2MHFjaGJ4Q2FLblNudldLQXJY?=
 =?utf-8?B?eExPc3VUWGZzdmZNenBEamtCcjNXRUFDY3lRS0pVa1RpaW0rd3BVZVQ2Zytp?=
 =?utf-8?B?dy9PV1FaM1E4NkJvbjljM3M0amx4S1Q2dGFCaXBFc2hhcmlTSXlINVZaemd0?=
 =?utf-8?B?RkkxazFPVGlqczVXMHI3dXdJWmdFa1Y1Wk9mZndPSDVHNXhQZTVWdm9Pd1Nq?=
 =?utf-8?B?akJYbEt1ZTkwNXYzOUovT0VtcDJiVHZVQzJKY0o5RXNmZU54bG1hV2NEYWpU?=
 =?utf-8?B?RkpBYkE5T0IvRGdaVWZJWFBXRVQrLzR1UWZZcE1pSjhUMkYzMFV4SXJtbEVr?=
 =?utf-8?B?K0hlS3ZTR3laVlRuMDNrZFFQLzFzTG9GcjZRMEJOVTJKZm9FbG5idm9ZZE12?=
 =?utf-8?B?YktQMEluakxzcE51dXhsdGsrZlJQY0d4VkRiQUhUQjdTczAwREMyZEo0Mnkx?=
 =?utf-8?B?MUtNWjd6L0gzN2dyUzBudUtJUWIzMlFITkdsVHcva0ozdzN0RlVWU2pacjdX?=
 =?utf-8?B?ZnBCVWI4bWJqSEdjMEVRTUZPMGRFRHoyKytzem5NYms1SkFsM1pDNlpRcjVa?=
 =?utf-8?B?WU9hTi9HUW9EV1FiOVhJc2UreEs2cWJnU1NqS2VxalNtVmxjK2lIaHV6cGRQ?=
 =?utf-8?B?c0FUZ2tVSXNuNlRlc0MwaC95SDI3RE43bkk1WGZncUZmMG5aZVRsYnhjM0hM?=
 =?utf-8?B?RGVsK1pzZ291MnJYQ0FNMGVPc0J3Z2JyQ1FNTXE3Y3Zncjd6bDluaVR6SnBa?=
 =?utf-8?B?dURSNE40NGRGS0dzU1BkcTNkYjN6MXMxN2ZEdTJxcGNPZzdKbGJyVVdjN1Rn?=
 =?utf-8?B?NmVYUjIzWTRIT285OXNhVUY4S0RIcEtvNHE3TzUwaWN1T0V5Wng0QkdGU0FC?=
 =?utf-8?B?Y09NbXBURUlSb3BOYlVyYlNaVTJlTjJndzlTZkFubDloeXluYUZtY0hkRW5V?=
 =?utf-8?B?Z3pXMFNiTEE5T2d3QW9hUXVXR1d5MnBRZFptSG9SYUxhQXdZY0hOYWxRNzBh?=
 =?utf-8?B?TWdlamVqNWEzNnFiaDZEQkU1aXFTQ0I2TFBsK29TUXNYWUwyUVRhNlhnNWM1?=
 =?utf-8?B?b3JuQUluRzVRZUJ4clFQYndnM1VQcmlqVlRMZ01VVVo0Y0xhc0p0ZG9aaXhP?=
 =?utf-8?B?Nkl5MXptK0hHRTVsWGh2RENmYUJSQ2JJQ25BYTc1L1VPV2h5V3UzQWUyYVlw?=
 =?utf-8?B?dDRKaXZFeHIyWGQyWTdUUHh5c3RLOVAwRURkRTE1cVJGdHREeFRwUlJEb3JE?=
 =?utf-8?B?SmVac3lMWVZTbmVLNkRwV25JajJBcEMxRlhNVVVHU25CaTluZ0YyWU10elcx?=
 =?utf-8?B?cGxsdklpQkVaMW4xekNhTVJ2dnplR2krZy9KMlkrY215dm9SSUxkcDNLM1ha?=
 =?utf-8?B?aWg1YndIT01NRHhkYmZQQXlRTjA5Wm1HSHQ0TzdVL0FYQk9GYVNxVjV0YUlI?=
 =?utf-8?B?aTJuZk1rdzdMcUs5Ui9ZT1R0UE83VHp0bHpoakdZMW5IWjBtUnh3dE42VFB5?=
 =?utf-8?B?eWVGVXFjTzlZNzVycjJVTlY4WCsrSzNBejY2MllJSzJTSWlveTV4djhjUWNs?=
 =?utf-8?B?SE9XMktXWG16TGtZdnBSTEZxeGNETWVYVWd3YVdtazQ2YnFJWkVNWHhXU0sv?=
 =?utf-8?B?S2VCaHR6Z2YxTUp2WGx5T1U0MjZsMnFGYWN5VnZqbHdRTlc1UG5iMkVoTnBy?=
 =?utf-8?B?OUJTR3EyR00wUEFLbkJ5aUdQNUVQN2RxbnA5bUl0bFVSWUFPOWEycEhEUkt0?=
 =?utf-8?B?S0orQ0JucFcwRDdxTUcyeW1IZzBHT3ZHMzFjRndGTVFlT0ZJM1hzTk9RYTVr?=
 =?utf-8?B?VnAyMjRGYjR3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkptUUZJK25DTkxEVVJsb1pBeGplMFdJc1hibGMrNGk1b2JtbDRDSHlDUVR5?=
 =?utf-8?B?REd3MHFBTU56RjVlTGZmN0phN0hxZVAxM1FCSkVyV3EzRnlIcmw1ZDFnejE0?=
 =?utf-8?B?OWpGNzhJZS81VU1va1BjdzIzb1pvbDBOOGRUS0lsSXBRZzM0MXNwcUVkM1pj?=
 =?utf-8?B?cE15cTd4VTREWndmMi9VMCtiNXFVY2V2ZHl4amIraFcwbS9ldjNsY1laekNI?=
 =?utf-8?B?bTRlWHRTa2sremsrR2prQkYyTWRURjZWOHhrVWtiVnZuaW5kMUNQSFlacGdz?=
 =?utf-8?B?T2VnS3c1WFBlNWs0UHhuTStPWTV2K1NnQmM0cDB1eDMvV0t1K3VuMjA1YnRN?=
 =?utf-8?B?RXgzNlBpaU4rd2ZhcXlIWFlHSWdoU3hXRVZOQ2tFb3lIVE9QbHMrT3JRMFcr?=
 =?utf-8?B?cUxFRlBHVzZKL0tGcTRxMjk0MVdHSmkyMVNVdkZqeFlSbEtFdU9IU3pqR3dC?=
 =?utf-8?B?WHc5QUt2bkZ2WlBrbThRdU9qSU42YzUrV1d0amVrSjUvVGxiNWJ6WjhkRVVV?=
 =?utf-8?B?QklYVVg4ME5CbzQ4ZkttelpNREJpWGUwc2loZ1lCVHdjeUdUdEZ5TEdEeS9w?=
 =?utf-8?B?ZHRCRWk5Y01iTDRwTlh5RG1abjZjVFZ0Y1FEbndEN2FpREw1YWRxVzJzNmZT?=
 =?utf-8?B?Z25qaWFOT2c5VkJtNHovUFZDVnRTSWdyN2d2Wkx2UUJWSlZWRmQ2RTZqaVZo?=
 =?utf-8?B?cGo5TmtpSVJrUVVIMWJvdmpTamRYRDZIcnNyVHB0WllncjdyT096bU9UZ2tr?=
 =?utf-8?B?ZnB1SmExWk0wMXRjUUJZTHF4bW5LQzZPUS84eGphWGJ5VnE2T1F3cGovVjBj?=
 =?utf-8?B?Y0lrNUdFMFFrN3dkOXUwNWFPeGFWc1BNaXRFU01vUVkralVsZlUySHgvL0tj?=
 =?utf-8?B?RWo5dHNlMktEdzI5MWpYVGVOdUdiQWxwclFxN3BHb1cyK0xMM0N1bWxuekRo?=
 =?utf-8?B?ZllIY3ZGaTM5WVZpd090NW5XSjJrbGhleXNIRGpkL3N1YXl6R21VLzVENit0?=
 =?utf-8?B?WjZGWXl6dnpqMFczdVk5RnovdmtHOUp0UXZHNlpxVmpmZkNZWm9RNUxsdHlt?=
 =?utf-8?B?QnNXUkR6TmJaSk9jQzRLZ1F0cUgraEY0TU0yR1A1U0ltYTdLYkNqSE45MGRh?=
 =?utf-8?B?UFQ2bWlhU0hYTmlVandpVFljdms4aCtFUmgybFVyd0dWVHBiZmQ4NUhkT1Nu?=
 =?utf-8?B?WSthVzFpVDJuZHF3a0N0bzI1VjZKR3pqN1o0eHVvbGNYbjdZblN6NWRFbVFx?=
 =?utf-8?B?SGlNRGtqS2ZBamNhcnpsRzZnWXN1VFJONHhHWHpNTEVtMnVGWVprV0pVK3I1?=
 =?utf-8?B?UUUyYWFBWkpndjExU2ZiYXlqM1dVZFhXM3JSUS95YW1OUlk3YmUyMTJxWWM0?=
 =?utf-8?B?akhDeU1NVFRaS0F5by81Vkg4d2J4MWM2L1hESDFKMlZwZlQ2dlhaQ1pwL285?=
 =?utf-8?B?TitiVWljSFl1RzFmaXhzeUU5dUo2NjVzY1p4TUVaYkdQemU1UzNlb0RWMVRD?=
 =?utf-8?B?ZDFtaktMRkJXL3RJaEdFQWN4a0FDblJ5RldtM3FmR0JIR2FSR3owMjZCSnll?=
 =?utf-8?B?M0FqN2N1KzlZaHg0dGgzaWtjVFNMb0tEQmNudm5kMGFnZzdzZFBLeld0V1h3?=
 =?utf-8?B?ZnlLT0lrRk1Ga0EzN1hQSzZSMVI4Mkh4bW92V2tsUkQxdWEyRndhZzhHclJi?=
 =?utf-8?B?ZDBqbzRJUHpic1BqZithQ3pCTEJCN1lPay9lTG5XMGNvUFNuNzBoTGNrVExw?=
 =?utf-8?B?Q0VwdW5QcVorYTJKcDJYbno2eTd2akJJZVh4LzgrSURjbzZDb21xdHgvUy9u?=
 =?utf-8?B?L2V2MmU5Ynh1amZ4TEZ4SWk1OVBhdXBya2txaGdLOFdyZWZwVjhtdkhtTHY5?=
 =?utf-8?B?NklPMlZUWVJrWTlzMmYzZ3FZNmtpL1VZeStPWURoUTI4Yno0VTRVdzBSSWRH?=
 =?utf-8?B?NFBUeUtYUEYyY3VCbXdPcG1LYVJlWVZaeisvS2FhTlZvZittcU9OcnJtYlJ1?=
 =?utf-8?B?OVhnbDRub09jK2JWc2dRbzBmWWdVUFdxS3lPYWt1cUVLbFNtZlpubW1ETW5B?=
 =?utf-8?B?UVVBMm83WUFsbUsvcHNLL1ZtMTVzLzNFSjVDTlNDN0QxbGRuRlg5cnFuTGRL?=
 =?utf-8?Q?e1uFeBE2NsVYEuZM/AzMAHR24?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC661B4EB4834845B50605B18C614197@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a7647e-db74-416b-e100-08ddb915790e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 03:06:43.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmULMr7SHTDihlTH1s4rjP7J9MkfCR/m1bXLC1sHTkwV/pgmES5KWmY9ztJo8DnYrsuBOfKrMfClKCLJN96sFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4716
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDE0OjEyICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIE1vbiwgSnVuIDMwLCAyMDI1IGF0IDExOjM0OjM0QU0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gWWVhaCBJIGFncmVlIHRoZSB0ZXh0IGNhbiBiZSBpbXByb3ZlZC4gIEkgdHJp
ZWQgdG8gcnVuIEFJIHRvIHNpbXBsaWZ5IGJ1dCBzbw0KPiA+IGZhciBJIGFtIG5vdCBxdWl0ZSBo
YXBweSBhYm91dCB0aGUgcmVzdWx0IHlldC4gIEknbGwgdHJ5IG1vcmUuDQo+IA0KPiBBc2sgaXQg
dG8gc2ltcGxpZnkgaXQuIEkgZ2V0IGl0IHRoYXQgeW91IHdhbnQgdG8gYmUgZXhoYXVzdGl2ZSBp
biB5b3VyIGNvbW1pdA0KPiBtZXNzYWdlIGJ1dCB0aGVyZSByZWFsbHkgaXMgc3VjaCB0aGluZyBh
cyB0b28gbXVjaCB0ZXh0Lg0KPiANCj4gVGhpbmsgb2YgaXQgdGhpcyB3YXk6IGlzIHRoZSB0ZXh0
IEknbSB3cml0aW5nIG9wdGltYWwgd2hlbiBhbnlvbmUgbmVlZHMgdG8NCj4gcmVhZCBpdCBpbiB0
aGUgZnV0dXJlIHRvIGtub3cgd2h5IGEgY2hhbmdlIGhhcyBiZWVuIGRvbmUuIElmIG5vdCwgdHJ5
IHRvIG1ha2UNCj4gaXQgc28uDQoNClllYWggdGhpcyBpcyBhIGdvb2QgcG9pbnQuICBUaGFua3Mg
Zm9yIHRoYXQuDQoNCkFmdGVyIHdvcmtpbmcgd2l0aCBBSSBJIGNhbWUgdXAgd2l0aCBiZWxvdyBb
Kl0uICBCYXNpY2FsbHkgSToNCg0KIC0gQWRkZWQgYSAiVEw6RFIiIGZvciBxdWljayByZWFkLCBh
bmQgYnJva2UgdGhlIHRleHQgaW50byBkaWZmZXJlbnQNCnNlY3Rpb25zIChlLmcuLCAiQmFja2dy
b3VuZCIgLi4pIHNvIGl0IGNhbiBiZSByZWFkIG1vcmUgZWFzaWx5Ow0KIC0gUmVtb3ZlZCBzb21l
IHRyaXZpYWwgdGhpbmdzIChlLmcuLCB0aGUgcGFyYWdyYXBoIHRvIGV4cGxhaW4gYSBjb21tZW50
DQpjaGFuZ2UgYXJvdW5kICdjYWxsIGRlcHRoIHRyYWNraW5nJyk7DQogLSBTaW1wbGlmaWVkIHRo
ZSAicmFjZSIgZGVzY3JpcHRpb247DQogLSBTaW1wbGlmaWVkIHNvbWUgd29yZGluZyB0byBtYWtl
IHNlbnRlbmNlIHNob3J0ZXIuDQoNCkkgYXBwcmVjaWF0ZSBpZiB5b3UgY2FuIGhlbHAgdG8gc2Vl
IHdoZXRoZXIgaXQgaXMgT0suDQoNCkJ0dywgaWYgd2UgcmVtb3ZlIHRoZSAicmFjZSIgZGVzY3Jp
cHRpb24sIGl0IGNvdWxkIGJlIHRyaW1tZWQgZG93biB0byBoYWxmLA0KYnV0IEkgdGhvdWdodCBp
dCBjb3VsZCBiZSBzdGlsbCB2YWx1YWJsZSB0aGVyZSBqdXN0IGluIGNhc2Ugc29tZW9uZSB3YW50
cyB0bw0KcmVhZCBpdCB5ZWFycyBsYXRlci4NCg0KPiANCj4gPiBZZWFoIEkgYWdyZWUgYSBzaW5n
bGUgdTMyICsgZmxhZ3MgaXMgYmV0dGVyLiAgSG93ZXZlciB0aGlzIGlzIHRoZSBwcm9ibGVtIGlu
DQo+ID4gdGhlIGV4aXN0aW5nIGNvZGUgKHRoaXMgcGF0Y2ggb25seSBkb2VzIHJlbmFtaW5nKS4N
Cj4gPiANCj4gPiBJIHRoaW5rIEkgY2FuIGNvbWUgdXAgd2l0aCBhIHBhdGNoIHRvIGNsZWFuIHRo
aXMgdXAgYW5kIHB1dCBpdCBhcyB0aGUgZmlyc3QNCj4gPiBwYXRjaCBvZiB0aGlzIHNlcmllcywg
b3IgSSBjYW4gZG8gYSBwYXRjaCB0byBjbGVhbiB0aGlzIHVwIGFmdGVyIHRoaXMgc2VyaWVzDQo+
ID4gKGVpdGhlciB0b2dldGhlciB3aXRoIHRoaXMgc2VyaWVzLCBvciBzZXBhcmF0ZWx5IGF0IGEg
bGF0ZXIgdGltZSkuICBXaGljaA0KPiA+IHdheSBkbyB5b3UgcHJlZmVyPw0KPiANCj4gQ2xlYW4g
dXBzIGdvIGZpcnN0LCBzbyB5ZWFoLCBwbGVhc2UgZG8gYSBjbGVhbnVwIHByZS1wYXRjaC4NCg0K
U3VyZSB3aWxsIGRvLiAgVGhhbmtzLg0KDQo+IA0KPiA+ICAgLyoNCj4gPiAgICAqIFRoZSBjYWNo
ZSBtYXkgYmUgaW4gYW4gaW5jb2hlcmVudCBzdGF0ZSAoZS5nLiwgZHVlIHRvIG1lbW9yecKgDQo+
ID4gICAgKiBlbmNyeXB0aW9uKSBhbmQgbmVlZHMgZmx1c2hpbmcgZHVyaW5nIGtleGVjLg0KPiA+
ICAgICovDQo+IA0KPiBCZXR0ZXIgdGhhbiBub3RoaW5nLiBJJ2QgdHJ5IHRvIGV4cGxhaW4gd2l0
aCAxLTIgc2VudGVuY2VzIHdoYXQgY2FuIGhhcHBlbiBkdWUNCj4gdG8gbWVtb3J5IGVuY3J5cHRp
b24gYW5kIHdoeSBjYWNoZSBpbnZhbGlkYXRpb24gaXMgcmVxdWlyZWQuIFNvIHRoYXQgdGhlDQo+
IGNvbW1lbnQgaXMgc3RhbmRhbG9uZSBhbmQgaXMgbm90IHNlbmRpbmcgeW91IG9uIGEgd2lsZCBn
b29zZSBjaGFzaW5nIHJpZGUuDQoNClllYWggYWdyZWUgd2l0aCB0aGUgY29tbWVudCBiZWluZyBz
dGFuZGFsb25lLiAgSG93IGFib3V0IGJlbG93Pw0KDQovKg0KICogVGhlIGNhY2hlIG1heSBiZSBp
biBhbiBpbmNvaGVyZW50IHN0YXRlIGFuZCBuZWVkcyBmbHVzaGluZyBkdXJpbmcga2V4ZWMuDQog
KiBFLmcuLCBvbiBTTUUvVERYIHBsYXRmb3JtcywgZGlydHkgY2FjaGVsaW5lIGFsaWFzZXMgd2l0
aCBhbmQgd2l0aG91dA0KICogZW5jcnlwdGlvbiBiaXQocykgY2FuIGNvZXhpc3QgYW5kIHRoZSBj
YWNoZSBuZWVkcyB0byBiZSBmbHVzaGVkIGJlZm9yZQ0KICogYm9vdGluZyB0byB0aGUgbmV3IGtl
cm5lbCB0byBhdm9pZCB0aGUgc2lsZW50IG1lbW9yeSBjb3JydXB0aW9uIGR1ZSB0bw0KICogZGly
dHkgY2FjaGVsaW5lcyB3aXRoIGRpZmZlcmVudCBlbmNyeXB0aW9uIHByb3BlcnR5IGJlaW5nIHdy
aXR0ZW4gYmFjaw0KICogdG8gdGhlIG1lbW9yeS4NCiAqLw0KDQo+IA0KPiA+IElJVUMgdGhlIFg4
Nl9GRUFUVVJFX1NNRSBjb3VsZCBiZSBjbGVhcmVkIHZpYSAnY2xlYXJjcHVpZCcga2VybmVsIGNt
ZGxpbmUuDQo+ID4gDQo+ID4gUGxlYXNlIGFsc28gc2VlIG15IHJlcGx5IHRvIFRvbS4NCj4gDQo+
IEkga25vdyBidXQgd2UgaGF2ZSBuZXZlciBzYWlkIHRoYXQgY2xlYXJjcHVpZD0gc2hvdWxkIGJl
IHVzZWQgaW4gcHJvZHVjdGlvbi4NCg0KVGhhbmtzIGZvciB0aGUgaW5mby4NCg0KPiBJZiB5b3Ug
YnJlYWsgdGhlIGtlcm5lbCB1c2luZyBpdCwgeW91IGdldCB0byBrZWVwIHRoZSBwaWVjZXMuIGNs
ZWFyY3B1aWQ9DQo+IHRhaW50cyB0aGUga2VybmVsIGFuZCBzY3JlYW1zIGJsb29keSBtdXJkZXIu
IFNvIEknbSBub3QgdG9vIHdvcnJpZWQgYWJvdXQNCj4gdGhhdC4NCj4gDQo+IFdoYXQgaXMgbW9y
ZSByZWxldmFudCBpcyB0aGlzOg0KPiANCj4gIkkgZGlkIHZlcmlmeSB0aGF0IGJvb3Rpbmcgd2l0
aCBtZW1fZW5jcnlwdD1vZmYgd2lsbCBzdGFydCB3aXRoDQo+IFg4Nl9GRUFUVVJFX1NNRSBzZXQs
IHRoZSBCU1Agd2lsbCBjbGVhciBpdCBhbmQgdGhlbiBhbGwgQVBzIHdpbGwgbm90IHNlZQ0KPiBp
dCBzZXQgYWZ0ZXIgdGhhdC4iDQo+IA0KPiB3aGljaCBzaG91bGQgYmUgcHV0IHRoZXJlIGluIHRo
ZSBjb21tZW50Lg0KDQpZZWFoIGFncmVlZC4gIEkgcmVhZCB0aGUgY29kZSBhZ2FpbiBhbmQgeWVh
aCBUb20gaXMgcmlnaHQgOi0pDQoNCkkgZGlkbid0IHdhbnQgdG8gZW5kIHVwIHdpdGggcmV3cml0
aW5nIHRoZSBvcmlnaW5hbCBjb21tZW50IHNvIEkgY2FtZSB1cA0Kd2l0aCBiZWxvdzoNCg0KICAg
ICAgICAvKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAg
ICAgICAgICogTWFyayB1c2luZyBXQklOVkQgaXMgbmVlZGVkIGR1cmluZyBrZXhlYyBvbiBwcm9j
ZXNzb3JzIHRoYXQgICAgIA0KICAgICAgICAgKiBzdXBwb3J0IFNNRS4gVGhpcyBwcm92aWRlcyBz
dXBwb3J0IGZvciBwZXJmb3JtaW5nIGEgc3VjY2Vzc2Z1bA0KICAgICAgICAgKiBrZXhlYyB3aGVu
IGdvaW5nIGZyb20gU01FIGluYWN0aXZlIHRvIFNNRSBhY3RpdmUgKG9yIHZpY2UtdmVyc2EpLg0K
ICAgICAgICAgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgDQogICAgICAgICAqIFRoZSBjYWNoZSBtdXN0IGJlIGNsZWFyZWQgc28gdGhhdCBp
ZiB0aGVyZSBhcmUgZW50cmllcyB3aXRoIHRoZSANCiAgICAgICAgICogc2FtZSBwaHlzaWNhbCBh
ZGRyZXNzLCBib3RoIHdpdGggYW5kIHdpdGhvdXQgdGhlIGVuY3J5cHRpb24gYml0LA0KICAgICAg
ICAgKiB0aGV5IGRvbid0IHJhY2UgZWFjaCBvdGhlciB3aGVuIGZsdXNoZWQgYW5kIHBvdGVudGlh
bGx5IGVuZCB1cA0KICAgICAgICAgKiB3aXRoIHRoZSB3cm9uZyBlbnRyeSBiZWluZyBjb21taXR0
ZWQgdG8gbWVtb3J5LiAgICAgICAgICAgICAgICAgDQogICAgICAgICAqICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAg
ICogVGVzdCB0aGUgQ1BVSUQgYml0IGRpcmVjdGx5IGJlY2F1c2Ugd2l0aCBtZW1fZW5jcnlwdD1v
ZmYgdGhlICAgIA0KICAgICAgICAgKiBCU1Agd2lsbCBjbGVhciB0aGUgWDg2X0ZFQVRVUkVfU01F
IGJpdCBhbmQgdGhlIEFQcyB3aWxsIG5vdCAgICAgDQogICAgICAgICAqIHNlZSBpdCBzZXQgYWZ0
ZXIgdGhhdC4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAg
Ki8NCg0KRG9lcyB0aGlzIGxvb2sgZ29vZCB0byB5b3U/DQoNCg0KWypdIFRoZSB1cGRhdGVkIGNo
YW5nZWxvZzoNCg0KVEw7RFI6DQoNClVzZSBhIHBlcmNwdSBib29sZWFuIHRvIGNvbnRyb2wgd2hl
dGhlciB0byBwZXJmb3JtIFdCSU5WRCB0byB1bmlmeSBjYWNoZQ0KZmx1c2hpbmcgdGhhdCBpcyBu
ZWVkZWQgZHVyaW5nIGtleGVjIGR1ZSB0byBtZW1vcnkgZW5jcnlwdGlvbiBmb3IgYm90aA0KU01F
IGFuZCBURFgsIGFuZCBzd2l0Y2ggU01FIHRvIHVzZSB0aGUgYm9vbGVhbi4NCg0KLS0tIEJhY2tn
cm91bmQgLS0tDQoNCk9uIFNNRSBwbGF0Zm9ybXMsIGRpcnR5IGNhY2hlbGluZSBhbGlhc2VzIHdp
dGggYW5kIHdpdGhvdXQgZW5jcnlwdGlvbg0KYml0IGNhbiBjb2V4aXN0LCBhbmQgdGhlIENQVSBj
YW4gZmx1c2ggdGhlbSBiYWNrIHRvIG1lbW9yeSBpbiByYW5kb20NCm9yZGVyLiAgRHVyaW5nIGtl
eGVjLCB0aGUgY2FjaGVzIG11c3QgYmUgZmx1c2hlZCBiZWZvcmUganVtcGluZyB0byB0aGUNCm5l
dyBrZXJuZWwgb3RoZXJ3aXNlIHRoZSBkaXJ0eSBjYWNoZWxpbmVzIGNvdWxkIHNpbGVudGx5IGNv
cnJ1cHQgdGhlDQptZW1vcnkgdXNlZCBieSB0aGUgbmV3IGtlcm5lbCBkdWUgdG8gZGlmZmVyZW50
IGVuY3J5cHRpb24gcHJvcGVydHkuDQoNClREWCBhbHNvIG5lZWRzIGEgY2FjaGUgZmx1c2ggZHVy
aW5nIGtleGVjIGZvciB0aGUgc2FtZSByZWFzb24uICBJdCB3b3VsZA0KYmUgZ29vZCB0byBoYXZl
IGEgZ2VuZXJpYyB3YXkgdG8gZmx1c2ggdGhlIGNhY2hlIGluc3RlYWQgb2Ygc2NhdHRlcmluZw0K
Y2hlY2tzIGZvciBlYWNoIGZlYXR1cmUgYWxsIGFyb3VuZC4NCg0KV2hlbiBTTUUgaXMgZW5hYmxl
ZCwgdGhlIGtlcm5lbCBiYXNpY2FsbHkgZW5jcnlwdHMgYWxsIG1lbW9yeSBpbmNsdWRpbmcNCnRo
ZSBrZXJuZWwgaXRzZWxmIGFuZCBhIHNpbXBsZSBtZW1vcnkgd3JpdGUgZnJvbSB0aGUga2VybmVs
IGNvdWxkIGRpcnR5DQpjYWNoZWxpbmVzLiAgQ3VycmVudGx5LCB0aGUga2VybmVsIHVzZXMgV0JJ
TlZEIHRvIGZsdXNoIHRoZSBjYWNoZSBmb3INClNNRSBkdXJpbmcga2V4ZWMgaW4gdHdvIHBsYWNl
czoNCg0KMSkgdGhlIG9uZSBpbiBzdG9wX3RoaXNfY3B1KCkgZm9yIGFsbCByZW1vdGUgQ1BVcyB3
aGVuIHRoZSBrZXhlYy1pbmcgQ1BVDQogICBzdG9wcyB0aGVtOw0KMikgdGhlIG9uZSBpbiB0aGUg
cmVsb2NhdGVfa2VybmVsKCkgd2hlcmUgdGhlIGtleGVjLWluZyBDUFUganVtcHMgdG8gdGhlDQog
ICBuZXcga2VybmVsLg0KDQotLS0gU29sdXRpb24gLS0tDQoNClVubGlrZSBTTUUsIFREWCBjYW4g
b25seSBkaXJ0eSBjYWNoZWxpbmVzIHdoZW4gaXQgaXMgdXNlZCAoaS5lLiwgd2hlbg0KU0VBTUNB
TExzIGFyZSBwZXJmb3JtZWQpLiAgU2luY2UgdGhlcmUgYXJlIG5vIG1vcmUgU0VBTUNBTExzIGFm
dGVyIHRoZQ0KYWZvcmVtZW50aW9uZWQgV0JJTlZEcywgbGV2ZXJhZ2UgdGhpcyBmb3IgVERYLg0K
DQpUbyB1bmlmeSB0aGUgYXBwcm9hY2ggZm9yIFNNRSBhbmQgVERYLCB1c2UgYSBwZXJjcHUgYm9v
bGVhbiB0byBpbmRpY2F0ZQ0KdGhlIGNhY2hlIG1heSBiZSBpbiBhbiBpbmNvaGVyZW50IHN0YXRl
IGFuZCBuZWVkcyBmbHVzaGluZyBkdXJpbmcga2V4ZWMsDQphbmQgc2V0IHRoZSBib29sZWFuIGZv
ciBTTUUuICBURFggY2FuIHRoZW4gbGV2ZXJhZ2UgaXQuDQoNCldoaWxlIFNNRSBjb3VsZCB1c2Ug
YSBnbG9iYWwgZmxhZyAoc2luY2UgaXQncyBlbmFibGVkIGF0IGVhcmx5IGJvb3QgYW5kDQplbmFi
bGVkIG9uIGFsbCBDUFVzKSwgdGhlIHBlcmNwdSBmbGFnIGZpdHMgVERYIGJldHRlcjoNCg0KVGhl
IHBlcmNwdSBmbGFnIGNhbiBiZSBzZXQgd2hlbiBhIENQVSBtYWtlcyBhIFNFQU1DQUxMLCBhbmQg
Y2xlYXJlZCB3aGVuDQphbm90aGVyIFdCSU5WRCBvbiB0aGUgQ1BVIG9idmlhdGVzIHRoZSBuZWVk
IGZvciBhIGtleGVjLXRpbWUgV0JJTlZELg0KU2F2aW5nIGtleGVjLXRpbWUgV0JJTlZEIGlzIHZh
bHVhYmxlLCBiZWNhdXNlIHRoZXJlIGlzIGFuIGV4aXN0aW5nDQpyYWNlWypdIHdoZXJlIGtleGVj
IGNvdWxkIHByb2NlZWQgd2hpbGUgYW5vdGhlciBDUFUgaXMgYWN0aXZlLiAgV0JJTlZEDQpjb3Vs
ZCBtYWtlIHRoaXMgcmFjZSB3b3JzZSwgc28gaXQncyB3b3J0aCBza2lwcGluZyBpdCB3aGVuIHBv
c3NpYmxlLg0KDQotLS0gU2lkZSBlZmZlY3QgdG8gU01FIC0tLQ0KDQpUb2RheSB0aGUgZmlyc3Qg
V0JJTlZEIGluIHRoZSBzdG9wX3RoaXNfY3B1KCkgaXMgcGVyZm9ybWVkIHdoZW4gU01FIGlzDQoq
c3VwcG9ydGVkKiBieSB0aGUgcGxhdGZvcm0sIGFuZCB0aGUgc2Vjb25kIFdCSU5WRCBpcyBkb25l
IGluDQpyZWxvY2F0ZV9rZXJuZWwoKSB3aGVuIFNNRSBpcyAqYWN0aXZhdGVkKiBieSB0aGUga2Vy
bmVsLiAgTWFrZSB0aGluZ3MNCnNpbXBsZSBieSBjaGFuZ2luZyB0byBkbyB0aGUgc2Vjb25kIFdC
SU5WRCB3aGVuIHRoZSBwbGF0Zm9ybSBzdXBwb3J0cw0KU01FLiAgVGhpcyBhbGxvd3MgdGhlIGtl
cm5lbCB0byBzaW1wbHkgdHVybiBvbiB0aGlzIHBlcmNwdSBib29sZWFuIHdoZW4NCmJyaW5naW5n
IHVwIGEgQ1BVIGJ5IGNoZWNraW5nIHdoZXRoZXIgdGhlIHBsYXRmb3JtIHN1cHBvcnRzIFNNRS4N
Cg0KTm8gb3RoZXIgZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQoNCi0tLSBNb3JlIFJlYWQg
LS0tDQoNClsqXSBUaGUgInJhY2UiIGluIG5hdGl2ZV9zdG9wX290aGVyX2NwdXMoKQ0KDQpDb21t
aXQNCg0KICAxZjVlN2ViNzg2OGU6ICgieDg2L3NtcDogTWFrZSBzdG9wX290aGVyX2NwdXMoKSBt
b3JlIHJvYnVzdCIpDQoNCmludHJvZHVjZWQgYSBuZXcgJ2NwdXNfc3RvcF9tYXNrJyB0byByZXNv
bHZlIGFuICJpbnRlcm1pdHRlbnQgbG9ja3VwcyBvbg0KcG93ZXJvZmYiIGlzc3VlIHdoaWNoIHdh
cyBjYXVzZWQgYnkgdGhlIFdCSU5WRCBpbiBzdG9wX3RoaXNfY3B1KCkuDQpTcGVjaWZpY2FsbHks
IHRoZSBuZXcgY3B1bWFzayByZXNvbHZlZCB0aGUgYmVsb3cgcHJvYmxlbSBtZW50aW9uZWQgaW4N
CnRoYXQgY29tbWl0Og0KDQogICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIENQVTENCg0KICAgICBzdG9wX290aGVyX2NwdXMoKQ0KICAgICAgIHNlbmRfSVBJcyhSRUJP
T1QpOyAgICAgICAgICAgICAgICAgICBzdG9wX3RoaXNfY3B1KCkNCiAgICAgICB3aGlsZSAobnVt
X29ubGluZV9jcHVzKCkgPiAxKTsgICAgICAgICBzZXRfb25saW5lKGZhbHNlKTsNCiAgICAgICBw
cm9jZWVkLi4uIC0+IGhhbmcNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB3YmludmQoKQ0KDQpXaGlsZSBpdCBmaXhlZCB0aGUgcmVwb3J0ZWQgaXNzdWUsIHRo
YXQgY29tbWl0IGV4cGxhaW5lZCB0aGUgbmV3IGNwdW1hc2sNCiJjYW5ub3QgcGx1ZyBhbGwgaG9s
ZXMgZWl0aGVyIiwgYW5kIHRoZXJlJ3MgYSAicmFjZSIgY291bGQgc3RpbGwgaGFwcGVuOg0KDQog
ICAgQ1BVIDAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBDUFUgMQ0KDQog
ICAgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpICAgICAgICAgICAgICAgICAgICBzdG9wX3RoaXNf
Y3B1KCkNCg0KICAgICAgICAvLyBzZW5kcyBSRUJPT1QgSVBJIHRvIHN0b3AgcmVtb3RlIENQVXMN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC4uLg0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgd2JpbnZkKCk7DQoN
CiAgICAgICAgLy8gd2FpdCB0aW1lc291dCwgdHJ5IE5NSQ0KICAgICAgICBpZiAoIWNwdW1hc2tf
ZW1wdHkoJmNwdXNfc3RvcF9tYXNrKSkgew0KICAgICAgICAgICAgICAgIGZvcl9lYWNoX2NwdShj
cHUsICZjcHVzX3N0b3BfbWFzaykgew0KDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAuLi4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGNwdW1hc2tfY2xlYXJfY3B1KGNwdSwNCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmNwdXNfc3RvcF9tYXNrKTsNCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhsdDsNCg0KICAg
ICAgICAgICAgICAgICAgICAgICAgLy8gc2VuZCBOTUkgICAgIC0tLT4NCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHdha2V1cCBmcm9tIGhsdCBhbmQgcnVu
DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdG9wX3Ro
aXNfY3B1KCk6DQoNCiAgICAgICAgICAgICAgICAgICAgICAgIC8vIFdBSVQgQ1BVcyBUTyBTVE9Q
DQogICAgICAgICAgICAgICAgICAgICAgICB3aGlsZSAoIWNwdW1hc2tfZW1wdHkoDQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJmNwdXNfc3RvcF9tYXNrKSAmJg0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAuLi4pDQogICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLi4uDQogICAgICAgICAgICAgICAgcHJv
Y2VlZCAuLi4gICAgICAgICAgICAgICAgICAgICB3YmludmQoKTsNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC4uLg0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgaGx0Ow0KDQpUaGUgIldBSVQgQ1BVcyBUTyBTVE9Q
IiBpcyBzdXBwb3NlZCB0byB3YWl0IHVudGlsIGFsbCByZW1vdGUgQ1BVcyBhcmUNCnN0b3BwZWQs
IGJ1dCBhY3R1YWxseSBpdCBxdWl0cyBpbW1lZGlhdGVseSBiZWNhdXNlIHRoZSByZW1vdGUgQ1BV
cyBoYXZlDQpiZWVuIGNsZWFyZWQgaW4gY3B1c19zdG9wX21hc2sgd2hlbiBzdG9wX3RoaXNfY3B1
KCkgaXMgY2FsbGVkIGZyb20gdGhlDQpSRUJPT1QgSVBJLg0KDQpEb2luZyBXQklOVkQgaW4gc3Rv
cF90aGlzX2NwdSgpIGNvdWxkIHBvdGVudGlhbGx5IGluY3JlYXNlIHRoZSBjaGFuY2UgdG8NCnRy
aWdnZXIgdGhlIGFib3ZlICJyYWNlIiBkZXNwaXRlIGl0J3Mgc3RpbGwgcmFyZSB0byBoYXBwZW4u
DQo=

