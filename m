Return-Path: <kvm+bounces-22275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F27C693CC48
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 03:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75D321F21F84
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 01:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3BD2C9A;
	Fri, 26 Jul 2024 01:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UfkHw92g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D1717E9
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 01:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721956369; cv=fail; b=WLpKYJIobvRdDcFWEDKmn/CWP1fd95tIWYJ2BAf7GgtnjGBKW4IoPK6yQmM1k7IYf80z/w8VMWkRxAS8OvrQXv8PVTzuAe1ZxvsgQN/5gMoxmjXVWMYkriHaVJWKmMGsi5RJmzSZc9cZ/5TXejXpDqx01FYbOh9i9hSIfQXCMaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721956369; c=relaxed/simple;
	bh=TdydGV97xz1hXImBhsmjj8mpP4761+y0THZyiwzrKqs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TBlGZqfc2LKYjKgIzDlbGQzLszv9ciD3VzE5W9oU4DvKS3jH/UNVTY5pwx9jrDRVzGnOOQ7T1AA20+tC9Oc/1J5Qmham2qbJBtXC0xWX9NwIaDUVQpySBCUuZh6qN4sQscu5t8kxYwCZK+DSTlyM/R7t2oYbIGFczjTH44rAdFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UfkHw92g; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721956368; x=1753492368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TdydGV97xz1hXImBhsmjj8mpP4761+y0THZyiwzrKqs=;
  b=UfkHw92g1EWp1tywJtVMstLPjYt3WNwO+7/EdXjU6Cen8oLA6rDav0kD
   yGyx+/aZfbqP265oSCHPR+ZGT/eqL4EPPInB+Ic+GPt7kUDJKC3v8lMfa
   uO5xVAjr6QXM9ez1Y+gjgVhHQ/MDEVb0eQqnGDwLAQCDtVDYkXzqMSJOr
   ddBrhi5xVRLB+QVvv3zOFgnvgGGdd421NYuexLDAJcsA9vZ7crznXxwQU
   zZMPwPEThE72dtSjstV3l8lR6LLool1rBGpq6dDIg2eDWEyJxxRIpP4Av
   UyW3kv7CdlGp717QRYS5P3NODevpK6O8x+wGYx2IFIjlH3OBHqiojieVo
   g==;
X-CSE-ConnectionGUID: gptRQb/KQx2dq5S2qs6Vsw==
X-CSE-MsgGUID: FzfBJYx0TUyywHe/GoJXvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="19855929"
X-IronPort-AV: E=Sophos;i="6.09,237,1716274800"; 
   d="scan'208";a="19855929"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 18:12:46 -0700
X-CSE-ConnectionGUID: aO7qr1S1QuGkyVriojD9XA==
X-CSE-MsgGUID: qx1oMqUdTdKg+Sm4I4EhCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,237,1716274800"; 
   d="scan'208";a="57927019"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jul 2024 18:12:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 18:12:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 18:12:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 25 Jul 2024 18:12:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 18:12:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTU7EnE49a0vEQNLkK7+1YNrPKLeX0XvDtN4FzkJi9EM94w4zi/mNjo5pZdz0oGOXwheRXPzxfRn7ESUJK1JXqYi5WHwPcLlBFo3uyGGqV5rzV1uhNTDLN6mrBukqKISlhyYuwq72KbnEFMRU3u4iT5wmvSkSoqbS0Dkndt4xH3mC6S378PYqsf2mIsIUbAKS2XKzBa7ohjQsZHQY95LljE5NctgJER2spSzgqAX7yEnzL0YRWdjksJlJ30s/qPaf3SkWRNACg3eUNNEErqGiFnsdlAFw6pc69SCaVRhaUTDqjyIsA7JIZH3JpqRYIoXE0KeWn9v0JQm2CEA+GKvNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdydGV97xz1hXImBhsmjj8mpP4761+y0THZyiwzrKqs=;
 b=eb54Ht+eWoO93SDDP6bwFWtyzjT/pumbAFS5S73N1EmxvCGVnn2KK7xhqosJkEIraR6GNYH+IwPFfcqzWUNrdH4TocQpZ1PNqu6vYKOwk8P9/yQ02msuf6CNnl1OEHwvsoddVr+gyz9VNOJN/INRIPz8VSy7FThAvkBtTwzwwVCowxVJpDVBV7JUHwlnrJ8Ppd61+9O9f7RhWeGyS2o1izeqaCTqtaqo9TrbWRLHOQrnvQRXqe7/E2V7xzkvK7XEQmbW5PwTIdYxnOgVeaYOW/NKAxWAqU/qbyzmOpBQGEpUAj7HIdLSEa2VgBe4WRt4g7Q9o3iPOmOYMiMezZls4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Fri, 26 Jul
 2024 01:12:42 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c%4]) with mapi id 15.20.7784.017; Fri, 26 Jul 2024
 01:12:42 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "Wang, Lei4" <lei4.wang@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] target/i386: Raise the highest index value used for any
 VMCS encoding
Thread-Topic: [PATCH] target/i386: Raise the highest index value used for any
 VMCS encoding
Thread-Index: AQHa3aDKefsVtZfqzUOIU714C48dorIF+b4AgAAd2ZA=
Date: Fri, 26 Jul 2024 01:12:42 +0000
Message-ID: <SA1PR11MB673499AE31632832A91042E3A8B42@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240724080858.46609-1-lei4.wang@intel.com>
 <CABgObfYHK+N68pOamxA4nT6iZUvEDeUN-AkNwEE9jgnig3AfNw@mail.gmail.com>
In-Reply-To: <CABgObfYHK+N68pOamxA4nT6iZUvEDeUN-AkNwEE9jgnig3AfNw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB5144:EE_
x-ms-office365-filtering-correlation-id: a3f32fdb-93a9-447c-7aa7-08dcad100cfb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWl5RHRWVHpSTFhsdndlVkFkYjhITW5JQzVoNmlLRk00dmZBRjlvcm5yaS9C?=
 =?utf-8?B?ZnI3aXhaSWtNWVJWWFFRNTRybTRLVlBsV1B4RTM2aHB3ekdEZFlKb08vV3pw?=
 =?utf-8?B?YWVaV1lNWExPODBiME9TTGZGSE1tMStvNWR3L0w4WDJhZkJqK05XcEh6cnJ0?=
 =?utf-8?B?dk1Fd200OExNWjFzSC85ZzhiK2UxTjZBR0U4eFo0QTNZM3lIY1ZZK0g2S2FU?=
 =?utf-8?B?dWhMd25yaGpMc0xMZUtsd3gveHJwSVZwN2dxM3A2cE84RjlhVThWeTRwMk1C?=
 =?utf-8?B?YXhqbzFVT2xZT1lweDFGMUd4em5BbEdPYzh5Uk00VUhqMklYM3d6V3cveG5U?=
 =?utf-8?B?aW1NUlM4cldNR1BtZXhhbE1TNC9iZjQ1UHFoQTRmS0dkK2pDVWlybldJc1Er?=
 =?utf-8?B?Qk1MYzZmV0FLZTVTUGNtVE5uck9UaG16TnlzNkVweVUxYmtIeDRxSkZzWTJD?=
 =?utf-8?B?RmtFV003V1BSSEpMa2hvdjAwTzlmOVJyeUNEc25YUmRGeWVwOTk3TEQwdCtI?=
 =?utf-8?B?aUFVSGtLVHlqVnNlWXRYZy9Pb2RxQlZmMkVxVFNZSGtjOGY5c3d3WHkzU2Q5?=
 =?utf-8?B?ZUhpUzB5a092Y1ErSlJsQm9Day9hUmdtbGlsWnhsbUhaNldUZEVvTmFzbWUz?=
 =?utf-8?B?dDdIWnlaUHozNDcvMWpVeWR0bWUrbk9CaXhDcmM0aTNiczl4R1E5RG1iUkgz?=
 =?utf-8?B?T1lLVFBUb1dUa21QUjFlS0ZJb3pzWURKWUFOU0ZFSmFmQ3hsNjRselhBN3Vl?=
 =?utf-8?B?MUxKREs4NEllTlBZYVBOazFZRzlSR2xMbE9zOFRHQ09TMEs4TW5sczdGRGtu?=
 =?utf-8?B?dHViQ05pTFNLTThPd0NWbU1uZXVrSktVSEo4VnkxZTJvalV3MHVXaUw1Sm93?=
 =?utf-8?B?SFZsZlNpQkNIeEdzRGQxSm8yOUt2elpDa0RtVks3ZFRwSmJsbC9JSWw0Mk5v?=
 =?utf-8?B?cEdCREM3Sk5ORWNnMFVCMjhhWmR6aUcwc1JDYkduaUFSakxZMGhPYkFPT1lU?=
 =?utf-8?B?Q1ZaWnBZWkZsaVhhaENxdTFEWU5pa2lkSTRTalZMOGhxUDRXdGhIVVBEN20z?=
 =?utf-8?B?ME9EMXBROEZ6UEI0SDJ0U1NRUnkwc0pkSVZyc1BmOFZURHJQKzNMTUpkTnhz?=
 =?utf-8?B?Z3c5RW5USExMYXZIRTNKNGhRLzl3bUtkUUNZdHRHTGlKb1d1bVJhVjlha0E3?=
 =?utf-8?B?R1pXNGpqZTlpR3V3Z1lIU0kzVVhRSjRqaEVRNi9CT0I2U2FpcndXM05ETGIz?=
 =?utf-8?B?TEllYXl5ZFJwSzRWcWg4SlA2NkVLdW5XWExranlrTVU4RWEwRXV2MU1iQnk2?=
 =?utf-8?B?WGFGZmRGd1l5U3QzMnZxd2plSHVadURyWnpuellpRm0zcHNHaFJoRHVOUmpQ?=
 =?utf-8?B?dUZSN3NTZW0zWVpydUpWVUhZNGU4b0xXSWZPQWwvYi9EY0l1bTUrcEo2bDBB?=
 =?utf-8?B?WmVEdTdLdGpGWXo4WUpEdVdOZHk0U2JpUGVFS0lzNkVZc01kV2k3bHRPUVEy?=
 =?utf-8?B?RUZpSThMdW4xRDYvcXdPbGhVQXlDaFhuY0hsZnREYkE0M2s3d0lDWnJrM0hM?=
 =?utf-8?B?VDFYcVo4bDVLOTVtY2JkMFltRXBZd1ZzVTJKV1RLdlhqWmVuN1R4YXUzNkdL?=
 =?utf-8?B?NjdqNDBNd24yUHoxQ1pJd3pzRE8zVEhraDVKdUQ1QXY5T2ZvZG1mVW1HVTlz?=
 =?utf-8?B?L2RYbEhyeUhxR1JnVFZJU2FQZmQ3WmFWTzhiRHZDU0xEZkcwUmNNNE9RR0lP?=
 =?utf-8?B?ZXhleGJzVVhrYzloa2dKVDhZa0k4SHQ2bWZZNGlWclc2UUNCbGtXNTEwR0RH?=
 =?utf-8?B?Q1hNWit6YmdRNUhuaWJqQnJCSDFjaVJMSHNQWm1ldEVacVRuaW80U3dSNkxv?=
 =?utf-8?B?dm5IWnZPQ2RET0pVTnk2VUlLMy82bUE0eEdleGY3T2dSZEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDI2dkkvcU9JbXcyZERCM25pNkN6MGQxaktxYXVyTXVrM2tYaWcwM1ZRQjRk?=
 =?utf-8?B?R3RkZkVaUmFHT0FCSTc0NUo2dStGWlpSSkFEVEY2M3RRTEovakpsL0FrdHh0?=
 =?utf-8?B?aGQ1SXQycUNXMHNYYktIRXIrQ2hBaWRPVzIxb05wQUlsTEZGZW92L0x3Q3hE?=
 =?utf-8?B?cmFBZ3l5SFV0NnNUOElqeEwrNko0MUFwUzZVSHRNbjJtVW5qakdlcldaazAy?=
 =?utf-8?B?anpXUlhHbFR5M2dScXlnR0JSa3lGck91WnMxL0thQXp1czQ2OVJseUdSMWND?=
 =?utf-8?B?Tk54bnd6T1I4bWorcGhxYmt3STA1UG1md0xDTnVuT3RNNWNIeWxYdlo5SURa?=
 =?utf-8?B?SlhWSmVxV3laR2N4azVObTlEZ3hqYXBNMkZpeU4zMk93TkNnUStBcWt3TWJV?=
 =?utf-8?B?aVVMQzlycVZJM3lOU1FqY1h2THJrdFhaOXVlQzMrOEt1cGE1K1AzU1JLYkw4?=
 =?utf-8?B?WHBkVmYrcjF2MWFmOWhlUkhaOVVtOUVqM25zSVhJMUFWYmNrZXNmcnJZQlY4?=
 =?utf-8?B?cWljeXZHQ2hNKzYvTWlRZ1p2eUNSeG0vV2hacE5mOWtNejNjVFc3R09RMXdx?=
 =?utf-8?B?WHBaS21DVitzOFFFTjhEOWxYYjFuZXZ1Rk8vQ3NiR3RVaE05VGYxN1haUWFv?=
 =?utf-8?B?UjVwdGN6UkJKRGtXcWwzclQ1OXZCYjRmQ2E4c2MwTC84TDVxeGVNMW5NMHRN?=
 =?utf-8?B?cWwrL3dJNUJCcHdMblpramhEb0FYVjBjR1J6UVBCSng4elZoVWpMZHNMVkEy?=
 =?utf-8?B?ZDM3T1RQM2NlbGlZR201YmZMbXF0aEFLTzA2U3lDN2F6Mytwd3hXSVk5cmtu?=
 =?utf-8?B?OGdnWVN1NWdoeUcrMDBtRElUeDIxbTl1SXg3aWhpalNhQ3ZjT0RoeU5pMFJU?=
 =?utf-8?B?THV0bE10YlJPNENvaDFvNDBTMFFEanl1cXNxa1QwcE9FTDFZQzJFM3lhb2tG?=
 =?utf-8?B?MWMrbmNnVUhXY2wxY3d6SW9FU3hac05jWWhFa3NmWDZwN2M1aGtCL0hKYnFI?=
 =?utf-8?B?WTNabzk4VHRqbWF3REpjbEVjOEdFZmxoVXVNYkw1NzNwZGRrTDlXelN5dDlt?=
 =?utf-8?B?S0J5bXg5SHQrQXhQbmhKb3NESjIybEcrSDVFSHdBdjJzdzNRbXMzWWpMMU9r?=
 =?utf-8?B?ODBET0RFUVBWNzZXTUZZZzlRMjBFc0pQUXplaVl3NDMxTGdoOUp3aUtjc3JG?=
 =?utf-8?B?NXVqTHVnMjBCLzZzVnRlWGJ2UGhncjJCWTNXZllDYU9vbkNsTkRqbjhLUUpJ?=
 =?utf-8?B?ZmtpY29sYzNSOVcyU3BjdG1ySGN0V0FVaTh2UVF1cmJuaFY1RTJLK3JSbkJR?=
 =?utf-8?B?VU9ENTNEMUV0S1JPMU5oYVl4MW01TExndlc3M2MxRDBseitvKzMrSVdvanJT?=
 =?utf-8?B?ZUszb2ViejN5ekdldzhEVFdLNDI2ODNnMGxqNldxang1aXdRQmV0OCtPNnJx?=
 =?utf-8?B?UGdBajB1ZEQ4WFJsYm9qelRNY3ZISmZCUGhYNEhDbnpsNzByNG5UN3BnUGFN?=
 =?utf-8?B?RFBuM2hsSmx3WUNYZ2hTUDhXSjg0YlpFakVBUjVwY3VOOUF1SUE4Ukt5aVpo?=
 =?utf-8?B?bGdYNTd1T3Awei9iY1ZQWnhkZ3JwSlV2b0JIL3ByL21PcGlZVW5RSEh4KzRn?=
 =?utf-8?B?T3phOGV6d1d6N2RaVVYwVFJHZlBkbkdpUFNEbWlLMzM0UCtjTTFXNkxHYmxs?=
 =?utf-8?B?QUxBYUprTm1uZDg2cVVXOURiTzdoRHZuTGpLYitadXQ1Yzh3NzJ5L2ovYWxI?=
 =?utf-8?B?TFRhTkp3TENDT0dZTnpvdkNqQlp6Q2lkb3JlcklqQ0wzb1EycC93Q3FsR0tu?=
 =?utf-8?B?YVFzTzRub1VIVkhwU29vTDZTWEdiRTdYZ3BSNzFoT2JZWXNOcjNaalpLenhp?=
 =?utf-8?B?aUFlSEY5RWFpZzllVzVnckVmMWJackdLTjR1TmYwN2p5akdHcHhGODRNNDNo?=
 =?utf-8?B?N0hhM0x1U0ttQXpVQWRrQThJcVY3enJPZ1F3YTdYWEV4cklxNk12bGJzNnpQ?=
 =?utf-8?B?YVFQM3pNSDEyejFGT0NKaUhQZVRvaEhWbzZVa2NPZ3lJSnVPMTdkQWNWVVM1?=
 =?utf-8?B?dEl0MXdISm5wN0NIQW5zWDVjcFRJaWdSUTJXRzg1dHh1S0lBTlRlZXhsM3NJ?=
 =?utf-8?Q?B5B8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f32fdb-93a9-447c-7aa7-08dcad100cfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2024 01:12:42.8128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7bo6kYWw5lCWLagIYAznqpMj1YINwZ3TkJB7sErAdNFGVrVce+TlQGuolJbPMVOyf7RJsXulDCmZK8gh04wWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5144
X-OriginatorOrg: intel.com

PiBPbiBXZWQsIEp1bCAyNCwgMjAyNCBhdCAxMDowOeKAr0FNIExlaSBXYW5nIDxsZWk0LndhbmdA
aW50ZWwuY29tPiB3cm90ZToNCj4gPiBCZWNhdXNlIHRoZSBpbmRleCB2YWx1ZSBvZiB0aGUgVk1D
UyBmaWVsZCBlbmNvZGluZyBvZiBTZWNvbmRhcnkNCj4gPiBWTS1leGl0IGNvbnRyb2xzLCAweDQ0
LCBpcyBsYXJnZXIgdGhhbiBhbnkgZXhpc3RpbmcgaW5kZXggdmFsdWUsIHJhaXNlDQo+ID4gdGhl
IGhpZ2hlc3QgaW5kZXggdmFsdWUgdXNlZCBmb3IgYW55IFZNQ1MgZW5jb2RpbmcgdG8gMHg0NC4N
Cj4gPg0KPiA+IEJlY2F1c2UgdGhlIGluZGV4IHZhbHVlIG9mIHRoZSBWTUNTIGZpZWxkIGVuY29k
aW5nIG9mIEZSRUQNCj4gPiBpbmplY3RlZC1ldmVudCBkYXRhIChvbmUgb2YgdGhlIG5ld2x5IGFk
ZGVkIFZNQ1MgZmllbGRzIGZvciBGUkVEDQo+ID4gdHJhbnNpdGlvbnMpLCAweDUyLCBpcyBsYXJn
ZXIgdGhhbiBhbnkgZXhpc3RpbmcgaW5kZXggdmFsdWUsIHJhaXNlIHRoZQ0KPiA+IGhpZ2hlc3Qg
aW5kZXggdmFsdWUgdXNlZCBmb3IgYW55IFZNQ1MgZW5jb2RpbmcgdG8gMHg1Mi4NCj4gDQo+IEhp
LCBjYW4geW91IHB1dCB0b2dldGhlciBhIGNvbXBsZXRlIHNlcmllcyB0aGF0IGluY2x1ZGVzIGFs
bCB0aGF0J3MgbmVlZGVkIGZvcg0KPiBuZXN0ZWQgRlJFRCBzdXBwb3J0Pw0KPiANCg0KV2UgY2Fu
IGRvIGl0Lg0KDQpKdXN0IHRvIGJlIGNsZWFyLCB0aGlzIHBhdGNoIGlzIG5vdCBuZWVkZWQgdG8g
ZW5hYmxlIG5lc3RlZCBGUkVELCBidXQgdG8NCmZpeCB0aGUgZm9sbG93aW5nIHZteCB0ZXN0IGlu
IGt2bS11bml0LXRlc3RzLCBvdGhlcndpc2Ugd2UgZ2V0Og0KICAgIEZBSUw6IFZNWF9WTUNTX0VO
VU0uTUFYX0lOREVYIGV4cGVjdGVkOiAyOSwgYWN0dWFsOiAxOQ0KDQpUaGFua3MhDQogICAgWGlu
DQo=

