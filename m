Return-Path: <kvm+bounces-17557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 221C08C7E89
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 00:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75903B21BB5
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 22:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBFC1586CB;
	Thu, 16 May 2024 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ftRWeeVl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79F43FE4;
	Thu, 16 May 2024 22:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715898219; cv=fail; b=i44jNTg0jqFzsRgOpAblIhuAcDWhgpJs2qKRoaQ+Pr5gJX56O5L3KnJRpti55oqsDhs07VAHCnSyv+1fPUzztEe4J/DdnrbC1fe7P3p5QY8sspSYAIPjl/WDu72NiuWAom03jInz8Vtkl/T3IVO9T4DgabC8WN7TyJget6ngpG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715898219; c=relaxed/simple;
	bh=uUtvEOtfrhPBU6VoRyI9Tx6B7Q3vEeobR9ihMfGcT+4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bnQU/+YviNrFsU9Nb0u1goIU4C/QfNBfPsexBmzpXO659r98Tsl09F8p9DeeAeoL0Y0JjCLffJdBUFHpJpnlqQtjMC1x6agprl4fZou+Sq9veH5Tq3YlT3OtRgEQ5NpGGMn6Ube/u4JEZe0CqUxyeLr3lE2oK0uFrd7gUHjgbJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ftRWeeVl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715898217; x=1747434217;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uUtvEOtfrhPBU6VoRyI9Tx6B7Q3vEeobR9ihMfGcT+4=;
  b=ftRWeeVlWkcWm3SayonzerMrQ3IPHxa3dTSnkwQ6tYS2ryBmEoZIpy2Y
   oUY2m9GJE48RpPU+Wg4LWBzAmXCh0Fb/wo2BwoMhjka8GgVsfwLc0x61N
   LEpVHcaF3Ozp//JHNdiOP+G7W0OJ9gVZ08Um+SowaYa7bL4+8MXBkgaS+
   o5MYRU8gka1pgPD1Yk+uKZD6IRELgGs2PfRUu3EdyZSmmqY8CzkUawTBd
   /OJLfXoHPVRd8yWaY5KtIiHPi6HhBWL8KcoJJiH1PYijNtByQWt4zF2fl
   l7Z/fCFWPJPrCTLO9rdStwLLGZg5HGMUdigiwzi0FzGLL5hVwq8CfzJZe
   w==;
X-CSE-ConnectionGUID: mjGStOapQCyxI88RFwAVWA==
X-CSE-MsgGUID: r8p4zbmISOWW6SsJw4eRjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11890707"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="11890707"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 15:23:37 -0700
X-CSE-ConnectionGUID: ynGgC4qNT5CAgiAY4PW70A==
X-CSE-MsgGUID: 28RW7p+9RBmADZFYCe6IWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="62405578"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 15:23:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 15:23:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 15:23:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 15:23:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IK215+YbX8ZpJ8M+wkT1Gk24C6wBr3VNzRp1oTN8bzlElAGkaVSOzq8uvUT//BGcR/qDCiruIdAjnXybbGZcpwfQgdePMRztZvlZiVCJQIIi+DpGAMyY/gso2ZIa1JGvW2BEEEsUCXnbDhkQym9zzRCiW8ZOrSEdsPjREvSQYkn0kaZmp096mf+LfY4Y/mD9Cy/kkP4Em5IZEVYPNU7Rl1r6vBGAB+b6ZKzJurx3XXhY1OIVyz320H94q26+72ei1wZYGaHVh7iHskRCgjgVT04fHrctuoEvWadvGgNExTGo2Q7GQnuv5Ah1hWa/fw6qgJGWmawFAiznXk+mpdlAKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuEufxLsM77KG62pJUpKZaPhat2o0dcy+wlkXfFHqcI=;
 b=PBrr/J2bVvcUW4JSkGPOmidnLGdarISn9vPMs6bk7FJvKUcrRuBlGHzKC2w840lzsyGZOjBnUOZNDmOIwS/26iKuf4NfNA+n6dsF5sk710j2JbU7i3y90Icpetjl1rm5aV+iRjMS4Lh+MXbLTjPEeF+RNEeACVKr/l8b9MPaM1Ne0B5bpeYkxsMW4ntXbFOTfXl8QxfzdKcdFJuutY+KMs67PvKeGiDk9sZ8LxArV208JVE8hOxMz9u0THaZIm26/m5hWTqS6xDMe7FToGNJ7VwjEZyBY0aQjrpiW8JLYxD8XOcE+uhF/x3i7ThHx7IMqNByoarAHbv9nH4q1XI2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB8065.namprd11.prod.outlook.com (2603:10b6:806:2de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Thu, 16 May
 2024 22:23:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 22:23:32 +0000
Message-ID: <e5d163ea-63ca-4c4f-9e69-6d1686be92c3@intel.com>
Date: Fri, 17 May 2024 10:23:23 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <aa8899fd3bba00720b76836ec4b4eec3347d43dc.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <aa8899fd3bba00720b76836ec4b4eec3347d43dc.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB8065:EE_
X-MS-Office365-Filtering-Correlation-Id: 2043df82-c212-45f1-b637-08dc75f6d1f3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QnV2aFEzUlg4TXoxR1hFVmVlWVgzVm04ckRYS1hCcmRrelc1RjhpVUJkZGxp?=
 =?utf-8?B?ekVSRFgyZFJLKythSDRRbzZML1l6OFJJaDZVbW5rNVMzWE5FeWc2NG5LcENk?=
 =?utf-8?B?MkUySVJzU3hzY0hZTC9rWVUyME9nR2RZTERmR2NyU2M1eDA2YjhkVE9TRVoy?=
 =?utf-8?B?NVI2eng4UGx5Z1FZRXRqNlhmYXE2TlVMUmlEZDU3azdCL3VDNUhGRUtmdDNX?=
 =?utf-8?B?OEFhOEZGSU9nWUgwY3ZaYzBiUFpSZjAzQzZHK1Baa0FGc1krcmE3VzBycTVv?=
 =?utf-8?B?Q3VvMXozTjNoYWxjVVhTcmRsRlorR2hQbXRnWThEV0E1SFZONk0xcDFYVzZT?=
 =?utf-8?B?SzEvRGFlcVQ0MTR0b3FGaG9tK2NtcFArUlZsZzBYeFkzYlFheE52RUJ2L2xS?=
 =?utf-8?B?SlU2ZWZIek16ODZ1V2hFVWhiMFYveXlOOWEzOTZ2a2hhMjArSGdvVlRjaWtK?=
 =?utf-8?B?ZDV1NFRBTHF5cm5NRWRDL3NlWldJUXBVQUVkNUxCaWhZUlJySVVkNE82MDV4?=
 =?utf-8?B?U0d0RkU1YmRFTEw3bWhYUjR5MVdPNWMzaG5Yc2pVNFFBVWdQcVZpWitUaW8w?=
 =?utf-8?B?aU1vNDNULytES0Y4TEpNOHJEbDZFZnp1MUFHVld1ZlNENWFhd1VXL3p5NHBV?=
 =?utf-8?B?aUgweStibTN5VEdpTG43S0lCQUdoc2p5ZlN2MTQ0dk90c3YvSXVQbEV3dVVB?=
 =?utf-8?B?aUlWZjNiZDBpaDFkeHloZVhZdGcxeTlVeE9iUzllVGV0U1h5M1ZnZjBsbk80?=
 =?utf-8?B?L1pPTWhCZzI2L3dDMnJjVDd3ZUh2dkI0d1d0TlRIMkhsRHA5UnVGd0pML0JS?=
 =?utf-8?B?b3p4VGJPSlFJWERSNXY5dVZ3OTQ5R3FRNnNuSnlRUmFlZ3p5cHk2T1laVEVw?=
 =?utf-8?B?NTZ4V2FPY2xWWnlpYVZJaWFCVERNMk5WczlKTm1QSFpvdmlpODdZUVdQcmQz?=
 =?utf-8?B?VG5lR1BTUXQzRzFDTk15MjczMUx5cVRmTzh2YSt1NEJ1KytaVUlRQWNMM1g2?=
 =?utf-8?B?cHlIVDEwa2lYb2x5bEpNTG9MdlpZQlJYc2pRcGtZUjdGSEczTUcyclhMZFVi?=
 =?utf-8?B?ckw5U2FmN2tFYlgwR1lFOWhFd3NSVXdiYXgxRk90UGQvS05pb2IxM2dHaDhq?=
 =?utf-8?B?SU5lUVphR2FzclJvbXFYaGFWc0drMU1xclFsZlhUNmFxWWlwNkI2Q1BEREo3?=
 =?utf-8?B?UkgvNXFaTkc1ckVNeDhjOXZ5eUl0c0hBUXNwdmpoNzRzYzNUVnFvZ0dDMVM5?=
 =?utf-8?B?RVY0SkNjSHZkQ3FoY3dJZnd3ZVg2YVNmYWtSMVdlQ0dicmdQZU40eEZneUt4?=
 =?utf-8?B?YUhHZ0wzK0tteElIVk55UGI0YXdUeDRoUkI3UERGdmtwcHBZM01NMkRVcGxM?=
 =?utf-8?B?V1hrNDZ4dnJjV1ZFTlYyc0tyeHMzUCs4MTYyMDF2b3RVUHRtRldOZ2x5RVhP?=
 =?utf-8?B?ay9Tdkk0Ty9MekpZb1NObURjdFJSZ083M2pmeVcxRGtoTVJHTG9VTlhPSFZy?=
 =?utf-8?B?ZDdNaVkxakF3bGxJT0Q3OWdoek9jRjJlR2VhZFdqQjIwcGVWaTNBU3lvLzRv?=
 =?utf-8?B?dlQvUnU1RlYvUEJtbnJSZi9tRm5hWDEwQm93MDRSRjdKdE44NWxqSTg2aDB3?=
 =?utf-8?B?OXFDYzJBMFo5Y2R5dHUrMy9WMlA0aVE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTBPeGFLWEtXNmhnRkY1UGt6UGZ6ZThROGlNMUZqR2JxL1F2bXhFbW1XTDBn?=
 =?utf-8?B?S0VUcG9TaE5ZbTVQN0dTRzZLNXIzYU1vM09vem43bEhTY0xvN0s3K1JXZWVC?=
 =?utf-8?B?NEJPd0VTekZwK0JJa3R6ZW1ZTjhFSldqbDN1Z09FWGZGdnZXNUlYdnNtUk8x?=
 =?utf-8?B?UEVET0V2NlMvUWRIKzlmd0JGaXZ3QWc4b0kwRUdJMDBxU2JWSjh3UnVOUlc5?=
 =?utf-8?B?TlVobGFrd0FzSys4NWNYZnhQL3B3NDQvY1paYVZLa2F5M3NQNW9lVWF4Yzhp?=
 =?utf-8?B?Wm5yU0orcVJuMzVFUlVoTVpZTjhiaUIxRHdyRUp6aFkxT3BDSFRxR3hkZFBi?=
 =?utf-8?B?Ymh5T0RFTkplejNOUktHUjZVR3h2N2crNHVxUUYyaTlZUUN3QlhCWG1kSnEw?=
 =?utf-8?B?a1lkaXZOMWJtbkp0THAvMXBUWGxTRzBoeVJVNm02VFlPcWp1YzBCdkdTNDNm?=
 =?utf-8?B?T0tETDk1bHVjVHZVc25YSjkxc3UvK1k0V2hkZlNvQ0U1OGRWb3hKaXhOVnNi?=
 =?utf-8?B?VGxBQWJpRmlnMHZDYWJCMmRjbUFnb3E5RE1HTXFqNTF0ODNWYjVNTXVWMiti?=
 =?utf-8?B?LzV4b1JYUnppQzBaYXZqcWNQRlgrbm1jeG8zNlJ1VVpDSExYelUrckFlRXVD?=
 =?utf-8?B?NnRHckxiRk1LSVB6UFRGcTBjUTlmd3paUlVidTArNVVBMENUUWxSVS9PdUlG?=
 =?utf-8?B?TENzQTdvQWc5ZlB2QWhYb3JzR3l1QWxjbmtRSmRkU1UyU1FLZU4xcGU4YlNY?=
 =?utf-8?B?RjJza3FNaEEvS3NOdksvRW5QMDF1Q2dRd29jWFIyZzdkRFBONlNJc0tobjRw?=
 =?utf-8?B?NmJ6MkhoUkcyWEVHUC9ISndNN0ZjNzkvcnBudDhEZFAxeTFBcFNicU1neGZY?=
 =?utf-8?B?Q2xKczNDOUx6LzZPNkt1U0U0ODhidjBLWUNiTkVYVkNNZ3I0Si9vTFZwUFlY?=
 =?utf-8?B?V3JSNVdyTmZuTzkrUWNma3dxNk5vcU9FVm54bVJyaWlVVWxac0hFMjN3cHZW?=
 =?utf-8?B?OVpuMjBKa0szTGI0anNKRkM1Vk42NmJpM3llSFdSbmRXcmxHa2kxRG1iKzZz?=
 =?utf-8?B?N1lQSWtoSHRQd0xzZEtTNTNYdnpkcGxjdS9sdElVZVp2MmVKNFhzSmZrOXJ0?=
 =?utf-8?B?amdlb0RWYlhIMjlUOTJjQnZmaW1oMnV1KzYySzlxclNLVDBuTzcrNmZPa2Jk?=
 =?utf-8?B?S0E5dGJxZmtoRkkvQzE1ZUNtQ2dWMFRaeWtGS2pEZkVlNnhkdXlJUEo5UEtv?=
 =?utf-8?B?UFVKdk5xREptekUwT3RUTmV6bm9tb1hoMjRRMmcwRTZHVG0zaXdpUW9FUmFa?=
 =?utf-8?B?ME4xK0ZNZVhxTHd0cVlxUVZMcmprTDYxM2Zvc1ZZdzV3RUxiTVJpejZUY0pE?=
 =?utf-8?B?eXRLajdNVUc0c1NSZTFyRkFnRHVuUGdQaEE4L3NHNlNOOGVoUWt4cFRpb0sw?=
 =?utf-8?B?NjVmTlhuZjlSZXhoakFSTmRacFlXaFJtSmVmdm9TbkM4NW8yd2h4Qmo4NkFt?=
 =?utf-8?B?dHBFaURHQzYwaWlYcGU3bEJaKy9RMFZmbWdhMytuZmc1dUYyRkRJVnRtYnFE?=
 =?utf-8?B?TTl5d1FBUXh6TVQyamsvczRPVWtYWlVhMi8wMU1iNTZKVXBQNUV2Zm5lWGRH?=
 =?utf-8?B?c2xKaEY4bnlBN0VlN2RRWFJaSXNLS0V4YXpsckhIM2lzakM1WDAvMzk2VjNn?=
 =?utf-8?B?MWExekxYNy9KOFM2STVkVFZJU1RheC9JT0NwR3h0OGNuS053ZEtucFlZOVBT?=
 =?utf-8?B?NWliODV0NnhyZFRWdndtTTdwaU8vaVRMelVyT3ExNDh4VkIzU1VmQ1k5cSsr?=
 =?utf-8?B?VCt0dk5SNlJWNmhLYTVqM0dqdGw3U3lsSExsWHY1RitMZGx6YkcrQ01LR2FD?=
 =?utf-8?B?VXh5MFcwZ3FIc3NJY0lGald2ODdlaFFkL01GT2N2M243NGZGekRnR051V2lo?=
 =?utf-8?B?N2ZrbWY4cFNrR2xvQXpkV2tlaHozZFJFRURDUVNhZVVNdDFzVjEveDd1NWFW?=
 =?utf-8?B?b0xLRms1aVJHY3NRUXRRSXlWTHM3dTgzbTdmUUVhakJqb3B6b0JhanFkejRU?=
 =?utf-8?B?dytCMkFubUdQdUIycit6eGVOQ2VLc09JRUowWnYzNFViRnFxeTkzcnNFWmNt?=
 =?utf-8?Q?bJVosft2FvEeiKQYDl3qzJHW7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2043df82-c212-45f1-b637-08dc75f6d1f3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 22:23:32.5580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvFrU6/4Yognrp+t345hiXJDplb0O2gUdAM6e7hOtPaRN2TTAvVdj84PAgMLjhKQD2DTNdjRk7cMSUdzEn8lUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8065
X-OriginatorOrg: intel.com



On 17/05/2024 9:46 am, Edgecombe, Rick P wrote:
> On Tue, 2024-05-14 at 17:59 -0700, Rick Edgecombe wrote:
>>
>> For lack of a better method currently, use kvm_gfn_shared_mask() to
>> determine if private memory cannot be zapped (as in TDX, the only VM type
>> that sets it).
> 
> Trying to replace kvm_gfn_shared_mask() with something appropriate, I saw that
> SNP actually uses this function:
> https://lore.kernel.org/kvm/20240501085210.2213060-12-michael.roth@amd.com/
> 
> So trying to have a helper that says "The VM can't zap and refault in memory at
> will" won't cut it. I guess there would have to be some more specific. I'm
> thinking to just drop this patch instead.

Or KVM_BUG_ON() in the callers by explicitly checking VM type being TDX 
as I mentioned before.

Having such checking in a generic function like this is just dangerous 
and not flexible.

Just my 2 cents, though.

