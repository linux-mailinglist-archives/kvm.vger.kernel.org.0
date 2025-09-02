Return-Path: <kvm+bounces-56627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D4DB40D66
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 20:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 129F1560732
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 18:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F29834DCE4;
	Tue,  2 Sep 2025 18:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ndDWG55j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB52324B2D;
	Tue,  2 Sep 2025 18:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756839316; cv=fail; b=JN1p7McRx9WONcdqyi+swGc36S9p4z8lS/qMFcz3BDTzrKNuBUMJbaq8onRUL7iahK6TDUjFNhMGNk7QE416T3hk2mKDypcQiXkrnKAwfTUhooJVxHQdRfmF7ZC7LQqtB1s7u0z1QlSX4wrBuDYb/+nt5FF3Xt22Yf3zJHFSL8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756839316; c=relaxed/simple;
	bh=0y3ha7cRNUCD49oSuut6eipbc2IWCiCb+Tv+Rd3+KXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bqT1iAnBpNdEIjyaO0tP84IkNW5AeAI3ZsruqA+BabfGEISS2cwm5a1LYrwoP23gI71PCqeSX/zaq5Hj7os3opZ7a4j0ZB3qhxd1Jr6q1RcQxJCxAGM2gAPnh7skER57PWHbKbahn8prvlE4O84Qoiw3RA5eNwNWnqTp7ZknqtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ndDWG55j; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756839315; x=1788375315;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0y3ha7cRNUCD49oSuut6eipbc2IWCiCb+Tv+Rd3+KXU=;
  b=ndDWG55jT6LsKs+kDMK7vN0vmLuLCGIUdiuJvQWj4tpKqblmZe1dmdXM
   WQyCYPysaiW1g201yi/4mrixFkQdbkKE8X2923p1w62wO4Pza/uL4Y6lW
   gjmHBKyXNBz7zzutuZNY7zVNekaq5hY7jX4J/j66Rf3tPsozBtsjHwr4F
   lcElmZMcqEdXZAS/15f+Hk6JEYwIni5mi5Qb9PQYZgSA4KyZzTBYKiiLD
   6DMeLFE2gwAV169jSkGk/umlGKwFyc6g41sh+ISrvw/VSYWlDDR0nuHB/
   f3Ii/2QWlgFEvh5ZWpVguPp2R7ISp4eh76I0VRzX+vgntJFmziTQnWhVO
   g==;
X-CSE-ConnectionGUID: 5zOlfpdcRs6vdYZXjqCFRA==
X-CSE-MsgGUID: Ebw5414+Rmagon6d9cHP/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="59265258"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="59265258"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 11:55:14 -0700
X-CSE-ConnectionGUID: CIFnYg12QgSwMahzXrrNkw==
X-CSE-MsgGUID: BbeYFQzlRD2UkRGTs+q3/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="175728969"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 11:55:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 11:55:12 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 11:55:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 11:55:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6Yp6DYx9VWm3m5PlxVotm9vJYdRSpXLlx1ROjBeDU2CLUe6qxUO4SuaeYbZJewAh6YvHC19VV7Ub0JJ777r95uXXz5Skhdr1tUjctqH1HUKmW9Inz6ZSY363uc5QQ3+AmYDRSE/+zl/QsqhA9XXYo3kSJ+QZoSqh8jEhmBYUpPt5511PbMTvP9QvNzN8b+pXtg3DXeqVGNT6UuFCmazPlkFzYu8/s3c6ruEXFB+ervc0woHdETVI0yAj31H1uBTcc3P83W68ACTcOQ/eN4b73SJGYQb2nTBwumJP1R4k83jEpMY/Lav5P4FxEMX6LFSw6XkQxBtZBmM209/vI83/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0y3ha7cRNUCD49oSuut6eipbc2IWCiCb+Tv+Rd3+KXU=;
 b=GJhYxsYfLCbR0rA46sino3xUfDf0rOVnrpXoiJAr4MgsyuMEIwdLhDHKodR4dIf9BiwbYSgZSGpVFgOZGjcL5PC2gu4+JlUm54PpI/APOp2kIAtKtxkXckazp0I2bbx9EMRKrWK21RLWvclk6+4ucaUC1tsRCBpJyv9vtAZOt2bmUuPHhQM15UVAAkGn6GM4kAVJRQRw4sQ0XpJldxm63sKJOE8ZZdIlJUBJ+ZbJRz2k6Gj61UGWo+pl8Q3f4N1Dt9tcOjz7jwcP5Jpkr5KVjvM92JmJzYQShiOvxfc+INIXeey81VGvC7Pu5ZNPt2UHckpxTaM4pnxDEM8uTPArJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7116.namprd11.prod.outlook.com (2603:10b6:806:29b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Tue, 2 Sep
 2025 18:55:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Tue, 2 Sep 2025
 18:55:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 15/18] KVM: TDX: Combine KVM_BUG_ON +
 pr_tdx_error() into TDX_BUG_ON()
Thread-Topic: [RFC PATCH v2 15/18] KVM: TDX: Combine KVM_BUG_ON +
 pr_tdx_error() into TDX_BUG_ON()
Thread-Index: AQHcGHjXBDKbwuufU0WJU6wIibQWj7SART6A
Date: Tue, 2 Sep 2025 18:55:06 +0000
Message-ID: <4b1fe5da252b186f0ad4715c46f32e18b735a9bf.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-16-seanjc@google.com>
In-Reply-To: <20250829000618.351013-16-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7116:EE_
x-ms-office365-filtering-correlation-id: 3383ae06-6849-42a8-00b0-08ddea523b9a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MXdkVGxoMVVoYUYrSC9SVGV2bU5XVDk3bUFrTmxkWGNhY1NKL1p6NGp3ek96?=
 =?utf-8?B?bndZa3d2NnhLQVRHa3Fod1VTdS9SUjBUeWF4dVVzaXQwdlg3TUFMZ0I0Y3lL?=
 =?utf-8?B?ZW5rZkVIUkhIaUo0RmRKM29YZWxpcUZKRmFiYzc3RFBCcEM2dmk3L2JES1c2?=
 =?utf-8?B?VlFpbEZvVlQ4c2ptZGMwR2RjUUJTb1Q4Q0t5cG5HNmxvSEhGMjBNUnN5Ni91?=
 =?utf-8?B?VTNVaWRZUXRWMk00djRDWU41THc1Q003RW1zSmVMUnlHQytBQ1Q0SmFoRnhx?=
 =?utf-8?B?WmhTQk03dG5RZm9CMmpQVVFSa0MycWlIVFE3QkZ4UTBwb0JNd0hnODdJVHFo?=
 =?utf-8?B?TUhRSnZlaEZEMk1DVkNnT2RpTHNxNXVUdExVZzcwd2wveTZLdHAweEttSElY?=
 =?utf-8?B?bGVka3hvcndJdkgvMGVGbWw3R2FCTlphelkzWFlWdFA3MjBYaDVDV0J1WVE4?=
 =?utf-8?B?QlVoZFdaNlc3NjhycFZLNExlTVY2cWYvMXBGZC9zVmpOekpuTFJmQkRGWUpF?=
 =?utf-8?B?S2haRzg3b0M4Qis5eDR6Nmptb1p4d0I5VklKd0JJM042K1ZSUjhUSzNJc1ow?=
 =?utf-8?B?Sk0zbVhyRUdacFpBMk16bmRsbHVXUVAxTFprMGYwYTd5UnVJbFNUcnN1QUkx?=
 =?utf-8?B?b1pRWUNJTWhOdXRnZGxldTl2akZYdjRCaGZCVkgrZEJaREtwL1gvV01ibEZB?=
 =?utf-8?B?R3dkZE4ySE1mTHBGOENiY2xaYVQwazZ3WkZCb2dQYXhDaVY5b3ZYc09OSHRT?=
 =?utf-8?B?dFJNQ0QxdCs5ckZONnhSZFJEZzkvVTlCdmdTbUo1eUFkNk81MTI3eVdKRGxq?=
 =?utf-8?B?eUphd2M5OXJudnBMbEY3TXNqem9YakFHOVRidjFiQkNFdkpibGhGYWRBVlJi?=
 =?utf-8?B?LzFDTHBLVjI2aktrMXV6NDBSaFo3UW4zaDFpWXBoNXRrZCtVRThMaklBbDda?=
 =?utf-8?B?WDk0Z2RpM0ppb0dYYTZ0cmtWR3k4N3dvUVFta2haV3kwZmJTak5HazJFdmdh?=
 =?utf-8?B?bUhQR1Zham9QWG1hZGVYYWdzL3Frc0F5UnlrZWd4aFZBUDg3c3JBbDZqTzE4?=
 =?utf-8?B?TVlJejhQOVN1b21ic2hnTGdkaTJMc0kyWmVqMUZaYWx3c2tHc3pOb3cyTTZi?=
 =?utf-8?B?MDAwTGp6SWVYb05PWDFOQmhwaWtmc1UzK1VUUVVuemo2eEdMelp5UzNjaVgy?=
 =?utf-8?B?TGsyUFJ2THdrTXVoYWtkSWtPeStkZVUxS0pRbDkweUlVYnE2RHNncUYwbzlF?=
 =?utf-8?B?S2lneHE0YWRNMkJybDZpb2lyR3BZL3hsZ0hzdUJvYkFSMk1oTERyWGdHZ3cx?=
 =?utf-8?B?SExnSFRQdmVxSW96U01pdC9idHE0MG55Y3VzeUErdDc1a1FRV1ZvWFgyT0ZR?=
 =?utf-8?B?SGpMc0hmWEI3THZKRUw1cGphQmZuRnc0TS9TU05JVWxGanJBUlZFTGIrWEtT?=
 =?utf-8?B?RHlsUjVwNWFWUlhzNVp5cCtaY2pDQThsU0Z4TzQySUU0c05JT2Mrc1NZa1Vo?=
 =?utf-8?B?YVJGSVdDSFVLeDM5RVo3RlpZUGVIRG5IY25vYWJSSTkxQTJCOXNZZkRNWi9z?=
 =?utf-8?B?TnJPQjJ3TEw1S3RYOTM1blFhS0tIU3VxR25wbVI2Q1o4L1cwNGpLNm5HTmJ1?=
 =?utf-8?B?SCt6YTFFdFF5U1dGMmlzeVJjV1hnM0oyc3Q4UXc1QjdGVURHanFpUExZbmtK?=
 =?utf-8?B?ckxCWlB5MHFXK01MVlZ5S2NIem9JbEN2eG1BTi9yVWE5bERhdDdqRjZPWEFx?=
 =?utf-8?B?b0UzOHF4cmp1STRUb2ZBUVdNN2loc0ZkR2hqMjRSSWZTTWhHNTRkSlNRNExq?=
 =?utf-8?B?UjVXN01yWExnWG11NUJDR3pQcjFWSmgwVHRoWGdUMG9QSkxTOGlydVJpNWEy?=
 =?utf-8?B?aUJDTURYaEo0NGhFRnBXVk54KzM2VHphRTJLakhVaHhqOUlUZ0Ivay9rTHhP?=
 =?utf-8?B?MjRSQWZaK3dLNXFwVTBMb1BUK1FFN3pwZ1o0VmU2YjZUL0NqWWluNU1vc25H?=
 =?utf-8?B?anhkVWFsMEFnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2dveXgzUW9TR1lKRG1FVU1kRTFpVFZ4YklRL3hOWlNWOWZ6eTU5QkQ1LzNO?=
 =?utf-8?B?YzVmbllib3FMNmhuYW0rK3dmTmpleTVNNFhDNXNOSFZpTEJ4UHpjZ0lwUWVB?=
 =?utf-8?B?dGdFWno1ZXJwQjE1S1ExMmNEeWVXNjBvTnJ1cytJdDUzdm54eTVRR29YVlRR?=
 =?utf-8?B?WllQT0MwK3FrV1BrN3MvUXdHMysxVXEwUkNuY2hKcE8yVVQ0cHFwSGtZODlF?=
 =?utf-8?B?anplbGFqMjNLdGFRZWhBM05CMTBvOVRIMFFaNjlaaVR3WG1zSWt1a0E1clhE?=
 =?utf-8?B?L2FWdnd3d3psTmVYeHNxK1pVZ2NjeWJiRXFaOS8vdHNOVldRQ3FXamM0elF5?=
 =?utf-8?B?Q1RKZjI5U2pEcllRQmVwdTFUbTNlUHAra3RHQm0rcVN4ZVgvcmt3SVZ1QWtR?=
 =?utf-8?B?RUdMdEQ2bDcrVjRHQzM1aWJPSEtBVWhyQ3dzVVc3RkEzNU53c2FrdUc3Ymdz?=
 =?utf-8?B?VGhURkxpWVdkdWwxYXNRSWx2UFNQaUJEZUppRk5Cd20rQmJ6Q3lQMEgyNmFC?=
 =?utf-8?B?Q1VXbXMxNFhZWmRpSHo4cDlNMWpBVlNwaHpNYnRCOXZtYm5wQnlVZGxGWkZ0?=
 =?utf-8?B?dnc5cDg4ak1WV1NtWlBXdjhxRThkL0EyQmR4Qmk4QlQ3b3ExNWhVVkNzOU9K?=
 =?utf-8?B?T1h0RXBZcnNqbkJ1UW5Tb0lTVkhoMHBtcE5mZHBacFlWRldtRU91aG5MY09h?=
 =?utf-8?B?cEZ5OUY1RGRQaEFQTTM4cXAvb2VtL0pyc1dpRExaREVaY2h3Z1BJeG9Tb3ov?=
 =?utf-8?B?SmExak5WdVh2elIwMmxLTlZVd083Z2ZlRHJUM2NzWWRtWUk1L0ovb0tyMXVE?=
 =?utf-8?B?azVNbEhZdjF3RWlFUGI2a1R0a3A1a0JTM2FIMWVDRENNQ05lQkwrUEVQOUx0?=
 =?utf-8?B?K3UzZ2hJZlZHUExVSDlnL0QvYUowbks3QnJCQ1NnWXc3R1V3aW9Tdy8xYjlw?=
 =?utf-8?B?cXJVUk1wWkVwbDlCa1JxOEp3T0ZGdk1JeHBSdm5YYUNrK2JReVAyUlkrS0FD?=
 =?utf-8?B?SG83OUZ0a05YYzZTWlo5YThkelRXcEFwbTNXSXIzVE1xZHR1M2tKQkl0WmVi?=
 =?utf-8?B?YzV3WE12NEVYOCs1MWZRZjR2TGhla0c0SG1VKzlxOEJwNlRoWkdKMHRpYWFl?=
 =?utf-8?B?ekh3YmpvQlpPNkozNHc2bFNOMkJ5VlhVRXFYWk16YWdIRmR1OEhhUXpLcE90?=
 =?utf-8?B?YnI5bHJMRDZxUFlFc3ppUUdtWHFHRkVvT2tlVGs4WnJSamhlR21jL0ZuOGFC?=
 =?utf-8?B?WWF6Tjg5djJLK0dKRWUzaUJXRmN1QWg1K3hEV0poa2h3aGg3d2hqS0RaR1Jx?=
 =?utf-8?B?dVlhUGlWYzVqMUMrNENjdmFGM21qWmV6UFRtZ3p0d2xBSWNOZnFRSnlURjRh?=
 =?utf-8?B?MUlyb3YzcnN2MXZMdVNDcDIyUWZzQVhEVURyNmE3cThwQlNuSCtBb1k3cEhJ?=
 =?utf-8?B?a0VLZXVXcGx1WDJySGNWT2hnTlhSbWF6RytKNklYRXR6NEtPL3k3Mjd2Y2R1?=
 =?utf-8?B?R2RtbWdPVm9xM005VzBsbi9abGlrTVMzWThjNEFudm1XU2hwS3FvdmgrcGhQ?=
 =?utf-8?B?MDhWTGRvNjBYdmg2RWFzcVdxWnFFVjNmak1JQlhMdHZmZWdnZHFudzVxOTBp?=
 =?utf-8?B?aFczUUt5eWZBa1VlUzBZWTRXMUovaGw1c1QxbE9MdTF5cDdCV1ByNlBSMTJz?=
 =?utf-8?B?eThiMlFNVG13VUttS2pIQ3A0TWFmaFhLbVdiQ0QzM082ejlka3RjclRGM2Jo?=
 =?utf-8?B?cEc0TkdNVjRHRGlNRXpZZ3M4TlowVzhycVpjQWxxL1N0QlB5WEJhaG1EenI0?=
 =?utf-8?B?Ni9zT3c3RmtTR1BaMHcrUFEyNUUvSlRNL2VLZklqSVlXeXRkT0pwY0svZ2JW?=
 =?utf-8?B?L2N3Zk1LMGNLTkFObDJTTXNBbDFNbkgzTFRHMEUyTExuT0xsd0FyZk5ZQTRk?=
 =?utf-8?B?NHdyRitmdDE5UDMydEJzejkxWGdwczZsWEdSUHVacElCRWV6OWZEY0RlVHdr?=
 =?utf-8?B?QzVHRXdoMW1YKzl6NUc5VmN3QjE4Q3ZpSzB5NGNjRmtWaHArZmVkZzIzTUx3?=
 =?utf-8?B?dVl2eERXalR4RmN0VURYSWdWNW5KS2tXa2xzUGhqUXl5cUl4Wmx6bkJTUldp?=
 =?utf-8?B?T2Z1SUIzUVhHTHBIN2FRT01VUnRRUWQ0OHloUmR3UDdHSjFLMEdnSWtkZ1NM?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <224B238F474B824AA3C7F2030AD6D084@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3383ae06-6849-42a8-00b0-08ddea523b9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 18:55:06.4175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LPF7i4ZIMLa9n9i5MiZKxafTx0myF6vA/daPZO2CIraXMjBHBTIZQ10TRr9BkUb7MQAZFCHVHCYU1u8POKKpwDm0k5oxKW/RNLmD93xobLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7116
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgVERYX0JVR19PTigpIG1hY3JvcyAod2l0aCB2YXJ5aW5nIG51bWJlcnMgb2Yg
YXJndW1lbnRzKSB0byBkZWR1cGxpY2F0ZQ0KPiB0aGUgbXlyaWFkIGZsb3dzIHRoYXQgZG8gS1ZN
X0JVR19PTigpL1dBUk5fT05fT05DRSgpIGZvbGxvd2VkIGJ5IGEgY2FsbCB0bw0KPiBwcl90ZHhf
ZXJyb3IoKS7CoCBJbiBhZGRpdGlvbiB0byByZWR1Y2luZyBib2lsZXJwbGF0ZSBjb3B5K3Bhc3Rl
IGNvZGUsIHRoaXMNCj4gYWxzbyBoZWxwcyBlbnN1cmUgdGhhdCBLVk0gcHJvdmlkZXMgY29uc2lz
dGVudCBoYW5kbGluZyBvZiBTRUFNQ0FMTCBlcnJvcnMuDQo+IA0KPiBPcHBvcnR1bmlzdGljYWxs
eSBjb252ZXJ0IGEgaGFuZGZ1bCBvZiBiYXJlIFdBUk5fT05fT05DRSgpIHBhdGhzIHRvIHRoZQ0K
PiBlcXVpdmFsZW50IG9mIEtWTV9CVUdfT04oKSwgaS5lLiBoYXZlIHRoZW0gdGVybWluYXRlIHRo
ZSBWTS7CoCBJZiBhIFNFQU1DQUxMDQo+IGVycm9yIGlzIGZhdGFsIGVub3VnaCB0byBXQVJOIG9u
LCBpdCdzIGZhdGFsIGVub3VnaCB0byB0ZXJtaW5hdGUgdGhlIFRELg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiDC
oGFyY2gveDg2L2t2bS92bXgvdGR4LmMgfCAxMTQgKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKSwgNjcg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBi
L2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggYWE2ZDg4NjI5ZGFlLi5kZjliNDQ5NmNk
MDEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL3ZteC90ZHguYw0KPiBAQCAtMjQsMjAgKzI0LDMyIEBADQo+IMKgI3VuZGVmIHByX2Zt
dA0KPiDCoCNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01PRE5BTUUgIjogIiBmbXQNCj4gwqAN
Cj4gLSNkZWZpbmUgcHJfdGR4X2Vycm9yKF9fZm4sIF9fZXJyKQlcDQo+IC0JcHJfZXJyX3JhdGVs
aW1pdGVkKCJTRUFNQ0FMTCAlcyBmYWlsZWQ6IDB4JWxseFxuIiwgI19fZm4sIF9fZXJyKQ0KPiAr
I2RlZmluZSBfX1REWF9CVUdfT04oX19lcnIsIF9fZiwgX19rdm0sIF9fZm10LCBfX2FyZ3MuLi4p
CQkJXA0KPiArKHsJCQkJCQkJCQkJXA0KPiArCXN0cnVjdCBrdm0gKl9rdm0gPSAoX19rdm0pOwkJ
CQkJCVwNCj4gKwlib29sIF9fcmV0ID0gISEoX19lcnIpOwkJCQkJCQlcDQo+ICsJCQkJCQkJCQkJ
XA0KPiArCWlmIChXQVJOX09OX09OQ0UoX19yZXQgJiYgKCFfa3ZtIHx8ICFfa3ZtLT52bV9idWdn
ZWQpKSkgewkJXA0KPiArCQlpZiAoX2t2bSkJCQkJCQkJXA0KPiArCQkJa3ZtX3ZtX2J1Z2dlZChf
a3ZtKTsJCQkJCVwNCj4gKwkJcHJfZXJyX3JhdGVsaW1pdGVkKCJTRUFNQ0FMTCAiIF9fZiAiIGZh
aWxlZDogMHglbGx4IiBfX2ZtdCAiXG4iLFwNCj4gKwkJCQnCoMKgIF9fZXJyLMKgIF9fYXJncyk7
CQkJCVwNCj4gKwl9CQkJCQkJCQkJXA0KPiArCXVubGlrZWx5KF9fcmV0KTsJCQkJCQkJXA0KPiAr
fSkNCj4gwqANCj4gLSNkZWZpbmUgX19wcl90ZHhfZXJyb3JfTihfX2ZuX3N0ciwgX19lcnIsIF9f
Zm10LCAuLi4pCQlcDQo+IC0JcHJfZXJyX3JhdGVsaW1pdGVkKCJTRUFNQ0FMTCAiIF9fZm5fc3Ry
ICIgZmFpbGVkOiAweCVsbHgsICIgX19mbXQswqAgX19lcnIswqAgX19WQV9BUkdTX18pDQo+ICsj
ZGVmaW5lIFREWF9CVUdfT04oX19lcnIsIF9fZm4sIF9fa3ZtKQkJCQlcDQo+ICsJX19URFhfQlVH
X09OKF9fZXJyLCAjX19mbiwgX19rdm0sICIlcyIsICIiKQ0KPiDCoA0KPiAtI2RlZmluZSBwcl90
ZHhfZXJyb3JfMShfX2ZuLCBfX2VyciwgX19yY3gpCQlcDQo+IC0JX19wcl90ZHhfZXJyb3JfTigj
X19mbiwgX19lcnIsICJyY3ggMHglbGx4XG4iLCBfX3JjeCkNCj4gKyNkZWZpbmUgVERYX0JVR19P
Tl8xKF9fZXJyLCBfX2ZuLCBfX3JjeCwgX19rdm0pCQkJXA0KPiArCV9fVERYX0JVR19PTihfX2Vy
ciwgI19fZm4sIF9fa3ZtLCAiLCByY3ggMHglbGx4IiwgX19yY3gpDQo+IMKgDQo+IC0jZGVmaW5l
IHByX3RkeF9lcnJvcl8yKF9fZm4sIF9fZXJyLCBfX3JjeCwgX19yZHgpCVwNCj4gLQlfX3ByX3Rk
eF9lcnJvcl9OKCNfX2ZuLCBfX2VyciwgInJjeCAweCVsbHgsIHJkeCAweCVsbHhcbiIsIF9fcmN4
LCBfX3JkeCkNCj4gKyNkZWZpbmUgVERYX0JVR19PTl8yKF9fZXJyLCBfX2ZuLCBfX3JjeCwgX19y
ZHgsIF9fa3ZtKQkJXA0KPiArCV9fVERYX0JVR19PTihfX2VyciwgI19fZm4sIF9fa3ZtLCAiLCBy
Y3ggMHglbGx4LCByZHggMHglbGx4IiwgX19yY3gsIF9fcmR4KQ0KPiArDQo+ICsjZGVmaW5lIFRE
WF9CVUdfT05fMyhfX2VyciwgX19mbiwgX19yY3gsIF9fcmR4LCBfX3I4LCBfX2t2bSkJXA0KPiAr
CV9fVERYX0JVR19PTihfX2VyciwgI19fZm4sIF9fa3ZtLCAiLCByY3ggMHglbGx4LCByZHggMHgl
bGx4LCByOCAweCVsbHgiLCBfX3JjeCwgX19yZHgsIF9fcjgpDQo+IMKgDQo+IC0jZGVmaW5lIHBy
X3RkeF9lcnJvcl8zKF9fZm4sIF9fZXJyLCBfX3JjeCwgX19yZHgsIF9fcjgpCVwNCj4gLQlfX3By
X3RkeF9lcnJvcl9OKCNfX2ZuLCBfX2VyciwgInJjeCAweCVsbHgsIHJkeCAweCVsbHgsIHI4IDB4
JWxseFxuIiwgX19yY3gsIF9fcmR4LCBfX3I4KQ0KDQpIYXZpbmcgZWFjaCBURFhfQlVHX09OKCkg
aW5kaXZpZHVhbGx5IGRvICNfX2ZuIGlzIGV4dHJhIGNvZGUgdG9kYXksIGJ1dCBpdA0KbGVhdmVz
IF9fVERYX0JVR19PTigpIHVzYWJsZSBmb3IgY3VzdG9tIHNwZWNpYWwgVERYX0JVR19PTigpJ3Mg
bGF0ZXIuDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBp
bnRlbC5jb20+DQo=

