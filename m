Return-Path: <kvm+bounces-63097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 173D8C5A8F7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8FB434E4AF9
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073C8328B55;
	Thu, 13 Nov 2025 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n3B/qPqK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A38328260;
	Thu, 13 Nov 2025 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076512; cv=fail; b=BtHtWkCJ/3N+uhgX6sEl0F95XGD84xf9c2PyFtkTdBVXR5XdUZwpISPSn6KYWJHPxVI8tPNeZK6gX/5PieOgH7auMoLQ9WGrIjhgwfpvuYFclZv+7rrzjlSZbiYESJ8Ch9TTNEzTKWF6D41KBhVCC7DPT5Fi/hkOZ4xwZBnf7MY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076512; c=relaxed/simple;
	bh=YSRCbaISN4uPG7FetUe/jwXCS6NmQ/Et1v9cz9vrs8o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IqmUvJuboSpDRfbRJFhnmMI3sPAU/ROrgtVGgVVRsvnBkhE8uOPe5JXOjpaeTEwGXwGhbL20Aw2MX5WfcTMkHpKQbzVEeq106DAZ1Lqw7dsifsyNdC/r/Q8fQuEGFsc45UkGfLzCbLN9D1SDVSXAlmRf1nOy+TGowmfV6lEVBMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n3B/qPqK; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076511; x=1794612511;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YSRCbaISN4uPG7FetUe/jwXCS6NmQ/Et1v9cz9vrs8o=;
  b=n3B/qPqKSNQjIrHivpc1IUV2887ZnnPMYzOJ9W5aMVjgZZsh4FeBq/XM
   Ly5SprfLs77pDnAtttmt/leH/JRYO0T6arzWyWKD1qO6mY7LPQQRdgxW1
   /yg2/KlEZ6x4eI/3JtOgAf/ix4Vrrrmgdg/vT98Y2bsPdkfktDh/PpXxe
   fsolq6autFYoyZ3OXts/iHRs/YhBExUiaSs/tvk47SsOy3r47GDD/f1PM
   EntmpO2vcW5a0zup2O4ehioE5UwBNTZRs+i1ly0ViCl4QJM2iSZ2mLf5O
   yKC9OXM5l0mdmBLQXFuC7v785c69Cy3DfJ/1uKu0wgNXsz/sOe4DtM5es
   Q==;
X-CSE-ConnectionGUID: zUYm2TGPQVa5VxlURwdv/w==
X-CSE-MsgGUID: Whmn5z38R7Spu736uzbMpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="75778082"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="75778082"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:28:30 -0800
X-CSE-ConnectionGUID: LNQtfihIQ/25gWEWqCe+hA==
X-CSE-MsgGUID: KJo1933OQB+1RhtFcaN+KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189457940"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:28:30 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:28:29 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:28:29 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.49)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:28:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E0Rqzs7i/CE81h78ji6TmJulQsg/rqVhVVe+8nvlreMOIBylII7aP2K48q/XeWuqFVsR/td0GZK3Mhfi5vB7Y96pTVv4rZvG+PCp+rAtzurNKXwb3n7ukTGSnWO50yufADFl3prhFJ3+YWyBow+G7YzungYlSvOWaAiNs8Q4vMwjgGz9xqwDfu9Kqzv+Yu0YVrfxEUy45mE/OVbUX/AYWFf9innAjM/AxHfSr41alSXe3PyIcMI/iDNuv/FJGlCECbW47MAzt6e10OQs++W2N11FX2Lc9BkbCQTxzi4sVTwlcVVeyq2KyL+GJkJAyOonqBIRmqCHENfFrHPTwtGE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOeVEoLCJd5M4Y+jLancejAc4HmwYAjiQN4VSrvI1A8=;
 b=b22YHZauq5nAmSE6YKrJj0SFvzY8XpZ+3hausLL8vReV+jmNnizyntXwRNVCMhxVO+3/Kb0VEm/EfeYgpU25ZjuxS8skFgxl2vgaHVbIYdaJPkV6XxQpOUXasokNkd7TDiLhOu20leuB2DkzqSKghQoV87IdVKIrObT/Nq8Ts6Y88PFeDXlmFkVkoabk+/N6In7CYOeViuwQZW/+Z5eBc7tPI1ZUmkaSVuEMlwfyfnlabkOJ51LOHv3Q1zGOYd3DsopxI2vHV1FTiGecIS9hoSPhr3ZNaguBGuFfpEUlaxEW6sOvPi0wdj8DuqhwiRv/edf4G+Ru965USbAEtnNtjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:28:27 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:28:27 +0000
Message-ID: <35eef645-f625-4a77-89ab-56b3085f91d3@intel.com>
Date: Thu, 13 Nov 2025 15:28:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 15/20] KVM: x86: Reject EVEX-prefix instructions in
 the emulator
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-16-chang.seok.bae@intel.com>
 <896debcd-f0d3-4f75-b090-c59b0ac1fa57@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <896debcd-f0d3-4f75-b090-c59b0ac1fa57@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::15) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f4cbe4-0d9c-4267-0a05-08de230c582b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b1p4ZkFHaUMraGtzN1R1UExPWUtvbVdWcVNZWEtDeXhzeVdMNnVWNEtJcVdY?=
 =?utf-8?B?UkhwaHREMUs2QWhBelExOS9odk9PT0tXYSsvUVFCQ0xIRWZkR3F3QjFxa3dI?=
 =?utf-8?B?MkJlL2JSRHVWQUkvZllHRDVVd2RuTm8rUHdYUEtvSytSMzVmcW94ekVUUWhz?=
 =?utf-8?B?aWpWTjV2OXpYNnJuVTU1cmU5RjV4T042WGQzY3ZVR2U4Z09DUzQ1eTBBU1h6?=
 =?utf-8?B?ZFNGMHJxbnVqakI1ZGNQa3ZvMU5IeTZMOWVja2FwZzFjZWxLVnJOSnlrUnR0?=
 =?utf-8?B?RjhLaHJJNnJSTFJic2RLbTJjVGVWSTRJNkh3d0swUi9qRWIxbWxIYTVoM3Q1?=
 =?utf-8?B?aWMzZFdEemI0a2tER0pmZ3NJcEtNZThZSFdRVlF2a0dWaUxIUTZDbTJTRldk?=
 =?utf-8?B?Y29BRm1TT2hEcEVhaUFWNGZvMXBVRUgySk9MUG1jbmJVZEV3VnpQWnBsUmww?=
 =?utf-8?B?dnJBSFRyeVo0d25Jb25VTy94bHAyQ1M0bXRXaWdqTzdDMFhRa2lWNVFBNitt?=
 =?utf-8?B?SEN2RWR2R2FtT0I4Z3VMU3FzUm1RRDRBNmpYMmhjMG9ENGJKMHFlcUhXWk5T?=
 =?utf-8?B?bUhjd2ZWUmVicUVSVmZPbzdlTW53d282ZVhseGJrVFpZOUJncGo4UURSUUlw?=
 =?utf-8?B?MlRlaDkyZDdmZWhIN1dic1FSdjZHd3JuV3RWZm5NbDFXWDY1ODEyc2RINzVz?=
 =?utf-8?B?aElzNmFScnRQc0I4RnZqczRIeWpucG9DZ2dScEVUVTNLRjl5UndvRzJDRmpa?=
 =?utf-8?B?VmpGQ3JTb3pTNXVkODM1dS9Gd1hSSXFnS2pNeWNyYVpjbzBGN0dvNy9ySS9N?=
 =?utf-8?B?U1dmTDIwTFJzbXJLbXRGZU5PZXA1UGJvQ2FtUlRDeGRHMVFYSENTamlOdE40?=
 =?utf-8?B?THZJNUUvK09oWldraWxKY2lRZTFMT2dEM1E3Z2NJWVhhY3h1REttUzdHOUtS?=
 =?utf-8?B?Yis4TEdZSURIeXZ6SWdHSFdxeTQ0K1ArWUlNaXZYemJubE9jcUo4bkZZUjB2?=
 =?utf-8?B?aDJRS21ieC8yc1o2MnozNlVHUndkQlFoOGppNUJHNXZ3MTVTVzQ3UnBKZUNP?=
 =?utf-8?B?WUxHVzBKU1U3N1ZKSUc2RWEvczdwUHcydS83aUVwVUFGK2JneWVBQTNuMU0z?=
 =?utf-8?B?OURHRnd6enRrbUh2THRKMU5aWm56a3dTTnlXemR1Yng2U25uYnFKSFdUZVYy?=
 =?utf-8?B?TzNUZmlPY3BDTkwwTXU0aHhZM2FsVVA1WlZ0eS8wSWN5MlNubjRKcnQ3MGYw?=
 =?utf-8?B?YkZDS00rZnFkNXptUzlidDRobTBmR3d2S2NIeU9hTm1NS3FiMUQzak5wR2RI?=
 =?utf-8?B?WW1XMFIvVTNabXYxVFBScEl5eDQ4UzNGUm1oN0JrbHBwMW1QR0o2bDZPRHQv?=
 =?utf-8?B?d2xWajdNYXFnZHgxTlllbXUxQitMTmRyb1JTc0FnR3NLbEdLODNUeXh4bmxR?=
 =?utf-8?B?bWhEbHNJSStKUkprbW82YjBUbW1CbWNwcjd4LzEzeDRTVnBzWTNzblNnT052?=
 =?utf-8?B?bzY0RmpiK3d6dHZWd0o3STJrZkpuWE5ldFZrWEoxdUthbHNFZUhaNjV6MmdK?=
 =?utf-8?B?OXd1L0duaUEwMlhxTWpsd241ZHczZGJUWSszTENLY3phM205RjhyaHEyMGpV?=
 =?utf-8?B?RmZZeVFsVmpWcjZaZ2dnSC80azkycDIrbHI5V1pGQmFXSVl4c3RkalhGWFla?=
 =?utf-8?B?WHBWRzBKQ2FyTTNwVTBNcjIwdTIxK1E3WSt1ckhBaktLWGx4VVZKblZiT202?=
 =?utf-8?B?UGRWWCtTd2JFR3JLeTJ3c2lzTWRuaCtkeVdIZi9lYUJQVnF3V1orRGtnVEZt?=
 =?utf-8?B?YjEwaHNBdEtHSldZR05IeUwwUmgvV2ZEZU55d3Jnd0VBMzR6bFRxRzVzQ2NI?=
 =?utf-8?B?ZFhyYnY2cWxMb0VKSUZlWXVpRU9EQWNKSXdCRmlTU0cwQVF4Y0Q4dFQ2Q3Yr?=
 =?utf-8?Q?/iNfTH/hCaf6prWe4yVNPGtXcsNV6+6L?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d21NS0VJOEhkd2NBd1hoTGdUYW0vUDJzUDFiQ0JWZkRGelZlUVpYZ0Q1emN3?=
 =?utf-8?B?eVd5YlFlYWJJUzNKMy82NDBIWnVMKy91NFlQaU95V095Y0JSSTcvalA0c0xQ?=
 =?utf-8?B?TjJVWTdXU1JVK1MzR2RzdVFnM09mS044MDBDdnltcnBqeFkzVVZkMk90YmNL?=
 =?utf-8?B?ZXBvUVl3M3R1bFFxM3VPYVRhc0R6anRSS3dPcENrMnJxd09yMTNoaWwxdjN0?=
 =?utf-8?B?aHNyMHhOT2lZck1sZkhTQnB0MkU0WkV6eDZvYWc2dTNGWm9ETWVZR2EzNWhY?=
 =?utf-8?B?T2FtUFJNSHF1Qmd6YllFenkvZXNoZFVMRTZ2azNKbXl6UnRkTjk4RENZTlZ5?=
 =?utf-8?B?Tjd3R2tvQ2hNRGhiVWNXNXZ0VlhRMmFoM2wzR29Yb25KTWV0WlJENEtaNWJJ?=
 =?utf-8?B?TDlPV0EyZ3Vvem14eGthQ3dLSlVZWUZibXRuN0FqTTR4NUVBajVCbmM1MnZ4?=
 =?utf-8?B?TFkrNnpJWWx2OUlKNU0xZXVZU01ncEdpdmNwMHFuN3ZMR0dhRzhGcGNFeFVz?=
 =?utf-8?B?U05CYlFnczJnSUdrbDdwNlFQc1MrYkNzazJaY3ZXa3NSVVFleHRiT3oxMXg1?=
 =?utf-8?B?VlBNM1VaeE5nMTlackJ3cnJrVDllVEJqWHV1cEJSU3R6czlFZCtibW9vRDZB?=
 =?utf-8?B?eXNFbzJ2dWJjdU5LUitzTjdqSStHRCtGTS9ONWpaU0NleGNjbS9qbG5WTmdq?=
 =?utf-8?B?eUlHbWcwKzBMb0dzYmEyejBFWjQ5TEk5UWRXT2R5eDMwTFFySkJHTVQ3ckF4?=
 =?utf-8?B?VUVPbmJ3bW56THZ6dDFzck1hb2VqUVdzcHBCaDdMUksyU0s0NWp2djdVZnJY?=
 =?utf-8?B?RVFMSmJqcU81RG5wd2JUMWFNSCt2MUZyNlhzWHdIRVYxdFBSZ2JGMWtDT3BQ?=
 =?utf-8?B?WGhKTHJDZ1ZIYTJTaUw1dE5UY280WUhSZDZwbjFHOE9lbE5yKzNTVFBMNHZo?=
 =?utf-8?B?NFNOaXN1bGVKR2Q1Z0RSTnNtQnBsY1AxRHBxclE1aGJkNjZKS3pub2hPTW1r?=
 =?utf-8?B?WUYwcURTbmoxSHJpanU4RHE5Y0pjeDdWbmo3T05mSTVBOWZEK0w4WFh0eHNu?=
 =?utf-8?B?L2tJZ2Z2dEpIcDNNWTNBQWJJZTlCZzMza1RibEIvYkpuY01RUHlIb3B2U0FE?=
 =?utf-8?B?ZFpqWWZIRVBxcTVKTEU3b0tEQksyQTJHekZheWYzMjBPLzNEcll5Rzc1U2ZC?=
 =?utf-8?B?bk1wNVhBa1dBdDdYWUlSeEtvMklqUENCVVJ6UHlYcGVWa3VkaVcrblZQZk1Q?=
 =?utf-8?B?ZzlZTGdhOWJjeHZKeDl2TEhVY2F4dzVmVTFlVnJuM1dIRkxOMWRYL0NMbm5y?=
 =?utf-8?B?RGc2VEdoZmN3S2ZNN01NNDNTMHgvQUxnNnkwazVRS3BNcGVuV0VrUFVvVWFC?=
 =?utf-8?B?cW9CQStkRVNQaHRmY3Z1RGRUWG12OUNHMVRMRVhsOGhXWDA4dkY2bW9NNEYw?=
 =?utf-8?B?bjIvNFVqUm1KRHcvSXJHMVNmaUNFUGhLM05MdnJCTUtPSUlqTWNzUVNmWjY2?=
 =?utf-8?B?THFLRzFxS1dJcG5PQ0xueHU3Q2ZSRGE2WjYvYlkwaUJsbG9BTFVBMXdxM0RE?=
 =?utf-8?B?cVA4dW9hNTkvOGV6aHFQenhTZ1lWVEVNSUNYYmJ3QWMwa2VIVXlJMlM5dTA0?=
 =?utf-8?B?MmhmZTYrdzlQaVg1bFlHeVozOGFqYUpvS1FqNjFkYW1sVUdiMDBCVHltQ0x4?=
 =?utf-8?B?djdDVVdiQlRJK2JoTWhaL3FGbEZ4N3RJZGhxOVZscUVkRUl1eFdkZ0N5SFk2?=
 =?utf-8?B?Z0ZSU2VXVVBVRFVWNlFPZldtSnFMekd1TGdTRlYxWmp6NUJvemtFbjhGM3hn?=
 =?utf-8?B?YmZJQlphSUNyUWN1d2pLc0ROMUpoS1d3MnU2aDBWN0JSK0kxWGZhZ2lrbkN6?=
 =?utf-8?B?TDRNemsyTkxUTlphdGtyVTNrb1hoY0RRb1RXRDB0N2c1K0U5LzMwV2JlTHNO?=
 =?utf-8?B?aGxGTkRhZVpVSWkvZVAvbktiQUZwZFR1Z3ZlWHFWQnRtQjR6ZENRUUZYVGVZ?=
 =?utf-8?B?RmVQVEU0NldBWHJoTW5iODdjV3NRZFdjZ05FWEF6cTUyc3JVOEFZY292S3NT?=
 =?utf-8?B?OTNmRUpIWTNDVXYrMXpaVTFxS056RGhmVzN1aU5UQ0FIMHJDT1JTNWl5VlFu?=
 =?utf-8?B?MGFuNlVxemZka3c5TFgvUk9hVzVISWQ5VGp2TUxGcTZKR3o3TzlYelZoZk1I?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f4cbe4-0d9c-4267-0a05-08de230c582b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:28:26.1967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLcuiUjWE5LtSMJ+BgyIBawc3LsD1eu0yZUudf32cVI6xCqG13vKk6MHczNjXHwSM2zBwf8wsBdpcd5KpIZOU0r8g56vQ3rd1bDMFMfl71E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

On 11/11/2025 8:37 AM, Paolo Bonzini wrote:
> 
> VEX support is coming (will post tomorrow I think) so the patches around 
> decode are going to need changes, but nothing major.

Sure, thanks for the note!

