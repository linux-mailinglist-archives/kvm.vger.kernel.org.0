Return-Path: <kvm+bounces-12585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5B288A491
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 15:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E5071C3B699
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6950514900D;
	Mon, 25 Mar 2024 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZW6u7ZrL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24FC16F849;
	Mon, 25 Mar 2024 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711363169; cv=fail; b=kjIfDd88NlVa7qBmoUJ2L/IPBvcJ2L3cuQFc/Muz7QLwTzuJBMjMNqTMNc0iKlMtHiUtQgp5yydtebkfJv/UJO/GYPdW+i3+wITzBoAVs/S07JrZSNHxT2HGtb/0DzMbS7Vo87zwJpFtGiCcD5kbxduKxfkAwxzbn0X/KgrkzxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711363169; c=relaxed/simple;
	bh=ycroRIzv2+sNlHVF8X3AnFa1S0o7aA5vGlZtjDQs8nY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I7vKmHUUnpKVx6xvvrDo3kZ5ZaHFFHR7xoN3IXAG0RvdrxdElbLBvRGaHuyf4bDWMCTNhNkj7J7Fq1c4cX4Mgm3UEN8SSEbZ9r1ZDsJBcuvwQEy4Py6rF0KES97gW7xoc2xzkZiskXYPqFlCoI7pzqLOiyqmO9qOlULBnDpN6gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZW6u7ZrL; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711363167; x=1742899167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ycroRIzv2+sNlHVF8X3AnFa1S0o7aA5vGlZtjDQs8nY=;
  b=ZW6u7ZrLTnnqrKljAy7QPgE05CBQnNldXSvm0wPNReydDbbFRAOy1K6z
   ZgT7YahHfu5ZD5yCl/we06twEJq5COLyLXDG6+JbEva0EGl5bWdZghbCq
   6B1Mm/upMMDH/lCuHQ5RlBx2PqpMpQ7ZFprB6ka3gnouwPrXbzcspy1ga
   wVCvcf86kQ0YMOIehrLQJGaomVws+0FeaWc1KEbEbDBOuz2jJVqyDi71J
   3Of1yC6aqKf88dVtjEIftypb8ckdcsivtR6p+nFLGX9BIxHioj8QWUK9u
   zADAJ8AlJlijh5ynJ6LFJmtk/mvduWkC4F22Qeu7ln2JFdEo1RnwoG4GC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6211779"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="6211779"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 03:39:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="53037048"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 03:39:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 03:39:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 03:39:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 03:39:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8LVoQRIRg+gzoV1AlBdumxbxUW9PMg+nR8ILktEpTX1xmF95IRfLZCDUupguRVVkt9CM0POqn5M42KmreEbv2dUGnyMyQKK6T7L9PFM0LcWMa1SmQ/9qVeCDQMHwDlT+eUNy5xFktXuFJvq9JB8rpqtnXoCBVdAzNMB9RxnYHFVvloPLscusvAFkQDFxam3WW6lq0W6X9XX6LNUGU48EHK/HPBLv2XpeeoNRQCR+BUMlaRXQPuiMWBLWUR/8dlD2lHGvwKsvjQWYCxi/worBgMv1ANu0nYkFjdqK9vgHqPKStyDsplS6z8BeIjVjv6piASlhZw4kOmPigFLpbI22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycroRIzv2+sNlHVF8X3AnFa1S0o7aA5vGlZtjDQs8nY=;
 b=k/mNyV//agexWs/rmpH1udR54kO1OxzuSokbt5ZuOJLp3UCRqDYtC43GWi9E8ankrDGZL9Bo+OehHHy2xedldsDb092wkXkGjTmEAEBEbVDZzV7+eRysA7lYV/Ez7S9poFQrGoYcNGNOMN/c1ukZ+Rv0rtKno5MHzgORZRrkh+Hcdn/k81S5LqqO4e8TcVi/5FFVo/BzcxiRW3Wv6cyQicYGOIOF/+DRmSayDisBcamd7Eqm2ELP4cnQxEwiTKCo4PL3Ze9HPwalQBF71DmTuoQhPZ5jtMFzKaMQAmpa8GXEErHktrsFe/AtSD8OWPUsyKS/caRYu3Tyk5afX2DNsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6653.namprd11.prod.outlook.com (2603:10b6:806:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 10:39:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 10:39:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHaaI27+nW2+xDcBUuwRQ1CzA45brFDxKKAgADrYQCAA8A0AA==
Date: Mon, 25 Mar 2024 10:39:10 +0000
Message-ID: <59fbe690d1765337b4b1785b4cef900415bd5df2.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
	 <5f0c798cf242bafe9810556f711b703e9efec304.camel@intel.com>
	 <20240323012224.GD2357401@ls.amr.corp.intel.com>
In-Reply-To: <20240323012224.GD2357401@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6653:EE_
x-ms-office365-filtering-correlation-id: bab44910-2dbb-48f9-701b-08dc4cb7ce35
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A/tCJ8FbkDbIyCjcjG6Ozz6oqNn9+OS0tcefDysfu0sMlmVu+o/zTpaKxzOyXnFaOR1c6b0vgMOerokYrvnBdNmSvlEJB5eWdNZyThDh2nG8s1+V3ABC5lZFbIr/WvW+lgNWS/wdVnzDANpHVEDViIofxNDwovZIK1wEBrcK6Wgk9Rw15gAJBOLzCpevAeTdcQ1KyVxqCyBKIB8Z6cct15rIHYhgJ0Xnhj7k0TzYiQo2d8fOVnDS8N1Oyo0Rt2kcOViOSMHc3frdGOiX2E8RmHbq4K7e207LDCDyNOPxx3uYV9haUaMGkuZW+uCp49i9mt+0Sm4gg3d3O7lofsKxzVsmpJQy90YjUFsVItTuBjsPWD6ssjOWHWKhxZzqhDOFaw3QbhBYsPfhjFkcLLXMgireKCo0SHfTAQsM4MSmJzUWWMoikcWODt8pVmR2fi5r+Jy5Pf+t4XyagdqfS0aOz31gA6T5eOF7oBsJltgEtw7ztt25S4im2e6HqTmWeQeE6KFwKNLUyxijrKC08oZsLMNfz32EPr2/XtWQKs8MAsrNK4/nchPaAobhWTtzBVGKX2PF2sNP6dOyn9x+gVge4Vl0cSJuilEo1ZBYYjmbfLKVNg+T2RI3ghws+QNAVpRPSu3Fz6qzrQIaRIrzbPT6miCld3AgxNkZ0uL8GO0e+l6lpSBIW+u5+d5/HqR8lRfUjPnBDH78L6dZL7ZYDAIMzLmBeEbS0YATrdBH6JGkFt4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVlsbzg3ekFxWG83UUZXSkt5UmhHWXBnMkFzMWNFdlpDUWptOUF4WWI3STNK?=
 =?utf-8?B?V0hYbzc4azlqR0pXdnFmRnV0YTh1NGpOVml4Z00rZEIyTlhBUjlCWU91dnJj?=
 =?utf-8?B?aktDSDFQNUJNak11M3lTYnVVMHI2UVQ4czJtdmJvY2lMcmpVV1dvRUx6TEI5?=
 =?utf-8?B?TDhSandnS1loRmpQd2dIeERUaXpuSFdIWEVTZXYxZVYyMDl1eFlMT1oxR1hQ?=
 =?utf-8?B?aEsrQjZ2WkdvdVJnV0pjcFl2VW5GTWZQVWkxYmR0MU1tMWRLM0trSkl6c0VL?=
 =?utf-8?B?SHhucXc0U0tFWkhuVDdQc0x3c2kyNmoxQjhFZ0U0Mk1FOWNEMzFDMFhFVUZy?=
 =?utf-8?B?U21tQUhtREV2dWlZb3kvSzRzSXNvQXl0OTc2Y3h1aTlONXVUWVVTVnJRU2FQ?=
 =?utf-8?B?bkplN3RidElFSCs0dE5PZkswNGp5MUJmWm54YXUybVNCQWVleGJiR1ZuTFdL?=
 =?utf-8?B?T1gvb2E4bmRHUGlleWpYNDVpbE9PL3BWSkNzY1Vqckg2OWNvSDVzQ2lNak0v?=
 =?utf-8?B?L0ZOdlREUU5OR01RSXFpTVdld01NWG9DM0gxTjVQTmVTQTN1U1ltMHJUbHVl?=
 =?utf-8?B?R05tRDFqdWR5MHdIZjF2dVFQZDZONGxhS2hnUTdwQjI2a0pkRnNGdWxERVZn?=
 =?utf-8?B?NEFUeGJkbHBEWnhoNW5BRmhZMmw2QkVaRDhkbkxCeVZlVERNbVNaa1hyekxp?=
 =?utf-8?B?aG1KTHE3bUpqZWNwSkNNOG1POWVZWnZVNHkzNTR2UXRWMjYyeVg2ZktvUUtz?=
 =?utf-8?B?UDEzRDdoVTVSZW5SR0wzMFN6am9GK2o3ZWpMRGFXc3dOdzVua3A5Vy9HNkhy?=
 =?utf-8?B?ZDBPQjcreVBpSXdiT1kxcWdMNkdmd3hhdVZrdHBSUHFPSWVqOGFVY3VCbVN5?=
 =?utf-8?B?b1RuMGFJVnZ5cGhHM3V0ajUvOHRFNEdOYXRWbFY1Z1NCVWxNREtSYThHd2Zy?=
 =?utf-8?B?a2JkNHoxWFdIRkNRck9Wa2VhS0s4UlhBcm02cm8yUnJ1ZDdpQVRvb2lKSTNL?=
 =?utf-8?B?SjN1VkM5Vm01dmQ4TDA2WkV6OWJFOWIwdURtYjN2d1FSc0tnOFQ5cGNDVXh6?=
 =?utf-8?B?QU5YZ21jTDJ2Y1VJdzRjU0U0OHo4eWlsU3VnSnBwUng5eUtWN0JiczNqNGdY?=
 =?utf-8?B?K1dZd3cxMkY1T1Znc2FBNFFyQ1p4WkYzODd4RzBwdjlmRHI0aWtIQ3hwZUlr?=
 =?utf-8?B?YnNuZ0wzdlQrOEdRaFljVHgyQWFkKzQrZnJUQjNDOGZudjMzMHdBL25rRDVC?=
 =?utf-8?B?QU5OY25JTENQS1Y0VGN3M0lMRlVweGVlSnlhSHY0N2VKTS9vNWgvaVU4RFVO?=
 =?utf-8?B?Z2tkbUlQaVA5UlhHdUczREU4TG9YV2huWHJqZUN5Z3A1aTZNb0h6UTh4WVRI?=
 =?utf-8?B?czBBM1BRL0JIb1JvV1M3WDJHSExscVpmeGxwc1REVlVqWTF3UnhUeE5WYUp0?=
 =?utf-8?B?bU94d1d2STlHK1J4d05meVBOR3g1dWdQdWFWaDRNN0V1K3NzODNIN09ycTdj?=
 =?utf-8?B?N2pQYTZsODhpQ1F5SDBsTHJnVFoyYkNTeWNmeFZCcXc5c1IxbnIvL2d4V2d1?=
 =?utf-8?B?MFVtYkNqS0s0dCtFL1YvQjY1ZGp4U25rM3BvVjhDOEgwUTRIc291WWc2aWdt?=
 =?utf-8?B?YTdDSEx2cU5oTThXVy9yMGdEZ2lhNlhWN0J5VmVsOHRNRGRmWWNBZHdzYmVy?=
 =?utf-8?B?R1loTHE5MGt2TVVZTHVlT2JyTzY4VmppUTZXc2Z1MFN6YlBzWTF1Y2wrdXRm?=
 =?utf-8?B?ZkpjRE1sVHZXeFloRUpuZjRRS3RSdWM3OHJjeSsvcFRIWkplVUFnRWZ6MSti?=
 =?utf-8?B?N09nQW84RTlCa1NPYzlIdll5aU15WDhScUtKUFZuakNwYVMweENBUllWekNL?=
 =?utf-8?B?QjJGSllLMnFxNS9tdlY4b0ZMNjZGZnhmUkZlU2xQQnhpZDlhMGNkUWUyUzE5?=
 =?utf-8?B?S1ZXYkZIdW4vQ0M5QWZHRDc3UHRUT1JpYXc5dStpWW0rYWNKTnc0b3kvOTBk?=
 =?utf-8?B?SnlHWERSL1ZXbmNBTTVBQnFOdFFsY2dKS29rMnJCd1g4NG5qVVZlQXYxV1Nx?=
 =?utf-8?B?bk0weHFZL1NWL3k3N2xxcVpyK29DMmZGeldja3JuTmFFUWw5VGhWZE9BTE9q?=
 =?utf-8?B?Nk1XdGpaOU8vajRwa0tpTFR1MGdLakFjL1ZzTDFScVhneitRcHRJTncwN01J?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C002E862C31264DA269968B65FFA8B8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bab44910-2dbb-48f9-701b-08dc4cb7ce35
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 10:39:10.1477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CU7gcuqOIpel6XUzKkTGopBEDHFOTChbFmCKCXunNo7nW5v6fsz5vXipnCam9iQYK3zNl6IJeS/yzTlFEANWzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6653
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDE4OjIyIC0wNzAwLCBZYW1haGF0YSwgSXNha3Ugd3JvdGU6
DQo+IE9uIEZyaSwgTWFyIDIyLCAyMDI0IGF0IDExOjIwOjAxQU0gKzAwMDAsDQo+ICJIdWFuZywg
S2FpIiA8a2FpLmh1YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiA+IE9uIE1vbiwgMjAyNC0w
Mi0yNiBhdCAwMDoyNSAtMDgwMCwgaXNha3UueWFtYWhhdGFAaW50ZWwuY29tIHdyb3RlOg0KPiA+
ID4gK3N0cnVjdCBrdm1fdGR4X2luaXRfdm0gew0KPiA+ID4gKwlfX3U2NCBhdHRyaWJ1dGVzOw0K
PiA+ID4gKwlfX3U2NCBtcmNvbmZpZ2lkWzZdOwkvKiBzaGEzODQgZGlnZXN0ICovDQo+ID4gPiAr
CV9fdTY0IG1yb3duZXJbNl07CS8qIHNoYTM4NCBkaWdlc3QgKi8NCj4gPiA+ICsJX191NjQgbXJv
d25lcmNvbmZpZ1s2XTsJLyogc2hhMzg0IGRpZ2VzdCAqLw0KPiA+ID4gKwkvKg0KPiA+ID4gKwkg
KiBGb3IgZnV0dXJlIGV4dGVuc2liaWxpdHkgdG8gbWFrZSBzaXplb2Yoc3RydWN0IGt2bV90ZHhf
aW5pdF92bSkgPSA4S0IuDQo+ID4gPiArCSAqIFRoaXMgc2hvdWxkIGJlIGVub3VnaCBnaXZlbiBz
aXplb2YoVERfUEFSQU1TKSA9IDEwMjQuDQo+ID4gPiArCSAqIDhLQiB3YXMgY2hvc2VuIGdpdmVu
IGJlY2F1c2UNCj4gPiA+ICsJICogc2l6ZW9mKHN0cnVjdCBrdm1fY3B1aWRfZW50cnkyKSAqIEtW
TV9NQVhfQ1BVSURfRU5UUklFUyg9MjU2KSA9IDhLQi4NCj4gPiA+ICsJICovDQo+ID4gPiArCV9f
dTY0IHJlc2VydmVkWzEwMDRdOw0KPiA+IA0KPiA+IFRoaXMgaXMgaW5zYW5lLg0KPiA+IA0KPiA+
IFlvdSBzYWlkIHlvdSB3YW50IHRvIHJlc2VydmUgOEsgZm9yIENQVUlEIGVudHJpZXMsIGJ1dCBo
b3cgY2FuIHRoZXNlIDEwMDQgKiA4DQo+ID4gYnl0ZXMgYmUgdXNlZCBmb3IgQ1BVSUQgZW50cmll
cyBzaW5jZSAuLi4NCj4gDQo+IEkgdHJpZWQgdG8gb3ZlcmVzdGltYXRlIGl0LiBJdCdzIHRvbyBt
dWNoLCBob3cgYWJvdXQgdG8gbWFrZSBpdA0KPiAxMDI0LCByZXNlcnZlZFsxMDldPw0KPiANCg0K
SSBhbSBub3Qgc3VyZSB3aHkgd2UgbmVlZCAxMDI0QiBlaXRoZXIuDQoNCklJVUMsIHRoZSBpbnB1
dHMgaGVyZSBpbiAna3ZtX3RkeF9pbml0X3ZtJyBzaG91bGQgYmUgYSBzdWJzZXQgb2YgdGhlIG1l
bWJlcnMgaW4NClREX1BBUkFNUy4gIFRoaXMgSU9DVEwoKSBpc24ndCBpbnRlbmRlZCB0byBjYXJy
eSBhbnkgYWRkaXRpb25hbCBpbnB1dCBiZXNpZGVzDQp0aGVzZSBkZWZpbmVkIGluIFREX1BBUkFN
UywgcmlnaHQ/DQoNCklmIHNvLCB0aGVuIGl0IHNlZW1zIHRvIG1lIHlvdSAiYXQgbW9zdCIgb25s
eSBuZWVkIHRvIHJlc2VydmUgdGhlIHNwYWNlIGZvciB0aGUNCm1lbWJlcnMgZXhjbHVkaW5nIHRo
ZSBDUFVJRCBlbnRyaWVzLCBiZWNhdXNlIGZvciB0aGUgQ1BVSUQgZW50cmllcyB3ZSB3aWxsDQph
bHdheXMgcGFzcyB0aGVtIGFzIGEgZmxleGlibGUgYXJyYXkgYXQgdGhlIGVuZCBvZiB0aGUgc3Ry
dWN0dXJlLg0KDQpCYXNlZCBvbiB0aGUgc3BlYywgdGhlICJub24tQ1BVSUQtZW50cnkiIHBhcnQg
b25seSBvY2N1cGllcyAyNTYgYnl0ZXMuICBUbyBtZSBpdA0Kc2VlbXMgd2UgaGF2ZSBubyByZWFz
b24gdG8gcmVzZXJ2ZSBtb3JlIHNwYWNlIHRoYW4gMjU2IGJ5dGVzLg0K

