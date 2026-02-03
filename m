Return-Path: <kvm+bounces-69991-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGzvGFfUgWmnKQMAu9opvQ
	(envelope-from <kvm+bounces-69991-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:56:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0442DD7FF9
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3F59430268ED
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 10:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8121D32937E;
	Tue,  3 Feb 2026 10:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mqpMOYkH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3CF314A7A;
	Tue,  3 Feb 2026 10:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770116180; cv=fail; b=MK9nGDUmG7i99X4zw37TBRT9OajjON/RXvntZBL75aCasMVXZ8K8WOs5wiGnGK2tlWhsuCVzdjejj9VoDXWiqIIRfC36C7Mz4qXXMlW2nOYCLjEI+Tzv4sPQKhChpnWqciM9ni+F8TWAJXYza4DYI9F9xfAiYnCRc/04VwFof50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770116180; c=relaxed/simple;
	bh=8LW/FMV4XxxwRbap2oPn1vQP1euOalz7Fv00rh/eDgo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hQ8pNYANq5lHRiPIKmulmY1vBVZ4yZg1yTaPJ99+6sb3n1gjWfypgipE7rSoqr5CJlpBozx8Upc3gkphtfD+KulKq8io4UPV5Bg52znqkDmy3mkzciShXwcyCif56Ioaato1OYuyYScB44FJGIEIWAcyedp/QpuLLrYAcrJJLMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mqpMOYkH; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770116179; x=1801652179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8LW/FMV4XxxwRbap2oPn1vQP1euOalz7Fv00rh/eDgo=;
  b=mqpMOYkH9UqyTOjLKgUDdMxkuvC2hEgQYpNOvUfJz6ThLMtCUUG02jNW
   nly5nuGCq1BzkwtQwtkP014Q8QAZOT75KHkcngJaxY29hQzPxMcHO9MFp
   3gL7LlSZTthlR58fuDx9bQ23LV94cgB7WiABc4ZVAmvf1ugEDB/AYKoYa
   t5Lm7wY8TBL7gAnLEhyWxymuCUKByWn+KnppgMeFPsZXuYoyA/tOhD/Gw
   JumvbEjAmM+nF4jrwRxBXC5VVZ2QuAzjwFbaIt1vszYL4QRLY5XOgaUGf
   kG6ZB5i4r0B5PlOTgvUDICvc9dzxc4JuSIxhIQGPZ7uXottnfms+L26Jq
   A==;
X-CSE-ConnectionGUID: B6Xrw3+1Q2KStGPF2/HK5Q==
X-CSE-MsgGUID: PmaX4zUyR+Of/Lg+KY14zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="75139143"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="75139143"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:56:19 -0800
X-CSE-ConnectionGUID: vQMiD4LtSDyCJV+hozLUtQ==
X-CSE-MsgGUID: tAbKEwXZTaifJ1+Q1AYfHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="214583465"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:56:18 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:56:17 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 02:56:17 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:56:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xXR3QtqJU/M0mbHH9NhOaRbSFgaVjb7rwEWcxBHu4Fbu1HN7EmnZ1VEf8XdhAvgTQJ8ehxo0usXEBST5gdreYBJjg0AqzNDIaLagNbXJ/P+XKlt07KNeKZeFu6/OPZ2GOuCeTQGyacVl3BaeVT3syLNnac4/SdonH3pFH5D+ITpweKpjm7Kc77rdtJZUrwUjH3lMzjZn7GT4oIsdgPiGIlvAoEhp9fATwArBIOIONJvHF43EB363i6Qt0psU/cx8T3UAgvcuCkz5u5TE/JpR5iMOQSmzTLizibu9IlwMQaYp64+4Qm7PWGljfIq4AbryxWtUUQAGFNXqyD4uCOI8kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LW/FMV4XxxwRbap2oPn1vQP1euOalz7Fv00rh/eDgo=;
 b=HHIoPFQiYaLNbYN+dSb3GSYYmocTprSmeR2E2PeTjmPGaDX3UutihnFJTq0tYPpXgSUE2sH/DWxgdUSn/tjzYaMJFTzz9pXWnkTBkkyddNDBe8/EADoHQC6xFhhdJr6nAygyfhJfzxr1Of33x/5zVg+PEFB/CyTqKxjgv00I96OcZMT4BhI8qbJNjXBGNzpcGTNe4CDPpGLprW6pZ+HaQ5D3VlQLVWIAdtXjMlYS8NYSn0DOz993zFHPVrkuVgEZXEikWTlWQXjDNvgqUPRIvEjO5A0UZlxLJXKHhVl9ZNUMcIArP7XAL/Cs0/BFulNSBX1Pbsufr5J7LEEkBQ0O3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by DS0PR11MB8019.namprd11.prod.outlook.com (2603:10b6:8:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.15; Tue, 3 Feb
 2026 10:56:14 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 10:56:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Topic: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Index: AQHckLztHxU2OO4T/UW0cV8EUajfk7Vw1fCA
Date: Tue, 3 Feb 2026 10:56:14 +0000
Message-ID: <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-20-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-20-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|DS0PR11MB8019:EE_
x-ms-office365-filtering-correlation-id: 88611437-f5eb-4fb2-f4f5-08de6312d991
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VFJCZjVDcXc2NTRoUjhhYy9zVGNkTTRxOE5Cek15d2xqY3htWERtNXpJSWg5?=
 =?utf-8?B?aTlUT04yUWdMVmJ5UjA3Ykh5emV3YTNYUXFUVUpQZnhOK0gxUkRUN3ZDOGVk?=
 =?utf-8?B?ekFKb3F4WklSdW16Q1QyK1lyUThhcUxDdzdjK3pLK1RqVk5XTThjRThySVdY?=
 =?utf-8?B?NkZBNDYxdjdycm1oRU56Y244Zi9yUGduM2ZpTVMzaHVaQ0hSdTRPL2dpSzRk?=
 =?utf-8?B?K205ajZFU0s3U0EzSlRVYytVZFZDRDZHeEJoMHcwWmU0cFp2Wm81b2hNOFdp?=
 =?utf-8?B?Y3VPUEU0YmN4NXVHRldldHg5YWdFekdMWUJVQloxa2pQN0xmSitVSlc4VHRM?=
 =?utf-8?B?YWVncUFIYnJmQ2NSNlpQdWVEUmJKbW5PYkYrdjJsLytFcFhKK25hRVl3VHA1?=
 =?utf-8?B?QTBpaDFXbHlDVGxQTWExalR2TnZWYnQveVV1VTl2bE9NUTU1R0tZV2FoNXRp?=
 =?utf-8?B?bERLY3ZJYkI1L3hSdXl6MDlORk1tZkk5eWVYcFhLWWJ5SE9ic0dSTWJjamlR?=
 =?utf-8?B?VUNZRStyVm9qR1c0dVUwVlVkZnhZNGNwalM2eS9hQTFEQ2Nkc21XdVJsR2Yz?=
 =?utf-8?B?VkJnNm40ZXducHlzRy94c0hpemtZNVZiZXBIYVVPaENtMHVnS3dlZXZLM3Z5?=
 =?utf-8?B?Z1N2c2c2QTE5RlVGRU5NM2w5SGNIeXc2WjFyKzRPRTVHemZSNDdSMHl1c2Za?=
 =?utf-8?B?VjkweDNVbmZXUjZwdm12L3ZNc0MrdW45Q21EMXBDV3BtbmlLSzA2TVFxNFBK?=
 =?utf-8?B?OW01OFBjU3RwTVFpRStNM3duN3lJWVp1SytHTWZOOFdnVVVWamY5TG9Wc2xV?=
 =?utf-8?B?ZXNBeHdNbmFBSWgzVWR5NVVKcXdoSGhrYWJzb0JnQ2JkbjVhbGt0Nk1QTFdi?=
 =?utf-8?B?dThwd1ZoQUZwZDJUa0s5MzZxNGxVWEpLUk9zdHNIYmkyZjZFL2JkWlFoWUlr?=
 =?utf-8?B?MWw5cEZJS1VHbGlKYjg2eGh0cGJiQVRoclFWNjc5Rkp1MFFVSDBRaGxuVzRo?=
 =?utf-8?B?ZEJOc3JPT3EvT05TRDNTQ3RmdUlvd0k5RG80R3Y5Umd2Z1JXWE5yckZONjdu?=
 =?utf-8?B?cU9yV1lCSVNuTis3aVFjaGhCREpaTTlDWXhUcWYyejltQXYvZEJHYUl5T2kr?=
 =?utf-8?B?ZkdvTUVXV25HOHVBaUNmemVkSlBoZzNxaW9wWG1TS3hoREtFNkdSOEFwbGlZ?=
 =?utf-8?B?bzV3RmNYVmZqakZ3OFl6VDQyb2w3azd1M1VoQ1MycTVLbmdCc0ZDYjEvaGdY?=
 =?utf-8?B?cXVvZlgxS200b1lkZjhLd0p3ZEkvNml6K0x5WFY0cVNPSDNKMURFWUQ5Vmsz?=
 =?utf-8?B?ZWFYTUY5T3cwUlRIUG1lZmZYdzNXaXZtWjlEVEsyRmpDOUZWRnBadGdKRmFF?=
 =?utf-8?B?MC8zZ1lRbmJOcjdsdkdNOXJJUjlKb2NHUTYrRVl2akFpVXozT3R0UG56OHpj?=
 =?utf-8?B?R3I2YlZqTm85WVJCRkhYU1dicDZVV2tIeUJTeUg3M0g0aW85c3d1RHBnUWpi?=
 =?utf-8?B?NnZIUWVNTnpTNE52WFd6UGFWUDhpR0JBSGQzVDN3UGFxYTlhSkk4RWNIUERZ?=
 =?utf-8?B?QXVISkRIdnhJNjVJSjBIYmVHQXBGYjc0V1Q3UVNlUldNWnM1UWE2WE5HQkVx?=
 =?utf-8?B?VFRvanlVa29pUDY2eGZjYjBralJDMFRBNERsbEhmYUdVYm9pQVFsN0pxOTdZ?=
 =?utf-8?B?WEE4dlF1dnpRRk90dS83dmJXZWlTV2NxeFczQ2FNYUpkanR2TGNBNzN0VHJS?=
 =?utf-8?B?VzFVUWFIejhYS0s0K2JyMDRkREc0MWozb3BITTIwN3JQT1RHSkRrK2RXb3Y5?=
 =?utf-8?B?dU9SV0ZaMm1tdGVQaGRFWjczblg4elM3dVNsMk9reEkyWktwbExTKytNVEhr?=
 =?utf-8?B?ZWtJalpGOWxpUXBPWkFzZkJyTjlDam8yK1lybnJ6TEFTODEvQTU0T291c240?=
 =?utf-8?B?N20xZ3VPOXhiV0dUejlsS01JaFNiUWFqeHMwdHhNWkwzNmZJRk13YkxqaUE5?=
 =?utf-8?B?YTlCYjRQcytsVmtDbUdRZTBhZ0E5RUpTcHd5VVF3Y3c5VjU0Sk81aVZ6a3dU?=
 =?utf-8?B?d1hWcTd5OG1RQjM0NS80YXp4b012RTJLZHNacm5GeDg4Vi9CaitWMEY0NmpH?=
 =?utf-8?B?WFdsMGNEeGttOGVVVlpzMmMwOXpCTlRSVnVHcDgrOVVjL1UxVVhOLzdRTkxS?=
 =?utf-8?Q?OhAgttT9ukvxghEPrknY1Pk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUpqZ3poclp5VU5LS3BmS3ZaaUhBSkRRYVRIdDBTRzZTNzExR2cwaWl5RTl6?=
 =?utf-8?B?bU92MjAzdFp2bzdwNTVoaDBZWFF4WnBZcXR2WkdIa3BwdEQ4K2xZZURvQlRq?=
 =?utf-8?B?NEZiNFdBR0x3SWtINTRzMzEzWGUwVHhBOWN5SG9EZGp2MXdWQzdJemR5MExs?=
 =?utf-8?B?ZjVzM1dNRVRJYmNpWUdxcFVrakdXNUdMdkF1Slo0RHkzcjRIU2JRVG00VVp2?=
 =?utf-8?B?Z2RpL1ZXREJJZUZSbVRjUm4vTmxVZWJJZEZuTVZCbEdTc3FuekM5SXI1SEJB?=
 =?utf-8?B?eFN6NGZpOHBVUy9uampYRXpjeG5VV0JXK0tiTDNJL0plUDNwOXNWV0JZSHh2?=
 =?utf-8?B?SENJU0d2eFRNVE9IWUsvRCtRUldyZHdBVTdmZXF1S0U2SUFNbkJtWlRjVEJn?=
 =?utf-8?B?eGwraUZ1QWhVNnI2TTNzTUtMcGVDdGZ1cHI5VEsveG50VndsaWs3aXNlVHNy?=
 =?utf-8?B?NVV6bzA5ZTM0MGpHZ0hMU3lKOFlIWmNOZHFCN3lrM1NkQzh4SmU1MW1qcmFC?=
 =?utf-8?B?cUE1WTViRllLdUdDMTlEVFFlNXVGU2Z0WEx3d3R4bjVXaENLcysvNloxV1JX?=
 =?utf-8?B?bEYwMlBPNXR6TjVqRldOK1BBWGNJQTdqZzExb2prWmZZVnpEYWU1dGtrd2dZ?=
 =?utf-8?B?dkdCZm10dlBEdmdmMk0wMmFyd0pFWGNrSVpNU3B1ZzZxMkcxWFE4M1J3WWhk?=
 =?utf-8?B?N1YxLzhYTVhUMisvN2NsV0hoYXg0UHIvamYrU05jRHYyZCsza3dORlZrOHFU?=
 =?utf-8?B?ZzFIeEgrZmpYWjByV2RpSUIwQmx4SjdPZy9KYkJwVDFsTXNWcDBPbko5T25U?=
 =?utf-8?B?OEc3L2tPeHgvTG9RM2IvTmZXSWh5RTU1U3lVa1lFMUdYWFJtbTdoT3NKQnBT?=
 =?utf-8?B?dzJXM2xHUTY2dlprankrQndZQVVvU3NxWFFoYU14T2hGU2tEQ0pIWFhiL3k1?=
 =?utf-8?B?NGYzT0FEMWtCdTlSQ1BuMDhlalhvZXZFdkFtL1FBaklaNENseDYvczhqZTdE?=
 =?utf-8?B?bG1HT3pLUWtCL1ZWYmwzQXpyeTVWUEM1NzE2MkovZCswVjFLTEpJVmZhNjRK?=
 =?utf-8?B?d1BRQzFyN1VPUGNLLytaOC9STXZZRkdBTFdjUy9UbjAwSUtYZVl5T21Wekpj?=
 =?utf-8?B?V1VtbHNseFJiK1YxamFJbHdqcGZ0OTZuZ2o4SnYzbkhNSUZCUWJGZjdVcU9M?=
 =?utf-8?B?cHlsSlZ1THhhNzRHZEh1Z3I0S0l1MnNXRXpMQ1o1SVZjUkd2NS80WkRFZU5U?=
 =?utf-8?B?dUFkeXFlMm9IRzYvY3pqTFdnSHRuQnBueEJ5RDBhdG9iVVRLYTh1bVE1NEI0?=
 =?utf-8?B?QmtkY0I2UnFmK1pVQUcwUzVYRlo2elZCWmtuUnMxR3NjTzY0d2xSeUNCN3ls?=
 =?utf-8?B?dWJPYzI0c1o4NGdwWHZrRUUwYW9hQ2ZxdmZPd1BBZzhxaEZ5UEtheTRlWk02?=
 =?utf-8?B?clNsUytYQkl2Wjc0MEJ5cjZaTU9tbHJhQ29Na3VxWmMvMnNuNkJSTTdHamFv?=
 =?utf-8?B?MTdIN3VYZEl4MXF0c3kxZHZUUy9VZm83NFFnV29HblB5dWFwZU1OajBqRm9M?=
 =?utf-8?B?QTNpS2FudHdIbVI4WWpYMGMvSmlEdi8yM3YySzl2YUIvTENwUHpwUzFldVlx?=
 =?utf-8?B?ZHE5aWRtR3JiQUhlSnhqT3lKRzl6WUlwcU5EU1I0UU5sMHArNXU5aWN5cHAv?=
 =?utf-8?B?cGI0WHkxcXZhWWN3dWd6cEkwZWlsN3N0S3JxUmtUTXNiOFFoVDYwNDNjLzY2?=
 =?utf-8?B?MUJXcXZPN0kyQU5mSnVyWk1PTXpRcDRYU25xN2tLVnJVbWNPYk9yNG5TUlpt?=
 =?utf-8?B?MlovaHJ6RjBJN1loallHUXFnMk0wWUpQNUlOc3RFQmlGT1lreXkwSCtlaDRW?=
 =?utf-8?B?cjVJejM5RjdrSEd6YXFYemp2OFg3M2hucWFGQ1pQOWtNMTNCUFNSUm1zWXRS?=
 =?utf-8?B?MkpmSCtrSGYwa3dtVnF1c2hQVmVFTEtyWnFWaTVXR3E1Tnlla1ltWVg2dWFm?=
 =?utf-8?B?VGxQZUlkY0huMWtVRUg2OVNMSzF2RTVmL3dBTXRhaWZUVDh3dVQ1bnNNRmg1?=
 =?utf-8?B?RnQ1ZHR1OWdEUUg3RlRrME1ZR0RPQ01saDFiKzJhbXRWV0VqTncydzd6WHNr?=
 =?utf-8?B?bDdYRzc1aHlZTDZpV0h6dy9vRG8yL2RWUU1OSXh2M2lBWG5yWG42RXNqU1J2?=
 =?utf-8?B?Z21sOEpDNyt3dzViTHJKSkpYM1hsMktpMnA5aHVMUmlvUjFQREs1UExkNzdV?=
 =?utf-8?B?OGE4UFB2ZWZ0NTd4emtCL1hTRndtWDhYTlVMcmpaRklBY05GZ3p3MW85SSsz?=
 =?utf-8?B?UW1FZ3VmZnRDZU5PUEVKR0NxT0V5N01lck90L2NVTThoNFg1NzAzQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F722D082BF10EB42A91485B434B3128D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88611437-f5eb-4fb2-f4f5-08de6312d991
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 10:56:14.3447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: smK+IBYgQ3UW5bQANlOOkp281a/N5N3awlF0DtL0n4YQbWkns3/YtcTUbAgPgw/HZEzF7tP92j1nhBTZpnfIZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8019
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69991-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 0442DD7FF9
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBFeHRlbmQgInN0cnVjdCBrdm1fbW11X21lbW9yeV9jYWNoZSIgdG8gc3VwcG9ydCBh
IGN1c3RvbSBwYWdlIGFsbG9jYXRvcg0KPiBzbyB0aGF0IHg4NidzIFREWCBjYW4gdXBkYXRlIHBl
ci1wYWdlIG1ldGFkYXRhIG9uIGFsbG9jYXRpb24gYW5kIGZyZWUoKS4NCj4gDQo+IE5hbWUgdGhl
IGFsbG9jYXRvciBwYWdlX2dldCgpIHRvIGFsaWduIHdpdGggX19nZXRfZnJlZV9wYWdlKCksIGUu
Zy4gdG8NCj4gY29tbXVuaWNhdGUgdGhhdCBpdCByZXR1cm5zIGFuICJ1bnNpZ25lZCBsb25nIiwg
bm90IGEgInN0cnVjdCBwYWdlIiwgYW5kDQo+IHRvIGF2b2lkIGNvbGxpc2lvbnMgd2l0aCBtYWNy
b3MsIGUuZy4gd2l0aCBhbGxvY19wYWdlLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpJIHRob3VnaHQgaXQgY291bGQgYmUgbW9yZSBnZW5l
cmljIGZvciBhbGxvY2F0aW5nIGFuIG9iamVjdCwgYnV0IG5vdCBqdXN0IGENCnBhZ2UuDQoNCkUu
Zy4sIEkgdGhvdWdodCB3ZSBtaWdodCBiZSBhYmxlIHRvIHVzZSBpdCB0byBhbGxvY2F0ZSBhIHN0
cnVjdHVyZSB3aGljaCBoYXMNCiJwYWlyIG9mIERQQU1UIHBhZ2VzIiBzbyBpdCBjb3VsZCBiZSBh
c3NpZ25lZCB0byAnc3RydWN0IGt2bV9tbXVfcGFnZScuICBCdXQNCml0IHNlZW1zIHlvdSBhYmFu
ZG9uZWQgdGhpcyBpZGVhLiAgTWF5IEkgYXNrIHdoeT8gIEp1c3Qgd2FudCB0byB1bmRlcnN0YW5k
DQp0aGUgcmVhc29uaW5nIGhlcmUuDQoNCkFueXdheToNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFu
ZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gIGluY2x1ZGUvbGludXgva3ZtX3R5
cGVzLmggfCAyICsrDQo+ICB2aXJ0L2t2bS9rdm1fbWFpbi5jICAgICAgIHwgNyArKysrKystDQo+
ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L2t2
bV90eXBlcy5oDQo+IGluZGV4IGE1NjhkOGU2ZjRlOC4uODdmYTlkZWZmZGI3IDEwMDY0NA0KPiAt
LS0gYS9pbmNsdWRlL2xpbnV4L2t2bV90eXBlcy5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgva3Zt
X3R5cGVzLmgNCj4gQEAgLTExMiw2ICsxMTIsOCBAQCBzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2Fj
aGUgew0KPiAgCWdmcF90IGdmcF9jdXN0b207DQo+ICAJdTY0IGluaXRfdmFsdWU7DQo+ICAJc3Ry
dWN0IGttZW1fY2FjaGUgKmttZW1fY2FjaGU7DQo+ICsJdW5zaWduZWQgbG9uZyAoKnBhZ2VfZ2V0
KShnZnBfdCBnZnApOw0KPiArCXZvaWQgKCpwYWdlX2ZyZWUpKHVuc2lnbmVkIGxvbmcgYWRkcik7
DQo+ICAJaW50IGNhcGFjaXR5Ow0KPiAgCWludCBub2JqczsNCj4gIAl2b2lkICoqb2JqZWN0czsN
Cj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5j
DQo+IGluZGV4IDU3MWNmMGQ2ZWMwMS4uNzAxNWVkY2U1YmQ4IDEwMDY0NA0KPiAtLS0gYS92aXJ0
L2t2bS9rdm1fbWFpbi5jDQo+ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gQEAgLTM1Niw3
ICszNTYsMTAgQEAgc3RhdGljIGlubGluZSB2b2lkICptbXVfbWVtb3J5X2NhY2hlX2FsbG9jX29i
aihzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUgKm1jLA0KPiAgCWlmIChtYy0+a21lbV9jYWNo
ZSkNCj4gIAkJcmV0dXJuIGttZW1fY2FjaGVfYWxsb2MobWMtPmttZW1fY2FjaGUsIGdmcF9mbGFn
cyk7DQo+ICANCj4gLQlwYWdlID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2UoZ2ZwX2ZsYWdzKTsN
Cj4gKwlpZiAobWMtPnBhZ2VfZ2V0KQ0KPiArCQlwYWdlID0gKHZvaWQgKiltYy0+cGFnZV9nZXQo
Z2ZwX2ZsYWdzKTsNCj4gKwllbHNlDQo+ICsJCXBhZ2UgPSAodm9pZCAqKV9fZ2V0X2ZyZWVfcGFn
ZShnZnBfZmxhZ3MpOw0KPiAgCWlmIChwYWdlICYmIG1jLT5pbml0X3ZhbHVlKQ0KPiAgCQltZW1z
ZXQ2NChwYWdlLCBtYy0+aW5pdF92YWx1ZSwgUEFHRV9TSVpFIC8gc2l6ZW9mKHU2NCkpOw0KPiAg
CXJldHVybiBwYWdlOw0KPiBAQCAtNDE2LDYgKzQxOSw4IEBAIHZvaWQga3ZtX21tdV9mcmVlX21l
bW9yeV9jYWNoZShzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUgKm1jKQ0KPiAgCXdoaWxlICht
Yy0+bm9ianMpIHsNCj4gIAkJaWYgKG1jLT5rbWVtX2NhY2hlKQ0KPiAgCQkJa21lbV9jYWNoZV9m
cmVlKG1jLT5rbWVtX2NhY2hlLCBtYy0+b2JqZWN0c1stLW1jLT5ub2Jqc10pOw0KPiArCQllbHNl
IGlmIChtYy0+cGFnZV9mcmVlKQ0KPiArCQkJbWMtPnBhZ2VfZnJlZSgodW5zaWduZWQgbG9uZylt
Yy0+b2JqZWN0c1stLW1jLT5ub2Jqc10pOw0KPiAgCQllbHNlDQo+ICAJCQlmcmVlX3BhZ2UoKHVu
c2lnbmVkIGxvbmcpbWMtPm9iamVjdHNbLS1tYy0+bm9ianNdKTsNCj4gIAl9DQo+IC0tIA0KPiAy
LjUzLjAucmMxLjIxNy5nZWJhNTNiZjgwZS1nb29nDQo=

