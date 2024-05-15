Return-Path: <kvm+bounces-17479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A52D48C6F3A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC947B21A54
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5333950283;
	Wed, 15 May 2024 23:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="APDvy8rL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95994101C8;
	Wed, 15 May 2024 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715816180; cv=fail; b=TSPi9EBdVSPv3dAZBlNJSKl917YWRtFEQUTKlkHUNwLoU5j8CP9m/Jedma44K0TQ8rF75SLTLckgdifMKCpNdeiwezsDm0tOm7iCnqHH9gsheWF4CoO6BpoIFqBjV8RPin9e0+28QAkuD03NkRBL9+owvSi+Pq2gFnkUDa+psC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715816180; c=relaxed/simple;
	bh=G23NzMX66w8ygnZe5nVwrSEgbMLsWd9ysxXYeMos4zY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OeN3t3D5CG5YDpNVor1aFl09+NVzG0X0SldCBwFINr/WUZv3cSBVpVseoj4CzLLTJhB1ByWet8OxIuKQSOxJqGuEIHurVBARux21sVKHBxnPOH3l/O+fJwXlNAqVDc0e/1MWrSF6ogEIXiYt+flMRZ0lO5OIW01jJaDhoZnlp7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=APDvy8rL; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715816178; x=1747352178;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G23NzMX66w8ygnZe5nVwrSEgbMLsWd9ysxXYeMos4zY=;
  b=APDvy8rL67W+8EBA26Pt8Uwb085DN+WscV5rUOC7g12ZX+FjYFC+j9zS
   yuQQ3ej8V1UsOGUb2tKiKZl695eu+XvCsuoJnAtTC4bRsrmGYzJFbTpW5
   akkjZ4V0s5AeAILW4sLBB0rTL9ek2ItJ6Al4tCiVEMzzZygf9W0Tx8ecw
   KeWGXgOSLdlEsL73Z+UN+L+8ieG08w3W9wK7PiRw8NjljIzCnDi3yEeNR
   DmmvRhEa4vUh1TqsN6DJ+JSoE/TJNjxJvX4WAXblnAccbvDKDAOw0M4QK
   iVHa5Dx6pbXOPJmq5CUyy6KM6d6Cy15GIWoIAfxZFGfxovcSm20mlK9Rj
   g==;
X-CSE-ConnectionGUID: cmSo2b9cQCWwhCSSzMSfNg==
X-CSE-MsgGUID: CcBI8+NeR7WMzRWuHSB3Fg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29388560"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="29388560"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:36:17 -0700
X-CSE-ConnectionGUID: Nta2Ma8jSW2aHB1WR2pK6Q==
X-CSE-MsgGUID: gOrsM4dnQ3izBFMq1/PY8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="62422452"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:36:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:36:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:36:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:36:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvPcBobK+Juf2YbQe6gPINewqmqWHiWQMyZ2KN1Tneq2s7iMzOQsB1cM1Np6NrxOQZ/LN5smlZqqkcU3nD2J2dUEygsxtkALq8XDsU0AI5w//BL1NC/KeWiCOfREtYG73kMTMb4i3Xxatuhj/14XdnGPFQdW+W5RvypVNzkvh3PEhqnqVR2dlUHRigko8jjWUzq61c8YSFKKlJxkmE62hPFj2X4E8jDP3lqfmDMauktudu0cu7UrnjU+X6hWeQPgpR1rM2CjhrpgXyyFMkVexgrMJFzO9Ke4O2N3CtCKwgPCdXns0WaWfAQphYLtzR2opIueWeVRDcc6ocW73Hk2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4SmBdWEiLgsRxOKXpm+GlxzmN7Sv4bUQpwx/UtVyos=;
 b=Yuo6vfauw/CX+mtMixFKBQGiiztSGs57nfZ8j0rl30CcWlschc86IjBgGpdTrnHCMLU5iXoPKQpEM5sqOE6O5fdneRFudol2BaLldpp2MzOUWT+hToEmk8DhsEDkZOmiMSh8t8asg0yoQ8itveMgDxatXJO61hQTbUPQVwMgiDvTglbHqHbhK+1kdBetQnOPhn0yzBR7HeVecY7VwvU9anngKm5CXYSwk0Z4Ff0NBwLIx9/tcw4R3EhLxoJb1TtH5NyXvKGEO3ibD42qVZ+Yn8FDcfuezTxTjZtyquJqcnP2j15OO+Lo1O9b97q1NUzRMf+A+oF1s7i3X6RPvIajIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7562.namprd11.prod.outlook.com (2603:10b6:510:287::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:36:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 23:36:13 +0000
Message-ID: <571be50a-d7a9-4d7b-98f8-0d97dafce14d@intel.com>
Date: Thu, 16 May 2024 11:36:04 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao
	<yan.y.zhao@intel.com>, Erdem Aktas <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com>
 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
 <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkVDIkgj3lWKymfR@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:303:8c::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 49cf02a0-ceb4-4128-dd7c-08dc7537ce96
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dlFoSWNudGRSMVgrayt6b3BkZ1ZnMG9JNUxaSERiQ1B6OTQ3WDNobVdYY29y?=
 =?utf-8?B?ZFhnRDd5WDcyaFNxQnVGYlYzUWxRRC9QNHU4emRPRDA0MFBwUWVVb1RmalYv?=
 =?utf-8?B?K0w5aFJPbDl4OXB0UjdFNHkyeENSaUp6d3VvK0NtaUoxU09GTCswZm9yMGhG?=
 =?utf-8?B?SFBOdmRrclNVMzZlU0VwQk03Z3pkM21nZ1dOcEpFdnhpNSt6dzBOdkl3bGdw?=
 =?utf-8?B?cE5la1ZCWk8vcmpPcE1HU0JqL0dwcFcvQVp4SEpTVmRXc3kvbGk4MjREYnJG?=
 =?utf-8?B?UDhSQWRKRnVmNXJQamQrZDhPanBnaDloMVZKQzJ0YkxHMGs5U1hlSjIwWGZR?=
 =?utf-8?B?UDNWN2JkRHJtTGErMi9MSEVuOThFOEJITHh2TmlHSlYzam9jUUw0TFduTTBN?=
 =?utf-8?B?ME5wMHJsMUNPOFdCNW1JUjRidWc2M2V4RW5sMlBOTFIvcHdOMG9xeG9NcGJY?=
 =?utf-8?B?VTVMOHczSHFwOWJHU25uNS9IQnd2TzExc2psU0kxME16Tkt1OFlkZk1zVnYz?=
 =?utf-8?B?alFIbHJ4VmRETUhNRWFIMGUrdGk2aG5CR3FhZGpwcis2eEd4Qm9WRFowSUdP?=
 =?utf-8?B?YkxmTTlObWRZWkg3ZEMvL1NYemRzT010Y1hFZUVlQTRnWEZrbUtjeGxmUjRa?=
 =?utf-8?B?czBoa2xHUzZhTi9sU0E4T0Uzdmp6UVZieFVjUjI1aStxMXVLbHFIcjBSMDZL?=
 =?utf-8?B?M1kxUjhkVzNKNEhKa0VVaWRXOUZ3dDgvT1AzUmtzOC8zMUQ3b2cwN1ZvV1hT?=
 =?utf-8?B?a0p3QVJQTVNoYlZSL2xtOTFRWnRqdnUyWCs5U2ZiY29iMlRxenJ3UU9UNnZs?=
 =?utf-8?B?ZTJDdmhHQnJuMkdnMldLV1ppNnRqQlFSdkFsZktxWWxtaHgrTkxKcTdvS2lw?=
 =?utf-8?B?R3hrN2h6RkJjZG1kMmZndlFMY1hxMEJHUkU1M2ljMndnOWR4U1ZWMng2dTBJ?=
 =?utf-8?B?TWQyeUZsOTF4ODAwMVN6bytkMlF5R2ttR2R3NG45Q0xHWkl2VFpkNFczR0tj?=
 =?utf-8?B?SlROZWtOcHNMcGVSQXovbTFkY3F6R2ZXaW01d2p3Y2hPaThnK2pOZTRUYUM1?=
 =?utf-8?B?bDNqN0hxRXg3TkJTVFhPU1k5a1YrRGJlNDNqdVdVR3pMd0tianBqbHdIcXFo?=
 =?utf-8?B?Yk82ekNRWXNsQnpjWW5Vb3RTV3BBcGI5eSsxR0tkVlhvYzdqSHhzbUo3bzkx?=
 =?utf-8?B?TkZkVityakE2MWJnVFJPSDd1MGU2QVBxNStpVGFuSlRIUXlQU1VIa2lmd1Fs?=
 =?utf-8?B?YmxVd0RySlNvd0pEemY1WlRzUmoxbnB6L2NiejlMRmJzelJUbGliazFJOUlx?=
 =?utf-8?B?MTFRcXJuZ1RzRmtFaDFtVjBpaFZDNjFWald6NXBsdmVaeGF2WWl3eDlZbGFJ?=
 =?utf-8?B?ZkZWUlZTM3h2VlBOYkpWYWx6STMza2lMZmlZQUpGSktsMCtyWHZ6bmdrYlZ0?=
 =?utf-8?B?NHZrdHlORmUrTUN4eTZOdVhxS3daWUJjbnNESnRDQlZwWTdmVWlKaG5hb1Vv?=
 =?utf-8?B?VXVPZ2Z4RnVBbUR0alNhTkVyUVlvN2tIZFFDS291dHYwRERGaS8yb0FpeEsz?=
 =?utf-8?B?MkNLRkRJdTBVTlExR053WHc5dm15UUlhWlY2UXd2UDBROXJjTHFFOXFza1hk?=
 =?utf-8?B?WHBBV0k5RzZNNGFaZ1hzUGNXaEFEYS9LUTBwOTYwbEt0U2tuU2w4cVZPMnVC?=
 =?utf-8?B?VEtHZ05aTExyZkNGVXQxczMzNThEbE84dWpSc1FCRCtFSGVKaE16U0pBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0xSZXFyR3NoaWpwUnFwQitQTTdzVUdhV2VTZG9PUjZhK0dZdDNCaGFBRm44?=
 =?utf-8?B?T3BRcDJrKzhudzQ1NDlkUlppVXVTMjZwRno1M2ZJQllRWDk4b0gzY0R0L1lH?=
 =?utf-8?B?Q1N6VXo3Ny9wWDRqcitDdU9Oc1B5R3RhUE4rM1hoMHdaSWYwSEl5cnlzL20v?=
 =?utf-8?B?WjlTbldheXJEOVJlMXZyRXNKRmhySzhmZVIxdWkxeWNDbXlNUFFCRmtkS2Yy?=
 =?utf-8?B?Q1d1dW9JYlJ4T2M5Z1lYVGpkK0c1emdFMEcvdlA3ZUgzejRIVDRWSVd4eUdK?=
 =?utf-8?B?dDRoc0lMY0RrOXM5YWhxZ0xRNWF4UDVGeEsvWjYrMGZPOUpQUVhEVUdZVWdY?=
 =?utf-8?B?bUt5aFN6RDdqWUovYlJQK2d2OGF3eUZmQTBYdUtheUdNaTlmQnR3aVdjek52?=
 =?utf-8?B?U3pTVjkrM2R3VmpYc1c5c29USGVaaDluRnJzSStrTVpld0tENTExMkJDemow?=
 =?utf-8?B?UG9sQXo1SkI5SGU1MnIyQ3BKTXFPRUN2VmpKUVh6Z2hrY0cvQ0NmKzV1ekpz?=
 =?utf-8?B?SG9lRXVibXNlS1gwV1owUlNVTXhSZGptaklBeGR5bXVmRklnbzdxTHdZN3By?=
 =?utf-8?B?MmMwa0c3NzlyYjJUdW1mc2RCYlluY25zRmhvZjNmVTBZVnA3dVF1a2gvTjcz?=
 =?utf-8?B?SWZyVzNDa0xic05iOW1Va2lsNzlJeDlwdnpENHNZWFg0Y01jdW8zR2VRVUt2?=
 =?utf-8?B?YWxkRkNQNkZuUUtEdzNDdkQyOGdvRTY3WEdYZjBMMG4veXphZ0hMbTMzdlFC?=
 =?utf-8?B?L2liZWlNZ21kcG9wR1lEb3JEZTVTbTU3TkFKVHlWQ3VTbUx6dXR2MURZT1ZT?=
 =?utf-8?B?OTdob1VIb3R3R2JxaEY1cnNud1VWb1k0elVQblZCb2tubkxpUlBoUVhudEt6?=
 =?utf-8?B?ekd3T1dOZ0pQaFV1SFNIVUMrMzdzazBuVllIdnVQYnBxWEZJRExDNGgxeFJR?=
 =?utf-8?B?TmplR3NhanFaN2dsaE9ScTlZaXJRWmdWTDlSRkU3RU5pZ3hxdVlwKzBKU09C?=
 =?utf-8?B?b3F5czhGM05qVnhiVksrVW9kZlQ2UWZ3R3ZiL3luK05PdDg0YzRJSWtLcWRH?=
 =?utf-8?B?ZTljZHhGOWlsUzcyMkRnWTIwZ0VWbkFVbzJSQm5Yd1RyU2I0SlEwdWY0amls?=
 =?utf-8?B?bk4zZkc3Nm8xNXFxdzFEWXh4aUpIR1g0VDZ5alZjdTVweFFQTklLTGJtaGQx?=
 =?utf-8?B?dEtGNUxTZmRoZ1JoWXVIcWZwQ21FeDlhMWl2SU5QZVBndTJGY1JyT0thZkpk?=
 =?utf-8?B?dkdwRTZFUkM4UWRKQUkyT3M3aVFJdEs2VFpld2dxbjlSL0FnMVBQT0lvdTRH?=
 =?utf-8?B?Z2gydkk1aWhVOE9Hd0FZSEV5YjhEZkxPMTArUEhPNEtTZFM3Q01jZStrblB0?=
 =?utf-8?B?ZFV3SXlUcjcydFJVNFJYakFWaG9aRzR5cWdJQ2F5ZFVsTTVBL0RvdDJ2ZVV1?=
 =?utf-8?B?UldnMjhpL05lOVpEMldxQ0t4SmZpYW1NQ2xCeWhGUEE1NVpZd1JGenZGT3E2?=
 =?utf-8?B?c1BkRjZUbFVWTFhYcXgrQlQ5cUpBbE42d3pPQ0IxU2J6d01aNDdFVERNLzdE?=
 =?utf-8?B?OTZ0ODZHMWxlMVRrb0djN0ZXNHJURkJIMERyK1dob0JFdXQvc0FaVCtVam9I?=
 =?utf-8?B?M09kZWJmZzlmTUVMZktRVzBvQlBFWGhtK0pFVjFEKzlVc1lWNmNWRXNJSVVF?=
 =?utf-8?B?b3d4cURiaE1FaU1DcmplM0N5M3c2WWJnRkVYR1ltWXRuMjB0L3pIYU9uUzRw?=
 =?utf-8?B?OW5UVXlCMU9HaGU5YmhyR2pianA4YnoyUWhMWHg0aEZyRUJhYWJrRlpBSi9y?=
 =?utf-8?B?Sk5odEE1YlJ0ZU1OL0srQk92N1R2UGsvTHphcmd0RzFmNktvQks0eFd3dHlp?=
 =?utf-8?B?bDV2WDFndW1nQ2YzL3BCSzVnbTN5UFhXRFRBR1VHa2xOUnFaOGJuNUZybG5D?=
 =?utf-8?B?RHJNSHNBSWRsM2FPYVV6cERxL05LZzVvN1VJQTJOV2dUaXpVMTYrSGRuQ3Ny?=
 =?utf-8?B?ODZJODhjeVMzM1JyV09Qb2tJN200WXh4bzJHY0piSGNGOXc0cnNteTdPVWps?=
 =?utf-8?B?QlB6R1d1ZTE3R2NsdmlvZUxpQzR4QXJtTjlXTGNpWlVWQlVDVHBxc2lvTk1Z?=
 =?utf-8?Q?rjXmsm9ajbArMscdcDytLLRR4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49cf02a0-ceb4-4128-dd7c-08dc7537ce96
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 23:36:13.1221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WugoA3aiqRaO/tPYiooqnsMtt3y5yj4+CSOdt97k/DSBjphwBNi2whEphfNuqfYtFGP68XVr4yhY5DJ8SiIj3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7562
X-OriginatorOrg: intel.com



On 16/05/2024 11:20 am, Sean Christopherson wrote:
> On Thu, May 16, 2024, Kai Huang wrote:
>>>> You had said up the thread, why not opt all non-normal VMs into the new
>>>> behavior. It will work great for TDX. But why do SEV and others want this
>>>> automatically?
>>>
>>> Because I want flexibility in KVM, i.e. I want to take the opportunity to try and
>>> break away from KVM's godawful ABI.  It might be a pipe dream, as keying off the
>>> VM type obviously has similar risks to giving userspace a memslot flag.  The one
>>> sliver of hope is that the VM types really are quite new (though less so for SEV
>>> and SEV-ES), whereas a memslot flag would be easily applied to existing VMs.
>>
>> Btw, does the "zap-leaf-only" approach always have better performance,
>> assuming we have to hold MMU write lock for that?
> 
> I highly doubt it, especially given how much the TDP MMU can now do with mmu_lock
> held for read.
> 
>> Consider a huge memslot being deleted/moved.
>>
>> If we can always have a better performance for "zap-leaf-only", then instead
>> of letting userspace to opt-in this feature, we perhaps can do the opposite:
>>
>> We always do the "zap-leaf-only" in KVM, but add a quirk for the VMs that
>> userspace know can have such bug and apply this quirk.
> 
> Hmm, a quirk isn't a bad idea.  It suffers the same problems as a memslot flag,
> i.e. who knows when it's safe to disable the quirk, but I would hope userspace
> would be much, much cautious about disabling a quirk that comes with a massive
> disclaimer.
> 
> Though I suspect Paolo will shoot this down too ;-)

The quirk only works based on the assumption that userspace _exactly_ 
knows what kinda VMs will have this bug.

But as mentioned above, the first step is we need to convince ourselves 
that doing "zap-leaf-only" by default is the right thing to do.

:-)

