Return-Path: <kvm+bounces-45982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53441AB044F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 22:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 338F798225A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40D0288C23;
	Thu,  8 May 2025 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XdlycnOC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250BD35976;
	Thu,  8 May 2025 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734548; cv=fail; b=rT1ILh/ONhzqb5jqIH+lPEyAvdu23/8QOfbn8taflvbvLTE8B234NTinol+lDFc89J0aCx+RJOSi9FVhSfgvL6MB7Je4D5EibyvT3pxr2ZrSyAgS0EuBRAXMSvo2OlpZOBouwWUDKS0PSkNNfB0FygBXFVSkpyP9YUJHzLkcmsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734548; c=relaxed/simple;
	bh=PuEUWg9D2D8EONI2ZYLAkvLkgvH+H6LNJbPkeyTDZLE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mqtRDwVhAuxltOOEE/1hrTVtxAQJ/4kcHCI8zq8za+Va3Ojxtr6/janEJDoUvNxoBK2CIsA8wAdygaBiWNZVBnGpfYHTFP0FxnJcT2W2JWQ/k/YCOft/gmoTrSTfadtDq1cjurni0pVHi6/gudpjHW/rDT0gDotXAri0v/KWXEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XdlycnOC; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746734546; x=1778270546;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PuEUWg9D2D8EONI2ZYLAkvLkgvH+H6LNJbPkeyTDZLE=;
  b=XdlycnOCBTEvNn5RpOzhzwfLs+kC+BX3JT1Wa6HDa5i2QCKOABiV8t0/
   R02fHs44RjFzuxYZp+LtJA3d86M7kr2zC1xiICtzcbPK0miVnkFoj2xOE
   aQnz4/7+dFO2hxF8HcgyrWXS4dHoysoOoSr/YpWgVxcllimPm2e2kviD0
   kklb6A8R+ksArssG3MYJ2EvT/8CRwhdrNsjtbvesAZeiLNOikwk91PFh1
   suYLkqtSXZZa4BE8tY9ZAZKrkqvoy6Oayn0Fqv+BSzCwcPqv+a9SEzoCW
   WneRFW+UIM0MjqwvQC7do0/KAx+x5oNapmEkmDIz0mv750WwvPYHi61nf
   g==;
X-CSE-ConnectionGUID: wDfGEsMRSIKxZGh26oqdkg==
X-CSE-MsgGUID: qWVEHjQrR5SMtuVXkw0EMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59884501"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="59884501"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 13:02:21 -0700
X-CSE-ConnectionGUID: nS1qcK4PQG2yBM186lQ8Cg==
X-CSE-MsgGUID: 4hhIjxJRTsq/UScC8nYdrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136282169"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 13:02:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 13:02:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 13:02:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 13:02:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyOSF+I2yVFuwYdGnSNMA45CQBe2T+IlUW8e4x5DcQoUx7Szv7BPEfQgGvKDuF2rahhHTLdNEZOAzyBqoPYefCwvD4BLeSop7e38c9b2M19rxCvnK5etHpfxHH/rWbgEtpL4uY3oAQIRpYqC5rm9temtnjBBEjWDaYkpas40fKLJU4hw3fbpM50g879exfcB9Dd57DdYWJ+n+3tIeHMaxb7DcJOXzLxv6UO4nbYEofzFSP824tjUNEUkHDxAHTrpvy3dq/NKo0BgKiFIXpWJOmRVTfZQHfO6yo/CUN/hC3j+n+N0kCqD/4EslpRjdtUrSuJ3vGwgqeHExVec610gKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuEUWg9D2D8EONI2ZYLAkvLkgvH+H6LNJbPkeyTDZLE=;
 b=Uy5XjYorgx9UbWUHOZ7DMCP5g4nsWR8g+nOvga+GY8MLMjV/HqNdylmGf+UepGRTt3B1NKh1E9Z+rVx3PbWAKiQDT+tn17MygmQecQN7nszbeh4FIm5IVBvk0df3+cJfhR4mVOt0wiQMsaGV1yOVSZdhgyIINqFTF25ENUMOKojPwB/SDHdYAkAXYmFNqSoNVm2TySlAxPySrA2luRDwq6e+b6if/A/vyGgzSJ7flfw2UdiPxL/bWCVJkfjSzvxPlPKBn4vLmoKatJO4LkEPMlydn33Dzaq/CXyGquRuB74UeXXfdlSy8BWs5lB1Cb9orIXkjBDWbe0DhV4pDVYo6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5087.namprd11.prod.outlook.com (2603:10b6:a03:2ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 20:02:09 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8699.019; Thu, 8 May 2025
 20:02:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Spassov, Stanislav" <stanspas@amazon.de>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, "Li, Xin3"
	<xin3.li@intel.com>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>, "Bae, Chang
 Seok" <chang.seok.bae@intel.com>, "oleg@redhat.com" <oleg@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "kees@kernel.org"
	<kees@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Mehta, Sohil" <sohil.mehta@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "vigbalas@amd.com" <vigbalas@amd.com>
Subject: Re: [PATCH v6 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v6 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbvmnqcqUOLZH/nkGJeGswVzRA1LPJK1MA
Date: Thu, 8 May 2025 20:02:09 +0000
Message-ID: <a7604a0d844abf97fc534d72c65a4bf5dd45c1a0.camel@intel.com>
References: <20250506093740.2864458-1-chao.gao@intel.com>
	 <20250506093740.2864458-4-chao.gao@intel.com>
In-Reply-To: <20250506093740.2864458-4-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5087:EE_
x-ms-office365-filtering-correlation-id: 0cabc9b6-d795-4a74-8319-08dd8e6b36ed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bEREZnJzTERsSWNoMUp2ZkZmdFRpVWxhRm02STBQOUJIVDFGd29DT1BxaXdm?=
 =?utf-8?B?dEpMTFVLckR2Tk9QOU1lQnljeG1ZTWF6cU85MDc5TW50QVJKU0JPM0p6UWRS?=
 =?utf-8?B?a0pGR3FudUdUQkJkVkVGYjg2dUhKZkxMUkUydjg2NGEzbFQ4dzRxK1BDZndP?=
 =?utf-8?B?QjE4Zkc5T1A3bkZoaGNTUEpMVVpES2VIWmd6WHhGT0gwR2VoQmtuTWJmeUhN?=
 =?utf-8?B?bVFPemNBbmlXUzdSa0VlK0MvSWh5R2ZjYitnRndxS25pYkhoZ1E1TFBFa0lC?=
 =?utf-8?B?MHZ5anJKVGxhbjAwTG9TeU94eFR4aFR2T2lrYVJ0dHNLS3B3ekEvN0VFVHkw?=
 =?utf-8?B?UlJOek1IMjV0YXp0M2VNRlFsN1J4MGVzYSsvaHBOc1BKMElaQk9aYzJhZytR?=
 =?utf-8?B?amZaTXBnd1RWTHBNYWJsdHpnRUg5K083WVU3bldoSzZaMGJrd0U1U05NVzZj?=
 =?utf-8?B?OHRzcDJiRE5FTjlLa2I4blJpZ1BmTUxpKzVhcXlaUHZKMms4em9NR2d2dzNL?=
 =?utf-8?B?VDRVQmFYbFZvanltZVFPQTJHbnpMNkhnMCtCRXY2Y0pGNElVYW9SZHllUnRJ?=
 =?utf-8?B?b3NiQUlrRm1POWdiR1VIQXBOcWxzaElZQVVnWHV3dkZwVTZkQTRLbXJ5MDh5?=
 =?utf-8?B?NjBvSjc3MmFhWDJrZ0NtdWMyY3V5MXNYRHJ0K2xma25NN2FWMm1IRStWRXZW?=
 =?utf-8?B?NlBtQnZmdVdVaHpFR2lqUEhxbTByN3BQSTBQdkZFUGl0UE04UlFVM2k3ZUtD?=
 =?utf-8?B?WWs4ajdvYXhGY2FBS3ZsMlpyc3RUTDBPQk1yR2QvTXI1dUN4a05lRzRic3lI?=
 =?utf-8?B?NXlNZmViTmdkd2J6UndTRFh1VzBycjRJV3ZONy8vclpDeW5ER2hlSFdKTXFK?=
 =?utf-8?B?WitPZ0pPMWM1WCtPZ0JySEQ2Y2ZGSU0vNllFZDcveTE2Sk9aeDBmVUJHMS9a?=
 =?utf-8?B?U003bXNUVkZtbzd2VEpEV3luL1pScDBVUUN0N1J3NGVsK0hyOEJ4SlFTZGNh?=
 =?utf-8?B?aFRScGZDa05WMEx4cUNyaUtvZGFYZS9KQXEwZGZSY1k0emlreVhMblN2SktB?=
 =?utf-8?B?TmxtNjk4VnYzMzY2M1RIRjBYK3JhTHI1ajNpZmtCZ0kvdGVpYyt1WGd2UUZM?=
 =?utf-8?B?M1JRcWxUS2cremV4YWFUTkttOWxnVVpSbVZCSXVKaE1EUWJBdE9JQjV0cmRi?=
 =?utf-8?B?ZDA1SjNXa3hSYk00Sm9XbVNPWGZmbm5aMXdvZnJEMDBrbDdjU3BFUm5jZGpX?=
 =?utf-8?B?V0JNMFZBYng0MXduOUhUY1lYLzNTRjlkblJQMUxVS2NBaUpCSGE3K1F1NnM0?=
 =?utf-8?B?aWR3UHJmYUtiOVYxQlh4ZDY3NDREZmt6OUtnbHQxbHdIUkt0RE1iaU4rUHY4?=
 =?utf-8?B?VlpGcnpzVm9CMkZVMUpVVmkxOFNsUldua3NmQ2VHV1ppKytFMWRRUnhQVDE5?=
 =?utf-8?B?WE1MV3ZmUjc3aG1VVVBWQmpuaVlzVWtmZ1BzZ3pEQWp5c2x0UHhoV3YvazdK?=
 =?utf-8?B?Tkt6aDVTZEJnV3c0dVV2MW4xbU40S015MmlxMERTejg5cC8vZ2FmVzJJbjFl?=
 =?utf-8?B?VGg2TXVqamV2U3grMkhBOWU5b3Baa3JXa3VtUWFaemJHRGxnOUtTd09icnlF?=
 =?utf-8?B?NTNSRHJaR2ZieXVNNTR0NXBYd0RvSWJ4M3ZsK1dWaTdWcU5iQnJPZGZIYjlh?=
 =?utf-8?B?c1VIdzQrejByZVFtb1BTeTBpTU5uNStQUDNrWHhIdzhGVzA1a3BOclpYVDVT?=
 =?utf-8?B?bTg0Z05HejNtSHBlNTdBSjZUT2FSbkdOZ2RTbDJTZkQ2bDRITGZPRm1iRnBv?=
 =?utf-8?B?cDd6K2J4cy9tb3dLNjdnZXhaS3FGUThyWUxoYnB1YWU3bDBsejBHcGJ3bVJF?=
 =?utf-8?B?UTA4QnAzSVFaOTM3Q2RUcU5memw1TDEzRG5hUk0vQTdBWmg0S2ZheVpqWEh2?=
 =?utf-8?B?RDQ3V2EzRnVqei81L3pYWTNkUHdqdEhoTU1VN0NIRGdiVVRlbWpyTmVXbGNs?=
 =?utf-8?Q?WjsMrZhE36YUT/hzRfHSvzrmUlB83g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VStISjh1KzVZcjg5Smtrc0d6UnhxSHV2WnhkMG9oZXl3Z3pCRDJXR1NRci9F?=
 =?utf-8?B?RWdSQVFLSFZkNmpLcW95YXRMMzFsOVk3dTcyMVh3TEQrdlpEdStzbmFsdVRF?=
 =?utf-8?B?a2xEdU1NdHhDbTAzQm11NHZhR0FGa0ZOUVpXZ2VVL0wzTDZnVFRoMTFJWFNO?=
 =?utf-8?B?THJRTDArczN1RG9ndU10cFEzZ0hiNHBEM25WYktiNlJkUmN4ZXQxL084aG9Z?=
 =?utf-8?B?ZnpML3MzQk96QXpvc2tMR2pnMy9GaUo3eXNvcy9TamhQSGQxY1MvaGxVeDFK?=
 =?utf-8?B?NWF5L3dVRTQ2ai82MUJIcjRORUtxYWhGcVF2aWY1NmR0cEl3ZStSaTdhd1l4?=
 =?utf-8?B?akM1YVUzeVMzU3VSaWd6K3ZJbGQvakR1YTlKb2tMYjFxTWYwbi9tL1JmZFhm?=
 =?utf-8?B?RENnMzFlNDdVdkV6MkRVaVBGMGhqQlFHbnQ0YjVQYkExWmtiOGdWSWhmMk5Y?=
 =?utf-8?B?M0ZPdVZwWml5bXVxM2svOXA1NlQ5R2UyUzZGTDU2TEFPZzVCbmhDUjEzYm5q?=
 =?utf-8?B?TWJSWk1vMTZBWCt1VU1Zam44TFFuN2p6dXd1eE9LcmlranEyZDhiTGZDbncv?=
 =?utf-8?B?WnlyaUZ0c21YSk9BSW9KTDZuWXlxOTRicDFpajlLSXdkdmlvd1FTd3lsR2pL?=
 =?utf-8?B?b2xzUTg0R3V4RWxGSDRFSmRQVnZiQmVYYWJVNkF3MExaTlh2cUlZS1NPRzRY?=
 =?utf-8?B?MVllUzFiTG55K2xxNXhQNEJ1ekRJNlFRbFFXV2RSQ0xmK0lCdmpPTzFtcHRp?=
 =?utf-8?B?aE01UWFuT3FGSkpXSU80dm5RdkpscllTUm1WQ2ZqWnN0Wk01UCtSUmV4eGFB?=
 =?utf-8?B?Z25DaDBLTkUzaE04cHNsMGcwV1FuSVkyTVhvYkoyRndQQnU1eXpEY1l3SC81?=
 =?utf-8?B?UEdNMXhrUzk3OVdRRHFESnJqaWtPeURQSUVkdlowamx1UXdUam51QkxVNkV1?=
 =?utf-8?B?Mis2U2prRlA2VzdQeS9aamhaclVndWt6aW8ycFdBWFc5MlVCSTBRdXh2M0ox?=
 =?utf-8?B?ZnBaMWFrcGNXOHVxWDhDcDdUR3VKekNEbnNxSE5EYjRGMkwvck9NanZoejlo?=
 =?utf-8?B?aHdVWEV1YmtMTlBITDlid0NRNGgzcUZ6U3VEdUlGeGdzMkFtM2s3Q05qdHZ4?=
 =?utf-8?B?R1o5Tys4bjZ0c1Jrbjc1UkloR0xFSHV2c2tNS0tsaFVrc2wwNDQwUkhtTEZE?=
 =?utf-8?B?TGcrRytOUVhhNjdOT01LdzAxQnhHekgrYklZL0ZITDVxMzV1TG1NTVVZcVV1?=
 =?utf-8?B?K2dLM0wzb21NOUY4YzN0L25GUm1KOHVPS1dhZzhCQVlPY2xiMm5WVit5MUkx?=
 =?utf-8?B?NENwMS9LZ3N1SGxDK2dKdExxd25BTnBpczdLdEhoa3FVMjV5dHl3dUluUzRM?=
 =?utf-8?B?eG1ZYlBqVUEvbVoyVlNCM09oUU0vcGxrUTQ0eGVXbldUa2theEljbnY3ZHcy?=
 =?utf-8?B?bDZCWFdnS0owSUJlZUowdk5QRFRnM1RPeWx6TEtVc3E3c0lIbzdSeHIyQm10?=
 =?utf-8?B?S1ZYRzVhNTl2OGZNazlPcjBwZFlrWDNqWTB5OVMvdVBJUnkxZmJ6TS9EMG1B?=
 =?utf-8?B?dXlGUUFicHdDRUF5YWRIMHlpNjNyUVlKeE05Nmd6WlRFdXptRHdmak5XRzly?=
 =?utf-8?B?dWloSUJrYmxuOUhxN1h6MHBYMXRSTzFNdG8rR3NZWHBaQnREa2NMUnlVUmhr?=
 =?utf-8?B?ZitDTHJCOTVHTU1MTFNpU2VVd1hvOG1ZQVdsem96Y0RjaWthMXNaK2xwT0xx?=
 =?utf-8?B?blV4TDY4d3hFcjcvMDJwcEF0bG5UQTJzVXN2WFV4bDlIang2bkRwNGpDblVs?=
 =?utf-8?B?dkhBaEpTeFVQL3BWUWhUK1Qwb0FseU4zV2N3d1ZlbmI3ME1RMmRaZ2wyc2FU?=
 =?utf-8?B?OGNINjdUL3VwWU50U28xUll3NjVralQ0eEZNMnJtSzhEY3JCUlZsOG0xTThV?=
 =?utf-8?B?SDF1R2h5bkpkNmVMS1l1SXVCdFowNmEvbCt1ajNueWc4czdPdUR1dnRuZzNQ?=
 =?utf-8?B?cGlTdWhDU1FsYmJOU0lqZ1laRDlNUjBTQVZGVkFyRWJIdDhpNmtjaXI1a1Zy?=
 =?utf-8?B?cE9NOWx4Qms5RkNoLytFWnBRRHM1akVSZDNYa0hodzZTYkcrNDNxV1FiVkt0?=
 =?utf-8?B?WitzbmJOOGF2NVpNK0d5enFWRzUxNjVzWUxKVlZXU2N1R3FVa1JmUHBEZi91?=
 =?utf-8?Q?0gA7w+z5vDiVKHsV5yvA5yo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A600584A92F02F44BAEA6A1AC39A0DF2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cabc9b6-d795-4a74-8319-08dd8e6b36ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 20:02:09.0256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sQ+jkIR7f53o2q+AoVnZwnaBEplQa9w4Zv+/gyRACDiGoI5J5KUIOkKR/WcfVydFPKO4bQqGy6c1GvDF2B3fgCNF7OzLewEz6cvsCq5z0jc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5087
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTA2IGF0IDE3OjM2ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gQ3Vy
cmVudGx5LCBndWVzdCBhbmQgaG9zdCBGUFVzIHNoYXJlIHRoZSBzYW1lIGRlZmF1bHQgZmVhdHVy
ZXMuIEhvd2V2ZXIsDQo+IHRoZSBDRVQgc3VwZXJ2aXNvciB4c3RhdGUgaXMgdGhlIGZpcnN0IGZl
YXR1cmUgdGhhdCBuZWVkcyB0byBiZSBlbmFibGVkDQo+IGV4Y2x1c2l2ZWx5IGZvciBndWVzdCBG
UFVzLiBFbmFibGluZyBpdCBmb3IgaG9zdCBGUFVzIGxlYWRzIHRvIGEgd2FzdGUgb2YNCj4gMjQg
Ynl0ZXMgaW4gdGhlIFhTQVZFIGJ1ZmZlci4NCj4gDQo+IFRvIHN1cHBvcnQgImd1ZXN0LW9ubHki
IGZlYXR1cmVzLCBhZGQgYSBuZXcgc3RydWN0dXJlIHRvIGhvbGQgdGhlDQo+IGRlZmF1bHQgZmVh
dHVyZXMgYW5kIHNpemVzIGZvciBndWVzdCBGUFVzIHRvIGNsZWFybHkgZGlmZmVyZW50aWF0ZSB0
aGVtDQo+IGZyb20gdGhvc2UgZm9yIGhvc3QgRlBVcy4NCj4gDQo+IE5vdGUgdGhhdCwNCj4gMSkg
Zm9yIG5vdywgdGhlIGRlZmF1bHQgZmVhdHVyZXMgZm9yIGd1ZXN0IGFuZCBob3N0IEZQVXMgcmVt
YWluIHRoZQ0KPiBzYW1lLiBUaGlzIHdpbGwgY2hhbmdlIGluIGEgZm9sbG93LXVwIHBhdGNoIG9u
Y2UgZ3Vlc3QgcGVybWlzc2lvbnMsIGRlZmF1bHQNCj4geGZlYXR1cmVzLCBhbmQgZnBzdGF0ZSBz
aXplIGFyZSBhbGwgY29udmVydGVkIHRvIHVzZSB0aGUgZ3Vlc3QgZGVmYXVsdHMuDQo+IA0KPiAy
KSBvbmx5IHN1cGVydmlzb3IgZmVhdHVyZXMgd2lsbCBkaXZlcmdlIGJldHdlZW4gZ3Vlc3QgRlBV
cyBhbmQgaG9zdA0KPiBGUFVzLCB3aGlsZSB1c2VyIGZlYXR1cmVzIHdpbGwgcmVtYWluIHRoZSBz
YW1lIFsxXVsyXS4gU28sIHRoZSBuZXcNCj4gdmNwdV9mcHVfY29uZmlnIHN0cnVjdCBkb2VzIG5v
dCBpbmNsdWRlIGRlZmF1bHQgdXNlciBmZWF0dXJlcyBhbmQgc2l6ZQ0KPiBmb3IgdGhlIFVBQkkg
YnVmZmVyLg0KPiANCj4gQW4gYWx0ZXJuYXRpdmUgYXBwcm9hY2ggaXMgYWRkaW5nIGEgZ3Vlc3Rf
b25seV94ZmVhdHVyZXMgbWVtYmVyIHRvDQo+IGZwdV9rZXJuZWxfY2ZnIGFuZCBhZGRpbmcgdHdv
IGhlbHBlciBmdW5jdGlvbnMgdG8gY2FsY3VsYXRlIHRoZSBndWVzdA0KPiBkZWZhdWx0IHhmZWF0
dXJlcyBhbmQgc2l6ZS4gSG93ZXZlciwgY2FsY3VsYXRpbmcgdGhlc2UgZGVmYXVsdHMgYXQgcnVu
dGltZQ0KPiB3b3VsZCBpbnRyb2R1Y2UgdW5uZWNlc3Nhcnkgb3ZlcmhlYWQuDQo+IA0KPiBTdWdn
ZXN0ZWQtYnk6IENoYW5nIFMuIEJhZSA8Y2hhbmcuc2Vvay5iYWVAaW50ZWwuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KDQpSZXZpZXdlZC1ieTog
UmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K

