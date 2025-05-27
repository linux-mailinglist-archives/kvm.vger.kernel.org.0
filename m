Return-Path: <kvm+bounces-47749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 183CAAC47A4
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B15AE3B6933
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 05:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF43778F58;
	Tue, 27 May 2025 05:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mp1NwGn6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E688B2F29
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 05:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748323818; cv=fail; b=OoCxgwHfDi4AsREeKTNsCIsdAeKgsuYaXdoegEjXhfQHKR1P8lkuEu19WrzSi2xACvNy4FAxx5FpGwhTNuncy9p9plTwDLplVYuV+Cr8R/OBIg++MjXxbhjxu7BrLpNsqp2GyBQ6EHvN73FHpBhGSUMvdmIp3qxV5KHf4PF/xDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748323818; c=relaxed/simple;
	bh=waT3NJwPpyimqDffc2VtStNoslkFAc+CQ2PCYb3uow0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NNmiw39iH0HupNLfPsETG2d9tQEe0PVW8zT8HFm4aoFjqz5wKlI8GunPEWht9puNyLxBHFHmFi4It6CSEnrGfrcAGo4mnw/Tmy+DcBKQCuIyllnYoJY1KsmyozfYgDJKPpmIlx4dFlQJHnCkt4aUje+dOIN8y6cCyw31pp4SEEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mp1NwGn6; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748323817; x=1779859817;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=waT3NJwPpyimqDffc2VtStNoslkFAc+CQ2PCYb3uow0=;
  b=Mp1NwGn6R9YFPzlRgbj0LBGp11vRX6NvmyPG1IleNVeK3H6hCyG7BbSg
   Vja8M/7v7eB+anPGFpW3sTBhte1iZ2qIK0q0zKLI3CK9eXHShYwOlC5GO
   yTFvesvV1xMaa5wfHpADooLVoFRvYfEzpNRRmq3lnfDqOiwR4JrtgBPo9
   30gkREAj/eqbK1VijdC0CgYgaMkgGHekXejQCVfCkRxeyjN9JuVktaoN3
   xOGZu0EzB9ZSnhj3x7yLpoPTMbYIyQp9WUV78Bl5uU92yvbFwBeV5bA8F
   dyGvwjytVBApa5VXzFXfg2gv83QrE9YD9BDZjK5jCGnok99HuRWynMA8X
   A==;
X-CSE-ConnectionGUID: 5TJifJVnR12FVlQiImKA8g==
X-CSE-MsgGUID: OpRLHH5KTUmuin77GaLt+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="72823573"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="72823573"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 22:30:16 -0700
X-CSE-ConnectionGUID: xPyvZabET5e0zTccJGDaSQ==
X-CSE-MsgGUID: ooQ0WYoKSG+SbKs6D+sIFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="143266054"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 22:30:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 22:30:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 22:30:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.68)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 22:30:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNoG008TbN4c3Q3ca9KTY2/kgp7ukl17pZTJWAs2ftQbJ8Q26CgKkUodwPQ3w0/cpIP4dp5iTis1oDsxTvrbTOIkpWKcl7HMe8l9tHCF7xPaEhKymFRLoWtNZuFkKu2gXvK6SJwJ9qVJtp89q7YEBzSovGL1w+fr839Xy4z33WW8tx379AoIE212Tot79KzphrkNKvSMDQ4anrVQjIdNtb36Ul36h1t5j8jCr3m6YYMvqnVw8CoYMwLkDEmuywoW+9M2FWKZwJpcPpk7jMUZlFD96voyl8HSyLGG6eyFiAJOBjC1HmDRb+m+dTBB1gz0smhdXFfc+zYutjIWpGh7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2P4cOeQ14l7nn6ZzNmNsZkn4mJ6tIJK9RjqEypj13V4=;
 b=rfT4dAleDxSS8AEgSStqlo54aRJCOoCvhw99fIsRQQCtEVM19NvC5Rad29n2FrVSY5DIlbDQ7N52Lo3fxgSONi6Wzhax+agfIbcmTJ5I2z6id4eWK72jSIrcvjVG8gbD37au5VHK4SSGjDvp4CYIBjKGDNs1ywkSirS2ajLE/LZ2MYdJfG5Mn+m3ewuh61FvhFCqMQ7Df8VLTjnFViIomnUXlOOJgln+2Me/QnMw8ElcmidLdgXYdLKnTrZRU5AcYFToTsJc8KiDArfTjrsqLMS65HS5ETJOgrZOyWYZdY0BXwX3QmBKwPyWV4zG3F4bNYqhzchMFiXfkuqcTwJ0Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ2PR11MB8586.namprd11.prod.outlook.com (2603:10b6:a03:56e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 27 May
 2025 05:29:46 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 05:29:46 +0000
Message-ID: <5ca3eefc-46bf-4948-9a6c-7a0c6c56757b@intel.com>
Date: Tue, 27 May 2025 13:29:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/10] memory: Change NotifyRamDiscard() definition to
 return the result
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-9-chenyi.qiang@intel.com>
 <91d978a8-98fa-44a8-bd69-829f3322488d@kaod.org>
 <bf65f5a1-999a-4133-b00a-be61d59c38bd@kaod.org>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <bf65f5a1-999a-4133-b00a-be61d59c38bd@kaod.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::15) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ2PR11MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: 271d6677-7046-4ec1-76b8-08dd9cdf7dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Sk5tWGJCYVJVT3ErUDBSeVE3UCtnTFkzN0dLN0NBMjdyNzNzVjB4dlJXMGlI?=
 =?utf-8?B?TVBuOVNjaFhrekRRQWQzZ1IrLzJla3hNMFRHQW43Ny9UbVNET2hSVER6QjFu?=
 =?utf-8?B?SENqVC9WQ1pwQm42Vk5RaU1iT1hkczBUZk1tblZ2OFF2OUhNeGkzOCtHZ2pw?=
 =?utf-8?B?ajhpMGdRdVVVMnVCdk5IcmRMd3dZMVExUmhhNVRYZXhFNDNaRzdJUG5henA4?=
 =?utf-8?B?dndYeUF2VGcxQmlPZ2NCbE81ZjJmK2YxZGg2SlpzbVBmaWxmYkVMTnBrNGhM?=
 =?utf-8?B?WTZ1NW1xdU8vV0Exb2wwL3o3MUhOM3pvQXZqcVo1cjlLTGRvbWNhckN2L1Q3?=
 =?utf-8?B?TEFvaktBOXNSM2szRitUOVFOOWhUVk8zWW1NYTdYanRvK0NtUkZIVUJ6enRY?=
 =?utf-8?B?c1F2OXkyTU1ycnJkUThGOTNWOE1sWDUzT2xjNVZZSENzcVdxVzlwdEhLTHNj?=
 =?utf-8?B?OEZiaHdWb3JTRzY0QXdpWndzRVFCbU1WY3Q1K2U2bDR3cklDYkkwUnRacTRD?=
 =?utf-8?B?Mi9Tald4UUJWOTlEYUNVSkZDc1ZlblZGT3dpc2ZVWGkxREt1TlFSem1lR2xt?=
 =?utf-8?B?bWRjZC91emRGWDRLdEJBOUFNRHM3eHVxYnpyeEo5YnNzVVJCWVNLWXVCL0lF?=
 =?utf-8?B?T3cxQ1laRFVDZ2p3SStpSFcycHl1VkpQYWhzQjRjT2o1NW42OCtDSjc1M28y?=
 =?utf-8?B?T1JPUzlPeWRobjEyeXBDM1ZvTkVjL2ovejRia1llWEZ4Q3BoTUtuWVVRSEQr?=
 =?utf-8?B?ZWdzRFNpUmloYmJYb1hEek1wUTE2K1NYc3BSRkJjVWo3cEdlRnVTUk1aZnRN?=
 =?utf-8?B?TTBBZXJDZFhaMkhvUzMrZDdNL0hxb1JPaWxuaE83OUdjVHR4SURhbU96RDFF?=
 =?utf-8?B?d2RHVTZNOUZldUMxWnFkcG1UU2poQmhvLzFCdVRZWHVjUHJOM2dIT2p2ajRp?=
 =?utf-8?B?SWhsSzJjak9IamQyUU9WWWhWK2lTVkFHSVhFRDlHMGUvZU9CQWo1NnUrRWZD?=
 =?utf-8?B?VlA2bEZPQlBXWjZKRzV1Kzd1MzNRTXE1bDVrK0RrTjBEV1hFdC9YbnE2VWJU?=
 =?utf-8?B?OWg5QVRpNVd3S0lFTy90QW5CQzVQVERnQ2JucEh1N1BWVHRqdlQzeVlqci96?=
 =?utf-8?B?OFYxNjMxUURBOURXWXNFVVA1VGxvSVBONGIvUzdiR29pWWVidDNkTWZxd1NV?=
 =?utf-8?B?c3l0YXptR2tSeE1kR0JQN1VHQ1I3SmdBQ2JjcTZQYkMxWEd5ckhNazJOb2Fp?=
 =?utf-8?B?SzZIOGJBa2F2VDN2dk5mWlA1T2NiYUVkemZRK2wrc0dMVlJsR3VTQkhJdno5?=
 =?utf-8?B?VmhMNVVyVkl6UVljaUxhekZlbU03cmRXMk51Vityb0JJb09oMnppZXFHRjRW?=
 =?utf-8?B?NXpQWW9McVhWMHNuOTRraTZRd0ptMVQwOUlkNkdtMG9lb1JKdDAxV3M2ZFhN?=
 =?utf-8?B?d2huUTJpVm5ja1BXc0tYVkkrS3pYNUFvV0oybVlEWklXS0xKakZ0RHByUW81?=
 =?utf-8?B?bTVxY0h5YUpkQ29RVUJFZ0V2OVdKN21WenhZMExKQWkySkRoOExWL2dYajR5?=
 =?utf-8?B?QmxFbXZWRjFNKy9CZDFydlIvTlIyOTNMWmNWb2NMayt4Mzk3OURHM0U4d0hn?=
 =?utf-8?B?OHRIOXNrVDc4b2hDaHNMOFdQNTJwdjQwTDFabmxza2JOMHJxWDB3M3V0R0VB?=
 =?utf-8?B?Qm9qK3VXKzFlYi9XeGQrMFVFMDhrdkJiT3k3N0xwZVAyWEJpU2tBRU1Mbk5n?=
 =?utf-8?B?TFFYbGk0VDMrbG9JRjlPWTJ3ZFNKaXk0WUlVVVcvVW9Ka3I0Y20rZ1BsWDFH?=
 =?utf-8?B?WFpoOXBLSW81TitDSFVPTHlKTkgyM3ZQeU9jOVVmVFVCYWRhZWI5SjRucUVa?=
 =?utf-8?B?aGJpWEpGckczei91U2hJK3hmcjl1ZjR3WFYxc0ZnWlZ2TlVONGRKTEhyQjE4?=
 =?utf-8?Q?eXwRAhv6DF4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlN5TE0yLzM4Rk5tK2U0SXNSVGJacXZhUDY5MW1wd3RIdjdRQkJwTkNHdU16?=
 =?utf-8?B?Tmp4RnRoYTNOTmlGd2V2YmNlZ3hVUElqZDhUWmRyVVp4V3Nub2pSVzVpanR6?=
 =?utf-8?B?QWc3RUZ1WGxiVXpVSlFoSWN4RFdCQ2w1bDhURTRvS2Z6N3drb2NNM2QzNENz?=
 =?utf-8?B?bEtaS05MbGlEeEREaGNUZTVEamhlUjg3aUlabk9ZL3NpT1BPNitMUVV2MnFt?=
 =?utf-8?B?RVZyU3poY0V6ODlGUFpBR2lwYmpiRFFZOThNQWhHVS91VCtELzZ0TFBDUUcx?=
 =?utf-8?B?bFRLUWl1OWlPNitQblNwa2d4RXF6eVoycU1jNHA2SXFtS0M5ZktXVmNXTVEx?=
 =?utf-8?B?bkk0WElObVVYU3V0NC9QbkpHaDR6VjVmUTlFMVY3eE1yUFdEZXNQZTlTc2tH?=
 =?utf-8?B?THZzUDh6VnkzOHRESytXTloxaDIrK0lkbWlXUWlzTSt4bUgxQnRzSG1QTm5h?=
 =?utf-8?B?dUJibHM1eUh2OUp0OE1Wdk5tSk9meHphSFNRVnR1Ti9TcmVXQjJ4RnRYSVVP?=
 =?utf-8?B?Y0RIaFJLd2lrT2ErS2ovV1ZYY1paUm5QQ3g3ZCtSNWtxU1puSFRQOXE0VE9s?=
 =?utf-8?B?UWxucmsxNmZ2ZFlCNlA2eWRSUlExTVdlYUxBNGhXb0NGdFhKSXpkYzFRSlJs?=
 =?utf-8?B?Yy9FcURxTFpKMjkvTkpta1FQTVgwczVmaW15dnVLR0ZsWjBOM28zMmhFY0JC?=
 =?utf-8?B?VlpYd1BJbUQ4VEd5K2VYNFFEVW0vL1VmbDVOZWUvN3BJVE9qWk13NzNGc1Ux?=
 =?utf-8?B?a0NHN0xtaEFEM2RIZHFXUHBGL0l1Vm96UEE2QmFqczNUWW1mcHJkdldNczNL?=
 =?utf-8?B?elIvU29FN0ZodTVIUFk0NjBtTy9HVjhGYnFHdTV2dmduOE9WVGVZVVNqR2N5?=
 =?utf-8?B?TSt4Mk9pdFN6cWtCWmRBODJlK2J4MllRWEJDZEJESGtsaFNCeTBsdVc1NmUx?=
 =?utf-8?B?cjBPUjhvaGV1bHVySmc5QUhydm9BWkZVTkFteGw0SStDQkdFc2RiWGlyZUpr?=
 =?utf-8?B?dGZEcVBhOENBZVdJQUJkVVFaRy9leGFsWnF0VmVjYTV6b1oxZDJDektpMGZV?=
 =?utf-8?B?NnhucEw4ZGtBd3c1YnlYOWUvTEwrc0oxc2N1MHo4Y08xSHd6SjdJaTQ5SjRD?=
 =?utf-8?B?M2V6cjlad0VXWXpJREtJVjFqLzhCMVZJSURCZkY1cElHM25sSmtzZ2dXYWda?=
 =?utf-8?B?V0JLN0ZrWStidVlNRmVVVEJ3Sm5uYzQwR2Evc1VBRGYrekZWYlZ5aDYyUVEv?=
 =?utf-8?B?bld1Y3NmQWNiR0IxOGNpeS8wRGNWV2R0UnBtOW9GcEVINWJsdExjMnZyMU53?=
 =?utf-8?B?blIrN0ZiOFBKOEhuL1gzUEVrd0wwMlVJUzlZbWlKRWJrVlRGM082RXgrVnQy?=
 =?utf-8?B?S0x1KzgzaEpPUk5rMXE5OWx4MllaSHV4MGJrenZsYUVOTFlFd05za3F5TTdl?=
 =?utf-8?B?Y3BsbU9zL0xQWDg5cEthSmxCLy9QT0dxYzZsNG1xZDJLSzhEREdQSTR5bGJ1?=
 =?utf-8?B?TFpleHNqS05FK004Nyt6Z3pTU3lYSmdCMkh0NFNCM3VSWEZiWDlsNnZHUE53?=
 =?utf-8?B?R3hiNjN3bFA1bTM3T1gxZWdvZ3Ztb3p1ZXpEWUMrWElOdzQ3MC8xYzRmYXlB?=
 =?utf-8?B?ak1yTkpYZDBuMlJnMWhhZWJzVkRCZHZaa3M5YmtyNUlWMTkzbGIzY1B4M0Jn?=
 =?utf-8?B?RTgybS9ZR3RSRllxYzdpMkdvSWdkb0dYanc3Z2JaNWxTTnc4T0xDZjBWMnJ3?=
 =?utf-8?B?R2J6ZXVVNExVYmtaU1h4ZFFGczgrYXlwc1lCNzF0VFlkVC9ZZGx3R0llM1Vh?=
 =?utf-8?B?NTlCRFVFcWIzK1FaOG9YVHRBL2l5dksvNGxYdmVsOFRqcEZuUVRScm5SNWRU?=
 =?utf-8?B?M1ZXQ2J5S2ZNTGhQVjVYN3U2ckRseUhkSmpjT3VFbVNvaXJTN0RxNVNHUksv?=
 =?utf-8?B?VXhQeEZDTHBoVm1sa3ZNR21jYk5iWjJobzViZko4a0E2bDdhdnVtaWNsTFQx?=
 =?utf-8?B?RVFWbVdrMmJ5RGkxcjUxY0RhMHhmeFFoL1VsL3pRSmtjYkphVzNMNnhTNXN6?=
 =?utf-8?B?SnI4ZUhlNHdNdG1SRjZnV21NWm1JNGxRbFdOdTVUZlozc1lBLzcwUWZMOGQx?=
 =?utf-8?B?UDVjTHlVMitoSVFTQTVqZmJlQnI5OVJjTXdoMjZkNUFBWXRjWnZoMEZGVkJl?=
 =?utf-8?B?WkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 271d6677-7046-4ec1-76b8-08dd9cdf7dcb
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 05:29:46.3064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emSz2DakSbvzplxEw19cwNwC10YXsOEnuG/FynVRWWM7m1GpqdxBbO4DTZQ5PACrKhRozneFarNqladQYkBNFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8586
X-OriginatorOrg: intel.com



On 5/26/2025 8:44 PM, Cédric Le Goater wrote:
> On 5/26/25 12:36, Cédric Le Goater wrote:
>> On 5/20/25 12:28, Chenyi Qiang wrote:
>>> So that the caller can check the result of NotifyRamDiscard() handler if
>>> the operation fails.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Changes in v5:
>>>      - Revert to use of NotifyRamDiscard()
>>>
>>> Changes in v4:
>>>      - Newly added.
>>> ---
>>>   hw/vfio/listener.c           | 6 ++++--
>>>   include/system/memory.h      | 4 ++--
>>>   system/ram-block-attribute.c | 3 +--
>>>   3 files changed, 7 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
>>> index bfacb3d8d9..06454e0584 100644
>>> --- a/hw/vfio/listener.c
>>> +++ b/hw/vfio/listener.c
>>> @@ -190,8 +190,8 @@ out:
>>>       rcu_read_unlock();
>>>   }
>>> -static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>> -                                            MemoryRegionSection
>>> *section)
>>> +static int vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>> +                                           MemoryRegionSection
>>> *section)
>>>   {
>>>       VFIORamDiscardListener *vrdl = container_of(rdl,
>>> VFIORamDiscardListener,
>>>                                                   listener);
>>> @@ -206,6 +206,8 @@ static void
>>> vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>>           error_report("%s: vfio_container_dma_unmap() failed: %s",
>>> __func__,
>>>                        strerror(-ret));
>>>       }
>>> +
>>> +    return ret;
>>>   }
>>
>> vfio_ram_discard_notify_populate() should also be modified
>> to return this value.
> 
> Nope. It should not. This is a rollback path in case of error. All good.

Thanks for your review! Anyway, according to the discussion in patch
#10, I'll revert this patch in next version, since it is a future work
to consider the failure case of notifying discard.

> 
> Thanks,
> 
> C.
> 


