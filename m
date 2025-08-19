Return-Path: <kvm+bounces-55006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FA7B2C8EF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C7BB1BA1A26
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251C228C00C;
	Tue, 19 Aug 2025 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVB8slGW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE385298CB2;
	Tue, 19 Aug 2025 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619189; cv=fail; b=jYgWREg1SRfe504mhQLc9fmn4hZR2hHsXgZZMiVAcZzX5fVYSxWviC13OdFnMEyYM9NSNJLm9sqHbw3ZqY/F07lsoRZRFakdR/ZlDXv8Qm3nRJlubOH6sb5mHTVCbtkuLqFTlWWFAsLH+6iP3thAEKxpKB/Q+CRG4eGFykrb7Z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619189; c=relaxed/simple;
	bh=CnJtEApHUcVBv2upVjKeDCGvyfI60IjfubqC+1kdhos=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MCq3brSOxlnWDgLHoe369hoS3AYa82VBoeTao59Tkmu6gMo40tj27L3StpkFwJOXXC/cgFRUoluEAROir594QgY5dJevfNWN7Fb1EQBk6l1hddtrnyBl1pLU3ivGtSp/8KXdOlGKfy+5kWd8FnPb82ukw803jHm//pDg+QY7g0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVB8slGW; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755619188; x=1787155188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CnJtEApHUcVBv2upVjKeDCGvyfI60IjfubqC+1kdhos=;
  b=UVB8slGW4s34TQio1TLZ5s85ZdcxB5GaF6jH41GKKHVDzNFqtDFXHpnE
   XBEOtC7QnYQudGe9MIbMC/brsFE/KNdNtucDtOQKtSk/SParDeMN9Ax5t
   AlQXU1XCt215H/lYIR6HXUH5zwHAsWBfq2yQ3CQtm4dYVlPtOm8P7zRNn
   dRZpfLNPKp+HZ01B53YexKPDlHbk+0EmA2mBi8guL9I6y4uSPSrjxwDvK
   4SCj/x8atIm7hWRy9xn9//ciB7JZPBPKXZ+51TQ6jh+fZCuPFPXbL670b
   2e8kXVHOckkw5OMNagcx5Hyc1PFH1USn7wm1YN5M2dOuOYAOSjc57P0GX
   w==;
X-CSE-ConnectionGUID: 1XMep1nlRIiq7/60qZ+F4A==
X-CSE-MsgGUID: ueryo8txR9O5yvyLZZu7Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="45440049"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="45440049"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:59:47 -0700
X-CSE-ConnectionGUID: lNr5ZPCNTt+xuRNf9vUPYQ==
X-CSE-MsgGUID: 1q9tUCkoQAa0PfhvY+sNtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="172120231"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:59:47 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:59:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 08:59:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTFGMifP5rqhiIoPbsKYCYqdasE4PxRb3bde3c9x9LCCEt+QDUPgX3FyMKh7EW6enohCVksxEJkbPlwrtjGo2654bI+kf8NLaBHjgmBHTsvZSq4b1jYAIpFMfVUHVWxT077pV4HPjbi7emF417eW8zCsCUWMhX+pnYwJOXbAEGMqTLPeMUcY5OAMQ1niPIdxQQeb6n88W9mWOsj34yIlWt4afeJr6MxPcytNxg0jxkAb71RRNUCCHwLG1AJyByV5T/FeV280oYuC9NT3ZSwoa1e1Q4OFbNM4hd0TycimJFYBmLAJbpeEIFWSHs+hDqVhCRLz2fnHMur41225SBczHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnJtEApHUcVBv2upVjKeDCGvyfI60IjfubqC+1kdhos=;
 b=BzRBvCHpFDPMBS8wS18QSl+hazCtxPP8/3rY4F2d0Obxy1KNhbVJnPBJK1qJq4NIjB5sw1P9EAiGt6vnBM5Bj1qXM5VK9zbmpOn3p3ByJ9tQzzandXBep+n9F0Q9xXv3I1A72b2OfnXWvkwbAN9iquXAta11RdXit0fqqIJzc8SnzGPPSkBwBw9Oz2/AI1TIg5Qy5fNVMgvtP5FcJOnPGNj8TNyot6DskBwVsWLX0wwWx8GTisebHVn1B3wegM2z0MG9Qu2Iv3LFSFbHr4PsKQcE0MoMHaSXsKI0I2LD4mVNjM9khXjSocULr0MzQwas7YxrJr/W9VWgDTIBlSyGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5063.namprd11.prod.outlook.com (2603:10b6:510:3d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 15:59:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 15:59:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Weiny,
 Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
Thread-Topic: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
Thread-Index: AQHcDrxaRC2HgQTKCkiAAwmmnxOsO7RodPeAgABPRoCAALX3AIAArOGA
Date: Tue, 19 Aug 2025 15:59:44 +0000
Message-ID: <b7ee32f9e343a10094b21bed455262fecd2e071e.camel@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
	 <20250816144436.83718-2-adrian.hunter@intel.com>
	 <aKMzEYR4t4Btd7kC@google.com>
	 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
	 <97d3090d-38c5-40df-bab0-c81fc152321d@linux.intel.com>
In-Reply-To: <97d3090d-38c5-40df-bab0-c81fc152321d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5063:EE_
x-ms-office365-filtering-correlation-id: d956dd9a-1dfc-45cd-95a9-08dddf3969fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S0Q5Sk9KdEFBdWh0aXhCTlZYdGRyakNHNFE4VkNSUDNFT2tSWGNwMTBqSHUv?=
 =?utf-8?B?NWZJc1Q1MDd3a0k0cW1HMkd1STJlNzVNRFNnWGFOcTF2UEJTTDdWa29PQWJz?=
 =?utf-8?B?RCtuTGVtYW95UW9yajVNR0dOUU9WTVpQbVRrL3lGM1VocGE1UFFpRERjNVVz?=
 =?utf-8?B?bit3aG5xTG5VKzl2VVhuS0N5UU1UV3AxKzEvY1lTeGlDNXhRaVVnc0NqOU5k?=
 =?utf-8?B?ZzJuV0Robzhid1FqUWd6MVRNc25NcHBOVVhERzZoZXZvaW9MUTlCL1MralAx?=
 =?utf-8?B?SFFhYXFTdGpmZytiRVZ3WkVPTnFJckwybDdQY3lDaWZUNWtCeFJDa0dqT2sx?=
 =?utf-8?B?UnNUdUZnUlJxTjhJbjI5QnRSQUNuVW5MY1Y5enhVMWZXeG4yemkyU0YxVVBF?=
 =?utf-8?B?TDN2SStjaS9PSlUvK0U3eWxwNEZjWm5aWGdTM3diYkxlWUNGOC81OHA5T3Rj?=
 =?utf-8?B?ODNRZ2k0ekRIMlpJb2liT0ZLSDlzR3o0NGE4UXlmcWtSL01sRlpqYWM0bHFv?=
 =?utf-8?B?a2RFTm5qRjQ2blFtU0hmeXBtenhqU0VLOGVQRDFVakFJYWRBelZid29saDkv?=
 =?utf-8?B?N1RVaFRJR1oyVnF5cmlQZ1QxVk5KcVlxeTBxQ01aUDdkUVd6bmljazFDYUtv?=
 =?utf-8?B?QkVvMzJCdGFEY29Dc3IzbVBDVE1ZWnhtQ3RScFN3c3I3L0s2bkVpOUxTcE5S?=
 =?utf-8?B?cU1DeVF3ak9lUHU0TFk3dkxGWHhjUk13WU4yc0xQUHE5a0xjRTE1Y0F4amFp?=
 =?utf-8?B?NkthdzRHZm1lUmY3a1gvYUJETUxCczVTYUZHRTFLajM2Q1BOMUNPbmJZQy9u?=
 =?utf-8?B?SEd0OS9MM3dhak91elJqM2xTVmNiRWN5SEU4ZURONy8rU2h1Ni9oZkVRM2lO?=
 =?utf-8?B?NWpBVE1GczQ0b0twMlkrQTArQkxMWE0vdXpyTXBnUzhnNXk1WWpIQXEvaGhP?=
 =?utf-8?B?dXZDdk9FWjFIbEdJNDBNRXBraWdMQVRSc0wvdXNQcjNjaFVhc25QbFVWZ2VW?=
 =?utf-8?B?Ui9EcDdJTU5MdG1PN2hYWGlReWkwTGorLzljUlpTeFpRbHBCZWtZdERCbVhm?=
 =?utf-8?B?akY4TjI0Y2N0TFFoWlJxc1lkL2F1d28yejgxbXk3OXpMdm9ZRVl6WkFnODg4?=
 =?utf-8?B?TjZidVpiYTBFb3JMSlN5N1ZsZ1B3NlU3ZE1qOVZNVTliVEpwRWJpMHNXTGFx?=
 =?utf-8?B?dVp4RmdpakhRSkNYcWFhQXlwUUwxczNhTnlWeGk2a1h2T1lsblJTdjNhcnZB?=
 =?utf-8?B?cVV5cm1HZEN1bXZqbUJySkkzUVpmWllWN2lmZlZaZnpLTzhLZ2o5amVoZUY5?=
 =?utf-8?B?cmlvT3hYUzBvWndDdEh1eW5xMXJxWmtCYjFtT2p1WXdnRUR1ditKUmhDTlJW?=
 =?utf-8?B?dTVUU3cwbFpVYlBSdTdZZ09ESVB4UmJ3bXdlaTRkNmpkV09XbU52Qmp6RENq?=
 =?utf-8?B?aU92UDdLRUVMQlN4VGp4QUVvM1AxdTlxL3BRT3Rab005aUtEMThOelVlTnUy?=
 =?utf-8?B?VGlsTU9WUE90RC9NbVNhNlR0Q0FpdGNyakJ2cTRxNVFrbCtjRnpyL1JrUHJ1?=
 =?utf-8?B?TU9Qa1lMR3F5Zi9COU9DSVhwbG1xV3hQT2hPcTRoaXdSWGg4dWpRMzJEZ2tZ?=
 =?utf-8?B?UmdMa2k3OGRNaHEzQmFzSk9pMDlpNVdJZHZyS2pMNG12clNUeks3dG1nQkxQ?=
 =?utf-8?B?c09jc2g1czBUWUVvbmljeWx6LzZyZG1Wd3lubU80b3FoNHRUNzNVRVkzSXZy?=
 =?utf-8?B?WDJoRVJSZ3QxLzhMQWtjR0JBTkdZQ0VkaUNOZll0VlZURnAzclFTT0t6S09h?=
 =?utf-8?B?VUpiMUNrTVBXNkNzSC9aV0hoNy85MUtLV291d0tFb0tmcWlyTjIvMGNOUjhv?=
 =?utf-8?B?aFIxUmJPN1pqWlVUTktMOEM3dkZ1cGgwRHZ5MGJSeFRUaXF1NTZCTy9iSWg0?=
 =?utf-8?B?c0Ridm1sV1loUnFkeUF3RG8zUTNQUHJYeUNvRGZ3aU1TaXR6eEhSam9DbVZr?=
 =?utf-8?Q?MTElblMjkNZJqf7cc10y9lt8JPfw6Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1J0QzltelZ6a3ZBa01DdWgyR20vaUdQR0d0ZE4vaVFQYk5JcklpaVNTRUQ0?=
 =?utf-8?B?ZFZpMGc3ditTVm9CVklzbjcxVFRBdmsrL3ZlK1BiQmczUkhNc0JCR2xueE1N?=
 =?utf-8?B?MTRmcjNsbVd2OXpzRzk4UWt5dm8rM256cDZXQ2pPbkJVRFA3OWpneHZLdldy?=
 =?utf-8?B?Tm9UditicEdxejBkZlV4elU3WE50V01MeWdpenBPbWNNZHMzMUI5ckFOOW9l?=
 =?utf-8?B?YVJBanRDSWtmek91V2lXTndUQitBc0FPajlSM09BMzRpME1iNjdlY2VvUE1L?=
 =?utf-8?B?amhVM2o0M01rVTFxazEvUWZCRjVENVBTek5mMWIzNjdNTnNrWHdZeG5LSlN6?=
 =?utf-8?B?OVlwYmlmL2lidDQyVVl5bklEOWEydzhNSVROWW10Z2VMb0tHNzBmQXhydTdH?=
 =?utf-8?B?NjN4TGxrTlB0Yk54TTFOREUyK3duR1d4Y04wNXpWMUl5TTROaHE3R2JzMjQ2?=
 =?utf-8?B?cXc5bzJDVld2d3pNaEltZE1pTUhjNDFTakNyMDRJTDNCNVRsaUlhbk9HazY0?=
 =?utf-8?B?alpDdjlHdlN4RmhCVThoSVdUaVZDUTErZmU3WVY4NDdVbElwbXhYZWp1bFVR?=
 =?utf-8?B?MFJHTFE4eVRBTnpsazU1QUdMRTlZMnU1U1JDS1V0eVU1eGJwT0NETzVWeHZx?=
 =?utf-8?B?Y1dGTUp5RDVVZmVLNTlhOWhHTDNOendBSUphRzE1ejViTnBTRUh1SDNvOWZj?=
 =?utf-8?B?TzRjQ2d5UFBrcnE2OElmS1NtYm1zL1NQTXdNbGFOSXd3RnV0WnpwNUZ2TGc4?=
 =?utf-8?B?djZKQSt0cmZNZk1WOCtXY1IwQjRZTEs3QWhDQ1E5NStKNDdCdmFKbE9mUGEv?=
 =?utf-8?B?S2N6bGtRQjBJcGlQL0Y3SEk4V1hyR0Z5dVZTc1Vac3RDRkNmek9iY3ZkWDZx?=
 =?utf-8?B?aDZjUmVqZXhnZThNdk14ZjdMV1VpempEeVlMSnUyMVRUWWZ4MlBkbkt1anlo?=
 =?utf-8?B?Y2wvekFPYi9UY3l3Vm1NTUNKQ1hnSVhkTUhDUDV2WE5EOWdEY0FzVmhpeUlT?=
 =?utf-8?B?cnJPL08weklRbzVrN3JBSFpCQk9QNkp5aCtEa21RdllSRzJneGs2RGR2eS91?=
 =?utf-8?B?OSsxQXUyc1VNOXZtSjhDa0NMeTRrK2d2TDg2cU9PczBCb2gvY0djNHFya0pa?=
 =?utf-8?B?dHF2N3hhN1BxM1Yyb0RGZ1V1bTRIcU1DSkhXQTdKSlpESk5BdkxRY2VUOTJL?=
 =?utf-8?B?c2JaaFZXVVB6TEptQUhNUG04YWl2NExxdVJvTjQ4c1hhVy9ZMWFJUlpKZmwr?=
 =?utf-8?B?SFFHWVJ6M1NJSldyUkgzWXZxVHFkUDM2ai9CdFBrT1RwV2luRmV5bWg2eFNK?=
 =?utf-8?B?V1VONVVXTEg5YVU0MnlLaXJ0T3QzS3dFUXJEMVRxR2IzcTg1MWFiRXgvV3ov?=
 =?utf-8?B?NllFRERwMHI4R1NGV2RlejhEOGlnbXBxMHpnTldoZ0RFWmdSOXBVSUlzMjhz?=
 =?utf-8?B?YmZ5TEJCdFBMTmlCWW51bEtVRUIyM0w0RS9vdDN3bitXNVRERlJvMWdheFRl?=
 =?utf-8?B?bUsrclEwQUNtT2RBWXdoeGlBN1VXeE1YSWR2VWdMNzROSWlUcXNzNVpTMmJN?=
 =?utf-8?B?aExyakQyR0RIek00eEdXZ3owclRTSmdPRENKaUZrdGFBTWwvSmxya3B5WURN?=
 =?utf-8?B?c283VDJrTW12TGU3cy9YQ0dueXpzOGxJWXYzMFJlOXRrcHRvcnVGa1BvdndH?=
 =?utf-8?B?TEp6RENoOHdxOGFHUXk5SkRCYzRJMGMzdDRNUFQvcmxIVXQ5cHhwNEFtTHVN?=
 =?utf-8?B?bnYvckhpaTZJSlcxWlo2TTVsM3gyQ3dyaTRMeHdmTWE5bmRXTGFadml5UTJF?=
 =?utf-8?B?RTIzUnZFZmI5ZTc5M1Bab3RsMUlFNWh2R2k5UVNrNG55bk5oalZrNmpYRzZC?=
 =?utf-8?B?eVdxam1XZ2ExQXVDSXNxOHh2VzB6aWw1SCtya2owbVpOY1JhQ3JWUHhmWDho?=
 =?utf-8?B?aVdXMGJJdmdraUxtdnloUTBKaGN6Vmk3bFYwTzFPaE5vWEFiT0dsR0xPV2RM?=
 =?utf-8?B?NUQyNS91LzZmVHdqNHluUUFJemx5M24xOXhKcFRWc1RNenBTR25Ud2pJVGx6?=
 =?utf-8?B?RWtaaWpMQ3FqV3FTU0MxRVN5TzZ6OS9EUGRaeWU4TEFEUUlybGtCcDdLbTJZ?=
 =?utf-8?B?Smc5YUxkcUdZN2xFL2thaXdqMnQ4YnBIem1IeWFlakdXM2JNK1BqdGtFRFdJ?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E8288EB61FD9248BA45E28D1167E73B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d956dd9a-1dfc-45cd-95a9-08dddf3969fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 15:59:44.0391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZObFqPOwXVQz5LSE28u881cTAKFbCdV8moSKBG+NNt4n/D9nqK2aKsV/0qteppauJjkhv1Z6yxXuXseHkWicroc2P59z7EAVaBO1Jbzq/7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5063
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDEzOjQwICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEN1
cnJlbnRseSwgS1ZNIFREWCBjb2RlIGZpbHRlcnMgb3V0IFRTWCAoSExFIG9yIFJUTSkgYW5kIFdB
SVRQS0cgdXNpbmcNCj4gdGR4X2NsZWFyX3Vuc3VwcG9ydGVkX2NwdWlkKCksIHdoaWNoIGlzIHNv
cnQgb2YgYmxhY2tsaXN0Lg0KPiANCj4gSSBhbSB3b25kZXJpbmcgaWYgd2UgY291bGQgYWRkIGFu
b3RoZXIgYXJyYXksIGUuZy4sIHRkeF9jcHVfY2Fwc1tdLCB3aGljaCBpcyB0aGUNCj4gVERYIHZl
cnNpb24gb2Yga3ZtX2NwdV9jYXBzW10uDQo+IA0KPiBVc2luZyB0ZHhfY3B1X2NhcHNbXSBpcyBh
IHdoaXRlbGlzdCB3YXkuDQoNCldlIGhhZCBzb21ldGhpbmcgbGlrZSB0aGlzIGluIHNvbWUgb2Yg
dGhlIGVhcmxpZXIgcmV2aXNpb25zIG9mIHRoZSBURFggQ1BVSUQNCmNvbmZpZ3VyYXRpb24uDQoN
Cj4gRm9yIGEgbmV3IGZlYXR1cmUNCj4gLSBJZiB0aGUgZGV2ZWxvcGVyIGRvZXNuJ3Qga25vdyBh
bnl0aGluZyBhYm91dCBURFgsIHRoZSBiaXQganVzdCBiZSBhZGRlZCB0bw0KPiDCoMKgIGt2bV9j
cHVfY2Fwc1tdLg0KPiAtIElmIHRoZSBkZXZlbG9wZXIga25vd3MgdGhhdCB0aGUgZmVhdHVyZSBz
dXBwb3J0ZWQgYnkgYm90aCBub24tVERYIFZNcyBhbmQgVERzDQo+IMKgwqAgKGVpdGhlciB0aGUg
ZmVhdHVyZSBkb2Vzbid0IHJlcXVpcmUgYW55IGFkZGl0aW9uYWwgdmlydHVhbGl6YXRpb24gc3Vw
cG9ydCBvcg0KPiDCoMKgIHRoZSB2aXJ0dWFsaXphdGlvbiBzdXBwb3J0IGlzIGFkZGVkIGZvciBU
RFgpLCBleHRlbmQgdGhlIG1hY3JvcyB0byBzZXQgdGhlIGJpdA0KPiDCoMKgIGJvdGggaW4ga3Zt
X2NwdV9jYXBzW10gYW5kIHRkeF9jcHVfY2Fwc1tdLg0KPiAtIElmIHRoZXJlIGlzIGEgZmVhdHVy
ZSBub3Qgc3VwcG9ydGVkIGJ5IG5vbi1URFggVk1zLCBidXQgc3VwcG9ydGVkIGJ5IFREcywNCj4g
wqDCoCBleHRlbmQgdGhlIG1hY3JvcyB0byBzZXQgdGhlIGJpdCBvbmx5IGluIHRkeF9jcHVfY2Fw
c1tdLg0KPiBTbywgdGR4X2NwdV9jYXBzW10gY291bGQgYmUgdXNlZCBhcyB0aGUgZmlsdGVyIG9m
IGNvbmZpZ3VyYWJsZSBiaXRzIHJlcG9ydGVkDQo+IHRvIHVzZXJzcGFjZS4NCg0KSW4gc29tZSB3
YXlzIHRoaXMgaXMgdGhlIHNpbXBsZXN0LCBidXQgaGF2aW5nIHRvIG1haW50YWluIGEgYmlnIGxp
c3QgaW4gS1ZNIHdhcw0Kbm90IGlkZWFsLiBUaGUgb3JpZ2luYWwgc29sdXRpb24gc3RhcnRlZCB3
aXRoIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEIGFuZCB0aGVuDQptYXNzYWdlZCB0aGUgcmVzdWx0
cyB0byBmaXQsIHNvIG1heWJlIGp1c3QgZW5jb2RpbmcgdGhlIHdob2xlIHRoaW5nIHNlcGFyYXRl
bHkNCmlzIGVub3VnaCB0byByZWNvbnNpZGVyIGl0Lg0KDQpCdXQgd2hhdCBJIHdhcyB0aGlua2lu
ZyBpcyB0aGF0IHdlIGNvdWxkIG1vc3Qgb2YgdGhhdCBoYXJkY29kZWQgbGlzdCBpbnRvIHRoZQ0K
VERYIG1vZHVsZSwgYW5kIG9ubHkga2VlcCBhIGxpc3Qgb2Ygbm9uLXRyaXZpYWwgZmVhdHVyZXMg
KGkuZS4gbm90IHNpbXBsZQ0KaW5zdHJ1Y3Rpb24gQ1BVSUQgYml0cykgaW4gS1ZNLiBUaGUgbGlz
dCBvZiBzaW1wbGUgZmVhdHVyZXMgKGRlZmluaXRpb24gVEJEKQ0KY291bGQgYmUgcHJvdmlkZWQg
YnkgdGhlIFREWCBtb2R1bGUuIFNvIEtWTSBjb3VsZCBkbyB0aGUgZnVsbCBmaWx0ZXJpbmcgYnV0
IG9ubHkNCmtlZXAgYSBsaXN0IHRoYXQgdG9kYXkgd291bGQganVzdCBsb29rIGxpa2UgVFNYIGFu
ZCBXQUlUUEtHIHRoYXQgd2UgYWxyZWFkeQ0KaGF2ZS4gU28gYmFzaWNhbGx5IHRoZSBzYW1lIGFz
IHdoYXQgeW91IGFyZSBwcm9wb3NpbmcsIGJ1dCBqdXN0IHNocmlua3MgdGhlIHNpemUNCm9mIGxp
c3QgS1ZNIGhhcyB0byBrZWVwLg0KDQo+IA0KPiBDb21wYXJpbmcgdG8gYmxhY2tsaXN0IChpLmUu
LCB0ZHhfY2xlYXJfdW5zdXBwb3J0ZWRfY3B1aWQoKSksIHRoZXJlIGlzIG5vIHJpc2sNCj4gdGhh
dCBhIGZlYXR1cmUgbm90IHN1cHBvcnRlZCBieSBURFggaXMgZm9yZ290dGVuIHRvIGJlIGFkZGVk
IHRvIHRoZSBibGFja2xpc3QuDQo+IEFsc28sIHRkeF9jcHVfY2Fwc1tdIGNvdWxkIHN1cHBvcnQg
YSBmZWF0dXJlIHRoYXQgbm90IHN1cHBvcnRlZCBmb3Igbm9uLVREWCBWTXMuDQoNCldlIGRlZmlu
aXRlbHkgY2FuJ3QgaGF2ZSBURFggbW9kdWxlIGFkZGluZyBhbnkgaG9zdCBhZmZlY3RpbmcgZmVh
dHVyZXMgdGhhdCB3ZQ0Kd291bGQgYXV0b21hdGljYWxseSBhbGxvdy4gQW5kIGhhdmluZyBhIHNl
cGFyYXRlIG9wdC1pbiBpbnRlcmZhY2UgdGhhdCBkb2Vzbid0DQoic3BlYWsiIGNwdWlkIGJpdHMg
aXMgZ29pbmcgdG8ganVzdCBjb21wbGljYXRlIHRoZSBhbHJlYWR5IGNvbXBsaWNhdGVkIGxvZ2lj
DQp0aGF0IGlzIGluIFFFTVUuDQoNCj4gDQo+IFRoZW4gd2UgZG9uJ3QgbmVlZCBhIGhvc3Qgb3B0
LWluIGZvciB0aGVzZSBkaXJlY3RseSBjb25maWd1cmFibGUgYml0cyBub3QNCj4gY2xvYmJlcmlu
ZyBob3N0IHN0YXRlcy4NCj4gDQo+IE9mIGNvdXJzZSwgdG8gcHJldmVudCB1c2Vyc3BhY2UgZnJv
bSBzZXR0aW5nIGZlYXR1cmUgYml0IHRoYXQgd291bGQgY2xvYmJlciBob3N0DQo+IHN0YXRlLCBi
dXQgbm90IGluY2x1ZGVkIGluIHRkeF9jcHVfY2Fwc1tdLCBJIHRoaW5rIGEgbmV3IGZlYXR1cmUg
dGhhdCB3b3VsZA0KPiBjbG9iYmVyIGhvc3Qgc3RhdGUgc2hvdWxkIHJlcXVpcmVzIGEgaG9zdCBv
cHQtaW4gdG8gVERYIG1vZHVsZS4NCg0KWWVzLCBidXQgaWYgaGF2ZSBzb21lIHdheSB0byBnZXQg
dGhlIGhvc3QgY2xvYmJlcmluZyB0eXBlIGluZm8gcHJvZ3JhbWF0aWNhbGx5DQp3ZSBjb3VsZCBr
ZWVwIHRoZSBob3N0IG9wdC1pbiBhcyBwYXJ0IG9mIHRoZSBtYWluIENQVUlEIGJpdCBjb25maWd1
cmF0aW9uLiBXaGF0DQpJIHRoaW5rIHdpbGwgYmUgYmFkIGlzIGlmIHdlIGdyb3cgYSBzZXBhcmF0
ZSBwcm90b2NvbCBvZiBvcHQtaW5zLiBLVk0gYW5kIFFFTVUNCm1hbmFnZSBldmVyeXRoaW5nIHdp
dGggQ1BVSUQsIHNvIGl0IHdpbGwgYmUgZWFzaWVyIGlmIHdlIHN0aWNrIHRvIHRoYXQuDQoNCg==

