Return-Path: <kvm+bounces-17706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3666F8C8C2E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 20:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 545AE1C21FA6
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C7613DDD3;
	Fri, 17 May 2024 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwODiB7u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615411FC8;
	Fri, 17 May 2024 18:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715969801; cv=fail; b=XC+BOKihNrHdX4Im80uTA5oNRpMTJaXQHLhNWWY73hfLBx8EaBH0+Y88YQoZ3hidnmEz9v8PeUalxR/tCowTXpv9aPIvki07uJcbdo9zSSsM7LacsXwpx5W+rCyrOJRk5lRrjJ2wRf3Q9g7ygBrx8vDcK1AMk3Q16oTnS+Se+8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715969801; c=relaxed/simple;
	bh=iNs/DVPNaW+SNZf8EL9DLqcvboyzWSBfuP6z8Bay/oE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qmqHFiGugiQ5JToZhsI1OSOjRA6fZyZOdgdImdN7bk4HDxk2zw7tDxstIn+3CenvP/hlmRk4r+qKdN4evnd65suJzzwmpMRVKwfWe5kAUQ+vuXoVjTceoa7D27ycDiaRmCVW0H3dseXJz99f1+NBBkr9oTtv3EiXdKkYWPt0jm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwODiB7u; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715969799; x=1747505799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iNs/DVPNaW+SNZf8EL9DLqcvboyzWSBfuP6z8Bay/oE=;
  b=SwODiB7uzBKl6N/a2Rtz5pILC0goSSBqoj6F8pGAhE6dfJReYqHH1ReT
   tXJR7w9MWhgY+1LlhGVoHZB7AGk6enlqWWg+gE5s5c5PLvVSJJphq8ISX
   +lxhrktFwgVtVuH0j8USQiQAyXqfbv2uedjpAtaIxjo/LtmES5MrVcMkc
   Qvk4u+iYsU/3zFskIltL1FSxXfF/NVbJGIGJiWl0FptzNZDY1883KtJfc
   y0S0IDCMCgQJjvtIBlHfGL/VQmRT6ASOnOMwReF/9lLMNYA0z9mXB+QR4
   txMc5cgTeTFy7PgfA3lW1CYuHMgHxwMofXRRHHaViZOypEH7AQ4RLAI91
   g==;
X-CSE-ConnectionGUID: ayYAeun/QSWj9QqhefmohQ==
X-CSE-MsgGUID: 7n2DmDriSwmDVmn5arh08Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12276179"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12276179"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 11:16:39 -0700
X-CSE-ConnectionGUID: s+dbKxLdTE26dAY69XdFyQ==
X-CSE-MsgGUID: kqw6Tei4ThaNpN4cd0EE6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31892883"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 11:16:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 11:16:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 11:16:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 11:16:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Py0qZ24X+olrc7lbsUukiW7RHVANc0PvAV5BKvzVpFVfhI/2LI+ArNEIlIEnIomRVUk5sasaCQdLleoFmeu3QlqPqh+1vtbYrWgGMsdPDwDvn6mUPLkAjy5JtPQfvEoMp12Q/srFjTitMe734ltjXS5MBG+cAvoambsEDKhbPkT+f1HVJA/XHjJvFq/YwNhjY1vzVq9QX3pE0Qit3VE2O4xkc84AvGp/ou9lMBv/oLfwacECrad9Hkb2PFpBzXIzUr7J9Ycb3PTTcuHjRiRsx0y2hCR+PoJpj+omj64dTQHc2hwd9JkjMBwqqWthxmlv3dtajTEi9w2pYyLaWtKFDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNs/DVPNaW+SNZf8EL9DLqcvboyzWSBfuP6z8Bay/oE=;
 b=I7GWFA6PssVGoN2r4dfEf6J0tDnfsh3IbmMpAr65nAbZc1LfgPVSLMXhFEo67UNrkKdvlTcRfnaDX0+SzJcLgPTLzL6Iy/W53eYoN3N2G2o6qCbuxuQpGB7tpgiaiy38gyMJTg1NGM0cuXYGITxp27scKzby7F8AZjqEG/iA8BrDXIpGjMBtPAiMH6KstZVh9/3AeT083cRfItp3lQGlVLqpyU9eunlsTdolwJI0UBJPw4Z1iiRCAu64S04WbyjQRolNvvH4tduw7PfMCs1cMVG9IfY7y2Rok7G1QCZUTqzEcZe/YyqtZEUYozWfrXRTOD0g5JIGmpjL+a6vdZXakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6723.namprd11.prod.outlook.com (2603:10b6:510:1af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Fri, 17 May
 2024 18:16:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 18:16:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaA
Date: Fri, 17 May 2024 18:16:26 +0000
Message-ID: <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
	 <20240517090348.GN168153@ls.amr.corp.intel.com>
In-Reply-To: <20240517090348.GN168153@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6723:EE_
x-ms-office365-filtering-correlation-id: 70a4d8f8-eb7c-4671-3d66-08dc769d7734
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TjRYa0Q5bVE3dXBZNHkrQVVROW5LQzhoTWFkQ00xZXJCMXY1TUFhaG5vdGx0?=
 =?utf-8?B?V0lnSlBjVy9qeDZaU29vNytWY2FKeldJd3NFV3hUaWkyVXVSczFGbHFZbitX?=
 =?utf-8?B?R3B4M0xCYzQ2dHFiWlo1elN4N1BUdkdRY3NtL2NhZStGb1N4TzRUaXJYU2VR?=
 =?utf-8?B?VUtjc2h5N2tuQmptcXdDT28waE84aXFYUjdkSWhPalo2OTY5R2I4VDRwOG5t?=
 =?utf-8?B?VzRGa0t0cTYzUlgyQ0ZFTEU4UUpxcWhzdFZ3aFl2cTc1N3lrQzBIeC9LQzMy?=
 =?utf-8?B?NkU2dE5tMkUxSVFacVREaUpCWkp6dDVGZWVwSEx6S1J2VVdQVHlkZTlOVFQ3?=
 =?utf-8?B?VkRBanlOa2pVc0lCVkNqRTZUeWNJeXp3eEIrN1BPdnhyY2VHVDRoTUx1bVA0?=
 =?utf-8?B?SzZNUmZIZHhiWlEzK3hWRXFrQmhtbFVkR1NzOGJQaUQrMlF2TklNMUFPOVJJ?=
 =?utf-8?B?c21qL0kvL3BHY0NuQXdPUVNlZThLYzlWTEsxN2N6cFFsZ2x6amd0UVN0emc4?=
 =?utf-8?B?Ry9MK1FhbkJSS0h2bXRlQVFjNWc1UzM1ZmhxejY2Vk9MU0kzTVJhenlKc3RB?=
 =?utf-8?B?eVdRSXgvbURFQXNicG9DQVFicitOMnVPbTNFTmJUemRKdFdiVHNsVEtoRmtU?=
 =?utf-8?B?dTdqd2JISlYzV2wrcjdPTG0wV2l0Wng2OUlJd0lXV0lzOFhJSTZSaXlMOHZ5?=
 =?utf-8?B?aHZQQkx6ZTV0ek1CbkNkc3ZYTHFhb1hCdVcwOEZuZFdYQk9uL1Njbm1MZTJp?=
 =?utf-8?B?OTNETERia3B5WHc1MTRPOUwxWmsrK1M4SkQzaFkvbWJnSi8ydUhjb2JnVE9w?=
 =?utf-8?B?ckNjYjUvT1FDdkdzaVlPSkFGL3pJT1RVUm9nU2lKbHZHM0JOa1M1VU44ZG1s?=
 =?utf-8?B?NWxGby9DVk9iQ1kzckp4TisyUFMvWHRWUnJMK1N1M3YxYzNCc28rQ0tQRmFW?=
 =?utf-8?B?WWlJc0FDNVNscURqTE9LY1YwL1dxTFhySktNeWVxWGUrZHlab05lWlcvNm1X?=
 =?utf-8?B?S283VkhPUmRLZXNvSzBJQWNxWWZlNFJLcVFsWHlZUno4U0d6Tk93WmtNOHVy?=
 =?utf-8?B?U3Q5UEM4anRyMXhTYVNMSlZ0RktEV1FOOXorTmcrQ3JidUhNZmRuSkthd2hv?=
 =?utf-8?B?OW9qa2ZVM0NWS2YwU3V0UW00V04wQ1h2Y1Z1QWFnTjgzK09oQjV1R0RxdmNN?=
 =?utf-8?B?Nkw3R1NZYnd1M1FtUmp6NzA2MXpyRU8zaXk3K21vKzRRRTdtRGJ6YlptSkpK?=
 =?utf-8?B?UTkxbEpERTVJR2QzcXU3VE50WVVBWUs3OHJhZENzMXNKK1JVdktiTG10VE95?=
 =?utf-8?B?M2RvU1M5WHdQLzdKWk4zdjZ6d2Nva1lZL1ZnTEdaQlp0OVlyNXFjeHVtS05F?=
 =?utf-8?B?MnhDOVp3RHN6Uk4wM3JlRU9NNnJVY2hCWDdoc2tHL0s3WGpUMmRCQk9nemNR?=
 =?utf-8?B?VjlLRUoxNzd1ZGVwUXJlcjJ2QW52MUlZSkYxcW5xdENMSXNTK3hJbXA0VCtI?=
 =?utf-8?B?T0wyNEJHMW52QnlsN3UzdUJoc21XMFZBZjZoUUp2U2Q0TXpXZ2pqRjBVQ3FM?=
 =?utf-8?B?bzhPRmRxdkJhOHdjUVhVT1hjZ3R1UWZ6dk84SUJ2NWh6TGtZSUJ3NmRkTG5L?=
 =?utf-8?B?WElqS3kvQ3NwNTdOUUwrNy9nejlNalZSZWFoKzdpZElwcVl6eTQzUjNrMlFT?=
 =?utf-8?B?NnZzVS82c2lMaGxqRTQrS0crWnV3NWRHTmN1cXE0Z0J0cFNUbVl3cUlRZzJU?=
 =?utf-8?B?Ri93WEJxS1ZIVkRZNGJxZnhqVktDWm9URzFLdWNVaE04U1JDQStnUW9SQ2NR?=
 =?utf-8?B?ODRzdTV0N0NZSXk1L0hsQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NytKdGdOZ2RIZm50bzJkNTB3RjlIK1BpcVhZbm9VSWFESHBaV3Q4c2ZSbDN3?=
 =?utf-8?B?RWQ1ZThyamwxREh1U2lFQTlEZHREVkhQOUV0aTlKbTMxY2kyTE4rT2VtU3lZ?=
 =?utf-8?B?TGtPTWhraEVFZFQ5KzdKbENiVE1SOEZTZVRLMnd4VXM4YUg5bENXWm9rSXUr?=
 =?utf-8?B?RXFrbXdiWWdsNndaM2NuSTlJRFZXZW1hNkNkbkFzM2F4RlhYeXhZT3ZrcEdV?=
 =?utf-8?B?Rkh4TTBaeE1hZkY4azZrbUFXOUFuekN1WEllbWxXM3daYmRnb3piOHFGSjdG?=
 =?utf-8?B?VGJXd2JoL0cveVc1R3V2ZUVERlN2bmRFaFp3eWNWT1Z0dHRXQW5tVzRsaC9y?=
 =?utf-8?B?cGJYUlpzZWp0eTkybFd6Y1FtdFFPMktxdUdTcjZHOU44Smp1SUZpTDdCOXlQ?=
 =?utf-8?B?L0RPdFI4TnFWZ0ljSlBOZzRhZThTNWR3VlJkN3pxU0xvZjJpa2tGNU9Fd1V0?=
 =?utf-8?B?UTRtYXFUdDF0Ni8yMktKSnQrN2FFUmlSZ0dYSFFKSjU0MVFFbG1tc2NXcnJS?=
 =?utf-8?B?c05DRHlOc3VEajJmK25NTWk2N2dQZ2I2a0NEVkhINVVmR1VWVVdzSHNXMU56?=
 =?utf-8?B?RmFKY0RON0xjTFp6MFg0Z0RVbmxZYWtZVlRLY2tkcVFyK2orU09VSWtadk5k?=
 =?utf-8?B?QTQxMWM1a2NMbXJMRG85ME95bTBSMTZPWEI1bzNSTmFmVmhOTnpaK1hIWjc4?=
 =?utf-8?B?TjRvTlNWaS9WRUxweG5LRTJDU0dVMGI3blBSUTJhakN5dlhLcGZUK3pFZjli?=
 =?utf-8?B?c1JzME5ZanZzZGdXM2ZxOVUyTEtpWlpSU1p1SDRYVnVNSnR6WUFOLzdLUzRN?=
 =?utf-8?B?MktaS2JCWXNwVFNDenJMSHNldzdnUFRBYkEzam9BeWpKWHRVc3dMYkd6dERt?=
 =?utf-8?B?cFphTDZPVjVhYkpaVkttZ2VQWGplakdmN05HOFpwK0crM0NFZ2JPTEpNYzcr?=
 =?utf-8?B?TEcwMGd6UWQxQ01nMmd4cCtpVVVabXliRm5QSGxjVC9YM1VXTW5VbVBHR3NG?=
 =?utf-8?B?dktieVhlTElxWXRqa1NPSGxQNTVlS1Y5NmpTZTF3cTdiUVJaU0Evc1pLMWlB?=
 =?utf-8?B?VVF3eFMzWjlFdjIyZTFkQ2xvMitaSFhDWURTZUhmZVlqV2ZZYnJrWlY5bXN2?=
 =?utf-8?B?aVRzbG93SUdNNzdVM1l1cVRFQzA3VHh3ZG1keFJSZ0cyL2xPZGY0eWJYUEZa?=
 =?utf-8?B?bWJ5M1RWM2pKbEVwWEpvSXloZkVxT2MzOERZOTY0azZ6dG96dWxXdDR0d2JO?=
 =?utf-8?B?aEVPSXIzUTZ2aFdya2NhZ0xWcjZZeTJmaDB4SWFSZUtOMnlTak52VTNZYXRG?=
 =?utf-8?B?TlFKY3J6V3pJVnNmQ1B3S3hMRDNMeExlaCsxbWFGbWF3NDdjYVYyRUoyOWYw?=
 =?utf-8?B?V2s0VmkyenZGcGs5TUV1cVVSNitLSVdhK052Rms3L3BJVEp0eGdUeDlROXFl?=
 =?utf-8?B?Snl0clhNcThZeUMyd0gwWW5mK0kxbU5oMW1ZQXpPcFVMOWxzRTZ6ZjNYVU1P?=
 =?utf-8?B?NmtCYTBPcTVZYmt6OUo2aG8yb2RuUFp3c3N5T3cxYXBVU2N4SjlvYjVvNkJG?=
 =?utf-8?B?T1dvOTJ1djJpVkIwQUpsRVc0UkhYRnhHWEUzNnRrdGw4Q29GUTRnZkk5VjRV?=
 =?utf-8?B?SDNoN0QxOHRtblIremd1OXFJOEMvdFM0RHZsR1ZGMzRNeVg1RmpCZDI4aVRF?=
 =?utf-8?B?aGhvS0czU3Z6ZnlXbSt0S2ZHQm9PbEVtYm5VcE1MZitWd1BRQ0VCQ1RFQ2NK?=
 =?utf-8?B?NFlqUGVmcmtLZzcyd3hqZXMyd2J3ck9IOGZTUHVZbU5TTTJKQlFjZXlLUzly?=
 =?utf-8?B?VWx4emhhV3hoWTBOYlMram9yZTZSblhBUGZGdDVvellBRDlJU2p1cjZDTFpV?=
 =?utf-8?B?RG0zdjd3YzNtK2U5ZTI3RzhxM09MR3dXRjZtNHkzQkRRZ1JYcXJzZzdIL01D?=
 =?utf-8?B?M3M4WUltUGFqVFpRbG51TmdNWHpWb0ZrMlE5emF1K08wV2RoTUF3SXhQQkZF?=
 =?utf-8?B?ckUybkp4M1Exc2xOR2xza2NTOFBiSWloWnp0VXpZa1ptVElXQWJ4Wm1OcnpS?=
 =?utf-8?B?aCtZYTUxSnpySXI4OTRiUG1JSDIyVmQySDc5bjVEQnVVc0JLTCt3Wi82VUsx?=
 =?utf-8?B?cmpidys1cWdnZHgxYzhlcGhmd0VNeGVidUlQSmMvaVVmOGpxRzhiMDRRUm5M?=
 =?utf-8?Q?lcTLbYi5SsqtdQVamNOeJFo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95EA86DF659DE44D8E62417B29860227@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a4d8f8-eb7c-4671-3d66-08dc769d7734
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 18:16:26.1122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: soJ5LmvaSBD/IiX2qjVLccFPrdRHY9/DffE/b53Y64vslk/OjqmAe8BTy8PnC4w+kVJkYVqyVdHqv2A0AEcgRoyyK5TNSZmOrll6fQkpbeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6723
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTE3IGF0IDAyOjAzIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gDQo+IE9uIHRvcCBvZiB5b3VyIHBhdGNoLCBJIGNyZWF0ZWQgdGhlIGZvbGxvd2luZyBwYXRj
aCB0byByZW1vdmUNCj4ga3ZtX2dmbl9mb3Jfcm9vdCgpLg0KPiBBbHRob3VnaCBJIGhhdmVuJ3Qg
dGVzdGVkIGl0IHlldCwgSSB0aGluayB0aGUgZm9sbG93aW5nIHNob3dzIG15IGlkZWEuDQo+IA0K
PiAtIEFkZCBnZm5fc2hhcmVkX21hc2sgdG8gc3RydWN0IHRkcF9pdGVyLg0KPiAtIFVzZSBpdGVy
Lmdmbl9zaGFyZWRfbWFzayB0byBkZXRlcm1pbmUgdGhlIHN0YXJ0aW5nIHNwdGVwIGluIHRoZSBy
b290Lg0KPiAtIFJlbW92ZSBrdm1fZ2ZuX2Zvcl9yb290KCkNCg0KSSBpbnZlc3RpZ2F0ZWQgaXQu
DQoNCkFmdGVyIHRoaXMsIGdmbl90J3MgbmV2ZXIgaGF2ZSBzaGFyZWQgYml0LiBJdCdzIGEgc2lt
cGxlIHJ1bGUuIFRoZSBNTVUgbW9zdGx5DQp0aGlua3MgaXQncyBvcGVyYXRpbmcgb24gYSBzaGFy
ZWQgcm9vdCB0aGF0IGlzIG1hcHBlZCBhdCB0aGUgbm9ybWFsIEdGTi4gT25seQ0KdGhlIGl0ZXJh
dG9yIGtub3dzIHRoYXQgdGhlIHNoYXJlZCBQVEVzIGFyZSBhY3R1YWxseSBpbiBhIGRpZmZlcmVu
dCBsb2NhdGlvbi4NCg0KVGhlcmUgYXJlIHNvbWUgbmVnYXRpdmUgc2lkZSBlZmZlY3RzOg0KMS4g
VGhlIHN0cnVjdCBrdm1fbW11X3BhZ2UncyBnZm4gZG9lc24ndCBtYXRjaCBpdCdzIGFjdHVhbCBt
YXBwaW5nIGFueW1vcmUuDQoyLiBBcyBhIHJlc3VsdCBvZiBhYm92ZSwgdGhlIGNvZGUgdGhhdCBm
bHVzaGVzIFRMQnMgZm9yIGEgc3BlY2lmaWMgR0ZOIHdpbGwgYmUNCmNvbmZ1c2VkLiBJdCB3b24n
dCBmdW5jdGlvbmFsbHkgbWF0dGVyIGZvciBURFgsIGp1c3QgbG9vayBidWdneSB0byBzZWUgZmx1
c2hpbmcNCmNvZGUgY2FsbGVkIHdpdGggdGhlIHdyb25nIGdmbi4NCjMuIEEgbG90IG9mIHRyYWNl
cG9pbnRzIG5vIGxvbmdlciBoYXZlIHRoZSAicmVhbCIgZ2ZuDQo0LiBtbWlvIHNwdGUgZG9lc24n
dCBoYXZlIHRoZSBzaGFyZWQgYml0LCBhcyBwcmV2aW91cyAobm8gZWZmZWN0KQ0KNS4gU29tZSB6
YXBwaW5nIGNvZGUgKF9fdGRwX21tdV96YXBfcm9vdCgpLCB0ZHBfbW11X3phcF9sZWFmcygpKSBp
bnRlbmRzIHRvDQphY3R1YWxseSBvcGVyYXRpbmcgb24gdGhlIHJhd19nZm4uIEl0IHdhbnRzIHRv
IGl0ZXJhdGUgdGhlIHdob2xlIEVQVCwgc28gaXQgZ29lcw0KZnJvbSAwIHRvIHRkcF9tbXVfbWF4
X2dmbl9leGNsdXNpdmUoKS4gU28gbm93IGZvciBtaXJyb3JlZCBpdCBkb2VzLCBidXQgZm9yDQpz
aGFyZWQgaXQgb25seSBjb3ZlcnMgdGhlIHNoYXJlZCByYW5nZS4gQmFzaWNhbGx5IGt2bV9tbXVf
bWF4X2dmbigpIGlzIHdyb25nIGlmDQp3ZSBwcmV0ZW5kIHNoYXJlZCBHRk5zIGFyZSBqdXN0IHN0
cmFuZ2VseSBtYXBwZWQgbm9ybWFsIEdGTnMuIE1heWJlIHdlIGNvdWxkDQpqdXN0IGZpeCB0aGlz
IHVwIHRvIHJlcG9ydCBiYXNlZCBvbiBHUEFXIGZvciBURFg/IEZlZWxzIHdyb25nLg0KDQpPbiB0
aGUgcG9zaXRpdmUgZWZmZWN0cyBzaWRlOg0KMS4gVGhlcmUgaXMgY29kZSB0aGF0IHBhc3NlcyBz
cC0+Z2ZuIGludG8gdGhpbmdzIHRoYXQgaXQgc2hvdWxkbid0IChpZiBpdCBoYXMNCnNoYXJlZCBi
aXRzKSBsaWtlIG1lbXNsb3QgbG9va3Vwcy4NCjIuIEFsc28gY29kZSB0aGF0IHBhc3NlcyBpdGVy
LmdmbiBpbnRvIHRoaW5ncyBpdCBzaG91bGRuJ3QgbGlrZQ0Ka3ZtX21tdV9tYXhfbWFwcGluZ19s
ZXZlbCgpLg0KDQpUaGVzZSBwbGFjZXMgYXJlIG5vdCBjYWxsZWQgYnkgVERYLCBidXQgaWYgeW91
IGtub3cgdGhhdCBnZm4ncyBtaWdodCBpbmNsdWRlDQpzaGFyZWQgYml0cywgdGhlbiB0aGF0IGNv
ZGUgbG9va3MgYnVnZ3kuDQoNCkkgdGhpbmsgdGhlIHNvbHV0aW9uIGluIHRoZSBkaWZmIGlzIG1v
cmUgZWxlZ2FudCB0aGVuIGJlZm9yZSwgYmVjYXVzZSBpdCBoaWRlcw0Kd2hhdCBpcyByZWFsbHkg
Z29pbmcgb24gd2l0aCB0aGUgc2hhcmVkIHJvb3QuIFRoYXQgaXMgYm90aCBnb29kIGFuZCBiYWQu
IENhbiB3ZQ0KYWNjZXB0IHRoZSBkb3duc2lkZXM/DQo=

