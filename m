Return-Path: <kvm+bounces-17445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A968C6A0F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A65121C21AA9
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FCD415625D;
	Wed, 15 May 2024 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3T5N0tl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2DA156226;
	Wed, 15 May 2024 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715788586; cv=fail; b=eS0Cg3Zp0TEMLoHCc0NxqX3NcSNzCI2nm2EoSzN68VXhC8QLmLupVyLOQYCRVRH5ACnqv/QZfCipSFazLcPMmbPtOMg4QgQSD+LpcPk9Ht0cG0aGA8GPpzIP1rf72cYHkRLVwPPL/uO14mqpsm+phKy4RG1QP2XOSymijIsjU4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715788586; c=relaxed/simple;
	bh=DLwFM8dQVxWT8Efw86nLvBEZEq4JXzdA1CS9FIEyhDY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PA1lVmME9YuzHuLpnJSUSi3rTKOXIOLWDU+jjXZq/cVRA97kVvBLM8Imgab1enRzLCzc3nqSeRDT79CQRVDBXKz8Pcd7bwOEHPtRsUXeMJMRzQNd1N5U4D/0qFWlUyavWMBgg5LL7LmyPJ4kjBG5/906JbFm8Q0tbWOO1mh8KoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3T5N0tl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715788585; x=1747324585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DLwFM8dQVxWT8Efw86nLvBEZEq4JXzdA1CS9FIEyhDY=;
  b=H3T5N0tli2WA8BWOGx/Vamok9YLPBdc14QmOW6O6GztBoME9zd9YYTTg
   iyBqroExf9gUmGdnDTL8Blcoe9iAh0zSIkI8d15nKm33/M2zKVoA2ulTV
   zeI/WSLZuYVkh2xrQTUhtUQ3SSeu13nwPjIWJplfGsXgEhdXuoWnphrej
   PXr1N5CLr6oBfCyxBtQcGEyFebgx46l3jmQY6h4wSpxmO116nMxHHFA+T
   AiuszQw4W2cbHCASBH/GqThWs3oTRNIOx9VE5uSfx/cUrAGO7fSmgV32D
   gqUW9m2GSRIzssBcF2xVbpX1ZgE82JxD3IRcVU6EBzJANf0P+bxSldy1c
   w==;
X-CSE-ConnectionGUID: EpUp1xjhTmqCi/jzuYbBlA==
X-CSE-MsgGUID: XVCSsGrGQYS7tSA3+AHvHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11678572"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11678572"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 08:56:24 -0700
X-CSE-ConnectionGUID: i/6dC1bATbe/AtGLi2u6hQ==
X-CSE-MsgGUID: 0StfX3XlREG5jfJIMJ3Mpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31106291"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 08:56:23 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:56:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:56:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 08:56:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 08:56:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdkF6TyHkwDtvMFZ6U/gbjUtjtL2031E8sba8plBI2hgYmc5hHx64OPQ1AV0wzq0kFX/HkWNHfgj9SgMgMlQPwKGaWSknO8Keb53IgX7Tle1yXYsvoD6OEaubzs1LE9yOAn5Fr05DA/SmEo+K4kmI//aksOrByHz/uIzVvbAdhmHmczeTKqSo5hD4Xg6JUVq31mhoLHfW6P5O1Hoxl4//SSECAMppjfNgBbrpPUltJmHntDqeJS4cexTuqAmo6LQSQS0XRUrxh7U0aKG72GWhS7V1uuigUJL9evlKaLrd7sODApn4nrjcPSVViAi9DXCmlbS0jTJttdNx+ZdX4wmqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLwFM8dQVxWT8Efw86nLvBEZEq4JXzdA1CS9FIEyhDY=;
 b=fEGjE4EyaLYr+eCMdleR4KhbbcIewJFqbUpwYaZPThGizRBMYKG/7AciS5gwxZNeUF/5HnSY24y+/rKh1MA5S5RdOH7b+8bl7qmfrp6k1Z/LPGDQ/xvRrT9gpLYwh0TwxfHVdp1Sg7SdUEsb6HaAqhwS6p4FkLRzr7Eg7tzH5ST9O2G8HAnKf0E+4jOoo1SR6KHyQ/RhwiecpcyzkMc8jfPePSp08hfjqSQkfxD9dwkvqkXgL6+ombWL8ernqkEULCZ2tDEPYc1ODIcxNSUE3DdT42/uXRtuIUSFHdrk4j9h09lpSwnBaHoupJeB89Btaq0Vk8yhPcxVFhMBVzcBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7303.namprd11.prod.outlook.com (2603:10b6:8:108::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 15:56:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 15:56:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAAELYCAAAHkgA==
Date: Wed, 15 May 2024 15:56:19 +0000
Message-ID: <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
In-Reply-To: <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7303:EE_
x-ms-office365-filtering-correlation-id: 252b8d8e-4d95-4c99-a0f4-08dc74f78fb1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MlpJVzhJQll1WUJVY1BCRXJUcW9HODZMNjFMdUUvNkRHditadlNmWGV4VHBT?=
 =?utf-8?B?VGd3WnNaeUhxQmlzZXJXaXpKckJVTDRDWnpVZnFHWWFrRlM0emh3VEVMRFdX?=
 =?utf-8?B?WXJoaTkzV0ErQTZZOTU0dWVOOWlkTG81emlLSEYybHFEY3hnMksvaHFLUXFW?=
 =?utf-8?B?eUFWSGNwMVd3NEJ0U3lRWEt4bE4wbU40YVJ1d2UvVXdSVVNuQVVKVU14a2hn?=
 =?utf-8?B?MU1aVExHcXdlci9BTEJ5aTBCcE9raE1aRCtURVZDU0JKV0x5c20zbm5RVkNY?=
 =?utf-8?B?WDRQM2l1SVd6bTlrZDBaclU3YU9sdzEzMWxpZ3RlWHNDNUVDVWhyZjR1QXpV?=
 =?utf-8?B?cWladlFFc1NBYlhnWnl4STRVUnU3T1RYbFVod1JTTlAvZnZQeVFqZzd2TUp5?=
 =?utf-8?B?L3N3Y3lzc0NoaWc0aHdGekF1OUpMWllwSXF0SVNEZVFWUGNxRCthZEt6aUhD?=
 =?utf-8?B?dTVOeG1yaUhEWmxwOWRWcm9WQlFwcEtBRzRyWGZGZ0pqbXArS0puUDRCazc0?=
 =?utf-8?B?dExEMW9rcFQ0Uk9tOTZvb2hWbEVnMTFXdTJSaUQwbDFFR0Y4Sm96Tk9DR0xP?=
 =?utf-8?B?TGFtZHRrV2JLRURXazB1MWFMeUhLZXlBUVJzYnJtNUF3Mk15VEo5RHRvcUkx?=
 =?utf-8?B?UHhrdVdvVzNQVC9Fb1dNVHk2SHBrekxZbmlUMlpsM2xpenZ2clRiTThNR0dI?=
 =?utf-8?B?azJnL1I1QUdNdG1RTnRwZWJ6cTRmTFMzbWhaWXJOVkVEZ2lCMXl2K2Y0QWNu?=
 =?utf-8?B?V2ZNdElsVW1MNk8zU2R3S1kzQnNtUnhoY0JLbk0wMlFuQlFyYS9HMERDMTk2?=
 =?utf-8?B?emRnK2dBaW1hZGNyQnVicGxFMVUxKzRoVHBuUEJnY3FwMTZablpTYk1ORWho?=
 =?utf-8?B?bFJJVS9VZitxQ1FMUUxtNzZKT2ZZNnRRZTdWdzRTdVpNeHNuVW5WUzBQM1Ro?=
 =?utf-8?B?aTZiZ1NJZjhPTDlBcGxueUczZFVkbzdLK25sNkc5bGpmbHZIQjk1YzRyY2h3?=
 =?utf-8?B?UC9ySUV4MzJpTW55aWVpUlh4VTUrR3FDWmkwTTRqNFZxQ1FtMm5NeDJhdFMw?=
 =?utf-8?B?cDNCd1QwWndvREdMRGRkQXl5UWlqNytyV1Bmalp0dzdVanlIMHZ5VXZacmFQ?=
 =?utf-8?B?aUdDaXgvc1Jydm40VGdYcG9Oa3hiSjZVQkVvWDA3b053TzRtT2IxNUdtZG9T?=
 =?utf-8?B?QktEYXZ5ajN5SHFKd2QzdHR1SnpRNUgzVHlwUVEveVQ4VGRVTjBEMEpKQ3RU?=
 =?utf-8?B?enlCSTFCeTdXRlBNbVZHTUVXUDd6YTkvUkMxaGprSDBqcVBpemlMUDRXaTMv?=
 =?utf-8?B?TmpaRENGMU1zZ3Y3U2wzNmJFTmZ3VVB4Ni9oalNTWmIrVTVpUnBBUUV0L3FQ?=
 =?utf-8?B?MkdaenpEYmpocTVFSGtHaUhxNklwZ01sQ3N3N0hXY1d1NW1TUHBKdEZVa01M?=
 =?utf-8?B?bUtoanJHVFpBNEdoQ2d0anJ6cDVVdXpNdnJUWDhkZ0FmMENtamlJelZ1VERm?=
 =?utf-8?B?Skx0SHZEenFrcVhualNhZkxCTEtZN2VRNW9KMGdWN3RhWjNJNFZZTDZ0cU9h?=
 =?utf-8?B?NDlLajFiU0hUQ0JXemZhVlZHLzlFYk9kMWVFcUJOTzFjL3hFUjJtSzdjV1ZO?=
 =?utf-8?B?SFFWWk5mOE9qSkxHNjQyVGlHbDBEYzUzellEWUxSTVdmK0pwYXZRNHVMTk9j?=
 =?utf-8?B?NkJNelFkdTQ0ekJRZ3RISmN5a3hkWWF5Y0hQNHpHVGpjZ0k3YW9oQXh3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFZLZVk2MU0ydzZMV2oyYWd2b3EyRHFnTFVlKzczZTBRRFFTanNFc1NhYzN2?=
 =?utf-8?B?NmxrL0czYUVjd2dtVUdZVWQwK3h6bU5ycmViOUFHNUdrK1FidW5UUzNySnB4?=
 =?utf-8?B?VTYxY3NTdXhLWkY5NW4zRUlQZE5XR2dSQUV4N1Rqd0U4ZlE1ZmVCSUE2U2pC?=
 =?utf-8?B?enp0bDVmWU1HOVZZK21JL21mc3F2Q25VbFhZTExSbXAxQ0ZIRnVJZnB3YlN5?=
 =?utf-8?B?V3pIeEJsQ281UjVtbC8xd2xXb2dqWk92K21xbUdTWERCZFYvS3hiZmVXbHg2?=
 =?utf-8?B?RVYxWW9BYnVXaU5EcFpESU0raEQ2Vkd5VzJuamlrNi85RGRmSlZNcThtOGRS?=
 =?utf-8?B?ZCswWUFBVjB5UEpIdFRqYUJwVHpMVnM3T05OWHZsWkc0MlpPRi9EakNvN280?=
 =?utf-8?B?VVpIOU5TaVF1dlBVcWRYYW1saHd2MStvV0RZclE3T3gwemUwZGZsVmo1YU5i?=
 =?utf-8?B?NitKUFFoRjNLdjAyTFY1MDF0L3dMNHBsdm95dkVUMnFqK2gxNExGZkp0cmhU?=
 =?utf-8?B?ZUkxSERqd0NCeHAxcWdOSGR6S0d5REFGdmFTYWgxOTM3UzhtdGpGbmM3Yll1?=
 =?utf-8?B?TFcvQnY0M2VhS01hVWppM1B3OUF5Y09IN0FrTDNRRU52aDB2Y0RpYU43R0RB?=
 =?utf-8?B?eUpQM1dWQjRFY042and0N1REQndmc1RJc0p4R283TERsVFlsem5KRXFZSUln?=
 =?utf-8?B?UXBDMnRtcnQ4QlIwdlAyUmovenYwbGRsMmUwT0NVOXYxbUlrUHB5dEt2OUU3?=
 =?utf-8?B?MHR0REhPN1UrdzlwSHhPd0piWFpFNzRGalF4NW1rVGZrTFNoWmRhbWNvUWhj?=
 =?utf-8?B?cTlxTGsvSnBXMWdYKzRxMGNvaHJmUndsL0tJZ3dBdjhDbW1VTWwrR3k4eUFL?=
 =?utf-8?B?bXprMTBUT09TKytvQ1JpTW1wcUZLclo0THpTcUhKQi9UdlpLQThGR21ZazFC?=
 =?utf-8?B?NFpScUwzTVNLWmRmUllSZ0pzR1ZiL2pUbXI5VW1ZcUViOWh5TDNGMXJpZzFI?=
 =?utf-8?B?QzRUSWoyQng0UStNbEE1R2pBTUdUWUFnRk9BWEw2bWhDZjB6d3BCdHdRYnNv?=
 =?utf-8?B?ZERFclR6Ty9iMzUrUm9CUXVaVXhtZWRQRkViU3BJajZmSmE3K3BQZytJVFFZ?=
 =?utf-8?B?a0hQSU9nTUEzYXBWUy85dlFzNVJRcmpXMFE0aDBYRHYrRGNLNEtMODd4dm1s?=
 =?utf-8?B?RFF2b0c4TmdwNlExZVRSUlh5OTliZUJaeWZEYWVtV1piak5BakFlemtxM2xv?=
 =?utf-8?B?N0pycVdqemdMa3ErdG5DeUowakpHYU1oVWdpNkdTSWx5eWhBTDRxVHdKei9y?=
 =?utf-8?B?dDBhYmpqRmxVVG1ybUw1TEw0Q3NkWVBuenZ0UWZlTzZFdllhdVZQMmFqdlVM?=
 =?utf-8?B?cnA0Y1hRb1d0TEQxSlk5VzV6MXMrUDFqc2tVaCtWYzBtT2lTcVo0SnFKaGxI?=
 =?utf-8?B?QmNEdHZrUmJTUkZBRGU4MUFPTVU5QTNSODFoNE96NURrVXozeUV1dnVjMWJY?=
 =?utf-8?B?QTYvdW54SjVHR3lsWWV0UmxxYTVWRUs2QStYb2lTbGVGSHJWK0xMOHVyejcv?=
 =?utf-8?B?TTVHL2s1TnBrNG5nWmFQaVNQUEl0U05yVU41N3BtN3k1NTdYY2dpNXByYTZS?=
 =?utf-8?B?UUQrVU1JMThZN3pPM2RBaXUvQjl6MXJhRXlMdGNlTDk0TUpaWDJCdjBPSFBy?=
 =?utf-8?B?bGk0N2g2MEdkcjIyUlg5STRiWFNyYllCdkFZMWNhdEt0N0p5bEN1N2tHWmlE?=
 =?utf-8?B?VlhuNk1EOWRtL01zL2RYY2xpRnhGc1dUb3czRVNmT0F2RW1sVGVIOTZuY0dr?=
 =?utf-8?B?aWlhMDFmb29uVklMMEJ5dm1nWElBUHZBT05kMFIvTVA4N3l1WmR3dVJVMGo3?=
 =?utf-8?B?NFI5WEcyY2hRVThLaFF3OVVzUmoyaEVLUDdSM2duSFJmMXZSbG5Mc2wxMTAx?=
 =?utf-8?B?WjkwdURJM3lUZFgxaFR1Sm94Y1FyNEhtTFQ5MnR2ZSs0Y1dKYkRZMDJVd2ZJ?=
 =?utf-8?B?Qm55eWhDaHYyc2tOd3hnVUVxc1VpemlvcmhKWHFBdUlmb0lXSis3V3ZSdHpD?=
 =?utf-8?B?QTNkU3p1d1VDd2dvMURiLzNiV3pWYlZSRDBKUzJ2azNoem93WDZ3UmlxUFlV?=
 =?utf-8?B?SFB3R0RXNXVISkh5d2N2TGtEcjhOaFZSR1REaUFCczZQYjh4a3dCdGNTVmpP?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC454988EFF7524893E37A0D246EEA27@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252b8d8e-4d95-4c99-a0f4-08dc74f78fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 15:56:19.6212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22fr59OnLoY9bJhglAnqWAdvfPZ0DkHSQn/wdbTAit2it8OkXBf4r9KLPr/cEET/6OUOXUnBpFoQKxujL7W5ZFsFtKNCLGwEXudI2cp4iIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7303
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDA4OjQ5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gV2VkLCAyMDI0LTA1LTE1IGF0IDA4OjM0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiA+IE9uIFR1ZSwgTWF5IDE0LCAyMDI0LCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiA+IFdoZW4gdmlydHVhbGl6aW5nIHNvbWUgQ1BVIGZlYXR1cmVzLCBLVk0gdXNlcyBrdm1f
emFwX2dmbl9yYW5nZSgpIHRvIHphcA0KPiA+ID4gZ3Vlc3QgbWFwcGluZ3Mgc28gdGhleSBjYW4g
YmUgZmF1bHRlZCBpbiB3aXRoIGRpZmZlcmVudCBQVEUgcHJvcGVydGllcy4NCj4gPiA+IA0KPiA+
ID4gRm9yIFREWCBwcml2YXRlIG1lbW9yeSB0aGlzIHRlY2huaXF1ZSBpcyBmdW5kYW1lbnRhbGx5
IG5vdCBwb3NzaWJsZS4NCj4gPiA+IFJlbWFwcGluZyBwcml2YXRlIG1lbW9yeSByZXF1aXJlcyB0
aGUgZ3Vlc3QgdG8gImFjY2VwdCIgaXQsIGFuZCBhbHNvIHRoZQ0KPiA+ID4gbmVlZGVkIFBURSBw
cm9wZXJ0aWVzIGFyZSBub3QgY3VycmVudGx5IHN1cHBvcnRlZCBieSBURFggZm9yIHByaXZhdGUN
Cj4gPiA+IG1lbW9yeS4NCj4gPiA+IA0KPiA+ID4gVGhlc2UgQ1BVIGZlYXR1cmVzIGFyZToNCj4g
PiA+IDEpIE1UUlIgdXBkYXRlDQo+ID4gPiAyKSBDUjAuQ0QgdXBkYXRlDQo+ID4gPiAzKSBOb24t
Y29oZXJlbnQgRE1BIHN0YXR1cyB1cGRhdGUNCj4gPiANCj4gPiBQbGVhc2UgZ28gcmV2aWV3IHRo
ZSBzZXJpZXMgdGhhdCByZW1vdmVzIHRoZXNlIGRpc2FzdGVyWypdLCBJIHN1c3BlY3QgaXQNCj4g
PiB3b3VsZA0KPiA+IGxpdGVyYWxseSBoYXZlIHRha2VuIGxlc3MgdGltZSB0aGFuIHdyaXRpbmcg
dGhpcyBjaGFuZ2Vsb2cgOi0pDQo+ID4gDQo+ID4gWypdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2FsbC8yMDI0MDMwOTAxMDkyOS4xNDAzOTg0LTEtc2VhbmpjQGdvb2dsZS5jb20NCj4gDQo+IFdl
IGhhdmUgb25lIGFkZGl0aW9uYWwgZGV0YWlsIGZvciBURFggaW4gdGhhdCBLVk0gd2lsbCBoYXZl
IGRpZmZlcmVudCBjYWNoZQ0KPiBhdHRyaWJ1dGVzIGJldHdlZW4gcHJpdmF0ZSBhbmQgc2hhcmVk
LiBBbHRob3VnaCBpbXBsZW1lbnRhdGlvbiBpcyBpbiBhIGxhdGVyDQo+IHBhdGNoLCB0aGF0IGRl
dGFpbCBoYXMgYW4gYWZmZWN0IG9uIHdoZXRoZXIgd2UgbmVlZCB0byBzdXBwb3J0IHphcHBpbmcg
aW4gdGhlDQo+IGJhc2ljIE1NVSBzdXBwb3J0Lg0KDQpPciBtb3N0IHNwZWNpZmljYWxseSwgd2Ug
b25seSBuZWVkIHRoaXMgemFwcGluZyBpZiB3ZSAqdHJ5KiB0byBoYXZlIGNvbnNpc3RlbnQNCmNh
Y2hlIGF0dHJpYnV0ZXMgYmV0d2VlbiBwcml2YXRlIGFuZCBzaGFyZWQuIEluIHRoZSBub24tY29o
ZXJlbnQgRE1BIGNhc2Ugd2UNCmNhbid0IGhhdmUgdGhlbSBiZSBjb25zaXN0ZW50IGJlY2F1c2Ug
VERYIGRvZXNuJ3Qgc3VwcG9ydCBjaGFuZ2luZyB0aGUgcHJpdmF0ZQ0KbWVtb3J5IGluIHRoaXMg
d2F5Lg0K

