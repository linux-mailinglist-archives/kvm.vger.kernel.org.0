Return-Path: <kvm+bounces-53767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1EFB169D7
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 03:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2605674C3
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 01:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F297DA7F;
	Thu, 31 Jul 2025 01:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQEcahup"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA8D3C3C;
	Thu, 31 Jul 2025 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753924043; cv=fail; b=qrI9sHDohENKeNQj8lvWfsCtRFt/h4mIadtckMeJeld+l1kKiAiLdlXRO+xD7SNo4+P+1+4cV+YxecDbRuOLSP8GxJiJr7mYtdcQj+XZWwTQOsiOZtw8SVXl7ZM1cPUM2tmH0UE87xMA5T/8jD13yp7uDVNTSu+v1byrGB2BU3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753924043; c=relaxed/simple;
	bh=nLvROgiK3QwD32DVNWBErrnhyPOojA4pqQBFciDIs3w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VNvqqinYH36rOOqrG4+Bjr1qFcowWsHWRREfcHIKWMRDSG5YkHAqPZ8IbcU4LIgvW/AHTMaBgF/U8JLHHuEQaedbm2mGi/Dul5x6zRcmQYNav7SkxA1LkMoOm04+auiil87FoxVCDEzPhsf0NyVaTtwnUUcDimam+YdoqNnLHFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQEcahup; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753924042; x=1785460042;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nLvROgiK3QwD32DVNWBErrnhyPOojA4pqQBFciDIs3w=;
  b=cQEcahup3YBj98Txa84NAvBuF4TxRakOhKZohbVd7ibngF90YUEkgZ5V
   spMPYhNd+iy/NzOKu1qDEZWIK4m2ug9QG1adASp81hh1v/Zx5z2R9sQyc
   HMopJ2OEQB37xjmdnvhSpNtgPM2Vp0HQ0BbVHWQfhMjAC7a3Y/5Ifzwpk
   rN7t9ULYJc5yh3wK28QMZkx5nQ7+lPqKZxweXUOUfThw2nXvnap9BUyU7
   s+OEuhqExcjXo2lpHduV2u31klvuFY90GguYS4AE3SGu74EHJVK47nYRJ
   K7QDcA+sKzd1kzJk5iHlhkgI0aktNQF4eAWuNwWXbwEvlNM3rW+AUMTRE
   A==;
X-CSE-ConnectionGUID: oRE1TnlRQIeSBVwkrHX0dw==
X-CSE-MsgGUID: pvjKkepiQwazBCgYDJ9bLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="55442994"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="55442994"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 18:07:21 -0700
X-CSE-ConnectionGUID: yK3oY3xyTFO/EvwyXWYlwA==
X-CSE-MsgGUID: 3/OvjiY+TwyickWy7qYFFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="163579627"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 18:07:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 18:07:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 18:07:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.46)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 18:07:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YD5T11BwDqTkY0YiKqOWd8pkv8cSLeDsfxLQL6MvECjQnBxe5S7Rc1StXb02+GtlM6Sd8cALh+VcveMA94QPAjlhYjAcQSa+5ZJOvOslU6imKH2FtL7tFGbs0o36DH1xu4F7QIi4ZFmPJtikJI5caLYt8jJ+Aldfudbugb6AeMM4LCICvuWGlgsnIwkBdRGG7mGzUIAAoGaW1cfHPZD4oAvgWfW5Ws/DKJQWCLKDMx7OK3cjWz5D+dXyWLmhdmFO2AsymGidrbclgsM/6iw2Qv7T0EzQCRuGIv9aAl2G2VaBlk4EqnsWXhojOn1jrvoNQ7lhfe/DTpr7U0sddg/k6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLvROgiK3QwD32DVNWBErrnhyPOojA4pqQBFciDIs3w=;
 b=RXPEFsPo4iy6UK3hS2iZfJmK+TCJ8KrwId3PGhRUUfA7sSilkPIuFBlDCMditv3+vMXN9GYVpsAvIBCXwoTyDBOZWJuE32mvQRC6tz8ZtJF07gYF7ue8Z8505zTx368bIvmZ6kgfTAtfbQEnDq7RIgEe/HkmoWB3qWgXXMDxrgpx5sf1n+nSE9z9ZlGs1GAqvZd6yn5SYOtQJxRWamD38mSBtkz3tXfGB/wTgO3SJMxItV3l4/1y9hvoG1BLkIjP1Nao6pUBYOzxlmclKHG/jMOlDURQz6xX6rGXbS1WMdeVeiNmNzQLVGOMSJ5MSTaAnS8PRDxkY6cH04FTPmyUQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB5011.namprd11.prod.outlook.com (2603:10b6:303:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Thu, 31 Jul
 2025 01:06:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Thu, 31 Jul 2025
 01:06:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHb2XKq2FQX8GuFvk+Y5LjRpGfbTbQURMoAgDd3BQA=
Date: Thu, 31 Jul 2025 01:06:33 +0000
Message-ID: <3b2d90dc8ae619c5d9372d6c5e22c47aeea1ef0b.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
	 <c3f77974-f1d6-4a22-bd1d-2678427a9fb1@intel.com>
In-Reply-To: <c3f77974-f1d6-4a22-bd1d-2678427a9fb1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB5011:EE_
x-ms-office365-filtering-correlation-id: 4494192b-340e-477b-7baf-08ddcfce7df0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OTJyTVFlOVhETklCZXVEcE5vbXRleU01U2l5Mkw3MC9YYzdaNjRMZ1U5cEVE?=
 =?utf-8?B?Wk8vVDc4a0RqZ2wyUzg3aWlocmFyajV0U1c1MjNMK0FMOUdVOG1TdVVKaURt?=
 =?utf-8?B?U3lGK0p3ZWdLU0pJN0x3SE8yQ0c0WUI4czV6WFhrcWhXN2NCYzRoNXpGeW9J?=
 =?utf-8?B?dXVVZEhyZGhCZVBLbTc3aXN0QTk2Z0U2anIzNjNPaXFMTHlRYmVDUDJPdXZ6?=
 =?utf-8?B?djljWDlhZGg4RXoxQjR6TlI5RkpwTm0xTm1kMVVkQmVpMDk0ZVNBWEdHWGlR?=
 =?utf-8?B?WlR5N3lJVmFVS3R0VWF2OHJnYndKazRDMU9JZzhiTmRPYWc5SStRallDZGxK?=
 =?utf-8?B?M09wOUxzOFlhR1dmWTAvQkNMejRpczNDR1laTVFKdXJZTnc2TFpIbW5HNjdD?=
 =?utf-8?B?dHdKaTJvVkg0RkZrNWRMQzZoM3FjZDVnTHBmUkJEUWtVRkpxclVTVmlhOTlP?=
 =?utf-8?B?SUtkTXdQR1pkRnZiSmhCOTBua24yLzczZ2FoUmgxY0NoaW9TOHFFS3p2NWNU?=
 =?utf-8?B?MmVFYVkvOXV5TkpwRnZ0MDhyYndVcEZBWndpSHhLVXJLTTZOYjJBeGRtRE5M?=
 =?utf-8?B?TjBYRDdmRU9zbzlVbDU0Y25qRFMrT05ZMVltTEl3d0lIMmdJTFJBZEtRU2Zi?=
 =?utf-8?B?bTRsSzUxUlpaS0NIRDhHdkFqZG83SnFseCtWUk94UW1YTFR0Zzg4MUd6MG5a?=
 =?utf-8?B?Sld4SWdFY1pvMkw4Z3ozRWpkemRVR1o4cEF5L013VmdQV2hrL2NMTFdSU0Fq?=
 =?utf-8?B?YkJ2NzhMNWVCZ1N3MUgxcEw2Mk9BRjZLMGw2dU5Ja1hnckMzVzk2YTBJOG03?=
 =?utf-8?B?ZFlqWFdSK2dPYzVhSTFFQ3lDa2xTTEppeEw1aVNDV25UbVUvUUJDSTN2a3pP?=
 =?utf-8?B?V0grRDFyeXRtZkRab1ZPa25JRTRrbCtFeEJEaDR6SnVqb2dtRXV6cVNqQVBP?=
 =?utf-8?B?Q2Z5c2trWVBFY1l6YTlGWUVmNjlsSE5KV1dWeEpqc0tvcytoRkFIOXlxUm9T?=
 =?utf-8?B?NDc2aFI2SWdpVll2SWVnQjg3OEEyRVhJREFUNDRJQzJHb0hFRHRqR0ExV0I0?=
 =?utf-8?B?NENrT0RNZjFJMysyL1czSUR0K0FQWVRnQWRMVUZxemFGN2k0YW1OS0N4M1NX?=
 =?utf-8?B?OWhKRlNDTXh2Nm9RMkRWS2tacnViTGxZbVl4SjJHdldjeEVES1BIdVltZ3Jh?=
 =?utf-8?B?VlNYVGhsdE9DaVliM3BQcksySTduVm9uV3F6UHZuT3o2am8zUW5tUWtWWTht?=
 =?utf-8?B?MG9VeGZxeGhQTnJtdXhaUkoyMDNVV2t0TFdNMERHYzZWUFphcnZXWDg1SGRi?=
 =?utf-8?B?TllTV3lxVHlETjAvWVVMOC9MNWwzT2Z5R1UrcDJsVDMvYXNOL0JsK3ZsMGNF?=
 =?utf-8?B?K2ZRb2NzeDZEbkhEbSsvU3I5SmdFSEtMdVo0Ry9CRGhTb0Qyc1B0V3lqSllJ?=
 =?utf-8?B?VDV4U2k0cWYzUkdQamJyWmhibk1zVTFqd2s0WUNUaUdxeDdjdkhYWUEyWVJC?=
 =?utf-8?B?bmIxeWdnQ0YwQklJOXUyS20wWVVKOWtQSEgxRDFGVXZ2c2Rsa0VUWTYrcndN?=
 =?utf-8?B?SHVHZ1RBcFpKKzNCYis2dVk1cEtqVjhITDlJWUFxNld3ZXV4Qk16cG5ydzhQ?=
 =?utf-8?B?dVBQcFpqemt1QU51bEYzU1VGWkdQU2V5c0hGMk5GWTVYdVo5Ukk4SEFSOGt3?=
 =?utf-8?B?bU41czZHMHh2L3I3TFdMVGZpOUdqdyt2SE9RYlRzNnlpaTk0ZGpKekUvbkhR?=
 =?utf-8?B?M2dTY2ZTcE5IdDlmemVXd0llR3FDMEZKUkRhMkRUTllMTlQ3Vm9nemNkTGRw?=
 =?utf-8?B?bmMxUjlEbGVnQmFzaG16NGgrMFZpdWtTdkRIMHU1RGoxcFF0dlM1N0hSeDZw?=
 =?utf-8?B?Rm5LMkFadjZjVW5NaEplTmlZVURxY3VHS0pzQk5OMUFBbFM0Vk92anBjZElz?=
 =?utf-8?B?cUxtdmtlSnpxSHgxV0JaSDd4V2ZCbjZqbDNkV21oWVhOYlZTZmNwNzErNjFX?=
 =?utf-8?Q?eMVqDvt9UaCwBu0YWXQIAegN+3Kb8k=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWdGb3FYWHdkdG15Z3RNeVVxdERlZFZDM0NQZG5iMk9LVC9KUlRVemFOcFpV?=
 =?utf-8?B?VXUrczVDWU9qNzNnU013Ti9KUExqcGxCNTNMZktRMmtDT0xvdUZQV2htcE5z?=
 =?utf-8?B?OGwyMFhPV0tRVDk3MGlWMlpsMHNZZklwcVB2YysxZE90L3VBNGdDS1N1SnBB?=
 =?utf-8?B?bHBCeTBLNk13NXFtMUIxanpEZm1zTCtMZGJWY2FoTlBNZXFwcTFEaHB3Rndp?=
 =?utf-8?B?clVpNDhLZFJ1RnRXWG4wWld3SjBtU09hNklwNkd1T3JLV1U0SjlqSG9CMFVw?=
 =?utf-8?B?dmtURlQ1VzdHbkFnUWJzeUtuTXorc2ZZcUd5THpEYTF0ODBBdTVNSk9Kdng5?=
 =?utf-8?B?amd5SXUxUERGTVVQTTU4TVBFMkhWQ281TmJQMHpOZi9tOXF1WXBFbjRzcmVa?=
 =?utf-8?B?eTVoYlZ2Uk5sY0FwMjRVcXl0dUVUOURLajd4MWtLRmg1OEhyS2wyVUFKeC9l?=
 =?utf-8?B?OTByVldWc0wrOWErTUpvTjdSdi9YTWZFSVAzVTdtWG9sd1BWU2lZSlNEY05z?=
 =?utf-8?B?bHdOVkhEZ1QzOUk5WE5CM3E4OG8xRzVvNHM4SEZjZEUxbTFPU0tFWTc1U3JG?=
 =?utf-8?B?WFZzOEg1RVdZa3QwWXMrYnREejU0RUFVT1F0MHU2WnprTTlPNXRZbktURUJw?=
 =?utf-8?B?UlRjUTdXajdQb3RkZWNLTS92cUt0dCsyT21HYUNLOFF4RzVmSXVUVmJ6ZU9B?=
 =?utf-8?B?ak9LRVo3TGFjdWxFdFBlWTQ0eHBOeEtUVzg1WDlrR0VHc3I0d1hDd2JqWEJu?=
 =?utf-8?B?SDB2N01CWHlnYlZvcm1zMHR3bXVmc3B4MHhLZ3VGdGw1bWxNSFdVb2VyeHZn?=
 =?utf-8?B?WUtTYXNzclc0S0hlb0dnSGhjQmFRcmJQc2YrbVc4UjlFSGxCK1VxOCtUZnQy?=
 =?utf-8?B?anJxdVlFUDRRaDQzQ29EYjREZkRDZWRLZVZOa0hMMHFBVUFOTXlmdnZWVENK?=
 =?utf-8?B?bDZWTWJSMHR0KzVkUWwxTDZNeVJvbGxUbGdXT1hTZUlUSGVyNjdLWW9kb3JG?=
 =?utf-8?B?ZmVtZmMydDRvNU9lQ3R0ZmFENU9BZEZMMkRDb1RkNWJFWFFzeGFMTE55THBH?=
 =?utf-8?B?UndSYnNXd3VaODlkaHZOWGNGWjk3eWY0dllhRzRkR0d1WlpXTzZKTXVVWnBW?=
 =?utf-8?B?a25RVnk5K3VwMnVMZVBQUU1ZZ0FaSkd2V0NHTlcyeC9lSWlEbDQyNEZKZlZ2?=
 =?utf-8?B?c3ZhWVBmZnBHbHZ1dVY1bllVVXcyd2FJK0RBK2FQYWcxM0JNbStYK3VDZ2Jy?=
 =?utf-8?B?WkdKR1daUHI2OG55S0VBVWtMS2hob3A0SC91UnFvQ2xvT2xKazcyeWJYMXhJ?=
 =?utf-8?B?RldWTTExSGZBZ0ZldGtWRXoxM0p4aEE2WWJ4SGk1RkxyVnh0ZVRidFg3Yzhl?=
 =?utf-8?B?blIxQzlWRW5rOWZ3TXV5MWhIODBWMndsaVlJZUlQODlWZVRRaEs0bjRRbkFy?=
 =?utf-8?B?OVcyd3ZKaXNhdjBaam94RUJQYXB5QUZSc2xsR0FXNUp3S3U1YTlZUHcyRENl?=
 =?utf-8?B?SFEyWXp0MzI4NHl0U1R4M3R2d2pMb3I3SUE0TUpOaXJqenIxWlMreE1Cc1VP?=
 =?utf-8?B?aERIdjJudml2Q2FHVFB6OUF5VlJxNytudTBQeFZnSzV3WWhTS3pzSDVNNnV0?=
 =?utf-8?B?cEpWZVBVWDVGalBMaTBLeWZZeFJMa2lCQUpEWUhyNzlzOGxjRDl5TldwK2RP?=
 =?utf-8?B?dlVSMnBEeWh5V1dRYjJ4K09FdFdQd0RRNCtsbzREZ3RVcUxSVFZ0dkFTc3or?=
 =?utf-8?B?WnhvUVhRbjMzOEhKaGxsYVkwWWEycmdhaGlxMU1kdkI2ZWJpd3QxckdMQnA2?=
 =?utf-8?B?amZUaS9YNDlhTExvcWpxdStqNFRES0R4MGltYzk4R3BpeU1wTkpMZ29YRjBL?=
 =?utf-8?B?TUdDalJtangzUzFHdW5mNi9ya1AxOE9tUkJuWVlyRnBwZ0dwamVqMDVOVHZu?=
 =?utf-8?B?TWZmUDlJMVRmTEQ2OWdzeU44RmFOTTl3NW00UW5pMTRMVmtXT3lVZzNBc0ox?=
 =?utf-8?B?bmdVMUJUZGtkeW9mNUg3V2N0WXpOQlkyNko3blRCVXBZZksyVUV0cFI1cytV?=
 =?utf-8?B?NGZYSzJVRUxSbE04U0Z0VHhPTUpjeFZocUg0UDcvcDlNbjNtMDg0K0tFT0dU?=
 =?utf-8?B?R1RYTVgwS3lDUlR2SkxFN1FBRnlDZGc3MUJQbHU5RndqYW9UbFlveFBjQXRX?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D73B38F8FFB874783284A4514E83013@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4494192b-340e-477b-7baf-08ddcfce7df0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2025 01:06:33.9061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UINFKOUe1f+unHs7zFVzvyspTdTChEQtDm1bfzIpsPoqLMw1UZKSxg7t06mCB5cUCaA3EFuwVOxhcNenyLLRNaCFPWCCy+45uwoYIcm/RHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5011
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDExOjA2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
VGhpcyBpcyB0aGUgd3JvbmcgcGxhY2UgdG8gZG8gdGhpcy4NCj4gDQo+IEhpZGUgaXQgaW4gdGRt
cl9nZXRfcGFtdF9zeigpLiBEb24ndCBpbmplY3QgaXQgaW4gdGhlIG1haW4gY29kZSBmbG93DQo+
IGhlcmUgYW5kIGNvbXBsaWNhdGUgdGhlIGZvciBsb29wLg0KDQpJJ20gZmluZGluZyB0aGlzIHRk
bXJfZ2V0X3BhbXRfc3ooKSBtYXliZSB0b28gc3RyYW5nZSB0byBidWlsZCBvbiB0b3Agb2YuIA0K
SXQgaXRlcmF0ZXMgdGhyb3VnaCB0aGVzZSBzcGVjaWFsIFREWCBwYWdlIHNpemVzIG9uY2UsIGFu
ZCBjYWxscyBpbnRvIA0KdGRtcl9nZXRfcGFtdF9zeigpIGZvciBlYWNoLCB3aGljaCBpbiB0dXJu
IGhhcyBhIGNhc2Ugc3RhdGVtZW50IGZvciBlYWNoIA0KaW5kZXguIFNvIHRoZSBsb29wIGRvZXNu
J3QgYWRkIG11Y2ggLSBlYWNoIGluZGV4IHN0aWxsIGhhcyBpdHMgb3duIGxpbmUgDQpvZiBjb2Rl
IGluc2lkZSB0ZG1yX2dldF9wYW10X3N6KCkuIEFuZCB0aGVuIGRlc3BpdGUgcHJlcHBpbmcgdGhl
IGJhc2Uvc2l6ZSANCmluIGFuIGFycmF5IHZpYSB0aGUgbG9vcCwgaXQgaGFzIHRvIGJlIHBhY2tl
ZCBtYW51YWxseSBhdCB0aGUgZW5kIGZvciBlYWNoIA0KaW5kZXguIFNvIEknbSBub3Qgc3VyZSBp
ZiB0aGUgZ2VuZXJhbCB3aXNkb20gb2YgZG9pbmcgdGhpbmdzIGluIGEgc2luZ2xlIHdheSANCmlz
IHJlYWxseSBhZGRpbmcgbXVjaCBoZXJlLg0KDQpJJ20gd29uZGVyaW5nIGlmIHNvbWV0aGluZyBs
aWtlIHRoZSBiZWxvdyBtaWdodCBiZSBhIGJldHRlciBiYXNlIHRvIGJ1aWxkIA0Kb24uIEZvciBk
cGFtdCB0aGUgInRkbXItPnBhbXRfNGtfc2l6ZSA9IiBsaW5lIGNvdWxkIGp1c3QgYnJhbmNoIG9u
IA0KdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFtdCgpLiBBbnkgdGhvdWdodHMgb24gaXQgYXMgYW4g
YWx0ZXJuYXRpdmUgdG8gdGhlIA0Kc3VnZ2VzdGlvbiB0byBhZGQgdGhlIGRwYW10IGxvZ2ljIHRv
IHRkbXJfZ2V0X3BhbXRfc3ooKT8NCg0KIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDY5
ICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA1MSBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KaW5kZXggYzdhOWEwODdjY2FmLi44ZGU2ZmEzZTU3
NzMgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCisrKyBiL2FyY2gv
eDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KQEAgLTQ0NSwzMCArNDQ1LDE2IEBAIHN0YXRpYyBpbnQg
ZmlsbF9vdXRfdGRtcnMoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QsDQogICogUEFNVCBzaXpl
IGlzIGFsd2F5cyBhbGlnbmVkIHVwIHRvIDRLIHBhZ2UgYm91bmRhcnkuDQogICovDQogc3RhdGlj
IHVuc2lnbmVkIGxvbmcgdGRtcl9nZXRfcGFtdF9zeihzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLCBp
bnQgcGdzeiwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTE2IHBhbXRf
ZW50cnlfc2l6ZSkNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTE2IHBh
bXRfZW50cnlfc2l6ZVtdKQ0KIHsNCiAgICAgICAgdW5zaWduZWQgbG9uZyBwYW10X3N6LCBucl9w
YW10X2VudHJpZXM7DQorICAgICAgIGNvbnN0IGludCB0ZHhfcGdfc2l6ZV9zaGlmdFtdID0geyBQ
QUdFX1NISUZULCBQTURfU0hJRlQsIFBVRF9TSElGVCB9Ow0KIA0KLSAgICAgICBzd2l0Y2ggKHBn
c3opIHsNCi0gICAgICAgY2FzZSBURFhfUFNfNEs6DQotICAgICAgICAgICAgICAgbnJfcGFtdF9l
bnRyaWVzID0gdGRtci0+c2l6ZSA+PiBQQUdFX1NISUZUOw0KLSAgICAgICAgICAgICAgIGJyZWFr
Ow0KLSAgICAgICBjYXNlIFREWF9QU18yTToNCi0gICAgICAgICAgICAgICBucl9wYW10X2VudHJp
ZXMgPSB0ZG1yLT5zaXplID4+IFBNRF9TSElGVDsNCi0gICAgICAgICAgICAgICBicmVhazsNCi0g
ICAgICAgY2FzZSBURFhfUFNfMUc6DQotICAgICAgICAgICAgICAgbnJfcGFtdF9lbnRyaWVzID0g
dGRtci0+c2l6ZSA+PiBQVURfU0hJRlQ7DQotICAgICAgICAgICAgICAgYnJlYWs7DQotICAgICAg
IGRlZmF1bHQ6DQotICAgICAgICAgICAgICAgV0FSTl9PTl9PTkNFKDEpOw0KLSAgICAgICAgICAg
ICAgIHJldHVybiAwOw0KLSAgICAgICB9DQorICAgICAgIG5yX3BhbXRfZW50cmllcyA9IHRkbXIt
PnNpemUgPj4gdGR4X3BnX3NpemVfc2hpZnRbcGdzel07DQorICAgICAgIHBhbXRfc3ogPSBucl9w
YW10X2VudHJpZXMgKiBwYW10X2VudHJ5X3NpemVbcGdzel07DQogDQotICAgICAgIHBhbXRfc3og
PSBucl9wYW10X2VudHJpZXMgKiBwYW10X2VudHJ5X3NpemU7DQogICAgICAgIC8qIFREWCByZXF1
aXJlcyBQQU1UIHNpemUgbXVzdCBiZSA0SyBhbGlnbmVkICovDQotICAgICAgIHBhbXRfc3ogPSBB
TElHTihwYW10X3N6LCBQQUdFX1NJWkUpOw0KLQ0KLSAgICAgICByZXR1cm4gcGFtdF9zejsNCisg
ICAgICAgcmV0dXJuIFBBR0VfQUxJR04ocGFtdF9zeik7DQogfQ0KIA0KIC8qDQpAQCAtNTA5LDI1
ICs0OTUsMTkgQEAgc3RhdGljIGludCB0ZG1yX3NldF91cF9wYW10KHN0cnVjdCB0ZG1yX2luZm8g
KnRkbXIsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGxpc3RfaGVhZCAqdG1i
X2xpc3QsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgdTE2IHBhbXRfZW50cnlfc2l6ZVtd
KQ0KIHsNCi0gICAgICAgdW5zaWduZWQgbG9uZyBwYW10X2Jhc2VbVERYX1BTX05SXTsNCi0gICAg
ICAgdW5zaWduZWQgbG9uZyBwYW10X3NpemVbVERYX1BTX05SXTsNCi0gICAgICAgdW5zaWduZWQg
bG9uZyB0ZG1yX3BhbXRfYmFzZTsNCiAgICAgICAgdW5zaWduZWQgbG9uZyB0ZG1yX3BhbXRfc2l6
ZTsNCiAgICAgICAgc3RydWN0IHBhZ2UgKnBhbXQ7DQotICAgICAgIGludCBwZ3N6LCBuaWQ7DQot
DQorICAgICAgIGludCBuaWQ7DQogICAgICAgIG5pZCA9IHRkbXJfZ2V0X25pZCh0ZG1yLCB0bWJf
bGlzdCk7DQogDQogICAgICAgIC8qDQogICAgICAgICAqIENhbGN1bGF0ZSB0aGUgUEFNVCBzaXpl
IGZvciBlYWNoIFREWCBzdXBwb3J0ZWQgcGFnZSBzaXplDQogICAgICAgICAqIGFuZCB0aGUgdG90
YWwgUEFNVCBzaXplLg0KICAgICAgICAgKi8NCi0gICAgICAgdGRtcl9wYW10X3NpemUgPSAwOw0K
LSAgICAgICBmb3IgKHBnc3ogPSBURFhfUFNfNEs7IHBnc3ogPCBURFhfUFNfTlI7IHBnc3orKykg
ew0KLSAgICAgICAgICAgICAgIHBhbXRfc2l6ZVtwZ3N6XSA9IHRkbXJfZ2V0X3BhbXRfc3oodGRt
ciwgcGdzeiwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwYW10X2Vu
dHJ5X3NpemVbcGdzel0pOw0KLSAgICAgICAgICAgICAgIHRkbXJfcGFtdF9zaXplICs9IHBhbXRf
c2l6ZVtwZ3N6XTsNCi0gICAgICAgfQ0KKyAgICAgICB0ZG1yLT5wYW10XzRrX3NpemUgPSB0ZG1y
X2dldF9wYW10X3N6KHRkbXIsIFREWF9QU180SywgcGFtdF9lbnRyeV9zaXplKTsNCisgICAgICAg
dGRtci0+cGFtdF8ybV9zaXplID0gdGRtcl9nZXRfcGFtdF9zeih0ZG1yLCBURFhfUFNfMk0sIHBh
bXRfZW50cnlfc2l6ZSk7DQorICAgICAgIHRkbXItPnBhbXRfMWdfc2l6ZSA9IHRkbXJfZ2V0X3Bh
bXRfc3oodGRtciwgVERYX1BTXzFHLCBwYW10X2VudHJ5X3NpemUpOw0KKyAgICAgICB0ZG1yX3Bh
bXRfc2l6ZSA9IHRkbXItPnBhbXRfNGtfc2l6ZSArIHRkbXItPnBhbXRfMm1fc2l6ZSArIHRkbXIt
PnBhbXRfMWdfc2l6ZTsNCiANCiAgICAgICAgLyoNCiAgICAgICAgICogQWxsb2NhdGUgb25lIGNo
dW5rIG9mIHBoeXNpY2FsbHkgY29udGlndW91cyBtZW1vcnkgZm9yIGFsbA0KQEAgLTUzNSwyNiAr
NTE1LDE2IEBAIHN0YXRpYyBpbnQgdGRtcl9zZXRfdXBfcGFtdChzdHJ1Y3QgdGRtcl9pbmZvICp0
ZG1yLA0KICAgICAgICAgKiBpbiBvdmVybGFwcGVkIFRETVJzLg0KICAgICAgICAgKi8NCiAgICAg
ICAgcGFtdCA9IGFsbG9jX2NvbnRpZ19wYWdlcyh0ZG1yX3BhbXRfc2l6ZSA+PiBQQUdFX1NISUZU
LCBHRlBfS0VSTkVMLA0KLSAgICAgICAgICAgICAgICAgICAgICAgbmlkLCAmbm9kZV9vbmxpbmVf
bWFwKTsNCi0gICAgICAgaWYgKCFwYW10KQ0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIG5pZCwgJm5vZGVfb25saW5lX21hcCk7DQorICAgICAgIGlmICghcGFtdCkgew0KKyAgICAg
ICAgICAgICAgIC8qIFplcm8gYmFzZSBzbyB0aGF0IHRoZSBlcnJvciBwYXRoIHdpbGwgc2tpcCBm
cmVlaW5nLiAqLw0KKyAgICAgICAgICAgICAgIHRkbXItPnBhbXRfNGtfYmFzZSA9IDA7DQogICAg
ICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQotDQotICAgICAgIC8qDQotICAgICAgICAqIEJy
ZWFrIHRoZSBjb250aWd1b3VzIGFsbG9jYXRpb24gYmFjayB1cCBpbnRvIHRoZQ0KLSAgICAgICAg
KiBpbmRpdmlkdWFsIFBBTVRzIGZvciBlYWNoIHBhZ2Ugc2l6ZS4NCi0gICAgICAgICovDQotICAg
ICAgIHRkbXJfcGFtdF9iYXNlID0gcGFnZV90b19wZm4ocGFtdCkgPDwgUEFHRV9TSElGVDsNCi0g
ICAgICAgZm9yIChwZ3N6ID0gVERYX1BTXzRLOyBwZ3N6IDwgVERYX1BTX05SOyBwZ3N6KyspIHsN
Ci0gICAgICAgICAgICAgICBwYW10X2Jhc2VbcGdzel0gPSB0ZG1yX3BhbXRfYmFzZTsNCi0gICAg
ICAgICAgICAgICB0ZG1yX3BhbXRfYmFzZSArPSBwYW10X3NpemVbcGdzel07DQogICAgICAgIH0N
CiANCi0gICAgICAgdGRtci0+cGFtdF80a19iYXNlID0gcGFtdF9iYXNlW1REWF9QU180S107DQot
ICAgICAgIHRkbXItPnBhbXRfNGtfc2l6ZSA9IHBhbXRfc2l6ZVtURFhfUFNfNEtdOw0KLSAgICAg
ICB0ZG1yLT5wYW10XzJtX2Jhc2UgPSBwYW10X2Jhc2VbVERYX1BTXzJNXTsNCi0gICAgICAgdGRt
ci0+cGFtdF8ybV9zaXplID0gcGFtdF9zaXplW1REWF9QU18yTV07DQotICAgICAgIHRkbXItPnBh
bXRfMWdfYmFzZSA9IHBhbXRfYmFzZVtURFhfUFNfMUddOw0KLSAgICAgICB0ZG1yLT5wYW10XzFn
X3NpemUgPSBwYW10X3NpemVbVERYX1BTXzFHXTsNCisgICAgICAgdGRtci0+cGFtdF80a19iYXNl
ID0gcGFnZV90b19waHlzKHBhbXQpOw0KKyAgICAgICB0ZG1yLT5wYW10XzJtX2Jhc2UgPSB0ZG1y
LT5wYW10XzRrX2Jhc2UgKyB0ZG1yLT5wYW10XzRrX3NpemU7DQorICAgICAgIHRkbXItPnBhbXRf
MWdfYmFzZSA9IHRkbXItPnBhbXRfMm1fYmFzZSArIHRkbXItPnBhbXRfMm1fc2l6ZTsNCiANCiAg
ICAgICAgcmV0dXJuIDA7DQogfQ0KQEAgLTU4NSwxMCArNTU1LDcgQEAgc3RhdGljIHZvaWQgdGRt
cl9kb19wYW10X2Z1bmMoc3RydWN0IHRkbXJfaW5mbyAqdGRtciwNCiAgICAgICAgdGRtcl9nZXRf
cGFtdCh0ZG1yLCAmcGFtdF9iYXNlLCAmcGFtdF9zaXplKTsNCiANCiAgICAgICAgLyogRG8gbm90
aGluZyBpZiBQQU1UIGhhc24ndCBiZWVuIGFsbG9jYXRlZCBmb3IgdGhpcyBURE1SICovDQotICAg
ICAgIGlmICghcGFtdF9zaXplKQ0KLSAgICAgICAgICAgICAgIHJldHVybjsNCi0NCi0gICAgICAg
aWYgKFdBUk5fT05fT05DRSghcGFtdF9iYXNlKSkNCisgICAgICAgaWYgKCFwYW10X2Jhc2UpDQog
ICAgICAgICAgICAgICAgcmV0dXJuOw0KIA0KICAgICAgICBwYW10X2Z1bmMocGFtdF9iYXNlLCBw
YW10X3NpemUpOw0KDQoNCg==

