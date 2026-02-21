Return-Path: <kvm+bounces-71436-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AA/0C6D3mGlyOgMAu9opvQ
	(envelope-from <kvm+bounces-71436-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:09:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA8816B80F
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58BA0301A141
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF3C8834;
	Sat, 21 Feb 2026 00:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G9UQ7UTy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7043FEF;
	Sat, 21 Feb 2026 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771632539; cv=fail; b=U2NOZxBlkEavzL/FaMfZPE3Q/I1nBxOiSOcg9+05UbL0VUNyPwQQOTWsyU2OOz4CEAdq+zDz/UssvXDFptJPQObXfiTbkr6GceWwHCr0AHN9zZOfC+0beype1FuftsKHCFzDsmMbroaBAavYg324NXmvO3I9dgBtUnd6A7fkj+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771632539; c=relaxed/simple;
	bh=Ttw8t0S+UsyMgKBEI2mxwzA+OlT7UiR7yrdDEhcLM9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YfzCaRB2x7meeP9yCVCjq7oYs3BWNyNNU+P22MY9blVtBquLBVvOcQCkf8Iw93LclUeAerdbUHQXPts7u5FItQPRLNR/b1SBYPIBFMDNxxxauAg8R8Kf8O7K/gkphwdjLi8F4heoKDUjnloPM+JFxvZMQ3rvqj5PY/r692pRtns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G9UQ7UTy; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771632537; x=1803168537;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ttw8t0S+UsyMgKBEI2mxwzA+OlT7UiR7yrdDEhcLM9c=;
  b=G9UQ7UTybuOQMINHVejbc1W5qrdqvvdwxuH2SRI+VYoj4S4GpbI6ler5
   u8CsItb74LuMb0HhV9ba7Ehd/5N4iLkWyCdY8i0a0qL1ve/wOp7OJ4Fe/
   QNEE5bN/MF/XyKULbhyEbuaNS6oW9nhQEMbE89XElZ6eWvyis7jAXfVA5
   kSgllqs8N25ZSX4ETqSmJpzxMLvHy1Ul7Y/HdEf5ZbyojzxWna/9ofT3C
   YxTcr4u4kbjynD+3GiwJi36FBDXBhrl2RZ6wHSHjtAmV3HGzi7rHu6TDC
   0HUB8cSvLQ/COS6sJUk2Y4EWQk0bwORl5jadYcY9jSciCRNCE+Bw99BNT
   Q==;
X-CSE-ConnectionGUID: 3eyONrYeTRK6YtKdzCzQyQ==
X-CSE-MsgGUID: v0Y4wEOhTtKq6djHlvjAfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11707"; a="83353105"
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="83353105"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 16:08:56 -0800
X-CSE-ConnectionGUID: HLLDqoqMSj6rQ4xEKwYpJg==
X-CSE-MsgGUID: QbYg/QNCRi6AkIn34iPsgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="214836003"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 16:08:56 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 16:08:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 20 Feb 2026 16:08:55 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.59) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 16:08:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tlPtSmhUTZXjaj3YfPcr5igt4t6BltesxWij7kGhl4ojteZUw32rNLt6VU6WyCfWb+xeZPUslba4I+yl0niVPuNgZx7D2vvwUs/6VRzB4rDh+SQbh5aGuwP0alOztVXyE4JlINbadLw+XrS+0XRsKXZ/IjC8af/1A5OGSaT7Umwqc9r/ZLUjZUCLfCyxUfpxA/pNaGgEus0MRJ0kfLPYzO65Dqf7+viGK/IZ9Z2xnZqk3leoSKYxmPWwLXRsyAun/ny1a2srUcj+d5LdHZDdLWUUjCCNmzJr43EApIw5EvcCn9t+2IOJdK8vo1qygxWJBrP1h6B+b4LyZ/muTtVLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ttw8t0S+UsyMgKBEI2mxwzA+OlT7UiR7yrdDEhcLM9c=;
 b=og1cmzQG6C2yDjWoiGLmSIpzfYTcA+U2fiJcRBhJNomNDaWefgskzkysgzdvqlyRp24Kgik8EDMZm5e7vQezGnMZuSkrEaXPIfJ7dSVV9nb+r+r8lsi4unF4qvCSToYQxEge+5o/ceUOxMlF9PekeN1r0G1rjX/OSomB2bM1lN0THZtHt4/0EDMAB2XCmV9EnpUbDLEGK6MTcaSUV0cgTwNUaTmozYRr20eCH/SK/1sWceqk+BhBTNu8FzG8aleV3aECuj8LwLrfsDI+LybldQD25cWM2wzWn76J0D2Dn+7lioO+6KEH1zQsSJe/k31Rtc1OhNxzplcjNFjD7LHavw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Sat, 21 Feb
 2026 00:08:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Sat, 21 Feb 2026
 00:08:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Index: AQHcoTXoP5tM7QU8XUq1kA8eNcmjl7WMShkA
Date: Sat, 21 Feb 2026 00:08:53 +0000
Message-ID: <7986057373abcb20585c916804422a13f51d5e55.camel@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
In-Reply-To: <20260219002241.2908563-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4820:EE_
x-ms-office365-filtering-correlation-id: 8d66a7cb-b197-4c0b-0274-08de70dd65d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NW5zdm1pcGxjVDJZZms5VnFtU3AyTXpsYzNxdmtJcjRHYnhMWWJkYUd1NVJX?=
 =?utf-8?B?VXI1di9ZM3RlOXFldW16UnVwalJaVS9TYjZQeHMxOS92YVdKSGx6NjF5TEcv?=
 =?utf-8?B?TTlncjJhT2RiSXZJWnRjNVprVTc4OWpBYmd0MXFyZExxTkZRK2U2WkNKTmhM?=
 =?utf-8?B?TGJLTU56WHFHdG9ZbnJpVHZFbjV0cHlNNXVURGt5akRhVjhkNU1aRmVCVDNQ?=
 =?utf-8?B?VHhRSlJPaUpDMXM0TVJ4bmZGT0JlZi9jYUVoV1pSck1EMlNnWk5SZ0tvclAx?=
 =?utf-8?B?Q0N6R2VCdGUyTlNiU0svam1ZNERWMVpBb01BTWpUS2FqSUdmd2F6dDAxdTZx?=
 =?utf-8?B?T1BnYjRRYkZacVNxcDUwT0xDSVFRZndUUGp6MWltUVVOSkNLMGhtVWRVbzR3?=
 =?utf-8?B?NUJUTXNqYTB4dlY5N0dLVkRYZC80cjBsSjUzTkR0aFA0VXQvd2ljeWtRb0Nn?=
 =?utf-8?B?ZXZiVHQyTTVGdDB5T3JFUWQ4TXR0S1JjdUJVa01QZldBWmljYkFIdzlnQUdt?=
 =?utf-8?B?bGl0WTNxUEF4UXJOQ0h1TkZBZ3piTllLYmh0M3M3Z2VGRVg0M3l0WUwyTzJi?=
 =?utf-8?B?RUtscUE0VU1nclM4anRuTFJNTTR4RWY1R3RnV3lBbU9tV0c2eHF5Zlk2aHlZ?=
 =?utf-8?B?MkJJa2F6djA3d0RHNUFzQTVwZ1dBb01UOTNlYVZHQWc3citXeVBMdVA2Qk85?=
 =?utf-8?B?NmhQak5zYWMxUFovYmFKeVNXbHd0WTE0WW9xRjFjUWkzMFl4RjFub2xEVWZk?=
 =?utf-8?B?b2V6cEZwdExUL3lYaW9LSG8vY2NUYnphUXJxYnQxamlRS1dPN2ZESGtITUVK?=
 =?utf-8?B?NXB3M2NCdktnMFhLSlpkSmtGUnRDV1BIck0wZnFZUHNOTFlqLzhkYUJXaW0z?=
 =?utf-8?B?ODZCMDU4ZWJPREozWkZJblVUQU9XQ3FiVHdMb2xTQ3BkbEk1TEl5S0FlZkpK?=
 =?utf-8?B?V1FNcjBrd2lCVXo4K3hjTzhOdmlRZGw2Y0JtMHlEWGo0cXF2M1RzOHRaUGJE?=
 =?utf-8?B?eXRVbUtzQ2lmdVE5aTdpR3oyL1oxRTdQZnBUR1hyRThMRTdIY2FKNEdyc2NJ?=
 =?utf-8?B?R1hIT3NqYmZyYXpLVC8vdi9iL01wMDRPdlpHbVlUdmRjYTV5clBUMTJuT1d6?=
 =?utf-8?B?NGx4Zk8xTFNPSjVjTkhuY3kybXdqTCtqOVdnTFpMNjdNL3I4YVZRSUxDdFZF?=
 =?utf-8?B?NWpjZnVGQ1FZaHdBYWNiOEtHUzZ5Q1VOUmRVVVpMSEphZmhsTTd0YlZWeDFS?=
 =?utf-8?B?clFGMWxaWkdVUUZsZ0dqb1JnRnd3dFhRbi9xR0JDZmRjR3hiM0crdEppR3Zu?=
 =?utf-8?B?cWhXODUvUEQxa003c2dESWtNVUVjQ3dqNldoZFNzcEo0VlVadUEwbGVoMkpJ?=
 =?utf-8?B?SUFIdktUa25xS2tNSkNwSjFOY25PRngySXJVUW5HekR5QkNXQ05jbTlUVGQ0?=
 =?utf-8?B?TDdJSzBwUERQRG4zNGd2R2JYOThNQTcxTkNVWWFqUUliT2tEU3RVWnk4bmda?=
 =?utf-8?B?aTNTMGlVSXY0bFBTQ2dJTkdKOFZZQkVydHlZTzJyUFBCTWJJL3JWUzNReC9p?=
 =?utf-8?B?WWR5OWovU0tQS1cvUHJRSEJsSksvYWdyMDBteHhKdjVCcjU4QVRFUWNkclFu?=
 =?utf-8?B?dC9FYlN0aHZaZTBjckNUbnJOTmhiMVhTVjZmMHJQaTJ0aFBJSWVKVmdHcVhI?=
 =?utf-8?B?NWlXS0JWOXRRQzhVV1k5QzlwL2ExTjdmczJNY2txSWljRUtheVVZQjlodGFE?=
 =?utf-8?B?elQ1ZkRFUWRmbStYVFcvZVZQZlhyNnE4UktSM1JMVDVOamhBL0dzOFZDbDlJ?=
 =?utf-8?B?UDVvbXMxYXMvOTZnM0dRaTJPVmF5SVJQay80cnk1T21laU9PeXl5a2xUWldW?=
 =?utf-8?B?TDZKR3JSb3BhRmZkcnk4K2llTXc1L3dQNzdkYUpkZ1c3SDhZLzJjNk1Gd3c3?=
 =?utf-8?B?Q2lqWGZmcmc2RGtLQmVyRnhUQlVYdmFPOGE4Z0JQRUE1ZUtCV2g2MXY4QUlF?=
 =?utf-8?B?aW9kdDMvUWdndGx1STB1NUZHeVZ1Sm91dHNZVHFpNlRMTnJSWVJMbFZJTTRZ?=
 =?utf-8?B?emw4eVJrd2paaVJWTkt4NnVKWnRmQnllWTVOWU9BZnJWUldVWGw2Um9hRmNq?=
 =?utf-8?B?M0paTThLMWErRk9mMERETlNXK0FCUU51YldiNDRJZkN1UVU3aDF4K3VzbEFx?=
 =?utf-8?Q?/vKZzidBZ4D+ZlBbr+xdNYY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnFqVmpHOE50NUhOYUtzakJEWURjTU1ORi9oRmlmWUlWQllJQ1lEcFJGcy9v?=
 =?utf-8?B?UldYSkQzWVNDMnBrM3pWbDlyU1BwdE9Ba1BaZ1NLWHMxQ2JPUk1QUWxqUlBz?=
 =?utf-8?B?Q2doZVdmVU9FdzA1S0pBd3Jja2lNMStOMXhLdWRBTGR2MkVjVi8vRllzdmNt?=
 =?utf-8?B?ZkJyYU8vSUdyS25WRW1KWi9lK3ZVMmtyd2xBaHkxRWFqb01TL2xHbEY1eXBE?=
 =?utf-8?B?VFhkai9kVWF2QjFma2tjUkZTb0dtU1FPNFRLT1hTZEtXeWRORDYyTURUYy9D?=
 =?utf-8?B?LzFnTEVHRzNKdFdaaXRSSm1wbVU0SndSZzkvczhRZmZzN2Y4RERYcDZ2U1J0?=
 =?utf-8?B?cmp2eGY3ZnVVd0tOcXIvN3ZJSGVjWjkvU2JHRVZmZU9QNjhHRUIwY0pTb2hI?=
 =?utf-8?B?djE3dS9LT2xLc1ZpOEdCdU01VTl1c2JyNmNydU02cFFmK3RYVzFjT0gxV3Zt?=
 =?utf-8?B?aGlSM25hS0U1Q0QxZUNXTGtTSUp2ZE1jajJ5R3ZYZ1k2UXgwcmF3OW9paWVQ?=
 =?utf-8?B?Q3NiQUJCaDl4VG9zN1hObmVMcGtINnoxVE9PZ25WbXcwR3NkRFEyRzJEMVN1?=
 =?utf-8?B?WUNJRm4rM3hWNTQvd1AzMjMvZ0NCR3JJeHVEQ0Y1eDY3cmFIMHNvWUhFT3VW?=
 =?utf-8?B?YlQxamNHUU1sR2YyZ1JWQ2xxcFYrVjFZeEM5ODFLYTBUQUxqaWZ0a3gvNXFS?=
 =?utf-8?B?RitxL0tPN2owWVRISy93dVBucFJiaU1CQmh6Zi9LR2F5VlN1dVNhUjNML3RF?=
 =?utf-8?B?R21XQ1FsTXhhaWVLVk5kQnRBaWlsTmp4dlZNWWNTMXFnYTExRTE3SEwvamdr?=
 =?utf-8?B?MW5qNllWRk0zWXJaK1U3ekdwSTB2eWNmSjl1VmdKb3lGZTNsUE90MmlQZEgz?=
 =?utf-8?B?NjArTjlmZzFnL05QdEVDTjZrUWRMeERiMDZYV0l1OUpIc0QyOGE5b3FTSnRi?=
 =?utf-8?B?TkZ1cklVV1M3OW1QeTEvZlFrMktSNmI4WEZHbW1tY1R6T2RIdEhKLzhPZjFj?=
 =?utf-8?B?bmdJdk82NEVETmt0Yy9PeHQ1N044WWZHaGJ1bEpEbDdRWWs3clRKREk1VmNW?=
 =?utf-8?B?dHErQjV6cE1saUxpanhOMERVc29ER2lnOXZQWGdGMlBjM2dwOER0Q3QzaS9X?=
 =?utf-8?B?bHdpNWFZWjB3Skx6TVZzcmxCOEEzb20zdXhTZ3dmYW9NMHZVVDJ3eDNvNUUz?=
 =?utf-8?B?dHRyRStXS0FSQWtETUhLd21hUThZbFd4R29YeklYZ0R5ejlSbFFpNzE4N0JX?=
 =?utf-8?B?Y2RybTFiV1U3d2sxYmY3RUZ1ZkhETHVEMGYybXdWYjNxUk5yenhnVCtSMEw2?=
 =?utf-8?B?ektRK1c1K09IOWhTQm4wOEgrMHZXRGdaV3JreHhJdHRFMWxNSGE3ZWc0ZFBV?=
 =?utf-8?B?S1VXQ0hXY2I3MENydkZHSG9HTmV3NnJvTi9yYWxCbE5HcUFHMTV2YlNOL3Vv?=
 =?utf-8?B?d3lBTXpuNnExeHQ4bUtTa2hKbmxnN0sxUUk5cGluWkdmOTFQMmVhUG9POXlU?=
 =?utf-8?B?RmVRcm5RWkNGcEVsRWRXQ3RWVS9pMThmYm5iQTYvWjZmOU1qT3I2eVlJRjMy?=
 =?utf-8?B?dDBDZTN2NXNjbjJ3V1M3U3pmRzhjMGtzSklyWE9RTWFkb2k5RVY3cHlXcW82?=
 =?utf-8?B?b3BIbEdsVFo0ZzY5VlBtY1NJS3N4UzR1Z0N5TkllUFoxWGVueWNodGQ2b2Rs?=
 =?utf-8?B?cWoxelNyL0hYeThXR3Q3U24vcFlZVXoyMWxNUW5WN0xTK2lOU1F6Z3ZrUHl5?=
 =?utf-8?B?OGE2Q3o3TEVCTTBQR1FYN3BvdTFWNEVTTUxkaVBkLzZ1ZXJHQm84aFpyYXNu?=
 =?utf-8?B?YTNoOFBmcHRwY2ZBVmNiNWZ0RCtMSDhBZVJZcHJQZTJIeEZYZnR5M3dOTzdj?=
 =?utf-8?B?RjExanZBSmZnQnZVWEsrdVIvUEYrQnBwQW9XbVhBQko3b2RaanZrM20wZXdQ?=
 =?utf-8?B?a2xuSU1xdzNtVk1WRDRlUDFkWFFBOXFJQms4c0VWMk5oOUN4bGZPSGsrOUw3?=
 =?utf-8?B?U25DOUt6VTRqbWU2NnFIblJwMXVFV3hhcXpPNEUxS05DMGtCRUF6V243ZDRO?=
 =?utf-8?B?eHNxTTBlS2k4aGRsZ25PWjR5YVdJc2FIUTF5Wk9sSlc0TFErbmZyWnhQT01j?=
 =?utf-8?B?QjZsdTN4ZDB1Tmc2YjNxZExWUVppZkVWN0orWUhHMnA3Z1pXNGo5aHZpcUdl?=
 =?utf-8?B?YXlkNFFPaWk0UW9BNW9iSSs2Y0pWd1lHSlg3RitXWmZnTGQvZVpnZTF4K01k?=
 =?utf-8?B?Zm9vTk81K3BrK2dDUkFObi9YS1RsaEx4UEVIVXFDWk5aQzRlb1RCdEY1b1dH?=
 =?utf-8?B?TnJuRHQwZlJ2dkFjU3RmME8zZkJSb3Y4cGNXSEZkS0lNeGM5NXJVb3ZCMlpj?=
 =?utf-8?Q?EwpT0v7kITOhEqSk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3722BF2FF8BD3148B5419B350420A856@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d66a7cb-b197-4c0b-0274-08de70dd65d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2026 00:08:53.1540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddoBpoFfY2wvEn23XwKwAVSN8C7JI391GI9/XTY2jgieuPrDubQTunDZUgXIN0s8fU39GRryOv3kfNUmuTiyb68OKlzLsQUyG9RmC+9uXXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4820
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71436-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 9EA8816B80F
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAyLTE4IGF0IDE2OjIyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiArc3RhdGljIHZvaWQgcmVzZXRfdGRwX3VubWFwcGFibGVfbWFzayhzdHJ1Y3Qga3Zt
X21tdSAqbW11KQ0KPiArew0KPiArCWludCBtYXhfYWRkcl9iaXQ7DQo+ICsNCj4gKwlzd2l0Y2gg
KG1tdS0+cm9vdF9yb2xlLmxldmVsKSB7DQo+ICsJY2FzZSBQVDY0X1JPT1RfNUxFVkVMOg0KPiAr
CQltYXhfYWRkcl9iaXQgPSA1MjsNCj4gKwkJYnJlYWs7DQo+ICsJY2FzZSBQVDY0X1JPT1RfNExF
VkVMOg0KPiArCQltYXhfYWRkcl9iaXQgPSA0ODsNCj4gKwkJYnJlYWs7DQo+ICsJY2FzZSBQVDMy
RV9ST09UX0xFVkVMOg0KPiArCQltYXhfYWRkcl9iaXQgPSAzMjsNCj4gKwkJYnJlYWs7DQo+ICsJ
ZGVmYXVsdDoNCj4gKwkJV0FSTl9PTkNFKDEsICJVbmhhbmRsZWQgcm9vdCBsZXZlbCAldVxuIiwg
bW11LT5yb290X3JvbGUubGV2ZWwpOw0KPiArCQltbXUtPnVubWFwcGFibGVfbWFzayA9IDA7DQoN
CldvdWxkIGl0IGJlIGJldHRlciB0byBzZXQgbWF4X2FkZHJfYml0IHRvIDAgYW5kIGxldCByc3Zk
X2JpdHMoKSBzZXQgaXQgYmVsb3c/DQpUaGVuIHRoZSB1bmtub3duIGNhc2UgaXMgc2FmZXIgYWJv
dXQgcmVqZWN0aW5nIHRoaW5ncy4NCg0KPiArCQlyZXR1cm47DQo+ICsJfQ0KPiArDQo+ICsJbW11
LT51bm1hcHBhYmxlX21hc2sgPSByc3ZkX2JpdHMobWF4X2FkZHJfYml0LCA2Myk7DQo+ICt9DQo+
ICsNCg0KR29zaCwgdGhpcyBmb3JjZWQgbWUgdG8gZXhwYW5kIG15IHVuZGVyc3RhbmRpbmcgb2Yg
aG93IHRoZSBndWVzdCBhbmQgaG9zdCBwYWdlDQpsZXZlbHMgZ2V0IGdsdWVkIHRvZ2V0aGVyLiBI
b3BlZnVsbHkgdGhpcyBpcyBub3QgdG9vIGZhciBvZmYuLi4NCg0KSW4gdGhlIHBhdGNoIHRoaXMg
ZnVuY3Rpb24gaXMgcGFzc2VkIGJvdGggZ3Vlc3RfbW11IGFuZCByb290X21tdS4gU28gc29tZXRp
bWVzDQppdCdzIGdvaW5nIHRvIGJlIEwxIEdQQSBhZGRyZXNzLCBhbmQgc29tZXRpbWVzIChmb3Ig
QU1EIG5lc3RlZD8pIGl0J3MgZ29pbmcgdG8NCmJlIGFuIEwyIEdWQS4gRm9yIHRoZSBHVkEgY2Fz
ZSBJIGRvbid0IHNlZSBob3cgUFQzMl9ST09UX0xFVkVMIGNhbiBiZSBvbWl0dGVkLg0KSXQgd291
bGQgaGl0IHRoZSB3YXJuaW5nPw0KDQpCdXQgYWxzbyB0aGUgJzUnIGNhc2UgaXMgd2VpcmQgYmVj
YXVzZSBhcyBhIEdWQSB0aGUgbWF4IGFkZHJlc3NlIGJpdHMgc2hvdWxkIGJlDQo1NyBhbmQgYSBH
UEEgaXMgc2hvdWxkIGJlIDU0LiBBbmQgdGhhdCB0aGUgVERQIHNpZGUgdXNlcyA0IGFuZCA1IHNw
ZWNpZmljYWxseSwNCnNvIHRoZSBQVDY0XyBqdXN0IGhhcHBlbnMgdG8gbWF0Y2guDQoNClNvIEkn
ZCB0aGluayB0aGlzIG5lZWRzIGEgdmVyc2lvbiBmb3IgR1ZBIGFuZCBvbmUgZm9yIEdQQS4NCg==

