Return-Path: <kvm+bounces-27692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9197398A9A6
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77ADB284225
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149C4193415;
	Mon, 30 Sep 2024 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GuMt2doP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C72191F74;
	Mon, 30 Sep 2024 16:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713372; cv=fail; b=MXEX4DuUu2U8CS6GMaqSxXxqJ/t+F6mjwbGyAR2ooEbBJAHhZ1N9mhks4sQnt4Qd/87L82Q72SEFSjlj0lfJB3SnZ9Kg5Qz+75MZq7U/m+edfy1w4B/I8jOQU8z7EBVewm7gWP4LZ286KX7V1MszWHOFQXW1blsyj0w3Lb/orPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713372; c=relaxed/simple;
	bh=dU46JZabkNwrKu63Zq8kg9o7g+OJsGYMRpjKZ3KFAQM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h8Rid0oeWx3UgVS32pbPgGai52ZCb9+VQ4LF2UTUWLOT/00r621+Prj3vNuy2WGBpSdUXi4oP/IaKn+M8PJ553z91YSd2/KGPGF2KSqDOmKUY7frjS+0bGRKBnfY2G3kUKrCgl6IZcH9ae2+GTOdRhccgXzHyVDiVAk6p+Y/sMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GuMt2doP; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727713369; x=1759249369;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dU46JZabkNwrKu63Zq8kg9o7g+OJsGYMRpjKZ3KFAQM=;
  b=GuMt2doPzTHNUVz/FEqIfXu+xsC+FkWXFXDgSLPMNNZMng6Zl4tUktUM
   qxLFggSzADjJUq7n+KgVdWXBu0T9MZYKyX598dWPJgZgytkVLPgm5QwBX
   IAJ7mdDSu1g1SReIgrtpwteBmRaQq7v5GenlExZru6VJnX9P/Q6eKZznH
   53VzE6OUPd0wSbNwUc97aWlFnlSfYOOscpU5bv914YF5Vg1WP9iddapoP
   tGU5fEWHEAG3Jv+GK45Gzbiq/JOKIBrKfSxIFTU6aQSka0+U/iI9p1Reu
   UE2HAmM1shi8tIo7s2E/1oK/02oH6EXVpD6wJLv8G0rWG/qwlFAEtAmbl
   Q==;
X-CSE-ConnectionGUID: Dh1JhOt2Ql+2BZEKNlv6Ow==
X-CSE-MsgGUID: cp4WQ0k+QGSUQL4Aao7YMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="26767423"
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="26767423"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 09:22:48 -0700
X-CSE-ConnectionGUID: 23DR03FMREy+9ajoh4quUw==
X-CSE-MsgGUID: izxsjecYR5mI3pVYztfhSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="78196558"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Sep 2024 09:22:48 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 09:22:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 09:22:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 30 Sep 2024 09:22:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 30 Sep 2024 09:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CzBlsUHuI0d57vsTDITSFtD3PQo4MGH4rUHHMuBfZ6bOhefIKnc67J/lDfU5e6kw+ZizgRjX/4pSef3M0cLeGI4qdKbW1QQ79NK4fyJWmIx4tVpsIq0MyRODMr2h+QosbPHU+Cgtc3mc+MV+5kUUp7+LSof0E2GoDXD9Dnl5lDdZd6oaoGCeKe5uq9oUMlC+I8i8a04sUayVbdBpR49plXTfle7xsVLdUipBEx4aUgKlTb48ITn0Arbou+6J/iZYasSa0bJj5jXp8zaDPBvqkhLHqTStU31XzNHx23kCj5enO9bZdKfI4hLuGuNVFgVDIhBADARnUiS+8573TJgQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dU46JZabkNwrKu63Zq8kg9o7g+OJsGYMRpjKZ3KFAQM=;
 b=UG5qh1ZdjHOXF7Z733uerqXkSn/GBisHJDmgNa0wYZVEl+KruNteuZDPnzWmuxjvzblO9X+rleKReOf+hzEJot3Df6KAJjoJtq9QrbVgsI0XLi0D9b6JC5y+Vc2T461hINwo3ZY0LOsnXf4QxJk/CKucYiwFWconcs4ju86ubqLdPFnrDkqshmARyv1FZu3CmThijCiTy8/qgnjjf80xBbrEACkVfHGTSTSjDlyqDOqkthXmHapaMRMqrGcOfadZ3KeadJBvM3pW7AiCSVckq/Zi/uBLUIJvxHquViXKmT9x6DBUzUpRzomv2cclv5s3BiI99C8UnrmKyrQi+UGhbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5022.namprd11.prod.outlook.com (2603:10b6:a03:2d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 16:22:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 16:22:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHa7QnRzseVoCBaJESngrUu+eI1nLJwKWmAgACmeAA=
Date: Mon, 30 Sep 2024 16:22:45 +0000
Message-ID: <f95f773271bef7622f491a8fa33e7125cf4ac479.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
	 <08478bf1-e927-4034-b598-c0cb1ac8249a@intel.com>
In-Reply-To: <08478bf1-e927-4034-b598-c0cb1ac8249a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5022:EE_
x-ms-office365-filtering-correlation-id: e02112b8-08fe-45d2-4598-08dce16c1dbb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RnF6T2FxVlB2WjdNMW52RDdBRnBPeTMrL21QNFpyeDVpSmgzM1lvanV3cDR5?=
 =?utf-8?B?UXdHbEtHNzRZMFpyck91ay9JZFhsaCtuWDVoclV4VFVKRWFSU2VGODNKRmhR?=
 =?utf-8?B?UDlxWU1nWnhXbXI4bHhIS2FDb2JlVkI1Qm9MRUM3cnhhWTVmS29COTRHUXU4?=
 =?utf-8?B?b1RwYml1czFzUDhTMCtuWDF1cWNneXNBQnljYndUWXVRbFkzOHM2ZFBJZ3JL?=
 =?utf-8?B?WWM3bHlMeGE1SUV5LzRpT3hKY0tFaUdzU3JVZGJLeFhRQ3hlNTh1ZFM3b0NY?=
 =?utf-8?B?ZVVGWnh2K0hlQmJtODQxTkVSZFMyQjRCMW5pazlieU9LYUhhSHphR043L1Mz?=
 =?utf-8?B?R1ovWVhEMGtlVWpaY1A1N29UeUdTcU4zckgyL2lLYnlDa3dKZmxYbmZJWU8y?=
 =?utf-8?B?UC9MK3RBSFJOQnJGSTk0S2VTeGpPTURBaXNLRzhCTi9VVHFHWlNOSDlXc2Zv?=
 =?utf-8?B?ZVpuOTYvVDZCRW1ReE0zOTgyeVVoSFFva0JTVGJKcUFWQjFCRVowQ3I2c0kz?=
 =?utf-8?B?bUpMSHZmUmdMNmVHVGlhZFF1Y0FvZ1ZSbm43aW9hUG9TS1ZralFNL0lMaC9K?=
 =?utf-8?B?NGVLeVhaaXpwaXp6OTJsZ3Y5bW5pbVdxM0NKanpFNzFuTzhjOVNGaC90bXV3?=
 =?utf-8?B?UXVkYVJCRUxqUGxFV0IxblpNVUY5eXpuUGZRTnhvYzc0aXNOcTNUTGF3dWU4?=
 =?utf-8?B?NFAvaEtoV1NPa0ZEdnN0RXdjMzl1Z2krWnI2ZVZ3d2tVV3VBcTFDRjFkL0xD?=
 =?utf-8?B?TUZlTjZQOXdtT0FhOW1xc2k5MXZnM0tFdmNPVDdOTnp2UXRBdHh1SkwvcEhN?=
 =?utf-8?B?d1I4Z080aGE2bVdxM2NWUUhSd1Z2VWtOSmhjczZDbEQzMDJqMzdLZjRmTFFB?=
 =?utf-8?B?K3hEV0JZY2xTRHB2SXg3Y2x4NGVyeHR2ZHRwNk9YS0hKUDhmeU9BUllybnUz?=
 =?utf-8?B?Tk9zVnY3dS9kYXB1RXhEa3BvcUx6c1VmZ2l3cHFLejhNRGdCVlR1NDNObW5C?=
 =?utf-8?B?Y1czTXRBVSszSUFWWEVjenEya1ozSUhYQzlmQ3hESmRZQ0ZqNWYxVCtIeTZo?=
 =?utf-8?B?Y1ZkNmprTVZpTnM2djFNdUtCdzQ4SFlrdmtGWUhBa1YrTHExSjh1WFNKc0N2?=
 =?utf-8?B?cTZtcmQ5bGxuRjVmeUcyMlRYdWdJYW16ZHBndTg5RVRQWGFTM3hIelZZOWdM?=
 =?utf-8?B?TzRlOHpKaE1qYlZLbGdnZVE2aVd4RnQ5K2N2KzJCbnBSUGRhR1U4aUVGdlpN?=
 =?utf-8?B?ck9rMlQ3UFFSUm1xbFg5RjRZWVpZZnNzMTNZMkhlVU84N09NNXAwbGtob29z?=
 =?utf-8?B?Zk05K1hpb0RoTkgvcmptTHRzU3RJa2NZWUo0OEVZTVUyaTRrUkozTUpVenh6?=
 =?utf-8?B?YUpqckVENzZuVWRKWmNJcmNQbHhac1hjbkxZY1ZKNUJFSjhWV1ZPUXU0UHBP?=
 =?utf-8?B?RjAvV0l6RFZWaVNTNDJtNlNOdS9UM0o5VGJORXVsbjU0d0Q2ZUFheEJldVQv?=
 =?utf-8?B?K3ZDeWVTME9Od0UxVEZOcnMyWHQrMUdVZm1VdTVVOFFHSW14NFd2WS9BLzdJ?=
 =?utf-8?B?NHR2dm5VWFhTZ25YL0lVbWVOOStFMlUzdk5vVEVSS3dwQU9LV2xGWjFsWEJH?=
 =?utf-8?B?aGdBbS9qY2dMUW5Nd2xDdXVlQWNLTW5EOWFiSnlPenRoSHd3WUpHSUpIeHVM?=
 =?utf-8?B?MkNiNmp2R0pFaU9EOW5hak0xTS9vN2dic0c5a0ZwdEMyS0NkUGZZQjVCVkw0?=
 =?utf-8?B?eXpQcDZRQnJFL0VpMGh4am9WNkRnZUdkaWd0UUVwd1dGK0xoWjc1OThCREFI?=
 =?utf-8?B?MjYvQW5JanpmcVBVb3VKQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bW0yYjVpaUovVndKYllCbU5GMHozYmRiOS9lNzFQWFJTZTVXS0lUaVltSDJQ?=
 =?utf-8?B?NElvSmd5ajUyYlp2dVp6cEhLaHBiZlllNnNpVUR3MHI0NzhyejVvRW15WndM?=
 =?utf-8?B?OFY4MmFWZXJ0cEhJMXA2MFRJejIvRk1vNXJmVnc3ejBhWEw1Skw4V3BZZWlW?=
 =?utf-8?B?dFF3aDZ2Y1pmdk0vUk5nckhpWDZYZ1UzeDBNUWJYaEcxZUhiVCs4SHVHZFRp?=
 =?utf-8?B?dFhFOFVvbHh6QXRyNXc4dnRBWFQyWjJiaU0yS0xJbDlWYjYxbWV1VU9nZFBr?=
 =?utf-8?B?K0xaa0x0Q0RoQXp2dURneW04SWxuZHNCSXM0ZGdQeTAwb3YzQjM0M1JmRXAr?=
 =?utf-8?B?bmdZOEhNTXI5T0lnMHZRWTRxZmZUcE42NitYUWpkVUhaaWEwVE44UlVkbG9D?=
 =?utf-8?B?VzB0UlAxZ0F2TTQwaEQ5aS9MYU40R1QxZ0hpd3FHSUVNN3l5OStXNEtLRXhU?=
 =?utf-8?B?V09HSFpKbmwxZmc0NGRFTGQzaFI2bzU3WW5vaTVLOUFxM2Y5K21SK3lMdHR5?=
 =?utf-8?B?bkRNQkFKQU9pL09qUWRRZkJ1QVpLa0FXUDBSbUVlQit3bDBOREZoUzZqa2Fn?=
 =?utf-8?B?NVd1U3o3ZU1oSm5hRWljZ2xVWHZQK2hKVkJ3MXdWaC9tSzhNZ3E0d2swOWpJ?=
 =?utf-8?B?L0pxN3RtVDFIL1d3T0dnK3lRbHhxWXFuamNZZ0Q3dGFUMTVUcW04a0tVN1pB?=
 =?utf-8?B?eHNFc1dQWEdvcDMyNGhkM0JDWHRzblNCYkRXOHE5MUp1QnQ4YUxEKzdHaFEw?=
 =?utf-8?B?YVVLcnl3R0dyeVRjcmNBcDdjZldLaUFxakQyRDFXdHdTMHhsMk9JYUVDM3h0?=
 =?utf-8?B?ck8zNi9YMzdPMnk0WTB6RFh2T0tNajU3S0hkWlJTTUZuUENhNHZxWXk1OVUy?=
 =?utf-8?B?bXV6WFlvUDZYbGRvSUhGZk1nY1U5c0RMeUVXaG00WWpMTUt2QndhNjJuN2hm?=
 =?utf-8?B?YkdReVZMbThyZ1I0c1hpeGx0Z3c2Z1R2WG1oMnE0dFE2TzJUMWJCNzBXMHhQ?=
 =?utf-8?B?SFUxa0F6UlBQMVhIR2xMeFAzNDZzcVk1U1ZDRklnQzNiWHp3OWJrQStpV2Ir?=
 =?utf-8?B?VEcvdGY5ejV2eU5QVy9xMzVjdzJ6cXRsTkVNQmxFWDlXNnd0L0g5ZWZaa2pK?=
 =?utf-8?B?bWp1aWszVWw5azMyS2VhTGNUdmdxNEJqMkdtdUtjSnd3Q3JVSW1FYmRWTmxr?=
 =?utf-8?B?SlkyaURvaCthTVF1b3JtalhLYjBqa0xjSE9STURCNlhFMjVLVWJWVWcrcGdh?=
 =?utf-8?B?LzlGak84WjZUWXFZQ0pDcnRXR3VYRE51Tm0relNMSUVUanMxdS9qSHJ0M1dk?=
 =?utf-8?B?WnZMQmZsNTh5eldVeFhnT0tZcVpJckVmUkhqUkp0Qk92SzRabjN2cHZUQ055?=
 =?utf-8?B?a3B4cGprUFcxaUYyZm94OHdUWHBDMmNLeDVURENpa0V2ZEV1eTBvS24zdVph?=
 =?utf-8?B?TDUrWWwxc2M4R242KzYxdjI1Q05xeCttdnNYbjlvTWdnVjVnVE1IRDlTUFNC?=
 =?utf-8?B?L3B3UkNlOEZkSHBBVnZQVjJNc3NlS1IxQ214R01adUJwSzYwSU81eFhsbkM4?=
 =?utf-8?B?RG1JVGx2N3pZSVdEOWZYMzRZckwrM1p3czVjdU5kemZGMzI5YXNuNVoxRXBO?=
 =?utf-8?B?ME5JZGtOWnJPTkhRMVlEaEYrSnpiaXZ4eUkvNzlTUGNBRm1mUVpBdWYvcnZX?=
 =?utf-8?B?WG91bk1aSU82Q3F3RlJwNUtkTG96QUVXRHFnS3NvdUZpaE5MQUxIUERmQWhV?=
 =?utf-8?B?bjE1K1JIUnJ2Q2lsUTZYaEV3cmJEKzRtMFpVOTdRTzUwYnNBenExZ1djZkJR?=
 =?utf-8?B?S1pkajBTY0plenBVYmhYaU1LNC90TjdsWmpWckN0ajlVRmxaemhLSGxZaDhM?=
 =?utf-8?B?VElkZHB3NzRyajdNL05TaTdTQlFNSzJPZ0oyNHNHZDVGdk1KaEFneEFIS2p2?=
 =?utf-8?B?NlFJend5YVlHZ3NxUHU3WDRCYmJrN3VyVkFtVzg0cFR4ekk4UmJNU0hJaW1R?=
 =?utf-8?B?K2YrajhENlpSaEFHMGxLbHAramJ5a1RjWUdVZjE4Q25XL0ZmUDBwd29xUUFM?=
 =?utf-8?B?WW9MeE9maTFtczlnQjlPUXgvNUFDQ1haakJraVF4Rk9BMzdkb1c4MjYyU1Nx?=
 =?utf-8?B?bG5iL0VtUFhwSmVLOEpEOEczOGc1Sllia1Z6VXRQWlFqSTB6N3Z6NnBQYUth?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3DD16A4A4C8244C8788D812315AD7FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02112b8-08fe-45d2-4598-08dce16c1dbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2024 16:22:45.1246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vkqy1vt+bY4QAiIokt3Qe7A6ZuDgD2fLvK++0MLQw+AL6f7SDRSUGrr1u0yRJFwctD06a1UND8XeKxcY22NWkW8/izOylRdA4qWDOXm1xPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5022
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTMwIGF0IDE0OjI2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBU
aGlzIHBhdGNoIGxhY2tzIHRoZSBkb2N1bWVudGF0aW9uIG9mIEtWTV9URFhfR0VUX0NQVUlEIHRv
IGRlc2NyaWJlIHdoYXQgDQo+IGl0IHJldHVybnMgYW5kIGhvdyB0aGUgcmV0dXJuZWQgZGF0YSBp
cyB1c2VkIG9yIGV4cGVjdGVkIHRvIGJlIHVzZWQgYnkgDQo+IHVzZXJzcGFjZS4NCg0KWWVzLCB3
ZSBzaG91bGQgYWRkIHNvbWUgZG9jcy4NCg0KPiANCj4gU2V0IGFzaWRlIHRoZSBmaWx0ZXJpbmcg
b2YgS1ZNJ3Mgc3VwcG9ydCBDUFVJRCBiaXRzLCBLVk1fVERYX0dFVF9DUFVJRCANCj4gb25seSBy
ZXR1cm5zIHRoZSBDUFVJRCBsZWF2ZXMgdGhhdCBjYW4gYmUgcmVhZGFibGUgYnkgVERYIG1vZHVs
ZSAoaW4gDQo+IHRkeF9tYXNrX2NwdWlkKCkpLiBTbyB3aGF0IGFib3V0IHRoZSBsZWF2ZXMgdGhh
dCBhcmVuJ3QgcmVhZGFibGU/IGUuZy4sIA0KPiBDUFVJRCBsZWFmIDYsOSwweGMsZXRjLCBhbmQg
bGVhZiAweDQwMDAwMDAwIGFuZCAweDQwMDAwMDAxLg0KDQpIbW0uIFRoZSBwdXJwb3NlIG9mIHRo
aXMgaXMgdG8gSU9DVEwgaXMgdG8gcmVhZCB0aGUgdmFsdWVzIHRoYXQgdGhlIFREWCBtb2R1bGUN
Cmtub3dzIGFib3V0IHNvIGl0IGNhbiBzZXQgdGhlIHZhbHVlcyBLVk0ga25vd3MgYWJvdXQuIFNv
IEkgdGhpbmsgd2Ugc2hvdWxkIGp1c3QNCmxldCBpdCByZWFkIHN0cmFpZ2h0IGZyb20gdGhlIFRE
WCBtb2R1bGUuDQoNCj4gDQo+IFNob3VsZCB1c2Vyc3BhY2UgdG8gaW50ZXJjZXB0IGl0IGFzIHRo
ZSBsZWF2ZXMgdGhhdCBhcmVuJ3QgY292ZXJlZCBieSANCj4gS1ZNX1REWF9HRVRfQ1BVSUQgYXJl
IHRvdGFsbHkgY29udHJvbGxlZCBieSB1c2Vyc3BhY2UgaXRzZWxmIGFuZCBpdCdzIA0KPiB1c2Vy
c3BhY2UncyByZXNwb25zaWJpbGl0eSB0byBzZXQgYSBzYW5lIGFuZCB2YWxpZCB2YWx1ZT8NCg0K
Tm90IHN1cmUgd2hhdCB5b3UgbWVhbiBieSAidXNlcnNwYWNlIHRvIGludGVyY2VwdCBpdCIuIEJ1
dCBsZXR0aW5nIHVzZXJzcGFjZSBiZQ0KcmVzcG9uc2libGUgdG8gInNldCBhIHNhbmUgYW5kIHZh
bGlkIHZhbHVlIiBzZWVtcyBjb25zaXN0ZW50IHdpdGggZ2VuZXJhbCBLVk0NCnBoaWxvc29waHks
IGFuZCBob3cgd2UgYXJlIHBsYW5uaW5nIHRvIGhhbmRsZSB0aGUgaXNzdWVzIGFyb3VuZCB0aGUg
VERYIGZpeGVkDQpiaXRzLg0KDQpDYW4geW91IGVsYWJvcmF0ZT8gQW5kIG9uIHRoZSBjb25zZXF1
ZW5jZXMgZnJvbSBRRU1VJ3Mgc2lkZT8NCg==

