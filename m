Return-Path: <kvm+bounces-70807-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OzBLAUO1i2kKZAAAu9opvQ
	(envelope-from <kvm+bounces-70807-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:46:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E9711FCE1
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2CEE304601F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB9D30BF69;
	Tue, 10 Feb 2026 22:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmXk8Spq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623D31E2614;
	Tue, 10 Feb 2026 22:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770763568; cv=fail; b=Ox4KUtx7KdlHhzgNOlxMSSbDECQOmFpW2sbeol1x9qWUePMhRAraoD6o13FX9ccfg0JOyFWFPVjSHDF0v+b05jlyXTSFHJ6yTebGkZT5Oy+ZV8OE56SNYh/+xe8T1rKy1IEmvwu7dzsEmfHwlqQo3x0AtLrQLHmn+N3uHFbG2Fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770763568; c=relaxed/simple;
	bh=dUWAKxEhNvzN4RoK8bB6QlOsY2kGqUIaqSecgilJ62o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FzVqQnDuhoLu15DAmyyECJkZUNpQu6GnCUaa2wvmrzQh+16Lz3wsasTxb/hzQ6rKSa24Y7qvN2ixsxxCjjk0tgttg/h/q1o21y7/yqvi1q+bTolbUbW8zcvnbxpFFUDPDy0xsitITQmQroZTU4/yQB9BFzbJz5mhvo1phMTJM9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmXk8Spq; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770763567; x=1802299567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dUWAKxEhNvzN4RoK8bB6QlOsY2kGqUIaqSecgilJ62o=;
  b=WmXk8Spqx5kxApxD5+sVRjypmPZxHFx/sQQW6BHZ6RNh7f/opYA82+dU
   y/Wm8d368sXjM/qB1RHL8BZnI5KU6f+xT4/ie2Zgn8knsc6O81KBkRDGS
   eyC0JvKVjBo6zqpBAdr1JWO+s0XxX6cdPOoGJTBGEbGBftTcmTeNwioXl
   cJx40SKpPa6WPWtOOwW25is2h5sHnCT0xT/+r4+oWdY7KTUSnNK7eswq+
   oci2sBYmx1nDPGa/EnfkHTZgVchgIvxqxbKMfqUX0to9gokUqnvW79HC1
   i0wnEw+KiQaYw7BGd8iWnIAM8VLGTNpOUr9Cxdr8+bQ3XUdQbxO3JCaXX
   w==;
X-CSE-ConnectionGUID: EWhu2pMQQUmAaMcPeBVXpw==
X-CSE-MsgGUID: 6Jwn4eLDSkuFLgYHJU1geQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71948688"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71948688"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 14:46:07 -0800
X-CSE-ConnectionGUID: hUWCb8+rQ5arOoO6LjH1pQ==
X-CSE-MsgGUID: owFi9bUIQ0iE+X3Qel+NNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211887111"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 14:46:06 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 14:46:06 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 14:46:06 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 14:46:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLKj7QwDFGUsnq+TA26bZmXUeCfz53qjXQHLSVmAUy7aelLr8aU5CYE4MyDyTTed/SQscAcH5AYFQnSjkCCskO8pHrxxqus+al3WdtL5d7QHe6Q8vVInRShc79eoN7dfOMQjrYPIWOGghfc301zKAidbnAoRObZ1ijvohFuePcfmtanjV22AFzpQukTVbTYNK/SaL5nnmsW4yVHwwBjRxUKM/IAjA/0oeBhKN9YLSrs/Rs6YcTKDixQYkGHiVMPfccKL4/IRORUCZChCxwSdyh20DbKq2368VpcjrUc/3hDD1nwijIbFp2swNj3neSBjK/lO/JcHmZul8IKXBpgZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUWAKxEhNvzN4RoK8bB6QlOsY2kGqUIaqSecgilJ62o=;
 b=N16FzdaqI9YxdAJeDcSxG11gPp2xX3NjrzrYU+j+FaAV34BO9YQlkqBkMfFTHvituoRCcP45pdD8VNYp9n6NQioprVdvkl3WWdH4F/0rfmA/yh18frSYXeFVvm3fcT7Q8vRpJWlP3jYVOr+ew5QXtZF3UcR2HKs5h2xdqYDmcEL1CfmZHhU8pnlznkhI3YgcgTQAQrC94Gkfd4RidVgfIdDSI15zh/MtP3DjxplzUxKV0Rl0sfvK/pJEbnGi+q0KoXai9cXR6gltLIJr5id1O8mtrYvQOuqdp57UNklB3PX7/k1Cfmo7x1YcCEEmWr1vdJrDTPnv5sRSn6nmha9+uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by DS7PR11MB8781.namprd11.prod.outlook.com (2603:10b6:8:256::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 22:46:02 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 22:46:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "kas@kernel.org"
	<kas@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "sagis@google.com"
	<sagis@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Topic: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Index: AQHckLzZ61zp4LHq+06z7n/dSkCkD7V8SEYAgABL1wCAAAD7gIAAB3wA
Date: Tue, 10 Feb 2026 22:46:02 +0000
Message-ID: <b9b4b80a3818e9ebb3cb1aec76d1a1083fb91c7c.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-17-seanjc@google.com>
	 <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
	 <ebd424718bb0b2754b7cbacb277746a3076faea3.camel@intel.com>
	 <4fe6121b-6fe3-4c97-b796-806533ed6806@intel.com>
In-Reply-To: <4fe6121b-6fe3-4c97-b796-806533ed6806@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|DS7PR11MB8781:EE_
x-ms-office365-filtering-correlation-id: a241ab04-4ea3-4a0e-764d-08de68f62b21
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Qk43TmxYd2tuR2I5MDgyT0hNOG1EMG16S0hWVDUzUkYvemEyU0o0NXFjd1lQ?=
 =?utf-8?B?UWFhaUZtZG9VeEU2UGtIaU5wQ1VYM3hhOEpGQ3dFaTB5dy9wNzgzc1lBc1RB?=
 =?utf-8?B?VkpyeW1iRGJ3a0Y4RlhxWm9Zd1daSHdzMzVkMmJnV3hTNGpjZHlXS0JoL0ZV?=
 =?utf-8?B?L2VvdU9YbFFBdUJWcXlpcE9RSzJrV0JzaC9xTWRsZ00wOWVUOW94MTJQby9y?=
 =?utf-8?B?ZzdNM1pPZCt4NVhIbkRXQ2tVTlZoSnpXL3dtbVgyTWJOUEg4aWw4SEhobWky?=
 =?utf-8?B?aUNoM2ZBR3RzM0VQUnhTelZhNXN3Z0RhTStxTjdJQVA4bGxaQ0kvRGY1OUdV?=
 =?utf-8?B?STh4TVNXSHhIMlRPTHBZRTBla2ZYeU5BdWpSREZvTCtPMEFFVlV0MUppSEc5?=
 =?utf-8?B?UG15SjFqQXV3cGd6WXRRTDR5M2dGT0cweXlneEFsUSs4a0JiQnZGUmRmejdz?=
 =?utf-8?B?L1pDamdMMWJRNmJxUzZaRTNMaWJlRFJYRnY4Y1BKNzBmcjRuSHh2TE5Ca05B?=
 =?utf-8?B?cGFNZlArV0RWWm52aEx6ZnFoYkY5T1JCMjEra0FlTDlCRWZLWk0vZVAvcG9D?=
 =?utf-8?B?SHkxNU9EOHR1QmN1UzZ4SllyT1E3dVV0aXloQ1RnTjFLeFBOaHE3WmhvKzJL?=
 =?utf-8?B?ajUyMkRnVWVWR1BHTDlXNHE5ejJnQUsxN0FaQ1VZT3ZramQvN0xvNWN4dzFQ?=
 =?utf-8?B?eG1wazRyYWY2K24vdkY5M28zYWpObkxpVUtiZGMydVhaeFZ4bkFiUXNXUTh3?=
 =?utf-8?B?S0doZEJCZlg5bHZWNVFqd2I4bDhzZURZRWxKYllEeWg2eVhDajJHb3RQWlB3?=
 =?utf-8?B?Ui94a2x0RnJ2U0NkWkorYmdoUVlSdjIzbEJnNnQrZHFTa1RNQW5nc0xYdmdu?=
 =?utf-8?B?TllFVWgzSkhpeDBWeTk3ZmZxTDBKWVo4cHlmNVhRYStSRnU0eTRFQkc0aU03?=
 =?utf-8?B?YUYxL1IySEFJQUFQYTBnOVl0Q05IOEtvVFRMQWxRdlFuVEZ4ZjlwVUZNOGtK?=
 =?utf-8?B?Z0ZXYjU2NFZ3MmRNaWZWbTNtRFhjcldpTHh2M2VEWGdma2dtWlFOaW5SU01U?=
 =?utf-8?B?SjhvdkV3azZDNm5tVVFpY2ZOQ01mdm85VkZIcHRSYWxWTEd5SXhzVnpxODhH?=
 =?utf-8?B?SWhnWWpKWFN2SEZ4YnV5ZG9NQ2dHVU94NXdIN3duRk8zd0RNSHdwYTA2RUZ2?=
 =?utf-8?B?aEVoTDVYMWxaMkgxdEZoUmt1VlpPZWhUd3BJTVdvSWs2SnZpOWxXL0ZFWGho?=
 =?utf-8?B?SVdYTnBSSXo3RUxwTGRraGljZkdYVmhCRm1tY2pUOElYaUxTZW5NcXFDMERC?=
 =?utf-8?B?d0F4dUJhMmVMalBRUjlXV3FWQldjTFREcENDZkdTRFZlcXVsVWYvMDJHaXJK?=
 =?utf-8?B?WnNwc3oyV2FzMEVzYzJZdUgxY3NYbGE4NXNiMVh0bUQ4dE5KZGllUjY4bkRr?=
 =?utf-8?B?d3dIT1NCSGozN25PUkc0RnJ1TytIL25tYjkveXdlckdzM2JKcDRwY2s1MEhB?=
 =?utf-8?B?dDdFV3o5SWJaY3AxaW54ZWJLaDFZWGJmNkVxVTRWekdValVGVjJvdll6M0JQ?=
 =?utf-8?B?emt1d0FNUGVUUXMzaDluTWVtbXhDaFRkZjA4UzhjTUZrV0hZbFZqTjlBLzVO?=
 =?utf-8?B?Z0tsMkJmVDQ5RFptYzMrOGFyZWRVclF5NXd3V3RxcFVvU3pHcDE5eUpyL1ln?=
 =?utf-8?B?dGZqNUE3T1VKN01tU2FjN3BZYTFvaFU4ZlJGd1NCWkI4WTJDeXM0aE1PKzc1?=
 =?utf-8?B?ekQ4R2hFbURoZ2pKSGE2Y3lhd3g2VW4yNWdCMnhySzNLUE1kTlREeEJYMEow?=
 =?utf-8?B?STgyc2NCZmVQTHlnUXNRMEFBNEpFaUFqRjVjL2wvb1lJL2lvT0FmWjIzVjF0?=
 =?utf-8?B?ZWxqZXJ3T0lGbG81dUZvRTZXTU9jNTRRNjl5MDV6ZGVId0hnckNoUk9zdmJE?=
 =?utf-8?B?RHN5MnlvRlA4QkQ2YzlvVnhseXRkRTI1MDNHVmxjY2N5bmFYb0swOTJUQnFm?=
 =?utf-8?B?cTJZUUdkSFhDZWFXNFp4YzFPNzNJdDlwdUpQbkw0M0FHeDlVdGVsOHVhbXo4?=
 =?utf-8?B?SU5Ia2MvaFdhTGNuVGVhMXB2OHBrcHFGV3FwNGowaE9tdGRTQjJKQWgwWDJw?=
 =?utf-8?B?VmxielJmTG1HSGVBajFyUTdramlKeG1td05rZFFjUTkxc042ajVWRjNPSldC?=
 =?utf-8?Q?KUmaoERAcweLNcrFsp1i2xuGkvQ+dq7YoS1CtIx5ll+B?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFlSYkw3d2RLY3k3R3hEWm5pVjd6K0NZTE9scjd2dDYxYW1lVEpSellkamNx?=
 =?utf-8?B?bVQ1TUFiWXB0YWlUYUpxeW9Lc1MrQ3BZOUE3QXZhazBsMEx5QVc3Z1V3Tmhj?=
 =?utf-8?B?eDVITE9PWnhxVmF5bFQvazJpTEl4dHJ3a3FXK1NEcDYvcHA0d2xuZWFYS3Yx?=
 =?utf-8?B?cmhLSFRNeDV5dUt0ODVVWS8zM29WRUozc29qVG9kSldValNYT2VzeXBnNGwv?=
 =?utf-8?B?OTEvb2hCR1hlU1VvckxkazU5VHB6ZXhIMDRHenpVUENrSDNQUzZRYldMSlY3?=
 =?utf-8?B?QlBTNmg2SHdCVjUxVGI0NDgwQUk2RGt1aEoyTm05NjNRUDcwSVhkN3U0QldK?=
 =?utf-8?B?SjJmU0VrbW1FZ1FCZ1dJbEt4Szk4QUdyNm1RVXF1QklsYkxEbWJrWXRFd05K?=
 =?utf-8?B?VGNzQXZOOUhwTVIxTnBER1FLNVVMQ0pLMTlycERyN3pOdENnQWZ1eEVuVjBv?=
 =?utf-8?B?ZUVWbDBJaXVhRXMzMXh5Zmdjbmp5cDBLdHo3RldsenpmTDdXNnBTNVZuS0E1?=
 =?utf-8?B?cklsdlRUQzVnUGoySFZUVjJRMHRUN3JvbDkzampQYjEySjgvMlRybXo5aisz?=
 =?utf-8?B?VmZXVGt1QlJYN055ZllidGpHMUlOQjA5OEZ0SzhqWkVtVmFBWlR0bm9ZT1U5?=
 =?utf-8?B?dU5tZHhLZmVTQkNjdXRSZEEvbTRHYm9hYWtaTlpHcDl3d3Y3K1N6dlhDUlBU?=
 =?utf-8?B?andOdmtwN3dpdTBBdldrSGd4d0M4dW83RzNINk5LWWxiQnBPYlJzZkxDVWQ5?=
 =?utf-8?B?S3FwbCtFUUVGWWk3YkVaUGJQMHZ4V1FzRTFhUzVId0xuNFhpKy9mMEkwTEVP?=
 =?utf-8?B?WGQwbWp1dEh0T1BYNnFDYTg2dVRFN3RTV2krVDhYanVPZEpId2JtRy82RFlY?=
 =?utf-8?B?NmNncDhaUi8xdTFPQWU0SzE0ZG1zMzlpc0x1NEM0Y3FLVm5ZNkxRcy9TWUZq?=
 =?utf-8?B?bmVZQzFoeUJSdDI1L1VWQmZDTGdDNUtoOUJvTDRTUHBaa2pHVER3YzI3Zms1?=
 =?utf-8?B?SHJsZnpTWXRSYk1aZ01YS1Vva0JUd21sZ1VZQUxsOGVjRVp3TEpSckxZOStE?=
 =?utf-8?B?dS9adjBKdHZVSWdRaDhwenVhdkRHaXdtMkN0YzIweVhnRFpCZUJOVEg3VGVO?=
 =?utf-8?B?WkU1ZkJMb2s1NHlxUkxtMTFCTFdjd1NqUHMzNVFqWnNkWXBGcmdaakUxeE02?=
 =?utf-8?B?UDJGb0dUWU5iR01MeGFOb1BucFJsTlpRaWJMT2ZGdDhHcit3eS93RFRKUVFE?=
 =?utf-8?B?SmJRNmRSYTV0d09zbGcxeThUcGlHV0ZiOHRHcm9UOUsvR3c1ZExtVlFtQ3lO?=
 =?utf-8?B?RHFEMVYwbTMvMzd4ZU9GM2VVekNoOVdpNlFjYS9xM2QraHp2Zm9CN3ZLaWUv?=
 =?utf-8?B?YUFWRGN3M1FQbWY3QUM1NGNmY2M1bW9YenlMcFd1WUFYNVdmckxlZWZyR3J6?=
 =?utf-8?B?OG9Ra3BkZGRIZWpuY2Vjem42NGRNWjBWYVdFbi9ERjZEejlwbFA3QWtXcXd6?=
 =?utf-8?B?MU5PWHlUY3ZIOENzVVgvZCs4VVoxalRJcGxOb292OUJCcnBaaTlzNE45Zjdz?=
 =?utf-8?B?RDRvWWhTUWM5SmU3RStadXVORXptTlRzUjV6STFPbW5leDFRcXJMWHRDZ0M1?=
 =?utf-8?B?WDhLa2c5SldCUlJQRCsvQVdMSUN2YmlhZ2k5RGNFRFJRUUUzbU40TlVBcHUz?=
 =?utf-8?B?N3FzbDFETWhxb1ZZMFk1d3I3TWp6dDZHQ2VCQlR3QmNDRnhwQnRUUmNLbmFs?=
 =?utf-8?B?a2Y0MTQ4ZzNNVmV2dUpWdWVPZkVjNDJveU9WVytNYkIrblFqaXMrUXNBMExk?=
 =?utf-8?B?L1lsL290R1dHUjBQZmVaZTVuTmJvVkRXRERFR29lbTZSNjJlT2Y5OVl6aTU0?=
 =?utf-8?B?SXV2KzJ4akZURjVRZ0s5VXE3SGlkZ0FTbURsdytvY1dMSzlUaCsxNkQ4cmJ3?=
 =?utf-8?B?L042d2szVWNETjBpdEtHQUlLcEhCbW9CaUgvQkxVSW45Zzg1Q1c5SCtSOEVm?=
 =?utf-8?B?eUEvSVdQQUc5WXlVVENLanFCWVBVRWdwMHM5MXc1UXk1b2J2VmhCYVBLTE0w?=
 =?utf-8?B?MXc2S1VxMFZpZk5tdWE1bEY5VEtNckpSUTNzNm9QU3ZQaWhCVGJQZ0x5VVhD?=
 =?utf-8?B?U3dENHZUQXZVbnR5bWZuemJ4bGhaQnM5SSs4ZWNSMm5iZkF5T3R2SVF0ZHVa?=
 =?utf-8?B?dXI4NkdUb0hGNk9nSFlOSVp1MnlXd2NuTVNyWnB4cGJaVUlQNDlKclhPMEZ2?=
 =?utf-8?B?UGw4d3JXRkI3QVgxMlk4c1QxZ0MwM05vMXY2c0hXTE1ZZjVNdThOczZma3ov?=
 =?utf-8?B?TkN4dGFqZ1FwSGdsWm96ckMvRzdFNUg2UmlISUZiREdyZFJsMWVudz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B27ABF92C7F1740B40EEB8593C9B7BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a241ab04-4ea3-4a0e-764d-08de68f62b21
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 22:46:02.7959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4r/VjxEa2wzfDr9L0BPgMXOX3Ufd1wWq9HZ3QbmeBgl+cw1t29le5AFqGzeVMKI6HuM7fbalyrnihQvQuW2vxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8781
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70807-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 57E9711FCE1
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDE0OjE5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xMC8yNiAxNDoxNSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gSSdtIHdhc24n
dCBmYW1pbGlhciB3aXRoIGF0b21pY19kZWNfYW5kX2xvY2soKS4gSSdtIGd1ZXNzIHRoZSBhdG9t
aWMNCj4gPiBwYXJ0IGRvZXNuJ3QgY292ZXIgYm90aCBkZWNyZW1lbnRpbmcgKmFuZCogdGFraW5n
IHRoZSBsb2NrPw0KPiANCj4gUmlnaHQuIE9ubHkgMT0+MCBpcyB1bmRlciB0aGUgbG9jay4gQWxs
IG90aGVyIGRlY3MgYXJlIG91dHNpZGUgdGhlIGxvY2suDQo+IA0KPiBJdCBkb2Vzbid0IGRvIHRo
ZSBhdG9taWMgYW5kIHRoZSBsb2NrICJhdG9taWNhbGx5IHRvZ2V0aGVyIiBzb21laG93Lg0KDQpT
b3JyeSBJIGFtIGEgYml0IGNvbmZ1c2VkLiAgQnV0IEkgdGhpbmsgdGhlICIxPT4wIGFuZCBsb2Nr
IiBhcmUgYXRvbWljDQp0b2dldGhlcj8NCg0KSWYgc28sIEkgdGhpbmsgd2UgY2FuIGF2b2lkIHRo
ZSAicmFjZSIgbWVudGlvbmVkIGJ5IFJpY2ssIHdoaWNoIGlzIGhhbmRsZWQNCmJ5ICJ4ODYvdmly
dC90ZHg6IE9wdGltaXplIHRkeF9hbGxvYy9mcmVlX2NvbnRyb2xfcGFnZSgpIGhlbHBlcnMiLg0K
DQpLaXJpbGwgZGVzY3JpYmVkIHRoZSByYWNlIFsqXS4gIFF1b3RlIGl0IGhlcmU6DQoNCi0tLQ0K
DQogIENvbnNpZGVyIHRoZSBmb2xsb3dpbmcgc2NlbmFyaW8NCg0KCUNQVTAJCQkJQ1BVMQ0KDQog
IHRkeF9wYW10X3B1dCgpDQogICAgYXRvbWljX2RlY19hbmRfdGVzdCgpID09IHRydWUNCiAgICAJ
CQkJICAgIHRkeF9wYW10X2dldCgpDQoJCQkJICAgICAgYXRvbWljX2luY19ub3RfemVybygpID09
IGZhbHNlDQoJCQkJCXRkeF9wYW10X2FkZCgpDQoJCQkJCSAgPHRha2VzIHBhbXRfbG9jaz4NCgkJ
CQkJICAvLyBDUFUwIG5ldmVyIHJlbW92ZWQgUEFNVG1lbW9yeQ0KCQkJCQkgIHRkaF9waHltZW1f
cGFtdF9hZGQoKSA9PSAgDQoJCQkJCQkJSFBBX1JBTkdFX05PVF9GUkVFDQoJCQkJCSAgYXRvbWlj
X3NldCgxKTsNCgkJCQkJICA8ZHJvcHMgcGFtdF9sb2NrPg0KICA8dGFrZXMgcGFtdF9sb2NrPg0K
ICAvLyBMb3N0IHRoZSByYWNlIHRvIENQVTENCiAgYXRvbWljX3JlYWQoKSA+IDANCiAgPGRyb3Ag
cGFtdF9sb2NrPg0KDQotLS0NCg0KQnV0IHdpdGggYXRvbWljX2RlY19hbmRfbG9jaygpIChhc3N1
bWluZyAiMT0+MCBhbmQgbG9jayIgaXMgYXRvbWljKSwgSSB0aGluaw0KdGhpcyByYWNlIHdvbid0
IGhhcHBlbi4gIEluIHRkeF9wYW10X3B1dCgpIG9uIENQVTAsIHRoZSBsb2NrIHdpbGwgYWx3YXlz
IGJlDQpncmFiYmVkIHdoZW4gcmVmY291bnQgYmVjb21lcyAwLCBzbyBQQU1UIHBhZ2VzIGFyZSBn
dWFyYW50ZWVkIHRvIGJlIGZyZWVkLiANClRoZXJlZm9yZSB0ZHhfcGFtdF9nZXQoKSBvbiBDUFUx
IHNob3VsZCBuZXZlciBtZWV0ICJIUEFfUkFOR0VfTk9UX0ZSRUUiLg0KDQpbKl0NCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2t2bS9iZmFzd3FtbHN5eWNyM2FsaWJuNmY0MjJjanRwZDZ5YnNzamVr
dnJyejR6ZHdnd2ZjekBweHkyNXJhNHNsbjIvDQo=

