Return-Path: <kvm+bounces-17499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF688C6FDB
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82578B2194E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0231362;
	Thu, 16 May 2024 01:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KneR0Xpb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CD764F;
	Thu, 16 May 2024 01:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715821912; cv=fail; b=K2xLPib0NYR8XarnQIxBkSk5fFxcdRJI1NqvljkjGEQ4FyhwetIDyF62fNInLwJrP/ugEUKh5ppy8qRBl8xrfF4syWFpJfNCOS9jtcn5BD8tvhe3k4UGq3QUwiVSGpyFPRZ1AAhzou4/j15KD11242WGYKSFqOQbz3EMlRmsdHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715821912; c=relaxed/simple;
	bh=1WrWO4kUCSHFebFCCbQx9IcFoo4J9zESEg85Stetya4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XwMPMfarBhEOYorgdQvuL4z1WhnKI+7HMyyiCoQ/duj73nu2ffMCeJbvEaWgvREp5gsBQGsjSCZB9zgaRs8/MJkdh4hdLz1VfjGhm+4MG6IwUF0YEitV8OpfFwX07OJlnjD5P5IrSAkZCBObiX3MT1mqf/HLryNl9gKX0ZyQwtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KneR0Xpb; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715821910; x=1747357910;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1WrWO4kUCSHFebFCCbQx9IcFoo4J9zESEg85Stetya4=;
  b=KneR0XpbvkRMwu3WtkWBChxbel1X8VmrD0lCUpaN7MTZ5kSXCYQox8+8
   8U3pAJmidfAOJ8rKhme6flqzBDb3Ys2vRS8SzLVqoSLVKgUvtJnOBWO6H
   UPHs+REIqbf3AyfZHqsGPb5xJ/SLVsfkv5b9sxLtygc+6vju624cv90WO
   ZBYqpAiNYcCd06w4NMe+vXyG9f+Nlf1t1pPAi9JJ/j8fQML1RXFtYYxri
   TH6/7ZMD4UwQaHwsVgO9PblTsrrbQSz1KZD8h7nDmYTE8ppKKCWUHmRC/
   6grN3qDMI5b89/j2KBK/yVVtf0j5wj866ie7Lsyo6MsSu4JxetHL7iAju
   A==;
X-CSE-ConnectionGUID: MCBoiA9hSOiHgl/ajmTgHg==
X-CSE-MsgGUID: 4edqHViEQLaTHkNv60FEXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23041945"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="23041945"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:11:48 -0700
X-CSE-ConnectionGUID: W0pxDCzNQaq1g83TV8aU4Q==
X-CSE-MsgGUID: 7kTlD4h7Se2cDHRwJ+lPxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31261978"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 18:11:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:11:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 18:11:35 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 18:11:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7Q2+iud178F8IXHRKOYzdZIVjGjykNsJL0w1W1kT9j/GukaCyIDeOJDXTCvDZcUtVpcJQt18r307jGFlydZ627eS2rmjZRTGvzsy/1MsTiky/f3kLRjz4moRq/x+6+jQQ/IVwgCBPohLTkPqZzqP9CA8TCbDfHwf83vC9SMAD3iTmwyxTn9qkhsUXLnXC79XKgw973oXyJr7XMFKT9QPr+IikChyJwL3MtDYGBX5JBJKwVvzXtAyzLoqNhdy/AkttjGhdkvdeRtQaU7SxSHh3obpIbkPTMO7sdMN+5r/Pp0o2zqV4P9MpYiR7Oi903+VQgsALXuUW+LxhP8L/Wq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKZ2DZ3rpX8Fcyxf7saCpFRRMcX8YfmFURDqsEn55kg=;
 b=ESM6drkfHPwtjMxhPRMZgNXia+qV8aB7P0bCJozR23fXUBfMTUEAPDr8PPw+xDB+C2BEYiG+nk6MAXfXCgXZetILtdbH1T0OK6uTr+y1ZzQsBhSOgze+VIf7rFf9l/rR7nRcn32HnydamIrffI935YQ8ev9wSXTO1blMtSaDxoAZuF5vRgUDOb49o8lspVotwYWEkp0WMPgzkLG4WQSNIdRL3UTpy5fHosp4t7ZJfIh9aQpfsssgWSpRaT92NnVpTZ56iguJbz0thEF4g7MEruOm1qCraP7pgpEweGaAT3mBfIVUgtf2NxbHXu7oTAAd5QdAHvlxUsK5jw7kynnf3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6436.namprd11.prod.outlook.com (2603:10b6:208:3bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 01:11:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 01:11:33 +0000
Message-ID: <32447c72-7447-4102-baf2-7af78020bee5@intel.com>
Date: Thu, 16 May 2024 13:11:24 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com> <20240515162240.GC168153@ls.amr.corp.intel.com>
 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
 <d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com>
 <66afc965-b3f5-41e5-8b8e-d19e7084b690@intel.com>
 <3879ed41213652da74c5de3e437f732dfb2324d7.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <3879ed41213652da74c5de3e437f732dfb2324d7.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:303:6a::28) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL3PR11MB6436:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fff388a-ce1a-42b8-8162-08dc75451fef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnZWSi9Mb3hkdVVVZ0VVZWp6ZnRmY3hMZ0htS1NmREVJdmw1Wk15YTJoSWxn?=
 =?utf-8?B?azJZcnE0Skw4RVEzdis1cHZFRHFMckx3bVVlV2hieXBZenovTzRwQ3VZOFJO?=
 =?utf-8?B?Zm5DdENTNDhBdm4rUVk2T0UyMzJBV1p2UHpwVjFpVEdEcWdpK3VpWXJyWHBW?=
 =?utf-8?B?aEFpanZQdElHcnpOWXoreFY2ZkRJVVpNVDBpdDhtRlZzRjZFRFB2Slc1ZTVq?=
 =?utf-8?B?M3F4eWtBVG5FUStRT1Mwc2F6Vmk4b2NIelV4ZUNGZFFQNFY5NDhjR2lxVDRL?=
 =?utf-8?B?TThIdUh0azlISkMzL1JBNWgrd0Q3NU4zdThWVXd3Tmx2aG15VnF6ZS85MGIv?=
 =?utf-8?B?QWpQQ0tlZXVWNFowdEM2dmZBNFZzNzE5cE95dXdZWURmeDI4UURjZWVwaGdW?=
 =?utf-8?B?NGxsN2VUQ3JNdWtZMERCRXBxckVGR3c5N3RoOXROUnVndENDZklEY2NENGcx?=
 =?utf-8?B?MWxDdEZUVzRJMmlIZi92WkRwRkZpa2lXSS9XOUF3eGhwM29IazU4YmhvejMw?=
 =?utf-8?B?NDZZS1NkVXdvcGU4V0RXZGIxMFpiU0ZxdlhIZWJhTkliZENHM3VvSGFOZlVH?=
 =?utf-8?B?WnVROWJEak9FeXBHajVMeCtWUkZOa3ZMaytITEQ0MGNqRzJqSUlEdTVrU3pH?=
 =?utf-8?B?Nk1WbS96cGp0T2pZRkJpa20raHMrUmUzYytScmd1M2pIVE1VeDVmSjFPMG9s?=
 =?utf-8?B?YWxpVVVmdXI2aitCampoRmZIakZWYklGMXcvRyttbFg3VEEwMENWcmFDV0pH?=
 =?utf-8?B?YWY3SXdtc1lwNDVhazVEOEMySlpqNjNWK0wxd2U1SlhYWGpheHZ0TGlMTWNV?=
 =?utf-8?B?N2owNzNOTE05NTg0UTIrUG1nTDRJaldMUEZ6Y3ZXRzJTWGVzL3BQcjFEbyt6?=
 =?utf-8?B?ZGZQYmlNS0VNdklOTjk1SzMwR3Qvc0RqZ3kzc29pLzNjVUVNelFaeFB2b2xw?=
 =?utf-8?B?bXBNbkEyZndSN2puMVpheUI3KytmZmdIOTdGd2ZaeWwxdWZvdjFWSGVSd3By?=
 =?utf-8?B?MmxsU0ZPYWdTSGlFSHNTak1UbVEycGhVUWNrQmo3U2lPNkFoeityZ0ZxbklC?=
 =?utf-8?B?QzEwTWIrVHVtUjI0VnQzWU1iWG8wYVZsYlZIVE9yMEdBaFErS3ZRZm1TZ1BS?=
 =?utf-8?B?ZkpHMzJKZVc5Ti9nbndlT2QrV2pZV2FJcU95dW9EdWZLZExCUitGbjhCSUM5?=
 =?utf-8?B?cUtqNVZCa05tTHNFdmhFWjk2OWFlaDRyazBDSDAwS2ZBZm0yYnlXZ2NyL1JY?=
 =?utf-8?B?VFRLeFgvbm1YZTMvRjFKNVcrZHhZdWxrV21KV01sZ3k4UlhmOU1hYkJUS04y?=
 =?utf-8?B?QmQ4bmppK2pXSzlnbjJ6eFFaWTgzczVsTWpsSStCQVNveFdNbHR3QUk2L2tW?=
 =?utf-8?B?Wm1YSG0yWC85cGJuakR6bjZuSG1KeitXZXNudnNzaFpzMDJPYnpMSFB4QS9n?=
 =?utf-8?B?bjdJSmlEdTBXZGVaKy96RWtBbVNvOFZZWUVLNXAvcElEY2s0Qm0xRVJXOGxa?=
 =?utf-8?B?eVZWQ3BzZEppWmJzdEI2WmpnTXRoaFdLeHhZcDczR3ByMEp6RXVRWHE5Yk5J?=
 =?utf-8?B?bzVIOXJjdk5XZVdRcDVuanRYOWZwc1lzRUppVlJ3VUNvS29QNURFZElwK1lV?=
 =?utf-8?B?eGx1YjRXaWlBblhONTFReDVCTnNMd2Q4MWxUc1VFL2prUnRyMk93bmN3WVdr?=
 =?utf-8?B?QWk1aFIwaDk0cFh1bHlYQ3kzNUZjM1RmT285YkRIWW9jWW9iN1pKS3RRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2JjaVdsVjZTanI5QXFoNGUyUG5RbVBONTZYQ1BTeDJacWtrMlNnWWNpVjc1?=
 =?utf-8?B?Rm9Dakx2bWFzOEJncmFrbEpuUXBFSDRGUjdlM1orTWIwZGFtZ2hjc2k4TkVw?=
 =?utf-8?B?dGhMWWJaVFROTlRqaVBaMysvUVN4emNNTFRySXBrcVNYY0NXNHdlWmhjUTBU?=
 =?utf-8?B?dWp6b0JVNkd4TENkOElsc0FadUIxeVZTNmtXc1ZRbkRTeThYd0JTZThnSDkz?=
 =?utf-8?B?clhvUzMrTlZnck92cGhobFNOVElhemhkWmttd1Uwei9sRW1EVXRiUFpaNG1R?=
 =?utf-8?B?RzBuZWg1N2V2VUlNY1Y4Rm16TUVFMk8ycVp5U3hIV2xtbjN0cWxLQTRhellJ?=
 =?utf-8?B?bzhDQkU2MmV4TERsVHBrM2I5Tld3YzlBLzk3c2NtTG9iRUsveHVEeGFlS0wy?=
 =?utf-8?B?anc2bkFmVDV1K3pWbHNtMmk5RlNzMGJZMWJ2MlNRbjJ5Y3F4SUhsQnZXK2kx?=
 =?utf-8?B?eTBvREZZN1Faa2JtT2pRL0NsYi9GVG81SlVIU1JraUprekZBQXEyZ1hjcE4y?=
 =?utf-8?B?OWNiMmpVV0xNdU54aXFyait1VC9qcXBZRVc4VnQ0VlZ2L3N1K056UHdLU1RB?=
 =?utf-8?B?SDVoZHJiRlUyZTVkWjhxRUVlWWFxL2xERnc4QWlzem1RbDUxUHZsVmlheElI?=
 =?utf-8?B?VHZTT0xCaHBtQmlhcXBFZnhOV1dmdmIzTk1BM0Frb3d1aDVVN1NoYlpxMklZ?=
 =?utf-8?B?SFJNUHpseGg4dUNTa2NFQjdtL2U1cHRyT05xWHpFVTIwM3E3NDJMYXh6OHlN?=
 =?utf-8?B?Q014RVpSSzFnWUNKRHRCZmdEWTNZUTJtVElRZWhDa3B1WnJnT2hJaWhidWhU?=
 =?utf-8?B?M29VZzQyNXpFa0JDY0tsdnZSWm92d2Q2TUI5N2huWkw5azNrTHV5MG53bGQv?=
 =?utf-8?B?ZTkzUzhzaHFnUFA5cFE4MEEwd3ZoY1A4eFp4d0hFL0sxWDd0Snd4VjExNXBj?=
 =?utf-8?B?MXdlak1GeVJKY053akZKdVZwQjhKblpsbDUveVRMeUpObUlqVEJDbUlpbzhK?=
 =?utf-8?B?c0h3WWJSaEVWNFZ5ek05SmNHUTVMb1VNK2h0NlZkc3NxWU5Ib3hQL2pPV0ti?=
 =?utf-8?B?QWtpNWRaUk9NQXF5TnR2V1h4UzV4b1JHSUxSWndGQU51eVNrZkxSZk5SVTNx?=
 =?utf-8?B?Q2FWZksxekIzYko0bGJLNWoycEVQdWRaQWhucThJek52SVZLS2diM2xJU0Rw?=
 =?utf-8?B?bGt0Z2l1eE5CWTB3UGwrcDE1czNjbGJtcGZaRWZicGl4UGNVSmVyN1ptVHQ5?=
 =?utf-8?B?U3dRVklzUDdjaUs0SXRibXRQSUtTclM1QUw1bk5IaWU1cWxaaXMxdEwxSWti?=
 =?utf-8?B?Wmx6ZkxVamJjbnhwYVBKOE5uKzN4ZzBxd2Ftc3ZoQWdjUlY5aW10RjdIRzFG?=
 =?utf-8?B?cGpnTkJtVk1PdkN2N0hyQUJwRStOLzBHeUdjQU9QQlUzTk85aWNYamRRdzlN?=
 =?utf-8?B?WldoNE5hRkxUVGlNYTF0OFJ6ZHhLdUpqeDBwbzRzMUhpQTVIaVdaRWZjMlov?=
 =?utf-8?B?bXVlTUVHVW8zUml4bDJRWmtCNEZrTVI4T0hHZFhDZzhWVDBSYkxrNWVCeW1n?=
 =?utf-8?B?blBmR2prdmptell1aWs1YTNlcm5iZDRnZGRXa0pBK1M1WmZ6T0VLRDBTdlFC?=
 =?utf-8?B?T0N4UXNlSHBJREFtYklqckJ6RGJqbGRHVlZxb1lTMndVUVI3MEdJT1V4Y3JT?=
 =?utf-8?B?aWk1K1ZkdHgzTlF1OWwxQmJDWGJFZUlPMlRWd1ppd295RFBxcngrN3U3QkRU?=
 =?utf-8?B?WXZQTVdVS3BkTmZzZHk4ek5EWEdFODV6L0Y0bWJhY2RFRTdJc1M3Q1hPY00v?=
 =?utf-8?B?U0V6bDAxY0Y2RkNGUE90S2xTb3hwaTc1UjhLUFNiK0Nkd2paVVZtNFIzTHhO?=
 =?utf-8?B?bmdqc0lzdEE4d3ErTzRnbDFaaHQxUHpqS0t2QmFUUjVpcTZTTGVNUzZvMDZz?=
 =?utf-8?B?djFGdStwbHBYZkppU1lzMEZuU09GR05KSDYwWHJFVlpNQkFFajFSRkJnRity?=
 =?utf-8?B?Z3RheHlTL0VoeDQrUVFpRHY2eHdJK1RzS0VMU1BxWHpHamJ0VDJoVG9mdXFO?=
 =?utf-8?B?VkNjL21LMSs3QUdURmM2QWl6c0tiWFNJajJTT2owYXJsWjZ5TitpSFYzVHV2?=
 =?utf-8?Q?2MpYRUMCMCa4FtlmHJEomTZqs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fff388a-ce1a-42b8-8162-08dc75451fef
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 01:11:33.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HYZofYjV+pcnmxILs0SY0IiXrvSBWgPniPETo5KuMx/BbTnbpNl5gEAwQPrx+z+/l7m43J5zBOGh4B2QSiWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6436
X-OriginatorOrg: intel.com


> 
> BTW, the role bit is the thing I'm wondering if we really need, because we have
> shared_mask. While the shared_mask is used for lots of things today, we need
> still need it for masking GPAs. Where as the role bit is only needed to know if
> a SP is for private (which we can tell from the GPA).

Yeah we can have a second thought on whether sp.role.private is 
necessary.  It is useful in shadow MMU (which we originally used to 
support at the first place), but may not be necessary for TDP MMU.

