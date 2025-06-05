Return-Path: <kvm+bounces-48613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 923ADACF9A7
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7A353AFC08
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7280C27C875;
	Thu,  5 Jun 2025 22:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V70A/qBu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54E72749F0;
	Thu,  5 Jun 2025 22:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749162155; cv=fail; b=eCIYnmIp2pCGQIXJP9JKlVscqfBVy7zuSLKBCvHZazOJ9TMhNKJwX6UMAiyO1KadvdOZJ752ztNF76sG7Q9szJHg2TpAHfZpm7JPE1bJjIXU/BYl/mkdZc9cwdH3jxtR+bXhURLC+FjrXxqgyBOo9VXmyMlBjC9HeDwYNMEgooM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749162155; c=relaxed/simple;
	bh=jwEDBe86Ra4fVPyGZjJ1LF2PMvG2Ixmw8MNFRwRdIn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mjHkABYB/yI6mAp9r5QPX3+d5jeakZi3TO83DFYvvHSxhwgWWiIspMMoTWqgzAo33Tl6HMGB04D5d1v9Yc4v2vdNjBt9cM2cOFhVqPs+7wFYc8grAitRcxW/5P/LBwR4c0vC2NTu3y7IbpxNZteFMkEnQWkuDgCh2i3pqi/B9YE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V70A/qBu; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749162154; x=1780698154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jwEDBe86Ra4fVPyGZjJ1LF2PMvG2Ixmw8MNFRwRdIn0=;
  b=V70A/qBuxpNunoOVn3xt49gCM63nKkwyRHaeY+aXN+C6utOKYuYXcoTl
   CfjwHAUieJrLTErWFZS8VInTLkJ/ugua38osHkvSaWMeVYHmZPwjLOzKa
   6XElpZSPYK8NOnSZjlku1S99lwZHF/lrSFcfbe+0eKT7t7/RjgDCzvygy
   GVS+AgQE6+jU0rW9dkEI1l7BWwvX044yyDMKF1f62mnCRtmQbOFQPtnh+
   ZX7OUuDQxnSC4iddTJUusITYTalajb7Dpq3LJfUxKAdXyzlZ0YWIv2iMD
   5pspzt8XZWlWlW6u2qz/YnmXyqaDNOBqWnP93hJbijg/YMIJeguRnGChq
   A==;
X-CSE-ConnectionGUID: O8FK+/2BQNOfY5iVysDQZA==
X-CSE-MsgGUID: zltLh4wRQ0eF7QqokaKqLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="62663241"
X-IronPort-AV: E=Sophos;i="6.16,213,1744095600"; 
   d="scan'208";a="62663241"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 15:22:33 -0700
X-CSE-ConnectionGUID: 9gNeDbiATcaFh+LGxiZCdg==
X-CSE-MsgGUID: YLegbgADRqSNdij4UyPfzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,213,1744095600"; 
   d="scan'208";a="145540118"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 15:22:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 15:22:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 5 Jun 2025 15:22:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.47)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 5 Jun 2025 15:22:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E94W4O0GrN4okBshF9YJ+GqMf1QfmNraN7yfhVHG2cx5akEUEu2DUxnoi71suAHjZvVQ+eKHeY+JuCx65pGW4LWAzV7NsyaXKF1nezbCeojVNMtfWtRJr3xZKFhK7t5Z0oynNJvwL7csAsFXw/XcP60TSilCOBJt3FmrkJ4YeXjnzN0+qHdSY0ZuV6fT/Gtd5CdtHmX3+zXaF9lEka0DUHMqZVdYhmo7zyNG3+fzIdp85UM7HK+0xxZeF7EGmzjiNwzWRvYh9XI8BwSjKUE9S0E8sZu1cflmaEOGEOxvWqXJ4n0dI2I3WaHfZUpLoONm11+ftqaEogiWJx5JCLH1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwEDBe86Ra4fVPyGZjJ1LF2PMvG2Ixmw8MNFRwRdIn0=;
 b=AqYIyfckTlHxikKAceU/WZALcBBDf1Xsbzx+3IKAseuiNFp9EpO7/JEceYUPfyu02wY6gEcckiB5iJXQtpj54KrRp3C9/poGJPm/A7VCBU4PbsTis1+prLaMkGhybEwMNBe0IEhLeHezexx3NtxADpnk47bmeFKX7Y7rtaRUuZbksjmnfyRnta0XeRQ4OXFDuZ2d6IRyyftvefw1Vy6xyVNO0MdLpPL3/SWho8df6CztbdWla7b9GeUok7ybYl0l6xPZ6JLWrNcP0MagelhxAmzZIZxgb0c//QQY9fgrrPYqT8l7XHJfGPjrPMh+4O6Wj0LXFtxPCWCBiy/ld0JEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPF957B3B2A8.namprd11.prod.outlook.com (2603:10b6:518:1::d39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 22:21:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8813.018; Thu, 5 Jun 2025
 22:21:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Thread-Topic: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Thread-Index: AQHbu2NdArquWBZL3k6ZxRzni0e1trPFhLGAgAM9bgCAAMm8AIAFRXMAgAJ+QICADu5ZAIAUf0OAgACcfYA=
Date: Thu, 5 Jun 2025 22:21:46 +0000
Message-ID: <46e0a089ea78613be5f0287eeca449231731f824.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
	 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
	 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
	 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
	 <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
	 <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>
	 <mgu7at7d3qy4h55bchxfmxj6yzqyi7gh4ieds4ecdvlv243frl@bzou376shiak>
	 <wwftow6boiueqbzrbfpedxs3e3ioelx3aqmsblzal6kxqdt3d5@dljyaozrfiry>
In-Reply-To: <wwftow6boiueqbzrbfpedxs3e3ioelx3aqmsblzal6kxqdt3d5@dljyaozrfiry>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPF957B3B2A8:EE_
x-ms-office365-filtering-correlation-id: 0b61c676-1edf-46ca-a18a-08dda47f5c05
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?UmlMSTUvbGcxU050NXp2ZTZHYXB6NWE1cW5rWU8wZWh6U0lSL0taSC8yZ3ly?=
 =?utf-8?B?aXd2UlVSdjU2Z3lEQm9ZZDdseE1SNUtlNGVDeXRlNDhUbmtuZlhVZk1IbDBO?=
 =?utf-8?B?YVhvVjBsV05aanlLN3g0amRSTFpzTCtUWnpESHJUZ1JZVUJ1aWZqZXZQNG0x?=
 =?utf-8?B?a3Ryd3A5WU1CUmVFeWM5UDNhM0xWWWlRclZmZk5iTHRKZXROb0VRSUJ1aC9T?=
 =?utf-8?B?ZTRqU1Y0UkEvcjUzNGRINEJQNWF4QVhRYS9XVmFId2p6WFpFNTBlb0J6Nnpa?=
 =?utf-8?B?ejZ4aTVOZ21wUm8yZDhyK0NiNjJNTmhyN2hhaDlVYmV2clQ1NkZ1N283UmtG?=
 =?utf-8?B?dk1QVE1jejVzV3F2MlR1Mk1DUkRtSFNJQkJ4ODMwRDk3bjVSaG16dEVqOUpI?=
 =?utf-8?B?b0c1RHBpTFdrYzhmQ0lzYVV3d0FGYXVETnIwQ1Z1b3RXYXVaSW1qMitWb29I?=
 =?utf-8?B?L1A0c0FZdFBDOEtBR1FWelhTd0lvU24wZjlDbytKZ1MvNWJFK3VtMmg4OXBv?=
 =?utf-8?B?NjhTWVZzN2xQNWlzYnZjMlp3aERxZHYzUnBMZGQ2bGxrTUJXbWUyQ3QwZWk0?=
 =?utf-8?B?bEUrYndiZWtOb1FaQ1JnbEJPK0NCaEdxcXdjWlF4dndnQ1pid0ZnakcvT3Vv?=
 =?utf-8?B?eHlBWEErLzNSR2xXYm1zWHc5b0UzN0pYZ0NrMzUzVFY0R0RnOXVydlpoVlVx?=
 =?utf-8?B?THVSSDY2cmFpOHhnTXNBa3R5bkU3WSsrRVJkK0RWZ2dXbkZ5Mkg0cHVnRDQw?=
 =?utf-8?B?MnRrRWZjL1JOKzNibkRudC9jUmNQMmR3OUdPWVdlVHE3aGNySEY5Sm5KZEJ6?=
 =?utf-8?B?c1F0cmthaU1LUy9RemU3UzBraDFDYklURDF5K0dPNmlZaTVJZzJTS2JRWDY0?=
 =?utf-8?B?c0tpQ1FWYUhDbGFEVXhlMUQzTWY4TFBlbEt2bmdmZ2FIQzdFMXNWVmhrOVdj?=
 =?utf-8?B?ZTZRdnBBbEFYV0U3d3NIWkhlcmpGY211ZVRqNkgvUmc0TldsZHZjUC9HZXpF?=
 =?utf-8?B?N2s3c0ZzVDk2cGRWL2NIQUlnZGJkcXVPT3B3NmthcDdkRUV2bUlBL1QwYlpW?=
 =?utf-8?B?NU5pazBhSWUyS1FRamlkYTl1TnJHRi8zN1IrN3dtVi9nY1VRcTRhWU5aWkVw?=
 =?utf-8?B?WmJaWGh4WkRmN28xTWU1VTB4WUo1T3lWdTROWnRUNkFRM2w5TndWVU9ITnBZ?=
 =?utf-8?B?VEc1NThDMVlyNUlMY2JkaytkRkNETFpqc2xaNTQ5aURvZHlVVjBYR3gvQ2Ux?=
 =?utf-8?B?dXd4WVllUmphZ0lqTU4rZUs2RkJQQkRiTnhJMWZKcENsVTRRRnJNK084NkNp?=
 =?utf-8?B?WThPUU9Ocms3WDJyUXJZVDdYSCtsSVJtSXhobE03M3ZSd1g2dE40bGk0Z1BB?=
 =?utf-8?B?blplOVYxZnpjcHRlU2xpMnN4VE5aL0JoQTdYc1NUY3hLTThvRXJHN1EraFJS?=
 =?utf-8?B?M2FPek9LQXB1bFFjSDhsMHJ2bm9wVGZGNExhMzdxRkRLbHE4bVFuNlF3Z1o0?=
 =?utf-8?B?M2pzRHRSUWdXTHNuSGJTZ3YxVmIzdk90d3gybXZCc0ExdlZaZXRnNzFpQkE3?=
 =?utf-8?B?OEdlSEF3N21aL1pYbEVFR2hTaDUzclluUG4vYk1ZUkMwRWtaaWxZL2JuUGNw?=
 =?utf-8?B?M3hBN05nRVVIdjhLb3F3YmpGbS9UbTFNN1U0bmZTV0t2ZGh0blVXN1h3YlZJ?=
 =?utf-8?B?NlpBd2EvV1hvdVArOUJUcEJmdEJvb1d4Zm0yQXBhQXRJMTlicldna0lKUVJM?=
 =?utf-8?B?ckt3cm9kYUc5aTJTaGRMU3Q0eStGY1o0M29idWdLcEpNTVVZcW9iRzVFeFd6?=
 =?utf-8?B?NnBab2luYnFVa1RRY0xUOEx2RU5iVWg2d0JUaUR1S3U1ZGVhdEdGQkc5ZFZ4?=
 =?utf-8?B?NC9RTzZyNWt0NllrOFRxTGxLdTZhSzhQa0Zwcld6d0t0eVY2a1VXeTRKVlp4?=
 =?utf-8?B?SEREaUp1V1hITFVQeXVYOXVvUnRObzVHNS8zRW1YaUUvWmx6bmtXTDVOb2FI?=
 =?utf-8?Q?0wZqfIpMI+gsMaKODnLwgf2P1Wj2b8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?am9GY01lMlVwNHpiOFF0b2pmVUlhZFZpZUI1azdEQkxyUFBxaWxXRFFXV0tl?=
 =?utf-8?B?R2NKa1NGc2JuL2lFelpYMWRYVFNBMGR6Y3lJS05DNG9sTWFoTlkrMzRVQm9Q?=
 =?utf-8?B?ZnJUVTA2S2R4NnJSNnYrcGlucldDQmpKdjFVeGUyalRMMkladVB4TmVHS2RX?=
 =?utf-8?B?cnNnVXJnQ3dsYzlFU0JzSzNyMzJ0b05SZmxsNk1PVEhDNVIyZ3U5bUFiNWs4?=
 =?utf-8?B?UjU1UElKd0gvZEVkVENabXBOS3VCMk5kcDZ4QzdxU0Q3QWszazhaeGdJdFFK?=
 =?utf-8?B?c3RIZURZM0xxV0V2ZkR3dGMxWndLQ3czNzlwQTNHVFRvY3BCOEJSTzdpMkhm?=
 =?utf-8?B?VVM4L1h1NGtnYjZBOHB0enhxcHd6RGk3ajYweWtWclVaRTY5ZDZ6SC9DL2Vi?=
 =?utf-8?B?Wm51bEFTYmhCbmJMWDcwOWZ2SkptSm5VVmdETG8rcHhjQXV5VGJ6OXltTFhH?=
 =?utf-8?B?YUFHT3oreUJRRzVoMm9hREVFUjJ0c250WXpPZnV1Sy9sRURXaVlGOGlXZkww?=
 =?utf-8?B?TzRDQjJ0RnE3U3QxbXRXQ05ndDBEMGFMVVFSRzR5MEE5UDdyeU0xKzA1Wkhi?=
 =?utf-8?B?QkQva1Y1VHV4UWpZdFJERSt2Q1REK3pBR0Y2WmhOSE5CSDNFUG9GYkZBRTla?=
 =?utf-8?B?S0ZDN0Vid1JqMjZDK1ZwSlM4QklTZWhZVERudCszK2VWaU1oWmVFOUJsU01K?=
 =?utf-8?B?ZlN1VGlNcDcwcHVHeStGK2JGcGtCUnZvc0x5L0tHZXR3WHFiR1ZrblBXT0pm?=
 =?utf-8?B?S2JvSWNvZ1d2VjZ3UmNJWWhURWN5TTVSUktUdmozR2ZsMUpJdEtqdWJGM0I4?=
 =?utf-8?B?cmcwM2dvVmVscU9SQWlGczdkOWI3anM0bjlZd1dWZnIyOHFQUjhaOEpOa0t4?=
 =?utf-8?B?Y1NQWDlNZy8rb1QrRzdudkZHYjZDV2hyZDhGZzNrM3VpNS9kaEpaTVkwUjFK?=
 =?utf-8?B?eWN3eGhWWWgvL2VaMDVEM1o0VFZSZWsxSU1KSjIxaTlMM3F5SmZjVmpwOTJW?=
 =?utf-8?B?cXltWEJ1K1lTRlc2eWZpYytyUDJtMWE0VVp2Z2FRQjVwaCs2aEhoS2g4YjJO?=
 =?utf-8?B?cmxWNWhscUd4MWhmdG4zb1VaeXhJZTkvL0duYlNIOGpmVzZCQXVmTFMzZ3lx?=
 =?utf-8?B?WGwyZDZPYlpTSjloNVh3WTBwRlRRZVdFOU9YbnhOTTQwbUpFMGVlSU9jU0hZ?=
 =?utf-8?B?ZEF5RUgrcXU3NzhXdmlBMWJ3azB0YnJVajJYOFVSMURVRmVnZkdqUEM1M1Jm?=
 =?utf-8?B?REtqa2E5eHRJMVQ2KzdESEpJS3YzNG94WDBkVGx6OHhuRVJJdkRaeXNESkxa?=
 =?utf-8?B?cUg3bDRoTjRiZHpVVlFHY2J3ZU9HampzMnZueklBMGF0SWNVS2JPanBUcEM2?=
 =?utf-8?B?cG9EdGs0dlY1Rm5VdUdYa1FrUDZzem0wdk95QS9PelIwaHZXUVpSZmFoWklx?=
 =?utf-8?B?Q213KytpYmpnbjRCRGwyeUl4SUlpaU5icFgxbG9hTkdFcSt0cWxwSVpLcjRP?=
 =?utf-8?B?Qlc2Q1NKZmRUMmhhNmI2S2dHSTB2MTZvMXlacW5pNSswNTFFTHZnZHJnK2pL?=
 =?utf-8?B?RjgyRlFZOVdheXplV0pmN28zVUs4ZVIrV0V0cUkxckJBRUF6UGhBWWdvd3BB?=
 =?utf-8?B?M0ExS01iMElXNlJ0Y3VnYXpxU3JJUXJmRDNFaGVDc25wVW4rU3Jwb0ZRcW52?=
 =?utf-8?B?MWFnOENqbHJkR0taR3dCTGhGMEdsU0lxSldiRDYxb2JRQ25FRWpxRmthYWxv?=
 =?utf-8?B?ZEs1TlJ3ZkNZZlp4bDlUTG1nS1JsZWZFOFhMbGswalF3ck51YkNvcXFSdjRM?=
 =?utf-8?B?VVJ1d0tURGlSYWhSUVY1eU5kdFgrcFhlQmxKc2ZDbCtMNytscU1xcHIzRS9G?=
 =?utf-8?B?YTNOZjBYam5lcExoYWtOMVMweWtZaXpubElkQ3FkTVBlQlFjN0JhSjdBSHZs?=
 =?utf-8?B?NXllT1RnSkJ6MkZ0SXZlUDEzaHJ0b2EwenVsWEpmTjB3ell2YVYzdFNVV2Rs?=
 =?utf-8?B?RmNzYmZUTmhVcjNrdTZiV1liRENWTVI0cmlSajV2UzI4SElaZTdMSzVHRGJG?=
 =?utf-8?B?ZGdJblpha0JXd2orN3Erak9QSnF4YVhoMTlLaDhQMVJ1UHBUaGt4WDBuT3o0?=
 =?utf-8?Q?lpqvv0djZC67my/zfimYq75pV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5B99ED71FF02B44B0D3F2D19862AB54@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b61c676-1edf-46ca-a18a-08dda47f5c05
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 22:21:46.7748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iumzwaiEkagtqU/FLo4owD/izzq235c3Uc0WiJyluOv6sHCsqrPlWEaHjQzBeY16xG/+jD9jzwycgHhrHrGwKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF957B3B2A8
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTA1IGF0IDE2OjAxICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBGcmksIE1heSAyMywgMjAyNSBhdCAwMzowMDo1NlBNICsw
MzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tIHdyb3RlOg0KPiA+IE9uIFdlZCwg
TWF5IDE0LCAyMDI1IGF0IDEyOjAwOjE3QU0gKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
PiBPbiBNb24sIDIwMjUtMDUtMTIgYXQgMTI6NTUgKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3
cm90ZToNCj4gPiA+ID4gT24gRnJpLCBNYXkgMDksIDIwMjUgYXQgMDk6MjU6NThBTSArMDgwMCwg
WWFuIFpoYW8gd3JvdGU6DQo+ID4gPiA+ID4gT24gVGh1LCBNYXkgMDgsIDIwMjUgYXQgMDQ6MjM6
NTZQTSArMDMwMCwgS2lyaWxsIEEuIFNodXRlbW92IHdyb3RlOg0KPiA+ID4gPiA+ID4gT24gVHVl
LCBNYXkgMDYsIDIwMjUgYXQgMDc6NTU6MTdQTSArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+ID4g
PiA+ID4gPiA+IE9uIEZyaSwgTWF5IDAyLCAyMDI1IGF0IDA0OjA4OjI0UE0gKzAzMDAsIEtpcmls
bCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiBUaGUgZnVuY3Rpb25zIGt2bV94
ODZfb3BzOjpsaW5rX2V4dGVybmFsX3NwdCgpIGFuZA0KPiA+ID4gPiA+ID4gPiA+IGt2bV94ODZf
b3BzOjpzZXRfZXh0ZXJuYWxfc3B0ZSgpIGFyZSB1c2VkIHRvIGFzc2lnbiBuZXcgbWVtb3J5IHRv
IGEgVk0uDQo+ID4gPiA+ID4gPiA+ID4gV2hlbiB1c2luZyBURFggd2l0aCBEeW5hbWljIFBBTVQg
ZW5hYmxlZCwgdGhlIGFzc2lnbmVkIG1lbW9yeSBtdXN0IGJlDQo+ID4gPiA+ID4gPiA+ID4gY292
ZXJlZCBieSBQQU1ULg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IFRoZSBuZXcg
ZnVuY3Rpb24ga3ZtX3g4Nl9vcHM6OnBoeXNfcHJlcGFyZSgpIGlzIGNhbGxlZCBiZWZvcmUNCj4g
PiA+ID4gPiA+ID4gPiBsaW5rX2V4dGVybmFsX3NwdCgpIGFuZCBzZXRfZXh0ZXJuYWxfc3B0ZSgp
IHRvIGVuc3VyZSB0aGF0IHRoZSBtZW1vcnkgaXMNCj4gPiA+ID4gPiA+ID4gPiByZWFkeSB0byBi
ZSBhc3NpZ25lZCB0byB0aGUgdmlydHVhbCBtYWNoaW5lLiBJbiB0aGUgY2FzZSBvZiBURFgsIGl0
DQo+ID4gPiA+ID4gPiA+ID4gbWFrZXMgc3VyZSB0aGF0IHRoZSBtZW1vcnkgaXMgY292ZXJlZCBi
eSBQQU1ULg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IGt2bV94ODZfb3BzOjpw
aHlzX3ByZXBhcmUoKSBpcyBjYWxsZWQgaW4gYSBjb250ZXh0IHdoZXJlIHN0cnVjdCBrdm1fdmNw
dQ0KPiA+ID4gPiA+ID4gPiA+IGlzIGF2YWlsYWJsZSwgYWxsb3dpbmcgdGhlIGltcGxlbWVudGF0
aW9uIHRvIGFsbG9jYXRlIG1lbW9yeSBmcm9tIGENCj4gPiA+ID4gPiA+ID4gPiBwZXItVkNQVSBw
b29sLg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBXaHkgbm90IGludm9rZSBwaHlz
X3ByZXBhcmUoKSBhbmQgcGh5c19jbGVhbnVwKCkgaW4gc2V0X2V4dGVybmFsX3NwdGVfcHJlc2Vu
dCgpPw0KPiA+ID4gPiA+ID4gPiBPciBpbiB0ZHhfc2VwdF9zZXRfcHJpdmF0ZV9zcHRlKCkvdGR4
X3NlcHRfbGlua19wcml2YXRlX3NwdCgpPw0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBCZWNh
dXNlIHRoZSBtZW1vcnkgcG9vbCB3ZSBhbGxvY2F0ZWQgZnJvbSBpcyBwZXItdmNwdSBhbmQgd2Ug
bG9zdCBhY2Nlc3MNCj4gPiA+ID4gPiA+IHRvIHZjcHUgYnkgdGhlbi4gQW5kIG5vdCBhbGwgY2Fs
bGVycyBwcm92aWRlIHZjcHUuDQo+ID4gPiA+ID4gTWF5YmUgd2UgY2FuIGdldCB2Y3B1IHZpYSBr
dm1fZ2V0X3J1bm5pbmdfdmNwdSgpLCBhcyBpbiBbMV0uDQo+ID4gPiA+ID4gVGhlbiBmb3IgY2Fs
bGVycyBub3QgcHJvdmlkaW5nIHZjcHUgKHdoZXJlIHZjcHUgaXMgTlVMTCksIHdlIGNhbiB1c2Ug
cGVyLUtWTQ0KPiA+ID4gPiA+IGNhY2hlPyANCj4gPiA+ID4gDQo+ID4gPiA+IEhtLiBJIHdhcyBu
b3QgYXdhcmUgb2Yga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKS4gV2lsbCBwbGF5IHdpdGggaXQsIHRo
YW5rcy4NCj4gPiA+IA0KPiA+ID4gSSBhbSBub3Qgc3VyZSB3aHkgcGVyLXZjcHUgY2FjaGUgbWF0
dGVycy4NCj4gPiA+IA0KPiA+ID4gRm9yIG5vbi1sZWFmIFNFUFQgcGFnZXMsIEFGQUlDVCB0aGUg
InZjcHUtPmFyY2gubW11X2V4dGVybmFsX3NwdF9jYWNoZSIgaXMganVzdA0KPiA+ID4gYW4gZW1w
dHkgY2FjaGUsIGFuZCBldmVudHVhbGx5IF9fZ2V0X2ZyZWVfcGFnZSgpIGlzIHVzZWQgdG8gYWxs
b2NhdGUgaW46DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+
ID4gICBzcC0+ZXh0ZXJuYWxfc3B0ID3CoA0KPiA+ID4gCWt2bV9tbXVfbWVtb3J5X2NhY2hlX2Fs
bG9jKCZ2Y3B1LT5hcmNoLm1tdV9leHRlcm5hbF9zcHRfY2FjaGUpOw0KPiA+ID4gDQo+ID4gPiBT
byB3aHkgbm90IHdlIGFjdHVhbGx5IGNyZWF0ZSBhIGttZW1fY2FjaGUgZm9yIGl0IHdpdGggYW4g
YWN0dWFsICdjdG9yJywgYW5kIHdlDQo+ID4gPiBjYW4gY2FsbCB0ZHhfYWxsb2NfcGFnZSgpIGlu
IHRoYXQuICBUaGlzIG1ha2VzIHN1cmUgd2hlbiB0aGUgImV4dGVybmFsX3NwdCIgaXMNCj4gPiA+
IGFsbG9jYXRlZCwgdGhlIHVuZGVybmVhdGggUEFNVCBlbnRyeSBpcyB0aGVyZS4NCj4gPiANCj4g
PiBJIGxvb2tlZCBjbG9zZXIgdG8gdGhpcyBhbmQgd2hpbGUgaXQgaXMgZ29vZCBpZGVhLCBidXQg
Y3RvciBpbiBrbWVtX2NhY2hlDQo+ID4gY2Fubm90IGZhaWwgd2hpY2ggbWFrZXMgdGhpcyBhcHBy
b2FjaCBub3QgdmlhYmxlLg0KPiA+IA0KPiA+IEkgZ3Vlc3Mgd2UgY2FuIGEgY29uc3RydWN0b3Ig
ZGlyZWN0bHkgaW50byBzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUuDQo+ID4gTGV0IG1lIHBs
YXkgd2l0aCB0aGlzLg0KPiANCj4gSSBmYWlsZWQgdG8gbWFrZSBpdCB3b3JrLg0KPiANCj4gV2Ug
bmVlZCB0byBoYXZlIGRlc3RydWN0b3IgcGFpcmVkIHdpdGggdGhlIGNvbnN0cnVjdG9yIHRoYXQg
d291bGQgZG8NCj4gUEFNVC1hd2FyZSBmcmVlaW5nLiBBbmQgcmVkaXJlY3QgYWxsIGZyZWUgcGF0
aHMgdG8gaXQuIEl0IHJlcXVpcmVzDQo+IHN1YnN0YW50aWFsIHJld29yay4gSSBkb24ndCB0aGlu
ayBpdCB3b3J0aCB0aGUgZWZmb3J0Lg0KPiANCj4gV2lsbCBkbyBtYW51YWwgUEFNVCBtYW5hZ2Vt
ZW50IGZvciBTUFQgaW4gVERYIGNvZGUuDQoNClRoYW5rcyBmb3IgdGhlIGVmZm9ydC4NCg0KTWF5
YmUgc29tZXRoaW5nIGJlbG93Pw0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXVf
aW50ZXJuYWwuaA0KYi9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oDQppbmRleCBkYjhm
MzNlNGRlNjIuLjQ4NzMyMjcwYmZmMCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11
X2ludGVybmFsLmgNCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11X2ludGVybmFsLmgNCkBAIC0x
NjQsOCArMTY0LDEwIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpc19taXJyb3Jfc3AoY29uc3Qgc3Ry
dWN0DQprdm1fbW11X3BhZ2UgKnNwKQ0KICAgICAgICByZXR1cm4gc3AtPnJvbGUuaXNfbWlycm9y
Ow0KIH0NCiANCi1zdGF0aWMgaW5saW5lIHZvaWQga3ZtX21tdV9hbGxvY19leHRlcm5hbF9zcHQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QNCmt2bV9tbXVfcGFnZSAqc3ApDQorc3RhdGlj
IGlubGluZSBpbnQga3ZtX21tdV9hbGxvY19leHRlcm5hbF9zcHQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBzdHJ1Y3QNCmt2bV9tbXVfcGFnZSAqc3ApDQogew0KKyAgICAgICBpbnQgcjsNCisNCiAg
ICAgICAgLyoNCiAgICAgICAgICogZXh0ZXJuYWxfc3B0IGlzIGFsbG9jYXRlZCBmb3IgVERYIG1v
ZHVsZSB0byBob2xkIHByaXZhdGUgRVBUDQptYXBwaW5ncywNCiAgICAgICAgICogVERYIG1vZHVs
ZSB3aWxsIGluaXRpYWxpemUgdGhlIHBhZ2UgYnkgaXRzZWxmLg0KQEAgLTE3Myw2ICsxNzUsMTIg
QEAgc3RhdGljIGlubGluZSB2b2lkIGt2bV9tbXVfYWxsb2NfZXh0ZXJuYWxfc3B0KHN0cnVjdA0K
a3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fDQogICAgICAgICAqIEtWTSBvbmx5IGludGVyYWN0
cyB3aXRoIHNwLT5zcHQgZm9yIHByaXZhdGUgRVBUIG9wZXJhdGlvbnMuDQogICAgICAgICAqLw0K
ICAgICAgICBzcC0+ZXh0ZXJuYWxfc3B0ID0ga3ZtX21tdV9tZW1vcnlfY2FjaGVfYWxsb2MoJnZj
cHUtDQo+YXJjaC5tbXVfZXh0ZXJuYWxfc3B0X2NhY2hlKTsNCisNCisgICAgICAgciA9IHRkeF9w
YW10X2dldCh2aXJ0X3RvX3BhZ2Uoc3AtPmV4dGVybmFsX3NwdCkpOw0KKyAgICAgICBpZiAocikN
CisgICAgICAgICAgICAgICBmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpc3AtPmV4dGVybmFsX3Nw
dCk7DQorDQorICAgICAgIHJldHVybiByOw0KIH0NCiANCiBzdGF0aWMgaW5saW5lIGdmbl90IGt2
bV9nZm5fcm9vdF9iaXRzKGNvbnN0IHN0cnVjdCBrdm0gKmt2bSwgY29uc3Qgc3RydWN0DQprdm1f
bW11X3BhZ2UgKnJvb3QpDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMg
Yi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KaW5kZXggN2YzZDcyMjliMmMxLi4yZDNhNzE2
ZDkxOTUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KKysrIGIvYXJj
aC94ODYva3ZtL21tdS90ZHBfbW11LmMNCkBAIC01NSw3ICs1NSwxMCBAQCB2b2lkIGt2bV9tbXVf
dW5pbml0X3RkcF9tbXUoc3RydWN0IGt2bSAqa3ZtKQ0KIA0KIHN0YXRpYyB2b2lkIHRkcF9tbXVf
ZnJlZV9zcChzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCkNCiB7DQotICAgICAgIGZyZWVfcGFnZSgo
dW5zaWduZWQgbG9uZylzcC0+ZXh0ZXJuYWxfc3B0KTsNCisgICAgICAgaWYgKHNwLT5leHRlcm5h
bF9zcHQpIHsNCisgICAgICAgICAgICAgICBmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpc3AtPmV4
dGVybmFsX3NwdCk7DQorICAgICAgICAgICAgICAgdGR4X3BhbXRfcHV0KHZpcnRfdG9fcGFnZShz
cC0+ZXh0ZXJuYWxfc3B0KSk7DQorICAgICAgIH0NCiAgICAgICAgZnJlZV9wYWdlKCh1bnNpZ25l
ZCBsb25nKXNwLT5zcHQpOw0KICAgICAgICBrbWVtX2NhY2hlX2ZyZWUobW11X3BhZ2VfaGVhZGVy
X2NhY2hlLCBzcCk7DQogfQ0KQEAgLTEyNzcsOCArMTI4MCwxMyBAQCBpbnQga3ZtX3RkcF9tbXVf
bWFwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0DQprdm1fcGFnZV9mYXVsdCAqZmF1bHQp
DQogICAgICAgICAgICAgICAgICovDQogICAgICAgICAgICAgICAgc3AgPSB0ZHBfbW11X2FsbG9j
X3NwKHZjcHUpOw0KICAgICAgICAgICAgICAgIHRkcF9tbXVfaW5pdF9jaGlsZF9zcChzcCwgJml0
ZXIpOw0KLSAgICAgICAgICAgICAgIGlmIChpc19taXJyb3Jfc3Aoc3ApKQ0KLSAgICAgICAgICAg
ICAgICAgICAgICAga3ZtX21tdV9hbGxvY19leHRlcm5hbF9zcHQodmNwdSwgc3ApOw0KKyAgICAg
ICAgICAgICAgIGlmIChpc19taXJyb3Jfc3Aoc3ApKSB7DQorICAgICAgICAgICAgICAgICAgICAg
ICByID0ga3ZtX21tdV9hbGxvY19leHRlcm5hbF9zcHQodmNwdSwgc3ApOw0KKyAgICAgICAgICAg
ICAgICAgICAgICAgaWYgKHIpIHsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGRw
X21tdV9mcmVlX3NwKHNwKTsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBy
ZXRyeTsNCisgICAgICAgICAgICAgICAgICAgICAgIH0NCisgICAgICAgICAgICAgICB9DQogDQog
ICAgICAgICAgICAgICAgc3AtPm54X2h1Z2VfcGFnZV9kaXNhbGxvd2VkID0gZmF1bHQtPmh1Z2Vf
cGFnZV9kaXNhbGxvd2VkOw0KDQo=

