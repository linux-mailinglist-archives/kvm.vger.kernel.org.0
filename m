Return-Path: <kvm+bounces-29746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2709B13F9
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 03:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 617301F22FA7
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 01:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4594E42ABE;
	Sat, 26 Oct 2024 01:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmEJWlm6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C13BBDE;
	Sat, 26 Oct 2024 01:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729905180; cv=fail; b=SFzyUKMup4BfeBoeCPeYE7tdWvn2FwABA2ZrcrBwRvsf2Uz6+8nQb6qyaR17QdlMc99CQIN6QgxlvilzdSaPdlxnGrJNFDMSGmwiP5jLEsaXlfjfRwNl9jj6+eXjLK1e3IZxa4+ILanqHKLjW9/dlsjnbu/kjbVZpmRBhDmWZ28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729905180; c=relaxed/simple;
	bh=aKV4Yrq1UHS+DYkpNeNt+dUfifTK9Yh7XOXT4rEr4Ks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r5LCDNfWJT1McsYKcPbCdEwPvHJp01tESeedggEKU4wKc+Iao90SPNHfL7Kb/+ZuThP7X9+Oukhxzv2DasS+rDw4SVVftEeaVhTU9WPRRu1qKqmnC2DiXZy6WRv9sQQUEysCxyijLRll61kpLPCaulnp1ncLnQDI4I0pPwqolv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmEJWlm6; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729905178; x=1761441178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aKV4Yrq1UHS+DYkpNeNt+dUfifTK9Yh7XOXT4rEr4Ks=;
  b=jmEJWlm67I/ljOHubBGCd/b1JfaBg6QIJbeLkVFtAla67v2s6Wnjhead
   T3lfiQw9ebSxEqlq43vMCTY+41+fK3VjjMhPraSpYu+D0w+kytq0CJPI1
   7/ZzGAA2VP8lxvAK5QaNfsua8yA6K4dBKi7O7Efq7TZ0n0aTBQbhsVyZB
   BrDRMDoJJ91X207rVLiA4LpFPn60ubd5jqkh9VhgiNfe9DBFPOy4TZifX
   TTthk1u4n+leIRvImEnShZsDRFQYZdOrEflyvCSAyRF7goKhrTdO/9S7v
   Fmy8O5P+uqjcN7qzyW3LYwYdrnDVm1YOE/DtBLDxkpydaDvdIa1xERdGH
   Q==;
X-CSE-ConnectionGUID: w+HYbdPmQrykawzejCY+Bw==
X-CSE-MsgGUID: uCSJzaIZQziwvP34cZr8qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11236"; a="33498221"
X-IronPort-AV: E=Sophos;i="6.11,233,1725346800"; 
   d="scan'208";a="33498221"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 18:12:57 -0700
X-CSE-ConnectionGUID: 2wtZIoo6SUG4he5400u8Og==
X-CSE-MsgGUID: rpKwqQ89Tw28hj1ZFV4XTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,233,1725346800"; 
   d="scan'208";a="81222563"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2024 18:12:57 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 18:12:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 18:12:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 25 Oct 2024 18:12:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nYpWVtXWEON80DbcY/rHV2BekfpDmZN+QHzDUxFuCy+dszqu339c4oLFcM9Mm+1hsZ0V5sZF+UJlqbjCdtHEKw5rJuOSHgc84avHb70bpVIR8/EBXgVG2Lhyc5AbDHhRkjBAgL2GD08tVWOw9Tj8GPm3JTcumAfuX1vr28NZ0rF1AfhyvjSX4nfmndDQ6Y4AAYzQ+8qGjqLDlZXU81YBd9HTctRRf+uwihuhQ+NxxkLkWIaqqn7rFAfkGk0kvtDHCN+fjXUVLRT3J1Qs2InJ8Sryw38g2HZ6r9GQMnGZxDijGY2KBTQM2HQd5AG6jxrGxsXpsTQ6yxWq2ywTLMP9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKV4Yrq1UHS+DYkpNeNt+dUfifTK9Yh7XOXT4rEr4Ks=;
 b=RY++rn1N2WYJw/snGSfPwQqe813g7NbZjNHAS4i4j7Q26YcxxftMQpOgr4a1+VMwdA2vojT73ER+kzmwm+2CgSe30RgJYeRmVauttiffDY6djT8UzWs4aHFGvYElqkWk6Bcu1sa2v97Hna7iPfBW4YSe8L2NZH4Mn2R6q5X+CtLeN37SH4A3aiOFVSYBxsfnu74ExjV37CYdg52y77lebAtJROevqmBf1P8NDpyab3ULXM/jVsoAAU1e+ihLKJunw0UAbNomwL1G+Qq7z6K8htgnlFrWUieU8jl1EM0o0sep3xqwXmGLLBkOEJzZgrvnZIfmek53YA0hK3ZyJ7gEyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7842.namprd11.prod.outlook.com (2603:10b6:610:128::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Sat, 26 Oct
 2024 01:12:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8093.021; Sat, 26 Oct 2024
 01:12:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Topic: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Index: AQHa7QnTM8YJSmcK70mWBvdOl91Ku7Ik046AgFoKj4CACy09gIACI3sAgADI7wCABFZ/gIAHYASA
Date: Sat, 26 Oct 2024 01:12:52 +0000
Message-ID: <d71540ab13e728d1326baae92e8ea82d00c08abe.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
	 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
	 <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
	 <1be47d7f9d4b812c110572d8b413ecdbb537ceb7.camel@intel.com>
	 <aa3d2db8-e72c-42e2-b08f-6a4c9ad78748@intel.com>
	 <0136dbcb2712828859447bc7696974e643a76208.camel@intel.com>
	 <1cb07b5d-1e42-44a4-bc0f-adc03433eb90@intel.com>
In-Reply-To: <1cb07b5d-1e42-44a4-bc0f-adc03433eb90@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7842:EE_
x-ms-office365-filtering-correlation-id: 7ad14543-1084-43e3-7697-08dcf55b50ab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bzFPQVU4SG1jQVdqL1RxdXBYY0ZJbTdEdldMVHFBazluNU9PRHY1akR5RjVx?=
 =?utf-8?B?UElPVHZINmFKaUlGNVJnWkJpTkRESTlUTzJyQTFrai9wS3lmM1pCTCs0a0tY?=
 =?utf-8?B?R00yMUh0M1hCQlN4UUZmeHVXQjF1TGhCM0I0Y3NYTjdPUDhjTk4rRWdrN0Vh?=
 =?utf-8?B?aW5yQ0kvcGpJTnBjRjVBNjBBNkR6cVZHeXcwb0RGcElQajZ4YTZUYldabm1Y?=
 =?utf-8?B?MVB2RXd1UEZSUDBGMGswc2Vpbk9WcDNNdVhUTVBWdE95VzNVNE5jaDlJSldR?=
 =?utf-8?B?UmFlcGUwWjVkUGtLQmd5QVNYTzJPVzhZMmtJZUZwNXZINjg1b0dMTCt0clBq?=
 =?utf-8?B?UVZscHRyWFIyMmt4T3lXMnJDTkpDZ1Y1YzNNSjVlZDFyUnRjM0I1Q3pKR1Qv?=
 =?utf-8?B?K2k5NzJYWVZDRUQ4cW9QdGlqNWt1MUdVVDFiUHo0NGZyVFA3aXJhZUdaankv?=
 =?utf-8?B?Q1hBYXdQcjZMcnVFWkpYcVRRMkRLVzVabEZKQVR2L1IyeXpvRGsvUkMvK2t6?=
 =?utf-8?B?d0NLQlh3ZlNaZTRKaW1Jem9sQi9aTWlTcFdMbDhpYm9RR05XQThReWZDblp1?=
 =?utf-8?B?RVlML1cwRncrTkZ2dU9xOGUvZElOdTFuM2pWL0EwVStqb2tWZGlYYzhDRjRo?=
 =?utf-8?B?b2NhR1RwcVltSnl5MGJobmphYWMwV09TN0tkTTZWcEg3aUdHYm5Qc2Ntbm1E?=
 =?utf-8?B?dlkva25sVlhlVUt2dzJLZ0FHUmlQcktzTDIzZkpRYXVhTlN4d00zMzhPZEgv?=
 =?utf-8?B?bzlJSG5JOHQxZVlqVkZJTHd3ejExV0VWUnRTVXA3VC9rS3NhSWxLUGFvZzVa?=
 =?utf-8?B?VVB1RDJyY25HUkZJTkg2SVRwZ0tvRytPclJFNHM1M2M1ZG1uTzdoS29Vc3J6?=
 =?utf-8?B?dmJnTzdaeDN1WVJ6bHdvTWt5WEVsRjJrNnhwaml3MnYva1krSHB4VnhIMXVM?=
 =?utf-8?B?SE5CdVk3R2k3a0pDajdwRXEvbFliNHBzWGxvRk1OYmd1NGhVT01zL3dyd1N5?=
 =?utf-8?B?eUlwWm9GSmRWa3p2RzZueXQ5dnE2NXVjbCtJR0ViMng5SElZR0IrSlUzdWJk?=
 =?utf-8?B?QUJBTndSb2JUSHhpelY2Y2xkUVg2Q3cxUFB2ZGMrSHFrUnI3RTZRK1FVR0ZK?=
 =?utf-8?B?cmc2N2hHamI3cUwvTVlVNFVQVk0vS3daaE90WERWQzdGQzdTZHlFOVc2RUda?=
 =?utf-8?B?bVhGemprdHZZS0czdTZjSTVNRVpqUzhKZzlIVml1SVJDM1dScDZwb0NGZEZV?=
 =?utf-8?B?cy8vakJjUlUxcXhCaGs5T2Zrd2FGNC82OVBxNkN5bHhVcXR4TlA2MVRJTWQ4?=
 =?utf-8?B?T1hTRVkxTXFGMUFyL0FxaTlETlptZSsvb2dDVW5MR0VnWWc0OVVtTkxYVTRn?=
 =?utf-8?B?MDFmaFpnYlNNc1JZaWY0UmErS2Ura0hrd2pPRUtpbE5oa1J5NHBDd3NUTWh1?=
 =?utf-8?B?d0pOZjkySi8yejUrT1V6NjNqS1pJRzdpakdTb0RvVTRsSTNLd3JsNUM3eCtZ?=
 =?utf-8?B?c0x2VGdkZDhONFZHbzZUVkRPNXNlaVcwWElLNjVEbTBTa1U4UmU0aFBzbWRB?=
 =?utf-8?B?MEMrbmhHMDdNSEt0SHU0TFZ0WVp6dzhVT0szb3Q1UjBaY3Zhb0kyMGxTZHhB?=
 =?utf-8?B?a1duVnY2aDJMb2s1dDRhWVdVZlpOMURCVFhQaUZhZWsyWUlYdlQ4dlpSQWZZ?=
 =?utf-8?B?dUo5K3BPbW4ydXp0RGxaSVp1bkJZYlM2aVRWaEVnUWpWT1luYkMrT0tKRTJz?=
 =?utf-8?B?Z3dNc3BDMlNiejNkSUorMFdFK2RrZUpRL04rM3cwMVo0dWx1VlE3NU1Pd2tt?=
 =?utf-8?Q?uE6xCRSlMXdBscEGkiqE7JQgGvUvpGZIM8bvA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elpnYXhRRVhwRm1ib0o0d1M1VkhLbU1XVGIrckpPRVhZb1phYUNuKzhjNFNi?=
 =?utf-8?B?WGt5VnZEbHB6OERCMTM2T0lmWDJjUC9uZGdGQXpXSnpSWFV4T1lWb0tLYUtr?=
 =?utf-8?B?V1JIcUVLVUUyWmpOOXNRTHZkam8zWWtXL1R4WnEyMTlyUGRlamNYL3M3bEZI?=
 =?utf-8?B?Z2JTeURPMjBLZDhFOEswSlVXeTFOOWpNYjltbjJ4dGp2N1NlNEJRNE1yY1Vm?=
 =?utf-8?B?akhvZmVYcm1EQzl1dUhmVXpCUmlYVkorM3pIUmZZZ2wyazByQnJBSnFKdHRC?=
 =?utf-8?B?bXJPS3dmVEIvRFg2b0FUMHdEQ2JnS05RRHZma1VTdUl5MFFHWlJGbDh4dEQy?=
 =?utf-8?B?L3I1UTU2bnllbzEycE1RTllaYWxjeCswaFdLZFljQUVtaTNWY1F5ZEtmbEN1?=
 =?utf-8?B?ME9WSlljOWZuckI2Rk1GSks2Vk5mdExUSXZOQk1LZHppWStMeHRCVFEvZk9V?=
 =?utf-8?B?QjVwNklYSVA4amh3azYzSXV1TlBwQ2xkSUttSkMrS210ZG9CNktSalkzcURJ?=
 =?utf-8?B?dHhhZE9ybmJUMURBMjlDZjJZNUlhRDRCbkdBdzVmRWpQSlIrVUgxTFI3cnNW?=
 =?utf-8?B?WHdrMFlKeGV0SVZVU1VrbFgvVkc4aWtxeVRmV0NWaWljNjhxQ2NHN1RZRnRu?=
 =?utf-8?B?WERCSnVrME00SlBKRndUcWNXZXdmcmpDUHpyT0FKSkVWYjJId2ttTWpFNkJE?=
 =?utf-8?B?YW95ajRJRXA2TldLekN3WUxsR2hpQUM0UVZlbE1CL3lycFFLSGlZUEZDN0JB?=
 =?utf-8?B?ZEt0OERCR0FoMzRkVFBHZzBZYjAzZ0RCWFJzR3M5NUphWkRxR21XU1RIYlJw?=
 =?utf-8?B?RVZyTEh6aXpZMmNsN3BIUkU3MmwxZDRmRDZYdVljTTltQTRmVzVUZmM2NXVG?=
 =?utf-8?B?M1g5T2Vya05MNWNZOThYaFR3eEZxclZPd1NvM3JNL085SjNEY210d3N1NHQ5?=
 =?utf-8?B?QUxVOXRJTGtPN1F5R2xSK2R1S3UrV1dVVUdlNXBlcU82UWtRQm5oaXhObG5Q?=
 =?utf-8?B?V1BLcCtlbUlrZU94T1RTTmdsSjdUUzZBWVVCUU9zNlhiT3ZENFJKRmNqWXdN?=
 =?utf-8?B?eFBIWURlZlNMUHBpczZucGlNMXMzS1NtQzE5TGRZaStvRzRPNlRNNWlNSHUr?=
 =?utf-8?B?TGtjU2tCNTM4MHlZTGRIQ1UzMTA4R0ZZNmNXVlNDQ0V1T1lyVkJwbWdjRzNp?=
 =?utf-8?B?TGErZ1lZT1JGeG43c3NUMzU3R1dQUUt1RTVIZmNRT3JvMDU2OFk4bGtXRTN0?=
 =?utf-8?B?L0NnL0N3NW9PbVNVNDZVbHpLS1IwWUl3aDFvbi9ZV0hUZHRLak1KOUV4cjJs?=
 =?utf-8?B?WXczMFBPcE1rRWQ5Z29mYm01Smo2UVUyUlFOMnpVcVljOVZoczNIMTJCSHRH?=
 =?utf-8?B?akRKTlkwQ1ZsQm0vWGcybm5wbFQ2VlViOS9hbTlVdTNQcERJNUppUmM0QmRR?=
 =?utf-8?B?SWVsdGxSRlFqeXpCMldHVFNnTWhEbDNwL1hOVG5YMW00dWo2WWxaSDljeHQ1?=
 =?utf-8?B?cHpoR0RGekxMeXFtTVMwbHhkNkFoVUtOSE5HV0FubEpPRGx2NTN3djlmQUJa?=
 =?utf-8?B?Y2hyMk9yZUQwanNHWDdEOVBpTWZYd3Q0S0R6YTYwKzdhOHNpcEpHUE5TMWdn?=
 =?utf-8?B?OWRXLzNzNyt2NVhteHBQZkpRdXE0eVRYUGNXOGZneStGb1ZRTko0MW1oLzdh?=
 =?utf-8?B?dTAwU3N0elpJUlBLU0hTZE43U1dYY1lsaUR3NjNQak5iWmc3QkdSSGhQSGFp?=
 =?utf-8?B?bWNJL3B4aitENkpiKzBnV0JScjh2ZFRzNTlKMXBNUm44ZjhMRlVpdDJtTnQr?=
 =?utf-8?B?aFVVRVY5S3VSVjF6ODJkNjlxWkhZSS9JR0Z3Y1JsZjQvWEpxb0JwaHljY3lZ?=
 =?utf-8?B?elMwbFROYWU4ZUpRUUFTN3RIaEdMZEtLcStrSCt2ZnBTbUNFYllBUXAwVGxN?=
 =?utf-8?B?b1JneExvajJkOUprc3FXd0hxM29Kc0tzMThjZ2xkVEZscXMyWlMwTkNjRTZL?=
 =?utf-8?B?YWZhZFFMcVQxamwzMU5lOTlEc3J0NXppQUFPcGNWR2oyUkRYQkVqZ2preDNR?=
 =?utf-8?B?dFAzaVQyMFdpT1BObnlKK1ZJMGJ5b2xhY2RWY0FtNmlEY2N3azBEVXJmeWdp?=
 =?utf-8?B?djYyYm1jeUI4LzVhT0NtZ0VkVVV3eHBVY1Rxdmpib3ZHUXRJS1Nid0hWT0R0?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36D5BAE2EBDDF243AE30122AF97FADAE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad14543-1084-43e3-7697-08dcf55b50ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2024 01:12:52.3501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tLDR5vYApfcGPo8GObT5fA27gR1yCBHK1LojLwixG8PhnA9RDlwozUPpj5GT8r3hz4cwAQPbjWRyUo1842u0C7QENoPdJ2qPQY5QqmT2QJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7842
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEwLTIxIGF0IDE2OjM1ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IA0KPiA+IEhvdyBhYm91dCBhZGRpbmcgaXQgdG8gdGhlIGRvY3M/DQo+IA0KPiBPSyBmb3IgbWUu
DQoNCkNhbiB5b3UgcHJvcG9zZSBzb21ldGhpbmc/DQoNCj4gDQo+ID4gPiANCj4gPiA+IEl0J3Mg
YXJjaGl0ZWN0dXJhbCB2YWxpZCB0aGF0IHVzZXJzcGFjZSBWTU0gY3JlYXRlcyBhIFREIHdpdGgg
bGVnYWN5DQo+ID4gPiB0b3BvbG9neSwgaS5lLiwgdG9wb2xvZ3kgZW51bWVyYXRlZCB2aWEgQ1BV
SUQgMHgxIGFuZCAweDQuDQo+ID4gPiANCj4gPiA+ID4gSW4gdGhhdCBjYXNlLCBkbyB5b3Ugc2Vl
IGEgbmVlZCBmb3IgdGhlIHZhbmlsbGEgdGRoX3ZwX2luaXQoKSBTRUFNQ0FMTA0KPiA+ID4gPiB3
cmFwcGVyPw0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIFREWCBtb2R1bGUgdmVyc2lvbiB3ZSBuZWVk
IGFscmVhZHkgc3VwcG9ydHMgZW51bV90b3BvbG9neSwgc28gdGhlDQo+ID4gPiA+IGNvZGU6DQo+
ID4gPiA+IMKgIMKgCWlmIChtb2RpbmZvLT50ZHhfZmVhdHVyZXMwICYNCj4gPiA+ID4gTURfRklF
TERfSURfRkVBVFVSRVMwX1RPUE9MT0dZX0VOVU0pDQo+ID4gPiA+IMKgIMKgCQllcnIgPSB0ZGhf
dnBfaW5pdF9hcGljaWQodGR4LCB2Y3B1X3JjeCwgdmNwdS0+dmNwdV9pZCk7DQo+ID4gPiA+IMKg
IMKgCWVsc2UNCj4gPiA+ID4gwqAgwqAJCWVyciA9IHRkaF92cF9pbml0KHRkeCwgdmNwdV9yY3gp
Ow0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIHRkaF92cF9pbml0KCkgYnJhbmNoIHNob3VsZG4ndCBi
ZSBoaXQuDQo+ID4gPiANCj4gPiA+IFdlIGNhbm5vdCBrbm93IHdoYXQgdmVyc2lvbiBvZiBURFgg
bW9kdWxlIHVzZXIgbWlnaHQgdXNlIHRodXMgd2UgY2Fubm90DQo+ID4gPiBhc3N1bWUgZW51bV90
b3BvbG9neSBpcyBhbHdheXMgdGhlcmUgdW5sZXNzIHdlIG1ha2UgaXQgYSBoYXJkDQo+ID4gPiBy
ZXF1aXJlbWVudCBpbiBLVk0gdGhhdCBURFggZmFpbHMgYmVpbmcgZW5hYmxlZCB3aGVuDQo+ID4g
PiANCj4gPiA+IMKgIMKgwqAgIShtb2RpbmZvLT50ZHhfZmVhdHVyZXMwICYgTURfRklFTERfSURf
RkVBVFVSRVMwX1RPUE9MT0dZX0VOVU0pDQo+ID4gDQo+ID4gV2Ugd2lsbCBkZXBlbmQgb24gYnVn
cyB0aGF0IGFyZSBmaXhlZCBpbiBURFggTW9kdWxlcyBhZnRlciBlbnVtIHRvcG9sb2d5LCBzbw0K
PiA+IGl0DQo+ID4gc2hvdWxkbid0IGJlIHJlcXVpcmVkIGluIHRoZSBub3JtYWwgY2FzZS4gU28g
SSB0aGluayBpdCB3b3VsZCBiZSBzaW1wbGVyIHRvDQo+ID4gYWRkDQo+ID4gdGhpcyB0ZHhfZmVh
dHVyZXMwIGNvbmRpdGlvbmFsLiBXZSBjYW4gdGhlbiBleHBvcnQgb25lIGxlc3MgU0VBTUNBTEwg
YW5kDQo+ID4gd2lsbA0KPiA+IGhhdmUgbGVzcyBjb25maWd1cmF0aW9ucyBmbG93cyB0byB3b3Jy
eSBhYm91dCBvbiB0aGUgS1ZNIHNpZGUuDQo+IA0KPiBJJ20gYSBsaXR0bGUgYml0IGNvbmZ1c2Vk
LiB3aGF0IGRvZXMgImFkZCB0aGlzIHRkeF9mZWF0dXJlMCBjb25kaXRpb25hbCIgDQo+IG1lYW4/
DQoNCkkgd2FzIHRhbGtpbmcgYWJvdXQgeW91ciBzdWdnZXN0aW9uIHRvIGNoZWNrIGZvcg0KTURf
RklFTERfSURfRkVBVFVSRVMwX1RPUE9MT0dZX0VOVU0uDQo=

