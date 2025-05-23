Return-Path: <kvm+bounces-47651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 717C8AC2C7A
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A7A69E79DD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53590217668;
	Fri, 23 May 2025 23:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mafyoDdD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA4A20E03F;
	Fri, 23 May 2025 23:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043670; cv=fail; b=r5WInSKiulKjH9GdYzpkeKZdhvgOrFyB9Wnk1Ho01TVOT+GaP2ORZ8M+gLAY2DOqBjMBMuMJ9LdU91dc1/gTzRoBFGYi0h1ySrGZfWU7/lhUspKwPc+6j6s9WTz1YzA4REwg77HFNHA2oc9121M9KU7aKJo9UlVppNmEILi+RuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043670; c=relaxed/simple;
	bh=Sll+Ghz5Nvnq+27gvqlwDJTF2e1JPxgzXS28dzbXN14=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mvIvqM+B3L2de1FZMq0nhfsGa52BWTqBGy0DWMwdyEborRw116TlZmArCkmE+HMbuzwn/9HagHIn8Vo6V0Lsl/8E/l7IpZ1EzoWIbLMPvtBXbrU3/ZX6sZOOCho4UtEuQtbk8xLqdzkRJw03AYQ7u06/iKQ5V9q9JzZBiq3BHNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mafyoDdD; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748043668; x=1779579668;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Sll+Ghz5Nvnq+27gvqlwDJTF2e1JPxgzXS28dzbXN14=;
  b=mafyoDdD0KIFi0iUwO3KywVywFCRrKbQVCHZ+6AElmVJV3DqZkSaZmMP
   1vAnOBKS7mpZjKW/GQP+iv46BHSetpaMlmqfp/rXss19Nxgk0gW1AcHSf
   naM9FqPED+ZfI+h8ywBDsvfDonMVlBzumeaSRbT8woLturUCqXQlffuZa
   8P1PZm9INZ8kGCuJ/XCtq1KuEXEd76rIyYVYs13/mWp5qrPrI7AgL2f8/
   /ENJ+aJzqQjkv9eXu5PVHvd3SrLmDgNwzO0mAF8TyVes29F1DVNPmfQgF
   ZqCJwR68R9sgrASGLnxVhlGakRiRTsMb+ImxppoXzflyk/Yy/+5Cs7Ltu
   g==;
X-CSE-ConnectionGUID: UW29It1VQw+weZCJkQej7g==
X-CSE-MsgGUID: 54y2vVY0RYOS3JQrfBt0lQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61158781"
X-IronPort-AV: E=Sophos;i="6.15,310,1739865600"; 
   d="scan'208";a="61158781"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 16:41:08 -0700
X-CSE-ConnectionGUID: fz9dHuosT1WsNU0ejSSO2g==
X-CSE-MsgGUID: GVZzGNHxSjOpmy354NiLTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,310,1739865600"; 
   d="scan'208";a="146331439"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 16:41:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 May 2025 16:41:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 23 May 2025 16:41:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 23 May 2025 16:41:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBL/HD/7oRzW62t1B6RtlmKr0TuoH2+QxaePs0w4yzKCMJ+IcMssshQ+4q25GgD6XBiDN9ljn4VmT6qzIPbuLwBj1JEsjyMv3mZpEbuFuGM+Rx0W7n+kJO3OWOk8b7DnT5FmbOFYx/tH231rX41Co5UoaYm3T0stYOKMC6skn9MYsbwVrGtg0AiSNWD0H/5+wHiZwZgVuErjTh39UJoLb0MRPyoR7zE32rn7gprdxsVBdLIlW7qF22obAbB3RP4Y9K8q5wq+a5kY66Gzavb1cukZsFLDqmo7EgIyfH6tiOKkctLJfJChW3C4v4IusV/HE/7yCipByD4MtmjAag/dIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sll+Ghz5Nvnq+27gvqlwDJTF2e1JPxgzXS28dzbXN14=;
 b=gcm3tMUI2msw6qVBihGqQsK9kjHVEGK+DT71D2cAC3aGQld8h+ClZ2PouO7g0ZIZHjW2ucNednRhkcK3/9K9dw6l5l5lt1JxcTt9d+9I4CiCbyNG0ZtG8tlwaDeMDnUaeJzcNOy7Dc7gIzeYspwdePeSRgFcOQzzR87PH9YAI+Y67CFwZuxbPdjdi25zpryJ0rI3WSPvakdc51+LsQ8Q7ammMFPmUV4HibasDbXX2qd5ZKFjx2KGw0acAASuZav1S59YebVf8U4gxH7yScDQqjDgm8iqwenoj3Gdk6Prk0BMvftgS0CxUR7M8EPmT3PxDHq1k4UGAYn64SxlHdUCIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6219.namprd11.prod.outlook.com (2603:10b6:208:3e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 23 May
 2025 23:40:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8746.035; Fri, 23 May 2025
 23:40:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgAH4cQCAAMy3AIAC3hsA
Date: Fri, 23 May 2025 23:40:25 +0000
Message-ID: <25e5dcc794435f1ae8afbead17eee460c1da9aae.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
	 <d922d322901246bd3ee0ba745cdbe765078e92bd.camel@intel.com>
	 <aC6fmIuKgDYHcaLp@yzhao56-desk.sh.intel.com>
In-Reply-To: <aC6fmIuKgDYHcaLp@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6219:EE_
x-ms-office365-filtering-correlation-id: f65f1cd8-c33a-436d-42ad-08dd9a53312f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHVBWXc4VmVYbFF4U0dlVkJmUS9VWDZWK3gwTlQzR2U2cEJjZlpFKzN2WWt0?=
 =?utf-8?B?N0w2TEloc1FkaTBJOWkxUU9VTWs2U3Q0cmhVTGIvUERURWZuSURWWXRQNytS?=
 =?utf-8?B?SEFTV1loSmRmeWdPZWFhejEzUmFadTMyNmEwa3dzZHFHeVJHd0JyQi92K2Ix?=
 =?utf-8?B?eExyNDBUWnUwR2cvNlo2VXZMYUora3psZTVNV0YyOVowWHJmWUROUWxDMnRD?=
 =?utf-8?B?U3dYTWlCSXV6ZWc4Vkc3L0srOVpXWUFYK0pOL0hva0xtWWlTaDhXNG9qdTE5?=
 =?utf-8?B?NkZqZ0RaS082ZHBVYXNiN0NtWXBsRHdWVDdsd1doTjJENWZJaVVxdlVsb0RV?=
 =?utf-8?B?RzhNOThSOGlYenJnTGNtc2tkMzJKOFlCcklSdkJLQzhLYUpBNHI5M1dVMkFI?=
 =?utf-8?B?a011cmgrSTdDbGgyczdSR2I5SGV2dTJtS1pmakpkcmptbjR0dG4zWmd6UjZW?=
 =?utf-8?B?UkRaZFBxMHRBWW96cWNOQjB1T0Izb2g2MTFrYjVhNStJaDFWQWNGTVk4UkJG?=
 =?utf-8?B?ZWRKd2J5OHV6emF1NWFNYXdmci9OL0Jsc21rZFZsYjhIUThQTEd4Mitialh3?=
 =?utf-8?B?WjFzbEM3TjhWbGo4ZDVTTExaMHFBVWJYUWpiZ1ZDcVRIWVZHV05yL0JpK21J?=
 =?utf-8?B?bzhMQUJab3RScVBzYmI3bExwNEJ4OFZMZnlTa0VYZldEVHl2cXp0aW81bWZE?=
 =?utf-8?B?S3hJU3pJU1BRN29PN29BR2srZ2FHa2NNR0dPTWtieGw4MktpSnJEc3J4SlI2?=
 =?utf-8?B?MWNBZmhtK0J1NDdUUDNCYUFqcDFJUHJwSzg0NFhUVkdPZHRiV25Pak9uVEo4?=
 =?utf-8?B?bFcxeHlWN0x5SE5HZkx2dEpCRWo5VWxONmxzNm5TK2RkdGtqajc2V3dZaGRr?=
 =?utf-8?B?Tjd5WmxFREZETTA1SFl6S05jb1I2T3h6emFObExMYktpZnN5a0RiTXlpNVE2?=
 =?utf-8?B?WDgzSlYvdHh2TzBkVU9TZkQvYUhOcDJZalc3Zk1aOXFoWXExdThxMXE5LzVl?=
 =?utf-8?B?Z2dUV3B1L1B2bU8ydzJJcE56SUp6NlJrMEJXNWZ4bE04NW10NVFQNlA2SFRa?=
 =?utf-8?B?NjVONEV2OFR5MnRsZ2U2bjQvaVU5VHQ4VTlTSjZieXRiN0V4NFFoZERpdmoy?=
 =?utf-8?B?Ti9XQUVlcDRJVFVhdVJSaDBHam9nT2NiYW5hUCtDdjhHajdkcm14SGpka1dx?=
 =?utf-8?B?WUFnZXpjdjdWT2lqaEwzOWl0N3puZk9HaTU2MkpsVjBoUDVDM3V4R0xRbnVD?=
 =?utf-8?B?V3J2QUNWbjJOMDdqSnMwOUFyTW5ZZjJ5SmsvckQ4b2xuejRXQjlMZXBRN1Bt?=
 =?utf-8?B?dDV2SWExZzB3RnlDK0NMNFFudmUvYjBudmhIWkkvdmlDa1FqeEdNK1RUVkFR?=
 =?utf-8?B?ejEyZXBCeGduR2ppUlJGUWwzbXFyQ3NpZUUxeHZ3enBmSzBBdnpDUS9jTVla?=
 =?utf-8?B?cG0xTFZaeTFOWGwrWXZBajF5S05kRyswNGMreCtmRmZkWGJ0M00wV09Lc216?=
 =?utf-8?B?OWZ6RWtodys5M25zOEFBemtKVEI3SEt6Rk0yZU1qc3F6Q2hTWnV0S3ZjTEtm?=
 =?utf-8?B?TFkwOXphVGwzTmI3VU0vSGhIdmNOWlNHdzN2V2I4N3czYW9UMFVHY0dkeitu?=
 =?utf-8?B?bXFkcURLb3VZaXNBbkN6QWNwcHJaNm44SW9MNDc2SHV4WWNNSUpVNUU5dTFh?=
 =?utf-8?B?NG5XWEp1aDh5VjJ5MlF6a1Rac2xTNzFQeFZobER2eHZhYlZMaUJMQWxsMjhI?=
 =?utf-8?B?ZCsrZnlRSnY1SDNiYzZCQmcxWkhlU3lMcCtzZFJESkpTTFBiQ2dHN2wvUHFr?=
 =?utf-8?B?b1pRbWVUREJITFppRTQ1OXZnVnJuTlYzWVI0NVZIa2J1ZUxQUWpWYTIzZTR3?=
 =?utf-8?B?dWRoV0MyMmgxWG8xSzMrZ3FTUDNvbUFwSlJGN2VnbjYyNytPS3drbU1VaGM2?=
 =?utf-8?B?V3JrQ01QaHloQzRvdU4zWk1aUk5lMXhqUUI5aXhpcmZWNG0wTVJJN0dOdHlH?=
 =?utf-8?B?eUVFbFdzeE9BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0VoM3M1UWlna0VZNkdsREgyTHZQNkRaQkNXWi9IZ05yN3RwQVBXVTAzOGlt?=
 =?utf-8?B?TDluSk4zTEJSd2l0N2Q0ajRXT1lHOFFLa05CRDZqeUNOUkZ5UjdkSjdPWWN2?=
 =?utf-8?B?OGhXV3RPWTFqVzNadG5aUENRTnR6djVHMjY3TkxrcmNNTGpXNjYyR2RUbFIv?=
 =?utf-8?B?MjBNWmRNTjBJSDlYOHRLVFhyYTVZY3JSRktJVGhVTmlQbzB2RXMwY21Oc3Fj?=
 =?utf-8?B?QXRuaHJIYUkrbzZwUlN0eEFleVpDYmwxTnp1WjRyUGlIMHBlN0Vvb1JJRDli?=
 =?utf-8?B?MDduRzFjeEZaQ0VUTHMvVGZPbG1CRktPbWpZbk5ENlJ1ejhvWUtXZG1mZkQv?=
 =?utf-8?B?b2VYdXlRM0VaTjFQUnpzUzhiNjUwTHN1UTFyaGczcFRlUDVQZ2RoVFo4R0NK?=
 =?utf-8?B?dFJsd0hIL1BRaHFKMWVLNzNxaGxRT29TdTdVdnVhR3d6N0hHZmQxWW1FVWJh?=
 =?utf-8?B?SVV0UmpzcldZVlNLUzdIZDdnSjJFcldFTCszV0dLRXdzbThPd3QyYUxaUzhH?=
 =?utf-8?B?ZnFyRkxINDlDcTlGVkl5Mkh5K3pSbzNXSkRnSDI3S2s1S3Jrc2dvZEtPWU0w?=
 =?utf-8?B?Mm4yeExZQ3JSbkhReEJzYk56ckowUS9rUkpPV1pkdG1tdGREdkYrOENvbWh6?=
 =?utf-8?B?Z0JiRGk1WmVmZUI3MnlGZXRMMVNwUDB6c1hrZEVkelkyQnBldDdoUXRVL0JM?=
 =?utf-8?B?eHhwMDNvMzNOeDNnYWZYNjU1Rm5GTDNsSGVUa3MwbUlQaWZmVnFwTHkyZHJR?=
 =?utf-8?B?UHVxQXNMaFk4dHJZN1VTcno5Q1NZbmI4NlNwMCtGcm44VXJsSHFQOXVKSEgx?=
 =?utf-8?B?MGIxNHVYOVVTTmkzSDZ2QU1td1phaXZoS1RibDkzcHVWUnIvZnlFQ29MSFFw?=
 =?utf-8?B?clMwMEQzbnd4Rk1sbldTc21zMVlyVU9KbXRoa3hPTkxMbUdzemlXZUQyUG9U?=
 =?utf-8?B?emZlYklxZ1hUcm1IdUtpMG9nRkMvZnNIVFZsNDd2cXRPN2hwcjhjK3lTcmEy?=
 =?utf-8?B?bTEyMUdoYkErd1JZUlAwbVpVRGdIblFmSkkvNGZ5cTZDN2FzM0k5TnBFcDAv?=
 =?utf-8?B?T2dJcDZoNExzZ0E0R3RzNS94Lys0eHd6QnRuRlVJSUdZN3ZXMmZhQUUzZHlQ?=
 =?utf-8?B?dEhQaEY1cEJZanltUnlMV2ExN3RNWVRPL29FcWlaQTFzVFdFY0tMTEZ3TEF5?=
 =?utf-8?B?M2FUZUFnSTg2cnJVN1FLbHpPZEU3T3ZSSHdOYkxGY2NvaXh3VnQ0ZElFMTkr?=
 =?utf-8?B?bFNKU2JOMmQ0NGFvU0lkYm1jK3pXWWJHZ3o1OThQekQ3VVhMMGFEd2FhM1VH?=
 =?utf-8?B?YWtaZ29LMHhFYTFjaHBVZWllbmhOSVRCMk92azRYc0dEeWg4THNXNDNoQ09Q?=
 =?utf-8?B?RmNraEtVTkY3TG4wK0R5OVZaQUdUVFlTSWdKVVVOT1hZa0NuNVhXSUlyclA2?=
 =?utf-8?B?VitJTS80djhlMmozdzBGL2hGc1o4bGkrdHdHalBPSVJOTm1MTnEyUDlkRG1P?=
 =?utf-8?B?OG1lMllpSzBvRFFzaFFRbjVmS3hTYzl6VWJkcm4wRy9tRk00UFk3OGJOQnYx?=
 =?utf-8?B?d2hDOXUxbUdGOERENGR4c3hjVnlXeDE3d0RVdHlmY2pKYjNsVkQ4QThDbUhz?=
 =?utf-8?B?alRNMXlwMUV4Y3NoR3pFRE9OY1c5cGNmL2dFNkN5cFpiZndDQXZNR0U4b1d4?=
 =?utf-8?B?NGFlR1crQUR3Z2FpR0dmMXVmeUxoS2FFWlhTQVBwanhURkRSVVg3bHNEQWlr?=
 =?utf-8?B?Ty80WVZZbWc0QmhHZUFicW9PMUtJa3ZoaXJMZFRIT0lrS0FwcFY5amJTamtF?=
 =?utf-8?B?ZVc0d2F1ZHhGdWxhcWs3T2psTWdDZUNWWlN6NzY1MWNiaEtDT3VqNUIwQUxW?=
 =?utf-8?B?OGRrQkZlUTFiQ3Q0azIramFWeWhTZEI3R2crakV1UjhBKzdKTmExMW11NFNj?=
 =?utf-8?B?cWpaTXp5QlJtajh4TndHRlc3NTkrdXhMSyswMmZ5S3hLeHVIVUFBUVVIOVRG?=
 =?utf-8?B?cWtaK1lYb2pncFl6eUF4M2l1dVZCb2hsYUxub1ZPei9LKzFIRTlvckVzTDc0?=
 =?utf-8?B?V3VNSXRDYnZVMTZjTC9Ccm4zbXQxaEF5bXBVVXpoVjJNYTdZUHZaZEFWdmdY?=
 =?utf-8?B?Vnp6bnI5WGZZUEFET2pzR3IwbWROVk9QbW8zc1BtdGRyQ3pnVHFWeXowYjd3?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8EB07DF9C00104EB90789BDEEC353CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65f1cd8-c33a-436d-42ad-08dd9a53312f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 23:40:25.4563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EtoJeVpHTA6lHgEaks6GKNtv4mmWrndd7XuHIzwZCzi8tvOyuP95J2Cbchny4e349ounp8Fqb9cotaQFm8j4NL94HfT4Ruv6cII6nZeBd00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6219
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTIyIGF0IDExOjUyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBNYXkgMjEsIDIwMjUgYXQgMTE6NDA6MTVQTSArMDgwMCwgRWRnZWNvbWJlLCBSaWNrIFAg
d3JvdGU6DQo+ID4gT24gVHVlLCAyMDI1LTA1LTIwIGF0IDE3OjM0ICswODAwLCBZYW4gWmhhbyB3
cm90ZToNCj4gPiA+IFNvLCB5b3Ugd2FudCB0byBkaXNhbGxvdyBodWdlIHBhZ2VzIGZvciBub24t
TGludXggVERzLCB0aGVuIHdlIGhhdmUgbm8gbmVlZA0KPiA+ID4gdG8gc3VwcG9ydCBzcGxpdHRp
bmcgaW4gdGhlIGZhdWx0IHBhdGgsIHJpZ2h0Pw0KPiA+ID4gDQo+ID4gPiBJJ20gT0sgaWYgd2Ug
ZG9uJ3QgY2FyZSBub24tTGludXggVERzIGZvciBub3cuDQo+ID4gPiBUaGlzIGNhbiBzaW1wbGlm
eSB0aGUgc3BsaXR0aW5nIGNvZGUgYW5kIHdlIGNhbiBhZGQgdGhlIHN1cHBvcnQgd2hlbiB0aGVy
ZSdzIGENCj4gPiA+IG5lZWQuDQo+ID4gDQo+ID4gV2UgZG8gbmVlZCB0byBjYXJlIGFib3V0IG5v
bi1MaW51eCBURHMgZnVuY3Rpb25pbmcsIGJ1dCB3ZSBkb24ndCBuZWVkIHRvDQo+ID4gb3B0aW1p
emUgZm9yIHRoZW0gYXQgdGhpcyBwb2ludC4gV2UgbmVlZCB0byBvcHRpbWl6ZSBmb3IgdGhpbmdz
IHRoYXQgaGFwcGVuDQo+ID4gb2Z0ZW4uIFBlbmRpbmctI1ZFIHVzaW5nIFREcyBhcmUgcmFyZSwg
YW5kIGRvbid0IG5lZWQgdG8gaGF2ZSBodWdlIHBhZ2VzIGluDQo+ID4gb3JkZXIgdG8gd29yay4N
Cj4gPiANCj4gPiBZZXN0ZXJkYXkgS2lyaWxsIGFuZCBJIHdlcmUgY2hhdHRpbmcgb2ZmbGluZSBh
Ym91dCB0aGUgbmV3bHkgZGVmaW5lZA0KPiA+IFRERy5NRU0uUEFHRS5SRUxFQVNFLiBJdCBpcyBr
aW5kIG9mIGxpa2UgYW4gdW5hY2NlcHQsIHNvIGFub3RoZXIgcG9zc2liaWxpdHkgaXM6DQo+ID4g
MS4gR3Vlc3QgYWNjZXB0cyBhdCAyTUINCj4gPiAyLiBHdWVzdCByZWxlYXNlcyBhdCAyTUIgKG5v
IG5vdGljZSB0byBWTU0pDQo+ID4gMy4gR3Vlc3QgYWNjZXB0cyBhdCA0aywgRVBUIHZpb2xhdGlv
biB3aXRoIGV4cGVjdGF0aW9uIHRvIGRlbW90ZQ0KPiA+IA0KPiA+IEluIHRoYXQgY2FzZSwgS1ZN
IHdvbid0IGtub3cgdG8gZXhwZWN0IGl0LCBhbmQgdGhhdCBpdCBuZWVkcyB0byBwcmVlbXB0aXZl
bHkgbWFwDQo+ID4gdGhpbmdzIGF0IDRrLg0KPiA+IA0KPiA+IEZvciBmdWxsIGNvdmVyYWdlIG9m
IHRoZSBpc3N1ZSwgY2FuIHdlIGRpc2N1c3MgYSBsaXR0bGUgYml0IGFib3V0IHdoYXQgZGVtb3Rl
IGluDQo+ID4gdGhlIGZhdWx0IHBhdGggd291bGQgbG9vayBsaWtlPw0KPiBGb3IgZGVtb3RlIGlu
IHRoZSBmYXVsdCBwYXRoLCBpdCB3aWxsIHRha2UgbW11IHJlYWQgbG9jay4NCj4gDQo+IFNvLCB0
aGUgZmxvdyBpbiB0aGUgZmF1bHQgcGF0aCBpcw0KPiAxLiB6YXAgd2l0aCBtbXUgcmVhZCBsb2Nr
Lg0KPiAgICByZXQgPSB0ZHhfc2VwdF96YXBfcHJpdmF0ZV9zcHRlKGt2bSwgZ2ZuLCBsZXZlbCwg
cGFnZSwgdHJ1ZSk7DQo+ICAgIGlmIChyZXQgPD0gMCkNCj4gICAgICAgIHJldHVybiByZXQ7DQo+
IDIuIHRyYWNrIHdpdGggbW11IHJlYWQgbG9jaw0KPiAgICByZXQgPSB0ZHhfdHJhY2soa3ZtLCB0
cnVlKTsNCj4gICAgaWYgKHJldCkNCj4gICAgICAgIHJldHVybiByZXQ7DQo+IDMuIGRlbW90ZSB3
aXRoIG1tdSByZWFkIGxvY2sNCj4gICAgcmV0ID0gdGR4X3NwdGVfZGVtb3RlX3ByaXZhdGVfc3B0
ZShrdm0sIGdmbiwgbGV2ZWwsIHBhZ2UsIHRydWUpOw0KPiAgICBpZiAocmV0KQ0KPiAgICAgICAg
Z290byBlcnI7DQo+IDQuIHJldHVybiBzdWNjZXNzIG9yIHVuemFwIGFzIGVycm9yIGZhbGxiYWNr
Lg0KPiAgICB0ZHhfc2VwdF91bnphcF9wcml2YXRlX3NwdGUoa3ZtLCBnZm4sIGxldmVsKTsNCj4g
DQo+IFN0ZXBzIDEtMyB3aWxsIHJldHVybiAtRUJVU1kgb24gYnVzeSBlcnJvciAod2hpY2ggd2ls
bCBub3QgYmUgdmVyeSBvZnRlbiBhcyB3ZQ0KPiB3aWxsIGludHJvZHVjZSBrdm1fdGR4LT5zZXB0
X2xvY2suIEkgY2FuIHBvc3QgdGhlIGZ1bGwgbG9jayBhbmFseXNpcyBpZg0KPiBuZWNlc3Nhcnkp
Lg0KDQpUaGF0IGlzIHRydWUgdGhhdCBpdCB3b3VsZCBub3QgYmUgdGFrZW4gdmVyeSBvZnRlbi4g
SXQncyBub3QgYSBwZXJmb3JtYW5jZQ0KaXNzdWUsIGJ1dCBJIHRoaW5rIHdlIHNob3VsZCBub3Qg
YWRkIGEgbG9jayBpZiB3ZSBjYW4gYXQgYWxsIGF2b2lkIGl0LiBJdA0KY3JlYXRlcyBhIHNwZWNp
YWwgY2FzZSBmb3IgVERYIGZvciB0aGUgVERQIE1NVS4gUGVvcGxlIHdvdWxkIGhhdmUgdG8gdGhl
biBrZWVwDQppbiBtaW5kIHRoYXQgdHdvIG1tdSByZWFkIGxvY2sgdGhyZWFkcyBjb3VsZCBzdGls
bCBzdGlsbCBjb250ZW5kLg0KDQpbc25pcF0NCj4gDQo+IA0KPiA+IFRoZSBjdXJyZW50IHphcHBp
bmcgb3BlcmF0aW9uIHRoYXQgaXMgaW52b2x2ZWQNCj4gPiBkZXBlbmRzIG9uIG1tdSB3cml0ZSBs
b2NrLiBBbmQgSSByZW1lbWJlciB5b3UgaGFkIGEgUE9DIHRoYXQgYWRkZWQgZXNzZW50aWFsbHkg
YQ0KPiA+IGhpZGRlbiBleGNsdXNpdmUgbG9jayBpbiBURFggY29kZSBhcyBhIHN1YnN0aXR1dGUu
IEJ1dCB1bmxpa2UgdGhlIG90aGVyIGNhbGxlcnMsDQo+IFJpZ2h0LCBUaGUga3ZtX3RkeC0+c2Vw
dF9sb2NrIGlzIGludHJvZHVjZWQgYXMgYSBydyBsb2NrLiBUaGUgd3JpdGUgbG9jayBpcyBoZWxk
DQo+IGluIGEgdmVyeSBzaG9ydCBwZXJpb2QsIGFyb3VuZCB0ZGhfbWVtX3NlcHRfcmVtb3ZlKCks
IHRkaF9tZW1fcmFuZ2VfYmxvY2soKSwNCj4gdGRoX21lbV9yYW5nZV91bmJsb2NrKCkuDQo+IA0K
PiBUaGUgcmVhZC93cml0ZSBzdGF0dXMgb2YgdGhlIGt2bV90ZHgtPnNlcHRfbG9jayBjb3JyZXNw
b25kcyB0byB0aGF0IGluIHRoZSBURFgNCj4gbW9kdWxlLg0KPiANCj4gICBSZXNvdXJjZXMgICAg
ICAgICAgU0hBUkVEICB1c2VycyAgICAgICAgICAgICAgRVhDTFVTSVZFIHVzZXJzIA0KPiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPiAgc2VjdXJlX2VwdF9sb2NrICAgdGRoX21lbV9zZXB0X2FkZCAgICAgICAg
ICAgIHRkaF92cF9lbnRlcg0KPiAgICAgICAgICAgICAgICAgICAgdGRoX21lbV9wYWdlX2F1ZyAg
ICAgICAgICAgIHRkaF9tZW1fc2VwdF9yZW1vdmUNCj4gICAgICAgICAgICAgICAgICAgIHRkaF9t
ZW1fcGFnZV9yZW1vdmUgICAgICAgICB0ZGhfbWVtX3JhbmdlX2Jsb2NrDQo+ICAgICAgICAgICAg
ICAgICAgICB0ZGhfbWVtX3BhZ2VfcHJvbW90ZSAgICAgICAgdGRoX21lbV9yYW5nZV91bmJsb2Nr
DQo+ICAgICAgICAgICAgICAgICAgICB0ZGhfbWVtX3BhZ2VfZGVtb3RlDQo+IA0KPiA+IHRoZSBm
YXVsdCBwYXRoIGRlbW90ZSBjYXNlIGNvdWxkIGFjdHVhbGx5IGhhbmRsZSBmYWlsdXJlLiBTbyBp
ZiB3ZSBqdXN0IHJldHVybmVkDQo+ID4gYnVzeSBhbmQgZGlkbid0IHRyeSB0byBmb3JjZSB0aGUg
cmV0cnksIHdlIHdvdWxkIGp1c3QgcnVuIHRoZSByaXNrIG9mDQo+ID4gaW50ZXJmZXJpbmcgd2l0
aCBURFggbW9kdWxlIHNlcHQgbG9jaz8gSXMgdGhhdCB0aGUgb25seSBpc3N1ZSB3aXRoIGEgZGVz
aWduIHRoYXQNCj4gPiB3b3VsZCBhbGxvd3MgZmFpbHVyZSBvZiBkZW1vdGUgaW4gdGhlIGZhdWx0
IHBhdGg/DQo+IFRoZSBjb25jZXJuIHRvIHN1cHBvcnQgc3BsaXQgaW4gdGhlIGZhdWx0IHBhdGgg
aXMgbWFpbmx5IHRvIGF2b2lkIHVubmVjZXNzc2FyeQ0KPiBzcGxpdCwgZS5nLiwgd2hlbiB0d28g
dkNQVXMgdHJ5IHRvIGFjY2VwdCBhdCBkaWZmZXJlbnQgbGV2ZWxzLg0KDQpXZSBhcmUganVzdCB0
YWxraW5nIGFib3V0IGtlZXBpbmcgcmFyZSBURHMgZnVuY3Rpb25hbCBoZXJlLCByaWdodD8gVHdv
IGNhc2VzDQphcmU6DQogLSBURHMgdXNpbmcgUEFHRS5SRUxFQVNFDQogLSBURHMgdXNpbmcgcGVu
ZGluZyAjVkVzIGFuZCBhY2NlcHRpbmcgbWVtb3J5IGluIHN0cmFuZ2UgcGF0dGVybnMNCg0KTm90
IG1haW50YWluaW5nIGh1Z2UgcGFnZXMgdGhlcmUgc2VlbXMgdG90YWxseSBhY2NlcHRhYmxlLiBI
b3cgSSBsb29rIGF0IHRoaXMNCndob2xlIHRoaW5nIGlzIHRoYXQgaXQganVzdCBhbiBvcHRpbWl6
YXRpb24sIG5vdCBhIGZlYXR1cmUuIEV2ZXJ5IGFzcGVjdCBoYXMgYQ0KY29tcGxleGl0eS9wZXJm
b3JtYW5jZSB0cmFkZW9mZiB0aGF0IHdlIG5lZWQgdG8gbWFrZSBhIHNlbnNpYmxlIGRlY2lzaW9u
IG9uLg0KTWFpbnRhaW5pbmcgaHVnZSBwYWdlIG1hcHBpbmdzIGluIGV2ZXJ5IHBvc3NpYmxlIGNh
c2UgaXMgbm90IHRoZSBnb2FsLg0KDQo+IA0KPiBCZXNpZGVzIHRoYXQgd2UgbmVlZCB0byBpbnRy
b2R1Y2UgMyBsb2NrcyBpbnNpZGUgVERYOg0KPiByd2xvY2tfdCBzZXB0X2xvY2ssIHNwaW5sb2Nr
X3Qgbm9fdmNwdV9lbnRlcl9sb2NrLCBzcGlubG9ja190IHRyYWNrX2xvY2suDQoNCkh1aD8NCg0K
PiANCj4gVG8gZW5zdXJlIHRoZSBzdWNjZXNzIG9mIHVuemFwICh0byByZXN0b3JlIHRoZSBzdGF0
ZSksIGtpY2tpbmcgb2YgdkNQVXMgaW4gdGhlDQo+IGZhdWx0IHBhdGggaXMgcmVxdWlyZWQsIHdo
aWNoIGlzIG5vdCBpZGVhbC4gQnV0IHdpdGggdGhlIGludHJvZHVjZWQgbG9jayBhbmQgdGhlDQo+
IHByb3Bvc2VkIFREWCBtb2R1bGVzJ3MgY2hhbmdlIHRvIHRkZ19tZW1fcGFnZV9hY2NlcHQoKSAo
YXMgaW4gdGhlIG5leHQgY29tbWVudCksDQo+IHRoZSBjaGFuY2UgdG8gaW52b2tlIHVuemFwIGlz
IHZlcnkgbG93Lg0KDQpZZXMsIGl0J3MgcHJvYmFibHkgbm90IHNhZmUgdG8gZXhwZWN0IHRoZSBl
eGFjdCBzYW1lIGRlbW90ZSBjYWxsIGNoYWluIGFnYWluLg0KVGhlIGZhdWx0IHBhdGggY291bGQg
bWF5YmUgbGVhcm4gdG8gcmVjb3ZlciBmcm9tIHRoZSBibG9ja2VkIHN0YXRlPw0KDQo+IA0KPiA+
IExldCdzIGtlZXAgaW4gbWluZCB0aGF0IHdlIGNvdWxkIGFzayBmb3IgVERYIG1vZHVsZSBjaGFu
Z2VzIHRvIGVuYWJsZSB0aGlzIHBhdGguDQo+IFdlIG1heSBuZWVkIFREWCBtb2R1bGUncyBjaGFu
Z2UgdG8gbGV0IHRkZ19tZW1fcGFnZV9hY2NlcHQoKSBub3QgdG8gdGFrZSBsb2NrIG9uDQo+IGFu
IG5vbi1BQ0NFUFRhYmxlIGVudHJ5IHRvIGF2b2lkIGNvbnRlbnRpb24gd2l0aCBndWVzdCBhbmQg
dGhlIHBvdGVudGlhbCBlcnJvcg0KPiBURFhfSE9TVF9QUklPUklUWV9CVVNZX1RJTUVPVVQuDQoN
ClBhcnQgb2YgdGhhdCBpcyBhbHJlYWR5IGluIHRoZSB3b3JrcyAoYWNjZXB0aW5nIG5vdC1wcmVz
ZW50IGVudHJpZXMpLiBJdCBzZWVtcw0KcmVhc29uYWJsZS4gQnV0IGFsc28sIHdoYXQgYWJvdXQg
bG9va2luZyBhdCBoYXZpbmcgdGhlIFREWCBtb2R1bGUgZG8gdGhlIGZ1bGwNCmRlbW90ZSBvcGVy
YXRpb24gaW50ZXJuYWxseS4gVGhlIHRyYWNrIHBhcnQgb2J2aW91c2x5IGhhcHBlbnMgb3V0c2lk
ZSBvZiB0aGUgVERYDQptb2R1bGUsIGJ1dCBtYXliZSB0aGUgd2hvbGUgdGhpbmcgY291bGQgYmUg
c2ltcGxpZmllZC4NCg0KPiANCj4gPiBJIHRoaW5rIHdlIGNvdWxkIHByb2JhYmx5IGdldCBhd2F5
IHdpdGggaWdub3JpbmcgVERHLk1FTS5QQUdFLlJFTEVBU0UgaWYgd2UgaGFkDQo+ID4gYSBwbGFu
IHRvIGZpeCBpdCB1cCB3aXRoIFREWCBtb2R1bGUgY2hhbmdlcy4gQW5kIGlmIHRoZSB1bHRpbWF0
ZSByb290IGNhdXNlIG9mDQo+ID4gdGhlIGNvbXBsaWNhdGlvbiBpcyBhdm9pZGluZyB6ZXJvLXN0
ZXAgKHNlcHQgbG9jayksIHdlIHNob3VsZCBmaXggdGhhdCBpbnN0ZWFkDQo+ID4gb2YgZGVzaWdu
IGFyb3VuZCBpdCBmdXJ0aGVyLg0KPiBPay4NCj4gDQo+ID4gPiANCg0KSSdsbCByZXNwb25kIHRv
IHRoZSBlcnJvciBjb2RlIGhhbGYgb2YgdGhpcyBtYWlsIHNlcGFyYXRlbHkuDQo=

