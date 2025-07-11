Return-Path: <kvm+bounces-52191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7812AB0234A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:02:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD393B7863
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6212F2359;
	Fri, 11 Jul 2025 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6A8Ngcz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14422F19A2;
	Fri, 11 Jul 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752256939; cv=fail; b=mbR1KMxpppV1FCNA1t1Iq/C5ae2sc5MOjfLRRs1MnEXD9M6JzkQQj142GvTNdB1Ri4jqzLLgwkSFLkljv4/qU2G/vM9pB09sRmBpk+X2q4f5MAb0dYuL85kYWCEEgYbFdiA1lW7DB0EawGy0jYnMKcMvtPB5+xTXp7QQpS9saUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752256939; c=relaxed/simple;
	bh=CCwZap8k3l3hiUUp+Cs7le/6KrGyDAd7VOvkWUCpXAQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X+NZ8dZIuGBxSLIwYoBl75f78Z66s7X9xwtrnkygeQ8EKCANe8xQZrQ9K8HABsK3RgHXYjcQYYMNgTu04rDMNhiiuvMwJznztS41mRSz8fUf7WMvbWkzQE9UCwt1clkPBAO/dDZzuLSktnitgDi7Cq8rkhuPoeeX8Lzhggepxx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6A8Ngcz; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752256938; x=1783792938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CCwZap8k3l3hiUUp+Cs7le/6KrGyDAd7VOvkWUCpXAQ=;
  b=m6A8NgczkvFeDr5UBMT5cv8Xo13k4QpU6nTgBuA7otKEotBCPu3W8jUg
   YOstO45DmhGEFwsdG7/+NgKCd909Of4uue6UdxXTLNgQTDmOeX0bZRxww
   +WLz88QvscwN+xtH5zl8380gZ5GpL6vT6UPaC1yxKdxFFTLWtMvWICQF7
   OxbbURatNlxEAsnlRk8IhYBPPjTNhpsggwzKAhhzX5APdHKYwX+Tl1yXP
   O1geRcrbH0W+ONmHKr1azbhiJ/gyiK0EoFWDyZALXUXbWKwtF9VmzDmdG
   LGu7cM5cY7SpRBO0zuoBZ2A91HLu/G+8QRQ02QD8GleAwxsA30Y8Nz/Uf
   w==;
X-CSE-ConnectionGUID: xUpYj/9DRKKVcy36wtwGVA==
X-CSE-MsgGUID: t8nhh0bKQNqyTeF9Q9uSEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54417585"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="54417585"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 11:02:17 -0700
X-CSE-ConnectionGUID: 3T0hWVYUSfORdem6wSwbEw==
X-CSE-MsgGUID: MY0p3lsGTuai/Gtauyd6MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="156762642"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 11:02:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 11:02:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 11:02:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 11:02:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8v4eaV97VzT2sr+r8CBao8nieLTP0AFhuC2dolkYX1+zGXYvfJ1iW/2LbQkF1HVpdrhTm+oW+B+eImYRFjXwLBClPGjLuNGurVKO6aaPNCQy0BLcxyDzl6YXYth9dkg7txmQNu7aizxnN8nw4G6va6+b2tsdxF9YArjeVFFq3DBy7mLHa5Kcw7qV3VPZkoxpPQj58LMZO2EXDNKSw7CwWpqv6mNlXSn9XKbzj2oLwsKY83VNkmjWEv2srtUtPrFBadUo0nCxP7MtZeA7Rb7dGz75nIdFWEH/u40rpQHUwpGanIiQ//TPezv4WW9RXCz3THggV3OX8OullnCj2pMVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCwZap8k3l3hiUUp+Cs7le/6KrGyDAd7VOvkWUCpXAQ=;
 b=d26a0JPvQSssgT7PK5sUlPTw/YT2QMN7E80TeX9RODQeJRPSzvmiNX6tqjhl+wlvLovyc5Bvci4Hh+6ijCG0NAFbNkIvmdTNEi70YuRbh5FAyBxhfI5WjMr+EEE0493XOWvr6jp03bXvkK+E9jUSpNCX6eCpkbLMyGkD4dxdul3kPbweehNqzoflAjoFZR/G7r1mYE/Oa3Y8EgG9cVTNNZnjEkZKkTavY2GmIxWy3eg6e6cwMBApZ2sDmjkhMuP3W40JwshnJjdrleShgelB1ioR9JWNZrTbrrzpnCd4yUr+cxRL11aF2AXLu0/XCPsWr4xS5I4Y8f/MU+/2gerQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9227.namprd11.prod.outlook.com (2603:10b6:208:575::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Fri, 11 Jul
 2025 18:02:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 18:02:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 0/3] TDX: Clean up the definitions of TDX ATTRIBUTES
Thread-Topic: [PATCH v2 0/3] TDX: Clean up the definitions of TDX ATTRIBUTES
Thread-Index: AQHb8midsdeH/5RQoUS6RvBy0ZwbfbQtNwWA
Date: Fri, 11 Jul 2025 18:02:10 +0000
Message-ID: <5154b5ba73f7917c0d239880d0056a40ba7f1e08.camel@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
In-Reply-To: <20250711132620.262334-1-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9227:EE_
x-ms-office365-filtering-correlation-id: e65515b9-8854-48fe-2450-08ddc0a50ed2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RGQxQTN1Sjk5K2Fyd0NUdktrbEswdmxDMUJVZ0RITUJ1RDByWlhkdUFHT1U5?=
 =?utf-8?B?cko0Zm5lQi9UdEkyR1dhZWRyL2c5WC9xRG5YUFZ0UWxrV0F3VnZTYXh3UExG?=
 =?utf-8?B?dHUrdFo1YWJWbWduakF0Y2tTYWRKak5ZUGwxREppRFdXamQvYjdmT1NhbGdw?=
 =?utf-8?B?WDNnWWNJU2t0T1haMHBoRDNaSW1qTUMreTlkWFFsTGlpc0hCNkkrQmdRVWR2?=
 =?utf-8?B?Uk53SlFXMnREQjVEbkZDd2JCQVg1ektCQWhiVG9FVy9BYmpSaisvK3ZQVEMx?=
 =?utf-8?B?L0xWajZmYU56N1ZDTnVuRFcveHNNazhyNWZCTTVNRUQxVVQzY3FVVEdiT1dE?=
 =?utf-8?B?NTFmeUZCRDFBY28rMjNPK2pzWlVsYUdnY09jMEp6ZWN3RnNpVWhtc1dMcFVi?=
 =?utf-8?B?OHR3bVNwRk52WXlDT3Z3K2FlY0M4RUdnUzhYTWhOdEVjVmRjY2VyMDRaREg5?=
 =?utf-8?B?UmdNdnBnY0t3cXFGRDBoQk84SElDT0JhSkJaS1k5N3A4YTg2anVXMi8xdisr?=
 =?utf-8?B?N2J0Ynk3WFRvZ3F6RUQyc1NJS2NVU2Y3emU2MTdGUGJmWWhNNGVMRGdOaWFD?=
 =?utf-8?B?dXV0d0J3TVpPZHU2RE1TcXJQZzJSWHprSU9WZmJxUjg4NkFpVXh4MVNUYSsv?=
 =?utf-8?B?Q0FsM01iZWlYMlAvV3ZOaDRuUDhuWVJPeVljbDFuTUFRRGhQQmh0OGVSL3NU?=
 =?utf-8?B?NWZGcStoZ0dKM0Y3eU9uc0NwOStpYms4Ym1OSFlNOFJpY1prejJaUkNwOGpu?=
 =?utf-8?B?RmFsdUhwMUZVTlZNTklBM2czUFpVS2VTTStzTnU4UUt1Mi9kZnoxRnBVdEhz?=
 =?utf-8?B?K09WSjdVZ3lObm1GTUpJbVNDSjR2MmpCSUJkYTFRUXlwZUg1NlgwVnFIczdz?=
 =?utf-8?B?Y0tCQk9OZVV5Nkhub2xMVE9DOExDYktCb0p5T2lld0xPUXI1dzYrUUwzT3FU?=
 =?utf-8?B?NEFYc3ZaUm1zTXNjZFhPbXlncmVuYmtETVNiTXFvdmNOenpqOVJjUU5Td3JC?=
 =?utf-8?B?cytVNW53b0dKeCsvbWdXL3FYcjlXb0lRWTFNZVFaQjM4cFBRRWhITlJMbDBB?=
 =?utf-8?B?L1JiWjJGL285QVJPNUE1SGtTd0w2VmljSXVYdERDUWY0OWJMc2VmbzJFNEFw?=
 =?utf-8?B?UHd6WkVNUUsvczlYQk5XakRZWUhSNWEzd25DMzRGTGFOQzVqTHJ1S3YvQ1dR?=
 =?utf-8?B?eUhmam82RlkrSnZTLzFyNFZrUGdnc2xvVWhCZTd0eXN2eENlNVhMaU5XbnZi?=
 =?utf-8?B?OGZmM1RIR2E5TFI0cXZRVUlIRFZ0bUdEMXZRS3RJNzQxYzRUVWdtQkNSYXhG?=
 =?utf-8?B?YTB4dU5Ec1U0c0lobXF6NE5TNWdHNm1DendsTlk1U3RRQ29OSnVwUWczc2p0?=
 =?utf-8?B?MUt6NXlXL3hiakRxSUxQZm9rSXE0SDdhdEdJdzZIVHJocjVCcWV1VWF4L2VK?=
 =?utf-8?B?b01iekFlUk5IcjF1QTZ6Q3pqMWw2QUJScVFpWHlkTHBFeWhXMjUwYTltV2RF?=
 =?utf-8?B?NFRtQ3ZIN0czb0JqTzAzcXRLVUdUZStyNWpObzl4VW9tdzloMmVGTGxSSjA4?=
 =?utf-8?B?dEluSkJsRmdkYlk0ZFEzVWNWMUxmZVJNNWR6MmdCMnNUSzVWWUxwVHh4dXdm?=
 =?utf-8?B?VlFoRDRPRzVpV1hiQ1pObWd1Q1hwWERZWjJhQzlIT29HdHZ3clpwa09zYitO?=
 =?utf-8?B?bHovNmc3NFRhMXorVGdPam1Dd0VJa0E5Wm0vU0FHRm1maGgwalhldmwyZ20w?=
 =?utf-8?B?RlZRZWxiR0xIVDBjWmpEM2FrTmt5MmZ3ZXlVWGhRTTUxcitHSlJMaWJBdHZ3?=
 =?utf-8?B?TUtpVFg3bzk4T205NXN1cEtHRFk3aU5vWjU5b2orZEdCZkdqN0d6NUtUekxn?=
 =?utf-8?B?MDVEN0dXWjJHeml6MHBzK3hYMm1TQmVzcWswRjh4d2NBcXBPQTM1MWE2aTNZ?=
 =?utf-8?B?YUNGV0xHRVl0eWxoclNXV2tmS3NlWnFvVHdqWFlrQXRlZ2RJckQzZUZkUFAx?=
 =?utf-8?Q?15RW0DPskLA+G/leeAZYhXzXU9aiRM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXB0L0JxeTZlZ3RUK0hZdlZvVXZ4Z09BMTdhYkpXcnQzZjJNRk53dFAramJQ?=
 =?utf-8?B?bFVNSUk1SFlYenhKbnhQMC9QeFR3dVAvVGVjRG9MSS9wSHRwbWcvTlV1MGtp?=
 =?utf-8?B?S0V2TVhBSnIwT0dXRTdoUkRBUDVXTzJueW44UEI1T3JuUDZrcllydzdvQ29M?=
 =?utf-8?B?Y1lwUmJHN29uT091NXpPakRXaCsvazZEOVgweHFEcjJxSGtvd0J2ZitZb2xR?=
 =?utf-8?B?bFErcS9ib3paMlhsZTNJQzhmN2M1dzBGMXc1dm0vL05mVHk3WmlZWTFzc1Iw?=
 =?utf-8?B?aUdDT0JpMldYQlUrdXBoUWJKa3oxSEk4dkVGYnVxLytKZFh2SFdtU3dIUG9T?=
 =?utf-8?B?S2s3L2NzOWJ3c2doTmdncE1yOG1XQmNmQTBqV3I2L2EvSkVsOGhnajFNMER5?=
 =?utf-8?B?RXB0QmtSejNudmttcjdpb3dWeTRyWHA5TVRHOTRPVStqUjRPVUNWU0pEbHpm?=
 =?utf-8?B?UnVqa2RxQVNaaFdXeVRWOExBblFnNThodFdHVVprcUE3eTJMZTQvY1ViK2FL?=
 =?utf-8?B?SUxpWVU1dW1OZmFpVWIzWDZrdTBaUUVDSjlJY2laWTFPRklkY0pobFdjczh1?=
 =?utf-8?B?WDZPN2lGb25haC9ubXdhUTJnQW5uT3pCb3kyU1JtcUF3bVlmQm4rdXJJcmE2?=
 =?utf-8?B?cW5SUjV4VFpqcUpQc3NnTjVWeFA4N0pFcVFaTlF6QmZuNm9wK2tHc1JMQ00r?=
 =?utf-8?B?OFBXeDBHUEhyMVZOZ1dxL0p6UzB3OTFXRjEzNkxsZnRTVVRVNFRnNTUrQ3pI?=
 =?utf-8?B?WEU0MWFrK2toMUEvUUZkbTlBVndVdUZlWTRicEZmOVk0czZhNnB5VlFUZnph?=
 =?utf-8?B?cm5lT3lrbWUzbVNpQ1A1R3RYUElUZHdMUVpMMDQ2YjNSaDJVcHAwMEJ2OTEr?=
 =?utf-8?B?WDVlMVRkT2YyMHFydnNtU1Rlay9qM2RIa2UxZUZRTE1Sc3J5NFF2ZTQvOVdS?=
 =?utf-8?B?M2dsT3k2S29IZUhNenhZcEFYSnNweU4xRmZ1WWZwRThiYjAyN3pBZkxweVVY?=
 =?utf-8?B?aXlicGVMbjNzMnRLSWZ6TXRocEtRNlhqeDdhVlV1dFdkNHRhV1p3dkpDNW5V?=
 =?utf-8?B?TzJFcDVHYjZmR0RRV2RQbzYyWmFTZmxibllCRGpYRlIrQ2V4bjhTS1B3ZFBz?=
 =?utf-8?B?QWpjeXBqV1E5TW02L1M2WTdOVzZCcDI2OERiV2s5aWphcU16M2RyY0FMYjF2?=
 =?utf-8?B?SUx5azNTNEhybUkySmRvRTEwS0Rsei9SeWRST0h2LzdBaCtzV1JTTStGWWQv?=
 =?utf-8?B?clVwdHdWeWEzYmtpK1ZEVHhFRkIxWEkyeVJZKzQ2Tk5zSkZlbE5xQTFFWXJM?=
 =?utf-8?B?bEE1R2Q4bWlvR3hjU01nWGxobjJqTXdhL0hnTmRwd1RUclcrcVhaMmt5Nk5q?=
 =?utf-8?B?RWxDMytlMlBjUC9pN2F5d3kxWkxyT1BIZUV4em5vNXYxTkJSWlV3Ri9VYTRT?=
 =?utf-8?B?VTBWWVRTODRFUElnUUZIazhWajBwNmwzelFGR2tsWmVXRkV0aEhJcnpTSDRx?=
 =?utf-8?B?a1N3cnZUQVdwMk56TmVFRFlOQ2Urd1hMMGk0eCsxTUgvRUI0T0JqWnBWVytU?=
 =?utf-8?B?WUd6eWRMQkd2M255RXpYRWVQYVN3MmoyV2k4Sy9hTVA5aThPTzMvOGh6WW8w?=
 =?utf-8?B?MlhOa0lXZVFPUzlKRmtLMmcvMDY2QkQ3U3FKSEtRdUJNNmRJcGNoN2tpR29D?=
 =?utf-8?B?Q3V0MFBEV0VZZWEreW1XMnV3NWtiS2t1TElrQ0VFcTBkdXNkWWF6dm1oc29z?=
 =?utf-8?B?UmxHMGpCYVNwcU1hNDhtc3B4Y2g4NXdlK0VFQnpzWFdCVXpSblBkbFlQekdX?=
 =?utf-8?B?TmdqOTlWcmoxODJSRzlvY2dCMVNna2F3R3pGeEtaWWtSV280TmZQYjFuWVZW?=
 =?utf-8?B?d1RDOUhtbHFRLzlOcG1sZEZFaWNrMDZqcDF6b1NQUXBxbUlOV0tlbTl6ZmdZ?=
 =?utf-8?B?a0h3KzA3UXB2eTltYjVGK0V0bHZadnFTSTJWUDBiVHF0RFNmRFc4UE5aY0hr?=
 =?utf-8?B?NjNYR2hJWTJPb0NTWkxadEQ4R01FZTlPdmg3dWEyMmQwLzBEUUlxZmtYc1Jt?=
 =?utf-8?B?NFNJN0s0VHFiWmg5NXRwR1BPVHgzQ3N2eVJKTXJ6TURCQnNSQ215bnhKZFRS?=
 =?utf-8?B?TDNiWW96cjVmZW1iaEVWajd3ZThUY3IzbTZrejRIbnUwZmdWdkl4ZzVEMEJP?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9A8E056D5AA1B4589BEA2036228E0B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65515b9-8854-48fe-2450-08ddc0a50ed2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 18:02:10.6681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4nSpe0pRR7UkeXuFI3BO1TaHDVaSRwvBUoYseuP+sLKSRTzHXYZQ+MXdgyrusCknkpkTZXQSANvjnGh5JJ2PEQDM+jySu2yzeNdiWHE1sbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9227
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDIxOjI2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBO
b3RlLCB0aGlzIHNlcmllcyBkb2Vzbid0IHJlbmFtZSBURFhfQVRUUl8qIGluIGFzbS9zaGFyZWQv
dGR4LmggdG8NCj4gVERYX1REX0FUVFJfKiwgc28gdGhhdCBLVk1fU1VQUE9SVEVEX1REWF9URF9B
VFRSUyBpbiBwYXRjaCAzIGxvb2tzDQo+IGEgbGl0dGxlIGluY29uc2lzdGVudC4gQmVjYXVzZSBJ
J20gbm90IHN1cmUgd2hhdCB0aGUgcHJlZmVyZW5jZSBvZiB0aXANCj4gbWFpbnRhaW5lcnMgb24g
dGhlIG5hbWUgaXMuIFNvIEkgb25seSBob25vciBLVk0gbWFpbnRhaW5lcidzIHByZWZlcmVuY2UN
Cj4gYW5kIGxlYXZlIHRoZSBzdHVmZiBvdXRzaWRlIEtWTSB1bmNoYW5nZWQuDQoNCkkgcHJlZmVy
IHRoZSBuYW1lcyB3aXRoICJURCIgYmFzZWQgb24gdGhlIGFyZ3VtZW50IHRoYXQgaXQncyBjbGVh
cmVyIHRoYXQgaXQgaXMNClREIHNjb3BlZC4gTXkgcmVhZCB3YXMgdGhhdCBTZWFuIGhhcyB0aGUg
c2FtZSByZWFzb25pbmcuIFRoaXMgc2VyaWVzIGNoYW5nZXMgS1ZNDQpjb2RlIHRvIHVzZSB0aGUg
bm9uLSJURCIgZGVmaW5lcy4gU28gSSBmZWVsIFNlYW4ncyBvcGluaW9uIGNvdW50cyBoZXJlLiBX
ZSBkb24ndA0KaGF2ZSBhbnkgeDg2IG1haW50YWluZXIgTkFLIG9uIHRoZSBvdGhlciBkaXJlY3Rp
b24sIHNvIGl0IGRvZXNuJ3Qgc2VlbSBsaWtlIGENCnJlYXNvbiB0byBnaXZlIHVwIHRyeWluZy4N
Cg0KVGhhdCBzYWlkIEkgdGhpbmsgdGhpcyBzZXJpZXMgaXMgYW4gb3ZlcmFsbCBpbXByb3ZlbWVu
dC4gV2UgY291bGQgYWx3YXlzIGFkZCBURA0KdG8gdGhlIG5hbWVzIGxhdGVyLiBCdXQgdGhlIHNv
b25lciB3ZSBkbyBpdCwgdGhlIGxlc3Mgd2UnbGwgaGF2ZSB0byBjaGFuZ2UuDQo=

