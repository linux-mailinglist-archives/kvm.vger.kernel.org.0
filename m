Return-Path: <kvm+bounces-16061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C308B3C1F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45A7F1C22117
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 15:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0FF14D2B8;
	Fri, 26 Apr 2024 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gO3/EB7t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD414A4E9;
	Fri, 26 Apr 2024 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714147083; cv=fail; b=ho3Rv/nINAcAPFrpC7/09QnI8PHg+x5YH/G+W5l49xcfCHv1ypQzrjgxRxaVLmoP2qu/HTTKIRUEGamGlllvNRLT2ENJm38B2WU/oxaGfnX9IrMK0solAflC5L/Fi7CJZwSohAYIPVk2D5edhLnyDxMIUr89xFMDhPv3g/eybVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714147083; c=relaxed/simple;
	bh=Ts0FqxdD2t6FZ2yniGfduON6ltwA49U0TaoZD0xs6bs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BYJ9e/aLlZkVDWx13MdvCA9JFYnUNya6rC6iRF5/bIscaANEkxtk8H8g3BVf2jWnb60aAlz8YnOLh1HhrMbTdVxdxqyFyShQcB8kYjtJpZVf4GILqtv47u2m/P4FJYm6L1GacXv8WbHFiWJrabp7uSBjbF9V1AxHYnnibP6yblE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gO3/EB7t; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714147082; x=1745683082;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ts0FqxdD2t6FZ2yniGfduON6ltwA49U0TaoZD0xs6bs=;
  b=gO3/EB7tnfoeHwenf5qOvZsxd3djoI289dtmwiX6cY3GtIwYG1BJ+4YJ
   sU4DgiDte6qU1eMFJtPdbNvcPvBuiDMbkOWaUNYRQs4qBa5DWUBix+WS3
   9yiJ0p+9bg0uyx/8qWCZjioUgnXL7Qk/fFzcuU4exPka1OlcdwVme4Zzq
   y3sVOQWFnzoB4JlPz7cTzQZjh+5Mj7dgBcE4/UlbpNuoUGi5Yhjgz4Fmf
   UXcwjR0I6aLV74OaHGeZm7N5vEe/HxOxm7XxFePyOCI7A2Sp3hKuFt93r
   +lxzjxsl/OO+3l619Pxl7xLrScg0PBOH5ZvmxECXYgejU0xZo+4QLgRZy
   A==;
X-CSE-ConnectionGUID: 35cHWXFBRM6ltr+SANjAgw==
X-CSE-MsgGUID: 8rokTEt2RbyR2lbwBYp5dw==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="13676309"
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="13676309"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 08:58:01 -0700
X-CSE-ConnectionGUID: wilQv79zRz2sSRoWTM8J0g==
X-CSE-MsgGUID: L6PjdxQNRJef5EtdU6kgEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="26090830"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 08:58:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 08:58:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 08:58:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 08:58:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 08:57:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcH14msIpK/VW6bH7LyY+dJ/L7QxFavJrImVpwmV4VYrQoQi5MnL0aKCHFZLbmJNCTDdOcP2wejKJibl0vLwYPHAshQ6hgXRfT8rgorrcf9YbMKswAmSeraQgUhrzvCbfQpiDIP81fV8rsdOESg8Fa5IIANxsiTJQ1x5+pzKTpYYif8eM2nsqkHexUuUfsAsBj54kUFFsK4vgIklwlDscXdX8K11PgRX/GprUrB9pGzMOTSVRMqM4SSIxOUxPFZH1173vww4F81kY4qtozDVzJG97VuVvfUJWQUCMeo8d/ZjfpbAM4fPQ7gaNmIVc4ywn09Q7lHBiwcT9Tpa+cWfRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ts0FqxdD2t6FZ2yniGfduON6ltwA49U0TaoZD0xs6bs=;
 b=VteuOh1Dl6UrMIlivg2/TuNVb/dOq71d2ikR8e5e+hvSIFAheA4G2M2mSFaj/TPxT7YUI0W1+ku++YJsUfleHW4T6X/P6CptXkT5cy6LkUmRCFZKA3gmw02oQc3X8TGyhONYs+4ZsA+BoE/thUYXjlKUqB5/TofwTGsQrihyu6Vw1LAr+Cjd4KzMRQkmJPFcS/HyJzdZfUBpIs8b1owHPRV3GIiZiMvdC1DAY1IEWVmPsZ8TP7Rt7rxHPpyWcsHiPNDc0/Jg2N31f5gfkpP8KfHDgV9oRWUOTasB8szt4raFGIHd6YrFWz5TD9PUOHZASL5fJdwMDHDfUrBrQDpQxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6334.namprd11.prod.outlook.com (2603:10b6:8:b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.24; Fri, 26 Apr
 2024 15:57:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Fri, 26 Apr 2024
 15:57:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "sagis@google.com" <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "tabba@google.com" <tabba@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Topic: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Index: AQHadnqYyiwEEDddI0GwsG68yoNoPLE/K9oAgAB2CoCAOsrgAIAAZ8AAgAAbRoCAAAhBgA==
Date: Fri, 26 Apr 2024 15:57:56 +0000
Message-ID: <21d284d23a7565beb9a0d032c97cc2a2d4e3988a.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
	 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
	 <20240313171428.GK935089@ls.amr.corp.intel.com>
	 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
	 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
	 <20240319215015.GA1994522@ls.amr.corp.intel.com>
	 <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
	 <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
	 <ZivIF9vjKcuGie3s@google.com>
In-Reply-To: <ZivIF9vjKcuGie3s@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6334:EE_
x-ms-office365-filtering-correlation-id: 4a61545e-1156-4482-a003-08dc6609a3a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SkkyRmR4UXd4T1pZTStPTzdwem9ReUhDclduQ2xDdG1Ub3g2dndTdGI2SnJN?=
 =?utf-8?B?RnhuS1RXdm93emtwRk9kVWE2cEdST0lVNCtpbzF5RTQ4dFphamJVWnloN1Rz?=
 =?utf-8?B?WHgvV0tDcjNmbzZJdURHaGoyUzN0bEs5OUp6UDdPenRLMmRITEFSaWdWMzkv?=
 =?utf-8?B?d1VCSXhHSm1HN3dqWFV3RTVPWElTUHd6Z1FaM3hhdkM5MUZtbnlMKzU4b1VK?=
 =?utf-8?B?c3VxbXZFVFppbW45eGgrelErcFRGQ1Y5RmpIb0dUSWNpSndadWtiY2kvWUlJ?=
 =?utf-8?B?UVV6UHY2R3c4ZXVtY0xFWTg1N0lUZUhjRDVWVFJlRGo1bWNocTFMdXpGU3E5?=
 =?utf-8?B?Q2JucEpwdktMamplZ1ZEcEJIS2xQai8vNXVhajZRY3hVQWJSby9wQ3VlRHMy?=
 =?utf-8?B?OWgxZkJtVTFwRCtNbFpwWklKTEMvaUN5ZVpYWnoyaXpLbkdIMld4WFNXcTU1?=
 =?utf-8?B?T01HenpBalFEYjdBb3ZJQWcvY0p2MzZ2bUltZEZLaHZSMnRVQzNPdjJiS1RQ?=
 =?utf-8?B?OTVaY1RCYVBFaDEyZ1BObSt2aG14ak9yM0Vta2E3QnVSN1RSMVlKZUp2bjls?=
 =?utf-8?B?V05ITThtL05kTE95R0RhMzhnTnpjVTdISzVNZ1BPYnZ3T2szaGcxUTVJSFFh?=
 =?utf-8?B?YURhU2FqckE3RTRYRmxUSElyUkMzMXFZWXFSSXB3RDJzUzYwR05MSWFYYlE2?=
 =?utf-8?B?RTl5WllSTlBMQ0pLTUFmNFlKUWNaajRJRDZKUUY3TUE2ZFBBQUFHdlg5RzRY?=
 =?utf-8?B?cXpYWjVZNkVudVFMSHJ0b016dUhCMkNjV1MzRFRTZzR2ekVyazdncnZWY2RX?=
 =?utf-8?B?UFI3cUZlYUQvNUtwOFBuaXI3SE44OS92eFR4bm1WMzdIMWdqaVdEemQyVnNa?=
 =?utf-8?B?NFZsdGlDOUVQK3NaWlZ2bUJQYVhpdzBqaG1RSlBIaEcxZTRUOFlGSkJGTjRz?=
 =?utf-8?B?eVUvOEFqcDJyVi9NajRnR1BVeENFRy9jTElJVktnY2dkVWNRK0ZNWkJnemN3?=
 =?utf-8?B?bi90ODJESStoTWtMY2duYmk4WHBaVkNSa2RnbXhYSDN4L0RrN1JNbHZYeTJY?=
 =?utf-8?B?NmNvZHVYOFMwdGxJYmtIcHNjdExoWk1EMjF4Zm9sL203ZEtKR01Ed1dKY3lp?=
 =?utf-8?B?SWZnbzlsY2t6bTZYS1lCbnBFRmhKcjA1QlFhZU16NEtrMzY4bkRaRGhJdHd2?=
 =?utf-8?B?THdEZmxqdjMyRVRHMFk1bmtIVjg1NnZmNEQrOWFlOHZiMmdnMklGWmR2RDNY?=
 =?utf-8?B?dFRLVEZvUjBOTjRiVldaYk9jSWVBVllXRGQ3dU5QMGUwVG1SejVndDk2RjAz?=
 =?utf-8?B?QWdiWHAzU2thdHNvb2ZBVXlkR2JtRjJ2MC9IRUw0Q0xYMTFBTTRuL3ZaR3o0?=
 =?utf-8?B?bWR0czg0NVpzV3dPVUpSSDQrZVlodkthSlp0dnhjV3lmcG8vNUk2Vi9maVlC?=
 =?utf-8?B?eVo0bEQvMWNhQWFmOHlSUjhpRlpBVysyZUlYTGk0ZzE1b2tzcUtlblkrYlNl?=
 =?utf-8?B?bTlheU56alNXWk1qOUVjSHk2cU5tNmV0QVh5U0R2alZtZ0JzYUlGeFlHaFRL?=
 =?utf-8?B?eUZMMmdieU4xTVVFYW9DeVh5ZU5JOE1WQURNWnY3S3U2M0VlbXU3VVpRYU1O?=
 =?utf-8?B?YjZsMEtXa1dLUkExRUhQcGhkR2ZCNEVvTDEzdkZUVzZsWmRpRDZZTHVzTGpw?=
 =?utf-8?B?WWRydEttVGY2ODQ1V0ZRc2RhVkZsWGQzNE5ZUS8xK1Vpak9zWkZRVjFiUHJH?=
 =?utf-8?Q?G0tLC6cKxVAcIPJ+Yg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEpsaFk3enlDdUd5MURiTDdqRkI5WGtlVUVvSFh6OWJBNGh5dllaNytkek91?=
 =?utf-8?B?UlNVWVQ5U20rSGYyemg4RFFJNzM5M0UxOGk1NlBkRmJIdmd4VkJNVTBnTkZL?=
 =?utf-8?B?K3ZqYys5aURMeWptanhGYkJJOXVIQldPRCtKaklBbUxpRWxFeXJNdXZLVSsx?=
 =?utf-8?B?R0U5N0hUNk9SUjhmbSt0dkVlKy9kK0YxT1QrTmlNTUNmejJqVUpFV3FSZTVa?=
 =?utf-8?B?Z3Qyb21EbzBWUGJRTHZOL2xzVTVtUiswRG5tRUh5U0pEWXptYjdpU1QvUkxa?=
 =?utf-8?B?UkFXZk5QZXE0VGVsNXNpQmVPSGdldU5UVEZYcFo1elZ0MGd3L0NzMmMxUXRw?=
 =?utf-8?B?di9kQnh0WGZhY1RXY2ZJS3Q2dUQrM21QK0w3bGdBSWN6NklXMmRBMTBuQmRB?=
 =?utf-8?B?enlUS2N3Nmh5MnNtNFkyV29Uc0l3NmNmcGppV3pLc0pPOTV1U1libUMwT1FY?=
 =?utf-8?B?d0ljU3B1elhJUm51cnU4bGJrZnNQUjhWK1cxMVROUjhBWllrNVphSGNzVnJi?=
 =?utf-8?B?NGd4akhkZW9BN082M2ZwamRMN2V6dU9IdEFYRmZyQmU3QStHRHpieldTU3BB?=
 =?utf-8?B?aFlWdS9oQUpJUnNBb3VFdGFISitqMTZmeWhqVnB5SjZKWk8wdy9jb1JhMXBO?=
 =?utf-8?B?bFdUcVl5NnB2d1FrR3RZNjI3SFFieEk1WTViekxPNVNLUzNwN1dmUjRzdlB1?=
 =?utf-8?B?ZzArVVQrTXVXaDJMcFBwMXNuOFlKaWNkMEtJUVlwK3hwaEZXME1yZmwwbWFt?=
 =?utf-8?B?L21oR0ZEbnRxU1JoTGt6b2licTMyNkY1NllhL0JXMS9mdVdhYUsvQ1dPZGQ1?=
 =?utf-8?B?bWMwZmh6YnNQa0w2YW1lS1B4WlQ0cGh0MVBFcGpWMDJzZFlremEzOWNjMHhZ?=
 =?utf-8?B?OVFTTHRNOThFU2NtQkE4T0M1M09rVjRmTGE2NWpzMzIxRlJUcVAyMC9kZWpN?=
 =?utf-8?B?Y0RDcVhOb1dReU84NWZ5bVhBQzYxcHhZSFFmdUVIdUNGZFc1OEw2K0VvYUg1?=
 =?utf-8?B?eWNGQ1dSSkJxcVdFS2UrZnFnd0ZoMksySHFVcDRTbHZSWVhJT1ZwNjRHVzZ2?=
 =?utf-8?B?QUxHREw3TGF2S1ZMbWxVb1NROWp4SGlQVXFOWS9BTThwUU8xT1pvMW9tOUhl?=
 =?utf-8?B?SWFJUUpTcmZBeTZkdmNWTlhzb0xuS0pIcnZvM0d1VjhEU1AxTXgwQUVyM1Mw?=
 =?utf-8?B?VEhZbGJxdS9RWW9hcmpsVW4wK1NLYlhIbytYTXFQNXFGUGZjZkNsZTNheXpP?=
 =?utf-8?B?UUVjSWJmNE5ySktTNkl1OGRJd0ZtZTJQMk9lSjVNQmM1OTZlMnFGajJBOFdk?=
 =?utf-8?B?WVdEaFJiUTFocHIwUkJ1WVVYQlgzR1BMMlhqcW85U3pwZ0R2NEI4V2xEanJJ?=
 =?utf-8?B?QXg0WkxyUWRNTmRiRjJ5emJNOXFKd3ZkWnMrWjE5MHdtcVQ4MnZHSVpoSUpj?=
 =?utf-8?B?R20za0pBdWNyOXUyUHhiYTJWRTRnb2RvNkhCMitEOWRVNUNYc2lhRzRORGxW?=
 =?utf-8?B?VFUzS2lzZDZNY2NEaW96cU0zOGpHaXFvMXpiVXB6aDNlNVBtem5TOWFSUFZB?=
 =?utf-8?B?aFFPNE15ellqYU1EbVVoYVNmTko5YXNUV1ZUY2t3UndHTFdtMDcyRW1HU1FY?=
 =?utf-8?B?c2w2S0ZtSUUzMVFRVm5zck91dE45NWNVSW1MOVptSlVrZWhFdlkvWWM5cGRm?=
 =?utf-8?B?R292LzlQMHNoSjhPYjFmYlNwdHNEMzBVdWsxWVpFMGljSXFMNkszZTIyeUd4?=
 =?utf-8?B?dGtyZXUxUHN1UnJycTNEa3J0U2toSVVZS3R2TGhEUXNlb1pXNXV2d1pEUnFW?=
 =?utf-8?B?ZHpvZEd3R1hpT2U4RStycVRNSldUdmpYZzdEMjBTdEVGY3dEcGhkVHpPL3cz?=
 =?utf-8?B?NWcrcXFIVWlZMjQvdU53QWsrUEdLRXdXc3RuL1ErZVBpckt6allSVDZ3RUo0?=
 =?utf-8?B?djdERUh3cXFKUHFEODMyT3ZNUUlIbkFuZm44MU9qbHhrMlN3Y21taTFnY1k0?=
 =?utf-8?B?MVc5STNmNEhpZDAwcTlwd3NYLzNKRjFwT1dRWE5yM2t6b1pVcjN3WkhqR3JE?=
 =?utf-8?B?RmN4NHpkZmpVVkNSNTUzZ2FlaHJCdWllT2s5OHRWZk5oOWtFZlI1bUVKbnVK?=
 =?utf-8?B?SklxeEgvTHN1S0UvZVFSN1dTdE5NM0Mwd3lQSStTZ1NUQmNHR25JbFFWY2FG?=
 =?utf-8?Q?3CpVeSnq0hnU2uMRpJnxPnM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4823E4F48770B44296ED2BF5088B6D7E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a61545e-1156-4482-a003-08dc6609a3a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 15:57:56.5745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2KViVfq1aXGWTIxBrxfVEr5UAg0JXYRNNw/dVeXlEIK8ZCrIsU75D1eN5kOD8BKL6sWpW7JnPfQ/mSZuctekNfZhCFXn8FsG9QJH1wZTK0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6334
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTI2IGF0IDA4OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBIbW0sIHllYWgsIEkgYnV5IHRoYXQgYXJndW1lbnQuwqAgV2UgY291bGQgZXZlbiBo
YXJkZWQgZnVydGhlciBieSBwb2lzb25pbmcgJzAnDQo+IHRvIGZvcmNlIEtWTSB0byBleHBsaWNp
dGx5LsKgIEFoYSHCoCBBbmQgbWF5YmUgdXNlIGEgYml0bWFwPw0KPiANCj4gwqDCoMKgwqDCoMKg
wqDCoGVudW0gew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoEJVR0dZX0tWTV9J
TlZBTElEQVRJT07CoMKgwqDCoMKgwqDCoMKgwqDCoD0gMCwNCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBQUk9DRVNTX1NIQVJFRMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoD0gQklUKDApLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFBST0NF
U1NfUFJJVkFURcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA9IEJJVCgxKSwNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBQUk9DRVNTX1BSSVZBVEVfQU5EX1NIQVJF
RMKgwqDCoMKgwqDCoD0gUFJPQ0VTU19TSEFSRUQgfA0KPiBQUk9DRVNTX1BSSVZBVEUsDQo+IMKg
wqDCoMKgwqDCoMKgwqB9Ow0KDQpTZWVtcyBsaWtlIGl0IHdvdWxkIHdvcmsgZm9yIGFsbCB3aG8g
aGF2ZSBiZWVuIGNvbmNlcm5lZC4gVGhlIHByZXZpb3VzIG9iamVjdGlvbg0KdG8gdGhlIGVudW0g
KGNhbid0IGZpbmQgdGhlIG1haWwpIHdhcyBmb3IgcmVxdWlyaW5nIGxvZ2ljIGxpa2U6DQoNCiAg
IGlmICh6YXAgPT0gUFJPQ0VTU19QUklWQVRFX0FORF9TSEFSRUQgfHwgemFwID09IFBST0NFU1Nf
UFJJVkFURSkNCiAgIAlkb19wcml2YXRlX3phcF9zdHVmZigpOw0KICAgDQogICANCldlIGFyZSB0
cnlpbmcgdG8gdGllIHRoaW5ncyB1cCBpbnRlcm5hbGx5IHNvIHdlIGNhbiBqb2ludGx5IGhhdmUg
c29tZXRoaW5nIHRvDQpzdGFyZSBhdCBhZ2FpbiwgYXMgdGhlIHBhdGNoZXMgYXJlIGRpdmVyZ2lu
Zy4gQnV0IHdpbGwgbWFrZSB0aGlzIGFkanVzdG1lbnQuDQoNCg0KPiANCj4gPiA+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2FsbC9aVU8xR2lqdTBHa1VkRjBvQGdvb2dsZS5jb20vDQo+ID4gDQo+
ID4gQ3VycmVudGx5IGluIG91ciBpbnRlcm5hbCBicmFuY2ggd2Ugc3dpdGNoZWQgdG86DQo+ID4g
ZXhjbHVkZV9wcml2YXRlDQo+ID4gZXhjbHVkZV9zaGFyZWQNCj4gPiANCj4gPiBJdCBjYW1lIHRv
Z2V0aGVyIGJldHR0ZXIgaW4gdGhlIGNvZGUgdGhhdCB1c2VzIGl0Lg0KPiANCj4gSWYgdGhlIGNo
b2ljZSBpcyBiZXR3ZWVuIGFuIGVudW0gYW5kIGV4Y2x1ZGVfKiwgSSB3b3VsZCBzdHJvbmdseSBw
cmVmZXIgdGhlDQo+IGVudW0uDQo+IFVzaW5nIGV4Y2x1ZGVfKiByZXN1bHRzIGluIGludmVydGVk
IHBvbGFyaXR5IGZvciB0aGUgY29kZSB0aGF0IHRyaWdnZXJzDQo+IGludmFsaWRhdGlvbnMuDQoN
ClJpZ2h0LCB0aGUgYXdrd2FyZG5lc3MgbGFuZHMgaW4gdGhhdCBjb2RlLg0KDQpUaGUgcHJvY2Vz
c2luZyBjb2RlIGxvb2tzIG5pY2UgdGhvdWdoOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3Zt
LzUyMTBlNmU2ZTJlYjczYjA0Y2I3MDM5MDg0MDE1NjEyNDc5YWUyZmUuY2FtZWxAaW50ZWwuY29t
Lw0KDQo+IA0KPiA+IEJ1dCBJIHN0YXJ0ZWQgdG8gd29uZGVyIGlmIHdlIGFjdHVhbGx5IHJlYWxs
eSBuZWVkIGV4Y2x1ZGVfc2hhcmVkLiBGb3IgVERYDQo+ID4gemFwcGluZyBwcml2YXRlIG1lbW9y
eSBoYXMgdG8gYmUgZG9uZSB3aXRoIG1vcmUgY2FyZSwgYmVjYXVzZSBpdCBjYW5ub3QgYmUNCj4g
PiByZS0NCj4gPiBwb3B1bGF0ZWQgd2l0aG91dCBndWVzdCBjb29yZGluYXRpb24uIEJ1dCBmb3Ig
c2hhcmVkIG1lbW9yeSBpZiB3ZSBhcmUNCj4gPiB6YXBwaW5nIGENCj4gPiByYW5nZSB0aGF0IGlu
Y2x1ZGVzIGJvdGggcHJpdmF0ZSBhbmQgc2hhcmVkIG1lbW9yeSwgSSBkb24ndCB0aGluayBpdCBz
aG91bGQNCj4gPiBodXJ0DQo+ID4gdG8gemFwIHRoZSBzaGFyZWQgbWVtb3J5Lg0KPiANCj4gSGVs
bCBubywgSSBhbSBub3Qgcmlza2luZyB0YWtpbmcgb24gbW9yZSBiYWdnYWdlIGluIEtWTSB3aGVy
ZSB1c2Vyc3BhY2Ugb3INCj4gc29tZQ0KPiBvdGhlciBzdWJzeXN0ZW0gY29tZXMgdG8gcmVseSBv
biBLVk0gc3B1cmlvdXNseSB6YXBwaW5nIFNQVEVzIGluIHJlc3BvbnNlIHRvDQo+IGFuDQo+IHVu
cmVsYXRlZCB1c2Vyc3BhY2UgYWN0aW9uLsKgDQoNCkhtbSwgSSBzZWUgdGhlIHBvaW50LiBUaGFu
a3MuIFRoaXMgd2FzIGp1c3QgYmVpbmcgbGVmdCBmb3IgbGF0ZXIgZGlzY3Vzc2lvbg0KYW55d2F5
Lg0KDQo=

