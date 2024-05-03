Return-Path: <kvm+bounces-16462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1BC8BA465
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DB521C22362
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB381C36;
	Fri,  3 May 2024 00:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/NtIxYA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A3193;
	Fri,  3 May 2024 00:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714695164; cv=fail; b=crud5zWhfh/6hahoTMetWHxO9lZg7RYNGQlukALRr7YHvlgD0kQftbZ5ShU2TlRLY0Kvweg0ePwQvfeDJAjEl5fJ/BEpXurQ16B3enX8vbuK0oyqlNvdU7rl8SIDKw/YlwXfDIauoWN5vGBdeBPafzfcjysVBAaKYlJEgZjWyF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714695164; c=relaxed/simple;
	bh=0f/CO90OMgkwd4apPkjBjUEUSBorIUxzMBlRInBRO7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ei0KQkSF8S5nG7oawu8/4yOw+L4ymJNoq8dqebugrACUKwpm/ji5+indRZl4Bp4/xJEjyR0oeazMXo5+3FDU7dRiNQ1jyT/8rFlRGXwtsbBi24hguwELZN5w3oN6jAJnFtiqLN13eF4A9UZEyW4xsAbhzeeYOGI/DHjOmz8noIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/NtIxYA; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714695162; x=1746231162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0f/CO90OMgkwd4apPkjBjUEUSBorIUxzMBlRInBRO7U=;
  b=d/NtIxYAOi690GGyUVPnCc1NN5YcdeUK1dFJhYZ8IUZybQsUKaGqf6kz
   0x+RtzL612ESQvFLuIRczk/hB9FhwkUP4c6CpQ+UY4XAbpaz57YQzvQb/
   sqA0xlSxwNIlq62kgyhx7tk+U7pHN3XBD/FSIIgwZ4vHTXYLtW610ZpUP
   fm+Mk+l3xczifkkVldKiRESP4U48NwN4s5fbHogTSWD34Oyhu427erTM4
   F3t2owGOmrymnjgl/THHaARf0k6BEFFwkjRAE1NLwKfuSA3Am5VGi5vJK
   hGDYZclu/TJwATfXYBHkMVS8s7mRoxaXHD5R9I10pscHH4W5vDKhNJ3ov
   A==;
X-CSE-ConnectionGUID: iiJdbQ/ZQ8+7EnZOArmN3Q==
X-CSE-MsgGUID: BMO3zgnwQQuLRtUFwGjAcA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10625764"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="10625764"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:12:42 -0700
X-CSE-ConnectionGUID: IEfPD6YgQOyhe8cJldFyTw==
X-CSE-MsgGUID: WJuSSHqORaa1hsin8X3AcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="31969372"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:12:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:12:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:12:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:12:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:12:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiTy6BWBjVXg1NSAzOqJ8ZnuLgKIvxmMfMLoojBmashLKVWcjOieB0F3hF0j+5xqWs0sBPdMqBxgkYj3Orx4Scfcr3NREhm8nMuXWDrG/SjpLvQvANBYf4b6dyWr7BiboQc7M5KTSMEAgsRmbp9xWUwDDSKM9zoUzW8xW12PvJiKeUKRA5WloanAiI3N0HH1uZK94sjpqlwpYkWUwc5ibag4ucEaaotGawZ5tDuxOxFnVHVkScLsQf8D0Nrn+coHeJxA8s0WTKb1+IdQZIXnL/ZSUohprgV2mAxcETMOJLw51FPaaz9BkRRaHdnj/hoVIs5liMt01/gfGPnfR6WIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0f/CO90OMgkwd4apPkjBjUEUSBorIUxzMBlRInBRO7U=;
 b=PMtkkhM7foiaPJQ26ZdlMUSKFhiPvZISslp9VnoH/AElYX7qc+aoi+oAFharxriy7PbYVC0oFtncNNVD57mbRmC1Oy6rhxkpNlLD9L2OfDiI0lBMvmQ35AlwoKlxw0hYMtVyBslko1IJLJE2CFs6n8joxJOLf/CNolrsyroFl+MXQNy3u8Rv7g6xFwaD3ID4/wHBetc//24yb5zcNNsl1IjHZOj2RHukDHBmhLII2tg/sNZGDppsZ14vGElNsaX/Jytw1E4HfUEWGvkT57xjgtcJ6rEaAAtBbmP1Y3lbZyoSmnT5DOJdkXPGzdlO7y1/E1upZQzIPug6NxpW4+n3aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8520.namprd11.prod.outlook.com (2603:10b6:610:1af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Fri, 3 May
 2024 00:12:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 00:12:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHanO1KbxcU5bsJu0u2fcnRk1NAs7GEo1kA
Date: Fri, 3 May 2024 00:12:37 +0000
Message-ID: <ebc3ef050ce889980c46275dac9eb21ab7289b8a.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <393931ee1d8f0dfb199b3e81aa660f2af0351129.1709288433.git.kai.huang@intel.com>
In-Reply-To: <393931ee1d8f0dfb199b3e81aa660f2af0351129.1709288433.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8520:EE_
x-ms-office365-filtering-correlation-id: f6e6094b-3ec0-4f56-6aba-08dc6b05bd1d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VllTWDIwNnFnNDVQMXRiM0hKaDVFNzY0NEM0UExReng0RGY3aW9zSndPcGVj?=
 =?utf-8?B?NW1qWExZM0xPTzVDcnRHTFEwZEo2NFhjV0RnakFTcnhGSEtOSFQ2cXBCL3lY?=
 =?utf-8?B?OGltbEhoSEh6RFdJYVozVW9Db2oxOVc3MkxPNEJOWmRsRDZvY1N0SWhnZW9m?=
 =?utf-8?B?Z3AzS1pZbEZtZzZ0UE5QZHNyREV2MXp5RHVYazZ2T3JSUkllMW5zZlBBeGh4?=
 =?utf-8?B?RGdNMEpsUW9INmluVUhEMS91eEF5dUdXTUNxdGNkcmNWOGdXZ3FlUUt3NjQ1?=
 =?utf-8?B?dUNmc3lyWVFQMXFFd05VMFFjNTlaMWlWN2g4MVBaNG84RngxSTd1TG1CTlRv?=
 =?utf-8?B?Zm16VUdMRTJFUXZ2RGdxOW5qNndkMXBHRlZOeTQvK3hxVml4WUxpUlF5ZWF5?=
 =?utf-8?B?dDZ0ZVBDVmhEU1RpYm1FdGZreW9YQTNWcFBwUTYxZkpxYjQ5cWovbG16bWxk?=
 =?utf-8?B?QVJlTVhpcGtwWjV6YXJ6NmxZdnI3WFJGSTZ2RWZSY3ZHNnFXV3YxcVBVcXdY?=
 =?utf-8?B?YldaQlJadk9MRG9vWmtXVFRDekFHYndBa1NNZ21Bb3QyZGRNZG1vRGUrZ2V6?=
 =?utf-8?B?RldwRzRtc1c1Y2lqVzBCSFZaUExDTjhIUmJKZlQxKzFNaGlBaWhTaDVCZExo?=
 =?utf-8?B?ODRIRUU1enVyYVFxaDFnMTdzVVowYTRFS2MvZm5sS3E4VE5RVzZocm9KZ01t?=
 =?utf-8?B?d01VTjhyYU9vWFYzVWFVeWVvdXNFWDJUV0E4NWx0U1NSaE9tMkc0UTY4ZkZZ?=
 =?utf-8?B?YityaGorZExFT0N1TTBsWmgvTm5YMWVrU0pkU2V2WVhJMkQzYTlxT1lVMGlK?=
 =?utf-8?B?Ujc5YnNVWHBrYU00TUFyenBsZGdhbU9BTUxvU3NSSXJHQ0dBbkdqRzQ2VVp4?=
 =?utf-8?B?dk9wMERIb0o4YmNmT29TN0RDNjZlZEpyVU5YZFNyakFLZE1lTGpxVHhCZllv?=
 =?utf-8?B?QURrNGwwbm4zZkxvamx2bUtHV1hvNHRKMXNObHVkTmYwTHFNc0dpaUJZZmFR?=
 =?utf-8?B?aXAzVTdCOW91VEs2dVZYaFR0ZmtxdkwxamVsU2NyWm9ZM001K0ZMNE4zR2o4?=
 =?utf-8?B?UjBGNjgwSFNpNE1rSUlTZU51c2k3VDVUeTkrYitaZVdiY0FRWW1mNHFLVXJo?=
 =?utf-8?B?aDdwZmx6NEF0UmhiM2RIVUtOMFRvM2paZ2gyZEVqLytzMlJhRHV5RjY3dnY4?=
 =?utf-8?B?aTlqS2pzbmtFc1ZITmNwZ1RPemkzVUhiNjdnajV2RXQzMVFJMGpuS1ZoYnUx?=
 =?utf-8?B?UE1KWDBYTDBSOWdUaUJEdUZXTk9GWXV4akNPZ1g3WVFXcUdSTFFneFVNUEFH?=
 =?utf-8?B?RnhxSGVEZkRscEtTbmxZdmNqbTJRTzc5RmJSNGlwUHJPajhjalBzSUF3dk9L?=
 =?utf-8?B?RzZwbm5MYUpHNm92RUlFMXBhZEUzYno5bWdoREFCZnU0NkdMZXZPeFRhaWth?=
 =?utf-8?B?ckQ3ZENoZ3VNeHI3VUd4VWN6andiM014NXA5c1NUR1ZIUHgrcWJKbmRtMytx?=
 =?utf-8?B?T3dXRjgvMmVXdjB0SlV2clh5b2NKbUhwQkxySlhCUHhiMTU2K1ZNQ0JoOERB?=
 =?utf-8?B?R0JJaE1iRm1SSGx2Qll5VEdKOWwyWU5od0tHcWRHTzhXTGRXZWdWczdibFlY?=
 =?utf-8?B?cWUwY1NsOC9OYUtCaU9QNEVFMzlxTTRLODhxaVA5RXZJcmxybUF6TXczVkcr?=
 =?utf-8?B?N0dkdVFTS1Z5VzhUOEQ2VUFqZTdpVkVKQmRLblJBTlZabldMSHdlblZsV0o4?=
 =?utf-8?B?TkdveWNPc2xaSEU0dEpjenVjN3E1VDhTVjBPUkQrQ2ZwbkQ4NERvamE4VGZ3?=
 =?utf-8?B?SlRVbkdMRTBObDEyQ2NEQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TURBVkNLeEx3alhUQ2xoQXdZL0xBTC83Uko3bXhYQWlqS0l6eGZHN2F2NkQ4?=
 =?utf-8?B?YjVMM2k5TTVUa09ud3hvVmEyeGxBcVhJQXNPV0liMUhwQXcyYkI0MzVuR096?=
 =?utf-8?B?bjdYVHVlV0VzeGhlS1dkQXNOcThNMHAwRks4c1R6elVDUXNXNTM4MVY0bE0w?=
 =?utf-8?B?SEFWckZzL1V0TUUvakpMZU9rTkdwMThDM3Rub2NrdXFHYmpZNkxLbjVyd3Qx?=
 =?utf-8?B?Z2tNYmZSSThLL0plOHk3QkFhT2lZREZGZUpXbWRnNmMvdFdBRm9haW1ta2lD?=
 =?utf-8?B?ZWJzQU9ycUY1bmtwUU1IS3FjTmo1VmVocUpjZ0F0NUpvdGc3MjluNFN0YzZa?=
 =?utf-8?B?M053Q1k3K0UyaEx3aUxaaW9CTjZ6SDZ1TWRhVkQwQ2t5Z3kza2F2THVzRkxN?=
 =?utf-8?B?TGlxUmxJYnRFbndiTGlRRGp0MEJkcUJFQnlZdUVNOWlOMENWK0Voc0NSRXZ2?=
 =?utf-8?B?VEQyRTlLMVBUN2JlTC9obU13NFBsZG9PZXpUM3RhMEZySUY0VEEwTVRUQ1Jj?=
 =?utf-8?B?MzdVUFFERjk3cW1hamFGMjZDTTQ1OWtnWnZwRTUvSE9OempjMHYxWVRsZVJW?=
 =?utf-8?B?Q09YZkJNU2EvWEZRdmlBMWhyQzh5OHdGTk5hM2o5TG8zN3pFODZIb21lOW5Z?=
 =?utf-8?B?MitXejE0bU5QdjBMWnlTaUVMa1NmdWZiSENuUmg2eEliY1B2b2Nma0dYSk1E?=
 =?utf-8?B?UGtiZ0tFS0VTdStqa1dmekZZaUxKNm1mSUF0ZnJSVUxHM05BUEtHRlNNdzN3?=
 =?utf-8?B?RzEvZU5zRGY5ZSs3NVI0dWNhOFV1U3BlOHN3alVPMkVmMlEzNERON0FIaU9r?=
 =?utf-8?B?SFdJVldwamlEcU8rbll1RGdQSTA1N0F6K05PVXVrdlB1VGltazE3TE1iU2RG?=
 =?utf-8?B?M1ZOK2ZuWUZZNG94eXhqZFRRZDg1aXpnYUxJZ1RIOUxzN1QwOGIxT0JoelRm?=
 =?utf-8?B?RllCMVd4RERWYi9xN2t5c3k3bEdBb1lZbDlRZFJQYzl3NC80RzkxbWFXc3pj?=
 =?utf-8?B?eDlDWWFjOFFZUjR2N2JLc1BFRlhiS293ZDhGcFJkYjBkNG5ZZ1dPNytSdUcz?=
 =?utf-8?B?d0NlNWdGZ3pMc0RZMThydVBOUkhIRFF3dGEwTHlhMjNTNDBQb1gxdUVZYkRZ?=
 =?utf-8?B?WDA4ZGw2MS9KMmJNYk1tVSttaDNCUkxwdFBnT0oyRzV0QkFvVjRpdzFFenRp?=
 =?utf-8?B?L0JQcGdmWnY4UmVVQTBpU1YzYVNHOGVsMFBwbXVUazhaYVVPaTBiM0trSnhZ?=
 =?utf-8?B?YzFKSVE4dEdjYkJIc2RmYzB0cml6aFhRdUY3UElpK0VDcFo0bDB3QVN2UFZ3?=
 =?utf-8?B?YVRuK0lnMHBJc25sQUtNZ1JiU0N4YTNhQitycVgvRUZza3lCY0txb3NFWFFp?=
 =?utf-8?B?c21wR1Z0MG8xRFFlYTkvcHl0aS9LeXUyQUI2TFZZTjZRc2I0aGhwVStkOEZG?=
 =?utf-8?B?QXplSXNMSDV1YkdzcWY0enYxTkhpOTB4ekNTZHV4bjdBM2JhaDVid3I5ckxW?=
 =?utf-8?B?QkRPMVdlaHUzNUxhN3lnM2JnUkcxNzlmUnY0eU1KdEhIMHVIaUpGaCtZRXQx?=
 =?utf-8?B?RUI1RVFsR2dqZlBxODFEZTNOcktyM2VXK0llRFFSbm5pZ2hsM1IxcGdiNDBU?=
 =?utf-8?B?RC9ZZ0g2M0Joc2E5Z1NHWGgybkxrKzBIa0NGaWs2Z1ltVURqdjlIMFJnUlVQ?=
 =?utf-8?B?NUh2YXRlbmhLUmx2L014eVhXVHllT2JKMnNWQm90QVE1MWloOEs5cUU0ZzNw?=
 =?utf-8?B?dk8vTjI0d05abmtnZGM5MFdabXI1Ykh3VTNlM3VIVWRJaU5sRE0xdFB3Ymhv?=
 =?utf-8?B?Tmt4WWdlejNDUEt3d1M2MkwyQUc5TUcyYmJDRFpvQUpqSGJhcXhDMWdTRkdR?=
 =?utf-8?B?ZVMrVmdQMzdqKytVTkNBZC9mdVdjbVdkQ2RHOHp3NkRibS9SM09tMCtyaEh6?=
 =?utf-8?B?V0lMU25XUHN2YlU5UjJBL2ordjBXT01QamNnK01nd3J0bW1kNEUvaVVhT1NM?=
 =?utf-8?B?UzY2dUMyVWZCUVVwM1JzQVJvQk5PWDhTNFFjSDNXZTN1SXVONXlEOG8yYWdI?=
 =?utf-8?B?czhMMXJndTlVdG52bXljT2thNDJ6dC9OdHhtRHhYNTBZcXA4MmdtMnJjSy9J?=
 =?utf-8?B?akg5QXV2b1VjM292MFlSdm9Rc0xBQjhXejdVaDRtZVVpSlJxTDhoV0hPaWVm?=
 =?utf-8?Q?xnW2kPHDWYKJzGVM2FEN5fs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BD244D7B95D1342B4BE6CB22DA53D27@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e6094b-3ec0-4f56-6aba-08dc6b05bd1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 00:12:37.1572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: viFNErk82mZTMrwDPUTSskDoXa4lKrHRdYilxy1QK84f8bOijITKI3gD360L2S2IAqGEqG6/Z8Zpyuop4wlpEcTTRDgCaOgE0HcHyeX5skw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8520
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6Cj4gKyNk
ZWZpbmUgVERfU1lTSU5GT19NQVBfVERNUl9JTkZPKF9maWVsZF9pZCwgX21lbWJlcinCoMKgwqBc
Cj4gK8KgwqDCoMKgwqDCoMKgVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBzdHJ1Y3QgdGR4X3Rk
bXJfc3lzaW5mbywgX21lbWJlcikKPiDCoAo+IMKgc3RhdGljIGludCBnZXRfdGR4X3RkbXJfc3lz
aW5mbyhzdHJ1Y3QgdGR4X3RkbXJfc3lzaW5mbyAqdGRtcl9zeXNpbmZvKQo+IMKgewo+IMKgwqDC
oMKgwqDCoMKgwqAvKiBNYXAgVERfU1lTSU5GTyBmaWVsZHMgaW50byAnc3RydWN0IHRkeF90ZG1y
X3N5c2luZm8nOiAqLwo+IMKgwqDCoMKgwqDCoMKgwqBjb25zdCBzdHJ1Y3QgZmllbGRfbWFwcGlu
ZyBmaWVsZHNbXSA9IHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgVERfU1lTSU5G
T19NQVAoTUFYX1RETVJTLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtYXhfdGRtcnMpLAo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBURF9TWVNJTkZPX01BUChNQVhfUkVTRVJWRURf
UEVSX1RETVIsIG1heF9yZXNlcnZlZF9wZXJfdGRtciksCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoFREX1NZU0lORk9fTUFQKFBBTVRfNEtfRU5UUllfU0laRSzCoMKgwqAKPiBwYW10
X2VudHJ5X3NpemVbVERYX1BTXzRLXSksCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oFREX1NZU0lORk9fTUFQKFBBTVRfMk1fRU5UUllfU0laRSzCoMKgwqAKPiBwYW10X2VudHJ5X3Np
emVbVERYX1BTXzJNXSksCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFREX1NZU0lO
Rk9fTUFQKFBBTVRfMUdfRU5UUllfU0laRSzCoMKgwqAKPiBwYW10X2VudHJ5X3NpemVbVERYX1BT
XzFHXSksCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFREX1NZU0lORk9fTUFQX1RE
TVJfSU5GTyhNQVhfVERNUlMswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtYXhfdGRtcnMpLAo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBURF9TWVNJTkZPX01BUF9URE1SX0lORk8o
TUFYX1JFU0VSVkVEX1BFUl9URE1SLAo+IG1heF9yZXNlcnZlZF9wZXJfdGRtciksCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFREX1NZU0lORk9fTUFQX1RETVJfSU5GTyhQQU1UXzRL
X0VOVFJZX1NJWkUswqDCoMKgCj4gcGFtdF9lbnRyeV9zaXplW1REWF9QU180S10pLAo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBURF9TWVNJTkZPX01BUF9URE1SX0lORk8oUEFNVF8y
TV9FTlRSWV9TSVpFLMKgwqDCoAo+IHBhbXRfZW50cnlfc2l6ZVtURFhfUFNfMk1dKSwKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgVERfU1lTSU5GT19NQVBfVERNUl9JTkZPKFBBTVRf
MUdfRU5UUllfU0laRSzCoMKgwqAKPiBwYW10X2VudHJ5X3NpemVbVERYX1BTXzFHXSksCgpUaGUg
Y3JlYXRpb24gb2YgVERfU1lTSU5GT19NQVBfVERNUl9JTkZPIHBhcnQgaXMgbm90IHN0cmljdGx5
IG5lZWRlZCwgYnV0IG1ha2VzCnNlbnNlIGluIHRoZSBjb250ZXh0IG9mIHRoZSBzaWduYXR1cmUg
Y2hhbmdlIGluIHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYoKS4gSXQKbWlnaHQgYmUgd29ydGgg
anVzdGlmeWluZyBpdCBpbiB0aGUgbG9nLgo=

