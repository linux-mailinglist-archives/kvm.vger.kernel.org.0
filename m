Return-Path: <kvm+bounces-49774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A58AFADDF6C
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47E5417E2BF
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B708B296166;
	Tue, 17 Jun 2025 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnYjB1N8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E601F5847;
	Tue, 17 Jun 2025 23:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201854; cv=fail; b=I/NxuC4aqVemJAD7d32UXzpjq6xS8J4Nf9f/4FqdYmlAGTQ+o9TvCQjCo4QODZBJPzJFSc25WeKmSX0GNZt2yQX3f1HdvlRPK9XVKdI2QyMX76a7l8UmupB9AyjlGNVK9Gv4bA2nGRXhS5p3xa/trRsu2GZ7+0HKqg6OfK1hT7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201854; c=relaxed/simple;
	bh=ephXTwW9TfD1kQ0XKaLPfoMKEYDZMeNQbp6T95MjiKY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ivWr1mAdFBABL9XKqZLrCU3Pklx34cFW+xIxLqttaEGjn1h9tz295bNfvqjxmbLRIjSqUOTpCbug4erhwiZwtOuwA1SonYqPEllEBjuVXEbp4oLf6PMCFkp7eED89XwpArcVqhSAb6sr3eNtDTUeRlIapAZpfdwc3i0B+81uFu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnYjB1N8; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750201854; x=1781737854;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ephXTwW9TfD1kQ0XKaLPfoMKEYDZMeNQbp6T95MjiKY=;
  b=fnYjB1N8VC2wQZRs7exwbj7ivuj1mUVgczc/BeSc3ap2KLoCb4mV4cpO
   /AfEAJedEXWHUWBeLV0qYp1KQw8SDkLc89TkjOrTs/X91dLYaT5fO+MRt
   wPrHa2twcXIto6pBMbO5d3c75G1OGCI58y60krBTcCokPlDei8xvO3/1L
   6CQo1j4G4lbESsCduz7HybGZckwqU3jJ7pktRzfS8mYRvCi/rMSw5SL8I
   uazAwfPMUITGYBbHml4i5aLR14Aq6wNZP9v976AcTAXOpSPBroUOLHa0H
   iq+GmL0VxKRfR7PQRYhgd0UM/4OJjSNK1uzqQgp7PKR2ZX48F5Wazmgbj
   w==;
X-CSE-ConnectionGUID: b6TrDmhqQw+Vu6fwbRq4AA==
X-CSE-MsgGUID: k6aZHcUrSL2+7YF1CFPWLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="62676743"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="62676743"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 16:10:53 -0700
X-CSE-ConnectionGUID: X/OLnmmtQXSkzrUvSoh93Q==
X-CSE-MsgGUID: vV/YmN4dR+uoOI9fgKInww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="148856239"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 16:10:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 16:10:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 16:10:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 16:10:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ah1cCz7ng1MTjnAzaW7P81tO9Grv8wd0U4AUDiu7lkQklZh5b29KbdAO349zXUQ3uzQo+l8E1VuH3mJy7ZhdSjvXr/oYqurvqfnhqsglU+Mvv7L+OqL73LAI3BlQJkty3EqnJXe9gxbqSKbabaDyMGvavYyrNj/aGw8EOfLZJk7Ibvo0nOOijCeFEfA6o/GMoYs7OqzFqr/fzME96GHYLSiCVBmItTB5Px/udy+wJKyRnMBv4xwq+EXyCuToFYzQp414eXtuyhiR7jzVsSvNFd2Gr2WJ4b/yHJy1T5U5Sx4DY4VFO6dM12Uu65am6utBfwiBZk+xbAFjC5qxXYULZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=beHDxOYWKtyFc3DXqTyJLOL+OaKaCO2DGiEt8u/Kp6E=;
 b=E/x4W2ZD8vphriclRhVyQ9bJ3Tzw9RVfZposlXAMd0yEbdmEyqvIZjq7w2PR3r+9cUc22XzL3VpgSw+NxXsboTw7cTfXVSY795dhZhjoUQYwP2p61vro52rTPL4s6g81F6PFU5uShtZ4ROaoGh3OK4JrAjRFjQSDq4LVFgiomctYwTxWLKGFa2/X19cdYDFJEEA8BnbBpC87oSumrGvMjMMUEKm6P2F1kCnG5Lkv4k8PfglHeYD4BWjBsKB44SsBYwX3q0EwAPqfiV0e11bUfvwWw0Wp52H+eJxJ5jpgAL4eiO8NkggzDMypeTs2SMH2c4LYu4iBCa3j15Gax5pz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SJ0PR11MB7701.namprd11.prod.outlook.com (2603:10b6:a03:4e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 23:10:21 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 23:10:20 +0000
Message-ID: <7ae5c378-a81a-469f-a7eb-ddd855590a3b@intel.com>
Date: Tue, 17 Jun 2025 16:10:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/traps: Initialize DR7 by writing its
 architectural reset value
Content-Language: en-US
To: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<brgerst@gmail.com>, <tony.luck@intel.com>, <fenghuay@nvidia.com>
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-3-xin@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250617073234.1020644-3-xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SJ0PR11MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 6586a7bb-dda7-48d0-6d2c-08ddadf421bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0EzMmpIS2plTnc0NHhZN2FOZUJ0WmxZRVFxcCtKbkpVUWlhRTBJaFUwdk9L?=
 =?utf-8?B?Z2FMaGlLZnZyR1lZOEhOZzk5S0RzUlF5RlZKdFVjazVZT1U1bkdicS9ibW9T?=
 =?utf-8?B?NlN3ZFlFSllwMGxnZEdMRkh0UWFjaERPSjYzb2JqOXhJNmlQazF3SVJnalhJ?=
 =?utf-8?B?THhkUDhOWmI4UDVHL0VPc2d3ZDQ4ZDdaODR4bi9JUWJDVi8ySzJoOFFRTXVL?=
 =?utf-8?B?ZjhsRHpaSFVmZzVGWENFV1FHYWhiQlJuV2VTSlBxK2dGNVJjNWxtemV0RU55?=
 =?utf-8?B?NU5pR29QSTZ0ai9mZVJxN1BITlpyTzVQU0wzRVFOTTBtbHRKejhCU01WdFU2?=
 =?utf-8?B?QUdtbjNVRlVOVEcxZlczRWtyc2dCK2xycy9icE9EYjhiazloYStJOGNCOUVv?=
 =?utf-8?B?RmZVWU9vdStaTkRMd0UzUnlEZDVoQmZxQ21tZ0srclJZeUphSWVqRkxkV2t3?=
 =?utf-8?B?UERJZEFvMFVhL0NuTmdWM3grOTBQODZGUmFpZHc2Vm1VdjdHbTZQUTFJR1F5?=
 =?utf-8?B?VGFBekhWVHhXbFNrR0dhVWwzeThlVGpTVzhweldxeitzay9DMGR1RmJ5a1Zj?=
 =?utf-8?B?c0dhL2xGNXBydkIwTENKNUVIUUpWdHpESWJXYmN4bFgyZjlqSmd0UDNVSHdN?=
 =?utf-8?B?RmVpcjIxQncyRktxeVYrNXg5d0Q4T2kwTmdyMGtHcnB5UjJ5VmYwVDZiNlcx?=
 =?utf-8?B?Qkd6MWtNQTVScWFlTGtJMWUwRVlaNDZQMmdRSXcwTW1FaXBJNEV1dTRVV1Az?=
 =?utf-8?B?QnRobk9BKzN6aHBTRFh1NG4rL3RNMGo5b2d0N1VJQnVINFFYZlQrR3dsZm92?=
 =?utf-8?B?aWljMW1OdkF3b2dqbGQvRjhKdFJCQ0FucDkvNHMrRmRzT0tySHQ0MjJOUDlW?=
 =?utf-8?B?ek95VEpFWG1sS1A3V005MTA5RkhYMmczTXYxd3AzTXNJWThRT29ieHVrUWdi?=
 =?utf-8?B?Ym9RTXd2dXFVbnl5UWdUYVZzNnpLNlMrUitHazQxTU1QcmwrRkwyQUlzQzZZ?=
 =?utf-8?B?OW1yWXFMajZJT3Z2YWVJQkpQcVpPVlN2VmNOZ1JtOWl0VVVJUTNrU0hDWG1V?=
 =?utf-8?B?amFkbmZLRzcrbGt6cGU0UWg0TXExNkVEaGoxS3BOTU1GWUJXWDZzU3Arbk5X?=
 =?utf-8?B?dE5PeHV5eFdlSXIzR25DSEsvQnhwYUdmTWRNZXBPb0huUGNqaTVWZnh2VmMx?=
 =?utf-8?B?Y2ZqbGxlcDcxQm9PYXllUFBDNkUrZ0VYMTdTZGtxRG44b0QwYTk3MlFGaVdt?=
 =?utf-8?B?Q1drRjBtQkVPTVZLemt2VXFzNzE1YTFaV0QvZlhvMkNxUWpTcktMK25WMFN6?=
 =?utf-8?B?WGRlWVVxeDBhczJOT3FvTWdGdDFZSnlVWHdKZ2dzNlR2SytkSGZZUmxzL1NN?=
 =?utf-8?B?OHptRm9pT2dCcFRpb2gzcXRMWEJxN056UkNPNGkxVE5NbXpyeVUxWUNxVU9S?=
 =?utf-8?B?TnNQOHhEL2grRmhsWWJwdFRTNysxMmZEelJBMVk5WnpybVdOWXh3V011dDk0?=
 =?utf-8?B?L0N1UHc5ZjN4aEY3NmV6c1pWb3JqQTRUbWlqRnhXSHpMYjViMVVRS0hoQ3JZ?=
 =?utf-8?B?a2FYeGVibklaeDRiM1FOY1AvQW5JWXZqU25VK1VUcXczblZ5Mk5QRThSV3F3?=
 =?utf-8?B?dlZNcEY3M1BrdndMVFVFUEJCbkNqSmVPU2d6WThxaTlTOElKNGQxVWNjWXJE?=
 =?utf-8?B?ZS9QL3NGenZMdFJHZDVkaWVnWGNqZ1lxbDh3N0x1QVZHTTZQWHdQc1ByL2VS?=
 =?utf-8?B?L280QjN2L3hSWGtKMittUTZGTVo2UnVHV0Z6TG54aWovRlFVUnRKTEVNNUdQ?=
 =?utf-8?B?UFVWVktLSit4MkpYaUgvRkpKNzZyUHFRU0ZiQ1ZNL0EyWUxyL0xaalNpWWNK?=
 =?utf-8?B?bW41eEVHZ2V4em5BNHVVOFg0dzV2ZmZTaERPeHZBcTkzSzJNNEhzOEZmZ1N1?=
 =?utf-8?Q?0Gfgj+iWKis=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHhnU1dkYzcwSUFEVXZSVHhiZXZiT0xKeURlSUVzUmFBeXFXVzJGOGV2SExq?=
 =?utf-8?B?NkFWdmpFRTM2YS9uODN3cU1qRkJuL21oT2orZ3Vmem50TWpiU2Fxa0NLQ2Q2?=
 =?utf-8?B?QUZXa3VMMEwzdWVUTEpuQXltSGpoQUphOXg1WTJZY1dhT2pHVW9ONkgrQU1Y?=
 =?utf-8?B?OXB5WGV3Vmp1M2xTUldqV0dRdGZxUnh2cm4vM254UmtjVkJzQVBCTDdkdGRz?=
 =?utf-8?B?dVhNRlFQSllwc1E0Rk9nMDlWcWl3UDd3cCtRS0U0VFlHTkg3NXA3M2x0L1I0?=
 =?utf-8?B?U3d6RzlJbzhGNVBKL0pUY2FRSFZUeGNNcEppQ1h4L3pXcXRxRjU4dEZ5UU9o?=
 =?utf-8?B?U0Rrei9nWjNlMGNZMHdKTDhoSWVpektsdUV2cFFCVE1NQzY3YTE0MTVDS1hp?=
 =?utf-8?B?KzNWZDd0dkE1S3lLKzA3bWlyVlFaeEZBT05lU1lhMFk1ZzU4eU8wNkNLRGNQ?=
 =?utf-8?B?L0RQeUpTTkI5NEZnNUNhdWhEWU81amRIanFWcSsyalNxUzdmQjY0WTMxUmxn?=
 =?utf-8?B?THlxaFJOWjI5NXV6TVhnS2RBczcwSmJLVDJHZFVUVDZGNkQ4azJMUnkxZXJ5?=
 =?utf-8?B?c2tWa2kzRmpWWDBaeDVJZjJHamtPMjRLL1BycXlkcFdFWTB5Z05GYXVNZkg4?=
 =?utf-8?B?OGliZUdKT01xK3dXcWJud2ttRjJJRVZGcUtxeHMwUEZKd3RENWZTcC9sajdO?=
 =?utf-8?B?bnNkMjBwQ3MvbzUrU05NTU9SR2poTUxxV29YU3QyMkdxYlBFMzR5NjRzdyty?=
 =?utf-8?B?dDRaTWNkSC9iVEE3UVN1S1RhNERPSnlTRjlVd1NmTWkxc29yYlg3TTF0L0FP?=
 =?utf-8?B?ZnhZYXMzU3FGdWpTdW5PZVY1QStVbkNhdjZSdUZGdXk4MmNVNy83VVJEaFhw?=
 =?utf-8?B?VFRURkJiczZmNVpFU29qN2YvSDJQVEJhSWE2Q3lGdk5yNDhCR0gzS3RWWUgy?=
 =?utf-8?B?UG5tMGF0Y1BNMXh4KytqRVhITSt4dUhtV2hwb1phQWRBamdGelhDbms2YlFn?=
 =?utf-8?B?d25tc3o5a0xFeGtCZnlPaU9NeG1PVUhLMVdJTS9IYTRqOGVFaWUrMEdIb0Ur?=
 =?utf-8?B?M1VUTkdoeTBtSVBhc1BOay9iVE03Y05mT2NvZUFNbE5ZUXo2WmVvOGd3NU44?=
 =?utf-8?B?S1ZWbWxSUGpFREwzNy9SL0d4Y0IvK0ZaUGt3ME16Yjh4VlpmYVRpV0c2UWxB?=
 =?utf-8?B?RFJ4UFVwVjFXSDExUlljR2NtTzZOOFRhd0lTZHlvMVAzLy9HY3JCSUlWMWdU?=
 =?utf-8?B?aXNZSlBwNGpuWGdTeVN5NWRiM0xJWEhCL0dWeU9xWjdNUnhnTUtxL0g2cGhW?=
 =?utf-8?B?WFRQNDlLQkJ0L3QvVkg0VEtHaEVsUzAvTmltOWFkRERWaldiNGd2RjNKNlFF?=
 =?utf-8?B?ZUJ6eGVOaXMrRFR6TWh4UUVCdDdUN2tNVzNsZWQvRUh6U3dHd3U0Zm5ScytI?=
 =?utf-8?B?QnpUUjFacGRoSjJ6YmNIb1IxNUdIdEVJaE1uUnhtSC9PRFhoWHFXWjUrejFB?=
 =?utf-8?B?TENZNWQxSGxmekVVMnhMekRoZWNweTNJR3EvNjljUG9hRm1ZVWdhczJ6RHNH?=
 =?utf-8?B?dGJhdllkZEE2RzB1aVhzdDlFbC9WMkV0Tm0yNC8vSzc4dCtQbWFXaUlmL0dz?=
 =?utf-8?B?Y1U5WXRBaGNPUWhuSE1vN3dwcWpJVXJTNnMxUlUyR205T0lIOVRjOFllUGtM?=
 =?utf-8?B?NEhaaXZOWHArSFBOU2s1cnRSa21jN2paUXhFU3l4emVqLzB1cERid0JwUjI5?=
 =?utf-8?B?aVQ1OUY0djlkWkpxdXEwRmlHcWwzSWlidXEvM2J4RjFGQ2l2N3QyVTVHY0Vw?=
 =?utf-8?B?cWdXbXYrajAwMHIrcm9IWmlPK3lOeXJ5RzhWV3BTaEtMQXFNRlNWK1lvVEkz?=
 =?utf-8?B?NnBzcmtHSzBBbmtPYS9NUWIvVUY1MHlPUTNhMS9CZHZWTEJhN1UvbEVWMWpW?=
 =?utf-8?B?b3dTT092UHlKOTd1cWpIV0VTQkpxQlFZYittem9xdTE1RzVFRFZxY3JadzhP?=
 =?utf-8?B?elA0RUlRbkZZWnlBL0xCV0VMTXl3Nzd3QmxybWhPNGhsZHBFWkNMWkR0c3ZE?=
 =?utf-8?B?WXhOZGNmYU50a2Z4SlE1aGFjbWpiZEZBdFM1bDRvTHJhSzh2c3JjK1RTV3Fn?=
 =?utf-8?Q?wcHfM3N2PvI+EiIjPAH9sglDv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6586a7bb-dda7-48d0-6d2c-08ddadf421bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 23:10:20.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMnlZJVplAnkfmGcfae2GcsIJJCwbLIRQpFNZZ/qhlMjxrIMr+Eg0pBknnAW6LSA+bZEPmM0w80Z5J9cShzb4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7701
X-OriginatorOrg: intel.com

On 6/17/2025 12:32 AM, Xin Li (Intel) wrote:
> Initialize DR7 by writing its architectural reset value to ensure
> compliance with the specification.
> 
> Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
> 
> Changes in v2:
> *) Use debug register index 7 rather than DR_CONTROL (PeterZ and Sean).
> *) Use DR7_FIXED_1 as the architectural reset value of DR7 (Sean).
> ---
>  arch/x86/include/asm/debugreg.h | 14 ++++++++++----
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kernel/cpu/common.c    |  2 +-
>  arch/x86/kernel/kgdb.c          |  2 +-
>  arch/x86/kernel/process_32.c    |  2 +-
>  arch/x86/kernel/process_64.c    |  2 +-
>  arch/x86/kvm/x86.c              |  4 ++--
>  7 files changed, 17 insertions(+), 11 deletions(-)
> 

With the updated commit message suggested by Sean,

Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>


> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> index 363110e6b2e3..3acb85850c19 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -9,6 +9,9 @@
>  #include <asm/cpufeature.h>
>  #include <asm/msr.h>
>  
> +/* DR7_FIXED_1 is also used as the init/reset value for DR7 */
> +#define DR7_FIXED_1	0x00000400
> +

Did you mean to describe what DR7_FIXED_1 is, and then say it is also
used as the init/reset value? Because the way the comment is framed
right now, it seems something is missing.

>  DECLARE_PER_CPU(unsigned long, cpu_dr7);
>  

