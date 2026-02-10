Return-Path: <kvm+bounces-70804-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yA9nFvyui2nmYQAAu9opvQ
	(envelope-from <kvm+bounces-70804-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:19:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E77811FB7E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2724B3013D5B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F0033A708;
	Tue, 10 Feb 2026 22:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVEczDzM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B4133986B;
	Tue, 10 Feb 2026 22:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770761749; cv=fail; b=KLUDRDp7YqxWSYpJU5aw0iF6v5Lem0/K6VgHftpRF2u2UfqGoaJfujCZyZ4cXLBI6uIiSKLpUJNg9ECgZup2BqB69FCsQX/p1vr8dfIi84gPXOTyuaBZgenDr+XFTQRl8jq7oGEI32a9q4YqQiICG/0SlvRQi9ONv2Br5NRMb6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770761749; c=relaxed/simple;
	bh=f28zp+1WfhCoAH9fNLjXjFZ7rudRdbNnRZ6GWpwDFjw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tTMmbvizY2+y1LUSf7QO/kPXbpO0iX8nYL9WYPfu9vhRDK5JeNPQbh5LSsuPrnfIpXG6MQKCDjKtIlAlWtqMGhExBonGvdJrXHcvOtZkM/JrZPZ/GrARu0aTSDWd15CzU6Mv8faVAr2cpiJLPn+kzE3iol1yVE2gONIYv5I3t4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVEczDzM; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770761749; x=1802297749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f28zp+1WfhCoAH9fNLjXjFZ7rudRdbNnRZ6GWpwDFjw=;
  b=fVEczDzMEVhVozvLKWvf3PY6UWrzPqK36onP5ht1w1PRbm8/WWHhfoce
   EJgOKmMefB/sosEDW318V2UQCWhaSfL/9gMuf0TLujDMQBObZwngaRJAr
   q2Jq14PKEmWel4trQSVO+rEbhBFw14hRz5BD/dXQvDsXVWFORLPncTfL+
   7h0Erby1TGla1c1YxpFTOyrY7jHPO0o9XCXLfULwe/OCuROTZdY7JG36w
   qnQ4S+cU8Ggnc5nJQE5oLJkD6hQqDAd5/0im2eLtjYq7+md9NfYYAYrOM
   gcv04jnEJnigAxiuSJgzVJS4Y2w2jKD2FkMB1aHJ98Pi/Pp4vxKREiprz
   Q==;
X-CSE-ConnectionGUID: QH6KjvbQRPOR2/QeGA8+ew==
X-CSE-MsgGUID: SoQXzSvdQu+Ilyjwn2X9kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="83340412"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="83340412"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 14:15:48 -0800
X-CSE-ConnectionGUID: kFexQQm7QL+CHEL52JV0vA==
X-CSE-MsgGUID: crSqL7iJQ8KW3jVXnSkO+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="217001845"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 14:15:47 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 14:15:47 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 14:15:47 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.11) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 14:15:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVpZdo27BouBsSdAtS+WTueNVEHKJBr2CcXUiTsoXLW0FUxS1FFl/WNvtlM9b4E0A9BrHm6tVidRta1XYQWkcszGLnXRW2Mq4IoT40NQf+UX3YDp1D3zta0p9tfHzTFDFo1uHoW3E1FwDpyxkB2i00IIaBViK61ZyRdZeC9Tdqmq1rbGqqHA4x41YjzxsX3jQ6AjoNayNc8wtDOIAwT0SWFQSy2cx2P1VnnLJWUXDNoHlhUL8F1qRLMgWC6wD+FxDEPLFHkGbDRkHS2Aq1apov0+qGQ2Rz74Ecq+jcoVbG5uMQk72un22bHkKyuCml1H+JtEQynr7gGzFK751mC/Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f28zp+1WfhCoAH9fNLjXjFZ7rudRdbNnRZ6GWpwDFjw=;
 b=Qjy+WF/Zy61S/lBc571/xJLTms80eDygH4mkeQt1jSlK/KD1my1j8Ftv9Vb/jH3AyEN+FsUJ4CLES/5Cr1aYHxlCYoGRv1wa+iDCcNjm1oR/zabK4N5zFmdaXscKiA52Hewq3ZbXVyBiNJftkWR0nRjLUcUcFpZzh5lfjBgt0twScSovnzK/F11MKeAuytFhaTa3nqrlcNBISjAFUVPQp/YBVXah++U0kGW1RzkQkl4isvkv0dmBZOMvRwHNDz608/fRZucjddfSCWY6YVezmnO6CdkJG42gNY4chOb1dDKOE0K3BS0kolebWosENfUTBJ+gcZ/8FbiEzqAiwe1JYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB7980.namprd11.prod.outlook.com (2603:10b6:806:2fc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Tue, 10 Feb
 2026 22:15:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9587.013; Tue, 10 Feb 2026
 22:15:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Topic: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Index: AQHckLzbLDbm1hcjXk2EfwFkWO7GVbV8SEYAgABL1AA=
Date: Tue, 10 Feb 2026 22:15:42 +0000
Message-ID: <ebd424718bb0b2754b7cbacb277746a3076faea3.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-17-seanjc@google.com>
	 <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
In-Reply-To: <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB7980:EE_
x-ms-office365-filtering-correlation-id: b04b8d9e-ab31-40ab-033e-08de68f1ee1e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MHdEYjYycnNyRnREeDNJckVzVE9tQ1FvUjdyMXBMcHkzcmVGOWRyTUtFMmwx?=
 =?utf-8?B?cnB5MUJHa2JJZGRRUEpKczdtdGZvWVRiNHF0bG5teEU2KytlNHlRT3p6S1Ix?=
 =?utf-8?B?Q2swSVUxVnYzbVF0WDV5Q21ycjZ2WXZGd25scEozMStTdTBNa0xmMWJCUmhH?=
 =?utf-8?B?VmdZOXBHOUxQZTRoeExZb29tYlpBQmp4cExTT0VRT3RJV0lNMWI5dTZEVjF6?=
 =?utf-8?B?SDZBcXhYK1J1WkJJUTYyV1NTL000QmtsNGNxblk0Q01kcGc3c3JLcEZNVzRk?=
 =?utf-8?B?WW5QYlJrRFR2dmtFblNXTUg2NTFDalV4THhxRlVMRFFySS9peThNU0NvOVI0?=
 =?utf-8?B?MnhDWlVtTHhCSnZpczRGZVJabWZjS2FuNlhLR29DWmkwZzg4bWhQWEJyeEZq?=
 =?utf-8?B?RzJCcW9CaWtjTW9YenlSbzhNSjZsU0c5bmtYQ0lIN2pHZzJkNjdUMm9ST0lr?=
 =?utf-8?B?c0p5MnBWWGp6cFRuTnU0THJFZ25vcytETUE3V0dUMnZNdjVONUdWVU5hMTlB?=
 =?utf-8?B?YXdwRGk2cllzMTJOV3dka09paEpEU0tlYXpsTlR4RExmbVdBLzNBWm1Dajly?=
 =?utf-8?B?N1dML1FROEdQWDJTenl2aDBDUVB6ZGNnNWNXV1k2Wngrd3pOdVFSRk8vTk05?=
 =?utf-8?B?dlB3b1NiY2h1STUvL2NQSUFXWjZTL3pycmFwNGk5WExOcHgvYlpwOFFrQzN4?=
 =?utf-8?B?VGFvam1kLzJ6QTBqMjhZaXZ3aUZYQXlLYUZCTlBjZlhobWc3dVVZWW5Bd3BB?=
 =?utf-8?B?UytYWTRBRVUzNTVwUGlMK084eThuYnVmblRCd0NnK1EvUmlhc3d6VlorVHRJ?=
 =?utf-8?B?TVp2aTAzY0pTSW5qNkhMOHVDUmlndXpEbHBBTFBlTE9FazJGdzQxR1YyQXp4?=
 =?utf-8?B?dW45TlN5ZTNuRkRUT3BKK2RnSk1VOVc0L3pCb0ltSVFvVGZLYy9KdU80TXpQ?=
 =?utf-8?B?SkNOdlVNYUFBT2VCVm9qUHo3ejFJb2hVS0phMUxrUVdsWS9DRUNuR2daODZ2?=
 =?utf-8?B?TkR0dDVsNGcvZUlxR1ZhSlRKeTQ1aU85L0hsQ2lSTnZsdkxzQ1JDV1pWODFM?=
 =?utf-8?B?SU0wZ1VtQlBZcXBEZEMvK0RNNWh2VkhYc2gwWEQxcm4rVGgvU2dzWkJlWmVV?=
 =?utf-8?B?elhKa29IdVFlRHovdjZtNzQrakxWQXpQZTk5RnFWSldJdnNiWXE5TEtMRC9B?=
 =?utf-8?B?RmYyYWFvQ2p3TDZtVEZkK0NLQjVVbWY4YWtJMzhOMVZSTjJkZ1ZnZmg1UVd5?=
 =?utf-8?B?R3BNdWdHZDNNVlRvWXpOYmRPdmduWE9qQUZwY2tYUzY0QkRsZjh6WG1sMld6?=
 =?utf-8?B?ZDF0eDIrOEtic3lhRGc2UzdZMytTckM3aDA3Wk40bDFHODZWWkx0b3ZQTGJi?=
 =?utf-8?B?ai9ncm5UYUtvaC9nbE8xR2FhMkxsUDBNUGUxSVMwTTZjNjB0dVYzRDNZK3Vt?=
 =?utf-8?B?MG4rNWxNdGJrZlpkSlFHMnZKbjY3dERmLzYvSTk0UmRBRGFVbXE0TDRBczB5?=
 =?utf-8?B?cEVBdDVxMGE1RE1NYWVtdzJhd1hLVVJlbGYzOTFaWGc2bnZXbEFSa2IxQjRN?=
 =?utf-8?B?a0dBcEtkV1d4eS9PUi9CSHpURVB6cGQ2c0M2Z0RRRDdRQjc3N0MzaVl6L0wz?=
 =?utf-8?B?STg4N0tmWFBiRlJyYUpoS2JNZ1hlbENNaFltVm9FNFd5Y2hMSHpPNFhURjVU?=
 =?utf-8?B?S2FCN1FyU09zQWZlM2pTaytwVXExTlgxWDFVaE01MzRPQTNybnhRSi9UeWFU?=
 =?utf-8?B?dy80cTVTVjZjbi9tdVgyYWk1MEdXQzlrem1scVdPbnQyUTBpTnhYY1NCcFJF?=
 =?utf-8?B?YmZwZ3dMczRuejRFbjZtak00ejhxbUh5ZlJQVHVMY21jblJLNDlKUE5ib3dW?=
 =?utf-8?B?YTE2d0x3SWsrbEt2TjliL1QweVZsWi9mU3FlRjRhNUl3TExhcWxZMnJDTitU?=
 =?utf-8?B?ZThGQnA0TVQyUFZSbnZmN1JVd0RnWkRYVURsUGhEWlNrckFxV0pEM2d2ZEJU?=
 =?utf-8?B?anh1ZXBQcGJha2tmY1NRZUdwY0RmMHozVDdSOW1KMUtySjl4MHdVU1Zjd243?=
 =?utf-8?B?NGpEaFZiMk82a3ViY3ZvSWlBTXZIV0V2VmJUdFJOajZ0dVlweEQ1YlNHM2dx?=
 =?utf-8?B?ODdMaE55WGdXbittQzV5c1FYZXlEQUpMWklPYldmOGluUFhCTHZDSDBIQkM4?=
 =?utf-8?Q?8LKJ5wtT/AVEkJFse4FCdey8I38lQzYK+5EbC5tMZQag?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlFNNE1qc29rU00yaW5KUy9heE9YOGFPaEIvYi9hVkFNbDZvVWUyN0YzNlBz?=
 =?utf-8?B?VzhBcE5pcFlsamF2MTNVZzNhOW4wclBUN09IeHN0SDhHM3B4YTBNcXRNb2JJ?=
 =?utf-8?B?RFp5cm9zdHFDVjdYa2MwZFdkMFNadUp4cTdlY3BwUVFFUzF0cW8wQWZML0Er?=
 =?utf-8?B?Rjk3ZFVPRXdRZWJWcm50NVQwUEZ2RVkvY2xQYWQ4VlNlcGxxRDUyck4vbndG?=
 =?utf-8?B?WkJZZndrcmZCcjl0RzdhSVNwSjdIVUZLNHZqTU03V3ZJRE9ER28zL0Qrdm00?=
 =?utf-8?B?NCtML2hyVUtRLzdjTkwrbVhSWHBwUWtYSndYKzFVUWRUUHRua1E5RjBlTkxa?=
 =?utf-8?B?SzFNaG9TT0ZmaFFsRDQzOXR1T0RFYUlHNlJLNDVsbDRPUzhlcmZaQy94dDdl?=
 =?utf-8?B?V1U5djJFVnZleFp4TWtxRy96K0dvaGhxWktvUUJpNU9rdVc2MXRYVHdEOWN0?=
 =?utf-8?B?RnNVMW9LeTJHMDcwRmx6V20zenZjaHdiQTJmVkkrOHlvQmZVTmU3L3JrQjRU?=
 =?utf-8?B?dkV2MWo5ZUJUNjRzQVp0M01RcDZLV0k5My90K2NldWxsa1JIZmpSZ2thdlJs?=
 =?utf-8?B?QVZRTFNkY3FscEEzdjB3eThLMUY3eHRVRU1lS3RMT1lTNnR4NlpIWnh0elMv?=
 =?utf-8?B?dVZpL3RIZ2x1L21UOWhaWHJpczFEdmNlSEtkZkZjOG94bDIyNm5NZVBUR0Nr?=
 =?utf-8?B?a2pudVBodmpyaTM5aitSRkRidDEyKyt4eEdTcUNqQ2FJYVRvOGUvQXNhUFpQ?=
 =?utf-8?B?WktjZXlnbVo0bFM3VnVRR3A4eU5pdVVqalJGRmdBQnVudmkzWTRyTTN5dU9l?=
 =?utf-8?B?U1k5T3VKV3pjTTduOTQrb3g5K1RmY1pheDJveU5lblJWam0vOFFWZFRaL095?=
 =?utf-8?B?eEJJeE94V1VjK2hPY2QvRFRRTzJ1R0JCbDZRUW8xWUFHRnNnUGV5NmVOcXk5?=
 =?utf-8?B?TDJBYmQzYVBIdE1aNkFxYTgwOVZiWld3TkI4YTlNaVZkV0M2d25MYlptSmVr?=
 =?utf-8?B?Y0JkeTFPWjl3dUh5TXM0MndldUVqc3FPZUh0Z3dhNlNQTHpCOFVGMEkxMk5j?=
 =?utf-8?B?OUh6RnJKSEJHVUVLTllPcWxMYkNUR3BQMUJ2WDRDMXVCMDNRNkZjbllQaWpK?=
 =?utf-8?B?MkpkNit2cTJKcGlzVlFRWXk0Tnd1QjNSa0FxZ1BmRE9PZlpXSUVmT0hzdTk2?=
 =?utf-8?B?QjdLZTBqdGkwcFZrNmQ5RGFFMGhyNzd6Vk9CV3JxbnBTdkd1U0s1SzNTOEo0?=
 =?utf-8?B?WFpQSmJlbE1kVkRTS0dWaDlySFpueEsxSWFqQ05nRWx6K1B0L1BtR2VtRy9n?=
 =?utf-8?B?TXU1dWZSRE5iNmxpVU5CbTg4eDlzRmg3WG5nMzlQL1d6bUtEa2l5Y3ZPM1dm?=
 =?utf-8?B?UTVIaXZLWFh6UEtDbUVNZEoxK1BmNGRNR05ESkVnQjdxT2VkSjNoUTM1M2hK?=
 =?utf-8?B?MTBQVkd5VTk2YWZSZVNnVDg1c2s4RHFVVmVqSVJ6STU0LzFJcm1uT2hKVHc1?=
 =?utf-8?B?MlRaUWloRkZlbjdGMGg3UFNRQzlNUHBOUXpSRldhN3Q3UXpaTk5MOThJaEx3?=
 =?utf-8?B?eFlLWndTWHFsWFgydmtsaHByRVkyZ0lxUlRPVW1vQStYNmZmeEsxUC9aSmkv?=
 =?utf-8?B?MU1PQ0hhYVBkN05TbFA3UTVPWGZ4ZjRRTVZtazN1YnVUOXdkSkc1OFBpNm9S?=
 =?utf-8?B?YWpWV1JaTmFHMUVZSTJtZnpYUjdDSDhabWh6N203OVlIa1pGREEzNUF6a1Nm?=
 =?utf-8?B?M2hKNFdNTERMb0E1Vzk2cCtaTkZjWjFUVnU5T2hNOXc5eWxoTFlSSmJrYWRP?=
 =?utf-8?B?OXVtT1ljOVhvYVNSaHE1N2RMQkNJTU1SOHJoWE1hODJ3RjRVUDdJdlBNbmNa?=
 =?utf-8?B?aWkvTjcyNXllM2l5TFZMZG14R0Fzdy9wTlpTTXVvcTNDOWdtbWV3OS9XVnZw?=
 =?utf-8?B?MFdNay94UmVwSDNPdWVBU0JFckJKZC9IdFZRZjBqUWV5S1hZSldCeHF3WGRY?=
 =?utf-8?B?QmFqZjQrdDVQQmpJb0xvSWcwMkp6LzdGY3NFRUdPNU0xUzJyRm9ONmhyenBZ?=
 =?utf-8?B?SlBOaWJzWmlkeVF3cnhBbzI3bHRBcDVoN2ttTExoY0gvZ0x3S3g4S2ZFQzdI?=
 =?utf-8?B?VEF2QzlsVFc5ZWFhZCtMUng0Tk5vS0dVWWdqSXpXR3pwZnBPMW5wK2FySUZS?=
 =?utf-8?B?OGRCTFJ5aWVGR0lRR0xZcU83WXhhbnRYenBmRmJvdHE4K0YzSllnOEhiMGxm?=
 =?utf-8?B?TU1YRTVWNHZoU0dhU25EbFEwaUtoS1l4RXVzdzhJd2M3c1BRdDA5dVJGbEtp?=
 =?utf-8?B?T1ZpSUhINVlKOSt5M0hINlRtdVNWWWFnOFlheTh0Vm5ZQTY3VFNZc3JjdHdw?=
 =?utf-8?Q?b1WfaYgWjEJywWVM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F812BCF30DC30F47945FB97EB2B9623A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b04b8d9e-ab31-40ab-033e-08de68f1ee1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 22:15:42.4336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2A1JXeUwakhGtNpV3Setik5jK4dUaUy48tkyIVrvFoI6GahJGxcWqz1my0cbcovlSp8mukDZvTgv4niG70HcUYlHP/pAkhYy5FYJPXiDRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7980
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70804-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 7E77811FB7E
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDA5OjQ0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
VGhpcyBsb29rcyBmdW5reS4NCj4gDQo+IFJpZ2h0IG5vdywgdGhpcyBpczoNCj4gDQo+IAlzcGlu
X2xvY2socGFtdF9sb2NrKQ0KPiAJYXRvbWljX2luYy9kZWMoZmluZS1ncmFpbmVkLXJlZmNvdW50
KQ0KPiAJdGRjYWxsX2JsYWhfYmxhaCgpDQo+IAlzcGluX3VubG9jayhwYW10X2xvY2spDQo+IA0K
PiBXaGVyZSBpdCAqYWx3YXlzKiBhY3F1aXJlcyB0aGUgZ2xvYmFsIGxvY2sgd2hlbiBEUEFNVCBp
cyBzdXBwb3J0ZWQuDQo+IENvdWxkbid0IHdlIG9wdGltaXplIGl0IHNvIHRoYXQgaXQgb25seSBh
Y3F1aXJlcyBpdCB3aGVuIGl0IGhhcyB0byBrZWVwDQo+IHRoZSByZWZjb3VudCBzdGFibGUgYXQg
emVybz8NCj4gDQo+IFJvdWdobHk6DQo+IA0KPiAJc2xvd19wYXRoID0gYXRvbWljX2RlY19hbmRf
bG9jayhmaW5lLWdyYWluZWQtcmVmY291bnQsDQo+IAkJCQkJcGFtdF9sb2NrKQ0KPiAJaWYgKCFz
bG93X3BhdGgpDQo+IAkJZ290byBvdXQ7DQo+IA0KPiAJLy8gZmluZS1ncmFpbmVkLXJlZmNvdW50
PT0wIGFuZCBtdXN0IHN0YXkgdGhhdCB3YXkgd2l0aA0KPiAJLy8gcGFtdF9sb2NrIGhlbGQuIFJl
bW92ZSB0aGUgRFBBTVQgcGFnZXM6DQo+IAl0ZGhfcGh5bWVtX3BhbXRfcmVtb3ZlKHBhZ2UsIHBh
bXRfcGFfYXJyYXkpDQo+IG91dDoJDQo+IAlzcGluX3VubG9jayhwYW10X2xvY2spDQo+IA0KPiBP
biB0aGUgYWNxdWlyZSBzaWRlLCB5b3UgZG86DQo+IA0KPiAJZmFzdF9wYXRoID0gYXRvbWljX2lu
Y19ub3RfemVybyhmaW5lLWdyYWluZWQtcmVmY291bnQpDQo+IAlpZiAoZmFzdF9wYXRoKQ0KPiAJ
CXJldHVybjsNCj4gDQo+IAkvLyBzbG93IHBhdGg6DQo+IAlzcGluX2xvY2socGFtdF9sb2NrKQ0K
PiANCj4gCS8vIFdhcyB0aGUgcmFjZSBsb3N0IHdpdGggYW5vdGhlciAwPT4xIGluY3JlbWVudD8N
Cj4gCWlmIChhdG9taWNfcmVhZChmaW5lLWdyYWluZWQtcmVmY291bnQpID4gMCkNCj4gCQlnb3Rv
IG91dF9pbmMNCj4gDQo+IAl0ZGhfcGh5bWVtX3BhbXRfYWRkKHBhZ2UsIHBhbXRfcGFfYXJyYXkp
DQo+IAkvLyBJbmMgYWZ0ZXIgdGhlIFREQ0FMTCBzbyBhbm90aGVyIHRocmVhZCB3b24ndCByYWNl
IGFoZWFkIG9mIHVzDQo+IAkvLyBhbmQgdHJ5IHRvIHVzZSBhIG5vbi1leGlzdGVudCBQQU1UIGVu
dHJ5DQo+IG91dF9pbmM6DQo+IAlhdG9taWNfaW5jKGZpbmUtZ3JhaW5lZC1yZWZjb3VudCkNCj4g
CXNwaW5fdW5sb2NrKHBhbXRfbG9jaykNCj4gDQo+IFRoZW4sIGF0IGxlYXN0IG9ubHkgdGhlIDA9
PjEgYW5kIDE9PjAgdHJhbnNpdGlvbnMgbmVlZCB0aGUgZ2xvYmFsIGxvY2suDQo+IFRoZSBmYXN0
IHBhdGhzIG9ubHkgdG91Y2ggdGhlIHJlZmNvdW50IHdoaWNoIGlzbid0IHNoYXJlZCBuZWFybHkg
YXMgbXVjaA0KPiBhcyB0aGUgZ2xvYmFsIGxvY2suDQoNCg0KVGhpcyBpcyBwcmV0dHkgbXVjaCB3
aGF0IHRoZSBuZXh0IHBhdGNoIGRvZXMgIng4Ni92aXJ0L3RkeDogT3B0aW1pemUNCnRkeF9hbGxv
Yy9mcmVlX2NvbnRyb2xfcGFnZSgpIGhlbHBlcnMiLCBhbHRob3VnaCBpdCBkb2Vzbid0IHVzZSB0
aGUNCmF0b21pY19kZWNfYW5kX2xvY2soKSBoZWxwZXJzLiBUaGVyZSBhcmUgYSBmZXcgZXh0cmEg
Y29uc2lkZXJhdGlvbnMuIFRoZSBnZXQvcHV0DQpmYXN0IHBhdGhzIGNhbiByYWNlLCBzbyBpbnNp
ZGUgdGhlIGxvY2sgaXQgaGFzIHRvIGRvdWJsZSBjaGVjayB0aGF0IHdvcmsgb3INCm90aGVyd2lz
ZSBoYW5kbGUgdGhlIHJhY2UuIFRoaXMgbGVhZCB0aGUgY29kZSB0byBiZSBjb21wbGV4IGVub3Vn
aCB0aGF0IGl0IHdhcw0Kc3BsaXQgaW50byB0b28gcGF0Y2hlcyAiZHVtYiBhbmQgY29ycmVjdCIg
YW5kICJzbWFydCBhbmQgY29tcGxpY2F0ZWQiLg0KDQpJJ20gd2Fzbid0IGZhbWlsaWFyIHdpdGgg
YXRvbWljX2RlY19hbmRfbG9jaygpLiBJJ20gZ3Vlc3MgdGhlIGF0b21pYyBwYXJ0DQpkb2Vzbid0
IGNvdmVyIGJvdGggZGVjcmVtZW50aW5nICphbmQqIHRha2luZyB0aGUgbG9jaz8NCg==

