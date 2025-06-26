Return-Path: <kvm+bounces-50875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A159AEA5D1
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B60987B0ED4
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284732EF288;
	Thu, 26 Jun 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k2c2TuaS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5D728D8FE;
	Thu, 26 Jun 2025 18:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750963924; cv=fail; b=NdzAbWjFy9Woqi85nWdOeK8s32yBlohOATBmYq0ugUCmC4uwdCnzCbtPib1Fd0yfoSxXmQmD2FbQiuLm73Nqe5g72VLZy4cE3qjEr3ibrnTICzHR7hf7JXLKKf7JtAG27r4+OjPSt0YXbHBROgg6c4uCnLTd91LTcn6W0D8w0a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750963924; c=relaxed/simple;
	bh=9mBeca3MDxCOmxkjtCaIRO/QDM2wlIoRm68LrGfRoKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FZhsFvU8ICs4GGIFWGkgkWQE9qMP+/GVl7HtN5v0k33EFYVfbXL4vsm3TNEufeSJqnnftXlvxRsNvTruf2M/qlEY7NzOuvFi+JU41krLBGYvfgKs7YfvxcGbjh5El1YrxKVUqp2U/i2/BAv6gZAQinmlZFgjJYaHP74/hqgQ7ZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k2c2TuaS; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750963923; x=1782499923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9mBeca3MDxCOmxkjtCaIRO/QDM2wlIoRm68LrGfRoKU=;
  b=k2c2TuaSdw8uCVEGSo2HjXsPQ9bZOT6lRCI/KQmfOPglKLtVO49tP/rB
   jDig7AcBKwgazNDucj6RVNpb/ZBQpU8qCI0TXfXF1fbSkpZdLmEAnuQGb
   yu3Ss/tSZqE4PUEFsAE6SxACWeQOxQcRXmzHq/VR3Zj10AB+PZfUWf0XP
   ZoVHwHX7f3b0rXTQZlWE5a45C+lDlExFDmVbAVydmcV23pR+iHAbkkcNp
   OEYiksAspaaz4+8qUGM8gfm9+s1hT3kWP+9GhtPmKNqsqvZdUJi1kZAI7
   Owk0zMyYlO0AvqFjQ4hobwFwoI0eVo0FNAbvIoRPcgzvHF4pYKs0Pch5G
   A==;
X-CSE-ConnectionGUID: yCMI7gLaRNiEKWP/G6YJFw==
X-CSE-MsgGUID: 7O/nJ8OiSi6GnrGPKJVlSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53349537"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53349537"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:52:01 -0700
X-CSE-ConnectionGUID: 4GVTIrxDTH21/NBwr5j8EQ==
X-CSE-MsgGUID: 0oJtXPopT4+//9jRdbPL/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="152108878"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:52:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:51:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 11:51:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKUI2XeQF2w+7JqcmpBDP9uUoH0ivBFpbzJ5K2STbktAnarxWyLMxkoDm761Q2sXjGCMrZqFoDi1UyLR1TQWIjUEcmrlTPQRIlwVS9l6luJHHWX/eRFjwdNIEdD0NlFSp1/feUZl2DQQ3DMLEAsUm7/WQfv/dr04/QDfTflvZWRyYW3zbvelWnSuVMhdghKZMVHct42Y1hj/HvTecCaxlLBEGyG3jEB2Dqs09bJbv+O2PHHwMnHdYxKwIq6Di8FjQiMQpZxFlmyyw2mYqzPNgD2K/DJWd9+Std55YPVkfMtZjnrBuHD+88/lU5Lzm3Q4pToGWBtnWJqAwg6P0D+GYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mBeca3MDxCOmxkjtCaIRO/QDM2wlIoRm68LrGfRoKU=;
 b=n4zJ5fiVbR7dP6gT7lzawJKlnJ2olRGY1AHfyB5Mw0hEPgNy2lBMw07mMPg1nS8hv4PcDYcJwMC80qDZ4FiY2Ql807EZ8kyGEutCSRQJWA3QmEAuXb7q9PiGvBel2TtWEP8uaPWbg0nfO+saXy01xHVR0uYSzehJzw3/ha0Qd8X8H1Hy6+gwT+ekPxobWOxQGho8/R/LYNp5l+o6yxdQdwwCYsixzBY8mtkomSXOtjfINC/R6mSxdGW8m/zzZpwDFjtuTT1K9fBhd7ZIp4Iy+SKmrx/GIp8jGWFrdFhurkoRGLFvEOEEs/9t9Fdka/eqEoR2MKJCD3BUHIRCftFZ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Thu, 26 Jun
 2025 18:51:54 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 18:51:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v3 5/6] x86/virt/tdx: Update the kexec section in the TDX
 documentation
Thread-Topic: [PATCH v3 5/6] x86/virt/tdx: Update the kexec section in the TDX
 documentation
Thread-Index: AQHb5ogQfC53BLIiXkO30JUJ+87k6bQVybOA
Date: Thu, 26 Jun 2025 18:51:54 +0000
Message-ID: <c691e84b48ed1dfbc5a73b8ca99d8e64cdfdb8e8.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <f885089aadd485fb07fb9d18e3654ba4ef40f55d.1750934177.git.kai.huang@intel.com>
In-Reply-To: <f885089aadd485fb07fb9d18e3654ba4ef40f55d.1750934177.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4790:EE_
x-ms-office365-filtering-correlation-id: db349e32-391d-47e7-7956-08ddb4e284fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?eFZHc2xHTE5aUkJHUy9abTJWTUd4NDhheFROMGUyQVF3RFNyVkdQcFZ4QTNR?=
 =?utf-8?B?d1MwSW9xdmtOUmZpcjhsclRDMVhqampsZEtlN2R4ZllwejlwREEzd1FZNjFs?=
 =?utf-8?B?b3A3cXpkaGFwZUNTekluWjJKWDJsVTYrOVl5eG9pMkxXNDJGQm4raHJmVml3?=
 =?utf-8?B?aGFUZ282VFVLOVVLWGlpUjZuVlBQSjBIaW9sQ2hNdjZoUDFEL0hRc3VaVWNK?=
 =?utf-8?B?ak52cHE0b2MrdVFHQTVhbXFocVgvZHpFTGVPU0JTUlg5VVZsZDNXNmFpSG55?=
 =?utf-8?B?cXlqOFFCQjN2QVM5VlhPTVlpcE8rWVZ5TDBYYUhUNjFJRVMwS043M1BIQ3dE?=
 =?utf-8?B?N25McnBLZThSaGJXZzc4RWhBa1dtcmhSOHN0TDdVTitvdFNYcnlJOElqeWNW?=
 =?utf-8?B?M2pHTURFVHp4SUppRTVjSzk4RnlQNmRySEFiWXZEMElLTzJyWEtTanovQlA0?=
 =?utf-8?B?NnkwWUM2T01OZW5mN0tCWnJ3akgzZXZQOWhMTDM3SHpveGJ3L3NHa0FIQXhj?=
 =?utf-8?B?Z0RldldGQ3N1TkVtdWZFTnNUL3krblBHaG9GRHNEbXQ1OEwwdHMrY09BbGJ4?=
 =?utf-8?B?aWtRTzFFMFFSNzgxdWVEUWE2bm9kU0JiU05vanFzc3hOWk1SSG9hY0tFUDVl?=
 =?utf-8?B?ektJbmI4aGJFVUJuMGtQRzQxdGxsbzZGeDB5UUhsR2ZTTkdjclA0bU9HNjJ6?=
 =?utf-8?B?V2hyWGxDdnBkUVFlV0ZMNGRkYkJWQTh1Z2FLWHlWc2M2TVdsWTZCQ2xDbTNi?=
 =?utf-8?B?TnJ4ZWhHSnE0a1JubUk2YUhyVHJ1NlZFSTJUY0p1WWJKWGdkY1VaVkxNNWM2?=
 =?utf-8?B?N2d3ZkN6TUo5Z05ySmZXUzkzMWlzV2Y1YTdycUhMVTRZMkVHbldOSEpqR2E0?=
 =?utf-8?B?cmQreUJLNzk4aVJvVVo0UEFHU2JGYTFmSXl6ZVN6K01QcUV2b29UVDViL1p4?=
 =?utf-8?B?bDFlVVJKSFE2SmxoSlM3TEJvMWtKM0h1MW5EUEYwY1Fha3Zma2dKcHh6VkRO?=
 =?utf-8?B?QVhFTVhDYTFFMElVemRxUWcxcG40b3dxelNBeVRLTy9BWUIvYU1wZHFIOW50?=
 =?utf-8?B?L2NGaFMwMWxMZEw3TnQ1V0lmbjJZZGJBa0lUVnhQS0V1dWVoVUUwajJ0UXJG?=
 =?utf-8?B?dm9FY1gybis0Q0xnN0xkRWY5MDgyT3BxYnpKMDRiMnhVVksrbjl3Ymx4Zndj?=
 =?utf-8?B?TTZvMjM0ZHl5TlJJN0paL1YzNlFTbURMM3l2eFNrajN6WDUvaGZBdUVQbGxq?=
 =?utf-8?B?bjlvUWx0U0xjVktieDhGVklOblh5UlFoeDI5V2RLZWlQZEFjWDF6U3RqMTJ5?=
 =?utf-8?B?d1RtOFVwMjRzWHovL1ZSOS96allHVTE3c1UxNWpxcll0a2diMk5Ud0xweGR3?=
 =?utf-8?B?Tms5WDNmZ0JhdU1IelJaWmFqcHNRVjlyZllhY250TDlNS2JlaFFEQ0hLMko5?=
 =?utf-8?B?Nm5WenRJT2VlakhxUjI2TFVhRGF4TDg0L0M0TklveVVKZXl0WThtVnFtWWZT?=
 =?utf-8?B?aVJyT1FoZmtXeDduYlNuUFZwYWZBc0x3MWRLb21MaHNYc240VTFqNXFsRTRL?=
 =?utf-8?B?Q1Rlck4yRTAySkR4elVIZmNkeW80OHFDa0FBVDYyNnBCUHA5SzFPNm9pY1ZO?=
 =?utf-8?B?SnJDNXJHb2pEOGtpcGxhM1pqSjRzUWIvcU90eERSeE1RakJUUktKbEJrUlBk?=
 =?utf-8?B?Q3d6RlV1OG5qengzV0dCajlLdUpvem5vUndGcEdZNWtDeWMvSHNkR0N4MXJV?=
 =?utf-8?B?Q09LeDJLMFlQK3ZJS3hnUjN4WWNzQ2Q2TWNwR1Nnc2lOM3FsMTlqQnZ4Ylh2?=
 =?utf-8?B?UzdZdmJnbGJ2eVA2MEhtMUY4dTZPYWVEbzlDMEc0TU1VV01FcEZGUnduOExo?=
 =?utf-8?B?dFVxMk5lNFFpVGFqTkF1TWpDejZVMmt3QUtScVA3dm5NS3E1YUNUbW4wOFRp?=
 =?utf-8?B?SE1KaHIxSDI0YVJUR0RIa0VRUWRKQXFyaVBpSW41RVRPcE1TUVZFR2l0Q1Jl?=
 =?utf-8?Q?f+8EAXwhzDMH2E0UD9nfJ/LW4A1Q18=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a29WNTV4SXZCcFcrcHErMzk5YmVIYlF5Z2lSTnRrQzRNQWdIaTY1eHBZRzRw?=
 =?utf-8?B?R1hCUHdHS0FPU0lEOWJlWjVONi9TRGttckx3ZWFTQjUzcERLTmdZandXc0Y0?=
 =?utf-8?B?cGhEZS9uQisrdCtESU0xZU1qOUpvY3ZkVTMwRUFEM0pSL3ptUEpqSzdpU1J4?=
 =?utf-8?B?dDVtbE9adm9LT25oU2k0dFlrYXZYYmg2YVk3dGlqVVhZamtzR1p1YVhpQkU3?=
 =?utf-8?B?akIvSUNpRzhleDBTbWZPdVRDdHhJS2pyTnUyVkpNazRKb2ZteHVuNFlwSUxY?=
 =?utf-8?B?STczLzRWamdWc1YzKzJ2WUpGWVRuZ0ROdzhIcjdiQkFpdDFJU2tLR2ZUWnI2?=
 =?utf-8?B?RkhJM0twaFNIVFFGc1Y3MlRycjdmUTc3UGh2dE1YY2g1NnNDbitadFlNY3Rj?=
 =?utf-8?B?NmZQV25yeHNOOHNNbHYzTmo5dC9VRUtWY0hUcCtYTEVjamJzcVkvY1ZRaGFW?=
 =?utf-8?B?Qi9ucXhNMDV1OWIyQXF2TXlIclBwTlRiZ0lIRmIxcFFDd0ZHSjlzeG0vQmlD?=
 =?utf-8?B?cXlEOWxzbXBmRmk1aHVDNzEyRjdmTGNyTU95TVJyRDRqZ1VGV1VzbkRFKzdZ?=
 =?utf-8?B?UnlNcStzcE9uWUVEcW9Ibi9oVGlISjNQMkZGQjhya3J4MWZGcHNHU3JxQkZn?=
 =?utf-8?B?UitrYWV2Sk1UWmMySWxvZVJtMklrTXczQXRuZ01haVFwK1NPck9hdWNyL2Vy?=
 =?utf-8?B?Y3F6eklHV1JxWXkyUzhaMXJPYnZUcWxRemwvWWszaDZmc3ZkNndsdHpCeHJY?=
 =?utf-8?B?MjlkakRpZEV0RFM2c2E2Y3kwV1grVTYvbkNkNGZUOXZhK0VMZmVVVmRtM0FD?=
 =?utf-8?B?TlpXY2RhV05OWE1CMzUwOWMxVllBdy8xbG92WGRxN1o0Y0txQXkwRG0wOU5L?=
 =?utf-8?B?WjBOS0V0NFJpVzMwUnoxc0gzS1Q4dzBzWlJkOTlrQTBma2RpSkd3NUJOYVVj?=
 =?utf-8?B?K2MxZzBDaGQ1RjI0SXJsQ1FHUWJhRWlPMGVIM09XWGdxR1F6eHFrNVUrTTVI?=
 =?utf-8?B?d3JqclcyWGdJdlJUQnZwTE85ZjdhOUFLc1RWVkdMUGN0YTJjMnUxQ0taVjla?=
 =?utf-8?B?R1VJVDMxVTF0Z1Y5d21vRCsxNU1aak54WnViM0lmeGFEdmo1QjNGR1ZkeU5Q?=
 =?utf-8?B?OXpOcWxxdFRrdkhXRXJ3REMwb1BkcEdWQ0N2NjBGZTJ5K1RZZ2J5ZGpMZklz?=
 =?utf-8?B?L05XT0t4SFZxeFk4a2ovaHU3WXNtNnpncVJJbVRnKzZxTGNNWVJZbnJxRkpv?=
 =?utf-8?B?QVpHK2dUMUJPdnlXLzEwOGtnUVVmamRlYzJqb2hLYThqVm93V29ncUQ1MXo3?=
 =?utf-8?B?dURBUEFnODdiR0FFQnRoWXZxZFhsNmVsaGhaVytlN2VzOHJIaDB5YlZDVUQ4?=
 =?utf-8?B?NG10MjBndkFOSVc5Z1U3UUFuTzUxV1JKM1BDYTgvd25OaGZwU3NRVkFQaUFV?=
 =?utf-8?B?akZVUHE0bDdxMVo4YS9BV0FoanJqeU03TmpJd2FENDA4ak9mR3hPOXJvVVZ0?=
 =?utf-8?B?N0lhaFdGQURQZWM5WUQvMDJKVzBlcDFVUDNqRGwxSjJLdDl4WmxTcXFDb1JW?=
 =?utf-8?B?YnBFY2hWTW1NY2lTc1dYWktiZ3lFcm1vOWc0c1p6U2RNZEE5dDV1cnJWMGx0?=
 =?utf-8?B?UjZSellhelQ5VFcyQUlQWDFOaW9jVkhKcy9BeWJGUk0xcHlCdHd6Vi9KNFFq?=
 =?utf-8?B?WGcwUjByL1JuOVlob1VoNlNreEI1eGRHRzMzem8vOTZlVkExbTdFc1FocWZx?=
 =?utf-8?B?QjdsWll1YVBtMUFDNm00MFB2RTUwVFdzUFE5MS9oSzBuOXJzMXdTWFR4eW5y?=
 =?utf-8?B?Qjg0QjlZZlB6U1dtVjVNOWs1dVlaZmhrQ2ZKVUV2RHFGSVZHUWpQYzI2b2JB?=
 =?utf-8?B?UEhheXowOHZPVElxdHA1ZWV3WlgyYWNkRkh4Q0NJNFE2YjRROXA1MTMraThs?=
 =?utf-8?B?Q3pQYnY1OEl4V0RWMUU4eGFqclRFRFBRWUhXR2RqYnVWczV5OHJNVGIxYk1V?=
 =?utf-8?B?WnUwaVBZY2YrWVVYSm1xRldRT2phZXhxYTFCYmE1VGVQazkvU25SaVFNanhW?=
 =?utf-8?B?QTVoOE82OU80dytmWXhmb2tMbDYxMUpocWFKa3ZOeHRQWWVCdHRjTnhpckdQ?=
 =?utf-8?B?YmpoS3dTK0ZtWWVNSnhycXN4aXlUUXpPNkNGVjRyTjdUKy8zOVBpMDlVSXph?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7FD3705CEE70149AB98884BEA3F9ABD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db349e32-391d-47e7-7956-08ddb4e284fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 18:51:54.3017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iXwCg3tXGJbQGGHddmm+KCO5e7a1dQ+sIwFlRo+jDG8vgn6MSAUDDvSKlpT++DnxPa5ztbRSH0bY1LWl4eGJrfKKSqm2khEDlWz20smehgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDIyOjQ4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRE
WCBob3N0IGtlcm5lbCBub3cgc3VwcG9ydHMga2V4ZWMva2R1bXAuwqAgVXBkYXRlIHRoZSBkb2N1
bWVudGF0aW9uIHRvDQo+IHJlZmxlY3QgdGhhdC4NCj4gDQo+IE9wcG9ydHVuaXN0aWNhbGx5LCBy
ZW1vdmUgdGhlIHBhcmVudGhlc2VzIGluICJLZXhlYygpIiBhbmQgbW92ZSB0aGlzDQo+IHNlY3Rp
b24gdW5kZXIgdGhlICJFcnJhdHVtIiBzZWN0aW9uIGJlY2F1c2UgdGhlIHVwZGF0ZWQgIktleGVj
IiBzZWN0aW9uDQo+IG5vdyByZWZlcnMgdG8gdGhhdCBlcnJhdHVtLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IEZhcnJh
aCBDaGVuIDxmYXJyYWguY2hlbkBpbnRlbC5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUmlj
ayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K

