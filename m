Return-Path: <kvm+bounces-25896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 491B396C386
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 18:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B681F26026
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74461DFE1F;
	Wed,  4 Sep 2024 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IgVE8tH2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212881DB55E;
	Wed,  4 Sep 2024 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466228; cv=fail; b=QPZHIaAZ5MphHvoFCmuYZlEjeuO3KeYNHa9uZYBTtBvohyIMzUU0NMoDhFgUMbM/n9wV09+zHdvkpVbDR14ww1R9j6oGU5sFqF3Bc7vSXnTEaVPeBtgmkwdbgmo9fCn/AjTEEqcpUfLPIhEm1I+rLYuGm4Su6GAtlUL7Yr/drDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466228; c=relaxed/simple;
	bh=1j5AsyfqbiG0JxcT2vFf2gjej5fvu/AKNc+Z7Sltc8I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rS2uSntFrXcgOsGgUpZRIteqvBZTzp9bcgJdz0aAnbsG/KF3478Rv+sI0R3ZGYnOB1sqU1bUxFhPqde0vMpf4jTk+64hFDObStXQfUR5KB2e+P1JQTrnrU12VdOUJOJxP1rjqt2kNbJCEZo8iQXTrhbvgphw+jMp9/Ht2c+yoyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IgVE8tH2; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725466226; x=1757002226;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1j5AsyfqbiG0JxcT2vFf2gjej5fvu/AKNc+Z7Sltc8I=;
  b=IgVE8tH2NyIIaFj+MTdUkFWK7dsbdva32/hrtKakAnDY3XRH/Y/6bbSy
   jTPiEelxvC0mUiUSZg4a6AGA5Y828qLtRWbNjsHycvhd+L5QNx1ViwyvW
   HWWbgPG9lT1pVUtC6ADdY8GXh5DW/urjzQcXvt0IqAuYipqnR35uW7S2E
   BB4SZCNhuIhUVXBdrAsaIUR8yc1mZ9NpchS9Ht/weelDLp1QPEdsWDuCg
   /YNU5CghV7kC47PLW8UwU5buI1XLCPb/B8I8G5Xj31id5hGSVlcx1ZeKK
   ktoKWf/yLakjg7+HlzLaFy2uTUwNe5DcZ5PBjf8Is/9hkV1FMKgnjGSUt
   A==;
X-CSE-ConnectionGUID: cBW2f7k2TKuITjCPmlV4ow==
X-CSE-MsgGUID: v4SVg7E8TNSO8BWA9Dkfgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="28025995"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="28025995"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 09:10:01 -0700
X-CSE-ConnectionGUID: lDsFdqflTzSWdu/WCoO9Zw==
X-CSE-MsgGUID: 8a+guAcHQeeVMD7DL3x0Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="88566979"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 09:10:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 09:10:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 09:10:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 09:10:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMZZ77vZ8j81OI3C+VGqfz0eaQgEhl+Y1EMpxmSE3eHCO7iLlgKa0aQkAeUZloWRFOiSf8LLklXyz4s1fIgkidRK8dUu4r14inpWZVZiMqaSVSK8PfW3SFzOczbQ0jBX/4v3NjvX3nfPtW70zgmqG7B2CY9chO3IFKEJ4I8IM1yYxdos4xrlWU23oDh7KsqTcsIak3hVms6UMUhMl2alAOskhPMtlopQmmERC/f37RrrNqgvtqh2BKh5FljguJhZkU3/QzGi77MrZcLIgEY3TgbbeVuRp9q7Y47xOMpXD+Hh5JYJFDncD49w4INsHdaZL+dhXSamxZk10FRiTyz4FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1j5AsyfqbiG0JxcT2vFf2gjej5fvu/AKNc+Z7Sltc8I=;
 b=aHlBXDxnUNF7+jlGLgSJ25z9xlQI0wQBc9Zv1ovd2nvDkoQOTeUMF1G9ZsSnlbsyxDE9kwgV4x52+VIlfm9DPSuz4kOBG6KIuuRHtWtXQabGCp+1fvJR9Dih2Ogdaz8zySRPy+z2yWgAmXiYC+M2Asn+KqsaFVQAwHRo1LPKkjSoqNo0GAmqAthgaSSg+FFNu0Gay9czYg3sZIUkalS3mmCjCIrGYWKlXc8FCkUgJp1QZleyfTdrYO5nAQsNuFogUerqI2olMz+H3bDOqlgj0/EdhBfEGASexiu8RSSKEAurjC6GQ7eJ7g9rgwpFFbvFO78sJ3qyoVICU50OrgBROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB8285.namprd11.prod.outlook.com (2603:10b6:510:1c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 16:09:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 16:09:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
Thread-Topic: [PATCH 20/21] KVM: TDX: Finalize VM initialization
Thread-Index: AQHa/neytRXdb7FYBkmadciQJYjo2rJHw82AgAAJCIA=
Date: Wed, 4 Sep 2024 16:09:58 +0000
Message-ID: <eca40f3f7a376661107cfd8cf62c6c9e7705bd3a.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
	 <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
In-Reply-To: <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB8285:EE_
x-ms-office365-filtering-correlation-id: 02b8f5b2-1e9f-4b31-5a90-08dcccfc05f0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R0ZUcFZsOG9HaU5ZbTFMYUcySW9oQXFhVkdNbG4vSzVodDBlVnFpMUgzOXk0?=
 =?utf-8?B?M1lnRHVaQ1VzRGpHQXM0WEpreEhGaldOUkgxWXVhZ1g0UFo0cTJ0eGpuYmNW?=
 =?utf-8?B?WUNhQ2JSM1A5Y29qQlhpUEI0cnhpMHBkSHRxOHJlWWJkVlZueTQ0dWJGcFNy?=
 =?utf-8?B?OTlIT1NDOHZabmhWNzdSY1QreFVNNFlJc1U4bGFVaks2WTdMWGpoQ2NuOUti?=
 =?utf-8?B?QkFQN2JLMjFPOTdZZis5RHcxc3htc1pTWi91VHB1K3F3ejQ2Szg4SDVsL2dS?=
 =?utf-8?B?NVEwU01qajZUSzgyemkxbXNhb2ZsNnVKMytsaVFJU2Nsc1dxeDhlSzFsU3po?=
 =?utf-8?B?VjE2NXIrdndCc3ZlYnZ0U05ZcGx5R1B5YTEvMGUxdXQ3UVF5MDdMVC9kSEg4?=
 =?utf-8?B?b0VtTER4cFRLdEtqMlBLcmhVOHhZbEdEd2l3c1Bib1Y3ZDUrYkwxRHBpWGxC?=
 =?utf-8?B?L29EdnhCMHJmeDhPWDVHRFhOam5mSzNZN2R3QTZEMGJBdUNGdlFaQUJMZmgz?=
 =?utf-8?B?OTR5bkhZQUY2L0ppc2k5M2VSb0dRelpJaVpGNGswUVk5S3Y5bzlvYjdFVWRY?=
 =?utf-8?B?eDJQcCt3VTFuL1hOekdsMG92K2c1NWc2cXVtUnlMQWhTdWY2ck9jenRObFBF?=
 =?utf-8?B?Q0Vtd1FTcldzWFF0S1dXU0dQdERxSlhJOEtiM3BmUjBHblB4SXUzakN4NG02?=
 =?utf-8?B?aFd4aHoyT3ozSGJlYTJBb1RjQVBPeHUvcU5ZaUlVRStoaHIrc0w5QUxtTUZ2?=
 =?utf-8?B?L0ZFVXZGWmIyb2IreDdwWmZORDJubFlmQTZNL3RIMWc4ZWVUQW1laHpyNlZt?=
 =?utf-8?B?Q05GRHdaYTVkVExheFM5UUg3MEpoNjh3UmtiaFJPV0ZzNEZFTENRelE0QmdB?=
 =?utf-8?B?QUJNeU1sL3RQUThnR0FWV3lzaVZKeGNoLzhSZ0UxemtUZTZSVGVFZ01IMlBJ?=
 =?utf-8?B?WFFMSTZmcmlWMitDUFZEaG04QUcyRU90WWNiVy9UdCthT0pISkNRcUhZUkVR?=
 =?utf-8?B?ZzIrSjQ0ZGQ0QTI0Ny9IcDhhbCtvRG1SYlF4bTg1U25xWEwzYzBpYUdpbStB?=
 =?utf-8?B?T1JBZHlWaExEU215eTBlWFpZMEN3dHA0RzFVS2h6d2pOdkNCNGdSYlVBd2d5?=
 =?utf-8?B?YjZ1UHJQaFVGS3RzdjZVc01WQng1cHZKcWNwZEJZMHNCTlpxTWI0MVhBd0Fq?=
 =?utf-8?B?eGRjMHZoM2FlRVNZczI3RDJDbWRLY1ZZbGVub3RVMjNNYW9maDVLTWVudVY2?=
 =?utf-8?B?QWQzK2xFdS8wQWNhUU00ODZZVjMzc3FTQ3ZSWDN0bUZmVzVwUUIrZjNtVUdX?=
 =?utf-8?B?Q0dsb0Q5bEs5Q1prenhvSVFoN3hmUytBQko5K1lpTWNBLzc3Nmp4TnJDdDFM?=
 =?utf-8?B?Zk55TXJyYnAya0hWeU1Bb25IT2dFaWtVWHBDeHBaeVU3RzdBOUFCQ3dHcDQx?=
 =?utf-8?B?Z2N4eUJ3RGllL1VhZDVpZE5DMGtEZzhpcVl4aUZzcEk3VHZlaUk2WHQzVXNq?=
 =?utf-8?B?cTBoSlVyS2RERVI1Undic3c2NWMybnFqMkJCVFlEZDFHNmY5Q05Rd0hWQTNZ?=
 =?utf-8?B?ZFowUkpHbkd6OXg5eDBkRG8ybHljcGJCR2oxa1FPRGFaV3BMZnBJV1lXTnp4?=
 =?utf-8?B?YUY1UEdXdDNTb0hONnl6MzQwejdYOFV4MEFaSFRqcElEOGRBVzRIRnJsNlFE?=
 =?utf-8?B?WjhLK0hMWXh6OEJPbUYyaE5ZOTN2R2RKSUhlRStncmEyekIzSzkrSkdURUZx?=
 =?utf-8?B?WVRGdVNGMWZ3NGZVbkFsTEVBUHFMb1B4eXVYdkdqbHhSSlJGbFhNbWVkd0lo?=
 =?utf-8?B?a3lna1B6VVUySEFYMWhzaFVIMTY5NDQ2V0UyR3VuMmZyQ0J2ZFpGSDl5UDVH?=
 =?utf-8?B?czgxaXByQWhBQUZSWmJuK2VyK0kxZ1greWg0UStvaEI3WEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUdiZkJUaXFBL3JEZ0ZoWHNvajk1UUFFQWFoTWVWcFVRbGpRRXNzT29vSFJ5?=
 =?utf-8?B?dXlZeThmaThtV3hjTU1SSmRjQzk1NnU5Mm1Jb2l4Rmcwc3dTR0dEOVJpaGE5?=
 =?utf-8?B?K1UxTTQzNlg0K2w5QjdzM0hObzMwZzdhUjQyNkJGRldjSXJTQ0tuSW9KR21O?=
 =?utf-8?B?U3Fzc0Z2VFJxZ0V4QUEzbmJ5L1dYcTVhZEJQODQvZmZtNjZiVjV0czAwZHNH?=
 =?utf-8?B?VFhCaXVzM05YUE1pRE50MThNMjQzaDl1S25uVWcxTldyK3JQZC90S0dhVlNS?=
 =?utf-8?B?eGNHNW5TckxuZVdwUWpKMWdZLzZuYkVJaW4rRWRRVllzRXo5eE5JS1dOdHBG?=
 =?utf-8?B?cmFDRERHY1JrNlBVUjNwRVFQaUdTbld6YzFLZG1kUG4zZ3ZhYjBTUWt4d0Nh?=
 =?utf-8?B?bWxzT3N4VWVKNVNQdGt4L2J5bVVYNU5UaVhDejlkNjlRbm1kRnJhbjRtSEI0?=
 =?utf-8?B?VE1rU1l6aUhqREIxb3BFOWxrZmdYaXpVTTRSVGFwMllMdEg4UWYxNXlkRmd6?=
 =?utf-8?B?alpGdXRUSlYxY1RmSVBETkVaNTFRclcra3NSUHljQmNFbThnWHlPOHNxWCs1?=
 =?utf-8?B?bVJHWWFSNlo4d2N1N1NqSS9TMEpreXpEUS9NdUYvMmlrY2NKZXp3QXNGS1BY?=
 =?utf-8?B?ekU1V0dtUlpFNzZNVEo4ck5PZktFQU9iSEtpelFIRXExTk1RWWEyeU5UOEdG?=
 =?utf-8?B?VEk5NGZTWEMyUTFoZUNUbUJnR29Xb2hDdlMwYkpwKzVFY241dXRCRlk2VGVv?=
 =?utf-8?B?VFZrZmlEaTRVdW1IVlBpOTNjRjNvWHB4ckRBZnNsYVQvS1hDWWFQb1UyL3Mr?=
 =?utf-8?B?RXdNZTdGV0p3Z2lkQW1VWTM5aUZpcU9JeUNVK1dlQmpIaHc0M0Yvb1NBM3pU?=
 =?utf-8?B?SlFLRUpnaFRicUtVZTBKTUsrcFlJbXp4a21IZEpTcDdhZ1ZoSkRuc25kR0Iz?=
 =?utf-8?B?VklmTUVaL3RGSnN2a0dpMzhZKzIzOE80bFhjTktVUXZJdXNwMGxNZ2gydWhp?=
 =?utf-8?B?Mmd1OHNCNE1rbTZRSHBNY2Zqd2hJSC9jQkx3YkNkUHIzQ2lDd0VZU0pIall6?=
 =?utf-8?B?QXhZengxUnUzeUQ0UTdnMTlLT2VmUGJKdjB6MnJIMFNnYmROYTcrMnJZeHc4?=
 =?utf-8?B?SWUzcnNDNU9WZFF6TjJYYmZ2KzBrTkRsS0xLNEJGdnZULzEzUEs4NHNBSzg1?=
 =?utf-8?B?SG5SRTYwcFpqV2crWkEya2FUN01PYmlQUWhWLzQxRDF2eTZtZCt2ejd6c1dK?=
 =?utf-8?B?VktxR2VvRk9IQnB6MEc0TUhxSHg4cnNvamRqbjFUSDdBY0dISWx6N09kYzhN?=
 =?utf-8?B?bnZHRXE4QmlKMUFVdWlnZk5oclJjalpaWFNUM2t2N3lpWXFTQjhLaUV4alJ1?=
 =?utf-8?B?N1V6NkJJZjJJTnozN1h0VVp2RURXNWtkcXlSUTh4ckJQaHUyWTA2ZFlDTk5H?=
 =?utf-8?B?VTdYSUpvZTNoVkgzdFFPaUlnT1lkM2prTlE5Qm0rdjVITVBYbEl0YjVHZ1gy?=
 =?utf-8?B?dXN4S3ZUanluMUVSeXhHK3pDQndyNWlGclRoRmU0ckFGK3RvaDlIQmNXcDdu?=
 =?utf-8?B?K2xsVXQ2L1AxMlFGeEJHUEt2NkJGRncyZjdWYzVvU1NwVzJIL1hpYy9WOTky?=
 =?utf-8?B?RXV3cHVEd1JSa3ppekJJWGEvY1F1UzdFL0s4YmlkMEdlY2huN2VFendUdXJh?=
 =?utf-8?B?Yk9neklKQTRqV21ZR3Zuakc3Ly91ZHFpRzB4SmorbnYyQzJFRmpEbHIxemlp?=
 =?utf-8?B?WWswckVBcUx6ZmNWMytPVE5EY3Z1YzlrRkhZT1E3Z3FwRVZxOVlISWZQcnZj?=
 =?utf-8?B?cWNCZ2Zzdk02Nm52a2F4T1YrYnczbkpjblhSZGRVUTFVeEFoMEdJMXc2NU5H?=
 =?utf-8?B?a1dlM1R2SnJta3lCZW00cU11bElXVk1hZlB6K1JFYXg0em5OWkpSL3hoU0Jr?=
 =?utf-8?B?OUYyL2dPVG1CKzUrelljZlJhOGk4ZE9hM0VadnNMVkEwVlE1Zyt4a29sc2d0?=
 =?utf-8?B?bms4cUROd3VnY01Hc3c2dnhQcUVoTlZVTlVaSEh6dTBUYk5SNEovZEtVOStI?=
 =?utf-8?B?TS9Da3ZPNUw0S3BwL2VVR3lieXpiSjlOYU8vSm5mOFpvOExFS0paWDVmZmll?=
 =?utf-8?B?VFFIbFpaMnFQY3hnL2VmbVM3bXpsUi8wb1VHTlZCZXRsSzM5KzlreVkrc0NR?=
 =?utf-8?Q?QNxKRzwHd3V77jSBFS0MqLA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66408AD83433444D8D39239BA24AC3FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b8f5b2-1e9f-4b31-5a90-08dcccfc05f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2024 16:09:58.3188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QrxTYTFs3H8J9ojemlmET7JmIsQNWbuzwss0aLAq0WPLHurShQ7GtjUO4oBEE7PjYItIrpBAdubxTDLgrxkukQrKfYxxlnRegoVNMrRXXDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8285
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTA0IGF0IDE4OjM3ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiANCj4gSXNha3Ugd2FzIGdvaW5nIHRvIGxvY2sgdGhlIG1tdS7CoCBTZWVtcyBsaWtlIHRoZSBj
aGFuZ2UgZ290IGxvc3QuDQo+IFRvIHByb3RlY3QgYWdhaW5zdCByYWNpbmcgd2l0aCBLVk1fUFJF
X0ZBVUxUX01FTU9SWSwNCj4gS1ZNX1REWF9JTklUX01FTV9SRUdJT04sIHRkeF9zZXB0X3NldF9w
cml2YXRlX3NwdGUoKSBldGMNCj4gZS5nLiBSZW5hbWUgdGR4X3RkX2ZpbmFsaXplbXIgdG8gX190
ZHhfdGRfZmluYWxpemVtciBhbmQgYWRkOg0KPiANCj4gc3RhdGljIGludCB0ZHhfdGRfZmluYWxp
emVtcihzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fdGR4X2NtZCAqY21kKQ0KPiB7DQo+IMKg
wqDCoMKgwqDCoMKgwqBpbnQgcmV0Ow0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoHdyaXRlX2xvY2so
Jmt2bS0+bW11X2xvY2spOw0KPiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gX190ZHhfdGRfZmluYWxp
emVtcihrdm0sIGNtZCk7DQo+IMKgwqDCoMKgwqDCoMKgwqB3cml0ZV91bmxvY2soJmt2bS0+bW11
X2xvY2spOw0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7DQo+IH0NCg0KTWFrZXMg
c2Vuc2UuIFRoYW5rcy4NCg==

