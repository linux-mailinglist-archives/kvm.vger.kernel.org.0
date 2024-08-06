Return-Path: <kvm+bounces-23348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1380948E26
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3EC028ACAC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF2B1C3F37;
	Tue,  6 Aug 2024 11:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X4Z0f/jk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1521C3F24;
	Tue,  6 Aug 2024 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722945072; cv=fail; b=JVFEF8OEBXDA4nSljwZFi+q9bEw0RyzlO+twVbZh64veRnNooHKtCbmNVA8tTUjEhCPE4Aj5MEFdr84W2uzBq7txCtx6nmVy25yRy3hXb+Ctra1uSekCJeiCDP8/mAgUhPXE1J4lDk+IB23+5411IwkOdqcnVrAjBLmrV/UbHoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722945072; c=relaxed/simple;
	bh=hMmBR/jDbXVeSLaZQeG8EwmJwXjByagWLMgL8ZWM1jY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H+vGRMQlrc9JOdtx9GpcEABOwBY/RDdpDfgEmD85/fPbHWqEN/GUccoLxtwly1vqAGcaEw9FuWoY/RaCawl57hevV2dNjlDRW1rFpNddH57KutkaWarvHUpvv5PXsW7E6NCxje9y7NOPEiAKknYlfwf5oJc1txnZkpmmtFcLVyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X4Z0f/jk; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722945071; x=1754481071;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hMmBR/jDbXVeSLaZQeG8EwmJwXjByagWLMgL8ZWM1jY=;
  b=X4Z0f/jkeXms8zLHf9+fpdBb4p3LxG1tPS4dCim7GmnCh7pHxcUJWXLA
   HECv79jK3JqZhrfv4pINC4Rxc1ARtCLQchA1pXPUtpVvyuT1tH43IlWbu
   sYP1fgqOikVikPrORtVzkdx6M78V42rJLqqAe8sgz9puFWFm7pnuOl7zo
   EsQyDDFilLMyJHHaafE2Rkz/ZhfAfVD0/KdKvYBYnH46D3oqtopIU4jwL
   MXAvaRwThMGqWX0u6BJtA24VQfoJJruXOSuSlUeMNSPJIv2fAKNt4m4Rj
   10Qz37uQrq3wp537SUZEgu0GYo9mqDFecEpWdzAn3wHVkZk5Dp7m2cn1i
   A==;
X-CSE-ConnectionGUID: DRoBbfxDSTKJ6HqdCyeMpQ==
X-CSE-MsgGUID: /STkaM2ESE25E9T+CSxQgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="32360386"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="32360386"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 04:51:09 -0700
X-CSE-ConnectionGUID: Eox1RcjYSBmOc/oEgCP7vg==
X-CSE-MsgGUID: /xRxduP/QK6N7RCGFvLC4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="56418968"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 04:51:09 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 04:51:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 04:51:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 04:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzyAfjs1CvX2IQhNfm1T6p1LtWcQ6ucVLWpN7St2vDr5uPZTlA2EmoaG1EaWdeLFOBGfWucoaTZC2XS70yK47myjS6lOGgDtodM7WYbpNVuYVjUCLoZCCzGaKRz3gllG1LSb7ejeW/VOEb5U16oVloi5lzY0oEGlI8IifhiHH+Os3aJgOtUNrfmNmjusegFdN1bSxiYakyQRyaFJFDZIQm0XX9fnbNpYTusxiv2IT0Pr5uxOz0U/jJITYxc8RHVDoF8WCUD7EZbcbF7RIycWOGArmRRMyQh2UsimIxXhOiWL58sM6ZfvMiCneF2u4N7/2+EFtk1AU7nPRYsVRCUfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMmBR/jDbXVeSLaZQeG8EwmJwXjByagWLMgL8ZWM1jY=;
 b=eqXlJtzUjKkXLCp0ntfQvDYkIXYhjkbgMXRIoZE53OSh4ja3nG52X0CPsCWxC+1B6KeduFcHBnFLGPyEb+G5srO+mbQoj+QpvtjwhwzVafvxwihfeOdPJJROcJHQSOcFBWLUt5VUiQnnmDDpM2fV7LaZhrfP0UUFstZiwfb5lqY9wacEwEhtuoF110n96qS6vWaFoZku6c9atNgafJ9kkHAOKmFzabOqbJy4OAgE0yW9D2PLz9r8UO4u0yW7xI8pODeYNHrDvt3fKL3kLU9BxVRZRLYcCkPbkr2MCyDjiemuarx+v7nb+KtdO6ARwVmBQjLBP0V2f6WyYP0J25HlVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5024.namprd11.prod.outlook.com (2603:10b6:a03:2dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28; Tue, 6 Aug
 2024 11:51:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 11:51:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
Thread-Topic: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic
 information
Thread-Index: AQHa1/rIRlz/jvOVzUGBp7cF8OmbMbIZv6EAgAB+OoA=
Date: Tue, 6 Aug 2024 11:51:05 +0000
Message-ID: <ccf6974cb0c0b30cd019abf195276c2e1dff49a2.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
	 <66b1a44236bf8_4fc72945a@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b1a44236bf8_4fc72945a@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5024:EE_
x-ms-office365-filtering-correlation-id: fd274b9e-4b0a-47cb-a056-08dcb60e0d7a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Tk5sL1N1blhQOXlVclpuSXpSYUU2TysxbU9zTHY4ck4zc2RsdFBnbUxjTktv?=
 =?utf-8?B?eTNpN01neXNoMUt4bnR4azgvWmpNWW9iY0hPYnlFVDhIOTJyTXVHcnRsU1h5?=
 =?utf-8?B?VWlUZlBaaGJyZ0ZKdUlWSFRGVjhOclVHK2pQUkw5ZGlzMUZZMG5MVnRvdFBZ?=
 =?utf-8?B?UXNTVVFEeThpU3FHUG9OT1FNUVpkalpoblhvNnlvc2xmT3c3WTR2bFNEK08z?=
 =?utf-8?B?SjZzemxpVnhibXQwSVNsaXBjRVcxazg2MnJTT2dYTHFPKzR2TzNjb2ZwNWc5?=
 =?utf-8?B?VWNZcGg4U0dZU2hFa2RoUkdaUkFkRFJLeEJXVXVDUzBlR21yWGViZ3NhNlRQ?=
 =?utf-8?B?ZzdXTkRzOTMzdzc3b2RxdUlveGJEOHVmc2RJcGZESXZSVExGVDVmaS9nTlVl?=
 =?utf-8?B?UUd3RGoyZFJSUDdWUDBoaVZNMS9vaUw3SDFJWkx6RlV2ZEQ2Q3FuNXQ5YVRt?=
 =?utf-8?B?M2RXSm4xT0N0MEVaa3A4WjF1eElZNW9WUTRXWEl6d1Z4T1o4MEpLZWozd1VV?=
 =?utf-8?B?ZDVPeU9OYXNKQW1uM1V4dXFadi9Md2dQRFE5V1pkTWsvYWJ2R0JoUXM2SGtp?=
 =?utf-8?B?VVBVZEZHQjhJa2lvb0VTTTJoWitkUWZqM0pPbzh5ckRkbjd5MkQ1bFR5My9L?=
 =?utf-8?B?TVNsMVFDc3lsQXA1NWZsM0F5cUpJbEsweEp0TUVOMlVYK3FTSnNBTGh6d2FN?=
 =?utf-8?B?dXVTRWRyMGU0RzRiTXJLK09mR2lCT0Z4cTVSSTNQNEFOM2RmTHArWEJCUVdn?=
 =?utf-8?B?Y0E0b3l1UTRhZlhoVXNxbm5YNUt1ODg3M0VtNU1JRjJuTGZrMnRDa2Q3R05F?=
 =?utf-8?B?OUNEdDBUWWJnZkVuL0VmWWdlSDhiVStqN3N5TW9JN2VIdjVUWExQNlhIWkQ3?=
 =?utf-8?B?djNJWDZiM2xsUEJ1SzBEYmp3Mk5MTkFvWWxONEJieXMwQm1LcmNNMDIwbkZT?=
 =?utf-8?B?T2lqeVZtSlc4NTZZcnQ2bHpqNTAwWjBwa2tOVnBXaHA5eWlyQmliVUQrL2Jm?=
 =?utf-8?B?c3o2WENkb0I5SkNSclllVGpHSS9VamVXM1J5NkZpM2ZnMmRPUnlrWWNmaTls?=
 =?utf-8?B?Qkx1K2E1MlB5UVIvVVIrMit5aGRUb1VrUmdpZGoyNkoyVndzd2Z5NmtRc3pS?=
 =?utf-8?B?VDdHVkdCTHcxSldzYzF1b2NCT3p6b2hXUkpvam5LSDJVenBLeFVRdERrRlNu?=
 =?utf-8?B?R0RoUFFBa3ZVMTV6R0Q1NnVoK3B5TTNOTlVoeDQ0UmdGUkZCeG95VytNZ25X?=
 =?utf-8?B?VXBEcldzSHpGcVhJZ2VXcG5UTmVtSi9BT2FJeGdWM3NWSkllU2d4TkdqQzN0?=
 =?utf-8?B?SjlQT3RWOEZoVzltK2JMN1V3ZjM4aU9NRVROaDc3OExmemQ3R0srQ3BPVEhV?=
 =?utf-8?B?UDNOaGhka2QxT0Vjd2F1SlFaZW9wTFlwNWZWMXZ4UXU2YndXQnlFdE9LK3o4?=
 =?utf-8?B?VmJ0Y1BmdmVKanozcEdNVVE4azd0cU1FRWZNQUwveXlxMC9nUGtzb3NrdVB0?=
 =?utf-8?B?RTF5ZkFXUjdJZ2dUeFMraFR2V0xXYklWdEhjVktKaUdKa1B5ZVQ1Wk1PWEhl?=
 =?utf-8?B?YVhYRFhyV05GeGw0V0gwUFNkeStFU1doZG1LRFZVdGtQNlp4K3NRNnE2NHdY?=
 =?utf-8?B?Y3NkL2x4SzMyTXNSbk9aQnpkRjh0amRmNWp0aVJ6bG51ZDNrWGdMRXZ6cTNU?=
 =?utf-8?B?djhyaHg0UHhQZUY3TDFsZXF2d0Y5eXNkSWhROTVSeXFNOU9wak9jcjFCazk3?=
 =?utf-8?B?VjQrQndqeGpvdG5TUUZZOXpEZEVLdzA2UUNzNEwyKzBlU0JyNjRkWlRZcU9j?=
 =?utf-8?B?WjVoQVBSMnVWcU0xWUhhWTc3bFFwU215UWRmRVY3ZktaTlc1Y0N3VVB1Y1BC?=
 =?utf-8?Q?0cISu/DuJoMIg?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N08wR2FEd01LWFlCYTF1UGdLdCs5ak1SMDhHTUhET1h3aDBSV0tBUlFmd3hi?=
 =?utf-8?B?WEpGOFJ3VERBQkx4MHpORzUzajFJcU9yK0Nnd0NSMUZHR0NCRWVPb29QUG0r?=
 =?utf-8?B?SkxCaE1jMVlDeGtCNWhENk15RGRGZHRPb3NxTmw1NGo5MTBpU0g1K3F0dnhi?=
 =?utf-8?B?RDBndVYzRVpEN3Zybzd4WVp4ZnRaOXdJQWtDS2VhRmFiVWpodTFSQmlWUWk3?=
 =?utf-8?B?YkF6VFVKTlFPRjQ3TTRuWkdVTkI5YmQ0ekszZFdWSmZRZlB0SmNLZnU5VDMr?=
 =?utf-8?B?Z3ZuMWw3STlOZjJqUHJYa3ZIMEtZZWRidlF0RHlJRVhNUVhhQ09OUFI5QzVH?=
 =?utf-8?B?WWhMZnEzaHJCK1ByUmVzVllZV1pHek5zcnRhU0VEMWpGYWlZSVhrYjRFcjJh?=
 =?utf-8?B?RmZrRi9zUzI2R3FZTTZMU2hSeVNRT1FpUXhjN28xVmsxeVI2V2h4L2N5WjRu?=
 =?utf-8?B?V2lNTlZ6MzNxUGhQMVA2bDNUY2p0Q0NEUzdhcTU3ei8rQkdsWlR4OW1IQVlq?=
 =?utf-8?B?VTR3QlZSR1M4em95Nm9TNTNGWjBxM3VRVXA3Zlp2RE9GWUh4Ti9MSUNoOWZo?=
 =?utf-8?B?RGN2U0tDYXpSUmg4UG1vc0ZONWR1ZjdrS2VDa2VTT0dTSVA0K0dIU0toZFhs?=
 =?utf-8?B?Z1NUR3hpMy9EMzdJeFF0K3ZyVG0vSWs2NXdnK0ZmcWRnUXBwYS9JdVNqWXdQ?=
 =?utf-8?B?RU9LbEFkQXpKRE01MGkyREFCWDBGdmZiRXpnaU9GSUFUWFJOS0Q4U05LY2dn?=
 =?utf-8?B?VE5KYmVVMlJKMGZKUHlGWUFwZC9ER2J5dEVQZHFaaWlWdXhVQWVRNjNtbGp1?=
 =?utf-8?B?OG9nQjlGeGdxTlg3U0dsSE03c2paSkx0WnpRdEsyNlplZ1VZek41SUw2em5j?=
 =?utf-8?B?NVdQZkRYdjdzZFFRbTlXMUZMb3A5VDExWnVkRWI3TkVSZ0NSTHZzbHY2L0pJ?=
 =?utf-8?B?eS96NHZ2eHN3V0E3TGUzTTYwVTlKWDY3S1dST0FGZDd2VEVCcHJmY3Jzd1Az?=
 =?utf-8?B?MGRhaGhwSWNydzU3dVgrUE1sRHpTZmkzblRsZ0RCZHdWRTd4QTNLVGxyWklw?=
 =?utf-8?B?SzVwaW1zRjRlVVN1a3JXSWVjZCt6NVJGTEcwYnV0S1RBMFdod0R3TjgzOFhC?=
 =?utf-8?B?eEhNR1hpdmdSczhTSW5aR0NieHBuTlk0MVBPMHdSeEsyeVp6bk5sM2Y0UVpj?=
 =?utf-8?B?bGQ2RmxmYkRlblBWU2lIRkx5K2llYzFwT2ZtRzIrNU9RaFVjSDFUR1AwcGM0?=
 =?utf-8?B?cHZ2T3ZDcTZHeUdFaDdUeXNMTTdoUjBESGhiQ0Qrc2ozQTdJVC9ldnVkcHFh?=
 =?utf-8?B?SmpVVVYxc1M3S1JlL213bEpaYlVFWDlLQ01KdDRRc1JsNjR4cVdMN2YrbkNo?=
 =?utf-8?B?Sm1QNmF0dDZQa0Z2VTFadXdNZWFIdzlvTzZXQjFBL0hZQ1BFdzZhMXlMbXBp?=
 =?utf-8?B?SThQUE9MSlhUVFlsaGV5RTMwYTNGZDdwWFBFeTdLQWdneW9ydFQrVDA0VmxD?=
 =?utf-8?B?TzhrL3BPVjlSdGVHVWtaYjIzT2NJVmsxSmlLYmF2RWN0Z3FrcWFZQzdZemov?=
 =?utf-8?B?YXF3eEtNeEdjREk1NXBaYkEzTUVFdkdSQkV1VXc4WElDZjl1Q3NOTVZqNEZa?=
 =?utf-8?B?NDZRai9sc24waTg3TXd6ZGQ1ZTE5cjlmTi9FOFBpQ2RxbTVHd0RkcGxibjFp?=
 =?utf-8?B?c2dSTTRKMFJYNGx3em9jYms2Uk1qS3drYk85TUVNUjhyM1hqWURxSWU5SkM5?=
 =?utf-8?B?NnIxcHdudFB5dm4zOUxGdlpRL2Q0dVlTQUtpWWZLRXd0ZWdaRG5NMjVmWEVw?=
 =?utf-8?B?cklkNmllYTVaeDJrRmdUbVVaTTZqZFFkdmJJYndFZzMvZVFKNVY0MTA2VmtG?=
 =?utf-8?B?anc1UElRK2dGa3dmR3lTK1R3eE92MnNuSXd5V2FxTU03bk5OUWk0aWtnRnhq?=
 =?utf-8?B?TTRDdHp0UmRibmFYR2lBb3ZoMkJKODdPUmFvNFVvVkZhaVJ6YnFCdi85QXVo?=
 =?utf-8?B?c0RabU5PMjJNWE54SlVPOUhtdVJEMDNYc1U4VXVEV1hqQ2ltK0NSekR4Q3hU?=
 =?utf-8?B?QkRXSlNqNjhTemhSSEM5U0FlUjVkN0NrVkxpM1hpV1NhR2laTkdnM285TDAr?=
 =?utf-8?Q?RqaqCJzxkLHVTt/cBFRAoBn1R?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCAFF3B72748ED44870DE783CC496C00@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd274b9e-4b0a-47cb-a056-08dcb60e0d7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 11:51:05.0173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ozgi0spJJKOrhdW0kHTGuCZ8UF9BsszlHANVBAi59NoP6EguQ7ZC69fjnorCNHAhNFft1wjgecJJCZ9YMMncEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5024
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTA1IGF0IDIxOjE5IC0wNzAwLCBXaWxsaWFtcywgRGFuIEogd3JvdGU6
DQo+IEthaSBIdWFuZyB3cm90ZToNCj4gPiBDdXJyZW50bHkgdGhlIGtlcm5lbCBkb2Vzbid0IHBy
aW50IGFueSBpbmZvcm1hdGlvbiByZWdhcmRpbmcgdGhlIFREWA0KPiA+IG1vZHVsZSBpdHNlbGYs
IGUuZy4gbW9kdWxlIHZlcnNpb24uICBJbiBwcmFjdGljZSBzdWNoIGluZm9ybWF0aW9uIGlzDQo+
ID4gdXNlZnVsLCBlc3BlY2lhbGx5IHRvIHRoZSBkZXZlbG9wZXJzLg0KPiA+IA0KPiA+IEZvciBp
bnN0YW5jZSwgdGhlcmUgYXJlIGEgY291cGxlIG9mIHVzZSBjYXNlcyBmb3IgZHVtcGluZyBtb2R1
bGUgYmFzaWMNCj4gPiBpbmZvcm1hdGlvbjoNCj4gPiANCj4gPiAxKSBXaGVuIHNvbWV0aGluZyBn
b2VzIHdyb25nIGFyb3VuZCB1c2luZyBURFgsIHRoZSBpbmZvcm1hdGlvbiBsaWtlIFREWA0KPiA+
ICAgIG1vZHVsZSB2ZXJzaW9uLCBzdXBwb3J0ZWQgZmVhdHVyZXMgZXRjIGNvdWxkIGJlIGhlbHBm
dWwgWzFdWzJdLg0KPiA+IA0KPiA+IDIpIEZvciBMaW51eCwgd2hlbiB0aGUgdXNlciB3YW50cyB0
byB1cGRhdGUgdGhlIFREWCBtb2R1bGUsIG9uZSBuZWVkcyB0bw0KPiA+ICAgIHJlcGxhY2UgdGhl
IG9sZCBtb2R1bGUgaW4gYSBzcGVjaWZpYyBsb2NhdGlvbiBpbiB0aGUgRUZJIHBhcnRpdGlvbg0K
PiA+ICAgIHdpdGggdGhlIG5ldyBvbmUgc28gdGhhdCBhZnRlciByZWJvb3QgdGhlIEJJT1MgY2Fu
IGxvYWQgaXQuICBIb3dldmVyLA0KPiA+ICAgIGFmdGVyIGtlcm5lbCBib290cywgY3VycmVudGx5
IHRoZSB1c2VyIGhhcyBubyB3YXkgdG8gdmVyaWZ5IGl0IGlzDQo+ID4gICAgaW5kZWVkIHRoZSBu
ZXcgbW9kdWxlIHRoYXQgZ2V0cyBsb2FkZWQgYW5kIGluaXRpYWxpemVkIChlLmcuLCBlcnJvcg0K
PiA+ICAgIGNvdWxkIGhhcHBlbiB3aGVuIHJlcGxhY2luZyB0aGUgb2xkIG1vZHVsZSkuICBXaXRo
IHRoZSBtb2R1bGUgdmVyc2lvbg0KPiA+ICAgIGR1bXBlZCB0aGUgdXNlciBjYW4gdmVyaWZ5IHRo
aXMgZWFzaWx5Lg0KPiA+IA0KPiA+IFNvIGR1bXAgdGhlIGJhc2ljIFREWCBtb2R1bGUgaW5mb3Jt
YXRpb246DQo+ID4gDQo+ID4gIC0gVERYIG1vZHVsZSB2ZXJzaW9uLCBhbmQgdGhlIGJ1aWxkIGRh
dGUuDQo+ID4gIC0gVERYIG1vZHVsZSB0eXBlOiBEZWJ1ZyBvciBQcm9kdWN0aW9uLg0KPiA+ICAt
IFREWF9GRUFUVVJFUzA6IFN1cHBvcnRlZCBURFggZmVhdHVyZXMuDQo+ID4gDQo+ID4gQW5kIGR1
bXAgdGhlIGluZm9ybWF0aW9uIHJpZ2h0IGFmdGVyIHJlYWRpbmcgZ2xvYmFsIG1ldGFkYXRhLCBz
byB0aGF0DQo+ID4gdGhpcyBpbmZvcm1hdGlvbiBpcyBwcmludGVkIG5vIG1hdHRlciB3aGV0aGVy
IG1vZHVsZSBpbml0aWFsaXphdGlvbg0KPiA+IGZhaWxzIG9yIG5vdC4NCj4gPiANCj4gPiBUaGUg
YWN0dWFsIGRtZXNnIHdpbGwgbG9vayBsaWtlOg0KPiA+IA0KPiA+ICAgdmlydC90ZHg6IEluaXRp
YWxpemluZyBURFggbW9kdWxlOiAxLjUuMDAuMDAuMDQ4MSAoYnVpbGRfZGF0ZSAyMDIzMDMyMywg
UHJvZHVjdGlvbiBtb2R1bGUpLCBURFhfRkVBVFVSRVMwIDB4ZmJmDQo+ID4gDQo+ID4gTGluazog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9lMmQ4NDRhZC0xODJhLTRmYzAtYTA2YS1kNjA5
YzljYmVmNzRAc3VzZS5jb20vVC8jbTM1MjgyOWFlZGY2NjgwZDQ2MjhjN2U0MGRjNDBiMzMyZWRh
OTMzNTUgWzFdDQo+ID4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9lMmQ4NDRh
ZC0xODJhLTRmYzAtYTA2YS1kNjA5YzljYmVmNzRAc3VzZS5jb20vVC8jbTM1MWViY2JjMDA2ZDJl
NWJjM2U3NjUwMjA2YTA4N2NiMjcwOGQ0NTEgWzJdDQo+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1
YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IHYxIC0+IHYyIChO
aWtvbGF5KToNCj4gPiAgLSBDaGFuZ2UgdGhlIGZvcm1hdCB0byBkdW1wIFREWCBiYXNpYyBpbmZv
Lg0KPiA+ICAtIFNsaWdodGx5IGltcHJvdmUgY2hhbmdlbG9nLg0KPiA+IA0KPiA+IC0tLQ0KPiA+
ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCA2NCArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrDQo+ID4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaCB8IDMzICsr
KysrKysrKysrKysrKysrKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IDMyNTNj
ZGZhNTIwNy4uNWFjMGM0MTFmNGY3IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBA
IC0zMTksNiArMzE5LDU4IEBAIHN0YXRpYyBpbnQgc3RidWZfcmVhZF9zeXNtZF9tdWx0aShjb25z
dCBzdHJ1Y3QgZmllbGRfbWFwcGluZyAqZmllbGRzLA0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0N
Cj4gPiAgDQo+ID4gKyNkZWZpbmUgVERfU1lTSU5GT19NQVBfTU9EX0lORk8oX2ZpZWxkX2lkLCBf
bWVtYmVyKQlcDQo+ID4gKwlURF9TWVNJTkZPX01BUChfZmllbGRfaWQsIHN0cnVjdCB0ZHhfc3lz
aW5mb19tb2R1bGVfaW5mbywgX21lbWJlcikNCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgZ2V0X3Rk
eF9tb2R1bGVfaW5mbyhzdHJ1Y3QgdGR4X3N5c2luZm9fbW9kdWxlX2luZm8gKm1vZGluZm8pDQo+
ID4gK3sNCj4gPiArCXN0YXRpYyBjb25zdCBzdHJ1Y3QgZmllbGRfbWFwcGluZyBmaWVsZHNbXSA9
IHsNCj4gPiArCQlURF9TWVNJTkZPX01BUF9NT0RfSU5GTyhTWVNfQVRUUklCVVRFUywgc3lzX2F0
dHJpYnV0ZXMpLA0KPiA+ICsJCVREX1NZU0lORk9fTUFQX01PRF9JTkZPKFREWF9GRUFUVVJFUzAs
ICB0ZHhfZmVhdHVyZXMwKSwNCj4gPiArCX07DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHN0YnVmX3Jl
YWRfc3lzbWRfbXVsdGkoZmllbGRzLCBBUlJBWV9TSVpFKGZpZWxkcyksIG1vZGluZm8pOw0KPiA+
ICt9DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFREX1NZU0lORk9fTUFQX01PRF9WRVJTSU9OKF9maWVs
ZF9pZCwgX21lbWJlcikJXA0KPiA+ICsJVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBzdHJ1Y3Qg
dGR4X3N5c2luZm9fbW9kdWxlX3ZlcnNpb24sIF9tZW1iZXIpDQo+ID4gKw0KPiA+ICtzdGF0aWMg
aW50IGdldF90ZHhfbW9kdWxlX3ZlcnNpb24oc3RydWN0IHRkeF9zeXNpbmZvX21vZHVsZV92ZXJz
aW9uICptb2R2ZXIpDQo+ID4gK3sNCj4gPiArCXN0YXRpYyBjb25zdCBzdHJ1Y3QgZmllbGRfbWFw
cGluZyBmaWVsZHNbXSA9IHsNCj4gPiArCQlURF9TWVNJTkZPX01BUF9NT0RfVkVSU0lPTihNQUpP
Ul9WRVJTSU9OLCAgICBtYWpvciksDQo+ID4gKwkJVERfU1lTSU5GT19NQVBfTU9EX1ZFUlNJT04o
TUlOT1JfVkVSU0lPTiwgICAgbWlub3IpLA0KPiA+ICsJCVREX1NZU0lORk9fTUFQX01PRF9WRVJT
SU9OKFVQREFURV9WRVJTSU9OLCAgIHVwZGF0ZSksDQo+ID4gKwkJVERfU1lTSU5GT19NQVBfTU9E
X1ZFUlNJT04oSU5URVJOQUxfVkVSU0lPTiwgaW50ZXJuYWwpLA0KPiA+ICsJCVREX1NZU0lORk9f
TUFQX01PRF9WRVJTSU9OKEJVSUxEX05VTSwJICAgICBidWlsZF9udW0pLA0KPiA+ICsJCVREX1NZ
U0lORk9fTUFQX01PRF9WRVJTSU9OKEJVSUxEX0RBVEUsCSAgICAgYnVpbGRfZGF0ZSksDQo+ID4g
Kwl9Ow0KPiA+ICsNCj4gPiArCXJldHVybiBzdGJ1Zl9yZWFkX3N5c21kX211bHRpKGZpZWxkcywg
QVJSQVlfU0laRShmaWVsZHMpLCBtb2R2ZXIpOw0KPiANCj4gTG9va3MgZ29vZCBpZiBzdGJ1Zl9y
ZWFkX3N5c21kX211bHRpKCkgaXMgcmVwbGFjZWQgd2l0aCB0aGUgd29yayBiZWluZw0KPiBkb25l
IGludGVybmFsIHRvIFREX1NZU0lORk9fTUFQX01PRF9WRVJTSU9OKCkuDQo+IA0KPiA+ICt9DQo+
ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBwcmludF9iYXNpY19zeXNpbmZvKHN0cnVjdCB0ZHhfc3lz
aW5mbyAqc3lzaW5mbykNCj4gPiArew0KPiA+ICsJc3RydWN0IHRkeF9zeXNpbmZvX21vZHVsZV92
ZXJzaW9uICptb2R2ZXIgPSAmc3lzaW5mby0+bW9kdWxlX3ZlcnNpb247DQo+ID4gKwlzdHJ1Y3Qg
dGR4X3N5c2luZm9fbW9kdWxlX2luZm8gKm1vZGluZm8gPSAmc3lzaW5mby0+bW9kdWxlX2luZm87
DQo+ID4gKwlib29sIGRlYnVnID0gbW9kaW5mby0+c3lzX2F0dHJpYnV0ZXMgJiBURFhfU1lTX0FU
VFJfREVCVUdfTU9EVUxFOw0KPiANCj4gV2h5IGlzIHRoaXMgY2FzdWFsbHkgY2hlY2tpbmcgZm9y
IGRlYnVnIG1vZHVsZXMsIGJ1dCBkb2luZyBub3RoaW5nIHdpdGgNCj4gdGhhdCBpbmRpY2F0aW9u
PyBTaG91bGRuJ3QgdGhlIGtlcm5lbCBoYXZlIHBvbGljeSBhcm91bmQgd2hldGhlciBpdA0KPiB3
YW50cyB0byBpbnRlcm9wZXJhdGUgd2l0aCBhIGRlYnVnIG1vZHVsZT8gSSB3b3VsZCBleHBlY3Qg
dGhhdCBrZXJuZWwNCj4gb3BlcmF0aW9uIHdpdGggYSBkZWJ1ZyBtb2R1bGUgd291bGQgbmVlZCBl
eHBsaWNpdCBvcHQtaW4gY29uc2lkZXJhdGlvbi4NCg0KRm9yIG5vdyB0aGUgcHVycG9zZSBpcyBq
dXN0IHRvIHByaW50IHdoZXRoZXIgbW9kdWxlIGlzIGRlYnVnIG9yDQpwcm9kdWN0aW9uIGluIHRo
ZSBkbWVzZyB0byBsZXQgdGhlIHVzZXIgZWFzaWx5IHNlZSwganVzdCBsaWtlIHRoZSBtb2R1bGUN
CnZlcnNpb24gaW5mby4NCg0KQ3VycmVudGx5IExpbnV4IGRlcGVuZHMgb24gdGhlIEJJT1MgdG8g
bG9hZCB0aGUgVERYIG1vZHVsZS4gIEZvciB0aGF0IHdlDQpuZWVkIHRvIHB1dCB0aGUgbW9kdWxl
IGF0IC9ib290L2VmaS9FRkkvVERYLyBhbmQgbmFtZSBpdCBURFgtU0VBTS5zby4gIFNvDQpnaXZl
biBhIG1hY2hpbmUsIGl0J3MgaGFyZCBmb3IgdGhlIHVzZXIgdG8ga25vdyB3aGV0aGVyIGEgbW9k
dWxlIGlzIGRlYnVnDQpvbmUgKHRoZSB1c2VyIG1heSBiZSBhYmxlIHRvIGdldCBzdWNoIGluZm8g
ZnJvbSB0aGUgQklPUyBsb2csIGJ1dCBpdCBpcw0Kbm90IGFsd2F5cyBhdmFpbGFibGUgZm9yIHRo
ZSB1c2VyKS4NCg0KWWVzIEkgYWdyZWUgd2Ugc2hvdWxkIGhhdmUgYSBwb2xpY3kgaW4gdGhlIGtl
cm5lbCB0byBoYW5kbGUgZGVidWcgbW9kdWxlLA0KYnV0IEkgZG9uJ3Qgc2VlIHVyZ2VudCBuZWVk
IG9mIGl0LiAgU28gSSB3b3VsZCBwcmVmZXIgdG8gbGVhdmUgaXQgYXMNCmZ1dHVyZSB3b3JrIHdo
ZW4gbmVlZGVkLg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBURFggbW9kdWxlIHZl
cnNpb24gZW5jb2Rpbmc6DQo+ID4gKwkgKg0KPiA+ICsJICogICA8bWFqb3I+LjxtaW5vcj4uPHVw
ZGF0ZT4uPGludGVybmFsPi48YnVpbGRfbnVtPg0KPiA+ICsJICoNCj4gPiArCSAqIFdoZW4gcHJp
bnRlZCBhcyB0ZXh0LCA8bWFqb3I+IGFuZCA8bWlub3I+IGFyZSAxLWRpZ2l0LA0KPiA+ICsJICog
PHVwZGF0ZT4gYW5kIDxpbnRlcm5hbD4gYXJlIDItZGlnaXRzIGFuZCA8YnVpbGRfbnVtPg0KPiA+
ICsJICogaXMgNC1kaWdpdHMuDQo+ID4gKwkgKi8NCj4gPiArCXByX2luZm8oIkluaXRpYWxpemlu
ZyBURFggbW9kdWxlOiAldS4ldS4lMDJ1LiUwMnUuJTA0dSAoYnVpbGRfZGF0ZSAldSwgJXMgbW9k
dWxlKSwgVERYX0ZFQVRVUkVTMCAweCVsbHhcbiIsDQo+ID4gKwkJCW1vZHZlci0+bWFqb3IsIG1v
ZHZlci0+bWlub3IsIG1vZHZlci0+dXBkYXRlLA0KPiA+ICsJCQltb2R2ZXItPmludGVybmFsLCBt
b2R2ZXItPmJ1aWxkX251bSwNCj4gPiArCQkJbW9kdmVyLT5idWlsZF9kYXRlLCBkZWJ1ZyA/ICJE
ZWJ1ZyIgOiAiUHJvZHVjdGlvbiIsDQo+ID4gKwkJCW1vZGluZm8tPnRkeF9mZWF0dXJlczApOw0K
PiANCj4gQW5vdGhlciBuaWNlIHRoaW5nIGFib3V0IGpzb24gc2NyaXB0aW5nIGlzIHRoYXQgdGhp
cyBmbGFnIGZpZWxkcyBjb3VsZA0KPiBiZSBwcmV0dHktcHJpbnRlZCB3aXRoIHN5bWJvbGljIG5h
bWVzIGZvciB0aGUgZmxhZ3MsIGJ1dCB0aGF0IGNhbiBjb21lDQo+IGxhdGVyLg0KDQpJJ2xsIGxv
b2sgaW50byBob3cgdG8gYXV0by1nZW5lcmF0ZSBiYXNlZCBvbiBKU09OIGZpbGUuDQoNCj4gDQo+
ID4gK30NCj4gPiArDQo+ID4gICNkZWZpbmUgVERfU1lTSU5GT19NQVBfVERNUl9JTkZPKF9maWVs
ZF9pZCwgX21lbWJlcikJXA0KPiA+ICAJVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBzdHJ1Y3Qg
dGR4X3N5c2luZm9fdGRtcl9pbmZvLCBfbWVtYmVyKQ0KPiA+ICANCj4gPiBAQCAtMzM5LDYgKzM5
MSwxNiBAQCBzdGF0aWMgaW50IGdldF90ZHhfdGRtcl9zeXNpbmZvKHN0cnVjdCB0ZHhfc3lzaW5m
b190ZG1yX2luZm8gKnRkbXJfc3lzaW5mbykNCj4gPiAgDQo+ID4gIHN0YXRpYyBpbnQgZ2V0X3Rk
eF9zeXNpbmZvKHN0cnVjdCB0ZHhfc3lzaW5mbyAqc3lzaW5mbykNCj4gPiAgew0KPiA+ICsJaW50
IHJldDsNCj4gPiArDQo+ID4gKwlyZXQgPSBnZXRfdGR4X21vZHVsZV9pbmZvKCZzeXNpbmZvLT5t
b2R1bGVfaW5mbyk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4gKw0K
PiA+ICsJcmV0ID0gZ2V0X3RkeF9tb2R1bGVfdmVyc2lvbigmc3lzaW5mby0+bW9kdWxlX3ZlcnNp
b24pOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiAgCXJl
dHVybiBnZXRfdGR4X3RkbXJfc3lzaW5mbygmc3lzaW5mby0+dGRtcl9pbmZvKTsNCj4gPiAgfQ0K
PiA+ICANCj4gPiBAQCAtMTEyMSw2ICsxMTgzLDggQEAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1
bGUodm9pZCkNCj4gPiAgCWlmIChyZXQpDQo+ID4gIAkJcmV0dXJuIHJldDsNCj4gPiAgDQo+ID4g
KwlwcmludF9iYXNpY19zeXNpbmZvKCZzeXNpbmZvKTsNCj4gPiArDQo+ID4gIAkvKg0KPiA+ICAJ
ICogVG8ga2VlcCB0aGluZ3Mgc2ltcGxlLCBhc3N1bWUgdGhhdCBhbGwgVERYLXByb3RlY3RlZCBt
ZW1vcnkNCj4gPiAgCSAqIHdpbGwgY29tZSBmcm9tIHRoZSBwYWdlIGFsbG9jYXRvci4gIE1ha2Ug
c3VyZSBhbGwgcGFnZXMgaW4gdGhlDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguaCBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+IGluZGV4IGI1ZWI3
YzM1ZjFkYy4uODYxZGRmMmMyZTg4IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+IEBA
IC0zMSw2ICszMSwxNSBAQA0KPiA+ICAgKg0KPiA+ICAgKiBTZWUgdGhlICJnbG9iYWxfbWV0YWRh
dGEuanNvbiIgaW4gdGhlICJURFggMS41IEFCSSBkZWZpbml0aW9ucyIuDQo+ID4gICAqLw0KPiA+
ICsjZGVmaW5lIE1EX0ZJRUxEX0lEX1NZU19BVFRSSUJVVEVTCQkweDBBMDAwMDAyMDAwMDAwMDBV
TEwNCj4gPiArI2RlZmluZSBNRF9GSUVMRF9JRF9URFhfRkVBVFVSRVMwCQkweDBBMDAwMDAzMDAw
MDAwMDhVTEwNCj4gPiArI2RlZmluZSBNRF9GSUVMRF9JRF9CVUlMRF9EQVRFCQkJMHg4ODAwMDAw
MjAwMDAwMDAxVUxMDQo+ID4gKyNkZWZpbmUgTURfRklFTERfSURfQlVJTERfTlVNCQkJMHg4ODAw
MDAwMTAwMDAwMDAyVUxMDQo+ID4gKyNkZWZpbmUgTURfRklFTERfSURfTUlOT1JfVkVSU0lPTgkJ
MHgwODAwMDAwMTAwMDAwMDAzVUxMDQo+ID4gKyNkZWZpbmUgTURfRklFTERfSURfTUFKT1JfVkVS
U0lPTgkJMHgwODAwMDAwMTAwMDAwMDA0VUxMDQo+ID4gKyNkZWZpbmUgTURfRklFTERfSURfVVBE
QVRFX1ZFUlNJT04JCTB4MDgwMDAwMDEwMDAwMDAwNVVMTA0KPiA+ICsjZGVmaW5lIE1EX0ZJRUxE
X0lEX0lOVEVSTkFMX1ZFUlNJT04JCTB4MDgwMDAwMDEwMDAwMDAwNlVMTA0KPiANCj4gVGhpcyBp
cyB3aGVyZSBJIHdvdWxkIHJhdGhlciBub3QgdGFrZSB5b3VyIHdvcmQgZm9yIGl0LCBvciBnbyBy
ZXZpZXcNCj4gdGhlc2UgY29uc3RhbnRzIG15c2VsZiBpZiB0aGVzZSB3ZXJlIGF1dG9nZW5lcmF0
ZWQgZnJvbSBwYXJzaW5nIGpzb24uDQoNCkknbGwgbG9vayBpbnRvIGhvdyB0byBhdXRvLWdlbmVy
YXRlIGJhc2VkIG9uIEpTT04gZmlsZS4NCg0KPiANCj4gPiArDQo+ID4gICNkZWZpbmUgTURfRklF
TERfSURfTUFYX1RETVJTCQkJMHg5MTAwMDAwMTAwMDAwMDA4VUxMDQo+ID4gICNkZWZpbmUgTURf
RklFTERfSURfTUFYX1JFU0VSVkVEX1BFUl9URE1SCTB4OTEwMDAwMDEwMDAwMDAwOVVMTA0KPiA+
ICAjZGVmaW5lIE1EX0ZJRUxEX0lEX1BBTVRfNEtfRU5UUllfU0laRQkJMHg5MTAwMDAwMTAwMDAw
MDEwVUxMDQo+ID4gQEAgLTEyNCw4ICsxMzMsMjggQEAgc3RydWN0IHRkbXJfaW5mb19saXN0IHsN
Cj4gPiAgICoNCj4gPiAgICogTm90ZSBub3QgYWxsIG1ldGFkYXRhIGZpZWxkcyBpbiBlYWNoIGNs
YXNzIGFyZSBkZWZpbmVkLCBvbmx5IHRob3NlDQo+ID4gICAqIHVzZWQgYnkgdGhlIGtlcm5lbCBh
cmUuDQo+ID4gKyAqDQo+ID4gKyAqIEFsc28gbm90ZSB0aGUgImJpdCBkZWZpbml0aW9ucyIgYXJl
IGFyY2hpdGVjdHVyYWwuDQo+ID4gICAqLw0KPiA+ICANCj4gPiArLyogQ2xhc3MgIlREWCBNb2R1
bGUgSW5mbyIgKi8NCj4gPiArc3RydWN0IHRkeF9zeXNpbmZvX21vZHVsZV9pbmZvIHsNCj4gDQo+
IFRoaXMgbmFtZSBmZWVscyB0b28gZ2VuZXJpYywgcGVyaGFwcyAndGR4X3N5c19pbmZvX2ZlYXR1
cmVzJyBtYWtlcyBpdA0KPiBjbGVhcmVyPw0KDQpJIHdhbnRlZCB0byBuYW1lIHRoZSBzdHJ1Y3R1
cmUgZm9sbG93aW5nIHRoZSAiQ2xhc3MiIG5hbWUgaW4gdGhlIEpTT04NCmZpbGUuICBCb3RoICdz
eXNfYXR0cmlidXRlcycgYW5kICd0ZHhfZmVhdHVlcmVzMCcgYXJlIHVuZGVyIGNsYXNzICJNb2R1
bGUNCkluZm8iLg0KDQpJIGd1ZXNzICJhdHRyaWJ1dGVzIiBhcmUgbm90IG5lY2Vzc2FyaWx5IGZl
YXR1cmVzLg0KDQo+ID4gKwl1MzIgc3lzX2F0dHJpYnV0ZXM7DQo+ID4gKwl1NjQgdGR4X2ZlYXR1
cmVzMDsNCj4gPiArfTsNCj4gPiArDQo+ID4gKyNkZWZpbmUgVERYX1NZU19BVFRSX0RFQlVHX01P
RFVMRQkweDENCj4gPiArDQo+ID4gKy8qIENsYXNzICJURFggTW9kdWxlIFZlcnNpb24iICovDQo+
ID4gK3N0cnVjdCB0ZHhfc3lzaW5mb19tb2R1bGVfdmVyc2lvbiB7DQo+ID4gKwl1MTYgbWFqb3I7
DQo+ID4gKwl1MTYgbWlub3I7DQo+ID4gKwl1MTYgdXBkYXRlOw0KPiA+ICsJdTE2IGludGVybmFs
Ow0KPiA+ICsJdTE2IGJ1aWxkX251bTsNCj4gPiArCXUzMiBidWlsZF9kYXRlOw0KPiA+ICt9Ow0K
PiA+ICsNCj4gPiAgLyogQ2xhc3MgIlRETVIgSW5mbyIgKi8NCj4gPiAgc3RydWN0IHRkeF9zeXNp
bmZvX3RkbXJfaW5mbyB7DQo+ID4gIAl1MTYgbWF4X3RkbXJzOw0KPiA+IEBAIC0xMzQsNyArMTYz
LDkgQEAgc3RydWN0IHRkeF9zeXNpbmZvX3RkbXJfaW5mbyB7DQo+ID4gIH07DQo+ID4gIA0KPiA+
ICBzdHJ1Y3QgdGR4X3N5c2luZm8gew0KPiA+IC0Jc3RydWN0IHRkeF9zeXNpbmZvX3RkbXJfaW5m
byB0ZG1yX2luZm87DQo+ID4gKwlzdHJ1Y3QgdGR4X3N5c2luZm9fbW9kdWxlX2luZm8JCW1vZHVs
ZV9pbmZvOw0KPiA+ICsJc3RydWN0IHRkeF9zeXNpbmZvX21vZHVsZV92ZXJzaW9uCW1vZHVsZV92
ZXJzaW9uOw0KPiA+ICsJc3RydWN0IHRkeF9zeXNpbmZvX3RkbXJfaW5mbwkJdGRtcl9pbmZvOw0K
PiANCj4gQ29tcGFyZSB0aGF0IHRvOg0KPiANCj4gICAgICAgICBzdHJ1Y3QgdGR4X3N5c19pbmZv
IHsNCj4gICAgICAgICAgICAgICAgIHN0cnVjdCB0ZHhfc3lzX2luZm9fZmVhdHVyZXMgZmVhdHVy
ZXM7DQo+ICAgICAgICAgICAgICAgICBzdHJ1Y3QgdGR4X3N5c19pbmZvX3ZlcnNpb24gdmVyc2lv
bjsNCj4gICAgICAgICAgICAgICAgIHN0cnVjdCB0ZHhfc3lzX2luZm9fdGRtciB0ZG1yOw0KPiAg
ICAgICAgIH07DQo+IA0KPiAuLi5hbmQgdGVsbCBtZSB3aGljaCBvaW5lIGlzIGVhc2llciB0byBy
ZWFkLg0KDQpJIGFncmVlIHRoaXMgaXMgZWFzaWVyIHRvIHJlYWQgaWYgd2UgZG9uJ3QgbG9vayBh
dCB0aGUgSlNPTiBmaWxlLiAgT24gdGhlDQpvdGhlciBoYW5kLCBmb2xsb3dpbmcgSlNPTiBmaWxl
J3MgIkNsYXNzIiBuYW1lcyBJTUhPIHdlIGNhbiBtb3JlIGVhc2lseQ0KZmluZCB3aGljaCBjbGFz
cyB0byBsb29rIGF0IGZvciBhIGdpdmVuIG1lbWJlci4NCg0KU28gSSB0aGluayB0aGV5IGJvdGgg
aGF2ZSBwcm9zL2NvbnMsIGFuZCBJIGhhdmUgbm8gaGFyZCBvcGluaW9uIG9uIHRoaXMuDQoNCg0K
DQo=

