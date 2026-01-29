Return-Path: <kvm+bounces-69576-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANtHNxKXe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69576-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:21:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB2BB2C4A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 848B2302834E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101BB348440;
	Thu, 29 Jan 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQLuzjFN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4B93382CA;
	Thu, 29 Jan 2026 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707144; cv=fail; b=KvF6ziPFCFP7SNGJ074F6pellmZvNZ8+lYIwckUMVfF9gx0XG7GNwSbOjUu/aUCIUFSrYTh1CEjjlBl7vajcaRw5yNeDg8IG762/G3KcRgDd/OaOmcyY1WZE/7OmorxrkcW7yFOonvl49yNu4WsGTwEM27PFL5XPXJ5+Pf0HUNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707144; c=relaxed/simple;
	bh=dpXwW3LIfPCPZvqWBPsd7SgLvnl5CNec4n56cJvNqKA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qCfuP8d3JBfg0fVDXF0uo5BAI2AaDHMBk5YT+YPCS9BDncAolNgzSANqNMhhadZQ9I5RbmQXMVq//Dizu3oxQn9nZHosYOS7qj8t/v6sZ+UuCkYHSD6A7VGSKNVPZ2s3ht1JeyQyRJl5edkIjq5er2b9+txt/ag3uWjW0YPWbnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQLuzjFN; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769707142; x=1801243142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dpXwW3LIfPCPZvqWBPsd7SgLvnl5CNec4n56cJvNqKA=;
  b=cQLuzjFN6t9r4rVSagoYqQsdalvPMZJ3QBBdH9qmIEXGpdxWaUOyZN8d
   4NpzZeh8EmjACVE3udkCfEU1mGLF/gOfg2/sWqkX2R2lSvryNqmDExhAV
   UNS4dvRtIPHGpLJ6S/fLAPIKy3jlGyPjS/maGXZ0rU9unsATILUsKe9Ee
   xb6OXVnFp6BqUe8nYK0q+KvOoIC0CiNxgS6HX3GpcTYuzZx3DMe+Ym8aL
   056hpAgp66mmDIdx9wRgt4feY6dHxPVtE7B3RUlMIt5rfP6GXWA+7mDoK
   /xklhY+/N1KNN1kQ8XV2/vMwa/pWvXWpaGfk2jWMCd0KkKWgotUBfRIVY
   A==;
X-CSE-ConnectionGUID: tlXspJBoSfWSG9hJIXmJ2w==
X-CSE-MsgGUID: 8rX5HVZaTZOi2KxOS3uBng==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="73548995"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="73548995"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 09:19:01 -0800
X-CSE-ConnectionGUID: gkZ/yQ90T4mgOYqE3+ruPA==
X-CSE-MsgGUID: 2tRVe8HSSTGCJk/hOnJ/lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="213126548"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 09:19:01 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 09:19:00 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 09:19:00 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 09:19:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhP7QV84JEv+Yssrq2uz+5Jq8R+lCom6qH0EzBKloH6onsNr6efPc1hbakzCUT9WSTSxCMq8UwI2GgQ0hMn1fivstaB223k36FVVlugxw/qhyHYH2wYzmDSrpm+VPq+zY/gvl9wPWp2f7GvzsiVJtLJCvRSQ4bXL6LoX5A0y5U5LJmvivAJgwhlv8l0XQpDeUIAKxq9UazvKU6kQj+qYuhxoHlVyJ1kXSfLIUcwzTM5d8GCa7BO/IPV/e1hzjmurmvVOZ+S+8IWELiauE7Xtqw/Wla0qZ2+NOoUSB0as5AaJ7Ju0z4pwzLyl6a5RHp56NDe0fdPYUBs7N4wMb53eIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpXwW3LIfPCPZvqWBPsd7SgLvnl5CNec4n56cJvNqKA=;
 b=UKvvlQeom8/lNIoyxBFdAdanMuMH8JDiGcyFyBgRVINoAJlDSglfHIUveAtbUu0+5g/lKR79MUOrlk+eglo90+x2htfa2tb2pan5COqX7UwL+QIt7dExrT7MwJsZ4M0jmRcyb5J1RMRL8VTPrBPZe5EDWDg5XsrqADYE4VvB3wLSPADHG2y6JZawvsfketYnppbm3cvJLp2LNAZBDl1+8lrBIf1ez3rKwtccA5OnxJvYYwFMPKOocs6gIG2RkrrVDIUrDddrCi1h3OWHXoeUDn+DyAvjFJ6ZDaXgscow/c09Lcj7Aggv93oWmHZXaziwxRJV+FxqMiK4UAfT6WWpyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH3PPF1AF044E07.namprd11.prod.outlook.com (2603:10b6:518:1::d0c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 17:18:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 17:18:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UDEL+AgAKCH4CAYzLJAIABDGCA
Date: Thu, 29 Jan 2026 17:18:58 +0000
Message-ID: <9096e7a47742f4a46a7f400aac467ac78e1dfe50.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
	 <67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com>
	 <aXq1qPYTR8vpJfc9@google.com>
In-Reply-To: <aXq1qPYTR8vpJfc9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH3PPF1AF044E07:EE_
x-ms-office365-filtering-correlation-id: 144673d3-fb26-4091-0540-08de5f5a7d0c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WW5KUlU1bit6THovVHJFN3RGMXJnTVVOcEllOXJSaEtrT2xMbE1lczJ3N3Y4?=
 =?utf-8?B?WTBUL3BMaXpjWGpHRlg3eXNkVXhCaURLSE9CQ0hmK1NwaGc2V2J0b2c2VEp4?=
 =?utf-8?B?M29vQjZUWHFQL1ZhNXhnQVhHSGE0dEVzeGN0cnVkUnR0VzJDcjFzTHlMeEg4?=
 =?utf-8?B?aGhlNm5Kb3JSclRxMVBpY1k5aXF5ekdJd3RCRElXRXNhdkN4YjZiM29UMzNp?=
 =?utf-8?B?VnN6L3RKQVdoallOd24vTVY3bVNKSm4zTU5sbHQwSXZ1YWZvemQ0Z3VXU2NO?=
 =?utf-8?B?cjVVbkk3SERFN2dJbDBKU1l3YmxzTjV3K254QWlFZ21aN1hjd3NSVitieVlK?=
 =?utf-8?B?dkQxZXRTb0IxNTV1TnVFVDBwc3hQRG8reTNnN1p2OWRDc2tRWGNPM2FNVkZ6?=
 =?utf-8?B?Q3lNdXpMOFpQTkxZaFBOaElxd1ZJRXA5aDhqSjZtSzFNbERGRWFyMXlKWi92?=
 =?utf-8?B?enpZaThvZzZOUERUeXcwVzVsNHIrTm1qOTBqZkdtOTVMbkZwNGVwSEhlRlRi?=
 =?utf-8?B?ZUF2cjlPeXUwOEtuNTZOL1NjS3FrQmFtM1hnRTB2d3dlYXlSb3VTZXhJYlVx?=
 =?utf-8?B?Tm82SE8yZWlTVGR4dkRjVWIvYnA4UXMwNzBmcCtYa3ZnRGo4QnB0cDl4aVZq?=
 =?utf-8?B?SFBvRjZ0VkxYWk1yL2pPSXAveC9hOTJ3eENxZUkxRnV4L2dIdnN1Wk5TclFV?=
 =?utf-8?B?RFZTRG1kVDJLVENCZmEybHJmVUVjQ0tZOElqbFBoeFBBZXcrY3ZDSVBMemt2?=
 =?utf-8?B?NWgvNDVkY0VlTkIrSXM0WmZXY3pzS2RwK3pWaFRvNVJxcUpBY3VhZTMxQ3o0?=
 =?utf-8?B?NDhXME9WQ2N0ZzdrNDZWVERXRDNuMi9oZG41UzMzVnhGbG5mZUNramY2bDRY?=
 =?utf-8?B?OXdHbTdJZmVkYmdsYlRsMEF4d3EvaDJVL2JaaEJvajd6cDZXYmVyMHFzNzRy?=
 =?utf-8?B?WTErWll6aFUrbW9zeDVwTjJEaW43UC9TanBQODZLbkl1b2Z1WU1MSU9ycWNL?=
 =?utf-8?B?aG5FL0EyVXkzSFVPeDR1dFFhZmY4MzRVUlRUeW9mRWM4Q3hVMlc3NHFpQzZK?=
 =?utf-8?B?MitONVc4ZUlIYlBtWkVxelBFRnJ2UXZRZ21naktob1c5OEdBRkdkT0ZyU0Jv?=
 =?utf-8?B?b3VnQUQvVkZBQTR6bkx5azNGdUM1ZDJYSlJNWll5L0hLQ3gwbFNxVVNUQUZt?=
 =?utf-8?B?SXVkYWNVY2F5N1FEV1NycDBqU0dLQjJnMUZLUXVNSUpKd285S3lEZER0TVdv?=
 =?utf-8?B?dVZRb3RWWkdJd1lrZFBCbTVueldPSjFIbmMvcXhqWVh4NFVOcjdEOGpTVlZZ?=
 =?utf-8?B?YnFyczV0VlZhTldpdlg3T3FsRzYvUlZXcnZncko1R2RpUlovU0JkSG1BRTdZ?=
 =?utf-8?B?d0ZNdEYzbVBINmFwa3dwUXlveEJkTER0T2hkMDhRNXlkeXg2NUxKdWtOTmdz?=
 =?utf-8?B?SkxrRUpuNEFPOEtNQk9nV1RmdFYzOExVRkRmMi9TZVJvMy9TWFRvcTE2NkMv?=
 =?utf-8?B?UHJLZGtVTnQ1R0VzUkp6SG9iSUl4bWlleXRxYnh1WmxYd0UvSnBjVVpJTFdx?=
 =?utf-8?B?ak5FVUgyd2pnTE1SUXRnVnpORGVwWVhhN1QyN3lNNlU5VzFaY3EyNzZ4STZP?=
 =?utf-8?B?UmlRdTJHOVV4bUlZTHBSenRYbkFxVnNUVVdMQy9zTEZ2WTBtRDVycDByTW9C?=
 =?utf-8?B?NWdJSVB2Mmd3SFZNMThqRUJFbkZjclo0cEZsdFAxRGdvTzZIaTZtUFJUa1lw?=
 =?utf-8?B?R1YrWFkrNHZmMUlITHlGd2taVXR2WGdBdWd2Szd6d0xwV3g3V0IwM09NME5k?=
 =?utf-8?B?TUdMVEowWCsvdGtpalRjYjU3SEM5S0d6YXdIVUY2OVhoSzA2WUNXVEQzRlhh?=
 =?utf-8?B?R2FjTFF6ME5keW9lNDViTTU0QThhTWJhcWsyRXoxd3B4NkY1a1JtOXJHR3RG?=
 =?utf-8?B?Q1RhcWdGeXVmd2hlWUx1eVlwYjhRV0xtNWt1ZGpIMjUvVkd5Q1NILzByY2xW?=
 =?utf-8?B?SWNTT3N2cHdjUnAzQnZWOWpBZm5xdk41OXlDRkJLYjg1bGhseXh5cUJ5QkVZ?=
 =?utf-8?B?VnVpR0lxTEFzSmNWNUd5TGl1Ty92RHBKTHBhVjgrb0FwWDF6NzUzR0lQaE1T?=
 =?utf-8?B?ZUtORUJOS3AvaGhqMDJBSXZwRnMyS2VBQSt0aVFESDNIZnU4eDZ2RUxhZSt0?=
 =?utf-8?Q?XK6NLYf4o2+79zEkq6QXJ41K1K5eEaWgyQMlcbbMSQMe?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEJaZDJIc0ZXdHJJeHQwOXp4NUw2QXdxR3drSXE3Z0Nic2RNK2dQTHc5cWRj?=
 =?utf-8?B?OVh0SFJFRDRVMFZUcG4za1Zjc2llN1pBQXhRNDhWcUFUdHM5NUlTcjA4WkxM?=
 =?utf-8?B?b2txNTdEZndJNjFtVHhnd2dBbC84UDYzNUdVSWRZUHNSaWovUGF5V1NKOGFu?=
 =?utf-8?B?TEJEa0FSdVVhaUQwTU9aK3Q4NHZWa09va0IxSlc3a1FoaEJOM0oySllleUdD?=
 =?utf-8?B?aElrUUN6b2hTY3FPeGJOSWhmTHNmbjBqS29IcVNiV3JlSmtRcHU5bHhNeWE0?=
 =?utf-8?B?SVBGRjBSeExIbGZ0ZmkxNGc3bE15ajVvZzQvT2phK2tQRTJQRkN6VEI2blpZ?=
 =?utf-8?B?QmJoTE80M3NWNEQ0a1RkeFgvWnZkc3Y3b3BDc1lubXZNTEwvZGFuWGtzeVZl?=
 =?utf-8?B?dGxHeFNhZnN4VUQycWJ6TVhIVWI4OE9KL0tFL3ZVNzlEQkxYdERRWWJLSmIy?=
 =?utf-8?B?Sk5hdjFicEUzR1lBOFpQMlNpeWFBZFR6QldWL05QRnZEUVZDeVdrcXZXaVdk?=
 =?utf-8?B?M0FHWlhDSWJ6UHNzcFVWSjV4SnVHY3M4NWs1M2VMWDVWdjRDempETHVERWQr?=
 =?utf-8?B?MmZqMkl0MTJ6aDJFSTZONFR4L2xGb1FiK082M24wbTJHNHJKUjNKa1RaZk9Z?=
 =?utf-8?B?VnFoTHl1czJTSWRNWCtoWjd5cUkzV2JTTkM1RGIyUzZRckt6VFU5N0hIOEIv?=
 =?utf-8?B?M3QvNUNHdVd3Z0lkb2x2ckc3blBDb0V2V2tQMmRzY0pPeGY1WnVMUHBOMVgw?=
 =?utf-8?B?QmYySklaTFV4STRrUXdmMTNOZFprT2NJeXYwdHdoNmpRVVNqclBjTWpMOEdi?=
 =?utf-8?B?dkxvUjJuMjJxVWJSL0F0czIxTmVIVGc2MWtVRmZKUmI4NjFlV1FvYmIyeTkw?=
 =?utf-8?B?YndNNTlrZW1tTmtnR2lkcjhCZHZCR09DMjhlNHdqektTbG5Hb2Z5RmZXSnds?=
 =?utf-8?B?cXpkM1lZRE0yQVNPYTJhN29SSFM4c0ZJUGtwSys3NysyK25BUjNlRFJTRmtX?=
 =?utf-8?B?WEZYR2dHSFNPZ0xaUUlHZFo0WkloNWYzd2s5T3dVMW1Db3kzVjMyY3h0WnBh?=
 =?utf-8?B?cUxwNG96eTc2aGhyVzRpRFB1SGFWb1FBd3JmUURDbE52dlpYY3o4WVRLVWxj?=
 =?utf-8?B?WlUxSnV4NFNoM3ZoTFhnS05hRzNKcm1HOWl5bThDSWNTcXNEQTdBVUJBQWpX?=
 =?utf-8?B?dkVjeXpLSEFvSkREdUNOMjF6RGZTcXltSE5keWk2YTFYOG42Zi82S2NHY01v?=
 =?utf-8?B?K2NEWjdjdHIycXVVcXFZcDdSZ2kvZUg4OHROUGVDMitQOXJhUGxCMmMwV2NX?=
 =?utf-8?B?WjZjR2lSYkprYWhXaUI0QkQwQURpZEFSQjRZSGRyT3RpWU9mTzR6eTBxZlhh?=
 =?utf-8?B?YXhnNytTcStxMkJaQlptb2I1aGhQaElrZVg0eVVqMHppODlWeENrWHNBY1N5?=
 =?utf-8?B?VDdTbXoxcjdtSE4xZnd5NnBybkl3UmtKWEVhS3R3bitTeTkrTG5DM3dESlI0?=
 =?utf-8?B?My9wODl2aGxXOFl5bjNVdE93dzVEM3ZNQklRT0d4Skc2NG1XUFRPTjBmRXdj?=
 =?utf-8?B?ekhhVGR4MDdLSGU5RVFUK2QwRGlWMUdzcGRudUlWdEx0eVRZR1ZCTWNoTzJD?=
 =?utf-8?B?WGNQMWlwOWxZRFJKSWx4MTVTRFA1a1hmWEhyU2I0Wlh3dzkvTEFuZ0NvYXlT?=
 =?utf-8?B?UHBxdmJybEZ0dVJEdmV5ekgzeTN2MnkvYjZDYVBHb3V3T3Q0eHhkS29oU2h3?=
 =?utf-8?B?RWMvV0o0dlNEeG9aMjZXNVRTOWlhM3dRS3RUS013Y2poWWlvamcveElpcm5N?=
 =?utf-8?B?dDdFRjNUaW1HTVRNcFVjeldwdktXUWdUOWtHRTlYeXFQakdOaDBUT3QxU3d1?=
 =?utf-8?B?TEFUb1g1cjJKN3NkSG9kQXJRbnc2SERoYnNWeFJqK05Ma05UdWVIR1ZrTGdk?=
 =?utf-8?B?a242aXptVnFPTFpONjBmV3BxVk1aeER1YXh0Q0lDOUk5cXczMExxTVJuRDla?=
 =?utf-8?B?TWtkY20vdFNYZDRUZFdUYXlBY09EU2lrTGJLbEJTR29XZng5ZnpJSDNPd0Z0?=
 =?utf-8?B?dGw2cys4dEFUMjZtcm9wV0FheFdVcHg3N0tDanVBQXlYZFdrVVY5NWQwTTlP?=
 =?utf-8?B?SHIwMEJOcTZyUHg4YXZZRE44VTVQNFI5Z3l2cUFhR3MxL3VKdDhvRC8vTUw4?=
 =?utf-8?B?M3d0djN0S1lnYURBQU9ZcU4wOC8yVVc3anJHTCtmaTlYNnBJTHVBaEIrc3JC?=
 =?utf-8?B?Q1lxVUIvOXJxNTJpam1vcHlJc1RWcU8wV2J1Ync3eWd2RnFjUFdVVTgxSnBw?=
 =?utf-8?B?MlBUZU41aFA3aUNid1hOYnFxYU1jMjMzUUFZbGFoOURTTXR6NjB6aFhRb3dR?=
 =?utf-8?Q?D0X8OOustI+wSL+0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <227C781BCFD62E41820745B73E6B6F47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144673d3-fb26-4091-0540-08de5f5a7d0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 17:18:58.2407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wHovIoRrd0ypD5ymkTDiawnBWPowf2+u7C5b86vAt+9DvJCrq3BU7Sx5Xcjw7j/lTRhpvWOcteRI/iBnptcoas7XYlIyGhoZps6vQ8BOyP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1AF044E07
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69576-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 4CB2BB2C4A
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBIb25lc3RseSwgdGhlIGVudGlyZSBzY2hlbWUgaXMgYSBtZXNzLsKgIEZvdXIgZGF5
cyBvZiBzdGFyaW5nIGF0IHRoaXMNCj4gYW5kIEkgZmluYWxseSB1bmRlcnRhbmQgd2hhdCB0aGUg
Y29kZSBpcyBkb2luZy7CoCBUaGUgd2hvbGUgInN0cnVjdA0KPiB0ZHhfbW9kdWxlX2FycmF5X2Fy
Z3MiIHVuaW9uIGlzIGNvbXBsZXRlbHkgdW5uZWNlc3NhcnksIHRoZSByZXN1bHRpbmcNCj4gYXJn
cy5hcmdzIGNydWQgaXMgdWdseSwgaGF2aW5nIGEgcGlsZSBvZiBkdXBsaWNhdGUgYWNjZXNzb3Jz
IGlzDQo+IGJyaXR0bGUsIHRoZSBjb2RlIG9iZnVzY2F0ZXMgYSBzaW1wbGUgY29uY2VwdCwgYW5k
IHRoZSBlbmQgcmVzdWx0DQo+IGRvZXNuJ3QgcHJvdmlkZSBhbnkgYWN0dWFsIHByb3RlY3Rpb24g
c2luY2UgdGhlIGtlcm5lbCB3aWxsIGhhcHBpbHkNCj4gb3ZlcmZsb3cgdGhlIGJ1ZmZlciBhZnRl
ciB0aGUgV0FSTi4NCg0KVGhlIG9yaWdpbmFsIHNpbiBmb3IgdGhpcywgYXMgd2FzIHNwb3R0ZWQg
YnkgTmlraWxheSBpbiB2MywgaXMgYWN0dWFsbHkNCnRoYXQgaXQgdHVybnMgb3V0IHRoYXQgdGhl
IHdob2xlIHZhcmlhYmxlIGxlbmd0aCB0aGluZyB3YXMgaW50ZW5kZWQgdG8NCmdpdmUgdGhlIFRE
WCBtb2R1bGUgZmxleGliaWxpdHkgKmlmKiBpdCB3YW50ZWQgdG8gaW5jcmVhc2UgaXQgaW4gdGhl
DQpmdXR1cmUuIEFzIGluIGl0J3Mgbm90IHJlcXVpcmVkIHRvZGF5LiBXb3JzZSwgd2hldGhlciBp
dCB3b3VsZCBhY3R1YWxseQ0KZ3JvdyBpbiB0aGUgc3BlY2lmaWMgd2F5IHRoZSBjb2RlIGFzc3Vt
ZXMgaXMgbm90IGNvdmVyZWQgaW4gdGhlIHNwZWMuDQpBcHBhcmVudGx5IGl0IHdhcyBiYXNlZCBv
biBzb21lIHBhc3QgaW50ZXJuYWwgZGlzY3Vzc2lvbnMuIFNvIHRoZQ0KYWdyZWVtZW50IG9uIHYz
IHdhcyB0byBqdXN0IHN1cHBvcnQgdGhlIGZpeGVkIHR3byBwYWdlIHNpemUgaW4gdGhlDQpzcGVj
Lg0KDQpIZXJlIHdhcyB0aGUgZW5kIG9mIHRoYXQgdGhyZWFkOg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtL2RhMzcwMWVhLTA4ZWEtNDVjOS05NGE4LTM1NTIwNWE0NWY4ZUBpbnRlbC5jb20v
DQoNClRoaXMgc2ltcGxpZmllcyB0aGUgd2hvbGUgdGhpbmcsIG5vIHVuaW9uLCBubyB3b3JzZSBj
YXNlIGFsbG9jYXRpb25zLA0KZXRjLiBJJ20ganVzdCBnZXR0aW5nIGJhY2sgYW5kIGdvaW5nIHRo
cm91Z2ggbWFpbCBzbyB3aWxsIGNoZWNrIG91dA0KeW91ciBmdWxsIHNvbHV0aW9uLiAoVGhhbmtz
ISkgQnV0IGZyb20gdGhlIGJlbG93IEkgdGhpbmsgdGhlIGZpeGVkDQphcnJheSBzaXplIGNvZGUg
d2lsbCBiZSBiZXR0ZXIgc3RpbGwuDQoNCj4gDQo+IEl0J3MgYWxzbyByZWx5aW5nIG9uIHRoZSBk
ZXZlbG9wZXIgdG8gY29ycmVjdGx5IGNvcHkrcGFzdGUgdGhlIHNhbWUNCj4gcmVnaXN0ZXIgaW4g
bXVsdGlwbGUgbG9jYXRpb25zOiB+NSBkZXBlbmRpbmcgb24gaG93IHlvdSB3YW50IHRvDQo+IGNv
dW50Lg0KPiANCj4gwqAgc3RhdGljIHU2NCAqZHBhbXRfYXJnc19hcnJheV9wdHJfcjEyKHN0cnVj
dCB0ZHhfbW9kdWxlX2FycmF5X2FyZ3MNCj4gKmFyZ3MpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICMxDQo+IMKg
IHsNCj4gCVdBUk5fT05fT05DRSh0ZHhfZHBhbXRfZW50cnlfcGFnZXMoKSA+IE1BWF9URFhfQVJH
UyhyMTIpKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAjMg0KPiANCj4gCXJldHVybiAmYXJncy0+YXJnc19hcnJheVtURFhf
QVJHX0lOREVYKHIxMildOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAj
Mw0KPiANCj4gDQo+IAl1NjQgZ3Vlc3RfbWVtb3J5X3BhbXRfcGFnZVtNQVhfVERYX0FSR1MocjEy
KV07DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIzQNCj4gDQo+IA0K
PiAJdTY0ICphcmdzX2FycmF5ID0gZHBhbXRfYXJnc19hcnJheV9wdHJfcjEyKCZhcmdzKTsNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAjNQ0KDQpZZWEgaXQg
Y291bGQgcHJvYmFibHkgdXNlIGFub3RoZXIgREVGSU5FIG9yIHR3byB0byBtYWtlIGl0IGxlc3Mg
ZXJyb3INCnByb25lLiBWYW5pbGxhIERQQU1UIGhhcyA0IGluc3RhbmNlcyBvZiByZHguDQoNCj4g
DQo+IEFmdGVyIGFsbCBvZiB0aGF0IGJvaWxlcnBsYXRlLCB0aGUgY2FsbGVyIF9zdGlsbF8gaGFz
IHRvIGRvIHRoZQ0KPiBhY3R1YWwgbWVtY3B5KCksIGFuZCBmb3IgbWUgYXQgbGVhc3QsIGFsbCBv
ZiB0aGUgYWJvdmUgbWFrZXMgaXQNCj4gX2hhcmRlcl8gdG8gdW5kZXJzdGFuZCB3aGF0IHRoZSBj
b2RlIGlzIGRvaW5nLg0KPiANCj4gRHJvcCB0aGUgc3RydWN0K3VuaW9uIG92ZXJsYXkgYW5kIGp1
c3QgcHJvdmlkZSBhIGhlbHBlciB3aXRoIHdyYXBwZXJzDQo+IHRvIGNvcHkgdG8vZnJvbSBhIHRk
eF9tb2R1bGVfYXJncyBzdHJ1Y3R1cmUuwqAgSXQncyBmYXIgZnJvbQ0KPiBidWxsZXRwcm9vZiwg
YnV0IGl0IGF0IGxlYXN0IGF2b2lkcyBhbiBpbW1lZGlhdGUgYnVmZmVyIG92ZXJmbG93LCBhbmQN
Cj4gZGVmZXJzIHRvIHRoZSBrZXJuZWwgb3duZXIgd2l0aCByZXNwZWN0IHRvIGhhbmRsaW5nIHVu
aW5pdGlhbGl6ZWQNCj4gc3RhY2sgZGF0YS4NCj4gDQo+IC8qDQo+IMKgKiBGb3IgU0VBTUNBTExz
IHRoYXQgcGFzcyBhIGJ1bmRsZSBvZiBwYWdlcywgdGhlIFREWCBzcGVjIHRyZWF0cyB0aGUNCj4g
cmVnaXN0ZXJzDQo+IMKgKiBsaWtlIGFuIGFycmF5LCBhcyB0aGV5IGFyZSBvcmRlcmVkIGluIHRo
ZSBzdHJ1Y3QuwqAgVGhlIGVmZmVjdGl2ZQ0KPiBhcnJheSBzaXplDQo+IMKgKiBpcyAob2J2aW91
c2x5KSBsaW1pdGVkIGJ5IHRoZSBudW1iZXIgb3IgcmVnaXN0ZXJzLCByZWxhdGl2ZSB0byB0aGUN
Cj4gc3RhcnRpbmcNCj4gwqAqIHJlZ2lzdGVyLsKgIEZpbGwgdGhlIHJlZ2lzdGVyIGFycmF5IGF0
IGEgZ2l2ZW4gc3RhcnRpbmcgcmVnaXN0ZXIsDQo+IHdpdGggc2FuaXR5DQo+IMKgKiBjaGVja3Mg
dG8gYXZvaWQgb3ZlcmZsb3dpbmcgdGhlIGFyZ3Mgc3RydWN0dXJlLg0KPiDCoCovDQo+IHN0YXRp
YyB2b2lkIGRwYW10X2NvcHlfcmVnc19hcnJheShzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdz
LCB2b2lkDQo+ICpyZWcsDQo+IAkJCQnCoCB1NjQgKnBhbXRfcGFfYXJyYXksIGJvb2wNCj4gY29w
eV90b19yZWdzKQ0KPiB7DQo+IAlpbnQgc2l6ZSA9IHRkeF9kcGFtdF9lbnRyeV9wYWdlcygpICog
c2l6ZW9mKCpwYW10X3BhX2FycmF5KTsNCj4gDQo+IAlpZiAoV0FSTl9PTl9PTkNFKHJlZyArIHNp
emUgPiAodm9pZCAqKWFyZ3MpICsgc2l6ZW9mKCphcmdzKSkNCj4gCQlyZXR1cm47DQo+IA0KPiAJ
LyogQ29weSBQQU1UIHBhZ2UgUEEncyB0by9mcm9tIHRoZSBzdHJ1Y3QgcGVyIHRoZSBURFggQUJJ
Lg0KPiAqLw0KPiAJaWYgKGNvcHlfdG9fcmVncykNCj4gCQltZW1jcHkocmVnLCBwYW10X3BhX2Fy
cmF5LCBzaXplKTsNCj4gCWVsc2UNCj4gCQltZW1jcHkocGFtdF9wYV9hcnJheSwgcmVnLCBzaXpl
KTsNCj4gfQ0KPiANCj4gI2RlZmluZSBkcGFtdF9jb3B5X2Zyb21fcmVncyhkc3QsIGFyZ3MsIHJl
ZykJXA0KPiAJZHBhbXRfY29weV9yZWdzX2FycmF5KGFyZ3MsICYoYXJncyktPnJlZywgZHN0LCBm
YWxzZSkNCj4gDQo+ICNkZWZpbmUgZHBhbXRfY29weV90b19yZWdzKGFyZ3MsIHJlZywgc3JjKQlc
DQo+IAlkcGFtdF9jb3B5X3JlZ3NfYXJyYXkoYXJncywgJihhcmdzKS0+cmVnLCBzcmMsIHRydWUp
DQo+IA0KPiBBcyBmYXIgYXMgdGhlIG9uLXN0YWNrIGFsbG9jYXRpb25zIGdvLCB3aHkgYm90aGVy
IGJlaW5nIHByZWNpc2U/wqANCj4gRXhjZXB0IGZvciBwYXJhbm9pZCBzZXR1cHMgd2hpY2ggZXhw
bGljaXRseSBpbml0aWFsaXplIHRoZSBzdGFjaywNCj4gImFsbG9jYXRpbmciIH40OCB1bnVzZWQg
Ynl0ZXMgaXMgbGl0ZXJhbGx5IGZyZWUuwqAgTm90IHRvIG1lbnRpb24gdGhlDQo+IGNvc3QgcmVs
YXRpdmUgdG8gdGhlIGxhdGVuY3kgb2YgYSBTRUFNQ0FMTCBpcyBpbiB0aGUgbm9pc2UuDQo+IA0K
PiAvKg0KPiDCoCogV2hlbiBkZWNsYXJpbmcgUEFNVCBhcnJheXMgb24gdGhlIHN0YWNrLCB1c2Ug
dGhlIG1heGltdW0NCj4gdGhlb3JldGljYWwgbnVtYmVyDQo+IMKgKiBvZiBlbnRyaWVzIHRoYXQg
Y2FuIGJlIHNxdWVlemVkIGludG8gYSBTRUFNQ0FMTCwgYXMgc3RhY2sNCj4gYWxsb2NhdGlvbnMg
YXJlDQo+IMKgKiBwcmFjdGljYWxseSBmcmVlLCBpLmUuIGFueSB3YXN0ZWQgc3BhY2UgaXMgYSBu
b24taXNzdWUuDQo+IMKgKi8NCj4gI2RlZmluZSBNQVhfTlJfRFBBTVRfQVJHUyAoc2l6ZW9mKHN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MpIC8NCj4gc2l6ZW9mKHU2NCkpDQo+IA0KPiANCj4gV2l0aCB0
aGF0LCBjYWxsZXJzIGRvbid0IGhhdmUgdG8gcmVndXJnaXRhdGUgdGhlIHNhbWUgcmVnaXN0ZXIN
Cj4gbXVsdGlwbGUgdGltZXMsIGFuZCB3ZSBkb24ndCBuZWVkIGEgbmV3IHdyYXBwZXIgZm9yIGV2
ZXJ5IHZhcmlhdGlvbg0KPiBvZiBTRUFNQ0FMTC7CoA0KPiBFLmcuDQo+IA0KPiANCj4gCXU2NCBw
YW10X3BhX2FycmF5W01BWF9OUl9EUEFNVF9BUkdTXTsNCj4gDQo+IAkuLi4NCj4gDQo+IAlib29s
IGRwYW10ID0gdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFtdCgmdGR4X3N5c2luZm8pICYmDQo+IGxl
dmVsID09IFBHX0xFVkVMXzJNOw0KPiAJdTY0IHBhbXRfcGFfYXJyYXlbTUFYX05SX0RQQU1UX0FS
R1NdOw0KPiAJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0gew0KPiAJCS5yY3ggPSBncGEg
fCBwZ19sZXZlbF90b190ZHhfc2VwdF9sZXZlbChsZXZlbCksDQo+IAkJLnJkeCA9IHRkeF90ZHJf
cGEodGQpLA0KPiAJCS5yOCA9IHBhZ2VfdG9fcGh5cyhuZXdfc3ApLA0KPiAJfTsNCj4gCXU2NCBy
ZXQ7DQo+IA0KPiAJaWYgKCF0ZHhfc3VwcG9ydHNfZGVtb3RlX25vaW50ZXJydXB0KCZ0ZHhfc3lz
aW5mbykpDQo+IAkJcmV0dXJuIFREWF9TV19FUlJPUjsNCj4gDQo+IAlpZiAoZHBhbXQpIHsNCj4g
CQlpZiAoYWxsb2NfcGFtdF9hcnJheShwYW10X3BhX2FycmF5LCBwYW10X2NhY2hlKSkNCj4gCQkJ
cmV0dXJuIFREWF9TV19FUlJPUjsNCj4gDQo+IAkJZHBhbXRfY29weV90b19yZWdzKCZhcmdzLCBy
MTIsIHBhbXRfcGFfYXJyYXkpOw0KPiAJfQ0KPiANCj4gV2hpY2ggdG8gbWUgaXMgZWFzaWVyIHRv
IHJlYWQgYW5kIG11Y2ggbW9yZSBpbnR1aXRpdmUgdGhhbjoNCj4gDQo+IA0KPiAJdTY0IGd1ZXN0
X21lbW9yeV9wYW10X3BhZ2VbTUFYX1REWF9BUkdTKHIxMildOw0KPiAJc3RydWN0IHRkeF9tb2R1
bGVfYXJyYXlfYXJncyBhcmdzID0gew0KPiAJCS5hcmdzLnJjeCA9IGdwYSB8IHBnX2xldmVsX3Rv
X3RkeF9zZXB0X2xldmVsKGxldmVsKSwNCj4gCQkuYXJncy5yZHggPSB0ZHhfdGRyX3BhKHRkKSwN
Cj4gCQkuYXJncy5yOCA9IFBGTl9QSFlTKHBhZ2VfdG9fcGZuKG5ld19zcCkpLA0KPiAJfTsNCj4g
CXN0cnVjdCB0ZHhfbW9kdWxlX2FycmF5X2FyZ3MgcmV0cnlfYXJnczsNCj4gCWludCBpID0gMDsN
Cj4gCXU2NCByZXQ7DQo+IA0KPiAJaWYgKGRwYW10KSB7DQo+IAkJdTY0ICphcmdzX2FycmF5ID0g
ZHBhbXRfYXJnc19hcnJheV9wdHJfcjEyKCZhcmdzKTsNCj4gDQo+IAkJaWYgKGFsbG9jX3BhbXRf
YXJyYXkoZ3Vlc3RfbWVtb3J5X3BhbXRfcGFnZSwNCj4gcGFtdF9jYWNoZSkpDQo+IAkJCXJldHVy
biBURFhfU1dfRVJST1I7DQo+IA0KPiAJCS8qDQo+IAkJICogQ29weSBQQU1UIHBhZ2UgUEFzIG9m
IHRoZSBndWVzdCBtZW1vcnkgaW50byB0aGUNCj4gc3RydWN0IHBlciB0aGUNCj4gCQkgKiBURFgg
QUJJDQo+IAkJICovDQo+IAkJbWVtY3B5KGFyZ3NfYXJyYXksIGd1ZXN0X21lbW9yeV9wYW10X3Bh
Z2UsDQo+IAkJwqDCoMKgwqDCoMKgIHRkeF9kcGFtdF9lbnRyeV9wYWdlcygpICoNCj4gc2l6ZW9m
KCphcmdzX2FycmF5KSk7DQo+IAl9DQoNCldoYXQgeW91IGhhdmUgaGVyZSBpcyBjbG9zZSB0byB3
aGF0IEkgaGFkIGRvbmUgd2hlbiBJIGZpcnN0IHRvb2sgdGhpcw0Kc2VyaWVzLiBCdXQgaXQgcmFu
IGFmb3VsIG9mIEZPUlRJRllfU09VQ0UgYW5kIHJlcXVpcmVkIHNvbWUgaG9ycmlibGUNCmNhc3Rp
bmcgdG8gdHJpY2sgaXQuIEkgd29uZGVyIGlmIHRoaXMgY29kZSB3aWxsIGhpdCB0aGF0IGlzc3Vl
IHRvby4NCkRhdmUgZGlkbid0IGxpa2UgdGhlIHNvbHV0aW9uIGFuZCBzdWdnZXN0ZWQgdGhlIHVu
aW9uIGFjdHVhbGx5Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzM1NWFkNjA3LTUyZWQt
NDJjYy05YTQ4LTYzYWFhNDlmNGM2OEBpbnRlbC5jb20vI3QNCg0KSSdtIGF3YXJlIG9mIHlvdXIg
dGVuZGVuY3kgdG8gZGlzbGlrZSB1bmlvbiBiYXNlZCBzb2x1dGlvbnMuIEJ1dCBzaW5jZQ0KdGhp
cyB3YXMgcHVyZWx5IGNvbnRhaW5lZCB0byB0aXAsIEkgd2VudCB3aXRoIERhdmUncyBwcmVmZXJl
bmNlLg0KDQpCdXQgSSB0aGluayBpdCdzIGFsbCBtb290IGJlY2F1c2UgdGhlIGZpeGVkIHNpemUt
MiBzb2x1dGlvbiBkb2Vzbid0DQpuZWVkIHVuaW9uIG9yIGFycmF5IGNvcHlpbmcuIFRoZXkgY2Fu
IGJlIGp1c3Qgbm9ybWFsIHRkeF9tb2R1bGVfYXJncw0KYXJncy4NCg==

