Return-Path: <kvm+bounces-19093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA23F900CDE
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 22:27:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AE1D1F22CCB
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 20:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CB514EC6F;
	Fri,  7 Jun 2024 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YaoH80vy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAFB42045;
	Fri,  7 Jun 2024 20:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792038; cv=fail; b=mZDDNXPdOosY/TP2TTRZSI4y2zPK6T2FCr4r+U/8uI/dRdbuhpPmhlK/503yIJJHnXScsdWsQYLz+UJUegQw8zXxo9IqpXUJxChN0GFQlB2YxkHbrotaT4q51qEmO/vSTkvVkhHlL77Tty88JfztO1l1lAKWLrHY8Cd3CQHrRCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792038; c=relaxed/simple;
	bh=Ju/NRrvAGQbejUIjaq3QZ70FwSk/tKR4QS7lKg8BVQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mAl4PsO4oiRTOF9Mn7A9lYsqedeEcuc4faZeJ3wDRoVHkobpWPvQLZm6sZBsCrB6Ny4WIxtIMdPfCO7NdKc4sqbm70k+3BAtZjxpmKr+Dz4PtwfLqsGeVhN7UmahRHCsEIlvKidRbs0/0QUZ6WjbEWe7lKL/7r5XjiJMkeodvo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YaoH80vy; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717792036; x=1749328036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ju/NRrvAGQbejUIjaq3QZ70FwSk/tKR4QS7lKg8BVQY=;
  b=YaoH80vyYTnMbPTsRoowk/8OeN/ROdNJmPZZ1e81EjdmKeqjLLuITUpK
   /RSSAElVPnlnQSUpzktVHNBCurqR8DgjcD+m9Ba3j81fxbhwjfbbaFjmt
   +P8bFlhkpYKSsyGBW1/x9PSoti2dZ/638KTHGDSy7/vo/Jh54iNUKHjoz
   MX1GNUvjdWiHccYSJl8g7ewheCRnA3OQcrLeD8nGHC8sGy2psDXkIYUAq
   zukO2Aq8PELT4ahdJxnYwMFD7SQpbAQn/konj/SZzR1PFHA+KV8rE7XUt
   dwV3LLJ4eRCIJ4vGfN7zO/gX9DVLHYjQu+7h9aNUN5S57GNzt2AgmUb7/
   w==;
X-CSE-ConnectionGUID: 4HmkwUtdSGyn0q9ufzaWXQ==
X-CSE-MsgGUID: 0gACRkuTRxmv6RzjnlgxyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14649647"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14649647"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 13:27:16 -0700
X-CSE-ConnectionGUID: tAneCusfSm+UL+zlEnBWaQ==
X-CSE-MsgGUID: 7bPy2aPARbKjBjCRSaMV1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="75925527"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 13:27:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 13:27:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 13:27:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 13:27:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt/219S8sQovg75cbw6Qttgw2VaIjirLsyvznFPSrUMLxUyOoMI+OKt75t5HVGsY4USvv4kzomdFfg9qmUqSMuCuXFkTsPrike2eDJWkBUVY828i1JUDYX0qWVeqKwqmY//OUPSX1BK9c6jrQChNtOPMHO27GhmvepHlMxAUsGWlYoE2A+SxEtstnrnzzehzn2MSSrzDyEmXszvuFgDhJ4t/Bitljzj5tvXIKLtUNkcjkdXEyf8FjxTr7LaixmitLFEjRiwusGpfz7urmxqjVJGT9AqJXoVdkGXFFy0Vir/brEPo1FSaTH7GInZsE6Aq2xxDdrveJi6Pm8epEksvCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ju/NRrvAGQbejUIjaq3QZ70FwSk/tKR4QS7lKg8BVQY=;
 b=ZYiNioOU+cqfGahJjxoz6o5D4JFyr9fghA86G0eEnT2L7lL4Y2kN14zPMtw3pfr7sfHknMq7ZyXrEJVb7VaeMgxNeMEabaPYWLM2razAasizo2MS/6D7QCHZvJht/Q8QYIzhMbeb1aHsJjyZxaR//BVmMStsykC5rLx276Z6m3DrjG7HYAoL1fB+YI+jXwJIRHjdODk3WzXjX2QatbQroMHs7oHAUFzi3hA6poTvz6buuGQfp9SW8cXJILIYFe4j43lcEJZYCYQeZlBykL4VX5FHKm6sT9WUHOEZM3vfT+4VNNWm+cMKNWTqNTPYastjVaK5Q/+Amdb7hfkEku0xFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6216.namprd11.prod.outlook.com (2603:10b6:8:a8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.22; Fri, 7 Jun 2024 20:27:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 20:27:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHastVuA3gf0B2hd0WXTTAj0WB0+7G8CKWAgADD1oA=
Date: Fri, 7 Jun 2024 20:27:12 +0000
Message-ID: <b1306914ee4ca844f9963fcd77b8bf9a30d05249.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-10-rick.p.edgecombe@intel.com>
	 <CABgObfbzjLtzFX9wC_FU2GKGF_Wq8og+O=pSnG_yD8j1Dn3jAg@mail.gmail.com>
In-Reply-To: <CABgObfbzjLtzFX9wC_FU2GKGF_Wq8og+O=pSnG_yD8j1Dn3jAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6216:EE_
x-ms-office365-filtering-correlation-id: 1700f368-dc37-494e-0a19-08dc87303669
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?OUdYcVpJSFR0MEpPbVJ5a3k1TjI2WVhHeWxCUWNQanVhNmhEbnFWR1FUT1JO?=
 =?utf-8?B?MFAvanNNcVdqSEZrMHVRRGs2bmc3MlByVlY4N08xS1pibStobzRJOHpEWWh3?=
 =?utf-8?B?VVJwalBiL1RHZjc1UkdVSXYraHdxUWNZOEREOVVZRENncUFJbzFNdmcxOGxJ?=
 =?utf-8?B?T0tyMXo3Y1pTaFNGVWh0czFvZ0hxeCsyL2dHcFg4Wm1IYTRIMXJaZ04xbnZ0?=
 =?utf-8?B?cWxvdjBFL3g5TWp2ME9pTnRrMHg5d09jSUR3MkZmQmhtM2gzSkNnckEwaW1n?=
 =?utf-8?B?Mks0YzRnNUFScEt6RXlmQ2hMNUUvYituWjV2UTFncC9XMXhsT1g3VnVTWXBo?=
 =?utf-8?B?UitrYkJ4MzZRaGd1Q2x0V0lNNnlUUUplVXNNUnNMRmJPcXpaZ1VJY1dLUXIw?=
 =?utf-8?B?YmlBQXROUFZTU0Q0MG02VFlYQk8zdjFiZThDRnFJTThOaGhXaGdpK0RpUjhU?=
 =?utf-8?B?cWJ3cVNVSEFPS1FTaVp2U1Y5M1hEM1RiVkVPWTZYYTRKNFBTNmxGZTRHTm5w?=
 =?utf-8?B?L091ZGxEUGMyQUxOOUxOcWs5bTBYUDRUNHhqZEJhOW8xanc2S0pFeGFBZFFN?=
 =?utf-8?B?cHRlTzI0ZndyNThhcGFCSDI2OWNNc0xQbTMxc2dBVXRMTmxaME5MZzJUMFRy?=
 =?utf-8?B?Tm5ZdW1scXFtTHpvbUJ2aEVFYXZ5Y1NTbVYvNm9ybGtIK2pWWERObDlwUDV2?=
 =?utf-8?B?bkNGWWRtMTJ3VEF1ZTdiWjVDOWJQdXJLMWRoRkFWcU43SWRmWmorVDJZaWoz?=
 =?utf-8?B?ZUFhV3BtRlNWVWRNL1BUeDJnekF5WVQzbGppUjBHMkNLa2FEU1VNdHR1SHR5?=
 =?utf-8?B?bGE2eHdzM2xCaVdwRHhlTHZONUNXWVFta2ZwMU1iKzQ3b2UyeFV4TGFyMHhL?=
 =?utf-8?B?d2xFWU8wQ0J3WnB2NVM2eWpOU3MyZnZMYXE4V09CZDFCMythQndOZmNVTG4x?=
 =?utf-8?B?YUs1NXhSeklpR0w2WjhzQXdxT3VLWWZxNk5XWVA5OHpla29BUE1ZdGhpR2xY?=
 =?utf-8?B?b2l5Q25BdVFlTGpxcEF2VU9TUkNIaENzWmozUTJwbitWWlV6VkpjaWZXT2Er?=
 =?utf-8?B?UHc5a0ZENXUrTGNVVlJoV3F6a0ZHR2c0MjNwWm5pTXROazFLbFUxSHUyd0Nq?=
 =?utf-8?B?OE5SakRXVHYzNFFBcThRN3JlbkJEQ3QwcHJJMEc1YWYrOElWR3llM3NpRlhC?=
 =?utf-8?B?cTZnNkJuNlBoMUZsVmRkcjRRbGJuNURXWnNrUUhhdUlSb3hwaTgyQlJnU1pS?=
 =?utf-8?B?V2VOQVJyUVo0eURlaE1idGwvVWFTYkpnTk1Sc1Y2dXNoaGY5cCtJMnRFcVpq?=
 =?utf-8?B?RjlYTHVVWCtuZnpacDlra1gxRzdmZFF6OHlNN1crVXVQT29wMGU2RHBYekdo?=
 =?utf-8?B?aWpETnFhVmllMjBsV005d1VMVW9pc28zVjcydFd4ZWpOZ2gxQUM0bUwzcTFo?=
 =?utf-8?B?dWF5VjliamJhdzBpYjJFVUUxTTlrYWhza2JiSWEvRnVNb204RExNRmZTVnIz?=
 =?utf-8?B?R21ibGRyN2pzOWdEQXRaVDN4ZGQvZGlUYS9aZTZ1VnJoMndwbndFbWZYWmxx?=
 =?utf-8?B?L2VsTVl1eXcvTjBweldBTzkzSmxhNXc2TWd6TXk2bzlYVjFSa3YxbDJRZHY0?=
 =?utf-8?B?VzUvZk0rMzJVY1MrNlNGa0FISTVtM3JObm91Skwvd2JLcm0vcXN6RGYwUVNH?=
 =?utf-8?B?bkordVJiNTRQbW82cEZLNy9Lb0hURFgvYVFIK1N2Zy9la0NDUVMzc3poMCs1?=
 =?utf-8?B?NDZhMEtDK25GcWpNdFVSejVGUzR2Qm1vR1E0OENzN2lOSm5nWFNFVU94L0lY?=
 =?utf-8?Q?Fa8GhgB7q77GTfXpKrIfVFP58gTykoZ4Wpe/Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGZ6SEJHeGwrTzI5SWxjbkhuS3hMaFFEUGpsaDIvRjdQbkdOaWJwZ1JJWTBE?=
 =?utf-8?B?djR3YkJDdnBzWklSendqTzJDU2NSc3phdnJ3NElUOUd4dXZFejF5VHFwSVlm?=
 =?utf-8?B?L0RkenZoL2lGcXFCanp6M004RHpVanY4M2ZwdEwzdWpZRWU2a0FJcThYZk85?=
 =?utf-8?B?UkFUZEFsTVBSR0ZuSFh0WWNMdHNYVmxrRVpSTjBJRGlIOXdCd2wvcVdnbE1u?=
 =?utf-8?B?Q2lnSU90Vjdqblg0MnhSVEJhZkdlWFBxTXo5TEtmc2RxZjUvQ1FZQXhienZ6?=
 =?utf-8?B?UmpFdEdGcytKT1RrbVpCUjVscnBvZEl3QmgxamY0NkFybmZDQXp5REtQRk50?=
 =?utf-8?B?SUcxaHlPZ296dk9qUkU2NW5YN1NHbWtNVkZkYkRNMVdCWDQrdWVmY3I2bkV2?=
 =?utf-8?B?aElHYUwxOHVFdUwveVRrMjBJK2VTRk1ML1MvRXBhZjBwT3U0R1BSRTFyZ3hE?=
 =?utf-8?B?eldIdVEzNDF5dWlJdlMwcGxFTlZhNHdQZ1RJK3czREhTRHU5amVpeDU5TWUx?=
 =?utf-8?B?Smg0cm1iaU5Hc0M0d2srV1k1ZG96TVpvZ0luMnZHcFNvdkFLQ1pNWStFS05r?=
 =?utf-8?B?VnRIWnN6cXlERWtrUWltNGFlWUhkYThVM1U2TjkwM3pKVGlFVUlLU2d3M0x4?=
 =?utf-8?B?YXM4SFR3T2FUZzhZUmZDMlN1UFFMa1V2RkpUaDBVaFFuK0dTUDZZa0p1SmVM?=
 =?utf-8?B?MkpIcFRiYi80OVFtMkVreFQrY1BmTjRsR2RqbGZ0ODFKNk4vWDAydkFqS1BW?=
 =?utf-8?B?dDNiWDQwMVUzTzdQRFRoL1IrOU1PeVVhTnJ6WkhWemNCVHVrK0lZd1J6S0d2?=
 =?utf-8?B?dkJPNGU1ZDRzZDB0MTVlZTJHV0laNXVIRGROZ243V01ZelU2SjUxR1VtTStP?=
 =?utf-8?B?MEdqWXQxVVc3V2NRT0FJSFlqcXM0VGVwdnhnMlVib0NGS0N4SmJaS0dDT2xq?=
 =?utf-8?B?YUJMR2pzbUFlVGQyS1RRa2RtR2hRdmV2b3V0NGkxaDdseDdZR2tCK0JlR0Va?=
 =?utf-8?B?OHVhMkE5WldpMHRIT1hRVlZCdEpBOU9ITllyOGVwL0dGM1VRcHlhSlptVVRl?=
 =?utf-8?B?aDROc2dlM1BIaDkvM1BiVldGQ2xPR1VUYWZVY3RHMGNTUEtHbk9iaVJwUzRu?=
 =?utf-8?B?S09JKzFraTNEdDlzaHRUSEZ4L0FKQzg1cXJsY1BNbmhGK2xFbjBEdFJvM0Fl?=
 =?utf-8?B?TWY5T3o3dUxMSXpsR3FwKzNtUFNKTy9Na2EzbFhKek1WaFYxUk43QmE5SE9D?=
 =?utf-8?B?U0ttb01vS3NlKzNNYTAwbzBteGFnSmJqYkdiV1hlTTJCNXJaRlg3L2E3N1VU?=
 =?utf-8?B?VjZPUk9sK29zZGRsTWJUdTd6WFNkZ0NpWUI2Lzd2ang4dTRJK2Nwb2RDNHdT?=
 =?utf-8?B?ODdJRkplQUUvTjdJVmlMdjU3dVlrM3Bmbm52VVoxbSs1WmFjNEhmazBJSTEx?=
 =?utf-8?B?MVhIR2Y3a2FnRHB3WHgvekZCMTAzY3U2Wi9sMXhFc2Q1WHBkcFd4QTlxMjBt?=
 =?utf-8?B?Y3BMcHZiRXZOMEhIV2JSQ1dDdnJITXhHMDR4RXQ3TkRGN0E3K3VhR2ZWNi9y?=
 =?utf-8?B?WDNnZlZJQWVrRFpYalM4Tmt4aDlVVDVsMUlWSWdqd0pid1hCRDlzeDNGTkJD?=
 =?utf-8?B?MmNlNVErWk5zSDYyYzUrWExyTThrVFNWOWpobW5qYnV4VVZlVkErdlBuQ0JV?=
 =?utf-8?B?VWl1UGtKUW55ajh3bGhxY2NXMERpemJHS2Rzd3RJZ0d5UWdiZTB6QW14WUhK?=
 =?utf-8?B?V0orQVIxZmt0ai9xZ2ZTNEh2WENLZDUwM1dHNjR4ejVycnlLb2VycnIzQi9B?=
 =?utf-8?B?dnJjSXFvd0ZsZHhxMUplVlFOcVhqMWtJZXJ4MXF5MlZybUtSbGJFUm02a1Bi?=
 =?utf-8?B?Yndtc1JMR0ViY2NNNDR3Kzg5bzVnRkhIZlg1bFUzeVhtNDhkb3hSWVN4bDRt?=
 =?utf-8?B?K3Ewb0NIU1B5MjBvK2dhZHpRVWlqRjA5MmhtdDlPQ0FLejk0SmcvVnVEalN4?=
 =?utf-8?B?YzlrSEZWVmYvRmxKOGZBaWVvRXJ5SWdCWXAyUzRYZ2lRelo1UlpIdTI4elRD?=
 =?utf-8?B?Qy9pNG1FOG85Z1RlK2JIeWlIdWJjSGNRaEVBYWIvUFlLYU1zWjR3a2tTMHc0?=
 =?utf-8?B?UWlpQmgxWTg0em9CYS9jd2tDa1o3aEZUSkhxa1paNUVtOEpodWdCYzQwUHlq?=
 =?utf-8?Q?0aq3iWy5QVEOrWSoTY2LzHI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <786A86907EF1BA4791B30B96567A4554@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1700f368-dc37-494e-0a19-08dc87303669
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 20:27:12.0610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KvgpUPBg3719AtKmcTGbQNZKbvppRYrdK6boDRik1/RAESaDq1zdh6QVxk/cbkaKzsOFKQTymrh+v1WfKejCq/anSvnHw2hlUIP9rvWFsqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6216
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDEwOjQ2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBUaHUsIE1heSAzMCwgMjAyNCBhdCAxMTowN+KAr1BNIFJpY2sgRWRnZWNvbWJlDQo+IDxy
aWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gK3N0YXRpYyBpbmxpbmUgYm9v
bCBrdm1fb25fbWlycm9yKGNvbnN0IHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fcHJvY2Vzcw0K
PiA+IHByb2Nlc3MpDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDCoMKgIGlmICgha3ZtX2hhc19taXJy
b3JlZF90ZHAoa3ZtKSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
ZmFsc2U7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIHByb2Nlc3MgJiBLVk1fUFJP
Q0VTU19QUklWQVRFOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wga3Zt
X29uX2RpcmVjdChjb25zdCBzdHJ1Y3Qga3ZtICprdm0sIGVudW0ga3ZtX3Byb2Nlc3MNCj4gPiBw
cm9jZXNzKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoCBpZiAoIWt2bV9oYXNfbWlycm9yZWRf
dGRwKGt2bSkpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHRydWU7
DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIHByb2Nlc3MgJiBLVk1fUFJPQ0VTU19T
SEFSRUQ7DQo+ID4gK30NCj4gDQo+IFRoZXNlIGhlbHBlcnMgZG9uJ3QgYWRkIG11Y2gsIGl0J3Mg
ZWFzaWVyIHRvIGp1c3Qgd3JpdGUNCj4ga3ZtX3Byb2Nlc3NfdG9fcm9vdF90eXBlcygpIGFzDQo+
IA0KPiBpZiAocHJvY2VzcyAmIEtWTV9QUk9DRVNTX1NIQVJFRCkNCj4gwqAgcmV0IHw9IEtWTV9E
SVJFQ1RfUk9PVFM7DQo+IGlmIChwcm9jZXNzICYgS1ZNX1BST0NFU1NfUFJJVkFURSkNCj4gwqAg
cmV0IHw9IGt2bV9oYXNfbWlycm9yX3RkcChrdm0pID8gS1ZNX01JUlJPUl9ST09UUyA6IEtWTV9E
SVJFQ1RfUk9PVFM7DQo+IA0KPiBXQVJOX09OX09OQ0UoIXJldCk7DQo+IHJldHVybiByZXQ7DQoN
ClRoZSBwb2ludCBvZiBrdm1fb25fbWlycm9yKCkgYW5kIGt2bV9vbl9kaXJlY3QoKSB3YXMgdG8g
dHJ5IHRvIGNlbnRyYWxpemUgVERYDQpzcGVjaWZpYyBjaGVja3MgaW4gbW11LmguIFdoZXRoZXIg
dGhhdCBpcyBhIGdvb2QgaWRlYSBhc2lkZSwgbG9va2luZyBhdCBpdCBub3cNCkknbSBub3Qgc3Vy
ZSBpZiBpdCBldmVuIGRvZXMgYSBnb29kIGpvYi4NCg0KSSdsbCB0cnkgaXQgdGhlIHdheSB5b3Ug
c3VnZ2VzdC4NCg0KPiANCj4gKEhlcmUgSSBjaG9zZSB0byByZW5hbWUga3ZtX2hhc19taXJyb3Jl
ZF90ZHAgdG8ga3ZtX2hhc19taXJyb3JfdGRwOw0KPiBidXQgaWYgeW91IHByZWZlciB0byBjYWxs
IGl0IGt2bV9oYXNfZXh0ZXJuYWxfdGRwLCBpdCdzIGp1c3QgYXMNCj4gcmVhZGFibGUuIFdoYXRl
dmVyIGZsb2F0cyB5b3VyIGJvYXQpLg0KPiANCj4gPiDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBr
dm0gKmt2bSA9IHZjcHUtPmt2bTsNCj4gPiAtwqDCoMKgwqDCoMKgIHN0cnVjdCBrdm1fbW11X3Bh
Z2UgKnJvb3QgPSByb290X3RvX3NwKHZjcHUtPmFyY2gubW11LT5yb290LmhwYSk7DQo+ID4gK8Kg
wqDCoMKgwqDCoCBlbnVtIGt2bV90ZHBfbW11X3Jvb3RfdHlwZXMgcm9vdF90eXBlID0NCj4gPiB0
ZHBfbW11X2dldF9mYXVsdF9yb290X3R5cGUoa3ZtLCBmYXVsdCk7DQo+ID4gK8KgwqDCoMKgwqDC
oCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290ID0gdGRwX21tdV9nZXRfcm9vdCh2Y3B1LCByb290
X3R5cGUpOw0KPiANCj4gUGxlYXNlIG1ha2UgdGhpcw0KPiANCj4gwqAgc3RydWN0IGt2bV9tbXVf
cGFnZSAqcm9vdCA9IHRkcF9tbXVfZ2V0X3Jvb3RfZm9yX2ZhdWx0KHZjcHUsIGZhdWx0KTsNCg0K
WWVzLCB0aGF0IHNlZW1zIGNsZWFyZXIuDQoNCg0KW3NuaXBdDQoNCj4gDQo+ID4gK3N0YXRpYyBp
bmxpbmUgZW51bSBrdm1fdGRwX21tdV9yb290X3R5cGVzDQo+ID4gdGRwX21tdV9nZXRfZmF1bHRf
cm9vdF90eXBlKHN0cnVjdCBrdm0gKmt2bSwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
dHJ1Y3QNCj4gPiBrdm1fcGFnZV9mYXVsdCAqZmF1bHQpDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDC
oMKgIGlmIChmYXVsdC0+aXNfcHJpdmF0ZSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4ga3ZtX3Byb2Nlc3NfdG9fcm9vdF90eXBlcyhrdm0sIEtWTV9QUk9DRVNTX1BS
SVZBVEUpOw0KPiA+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIEtWTV9ESVJFQ1RfUk9PVFM7DQo+ID4g
K30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgc3RydWN0IGt2bV9tbXVfcGFnZSAqdGRwX21t
dV9nZXRfcm9vdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gZW51bSBrdm1fdGRwX21tdV9y
b290X3R5cGVzIHR5cGUpDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDCoMKgIGlmICh0eXBlID09IEtW
TV9NSVJST1JfUk9PVFMpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IHJvb3RfdG9fc3AodmNwdS0+YXJjaC5tbXUtPm1pcnJvcl9yb290X2hwYSk7DQo+ID4gK8KgwqDC
oMKgwqDCoCByZXR1cm4gcm9vdF90b19zcCh2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEpOw0KPiA+
ICt9DQo+IA0KPiBzdGF0aWMgaW5saW5lIHN0cnVjdCBrdm1fbW11X3BhZ2UgKg0KPiB0ZHBfbW11
X2dldF9yb290X2Zvcl9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFn
ZV9mYXVsdA0KPiAqZmF1bHQpDQo+IHsNCj4gwqAgaHBhX3Qgcm9vdF9ocGE7DQo+IMKgIGlmICh1
bmxpa2VseShmYXVsdC0+aXNfcHJpdmF0ZSAmJiBrdm1faGFzX21pcnJvcl90ZHAoa3ZtKSkpDQo+
IMKgwqDCoCByb290X2hwYSA9IHZjcHUtPmFyY2gubW11LT5taXJyb3Jfcm9vdF9ocGE7DQo+IMKg
IGVsc2UNCj4gwqDCoMKgIHJvb3RfaHBhID0gdmNwdS0+YXJjaC5tbXUtPnJvb3QuaHBhOw0KPiDC
oCByZXR1cm4gcm9vdF90b19zcChyb290X2hwYSk7DQo+IH0NCg0KSSB3YXMgbm90IGxvdmluZyB0
aGUgYW1vdW50IG9mIGluZGlyZWN0aW9uIGhlcmUgaW4gdGhlIHBhdGNoLCBidXQgdGhvdWdodCBp
dA0KY2VudHJhbGl6ZWQgdGhlIGxvZ2ljIGEgYml0IGJldHRlci4gVGhpcyB3YXkgc2VlbXMgZ29v
ZCwgZ2l2ZW4gdGhhdCB0aGUgYWN0dWFsDQpsb2dpYyBpcyBub3QgdGhhdCBjb21wbGV4Lg0K

