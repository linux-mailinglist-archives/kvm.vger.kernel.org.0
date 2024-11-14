Return-Path: <kvm+bounces-31828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8A89C7F61
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7318283CEB
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05AA3C8E0;
	Thu, 14 Nov 2024 00:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nq837Ja0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178BC370;
	Thu, 14 Nov 2024 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731544390; cv=fail; b=atvlJoaNug4UDh8onkbB+EB1ND3egWLdLhF9Z4MRmOsAMaEOWhMDFacS1/FocZc9zo4t2uvUmmSYNL8UYFpL+LiOxqOYDe51mFFiXq3+5OQGT1bhzF7Ql5XjlLt23Dpsvm2XEwQbesSosyjifrjQUZTS2FtXWkJC8i7f84Md7uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731544390; c=relaxed/simple;
	bh=ZU1ro7/HKCuQJD+duNtb4I4mQu1gVMTuDNRO1s9xnpI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uFcGsRKAn3GBRlKqge0j9MTKJjOZz49FFiLGlh1CcAqxfcbuuXnu9SKITneedk1n7z3An8Hhm1QvhblL/YJAhSGLjA2c9vJdpKYNOA95BsFwieaA5iyNEkDH7/f7ZJGs+C/BEkyks9CG5Bebg5Nx0XbRWMrYA9FIDi1+jP2JGpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nq837Ja0; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731544388; x=1763080388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZU1ro7/HKCuQJD+duNtb4I4mQu1gVMTuDNRO1s9xnpI=;
  b=Nq837Ja0dAPfR45MZdbwSNz21BnOHHgXY9TT88h/1epNa9pAp5eL+UcP
   MvHzAxT/fg8qL9n5mzyqVz8Rx3E7WgDjX9CFdID3BdIVyrHoTk5/SuiM4
   d8sHpp55fbh1EF44Y0dQ1uVCQwct3py+T3G1UdSG1a2+g33nvksMJV6vZ
   4F/JkPLGGUaLbbWy0keBWqtMOBmsuysVnPPP/k1gUuSlUN97juKyL+bID
   /cmzFPNa91kRExChE5aXWbcxxceTLpFfhXbzNg4RJDKkZuveSV8VbkUGA
   ny/hchoJnou1LFGmMIrPmVrTRMUZ7mO4rdMcBYJAbY5elD6rXQEZifgKo
   g==;
X-CSE-ConnectionGUID: rTVmZPrvTXO85wzafceAXA==
X-CSE-MsgGUID: ua6A4M41QsKG2eXnarKxnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="42088370"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="42088370"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:33:07 -0800
X-CSE-ConnectionGUID: yP3ZpwUwQr2pgLpO0c7tJA==
X-CSE-MsgGUID: x0/E/7pARdSmA0qGVDlmww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88452714"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 16:33:07 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 16:33:07 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 16:33:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 16:33:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XNVgnvSSwQBT5ovip2JaazAR3cqqIU0Ilgn6CixvKJXQxuTRctFiytbxFcRS7MhI1Zfg6NIhHV7iC55oVtVImneffZhaOySp0mYRlC82D1W8rY3oUspoJ7yB2gRGsKSeOmyjG/ZhxV0Jh9nnNFDqxl/lolkE+u7ZM1RNRNFINI/xXcb4Z4XRtKLQv5MualWA+/zB3sxA2vlv5CqXOxNLhxqIKSJOPYFNjkKmaIyeVYsAIYgydyTjh8ADckDTzRHPw4ygsFenn72DfeScoBlpkzUNpYFEIUTopx/hA9YvCQLcHo8dyO0c3QDVqEfkjvJJVcPO+ODT3KUwNO+wP94jaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZU1ro7/HKCuQJD+duNtb4I4mQu1gVMTuDNRO1s9xnpI=;
 b=wHo4OUQHVqDDWWKeDOzw6X4NYcdxehYsE2Py3GeLK2giA5d5rotO1xu64AJwMlZaMlBhTFlm6906+xGPZYYwVVahGkckDFPLSVbJwh4b9lAQoGyrbKAxHo4+pNR/sy4NnfaswaLhwaVfY814bSfLGs6WIfhlgY1oN0mFCWNCYLs/ud4erjIccaaB6h1uw59H4myhJcBW7aq120UdfP8CP77+AI6yjZTIXCbyqQE9nloabV0AVYvcOOiD+V/jafZWmDHDjJVkVQ7XQbVgf1ANyDcPyca6muUp4R4gz5CVOzBSr8YAomjgdDqSJL6mhd2GcoJrVmsCSjRGZHZ00C45Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7841.namprd11.prod.outlook.com (2603:10b6:610:121::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 00:32:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8158.017; Thu, 14 Nov 2024
 00:32:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
Thread-Topic: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbKv4rca7tZFwUNEOLKBi110Inj7K0baeAgAFX54CAAATNAIAACg6AgAABzICAAALSgIAAJ2kAgAADFIA=
Date: Thu, 14 Nov 2024 00:32:58 +0000
Message-ID: <32f7cd5fde98acc1b9e55ab2d4616de83173adc9.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
	 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
	 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
	 <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
	 <2adb22bef3f5d2b7e606031f406528e982a6360a.camel@intel.com>
	 <e00c6169-802b-452b-939d-49ce5622c816@intel.com>
	 <92fcc4832bdb10be424a5bcd214c5e9e746ede44.camel@intel.com>
	 <3f9752a1-53c1-4be0-a3a0-8be25d603dc2@intel.com>
In-Reply-To: <3f9752a1-53c1-4be0-a3a0-8be25d603dc2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7841:EE_
x-ms-office365-filtering-correlation-id: f8b32e9e-1499-40f6-e4b4-08dd0443e391
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0VqR1JKR2x1T2xnM21WMVBaZnVvZ0tDYnZNN2tkUTRWUE1wdkxGNzljVzhM?=
 =?utf-8?B?UUJpa3NHSTVtcXdNbTdUVnRmc0ozcmhmUGNVbTYrMHdBcy9razluWnppekJP?=
 =?utf-8?B?MU9GZjRJZ1RvcmZMMzRtRkhtaEY4RUo3V1BmQk9SWVhLOEdEOHdKcjl3cFdH?=
 =?utf-8?B?WGZrcFNSYnFxY0hEUWVGTUdBb3V0RDFHZHlieEoxQkphbndjWnppbkdXbTBK?=
 =?utf-8?B?TXN5OElGTkhIR0V1aFdnZFFqVmVCWDJnbjlDWWNKUjJ5SHJBdHZFaklNTVZB?=
 =?utf-8?B?M0tmMktGdi9iWnBxVWJSUFZSVFpSZ0ZqMnpMeEViaVFWbkkxeGNBcHd5NWtG?=
 =?utf-8?B?SnJoYmVxRWg4ckFoSlRRWG1EcnI5THlwZzFRWWlSdmUvS3Y0VkJMQnF4SHMz?=
 =?utf-8?B?ZXhUZ2NMV1RJbzlZY2pneXZVcEloc2JzeW5ZWVZJM09wY1EvUGt6aGFFMzdU?=
 =?utf-8?B?T21pdGpadnUrcEJKaW42QnBHamxFcFBpcUxiQVE3bENmR3Y3aHdqVWVYbnBz?=
 =?utf-8?B?NXBkU2lDN0ovVWMzWEhFRG1mZG05aVBvakFpUW1Ob1BMR2lRaGNZbkRlQ1lv?=
 =?utf-8?B?dUROWjNOTVNhTzlTWi9WTzJuK2VROVBvU3RPS2dZOTJoUjFxK0xuSzVIUkpP?=
 =?utf-8?B?aEY0UzA0Wi9CRlpNL3RRYy9Jei9yaFM1emJlRVNiVEJWUCtXaVFMZ0R2Z0Ey?=
 =?utf-8?B?WWZpY0NEZTZOZGxwTjFtZkFuQnpFOVV2Z0JFSC9MR2V1QkNrd0RUdHRnWHdD?=
 =?utf-8?B?UFRtK3I3OWRqYWZxaEkvRjAwTHcxMXlJQTdzUUVEUE9VK0tnS1lIY3RiNUVY?=
 =?utf-8?B?dUlyZXNjVW9pUno2WDdDQzZKWGN3dTRuMzNjaDhyTis4RXYyazMycE9uOXNS?=
 =?utf-8?B?MTFMRjQwYlhkYmZoVTRQWFBIVW5tWXdwR3VKR2dSR0dtd1ppdnBuWVBvUHdF?=
 =?utf-8?B?MUhYd2hqVEFQcTlSSklWU29WWWVYaUk5Q3FPVENUdzdONXFRY28zRm5IS0Zi?=
 =?utf-8?B?dDhhblp0aENNYVFTTjRrUWJaS0tsZzVzaWtHSlJMbjJYcjl2NGxNUVRSUXBI?=
 =?utf-8?B?RUdUY0psK3dDZnpRRzV0cE5BVkIxZmNMOGZNL1I0NkY5VE55cVdpeThnaVJ1?=
 =?utf-8?B?d3dIUE5aZVZXQ2pZdFdHVFNFVGFrSEtzU3kyOTNSSVNXSGkyc29PYXdYZEEy?=
 =?utf-8?B?bEVVOHphWEFwMWN1TVlOaTdWajlNd3pqL3RqZWdWNTBaUDJpYzNQRFZpQzRr?=
 =?utf-8?B?bWUwYzNzVjR0d055ZWdCcG9JS1NmelEydG1pZEMxVllYc05SMmZBVGFEVDRM?=
 =?utf-8?B?S2Z1Yi91ajF5UVFYTG45eEFhTUdxZFc5ZlppczRkd3hHODJNUlVUL0VpY3ZX?=
 =?utf-8?B?ZU5COTlnMTNjMStSN1didHJLelNxd0tLaTAyMEpxZnB6eGErWkpqemxwUEhU?=
 =?utf-8?B?SFl2QUhJbVYydzM3a1hpdnhDbkhQMlQ3UnRzeVRIZGh2UGJkb3lIdy9DM3hX?=
 =?utf-8?B?TzhBMVFrV1YwRGN4TVFWTUhGTnlkYWx2ekx5d0lkZklwVWZYQTlrSmpIUUVL?=
 =?utf-8?B?MkRNYjZ3Lzd6dy9uMHNjdWU3RnRqU24waHBKY1dya05kbnp4U3B5eXFaRGNI?=
 =?utf-8?B?VE1VQktFRXlMTEZMWVFDWCtYN252MzB5aDk0QUQrS1FDYlBVYW9DT2dLVHJj?=
 =?utf-8?B?bnhvZE5SV2oyQmJ3TnYycWdIMWNPcHFMSFBMVFVwTzhKY3ZKZnJTakVkTjI3?=
 =?utf-8?B?SHJYYUxmaWdsWnZKTnRJMlJFYy9IOGlZTW03elV5d29Ob3VhWktqa2lxbGty?=
 =?utf-8?Q?DSo0/5P9Fdi4xHdRmECyK6fK74RyudpxhqUcI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azFtaUpwemdLRUE1bmIwdm1YQmdzV0ZhSFpSUFE1NVk5T1U4dmJ1QXViWTR3?=
 =?utf-8?B?VFVVK0trMXFYMHU0WjhvSHVwb29XSVk1SkZGUDZNVlNOU0lERG82dmFwY29N?=
 =?utf-8?B?bFBGVDlPSGMrRUYvTGZxN0pFNmZTNE9YR1BqSXFJRWlxa3NJbmdBSkxMaXNi?=
 =?utf-8?B?UjYwQXNRbmpGdlNIRFNTZnNaMDRXTFU1N1RuNkNBdUZFbFNhbUJNTDlvQUl6?=
 =?utf-8?B?cXNITlZmKzhEc2FzSjR1RnJ5VlVPNDNhTFM3dkh4MXIvNEI3RHVXcTc3TjB1?=
 =?utf-8?B?N3NzeFB2OEh5Wk5VekRtWUNmZXlzT2IwWVRJSUNnbFNWbVJhS25DOGRQZVZZ?=
 =?utf-8?B?b3hNb1BYT0xLdkxwVi9LcjhaRWVmZVM3UDlGNnhwNklPMDdueEpIT1VmbEx6?=
 =?utf-8?B?T0RrelArQ2xnckNpMVZ5RDZYeHFTZFpKMmY2UU9SWFBtSnRBRSswbFVrc2p0?=
 =?utf-8?B?TkxmSjJ0VGJZNHV0di9pY1BnQVpUQ09lREpYd3VnbVdPSlc2V1hQbWxHVjN4?=
 =?utf-8?B?N3laTmdUU2oxMUkvY09QWGtPOXpmR2dGS3drRmt6Nmp3YUtmU1RTeU5RUVlr?=
 =?utf-8?B?K3ZjY2Vrdm52SEwwSllXSEFURHNzb20zL25tbHJwNEkwZ0Rmc1IxVGQ1d05r?=
 =?utf-8?B?bG5ZTUJZV2Z1Q00wSm5KU0FuY2hHYXdPaUZzc2lHbzE0ZFd3UjU0OWNjeHI2?=
 =?utf-8?B?WFZuRlZCUzdiM3VjNTI1MGZueGloZXZtSm5mQ0tBenloNXZvVUVvSlNwMjVW?=
 =?utf-8?B?bjQ1cllOVnMvcDkySm5ITmVJV2xvNWY3ck5FdXVFcG40U1B2MDhQYmhrRlFt?=
 =?utf-8?B?UmJ1cEdrYkZ1bjBCbjgvdEFBS3FSVEpLbllUSkJDM2c3SHZZdmk0cXpGZFF5?=
 =?utf-8?B?MjdJMkhkakx4OEdzM2NSS1JHYUNqcEFSS2EzdFdnVmJPRTdoQ0VVbDJwUUZ3?=
 =?utf-8?B?bGxod2NkMDVVZitra29iMGhpaTY5YXIxUDBXZFBKdXFkQnp3S1V2WHhaS09V?=
 =?utf-8?B?Q1hKMkZ0TWpSVnBKemVGaHdmTGl1VzkzeE91N2doTVlIRzAzaVZ5SkpUcVlB?=
 =?utf-8?B?WVU1dXExT3p6WjhsMFpnd3hYVnVKUU5Bbk9iSHNGbEtvWTZXdi9zM055V3A4?=
 =?utf-8?B?ZXQ1Znh0VEpuMWo2NVVTTTNWcWxqMU92ZkZHOUJ4OWM5N0hIUU9vc3Z5aE1j?=
 =?utf-8?B?bEZIUEdKcWtCVE1hYk9JZFBRL2NpREk4T0lYcmIvOXJDTWJwT1Z5aCsyZnhN?=
 =?utf-8?B?UHZQYVlnQWF0cE5OdVpRRE5iazIza0kxMUpObjJscWt6SG1XWHRoWEMyQUc1?=
 =?utf-8?B?SDBhQk9mSithOTA2UlQvcHZJR2lXTC9rUC9CVGdhVFh6S2Q2S3V3OUtmZFhy?=
 =?utf-8?B?NVJXSTVpd0dCWVoxdjd4WnU0QUpjQktwcjN2ckhkdkNnakViRkxIL1h6YnhG?=
 =?utf-8?B?dC85OU1KYWR0NzZuL0RQNnp3QzN5Y05BbEUxYkpYUFh4K1NnMzRhWGR5c3VY?=
 =?utf-8?B?dXB5MW5GWEcxTHlFZHlzRXBpUXdLOVhkVll3ZGN0L1VVcUVaaDVXMGhBNmk2?=
 =?utf-8?B?bDJLbUUyK1dwc3BVRS83MmM0ZjJJSUREbWM1QnpaNjViQ2FBeFVhejhyNTdO?=
 =?utf-8?B?YUFvc3JTTWNLbWZpTy9JKzFJSWFUYm83d2pLcW1mYzlYREgrQXJDUFdQd0w2?=
 =?utf-8?B?UjRHdEQwNWlCZmJxWUpTZU5BYndORnBPYmhFMlhmZFI3VWU2RFc5Z1hkMkJU?=
 =?utf-8?B?ZnBEc0Z6VUU3dXpndWEyWnZXekVoSVJua2tGUjhFNWJlKzFISUczNkh4S3lQ?=
 =?utf-8?B?Z3RQN0V6TE1lSWNMOXhNWitlb1BYTDNYUTBkMzl2dzhaYjNFdHVBMnp5OUVR?=
 =?utf-8?B?M1J5bGQ1RGg5bDlOWkJxbmIzRDIvcGkvM3Q5MEIrNEw1aDh6eFVXWXBYMGlF?=
 =?utf-8?B?ek1qMnZITGV4Nlh5ZGZmMTd1SStMaG50all5UzgvYkNtbFhIbTFRUzRZb1Bi?=
 =?utf-8?B?NVlIQXByVXNxSEhPdktlRzdlcEdybGZhVEs3bitreW1CeUpGMTdpbEtMMTUy?=
 =?utf-8?B?bG41N1NpR2h2M1o0UC8wVEhTS0FWOFFGUVNxZEVieWErbWl4clo5K0RtV1B0?=
 =?utf-8?B?VWhnT0oxc05ORFVOSkVEK0Fadk50cHZ2UTFpZ0E0QnoyYzBQeXFJaGczeEsy?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6383B8C738E2584F8747001C67AB35B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b32e9e-1499-40f6-e4b4-08dd0443e391
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2024 00:32:58.3281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAgtNoWj1RvIAX3AHWx7uWxtTHnBiZdC4a+lPcfFhKANTXabJYAN10hUV8EWNxrlOLl4EzqUzKI3+BCIt46EQVWKJbftBc+lsazSw9j2jLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7841
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTExLTE0IGF0IDEzOjIxICsxMzAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gT24gMTQvMTEvMjAyNCAxMTowMCBhbSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4g
T24gV2VkLCAyMDI0LTExLTEzIGF0IDEzOjUwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiA+IE9uIDExLzEzLzI0IDEzOjQ0LCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiA+ID4g
TW92aW5nIHRoZW0gdG8gYXJjaC94ODYgbWVhbnMgd2UgbmVlZCB0byB0cmFuc2xhdGUgc29tZSB0
aGluZ3MgYmV0d2VlbiBLVk0ncw0KPiA+ID4gPiBwYXJsYW5jZSBhbmQgdGhlIHJlc3Qgb2YgdGhl
IGtlcm5lbHMuIFRoaXMgaXMgZXh0cmEgd3JhcHBpbmcuIEFub3RoZXIgZXhhbXBsZQ0KPiA+ID4g
PiB0aGF0IHdhcyB1c2VkIGluIHRoZSBvbGQgU0VBTUNBTEwgd3JhcHBlcnMgd2FzIGdwYV90LCB3
aGljaCBLVk0gdXNlcyB0byByZWZlcnMNCj4gPiA+ID4gdG8gYSBndWVzdCBwaHlzaWNhbCBhZGRy
ZXNzLiB2b2lkICogdG8gdGhlIGhvc3QgZGlyZWN0IG1hcCBkb2Vzbid0IGZpdCwgc28gd2UNCj4g
PiA+ID4gYXJlIGJhY2sgdG8gdTY0IG9yIGEgbmV3IGdwYSBzdHJ1Y3QgKGxpa2UgaW4gdGhlIG90
aGVyIHRocmVhZCkgdG8gc3BlYWsgdG8gdGhlDQo+ID4gPiA+IGFyY2gveDg2IGxheWVycy4NCj4g
PiA+IA0KPiA+ID4gSSBoYXZlIHplcm8gaXNzdWVzIHdpdGggbm9uLWNvcmUgeDg2IGNvZGUgZG9p
bmcgYSAjaW5jbHVkZQ0KPiA+ID4gPGxpbnV4L2t2bV90eXBlcy5oPi7CoCBXaHkgbm90IGp1c3Qg
dXNlIHRoZSBLVk0gdHlwZXM/DQo+ID4gDQo+ID4gWW91IGtub3cuLi5JIGFzc3VtZWQgaXQgd291
bGRuJ3Qgd29yayBiZWNhdXNlIG9mIHNvbWUgaW50ZXJuYWwgaGVhZGVycy4gQnV0IHllYS4NCj4g
PiBOZXZlcm1pbmQsIHdlIGNhbiBqdXN0IGRvIHRoYXQuIFByb2JhYmx5IGJlY2F1c2UgdGhlIG9s
ZCBjb2RlIGFsc28gcmVmZXJyZWQgdG8NCj4gPiBzdHJ1Y3Qga3ZtX3RkeCwgaXQganVzdCBnb3Qg
ZnVsbHkgc2VwYXJhdGVkLiBLYWkgZGlkIHlvdSBhdHRlbXB0IHRoaXMgcGF0aCBhdA0KPiA+IGFs
bD8NCj4gDQo+ICdzdHJ1Y3Qga3ZtX3RkeCcgaXMgYSBLVk0gaW50ZXJuYWwgc3RydWN0dXJlIHNv
IHdlIGNhbm5vdCB1c2UgdGhhdCBpbiANCj4gU0VBTUNBTEwgd3JhcHBlcnMgaW4gdGhlIHg4NiBj
b3JlLg0KPiANClllYSwgbWFrZXMgc2Vuc2UuDQoNCj4gwqAgSWYgeW91IGFyZSB0YWxraW5nIGFi
b3V0IGp1c3QgdXNlIA0KPiBLVk0gdHlwZXMgbGlrZSAnZ2ZuX3QvaHBhX3QnIGV0YyAoYnkgaW5j
bHVkaW5nIDxsaW51eC9rdm1fdHlwZXMuaD4pIA0KPiBwZXJoYXBzIHRoaXMgaXMgZmluZS4NCj4g
DQo+IEJ1dCBJIGRpZG4ndCB0cnkgdG8gZG8gaW4gdGhpcyB3YXkuwqAgV2UgY2FuIHRyeSBpZiB0
aGF0J3MgYmV0dGVyLCBidXQgSSANCj4gc3VwcG9zZSB3ZSBzaG91bGQgZ2V0IFNlYW4vUGFvbG8n
cyBmZWVkYmFjayBoZXJlPw0KDQpUaGVyZSBhcmUgY2VydGFpbmx5IGEgbG90IG9mIHN0eWxlIGNv
bnNpZGVyYXRpb25zIGhlcmUuIEknbSB0aGlua2luZyB0byBwb3N0DQpsaWtlIGFuIFJGQy4gTGlr
ZSBhIGZvcmsgdG8gbG9vayBhdCBEYXZlJ3Mgc3VnZ2VzdGlvbnMuDQo=

