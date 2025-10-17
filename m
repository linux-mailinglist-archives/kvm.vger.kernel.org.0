Return-Path: <kvm+bounces-60433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03021BEC5F9
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 04:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 942E71A65A34
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD902765D3;
	Sat, 18 Oct 2025 02:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8upFP6A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86722737F8;
	Sat, 18 Oct 2025 02:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760755711; cv=fail; b=f4oQ9OMkOY4qk25JHPC2uj3CCGT1l5mXOmIS6bihXEVGoG4zuBPdBLKPNu7+S3/tFVgb7otQO4r4h7SqYysB8KX7i5xvH6lyU06uq7+8bW3CsiDUBphyGaQGxgb8jnVoqFFw4RsmGCQvBMAHWyUbs8P3yrUcR/EP7mUL+VtwvIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760755711; c=relaxed/simple;
	bh=QStMlFeXt+Ad6d4kXPkC/y7pd7h28g4rU/anCNjrS18=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qby1Zu3O8X2B/+wgKJGUPpJEIWF6TM93fc800ItxW14jMefABqz7dA4THMct2oaIhQ0XachezR96t07miG9+TauII1Hvw5fHf+N3o3CJhbkif8Naxn0ZDT4tKzCTy2tObiw5gNI4qDTq42R5QoOzxEumxfpBpHRAemEx31d39QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8upFP6A; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760755710; x=1792291710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QStMlFeXt+Ad6d4kXPkC/y7pd7h28g4rU/anCNjrS18=;
  b=b8upFP6AtYhbHhebRb8a8D7hGcNOlk+CP6nuuBODALAX9B6anZjZFo4G
   cQoMmdVvDbxfUVLKSnuZcSrfXpeePs0J42LDMxAwhxZNS4XBi26k65bUV
   NDz7ALawNY9GcocGNKTydzBUyNWBfBwKnosBWKaRgZ0A1qqKTEB2+t9Qb
   XBPZOpDzBYmIATCn8uvV3Z/qmaJiWVCcNWc/DYfolKR9X0Lzoeb9uJbbs
   35pjLVkYPVal3jzoDfL3RH9S8/1Rzfb5jnzlytIoltbMiHaIt7Jt4kZ95
   mYEqt2Bvavi8TPk9i4EzazlGJcI1rA4dodrUJThyY5o2c+Xj6j2c88OEe
   g==;
X-CSE-ConnectionGUID: buFBk67YT/eAX9BOSADa+g==
X-CSE-MsgGUID: AHSJI4TcToG7UlCsrpcZWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="50541593"
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="50541593"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP; 17 Oct 2025 19:48:29 -0700
X-CSE-ConnectionGUID: CJmipqZYSHSXPxNnn5yIRQ==
X-CSE-MsgGUID: 6w/RNXCiTbiXchwBjPy2Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="182818780"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:48:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 13:58:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 13:58:37 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 13:58:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/Q6LfM4m/+HPyj89UhByCkmCG9v37TyUU9rT+mgHczeYeOuJOKUu408jobtCkAY6FzBHDyYTWNhu8uqBHEaRZnv3MOlayhb5JU4bKG4M38YwxujSzOsFAUU+JR7WfIvGNC3GkyV2qudX/ONR0p8XKaT2/0bzvp4ojfhCL/c5qRUOftX70h4j6IiH8ZrfUiv6sxO+vE0K/0vh1g25QsLxIWZQ7OlD1yZh94G4Szttki+1n9dacIrCORCfdMevBS5mt3CWo0uvcZNTMu8KV49/fiUjTkuWh1iY8vV9rRmq+Hsy9glb3kJCIZiPZ2FK2bHKfLY4DXxLW59cohiDtG6aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QStMlFeXt+Ad6d4kXPkC/y7pd7h28g4rU/anCNjrS18=;
 b=YXomGUjBmzQwT+KRJHffi4+ubX1hpyZ52dwtdn8FvgRFLF1NSmKAtpE2IeSIK17OKGSmG3f7acoBGpvcMekx9u33J2Ke2MD41xGG1cunzboui8RS4kBI8RWWJYXoFMW02QkK1n9JovMitKIC5xJ3rx0py0Ummkx09S0Zl0ghCt8w7sQ7bEW0kOs+ENuMm2sga76RKeSnJJC1h5YI4whKJKW2hQjZ8UPgOTfEa+uqy4pvs5biiZNRmXvdmue1zQtH4sBdquRi2aIY+EQ1eucIrnR7GTPG/UNEU42HiPdrhsK+klmXDSpcWKcpOqYyMIUiaQPmaGDcUvDsgi7IFy22iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB8802.namprd11.prod.outlook.com (2603:10b6:208:598::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 20:58:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 20:58:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
Thread-Topic: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its
 way out to KVM
Thread-Index: AQHcPsnJasRrDnCPH0SaPtwK/HwoHLTGJ2uAgABxC4CAADuPgA==
Date: Fri, 17 Oct 2025 20:58:36 +0000
Message-ID: <38ac916f7c3ae7520708f37389f5524d9278c648.camel@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
	 <20251016182148.69085-3-seanjc@google.com>
	 <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
	 <aPJ8A8u8zIvp-wB4@google.com>
In-Reply-To: <aPJ8A8u8zIvp-wB4@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB8802:EE_
x-ms-office365-filtering-correlation-id: 0ed25f15-3753-4ad0-4ef9-08de0dbff0a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NGM3L3NNV1pucW9TYzN0cjlVNS9DNk5vS2VCRUxSeXBXL1dLbG5nWVN6Ry9B?=
 =?utf-8?B?ZDcvQ0FXNFFIaXh0WUtxUHR3STFPUXgvK1lrdndFem1EUnlyR1l2VkdtUlRS?=
 =?utf-8?B?QjV6d2l4ZE82bHc4UXArSXpZSnRaS01MR2VxRmVETzFVaUZTZkgyQjk3R1Y4?=
 =?utf-8?B?UVlLcCtLQWNYOHhWc1lSYmV3QWR1M0Q3d3JVTktFQytDWHVJYkh1WG5rU0xV?=
 =?utf-8?B?Wi92SG8wc1gwTTVHc1p1SXBYNE5oczZGRktuSDI3UlhGV0llaXdsMUJHaFdp?=
 =?utf-8?B?RGdkSTNxcExHekJQRHV0OVJUTTVxUTI1eTFIWTJqZERlcnBGc0lvOXM5clJJ?=
 =?utf-8?B?d1phQ1YvSUxFMzhETTJLa0VzWTZXNVdwWGZBbHZTcVRxTEpuQUtRM1BWelI4?=
 =?utf-8?B?cG9qb2JnQVErbXh1MkpRTjRZbFJ1Zjg3ZWlYeHRCMVRRU2xISFVPMlpYaGp2?=
 =?utf-8?B?MVNVMTV3Rnk3L3kvWUQxVXpjSzlmNlB0QU91SlBpSG9pNFVTZUFYaXkxdCtD?=
 =?utf-8?B?Q21kWjQyc2Y4NER0bFhoTkR0ajRKWFlVZ0FsejFjY1hMVmJuVkxNL091Q3M0?=
 =?utf-8?B?eUx5aDcweldKc0h4QkNvQjkwd3NQSk5pN1lzU3ZWL0lCSHNaUklUWlJxLzNU?=
 =?utf-8?B?ZTVaNWJiclV1WlpLUElmd2d5RldaMjV3SGVYNXErTHg1WU12MFNWME9JWmtY?=
 =?utf-8?B?Q0RoWU5admxHS2g4SFh0cXBFWnk4VWRWY011ajloSHVjTXU4NjdUSE1yYmsr?=
 =?utf-8?B?THJNNXB3eU1aTUhwcTAzMmtUYnJFOHlTTlVIMmtjamV0c0FjbkRYOTBFNUxr?=
 =?utf-8?B?OThseklqWGUrQ00xeTZlblIxVzcxcW5WV1JjdDNWSDRRcmpHb1QzUllVa2tk?=
 =?utf-8?B?YnNQUE53RVlYb0cvVlY3NFF3WkZLV0EwRngwSHE5ajB2eVdtVGhmQ2RIczU1?=
 =?utf-8?B?Z0p4SmFYa1RCWXNOazVlMUFGTHBOOHRodGk0aVhmVHZIMTZFZ1Y2dmNFMEVh?=
 =?utf-8?B?QU56ZmVzSGdEL2JoRy9menJ0dm5ZdDhLb0F5UVlDY3AydHpYSjZHNEtnek5r?=
 =?utf-8?B?N24rMVBjeFl5WDYvNWRGeG1vTkpUbU9Pd01ueEZvamM4cEVqdGJ0cXBnUUs2?=
 =?utf-8?B?bmp5cXBmTUR0R1Z6VGZzbG5NbjVNU3FOejNUZlllVlErZmNNdzNGdng3MEp5?=
 =?utf-8?B?V2YxMDF4RWJyS2Voa3RkNXFHS25PeC9OQ01yVlpTUkZhclFyVHFpMGVDV0Iv?=
 =?utf-8?B?ZE1ROWRnWnB5aVh1cVJieVk4djZqUW1YbWN6ZTlzUjREclFlOVRsblQweC9h?=
 =?utf-8?B?dTd1cDlZQXhEQmUxWjhwUml2QURkaHBmbnlkV1FtelpOREh3ZVZUekMrTkhs?=
 =?utf-8?B?eCtGV1FYMzBnVTUveGJ1M09rQm96cUNYY2p1cXQ4YjlQdkdWYkhNNklpbzk1?=
 =?utf-8?B?OG8wMWFoYXJiQkw5U0ZyeTNmMGVpQXZ6NWovL2VJbC82NUM0ZVdwS3JtQTR6?=
 =?utf-8?B?TDBzdlRTMFVDNnlDZEE5c2lDazNVTmFqaTNITkljak5oc1VVemZJTVRXYk5C?=
 =?utf-8?B?bmxORjI2emRrTEFQTzBkRGpFOXBqNnJUODNndVc3aS8rNHI1L2tJVU83MWJL?=
 =?utf-8?B?WSt5UjhzT01EQzR0eldMeG42eFNnajJOaTBXdHJsZzN5aXNSSnJEeEJ5RUpw?=
 =?utf-8?B?Uit5Uk5RYjdBK01aelE1ZXVQdGtJdi9FYjFSSjU1SjgvN1NEeTFDYitlU29O?=
 =?utf-8?B?TTNxcXQxZWZUQUdoTnVIOTRkVDVkU0p1cUxEZExOQTVKNmRGSGlEMmF2SXRC?=
 =?utf-8?B?VDNQWDNrR1NBN3VpUGV1aWtaNGJ4ZW8zTUpEdkgxZXdUblRRV0JCRS84TUVt?=
 =?utf-8?B?OGVSbnVPUEdldUUwelVlRTZpS3Rkdlg3WXFQRVFYTFVXTktGSnd6aU55dzFy?=
 =?utf-8?B?WE9Ua2U2akRrdUl4ckRsMm1yaHlUREk3bm4wdkNic1dSVzlLZnc1MVZlUDBV?=
 =?utf-8?B?QmtQM01jY0VTcE1vZy9tUzBVanhCT0Q2YWFnZnV6WHRrOFloOHVJYUlCbjlK?=
 =?utf-8?Q?RkB3r6?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnhHejM5RDdkbWY0eDMzZmpmNHNYSXI3OEtXM01VQ3QwY092MVF2WEFaa0Yr?=
 =?utf-8?B?MGpPUXltMThNRXFNS1MrTjlKSDNtR1U0a1UvQTR2UTNDNnZWNDU2VXU5amwv?=
 =?utf-8?B?UmdGRWdkQVdBK0wxR0RRRFBrWjZPUU9Wc1ZuUyt4ZDNkRHJSZm0waGF2Tks2?=
 =?utf-8?B?Mk4zN1AyT0JXS0hZd3RIZHJJVm9oSktlZ1l4Q1BPbFp0Q1NVU2ZwRmNLdG1P?=
 =?utf-8?B?bHNmK3NETzBJTjUwNVI2VHlrRzNqMGNtSGIwZXFjYk55VzNNK0pCemNZQXpE?=
 =?utf-8?B?cmdidWVyTHFVUzFVYXR5QjdpNkYyMDVWRlJuM1pIZC9EUktILzBkM1l6M1Rr?=
 =?utf-8?B?NStyc01DcWJZRGovcFZXcEpqRG9FSWdmNXZ1SlpYczFqV3VPcUVrZ09KcE12?=
 =?utf-8?B?YitPb3lYdjZKRlhCZGtzYTdCckM5WlM4MHpaMEpuZzJZZ0ZrUXRFeHU3ZjdM?=
 =?utf-8?B?QUViQWVVdy85TDg4enNLTWtOYlNYRHZnUldBY0ZlWUl6VUJqR2RyU0tQcjFQ?=
 =?utf-8?B?TWExeWVPQ29qOUxHYWQyKzZLZ1FhWkh1dmVISmdleDExT2FVMTQwRE5aVm00?=
 =?utf-8?B?UEYybHl5encwOUpVRWExWDlOSEFBSDNRZlVCRmYvTkN6T094SkVwNWdSNnI2?=
 =?utf-8?B?VXM4YWFQQVh0dFRWTVNpd0g2ZHNEZVA5WFdvUnlzYlJkeVliUEczZ1dpM1lG?=
 =?utf-8?B?cnhJZlBVVjh6UndQTVkvUTR2YkJwWjFwQ05XZG5FdWxPaXZmNkJHUkV6bXBr?=
 =?utf-8?B?SXFVN0szaXYwa1U0ZkVwcWZUaHJCVXV1WHJuQ2JMajZwczRmQXJLZEQvK1Bm?=
 =?utf-8?B?czUxakF5WXdyZ2t0MDB4NzBvR21qY0lKdTBxeUVjaFo4c2NDZkF5Uk8vMG1I?=
 =?utf-8?B?VE5hRGlJaUU4Sm9aS3c3WGpzN1QwS1N2ZDArb2pQUjRqUmFvY3hmTWM5b0Ny?=
 =?utf-8?B?dGdLNVloUG9LUkNXa09NRHhTVnRHN25uMDdoa0hONTFoN1RLdnYweTRkOW13?=
 =?utf-8?B?eURQZXpBMmpoQkN0bVpoeW9OWUpkWlBYWDRJditTZUdzUW5oVjRnM3NEZjI4?=
 =?utf-8?B?SFRsVnJpanE4QmxaU051MkJEYVREUExnYnZVTGVEeFdsR0lRYXBsclRYbWV5?=
 =?utf-8?B?cXNqdEpPS20wZHRXTHhXVkpCc1lwTTh3WVljN0dORmVxY1dlNFFvY3BPTExI?=
 =?utf-8?B?T3laT0pjcWlLOXRVc2NOVThzbVl0MmhLMGRWUnN1bmpiaXBrOElySWxtWFFK?=
 =?utf-8?B?VlFlOStpWjIxWHNHamI2NytleUliTmFZSmljRldlOHF5bjlMNHR6MjY2Y2RG?=
 =?utf-8?B?RG1uaGErcjhISTVadGg5WTBvWnlJZlprdjBNK1FWTm8xdm9kT3RSaTRjTVdO?=
 =?utf-8?B?YVluNmd5MXllOGc2VFF6cHZ5R2NaMVRtVHhqRk5GakF4YTlSTjBWZUV4aHNG?=
 =?utf-8?B?YnFUU0JqeXZlT0w3NHdkejZRM0UrZkMvVTRjM2RJbTg2YkQ5STNuaTBQamJP?=
 =?utf-8?B?QTlqM1grMVZFaU14ckFyeEh0UktreFZLZ0hmUXFjMTI0alZtSjRVanphR1VB?=
 =?utf-8?B?UmYzbGVFc3RTYWs1UGI4ajJHdjhGc2hpMjBJSVAvM1lpOFFKWWh3OWRpb25V?=
 =?utf-8?B?OUtwVUNsRXc5dXhVMWVmRVFsRVVtNjA4RmVQMkxUVEdnbFlrSEkvVGM1ZVFG?=
 =?utf-8?B?QjJYTmRERDliRGtiQ2JXcGgwb1JNYjI1bGpwYzVGSEJiVlNyNC9ReitmSTJq?=
 =?utf-8?B?ZkYxK2ZodjZ6RmdlTm16V25JY3liVjEyQWU3cCtXSVhjZk9sNGVUWFgyY3VY?=
 =?utf-8?B?WW5RUjhDa2RkY3F3c2JTUExzRjVDRkluYzJnM3JJanVFdndJZUJUdkFGMXor?=
 =?utf-8?B?bzhpUmtUcmd4MXJYQUsxa1RuY3Jvbm9xUVpqQTB2U1F2MXJ0YjJVbFF4OWlC?=
 =?utf-8?B?YUtTS0xnOC9TM21UaS9HMnMwZDg5Z0gxZjRhWks1NnlIL0xJcjhGTVpkb0FO?=
 =?utf-8?B?ZHBHVWsvUWs0MVkvOXN3QXROMzdFUjRFa0VXS3dXa21XQTdaRUdWdUNqMndM?=
 =?utf-8?B?bUNJQVBvYUljZEVXUTRiZlFHN1FhS3p3emh2K29mNlFMUCt6bUNXTDFNOWpw?=
 =?utf-8?Q?vNPpaA5/dneWpP6vxOsKf8/7w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C3971A7BFCBE54CA46FBBB1F3B928AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed25f15-3753-4ad0-4ef9-08de0dbff0a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 20:58:36.0420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vss0CWWPQWLHjsuZ4K3CN/Y1bt99xSPqnrBu8oMqOLNDU+6ibWk5j6HhLiuG1asZR1K2PGI2NodXrvIxrb9k8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8802
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTEwLTE3IGF0IDEwOjI1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIE9jdCAxNywgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0xMC0xNiBhdCAxMToyMSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFdBUk4gaWYgS1ZNIG9ic2VydmVzIGEgU0VBTUNBTEwgVk0tRXhpdCB3aGlsZSBydW5u
aW5nIGEgVEQgZ3Vlc3QsIGFzIHRoZQ0KPiA+ID4gVERYLU1vZHVsZSBpcyBzdXBwb3NlZCB0byBp
bmplY3QgYSAjVUQsIHBlciB0aGUgIlVuY29uZGl0aW9uYWxseSBCbG9ja2VkDQo+ID4gPiBJbnN0
cnVjdGlvbnMiIHNlY3Rpb24gb2YgdGhlIFREWC1Nb2R1bGUgYmFzZSBzcGVjaWZpY2F0aW9uLg0K
PiA+ID4gDQo+ID4gPiBSZXBvcnRlZC1ieTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5j
b20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gveDg2L2t2bS92bXgvdGR4LmMgfCAzICsr
Kw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gPiA+IA0KPiA+ID4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5jDQo+ID4gPiBpbmRleCAwOTczMDRiZjFlMWQuLmZmY2ZlOTVmMjI0ZiAxMDA2NDQNCj4gPiA+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvdGR4LmMNCj4gPiA+IEBAIC0yMTQ4LDYgKzIxNDgsOSBAQCBpbnQgdGR4X2hhbmRsZV9leGl0
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZmFzdHBhdGhfdCBmYXN0cGF0aCkNCj4gPiA+ICAJCSAq
IC0gSWYgaXQncyBub3QgYW4gTVNNSSwgbm8gbmVlZCB0byBkbyBhbnl0aGluZyBoZXJlLg0KPiA+
ID4gIAkJICovDQo+ID4gPiAgCQlyZXR1cm4gMTsNCj4gPiA+ICsJY2FzZSBFWElUX1JFQVNPTl9T
RUFNQ0FMTDoNCj4gPiA+ICsJCVdBUk5fT05fT05DRSgxKTsNCj4gPiA+ICsJCWJyZWFrOw0KPiA+
ID4gDQo+ID4gDQo+ID4gV2hpbGUgdGhpcyBleGl0IHNob3VsZCBuZXZlciBoYXBwZW4gZnJvbSBh
IFREWCBndWVzdCwgSSBhbSB3b25kZXJpbmcgd2h5DQo+ID4gd2UgbmVlZCB0byBleHBsaWNpdGx5
IGhhbmRsZSB0aGUgU0VBTUNBTEw/ICBFLmcuLCBwZXIgIlVuY29uZGl0aW9uYWxseQ0KPiA+IEJs
b2NrZWQgSW5zdHJ1Y3Rpb25zIiBFTkNMUy9FTkNMViBhcmUgYWxzbyBsaXN0ZWQsIHRoZXJlZm9y
ZQ0KPiA+IEVYSVRfUkVBU09OX0VMQ0xTL0VOQ0xWIHNob3VsZCBuZXZlciBjb21lIGZyb20gYSBU
RFggZ3Vlc3QgZWl0aGVyLg0KPiANCj4gR29vZCBwb2ludC4gIFNFQU1DQUxMIHdhcyBvYnZpb3Vz
bHkgdG9wIG9mIG1pbmQsIEkgZGlkbid0IHRoaW5rIGFib3V0IGFsbCB0aGUNCj4gb3RoZXIgZXhp
dHMgdGhhdCBzaG91bGQgYmUgaW1wb3NzaWJsZS4NCj4gDQo+IEkgaGF2ZW4ndCBsb29rZWQgY2xv
c2VseSwgYXQgYWxsLCBidXQgSSB3b25kZXIgaWYgd2UgY2FuIGdldCBhd2F5IHdpdGggdGhpcz8N
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3Zt
L3ZteC90ZHguYw0KPiBpbmRleCAwOTczMDRiZjFlMWQuLjRjNjg0NDRiZDY3MyAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5jDQo+IEBAIC0yMTQ5LDYgKzIxNDksOCBAQCBpbnQgdGR4X2hhbmRsZV9leGl0KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgZmFzdHBhdGhfdCBmYXN0cGF0aCkNCj4gICAgICAgICAgICAgICAgICAq
Lw0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+ICAgICAgICAgZGVmYXVsdDoNCj4gKyAg
ICAgICAgICAgICAgIC8qIEFsbCBvdGhlciBrbm93biBleGl0cyBzaG91bGQgYmUgaGFuZGxlZCBi
eSB0aGUgVERYLU1vZHVsZS4gKi8NCj4gKyAgICAgICAgICAgICAgIFdBUk5fT05fT05DRShleGl0
X3JlYXNvbi5iYXNpYyA8PSBjKTsNCj4gICAgICAgICAgICAgICAgIGJyZWFrOw0KPiAgICAgICAg
IH0NCg0KTm90IDEwMCUgc3VyZSwgYnV0IHNob3VsZCBiZSBmaW5lPyAgTmVlZHMgbW9yZSBzZWNv
bmQgZXllcyBoZXJlLg0KDQpFLmcuLCB3aGVuIGEgbmV3IG1vZHVsZSBmZWF0dXJlIG1ha2VzIGFu
b3RoZXIgZXhpdCByZWFzb24gcG9zc2libGUgdGhlbg0KcHJlc3VtYWJseSB3ZSBuZWVkIGV4cGxp
Y2l0IG9wdC1pbiB0byB0aGF0IGZlYXR1cmUuDQoNCkRvbid0IHF1aXRlIGZvbGxvdyAnZXhpdF9y
ZWFzb24uYmFzaWMgPD0gYycgcGFydCwgdGhvdWdoLiAgTWF5YmUgd2UgY2FuDQpqdXN0IHVuY29u
ZGl0aW9uYWwgV0FSTl9PTl9PTkNFKCk/DQoNCk9yIHdlIGNhbiBkbyB0aGluZ3Mgc2ltaWxhciB0
byBWTVg6DQoNCiAgICAgICAgdmNwdV91bmltcGwodmNwdSwgInZteDogdW5leHBlY3RlZCBleGl0
IHJlYXNvbiAweCV4XG4iLCAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgZXhpdF9yZWFz
b24uZnVsbCk7DQoNCk9yIGp1c3QgZ2V0IHJpZCBvZiB0aGlzIHBhdGNoIDotKQ0K

