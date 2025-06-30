Return-Path: <kvm+bounces-51109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFA5AEE628
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 19:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 225527A710A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 17:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D21B2D130C;
	Mon, 30 Jun 2025 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QH8n3Ndf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3596235055;
	Mon, 30 Jun 2025 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751306151; cv=fail; b=XT6fSROhQU4jDJ3/vyTOEV6ngfY/kcuoMe+8+Bg48qOQ1BA8fe6RqqvA10OkuO8ehBcKOk4KTyVHID61UVq3o6/GFlZdwtuESGDbtlsF4YxyaeYsWoWusBJSSWalPUoKYpkMdTcdsiCAdveRnxJEDi0MKUmbCJjInAECZliks1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751306151; c=relaxed/simple;
	bh=J5QWZNYsLj+BNpfQ9OcxIS4LF0mhw576YJuHXDMi3zE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TRU5CYCy6q8V0x6jiHEL0R821yqDvCpWt2TdO+oq6xIiQIPuft0uBP8iKM+gRSN2S66iVI7UB4qKlnnW0ufBWVy7wky+smFltyDraW/+hfQjvnv4kEvzAHlBS73H09qQPNeLFzl+YoQGgZEMIai1O7GbANENdYaBZ3SGKxYcOD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QH8n3Ndf; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751306150; x=1782842150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J5QWZNYsLj+BNpfQ9OcxIS4LF0mhw576YJuHXDMi3zE=;
  b=QH8n3Ndf6XJQZQyggWbT0/hAERdAoiSLYOCUdkJNdZ5wafTTs2A5CcDq
   OQMrHaQKhIDlTL81YiITxd7DsbCn0PC2r5Ja+oNLJuxuLJgp5xRzDzNAb
   mN2xJeskzOFM6lAXPzNxUNoEjTfh3pHaVRcYT5eJ+Mo8mrkmF/V4bzIFT
   rp6AsXqS8N+0RuZVdYAircI+VvPXrU0tyfD//zrOMjvL39kgTLt2QZegi
   mw39CXIY7CPg3HygRvPIeYpcXdh/GPBDNPZ3BXYr3m8DEMuufLuxR7q4n
   RdsTdOQ39Yl/Zlifu/1R0tsALU7RHXKobP+5zMAaohxTdN+WguuBs8yeS
   w==;
X-CSE-ConnectionGUID: QdASecvERmOkJyUMC1Wing==
X-CSE-MsgGUID: OD4p0fueRLKuQxy6J+q83A==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53504233"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="53504233"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 10:55:49 -0700
X-CSE-ConnectionGUID: zpZxo8aCSuelz9gj9ABE7g==
X-CSE-MsgGUID: nEgBWd5pRfGl/xdnaaXhsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="159246840"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 10:55:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 10:55:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 10:55:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.82)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 10:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YE6eVfyqvh59Fc3d5lL3zdpD4m7u9+srYLwQkr0CZgAueRcONCS/Lzt5Hz5JCb+9WJIomVeVVDzwAVnvxNYA3yhMTX88C11GM7hrhA2ipGHBzAbBOSTTF8f87RqphZSw1H65zF/75nASdqmLTFJBXOcpxaM+S3J689arlXmHDT1Nl1lesv0cX9BbP2BinzxzxX/W8NODxJPbBidMW4NnBRpR6uFrRYizsnPFRdMxfai8o21joQ8JMJqMZWzFyys6nbWTM/z4aDpUjU6+lAFE9/C5g+Q7M4Okom1WQGx3tMa5UVlSAlT5D0IUAeKyuiZzdpC0YnLxeIRjYuJnldTceA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5QWZNYsLj+BNpfQ9OcxIS4LF0mhw576YJuHXDMi3zE=;
 b=WJuOjziFixTsrgjgOGy+JWVoX5jZggjPte+nxzjHZOnHpuXF2n9UlKcgbP8Qf1ZcW6g3HKNB/KwIgA7V3TJOju19aSEMcHob+wght6wMHllQ3lhOkmb7oF9FhhzfaoLyy4yYuVvkFcmO80JvccyW1fH0MFt9G275WPyYbFjoTLL5xKVB6lp4QVjsuqiC/D13f42dnukcWaYngie7bp4KlNgiUgjLV20s7P/cEvN41RpOBUAAW7xTjIPu1DaClSEbv/sSl1kDl9B1Ni5lInX2xWxPsPXXZTpqyf0r+i8hVHQsgmGO3Ypscen7e/cf1QTTJ+JaA9jF2PoS/PLWBGChdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYXPR11MB8663.namprd11.prod.outlook.com (2603:10b6:930:da::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.24; Mon, 30 Jun
 2025 17:55:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8880.027; Mon, 30 Jun 2025
 17:55:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoA=
Date: Mon, 30 Jun 2025 17:55:43 +0000
Message-ID: <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
References: <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
	 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYXPR11MB8663:EE_
x-ms-office365-filtering-correlation-id: 3ddaa361-cc8f-4bf3-183a-08ddb7ff55c9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZlpqbFpVREIzck0yeGpkMkJpK05WZUZpVjAycmhaYVViT21xMFZSSXUwZ0Vw?=
 =?utf-8?B?V2h4OVVnKzB6S3RUMjZIb05TVUJndCtFeFlscnhKdmxFT2FVQ29UNDNrMCtr?=
 =?utf-8?B?R0dXZlR2bTdnYjNVRVlVTzFNZ1NRNnh5cUNJZzlRam1URm5mL2xIekNuWEZw?=
 =?utf-8?B?OVRMMGRrRWN6RE1FRENrUGNwY1NZS3RTSGJXQ2pwZTRZQUlYaStNZkJYNDVm?=
 =?utf-8?B?T3Zac2VQL2M1VXpxU0VKQWpSNnVNL2pXQ2N3Q0h4NkIrNEUzYVJOcHAwTmR1?=
 =?utf-8?B?cE9SR1VVTUl3Z21BbDVReDJ5M21RNTd5ZUtYZDBQblBsWXJqdjcraVhHUHR6?=
 =?utf-8?B?SmVLMHNvbWR5eVNheG9STGw0S0F5NS9BSnFqRm15TExwRExXQTV6UE1RWkoz?=
 =?utf-8?B?U1Ftak1URFp5QW95WjF6S09EZ0V2SnNqNHZqTUcweGp3eiswRkxmb0tUVm5h?=
 =?utf-8?B?bVNVeUdibUR1Q2xyM293aWhyVEpqMDV6dEtsQTl1d2JTR0p0UnNtUDFzWVpL?=
 =?utf-8?B?bCtyNUk3SGU5WmxDQTZ4dU82Vk5PTkFJVkpORWNPaVc2N00wR2dFUmdPMlZz?=
 =?utf-8?B?TGdObnMrRHJSYWg4dmdnVXNqaHFGdWIzRWFRMy9uZ2k4VkZGU3NRSmpTNmdC?=
 =?utf-8?B?Ry9FQ1grbGhFZTdSTjNhM1Rlczl0UUIwSHVlaUFyMk16dWZ1SzBXNTZ0eWxI?=
 =?utf-8?B?L0FMY0xoVm5qVHRDamdkWHI0L1FFUnRTQ0Uya0FXYmt0c3ZIMnBDTWY5bi9D?=
 =?utf-8?B?cVlFdmdjQjNmTjVDeVovSDhYd1dXa2F4K3FqcDc0L25hdHRuQ2QyZEMxcnp2?=
 =?utf-8?B?SXlBY0JQQnlHKzN3bVBxOHRHOE1HVnRIRFlUa2J0UDArUU50RWtFbEJxRnFQ?=
 =?utf-8?B?NzVtd1FFMU9iaFFYWTFDY1hvRG0rNjg5UU1XY1ZyKzhNM1BUMkJzNmNUT2NR?=
 =?utf-8?B?cGVQTXhDaVY4VURhM0N0SUxUdzRyT0JRR0Y5Rm9CNUJUQjBYeDQyMU1PaGNK?=
 =?utf-8?B?b3l3dU95Y1Nla3A4YzBmWEdaTWRwc1Z0UnNxWmlacGgxQThIYjE1SEJOcWdh?=
 =?utf-8?B?VWtXcndPcHRwWm1XWE91UER3bVdrRGw0aWhqLzQ1M25WaVE5R1hXeFBpa3Rh?=
 =?utf-8?B?d1RVSHkwTUNrQ1Z2TzZzY0VZMnlNNUUzNWNaOVFPR2Ftdm9YNjg0dVRuNC9z?=
 =?utf-8?B?LzV0c1ZSUXVrdnl1TlBvekpVS0ZuRzd1M1NsK3VHKy9TeXVzbk56OGc4RmRT?=
 =?utf-8?B?MUlZRHE1MjRtelNpeTdPeUIramMvWG00R2hHc2VhSjkrelh6MFc2cE1xWHU4?=
 =?utf-8?B?eDNwbFdhMkkySUMwaXloUmNHL3FuSzdUZTZpYU9jcy9TcGplbGpGNzZpNWI5?=
 =?utf-8?B?S2tmaVJ3VmZQdDhEcEpoRVVYZERCVEFKTW9UMjhUdi93SFVkZ3BYSjg2VDdW?=
 =?utf-8?B?QmxSandVZjNOelIzL2FZbDJHR3JiVlUxelk0dG1iMGZIVXVpR3N4Y0VveTdN?=
 =?utf-8?B?TVEvRHZoN2cwS0tNMkxTVHZBNXRqL0NuT2JkaisyV2xWd1p6VjhoM0xNY3FE?=
 =?utf-8?B?YWNVTWFsN2VYcXd3VGFKSDRuVmJlT3ZGbFdaU0pBSExVYVhGTWhmSjRsWW1t?=
 =?utf-8?B?cFdCOEx3WFFocnlxZnZTK3g4TWd4Sms4TVprUlF4eXFWdWhyalN3SVRPWkR4?=
 =?utf-8?B?T1kyNzNLQjB2Wk5mRUFwQWFSV2FaQTVZRThsMlV4TkwrelllUzJjQ1JsRmlw?=
 =?utf-8?B?ektuMmRkVFE2RnkxdElKSVprU3hwUUt1RDdMYjkzTFZmUit3OGgvNVZmN0Mv?=
 =?utf-8?B?WFBKeTl0bkNnNlZHWWhtbW5Oa1RrRUZDbE1odmcyaGVrNGxLU1MrSXpVQnZ2?=
 =?utf-8?B?N2VHNk1XcXU5bEVaY0pRMFRaWnJCQlc0YmdlNFhRUEtmS2FjK2ZyVURLVmFj?=
 =?utf-8?B?b0U0OVNhOXBGY0xybUtHRCtIZnp4L2JvZ1FxZFJNR05nNFBPeTN4Mnl6UWhQ?=
 =?utf-8?Q?M4ZvW0w3O9J56Rtr05tBvyGc5PD7as=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWVLTmtuTkY0bnFPUVA2OHZ2VmplS2p2ZlZiUnBkdHdsVzFyZ1N5QnpRY09l?=
 =?utf-8?B?V3JFOUU5QThWV1pvZDh6RWdTRHowT2pTVmZGWE9CRCtld0Foa3dnbFFVbmxz?=
 =?utf-8?B?aktHV3IwVUxiY0JIYUVxUm03Q28ybzUvb3N1ZjBacC9kTVh4Y0ZjcVhvOGpa?=
 =?utf-8?B?OGpNaGxwUzIwRWVraG1PZlpjQUdScFAwanFoVlVGYVp0YmVxQU82Z1VuTGho?=
 =?utf-8?B?SXdwVVBxVnFKQ0FCMmpvRXJCckw2dWFnQ1hhUGdCNHExS1l0bU95aGVYVFd1?=
 =?utf-8?B?MUI3S1lHQ1F5dUZIM1dWQzVadVdJd1dZK0M5STR1ZlBvdzZrdUhkOGxjd3h3?=
 =?utf-8?B?RlhwV1hSUmI1bUFsajE5NE5ZdWtrb0JFM2ovZExVWnhKc3IrZXh3K3ZuRCtk?=
 =?utf-8?B?NGlrR1Q3QjBLVThRWTJRdVlzMFRqa0xqc0dXMEwzSjErdk5vaXFKc3EwWlFF?=
 =?utf-8?B?RmpsSGhScW85b1V4UFhnOW1IelFIbkJ0azRaa1V3bG1vdXBwWHMrRVAyeVRD?=
 =?utf-8?B?QXBjL2F0QWJqREVaMmRVMHg5R0xNdHBYZWM3S2JTekYwN1RqVExwZGhZcTdj?=
 =?utf-8?B?eDArcm9aOE95NHJUNHBCc3kvVTU3QXQwamFyR1I2L3c1Z0t3UHR4YjZXOE9q?=
 =?utf-8?B?ZElUdFFkNEt4WjhGODl4TTZFYndnTWhOaWZ5ZDZQbTV1dU9Kam9IRmFPQlIx?=
 =?utf-8?B?WWNSbGtHK2xGbjZPZzdPMTlFa3gyb1MxWEFuRTladTcrQjVOeUFrb3pRQlZE?=
 =?utf-8?B?ZFF2MWdsR214Y1lUN0tUanpvdlZvRVBNemJrMkV3cm40dkFJVXRKczhHQ1dq?=
 =?utf-8?B?UDdsTk5mb2MvNnRMUFZ2V2o5ZlFkdnk0azBKVTZlSzFjZ1JoNThGL200MkZ4?=
 =?utf-8?B?N2hlYTVYSGpocWF3K1BkcUVEcGxmQ21FN01mVzNXc01zdFphTU03MVFiOVdh?=
 =?utf-8?B?WHcvOGduZ2VsSlBtU3BaS2dDUnRlRmtvaDFNMXREZndVZ3lONWd0T2FPQ2dN?=
 =?utf-8?B?bzdGYnVUTFBmTEhtTzhmYm9xTkVqalRMYzN0cThsYXVOdUF6RmpteEN5U2k4?=
 =?utf-8?B?MzZmY1V5VzEwODdaZDRtdWNYVFFoUXc1bHRZSkpFR1JFYmxBZHNQclZudFpD?=
 =?utf-8?B?bDZKT2ZGQXQ3Vm42N1BuNlVGNVpjRHlpS1FpUWxRc1kvRmlIZHRPRTFPWm9z?=
 =?utf-8?B?Y3llNWgvdHd6YkgvQzM4eUhJUnRYcWxYQUs3bFQ0VEpBSW9xZ3N2bEh3QjJs?=
 =?utf-8?B?SloycW54QmlnVW51TS9lalZ1MjZwL3lmcnVueG1BU2JLNU9peVQxdnBvRnE4?=
 =?utf-8?B?OUMyYVRFYlp0YUFYVFhDc0h2ajhTTGR4VUZIZ3ljejAra2FmbkNpKzRzamU0?=
 =?utf-8?B?RFp5OWVtbkxJeDNIUjNWWk1TRmR1R3VWbCtnMyt5M1dERk5nbXlGR0RzakZ3?=
 =?utf-8?B?dnJIampTYlViYmZadjRCOVFTSlVwcE44MWltRGw3Z0kyYVhQeGcxSm5mRWw5?=
 =?utf-8?B?VkF4bGVVY1huTDc5Qi9uZWdSVXdVZzNxZGc0VzVxQUEvdVM5VW9XZlhrYktU?=
 =?utf-8?B?bzB0QkFCd083RWF1U1Q0bXVOUkVJTFZZY2JTSUFFQ3J2SThFZTg3MVYzRXow?=
 =?utf-8?B?WE1Id25oWjV3THhjMm5kTjRqV01tWU95RU9WcmpmUjVnRHg1MFNjSmZIZ3hk?=
 =?utf-8?B?aTZBbWZzMkxZaHRPeElHdXpWME45QzVSMi92Qk84NmJYNG9GKzR2OXBnRlhN?=
 =?utf-8?B?eVhXQU13VGpLbE9PdmlhNm9HR3FuaklDdml0K3ZNenhDUldLd3NuMnZnVi9h?=
 =?utf-8?B?My9nUmtld2dQRXUwRzNNMzI5ZUZudE1IYmFzSVpKTldtOGp4RUE1eGIxVEc0?=
 =?utf-8?B?cG82WFZwQzFKSXVGQUdCdEdxdU1vOUdIVXA3QlhydWQrRDdRVngwSm9xcG5N?=
 =?utf-8?B?RkVWeTlWQUl6aXU4TmNRK01ZR0oya0dLcVltWnlHeERiNEtwd0tsaVNWcWhk?=
 =?utf-8?B?c0lsOTVpM1RDeVplR2h3VVNaN0ZVRXlPbEQ0VTlQNkVLZUhSYXNUcmhKWThz?=
 =?utf-8?B?eEVEMjl3ZWJENENESVFmaUFOOGtrNmQ4RWJnUHlSK3lvUVpvWWxjZHRxQnN0?=
 =?utf-8?B?bXJuTlNncEdwam85Q3JnVEk4b2kzb1N6MmN2RHRCVTRNSUFZOGZKWkdUUkdO?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8D032CEEF265840B9756F70096E5812@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddaa361-cc8f-4bf3-183a-08ddb7ff55c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 17:55:44.0146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hUAZ/kfQsZAdbR4UFCsud73FgrxnbBUbyqVWaxl9UGYo8KO+KapUp5apv6zRnPrDveiC3NY3e189sOybpkxnaZms21QE6ZFXggbBXERHN04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8663
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTMwIGF0IDE5OjEzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiA+
IG9rISBMZXRzIGdvIGYvZy4gVW5sZXNzIFlhbiBvYmplY3RzLg0KPiBJJ20gb2sgd2l0aCBmL2cu
IEJ1dCBJIGhhdmUgdHdvIGltcGxlbWVudGF0aW9uIHNwZWNpZmljIHF1ZXN0aW9uczoNCj4gDQo+
IDEuIEhvdyB0byBzZXQgdGhlIEhXUG9pc29uIGJpdCBpbiBURFg/DQo+IDIuIFNob3VsZCB3ZSBz
ZXQgdGhpcyBiaXQgZm9yIG5vbi1ndWVzdC1tZW1mZCBwYWdlcyAoZS5nLiBmb3IgUy1FUFQgcGFn
ZXMpID8NCg0KQXJnaCwgSSBndWVzcyB3ZSBjYW4ga2VlcCB0aGUgZXhpc3RpbmcgcmVmIGNvdW50
IGJhc2VkIGFwcHJvYWNoIGZvciB0aGUgb3RoZXINCnR5cGVzIG9mIFREWCBvd25lZCBwYWdlcz8N
Cg0KPiANCj4gVERYIGNhbid0IGludm9rZSBtZW1vcnlfZmFpbHVyZSgpIG9uIGVycm9yIG9mIHJl
bW92aW5nIGd1ZXN0IHByaXZhdGUgcGFnZXMgb3INCj4gUy1FUFQgcGFnZXMsIGJlY2F1c2UgaG9s
ZGluZyB3cml0ZSBtbXVfbG9jayBpcyByZWdhcmRlZCBhcyBpbiBhdG9taWMgY29udGV4dC4NCj4g
QXMgdGhlcmUncyBhIG11dGV4IGluIG1lbW9yeV9mYWlsdXJlKCksDQo+ICJCVUc6IHNsZWVwaW5n
IGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCBhdCBrZXJuZWwvbG9ja2luZy9t
dXRleC5jIg0KPiB3aWxsIGJlIHByaW50ZWQuDQo+IA0KPiBJZiBURFggaW52b2tlcyBtZW1vcnlf
ZmFpbHVyZV9xdWV1ZSgpIGluc3RlYWQsIGxvb2tzIGd1ZXN0X21lbWZkIGNhbiBpbnZva2UNCj4g
bWVtb3J5X2ZhaWx1cmVfcXVldWVfa2ljaygpIHRvIGVuc3VyZSBIV1BvaXNvbiBiaXQgaXMgc2V0
IHRpbWVseS4NCj4gQnV0IHdoaWNoIGNvbXBvbmVudCBjb3VsZCBpbnZva2UgbWVtb3J5X2ZhaWx1
cmVfcXVldWVfa2ljaygpIGZvciBTLUVQVCBwYWdlcz8NCj4gS1ZNPw0KDQpIbW0sIGl0IG9ubHkg
aGFzIHF1ZXVlIG9mIDEwIHBhZ2VzIHBlci1jcHUuIElmIHNvbWV0aGluZyBnb2VzIHdyb25nIGlu
IHRoZSBURFgNCm1vZHVsZSwgSSBjb3VsZCBzZWUgZXhjZWVkaW5nIHRoaXMgZHVyaW5nIGEgemFw
IG9wZXJhdGlvbi4gQXQgd2hpY2ggcG9pbnQsIGhvdw0KbXVjaCBoYXZlIHdlIHJlYWxseSBoYW5k
bGVkIGl0Pw0KDQoNCkJ1dCwgYXQgdGhlIHJpc2sgb2YgZGVyYWlsaW5nIHRoZSBzb2x1dGlvbiB3
aGVuIHdlIGFyZSBjbG9zZSwgc29tZSByZWZsZWN0aW9uDQpoYXMgbWFkZSBtZSBxdWVzdGlvbiB3
aGV0aGVyIHRoaXMgaXMgYWxsIG1pc3ByaW9yaXRpemVkLiBXZSBhcmUgdHJ5aW5nIHRvIGhhbmRs
ZQ0KYSBjYXNlIHdoZXJlIGEgVERYIG1vZHVsZSBidWcgbWF5IHJldHVybiBhbiBlcnJvciB3aGVu
IHdlIHRyeSB0byByZWxlYXNlIGdtZW0NCnBhZ2VzLiBGb3IgdGhhdCwgdGhpcyBzb2x1dGlvbiBp
cyBmZWVsaW5nIHdheSB0b28gY29tcGxleC4NCg0KSWYgdGhlcmUgaXMgYSBURFggbW9kdWxlIGJ1
ZywgYSBzaW1wbGVyIHdheSB0byBoYW5kbGUgaXQgd291bGQgYmUgdG8gZml4IHRoZQ0KYnVnLiBJ
biB0aGUgbWVhbnRpbWUgdGhlIGtlcm5lbCBjYW4gdGFrZSBzaW1wbGVyLCBtb3JlIGRyYXN0aWMg
ZWZmb3J0cyB0bw0KcmVjbGFpbSB0aGUgbWVtb3J5IGFuZCBlbnN1cmUgc3lzdGVtIHN0YWJpbGl0
eS4NCg0KSW4gdGhlIGhvc3Qga2V4ZWMgcGF0Y2hlcyB3ZSBuZWVkIHRvIGhhbmRsZSBhIGtleGVj
IHdoaWxlIHRoZSBURFggbW9kdWxlIGlzDQpydW5uaW5nLiBUaGUgc29sdXRpb24gaXMgdG8gc2lt
cGx5IHdiaW52ZCBvbiBlYWNoIHBDUFUgdGhhdCBtaWdodCBoYXZlIGVudGVyZWQNCnRoZSBURFgg
bW9kdWxlLiBBZnRlciB0aGF0LCBiYXJyaW5nIG5vIG5ldyBTRUFNQ0FMTHMgdGhhdCBjb3VsZCBk
aXJ0eQ0KbWVtb3J5LMKgdGhlIHBhZ2VzIGFyZSBmcmVlIHRvIHVzZSBieSB0aGUgbmV4dCBrZXJu
ZWwuIChhdCBsZWFzdCBvbiBzeXN0ZW1zDQp3aXRob3V0IHRoZSBwYXJ0aWFsIHdyaXRlIGVycmF0
YSkNCg0KU28gZm9yIHRoaXMgd2UgY2FuIGRvIHNvbWV0aGluZyBzaW1pbGFyLiBIYXZlIHRoZSBh
cmNoL3g4NiBzaWRlIG9mIFREWCBncm93IGENCm5ldyB0ZHhfYnVnZ3lfc2h1dGRvd24oKS4gSGF2
ZSBpdCBkbyBhbiBhbGwtY3B1IElQSSB0byBraWNrIENQVXMgb3V0IG9mDQpTRUFNTU9ERSwgd2Jp
dm5kLCBhbmQgc2V0IGEgIm5vIG1vcmUgc2VhbWNhbGxzIiBib29sLiBUaGVuIGFueSBTRUFNQ0FM
THMgYWZ0ZXINCnRoYXQgd2lsbCByZXR1cm4gYSBURFhfQlVHR1lfU0hVVERPV04gZXJyb3IsIG9y
IHNpbWlsYXIuIEFsbCBURHMgaW4gdGhlIHN5c3RlbQ0KZGllLiBaYXAvY2xlYW51cCBwYXRocyBy
ZXR1cm4gc3VjY2VzcyBpbiB0aGUgYnVnZ3kgc2h1dGRvd24gY2FzZS4NCg0KRG9lcyBpdCBmaXQ/
IE9yLCBjYW4geW91IGd1eXMgYXJndWUgdGhhdCB0aGUgZmFpbHVyZXMgaGVyZSBhcmUgYWN0dWFs
bHkgbm9uLQ0Kc3BlY2lhbCBjYXNlcyB0aGF0IGFyZSB3b3J0aCBtb3JlIGNvbXBsZXggcmVjb3Zl
cnk/IEkgcmVtZW1iZXIgd2UgdGFsa2VkIGFib3V0DQpJT01NVSBwYXR0ZXJucyB0aGF0IGFyZSBz
aW1pbGFyLCBidXQgaXQgc2VlbXMgbGlrZSB0aGUgcmVtYWluaW5nIGNhc2VzIHVuZGVyDQpkaXNj
dXNzaW9uIGFyZSBhYm91dCBURFggYnVncy4NCg0K

