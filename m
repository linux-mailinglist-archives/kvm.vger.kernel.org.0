Return-Path: <kvm+bounces-63435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 84AD4C66A87
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C564B4E60E2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66A527B336;
	Tue, 18 Nov 2025 00:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YmOfZyb8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446E026ED37;
	Tue, 18 Nov 2025 00:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425615; cv=fail; b=SVqf5KkBMwCQ+yURNLcewhK0naiYmXwhi64XER3qfknl4FuhiN+qUSQbipkYRxxKpWV3d0V7MOrESOJFbKO52Iyb+GMzpJ6ggFflQXhLCnLvZCKVtUvb1005VFLKpxJy8Nbb90vp2O/Sgx9L5Z3MbYCbGw7r1zTbc4sVhZeL4D4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425615; c=relaxed/simple;
	bh=Og2RT/e1/vDMAONkhb6dtCUoxT8PzcPAvHU8IfPyl7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VRh4c7yeCwK9ShwNoVGdLzrD5pcSE1zZy5u9KwqNpJG94NpxPJDqCS7nR3QC8DWve5kaJXeN2Exb5tHxVRCgg2+usRJsYq9a6tkHXyA8BTKKS2uX112xOg0K+OPEaoDEnpyZO+vqnfFhI3HzYqMcIQk5ttHaj+cFQ3jZ23w+pAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YmOfZyb8; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763425614; x=1794961614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Og2RT/e1/vDMAONkhb6dtCUoxT8PzcPAvHU8IfPyl7o=;
  b=YmOfZyb8k3oBWpEkdne63oBxktRAJlGpMliJbyhHELLPpALJRQaxOjTQ
   FQ+KglTgQhVpgNROoVIwL8lbkabcBPg1sf1a+rpvGck07etoxTdTSOycT
   yHdkTe0Hp7ikFxYIR8Dhv7Hga0dV3KZgcWtwMdPi73u29MSEvxj7HMBSe
   J8i3DCYZf36kI8DPxuSPGe5Aqo+V8rELxvZ8DlTckbrku6Hv4bb9ViN7Z
   FrjwH3BFNPA5XuKebbe1PFdiijFr6iSkf7VzWEjecap9AA4B4TAKWM8fN
   DfErgrvPbxWyZJIp9Pkk//674+f++J5RQD0R5dU9Ihr5ROzAR6CLAR0XC
   Q==;
X-CSE-ConnectionGUID: vG43KSQrQ2SEGAjdaAVJbA==
X-CSE-MsgGUID: CNVHgZXCS+qRzC/78b6baA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69288874"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="69288874"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:26:46 -0800
X-CSE-ConnectionGUID: kqvK77/ASJGNJwjTVY5Jxw==
X-CSE-MsgGUID: dGQgHs6SS4epPTIvHLxotg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190401403"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:26:45 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:26:45 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 16:26:45 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.1) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:26:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XwyUe1nhvTO+j+JKtR51Tn2rT6doHMShRWsSA8S7plHYtnvrwPvi8HUR6ZAfGKXuUwTHdiLR1kelg/kZkarf0C0nUFsleuNT/WlX9tvs04Lw+1zwYcYSLbRDalopRyloz1ydrY82A4CauKjPmOywud+8xDbMyIrPSPxUD9hOBXNSLy9AUBHB9vz1zXScaR2NLfxIEFbHdKQyufaotR2Y+Pn1GLSQufso7d/FUIaUCEechPWiEaW/VNSVXIdx49qiqkv3O6DUmTIY9f9mImVWQWu468G4mWwy5iPdwvxleZYiTCgO/olvEcHhMFBz0wWkpSeFe1pTAjq9IQCOV0TDHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Og2RT/e1/vDMAONkhb6dtCUoxT8PzcPAvHU8IfPyl7o=;
 b=tHL7xp3cmT3ESW4YJ6Q7PGn7N3sCK2VQfPgAW2UX2tGpzNVaGxGHl1tyDgfOCTRPONTe1ekXaEq01kpAfwR06suFU7Fsbo2BflucYQSqdyxMCAoHSlXHDqp1MQKQxSyNdjb1OHOQsX5bGbD65eBjlSErpt/XNPWJ830ufNNzfll+GYrVVkHxCnmYJz6KqEBzucQai0YNmq+KL22CHk5r/E3u31ij+WAEQXP49sWP3nMDSTNQKgWpFfmEb1zicBFFpii3MCwxK3wkHpcJ67CkwpUvU0k6JWK0KDIUOOx6wbMkPJFCxLQiKYr0WC7EWOj+tfWy8KEP9sc/K0eHgL/Epw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PR11MB8672.namprd11.prod.outlook.com (2603:10b6:0:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 00:26:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 00:26:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
Thread-Topic: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Thread-Index: AQHcB4ATc43XQ6PqxUuwXAgCtykiwLTt5HOAgAQcfYCABjQTAA==
Date: Tue, 18 Nov 2025 00:26:42 +0000
Message-ID: <ada5b8af9ba70b7af87820d5e3a551fb6352853d.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094423.4644-1-yan.y.zhao@intel.com>
	 <183d70ae99155de6233fb705befb25c9f628f88f.camel@intel.com>
	 <aRaJE6s8AihGfh8w@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRaJE6s8AihGfh8w@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PR11MB8672:EE_
x-ms-office365-filtering-correlation-id: 52c2dde3-bd6f-4b77-bb97-08de2639260e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OFR3NFJNK0xDVUVkWUsvUnpocjYzQmRyRkV6WnZidzlab3lmR1crZ2sxbUYr?=
 =?utf-8?B?elpZYVFFWGVUcVlwUklydmpTMEMyM1VjSk5OTWlscnlicVNiUEFNWEoxTmdN?=
 =?utf-8?B?Z3ZHZHJxL00yWjdPY0dlb3poY2hnMytwN2pjYWRwYk5wR3BXVmVEU0pHZ2JL?=
 =?utf-8?B?NE92R2VvUEpRcTV6UjlTTnpWRjh1Z1QyeitwTWNneWMvWDB2NVN2c05idWF6?=
 =?utf-8?B?Y2VPT0trZG1JMjdGbUx1WkRHQ2NLTkRaU2JOS0dnZW00dllhUFNtaUh1b0dw?=
 =?utf-8?B?ZmlvaWRPWE5IbE5OOVZzclMvT25pZnlwT1dPUDlPckFkZkFhYmlQY1h0a0NH?=
 =?utf-8?B?Y3Vpd1B1SllGeWpad1VLYXhGd3o5VU9rcFdOTlJNQTVBWENWYWFqVysrc21Q?=
 =?utf-8?B?MXl5QmtPdWZnWnhtRWZZY3BqVlJHaWxsYWp5aDY0RUJoWVI1ZlJzMXlNcTd3?=
 =?utf-8?B?UGFBVTZhNjFtc3JSOFVCc2lPRVFIb1NzMHN1QjFWTzl3OTE2cUVzb2Y2cDhU?=
 =?utf-8?B?ZkNoOUJCR0xjcDdJT3ZiTFJ6T1RjUGNiUTk3bE9NWWRkd3RWS0tkRUxoT29R?=
 =?utf-8?B?SG5JYUt3dnBmRUIwZmFTM3pFVlNZOWprSERPMHN0SnJFc2J2NEcyckhTSE9q?=
 =?utf-8?B?NmU3dVRja2l0MXZ0b04wajNOWjVYWUZYY3gyOUd5WEt3Z1ZsMUhtdGZSUXd1?=
 =?utf-8?B?eFBUUFlHUHB1ZjZabm9odCtaYVRnQmFUQUpXWVZ4R25NbWFscXhOZ3RrTjNS?=
 =?utf-8?B?SnBqeWYrNFBvd045OGlZUmkxdlAzZzFFbElzSmIwVnN5ZmNFMU9ORWhwQkRP?=
 =?utf-8?B?aGI5L3drQXd6a243T3dLQTVyN3VWR2tOYXdWall3OUlIUHhVZFBuR3Ntc0Z5?=
 =?utf-8?B?V1dYWE5NUVllVy8rckdBRnNoYVpGdWZMK0xqV1FnOEtRVFd0UUY4aEdUOVkx?=
 =?utf-8?B?UE5rdDZzMFVQWXp1clhkdWFwbTlSVktRUXRpMkFZVmhBTHZoOXFxVWx1K3pu?=
 =?utf-8?B?aUE3ZE04QWorUllkKzdPMWRmNVNLblV6Z3F6dWlzVjNFTHBSMnhLTSt3L3g5?=
 =?utf-8?B?ZnV3cWJKQzBlWndCemhJYkwrVU9GallseTFOWkorTUY0dVZLTHVySWRXL1hy?=
 =?utf-8?B?WWVWLytrNWNVSE5LdTRkaHpWb0tUaTZHZmFjamlJL2lJSTU3c2Q4enJidXVV?=
 =?utf-8?B?YTVTeDlCM01PU0swYlg5UXJTQllMV2tjZEp0Sk9sejRNNWFKZ3ozZ1pVTHE1?=
 =?utf-8?B?NGpuZHl5Q3ZueWxmVkNpRDlNb1MrdW9uZ1lVdXdyRllEQzFPQ3NXUXlaSXdJ?=
 =?utf-8?B?aHdFbnplWUcrb3NoN1lQVkYvYXdmOXpoS1kwMHZRRDZxaUJEbmVFUEFNaEh2?=
 =?utf-8?B?TXJaQjVweEtNVUVvVTZzZnJ0ZzlYbXorRHVkOHNwUm4wMnpZRjN3MGJvYStK?=
 =?utf-8?B?UnRRUjZWQlhGU2NnWTh4WU9DWjAwNmVUQnBqWkVpTDkwelp5M2hnQXFWMHhB?=
 =?utf-8?B?dW1icnIyOFpDdUhBaWJUTUJTYkdBUFVodDVvMUdEMDZrWmkxS21xdjVweS9t?=
 =?utf-8?B?bnZDcTdpcDQvT3lIMkhra2FIcklIM3I4Sm5oRElXU2Y0ZWtDUVc4endBdXB5?=
 =?utf-8?B?SS95SGR0bmsrc0V6Vi9qU0NiY3pJY1BEWnoxZTFsbW1GLy9mYThpNUFSck1u?=
 =?utf-8?B?K0RZYzRlK1Z2RENpNHpVRXE1V1FhZEpSbjh6dmxRN0RBSWVseWxFMVpoaStj?=
 =?utf-8?B?UlJkUmJCVlhqT3QzOG91T1NYdTlGVHh5M2pENWhVc1E3b1kxMkNRMnBDd3Zn?=
 =?utf-8?B?YklmbFR2aStlVWtUbWpvU2ltbXBNVTVYV2RYREdaRUNJN2dHRVBCYUZ5QmNU?=
 =?utf-8?B?WVErZjY0MTZBVkpuVktoQ1lLYllTTnlOSUNjV05OWFhtOVNwUDdtakZYbExS?=
 =?utf-8?B?M1VlbzdrOTdleHlTMGtSM25CYUZabGtINzJuWnpsRlFTeWRidzdGWG5GSSsv?=
 =?utf-8?B?a0FCMm1Tb1o2WGVEcW5ObGFMb05jYys1cm5SRzNuNGFmWS9tdDdRL0VmU3dW?=
 =?utf-8?Q?a/MDW4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUlrK0paS05xME9YTVNqTE5qZkxET25PMWcxL1FBMXBicnhUQzdUOU8xVFY1?=
 =?utf-8?B?ZlZ6Tkx2L2xLcG9iSWVzcnNlQktCZlN4bUJvNGdMS3lJd3pGOUFucGNTNVYr?=
 =?utf-8?B?WGFrcEpKY3k5RzlHNTFsSDlCa1VPaXd1RjN4VEpXYUp6VnIxZzFrMlJ6ZE81?=
 =?utf-8?B?MEV5S2Zkbnp5MzVQdUdPT29wSkpDTGp4aHhQQzZUZVVPa3ZLT1R5VFhCSkYv?=
 =?utf-8?B?MGNIRExOOW1ibnh6c09GQiswdFJ0L3NTMm5xd0dTTE84WThKU0dYVnkxNitx?=
 =?utf-8?B?VlBMcmNGTVBJdnU4T1FBeml5THp2MlFKNzEyQlltd1JaZXNVNStTdDdQTWk0?=
 =?utf-8?B?UlpML3VDQXJjbUN0UFRrdUs1OUx5VU9BOFVXTUJGSTFnTGF6M0pVMm1OVEdq?=
 =?utf-8?B?M0oxclQvelRKbktoRjBBSitqRnBJVnFGR1NER3lZb1MrRkZsa1RSbk9YOTly?=
 =?utf-8?B?V2ZaTExnNkJJOERGUm0zQ3d6UlkvVTFuV25pWEVvSzBQR2ZhM3pDYVNJamlm?=
 =?utf-8?B?QzFVRWJQbWdvcXlVQzE0eXZ6SkdqZ2pLYWV3eDhvck5yREJqT2FneWpxeTVN?=
 =?utf-8?B?RzNadkwwR3FucmZ3bFJNMzFpWjJRemRCOHFOd282YXI2aUd1aVU5ZlZkZ1Fa?=
 =?utf-8?B?Ty9SQnVLbjJoU1JrMHdUekNtSDM1M3dTTm50NEZsVXlHR3Bqa09xVk9GS3pj?=
 =?utf-8?B?SE9PcERJb0ZEdUY5b0RZd3pUR0xhUTdvVlFsdlhrMEJHOTQ5a0JkVGVtd2tu?=
 =?utf-8?B?QnNGZmkyRjNOODVLcmJ1Wnd3YnJ3b3UvOWQ5bDFCcWhsWGhXOEJ6NGtHZ2N4?=
 =?utf-8?B?OGtCZjNQM3lnditXZnZRRG5HbW4wVURTNk40RG1QbnIwMUpocGJxbWpFRnZ6?=
 =?utf-8?B?dWtYTUtxVmtDYllwbzZNVVZLSVoxRkNvVkF3K0dGcjFKYnpaZG0zOVRodStm?=
 =?utf-8?B?UXVEekRZSU1JQmhIcXo4SUNPQTR6SDZQcldYUnR1RGFhdTA3RHBBb2RPSElK?=
 =?utf-8?B?dDVYMWtETml3N2xsdkt5Y1hpREVtdEFGeStnNXg4Z2wweUx2NXpOdVZGVGlm?=
 =?utf-8?B?dGY2Qm1lcGdvcC9aZHEwNU1QNXVGa2twdmVQeWVMSm52YVp5KytBV09UZzhq?=
 =?utf-8?B?eG9uR0F3YWltZERDeWF0aW1kQTZBalNmMkY1N3paRWt1Q1BxRnI3S3pESUZU?=
 =?utf-8?B?cUl3VnNrc3pZcVN4L05ZdjMrVkp5Qk5wbHduNm9GRitQNVNyY1dIODB5dHNh?=
 =?utf-8?B?eWgwZjhwUkVtU3ROK2pKR2JNUi81NVZSRW5aY0ZYeWluTnAvTHN5bjFNSSt4?=
 =?utf-8?B?ZlN6cE9EZkxkczVRTmxqa3l6bmF1d00zOWZBcjJXeUFZbEFYanlDTVZhck9u?=
 =?utf-8?B?cEZjWUVseEc1VzJOR1BFT25KaVBKck5OV0VFTktjei80R2p5OC9CbFVGVm1Q?=
 =?utf-8?B?WHBFOHBMQW42dTBQREJ4QkhOSlhoNEtMOExwY3dqejlSNExXdUtHbkFBaWEr?=
 =?utf-8?B?Mk5WYnB5UUpUNU9ETzZDc1lSU2MxSDNtVkdBV2dHMWxicFlUNXNZQXJHajdz?=
 =?utf-8?B?ZWFFdUY4MEFueXcyVFgrTkVzelNES3lFcjc2U3JNd0lPWlZKbWVvV2k1eVlI?=
 =?utf-8?B?cXF1RVl4YS9VcjAwdFhtSk5UTytiZ29YM0dwMGJ6ck1KbGlzL01CMkV4VXpM?=
 =?utf-8?B?cDZZTThyNlFlS3o1ei9wbGd0dEdrbnF3VDNJWFpkdWNHSUNLM1JwZkxyTDRw?=
 =?utf-8?B?WFdCQldma3B6UkxpdnhIUjdQNnAvbHdzWHBkUDRURERJWkw2bmF6RGI3V2FI?=
 =?utf-8?B?TCswdDdhM0FoUFJ5VmtUYzBMY3JWMDBOL0FKdUdNMllUZHRGU3dLRUNBeDBI?=
 =?utf-8?B?NEhoSEtEeVVSa2lBdlIvd0VTNGwybFhxQXRoSzhUbGI4N0dHeEJMR3RuMmNi?=
 =?utf-8?B?QU5YenZ1VTVnMnU2Qks2U3pvNEdrRm5hRndYTjVvNi9wMkREQlY2VTNpZjh0?=
 =?utf-8?B?QkEyd2k2MmlTYlNQTE9JeXJ4V0w5NDQxbTMyYjJuQmp5bnR3ekFRYkl1OGRq?=
 =?utf-8?B?VTZEWkg4WHVLakR4TWFyb3lEN1AxSDVGQXFmNnltWlZQNFRYWnVlOFpFOFRr?=
 =?utf-8?Q?L6lrcDuNYpEnHJlxYfTJ/2YbI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63ED94A1520EF342BEE7FB3D06C130E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c2dde3-bd6f-4b77-bb97-08de2639260e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 00:26:42.6099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oNNp23clzVZvax81ew/CfzO8FhfPyyStSiczpyINOfwY9Jh4G2mOc5xJg+sdWNQZTXgVZNSaPB82Q4Zy+U1hpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8672
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTExLTE0IGF0IDA5OjQyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VHVlLCBOb3YgMTEsIDIwMjUgYXQgMDY6NTU6NDVQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjUtMDgtMDcgYXQgMTc6NDQgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gQEAgLTIwNDQsNiArMjA5MSw5IEBAIHN0YXRpYyBpbnQgdGR4X2hhbmRsZV9lcHRfdmlv
bGF0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+IMKgCQkgKi8NCj4gPiA+IMKgCQll
eGl0X3F1YWwgPSBFUFRfVklPTEFUSU9OX0FDQ19XUklURTsNCj4gPiA+IMKgDQo+ID4gPiArCQlp
ZiAodGR4X2NoZWNrX2FjY2VwdF9sZXZlbCh2Y3B1LCBncGFfdG9fZ2ZuKGdwYSkpKQ0KPiA+ID4g
KwkJCXJldHVybiBSRVRfUEZfUkVUUlk7DQo+ID4gPiArDQo+ID4gDQo+ID4gSSBkb24ndCB0aGlu
ayB5b3Ugc2hvdWxkIHJldHVybiBSRVRfUEZfUkVUUlkgaGVyZS4NCj4gPiANCj4gPiBUaGlzIGlz
IHN0aWxsIGF0IHZlcnkgZWFybHkgc3RhZ2Ugb2YgRVBUIHZpb2xhdGlvbi4gIFRoZSBjYWxsZXIg
b2YNCj4gPiB0ZHhfaGFuZGxlX2VwdF92aW9sYXRpb24oKSBpcyBleHBlY3RpbmcgZWl0aGVyIDAs
IDEsIG9yIG5lZ2F0aXZlIGVycm9yIGNvZGUuDQo+IEhtbSwgc3RyaWN0bHkgc3BlYWtpbmcsIHRo
ZSBjYWxsZXIgb2YgdGhlIEVQVCB2aW9sYXRpb24gaGFuZGxlciBpcyBleHBlY3RpbmcNCj4gMCwg
PjAsIG9yIG5lZ2F0aXZlIGVycm9yIGNvZGUuDQo+IA0KPiB2Y3B1X3J1bg0KPiAgIHwtPnIgPSB2
Y3B1X2VudGVyX2d1ZXN0KHZjcHUpOw0KPiAgIHwgICAgICAgIHwtPnIgPSBrdm1feDg2X2NhbGwo
aGFuZGxlX2V4aXQpKHZjcHUsIGV4aXRfZmFzdHBhdGgpOw0KPiAgIHwgICAgICAgIHwgIHJldHVy
biByOw0KPiAgIHwgIGlmIChyIDw9IDApDQo+ICAgfCAgICAgYnJlYWs7DQo+IA0KPiBoYW5kbGVf
ZXB0X3Zpb2xhdGlvbg0KPiAgIHwtPnJldHVybiBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbih2
Y3B1LCBncGEsIGV4aXRfcXVhbGlmaWNhdGlvbik7DQo+IA0KPiB0ZHhfaGFuZGxlX2VwdF92aW9s
YXRpb24NCj4gIHwtPnJldCA9IF9fdm14X2hhbmRsZV9lcHRfdmlvbGF0aW9uKHZjcHUsIGdwYSwg
ZXhpdF9xdWFsKTsgDQo+ICB8ICByZXR1cm4gcmV0Ow0KPiANCj4gVGhlIGN1cnJlbnQgVk1YL1RE
WCdzIEVQVCB2aW9sYXRpb24gaGFuZGxlcnMgcmV0dXJucyBSRVRfUEZfKiB0byB0aGUgY2FsbGVy
DQo+IHNpbmNlIGNvbW1pdCA3YzU0ODAzODYzMDAgKCJLVk06IHg4Ni9tbXU6IFJldHVybiBSRVRf
UEYqIGluc3RlYWQgb2YgMSBpbg0KPiBrdm1fbW11X3BhZ2VfZmF1bHQiKSBmb3IgdGhlIHNha2Ug
b2YgemVyby1zdGVwIG1pdGlnYXRpb24uDQo+IA0KPiBUaGlzIGlzIG5vIHByb2JsZW0sIGJlY2F1
c2UNCj4gDQo+IGVudW0gew0KPiAgICAgICAgIFJFVF9QRl9DT05USU5VRSA9IDAsDQo+ICAgICAg
ICAgUkVUX1BGX1JFVFJZLA0KPiAgICAgICAgIFJFVF9QRl9FTVVMQVRFLA0KPiAgICAgICAgIFJF
VF9QRl9XUklURV9QUk9URUNURUQsDQo+ICAgICAgICAgUkVUX1BGX0lOVkFMSUQsDQo+ICAgICAg
ICAgUkVUX1BGX0ZJWEVELA0KPiAgICAgICAgIFJFVF9QRl9TUFVSSU9VUywNCj4gfTsNCj4gDQo+
IC8qDQo+ICAqIERlZmluZSBSRVRfUEZfQ09OVElOVUUgYXMgMCB0byBhbGxvdyBmb3INCj4gICog
LSBlZmZpY2llbnQgbWFjaGluZSBjb2RlIHdoZW4gY2hlY2tpbmcgZm9yIENPTlRJTlVFLCBlLmcu
DQo+ICAqICAgIlRFU1QgJXJheCwgJXJheCwgSk5aIiwgYXMgYWxsICJzdG9wISIgdmFsdWVzIGFy
ZSBub24temVybywNCj4gICogLSBrdm1fbW11X2RvX3BhZ2VfZmF1bHQoKSB0byByZXR1cm4gb3Ro
ZXIgUkVUX1BGXyogYXMgYSBwb3NpdGl2ZSB2YWx1ZS4NCj4gICovDQo+IHN0YXRpY19hc3NlcnQo
UkVUX1BGX0NPTlRJTlVFID09IDApOw0KDQpBaCwgT0suDQoNCkJ1dCB0aGlzIG1ha2VzIEtWTSBy
ZXRyeSBmYXVsdCwgd2hlbiBrdm1fc3BsaXRfY3Jvc3NfYm91bmRhcnlfbGVhZnMoKSBmYWlscywg
ZHVlDQp0byAtRU5PTUVNLCBwcmVzdW1hYmx5LiAgV2hpbGUgaW4gdGhlIG5vcm1hbCBwYWdlIGZh
dWx0IGhhbmRsZXIgcGF0aCwgLUVOT01FTQ0Kd2lsbCBqdXN0IHJldHVybiB0byB1c2Vyc3BhY2Ug
QUZBSUNULg0KDQpUaGlzIGlzIG5vdCBjb25zaXN0ZW50LCBidXQgSSBndWVzcyBub2JvZHkgY2Fy
ZXMsIG9yIG5vdGljZWQuDQo=

