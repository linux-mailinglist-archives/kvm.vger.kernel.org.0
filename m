Return-Path: <kvm+bounces-59944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE13BBD6936
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE1393A914E
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335E7309EE2;
	Mon, 13 Oct 2025 22:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mkr7sKYr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508743093A6;
	Mon, 13 Oct 2025 22:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760393322; cv=fail; b=Y0RXgZEmhD9QdFcJDT2cprF3xLva0yXA8f8xBzUfAPGYrY2/yD+AIifhWHI63CQA1vI1T59jOeD7Zd4boIcsC9A+2E81L3RUIAGmiU0G63ZF+QaF4DIWep83kOsI6cwrG54ORkyHlUM+3Y5J2BdYWVGmLFY5zI2nEM6Mo1vfZiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760393322; c=relaxed/simple;
	bh=rRcd6IofuzVg03w7mkjNcqmPEvaBx3WhY43hhQbJ7XA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oBmVOWHIMjjVBQCs01j6L7UPYFsF8EcNtAH+i+u7nh0aHHDIdAOQt7tzgyoKKj3PFoH7VOznhSBps7rcCRugcAIrAJAoklK7kOONrJUoC0QrrW5WbC3wozT9nfQjEb9CcBSrlIBLZzU081QXIV7ITRzXuhQZb63Ho1GDcmn3SYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mkr7sKYr; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760393321; x=1791929321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rRcd6IofuzVg03w7mkjNcqmPEvaBx3WhY43hhQbJ7XA=;
  b=mkr7sKYrGXhdh7XOTBiVt3V8rx19eDnsaPuEe3p43I/S3s1fmSsZeLzK
   uONurhjRDMg+DVakMQGzGvTJoOBsZAhgQm4vzaXPuyN+avk+4vzYzHk/r
   gYOXKCDXZxtDBdNARV0uxmCeRDdlJNODFWJR40ryMVWSslzKAM6b6jSv8
   GIuB/PGeDHGsfZTNtXvvm/h69SFXLkB+4Paq8Z29SmI8lBfVsQbuVwnTv
   slsP3TWLQOkPkPPk2VuPd56eyrNI4s8w6LgpGqHMja23pFS2yIR5ckAXj
   dUihmv/uEaTXpsHQwJ41ChHEaFbB9eUvqdXpH+fA0veqRMNDPNIa/HhaK
   w==;
X-CSE-ConnectionGUID: YR3qDhwERzuLa1+TzLv+rw==
X-CSE-MsgGUID: IHCggTqDRMaiv4sGxlhHFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62644636"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="62644636"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:08:40 -0700
X-CSE-ConnectionGUID: xupZqr2FSNGAUlCqXdlnoA==
X-CSE-MsgGUID: yS+Ker17TYCecClQhj49uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="187012528"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:08:39 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 15:08:38 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 15:08:38 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.53) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 15:08:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVj0qc8Ff9ZK7W+OwUDV5FkDWOI9rM5mQ+XZBrZeGkzWOjadSug+aWt7nFMIKckPXrIzFgf45Ae1hIwzI4+TeFs21qX7+uGR+DLdKvu7VwygJ+npuqbSUaJEeJbhfvEkwaIuQTQ7ixcd/jIDXs/4P2ptJsGdfJeApxb05xkyuLoSwQZz22Xn3vXLqyY0qKhg9OwqNXYh+2RsnVlHzIeYv7UkfFk9iiI/OTvR1p3CQJl761JkjEh7v4FwDPH2Ug1us5kfNvp4usxQ+Vx5woWb6REFa1pcY7H7F7hS8YSTMomSrs5kUgtVxQzXj16mi6MyCG9hcTK7gYYwZTJpwPwtbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRcd6IofuzVg03w7mkjNcqmPEvaBx3WhY43hhQbJ7XA=;
 b=KGlE1XC3A2+beOJF8VtsaHPCL/lX9tY6pz0PyL3S3A2+dsY/q40RobZo9BKtK78qxNvwXCpagHfv1l1Th1HQkNDSummsYsIEgXDrqFCgyMJtHCUi3GuZlovv815lWZ8kl/0yrQ3gt/azDjRrReUhd3RQMICTyCkFzYOIZJQURIRvnwjr0QBoMn+ftSMW5Qft9gjxEocI9XRXTVQj/swenvwXegKV9Rxz4nCp+WiUw5jcyClHC+wqFnPtcuEpyseIGyApQ2+edXSEfdhQ5LdlwSxBetfk62Df2JB/M1B7fYO1Ws4warEKwox6vR8HuV7S8NyQP7OvSO0nxOkLOXM+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 22:08:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 22:08:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "xin@zytor.com" <xin@zytor.com>
Subject: Re: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Thread-Topic: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Thread-Index: AQHcPG9+ji4Sx5eRzE+xlwAWwOAOMbTAovgA
Date: Mon, 13 Oct 2025 22:08:36 +0000
Message-ID: <d75130b0a0fb9602fa8712a620cb1f7e52606ea4.camel@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
	 <20251010220403.987927-3-seanjc@google.com>
In-Reply-To: <20251010220403.987927-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7714:EE_
x-ms-office365-filtering-correlation-id: 2bbb4c52-0bcf-409c-7931-08de0aa50eeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Uy9QTFlKMTJFblNhczZDejhXcXo5OUF3UlFKaTNHYzVmSVZVMUtTN1ppUXlS?=
 =?utf-8?B?L1pqREhzeDJMU1ZsaW9UWXJ0c0ZROG96OFo0dHdNWWJVdEUwbkUxcStZZyt3?=
 =?utf-8?B?Y0ZhQ0w4RWJTcGhVR2szNk9nSGRlb3NyOVJLRzRFZXQ2T0hNeWlWbERkSkNu?=
 =?utf-8?B?RkhLWXQxeTN1WUtyblRVc1BNQ25paHJuWlFnQXdFSnRXbENMa1hCc1lmYldi?=
 =?utf-8?B?VlBMMEpZNWtwd1hYYnl6VkpwRE10ZkdSNlN1U215d05GVUVYdW1BMFN6VndT?=
 =?utf-8?B?MXhZS0IzMUIvbFdFdmtGa1lqTXNnVDRRWFZmSTR0THd6ODh0MWV6TmxEWVNp?=
 =?utf-8?B?VnN5OWZuK1dLaXhGWGFXQWNsQW0wSXhYTkFMSmZDOXFYVC84TkZPeTdBNFpY?=
 =?utf-8?B?MXF3bE5UYkc5QjZBdjl5YTkwWk5vbE1GVlgvTGozOU80Q1VBeEg5aDBvc0t0?=
 =?utf-8?B?UlFVblN2QWhLekJ2M29raWduVCtJemhjQkdxaUNZYmxSTGY4ZzgrUEQyMGlN?=
 =?utf-8?B?WGFLcVJNNFJBZ2NJZ3d0T0d2VlVvRk5heU5UNktuVnpCZGlXVlZwNXdpUkcw?=
 =?utf-8?B?bHhuNzNCNFhRV3hnWmt5NjlMSys5aHJwZ1N5REFGV0dIZWEwZmJKQ1F0QTl2?=
 =?utf-8?B?U2QySEM3TjB5WGE4THNtb0RLSDdmWXhPc2dqcWJyLzV3MUwraGJ6eGQ3UEsz?=
 =?utf-8?B?U3hCbjNWVGVDTElIdU05b1hjY0pESWJZZXhvWXNKM2tOcUxrVGVUWm1jOUh5?=
 =?utf-8?B?OFNoaVZOOVcxZE0zRzUvbVVNSnZKVWVjUHB1VnhzNFZPYmt3aitZa01LUVA5?=
 =?utf-8?B?Y0pNUHNVNEoyN3R3VnlzWnVsODg5cjF5bUNVcWtBRnZWZHdNWVgzaU41bWhX?=
 =?utf-8?B?a3M3N2VPUmNON3N0QWpSb0pJSzhyb1g4dDZPTnQxUEh6dlFjL25NWmhaYzZp?=
 =?utf-8?B?djREUWUrREJYM1M0cWFNR3JiZkNLKzZrczMxSzlqTm9idGZJNWxVdStGVFhm?=
 =?utf-8?B?WHEva3kzL1d5Q1VhdkNPNHBEMlQ1UDRWdzVydWc5Y2oyeUZmYTN4MWp5UDJJ?=
 =?utf-8?B?SzdTbEo5eWJjWGRRQURUTmw3RWdPMyt3L0VwenlHOCtFc2x0L3pKNEI0SUZJ?=
 =?utf-8?B?MFpXNWQ0Wko2SW4wTGkwSDFaTk05UEdzS25LS3Y1MFE0eVZxbXNjN2wvbzFp?=
 =?utf-8?B?RXR6S2JwVkNXdjd1SndvWmlqRVRNcE02WmQyRlFXdlVKMzR6NmVNdnZScjF3?=
 =?utf-8?B?NE44bTRTR2QrdldXcmFIWVRObStnQWhjUnJ3KzJ4OVVQN25UaEdjUTVobWx5?=
 =?utf-8?B?WnNuTklmZjhTN0tUcDBpODB2U3NNUVZpMG1vcmo3cHppMVBwN2M4RTNyd3B1?=
 =?utf-8?B?NG05a0xOc3A4SUNYMjRYbHJJVTVLTmNNUklKdGk3VXRlOGQ2a2ZlbU5oWWV5?=
 =?utf-8?B?U2dUdlhsM2lvVXRESTN4V1VGQ3BGUzVUcUNVK0dDTnFjKzR5V2RDamVwMmRk?=
 =?utf-8?B?TEpqejBQTG5McU9NTXpJM1ZiZElIZW13LzFDNldiQzdYMmN1RlJFY00vZ1hV?=
 =?utf-8?B?ejZBUmtZNllLNHhkWnl0OWxwaFA2Uk5QN1ZnbGZVd20wY1dzMzNMNGpSS3RO?=
 =?utf-8?B?bnp2aUw5em10KzFuanpGemdtaDgvZ05wUUFPWktBZXlZNlpFb2t5dE15SDRB?=
 =?utf-8?B?cml3dFZEOXF3N3QzRUZSUEUyYlhKb3VQYmxzSGhiSE5KdDFOcW5ZRTlpY01F?=
 =?utf-8?B?SmlHc3VUbEQyY1NZRHZTZDIza1dqbENYSnFTTmNBVWppRkR5YUpGZVRlS0tQ?=
 =?utf-8?B?Mm5iZEtUVTB3QUFLNmlUSm9La3NMT1dSNUdFVm9IMHExSklOdjF1THl5SW94?=
 =?utf-8?B?MkM1aE9hcnpSU3FJQ1o0VzhtZ0UrdUhSUXViUWJnd2VpR1NJcXMyRnpCeTJW?=
 =?utf-8?B?bTcvaDhpWUdDdDhTU0Z2YlpjT2c3bE5LU0k3VVByZXRZazJqZHJKcEdYdnhx?=
 =?utf-8?B?WDNvN2puL2V2a2YzOGkyNzJSU0JBeDE4Zlp2UFhrcHhPTVB4aGpSS080THE2?=
 =?utf-8?Q?2+tCtf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFpZU1VVVHBTM1p6SXZTNzl4VXRpdHZZdlFqdDdMN3VBRVhyVmMzV0YwSXVG?=
 =?utf-8?B?QUxlbU1IRnpHS0MwS2JFbGsycHJUY29XaE1WNEMvRW1rbjl6WXl3aERIeUt6?=
 =?utf-8?B?VlRMOE9xd0dtclc4THUvRXJlQlVsT2d5Yms0ZkxaY2lJOW9veHEzSGJ6aWRL?=
 =?utf-8?B?b083dk85Zmp6RUM3cU1FQ1dQaWNDRnhpa1B5SEVkdGduaVFENDNScVhHNDdu?=
 =?utf-8?B?dnBwdFZxMytCb0RMNSsrY3dWUEVENXVnRGZoazUwZGlTTzZPUTZQUytzK2tB?=
 =?utf-8?B?Q1BYNFd6andMbDVTVmNKOWxKelFTeVZXWG5BTWJySlBsV0RWdFhwaEs1Z0VM?=
 =?utf-8?B?VkVSdFlORDF1RDRNSWhjZHM4MkdsdENmamVCQVhrL1pUV2kxUjE1OTJwU21M?=
 =?utf-8?B?em1LbXVIRCtGNFArSEpTQ0dBTkZ2RVlxMVZqa0dsV29qbEc5T04rNTNkTGpv?=
 =?utf-8?B?Qm54TmhMWm96VVdjbDEvemJUZGNVWG8zMllxbkZKMXNQTmxMejNQMGhaSGYy?=
 =?utf-8?B?UStIbWFNNEdkeVpCUHJNRktrWmZsZk1XeVRMNlVmS3ZFVUdTRjFTK292L3R4?=
 =?utf-8?B?bnorOWRRYzBmYjhpSlFqdURhOGJ3czcraWxUMkVtcnZMWVJNSE5ZNUM4Zis1?=
 =?utf-8?B?VEordVhrNE9ZazNINGkzczBLdE9oNkpLV24vTURFRjh2RFFnSllSQlFSREEw?=
 =?utf-8?B?cXhQVkwwNkxrdWVicXpNTEtOclJ0RU1zVTRBMU96K3UzamtiZ2QrZ2RLaW5z?=
 =?utf-8?B?enRQb1BaQWpWQWF0VGs0ckE5aVk3dGJXVjg4UnVETkVzZWhFOHkzR0ovS1lL?=
 =?utf-8?B?QkZSbU5DVlgzRTF4VW83L2Q3ZlgvNHhKZ0ZxelBWSUgrVUQzVGZiNFBEYzdY?=
 =?utf-8?B?ay9qMURyRTFpQXFTM1QrRVBaV3lyOXorVXk0RXB5RzNmUGROYW85ZVg3VmNC?=
 =?utf-8?B?dXY3VmVJV1JJdWl1SnlLbDlKczMyeXZSWUs2ZkZ0MDEyR0VmdmFXM2JGSU8v?=
 =?utf-8?B?dmZtTTJDajErT2ExMGx1cmhOanRrSTBMU2V5ZUxoNzRNaVNydWV4OGJzS21p?=
 =?utf-8?B?SkdMTTN6Qk5hSjdwZXk5N0diTnVzbFAxazJGVjFOZ3B6WFlpNXRpUmxZWWhV?=
 =?utf-8?B?YXp2Y2VNYXNqZU5SV0dUWkJRMUNBZkNGc2VILzZDUDVQOW1OTEhMblE3bXR5?=
 =?utf-8?B?c3FzbjhZUGpYREI3LzhhaFI5RnRJTkhITUZZMHZMU3RUdkx3ekp6Vlh3K2Zx?=
 =?utf-8?B?S2t1Y3NkOHpWM3lkNFBOeVBaNnhVaHJCMlcybHRUSUU1RTJlRnFvK2FDeUVO?=
 =?utf-8?B?NnQ0S1hkbCt6UUIwVHhLcGtadzRYZ1dWTVJ3QU5JSlNJWE5QZTVHNWVDWlJz?=
 =?utf-8?B?aW5XRFhoWUVLTk4vaFRNOVFqZGJJbWxaS1hhb2cxSFZJZ2lYcVZ1cFpXUG45?=
 =?utf-8?B?RU5WZy9XN3creW1FNTJtTy9NS1pvelRIOGZIZDFRSHFRNlVUTzVUN3ZrcENQ?=
 =?utf-8?B?bFpJbUYza0FKa1ZVMjZ1QWpGOEo1eDdUT0ZiSjQ4Z01kRTRDV0s2ODJhdzdy?=
 =?utf-8?B?MUR2Yk1aT0kwVERWY1Yzb1lucVJmcFZIRHlYQjlINDNwZUtPT2o5Y3g3NlZh?=
 =?utf-8?B?Z3hwRXE5cC84d01Xbm5pME91NXlVamFsREM5RlJkNWtPQVh6eFU0VENBc1Ew?=
 =?utf-8?B?bitna0FjcklpS0FwNzE2a2k2eHhiVnRlaG5CTVlLNUpWcXdRWE02WkFkanBq?=
 =?utf-8?B?US9DUFpSMU5lNCtEUjEzY0JBWWpJVXRyRXYwZXVyMGQwZ1dlY0w4R2k4VUZa?=
 =?utf-8?B?Z1liT2dFdUljeXJsQnBtMWJCWFQ1cnRBT0RJVHJlTEtxOVJZMG4zblpiZWdQ?=
 =?utf-8?B?cUV2Ri9kY2s2QUt5NHpvRHZxWnZBQkFQQmE0V1poaU94d3ZKRXFJUDRjTDVT?=
 =?utf-8?B?WUo5S1k1Q3N2NGVROVFWUXliMmRXOTlvc0lheEh5QjRGVTdJYVF4dmYxTEEz?=
 =?utf-8?B?UHBoWWRBbWo4bVowNlU0Z0ZLcUl4MlQ4OUJBcEViWGIxa1JObndKekJiSzJx?=
 =?utf-8?B?S0pmQ3NrQ2UyUkZ5ZHNKVkhQeDJOYUtJTXdtZE96WG9PS0t0U0VCOFhjWEVI?=
 =?utf-8?B?ZlkrbTAwWk1nUXdYZnB6dk9OWjRKUWVKUElBY0s2aEpsb056UzNrekZkWG0x?=
 =?utf-8?B?eEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A886935DEF238409B510580A44FE733@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbb4c52-0bcf-409c-7931-08de0aa50eeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 22:08:36.9220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J1JwAQS6BNQE7B4j9YKKoKnKWcCdUm2nTD6XVjB79CaPMgj4n3w1Dydga04FDH4/VY6WSm9Zm8yBYlG9ecmMoo312iAlPNAtGHoWDKZSlcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTEwLTEwIGF0IDE1OjA0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KDQo+ICsNCj4gK2ludCB4ODZfdmlydF9nZXRfY3B1KGludCBmZWF0KQ0KPiArew0KPiAr
CWludCByOw0KPiArDQo+ICsJaWYgKCF4ODZfdmlydF9pbml0aWFsaXplZCkNCj4gKwkJcmV0dXJu
IC1FT1BOT1RTVVBQOw0KPiArDQo+ICsJaWYgKHRoaXNfY3B1X2luY19yZXR1cm4odmlydHVhbGl6
YXRpb25fbnJfdXNlcnMpID4gMSkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlpZiAoeDg2X3Zp
cnRfaXNfdm14KCkgJiYgZmVhdCA9PSBYODZfRkVBVFVSRV9WTVgpDQo+ICsJCXIgPSB4ODZfdm14
X2dldF9jcHUoKTsNCj4gKwllbHNlIGlmICh4ODZfdmlydF9pc19zdm0oKSAmJiBmZWF0ID09IFg4
Nl9GRUFUVVJFX1NWTSkNCj4gKwkJciA9IHg4Nl9zdm1fZ2V0X2NwdSgpOw0KPiArCWVsc2UNCj4g
KwkJciA9IC1FT1BOT1RTVVBQOw0KPiArDQo+ICsJaWYgKHIpDQo+ICsJCVdBUk5fT05fT05DRSh0
aGlzX2NwdV9kZWNfcmV0dXJuKHZpcnR1YWxpemF0aW9uX25yX3VzZXJzKSk7DQo+ICsNCj4gKwly
ZXR1cm4gcjsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHg4Nl92aXJ0X2dldF9jcHUpOw0K
DQpOb3Qgc3VyZSBpZiBJIG1pc3NlZCBzb21lIHByZXZpb3VzIGRpc2N1c3Npb24gb3IgZnV0dXJl
IHBsYW5zLCBidXQgZG9pbmcgdGhpcw0KdmlhIFg4Nl9GRUFUVVJFX0ZPTyBzZWVtcyBleGNlc3Np
dmUuIFdlIGNvdWxkIGp1c3QgaGF2ZSB4ODZfdmlydF9nZXRfY3B1KHZvaWQpDQphZmFpY3Q/IEN1
cmlvdXMgaWYgdGhlcmUgaXMgYSBwbGFuIGZvciBvdGhlciB0aGluZ3MgdG8gZ28gaGVyZT8NCg==

